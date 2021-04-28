mod api;
mod models;
use api::Prods;
use models::book_model::*;
fn main() {
    let book = new_book(101, 25.0);
    println!("{:?}", book.get_price());
}
