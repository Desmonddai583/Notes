const CSV_PATH:&str="./test.csv";
use csv::Reader;

struct User{
    id:i32,
    age:i32,
    score:i32,
}
impl User {
    fn iter(&self)->UserIterator{
        UserIterator{index:0,item:self}
    }
}
struct  UserIterator<'a> {
    index:usize,
    item: &'a User,
}
impl<'a> Iterator for  UserIterator<'a> {
    type Item= &'a i32;
    fn next(&mut self) -> Option<Self::Item> {
     
      let ret=match self.index {
             0=>Some(&self.item.id),
             1=>Some(&self.item.age),
             2=>Some(&self.item.score),
            _=>None,
        };
       self.index+=1;
     ret 
    }
}
 
 
fn main(){
    let u=User{id:101,age:19,score:100};
    u.iter().for_each(|item|{
        println!("{}",item);
    });





    
    //  let mut data=Reader::from_path(CSV_PATH).unwrap();

    // data.records().into_iter().for_each(|item|{
    //         if let Ok(sr)=item{
                
    //             sr.into_iter().for_each(|c|{
    //                 print!(" {} ",c);
    //             });
    //             println!("\n{}","----------");
    //         }

    // });
   
     

}