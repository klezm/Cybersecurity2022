#![no_main]
// #[macro_use] extern crate libfuzzer_sys;
use libfuzzer_sys::fuzz_target;
// use bytes::Bytes;

// extern crate rpki;
// use rpki::{
//     ca::{idexchange::CaHandle, provisioning::ResourceClassName},
//     repository::resources::ResourceSet,
// };
// pub use rpki;
// mod rpki {
//     pub mod ca {
//         pub mod idcert {
//             // pub use rpki::ca::idcert::TbsIdCert;
//             // pub use TbsIdCert;
//         }
//     }
// }
// use crate::{ca::idcert::TbsIdCert};
// use crate::src::ca::idcert;
// use super::src::{ca::idcert::TbsIdCert};
// use rpki::*;
// use rpki::TbsIdCert;
// use rpki::repository::Cert;
// use rpki::ca::idcert::TbsIdCert;
use rpki::ca::idcert::IdCert;
use rpki::repository::Cert;

fuzz_target!(|data: &[u8]| {
    // let _ = TbsIdCert::from_constructed(&mut rpki::decode::Constructed::new(&data));
    // let _ = rpki::ca::idcert::TbsIdCert::from_constructed(&data);
    // let _ = ca::idcert::TbsIdCert::from_constructed(&data);
    // let _ = TbsIdCert::from_constructed(&data);
    let _ = IdCert::decode(data);

    let _ = Cert::decode(data);
    // if let Ok(s) = std::str::from_utf8(data) {
    // if let Ok(s) = Bytes::from_static(data) {
    //     // let _ = s.parse::<rpki::repository::resources::ResourceSet>();
    //     // let _ = TbsIdCert::from_constructed(&data);
    //     let _ = Cert::decode(&s);
    // }
    // let _ = Cert::decode(Bytes::from_static(data));
});
