热启动
    文档
    https://actix.rs/docs/autoreload/
    https://github.com/watchexec/cargo-watch
    cargo watch -x run 即可 

validator
    https://github.com/Keats/validator
    validator = { version = "0.15", features = ["derive"] }

    基本使用
        use validator::{Validate};

        #[derive(serde::Deserialize,serde::Serialize,Debug,Validate)]
        struct UserModel{
                user_id:i32,
                #[validate(length(min=4,message="用户名至少4长度"))]
                user_name:String,
                #[validate(range(min=12,max=200,message="年龄不符合规范"))]
                user_age:u8
        }

正则验证
    once_cell = "1.16.0" 
    regex = "1.7.0"

    基本使用
        use regex::Regex;
        use once_cell::sync::Lazy;
        
        static USERNAME_REG: Lazy<Regex> = Lazy::new(|| {
            Regex::new(r"[a-z]{4,20}").unwrap()
        });

中间件使用
    https://actix.rs/docs/middleware
    中间件是一种实现了Service trait和Transform trait的类型

    Service
        它是一个 接受请求   并异步 返回响应     的 过程。通过call方法来调用

    Transform
        将服务包装在另一个服务中来“转换”服务
