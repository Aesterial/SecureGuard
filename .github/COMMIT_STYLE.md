# Commit Style

This repository mostly follows a lightweight Conventional Commits style.

## Recommended format

```text
<type>(<scope>): <summary>
```

Examples:

```text
feat(server): add stats persistence worker
fix(client): handle expired session on password copy
refactor(api): simplify proto package layout
docs(readme): update local setup instructions
ci(github): tighten Rust static analysis workflow
```

## Types used in repository history

Prefer these commit types:

- `feat`: new functionality
- `fix`: bug fix
- `refactor`: internal code change without behavior change
- `docs`: documentation-only changes
- `test`: tests added or updated
- `ci`: GitHub Actions or other automation changes
- `chore`: maintenance that does not fit the categories above

## Scopes that fit this monorepo

Use a scope when the change is clearly limited to one area:

- `client`
- `server`
- `api`
- `proto`
- `web`
- `github`
- `readme`
- `deps`

If a change spans multiple areas, prefer one of these options:

1. Split it into separate commits by area.
2. Omit the scope if the change is truly cross-cutting.

Avoid mixed subjects like:

```text
feat(server): tests, fix(server): stats, repos, registration bug
```

That kind of message makes history harder to scan and classify.

## Subject line rules

- Use lowercase type and scope.
- Keep the summary short and specific.
- Write the summary in imperative style.
- Do not add a trailing period.
- Prefer staying within about 72 characters for the first line.

Good:

```text
fix(server): reject invalid session prefix
feat(client): add startup toggle
docs(readme): document port mismatch and override env
```

Avoid:

```text
Fixed a bug
feat(client & backend): connected to backend, fix screenshot guard, and etc
added settings
```

## Practical guidance

- One commit should represent one coherent change.
- If you changed protobuf contracts, generated code, and server wiring for the same feature, keep them in one commit.
- If you made unrelated fixes in different areas, split them.
- Merge commits are acceptable when required by workflow, but feature work should use descriptive commit subjects.
