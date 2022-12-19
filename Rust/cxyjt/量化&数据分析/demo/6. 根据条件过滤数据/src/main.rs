#![allow( dead_code, unused_imports)]
// 本课程来自 程序员在囧途(www.jtthink.com) 咨询群：98514334
 
const CSV_PATH:&str="./test2.csv";
 
use std::ops::Index;

use polars::{prelude::*, time::RollingGroupOptions,};

 
const NAMES:&[&'static str]=&["代码","交易日期","开盘","最高",
"最低","收盘","昨收","涨跌","幅度","成交量(手)","成交额"];

const SELECT:&[&'static str]=&["代码","交易日期","开盘","最高",
"最低","振幅"];
mod helper;
use helper::*;
 
// 本课程来自 程序员在囧途(www.jtthink.com) 咨询群：98514334
fn main()-> Result<(),PolarsError>{
     let mut df=CsvReader::from_path(CSV_PATH)?.finish()?;
     let print_exp=[
      col("ts_code").alias("股票代码"),
      col("trade_date").alias("交易日期"),
      col("open").alias("开盘"),
      col("close").alias("收盘"),
      col("high").alias("最高"),
   ];

     df=df.lazy().filter(
       col("ts_code").str().contains("^601398")
     ).filter(col("trade_date").gt_eq(20221017.0)).collect()?;

     let ret=df.lazy().select(print_exp).limit(5);

    println!("{:?}",ret.collect()?);
     
 
    
 
  // // 本课程来自 程序员在囧途(www.jtthink.com) 咨询群：98514334
   
 
  
  Ok(())

}
  // 本课程来自 程序员在囧途(www.jtthink.com) 咨询群：98514334