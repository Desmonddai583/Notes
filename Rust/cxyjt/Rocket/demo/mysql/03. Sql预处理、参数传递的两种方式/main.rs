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

    let stmt = conn
        .prep("select user_id,user_name from users where user_id=:uid")
        .unwrap();

    let ret: Option<(i32, String)> = conn.exec_first(&stmt, params! {"uid"=>3}).unwrap();

    let ret2 = conn
        .exec_map(&stmt, params! {"uid"=>3}, |(uid, uname)| UserModel {
            user_id: uid,
            user_name: uname,
        })
        .unwrap();
    println!("{:?}", ret);
    println!("{:?}", ret2);
}
