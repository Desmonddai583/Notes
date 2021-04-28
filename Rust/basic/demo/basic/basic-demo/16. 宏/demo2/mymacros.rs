macro_rules! echo {
    () => (
        println!("shenyi");
    );
    ($exp:expr) => (
        println!("{}",stringify!($exp));
    );
    ($($exp:expr),+) => (
        $(
            println!("{}",stringify!($exp));     
        )+
    );
    
}