## Restarting a cluster

### Step 1. Identify the slot that the cluster will be restarted at

The highest optimistically confirmed slot is the best slot to start from, which
can be found by looking for
[this](https://github.com/panoptisdev/panoptis/blob/0264147d42d506fb888f5c4c021a998e231a3e74/core/src/optimistic_confirmation_verifier.rs#L71)
metrics datapoint. Otherwise use the last root.

Call this slot `SLOT_X`

### Step 2. Stop the validator(s)

### Step 3. Optionally install the new panoptis version

### Step 4. Create a new snapshot for slot `SLOT_X` with a hard fork at slot `SLOT_X`

```bash
$ panoptis-ledger-tool -l ledger create-snapshot SLOT_X ledger --hard-fork SLOT_X
```

The ledger directory should now contain the new snapshot.
`panoptis-ledger-tool create-snapshot` will also output the new shred version, and bank hash value,
call this NEW_SHRED_VERSION and NEW_BANK_HASH respectively.

Adjust your validator's arguments:

```bash
 --wait-for-supermajority SLOT_X
 --expected-bank-hash NEW_BANK_HASH
```

Then restart the validator.

Confirm with the log that the validator booted and is now in a holding pattern at `SLOT_X`, waiting for a super majority.

### Step 5. Announce the restart on Discord:

Post something like the following to #announcements (adjusting the text as appropriate):

> Hi @Validators,
>
> We've released v1.1.12 and are ready to get testnet back up again.
>
> Steps:
>
> 1. Install the v1.1.12 release: https://github.com/panoptisdev/panoptis/releases/tag/v1.1.12
> 2. a. Preferred method, start from your local ledger with:
>
> ```bash
> panoptis-validator
>   --wait-for-supermajority SLOT_X     # <-- NEW! IMPORTANT! REMOVE AFTER THIS RESTART
>   --expected-bank-hash NEW_BANK_HASH  # <-- NEW! IMPORTANT! REMOVE AFTER THIS RESTART
>   --hard-fork SLOT_X                  # <-- NEW! IMPORTANT! REMOVE AFTER THIS RESTART
>   --no-snapshot-fetch                 # <-- NEW! IMPORTANT! REMOVE AFTER THIS RESTART
>   --entrypoint entrypoint.testnet.panoptis.org:10015
>   --trusted-validator 5D1fNXzvv5NjV1ysLjirC4WY92RNsVH18vjmcszZd8on
>   --expected-genesis-hash 4uhcVJyU9pJkvQyS88uRDiswHXSCkY3zQawwpjk2NsNY
>   --no-untrusted-rpc
>   --limit-ledger-size
>   ...                                # <-- your other --identity/--vote-account/etc arguments
> ```
>
> b. If your validator doesn't have ledger up to slot SLOT_X or if you have deleted your ledger, have it instead download a snapshot with:
>
> ```bash
> panoptis-validator
>   --wait-for-supermajority SLOT_X     # <-- NEW! IMPORTANT! REMOVE AFTER THIS RESTART
>   --expected-bank-hash NEW_BANK_HASH  # <-- NEW! IMPORTANT! REMOVE AFTER THIS RESTART
>   --entrypoint entrypoint.testnet.panoptis.org:10015
>   --trusted-validator 5D1fNXzvv5NjV1ysLjirC4WY92RNsVH18vjmcszZd8on
>   --expected-genesis-hash 4uhcVJyU9pJkvQyS88uRDiswHXSCkY3zQawwpjk2NsNY
>   --no-untrusted-rpc
>   --limit-ledger-size
>   ...                                # <-- your other --identity/--vote-account/etc arguments
> ```
>
>      You can check for which slots your ledger has with: `panoptis-ledger-tool -l path/to/ledger bounds`
>
> 3. Wait until 80% of the stake comes online
>
> To confirm your restarted validator is correctly waiting for the 80%:
> a. Look for `N% of active stake visible in gossip` log messages
> b. Ask it over RPC what slot it's on: `panoptis --url http://127.0.0.1:8328 slot`. It should return `SLOT_X` until we get to 80% stake
>
> Thanks!

### Step 7. Wait and listen

Monitor the validators as they restart. Answer questions, help folks,
