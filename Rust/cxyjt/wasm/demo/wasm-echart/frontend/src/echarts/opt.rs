#![allow(unused_unsafe)]
#![allow(non_snake_case)]
use js_sys::{Array, Object};
use wasm_bindgen::{JsValue,JsCast};
use crate::helper::{js, web::log, log_str};
 
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
 // 定制函数
 fn vec_to_i32_array(arr:&Vec<Option<i32>>)->JsValue{
    let buf: Array = Array::new();
    arr.into_iter().for_each(|item|{
          if let Some(v)=item{
            buf.push(&JsValue::from(v.to_owned()));
          }else{
            buf.push(&JsValue::from(0));
          }
    }) ;
    return JsValue::from(buf);
 }
 fn vec_to_f64_array(arr:&Vec<Option<f64>>)->JsValue{
    let buf: Array = Array::new();
    arr.into_iter().for_each(|item|{
          if let Some(v)=item{
            buf.push(&JsValue::from(v.to_owned()));
          }else{
            buf.push(&JsValue::from(0.0));
          }
    }) ;
    return JsValue::from(buf);
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
 fn to_i32_array(arr:&[i32])->JsValue{
    let float_data=js_sys::Int32Array::from(arr as &[i32]);
    let data=js_sys::Array::from(&float_data);
    return JsValue::from(data);
 }
 
 static  GREEN_COLOR:&str="#06B800";
 static  RED_COLOR:&str="#FA0000";

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
    //蜡烛图 的样式 ，，放在series 里面的 .颜色值是写死的
    fn make_candles_style(&mut self)->js_sys::Object{
        let item_style=js_sys::Object::new();
        let normal=js_sys::Object::new();
        self.set_prop(&normal, "color", &JsValue::from_str(GREEN_COLOR));
        self.set_prop(&normal, "color0", &JsValue::from_str(RED_COLOR));
        self.set_prop(&normal, "borderColor", &JsValue::NULL);
        self.set_prop(&normal, "borderColor0", &JsValue::NULL);
        self.set_prop(&item_style, "normal", &normal);
        return item_style;
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
  
    pub fn set_grid(&mut self)->&mut Self{
        let grid_array=js_sys::Array::new();
        unsafe{
            let grid_obj1=js_sys::Object::new();  //蜡烛图的位置
            self.set_prop(&grid_obj1, "left", &JsValue::from_str("10%"));
            self.set_prop(&grid_obj1, "right", &JsValue::from_str("8%"));
            self.set_prop(&grid_obj1, "height", &JsValue::from_str("50%"));
            grid_array.push(&grid_obj1);


            let grid_obj2=js_sys::Object::new(); //成交量图的位置
            self.set_prop(&grid_obj2, "left", &JsValue::from_str("10%"));
            self.set_prop(&grid_obj2, "right", &JsValue::from_str("8%"));
            self.set_prop(&grid_obj2, "top", &JsValue::from_str("75%"));
            self.set_prop(&grid_obj2, "height", &JsValue::from_str("16%"));
            grid_array.push(&grid_obj2);

            self.add_to_object("grid", &grid_array);
        }
        self
    }

    // 设置视觉映射
    pub fn set_visual_map(&mut self)->&mut Self{
        let visual_obj=js_sys::Object::new();
        unsafe{
            // 第几个图形的数据，0是蜡烛图，2-3 是MA5/10/20   4代表的是成交量的柱状图
            self.set_prop(&visual_obj, "show", &JsValue::from_bool(false));
            self.set_prop(&visual_obj, "seriesIndex", &JsValue::from(4));
            self.set_prop(&visual_obj, "dimension", &JsValue::from(2));
            
            let pieces=js_sys::Array::new();

            let piece_obj1=js_sys::Object::new();
            self.set_prop(&piece_obj1, "value", &JsValue::from(1));
            self.set_prop(&piece_obj1, "color", &JsValue::from_str(RED_COLOR));
            pieces.push(&piece_obj1);

            let piece_obj2=js_sys::Object::new();
            self.set_prop(&piece_obj2, "value", &JsValue::from(0));
            self.set_prop(&piece_obj2, "color", &JsValue::from_str(GREEN_COLOR));
            pieces.push(&piece_obj2);


            self.set_prop(&visual_obj, "pieces", &pieces);
        }
        self.add_to_object("visualMap", &visual_obj);
        self
    }
    //设置成交量series
    pub fn set_series_amount(&mut self,data:&JsValue)->&mut Self{
        unsafe{
            // 其中一个对象
            let series_obj=js_sys::Object::new();
           
            self.set_prop(&series_obj, "name", &JsValue::from_str("成交量"));
            self.set_prop(&series_obj, "type", &JsValue::from_str("bar"));
           
            //设置为第二个坐标系，否则会把上面的曲线图给覆盖了
            self.set_prop(&series_obj, "xAxisIndex", &JsValue::from(1));
            self.set_prop(&series_obj, "yAxisIndex", &JsValue::from(1));
            self.set_prop(&series_obj, "data", data);

            

            self.series.push(series_obj);
           
   //本课程来自 程序员在囧途(www.jtthink.com) 咨询群：98514334
        }
        self
    }
    // 设置蜡烛图的 series  ---内容是写死的。 数据是传过来的
    pub fn set_series_candles(&mut self,data:&JsValue)->&mut Self{
        unsafe{
            // 其中一个对象
            let series_obj=js_sys::Object::new();
           
            self.set_prop(&series_obj, "name", &JsValue::from_str("价格走势"));
            self.set_prop(&series_obj, "type", &JsValue::from_str("candlestick"));
           
        
            self.set_prop(&series_obj, "data", data);

            let candles_style=self.make_candles_style();

            self.set_prop(&series_obj, "itemStyle", &candles_style);

            

            self.series.push(series_obj);
           
   //本课程来自 程序员在囧途(www.jtthink.com) 咨询群：98514334
        }
        self
    }
     //暂时写死  --- 主要是 折线图
    pub fn set_series(&mut self,name:&str,data:&Vec<Option<f64>>,color:Option<&str>)->&mut Self{
   //本课程来自 程序员在囧途(www.jtthink.com) 咨询群：98514334
        unsafe{
            // 其中一个对象
            let series_obj=js_sys::Object::new();
            self.set_prop(&series_obj, "name", &JsValue::from_str(name));
          
            self.set_prop(&series_obj, "type", &JsValue::from_str("line"));
            //平滑曲线
            self.set_prop(&series_obj, "smooth", &JsValue::from_bool(true));
           
            //曲线上的节点  控制显示和不显示
            self.set_prop(&series_obj, "symbol", &JsValue::from_str("none"));


            // 这里处理颜色， 视频中就不演示 了 。很简单
            // if let Some(c)=color{
            //         let line_style=self.make_line_style(c);  // 自行观看 make_line_style
            //         self.set_prop(&series_obj, "lineStyle", &line_style);
            // }

            let arr1=vec_to_f64_array(data);
            self.set_prop(&series_obj, "data", &arr1);

            self.series.push(series_obj);
           
            self.legend.push(name.to_string());
    
   //本课程来自 程序员在囧途(www.jtthink.com) 咨询群：98514334
        }
        self
    }
    //格式如下：  官方文档抄袭的
    // yAxis: [
    //     {
    //       scale: true,
    //       splitArea: {
    //         show: true
    //       }
    //     },
    //     {
    //       scale: true,
    //       gridIndex: 1,
    //       splitNumber: 2,
    //       axisLabel: { show: false },
    //       axisLine: { show: false },
    //       axisTick: { show: false },
    //       splitLine: { show: false }
    //     }
    //   ]
    pub fn set_yaxis(&mut self)->&mut Self{
        let y_array=js_sys::Array::new();
       
        unsafe{
            let y_object1=js_sys::Object::new();
            //坐标刻度不会强制包含零刻度
             self.set_prop(&y_object1, "scale", &JsValue::from_bool(true));
         

            let y_object2=js_sys::Object::new();
            self.set_prop(&y_object2, "scale", &JsValue::from_bool(true));
            self.set_prop(&y_object2, "gridIndex", &JsValue::from(1));
            //坐标轴的分割段数 -- 一个预估值
            self.set_prop(&y_object2, "splitNumber", &JsValue::from(5));

            {
                let axisLabel=js_sys::Object::new();
                //坐标轴刻度 显示设置
                self.set_prop(&axisLabel, "show", &JsValue::from_bool(false));
                self.set_prop(&y_object2, "axisLabel", &axisLabel);
            }
            
            {
                let axisLine=js_sys::Object::new();
                //坐标轴 轴线 显示设置
                self.set_prop(&axisLine, "show", &JsValue::from_bool(false));
                self.set_prop(&y_object2, "axisLine", &axisLine);
            }
            {
                let axisLine=js_sys::Object::new();
                //坐标轴 轴线 显示设置
                self.set_prop(&axisLine, "show", &JsValue::from_bool(false));
                self.set_prop(&y_object2, "axisLine", &axisLine);
            }
            

            y_array.push(&y_object1);   //曲线图 用
            y_array.push(&y_object2);   //   为了 成交量 柱状图显示用
           }
           self.add_to_object("yAxis", &y_array);
            self
    }
    
    //x轴
    pub fn set_xaxis(&mut self,data:&Vec<Option<i32>>)->&mut Self{
        // type 有 value、category、time、log    后面 再说
        
        let x_array=js_sys::Array::new();
     
        unsafe{

            {
                let x_object1=js_sys::Object::new();
                self.set_prop(&x_object1, "type", &JsValue::from_str("category"));
                let arr=vec_to_i32_array(data);
                self.set_prop(&x_object1, "data", &arr);
                self.set_prop(&x_object1, "scale", &JsValue::from_bool(true));
    
                x_array.push(&x_object1); //曲线图 x轴
            }

            {
                let x_object2=js_sys::Object::new();
                self.set_prop(&x_object2, "type", &JsValue::from_str("category"));
                let arr=vec_to_i32_array(data);
                self.set_prop(&x_object2, "data", &arr);
                self.set_prop(&x_object2, "scale", &JsValue::from_bool(true));
                self.set_prop(&x_object2, "gridIndex", &JsValue::from(1));
                x_array.push(&x_object2); //成交量图 x轴
            }
           


      
         self.add_to_object("xAxis", &x_array);
        }
         self
     }
    fn  set_tooltip(&mut self){
        let tooltip=js_sys::Object::new();
        {
            self.set_prop(&tooltip, "trigger", &JsValue::from("axis"));

            let axisPointer=js_sys::Object::new();
            {
                self.set_prop(&axisPointer, "type", &JsValue::from("cross"));
                self.set_prop(&tooltip, "axisPointer", &axisPointer);
            }

             
            let pos_func=|point:js_sys::Array,_:js_sys::Object,
            _:web_sys::HtmlElement,_:js_sys::Object,size:js_sys::Object|->js_sys::Object{
                let obj=js_sys::Object::new();
                unsafe{
                    js_sys::Reflect::set(&obj,
                        &JsValue::from_str("top"),&JsValue::from(60)).unwrap();
                        //point: 鼠标位置，如 [20, 40]
                    let pos=point.get(0).as_f64().unwrap();
                    
                    // {contentSize: [width, height], viewSize: [width, height]}
                    let viewSize= js_sys::Reflect::get(&size, &JsValue::from_str("viewSize")).unwrap();
                    let viewSizeWidth=viewSize.dyn_into::<js_sys::Array>().unwrap().get(0).as_f64().unwrap();
                    if pos<(viewSizeWidth/2.0){
                        js_sys::Reflect::set(&obj,
                            &JsValue::from_str("right"),&JsValue::from(30)).unwrap();
                    }else{
                        js_sys::Reflect::set(&obj,
                            &JsValue::from_str("left"),&JsValue::from(30)).unwrap();
                    }
                    return obj;

                }
             
            };

            let func = wasm_bindgen::closure::Closure::wrap(
                Box::new(move |point:js_sys::Array,param:js_sys::Object,
                    dom:web_sys::HtmlElement,react:js_sys::Object,size:js_sys::Object| { 
                 return  pos_func(point,param,
                    dom,react,size);
        
         }) as Box<dyn FnMut(js_sys::Array,js_sys::Object,
                web_sys::HtmlElement,js_sys::Object,js_sys::Object)->js_sys::Object>);
             
                unsafe{
                    js_sys::Reflect::set(&tooltip,
                        &JsValue::from_str("position"),
                        func.as_ref().unchecked_ref()).unwrap();
                        func.forget(); //这句话一定要加，否则 会出错
                }
               // 设置formatter
               //下面设置tooltip 
         
            {
                let formater=js_sys::Object::new();
                let format_func=|param:js_sys::Array|->JsValue{
            
                        unsafe{
                          let seriesType=js_sys::Reflect::get(&param.get(0),&JsValue::from_str("seriesType")).unwrap().as_string().unwrap();
                          if seriesType=="candlestick"{
                            // name1 是时间
                            let name1=js_sys::Reflect::get(&param.get(0),&JsValue::from_str("name")).unwrap().as_string().unwrap();
                        
                            //param.get(0) 得到的data是蜡烛图的 data [序号,open,close,low,heigh]
                            let data=js_sys::Reflect::get(&param.get(0),&JsValue::from_str("data")).unwrap().dyn_into::<js_sys::Array>().unwrap();
                             
                            let ma5= js_sys::Reflect::get(&param.get(1),&JsValue::from_str("data")).unwrap().as_f64().unwrap();
                            let ma10= js_sys::Reflect::get(&param.get(2),&JsValue::from_str("data")).unwrap().as_f64().unwrap();
                            let ma20= js_sys::Reflect::get(&param.get(3),&JsValue::from_str("data")).unwrap().as_f64().unwrap();

                             return JsValue::from_str(format!("{}<br/>开盘价: {}<br/>
                             收盘价: {}<br/>最低价: {}<br/>最高价: {}<br/>
                              MA5: {} <br/>MA10: {} <br/>MA20: {} <br/>",name1,
                             data.get(1).as_f64().unwrap(),data.get(2).as_f64().unwrap(),
                             data.get(3).as_f64().unwrap(),data.get(4).as_f64().unwrap(),
                             ma5,ma10,ma20
                            ).as_str());
                            // return JsValue::from_str(format!("蜡烛图: {}","fefe").as_str());
                          }else{
                            let data=js_sys::Reflect::get(&param.get(0),&JsValue::from_str("data")).unwrap().dyn_into::<js_sys::Array>().unwrap();
                            return JsValue::from_str(format!("成交量: {}",data.get(1).as_f64().unwrap()).as_str());
                          }
                            
                         }
                  
                };
                let func = wasm_bindgen::closure::Closure::wrap(
                    Box::new(move |param:js_sys::Array|->JsValue { 
                     return  format_func(param);
            
                }) as Box<dyn FnMut(js_sys::Array)->JsValue>);
                self.set_prop(&tooltip, "formatter", func.as_ref().unchecked_ref());
                func.forget();

                
            }
            
            self.add_to_object("tooltip", &tooltip);


        }
    }
    // 缩放 。初步
    fn set_datazoom(&mut self ){
        let dataZoom=js_sys::Array::new();
        {
            let zoom1=js_sys::Object::new();
            {
            
                self.set_prop(&zoom1, "type", &JsValue::from("inside"));
                self.set_prop(&zoom1, "xAxisIndex", &to_i32_array(&[0,1]));

            
                self.set_prop(&zoom1, "start", &JsValue::from(70));
                self.set_prop(&zoom1, "end", &JsValue::from(100));
            
            }
            let zoom2=js_sys::Object::new();
            {
                self.set_prop(&zoom2, "type", &JsValue::from("inside"));
                self.set_prop(&zoom2, "xAxisIndex", &to_i32_array(&[0,1]));

                self.set_prop(&zoom2, "top", &JsValue::from_str("80%"));
                self.set_prop(&zoom2, "start", &JsValue::from(70));
                self.set_prop(&zoom2, "end", &JsValue::from(100));
            
            }
            dataZoom.push(&zoom1);
            dataZoom.push(&zoom2);
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

        // 设置视觉映射
        self.set_visual_map();

        JsValue::from(&self.object)
    }
}