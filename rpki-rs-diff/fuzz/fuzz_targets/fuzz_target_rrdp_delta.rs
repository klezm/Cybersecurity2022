#![no_main]

use libfuzzer_sys::fuzz_target;

use rpki::rrdp::Delta;

fuzz_target!(|data: &[u8]| {
    let _ = Delta::parse(data);
});
