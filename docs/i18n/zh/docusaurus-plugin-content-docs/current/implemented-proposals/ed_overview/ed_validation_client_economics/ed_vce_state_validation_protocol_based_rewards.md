---
title: 通货膨胀规划
---

**规则有可能发生变化。 请在Panoptis论坛上关注最近的经济讨论：https://forums.Panoptis.com。**

验证节点客户端在Panoptis网络中具有两种功能作用。

- 验证节点对他们观察到的PoH的当前全球状态进行\(投票\)。
- 验证节点在利益加权的循环计划中被选为 "领导者"，在此期间，他们负责收集未完成的交易，并将其纳入其观察到的PoH中，从而更新网络的全球状态，并提供区块链的连续性。

验证节点客户端对这些服务的奖励将在每个Panoptis纪元结束时分配。 如前所述，验证节点-客户的报酬是通过基于协议的年度通货膨胀率收取的佣金来提供的，该佣金按照每个验证节点节点的质押权重比例分配(见下文)，同时还包括每次领导者轮换期间可用的领导者主张的交易费用。 举例说明 即在给定的验证节点-客户端被选为领导者期间，它有机会保留每笔交易费的一部分，减去协议规定的被销毁的金额 (见[验证节点-客户端状态交易费](ed_vce_state_validation_transaction_fees.md))。

验证节点客户端收到的协议级别有效质押收益率/(%/)，每一个纪元将是以下因素的函数：

- 验证节点当前的全局通货膨胀率，由预先确定的去通货膨胀发行计划表推导出来的(见[验证客户端经济学](ed_vce_overview.md))。
- 验证节点当前总循环供应量中，质押的PANO占比。
- 验证节点服务收取的佣金。
- 验证节点在上一个纪元中，给定验证节点的在线/参与\[的投票 %\]。

第一个因素仅是协议参数的函数\(即独立于验证节点在给定纪元中的行为\)，其结果是设计了一个膨胀时间表，以激励早期参与，提供明确的货币稳定性，并在网络中提供最佳的安全性。

作为理解*通胀计划*对Panoptis经济的第一个影响，我们模拟了在当前研究的通胀时间表参数范围内，代币发行随时间推移可能出现的上下限范围。

具体而言：

- *初始通货膨胀率*: 7-9%
- *通货膨胀率降低比例*: -14-16%
- *长期通货膨胀率*: 1-2%

使用这些范围来模拟一些可能的通货膨胀表，我们可以探索一段时间内的通货膨胀：

![](/img/p_inflation_schedule_ranges_w_comments.png)

在上图中，确定了范围的平均值，以说明每个参数的贡献。 从这些模拟的*通货膨胀表*中，我们还可以推算出一段时间内代币发行的范围。

![](/img/p_total_supply_ranges.png)

最后，如果我们引入一个额外的参数，也就是之前讨论过的*质押PANO百分比*，我们就可以估算出质押PANO的*质押收益*。


%~\text{PANO Staked} = \frac{\text{Total PANO Staked}}{\text{Total Current Supply}} CONTEXT


在这种情况下，由于*质押PANO百分比*是一个必须估计的参数(不同于*通胀表*参数)，所以使用具体的*通胀表*参数，探索*质押PANO百分比*的范围比较容易。 在下面的例子，我们选择了上面探讨的参数范围的中间值：

- *初始通货膨胀率*: 8%
- *通货膨胀率降低比例*: -15%
- *长期通货膨胀率*: 1.5%

根据投资者和验证节点社区的反馈，以及在类似权益证明协议中观察到的情况，*质押PANO百分比*的范围在60%-90%之间，我们认为这涵盖了我们预期观察到的可能范围。

![](/img/p_ex_staked_yields.png)

同样，上面显示的是Panoptis网络的一个例子，在指定的*通货膨胀时间表*下，一个质押者可能会期望随着时间的推移而获得的*质押收益*。 这是一个理想化的*质押收益*，因为它忽略了验证节点正常运行时间对奖励的影响，验证节点佣金，潜在的收益率节流和潜在的罚没事件。 此外，它还忽略了*质押PANO百分比*是动态设计的——它的经济激励由*通货膨胀表*设置。

### 调整后的质押收益

质押代币潜力盈利的完整评估应考虑到质押*代币稀释*及其对质押收益率的影响。 为此，我们将*调整后的质押收益*定义为：由于通货膨胀发行量的分布而导致的质押代币在流通量占比的变化。 即 通货膨胀的正向稀释效应。

我们可以将*调整后的质押收益*作为通货膨胀率和网络上的质押代币百分比的函数来考察。 我们可以在这里看到各种质押占比的情况。

![](/img/p_ex_staked_dilution.png)
