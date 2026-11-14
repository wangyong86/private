# 构建与测试

以下路径均相对仓库根目录；构建目录、安装目录和连接参数取自当前任务。

## 构建

- mxvector 实现编入 matrixts.so；contrib/mxvector 下的 mxvector.so
  是兼容占位库。对象列表见 contrib/matrixts/scripts/mxvector.mk。
- 沿用当前构建配置及工具链。切换编译器或关键编译选项后，
  重建受影响对象，避免混用旧产物。
- 若增量构建没有更新预期对象，检查依赖，必要时显式构建该对象，
  再链接所属库；不要默认全量清理。

## 运行

- 确认构建产物安装到了目标实例实际使用的位置。
- 更新 shared_preload_libraries 中的库，需要重启对应实例才能生效；
  仅重新连接不能替换已预加载的代码。
- MPP 测试要确认实际执行代码的 QD/QE 均使用预期产物。

## 测试

- 使用仓库的 Makefile 和 schedule 选择测试入口，不直接套用
  单机 PostgreSQL 的 make check。
- mxvector 测试由 contrib/matrixts/scripts/mxvector.mk 组织。
  RF 回归入口：
  make -C contrib/matrixts installcheck-mxvector-runtime-filter
- 验证优化时同时检查结果和实际执行路径；路径未触发不算覆盖。
- 性能对照保持代码、配置和数据条件可追溯。单次运行标为诊断结果，
  超时不作为已完成耗时；避免编译、其他重查询和调试器干扰测量。
