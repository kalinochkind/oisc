mod cpu;
mod utils;

use std::{fs, env, slice};

use cpu::CPU;

fn main() {
    let args: Vec<String> = env::args().collect();
    if args.len() < 2 {
        utils::die("Filename required!");
    }
    let mut program = fs::read(&args[1]).unwrap_or_else(|_| {
        utils::die("Invalid filename!");
    });
    if program.len() == 0 || program.len() % 4 != 0 {
        utils::die("Invalid program!");
    }
    let mut cpu = CPU::new(unsafe {
        slice::from_raw_parts_mut(program.as_mut_ptr() as *mut i32, program.len() / 4)
    });
    loop {
        cpu.step();
    }

}
