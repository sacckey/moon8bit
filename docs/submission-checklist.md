# Submission Checklist (moon8bit)

## Metadata

- Submission target: MoonBit SCC 2026
- Deadline: 2026-04-21
- Current status date: 2026-03-31

## Stage 1 Submission Gate

- [ ] Google Form is submitted (target: 2026-04-01).
- [ ] Submission timestamp is recorded in `docs/handoff.md`.
- [ ] Final submitted text snapshot is preserved locally.

## Messaging Safety Checks

- [ ] Claims are evidence-based (implementation facts only).
- [ ] No "first/only/better than X" uniqueness claims without proof.
- [ ] Competitor comparison is optional and not required for this submission.

## Required Artifacts

- [ ] Repository URL is final and accessible.
- [ ] Application text (300+ words) is finalized.
- [ ] AI usage / retrospective note is finalized.
- [ ] README has reproducible run steps.
- [ ] Demo video or GIF is ready and viewable.

## Repository Docs to Confirm

- [ ] `README.mbt.md`
- [ ] `docs/application-draft.md`
- [ ] `docs/ai-usage-log.md`
- [ ] `docs/decision-log.md`
- [ ] `docs/demo-script.md`

## Reproducibility Checks

Run from module root:

```bash
moon check
moon test
moon build --target js cmd/web
python3 -m http.server 8000
```

Open:

- `http://localhost:8000/demo/`

Expected:

- [ ] Driftbird demo is playable (`Space` / `ArrowUp`, `R` reset).
- [ ] DSL `Apply` updates screen output.
- [ ] `Import DSL` loads local file and applies.
- [ ] `Export DSL` downloads current editor text.
- [ ] Status line updates (`score`, `frame`, `hit`).

## Final Submission Pass

- [ ] Freeze major features (docs/bugfix only).
- [ ] Re-run reproducibility checks.
- [ ] Ensure latest docs match actual implementation.
- [ ] Ensure commit history is clean and understandable.
- [ ] Submit with final application text and demo link.

## Post-Submission Priority (Execution Order)

1. Add thin ergonomic wrapper APIs with backward compatibility.
2. Add wrapper equivalence tests (same behavior as existing APIs).
3. Add a compact wrapped sample while keeping `game_driftbird.mbt` as baseline.
4. Update README with concise API examples and reproducibility proof points.
