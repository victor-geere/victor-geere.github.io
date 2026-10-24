# The chain still closes: |P<sub>400</sub>| = 0.024988, and the un-alternated ζ train diverges like √N

**Kind:** Claim
**Status:** VERIFIED (numerical; evidence absent; the source is prose only, no committed evaluator)
**Area:** rh-html
**Source:** [`rh38.html`](../../html/rh38.html) — §6 "The chain still closes"

## Statement

> Checked on the way past, because a construction whose train did not converge would make everything above beside the point. It converges.

> The terms are n<sup>−σ</sup> and go to zero for every σ &gt; 0 — 10<sup>−4</sup> at the hundred-millionth gear, with nothing about a zero involved. The alternating partial sums close on 0 at s = ½ + iγ<sub>1</sub>: |P<sub>400</sub>| = **0.024988**, which is the 0.0250 rh3's Figure 3 caption prints, still falling at 4000, and |η(½ + iγ<sub>1</sub>)| = 2.3×10<sup>−15</sup> by Borwein at thirty-two terms. The prefactor |1 − 2<sup>1−s</sup>| = 2.3737 is finite and non-zero, so a zero of ζ is a zero of η and the construction sees it.

> One readout deserves a note because it reads alarming out of context. With the half-turns *off*, Figure 2 reports *"grows like √N; it does not converge for σ ≤ 1"*. That is the un-alternated ζ train, exactly as rh3 §9 describes it, and the claim is correct: the partial sums reach **7.0705** at N = 10<sup>4</sup> against the predicted √N/|1 − s| = 7.0704, and multiply by 1.99996 when N quadruples. It is what the half-turns buy, stated as a divergence. With them on — the default — the chain closes.

## Hypotheses and notation

- Terms n<sup>−σ</sup>; s = ½ + iγ<sub>1</sub>; P<sub>N</sub> the alternating partial sums; η the Dirichlet eta function.
- The prefactor is |1 − 2<sup>1−s</sup>| = 2.3737; Borwein's acceleration is used at thirty-two terms.
- "Half-turns off" means the un-alternated ζ train.

## Proof / evidence

Numerical: terms 10<sup>−4</sup> at the hundred-millionth gear; |P<sub>400</sub>| = 0.024988 (rh3's caption prints 0.0250), still falling at 4000; |η(½ + iγ<sub>1</sub>)| = 2.3×10<sup>−15</sup> by Borwein at thirty-two terms; the un-alternated train reaches 7.0705 at N = 10<sup>4</sup> against the predicted 7.0704 and multiplies by 1.99996 on quadrupling N.

## Dependencies and related results

- [rh38-uniform-lift-definition](rh38-uniform-lift-definition.md) — the half-turns/torsion bookkeeping this section checks.
- rh3 §9 — the un-alternated divergence; rh3's Figure 3 caption value 0.0250.
- rh29's table is not used here; §6 uses γ<sub>1</sub> and the η–ζ identity and is unconditional.

## Notes


- The source says the alarming readout is correct as a statement about the un-alternated train, and is what the half-turns buy; it is not a defect of the construction.
- The convergence statement is about the alternating partial sums at s = ½ + iγ<sub>1</sub>, not a proof of convergence for all s in the strip.

- **Evidence absent (session-003 audit repair 3, 2025-10-06).** No script, log or other evaluator is named in the document or in the source it was harvested from. The number(s) above therefore rest on the source's prose alone: nothing committed in this repository computes them. The label carries `evidence absent` for that reason and for no other — it is **not** a claim that the result is wrong, and it is **not** a demotion of the mathematics. It is the qualifier the archive already uses well elsewhere: `research/twin-prime-parity/checks/06-numerical-checks.md:378` discloses in the same spirit that `explicit_formula.log` "DOES NOT EXIST".
