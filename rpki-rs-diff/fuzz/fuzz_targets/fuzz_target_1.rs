#![no_main]
// #[macro_use] extern crate libfuzzer_sys;
use libfuzzer_sys::fuzz_target;

// Import

// extern crate rpki;
// use rpki::{
//     ca::{idexchange::CaHandle, provisioning::ResourceClassName},
//     repository::resources::ResourceSet,
// };
// pub use rpki;
mod rpki {
    pub mod ca {
        pub mod idcert {
            // pub use rpki::ca::idcert::TbsIdCert;
            // pub use TbsIdCert;
        }
    }
}
// use crate::{ca::idcert::TbsIdCert};
// use crate::src::ca::idcert;
// use super::src::{ca::idcert::TbsIdCert};
// use rpki::{ca::idcert::TbsIdCert};
// use rpki::*;
// pub use rpki::ca::idcert::TbsIdCert;
use ::rpki::ca::idcert;
// use rpki::ca::idcert::TbsIdCert;
// use rpki::idcert::TbsIdCert;
// use rpki::TbsIdCert;

fuzz_target!(|data: &[u8]| {
    // let _ = TbsIdCert::from_constructed(&mut rpki::decode::Constructed::new(&data));
    // let _ = rpki::ca::idcert::TbsIdCert::from_constructed(&data);
    // let _ = ca::idcert::TbsIdCert::from_constructed(&data);
    let _ = TbsIdCert::from_constructed(&data);
    // let _ = TbsIdCert::from_constructed(&data);
});
