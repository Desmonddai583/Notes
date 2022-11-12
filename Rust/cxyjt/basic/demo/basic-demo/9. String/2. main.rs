fn main() {
    let first_name = String::from("shen");
    let last_name = String::from("yi");
    ///  first_name.push_str(&str)
    let name = format!("{}{}", first_name, last_name);
    println!("{}", name);
}
