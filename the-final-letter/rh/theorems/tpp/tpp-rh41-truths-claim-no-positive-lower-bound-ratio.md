# The ratio r_{k+1}/r_k² has no positive lower bound

**Kind:** Claim
**Status:** CHECKED (exhaustive finite, 4 000 exact rational orbits; Lean-proved)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh41/TRUTHS.md`](../../research/twin-prime-parity/rounds/rh41/TRUTHS.md) — §3 "The support: greedy orbits"

## Statement

> **Checked, and this is the sharp half.** `r_{k+1}/r_k² = (1−f)/(1+(1−f)r_k)` with `f = {1/r_k}` has **no positive lower bound** (minimum 1.58·10⁻⁴ over 4 000 exact rational orbits; it tends to 0 as `f → 1`). Therefore no two-sided law `c·r_k² ≤ r_{k+1} ≤ r_k²` with `c > 0` exists, and the matching upper bound `A(N) = O(log log N)` is **open**.

## Hypotheses and notation

- `r_k` is the residual of the greedy rule at the `k`-th active step; `f = {1/r_k}` is the fractional part of `1/r_k`.
- The displayed identity is the source's exact expression for the per-step ratio `r_{k+1}/r_k²`.
- `c > 0` is a constant in the two-sided law; `A(N) = #{k : n_k ≤ N}` is the counting function of [the squaring-law claim](tpp-rh41-truths-claim-squaring-law-omega-lower-bound.md).

## Proof / evidence

The source's evidence is the exact-rational computation over 4 000 orbits, with observed minimum `1.58·10⁻⁴`; the limiting behaviour is stated as `f → 1`.

Machine-checked as `Harmonic.no_positive_lower_bound` in `Rh41/GreedyResidual.lean` (no `native_decide`); the round's Lean README lists the decimal minimum `1.58·10⁻⁴` under "Not formalised" (the qualitative statement is formalised, the decimal is not).

## Dependencies and related results

- [The squaring law r_{k+1} ≤ r_k² and the lower bound A(N) = Ω_x(log log N)](tpp-rh41-truths-claim-squaring-law-omega-lower-bound.md) — the upper half of the pair, and the source of the open `O(log log N)` question.
- [Refuted — the residual-orbit average has a limit independent of x](tpp-rh41-truths-refuted-residual-orbit-average-limit.md) — the §5 row on the same orbit.
- [Refuted — `A(N) = log₂ log N + O(1)` with an explicit constant](tpp-rh41-truths-refuted-explicit-loglog-constant.md) — the §5 row that cites this minimum.

## Notes

- The source labels this **Checked** and calls it "the sharp half"; the round's Lean README reports a general proof (`Harmonic.no_positive_lower_bound`), which is why the status line carries both.
- The minimum `1.58·10⁻⁴` and the orbit count `4 000` are quoted exactly as printed.
