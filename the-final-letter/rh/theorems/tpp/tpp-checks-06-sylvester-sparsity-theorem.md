# The Sylvester-sparsity theorem

**Kind:** Theorem *(so labelled by the source: "The Sylvester-sparsity theorem (the round's one new exhaustive statement)")*
**Status:** PROVED (paper argument — the source calls it "the rigidity lemma"; VERIFIED numerically, 0 violations in 53 159 consecutive pairs over 20 320 supports)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/checks/06-numerical-checks.md`](../../research/twin-prime-parity/checks/06-numerical-checks.md) — § rh47, "Headline numbers" (lines 619–624) and "What it establishes" (lines 684–695, 710–711)

## Statement

> The Sylvester-sparsity theorem (the round's one new exhaustive statement): `m_{i+1} ≥ m_i(m_i−1)+1`, **0 violations in 53 159 consecutive pairs over 20 320 supports**. Consequences: `|A| ≥ 20 ⇒ max A ≥ s_20`, which has **106 721 decimal digits** (`s_6 = 3263443`; `s_7 = 10650056950807` has 14 digits; `s_8` has 27). The ladder `x_k = (s_{k+1}−2)/(s_{k+1}−1)` realises `|A| = k` exactly, so the size class is non-empty but uncomputable.

The register's own assessment:

> The **Sylvester-sparsity ceiling is a proof** (the rigidity lemma), and it is the only logically exhaustive statement in the round. It is a statement about the greedy object, not about primes.

## Hypotheses and notation

- `A = {m_1 < m_2 < …}` is the support of the greedy harmonic sine's selected indices, listed increasingly; `m_i` is its `i`-th element.
- The `s_k` are the Sylvester sequence terms (`s_6 = 3263443`, `s_7 = 10650056950807`, `s_20` having 106 721 decimal digits).
- `x_k = (s_{k+1}−2)/(s_{k+1}−1)` is the explicit ladder realising `|A| = k`.
- "Support" and "target" are the greedy object's support set and the rational target it is run against; the supports are computed with exact `Fraction` greedy/`ceil`-chain arithmetic cross-checked against the literal step-by-step rule, with a big-integer Sylvester sequence to `s_21`.

## Proof / evidence

- Stated by the register as "the round's one new exhaustive statement" and as a proof ("the rigidity lemma"), with the numerical evidence "0 violations in 53 159 consecutive pairs over 20 320 supports".
- `rh47/greedy_parity_probe.py` → `greedy_parity_probe.log`, whose current summary is **`23 checks pass, 0 fail (wall clock 3.5 s)`** (confirmed by re-running the on-disk script in a scratch copy); auditor `rh47/verify/independent_check.py` → `independent_check.log` (**`RESULT: 31/31 checks pass`**), described by the register as reproducing "rigidity, parity lock, density".
- `rh47` has **no Lean layer**: "`rh47/lean/Rh47/` is **empty**, there is no `rh47/verify/lean_check.log`".

## Dependencies and related results

- The corrected sparse-modification bound of the same register; the two together give that a sparse `A` moves `S` by `o(x)`.
- `OP-12` in [`07-open-problems.md`](../../research/twin-prime-parity/open/07-open-problems.md): the corrected bound and the empty `rh47` Lean layer.
- Ledger row `T18` ("the greedy support is Sylvester-sparse", `m_{i+1} ≥ m_i(m_i−1)+1`, hence `A(N) = O(log log N)`) of the dictionary source.

## Notes

- The statement is about the greedy object only: "It is a statement about the greedy object, not about primes", and "The Sylvester ceiling says a large-support target is uncomputable, not that no parity signal could exist in principle."
- The register does not reproduce the proof of the rigidity lemma; only its name ("the rigidity lemma") and the numerical violation count are given. The register's evidence line is the exhaustive numerical check.
