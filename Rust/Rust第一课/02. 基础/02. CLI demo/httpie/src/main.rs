use clap::{Parser, Subcommand};
use anyhow::{anyhow, Result};
use colored::*;
use mime::Mime;
use reqwest::{header, Client, Response, Url}; 
use std::{collections::HashMap, str::FromStr};

/// A native httpie implementation with Rust, can you imagine how easy it is?
#[derive(Parser, Debug)]
#[clap(version = "1.0", author = "Desmond Dai <desmonddai583@gmail.com>")]
struct Opts {
  #[clap(subcommand)]
  subcmd: SubCommand,
}

#[derive(Subcommand, Debug)]
enum SubCommand {
  Get(Get),
  Post(Post),
}

#[derive(Parser, Debug)]
struct Get {
  #[arg(value_parser = parse_url)]
  url: String,
}

#[derive(Parser, Debug)]
struct Post {
  #[arg(value_parser = parse_url)]
  url: String,
  #[arg(value_parser = parse_kv_pair)]
  body: Vec<KvPair>,
}

fn parse_url(s: &str) -> Result<String> {
  let _url: Url = s.parse()?;

  Ok(s.into())
}

#[derive(Debug, Clone, PartialEq)]
struct KvPair {
  k: String,
  v: String,
}

impl FromStr for KvPair {
  type Err = anyhow::Error;

  fn from_str(s: &str) -> Result<Self, Self::Err> {
    let mut split = s.split("=");
    let err = || anyhow!(format!("Failed to parse {}", s));
    Ok(Self {
      k: (split.next().ok_or_else(err)?).to_string(),
      v: (split.next().ok_or_else(err)?).to_string(),
    })
  }
}

fn parse_kv_pair(s: &str) -> Result<KvPair> {
  Ok(s.parse()?)
}

async fn get(client: Client, args: &Get) -> Result<()> {
  let resp = client.get(&args.url).send().await?;
  Ok(print_resp(resp).await?)
}

async fn post(client: Client, args: &Post) -> Result<()> {
  let mut body = HashMap::new();
  for pair in args.body.iter() {
    body.insert(&pair.k, &pair.v);
  }
  let resp = client.post(&args.url).json(&body).send().await?;
  Ok(print_resp(resp).await?)
}

fn print_status(resp: &Response) {
  let status = format!("{:?} {}", resp.version(), resp.status()).blue();
  println!("{}\n", status);
}

fn print_headers(resp: &Response) {
  for (name, value) in resp.headers() {
    println!("{}: {:?}", name.to_string().green(), value);
  }

  print!("\n");
}

fn get_content_type(resp: &Response) -> Option<Mime> {
  resp.headers().get(header::CONTENT_TYPE).map(|v| v.to_str().unwrap().parse().unwrap())
}

fn print_body(m: Option<Mime>, body: &String) {
  match m {
    Some(v) if v == mime::APPLICATION_JSON => {
      println!("{}", jsonxf::pretty_print(body).unwrap().cyan());
    }
    _ => println!("{}", body),
  }
}

async fn print_resp(resp: Response) -> Result<()> {
  print_status(&resp);
  print_headers(&resp);
  let mime = get_content_type(&resp);
  let body = resp.text().await?;
  print_body(mime, &body);
  Ok(())
}

#[tokio::main]
async fn main() -> Result<()> {
  let opts: Opts = Opts::parse();
  let mut headers = header::HeaderMap::new();
  headers.insert("X-POWERED-BY", "Rust".parse()?);
  headers.insert(header::USER_AGENT, "Rust Httpie".parse()?);
  let client = reqwest::Client::builder().default_headers(headers).build()?;
  let result = match opts.subcmd {
    SubCommand::Get(ref args) => get(client, args).await?,
    SubCommand::Post(ref args) => post(client, args).await?,
  };

  Ok(result)
}

#[cfg(test)]
mod tests {
  use super::*;

  #[test]
  fn parse_url_netwotks() {
    assert!(parse_url("abc").is_err());
    assert!(parse_url("http://abc.xyz").is_ok());
    assert!(parse_url("https://httpbin.org/post").is_ok());
  }

  #[test]
  fn parse_kv_pair_works() {
    assert!(parse_kv_pair("a").is_err());
    assert_eq!(parse_kv_pair("a=1").unwrap(), KvPair{
      k: "a".into(),
      v: "1".into(),
    });
    assert_eq!(parse_kv_pair("b=").unwrap(), KvPair{
      k: "b".into(),
      v: "".into(),
    });
  }
}
