---
name: matrixdb-code-development
description: 修改 MatrixDB 源码时使用，遵循项目编码约定并查阅必要的构建、测试说明。
---

## 开发规则

1. 代码遵循周边代码的规范，pg/mars2x/mxvector都有自己的代码规范，后两者有clang-format要求。
2. 写代码的时候严禁自造轮子，要尽量复用，如果一定要抽utils，要有一定的抽象和复用。
3. 变量命名要遵循周边代码风格，并尽量使用良好的命名风格，复用原有代码里常用的，规范的命名。
4. 写完代码要自查。
5. 代码提交要按相应skill提交commit message。

## 按需查阅

- 构建或运行测试：[build-and-test.md](references/build-and-test.md)。
- 涉及 FastDD：[fdd.md](references/fdd.md)。
- 提交代码：[write-commit-message](../write-commit-message/SKILL.md)。

引用与当前仓库不一致时，以实际代码和构建规则为准。
