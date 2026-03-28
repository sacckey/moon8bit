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

- Date: 2026-03-28
- Decision: Implement browser-level `Export/Import` for DSL persistence before direct file-write integration.
- Why: Reliable cross-environment UX with lower implementation risk for v1 timeline.
- Impact: Users can keep edited assets between sessions without server-side components.

- Date: 2026-03-28
- Decision: Introduce engine-level `Collider` API and route bird-like collision checks through it.
- Why: Remove game-specific ad-hoc collision logic and provide reusable overlap primitives.
- Impact: Future games can share one collision detection path while keeping collision response in game code.

- Date: 2026-03-28
- Decision: Record collision hit tags (`ground`, `ceiling`, `pipe_*`) in game state.
- Why: Keep collision outcomes explainable and allow game-side branching based on collision type.
- Impact: Integration tests can verify both game-over and collision cause, improving debugging and reproducibility.

- Date: 2026-03-28
- Decision: Surface `last_hit_tag` in web status UI and add a pipe-hit runtime test.
- Why: Make collision outcomes visible during demo play and prevent regressions in tag wiring.
- Impact: Better UX explainability and stronger confidence in collision behavior changes.
