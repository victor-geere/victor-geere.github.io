# The four thresholds, rigorously enclosed

**Kind:** Claim
**Status:** PROVED (paper argument; VERIFIED by rigorous bisection, brackets of width ≤ 2.2·10⁻¹²)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh42/truths.md`](../../research/twin-prime-parity/rounds/rh42/truths.md) — §6 "The four thresholds, rigorously enclosed"

## Statement

> | name | equation | value | meaning |
> |---|---|---|---|
> | `pN` | `N(p) = 1` | `1.3777851698375411838…` | `sin = −1` becomes writable |
> | `pP` | `P(p) = 1` | `1.4649845878051603837…` | `sin = +1` becomes writable |
> | `p*` | `ζ(p) = 2` | `1.7286472389981836181…` | the positive half becomes complete (rh41's threshold) |
> | `q` | `N(p) = 2·3^{−p}` | `2.07677517921069…` | the negative half becomes complete |
>
> **Ordering:** `pN < pP < p* < q`. The whole sine range `[−1,1]` is inside budget
> iff `p ≤ pN`; for `pN < p ≤ pP` only the positive sines are all in budget; beyond
> `pP` even `sin = 1` is out of budget. At `p*` the budget interval is
> `[−0.3965305007, +0.6034694993]` — length exactly `ζ(p*) − 1 = 1`, the sine range's
> length — yet `sin = ±1` is *not* writable at `p*` because the budget is split
> unevenly (`P(p*) = 0.6035 < 1`).

## Hypotheses and notation

- `P(p) = Σ_{k≥1} (2k)^{−p}` and `N(p) = Σ_{k≥1} (2k+1)^{−p}` — the two budgets of §2.
- `pN`, `pP`, `p*`, `q` — the four thresholds characterized by the equations in the table.
- `sin` is the target height `x = sin(2πθ)` of §0/§8; the sine range is `[−1,1]`.
- "Budget interval" at `p*` is `[−N(p*), P(p*)] = [−0.3965305007, +0.6034694993]`.

## Proof / evidence

> **PROVED** (the equations and the ordering follow from Theorem 8 and the
> monotonicity of `ζ` on `(1,∞)`, whose derivative `−Σ log k · k^{−p}` is negative
> termwise), **VERIFIED** by rigorous bisection: `ζ` is enclosed at every dyadic test
> point by Euler–Maclaurin at order 1,
> `Σ_{k>N} k^{−p} = N^{1−p}/(p−1) − N^{−p}/2 + p N^{−p−1}/12 ± (p/12)N^{−p−1}`,
> with a conservative sign test, and the endpoints are re-certified with `N = 4·10⁵`.
> The certified brackets (width `≤ 2.2·10⁻¹²`) all contain the published values:
>
> ```
> p* ∈ [1.72864723899810998, 1.72864723899824641]
> pP ∈ [1.46498458780406505, 1.46498458780624784]
> pN ∈ [1.37778516983707959, 1.37778516983817098]
> q  ∈ [2.07677517921067642, 2.07677517921071053]
> ```

## Dependencies and related results

- [Theorem 8 (completeness thresholds, T10, T13)](tpp-rh42-truths-theorem-8-completeness-thresholds.md) supplies the `p*` and `q` characterizations; `ζ`-monotonicity on `(1,∞)` supplies the ordering.
- Handoff ledger rows T14 (§11, "the three thresholds `pN < pP < p*`": VERIFIED → **VERIFIED** rigorously, + `q`) and T15 (§11, "at `p*` the budget interval has length `1`": VERIFIED → **PROVED** + **VERIFIED**) are exactly this result.

## Notes

- The bracket endpoints, the width bound `2.2·10⁻¹²`, the order-1 Euler–Maclaurin tail formula and the re-certification parameter `N = 4·10⁵` are quoted exactly as printed.
- The source's remark that `sin = ±1` is not writable at `p*` despite `ζ(p*) − 1 = 1` is a genuine caveat, not a contradiction: the budget is split unevenly (`P(p*) = 0.6035 < 1`).
