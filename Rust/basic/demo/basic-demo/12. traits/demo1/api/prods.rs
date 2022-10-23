use crate::models::book_model::Book;
pub trait Prods {
    fn get_price(&self) -> f32;
}

impl Prods for Book {
    fn get_price(&self) -> f32 {
        &self.price + 10.0
    }
}
