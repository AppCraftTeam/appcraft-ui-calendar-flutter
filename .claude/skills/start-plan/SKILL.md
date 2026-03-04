---
name: start-plan
description: Start executing a plan from .claude/plans/
---

Execute a plan from `.claude/plans/`. Optional argument: plan filename (without path).

## Steps

### 1. Select a plan

- If an argument is provided, use it as the plan name (e.g., `/start-plan unit-testing-plan`).
- Otherwise, list all `.md` files in `.claude/plans/` and ask the user which plan to start.
- If no plans exist, inform the user and stop.

### 2. Read the plan and find tasks

- Read the selected plan file.
- Parse the `## Tasks` section: extract file paths (lines matching `- .claude/tasks/...`).
- Check which task files still exist on disk. Existing files = remaining tasks. Missing files = already completed.
- If no remaining tasks, ask the user whether to delete the plan file, then stop.

### 3. Create or switch to branch

- Derive branch name: `feature/<plan-filename-without-extension>` (e.g., `feature/unit-testing-plan`).
- If the branch already exists locally, switch to it (`git checkout <branch>`).
- If it does not exist, create it from the current HEAD (`git checkout -b <branch>`).

### 4. Ask which tasks to execute

- Display the list of remaining tasks (filename + first heading from each task file).
- Ask the user which tasks to execute now.
- The user will respond with a list of tasks (links, numbers, or filenames).

### 5. Execute tasks

For each selected task, in order:

1. Read the task file to understand what needs to be done.
2. Execute the task according to its description.
3. After completing the task, stage and commit changes with a descriptive message.
4. Delete the task file and amend the commit to include the deletion.

### 6. Check remaining tasks

- After all selected tasks are done, re-check remaining tasks in the plan.
- If tasks remain, inform the user how many are left.
- If no tasks remain, ask the user whether to delete the plan file. If yes, delete it and commit.
