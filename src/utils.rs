use std::process;


pub fn die(arg: &str) -> ! {
    eprintln!("{}", arg);
    process::exit(1)
}

