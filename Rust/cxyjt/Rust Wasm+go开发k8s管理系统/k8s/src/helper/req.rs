
pub struct Request  {
    base_url:&'static str
}
impl Request{
    fn New(baseurl:&'static str) ->Request{
         Request{base_url:baseurl}   
    }
    fn Get(_path:&'static str){

    }

}