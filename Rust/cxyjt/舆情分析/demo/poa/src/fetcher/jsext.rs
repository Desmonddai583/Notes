// 本课程来自 程序员在囧途(www.jtthink.com) 咨询群：98514334
 // 专注golang、k8s云原生、Rust技术栈

 //放的是 JS相关的一些扩展，用来处理抓取内容的转化、归一化

 

fn jsvalue_to_string(v:&JsValue,ctx:&mut Context)->JsResult<String>{

       JsResult::Ok(v.to_string(ctx)?.to_string())
}
 

 use boa_engine::{JsValue,Context,JsResult};
 use boa_engine::builtins::JsArgs;
 use chrono::NaiveDateTime;
 fn js_ctx()->Context{
    let mut ctx=Context::default();
    ctx.register_global_function("date_to_timestamp", 2, date_to_timestamp);
    ctx
 }
 // 本课程来自 程序员在囧途(www.jtthink.com) 咨询群：98514334
 // 最终执行的程序
 pub fn js_exec(js_code:&str,default_value:String)->String{
    let mut ctx=js_ctx();
    match  ctx.eval(js_code){
        Result::Ok(v)=>{
            return jsvalue_to_string(&v,&mut ctx).unwrap_or(default_value)
       }
       Err(e)=>{
          return default_value;
       }
   }
 }
// 把传进来的 时间转为时间戳 
 // 2个参数 ，第一个 字符串 就是时间，譬如 20200822  或者 2012-03-01 ，第二个也是字符串
 // 是 format 格式  %Y%m%d
 // 本课程来自 程序员在囧途(www.jtthink.com) 咨询群：98514334
 pub fn date_to_timestamp(_this:&JsValue, args:&[JsValue], ctx:&mut Context) -> JsResult<JsValue>{
    let date_str=args.get_or_undefined(0);
    let data_format=args.get_or_undefined(1);


    if !date_str.is_null_or_undefined() && date_str.is_string() &&
         !data_format.is_null_or_undefined() || data_format.is_string() {
         let date= NaiveDateTime::parse_from_str(
            jsvalue_to_string(date_str,ctx)?.as_str(),
            jsvalue_to_string(data_format,ctx)?.as_str(),
         );
 
         match date{
            Ok(d)=>{
                return JsResult::Ok(JsValue::from(d.timestamp().to_string()));  
            }
            Err(e)=>{
                return JsResult::Err(JsValue::from(e.to_string()));
            }
         }
        
    }else{
        return JsResult::Err(JsValue::from("日期解析参数不正确"));
    }
 
  }