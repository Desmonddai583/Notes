 
use web_sys::window;
use web_sys::console;
  //本课程来自 程序员在囧途(www.jtthink.com) 咨询群：98514334
// window.alert 
pub fn alert(str:&str){
   window().unwrap().alert_with_message(str).unwrap();
} 

//本课程来自 程序员在囧途(www.jtthink.com) 咨询群：98514334
pub fn log(obj:&wasm_bindgen::JsValue){
   console::log_1(obj);
   // js console.log(xxx)
}
pub fn log_str(str:String){
   log(&wasm_bindgen::JsValue::from_str(str.as_str()));
   // js console.log(xxx)
}