WebAssembly
  通过Web执行一种类似于机器码的程序,简称wasm。相对于JS解析执行性能大大提升,目前主流浏览器都已支持
  wasm本身是一种字节码标准
  一般通过c/c++、GO、Rust来进行开发，并编译成wasm
  场景：如图像处理、视觉效果、3D游戏、其他需要CPU高性能计算的场景

  安装wasm-pack 这是一个打包工具
    cargo install wasm-pack

  编译
    wasm-pack build  

  使用nodejs编译
    wasm-pack build -t nodejs

  导入nodejs方法
    #[wasm_bindgen]
    extern {
        //console.log(xxxx)
        #[wasm_bindgen(js_namespace=console)]
        fn log(s:&str);
    }
  
  声明构造函数
    #[wasm_bindgen]
    impl UserModel {
      pub fn get_user_id(&self) -> i32 {
          self.user_id
      }

      #[wasm_bindgen(constructor)]
      pub fn new() -> UserModel {
          UserModel { user_id: -1 }
      }
    }

  声明getter和setter
    #[wasm_bindgen]
    impl UserModel {
        #[wasm_bindgen(getter)]
        pub fn uid(&self) -> i32 {
            self.user_id
        }
        #[wasm_bindgen(setter)]
        pub fn set_uid(&mut self, id: i32) {
            self.user_id = id;
        }

        #[wasm_bindgen(constructor)]
        pub fn new() -> UserModel {
            UserModel { user_id: -1 }
        }
    }

前端
  网页中调用wasm
    npm install webpack webapck-cli webpack-dev-server
    配置webpack.config.js
    
  使用web-sys
    Cargo.toml中加入
      [dependencies.web-sys]
      version = "0.3"
      features = [
        'Document',
        'Element',
        'HtmlElement',
        'Node',
        'Window',
      ]

    代码
      // start代表前端一开始运行就会执行
      #[wasm_bindgen(start)]
      pub fn run() ->Result<(),JsValue>   {
          let window = web_sys::window().expect("no window");
          let document = window.document().expect("no document");
          let body = document.body().expect("no body");
      
          let val = document.create_element("button")?;
          val.set_inner_html("click me");

          body.append_child(&val)?;
          Ok(())
      }
  
  yew
    Yew 是一个设计先进的 Rust 框架，目的是使用 WebAssembly 来创建多线程的前端 web 应用。
    基于组件的框架，可以轻松的创建交互式 UI。拥有 React 或 Elm 等框架经验的开发人员在使用 Yew 时会感到得心应手。
    高性能 ，前端开发者可以轻易的将工作分流至后端来减少 DOM API 的调用，从而达到异常出色的性能。
    支持与 JavaScript 交互 ，允许开发者使用 NPM 包，并与现有的 JavaScript 应用程序结合。

    配置
      [dependencies]
      yew = "0.19.3"
    
    基本写法
      extern crate wasm_bindgen;
      use wasm_bindgen::prelude::*;
      use web_sys::HtmlInputElement;
      use yew::prelude::*;

      #[wasm_bindgen]
      extern "C" {
          fn alert(s: &str);
      }

      pub struct App {
          user_name: String,
          user_pass: String,
      }
      pub enum Msg {
          BtnClick,
          SetInput(InputEvent, u8),
      }
      impl Component for App {
          type Message = Msg;
          type Properties = ();
          fn create(_ctx: &Context<Self>) -> Self {
              App {
                  user_name: "".to_string(),
                  user_pass: "".to_string(),
              }
          }
          fn update(&mut self, _ctx: &Context<Self>, msg: Self::Message) -> bool {
              match msg {
                  Msg::BtnClick => {
                      alert(format!("username:{},userpass:{}", self.user_name, self.user_pass).as_str());
                  }
                  Msg::SetInput(e, t) => {
                      if t == 1 {
                          let input: HtmlInputElement = e.target_unchecked_into();
                          self.user_name = input.value();
                      } else {
                        let input: HtmlInputElement = e.target_unchecked_into();
                          self.user_pass = input.value();
                      }
                  }
              }
              true
          }
          fn view(&self, ctx: &Context<Self>) -> Html {
              html! {
                  <div id="app">
                    <div><span>{"Username:"}</span>
                  <input    type="text" oninput={ctx.link().callback(|e:InputEvent| Msg::SetInput(e,1))}/>
                    </div>
                    <div><span>{"Password:"}</span>
                        <input   type="text" oninput={ctx.link().callback(|e:InputEvent| Msg::SetInput(e,2))}  />
                    </div>
                    <div>
                        <button onclick={ctx.link().callback(|_| Msg::BtnClick )}>{ "button" }</button>
                    </div>
                      <div>
                        <p>{"username:"}{self.user_name.as_str()}</p>
                        <p>{"userpass:"}{self.user_pass.as_str()}</p>
                      </div>
                  </div>
              }
          }
      }

    启动
      yew::start_app::<App>();

  serde 解析JSON
    [dependencies] 
    serde = { version = "1.0", features = ["derive"] }
    serde_json = "1.0"

    基本用法
      use serde::{Deserialize, Serialize};

      #[derive(Debug, Serialize, Deserialize)]
      struct User {
          userid: i32,
      }
      fn main() {
          let data = r#"
              {
                  "userid": 101
              }"#;

          let v: User = serde_json::from_str(data).unwrap();
          println!("{:?}", v.userid);
      }
    
