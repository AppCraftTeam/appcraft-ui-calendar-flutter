---
name: perform-plan
description: Execute all tasks from a plan in .claude/plans/
---

Execute a plan from `.claude/plans/`. Optional argument: plan filename (without path).

## Steps

### 1. Select a plan

- If an argument is provided, use it as the plan name (e.g., `/perform-plan unit-testing-plan`).
- Otherwise, list all `.md` files in `.claude/plans/` and ask the user which plan to start.
- If no plans exist, inform the user and stop.

### 2. Read the plan and find tasks

- Read the selected plan file.
- Parse the `## Tasks` section: extract file paths (lines matching `- .claude/tasks/...`).
- Check which task files still exist on disk. Existing files = remaining tasks. Missing files = already completed.
- If no remaining tasks, go to step 6.

### 3. Create or switch to branch

- Derive branch name: `feature/<plan-filename-without-extension>` (e.g., `feature/unit-testing-plan`).
- If the branch already exists locally, switch to it (`git checkout <branch>`).
- If it does not exist, create it from the current HEAD (`git checkout -b <branch>`).

### 4. Execute all tasks

Execute **all** remaining tasks sequentially, in order. Do NOT ask the user which tasks to execute — just run them all.

For each task:

1. Read the task file to understand what needs to be done.
2. Execute the task according to its description.
3. After completing the task, stage and commit changes with a descriptive message.
4. Delete the task file and amend the commit to include the deletion.

### 5. Check remaining tasks

- After all tasks are done, re-check remaining tasks in the plan.
- If tasks remain (e.g., due to errors), inform the user how many are left and stop.

### 6. Finish

- Ask the user whether to delete the plan file. If yes, delete it and commit.
- Then ask the user whether to run `/pull-request-develop`. If the user agrees, execute the `pull-request-develop` skill.
