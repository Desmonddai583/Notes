#![allow(unused_unsafe)]
use js_sys::Array;
use wasm_bindgen::{JsValue,JsCast};
use crate::helper::{js, web::log};
#[derive(Default)]
pub struct EchartOption{
    series: Vec<js_sys::Object>,
    legend: Vec<String>,  
    object:js_sys::Object
}
   //本课程来自 程序员在囧途(www.jtthink.com) 咨询群：98514334
//帮助函数， 直接返回 array  (注意类型是 JsValue)
 fn to_f64_array(arr:&[f64])->JsValue{
    let float_data=js_sys::Float64Array::from(arr as &[f64]);
    let data=js_sys::Array::from(&float_data);
    return JsValue::from(data);
 }
 fn to_object_array(arr:&[js_sys::Object])->JsValue{
    let arr=arr.
    into_iter().map(|s| JsValue::from(s)).collect::<js_sys::Array>();
    return JsValue::from(arr);
 }
 fn to_str_array(arr:&[&str])->JsValue{
    let arr=arr.
    into_iter().map(|s| JsValue::from_str(s)).collect::<js_sys::Array>();
    return JsValue::from(&arr);
 }
 

impl EchartOption {
    pub fn new()->Self{
        let obj=js_sys::Object::new();
        EchartOption { object:obj,..Default::default() }
    }
    // lineStyle:{ 
    //     normal:{
    //         width:10,  //连线粗细
    //         color: "#0F0"  //连线颜色
    //     }
    // }   以上就是大概的形式
    fn make_line_style(&mut self,color:&str)->js_sys::Object{
        let line_style=js_sys::Object::new();
        let normal=js_sys::Object::new();
        self.set_prop(&normal, "color", &JsValue::from_str(color));
        self.set_prop(&line_style, "normal", &normal);
        return line_style;
    }
    // 根据传入的对象设置属性
    fn set_prop(&mut self,obj:&JsValue,name:&str,v:&JsValue)->&mut Self{
        unsafe{
            js_sys::Reflect::set(obj,
                &JsValue::from_str(name),v).unwrap();
        }
        self
    }
    //把属性  赛到 主对象中   也就是self.object
    fn add_to_object(&mut self,name:&str,v:&JsValue){
        unsafe{
            js_sys::Reflect::set(&self.object,
                &JsValue::from_str(name),v).unwrap();
        }
    }
    pub fn set_title(&mut self,title:&str)->&mut Self{
       let title_obj=js_sys::Object::new();
       unsafe{
       
        self.set_prop(&title_obj,"text", &JsValue::from_str(title)).
            add_to_object("title", &title_obj);
    
       }
        self
    }
     //暂时写死
    pub fn set_series(&mut self,name:&str,data:&[f64],color:Option<&str>)->&mut Self{
   //本课程来自 程序员在囧途(www.jtthink.com) 咨询群：98514334
        //let series=js_sys::Array::new();
        
        unsafe{
            // 其中一个对象
            let series_obj=js_sys::Object::new();
            self.set_prop(&series_obj, "name", &JsValue::from_str(name));
          
            self.set_prop(&series_obj, "type", &JsValue::from_str("line"));
            //平滑曲线
            self.set_prop(&series_obj, "smooth", &JsValue::from_bool(true));
           
            // 这里处理颜色， 视频中就不演示 了 。很简单
            if let Some(c)=color{
                    self.make_line_style(c);  // 自行观看 make_line_style
            }

            let arr1=to_f64_array(data);
            self.set_prop(&series_obj, "data", &arr1);

            self.series.push(series_obj);
           
            self.legend.push(name.to_string());
          

           // series.push(&series_obj1);
     
   //本课程来自 程序员在囧途(www.jtthink.com) 咨询群：98514334
          //  self.add_to_object("series", &series);
        }
        self
    }
    pub fn set_yaxis(&mut self)->&mut Self{
        let y_object=js_sys::Object::new();
        unsafe{
            self.set_prop(&y_object, "type", &JsValue::from_str("value"));
         

            self.add_to_object("yAxis", &y_object);
           }
            self
    }
    //x轴
    pub fn set_xaxis(&mut self)->&mut Self{
        // type 有 value、category、time、log    后面 再说
        
        let x_object=js_sys::Object::new();
        unsafe{
            self.set_prop(&x_object, "type", &JsValue::from_str("category"));
        

         //暂时写死的arr
         let arr=to_str_array(&["1月", "2月","3月","4月","5月","6月","7月","8月","9月","10月"]);
         self.set_prop(&x_object, "data", &arr);
      
         self.add_to_object("xAxis", &x_object);
        }
         self
     }
    fn  set_tooltip(&mut self){
        let tooltip=js_sys::Object::new();
        {
            self.set_prop(&tooltip, "trigger", &JsValue::from("axis"));
            self.add_to_object("tooltip", &tooltip);
        }
    }
    // 缩放 。初步
    fn set_datazoom(&mut self){
        let dataZoom=js_sys::Array::new();
        {
            let zoom1=js_sys::Object::new();
            {
                self.set_prop(&zoom1, "id", &JsValue::from("zoom1"));
                self.set_prop(&zoom1, "type", &JsValue::from("inside"));
                self.set_prop(&zoom1, "filterMode", &JsValue::from("filter"));
                self.set_prop(&zoom1, "start", &JsValue::from(30));
                self.set_prop(&zoom1, "end", &JsValue::from(70));
            }
            dataZoom.push(&zoom1);
        }
        self.add_to_object("dataZoom", &dataZoom);
    }
    //本课程来自 程序员在囧途(www.jtthink.com) 咨询群：98514334
    pub fn build(&mut self)->JsValue{
        // 创建legend对象
        let legend_obj=js_sys::Object::new();
        let legend_arr=self.legend.clone().into_iter().map(|item| 
            JsValue::from_str(item.as_str()))
        .collect::<js_sys::Array>();

        self.set_prop(&legend_obj, "data", &legend_arr);
        //本课程来自 程序员在囧途(www.jtthink.com) 咨询群：98514334

        //创建series对象
        let series_array=js_sys::Array::new();
        self.series.iter().for_each(|obj|{
            series_array.push(obj);
        });

        self.add_to_object("legend", &legend_obj);
        self.add_to_object("series", &series_array);

        // 设置tooltip 
        self.set_tooltip();
       
        // 设置缩放
        self.set_datazoom();
        JsValue::from(&self.object)
    }
}