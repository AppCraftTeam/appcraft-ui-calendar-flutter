---
name: publish
description: Create a new patch release — update CHANGELOG.md and commit
disable-model-invocation: true
---

Create a new patch release:

1. Read `CHANGELOG.md` and determine the latest version.
2. Increment the **patch** segment: `x.y.z` -> `x.y.(z+1)`.
3. Read `git diff` and `git log` since the last release to understand what changed.
4. Add a new `## <new_version>` section at the top of the changelog (below the header comment) following the existing style:
   - Imperative mood, present tense, in Russian.
   - Each meaningful change as a separate bullet point.
   - No implementation details — only user-facing changes.
5. Commit with message: `<summary> (<new_version>)`
   - Stage all changed files.
