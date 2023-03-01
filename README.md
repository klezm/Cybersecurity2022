# Cybersecurity Course 2022/2023

This repository contains the code for the Cybersecurity Course 2022/2023.

## Repo

```
├ .zsh_history            | Shell history
├ Corpus.zip              | Corpus provided by the course
├── .devcontainer         | Devcontainer configuration
│   ├── java              |   for Java
│   ├── rust              |   for Rust
│   └── scripts           | Scripts used by the devcontainer
├── .github               |
│   └── workflows         | CI configuration for GitHub Actions
├── .vscode               | Settings & Scripts (Tasks) for VSCode
├── corpus                | The corpus will be created using "scripts/make-corpus.sh"
├── docs                  | Logs, Reports, etc.
├── krill                 | Fuzz target
│   ├── fuzz              | 
│       └── fuzz_targets  | Fuzz tests are located here
├── krill-diff            | Changes to the original krill repository
├── Lab1                  | Solution for Lab 1
├── rpki-rs               | Fuzz target
│   ├── fuzz              | 
│       ├── fuzz_targets  | Fuzz tests are located here
├── rpki-rs-diff          | Changes to the original rpki-rs repository
├── rpki-validator-3      | Fuzz target
├── rpki-validator-3-diff | Changes to the original rpki-validator-3 repository
└── scripts               | Helper scripts
```

## Development

### Devcontainer

Two devcontainers are provided for fuzzing either [Rust](.devcontainer/rust/devcontainer.json) or [Java](.devcontainer/java/devcontainer.json) code.
When using the devcontainer, all dependencies are installed, the submodules are pulled and the changes to the submodules are copied automatically.
This is the preferred method.

### VSCode

The [settings](.vscode/settings.json) need to be adjusted for rust-analyzer to work with other submodules then `rpki-rs`. Therefore the path to the submodule you want to work with needs to be added in `rust-analyzer.linkedProjects` removed from `rust-analyzer.files.excludeDirs`.

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

