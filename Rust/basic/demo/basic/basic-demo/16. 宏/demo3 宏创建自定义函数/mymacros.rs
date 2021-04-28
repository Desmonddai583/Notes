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

macro_rules! func {
    ($fn_name:ident) => {
        fn $fn_name(){
            println!("my function,name is :{}",stringify!($fn_name));
        }
    };
}

 