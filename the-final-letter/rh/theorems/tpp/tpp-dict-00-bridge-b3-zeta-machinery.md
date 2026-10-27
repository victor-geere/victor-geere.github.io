# bridge B3: the `ζ`-machinery does not apply to the correlation

**Kind:** Theorem
**Status:** PROVED (paper argument; source records THEOREM + NUMERICAL)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/dictionary/00-dictionary.md`](../../research/twin-prime-parity/dictionary/00-dictionary.md) — "Index. F — the parity obstruction and the programme's barriers (rh46, rh47)", row F8, line 110

## Statement

The ledger row, verbatim:

> | F8 | **bridge B3**: the `ζ`-machinery does not apply to the correlation | THEOREM + NUMERICAL | rh47 §2 |

## Hypotheses and notation

- "The `ζ`-machinery" is the analytic apparatus built on the Euler product/Dirichlet series of `ζ` ([P1](tpp-dict-01-euler-product-and-continuation.md), [P4](tpp-dict-01-abel-partial-summation.md), [P5](tpp-dict-01-explicit-formula-rvm.md)).
- "The correlation" is `Σ_{n≤x} λ(n)λ(n+2)` ([F1](tpp-dict-00-correlation-trivial-bound.md)).
- The claim is the **negative** one: that machinery does not apply here.

## Proof / evidence

The ledger records `THEOREM + NUMERICAL` with source `rh47 §2` and gives no proof. The capstone chapter disposes of the mirror-image bridge claim as [B3 — the ζ-machinery applies to the correlation (refuted)](tpp-dict-05-b3-zeta-machinery-correlation-refuted.md), quoting the discrepancy `D(2) = −1.12681304` vs naive `0.88757352`, discrepancy `2.0144` against a tail `1.84·10⁻⁵`. The structural reason is recorded in [F3](tpp-dict-00-correlation-not-multiplicative.md): the correlation has no Euler product.

## Dependencies and related results

- [F3 — the correlation is not multiplicative](tpp-dict-00-correlation-not-multiplicative.md) is the analytic reason; [(P4) Abel/partial summation](tpp-dict-01-abel-partial-summation.md) records that the converse of the summability implication fails.
- [F6 — bridge B1](tpp-dict-00-bridge-b1-no-parity-signal.md) and [F7 — bridge B2](tpp-dict-00-bridge-b2-index-parity.md) are the other two bridges.
- [E5 — the explicit formula needs the archimedean term](tpp-dict-00-weil-explicit-formula-archimedean-term.md) is part of the `ζ`-machinery concerned.

## Notes

- Ledger entry restating round **rh47** (§2).
- The two sources state this finding from opposite directions (here: "does not apply"; in the capstone: the claim "applies" is REFUTED); both are preserved as written.
