 

 
use std::{cell::RefCell, borrow::BorrowMut, fmt::Error};

use chrono::{NaiveDate};

use csv::Reader;
use serde::{Deserialize};
 
// 本课程来自 程序员在囧途(www.jtthink.com) 咨询群：98514334
#[derive(Default,Debug,Clone,Deserialize)]
  pub struct data_frame{
   pub ts_code:Option<String>, //股票代码
   #[serde(deserialize_with = "date_from_str")]
   pub trade_date:NaiveDate,  //交易日期
   pub open:Option<f64>,   //开盘价
   pub high:Option<f64>,  //最高价
   pub low:Option<f64>, //最低价
   pub close:Option<f64>, //收盘价
   pub pre_close:Option<f64>, //前日收盘价
   #[serde(skip)]// 跳过json处理
   pub ma5:f64,  //5日 均值 
   #[serde(skip)]// 跳过json处理
   pub ma20:f64,   

 }
 fn date_from_str<'de, D>(deserializer: D) -> Result<NaiveDate, D::Error>
 where
     D: serde::Deserializer<'de>,
 {
     let s: String = Deserialize::deserialize(deserializer)?;
     NaiveDate::parse_from_str(&s, "%Y%m%d").
         map_err(serde::de::Error::custom)
 }

 pub struct DataFrame {
      data:Vec<data_frame>,
 
 }
 // 本课程来自 程序员在囧途(www.jtthink.com) 咨询群：98514334
 impl From<&str> for DataFrame {
     // 读取 csv 
        fn from(path:&str)->Self{
        let mut _data:Vec<data_frame>=Vec::new();
        let mut csv_data=Reader::from_path(path).unwrap();
        csv_data.deserialize().for_each(|item|{
           if let Ok(row)=item{
            _data.push(row);
           }
        });
      DataFrame { data:  _data}
       
          
      }
 }
 // 本课程来自 程序员在囧途(www.jtthink.com) 咨询群：98514334
 use comfy_table::Table;
 const TABLE_HEADERS:&[&'static str]=&["股票代码","交易日期","开盘",
                                      "最高","最低","收盘","振幅",
                                       "MA5","MA20" ];
 impl DataFrame {
      // 暂时写死根据交易日期 进行 排序
      pub fn sort_by_trade_date(&mut self, desc:bool)->&Self{
          self.data.sort_by(|d1,d2|{
               // d1.trade_date.cmp(&d2.trade_date) // 正序
               if desc{
                  d2.trade_date.cmp(&d1.trade_date)
               }else{
                  d1.trade_date.cmp(&d2.trade_date) 
               }
          });
          self
      }
     
      //表格化打印 数据
      pub fn print(&mut self,filter:Option<Box<dyn Fn(&data_frame)->bool>>) 
    
      {
        let mut table = Table::new();
        table.set_header(TABLE_HEADERS);

        self.sort_by_trade_date(true);//先倒排序

        let len=self.data.len(); 

        for index in 0..len{ //[0..5)
            if index+5>len{
                  break;
            }
            let mut sum=0.0;
            for next in 0..5{
                sum+=self.data.get(index+next).unwrap().close.unwrap();
            }
            let sum=sum/5.0; //计算均值
            self.data.get_mut(index).unwrap().ma5=sum;

            // 计算ma20
            if index+20>len{
              continue;
            }      
            let mut sum=0.0;
            for next in 0..20{
                sum+=self.data.get(index+next).unwrap().close.unwrap();
            }
            let sum=sum/20.0; //计算均值
            self.data.get_mut(index).unwrap().ma20=sum;  
        }
    
        // let data=self.data.iter().filter(|item|{
        //     item.high.unwrap_or(0.0)>2000.0
        // }).collect::<Vec<&data_frame>>();

        let mut data:Vec<data_frame>=self.data.clone();
        if let Some(f)=filter{ //传递了闭包函数
            data=data.into_iter().filter(f).collect();
        } 
      
        // 本课程来自 程序员在囧途(www.jtthink.com) 咨询群：98514334
        data.iter().for_each(|row|{
          
           let amp=(row.high.unwrap_or(0.0)-row.low.unwrap_or(0.0))/
            row.pre_close.unwrap()*100.0;

          let amp=format!("{:.2}%",amp);
          let ma5=format!("{:.2}",&row.ma5);
          let ma20=format!("{:.2}",&row.ma20);
          table.add_row(vec![
              row.ts_code.as_ref().unwrap(),
              &row.trade_date.to_string(),
              &row.open.unwrap().to_string(),
              &row.high.unwrap().to_string(),
              &row.low.unwrap().to_string(),
              &row.close.unwrap().to_string(),
              &amp,
              &ma5,
              &ma20
            
          ]) ;
        });

       
        println!("{}",table);
      }
 }