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


//  计算 ma5
pub fn set_ma5(df:&mut DataFrame)->Result<(),PolarsError>{
    let   close=df.column("收盘")?;
    let mut opt=RollingOptionsImpl::default();
    opt.window_size=Duration::new(5);
    opt.min_periods=5;
    let ma5=close.reverse().rolling_mean(opt)?.reverse();

    let ma5=Series::new("MA5",ma5);
     
     df.insert_at_idx(0, ma5)?;
    Ok(())
}