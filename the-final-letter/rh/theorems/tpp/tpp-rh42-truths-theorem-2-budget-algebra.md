# Theorem 2 (T2, T3)

**Kind:** Theorem
**Status:** PROVED (paper argument; VERIFIED to 1e−50 at p = 1.5, 2, 3, 4)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh42/truths.md`](../../research/twin-prime-parity/rounds/rh42/truths.md) — §2 "The budgets and their algebra"

## Statement

> For every `p > 1`,
>
> ```
> P(p) + N(p) = ζ(p) − 1 ,      P(p) − N(p) = 1 − η(p) ,
> P(p) = (ζ − η)/2 ,            N(p) = (ζ + η − 2)/2 .
> ```

## Hypotheses and notation

- `p > 1` (the range in which all series below converge).
- `P(p) = Σ_{k≥1} (2k)^{−p} = 2^{−p} ζ(p)` — the "positive budget".
- `N(p) = Σ_{k≥1} (2k+1)^{−p} = (1 − 2^{−p}) ζ(p) − 1` — the "negative budget".
- `η(p) = Σ_{n≥1} (−1)^{n−1} n^{−p} = (1 − 2^{1−p}) ζ(p)` (`p ≠ 1`), `η(1) = ln 2`.
- In the last two identities `ζ` and `η` stand for `ζ(p)` and `η(p)`.

## Proof / evidence

> **PROVED** (split `ζ(p) = Σ_{k≥1}(2k)^{−p} + Σ_{k≥0}(2k+1)^{−p}` and subtract),
> **VERIFIED** to `1e−50` at `p = 1.5, 2, 3, 4` and against direct even/odd partial
> sums to 200 000 terms in [`helix_zeta.py`](../../research/twin-prime-parity/rounds/rh42/helix_zeta.py) §1.

## Dependencies and related results

- Uses the definition of `ζ` and the even/odd split of its series.
- The closed forms at `p = 2, 4` are Theorem 5; the Lean file `lean/Rh42/Budget.lean` proves the `p = 2, 4` cases.
- Handoff ledger row T2 (§11) records `P = 2^{−p}ζ`, `N = (1−2^{−p})ζ − 1` as PROVED (+ Lean at `p = 2,4`); row T3 records `P+N = ζ−1`, `P−N = 1−η` as PROVED.

## Notes

- The qualifier "to `1e−50`" and the partial-sum comparison "to 200 000 terms" are the source's own precision statements.
- The source's numeric table in §2 gives, e.g., at `p = 2`: `ζ = 1.644934`, `P = 0.411234`, `N = 0.233701`, `P+N = 0.644934`; at the threshold `p* = 1.7286472390`: `ζ = 2.000000`, `P = 0.603469`, `N = 0.396531`, `P+N = 1.000000`.
