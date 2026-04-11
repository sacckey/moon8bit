# Tilemap Spec (Frozen: 2026-04-11)

This document freezes the v1 tilemap behavior for implementation and GUI work.

## Fixed Decisions

1. Transparent Cell Representation
- `tilemap` transparent cell is `.` only.
- `-1` is not part of the v1 authoring syntax.

2. Tilemap Size Constraint
- `tilemap` size is variable (`width x height`), not forced to screen size.
- Both smaller and larger maps than the screen are valid.

3. Origin and Placement
- Rendering origin is fixed at top-left `(0, 0)`.
- Without camera, the viewport shows map area from top-left.

4. Draw Rule (v1)
- Integer pixel rendering only (no interpolation).
- Viewport cutout from map space.
- Out-of-map area is treated as transparent.
- Camera/scroll parameters are deferred from this freeze and handled in a later extension.

5. Out-of-Bounds Policy
- Use `transparent + clip` policy.
- No wrap, no clamp, no error for out-of-bounds sampling during draw.

6. Collision Data Ownership
- Collision semantics are attached to `tile` definitions (tile-side ownership).
- Game logic should query tile properties, not hardcode numeric tile IDs.

## Accepted Defaults (from prior agreement)

- Single `tileset` in v1.
- Tile size is fixed to `8x8`.
- Tile IDs are assigned by declaration order (`0` origin).
- `tile` name is required.

## Notes

- This freeze is for implementation stability. If camera/wrap is added later, it must be documented as v1 extension, not silent behavior change.
