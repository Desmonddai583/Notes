#![allow(unused_unsafe)]
#![allow(non_snake_case)]
use crate::helper::*;
 
 
//本课程来自 程序员在囧途(www.jtthink.com) 咨询群：98514334
use wasm_bindgen::{JsCast,JsValue};
 
 
 //本课程来自 程序员在囧途(www.jtthink.com) 咨询群：98514334
use js_sys::{Reflect,Array};
 
pub fn init_chart(div_id:&str)->Option<JsValue>{
    if let Some(echart_obj)=get_window_object("echarts"){

        unsafe{
            let fn_init=Reflect::get(&echart_obj,
                &JsValue::from_str("init")).expect("无法获取init函数");
            let div_main=get_by_id(div_id).expect("无法获取main对象");

            let args=Array::new(); //参数，必须是数组
            args.push(&div_main);
            let my_chart= Reflect::apply(fn_init.unchecked_ref(),
            &JsValue::undefined(), &args).unwrap();
            return Some(my_chart);
        }
    }
    None
}
pub fn set_option(chart:&JsValue,v:&JsValue){
   log(v);
    unsafe{
        let setOption=Reflect::get(&chart,
            &JsValue::from_str("setOption")).expect("无法获取setOption函数");
    
           
 
            let args=Array::new(); //参数，必须是数组
            args.push(v);
         
        let ret=Reflect::apply(setOption.unchecked_ref(),
        &chart, &args);
        match ret {
            Ok(v)=>{
                log_str("ok");
            }
            Err(e)=>{
                log(&e);
            }
        }
        
    }
  
    
}