# Theorem 5 (closed forms)

**Kind:** Theorem
**Status:** PROVED (Lean, no sorry)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh42/truths.md`](../../research/twin-prime-parity/rounds/rh42/truths.md) — §2 "The budgets and their algebra"

## Statement

> `P(2) = π²/24`, `N(2) = π²/8 − 1`,
> `P(4) = π⁴/1440`, `N(4) = π⁴/96 − 1`, and `P(2) + N(2) = π²/6 − 1`.

## Hypotheses and notation

- `P(p) = Σ_{k≥1} (2k)^{−p} = 2^{−p} ζ(p)` (positive budget).
- `N(p) = Σ_{k≥1} (2k+1)^{−p} = (1 − 2^{−p}) ζ(p) − 1` (negative budget).
- `π²` and `π⁴` are the squares of pi.

## Proof / evidence

> **PROVED in Lean** — [`lean/Rh42/Budget.lean`](../../research/twin-prime-parity/rounds/rh42/lean/Rh42/Budget.lean) proves all
> nine statements from Mathlib's `hasSum_zeta_two` and `hasSum_zeta_four` by
> splitting the `ζ` series into its even and odd parts
> (`tsum_even_add_odd`, `Summable.comp_injective`), with no `sorry`. Numerically
> verified to `1e−40`.

The reproduction section (§12) confirms the Lean development: `lean/Rh42/Budget.lean` carries the budget closed forms `P(2) = π²/24`, `N(2) = π²/8 − 1`, `P(4) = π⁴/1440`, `N(4) = π⁴/96 − 1`, `P(2)+N(2) = π²/6 − 1`, from Mathlib's `hasSum_zeta_two/four` by even/odd splitting; `./check.sh --all` reports 4/4 modules OK, exit 0, no `sorry`, no new axiom.

## Dependencies and related results

- Mathlib: `hasSum_zeta_two`, `hasSum_zeta_four`, `tsum_even_add_odd`, `Summable.comp_injective`.
- Theorem 2 supplies the algebra `P+N = ζ−1`, `P−N = 1−η` used to reach the closed forms.
- Handoff ledger row T2 (§11) records the Lean coverage at `p = 2, 4`.

## Notes

- The Lean file proves "all nine statements"; the five identities above are the ones stated in the theorem sentence.
- The supporting numeric table of §2 gives, at `p = 2`: `ζ(2) = 1.644934`, `P(2) = 0.411234`, `N(2) = 0.233701`, `P+N = 0.644934` — consistent with `P(2) = π²/24`, `N(2) = π²/8 − 1`. The §5 table gives `P(4) = 0.0676452`.
