#![no_main]

use libfuzzer_sys::fuzz_target;

// use krill::cli::options::Options;

fuzz_target!(|data: &[u8]| {
    // let _ = Options::parse_my_ca(data)
});
