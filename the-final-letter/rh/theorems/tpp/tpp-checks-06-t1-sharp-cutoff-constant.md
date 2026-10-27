# T1 — sharp cutoff: `|S_N(1/2+it) − ζ(1/2+it)|/√N → 1/√(1/4+t²) = 1/|s−1|`

**Kind:** Claim
**Status:** VERIFIED (numerical — finite-range, observed at `N=102400` with relative deviation ≈ `2.44e-6`; the exact leading law comes from the Abel/Euler–Maclaurin derivation, not from the fit)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/checks/06-numerical-checks.md`](../../research/twin-prime-parity/checks/06-numerical-checks.md) — § rh044, "Headline numbers", T1 (lines 269–279) and "What it does not" (lines 356–363)

## Statement

> T1 — sharp cutoff. `|S_N(1/2+it) − ζ(1/2+it)|/√N → 1/√(1/4+t²) = 1/|s−1|`:
>
> | t | exact constant C | brief's `1/√(2t)` | ratio | observed at `N=102400` | ratio obs/C |
> |---|---|---|---|---|---|
> | 14.134725141734693 | 0.0707035277318122 | 0.1880794379435 | 2.6601139 | 0.0707037004038 | 1.0000024422 |
> | 21.022039638771555 | 0.0475556741610922 | 0.154222442448529 | 3.2429872 | 0.0475557903472 | 1.0000024432 |
> | 10.0 | 0.0998752338877845 | 0.223606797749979 | 2.2388613 | 0.0998754777633 | 1.0000024431 |
>
> Fitted slopes of `log|S_N−ζ|` vs `log N`: `0.49968393` over all `N` (`1e2…1.024e5`), `0.49995164` for `N ≥ 1000`. The next Euler–Maclaurin orders are confirmed: `|R_1|√N = 0.4999995932 → 1/2`, `|R_2| N^{3/2} = 1.178630488 → |s|/12 = 1.178630487`.

## Hypotheses and notation

- `S_N(s) = Σ_{n≤N} n^{−s}` is the sharp-cutoff partial sum; `s = 1/2 + it` throughout.
- `C = 1/√(1/4+t²) = 1/|s−1|` is the exact constant; the "brief's `1/√(2t)`" is the round brief's incorrect normalisation.
- `R_1`, `R_2` are the first two Euler–Maclaurin remainder terms of the partial sum.

## Proof / evidence

- Computed in `rh044/smoothed_zeta.py` → `rh044/verify/smoothed_zeta.log` (final line **`59 checks pass, 0 fail`**, total wall `302.5 s`) at the dps reported with every claim (60 dps for §§1–2); `mpmath` 1.3.0.
- The auditor (`rh044/verify/independent_check.py`, own θ route) confirms the constant and refutes the brief's normalisation; the register records **`3 of 5 round claims REFUTED as stated, 2 verified`**.
- Rigorous side: the register records an a-priori Euler–Maclaurin bound for the refutation of the brief's limit: `|S_N−ζ|√(2t)/√N ≤ 0.3760035107` at `N=1e5`.

## Dependencies and related results

- T2 (smoothing) and T3 (the θ / functional-equation identity) of the same register section.
- The corrected constant is also recorded in the register's *Corrections* item 6, against the brief's `1/√(2t)`.

## Notes

- **Finite range only.** The register states plainly: "`|E|/√N → |J(φ)|`" is a **finite-range** statement; the fitted slopes (`0.4997`, `0.5125`, …) are 12-point descriptions. The exact leading law comes from the Abel/Euler–Maclaurin derivation, not from the fit."
- The `ratio obs/C` entries are ≈ `1.00000244` at `N=102400`, i.e. the observed deviation from the exact constant is ≈ `2.44×10⁻⁶` at that `N`; the table's `1.0000024422`, `1.0000024432`, `1.0000024431` are copied exactly.
- The register also notes "Nothing here about RH".
