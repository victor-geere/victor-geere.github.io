# L1 — the one-sided cut (rh17 §1)

**Kind:** Lemma
**Status:** CITED (literature, rh17 §1)
**Area:** rh-html
**Source:** [`rh27a.html`](../../html/rh27a.html) — §2 "(a) A bigger cut needs no new error analysis", "L1 is about the range, and it is one-sided"

## Statement

> rh17 §1 states two lemmas and uses each once. L1: ψ̃(r) = Re ψ(¼ + ir/2) − ln π is positive past r₊ = 6.289836, so the archimedean tail beyond any cut R ≥ r₊ is a positive combination of cosine kernels — positive semidefinite, "and never needs a bound at all".

And, made precise on the object the certificate uses:

> ψ̃ crosses zero at r₊ = 6.289836 — a whisker above 2π = 6.283185 — and increases thereafter, so for J ≥ r₊/H every term dropped from the sum is a nonnegative multiple of cos(jHv), and the dropped part of the row is a positive semidefinite Toeplitz form. Truncating lowers λ<sub>min</sub> and can never raise it. rh26 §3 used this to explain why the cut at 600 manufactured false negatives; the same sentence, read forwards, says that any J at all gives a valid lower bound, and a larger J gives a better one.

## Hypotheses and notation

- ψ̃(r) = Re ψ(¼ + ir/2) − ln π.
- r₊ = 6.289836, the numerically located zero of ψ̃; 2π = 6.283185.
- R is the cut of the archimedean integral; J is the last trapezoid index retained; H = 0.05 is the step in the trapezoid sum (1) of rh27a.
- The archimedean weight in the kernel is (1/π)∫<sub>0</sub><sup>∞</sup> |ĥ(r)|² ψ̃(r) cos(rv) dr, approximated by (H/π) Σ<sub>j=0</sub><sup>J</sup>″ |ĥ(jH)|² ψ̃(jH) cos(jHv), the double prime being the trapezoid's half-weight at the ends.

## Proof / evidence

The source quotes the lemma from rh17 §1 and says "rh17 proved both halves and never put them together". It reports that "every one of the 96,001 interval nodes of the AT table is verified nonnegative past r₊, which is L1 made concrete on the object the certificate actually uses". No independent proof is given in rh27a.

## Dependencies and related results

- rh17 §1 lemma L1 — the cited original; also quoted by rh26 ([rh26-one-sided-cut](../rh26/rh26-one-sided-cut.md)).
- Its companion [rh27a-l2-aliasing-bound](rh27a-l2-aliasing-bound.md) is the other half of the pair.
- rh27a's corollary [rh27a-bigger-cut-same-theorem](rh27a-bigger-cut-same-theorem.md) combines L1 and L2.

## Notes

- The statement is quoted from rh27a's abstract, which paraphrases rh17; rh26 §3 quotes rh17's own words ("ψ̃(r) = Re ψ(¼ + ir/2) − ln π > 1.10 for r ≥ 20 …").
- Status is CITED (literature) because rh27a cites rh17 rather than proving L1 here.
