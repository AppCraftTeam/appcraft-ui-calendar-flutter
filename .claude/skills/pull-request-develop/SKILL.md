---
name: pull-request-develop
description: Fix warnings, bump version, update changelog, create PR to develop
---

Create a pull request from the current feature branch into `develop`.

## Steps

### 1. Check for warnings

- Run `flutter analyze` on the project.
- Filter results to only files changed on this branch (`git diff develop...HEAD --name-only`).
- If there are **error** or **warning** level issues in changed files, fix them and commit.
- `info`-level hints (cascade_invocations, prefer_const_constructors, etc.) may be ignored.

### 2. Ask about version

- Read the current version from `pubspec.yaml`.
- Ask the user which version to set, offering options:
  - Increment **patch** (`x.y.z` → `x.y.(z+1)`)
  - Increment **minor** (`x.y.z` → `x.(y+1).0`)
  - Increment **major** (`x.y.z` → `(x+1).0.0`)
  - Or enter a custom version.

### 3. Update version

- Update the `version` field in `pubspec.yaml` to the chosen version.

### 4. Update CHANGELOG.md

- Read `git log develop...HEAD` to understand all changes on this branch.
- Read `CHANGELOG.md` to understand the existing format.
- Add a new `## <new_version>` section at the top (below the header), following the existing style:
  - Imperative mood, present tense, in Russian.
  - Each meaningful change as a separate bullet point.
  - No implementation details — only user-facing changes.

### 5. Commit

- Stage `pubspec.yaml` and `CHANGELOG.md`.
- Commit with message: `<краткое описание> (<new_version>)`.

### 6. Create pull request

- Push the branch to remote with `-u` flag.
- Create a PR into `develop` using `gh pr create`:
  - Title: short summary (under 70 characters).
  - Body: summary of changes + test plan, in the standard format.
