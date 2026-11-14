# FastDD 开发索引

- 观察 QE 实际执行计划，不能只依据 QD Explain 判断执行路径。
- 诊断入口为 mx_print_fast_direct_dispatch_plan 及其
  with_analyze、with_verbose、with_costs、with_timing 开关。
- QD 会话中的 SET 不保证相关设置传播到 FastDD QE。
  核验实际生效位置；临时修改数据库级设置时记录并恢复原状态。

## RF 代码入口

- contrib/mxvector/mxvector/MxVRuntimeFilter.cc：计划装饰、创建、下推。
- contrib/mxvector/mxvector/MxVHashJoin.cc：构建与发布。
- contrib/mxvector/mxvector/MxVScan.cc：扫描端消费。
- src/backend/executor/runtimefilter.c：通用 RF 创建与传递。

## 测试入口

查看 contrib/mxvector/Makefile 的 check-runtime-filter-* 目标，
以及 contrib/mxvector/sql/mxvector/ 下对应脚本。先确认当前分支存在这些目标，
并阅读其运行前提；不要将某个测试的容量阈值或取消策略当成长期约束。
