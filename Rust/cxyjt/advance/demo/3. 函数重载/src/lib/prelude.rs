pub trait UserInit<T> {
  fn new(v: T) -> Self;
}

pub trait CommonInit {
  fn new() -> Self;
}