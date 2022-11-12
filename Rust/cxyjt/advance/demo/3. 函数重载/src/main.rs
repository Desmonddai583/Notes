mod lib;
use lib::user::*;
use lib::prelude::UserInit;

fn main() {
    // let u: User = User::new();
    // let u: User = User::new(101);
    let u: User = User::new("desmond");
    println!("{:?}", u);
}
