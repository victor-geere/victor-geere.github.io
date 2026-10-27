# T2 — the budgets `P(p) = 2^{−p}ζ(p)`, `N(p) = (1−2^{−p})ζ(p) − 1`

**Kind:** Claim
**Status:** PROVED (paper argument; even/odd split of ζ) + VERIFIED (numerical, direct partial sums to 200k terms)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh42/HANDOFF.md`](../../research/twin-prime-parity/rounds/rh42/HANDOFF.md) — §6 "The rh42 ledger", row T2; statement in §4 (Definitions) and §5.1

## Statement

> `P(p) = Σ_{k≥1} (2k)^{−p}      = 2^{−p} ζ(p)                 "positive budget"`
>
> `N(p) = Σ_{k≥1} (2k+1)^{−p}    = (1 − 2^{−p}) ζ(p) − 1       "negative budget"`

## Hypotheses and notation

- `p > 1` for the convergent range; the ledger row T2 carries no explicit hypothesis beyond the definition of the two budgets.
- `α_n = (−1)^n/(n+2)^p` — the signed ("Tau") alphabet; the positive half is the even-denominator terms, the negative half the odd denominators from 3 on.
- `ζ` is the Riemann zeta function.

## Proof / evidence

> | T2 | `P(p) = 2^{−p}ζ(p)`, `N(p) = (1−2^{−p})ζ(p) − 1` | **PROVED** | even/odd split of ζ; direct partial sums to 200k terms |

The source's §5.1 carries the split out explicitly (`ζ(p) = Σ_{k≥1} (2k)^{−p} + Σ_{k≥0} (2k+1)^{−p}`) and adds: "All of this is recomputed: `P + N = ζ − 1` and `P − N = 1 − η` to 1e−81 at `p = 1.25, 1.5, 2, 3, 4`; direct even/odd partial sums agree within the truncation tail".

## Dependencies and related results

- The same row's identities are exploited by T3 (`P+N = ζ−1`, `P−N = 1−η`).
- Closed forms at even integers (§5.1): `P(2) = π²/24`, `N(2) = π²/8 − 1`, `P(4) = π⁴/1440`, `N(4) = π⁴/96 − 1`.
- Restates `rh42/truths.md` T2 (harvested as "Theorem 2 (T2, T3)"): `P(p) = Σ_{k≥1} (2k)^{−p} = 2^{−p} ζ(p)` and `N(p) = Σ_{k≥1} (2k+1)^{−p} = (1 − 2^{−p}) ζ(p) − 1`.
- The same budgets are restated in the lean README (`Rh42/Budget.lean`, truths.md §2) at `p = 2, 4`.

## Notes

- The row's status is `—` for the *definition* T1 only; T2 itself is `PROVED`.
- The source's §5.1 numeric table gives `P(1.5) = 0.923614`, `N(1.5) = 0.688761`, `P(2) = 0.411234`, `N(2) = 0.233701`, and at `p* = 1.7286472390`: `P = 0.603469`, `N = 0.396531`.
- "direct partial sums to 200k terms" and "to 1e−81" are the source's own precision figures; they are quoted, not re-derived here.
