# Cybersecurity Course 2022/2023

Currently, four implementations of Relying Parties are actively maintained,
[Routinator](#routinator-rust-nlnetlabs),
[OctoRPKI](#octorpki-go-cloudflare),
[Fort](#fort-c),
and [RPKI-client](#rpki-client-c).
Furthermore, we also want to look at an open source implementation of an RPKI publication point, named [Krill](#krill-nlnetlabs).

## Relying Parties (RPs)

### Routinator (Rust) (nlnetlabs)

|          |                                                   |
| -------- | ------------------------------------------------- |
| Git      | https://github.com/NLnetLabs/routinator           |
| Homepage | https://www.nlnetlabs.nl/projects/rpki/routinator |
| Docs     | https://routinator.docs.nlnetlabs.nl              |

### OctoRPKI (Go) (Cloudflare)

|          |                                      |
| -------- | ------------------------------------ |
| Git      | https://github.com/cloudflare/cfrpki |
| Homepage | https://rpki.cloudflare.com          |

### Fort (C) 

|      |                                         |
| ---- | --------------------------------------- |
| Git  | https://github.com/NICMx/FORT-validator |
| Docs | https://nicmx.github.io/FORT-validator  |


### RPKI-client (C)

|          |                                                     |
| -------- | --------------------------------------------------- |
| Git      | https://github.com/rpki-client/rpki-client-portable |
| Homepage | https://rpki-client.org                             |

### Krill (nlnetlabs)

|          |                                                   |
| -------- | ------------------------------------------------- |
| Git      | https://github.com/NLnetLabs/krill                |
| Homepage | https://www.nlnetlabs.nl/projects/rpki/krill      |
| Docs     | https://krill.docs.nlnetlabs.nl/en/stable/        |

### More (not actively maintained)

#### RTRLib (C, Python Binding)

|      |                                                     |
| ---- | --------------------------------------------------- |
| Git  | https://github.com/rtrlib/rtrlib                    |
| Docs | https://rtrlib.readthedocs.io/en/latest/python.html |

## Fuzzer

### Cargo Fuzz (Rust)

|      |                                             |
| ---- | ------------------------------------------- |
| Git  | https://github.com/rust-fuzz/cargo-fuzz     |
| Docs | https://rust-fuzz.github.io/book/cargo-fuzz |

- Also supports afl https://rust-fuzz.github.io/book/afl/setup.html

### Go-Fuzz

### libFuzz (C)

### AFL++

- https://github.com/AFLplusplus/cargo-libafl

## Glossary

|      |                                    |     |
| ---- | ---------------------------------- | --- |
| RPKI | Resource Public Key Infrastructure | The RPKI is a Public Key Infrastructure to attest the ownership of IP prefixes and autonomous system numbers, also known as Internet resources. The attestation objects are stored in distributed repositories. |
| BGP  | Border Gateway Protocol            | Any BGP speaker can announce any IP prefix. A BGP peer cannot verify the correctness of the data. If a bogus update was successful, traffic is incorrectly redirected, which might lead to interception or dropping. |
| PP   | Publication Point                  | Repositories are called Publication Point. |
| RP   | Relying Party                      | Relying Party is software necessary to fetch and validate ROAs, which happens periodically. |
| RRDP |                                    | repository access protocol to synchronize ROA caches |
| PoC  | Proof of Concept                   |
| DoS  | Denial of Service                  |
| ROC  | Remote Code Execution              |
| RTR  | RPKI-To-Router                     | protocol to provide cryptographically validated RPKI prefix data to BGP routers. |
| RIR  |
| AS   | Autonomous System                  |
| ROA  | Route Origin Authorization         | Part of the RPKI are ROA objects that implement the binding between AS number and IP prefix(es). Thus a BGP router can verify the origin of an IP prefix included within an BGP update. |
|      | Caches & The RPKI/RTR Protocol     | To reduce load at BGP routers, RPKI objects are fetched and cryptographically validated by cache servers. The RPKI/RTR protocol defines a standard mechanism to maintain the exchange of valid RPKI data between cache server and router, which is implemented by the RTRlib. |
| TAL  | Trust Anchor Location              |
| CA   | Certificate Authority              |

### A Short Introduction to RPKI

1. Distributed Database of resources that complement **BGP** table decision-making process.
2. Repositories are called Publication Point (**PP**).
3. Most important file is Route Origin Authorization (**ROA**). A cryptographically signed mapping of prefixes to ASesthat own them.
4. Publication Points contain and serve x509/PKIX resource certificates, certificate revocation lists (**CRL**) and signed objects.
5. Publication Points serve at least one Certificate Authority (**CA**) which is responsible for issuing certificates, CRLs and signed objects.
6. A Certificate Authority corresponds to a ROA issuing entity.
7. A ROA issuing entity can either create their own certificate authority (delegated RPKI) or let the original resource provider (RIR, ISP etc.) issue ROAs via their own Publication Points. (hosted RPKI)

### Repetition: Relying Parties

- Recursively iterate all publication points starting at the PPs of the 5 RIRs to download objects
- Parse and validate objects that are downloaded – e.g. check signatures, check that repository content equals Manifest content, check ROAs align with resources assigned in the Certificate Authority (CA) certificate
- After all validation is over, pass a compiled file of all valid AS – Prefix pairs to an RTR server
- Go back to step one after a predefined time-interval

### Why is the RPKI so vulnerable to attacks?

- All Relying Parties must request all Publication Points -> A single PP can potentially attack all Relying Parties
- RPKI is relatively new (2013) and software is not mature
- DOS attacks on Relying Parties disable RPKI validation in all routers, making it a very effective attack vector
- RPKI is complex, with 10s of RFCs and using multiple technologies, offering a great attack surface


## Labs

### Lab 2

- [x] Task 1: Setting up the Tools
  - [x] Dev environment
  - [x] Fuzzer
  - [x] `git clone` RP client
- [ ] Task 2: Know your Enemy
  - [ ] Go through the source code and find an interesting function to start your fuzzing. A good first function is identified by **multiple characteristics**...
    - [ ] The function takes a basic datatype as input, like bytes or a string value
    - [ ] The input of the function is attacker-controlled, i.e. stems from external input
    - [ ] The function conducts some critical task, like memory access
    - [ ] The function parses objects

<!--
  | Code | Local | GitHub |
  --- | --- | ---
  `fn handle_validity_query(head: bool, origins: &SharedHistory, query: Option<&str> ) -> Response {` | [src/http/validity.rs#L53](routinator/src/http/validity.rs#L53) | [GitHub](https://github.com/NLnetLabs/routinator/blob/main/src/http/validity.rs#L53)
  `fn parse_etag(etag: &[u8]) -> Option<Bytes> {` | [src/collector/rrdp.rs#L1628](routinator/src/collector/rrdp.rs#L1628) | [GitHub](https://github.com/NLnetLabs/routinator/blob/main/src/collector/rrdp.rs#L1628)
  `fn extend_from_parsed(&mut self, json: SlurmFile, path: Option<Arc<Path>>, keep_comments: bool, ) {` | [src/slurm.rs#L92](routinator/src/slurm.rs#L92) | [GitHub](https://github.com/NLnetLabs/routinator/blob/main/src/slurm.rs#L92)
  `pub fn parse_http_date(date: &str) -> Option<DateTime<Utc>> {` | [src/utils/date.rs#L84](routinator/src/utils/date.rs#L84) | [GitHub](https://github.com/NLnetLabs/routinator/blob/main/src/utils/date.rs#L84)
  `fn parse(source: &mut R) -> Result<Self, ParseError>;` | [src/utils/binio.rs#L22](routinator/src/utils/binio.rs#L22) | [GitHub](https://github.com/NLnetLabs/routinator/blob/main/src/utils/binio.rs#L22)
  `fn parse(content: &str, path: &Path) -> Result<Self, Failed> {` | [src/config.rs#L1990](routinator/src/config.rs#L1990) | [GitHub](https://github.com/NLnetLabs/routinator/blob/main/src/config.rs#L1990)
-->

  <table>
    <tr>
      <th>Code</th>
      <th>Local</th>
      <th>GitHub</th>
    </tr>
<tr><td>

```rs
fn handle_validity_query(
    head: bool,
    origins: &SharedHistory,
    query: Option<&str>
) -> Response {
```

</td><td>

[src/http/validity.rs#L53](routinator/src/http/validity.rs#L53)

</td><td>

[GitHub](https://github.com/NLnetLabs/routinator/blob/main/src/http/validity.rs#L53)

</td></tr>
<tr><td>

```rs
fn parse_etag(
    etag: &[u8]
) -> Option<Bytes> {
```

</td><td>

[src/collector/rrdp.rs#L1628](routinator/src/collector/rrdp.rs#L1628)

</td><td>

[GitHub](https://github.com/NLnetLabs/routinator/blob/main/src/collector/rrdp.rs#L1628)

</td></tr>
<tr><td>

```rs
fn extend_from_parsed(
    &mut self,
    json: SlurmFile,
    path: Option<Arc<Path>>,
    keep_comments: bool,
) {
```

</td><td>

[src/slurm.rs#L92](routinator/src/slurm.rs#L92)

</td><td>

[GitHub](https://github.com/NLnetLabs/routinator/blob/main/src/slurm.rs#L92)

</td></tr>
<tr><td>

```rs
pub fn parse_http_date(
    date: &str
) -> Option<DateTime<Utc>> {
```

</td><td>

[src/utils/date.rs#L84](routinator/src/utils/date.rs#L84)

</td><td>

[GitHub](https://github.com/NLnetLabs/routinator/blob/main/src/utils/date.rs#L84)

</td></tr>
<tr><td>

```rs
fn parse(
    source: &mut R
) -> Result<Self, ParseError>;
```

</td><td>

[src/utils/binio.rs#L22](routinator/src/utils/binio.rs#L22)

</td><td>

[GitHub](https://github.com/NLnetLabs/routinator/blob/main/src/utils/binio.rs#L22)

</td></tr>
<tr><td>

```rs
fn parse(
    content: &str,
    path: &Path
) -> Result<Self, Failed> {
```

</td><td>

[src/config.rs#L1990](routinator/src/config.rs#L1990)

</td><td>

[GitHub](https://github.com/NLnetLabs/routinator/blob/main/src/config.rs#L1990)

</td></tr>
</table>

- [ ] Task 3 Building a Testing-Harness
  - [x] **Find the exact specification** how a testing harness is created for the fuzzer you want to use. This is usually part of the basic documentation and should e.g. be available on the GitHub page of the respective fuzzer.
  - [ ] **Create a testing harness** that takes data from the fuzzer as input and calls the function that you chose as your first target.
- [ ] Task 4 Creating a Corpus
  - [ ] Find out how the creation of a corpus works for the fuzzer you want to use
  - [ ] **Create a corpus of at least three different valid inputs** to the function that you want to fuzz. These might e.g. be valid URLs or valid RPKI objects. Put the samples in the appropriate folder where they can be handed over to the fuzzer.
- [ ] Task 5 Running the Fuzzer
  - [ ] **Run the fuzzer** with the harness and corpus you created. Let the fuzzer run for a while until you find a crash.
- [ ] Task 6 Confirming the Bug
  - [ ] **Create either a main function** in a new project or a **test-case** that calls the suspicious function in the library you investigate. Take your test harness as a template. Compile and execute your code. If the input indeed crashes the library, the bug is confirmed.
- [ ] Task 7 Collecting Evidence
  - [ ] Open the function that you want to investigate in an IDE and try to understand its exact workings, i.e. the control-flow that leads up to the crash.
    - [ ] Look at the stack-trace
    - [ ] A helpful tool to understand the data- and control-flow during code-audits are debuggers.
- [ ] Task 8 The Art of Exploitation
  - [ ] Creating the Proof of Concept (PoC) exploit consists of two separate tasks
    - [ ] Availability is of essential importance for RPs and PPs. Create a PoC for your found vulnerability that can crash the client implementation.
    - [ ] Think about how this bug can further be exploited to cause bigger harm than DOS. E.g. the bug might allow the attacker to create/read files from disc, corrupt memory or allow manipulation of objects from other publication points. Create a PoC that goes further than a simple DOS.
