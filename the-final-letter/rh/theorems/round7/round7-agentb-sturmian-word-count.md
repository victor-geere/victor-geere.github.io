# A Sturmian word of slope b has #ones(N) = bN + O(1)

**Kind:** Theorem
**Status:** CITED (literature, classical Sturmian counting)
**Area:** workspace
**Source:** [`round7_agentB.md`](../../research/various/round7_agentB.md) — §(4) "THE REFUTED DENSITY — POST-MORTEM", lines 40–42

## Statement

> A Sturmian word of slope b=theta/pi has #ones(N) = bN + O(1) — LINEAR, not (theta/pi)log N.
> At N=20000: Sturmian predicts 2026 (1/pi), 4413 (log2), 2637 (sqrt2-1); the retracted formula
> predicts 1.00, 2.19, 1.31.

## Hypotheses and notation

- b = θ/π is the slope of the Sturmian word; #ones(N) counts the 1s among the first N letters.
- The numerical comparison is at N = 20000 for the targets 1/π, log 2 and √2−1; the "retracted formula" is (θ/π) log N.

## Proof / evidence

The source states the classical linear count for Sturmian words and uses it as a yardstick: at
N = 20000 the Sturmian prediction is 2026 (1/π), 4413 (log 2), 2637 (√2−1), while the retracted
formula gives 1.00, 2.19, 1.31. No proof of the Sturmian count is given in the document.

## Dependencies and related results

- [round7-agentb-decreasing-threshold-density-refuted](round7-agentb-decreasing-threshold-density-refuted.md) — the refutation of the retracted density formula using this comparison.
- [round7-agentb-p-l-saturates-by-gaps](round7-agentb-p-l-saturates-by-gaps.md) — the companion finding that the greedy word is not Sturmian.

## Notes

- Status CITED (literature): the count law is classical and the source uses it only as a comparison
  standard; the workspace did not prove it.
- The three Sturmian predictions 2026, 4413, 2637 and the three retracted-formula values 1.00, 2.19,
  1.31 are quoted exactly.
