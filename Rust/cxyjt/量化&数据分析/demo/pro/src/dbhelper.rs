
use polars::prelude::*;
use sqlx::QueryBuilder;
use sqlx::Value;
use sqlx::mysql::*;
 //  本课程来自 程序员在囧途(www.jtthink.com) 咨询群：98514334
 // 保存dataframe入库。 这里面会自动拼凑 SQL
 pub fn save_df<'a>(df:&'a DataFrame,table:&'a str)->QueryBuilder<'a,MySql>{
    let cols=df.get_column_names(); //所有列名
    let mut query_builder: QueryBuilder<MySql> = QueryBuilder::new("");

    //  拼凑出 insert into table(`xxx`,`xxx`,`xx`)  列 取决于 cols
    query_builder.push("insert into ");
    query_builder.push(table);
    query_builder.push("(");
    for i  in 0..cols.len(){
        if i>0{
            query_builder.push(",");
        }
        query_builder.push("`");
        query_builder.push(cols.get(i).unwrap());
        query_builder.push("`");
    }
    query_builder.push(") ");

    //开始拼凑 values 。cols顺序和 遍历顺序是一样的，所以无需担心 会错乱
    query_builder.push(" values");
    for i in 0..df.shape().0{ //行遍历
      if i>0{
        query_builder.push(",");
      }
      query_builder.push("(");

      for j in 0..cols.len() {
        let get_row=df.get_row(i).0;
        let v=get_row.get(j).unwrap().clone();
        
        if j>0{
          query_builder.push(",");
        }
         match  v {
          AnyValue::UInt32(val) => query_builder.push_bind(val),
          AnyValue::UInt64(val) => query_builder.push_bind(val),
          AnyValue::Int32(val) => query_builder.push_bind(val),
          AnyValue::Int64(val) => query_builder.push_bind(val),
          AnyValue::Utf8(val)=> query_builder.push_bind(val),
          AnyValue::Float64(val)=> query_builder.push_bind(val),
          AnyValue::Float32(val)=> query_builder.push_bind(val),  
          AnyValue::Null=> query_builder.push_bind(0),  
          _=>panic!("不支持的 值:{:?}",v)
         };
      }
      query_builder.push(")");
    }
    query_builder
 }