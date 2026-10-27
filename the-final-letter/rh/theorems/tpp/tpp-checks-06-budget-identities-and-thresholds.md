# rh42 — the budget identities and the four threshold certificates

**Kind:** Claim
**Status:** VERIFIED (numerical — budget identities to `1e-81`; each threshold certified by a sign change on an explicit rational bracket)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/checks/06-numerical-checks.md`](../../research/twin-prime-parity/checks/06-numerical-checks.md) — § rh42, "Headline numbers" and "What it establishes" (lines 70–127)

## Statement

> Budgets `P(p)=2^{−p}ζ(p)` (even m), `N(p)=(1−2^{−p})ζ(p)−1` (odd m ≥ 3):
>
> | p | ζ(p) | P(p) | N(p) | P+N | P−N |
> |---|---|---|---|---|---|
> | 2 | 1.644934067 | 0.4112335167 | 0.2337005501 | 0.6449340668 | 0.1775329666 |
> | 3 | 1.202056903 | 0.1502571129 | 0.05179979026 | 0.2020569032 | 0.09845732263 |
> | 4 | — | 0.06764520211 | 0.01467803160 | — | 0.05296717050 |
>
> Identity residuals `P+N−(ζ(p)−1)` and `P−N−(1−η(p))` are `≤ 1.32e-81` (`helix_zeta.log` §1). The alphabet's total sign sum is **`1 − ln 2 = +0.30685281944005469058`** — the log explicitly corrects a page that prints `ln 2 − 1 = −0.306852819440054691`.
>
> Thresholds, each certified by a **sign change on an explicit rational bracket** (`reachable.log` §5):
>
> | threshold | meaning | value | bracket width |
> |---|---|---|---|
> | `pN` | `N(pN)=1` | 1.3777851698375411838 | 1.1e-12 |
> | `pP` | `P(pP)=1` | 1.4649845878051603837 | 2.2e-12 |
> | `p*` | `ζ(p*)=2` | 1.7286472389981836181 | 1.4e-13 |
> | `q` | negative half complete | 2.07677517921069 | 3.4e-14 |
>
> and `pN < pP < p* < q`. At `p*` the budget interval has length exactly 1 (`P(p*)+N(p*) = 1.00000000000013`); `P(p*) = 0.6034694993 = 2^{1−p*} < 1`, so `sin=1` is **not** representable at `p*`.

## Hypotheses and notation

- `P(p)=2^{−p}ζ(p)` is the budget of the even-`m` half, `N(p)=(1−2^{−p})ζ(p)−1` that of the odd-`m` half (`m ≥ 3`).
- `η(p)` is the quantity in the second identity residual; the source does not define it in this register beyond the identity `P−N = 1−η(p)`.
- `pN`: the exponent with `N(pN)=1`; `pP`: the exponent with `P(pP)=1`; `p*`: the exponent with `ζ(p*)=2`; `q`: the exponent at which the negative half-tail is complete.
- "The alphabet's total sign sum" is the total signed mass of the alphabet; the log's value is `1 − ln 2`.

## Proof / evidence

- Identity residuals as computed in `rh42/verify/helix_zeta.log` §1 (`≤ 1.32e-81`, exact `Fraction` arithmetic and outward-rounded rational enclosures; Machin's formula for π, Euler–Maclaurin for `ζ(3)`, `2 artanh(1/3)` for `ln 2`).
- Thresholds from `rh42/verify/reachable.log` §5; each provably lies in the quoted interval by a sign change plus monotonicity/sign analysis on that interval (the register's own wording: "each of `pN, pP, p*, q` provably lies in the quoted interval").

## Dependencies and related results

- Same round and scripts: the exact reachable sets at `p=2, 3` and the census identity (`#intervals`, `measure`) recorded in this same register (§ rh42, "What it establishes").
- The completeness thresholds `p*` and `q` recur as `THEOREM 8 (completeness thresholds)` in the rh42 ledger and as `tpp-dict-04-completeness-thresholds.md` elsewhere in this harvest; the global "iff" for completeness of the two halves is attributed by this register to the Lean module `Rh42/Reachable.lean`.

## Notes

- The register is explicit that `ALL 80 CHECKS PASS` counts **80 criteria, not 80 theorems**, and that the thresholds are located only **inside their brackets**: "the quoted decimals are the published values, and the check is that the bracket contains them — nothing is claimed about digits beyond the bracket."
- The `p=1` in-budget claim (`max |residual| = 2.291e-6` for the sines tested) is empirical: both budgets are infinite at `p=1`, so "no target is out of budget" is true for the wrong reason.
- The sign-sum value is recorded here as a correction of a page that prints `ln 2 − 1 = −0.306852819440054691` (§ Corrections, item 10).
