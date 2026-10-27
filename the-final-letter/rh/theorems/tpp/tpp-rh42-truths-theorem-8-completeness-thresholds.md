# Theorem 8 (completeness thresholds, T10, T13)

**Kind:** Theorem
**Status:** PROVED (paper argument; VERIFIED in both directions at the bracketing points)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh42/truths.md`](../../research/twin-prime-parity/rounds/rh42/truths.md) — §3 "The exact reachable set: Brown's criterion"

## Statement

> At `p > 1`,
>
> ```
> positive half complete (S = [0, P(p)])   ⟺   n_min(p) = 1   ⟺   ζ(p) ≥ 2   ⟺   p ≤ p*
> negative half complete (S = [0, N(p)])   ⟺   n_min^odd(p) = 1 ⟺ N(p) ≥ 2·3^{−p} ⟺ p ≤ q
> ```
>
> with `p* = 1.7286472389981836181…` (the rh41 threshold, `ζ(p*) = 2`) and
> `q = 2.07677517921069…`.

## Hypotheses and notation

- `p > 1`.
- `S` is the reachable/sub-sum set; `P(p)` and `N(p)` are the positive and negative budgets of §2.
- `n_min(p)` is the first complete positive tail (Theorem 7); `n_min^odd(p)` is the analogous first complete negative tail.
- `p* = 1.7286472389981836181…` — the rh41 threshold, characterized by `ζ(p*) = 2`.
- `q = 2.07677517921069…` — the negative-half threshold, characterized by `N(p) = 2·3^{−p}`.
- `N(p) ≥ 2·3^{−p}` uses the negative half's first term `3^{−p}`.

## Proof / evidence

> **PROVED**: Theorem 7 makes the condition at `n = 1` the binding one, since `h`
> is unimodal (increasing, then decreasing to `0⁺`), so `{n : h(n) < 0}` is an
> initial segment — if `h(1) ≥ 0` every condition holds, and if `h(1) < 0` the first
> already fails. **VERIFIED** in both directions at `p* ± 10⁻⁹` and `q ± 10⁻⁶`.

## Dependencies and related results

- [Theorem 7 (unimodality)](tpp-rh42-truths-theorem-7-unimodality.md) supplies the initial-segment property; [Theorem 6 (Brown's criterion)](tpp-rh42-truths-theorem-6-brown-criterion.md) supplies the completeness criterion.
- Corollary 9 is the writability consequence; Theorem 10 uses `n_min(p)` for the census.
- Handoff ledger rows T10 and T13 (§11): "the positive half is complete iff `p ≤ p*`" and "the negative half is complete iff `p ≤ q`", both PROOF-SKETCH before and **PROVED** after.
- The four thresholds themselves, with rigorous enclosures and the ordering `pN < pP < p* < q`, are in §6 (harvested as [The four thresholds, rigorously enclosed](tpp-rh42-truths-four-thresholds-enclosed.md)).

## Notes

- The source's emphasis, quoted verbatim: "**The rh41 threshold `p*` is exactly the exponent at which the signed sine set stops being an interval.**"
- The brackets for `p*` and `q` are given in §6 (widths `≤ 2.2·10⁻¹²`); the values quoted in the statement are the published ones.
