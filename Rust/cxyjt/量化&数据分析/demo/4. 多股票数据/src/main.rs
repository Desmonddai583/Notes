#![allow( dead_code, unused_imports)]
// 本课程来自 程序员在囧途(www.jtthink.com) 咨询群：98514334
 
const CSV_PATH:&str="./test2.csv";
 
use polars::{prelude::*,};

 
const NAMES:&[&'static str]=&["代码","交易日期","开盘","最高",
"最低","收盘","昨收","涨跌","幅度","成交量(手)","成交额"];

const SELECT:&[&'static str]=&["代码","交易日期","开盘","最高",
"最低","振幅"];
mod helper;
use helper::*;
 
// 本课程来自 程序员在囧途(www.jtthink.com) 咨询群：98514334
fn main()-> Result<(),PolarsError>{
    let mut df=CsvReader::from_path(CSV_PATH)?.finish()?;
    df.set_column_names(NAMES)?;
 
    let g=df.groupby(["代码"])?.select(["交易日期"]).count()?;
     println!("{:?}",g);
  // // 本课程来自 程序员在囧途(www.jtthink.com) 咨询群：98514334
   
  //  println!("{:?}",df.select(&["交易日期","收盘","振幅","MA5","MA20"])?);
  
  Ok(())

}
  // 本课程来自 程序员在囧途(www.jtthink.com) 咨询群：98514334