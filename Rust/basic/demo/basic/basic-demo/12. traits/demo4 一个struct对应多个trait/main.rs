mod api;
mod models;
use api::Prods;
use api::Stock;
use models::*;
 
fn show_detail<T>(p:T) 
where T:Prods+Stock{
  println!("商品的库存是:{}",p.get_stock());
} 

fn main() {
    let book1: Book = Prods::new(101, 20.6);
    show_detail(book1);
}
