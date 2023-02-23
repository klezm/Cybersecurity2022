#![no_main]
use libfuzzer_sys::fuzz_target;

use rpki::ca::idcert::IdCert;
use rpki::repository::Cert;

fuzz_target!(|data: &[u8]| {
    let _ = IdCert::decode(data);
    let _ = Cert::decode(data);
});
