#![allow(unused_unsafe)]
use js_sys::Array;
use wasm_bindgen::{JsValue,JsCast};
use crate::helper::{js, web::log};
#[derive(Default)]
pub struct Option{
    legend: Vec<String>,  
    object:js_sys::Object
}

//帮助函数， 直接返回 array  (注意类型是 JsValue)
 fn to_f64_array(arr:&[f64])->JsValue{
    let float_data=js_sys::Float64Array::from(arr as &[f64]);
    let data=js_sys::Array::from(&float_data);
    return JsValue::from(data);
 }
 fn to_str_array(arr:&[&str])->JsValue{
    let arr=arr.
    into_iter().map(|s| JsValue::from_str(s)).collect::<js_sys::Array>();
    return JsValue::from(&arr);
 }
 

impl Option {
    pub fn new()->Self{
        let obj=js_sys::Object::new();
        Option { object:obj,..Default::default() }
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
    pub fn set_series(&mut self)->&mut Self{

        let series=js_sys::Array::new();
        
        unsafe{
            // 其中一个对象
            let series_obj1=js_sys::Object::new();
            self.set_prop(&series_obj1, "name", &JsValue::from_str("分时数据"));
          
            self.set_prop(&series_obj1, "type", &JsValue::from_str("line"));
            //平滑曲线
            self.set_prop(&series_obj1, "smooth", &JsValue::from_bool(true));
           
            let arr1=to_f64_array(&[5.0, 20.0, 36.0, 10.0, 10.0, 20.12]);
            self.set_prop(&series_obj1, "data", &arr1);

 
            self.legend.push("分时数据".to_string());
          

            series.push(&series_obj1);
     

            self.add_to_object("series", &series);
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
         let arr=to_str_array(&["1月", "2月","3月","4月","5月","6月"]);
         self.set_prop(&x_object, "data", &arr);
      
         self.add_to_object("xAxis", &x_object);
        }
         self
     }
    pub fn build(&mut self)->JsValue{
        // 创建legend对象
        let legend_obj=js_sys::Object::new();
        let legend_arr=self.legend.clone().into_iter().map(|item| 
            JsValue::from_str(item.as_str()))
        .collect::<js_sys::Array>();

        self.set_prop(&legend_obj, "data", &legend_arr);

        self.add_to_object("legend", &legend_obj);

        JsValue::from(&self.object)
    }
}