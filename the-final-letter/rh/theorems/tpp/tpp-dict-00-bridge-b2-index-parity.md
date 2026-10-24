# bridge B2: the ζ budgets split index parity, not `Ω`-parity

**Kind:** Theorem
**Status:** VERIFIED (numerical, `χ²=2.94`; source calls it "THEOREM-adjacent")
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/dictionary/00-dictionary.md`](../../research/twin-prime-parity/dictionary/00-dictionary.md) — "Index. F — the parity obstruction and the programme's barriers (rh46, rh47)", row F7, line 109

## Statement

The ledger row, verbatim:

> | F7 | **bridge B2**: the ζ budgets split *index* parity, not `Ω`-parity | THEOREM-adjacent + NUMERICAL (`χ²=2.94`) | rh47 §2 |

## Hypotheses and notation

- The **ζ budgets** are `P(p)` and `N(p)` ([C1](tpp-dict-00-positive-budget.md), [C2](tpp-dict-00-negative-budget.md)).
- "*index* parity" is the parity of the summation index (even vs odd `k`); "`Ω`-parity" is the parity of the number of prime factors with multiplicity, i.e. the sign of `λ`.
- The ledger's evidence figure is `χ² = 2.94` (quoted exactly, `χ²=2.94`), and its status field is the non-vocabulary phrase **"THEOREM-adjacent"**, preserved in the harvest qualifier.

## Proof / evidence

The ledger records `THEOREM-adjacent + NUMERICAL (χ²=2.94)` with source `rh47 §2` and gives no proof. The capstone chapter disposes of the corresponding bridge claim with the same statistic: [B2 — the ζ budgets carry Ω-parity information (refuted)](tpp-dict-05-b2-zeta-budgets-omega-parity-refuted.md), quoting `χ²(1) = 2.944` and `S(λ·(−1)^n) = S(λ)` exactly.

## Dependencies and related results

- [C1](tpp-dict-00-positive-budget.md), [C2](tpp-dict-00-negative-budget.md), [C3](tpp-dict-00-budget-relations.md).
- [F6 — bridge B1](tpp-dict-00-bridge-b1-no-parity-signal.md) and [F8 — bridge B3](tpp-dict-00-bridge-b3-zeta-machinery.md) are the other two bridges.
- The dictionary's three-line summary (item 1) cites "budgets, completeness, parity lock — is a structure of *indices*, not of factorisations (C1–C8, F7)".

## Notes


- Ledger entry restating round **rh47** (§2).
- The source's own status phrase "**THEOREM-adjacent**" is not one of the spec's status terms; the harvested status is the honest numerical one, with the source's phrase kept in the qualifier. It must not be read as a proof.
- The statistic appears as `χ²=2.94` here and as `χ²(1) = 2.944` in the capstone chapter (the same test, quoted at the precision each source gives).
- **Correction to a correction (session-003 audit, 2025-10-06).** The `evidence absent` qualifier that briefly stood here was **false** and has been reversed: a committed artefact does compute the numbers above — `research/twin-prime-parity/rounds/rh47/verify/greedy_parity_probe.log`. The qualifier was assigned by a mechanical rule that looked only at this document and at the source it was harvested from, and only for artefact names, so it missed evaluators kept elsewhere in the tree. The original label is restored, unqualified. See `AUDIT-verification-labels-002.md` §6.
