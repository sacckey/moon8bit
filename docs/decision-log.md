# Decision Log

Use one short entry per decision to prevent direction drift.

## Format

- Date:
- Decision:
- Why:
- Impact:

---

- Date: 2026-03-27
- Decision: Use text-first DSL (`palette/sprite/tilemap`) as asset source for v1.
- Why: AI and humans can iterate via small textual diffs with lower token cost than binary images.
- Impact: Parser/CLI and docs become core deliverables.

- Date: 2026-03-27
- Decision: Prioritize Web Canvas runtime before WebGPU.
- Why: Faster to make a playable and reviewable demo before deadline.
- Impact: Rendering backend remains simple; WebGPU can be an optional later path.

- Date: 2026-03-28
- Decision: Adopt local-first workflow (`localhost`) with browser live-apply loop.
- Why: Lowest operational overhead and fastest iteration for solo development.
- Impact: Persistence features (`Export/Import`) are planned as next UX step.

