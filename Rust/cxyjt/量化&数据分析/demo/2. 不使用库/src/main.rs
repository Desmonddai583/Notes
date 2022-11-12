// 本课程来自 程序员在囧途(www.jtthink.com) 咨询群：98514334

const CSV_PATH:&str="./test.csv";
 
mod lib;
use lib::{DataFrame, data_frame};

macro_rules! test {
    () => {
        
    };
}
// 本课程来自 程序员在囧途(www.jtthink.com) 咨询群：98514334
fn main(){
      let mut  df=DataFrame::from(CSV_PATH);
      let filter=|df:&data_frame|{
            df.high.unwrap_or(0.0)>2040.0
      };
 
      df.print(Some(Box::new(filter)));
    
  // 本课程来自 程序员在囧途(www.jtthink.com) 咨询群：98514334

 
}