use std::io::prelude::*;
use dynasm::dynasm;
use dynasmrt::{DynasmApi, DynasmLabelApi};

mod opcode;
mod ir_code;

use ir_code::IR;

unsafe extern "sysv64" fn putchar(char: u8) {
    std::io::stdout().write_all(&[char]).unwrap()
}

#[derive(Default)]
struct Interpreter {}

impl Interpreter {
    fn run(&mut self, data: Vec<u8>) -> Result<(), Box<dyn std::error::Error>> {
        // 将源文件中的内容转换为 Opcode 数组
        let opcode_code = opcode::Code::from(data)?;
        // 将 opcode 转换为 ir code
        let code = ir_code::Code::from(opcode_code.instrs)?;
        // 用来当匹配到 [ 和 ] 时执行跳转的
        let mut loops = vec![];

        // 通过此对象分配可写、可执行的内存，并且需要将代码都写入到此内存中
        let mut ops = dynasmrt::x64::Assembler::new()?;
        // 代码的入口点
        let entry_point = ops.offset();

        dynasm!(ops
            // 声明要使用的汇编语法
            ; .arch x64
            // 将内存的起始地址放到 rcx，rdi存储的是我们生成的函数的第一个参数
            ; mov rcx, rdi
        );

        for ir in code.instrs {
            match ir {
                IR::SHL(x) => dynasm!(ops
                    ; sub rcx, x as i32 // sp -= x
                ),
                IR::SHR(x) => dynasm!(ops
                    ; add rcx, x as i32 // sp += x
                ),
                IR::ADD(x) => dynasm!(ops
                    ; add BYTE [rcx], x as i8 // sp* += x
                ),
                IR::SUB(x) => dynasm!(ops
                    ; sub BYTE [rcx], x as i8 // sp* -= x
                ),
                IR::PUTCHAR => dynasm!(ops
                    ; mov r12, rcx
                    ; mov rdi, [rcx]
                    ; mov rax, QWORD putchar as _
                    ; sub rsp, BYTE 0x28 // Make stack 16 byte aligned
                    ; call rax
                    ; add rsp, BYTE 0x28
                    ; mov rcx, r12
                ),
                IR::GETCHAR => {
                    // 用的少，省略
                }
                IR::JIZ(_) => {
                    let l = ops.new_dynamic_label();
                    let r = ops.new_dynamic_label();
                    loops.push((l, r));
                    // 如果指针指向的单元值为零，向后跳转到对应的 ] 指令的次一指令处
                    dynasm!(ops
                        ; cmp BYTE [rcx], 0
                        ; jz => r
                        ; => l
                    )
                }
                IR::JNZ(_) => {
                    let (l, r) = loops.pop().unwrap();
                    // 如果指针指向的单元值不为零，向前跳转到对应的 [ 指令的次一指令处
                    dynasm!(ops
                        ; cmp BYTE [rcx], 0
                        ; jnz => l
                        ; => r
                    )
                }
            }
        }
        dynasm!(ops
            ; ret
        );

        // 对 ops 对象调用 finalize 后才会实际分配内存
        let exec_buffer = ops.finalize().unwrap();
        // 给 Brainfuck 源码执行时所使用的内存
        let mut memory: Box<[u8]> = vec![0; 65536].into_boxed_slice();
        // 内存起始地址
        let memory_addr_from = memory.as_mut_ptr();
        // 内存结束地址
        let memory_addr_to = unsafe { memory_addr_from.add(memory.len()) };
        // 将 exec_buffer 这块可写、可执行的内存转换成一个函数
        let fun: fn(memory_addr_from: *mut u8, memory_addr_to: *mut u8) =
            unsafe { std::mem::transmute(exec_buffer.ptr(entry_point)) };
        // 执行该函数
        fun(memory_addr_from, memory_addr_to);

        Ok(())
    }
}

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let args: Vec<String> = std::env::args().collect();
    assert!(args.len() >= 2);
    let mut f = std::fs::File::open(&args[1])?;
    let mut c: Vec<u8> = Vec::new();
    f.read_to_end(&mut c)?;
    let mut i = Interpreter::default();
    i.run(c)
}