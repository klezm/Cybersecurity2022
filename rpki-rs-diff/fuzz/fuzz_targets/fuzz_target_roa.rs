#![no_main]

use libfuzzer_sys::fuzz_target;

use rpki::repository::roa::Roa;

fuzz_target!(|data: &[u8]| {
    let _ = Roa::decode(data, true);
    let _ = Roa::decode(data, false);
});

// cp rpki-rs/test-data/**/*.roa corpus/roa/* dest/
// cp **/*snap*.xml corpus/roa/* dest/
