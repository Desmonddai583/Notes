 use chrono::Utc;
// 本课程来自 程序员在囧途(www.jtthink.com) 咨询群：98514334
// 专注golang、k8s云原生、Rust技术栈
 
 
mod fetcher;
use fetcher::*;
use regex::Regex;
#[tokio::main]
 async fn main()->anyhow::Result<()>{
    // 构建抓取的URL
        let now=Utc::now().timestamp(); 
        let url=format!("https://www.cls.cn/nodeapi/refreshTelegraphList?lastTime={}",now);
        println!("当前地址:{}",url);
    
           let x=Xhr::new(url,XhrOption::new(r#""title":"(?P<title>.*?)","content":"(?P<content>.*?)""#));

           println!("{:?}",x.get_to_model().await?);
        
//         let    str=r#"
//         {"l":{"1200858":{"id":1200858,"ctime":1669907827},"1200859":{"title":"布伦特原油日内涨超3%","content":"【布伦特原油日内涨超3%】财联社12月1日电，
//         布伦特原油日内涨超3%，现报89.33美元/桶。WTI原油涨约3.4%，报83.17美元/桶。","brief":"【布伦特原
// 油日内涨超3%】财联社12月1日电，布伦特原油日内涨超3%，现报89.33美元/桶。","type":-1,"ctime":1669907802,"level":"C","id":1200859,"sub_titles":[],"images":[],"stock_list":[],"subjects":[{"article_id":1200859,"subject_id":1556,"subject_name":"环球市场情报","subject_img":"","subject_description":"","category_id":0,"attention_num":0,"is_attention":false,"is_reporter_subject":false},{"article_id":1200859,"subject_id":1583,"subject_name":"原油市场动态","subject_img":"","subject_description":"","category_id":0,"attention_num":0,"is_attention":false,"is_reporter_subject":false},{"article_id":1200859,"subject_id":1741,"subject_name":"海外大宗商品","subject_img":"","subject_description":"","category_id":0,"attention_num":0,"is_attention":false,"is_reporter_subject":false}],"reading_num":27693,"comment_num":0,"share_num":23},"1200861":{"title":"abc","content":"财联社12月1日电，瑞士信贷的第一波裁员可能比先前公布的人数要多；在其香港财富中心削减约5%的私人银
// 行员工；已在削减成本方面取得长足进展。","title":"原油日内","brief":"财联社12月1日电，瑞士信贷的第一波裁员可能比先前公布的人数要多；在其香
// 港财富中心削减约5%的私人银行员工；已在削减成本方面取得长足进展。","type":-1,"ctime":1669908131,"level":"C","id":1200861,"sub_titles":[],"images":[],"stock_list":[],"subjects":[{"article_id":1200861,"subject_id":1098,"subject_name":"美股动
// 态","subject_img":"","subject_description":"","category_id":0,"attention_num":0,"is_attention":false,"is_reporter_subject":false},{"article_id":1200861,"subject_id":1556,"subject_name":"环球市场情报","subject_img":"","subject_description":"","category_id":0,"attention_num":0,"is_attention":false,"is_reporter_subject":false}],"reading_num":33305,"comment_num":0,"share_num":6},"1200862":{"id":1200862,"ctime":1669908160},"1200863":{"id":1200863,"ctime":1669908279},"1200866":{"id":1200866,"ctime":1669908437},"1200867":{"id":1200867,"ctime":1669908624},"1200868":{"id":1200868,"ctime":1669908856},"1200869":{"id":1200869,"ctime":1669908849},"1200870":{"id":1200870,"ctime":1669909190}},"i":1669907802,"a":1669909321}
//  "#;
//        let str=&str.replace("\n", "");
//        let re=Regex::new(r#""title":"(?P<title>.*?)","content":"(?P<content>.*?)""#).expect("正则pattern错误");
//         // 本课程来自 程序员在囧途(www.jtthink.com) 咨询群：98514334
//        re.captures_iter( str).
//               into_iter().for_each(|item|{
//                      if let Some(v)=item.name("title"){
//                         println!("{}",v.as_str());
//                      }
//                      if let Some(v)=item.name("content"){
//                             println!("{}",v.as_str());
//                       }
              
//        });
       

        
        Ok(())

 }
    

 
// 本课程来自 程序员在囧途(www.jtthink.com) 咨询群：98514334
// 专注golang、k8s云原生、Rust技术栈