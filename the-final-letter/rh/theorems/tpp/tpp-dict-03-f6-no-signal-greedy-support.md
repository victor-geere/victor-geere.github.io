# F6 — no signal in the greedy support (bridge B1)

**Kind:** Claim
**Status:** REFUTED (numerically, with controls)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/dictionary/03-parity-problem.md`](../../research/twin-prime-parity/dictionary/03-parity-problem.md) — §6, barrier table row F6; bridge **B1** in §5.4

## Statement

> **F6** — no signal in the greedy support: see §5.4 (B1). Status: REFUTED (numerically, with controls).

The bridge row states the claim that was refuted:

> **B1** (`F6`): the greedy **support** carries `λ`-parity signal — REFUTED (no signal).

## Hypotheses and notation

- The greedy support is the support `A` of the signed greedy support of [`02-greedy-harmonic-sine.md`](../../research/twin-prime-parity/dictionary/02-greedy-harmonic-sine.md) Theorem 2.3 and `rh47/truths.md` §1; the greedy harmonic sine's take rule is parity-blind *and* arithmetic-free (Definition 1.11).
- `z` is the reported test statistic; `p` the reported p-value; "targets" are the 8 820 tested targets.
- `m = 2` refers to the multiplicity of repeated positions in supports.

## Proof / evidence

- Numerical refutation with controls (source, §5.4): nominal `z = −47.9` on 8 820 targets, killed by positional sign-permutation (`z = +0.43`, `p = 0.66`) and rank-matched (`z = +1.55`, `p = 0.12`) controls; the nominal signal was an artefact of repeated positions (`m = 2` in 70.5 % of supports). The take rule reads the target alone — no arithmetic input.
- Source of the evidence: `rh47` §2 (`rh47/greedy_parity_probe.py`, 23/23 checks per Appendix C).

## Dependencies and related results

- [Corollary 6.1](tpp-dict-03-corollary-6-1-greedy-support-loglog.md) (why the greedy support is quantitatively useless here); [F7](tpp-dict-03-f7-index-parity-invisible.md) and [F9](tpp-dict-03-f9-corrected-barrier.md) (the companion barrier rows).
- Definition 1.11 (parity-blind weight / rule); the source's index tag `F6`; register entries OP-3, OP-18.
- Restated as barrier-row `F6` in the §7 ledger row "6 (F6–F8)".

## Notes

- The **claim** is refuted, not proved: the row records that the greedy support carries no `λ`-parity signal. The refutation is numerical (with controls), not a Lean proof.
- Appendix B records `rh47/greedy_parity_probe.py` as "23/23 checks (bridges B1-B3)".
