#[derive(Debug, Default, Clone)]
pub struct User {
  pub id: i32,
  pub name: String,
  pub age: i32
}

use std::fmt;
impl fmt::Display for User {
  fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
    write!(f, "user is {}, age is {}, name is {}", self.id, self.age, self.name)
  }
}

use super::prelude::*;
impl UserInit<i32> for User {
  fn new(id: i32) -> Self {
    User{id: id, ..Default::default()}
  }
}

impl UserInit<&str> for User {
  fn new(name: &str) -> Self {
    User{name: name.to_string(), ..Default::default()}
  }
}

impl CommonInit for User {
  fn new() -> Self {
    User{..Default::default()}
  }
}