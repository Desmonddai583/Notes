use serde::{Serialize,Deserialize};
#[derive(Serialize, Deserialize, Debug,Clone,PartialEq)]
pub struct ValueText {
    pub value: String,
    pub text: String,
}