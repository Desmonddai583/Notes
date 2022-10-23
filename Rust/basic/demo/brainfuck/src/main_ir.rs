
mod opcode;
mod ir_code;

use std::io::Write;
use std::io::Read;
use ir_code::IR;

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
        let opcode_code = opcode::Code::from(data)?;
        // 将 opcode 转换为 ir code
        let code = ir_code::Code::from(opcode_code.instrs)?;
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
                IR::SHR(x) => {
                    sp += x as usize;
                    // 如果超过了纸带的长度就进行扩充
                    if sp >= self.stack.len() {
                        let expand = sp - self.stack.len() + 1;
                        for _ in 0..expand {
                            self.stack.push(0);
                        }
                    }
                }
                IR::SHL(x) => sp = if sp == 0 { 0 } else { sp - x as usize },
                IR::ADD(x) => {
                    // 允许溢出
                    self.stack[sp] = self.stack[sp].overflowing_add(x).0;
                }
                IR::SUB(x) => {
                    self.stack[sp] = self.stack[sp].overflowing_sub(x).0;
                }
                IR::PUTCHAR => {
                    // 将字符打印到标准输出
                    std::io::stdout().write_all(&[self.stack[sp]])?;
                }
                IR::GETCHAR => {
                    let mut buf: Vec<u8> = vec![0; 1];
                    // 从标准输入读取字符
                    std::io::stdin().read_exact(&mut buf)?;
                    // 将字符写到纸带上
                    self.stack[sp] = buf[0];
                }
                IR::JIZ(x) => {
                    // 如果指针指向的单元值为零，向后跳转到对应的 ] 指令的次一指令处
                    if self.stack[sp] == 0x00 {
                        pc = x as usize;
                    }
                }
                IR::JNZ(x) => {
                    // 如果指针指向的单元值不为零，向前跳转到对应的 [ 指令的次一指令处
                    if self.stack[sp] != 0x00 {
                        pc = x as usize;
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