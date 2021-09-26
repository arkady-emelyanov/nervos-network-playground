# Nervos Network playground

Simple docker-compose based setup for running local development Nervos Network blockchain.

## Miner account

For simplicity, miner account has been pre-generated.
Private key (`miner_pk`) and steps for account generation is stored in [keys](./blockchain/keys).
Under the `cli` service, this key is mounted to the `/home/ckb/keys` directory.
The password for `miner_pk` private key is `123`.
The address for `miner_pk` is `ckt1qyq8fzg04mvezah4an4rflmk693ypmnlvlssmetfc2`.


## Starting up blockchain

```
$ docker compose build
$ docker compose up -d
```

Miner will generate new block every 5 seconds. 

## JSON-RPC API

Endpoints:
* REST: `http://127.0.0.1:28114`
* WebSocket: `ws://127.0.0.1:38114`
* TCP: `127.0.0.1:48114`

### Sample REST API call

Request:
```
echo '{"id": 42, "jsonrpc": "2.0", "method": "sync_state", "params": []}' \
| curl -s -H 'content-type: application/json' -d @- http://localhost:28114 | jq
```

Response:
```
{
  "jsonrpc": "2.0",
  "result": {
    "best_known_block_number": "0x531251",
    "best_known_block_timestamp": "0x17c1edec480",
    "fast_time": "0xd4",
    "ibd": true,
    "inflight_blocks_count": "0xfe",
    "low_time": "0x486",
    "normal_time": "0x383",
    "orphan_blocks_count": "0x13d"
  },
  "id": 42
}
```

## Setting up transaction watcher

```
$ telnet localhost 48114
Trying ::1...
Connected to localhost.
Escape character is '^]'.
```

Put subscribe command to telnet:
```
{"id": 2, "jsonrpc": "2.0", "method": "subscribe", "params": ["new_transaction"]}
```

Subscription confirmation:
```
{"jsonrpc":"2.0","result":"0x0","id":2}
```

## Moving CKB from miner account to new account

Open shell to cli service and run ckb-cli interactive shell
```
$ docker compose exec -- cli bash
ckb@cli:~$ ckb-cli

  _   _   ______   _____   __      __   ____     _____
 | \ | | |  ____| |  __ \  \ \    / /  / __ \   / ____|
 |  \| | | |__    | |__) |  \ \  / /  | |  | | | (___
 | . ` | |  __|   |  _  /    \ \/ /   | |  | |  \___ \
 | |\  | | |____  | | \ \     \  /    | |__| |  ____) |
 |_| \_| |______| |_|  \_\     \/      \____/  |_____/

[  ckb-cli version ]: 0.100.0 (3d23e8b 2021-09-15)
[              url ]: http://node:28114/ (network: Dev)
[              pwd ]: /home/ckb
[            color ]: true
[            debug ]: false
[          no-sync ]: false
[    output format ]: yaml
[ completion style ]: List
[       edit style ]: Emacs
[   index db state ]: Waiting for first query
CKB>
```

Query miner's address and import miner's private key:
```
CKB> wallet get-capacity --address 'ckt1qyq8fzg04mvezah4an4rflmk693ypmnlvlssmetfc2'
total: 4019.76845121 (CKB)

CKB> account import --privkey-path keys/miner_pk
Password: 123
address:
  mainnet: ckb1qyq8fzg04mvezah4an4rflmk693ypmnlvlssxu4k5k
  testnet: ckt1qyq8fzg04mvezah4an4rflmk693ypmnlvlssmetfc2
lock_arg: 0x74890faed99176f5ecea34ff76d16240ee7f67e1
```

Create target account:
```
CKB> account new
Your new account is locked with a password. Please give a password. Do not forget this password.
Password: 123
Repeat password: 123
address:
  mainnet: ckb1qyqglncup9ezk37nz9qmqylwyp7s3v50eruq404lxv
  testnet: ckt1qyqglncup9ezk37nz9qmqylwyp7s3v50eruqg2tq2s
lock_arg: 0x8fcf1c09722b47d31141b013ee207d08b28fc8f8
lock_hash: 0x2466d17e8042ad9987e9fa4aef83a1231c3a4234f7bcc6db5015c04476418a0a
```

Query target account balance:
```
CKB> wallet get-capacity --address 'ckt1qyqglncup9ezk37nz9qmqylwyp7s3v50eruqg2tq2s'
total: 0.0 (CKB)
```

Account has been created locally, no need to import private key.
Perform CKB transfer from miner's account to the freshly created one: 
```
CKB> wallet transfer --from-account 'ckt1qyq8fzg04mvezah4an4rflmk693ypmnlvlssmetfc2' --to-address 'ckt1qyqglncup9ezk37nz9qmqylwyp7s3v50eruqg2tq2s' --capacity 10000 --tx-fee 0.00001
Password:
0xa76b3da6911e1a3deb219a76161f43acc286ca8ef75879658c8f8d4b59a5df7d
```

Wait at least one block to be committed (~5-7 seconds) and query target account balance:
```
CKB> wallet get-capacity --address 'ckt1qyqglncup9ezk37nz9qmqylwyp7s3v50eruqg2tq2s'
total: 10000.0 (CKB)
```

Switch to terminal with telnet running, transaction has been pushed by node service:
(please note, output has been formatted and truncated):
```
{
  "jsonrpc": "2.0",
  "method": "subscribe",
  "params": {
    "result": "{\"transaction\":{\"version\":\"0x0\",...}",
    "subscription": "0x0"
  }
}
```
