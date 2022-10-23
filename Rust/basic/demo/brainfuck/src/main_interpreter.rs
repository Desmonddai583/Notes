mod opcode;

use std::io::Write;
use std::io::Read;
use opcode::{Opcode, Code};

struct Interpreter {
    // 表示无限长的纸带
    stack: Vec<u8>,
}

impl std::default::Default for Interpreter {
    fn default() -> Self {
        // 初始化，提供默认值
        Self { stack: vec![0; 1] }
    }
}

impl Interpreter {
    fn run(&mut self, data: Vec<u8>) -> Result<(), Box<dyn std::error::Error>> {
        // 将源文件中的内容转换为 Opcode 数组
        let code = Code::from(data)?;
        let code_len = code.instrs.len();
        // Program counter，程序计数器
        let mut pc: usize = 0;
        // Stack Pointer，栈指针，也就是表示在纸带的哪个位置
        let mut sp: usize = 0;

        // 解释器的主循环
        loop {
            if pc >= code_len {
                // 代码已经执行完了
                break;
            }

            // 匹配相应的指令并解释执行
            match code.instrs[pc] {
                Opcode::SHR => {
                    sp += 1;
                    // 如果达到了纸带的长度就进行填充，延长纸带的长度
                    if sp == self.stack.len() {
                        self.stack.push(0)
                    }
                }
                Opcode::SHL => sp = if sp == 0 { 0 } else { sp - 1 },
                Opcode::ADD => {
                    // 允许溢出
                    self.stack[sp] = self.stack[sp].overflowing_add(1).0;
                }
                Opcode::SUB => {
                    self.stack[sp] = self.stack[sp].overflowing_sub(1).0;
                }
                Opcode::PUTCHAR => {
                    // 将字符打印到标准输出
                    std::io::stdout().write_all(&[self.stack[sp]])?;
                }
                Opcode::GETCHAR => {
                    let mut buf: Vec<u8> = vec![0; 1];
                    // 从标准输入读取字符
                    std::io::stdin().read_exact(&mut buf)?;
                    // 将字符写到纸带上
                    self.stack[sp] = buf[0];
                }
                Opcode::LB => {
                    // 如果指针指向的单元值为零，向后跳转到对应的 ] 指令的次一指令处
                    if self.stack[sp] == 0x00 {
                        pc = code.jtable[&pc];
                    }
                }
                Opcode::RB => {
                    // 如果指针指向的单元值不为零，向前跳转到对应的 [ 指令的次一指令处
                    if self.stack[sp] != 0x00 {
                        pc = code.jtable[&pc];
                    }
                }
            }
            // 移动计数器，执行下一个指令
            pc += 1;
        }

        Ok(())
    }
}

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let args: Vec<String> = std::env::args().collect();
    let data = std::fs::read(&args[1])?;
    let mut interpreter = Interpreter::default();
    interpreter.run(data)
}