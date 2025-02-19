# RiP Curl：低延迟，面向事务的RPC

## 面临的问题

创建Panoptis的初始RPC实现是为了让用户确认最近刚发送到集群的交易。 在设计时就考虑到了它的内存使用情况，因此任何验证节点都应该能够支持API，而不必担心DoS攻击。

后来，使用相同的API来支持Panoptis浏览器变得很必要。 原始设计仅支持几分钟的历史记录，因此我们将其更改为改为将事务状态存储在本地RocksDB实例中，并提供长达几天的历史记录。 然后，我们通过BigTable将其扩展到六个月。

每次修改都让API变得更适合于提供静态内容的应用程序，并且对交易处理的吸引力降低了。 客户轮询交易状态而不是被通知，会给人一种错误的印象，即确认时间更长。 此外，客户可以轮询的内容是有限的，这会阻止他们做出合理的实时决策，例如，一旦特定的、受信任的验证者对其进行投票，便确认了交易。

## 拟定的解决方案

基于验证者的ReplayStage，构建一个网络友好、面向事务的流式API。

改善客户体验：

* 直接从WebAssembly应用程序支持连接。
* 可以实时向客户通知确认进度，包括投票和投票者质押权重。
* 当占比最重的分叉发生变化，如果它会影响交易确认计数，则会通知客户。

对验证节点的支持更加简单：

* 每个验证节点支持一定数量的并发连接，否则没有明显的资源限制。
* 交易状态永远不会存储在内存中，因此无法进行轮询。
* 签名仅存储在内存中，直到所需的承诺级别或直到区块哈希过期为止（以较晚的日期为准）。

工作原理：

1. 客户端使用可靠的通信通道（例如Web socket）连接到验证节点。
2. 验证节点使用ReplayStage注册签名。
3. 验证程序将交易发送到Gulf Stream，并重试所有已知的派生，直到区块哈希过期(直到仅在最长的分叉上接受交易为止)。 如果区块哈希过期，则签名未注册，通知客户端，并关闭连接。
4. 当ReplayStage检测到影响交易状态的事件时，它将实时通知客户端。
5. 确认交易已植根后 (`CommitmentLevel::Max`)，签名则未注册，服务器关闭上游通道。
