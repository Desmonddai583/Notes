use crate::opcode::Opcode;

#[derive(Debug)]
pub enum IR {
    SHR(u32),
    SHL(u32),
    ADD(u8),
    SUB(u8),
    PUTCHAR,
    GETCHAR,
    JIZ(u32), // Jump if zero, alias of "["
    JNZ(u32), // Jump if not zero, alias of "]"
}

pub struct Code {
    pub instrs: Vec<IR>,
}

impl Code {
    pub fn from(data: Vec<Opcode>) -> Result<Self, Box<dyn std::error::Error>> {
        // 存储匹配到的指令，遇到相同且相邻指令时进行折叠
        let mut instrs: Vec<IR> = Vec::new();
        // 借助栈结构来匹配 [ 和 ] 符号
        let mut jstack: Vec<u32> = Vec::new();

        for e in data {
            match e {
                Opcode::SHR => {
                    // 如果最后一个元素是 IR::SHR 则将其计数值加一，也就是折叠起来，否则就添加新元素
                    match instrs.last_mut() {
                        Some(IR::SHR(x)) => {
                            *x += 1;
                        }
                        _ => {
                            instrs.push(IR::SHR(1))
                        }
                    }
                }
                Opcode::SHL => {
                    match instrs.last_mut() {
                        Some(IR::SHL(x)) => {
                            *x += 1;
                        }
                        _ => {
                            instrs.push(IR::SHL(1))
                        }
                    }
                }
                Opcode::ADD => {
                    match instrs.last_mut() {
                        Some(IR::ADD(x)) => {
                            // 允许溢出
                            let (b, _) = x.overflowing_add(1);
                            *x = b;
                        }
                        _ => {
                            instrs.push(IR::ADD(1))
                        }
                    }
                }
                Opcode::SUB => {
                    match instrs.last_mut() {
                        Some(IR::SUB(x)) => {
                            // 允许溢出
                            let (b, _) = x.overflowing_add(1);
                            *x = b;
                        }
                        _ => {
                            instrs.push(IR::SUB(1))
                        }
                    }
                }
                Opcode::PUTCHAR => {
                    instrs.push(IR::PUTCHAR)
                }
                Opcode::GETCHAR => {
                    instrs.push(IR::GETCHAR)
                }
                Opcode::LB => {
                    instrs.push(IR::JIZ(0));
                    // 将 IR::JIZ 符号所在的索引位置压入栈中
                    jstack.push((instrs.len() - 1) as u32)
                }
                Opcode::RB => {
                    let j = jstack.pop().ok_or("pop from empty list")?;
                    // IR::JNZ 所存储的值是对应 IR::JIZ 指令在 instrs 中的索引位置
                    instrs.push(IR::JNZ(j));
                    let instrs_len = instrs.len();
                    match &mut instrs[j as usize] {
                        IR::JIZ(x) => {
                            // 同样，IR::JIZ 所存储的值是对应 IR::JNZ 指令在 instrs 中的索引位置
                            *x = (instrs_len - 1) as u32
                        }
                        _ => unreachable!()
                    }
                }
            }
        }

        Ok(Code { instrs })
    }
}