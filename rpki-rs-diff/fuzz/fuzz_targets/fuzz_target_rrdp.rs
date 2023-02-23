#![no_main]

use libfuzzer_sys::fuzz_target;

use rpki::rrdp::Snapshot;

fuzz_target!(|data: &[u8]| {
    // fuzzed code goes here
    let _ = Snapshot::parse(data);
});
