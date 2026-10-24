# 007 — Structural generalisation #6: Dirichlet L-functions (character-sum twist)

Attack on `006/handoff.md` §11, item 6: replace the parity sieve of OP-5/OP-6 by
a character sum, `a_k = χ(k)k^{−p}`, and ask how much of the OP-5 second-order
expansion survives when `χ` is non-principal.

**Read in this order.**

1. [`notes/generalisation-06.md`](notes/007/generalisation-06.md) — the mathematical
   note: the substitution, the limit law, the threshold criterion, the
   second-order deformation, the two non-existence theorems, the numerics.
2. `handoff.md` — current state, build and verify instructions,
   file map, what is and is not proved, technique notes.
3. `index.html` — the paper (self-contained).
4. `lean/README.md` — the Lean 4 formalisation.

## Summary

* The twisted boundary functional is a character-weighted geometric sum:
  `Φ_c(p,n) → F_{n mod q}(e^{−p/n})`,
  `F_r(x) = Σ_{j≥1} c(r+j)x^j = f_r(x)/(1−x^q)`, error `O(1/n)`.
* OP-5 is `c ≡ 1`; the leading equation `Σ x^j = 1` (`x = 1/2`) becomes
  `F_r(x) = 1`. For the parity sieve this is `x = 1/√2` (even `r`) or
  `x = (√5−1)/2` (odd `r`) — both **proved** in Lean.
* The second-order expansion survives in full shape,
  `p(n) = a n + g + c/n + O(1/n²)`, with character-twisted moments; at `c ≡ 1`
  it reproduces `c₅ = 3(log 2)² − (25/12)log 2` exactly.
* Whether the leading equation has a root is an arithmetic condition on `(χ,r)`.
  It fails for `χ₃` and `χ₄` (**proved**: `F_r < 1` on `[0,1)`), and holds for
  29.7 % of the 4537 `(χ,r)` pairs among all real characters mod `q ≤ 60`.
* Lean: `./check.sh --all` green, **0 `sorry`, 0 `axiom`**, footprint
  `propext, Classical.choice, Quot.sound`.

Nothing here bears on the Riemann Hypothesis.
