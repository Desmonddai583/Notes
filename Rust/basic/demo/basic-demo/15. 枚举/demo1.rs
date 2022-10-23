mod api;
mod models;
// use api::Prods;
// use models::*;

// fn show_name<'a>(name: &'a str) -> &'a str {
//     name
// }

#[derive(Debug)]
enum Sex {
    Male(String, i32), //1也代表男
    Female(String, i32),
}
#[derive(Debug)]
struct User {
    id: i32,
    sex: Sex,
}
fn main() {
    let u = User {
        id: 101,
        sex: Sex::Male(String::from("男"), 1),
    };
    println!("{:?}", u);
}
