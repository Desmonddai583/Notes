 
mod helper;
 
 
use std::rc::{Rc};

use helper::{set_onclick, set_onchange, log_str,set_onloadend, log,png_to_base64};
 
use image::GenericImageView;
use web_sys::FileReader;
//本课程来自 程序员在囧途(www.jtthink.com) 咨询群：98514334
use wasm_bindgen::JsCast;
mod funcs;
use funcs::*;
use base64::encode;

 
fn main() {
         
        let btn_select_pic=get_htmlelement_byid("btn_select_pic");
        let files_input=get_files_input();

        let rc_fles_input=Rc::new(files_input); //原始 Rc对象 

        let clone_rc_files_input=rc_fles_input.clone();
         let image_element=get_htmlelement_byid("image");
         set_onclick(btn_select_pic, move || {
              get_files_input().click();           
         });
       
        let fr=FileReader::new().unwrap(); //创建一个文件读取对象
         let rc_fr=Rc::new(fr);
         let rc_fr_1=rc_fr.clone();
         let rc_fr_2=rc_fr.clone();

         //本课程来自 程序员在囧途(www.jtthink.com) 咨询群：98514334
         set_onloadend(rc_fr.clone(), move || {
                let data=rc_fr_1.result().expect("图片内容不合法").dyn_into::<js_sys::JsString>().unwrap();
                let data_vec:Vec<u8>=data.iter().map(|d| d as u8).collect();
                 
                let mut img=image::load_from_memory(data_vec.as_slice()).expect("加载图片失败");
                img=img.grayscale();//变成灰色 
               
                img=img.resize(160, 120, image::imageops::Nearest);
             
                image_element.set_attribute("src", 
                png_to_base64(&img).as_str()).expect("回显图片出错");

                  image_element.set_attribute("style",
                   format!("width: {}px;height: {}px",img.width(),img.height()).as_str()).expect("设置style出错");
             
         });
         set_onchange(clone_rc_files_input, move || {
                let file_list= get_files_input().files().expect("无法获取文件列表");
                let get_file=file_list.get(0).expect("无法取到文件");
                rc_fr_2.read_as_binary_string(&get_file).expect("无法读取文件内容");
                log_str(file_list.length().to_string().as_str());

         });
        
        //本课程来自 程序员在囧途(www.jtthink.com) 咨询群：98514334
 }