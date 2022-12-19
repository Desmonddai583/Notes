#![allow(dead_code)]
mod helper;
use std::ops::Add;

use helper::{*, data::*};
mod echarts;
use echarts::*;
use polars_io::SerReader;
//本课程来自 程序员在囧途(www.jtthink.com) 咨询群：98514334
use wasm_bindgen::{JsCast,JsValue};
mod funcs;
use funcs::*;

// use chrono::{prelude::*, Duration};
 
// // 从 10-1 开始 生成30天数据
// fn mock_date()->Vec<String>{
//         let mut  ret=Vec::new();
//         let mut start=NaiveDate::parse_from_str("2020-10-1", "%Y-%m-%d").unwrap();
//         for i in 0..30{
//                 start=start+Duration::days(i+1);
//                 ret.push(start.format("%Y-%m-%d").to_string());
//         }
//         ret
// }
 
use polars_core::prelude::*;
 
use polars_lazy::prelude::*;
//本课程来自 程序员在囧途(www.jtthink.com) 咨询群：98514334
fn main() {
   
         wasm_bindgen_futures::spawn_local(async {
            let data=get_dayk("600031.SH").await;
            match data {
                Ok(list)=>{
                  let mut ts_code_builder=Utf8ChunkedBuilder::new("ts_code",list.len(),list.len()*10);
                  let mut ma5_builder=PrimitiveChunkedBuilder::<Float64Type>::new("ma5", list.len());

                  list.iter().for_each(|v|{
                    ts_code_builder.append_value(&v.ts_code);
                    ma5_builder.append_value(v.ma5);
                  });
                  let ts_code_series:Series=ts_code_builder.finish().into();
                  let ma5_series:Series=ma5_builder.finish().into();
                  
                  let df=DataFrame::new(vec![
                    ts_code_series,ma5_series
                  ]).unwrap();
                     
                  log_str(df.column("ts_code").unwrap().to_string().as_str());
                  log_str(df.column("ma5").unwrap().to_string().as_str());
                }
                Err(e)=>{
                  log_str(e.as_ref().to_string().as_str());
                }
            }
         });
        
    
         if   let Some(mychart)=init_chart("main"){
             
        unsafe{
                let mut chart_opt=opt::EchartOption::new();
                let opt_data=chart_opt.set_title("日K模拟展现，数据别当真")
                .set_xaxis()
                .set_yaxis()
                .set_series("MA5",&[5.0, 20.0, 36.0, 10.0, 10.0, 20.12,26.0,29.0,22.3,24.5],Some("#7096ff"))
                .set_series("MA10", &[5.5, 20.1, 26.0, 9.0, 12.0, 19.12,27.5,27.0,24.3,27.5],Some("#e6b547"))
                .set_series("MA20", &[4.5, 18.1, 24.0, 7.5, 11.0, 20.12,24.0,28.0,25.3,26.5],Some("#ff3aff"))
                .build();
                set_option(&mychart, &opt_data);
        }
      } 
        
       
       //本课程来自 程序员在囧途(www.jtthink.com) 咨询群：98514334
 }