# Miner account generation

Steps for generating and setting up the miner account.

## Account creation
```
CKB> account new
Your new account is locked with a password. Please give a password. Do not forget this password.
Password: 123
Repeat password: 123
address:
mainnet: ckb1qyq8fzg04mvezah4an4rflmk693ypmnlvlssxu4k5k
testnet: ckt1qyq8fzg04mvezah4an4rflmk693ypmnlvlssmetfc2
lock_arg: 0x74890faed99176f5ecea34ff76d16240ee7f67e1
lock_hash: 0xd4f9fc2fc0243513309478157f667b09d87d08bf98828423ec19537f944858ee
```

## Private key export
```
CKB> account export --extended-privkey-path miner_pk --lock-arg 0x74890faed99176f5ecea34ff76d16240ee7f67e1
Password: 123
message: "Success exported account as extended privkey to: \"miner_pk\", please use this file carefully"
```

## Private key contents
```
ckb@cli:~$ cat ./miner_pk
efa06f4acb3157bc5e60deaae37037c94fb094f9eb8027df439c3737d09c0d7b
2fae77da4f63502d5d51f1a8addafc0447c79f5814df53e0976808551d84e770
```

## Setting up the miner

Under the section of `block_assembler` in [ckb.toml](../config/ckb.toml) file,
use `lock_arg` to provide miner reward address.

```
[block_assembler]
code_hash = "0x9bd7e06f3ecf4be0f2fcd2188b23f1b9fcc88e5d4b65a8637b17723bbda3cce8"
args = "0x74890faed99176f5ecea34ff76d16240ee7f67e1" <-- put lock_arg here
hash_type = "type"
message = "0x"
```
