# Cybersecurity Course 2022/2023

Currently, four implementations of Relying Parties are actively maintained,
[Routinator](#routinator-rust-nlnetlabs),
[OctoRPKI](#octorpki-go-cloudflare),
[Fort](#fort-c),
and [RPKI-client](#rpki-client-c).
Furthermore, we also want to look at an open source implementation of an RPKI publication point, named [Krill](#krill-nlnetlabs).

## Protocol

Requirements

- Software to fuzz: [RIPE-NCC/rpki-validator-3](https://github.com/RIPE-NCC/rpki-validator-3)
- Fuzzing Software: [Jazzer](https://github.com/CodeIntelligenceTesting/jazzer)
  - can be run using [cifuzzer](https://github.com/CodeIntelligenceTesting/cifuzz/wiki)
  - offers [autofuzz](https://www.code-intelligence.com/blog/autofuzz)
  - https://docs.code-intelligence.com/cli-quick-start-java
  - https://codeintelligencetesting.github.io/jazzer-docs/jazzer-api/com/code_intelligence/jazzer/api/FuzzedDataProvider.html

A more or less complete history of all commands run in the terminal can be found in [.zsh_history](.zsh_history)

Initialize `jazzer` using `cifuzz` either in the the `rpki-validator` main repo or in the rpki-validator subdirectory

```sh
cifuzz -v -C $CODESPACE_VSCODE_FOLDER/rpki-validator-3/rpki-validator init
```

As suggested from the stdout of the `cifuzz init` command: Add dependencies to the maven config file in the main repo [pom.xml](rpki-validator-3/pom.xml) or in the rpki-validator subdirectory [pom.xlm](rpki-validator-3/rpki-validator/pom.xml)

Now create and write a test e.g.: [FuzzRrdp.java](rpki-validator-3/rpki-validator/src/test/java/net/ripe/rpki/validator3/rrdp/FuzzRrdp.java), [FuzzTest.java](rpki-validator-3/rpki-validator/src/test/java/net/ripe/rpki/validator3/rrdp/FuzzTest.java)

For some reason copying the `FuzzTest.java` from rpki-validator-3-diff does cause an error.
Therefore, we skip it.

```sh
cifuzz -v -C $CODESPACE_VSCODE_FOLDER/rpki-validator-3/rpki-validator/src/test/java/net/ripe/rpki/validator3/rrdp/ create -o FuzzRrdp.java
```

Run the Fuzzer with e.g.

```sh
cifuzz -v -C $CODESPACE_VSCODE_FOLDER/rpki-validator-3/rpki-validator run FuzzRrdp --use-sandbox=false
```

So far the Fuzzer always threw errors as shown here: [stdout.html](stdout.html) (VSCode offers a HTML preview mode with the addon [Live Preview](https://marketplace.visualstudio.com/items?itemName=ms-vscode.live-server))

## Development

### Submodules (Fuzzing Targets)

The repositories we want to fuzz are included as submodules.
To clone this repository with all submodules, use the following command:

```sh
git clone --depth 1 --recurse-submodules --shallow-submodules <REPO URL>
```

Since we ran `git config -f .gitmodules submodule.<REPO>.shallow true` for all submodules you can omit the `--shallow-submodules` flag.
If you cloned the repository without the `--recurse-submodules` flag, you can initialize and update the submodules with the following commands:

```sh
# https://git-scm.com/book/en/v2/Git-Tools-Submodules
git submodule update --init # --recursive
```

To Update all submodules to the latest commit on their respective default branch, use the following command:

```sh
git submodule update --remote --merge
```

### Devcontainer

Two devcontainers are provided for fuzzing either Rust or Java code.

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

<table>
  <tr>
    <th>Code</th>
    <th>Local</th>
    <th>GitHub</th>
  </tr>
<tr><td>

```java
public Notification notification(
  final InputStream inputStream
) {
```

</td><td>

[rrdp/RrdpParser.java#L215](rpki-validator-3/rpki-validator/src/main/java/net/ripe/rpki/validator3/rrdp/RrdpParser.java#L215)

</td><td>

[GitHub](https://github.com/RIPE-NCC/rpki-validator-3/blob/41f6fd719793ba2ded8b0dedd318d51b83ac9583/rpki-validator/src/main/java/net/ripe/rpki/validator3/rrdp/RrdpParser.java#L215)

</td></tr>

</table>

More resources

- [Krill test resources](krill/test-resources/)

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


## Glossary

|      |                                    |     |
| ---- | ---------------------------------- | --- |
| RPKI | Resource Public Key Infrastructure | The RPKI is a Public Key Infrastructure to attest the ownership of IP prefixes and autonomous system numbers, also known as Internet resources. The attestation objects are stored in distributed repositories. |
| BGP  | Border Gateway Protocol            | Any BGP speaker can announce any IP prefix. A BGP peer cannot verify the correctness of the data. If a bogus update was successful, traffic is incorrectly redirected, which might lead to interception or dropping. |
| PP   | Publication Point                  | Repositories are called Publication Point. |
| RP   | Relying Party                      | Relying Party is software necessary to fetch and validate ROAs, which happens periodically. |
| RRDP |                                    | repository access protocol to synchronize ROA caches  |
| PoC  | Proof of Concept                   |  |
| DoS  | Denial of Service                  |  |
| ROC  | Remote Code Execution              |  |
| RTR  | RPKI-To-Router                     | protocol to provide cryptographically validated RPKI prefix data to BGP routers. |
| RIR  |                                    |  |
| AS   | Autonomous System                  |  |
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

## List of Relying Parties, Publication Points and Fuzzers

### Relying Parties (RPs) & Publication Points (PPs)

#### Routinator (Rust) (nlnetlabs)

|          |                                                   |
| -------- | ------------------------------------------------- |
| Git      | https://github.com/NLnetLabs/routinator           |
| Homepage | https://www.nlnetlabs.nl/projects/rpki/routinator |
| Docs     | https://routinator.docs.nlnetlabs.nl              |

#### OctoRPKI (Go) (Cloudflare)

|          |                                      |
| -------- | ------------------------------------ |
| Git      | https://github.com/cloudflare/cfrpki |
| Homepage | https://rpki.cloudflare.com          |

#### Fort (C) 

|      |                                         |
| ---- | --------------------------------------- |
| Git  | https://github.com/NICMx/FORT-validator |
| Docs | https://nicmx.github.io/FORT-validator  |


#### RPKI-client (C)

|          |                                                     |
| -------- | --------------------------------------------------- |
| Git      | https://github.com/rpki-client/rpki-client-portable |
| Homepage | https://rpki-client.org                             |

#### Krill (nlnetlabs) (Publication Point)

|          |                                              |
| -------- | -------------------------------------------- |
| Git      | https://github.com/NLnetLabs/krill           |
| Homepage | https://www.nlnetlabs.nl/projects/rpki/krill |
| Docs     | https://krill.docs.nlnetlabs.nl/en/stable/   |

#### More (not actively maintained)

##### RIPE Validator (Relying Party)

|     |                                              |
| --- | -------------------------------------------- |
| Git | https://github.com/RIPE-NCC/rpki-validator-3 |

##### RTRLib (C, Python Binding)

|      |                                                     |
| ---- | --------------------------------------------------- |
| Git  | https://github.com/rtrlib/rtrlib                    |
| Docs | https://rtrlib.readthedocs.io/en/latest/python.html |

### Fuzzer

#### Cargo Fuzz (Rust)

|      |                                             |
| ---- | ------------------------------------------- |
| Git  | https://github.com/rust-fuzz/cargo-fuzz     |
| Docs | https://rust-fuzz.github.io/book/cargo-fuzz |

- Also supports afl https://rust-fuzz.github.io/book/afl/setup.html

#### Go-Fuzz

#### libFuzz (C)

#### AFL++

- https://rust-fuzz.github.io/book/afl.html
- https://github.com/AFLplusplus/cargo-libafl
