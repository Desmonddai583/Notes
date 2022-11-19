#![allow(dead_code)]
mod helper;
use helper::{*};
mod echarts;
use echarts::*;
//本课程来自 程序员在囧途(www.jtthink.com) 咨询群：98514334
use wasm_bindgen::{JsCast,JsValue};
mod funcs;
use funcs::*;
 
 
     
        //本课程来自 程序员在囧途(www.jtthink.com) 咨询群：98514334
fn main() {
       
       
         if   let Some(mychart)=init_chart("main"){

        
             let obj=js_sys::Object::new();
            
       
        unsafe{
                let mut chart_opt=opt::Option::new();
                let opt_data=chart_opt.set_title("程序员在囧途行情图表")
                .set_xaxis()
                .set_yaxis()
                .set_series()
                .build();
                set_option(&mychart, &opt_data);
        }
      } 
        
       
    
 }