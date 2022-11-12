const CSV_PATH:&str="./test.csv";
use csv::Reader;
fn main(){
    //  let mut data=Reader::from_path(CSV_PATH).unwrap();

    // data.records().into_iter().for_each(|item|{
    //         if let Ok(sr)=item{
                
    //             sr.into_iter().for_each(|c|{
    //                 print!(" {} ",c);
    //             });
    //             println!("\n{}","----------");
    //         }

    // });
   
     let  list =[String::from("u1"),String::from("u2"),String::from("u3")];
 
    let newlist= list.into_iter().map(|mut item|{
        item.push_str("--user");
        item
     }).collect::<Vec<String>>();
     println!("{:?}",newlist);

}