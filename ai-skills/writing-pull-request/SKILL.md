---
name: writing-pull-request
description: Use when opening or rewriting a pull request so reviewers can judge a commit batch, including an 80-column commit message check and a Chinese explanation of the phenomenon, cause, approach, changes, decisions, and effect.
---

# Writing Pull Request

写给 reviewer 的 PR 说明。目的是让人按节评审、按节提意见。说明用中文。

已有的 `yeet` 只负责用 `gh` 暂存、提交、推送并在 GitHub 上开 PR。本 skill 不替代它，也不负责创建远程。

## When to use

- 新建或改写 PR 说明
- 一批提交需要按现象、原因、思路、改动、决定、效果分开说明
- 提交说明可能超过 80 列

不用于：

- 只改代码、不改 PR 说明
- 子系统设计笔记（用 technique-brief）
- 用户没有要求时去改写已经推送的历史

## Commit message

先检查这批每个 commit 的标题和正文。每一行都不超过 80 列，按字符数计，含标题。

```bash
git log --reverse --format='%H%x1f%s%x1f%b%x1e' <base>..HEAD
```

某一行超过 80 列时，先改那条说明，再写 PR 正文。已经推送的提交只有用户明确要求 amend 或 force-push 时才改历史。没有超过的提交保持原样。

## 正文

六节只写这一批，标题用下面这六个词。不要给每个 commit 再重复这六节。

1. 现象：测试、计划或运行里能看到什么。
2. 原因：这个现象从哪条机制来。写机制，不写排查经过。
3. 整体思路：这一批准备怎么收，以及为什么这样拆。
4. 具体改动：改了哪条路径。文件名只用来定位。
5. 关键决定：reviewer 可能不同意的选择，以及没有采用的做法。
6. 效果：已经观测到的结果。没有测过的耗时不要写成数字。

正式提交各补一段，从旧到新。一段里写清这一提交负责什么、故意不做什么。补充修改集中成一段，不单独展开成章节，也不写进标题。后一个提交退回前一个提交的行为时，在补充段里写明。

## 约束

- 标题反映正式提交的内容。补充修改不进入标题。
- 已有的测量放进「效果」，并写清数据属于哪一组。
- 仓库模板里的合并检查项留在正文末尾。
- 说明和代码冲突时，以当前 diff 为准。
