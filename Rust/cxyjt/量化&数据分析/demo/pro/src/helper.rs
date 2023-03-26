use chrono::format::format;
use polars::{prelude::*,};
use sqlx::query::Query;
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

// 本课程来自 程序员在囧途(www.jtthink.com) 咨询群：98514334
//  计算 ma  ,i 是5代表ma5  是20代表ma20
pub fn set_ma(df:&mut DataFrame,i:usize,col:&str)->Result<(),PolarsError>{
    let   close=df.column("close")?;
    let mut opt=RollingOptionsImpl::default();
    opt.window_size=Duration::new(i as i64);
    opt.min_periods=i;
    let mai=close.reverse().rolling_mean(opt)?.reverse();

    let mai=Series::new(col,mai);
     
     df.insert_at_idx(0, mai)?;
    Ok(())
}

//计算布林上轨   nstr 让用户传， 一般传 ma20
pub fn set_bollup(df:&mut DataFrame,i:usize,col:&str)->Result<(),PolarsError>{
    let   close=df.column("close")?;
    let ma=df.column(col)?;
    let mut opt=RollingOptionsImpl::default();
    opt.window_size=Duration::new(i as i64);
    opt.min_periods=i;
    let db_std=close.reverse().rolling_std(opt)?.reverse()*2;

    let bollup=Series::new("bollup",db_std.add_to(ma)?);
     
     df.insert_at_idx(0, bollup.round(2)?)?;
    Ok(())
}
// 本课程来自 程序员在囧途(www.jtthink.com) 咨询群：98514334
// 计算移动平均  n 可以取 12  26 分别代表 12 和 26日移动平均
// 之前课时 故意留了一坑，请大家 提问告知
pub fn set_ema(df:&mut DataFrame,n:usize)->Result<(),PolarsError>{

    let   close=df.column("close")?;
 
    let opt=EWMOptions::default();

    let close_ema=close.reverse().ewm_mean(   opt.and_span(n))?.reverse();
    let ema_series=Series::new(format!("ema{}",n).as_str(),close_ema);
    df.insert_at_idx(0, ema_series.round(2)?)?;
    Ok(())
}

// 计算 MACD---DIF值, 执行后 会出现一个series ，名称就是 dif （注意是小写的)
pub fn set_dif(df:&mut DataFrame)->Result<(),PolarsError>{
    set_ema(df,12)?; // --- ema12
    set_ema(df,26)?; // --- ema26
    let   ema12=df.column("ema12")?;
    let   ema26=df.column("ema26")?;
    let mut dif_series=ema12-ema26;
    df.insert_at_idx(0, dif_series.rename("dif").round(2)?)?;
    Ok(())
}
// 计算 MACD---DEA值
pub fn set_dea(df:&mut DataFrame)->Result<(),PolarsError>{
    let   close=df.column("dif")?;
 
    let   opt=EWMOptions::default();

    let mut close_ema=close.reverse().ewm_mean(   opt.and_span(9))?.reverse();
    df.insert_at_idx(0, close_ema.rename("dea").round(2)?)?;
    Ok(())
}
 
 
 // 计算 KDJ指标中的RSV值
pub fn set_rsv(df:&mut DataFrame)->Result<(),PolarsError>{
   let close=df.column("close")?;

   let mut opt=RollingOptionsImpl::default();
   opt.window_size=Duration::new(9 as i64);
   opt.min_periods=9;
   let l9=df.column("low")?.   // 前9日最低价
     reverse().rolling_min(opt.clone())?.reverse();

    let h9=df.column("low")?.  //前9日最高
    reverse().rolling_max(opt.clone())?.reverse();

    let mut rsv=(close-&l9)/(h9-l9)*100;

    df.insert_at_idx(0, rsv.rename("rsv").round(2)?)?;
    Ok(())
}
 

 // 本课程来自 程序员在囧途(www.jtthink.com) 咨询群：98514334
 
use hyper::Client;
pub async fn testdf() ->String{
    let client = Client::new();
    
        let uri = "http://localhost:8081/dayk/600031.SH".parse().unwrap();

        // Await the response...
        let mut resp = client.get(uri).await.unwrap();
        
        let a=hyper::body::to_bytes(resp.body_mut()).await.unwrap();
        let result = String::from_utf8(a.into_iter().collect()).expect("none");
        return result;
    

}
