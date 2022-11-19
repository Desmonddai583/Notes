use anyhow::Result;
use axum::{extract::{Extension, Path}, routing::get, http::{HeaderMap, HeaderValue, StatusCode}, Router};
use bytes::Bytes;
use image::ImageOutputFormat;
use lru::LruCache;
use percent_encoding::{percent_decode_str, percent_encode, NON_ALPHANUMERIC};
use serde::Deserialize;
use std::{
  collections::hash_map::DefaultHasher,
  convert::TryInto,
  hash::{Hash, Hasher},
  sync::Arc,
  num::NonZeroUsize,
};
use tokio::sync::Mutex;
use tower::ServiceBuilder;
use tracing::{info, instrument};

mod pb;
mod engine;
use engine::{Engine, Photon};

use pb::*;

// 参数使用 serde 做 Deserialize，axum 会自动识别并解析
#[derive(Deserialize)]
struct Params {
  spec: String,
  url: String,
}

type Cache = Arc<Mutex<LruCache<u64, Bytes>>>;

// ./httpie get "http://localhost:3000/image/CgoKCAjYBBCgBiADCgY6BAgUEBQKBDICCAM/https%3A%2F%2Fimages%2Epexels%2Ecom%2Fphotos%2F2470905%2Fpexels%2Dphoto%2D2470905%2Ejpeg%3Fauto%3Dcompress%26cs%3Dtinysrgb%26dpr%3D2%26h%3D750%26w%3D1260"

#[tokio::main]
async fn main() {
  // 初始化 tracing
  tracing_subscriber::fmt::init();
  
  let cache: Cache = Arc::new(Mutex::new(LruCache::new(NonZeroUsize::new(1024).unwrap())));

  // 构建路由
  let app = Router::new()
    // `GET /image` 会执行 generate 函数，并把 spec 和 url 传递过去
    .route("/image/:spec/:url", get(generate))
    .layer(
      ServiceBuilder::new()
        .layer(Extension(cache))
        .into_inner(),
    );

  // 运行web服务器
  let addr = "127.0.0.1:3000".parse().unwrap();

  print_test_url("https://images.pexels.com/photos/1562477/pexels-photo-1562477.jpeg?auto=compress&cs=tinysrgb&dpr=3&h=750&w=1260");

  info!("listening on {}", addr);

  axum::Server::bind(&addr)
    .serve(app.into_make_service())
    .await
    .unwrap();
}

async fn generate(
  Path(Params { spec, url }): Path<Params>,
  Extension(cache): Extension<Cache>,
) -> Result<(HeaderMap, Vec<u8>), StatusCode> {
  let spec: ImageSpec = spec
    .as_str()
    .try_into()
    .map_err(|_| StatusCode::BAD_REQUEST)?;

  let url: &str = &percent_decode_str(&url).decode_utf8_lossy();
  let data = retrieve_image(&url, cache)
    .await
    .map_err(|_| StatusCode::BAD_REQUEST)?;
  
  // 使用 image engine 处理
  let mut engine: Photon = data
    .try_into()
    .map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;
  engine.apply(&spec.specs);

  let image = engine.generate(ImageOutputFormat::Jpeg(85));

  info!("Finished processing: image size {}", image.len());
  let mut headers = HeaderMap::new();

  headers.insert("content-type", HeaderValue::from_static("image/jpeg"));
  Ok((headers, image))
} 

#[instrument(level = "info", skip(cache))]
async fn retrieve_image(url: &str, cache: Cache) -> Result<Bytes> {
  let mut hasher = DefaultHasher::new();
  url.hash(&mut hasher);
  let key = hasher.finish();

  let g = &mut cache.lock().await;
  let data = match g.get(&key) {
    Some(v) => {
      info!("Match cache {}", key);
      v.to_owned()
    }
    None => {
      info!("Retrieve url");
      let resp = reqwest::get(url).await?;
      let data = resp.bytes().await?;
      g.put(key, data.clone());
      data
    }
  };

  Ok(data)
}

// 调试辅助函数
fn print_test_url(url: &str) {
  use std::borrow::Borrow;
  let spec1 = Spec::new_resize(500, 800, resize::SampleFilter::CatmullRom); 
  let spec2 = Spec::new_watermark(20, 20); 
  let spec3 = Spec::new_filter(filter::Filter::Marine); 
  let image_spec = ImageSpec::new(vec![spec1, spec2, spec3]); 
  let s: String = image_spec.borrow().into(); 
  let test_image = percent_encode(url.as_bytes(), NON_ALPHANUMERIC).to_string(); 
  println!("test url: http://localhost:3000/image/{}/{}", s, test_image);
}