# Session Brief

## Session

- Date: 2026-03-28
- Timebox: 2-3 hours
- Branch: `main`

## Today Focus (max 2)

1. Add `Export DSL` and `Import DSL` to the web editor workflow.
2. Update docs and verify the full build/test flow.

## Done Definition

- Web demo supports `Edit -> Apply -> Export`.
- Web demo supports `Import -> Textarea update -> Apply`.
- README includes operation steps for export/import.
- `moon check`, `moon test`, and `moon build --target js cmd/web` pass.

## Explicitly Out of Scope Today

- WebGPU backend.
- Engine-level collision API refactor.
- External LLM API integration.

## Constraints / Assumptions

- Keep local-first workflow (`localhost`) and browser-based persistence via file import/export.
- Preserve existing Canvas runtime behavior and controls.

## Verification Plan

- `moon check`
- `moon test`
- `moon build --target js cmd/web`
