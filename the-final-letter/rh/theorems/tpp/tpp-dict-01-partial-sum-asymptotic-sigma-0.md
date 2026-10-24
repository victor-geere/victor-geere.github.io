# (P2) The partial-sum asymptotic at `σ = 0` (Euler–Maclaurin)

**Kind:** Theorem
**Status:** CITED (literature; re-measured numerically in the source)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/dictionary/01-preliminaries.md`](../../research/twin-prime-parity/dictionary/01-preliminaries.md) — §3 "Prerequisites: what the programme uses from analysis", "(P2)", line 77

## Statement

> **(P2) The partial-sum asymptotic at `σ = 0` (Euler–Maclaurin).**  For fixed `t`,
> ```
> S_N(it) = N^{1−it}/(1−it) + ζ(it) + O(N^{−1/2}) .
> ```

The source adds the numerical verification, verbatim:

> *Status:* THEOREM.  *Verified numerically:* rh43 §4 and rh044 §1; the record here
> re-measures `|S_N − N^{1−s}/(1−s) − ζ|·√N = 0.499996, 0.500000` at `N = 10⁴, 10⁵`
> (`t = 14.1347`), confirming the `1/2` constant of the first correction term.

## Hypotheses and notation

- `S_N(t) = Σ_{n≤N} n^{−it}` is the zeta partial sum at `σ = 0` (source §1).
- `t` is **fixed**; the asymptotic is in `N`.
- The error term is `O(N^{−1/2})`; the source records the numerical value of the implied constant as `1/2` (measured `0.499996, 0.500000`).

## Proof / evidence

The source gives no proof; it cites **Euler–Maclaurin** in the heading and records the status line and numerical re-measurement quoted above.

## Dependencies and related results

- Uses `ζ` and its continuation from [(P1) Euler product and analytic continuation of `ζ`](tpp-dict-01-euler-product-and-continuation.md).
- Referenced by ledger rows D8 and D9 of [`00-dictionary.md`](../../research/twin-prime-parity/dictionary/00-dictionary.md) — [linear growth of `S_N`](tpp-dict-00-linear-growth-of-sn.md) and [the `σ = 1/2` parts](tpp-dict-00-half-abscissa-parts-asymptotic.md).

## Notes

- Listed by the source under **§3 "Prerequisites"**: a classical (Euler–Maclaurin) rung, hence **CITED (literature)**.
- The numerical numbers are finite measurements at `N = 10⁴, 10⁵`, `t = 14.1347`; they support, but do not prove, the asymptotic.
