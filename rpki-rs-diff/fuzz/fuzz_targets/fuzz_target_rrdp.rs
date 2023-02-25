#![no_main]

use libfuzzer_sys::fuzz_target;

use std::io::BufReader;
use rpki::xml::decode::Reader;

use rpki::rrdp::Snapshot;

fuzz_target!(|data: &[u8]| {
    let _ = Snapshot::parse(data);
});

// fuzz_target!(|data: &[u8]| {
//     if let Ok(data) = BufReader::new(data) {
//         let _ = Snapshot::parse(data);
//     }
// });

// // fuzz_target!(|data: io::BufRead| {
// fuzz_target!(|data: Reader<R>| {
//     let _ = Snapshot::parse(data);
// });

// fuzz_target!(|data: &[u8]| {
//     let _ = Snapshot::parse(BufReader::new(data));
// });
