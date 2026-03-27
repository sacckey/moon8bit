# moon8bit (Draft Submission Description)

moon8bit is a retro 2D game engine prototype built in MoonBit with one clear design target: AI-first game generation workflows.

When people ask an LLM to generate a small game, they usually hit a friction point very quickly: visual assets. Code generation is easy, but image generation and integration often introduce heavy tools, binary pipelines, and non-deterministic steps. My project focuses on a pragmatic alternative: a text-native asset workflow where sprites and tilemaps are described in a compact DSL and converted into runtime data.

This prototype currently ships with four parts. First, an engine core with fixed-step update and explicit init/update/draw stages through a Game trait. Second, a text DSL v1 for palette, sprite, and tilemap definitions. Third, an asset conversion path from DSL to JSON so generated assets are inspectable and reproducible. Fourth, a bird-like side-scroller sample that demonstrates input handling, scrolling obstacles, collision checks, and frame rendering.

The project aligns with MoonBit's strengths. MoonBit has strong portability goals and Web/Wasm relevance, and the language model encourages clear data definitions and deterministic logic. That makes it suitable for AI-collaborative development, where generated output should remain readable and testable.

From an engineering perspective, I prioritized deterministic behavior and strong error reporting over raw feature count. The DSL parser reports line-numbered errors, which is important for iterative AI correction loops. The runtime loop is fixed-step, which keeps behavior stable across tests and simplifies regression detection. The current test suite validates successful parsing, malformed input handling, deterministic replay, and integration-level execution.

For explainability, the repository keeps the architecture intentionally compact: asset types, parser, renderer, runtime, and sample game are separated but small enough to review quickly. The CLI commands expose the system in a direct way (`demo`, `sample-dsl`, `assets`), making evaluator reproduction straightforward.

In short, moon8bit is not trying to be a full-featured engine yet. It is a focused submission that explores an AI-friendly game development surface: text assets, deterministic execution, and portable MoonBit implementation. The next steps are browser-facing rendering, richer DSL features (animation and tileset references), and stronger tooling around automated AI generation loops.
