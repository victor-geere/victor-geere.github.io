# 009 — Angle parity and Ω-dependent signs: two decisive tests

Two concrete obligations from the previous round, executed:

1. **Machine-check the sparse-pair lemma** for the eta/angle sign
   `w(n) = sign(sin(t log n))` — that the symmetric twist of the shift-2
   correlation is `Σ λ(n)λ(n+2) + O(t log x)`.
2. **Test whether an Ω-dependent sign changes the pair sum by positive density**
   (the backward criterion `M_w(x) ≢ o(x)`).

**Read in this order.** [`notes/angle-parity-and-omega-signs.md`](notes/009/angle-parity-and-omega-signs.md)
→ `handoff.md` → `index.html` → `lean/README.md`.

## Results

**Move 1 (proved, Lean, 0 `sorry`, 0 `axiom`).**

* `Op59.sparse_pair_bound`: `|Σ a n (w n w (n+2) − 1)| ≤ 2 · #{crossings}`.
* `Op59.phaseCrossing_card_le`: `#crossings ≤ 2·(⌊θ(N+2)/c⌋ + 1)` for a strictly
  increasing phase.
* `Op59.angle_twist_invisible`: the angle twist changes the correlation by
  `O(θ(N+2)/c)` — for `θ n = t log n`, `c = π`, that is `O(t log N)`.

Confirmed numerically to `X = 10⁷` for `t ≤ 100`.

**Move 2 (measured).** The criterion separates three behaviours:

| `w` | `W/x` | `U/x` | `M/x` | reading |
|---|---|---|---|---|
| `λ` (circular) | 0.00 | **1.000** | **0.9999** | `w` *is* λ |
| `(−1)^{ω(n)}` | 0.00 | **0.4717** | **0.1589** | couples to Ω at density, **destroys** cancellation |
| squarefree parity | 0.22 | 0.0003 | −0.0004 | preserves cancellation, uninformative |
| `χ₄` (Hecke char of ℚ(i)) | 0.00 | 0.0003 | −0.0003 | preserves cancellation, uninformative |
| angle sign `t = 10` | 0.05 | −0.0005 | 0.0000 | pair-invisible (Move 1) |

## Verdict

A sign either **preserves** the pair cancellation (and cannot force the
conclusion) or **destroys** it (and is useless). None both preserves it and
separates Ω. The parity barrier stands, now with a proved sparse-pair lemma and a
measured dichotomy rather than a slogan.

Nothing here bears on the Riemann Hypothesis or the twin prime conjecture. Finite
ranges (`10⁶`–`10⁷`) prove nothing about asymptotics (006 dictionary F4).
