mod api;
mod models;
use api::Prods;
use models::book_model::*;
fn main() {
    let book: Book = Prods::new(101, 20.6);
    println!("{:?}", book.get_price());
}
