初始化
  rustup target add wasm32-unknown-unknown
  cargo install trunk 
  cargo install wasm-bindgen-cli

  添加yew依赖

  运行 trunk serve

web-sys进行js交互
  https://rustwasm.github.io/wasm-bindgen/web-sys/index.html
  基于 wasm-bindgen  提供原生的导入
  加入依赖
 [dependencies.web-sys]
  version = "0.3.4"
  features = [
    'Document',
    'Element',
    'HtmlElement',
    'Node',
    'Window',
  ]

http请求
  Gloo
    https://github.com/rustwasm/gloo
    Gloo 是一个库集合(工具包) , 不是一个具体的框架
    web-sys/js-sys直接使用非常 不方便，因此 gloo 提供了原始绑定的包装器 
    主要用它的 gloo-net  https://github.com/rustwasm/gloo/tree/master/crates/net

    依赖
      [dependencies]
      wasm-bindgen-futures = "0.4"
      gloo-net = "0.2"
      serde = { version = "1.0", features = ["derive"] }

      serde是用来做 序列化和反序列化的
      wasm-bindgen-futures 主要是实现前端(js)中的Promise 

    use gloo_net::http::Request;
    wasm_bindgen_futures::spawn_local(async move {
        let a=Request::get("http://localhost:8081/test").
        send().await.unwrap().text().await.unwrap();
        js::log(&wasm_bindgen::JsValue::from_str("shenyi"));
    });


