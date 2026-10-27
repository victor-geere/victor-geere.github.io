# T3 — corrected θ / functional-equation identity for `ζ`

**Kind:** Claim
**Status:** VERIFIED (numerical — reproduces `ζ` at the tested points to `3.4e-48`…`5.68e-69`; the corrected identity replaces the brief's algebraically wrong formula)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/checks/06-numerical-checks.md`](../../research/twin-prime-parity/checks/06-numerical-checks.md) — § rh044, "Headline numbers", T3 (lines 299–315) and "What it establishes" (lines 339–352)

## Statement

> T3 — θ / functional equation. The corrected identity
> `π^{−s/2}Γ(s/2)ζ(s) = 1/(s(s−1)) + ½[A(s)+A(1−s)]`,
> `A(s)=∫_1^∞ x^{s/2−1}(θ(x)−1)dx`, reproduces ζ at the tested points:
>
> | s | `|ζ_θ(s) − ζ(s)|` (round, X=40) | auditor (own θ route, X=34) |
> |---|---|---|
> | 2 | 2.6708e-55 | 5.679e-69 (series remainder bound 5.707e-69) |
> | 4 | 3.3698e-53 | 1.784e-68 (bound 1.793e-68) |
> | ½ + i·14.134725141734693 | 3.3105e-52 | 1.035e-64 (bound 1.042e-64) |
> | ½ + i·21.022039638771555 | 6.0056e-50 | — |
> | ½ + i·25.010857580145688 | 2.2357e-48 | — |
>
> Rigorous tail: `X_min = 25` for a bound `< 1e-30`; the script uses `X=40`; self-consistency `X=30` vs `X=50` differs by `1.7238e-38`. The brief's stated formula was tested and fails at `s=2` by `|brief − ζ(2)| = 0.0977365` (`smoothed_zeta.log`; independently `|diff| = 0.09774`, `0.4463` at `s=4`, `0.1417` at the zero, in `rh044/verify/independent_check.log`).

## Hypotheses and notation

- `θ(x) = Σ_{n≥1} e^{−πn²x}` is the Jacobi theta function; `A(s)=∫_1^∞ x^{s/2−1}(θ(x)−1)dx`.
- `ζ_θ(s)` denotes the right-hand side `1/(s(s−1)) + ½[A(s)+A(1−s)]`, i.e. the completed zeta via the θ route.
- `X` is the truncation height of the θ integral (script uses `X=40`; auditor `X=34`); `X_min = 25` is the height at which the rigorous tail bound is `< 1e-30`.
- `mpmath` 1.3.0; 120 dps for the round's θ route, 160 dps for the auditor's.

## Proof / evidence

- `rh044/smoothed_zeta.py` → `rh044/verify/smoothed_zeta.log`; auditor `rh044/verify/independent_check.py` → `independent_check.log` with the auditor "rebuilding the incomplete `Γ` by its own series **and** its own quadrature (mutual agreement to `2.65e-163`) and the θ integral by its own quadrature (agreement to `1.83e-69`)".
- The register's "What it establishes": "The auditor's θ identity is verified **without `mpmath`'s `zeta` and without `mpmath`'s incomplete Γ**: own series, own quadrature, mutual agreement `1.8e-69`, series tail bound `5.7e-69`."
- The brief's competing formula is refuted numerically (register's *Corrections* item 6: "The brief's θ formula is also wrong: at `s=2` it returns `ζ(2) − 0.0977365`").

## Dependencies and related results

- T1, T2 of the same register section; the register's *Corrections* item 6.
- The same θ / functional-equation route is what reaches `o(N^{−A})` (error `e^{−πX}`) where no smoothing weight does.

## Notes

- The word "corrected" belongs to the source: the identity is stated as the correction of the round brief's formula, which "is algebraically wrong and was re-derived" (register's "What it establishes").
- The identity is the standard completed-zeta relation; this file records it as the source states it, with the source's accuracy figures. It is not claimed by the source to be a new theorem.
