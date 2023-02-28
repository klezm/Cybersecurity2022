#![no_main]

use libfuzzer_sys::fuzz_target;

use rpki::rrdp::NotificationFile;

fuzz_target!(|data: &[u8]| {
    let _ = NotificationFile::parse(data);
});
