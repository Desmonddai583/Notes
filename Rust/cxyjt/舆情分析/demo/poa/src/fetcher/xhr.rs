 
 
 use std::{future::Future};

// 本课程来自 程序员在囧途(www.jtthink.com) 咨询群：98514334
 // 专注golang、k8s云原生、Rust技术栈
 use hyper_tls::HttpsConnector;
 use hyper::{Client, client::HttpConnector, Response, Body};
 
 pub struct XhrOption<'a>{
     text_pat:String,   //标题 以及正文正则    正则必须包含 title 和content 名称
     time_getter: Option<Box<dyn Fn(&str)->String+'a>>
     
 }
 impl<'a> XhrOption<'a> {
     pub fn new<>(pattern:&str,time_fn:Option<Box<dyn Fn(&str)->String+'a>>)->Self{
        XhrOption { text_pat: pattern.to_string(),time_getter:time_fn}
     }
 }
// 辅助函数， 获取https_client
pub fn https_client() ->Client<HttpsConnector<HttpConnector>>{
    let https = HttpsConnector::new();
  
    let client = Client::builder().build::<_, hyper::Body>(https);
 
    return client;
}

 // 以xhr模式抓取的内容
pub struct Xhr<'a>{
    url:String,
    client:Client<HttpsConnector<HttpConnector>>,
    option:XhrOption<'a>
}
 
use std::pin::Pin;

use super::News;
use regex::Regex;
// 本课程来自 程序员在囧途(www.jtthink.com) 咨询群：98514334
impl<'a>  Xhr<'a> {
    // 初始化 
     pub fn new(url:String,opt:XhrOption<'a>)->Self{
        Xhr{
            url:url,
            client:https_client(),
            option:opt
        }
     }
     //  辅助函数，统一 得到响应
       async  fn get_resp(&self)->anyhow::Result<Response<Body>>{
        let mut req:hyper::Request<_>=hyper::Request::default();
            *req.uri_mut()=self.url.parse()?;
            *req.method_mut()=hyper::Method::GET;
   
            let   resp=self.client.request(req).await?;
            return Ok(resp);
     }
     // 本课程来自 程序员在囧途(www.jtthink.com) 咨询群：98514334
     // 执行GET请求 获取量化舆情分析， 并把 body 以string的方式 返回
     pub fn get_to_string<'b>(&'b self)->Pin<Box<dyn Future<Output=anyhow::Result<String>>+'b>>{

        Box::pin(async {
            
            let mut resp=self.get_resp().await?;

            let body_bytes=hyper::body::to_bytes(resp.body_mut()).await?;

            let body_string=String::from_utf8(body_bytes.into_iter().collect())?;
            
            Ok(body_string)
        })
     }
     pub fn get_to_model<'b>(&'b self)->Pin<Box<dyn Future<Output=anyhow::Result<Vec<News>>>+'b>>{

        Box::pin(async {
            let mut resp=self.get_resp().await?;

            let body_bytes=hyper::body::to_bytes(resp.body_mut()).await?;

            let body_string=String::from_utf8(body_bytes.into_iter().collect())?;
            let body_string=body_string.replace("\n", "");

            let re=Regex::new(self.option.text_pat.as_str())?;
           
            let mut NewsList:Vec<News>=Vec::new();
            let time_fn=&self.option.time_getter;
            re.captures_iter( body_string.as_str()).
               into_iter().for_each(|item|{
                  let (mut title,mut content,mut create_time)=("","","");
                   if let Some(t)=item.name("title"){
                       title=t.as_str();
                   }
                   if let Some(t)=item.name("content"){
                       content=t.as_str();
                   }
                   if let Some(t)=item.name("create_time"){
                      create_time=t.as_str();
                }
                   if title!="" || content!=""{
                    let mut  news=News::new();
                    news.set_title(title.to_string());
                    news.set_content(content.to_string());
                    if let Some(tf)=time_fn.as_ref()   {
                        if create_time!="" {
                            let get_time=tf(create_time);
                         news.set_time(get_time);
                        }
                    }
                    NewsList.push(news);
                   }
          });
     

            Ok(NewsList)
        })
     }
}