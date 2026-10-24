# Lean core — partial sum plus tail

## Build

```bash
cd the-final-letter/topics/partial-sum-plus-tail
./lean/check.sh
```

`check.sh` compiles `IBox.lean`, `Expr.lean`, `Transcend.lean`, `Replay.lean`, `ReplayAtoms.lean` and `Topic.lean` in dependency
order against the shared Mathlib at `~/lean/mathlib4`. The recorded build is
[`BUILD.log`](BUILD.log).

## What is formalised

| File | Content |
|---|---|
| [`IBox.lean`](IBox.lean) | Rational intervals `Iv` and complex rectangles `Cx`; soundness of `add`, `neg`, `sub`, `scale`, `mul`, `inflate` over both `ℚ` and `ℝ`. |
| [`Expr.lean`](Expr.lean) | The straight-line certificate language `Expr`, the computable checker `wf`, and the inclusion theorem `wf_sound`: if every atom lies in its declared box and `wf` accepts, the denoted value lies in the final box. |
| [`Transcend.lean`](Transcend.lean) | Kernel-checked enclosures for `π`, `exp`, `log`, `sin` and `cos`: Taylor/log series, explicit geometric or alternating remainders, `Real.hasSum_log_one_add`, `Real.hasSum_cos`/`sin`, and `2π` reduction. |
| [`Replay.lean`](Replay.lean) | A concrete generated ζ(2) certificate; `cert_mem` applies `wf_sound` and `native_decide` checks `wf`. |
| [`ReplayAtoms.lean`](ReplayAtoms.lean) | The true atom values `σ`, the totalised boxes `A'`, and `atom_mem'`; `cert_mem_closed` is the replay with no atom hypothesis. |
| [`Topic.lean`](Topic.lean) | The partial-sum-plus-tail transport lemmas (`tsum_eq_finite_add_tail`, the residual and three-tail bounds) and the eta cos/sin split (`etaTerm_re`, `etaTerm_im`, `etaPartial_re`, `etaPartial_im`). |

No `sorry`, no `axiom`, no `admit`.

## What is not formalised

- The Euler–Maclaurin decomposition of `ζ(s,a)` and the explicit tail bound
  `|R_K| ≤ …`; these are source claims, implemented in Python.
- The transcendental enclosures are now **proved** in `Transcend.lean` (see
  the theorem ledger T26–T31): `π` from Mathlib's 20-digit bounds, `exp` by a
  reduced Taylor series and arbitrary scaling, `log` from the positive
  `log(1+a)` series with a geometric tail, and `sin`/`cos` from the alternating
  series with a rigorous `2π` reduction.  The atom leaves of the concrete
  ζ(2) replay are discharged in `ReplayAtoms.lean` (`cert_mem_closed`), so the
  replay itself has no atom hypothesis.  The Euler–Maclaurin formula and its
  tail bound remain source claims.
- The independent certificate verifier and the certificate emitter: Python
  side (`verify_certificate.py`, `partial_tail.py`).
- Derivatives (`L'/L`), and the `s = 1` case for `L`.

The Lean replay of a concrete certificate uses `native_decide` to evaluate
`Expr.wf`; `Expr.wf_sound` itself is kernel-checked.

[Back to the programme](../README.md) · [Topic index](../../README.md)
