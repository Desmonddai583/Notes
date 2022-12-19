

// 新闻实体类
#[derive(Default,Debug)]
pub struct News{
    pub title:String,
    pub content:String,
    pub url:String
}
impl  News {
     pub fn new()->Self{
        News{..Default::default()}
     }
     pub fn set_title(&mut self,title:String){
        self.title=title;        
     }
     pub fn set_content(&mut self,content:String){
        self.content=content;
     }
     pub fn set_url(&mut self,url:String){
        self.url=url;
        
     }
}