创建迭代器
  iter()  迭代 &T 引用   只需查看数据时使用
  iter_mut() &mut T 可变引用  需要编辑修改时使用
  into_iter() T 会移动所有权  来自于IntoIterator trait  赋予新所有者时使用

表格库
  https://github.com/nukesor/comfy-table

  comfy-table = "6.1.0"

  use comfy_table::Table;

  定义表头
    const headers:&[&'static str]=&["股票代码","交易日期","开盘价"];

  排序
     pub fn sort(&mut self)->&Self{
          self.data.sort_by(|d1,d2| 
                d1.trade_date.cmp(&d2.trade_date));
                self
      }
  
  处理日期库
    https://github.com/chronotope/chrono

    chrono = "0.4.22"

    当前时间
      let now=Local::now();
      println!("{}",now.format("%Y%m%d").to_string());

    格式化文档
      https://docs.rs/chrono/latest/chrono/format/strftime/index.html

    #[derive(Default,Debug,Clone,Deserialize)]
    struct DataFrame{
      ts_code:Option<String>,
      #[serde(deserialize_with = "date_from_str")]
      trade_date:NaiveDate,
      open:Option<f64>
    }
    fn date_from_str<'de, D>(deserializer: D) -> Result<NaiveDate, D::Error>
    where
        D: serde::Deserializer<'de>,
    {
        let s: String = Deserialize::deserialize(deserializer)?;
        NaiveDate::parse_from_str(&s, "%Y%m%d").
            map_err(de::Error::custom)
    }

Polars
  https://github.com/pola-rs/polars  
  参考文档 https://pola-rs.github.io/polars-book/user-guide/introduction.html
  拥有 和pandas差不多的语法。但是速度快很多

  静态数据创建
    let df = df! [
      "代码" => ["001", "002", "003"],
      "开盘价" => [20.0, 30.0, 33.0],
      "收盘价" => [Some(19), None, Some(33)]
    ]?;

  手工
    let s1 = Series::new("名称", &["001", "002", "003"]);
    let s2 = Series::new("开盘价", &[Some(1), None, Some(3)]);
    let df = DataFrame::new(vec![s1, s2])?;
    print!("{:?}",df);
