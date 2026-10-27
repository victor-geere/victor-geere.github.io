# Research journal — outcome summary (compacted)

The full project-wide journal (677 sections, ~2 MB of round-by-round process) has been
**compacted to its outcome-relevant content**. The complete machine-readable log is
`objectives.json` (the `round_log`: 263 rounds, one entry per round); the proved ledger
is `truths.md`; the human-readable chronicle is `html/objectives.html`. This file keeps
only what the programme actually established.

## Final state (round 263)

- **3 objectives, 27 tasks: 19 done · 3 refuted · 3 blocked · 2 open.**
- The **011 part (A) development is complete and verified**: 365 footprint-clean
  declarations, zero `sorry`/`admit`/`axiom`/`native_decide`, every `#print axioms`
  exactly `[propext, Classical.choice, Quot.sound]`, 29 Lean files.
- The **sharp archimedean rate is mathematically complete and verified** (the Lean
  formalisation is one lemma — the Euler–Maclaurin endpoint term — short).

## The three objectives and what they established

**O1 — Can Routes A, B, C be generalised?** (Dirichlet `L`-function instantiation.)
The Route A/B/C theorem cores are already general in Lean; the Riemann–von Mangoldt
interface is a compiled conditional theorem `criticalStripLogDerivBound_of_L_and_hH`
from exactly the two classical inputs `hL`, `hH` (both PNT-strength); the archimedean
input is the sharp rate `‖Γ(σ+it)‖ ≤ 2√(2π)·|t|^(σ−1/2)·e^(−(π/2)|t|)` for
`|t| ≥ 2`, `σ ∈ [0.25, 2]` (sup ratio 0.559, verified; see
`notes/sharp-gamma-rate.md`, `python/t12_sharp_rate_probe.py`).

**O2 — Decomposition-lab and the zeta series.** Verdict: the harmonic tier's Egyptian
decomposition is a representation identity whose only invariant is the *sum*, so no
term-level partition can see a zero; `|S_N(1/2+iγ₁)| ~ 0.0707·√N`. (Refuted: the
index, magnitude, and zero-information readings.)

**O3 — The η/Euler route to ζ on the critical line.** Verdict: an *evaluator*, not a
certification — `η = (1−2^(1−s))ζ` converges for `Re s > 0` via odd/even cancellation,
Euler's transformation makes the tail geometric, and the double-precision floor is
`≈ 2·10⁻¹⁵`. See `html/eta-euler-acceleration.html`.

## Proved ledger (11 items)

1. Greedy digit word: factor-complexity law and inverse-problem impossibility (Rh41).
2. Signed Tau alphabet: budget algebra, Brown's criterion, census law, four thresholds, parity lock (Rh42).
3. Balance `⇔ Re S_N(t) = 0`, attainable for every `N ≥ 2` (Rh43).
4. Smoothing does not remove `√N`; only the functional equation does (Rh044).
5. The correct Weil explicit formula and the closed Turing windows `1/2 < Im < 15`, `1/2 < Im < 33` (Rh45/010), both unconditional.
6. The finite-prefix indeterminacy theorem (two-point Chowla) — the programme's one clean new theorem (Rh46).
7. The Sylvester-sparsity theorem for the greedy support (Rh47).
8. OP-5/OP-6: `n_min(p) = p/log 2 − 3/2 + O(1)`; `measure(S₁)/P(p) = p^(−p) e^((1+log log 2)p)(1+o(1))` (Op56).
9. The von Mangoldt sieve results (publish/001, sibling edition).
10. Three thresholds `pN < pP < p*` (TppLean).
11. 011 part (A) steps 1–3: `sup_t ‖L(1+it)‖ < ∞`; `Λ` bounded on the closed strip; the interface reduced to (H)/(V); the polynomial bound for `LFunction`.

## Open, blocked, and not done

- **Open (2):** `O1.T12` and `O1.T6` — the sharp archimedean rate; the mathematics is
  complete and verified, the remaining Lean step is the Euler–Maclaurin endpoint lemma
  (Mathlib has no Euler–Maclaurin or trapezoidal lemma).
- **Blocked (3):** `O1.T5`, `O1.T9`, `O1.T11` — their remainders are the two PNT-strength
  classical inputs `hL` and `hH` (the Riemann–von Mangoldt theorem itself).
- **Not done, stated plainly:** nothing is proved about twin primes or the parity
  obstruction — `Σ_{n≤x} λ(n)λ(n+2) = o(x)` remains OPEN.
