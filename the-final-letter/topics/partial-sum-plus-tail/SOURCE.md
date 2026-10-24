# Source harvest

**Bundle:** `~/workspace/rh/research/twin-prime-parity/012/` — “a
partial-sum-plus-tail evaluator with checked certificates”.

## Copied into this folder

| Source | Destination | Notes |
|---|---|---|
| `lean/IBox.lean` | `lean/IBox.lean` | Rational `Iv` intervals and complex `Cx` rectangles; soundness lemmas. |
| `lean/Expr.lean` | `lean/Expr.lean` | The `Expr` certificate language, `wf`, `wf_sound`. |
| `lean/Replay.lean` | `lean/Replay.lean` | Generated ζ(2) replay; `cert_mem`. |
| `rigorous/rativ.py` | `python/rativ.py` | Exact-rational interval engine, `π`/`log`/`exp`/`sin`/`cos` enclosures. |
| `rigorous/partial_tail.py` | `python/partial_tail.py` | Euler–Maclaurin evaluator and certificate emitter. |
| `rigorous/verify_certificate.py` | `python/verify_certificate.py` | Independent checker. |
| `rigorous/to_lean.py` | `python/to_lean.py` | Certificate → Lean replay generator. |

## Written for this folder

| File | Purpose |
|---|---|
| `lean/Topic.lean` | Partial-sum + tail transport lemmas and the eta cos/sin split. |
| `lean/Transcend.lean` | Kernel-checked `π`, `exp`, `log`, `sin`, `cos` interval enclosures, with concrete checks. |
| `lean/ReplayAtoms.lean` | The true atom values of the concrete ζ(2) replay and the unconditional `cert_mem_closed`. |
| `python/programme.py` | Clean API over `rativ`/`partial_tail`, including `eta_enclosure` and `eta_cos_sin_enclosure`. |
| `tests/test_programme.py`, `tests/test_interval.py` | The computation ledger (14 tests). |
| `README.md`, `index.html`, `lean/README.md` | Dossier and ledger. |

## Not copied

- `lean/ReplayL.lean`, `lean/ReplayBig.lean` — larger generated replays; the
  ζ(2) replay is enough to exercise the checker.
- `lean/Axioms.lean` — depends on all three replays and only prints axiom
  footprints.
- `verify/` JSON/logs — source-run artefacts; the recorded source results are
  quoted in `README.md`.
- `notes/011-reproducibility.md` — describes the 011 engine, not this folder.

## Reproduction

```bash
cd the-final-letter/topics/partial-sum-plus-tail
python3 -m pytest -q tests
./lean/check.sh
```
