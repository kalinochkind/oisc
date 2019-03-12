use std::{process, io};
use std::io::{Read, Write};
use crate::utils;


pub struct CPU<'a> {
    data: &'a mut [i32],
}

impl<'a> CPU<'a> {
    pub fn new(program: &mut [i32]) -> CPU {
        assert!(program.len() > 0);
        CPU { data: program }
    }

    pub fn step(&mut self) {
        let index = self.data[0] as usize;
        if index >= self.data.len() {
            if self.data[0] == -1 {
                process::exit(0);
            }
            utils::die(format!("Invalid instruction pointer: {}", index).as_str());
        }
        self.data[0] += 3;
        self.access(index + 2);
        let val = *self.access(self.data[index] as usize);
        if val < 0 {
            return;
        }
        let val = if self.data[index + 1] == -1 {
            -io::stdin().bytes().next()
                .and_then(|res| { res.ok() })
                .map(|x| { x as i32 }).unwrap_or(-1)
        } else {
            let src_addr = *self.access(self.data[index + 1] as usize);
            *self.access(src_addr as usize)
        };
        if self.data[index + 2] == -1 {
            io::stdout().write(&[val as u8]).unwrap();
            io::stdout().flush().unwrap();
        } else {
            let dst = *self.access(self.data[index + 2] as usize);
            *self.access(dst as usize) -= val;
        }
    }

    fn access(&mut self, index: usize) -> &mut i32 {
        if index >= self.data.len() {
            utils::die(format!("Invalid address: {}", index).as_str());
        }
        &mut self.data[index]
    }
}