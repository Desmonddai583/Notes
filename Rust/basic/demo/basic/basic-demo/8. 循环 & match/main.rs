
fn filter(html:&str){

    // for c in html.chars(){
    //     println!("{}",c)
    // }
    // println!("{}",html.len())
    // match html.len() {
    //     4..=10 => println!("{}","oK"),
    //     0..=3=> println!("{}","太短了"),
    //     _ => println!("{}","太长了"),
    // }
    
    for i in 1..=10{
        println!("{}",i);
    }
}
fn main() {
     
    let html="12345678901";
    filter(html);

}


