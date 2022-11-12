mod api;
mod models;
use api::Prods;
use models::*;
 
fn sum(p1:Book,p2:Book)
 {
  println!("商品总价是:{}", p1+p2);
}

fn main() {
  
    let book1: Book = Prods::new(101, 20.6);
    let book2: Book = Prods::new(110, 30.5);
    sum(book1,book2);
}
