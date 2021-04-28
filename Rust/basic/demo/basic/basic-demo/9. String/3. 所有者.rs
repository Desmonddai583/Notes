fn change(s: &mut String) {
    s.push_str("_19");
}
fn main() {
    let mut me = String::from("shenyi");
    change(&mut me);
    println!("{}", me);
} //me才废掉
