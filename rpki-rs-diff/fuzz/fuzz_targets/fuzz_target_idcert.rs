#![no_main]
use libfuzzer_sys::fuzz_target;

use rpki::ca::idcert::IdCert;

fuzz_target!(|data: &[u8]| {
    let _ = IdCert::decode(data);
});

// cp rpki-rs/test-data/**/*id*.cer dest/
