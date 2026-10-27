# rh42 — the exact reachable sets at `p=2` and `p=3`

**Kind:** Claim
**Status:** CHECKED (exhaustive finite — exact enumeration of all `2^16` sub-sums at `p=2`; exact `Fraction` arithmetic)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/checks/06-numerical-checks.md`](../../research/twin-prime-parity/checks/06-numerical-checks.md) — § rh42, "Headline numbers" and "What it establishes" (lines 99–127)

## Statement

> Exact reachable sets (`reachable.log` §3–3b):
>
> | p | reachable set | gap |
> |---|---|---|
> | 2 | `[0, π²/24 − 1/4] ∪ [1/4, π²/24]` = `[0, 0.161233516712] ∪ [0.25, 0.411233516712]` | `(0.161233516712, 0.25)` |
> | 3 | `[0,0.0096321129] ∪ [0.015625,0.025257113] ∪ [0.125,0.13463211] ∪ [0.140625,0.15025711]` | four intervals |

The source's own reading of the strength of this statement:

> The **exact** reachable sets at `p=2` and `p=3` (a finite but exact statement: the sub-sum structure of a specific rational sequence)

## Hypotheses and notation

- The reachable set is the set of values attained by sub-sums of the signed alphabet `{±n^{−p}}`; the register records it as a union of closed intervals on the line of the relevant (sine) target.
- `π²/24 − 1/4` and `π²/24` are the closed-form endpoints at `p=2`; `1/4` is the base point.
- Method: exact `Fraction` arithmetic and outward-rounded rational enclosures throughout, "exact enumeration of all `2^16` sub-sums at `p=2`"; `π²` was enclosed to width `5.615e-84` (Machin), `ζ(3)` to width `3.125e-18` (Euler–Maclaurin).

## Proof / evidence

- `rh42/reachable.py` → `rh42/verify/reachable.log` §3–3b, final line **`ALL 70 CHECKS PASS`** (`exit=0`).
- The register classifies this as "a finite but exact statement: the sub-sum structure of a specific rational sequence"; the census formula `#intervals = 2^{n_min−1}`, `measure = 2^{n_min−1} T_{n_min}` was additionally checked for `p = 1.2 … 12`, the two independent routes agreeing to `3.89e-62`.

## Dependencies and related results

- The budget identities and thresholds of the same round (`P(p)`, `N(p)`, `pN < pP < p* < q`).
- The census identity (see the census entry for this source); the global completeness statement is the Lean module `Rh42/Reachable.lean`.

## Notes

- "Exact" here means exact over a **specific finite rational sequence**, not an asymptotic statement; the register says so in those words.
- The register warns that `ALL 80 CHECKS PASS` / `ALL 70 CHECKS PASS` are counts of criteria, not of theorems.
