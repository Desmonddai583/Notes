mod api;
mod models;
// use api::Prods;
// use models::*;
 
fn show_name<'a>(name:&'a str)->&'a str{
    name
}

fn main() {
      let name="zhangsan";
    show_name(name);
 

}
