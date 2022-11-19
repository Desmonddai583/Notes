use wasm_bindgen::JsCast;
use wasm_bindgen::prelude::*;
use web_sys::FileReader;
use web_sys::{HtmlElement,HtmlInputElement};
use std::io::Cursor;
/*
闭包作为函数的输入参数时，必须指出闭包的完整类型。
Fn：表示捕获方式为通过引用（&T）的闭包
FnMut：表示捕获方式为通过可变引用（&mut T）的闭包
FnOnce：表示捕获方式为通过值（T）的闭包
*/
// 这里是 模仿 官方示例改造过后的代码。 用于把 Rust闭包转为前端可调用的Function
pub fn wrap_function<F>(f:F)->Closure<dyn FnMut()>
where
F:FnMut()+Clone+'static
{

     let mut ff=f.clone();
    let func = Closure::wrap(Box::new(move || { 
            ff();
    
     }) as Box<dyn FnMut()>);
     func
}
// 对html元素 设置onclick事件 
pub fn set_onclick<F:FnMut()+Clone+'static>(element:HtmlElement,f:F){
      let func=wrap_function(f);
      element.set_onclick(Some(func.as_ref().unchecked_ref()));
      func.forget();
}
 //本课程来自 程序员在囧途(www.jtthink.com) 咨询群：98514334
 use std::rc::Rc;
pub fn set_onchange<F:FnMut()+Clone+'static>(element:Rc<HtmlInputElement>,f:F){
      let func=wrap_function(f);
      element.set_onchange(Some(func.as_ref().unchecked_ref()));
      func.forget();
}
pub fn set_onloadend<F:FnMut()+Clone+'static>(element:Rc<FileReader>,f:F){
      let func=wrap_function(f);
      element.set_onloadend(Some(func.as_ref().unchecked_ref()));
      func.forget();
}

// 帮助函数
pub fn png_to_base64(img: &image::DynamicImage) -> String {
      let mut image_data: Vec<u8> = Vec::new();
      img.write_to(&mut Cursor::new(&mut image_data), 
      image::ImageOutputFormat::Png)
          .unwrap();
      let res_base64 = base64::encode(image_data);
      format!("data:image/png;base64,{}", res_base64)
  }