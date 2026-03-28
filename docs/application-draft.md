# moon8bit (Draft Submission Description)

moon8bit is a retro 2D game engine prototype built in MoonBit with a clear product direction: make game generation workflows practical for AI and humans without relying on heavy binary asset pipelines.

The core problem is simple. LLMs can generate gameplay code quickly, but visual assets often become the bottleneck. Typical PNG-centered workflows require external tools, binary diffing, and manual integration steps that are hard to iterate in short AI loops. moon8bit addresses this by making assets text-native first. In v1, palettes, sprites, and tilemaps are authored in a compact DSL, parsed with line-numbered diagnostics, and converted into runtime data (or JSON for inspection).

Current implementation includes five integrated parts:

1. Engine core with explicit `init/update/draw` phases and fixed-step runtime.
2. DSL v1 (`palette`, `sprite`, `tilemap`, `end`) with strict validation and clear parser errors.
3. CLI flow for demo execution and DSL conversion (`demo`, `sample-dsl`, `assets`).
4. Web Canvas demo with live DSL editing plus local `Import DSL` / `Export DSL`.
5. A bird-like side-scroller sample covering input, scrolling, collision, and rendering.

This design maps directly to the SCC evaluation axes:

- Functional Completeness: the repository ships a playable web demo, CLI tooling, and a full parse -> runtime pipeline.
- Engineering Quality: deterministic fixed-step execution, reusable collision primitives (`Rect` + `Collider`), and tests for parser errors, deterministic replay, collision behavior, and integration paths.
- Explainability: small module boundaries (types/parser/runtime/render/sample), explicit decision logs, and reproducible commands in README.
- User Experience: immediate edit/apply loop in browser, visible status feedback (`hit=<tag>`), and import/export to preserve local iteration results.

MoonBit is a strong fit for this direction because of portability and clean data modeling. The implementation stays intentionally compact so evaluators can inspect behavior quickly and reproduce results with minimal setup.

moon8bit is not positioned as a full-featured engine yet; it is a focused, submission-ready exploration of an AI-friendly retro game surface. The next steps after submission are richer DSL features (animation/tileset references), broader runtime backends, and stronger automation around AI-generated content validation.
