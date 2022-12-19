
 
 use std::{future::Future};

// 本课程来自 程序员在囧途(www.jtthink.com) 咨询群：98514334
 // 专注golang、k8s云原生、Rust技术栈
 use hyper_tls::HttpsConnector;
 use hyper::{Client, client::HttpConnector};
 
 pub struct XhrOption{
     text_pat:String,   //标题 以及正文正则    正则必须包含 title 和content 名称
     
 }
 impl XhrOption {
     pub fn new(pattern:&str)->Self{
        XhrOption { text_pat: pattern.to_string()}
     }
 }

 // 以xhr模式抓取的内容
pub struct Xhr{
    url:String,
    client:Client<HttpsConnector<HttpConnector>>,
    option:XhrOption
}
 
use std::pin::Pin;

use super::News;
use regex::Regex;
// 本课程来自 程序员在囧途(www.jtthink.com) 咨询群：98514334
impl  Xhr {
    // 初始化 
     pub fn new(url:String,opt:XhrOption)->Self{
        let https = HttpsConnector::new();
        let client = Client::builder().build::<_, hyper::Body>(https);
        Xhr{
            url:url,
            client:client,
            option:opt
        }
     }
     // 本课程来自 程序员在囧途(www.jtthink.com) 咨询群：98514334
     // 执行GET请求 获取量化舆情分析， 并把 body 以string的方式 返回
     pub fn get_to_string<'a>(&'a self)->Pin<Box<dyn Future<Output=anyhow::Result<String>>+'a>>{

        Box::pin(async {
            let mut resp=self.client.get(self.url.parse()?).await?;

            let body_bytes=hyper::body::to_bytes(resp.body_mut()).await?;

            let body_string=String::from_utf8(body_bytes.into_iter().collect())?;
            
            Ok(body_string)
        })
     }
     pub fn get_to_model<'a>(&'a self)->Pin<Box<dyn Future<Output=anyhow::Result<Vec<News>>>+'a>>{

        Box::pin(async {
            let mut resp=self.client.get(self.url.parse()?).await?;

            let body_bytes=hyper::body::to_bytes(resp.body_mut()).await?;

            let    body_string=String::from_utf8(body_bytes.into_iter().collect())?;
            let body_string=body_string.replace("\n", "");

            let re=Regex::new(self.option.text_pat.as_str())?;
           
            let mut NewsList:Vec<News>=Vec::new();
            re.captures_iter( body_string.as_str()).
               into_iter().for_each(|item|{
                  let (mut title,mut content)=("","");
                   if let Some(t)=item.name("title"){
                       title=t.as_str();
                   }
                   if let Some(t)=item.name("content"){
                       content=t.as_str();
                   }
                   if title!="" || content!=""{
                    let mut  news=News::new();
                    news.set_title(title.to_string());
                    news.set_content(content.to_string());
                      NewsList.push(news);
                   }
          });
     

            Ok(NewsList)
        })
     }
}