use mysql::prelude::*;

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
    let sql = "select user_id,user_name from users";
    let users = conn.query_map(sql, |(uid, uname)| UserModel {
        user_id: uid,
        user_name: uname,
    });

    println!("{:?}", users.unwrap());
}
