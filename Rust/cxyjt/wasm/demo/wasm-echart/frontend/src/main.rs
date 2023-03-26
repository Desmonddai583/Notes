#![allow(dead_code)]
#![allow(unsafe_code)]
#![allow(unused)]
mod helper;
use std::ops::Add;

use helper::{*, data::*};
mod echarts;
use echarts::*;
use polars_io::SerReader;
//本课程来自 程序员在囧途(www.jtthink.com) 咨询群：98514334
use wasm_bindgen::{JsCast,JsValue, __rt::RefMut};
mod funcs;
use funcs::*;

  use chrono::{prelude::*, Duration};
 
// 临时函数 。得到trade_date最大值，减掉4个月
// 返回切片， 其中 第一个值是最小值，  第二个值是最大值
// fn zoom_range(df:&DataFrame)->[i32;2]{
 
//   let mut ret=[0,0];
 
//   let max:i32=df.column("trade_date").unwrap().max().unwrap();
//   log_str(max.to_string().as_str());
//         let   start=NaiveDate::parse_from_str(max.to_string().as_str(), "%Y%m%d").
//               unwrap()-chrono::Months::new(4);
//         let start= start.format("%Y%m%d").to_string();
//         ret[0]=start.parse().unwrap();
//         ret[1]=max;
//         ret 
// }
 
use polars_core::prelude::*;
 
use polars_lazy::prelude::*;
//本课程来自 程序员在囧途(www.jtthink.com) 咨询群：98514334
fn main() {
 
         wasm_bindgen_futures::spawn_local(async {
            let list=get_dayk("600031.SH").await.unwrap();
            let df=build_df(&list);
            
             let trade_date:Vec<Option<i32>>=df.column("trade_date").unwrap().i32().unwrap().into_iter().collect();

            let ma5:Vec<Option<f64>>=df.column("ma5").unwrap().f64().unwrap().into_iter().collect();
            let ma10:Vec<Option<f64>>=df.column("ma10").unwrap().f64().unwrap().into_iter().collect();
            let ma20:Vec<Option<f64>>=df.column("ma20").unwrap().f64().unwrap().into_iter().collect();
               
            if   let Some(mychart)=init_chart("main"){            
              unsafe{        
                // 蜡烛图的数据
                      let candles_data=JsValue::from(gen_candles_data(&df));
                      //成交量数据
                      let amount_data=JsValue::from(gen_amount_data(&df));
                      let mut chart_opt=opt::EchartOption::new();
                      let opt_data=chart_opt.set_title("日K模拟展现，数据别当真")
                      .set_xaxis(&trade_date)
                      .set_yaxis()
                      .set_grid()
                      .set_series_candles(&candles_data)// 设置蜡烛图   第一个调用
                      .set_series("MA5",&ma5,Some("#ff9100"))
                      .set_series("MA10", &ma10,Some("#76a8db"))
                      .set_series("MA20", &ma20,Some("#e74dc3"))
                      .set_series_amount(&amount_data)
                      .build();
                      set_option(&mychart, &opt_data);
              }
            } 
         });
        
    
       
        
       
       //本课程来自 程序员在囧途(www.jtthink.com) 咨询群：98514334
 }