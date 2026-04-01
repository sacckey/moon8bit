# moon8bit (Draft Submission Description)

moon8bit is a retro 2D game engine prototype built in MoonBit with a clear product direction: make game generation workflows practical for AI and humans through text-first assets, deterministic runtime behavior, and a compact API surface.

The core problem is simple. LLMs can generate gameplay code quickly, but assets and debugging loops often slow iteration. moon8bit focuses on reducing that loop cost in MoonBit: palettes, sprites, and tilemaps are authored in a compact DSL, parsed with line-numbered diagnostics, and converted into runtime data (or JSON for inspection). The contribution of moon8bit is a reproducible MoonBit workflow that integrates text-first assets, deterministic runtime behavior, and line-numbered diagnostics for fast AI-assisted iteration.

Concrete scope for this submission:

- Engineering goal: deliver a compact MoonBit retro 2D engine that keeps AI-assisted iteration practical and reproducible.
- Target users: solo developers and small teams building pixel-style prototypes with AI assistance, plus learners who want an inspectable MoonBit game-engine codebase.
- Architecture idea: a layered flow of `assets DSL -> parser/validation -> runtime state transition -> renderer -> web demo`, with CLI and tests sharing the same core package.
- Feasibility: the repository already includes a playable driftbird web demo, CLI commands, parser diagnostics, deterministic runtime tests, and reproducible local run steps.

Current implementation includes five integrated parts:

1. Engine core with explicit `init/update/draw` phases and fixed-step runtime.
2. DSL v1 (`palette`, `sprite`, `tilemap`, `end`) with strict validation and clear parser errors.
3. CLI flow for demo execution and DSL conversion (`demo`, `sample-dsl`, `assets`).
4. Web Canvas demo with live DSL editing plus local `Import DSL` / `Export DSL`.
5. A driftbird side-scroller sample covering input, scrolling, collision, and rendering.

This design maps directly to the SCC evaluation axes:

- Functional Completeness: the repository ships a playable web demo, CLI tooling, and a full parse -> runtime pipeline.
- Engineering Quality: deterministic fixed-step execution, reusable collision primitives (`Rect` + `Collider`), and tests for parser errors, deterministic replay, collision behavior, and integration paths.
- Explainability: small module boundaries (types/parser/runtime/render/sample), explicit decision logs, and reproducible commands in README.
- User Experience: immediate edit/apply loop in browser, visible status feedback (`hit=<tag>`), and import/export to preserve local iteration results.

MoonBit is a strong fit for this direction because of portability and clean data modeling. The implementation stays intentionally compact so evaluators can inspect behavior quickly and reproduce results with minimal setup.

moon8bit is not positioned as a full-featured engine yet; it is a focused, submission-ready exploration of an AI-friendly retro game surface. The first post-submission engineering milestone is API ergonomics: add thin wrapper APIs (`init`, `btn`, `step`, `run`, `cls`, `pset`, `rect`, `spr`) while preserving existing APIs for backward compatibility. This will let us prove simpler authoring style without destabilizing the current demo and tests.

The next steps after that are richer DSL features (animation/tileset references), broader runtime backends, and stronger automation around AI-generated content validation.
