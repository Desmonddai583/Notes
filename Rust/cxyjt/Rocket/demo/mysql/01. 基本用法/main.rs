use mysql::prelude::*;

mod util;
use util::*;

fn main() {
    init_db(5, 10);
    let mut conn = db().unwrap();
    let ret: Option<(i32, String)> = conn
        .query_first("select user_id,user_name from users order by user_id desc limit 1 ")
        .unwrap();
    println!("{:?}", ret.unwrap().1);
}
