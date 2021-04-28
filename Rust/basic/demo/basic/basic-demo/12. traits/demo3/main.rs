mod api;
mod models;
use api::Prods;
use models::Book;
use models::Phone;
fn sum<T: Prods, U: Prods>(p1: T, p2: U) {
    println!("商品总价是:{}", p1.get_price() + p2.get_price());
}

fn main() {
    let book1: Book = Prods::new(101, 20.6);
    let phone1: Phone = Prods::new(202, 1300.0);
    sum(book1, phone1);
}
