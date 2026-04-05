---
name: generate-plan-doc
description: Use this skill when the user wants a structured implementation plan or contributor-facing planning document generated from a repository template such as docs/PLAN_TEMPLATE.md. It is for planning only, not coding or editing.
---

# Generate Plan Doc

Use this skill when a user wants a complete implementation plan, delivery plan, or planning document based on a repository template.

## Workflow
1. Read `docs/PLAN_TEMPLATE.md` first. If the repo does not contain that file, look for the nearest equivalent and say which template you used.
2. Explore the repository before asking questions. Reuse actual file paths, naming, dependencies, and patterns from the codebase.
3. Ask only the minimum questions needed to resolve high-impact product or implementation decisions that cannot be discovered locally.
4. Output the plan in Chinese unless the user explicitly asks for another language.
5. Keep the plan decision-complete. The implementer should not need to make major product or technical decisions.

## Output requirements
- Follow the repository template section order and labels closely.
- Include real repo references when they materially guide implementation.
- State assumptions explicitly when the user did not decide something important.
- Scope the output to planning only. Do not implement code, edit files, or present code patches unless the user separately asks for execution.
- When the user asks where the plan should be saved, default to `docs/<current-branch>/规划-<topic>.md`.

## Guardrails
- Do not paste the template verbatim unless the user asked for it.
- Do not invent libraries or architecture that conflict with the existing repo without saying so.
- Do not switch into execution mode inside the plan.
