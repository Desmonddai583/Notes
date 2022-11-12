#[derive(Debug, Default, Clone)]
struct User {
  id: i32,
  name: String,
  age: i32
}


// fn load_user(u: &mut User) {
//   u.age = 18;
// }

// fn main() {
//     let mut a: User = User{id: 123, ..Default::default()};
//     load_user(&mut a);

//     println!("a={:?}", a);
// }


fn load_user(u: &mut User) -> User {
  u.age = 18;
  u.clone()
}

fn main() {
    let mut a: User = User{id: 123, ..Default::default()};
    let user2 = load_user(&mut a);

    println!("a={:?}", a);
    println!("a={:?}", user2);
}
