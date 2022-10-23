#[macro_use]
mod mymacros;
 
fn test() -> &'static str {
   "abc"
}
fn main() {
   echo!();
   let a=3;
   echo!(a==4);
  
}
