---
name: pull-request-develop
description: Fix warnings, bump version, update changelog, create PR to develop
---

Create a pull request from the current branch into `develop`.

## Steps

### 1. Ensure feature branch

- If the current branch is NOT a `feature/` branch (e.g., you are on `develop` or `main`), create a new `feature/` branch.
  - Suggest a branch name based on the recent changes, or ask the user for a name.
  - Create the branch from the current HEAD (`git checkout -b feature/<name>`).

### 2. Check for warnings

- Run `flutter analyze` on the project.
- Fix **all** issues in the project (including `info`-level). If unsure how to fix a specific issue, ask the user.
- If any fixes were made, stage and commit them.

### 3. Ask about version

- Read the current version from `pubspec.yaml`.
- Ask the user which version to set, offering options:
  - **No change** — keep the current version as-is.
  - Increment **patch** (`x.y.z` → `x.y.(z+1)`)
  - Increment **minor** (`x.y.z` → `x.(y+1).0`)
  - Increment **major** (`x.y.z` → `(x+1).0.0`)
  - Or enter a custom version.
- If the user chose **no change**, skip steps 4 and 5 — go directly to step 6.

### 4. Update version

- Update the `version` field in `pubspec.yaml` to the chosen version.

### 5. Update CHANGELOG.md

- Read `git log develop...HEAD` to understand all changes on this branch.
- Read `CHANGELOG.md` to understand the existing format.
- Add a new `## <new_version>` section at the top (below the header), following the existing style:
  - Imperative mood, present tense, in Russian.
  - Each meaningful change as a separate bullet point.
  - No implementation details — only user-facing changes.

### 6. Commit (if version changed)

- Stage `pubspec.yaml` and `CHANGELOG.md`.
- Commit with message: `<краткое описание> (<new_version>)`.

### 7. Create pull request

- Push the branch to remote with `-u` flag.
- Create a PR into `develop` using `gh pr create`:
  - Title: short summary (under 70 characters).
  - Body: summary of changes + test plan, in the standard format.
