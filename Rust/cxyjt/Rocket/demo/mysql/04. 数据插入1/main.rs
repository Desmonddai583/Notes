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

    let stmt=conn.prep("insert into user_coins(username,coins)
    values(?,?)
    ").unwrap();
    let ret=conn.exec_iter(stmt, ("lisi",10)).unwrap();

    println!("{:?}",ret.affected_rows());
}
