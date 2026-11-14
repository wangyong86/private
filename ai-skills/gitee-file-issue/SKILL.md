---
name: gitee-file-issue
description: >-
  File a Gitee enterprise issue or 子工作项 under a parent kanban issue, with an
  evidence-backed body and large EXPLAIN/add_path dumps as attachments rather
  than inline text. Use when the user asks to create, file, or hang a Gitee
  (e.gitee.com / ymatrix) issue, child work item, or 子任务.
---

# Gitee File Issue

Create a Gitee **enterprise** work item. This skill is for **filing**, not
replying (`technical-issue-response`) and not reviewing PRs (`gitee-pr-review`).

Do not print tokens, cookies, or Authorization headers. Do not `gpstop` or
change cluster data unless the user explicitly asked for that in the same
request.

## When to use

- “提 / 建 / 挂一个 Gitee issue / 工作项 / 子工作项”
- User gives a parent kanban URL such as
  `https://e.gitee.com/ymatrix/issues/kanban/states?issue=IDENT`
- User wants a structured body (problem / pattern / gap / direction, or another
  explicit outline) plus a large dump attachment

If the user only wants a reply on an existing issue, switch to
`technical-issue-response`.

## Auth and transport

1. Discover tools with `GetDynamicTools` (`gitee` / `gitee_ent` /
   `create_enterprise_issue`). If the namespace is `needsAuth`, call `mcp_auth`.
2. Prefer MCP `create_enterprise_issue` / `get_enterprise_issue_detail` when
   they actually exist in this session.
3. This environment often has **no Gitee MCP namespace**. Then use the
   enterprise REST API that the MCP binary itself uses:

   - Base: `GITEE_ENT_API_BASE` from `~/.codex/config.toml`
     (default `https://api.gitee.com/enterprises`)
   - Enterprise: **13428393** (ymatrix / e.gitee.com)
   - Token: `GITEE_ENT_MCP_ACCESS_TOKEN` in the same `gitee_ent` section.
     Read it in-process; never echo, never write it into the issue, skill, or
     chat.
   - `User-Agent` **must** start like `mcp-gitee-ent 0.2.3 ...`. Other UAs get
     401 “Only For MCP Gitee Enterprise Application” / “登录已失效”.
   - `Authorization: Bearer <token>`

Parse `IDENT` from `?issue=IDENT`. Resolve numeric id with
`GET /{enterprise_id}/issues/{IDENT}?qt=ident`.

## Hang under a parent (IKQQAE-style)

Gitee enterprise **does** support parent-child. Use `parent_id=<parent numeric
id>` on create.

Observed constraint (2026-11, ymatrix):

> 子工作项的任务属性必须与父工作项一致

Copy the parent’s `issue_type_id` / `category` (缺陷/任务/需求). Do not assume
“子工作项 = 任务” if the parent is a 缺陷.

Also copy, unless the user overrides: `assignee_id`, `label_ids`, `priority`.
`program_id` / `project_id` / `kanban_id` are often 0/null on kanban-only
items; omit rather than invent.

Verify both sides after create:

- child `parent_id` and `parent.ident`
- `GET /{enterprise_id}/issues/{parent_id}/children`

If create without `parent_id` is the only thing that works, stop and say so;
do not pretend a `link_issue_id` comment is a 子工作项 unless that is all the
API allowed.

Create with **`application/x-www-form-urlencoded`** (SDK `formData` shape).
JSON create works for title/body/`parent_id`, but **`attachment_ids` only
binds on form create**. `PUT` of `attachment_ids` after the fact does **not**
attach the file (200 with empty `attach_file_ids`).

## Body shape

If the user specifies sections, use **those headings, in that order**. A
common planner/debug-path outline is:

1. **问题** — observed wrong/suboptimal behavior and the chosen-plan facts
2. **模式** — tables, query shape, cardinality, indexes, partitions, cluster
3. **缺口** — compare discarded add_path alternatives vs the chosen path
4. **方向** — bounded planner/executor change; not a dump of the whole redesign

Generalize; do not hardcode B08 / runtime filter. If the user gives a
different outline, follow it. If they give none, use: 结论 → 证据 → 范围 →
建议，and keep fact / inference / proposal labeled
(`technical-issue-response` / `write-evidence-backed-design` wording).

Rules for the body:

- Cite measured plan/cost/catalog numbers and dump line ranges.
- Label **事实 / 推断 / 建议 / 未知**.
- Do not paste a ≥100KB EXPLAIN / `gp_debug_add_path` dump into the body.
  Point at the attachment and the original path.
- Keep the issue scoped. Related redesigns are one-line context, not extra
  work items hidden in the same body.

## Large attachments (EXPLAIN / add_path)

Never inline a 700KB+ dump.

1. Prefer the path the user named. If the file still has psql/control
   characters, strip them to a sibling `*.out` and attach that; say what was
   stripped.
2. **Upload first**, then create the issue with `attachment_ids`:

   `POST /{enterprise_id}/attach_files/upload`  
   multipart: `attach_type=Issue`, `file=<bytes>`  
   → `{id, name, size}`

   Upload alone does **not** hang the file on an issue. Orphan ids are normal
   until create.

3. Create the issue with form field `attachment_ids=<id>[,id...]`.
4. Confirm `GET /{enterprise_id}/issues/{id}/attach_files` shows `name` +
   `size`.
5. If the original is rejected (size/type), `gzip -9` (or xz), attach the
   archive, and write the original path + uncompressed size in the body.
6. A comment with `attachment_ids` does **not** bind the file. Do not leave
   placeholder comments that only say “附件：filename”.

## Evidence

- Chosen-plan nodes, costs, and add_path WARNING lines are facts when quoted
  from a named dump.
- Catalog `reltuples` / index defs / `gp_segment_configuration` are facts
  when queried read-only in the named database.
- “This path would win if RF were costed” is an inference unless a
  measurement shows it.
- Current GUCs (`mx_enable_runtime_filter`, `optimizer`, …) are “now”, not
  automatically the dump-time setting.

Do not implement the proposed code change unless the user also asked for
implementation in the same request.

## Return to the user

- Child ident + kanban URL
  `https://e.gitee.com/ymatrix/issues/kanban/states?issue=IDENT`
- Whether `parent_id` / children list succeeded
- Attachment name + size (and compressed-fallback note)
- The four (or user-specified) sections, or a link if they live only on Gitee
- Commands actually run; auth/API/size limitations

## Worked API sequence (REST fallback)

```text
GET  /{ent}/issues/{PARENT_IDENT}?qt=ident
POST /{ent}/attach_files/upload          # multipart attach_type=Issue + file
POST /{ent}/issues                       # form: title, description, parent_id,
                                         # issue_type_id, attachment_ids, ...
GET  /{ent}/issues/{parent_id}/children
GET  /{ent}/issues/{new_id}/attach_files
```

MCP equivalent when present: `get_enterprise_issue_detail` then
`create_enterprise_issue` with `parent_id` and `attachment_ids`. The
same-type and form-bind constraints apply if the MCP is a thin wrapper.
