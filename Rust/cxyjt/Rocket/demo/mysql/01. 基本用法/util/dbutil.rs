use mysql::*;
static mut DB_POOL: Option<Pool> = None;
pub fn init_db(_min: usize, _max: usize) {
    let dsn = "mysql://root:123123@192.168.29.1:3307/test";
    unsafe {
        DB_POOL = Some(Pool::new_manual(_min, _max, dsn).unwrap());
    }
}
pub fn db() -> Result<PooledConn> {
    unsafe {
        match &DB_POOL {
            Some(pool) => pool.get_conn(),
            None => {
                panic!("you must call init_db()");
            }
        }
    }
}
