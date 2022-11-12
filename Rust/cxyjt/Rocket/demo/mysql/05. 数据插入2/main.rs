use mysql::prelude::*;
use mysql::*;
mod util;
use util::*;

#[derive(Debug)]
struct UserModel {
    user_id: i32,
    user_name: String,
}

fn main() {
    init_db(5, 10);
    let mut conn = db().unwrap();

    // let stmt=conn.prep("insert into user_coins(username,coins)
    // values(?,?)
    // ").unwrap();
    // let ret=conn.exec_iter(stmt, ("lisi",10)).unwrap();

    // println!("{:?}",ret.affected_rows());

    {
        let ret="insert into user_coins(username,coins)
        values(?,?)".with(("lisi",10)).run(&mut conn).unwrap();
    
        println!("{:?}",ret.affected_rows());
    }
    

    let users="select user_id,user_name from users".map(&mut conn, |(uid,uname)|{
            UserModel{
                user_id:uid,
                user_name:uname
            }
    }).unwrap();

    println!("{:?}",users);

     
}
