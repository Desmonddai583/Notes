use std::io;
use rand::Rng;

fn main() {
  println!("Guess the number!");

  let secret_number: u32 = rand::thread_rng().gen_range(1..101);

  loop {
    println!("Please input your guess:");
    let mut guess = String::new();
    io::stdin().read_line(&mut guess).unwrap();
    
    let guess_number: u32 = match guess.trim().parse() {
      Ok(number) => number,
      Err(_) => continue,
    };

    println!("You guessed: {}", guess_number);

    if guess_number > secret_number {
      println!("Too large");
    } else if guess_number < secret_number {
      println!("Too small");
    } else {
      println!("You win!");
      break;
    }
  }
}
