#![allow( dead_code, unused_imports)]
// 本课程来自 程序员在囧途(www.jtthink.com) 咨询群：98514334
 
const CSV_PATH:&str="./test2.csv";
 
use std::ops::{Index, Sub};

use polars::export::arrow::compute::filter;
use polars::{prelude::*, time::RollingGroupOptions,};

 
const NAMES:&[&'static str]=&["代码","交易日期","开盘","最高",
"最低","收盘","昨收","涨跌","幅度","成交量(手)","成交额"];

const SELECT:&[&'static str]=&["代码","交易日期","开盘","最高",
"最低","振幅"];
use once_cell::sync::Lazy;
use std::sync::Mutex;
static  PRINTCOLS:Lazy<Mutex<Vec<Expr>>>=Lazy::new(||{
 let cols= vec![
      col("ts_code").alias("股票代码"),
      col("trade_date").alias("交易日期"),
      col("open").alias("开盘"),
      col("close").alias("收盘"),
      col("high").alias("最高"),
   ];
   return Mutex::new(cols);
});
mod helper;
use helper::*;
mod dbhelper;
use dbhelper::*; 
 
 use std::collections::HashMap;
// 本课程来自 程序员在囧途(www.jtthink.com) 咨询群：98514334
 use polars::datatypes::DataType;
 use sqlx::{QueryBuilder, Value};
 use chrono::prelude::*;
fn any_to_f64(v:&AnyValue) -> f64{
   if let AnyValue::Float64(v)=v{
    return v.clone() ;
   }
   if let AnyValue::Int64(v)=v{
    return v.clone() as f64 ;
   }
   0.0
}
 
#[tokio::main]
async fn main()-> Result<(),PolarsError>{
  
      // 设置全局 连接池
   //   POOL.set(MySqlPoolOptions::new().max_connections(10)
   //    .connect("mysql://root:123123@localhost:3307/rustdb").await.unwrap()).unwrap();
   
     // 本课程来自 程序员在囧途(www.jtthink.com) 咨询群：98514334
     let df=CsvReader::from_path(CSV_PATH)?.finish()?;
     //  聚合统计
     let agg_df=df.clone().lazy().groupby([col("ts_code")]).
     agg([
      col("trade_date").count().alias("ts_count")
     ]).collect()?;

     let mut ts_code_list:Vec<String>=Vec::new();
     let ts_code_list_str:Vec<Option<&str>>= agg_df.column("ts_code")?.utf8()?.
                           into_iter().collect();
     ts_code_list_str.into_iter().for_each(|item|{
      ts_code_list.push(item.unwrap().to_string());
     });

     for (_,code) in ts_code_list.into_iter().enumerate(){
     
      let  mut filter_df=df.clone().lazy().filter(
                   col("ts_code").str().contains(code.as_str())
              ).collect().unwrap();
              set_ma(&mut filter_df, 20, "ma20")?;
              set_bollup(&mut filter_df, 20, "ma20")?;
              set_rsv(&mut filter_df)?;
              println!("{:?}",filter_df.lazy().select([col("ts_code"),
                     col("trade_date"),col("ma20"),col("bollup"),col("rsv")]).limit(10).collect());
              break;
     }
 
   //   for (_,code) in ts_code_list.into_iter().enumerate(){
   //    let tmp_df=df.clone();
   //    let handler=tokio::spawn(async move {
   //          let  mut filter_df=tmp_df.lazy().filter(
   //            col("ts_code").str().contains(code.as_str())
   //          ).collect().unwrap();
   //          set_ma(&mut filter_df, 5, "ma5").unwrap();
   //          set_ma(&mut filter_df, 10, "ma10").unwrap();
   //          set_ma(&mut filter_df, 20, "ma20").unwrap();
   //          set_ma(&mut filter_df, 60, "ma60").unwrap();
   //          // 数据入库
   //          let mut qb=save_df(&filter_df, "dayk");
   //          qb.build().execute(POOL.get().unwrap()).await.unwrap(); 
   //    });
   //     handler.await.unwrap();
       
       
    //  }
    
   
    
// 本课程来自 程序员在囧途(www.jtthink.com) 咨询群：98514334
   
   
  

 
 // 本课程来自 程序员在囧途(www.jtthink.com) 咨询群：98514334
 

   Ok(())
}
  
     
      

 
    
     // 设置全局 连接池

  //    POOL.set(MySqlPoolOptions::new().max_connections(10)
  //     .connect("mysql://root:123123@localhost:3307/rustdb").await.unwrap()).unwrap();
  // // // 本课程来自 程序员在囧途(www.jtthink.com) 咨询群：98514334
  //      test().await.unwrap();

  
 

use sqlx::{mysql::*,pool, Pool};
use sqlx::Row;
 
 
use tokio::runtime::Runtime;
 
use once_cell::sync::OnceCell;
static POOL:OnceCell<Pool<MySql>>=OnceCell::new();

 
 
async fn test()->Result<(),sqlx::Error>{
    

     let ret=sqlx::query("insert into users(user_name,user_age) values(?,?)")
     .bind("abc").bind(19).execute(POOL.get().unwrap()).await?;
     println!("{:?}",ret.last_insert_id());
     Ok(())
}


  // 本课程来自 程序员在囧途(www.jtthink.com) 咨询群：98514334
 