mod api;
mod models;
// use api::Prods;
// use models::*;
 
fn max<'x>(a:&'x i32,b:&'x i32) ->&'x i32{
  if a>b{
      a
  }else {
    b
  }
}

fn main() {
    let a=12;
    let b=21;
    println!("最大值是:{}",max(&a,&b));

   
 

}
