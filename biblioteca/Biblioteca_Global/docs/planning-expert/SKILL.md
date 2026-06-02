---
name: planning-expert
description: Master of project planning and execution. Guides context scanning, concise atomic checklists (5-10 tasks), detailed implementation plans (TDD, bite-sized tasks, exact file paths), and step-by-step validation.
allowed-tools: Read, Glob, Grep
---

# Project Planning & Execution Expert

This skill governs the entire lifecycle of task planning and execution. It consolidates both light, high-velocity checklists and deep, multi-phase implementation plans using TDD and strict validation steps.

---

## 🎯 Use this skill when

- A user requests a plan or architecture roadmap for a programming task before modifying code.
- Building structured checklists, defining atomic execution tasks, or writing detailed feature specifications.
- Implementing plans step-by-step (executing-plans) with rigorous local testing and frequent commits.

## 🚫 Do not use this skill when

- Answering simple, immediate questions that don't involve code modifications or systematic tasks.
- Executing minor syntax/linter fixes that do not change code logic or structure.

---

## 🏗️ The 3 Planning Levels

### Level 1: High-Velocity Checklist (Concise Planning)
Best for small-to-medium tasks (<4 hours of dev time). Generate a fast, atomic checklist directly in the discussion.

**Checklist Template:**
```markdown
# Implementation Plan

Brief approach summary (1-3 sentences).

## Scope
- **In:** What is changing
- **Out:** What is strictly excluded

## Action Checklist
[ ] Step 1: Scan files `path/to/module` and mock variables
[ ] Step 2: Implement validation utility in `src/utils/`
[ ] Step 3: Write tests inside `tests/utils.test.js`
[ ] Step 4: Validate local execution using `npm test`
[ ] Step 5: Commit changes to Git
```

---

### Level 2: Comprehensive Architecture Plan (Implementation Plan)
Best for large features, refactoring, or multi-agent environments. Save the plan to `docs/plans/YYYY-MM-DD-<feature-name>.md` or inside the conversation workspace.

**Deep Plan Template:**
```markdown
# [Feature Name] Implementation Plan

**Goal:** [Clear 1-sentence statement of what this builds/changes]
**Architecture:** [Approach details, design patterns, and dependency maps]
**Tech Stack:** [Databases, libraries, and frameworks involved]

---

### Task 1: [Module or Component Name]
**Files:**
- Create: `exact/path/to/new_file.py`
- Modify: `exact/path/to/existing_file.py:12-45`
- Test: `tests/exact/path/to/test.py`

**Steps to Execute:**
1. **Write failing test:** Define `test_specific_behavior()` in the test file.
2. **Verify fail:** Run `pytest tests/path/test.py` -> Expected: FAIL.
3. **Minimal implementation:** Write the simplest code to satisfy the test.
4. **Verify pass:** Run `pytest tests/path/test.py` -> Expected: PASS.
5. **Commit:** `git add <files>` and `git commit -m "feat: implement specific behavior"`
```

---

### Level 3: Plan Execution & Handoff (Executing Plans)
When executing an approved plan:
- **Never skip validation:** Always write or run unit/integration tests before writing implementation code (TDD) and verify they pass.
- **Granular Commits:** Commit after every atomic step to isolate regressions.
- **Atomic Checklist Tracking:** Mark items as completed `[x]` or in progress `[/]` inside `task.md` or the corresponding tracking file.

---

## 📐 Core Planning Guidelines

| Guideline | Why & How |
|:---|:---|
| **Context First** | Scan `README.md`, dependencies, and active files via glob/grep before proposing changes. |
| **Verb-First Steps** | Tasks must start with action verbs: `"Add..."`, `"Refactor..."`, `"Delete..."`, `"Verify..."`. |
| **Exact Paths** | Always specify exact file paths and line ranges. Avoid vague targets like `"update user code"`. |
| **DRY & YAGNI** | Keep plans focused. Do not build speculative features or duplicate existing logic. |
