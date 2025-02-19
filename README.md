<p align="center">
  <a href="https://solana.com">
    <img alt="Panoptis" src="https://raw.githubusercontent.com/Fair-Exchange/safecoinwiki/master/Logos/SafeCoin/SafeCoin-Logo-with-text.png"/>
  </a>
</p>

[![twitter](https://img.shields.io/twitter/follow/safecoins?style=social)](https://twitter.com/safecoins)


# Building

## **1. Install rustc, cargo and rustfmt.**

```bash
$ curl https://sh.rustup.rs -sSf | sh
$ source $HOME/.cargo/env
$ rustup component add rustfmt
```

Please make sure you are always using the latest stable rust version by running:

```bash
$ rustup update
```

On Linux systems you may need to install libssl-dev, pkg-config, zlib1g-dev, etc.  On Ubuntu:

```bash
$ sudo apt-get update
$ sudo apt-get install libssl-dev libudev-dev pkg-config zlib1g-dev llvm clang make
```

## **2. Download the source code.**

```bash
$ git clone https://github.com/panoptisDev/panoptis.git
$ cd panoptis
```

## **3. Build.**

```bash
$ cargo build
```

## **4. Run a minimal local cluster.**
```bash
$ ./run.sh
```

# Testing

**Run the test suite:**

```bash
$ cargo test
```

### Starting a local testnet
Start your own testnet locally, instructions are in the [online docs](https://docs.solana.com/cluster/bench-tps).

### Accessing the remote development cluster
* `devnet` - stable public cluster for development accessible via
devnet.safecoin.org. Runs 24/7. Learn more about the [public clusters](https://docs.solana.com/clusters)

# Benchmarking

First install the nightly build of rustc. `cargo bench` requires use of the
unstable features only available in the nightly build.

```bash
$ rustup install nightly
```

Run the benchmarks:

```bash
$ cargo +nightly bench
```

# Release Process

The release process for this project is described [here](RELEASE.md).

# Code coverage

To generate code coverage statistics:

```bash
$ scripts/coverage.sh
$ open target/cov/lcov-local/index.html
```

Why coverage? While most see coverage as a code quality metric, we see it primarily as a developer
productivity metric. When a developer makes a change to the codebase, presumably it's a *solution* to
some problem.  Our unit-test suite is how we encode the set of *problems* the codebase solves. Running
the test suite should indicate that your change didn't *infringe* on anyone else's solutions. Adding a
test *protects* your solution from future changes. Say you don't understand why a line of code exists,
try deleting it and running the unit-tests. The nearest test failure should tell you what problem
was solved by that code. If no test fails, go ahead and submit a Pull Request that asks, "what
problem is solved by this code?" On the other hand, if a test does fail and you can think of a
better way to solve the same problem, a Pull Request with your solution would most certainly be
welcome! Likewise, if rewriting a test can better communicate what code it's protecting, please
send us that patch!

# Disclaimer

All claims, content, designs, algorithms, estimates, roadmaps,
specifications, and performance measurements described in this project
are done with the Solana Foundation's ("SF") best efforts. It is up to
the reader to check and validate their accuracy and truthfulness.
Furthermore nothing in this project constitutes a solicitation for
investment.

Any content produced by SF or developer resources that SF provides, are
for educational and inspiration purposes only. SF does not encourage,
induce or sanction the deployment, integration or use of any such
applications (including the code comprising the Panoptis blockchain
protocol) in violation of applicable laws or regulations and hereby
prohibits any such deployment, integration or use. This includes use of
any such applications by the reader (a) in violation of export control
or sanctions laws of the United States or any other applicable
jurisdiction, (b) if the reader is located in or ordinarily resident in
a country or territory subject to comprehensive sanctions administered
by the U.S. Office of Foreign Assets Control (OFAC), or (c) if the
reader is or is working on behalf of a Specially Designated National
(SDN) or a person subject to similar blocking or denied party
prohibitions.

The reader should be aware that U.S. export control and sanctions laws
prohibit U.S. persons (and other persons that are subject to such laws)
from transacting with persons in certain countries and territories or
that are on the SDN list. As a project based primarily on open-source
software, it is possible that such sanctioned persons may nevertheless
bypass prohibitions, obtain the code comprising the Panoptis blockchain
protocol (or other project code or applications) and deploy, integrate,
or otherwise use it. Accordingly, there is a risk to individuals that
other persons using the Panoptis blockchain protocol may be sanctioned
persons and that transactions with such persons would be a violation of
U.S. export controls and sanctions law. This risk applies to
individuals, organizations, and other ecosystem participants that
deploy, integrate, or use the Panoptis blockchain protocol code directly
(e.g., as a node operator), and individuals that transact on the Panoptis
blockchain through light clients, third party interfaces, and/or wallet
software.
