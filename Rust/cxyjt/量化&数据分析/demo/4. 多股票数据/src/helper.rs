use polars::{prelude::*,};
// 本课程来自 程序员在囧途(www.jtthink.com) 咨询群：98514334
// 获取 振幅 
pub fn set_amp(df:&mut DataFrame)->Result<(),PolarsError>{
    let high=df.column("最高")?;
    let low=df.column("最低")?;
    let pre_close=df.column("昨收")?;

    let amp=(high-low).divide(pre_close)?*100.0;
    let amp:Series=  amp.f64()?.into_iter().map(|item|{
        format!("{:.2}%",item.unwrap_or(0.0))
     }).collect();
 
     let amp=Series::new("振幅",amp);
     
     df.insert_at_idx(0, amp)?;

     Ok(())
}


//  计算 ma  ,i 是5代表ma5  是20代表ma20
pub fn set_ma(df:&mut DataFrame,i:usize,col:&str)->Result<(),PolarsError>{
    let   close=df.column("收盘")?;
    let mut opt=RollingOptionsImpl::default();
    opt.window_size=Duration::new(i as i64);
    opt.min_periods=i;
    let mai=close.reverse().rolling_mean(opt)?.reverse();

    let mai=Series::new(col,mai);
     
     df.insert_at_idx(0, mai)?;
    Ok(())
}