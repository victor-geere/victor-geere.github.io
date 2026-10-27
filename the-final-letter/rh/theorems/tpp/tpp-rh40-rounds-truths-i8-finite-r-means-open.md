# I8 — the finite-r means are not −1 (no convergence claim either way)

**Kind:** Claim
**Status:** **SETTLED (2026-10-11 attack; OP-33).** (a) **PROVED** (Lean, `Rh42.step_bound`, `rounds/rh42/lean/Rh42/PrecisionFloor.lean`, axiom-clean): if `r_0 ≤ 1/10`, `r_{k+1} ≤ r_k²` and `10^{−D} < r_{K−1}` then `2^{K−1} ≤ D`, so `D` digits reach only `K ≤ log₂ D + 1` steps — the source's `7–13 steps before underflow` is a theorem, not a bug. (b) Means of `log c_k` over `10⁴` prescribed steps converge to the mean of `log α_k` (`1/2→−0.6931`, `1/4→−1.3863`, `1/10→−2.3026`); **none is `−1`** — the source's claim is confirmed but re-attributed (no universal limit exists; the finite-`K` mean is strictly below the `s`-mean by the un-decayed gap `Γ_K/K`). See `research/attacks/OP-28-30-33.md`.
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/rounds/truths.md`](../../research/twin-prime-parity/rounds/rh40/rounds/truths.md) — §I "Verified constants", register row I8

## Statement

> The finite-`r` means are **not** `−1`; but this was measured on runs of only 7–13 steps before underflow, so no convergence claim follows either way

## Hypotheses and notation

- "Finite-`r` means" are the running averages of the residual-orbit steps at finite residual.
- Underflow is the precision limit quantified by register rows I5/I6.

## Proof / evidence

Register row I8's evidence cell reads: "`probes.py` probe 5; limited by I6".

## Dependencies and related results

- Register rows I4 (the integral is exactly `−1`), I5, I6, I7, K6f.
- [The residual-orbit limit depends on x (the handoff's universal limit is refuted)](tpp-rh40-k-remaining-theorem-limit-depends-on-x.md).

## Notes

- The row is explicitly left `OPEN`: the source refuses to read either convergence or divergence out of 7–13 usable steps.
