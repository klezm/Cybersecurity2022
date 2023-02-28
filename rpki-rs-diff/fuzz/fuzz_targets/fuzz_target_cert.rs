#![no_main]
use libfuzzer_sys::fuzz_target;

use rpki::repository::Cert;

fuzz_target!(|data: &[u8]| {
    let _ = Cert::decode(data);
});

// cp rpki-rs/test-data/**/*.cer dest/
