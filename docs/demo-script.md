# Demo Script (30-45 sec)

## Goal

Show fast AI-friendly iteration with the current web workflow:
`Open game page -> Edit DSL/Sprite/Sound -> Apply -> Immediate playable result`.

## Recording Setup

- Open `http://localhost:8000/g/driftbird/`
- Keep browser zoom at 100%
- Keep all tabs visible (`Game`, `DSL`, `Sprite`, `Sound`)

## Timeline

1. 0s-8s: Game control and HUD
   - In `Game` tab, press `Space` a few times.
   - Show in-canvas HUD updates (`S`, `F`, `H`).

2. 8s-18s: DSL edit + apply
   - Switch to `DSL` tab.
   - Change a `tilemap` or `sprite` row.
   - Click `Apply DSL`.
   - Return to `Game` tab and show visual change.

3. 18s-30s: Sprite GUI editing
   - Switch to `Sprite` tab.
   - Modify a few pixels.
   - Click `Write + Apply`.
   - Return to `Game` tab and show updated sprite.

4. 30s-40s: Sound GUI editing
   - Switch to `Sound` tab.
   - Press SFX test buttons and adjust one parameter.
   - Return to `Game` tab and show sound still works during play.

5. 40s-45s: Import/Export loop
   - In `DSL` tab, click `Export DSL`.
   - Click `Import DSL` and re-apply.

## Optional Voiceover

- "Assets are text-first DSL and editable in-browser."
- "The runtime is deterministic and update/apply is immediate."
- "Sprite and sound authoring are integrated into the same per-game page."
