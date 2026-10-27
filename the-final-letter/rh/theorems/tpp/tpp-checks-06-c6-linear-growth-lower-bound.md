# C6 — the growth of `S_N` is linear, not `N^{1/2}`

**Kind:** Claim
**Status:** REFUTED (the round's claim "`N^{1/2}`-ish growth"), with a rigorous Euler-summation lower bound and certified exponents
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/checks/06-numerical-checks.md`](../../research/twin-prime-parity/checks/06-numerical-checks.md) — § rh43, "What it establishes" (lines 217–228); *Corrections and discrepancies*, item 8

## Statement

> * **C6 "`N^{1/2}`-ish growth" — REFUTED.** With the rigorous first-order Euler-summation lower bound
>   `|S_N(t)| ≥ N/√(1+t²) − (|t|/2)log N − (1/√(1+t²)+1) → ∞`, growth is **linear**:
>   certified exponents `0.986434` (`t=1`), `1.061003` (`t=14.134…`), `1.000126` (C1 root); `|S_N|/N → 1/√(1+t²)` with max deviation `5.44e-07` at `N=10^6`.

## Hypotheses and notation

- `S_N(t) = Σ_{n≤N} n^{−it}`; the round's convention is `S = i t`.
- The lower bound is the first-order Euler-summation bound `|S_N(t)| ≥ N/√(1+t²) − (|t|/2)log N − (1/√(1+t²)+1)`.
- "C1 root" is the smallest positive root of the balanced split `Re S_N = 0` of the same round (`N = 6`: `1.36250808733474170983371419814076`).

## Proof / evidence

- The register lists this as the third of "Three **refutations** of the round's own stated claims, with certificates"; the certificate is the lower bound above, which diverges linearly, together with the certified exponents `0.986434`, `1.061003`, `1.000126` and the limit `|S_N|/N → 1/√(1+t²)` with max deviation `5.44e-07` at `N=10^6`.
- Sources: `rh43/zeta_split.py` → `rh43/verify/zeta_split.log` (**`64 checks pass, 0 fail`**); auditor `rh43/verify/independent_check.py` → `independent_check.log` (**`102/102 checks pass`**, `EXIT=0`); `rh044`'s `independent_check.log` records "sharp partial-sum roots are *not* zeta zeros".

## Dependencies and related results

- The C5 exact-vanishing refutation of the same round (`tpp-checks-06-c5-no-exact-vanishing-refuted.md`).
- The register's note that "Nothing here concerns RH: `Re(S) = 0` is far outside the half-plane of convergence, so divergence of `S_N` is expected."

## Notes

- The Euler-summation bound is described by the register as "rigorous"; the exponents `0.986434`, `1.061003`, `1.000126` are certified numerical readings at the stated `t`, and `5.44e-07` is the maximum deviation of `|S_N|/N` from `1/√(1+t²)` at `N=10^6`.
- *Corrections* item 8 records the same refutation in compressed form: "'`|S_N|` grows like `N^{1/2}`' is refuted: growth is linear, with the rigorous Euler-summation lower bound."
