---
name: documentation-expert
description: Technical documentation expert. Guides automatic generation from code, establishes architectural guidelines, and provides robust templates (README, API, JSDoc, ADR, llms.txt) for maximum clarity, scannability, and AI readability.
allowed-tools: Read, Glob, Grep
---

# Technical & Automated Documentation Expert

This skill combines automatic documentation generation guidelines with standardized, high-quality structures and templates for both human developers and AI agents.

---

## 🎯 Use this skill when

- Designing, writing, or standardizing project documentation (README, API Reference, Architecture Decision Records).
- Automatically extracting docstrings/JSDoc/TSDoc or compiling code-level metadata into external documentation.
- Structuring AI-friendly reference files (like `llms.txt` or MCP-ready schemas) for RAG or LLM-native environments.

## 🚫 Do not use this skill when

- Writing generic copy or non-technical articles.
- You have no codebase, configuration files, or clear system source of truth.

---

## 🛠️ Automated Documentation Flow

When tasked with generating technical documentation from code, follow this structured process:

1. **Extract Context:** Scan code, configs, dependencies, and comments using glob/grep.
2. **Identify Audience:** Tailor terminology and depth depending on the target reader (e.g., end-user vs. API integrator).
3. **Draft Consistently:** Apply the standardized templates below to ensure visual and conceptual harmony.
4. **Ensure Living Alignment:** Build procedures or guidelines to ensure docs stay synchronized with codebase modifications.
5. **Security Check:** Ensure no secrets, internal domain hosts, or sensitive credentials are ever printed in documentation files.

---

## 📋 Standardized Documentation Templates

### 1. README Structure (Priority Order)

```markdown
# Project Name

Brief one-liner describing the objective and value of the project.

## Quick Start

[Minimal commands to build, install, and run in less than 5 minutes]

## Features

- Feature 1: Detailed impact
- Feature 2: Detailed impact

## Configuration

| Variable | Description | Default | Required |
|----------|-------------|---------|:---:|
| PORT | Server execution port | 3000 | No |

## Documentation

- [API Reference](./docs/api.md)
- [Architecture Details](./docs/architecture.md)

## License

MIT
```

---

### 2. API Reference (Per-Endpoint Structure)

```markdown
## GET /users/:id

Fetches a user profile by their unique identifier.

**Path Parameters:**
| Name | Type | Required | Description |
|------|------|:---:|-------------|
| id | string | Yes | The user's system ID |

**Response Codes:**
- `200 OK`: Returns the matched User JSON object.
- `404 Not Found`: Triggered when the ID does not exist.

**Example Request/Response:**
```json
// GET /users/usr_123
{
  "id": "usr_123",
  "name": "Jane Doe",
  "role": "admin"
}
```
```

---

### 3. Code Comment Standards (JSDoc/TSDoc)

Ensure clear function signatures. Focus comments on **why** (business rules) rather than **what** (self-explanatory code).

```typescript
/**
 * Processes database synchronization records.
 * 
 * @param records - Array of dirty context sync models
 * @returns Promise resolving to the number of synchronized rows
 * @throws DatabaseConnectionError - When Neon connection drops
 * 
 * @example
 * const syncCount = await syncRecords(dirtyList);
 */
```

---

### 4. Architecture Decision Record (ADR)

Use this format to log significant architectural choices and trade-offs.

```markdown
# ADR-00X: [Short Descriptive Title]

## Status
Proposed / Accepted / Deprecated / Superseded by [ADR-00Y]

## Context
What is the problem? Why is this decision required now? What assumptions or constraints are we facing?

## Decision
What is the chosen approach? What components or databases are affected?

## Consequences
What are the benefits of this choice? What are the trade-offs, risks, or technical debt incurred?
```

---

### 5. AI-Friendly Documentation (`llms.txt`)

For AI assistants and RAG systems, place a raw `llms.txt` in the repository root:

```markdown
# Project Name
> High-level system purpose.

## Core Files & Entrypoints
- [src/index.ts]: Primary execution entrypoint
- [src/api/]: Endpoint controllers and routers
- [docs/]: Deep technical specifications

## Ecosystem Concepts
- Concept A: Business rule details
- Concept B: Data flow expectations
```

---

## 📐 Structural Design Principles

| Principle | Action |
|:---|:---|
| **Scannable Layout** | Always use tables, markdown lists, and short sentences to simplify parsing. |
| **Progressive Disclosure** | Introduce high-level goals first, then deep-dive into complex architectures. |
| **Examples First** | Provide request/response payloads, snippets, and commands instead of abstract text. |
| **Lint & Validate** | Ensure markdown syntax is valid and all file paths are accurate. |
