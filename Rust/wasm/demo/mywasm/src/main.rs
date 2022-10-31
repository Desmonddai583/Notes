use serde::{Deserialize, Serialize};

#[derive(Debug, Serialize, Deserialize)]
struct User {
    userid: i32,
    username: String,
}
fn main() {
    let data = r#"
        {
            "userid": 101,
             "username": "abc"
        }"#;

    let v: User = serde_json::from_str(data).unwrap();
    println!("{:?}", v);
}
