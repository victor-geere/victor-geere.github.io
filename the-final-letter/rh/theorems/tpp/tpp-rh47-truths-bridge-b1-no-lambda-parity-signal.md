# B1 — the greedy support carries no `λ`-parity signal

**Kind:** Claim
**Status:** REFUTED (no signal; the nominal `z = −47.9` is killed by the size-matched controls)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh47/truths.md`](../../research/twin-prime-parity/rounds/rh47/truths.md) — §2, "B1 — does the greedy support carry `λ`-parity signal?  **REFUTED (no signal)**", line 46

## Statement

> ### B1 — does the greedy support carry `λ`-parity signal?  **REFUTED (no signal)**
>
> Relaxed diagnostic (`|A| ≥ 4`, elements `≤ 10¹³`, 8 820 targets): the observed mean of `λ` over the support is `−0.3006`, giving a **nominal** `z = −47.9` against a size-matched range control — a large apparent signal, which the controls kill:
>
> | control | result |
> |---|---|
> | positional sign-permutation pool (38 816 occurrences) | `z = +0.43` (p = 0.66) |
> | rank-matched slot pools | `z = +1.55` (p = 0.12); per-target 5 % rejection `0.024` |
>
> The nominal signal is an artefact of **repeated positions**: 8 820 supports use only 7 033 distinct indices, with `m = 2` appearing in 70.5 % of them — the statistic is really a statement about `λ(2) = λ(3) = λ(7) = λ(8) = −1`, `λ(4) = +1`.  The auditor's independent attempt (C3b) also found only nulls (pooled `z = −1.68, −0.72, +1.37, −0.74`), and the parity-lock route (C3c) gives match `0.4938` against chance `0.5009` at **zero** density.  **No signal survives.**

## Hypotheses and notation

- `A` is the greedy support; the relaxed diagnostic restricts to `|A| ≥ 4` with support elements `≤ 10¹³` and 8 820 targets.
- `λ(n) = (−1)^{Ω(n)}` is the Liouville function; "the observed mean of `λ` over the support" is the statistic tested.
- `z` is the standardized score against a size-matched range control.
- C3b and C3c are the auditor's independent checks in `verify/independent_check.py`.

## Proof / evidence

Numerical, by the probe [`greedy_parity_probe.py`](../../research/twin-prime-parity/rounds/rh47/greedy_parity_probe.py) → `verify/greedy_parity_probe.log` (**23/23 checks**, exit 0), audited by `verify/independent_check.py` (**31/31 checks**, exit 0). The controls are the positional sign-permutation pool (`z = +0.43`, p = 0.66) and the rank-matched slot pools (`z = +1.55`, p = 0.12; per-target 5 % rejection `0.024`); the auditor's C3b/C3c reproduce only nulls. No proof is offered, only measurement plus controls.

## Dependencies and related results

- [The greedy support is Sylvester-sparse](tpp-rh47-truths-sylvester-sparse-support.md) — the round's harness for the support statistics (`|A| ≥ 4` is the relaxed diagnostic; `|A| ≥ 20` is empty).
- [B2 — the ζ budgets carry no `Ω`-parity information](tpp-rh47-truths-bridge-b2-index-parity-independent.md) and [B3 — no Euler product](tpp-rh47-truths-bridge-b3-no-euler-product.md) — the other two bridges.
- [The corrected barrier, sign-blind alphabet with no arithmetic input](tpp-rh47-truths-corrected-barrier-open.md).
- Restated in this round with a different status wording: [README B1](tpp-rh47-readme-bridge-b1-no-signal.md) ("no signal above a size-matched control") and [HANDOFF B1](tpp-rh47-handoff-bridge-b1-no-mechanism-known.md) ("no mechanism known").
- Earlier ledger row: [bridge B1](tpp-dict-00-bridge-b1-no-parity-signal.md).

## Notes

- The status is the source's own: **REFUTED (no signal)**. The refutation is numerical (the nominal signal is an artefact of repeated positions), not an analytic impossibility theorem.
- The round's HANDOFF keeps the weaker phrasing "no mechanism known" for the same bridge; the two must not be conflated — truths.md claims the refutation, HANDOFF records the absence of a mechanism.
