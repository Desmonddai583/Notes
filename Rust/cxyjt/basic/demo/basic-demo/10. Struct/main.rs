#[derive(Debug)]
struct User{
    name: String,
    age: u8
}
impl User{
    fn version(&self){
        println!("1.0")
    }
    fn to_string(&self)->String{
        return String::from(format!("我的名字是：{}，我的年龄是:{}",&self.name,&self.age));
    }
}
 

fn main() {
     
     let me=User{name:String::from("shenyi"),age:19};
     println!("{:#?}",me); 

 

}  
