use polars_core::prelude::DataFrame;
use polars_lazy::{prelude::IntoLazy, dsl::cols};
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
    let url=format!("http://localhost:8081/dayk/{}?year=2022",ts_code);
    let req=Request::new(url.as_str()).header("content-type", "application/json");
    let list=req.send().
    await?.json().await?;
    Ok(list)
  
}
use polars_core::prelude::*;
//直接写死的代码 用来构建出DataFrame
// 目前只构建出 ma5--60  还有交易日期和 股票代码
pub fn build_df(list:&Vec<DayK>)->DataFrame{
    let mut ts_code_builder=Utf8ChunkedBuilder::new("ts_code",list.len(),list.len()*10);
    let mut trade_date_builder=PrimitiveChunkedBuilder::<Int32Type>::new("trade_date", list.len());

    //增加开盘、收盘、最低、最高价 四个series
    let mut open_builder=PrimitiveChunkedBuilder::<Float64Type>::new("open", list.len());
    let mut close_builder=PrimitiveChunkedBuilder::<Float64Type>::new("close", list.len());
    let mut low_builder=PrimitiveChunkedBuilder::<Float64Type>::new("low", list.len());
    let mut high_builder=PrimitiveChunkedBuilder::<Float64Type>::new("high", list.len());

    let mut ma5_builder=PrimitiveChunkedBuilder::<Float64Type>::new("ma5", list.len());
    let mut ma10_builder=PrimitiveChunkedBuilder::<Float64Type>::new("ma10", list.len());
    let mut ma20_builder=PrimitiveChunkedBuilder::<Float64Type>::new("ma20", list.len());
    let mut ma60_builder=PrimitiveChunkedBuilder::<Float64Type>::new("ma60", list.len());


    list.iter().for_each(|v|{
      ts_code_builder.append_value(&v.ts_code);
      trade_date_builder.append_value(v.trade_date);

      open_builder.append_value(v.open);
      close_builder.append_value(v.close);
      low_builder.append_value(v.low);
      high_builder.append_value(v.high);

      ma5_builder.append_value(v.ma5);
      ma10_builder.append_value(v.ma10);
      ma20_builder.append_value(v.ma20);
      ma60_builder.append_value(v.ma60);
    });
    
    let df=DataFrame::new(vec![
        ts_code_builder.finish().into_series(),
        trade_date_builder.finish().into_series(),

        open_builder.finish().into_series(),
        close_builder.finish().into_series(),
        low_builder.finish().into_series(),
        high_builder.finish().into_series(),

        ma5_builder.finish().into_series(),
        ma10_builder.finish().into_series(),
        ma20_builder.finish().into_series(),
        ma60_builder.finish().into_series(),
      ]).unwrap();
    
      df
         
}

use wasm_bindgen::JsValue;

use super::log_str;
// 辅助函数 ，把anyvalue 转为 f64 ，不符合的类型 返回0
fn any_to_f64value(v:&AnyValue) -> JsValue{
  if let AnyValue::Float64(v)=v{
   return JsValue::from(v.clone()) ;
  }
  if let AnyValue::Int64(v)=v{
   return JsValue::from(v.clone() as f64)  ;
  }
  JsValue::from(0.0)
}


//生成蜡烛图 数据  ,格式看下面
// [
//   [129,128,120,132],[129,128,120,132],
//]
pub fn gen_candles_data(df:&DataFrame)->js_sys::Array{
  
  let ret_array=js_sys::Array::new(); //最外层的数组
  let df=df.select(&["open","close","low","high"]).unwrap();

    
     for i in 0..df.shape().0 {
        let   child_array=js_sys::Array::new(); 
        let get_row=df.get_row(i).0;
    
        let open=any_to_f64value(get_row.get(0).unwrap());
        let close=any_to_f64value(get_row.get(1).unwrap());
        let low=any_to_f64value(get_row.get(2).unwrap());
        let high=any_to_f64value(get_row.get(3).unwrap());
        child_array.push(&open);
        child_array.push(&close);
        child_array.push(&low);
        child_array.push(&high);

        ret_array.push(&child_array);
     }
     ret_array
    
}