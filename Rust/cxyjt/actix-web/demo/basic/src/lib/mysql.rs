use once_cell::sync::OnceCell;
use sqlx::{mysql::*, Pool};
// 连接池，全局的
static POOL:OnceCell<Pool<MySql>>=OnceCell::new();

#[derive(Debug,Default,sqlx::FromRow,serde::Serialize)]
pub struct Share {
    pub share_name:String,
    pub share_kind_id:i32,
    pub share_kind_name:String,
    pub share_url:String,
}

//本课程来自 程序员在囧途(www.jtthink.com) 咨询群：98514334
// 专注golang、k8s、RUst云原生技术栈
pub async fn  init_my_sql_pool(){
     _= POOL.set(MySqlPoolOptions::new().max_connections(10)
    .connect("mysql://root:123123@localhost:3307/rustdb").await.unwrap());
}

pub async fn test_mysql()->anyhow::Result<Vec<Share>>{
    let db=POOL.get().unwrap();
    let ret=sqlx::query_as::<_,Share>("select * from shares order by id desc limit 10").
    fetch_all(db).await?;
    Ok(ret)
}

 
