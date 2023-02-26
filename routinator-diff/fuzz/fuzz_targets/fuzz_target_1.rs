#![no_main]

use libfuzzer_sys::fuzz_target;

// use routinator::http::validity::{handle_validity_query};
use routinator::collector::rrdp::HttpResponse::parse_etag;
// use routinator::slurm::extend_from_parsed;
// use routinator::utils::date::parse_http_date;
// use routinator::utils::binio::parse;
// use routinator::config::ConfigFile::parse;

fuzz_target!(|data: &[u8]| {
    // fuzzed code goes here
    // let _ = handle_validity_query(data);
    let _ = parse_etag(data);
});
