 
use web_sys::{HtmlInputElement, HtmlElement};

use crate::helper::{get_by_id};
use wasm_bindgen::JsCast;
const FILES_INPUT_ID:&str="files";
// 获取 file上传组件 对象
pub fn get_files_input()->HtmlInputElement{
    let fi=get_by_id(FILES_INPUT_ID).expect("无法获取files组件");
    fi.dyn_into::<HtmlInputElement>().expect("转换files组件类型失败")
}

pub fn get_htmlelement_byid(id:&str)->HtmlElement{
     get_by_id(id).expect("无法获取组件")
   
}   