// use anyhow::Result;
// use polars::prelude::*;
// use std::io::Cursor;

// #[tokio::main]
// async fn main() -> Result<()> {
//     tracing_subscriber::fmt::init();

//     let url = "https://raw.githubusercontent.com/owid/covid-19-data/master/public/data/latest/owid-covid-latest.csv";
//     let data = reqwest::get(url).await?.text().await?;

//     // 使用 polars 直接请求
//     let df = CsvReader::new(Cursor::new(data))
//         .infer_schema(Some(16))
//         .finish()?;
    
//     let filterd = df.filter(&df["new_deaths"].gt(500)?)?;
//     println!(
//         "{:?}",
//         filterd.select([
//             "location",
//             "total_cases", 
//             "new_cases", 
//             "total_deaths", 
//             "new_deaths"
//         ])
//     );

//     Ok(())
// }

use anyhow::Result;
use queryer::query;

#[tokio::main]
async fn main() -> Result<()> {
    tracing_subscriber::fmt::init();

    let url = "https://raw.githubusercontent.com/owid/covid-19-data/master/public/data/latest/owid-covid-latest.csv";

    // 使用 sql 从 URL 里获取数据
    let sql = format!(
        "SELECT location name, total_cases, new_cases, total_deaths, new_deaths \
        FROM {} where new_deaths >= 500 ORDER BY new_cases DESC",
        url
    );
    let df1 = query(sql).await?;
    println!("{:?}", df1);

    Ok(())
}