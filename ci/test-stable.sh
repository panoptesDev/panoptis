#!/usr/bin/env bash
set -e
cd "$(dirname "$0")/.."

cargo="$(readlink -f "./cargo")"

source ci/_

annotate() {
  ${BUILDKITE:-false} && {
    buildkite-agent annotate "$@"
  }
}

# Run the appropriate test based on entrypoint
testName=$(basename "$0" .sh)

source ci/rust-version.sh stable

export RUST_BACKTRACE=1
export RUSTFLAGS="-D warnings"
source scripts/ulimit-n.sh

# Limit compiler jobs to reduce memory usage
# on machines with 2gb/thread of memory
NPROC=$(nproc)
NPROC=$((NPROC>14 ? 14 : NPROC))

echo "Executing $testName"
case $testName in
test-stable)
  _ "$cargo" stable test --jobs "$NPROC" --all --exclude solana-local-cluster ${V:+--verbose} -- --nocapture
  ;;
test-stable-bpf)
  # Clear the C dependency files, if dependency moves these files are not regenerated
  test -d target/debug/bpf && find target/debug/bpf -name '*.d' -delete
  test -d target/release/bpf && find target/release/bpf -name '*.d' -delete

  # rustfilt required for dumping BPF assembly listings
  "$cargo" install rustfilt

  # panoptis-keygen required when building C programs
  _ "$cargo" build --manifest-path=keygen/Cargo.toml
  export PATH="$PWD/target/debug":$PATH
  cargo_build_bpf="$(realpath ./cargo-build-bpf)"

  # BPF panoptis-sdk legacy compile test
  "$cargo_build_bpf" --manifest-path sdk/Cargo.toml

  # BPF Program unit tests
  "$cargo" stable test --manifest-path programs/bpf/Cargo.toml
  "$cargo_build_bpf" --manifest-path programs/bpf/Cargo.toml --bpf-sdk sdk/bpf

  # BPF program system tests
  _ make -C programs/bpf/c tests
  _ "$cargo" stable test \
    --manifest-path programs/bpf/Cargo.toml \
    --no-default-features --features=bpf_c,bpf_rust -- --nocapture

  # Dump BPF program assembly listings
  for bpf_test in programs/bpf/rust/*; do
    if pushd "$bpf_test"; then
      "$cargo_build_bpf" --dump
      popd
    fi
  done

  # BPF program instruction count assertion
  bpf_target_path=programs/bpf/target
  _ "$cargo" stable test \
    --manifest-path programs/bpf/Cargo.toml \
    --no-default-features --features=bpf_c,bpf_rust assert_instruction_count \
    -- --nocapture &> "${bpf_target_path}"/deploy/instuction_counts.txt

  bpf_dump_archive="bpf-dumps.tar.bz2"
  rm -f "$bpf_dump_archive"
  tar cjvf "$bpf_dump_archive" "${bpf_target_path}"/{deploy/*.txt,bpfel-unknown-unknown/release/*.so}
  ;;
test-stable-perf)
  if [[ $(uname) = Linux ]]; then
    # Enable persistence mode to keep the CUDA kernel driver loaded, avoiding a
    # lengthy and unexpected delay the first time CUDA is involved when the driver
    # is not yet loaded.
    sudo --non-interactive ./net/scripts/enable-nvidia-persistence-mode.sh || true

    rm -rf target/perf-libs
    ./fetch-perf-libs.sh

    # Force CUDA for panoptis-core unit tests
    export TEST_PERF_LIBS_CUDA=1

    # Force CUDA in ci/localnet-sanity.sh
    export PANOPTIS_CUDA=1
  fi

  _ "$cargo" stable build --bins ${V:+--verbose}
  _ "$cargo" stable test --package panoptis-perf --package panoptis-ledger --package panoptis-core --lib ${V:+--verbose} -- --nocapture
  _ "$cargo" stable run --manifest-path poh-bench/Cargo.toml ${V:+--verbose} -- --hashes-per-tick 10
  ;;
test-local-cluster)
  _ "$cargo" stable build --release --bins ${V:+--verbose}
  _ "$cargo" stable test --release --package solana-local-cluster ${V:+--verbose} -- --nocapture --test-threads=1
  exit 0
  ;;
*)
  echo "Error: Unknown test: $testName"
  ;;
esac

(
  export CARGO_TOOLCHAIN=+"$rust_stable"
  echo --- ci/localnet-sanity.sh
  ci/localnet-sanity.sh -x

  echo --- ci/run-sanity.sh
  ci/run-sanity.sh -x
)
