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
- Decision: Introduce engine-level `Collider` API and route driftbird collision checks through it.
- Why: Remove game-specific ad-hoc collision logic and provide reusable overlap primitives.
- Impact: Future games can share one collision detection path while keeping collision response in game code.

- Date: 2026-03-28
- Decision: Adopt `driftbird` as the sample game naming for public-facing docs/demo text.
- Why: Avoid direct similarity to existing IP phrasing while keeping the gameplay concept clear.
- Impact: Documentation and demo messaging are aligned with safer, original naming.

- Date: 2026-03-28
- Decision: Record collision hit tags (`ground`, `ceiling`, `pipe_*`) in game state.
- Why: Keep collision outcomes explainable and allow game-side branching based on collision type.
- Impact: Integration tests can verify both game-over and collision cause, improving debugging and reproducibility.

- Date: 2026-03-28
- Decision: Surface `last_hit_tag` in web status UI and add a pipe-hit runtime test.
- Why: Make collision outcomes visible during demo play and prevent regressions in tag wiring.
- Impact: Better UX explainability and stronger confidence in collision behavior changes.

- Date: 2026-03-28
- Decision: Rework submission draft to explicitly map SCC evaluation axes and add evaluator quickstart to README.
- Why: Reduce reviewer friction and make value proposition/scoring alignment obvious.
- Impact: Stronger explainability and faster project evaluation during screening.

- Date: 2026-03-28
- Decision: Add dedicated submission checklist/demo script and switch handoff to concrete session data.
- Why: Minimize last-week execution risk and make Monday restart frictionless.
- Impact: Clear pre-submit gate and stable handoff workflow.

- Date: 2026-03-28
- Decision: Use root-based GitHub Pages with `demo/` as the published web demo path.
- Why: `docs/` is reserved for project documents, so demo assets should be isolated without changing docs usage.
- Impact: Added root `index.html`, `demo/index.html`, and bundle sync script for Pages-ready deployment.

- Date: 2026-03-28
- Decision: Switch driftbird control flow to press-to-start/restart with edge-triggered jump input and pass-through scoring.
- Why: Prevent hold-to-fly behavior, improve game feel, and match retro loop expectations.
- Impact: Added `is_started` state, one-press jump semantics, pipe pass scoring, and new tests for start/restart/score behavior.
