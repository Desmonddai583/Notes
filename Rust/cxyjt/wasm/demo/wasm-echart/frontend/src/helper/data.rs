use serde::{Deserialize,Serialize};
#[derive(Debug,Clone,Default,Deserialize,Serialize)]
pub struct DayK{
   pub id:i32,
   pub ts_code: String,//guest
   pub trade_date:i32 ,
   pub open:f64,
   pub high:f64,
   pub low:f64,
   pub close:f64,
   pub pre_close:f64,
   pub change:f64,
   pub pct_chg:f64,
   pub vol:f64,
   pub amount:f64,
   pub ma5:f64,
   pub ma10:f64,
   pub ma20:f64,
   pub ma60:f64,
}
// 本课程来自 程序员在囧途(www.jtthink.com) 咨询群：98514334
use gloo_net::http::Request;
pub async fn get_dayk(ts_code:&str)->Result<Vec<DayK>, Box<dyn std::error::Error>>{
    let url=format!("http://localhost:8081/dayk/{}",ts_code);
    let req=Request::new(url.as_str()).header("content-type", "application/json");
     

    let list=req.send().
    await?.json().await?;
    Ok(list)
  
}