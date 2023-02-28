#![no_main]

use libfuzzer_sys::fuzz_target;
use rpki::uri::Rsync;

fuzz_target!(|data: &[u8]| {
    if let Ok(s) = std::str::from_utf8(data) {
        let _ = Rsync::from_string(s.to_string());
    }
    // let _ = Rsync::from_slice(data);
});

// "rsync://host/module/$%&'()*+,-./0123456789:;=ABCDEFGHIJKLMNOPQRSTUVWXYZ_abcdefghijklmnopqrstuvwxyz~"
// "rsync://host/module/"
// "rsync://host/module/foo/"
// "rsync://host/module/foo/bar"
