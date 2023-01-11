 
 use chrono::Utc;
// 本课程来自 程序员在囧途(www.jtthink.com) 咨询群：98514334
// 专注golang、k8s云原生、Rust技术栈
 
 
mod fetcher;
use fetcher::*;
use hyper::Request;
use regex::Regex;
 
#[tokio::main]
 async fn main()->anyhow::Result<()>{
    // 构建抓取的URL
        let now=Utc::now().timestamp(); 
        let url=format!("https://www.cls.cn/nodeapi/refreshTelegraphList?lastTime={}",now);
        println!("当前地址:{}",url);
 
          let time_fn:Box<dyn Fn(&str)->String>=Box::new(|time|{
                  time.to_string()
          });
           let x=Xhr::new(url,XhrOption::new(r#""\d+":\{"title":"(?P<title>.*?)","content":"(?P<content>.*?)".*?"ctime":(?P<create_time>.*?),"#,
           Some(time_fn)));
          println!("{:?}",x.get_to_model().await?);
           //  println!("{:?}",x.get_to_string().await?);
 // 本课程来自 程序员在囧途(www.jtthink.com) 咨询群：98514334
// 专注golang、k8s云原生、Rust技术栈

      //   let url="https://zhibo.sina.com.cn/api/zhibo/feed?page=1&page_size=20&zhibo_id=152&tag_id=10";
      //   let client=https_client();
       
      //   let mut req:Request<_>=hyper::Request::default();
        
      //   *req.uri_mut()=url.parse()?;
      //   *req.method_mut()=hyper::Method::GET;
  
      //   let mut resp=client.request(req).await?;

      //   let body_bytes=hyper::body::to_bytes(resp.body_mut()).await?;

      //   let body_string=String::from_utf8(body_bytes.into_iter().collect())?;

      //   let re=Regex::new(r#""rich_text":"(?P<content>.*?)""#)?;
        
      //   re.captures_iter(body_string.as_str()).for_each(|item|{
      //          if let Some(c)=item.name("content"){
      //             println!("{}",unescape::unescape(c.as_str()).unwrap());
      //          }
      //   });
        Ok(())

 }
    

 
// 本课程来自 程序员在囧途(www.jtthink.com) 咨询群：98514334
// 专注golang、k8s云原生、Rust技术栈