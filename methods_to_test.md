* [`IdCert::verify_validity`](https://github.com/NLnetLabs/rpki-rs/blob/80ca2f627892f863bb075974ae3fa545e519d379/src/ca/idcert.rs#L251) - Verifiziert die Validität eines Zertifikats, somit für kritische Aufgabe zuständig (evtl. auch simple Datentypen?)
* [`IdCert::verify_signature`](https://github.com/NLnetLabs/rpki-rs/blob/80ca2f627892f863bb075974ae3fa545e519d379/src/ca/idcert.rs#L282) - Verifiziert die Signatur eines Zertifikats, smit ebenfalls kritisch
* [`Csr::verify_signature`](https://github.com/NLnetLabs/rpki-rs/blob/80ca2f627892f863bb075974ae3fa545e519d379/src/ca/csr.rs#L150) - Validiert CSR gegen öffentlichen Schlüssel
* [`DigestAlgorithm::digest`](https://github.com/NLnetLabs/rpki-rs/blob/80ca2f627892f863bb075974ae3fa545e519d379/src/crypto/digest.rs#L52) - Nimmt primitiven Datentyp u8 an
* [`sha1_digest`](https://github.com/NLnetLabs/rpki-rs/blob/80ca2f627892f863bb075974ae3fa545e519d379/src/crypto/digest.rs#L199) - Nimmt primitiven Datentyp u8 an