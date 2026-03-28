# Demo Script (30-45 sec)

## Goal

Show that moon8bit supports fast AI-friendly iteration:
`Edit DSL -> Apply -> Visual change -> Explainable collision tag`.

## Recording Setup

- Open `http://localhost:8000/demo/`
- Keep browser zoom at 100%
- Show canvas, DSL editor, and status line in one frame

## Timeline

1. 0s-8s: Start and movement
   - Press `Space` a few times so the bird is clearly controllable.
   - Briefly show status updates (`score`, `frame`, `hit`).

2. 8s-20s: Live DSL edit + apply
   - In `tilemap ground ...`, change one row value (example: `3` to `4`).
   - Click `Apply DSL`.
   - Show immediate visual change on ground color/pattern.

3. 20s-30s: Import/Export workflow
   - Click `Export DSL` and show file download.
   - Click `Import DSL` and load a local `.dsl` file.
   - Show editor content update and applied scene.

4. 30s-45s: Collision explainability
   - Let the bird collide (or stop flapping).
   - Show `hit=<tag>` in status line (for example `ground` or `pipe_top`).

## Optional Voiceover (Short)

- "Assets are text-first DSL, so iteration is diffable and AI-friendly."
- "Apply is immediate in browser; import/export keeps local persistence."
- "Collision outcomes are explainable through tagged hits."
