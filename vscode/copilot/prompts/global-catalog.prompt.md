name: global-catalog
summary: Use the global catalog master skill to list, inspect or import shared assets.

Use the `/master-skill` router skill to access the shared library in `${HOME}/AI/global-ai-config/biblioteca/Biblioteca_Global`.

Examples:
- `/master-skill liste as skills`
- `/master-skill liste os agentes`
- `/master-skill liste os workflows`
- `/master-skill traga a skill de <nome>`
- `/master-skill traga o agente de <nome>`
- `/master-skill traga o workflow de <nome>`
- `/master-skill instale o <framework>`
- `/master-skill quais skills devo usar para <tarefa>`

Behavior:
- Only operate after explicit user invocation.
- Prefer metadata and summaries before copying any asset.
- Do not import the entire catalog automatically.
- Copy a selected asset only when requested explicitly.
