# Phase Guide

只在组织阶段输出、任务拆分或 checkpoint 时读取。以下模板应按当前 feature 裁剪，不作为固定问卷。

## 启动或恢复

先建立：

~~~text
任务与当前阶段：
最新 Scope / Framework / Interface：
相关用户结论：
已否决方向：
已验证源码事实：
当前开放问题：
仓库或运行状态：
~~~

阶段开场：

~~~text
本阶段的收敛目标是：<target>。
根据你此前的输入，我已经记录：<decisions and exclusions>。
仍会影响本阶段结果的是：<material decisions>。
接下来核实：<source facts>。
~~~

## 范围

输出：

1. 问题和目标行为；
2. 适用的 feature 维度及其影响；
3. in-scope / out-of-scope；
4. 本轮完成层次与长期目标；
5. 验收证据；
6. 少量真正影响方向的待确认项。

结束提示：

~~~text
Scope vN 已收敛为：<summary>。
本轮采用的用户输入：<decisions>。
明确延期：<items>。
请确认范围；确认后进入框架阶段，明确职责、状态流和异常路径。
~~~

## 框架

输出：

1. 组件或职责图；
2. 决策位置与权威状态；
3. 适用的生命周期流程；
4. 正常路径和关键异常路径；
5. 复用边界；
6. 新抽象及其必要性；
7. 适用的并发、恢复、分布式或兼容约束。

对新抽象只问四件事：现有机制为何不足；差异属于 metadata、存储、控制流还是语义；更薄的 provider、adapter、alias 或函数是否足够；后续能力是否真的复用它。

结束提示：

~~~text
Framework vN 已收敛：<components and flow>。
权威状态来源：<authority or not applicable>。
复用边界：<boundary>。
需要确认的框架决定：<decisions>。
确认后进入接口阶段。
~~~

## 接口

必要时使用：

| Contract | Responsibility | Caller | Ownership/lifetime | Error/state rules |
|---|---|---|---|---|

公共接口改动使用：

| Option | Call-site impact | State expressiveness | Compatibility | Ongoing complexity |
|---|---:|---|---|---|

对每个新类型回答：它持有什么状态或不变量；为何现有类型、函数、alias 或组合不足；公开接口是否与职责相称；是否重复 metadata。

结束提示：

~~~text
Interface vN 已收敛：<contracts>。
公共接口或持久化影响：<impact or none>。
新增类型的必要性：<justification>。
请确认接口；确认后按依赖和垂直行为拆分任务。
~~~

## 任务拆分

| Work item | Depends on | Completed behavior | Excludes | Evidence | Risk |
|---|---|---|---|---|---|

实施前回显：

~~~text
首条路径：<slice>。
它验证：<framework decisions>。
暂不覆盖：<deferred behavior>。
可直接复用：<contracts>。
可能触发重审：<risks>。
~~~

若用户已授权实现且关键契约已确认，回显后直接实施，不重复请求普通编码权限。

## 实现更新

~~~text
已贯通：<call path or behavior>。
与 Interface vN 的偏差：<none or deviation>。
剩余缺口：<items>。
下一步验证：<uncertainty and evidence>。
~~~

共享核心改动或新抽象应先给技术比较；如果改变已确认契约，回退确认。

快速 diff 检查：

- 每行修改能追溯到当前 feature；
- 无无关格式或代码移动；
- 无重复校验、metadata 或既有算法副本；
- 新参数承载真实状态；
- 原有注释和不变量没有在抽取中丢失。

## 验证与 review

| Requirement | Evidence | Result | Limitation |
|---|---|---|---|

review 结果分为：

~~~text
必须修复：
本 feature 内应完成：
已接受限制：
缺少证据：
无关发现：
~~~

结束提示：

~~~text
已验证：<facts>。
仅源码推断：<facts>。
未验证：<facts and reason>。
阻塞交付：<items or none>。
下一步完成交付、提交准备或 checkpoint。
~~~

## 交付或 checkpoint

交付：

~~~text
已交付行为：
关键设计决定：
实际验证：
延期或不支持：
残余风险：
仓库状态：
~~~

Checkpoint：

~~~text
Worktree / branch / base / HEAD：
Tracked / untracked：
Scope / Framework / Interface：
已完成：
当前阶段和目标：
关键代码入口：
命令与真实结果：
后台 PID / 命令 / 日志 / 阶段：
剩余任务及依赖：
约束与已否决方向：
新 session 首条提示词：
~~~

新 session 必须先读取适用的仓库说明，并用 git 状态、HEAD、文件、进程和日志核对 checkpoint。
