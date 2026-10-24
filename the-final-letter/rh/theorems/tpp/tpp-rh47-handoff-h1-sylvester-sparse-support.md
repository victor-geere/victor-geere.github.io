# H1 — the greedy support is Sylvester-sparse (the round's own new theorem)

**Kind:** Theorem
**Status:** PROVED (paper argument; the numerical legs — `max A ≥ s₂₀`, the density, the controls — are VERIFIED)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh47/HANDOFF.md`](../../research/twin-prime-parity/rounds/rh47/HANDOFF.md) — §3 "What this round verifies (done — 23/23 probe, 31/31 audit)", item **H1**, line 90

## Statement

> **H1 (new theorem, the round's own result).**  The greedy support is
> **Sylvester-sparse**: `m_{i+1} ≥ m_i(m_i−1)+1`, so `|A| ≥ 20 ⟹ max A ≥ s₂₀`
> (106 721 digits) and the density is `3.9·10⁻⁵`.  The specified parity test has an
> **empty domain**; the relaxed version's nominal `z = −47.9` is killed by positional
> (`z = +0.43`) and rank-matched (`z = +1.55`) controls.

## Hypotheses and notation

- The greedy support `A = {m₁ < m₂ < …}` of the greedy harmonic-sine word; `m_i` its `i`-th element.
- `s₂₀` is the 20th Sylvester-sequence term; `λ(n) = (−1)^{Ω(n)}` is the Liouville function.
- The "specified parity test" is the `|A| ≥ 20` test; the "relaxed version" is the `|A| ≥ 4` diagnostic.

## Proof / evidence

The HANDOFF labels H1 the round's new theorem and states it as verified by the reconnaissance: the probe [`greedy_parity_probe.py`](../../research/twin-prime-parity/rounds/rh47/greedy_parity_probe.py) gives **23/23 checks**, exit 0, and the audit `verify/independent_check.py` gives **31/31 checks**, exit 0. The residual argument (`r < 1/(m_i(m_i−1))` after taking `1/m_i`) is the proof of the sparse inequality; the digit count, density and control `z`-values are numerical.

## Dependencies and related results

- [truths.md §1](tpp-rh47-truths-sylvester-sparse-support.md), [the `max A ≥ s₂₀` consequence](tpp-rh47-truths-max-support-sylvester-bound.md), [the density consequence](tpp-rh47-truths-support-density-3-9e-5.md) — the full account.
- [README §1.5](tpp-rh47-readme-sylvester-sparse-support.md) — the README's restatement.
- [B1](tpp-rh47-handoff-bridge-b1-no-mechanism-known.md) — the bridge the sparsity disposes of.
- Earlier ledger row: [the support is Sylvester-sparse](tpp-dict-00-sylvester-sparse-support.md).

## Notes

- The source calls H1 "new theorem, the round's own result"; the sparse inequality is proved on paper, while the `106 721 digits`, the density `3.9·10⁻⁵` and the control values are numerical.
- The HANDOFF notes that "What remains for `rh47` itself: the corrected sparse bound `≤ 4·#{m ≤ x+2 : m ∈ A}`, and the *negative* statement R2 below (which is the round's real ambition and is OPEN)".
