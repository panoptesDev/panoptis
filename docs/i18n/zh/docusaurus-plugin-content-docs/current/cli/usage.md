---
title: CLI 使用参考
---

[solana-cli crate](https://crates.io/crates/solana-cli) 为 Panoptis 提供了一个命令行界面工具

## 示例：

### 获取公钥

```bash
// 命令
$panoptis-keygen pubkey

// 返回
<PUBKEY>
```

### 空投 PANO/Lamports

```bash
// 命令
$ panoptis airdrop 2

// 返回
"2.0000000 PANO"
```

### 获取余额

```bash
// 命令
$ panoptis balance

// 返回
"3.00050001 PANO"
```

### 确认交易

```bash
// 命令
$ panoptis confirm <TX_SIGNATURE>

// 返回
"Confirmed" / "Not found" / "Transaction failed with error <ERR>"
```

### 部署程序

```bash
// 命令
$ panoptis deploy <PATH>

// 返回
<PROGRAM_ID>
```

## 使用方法
###
```text

```
