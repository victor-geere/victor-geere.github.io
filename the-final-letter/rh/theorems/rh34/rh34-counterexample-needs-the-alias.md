# The counterexample needs the alias: a modulation has nowhere to stand unwrapped

**Kind:** Claim
**Status:** VERIFIED (numerical; evidence absent; the source is prose only, no committed evaluator)
**Area:** rh-html
**Source:** [`rh34.html`](../../html/rh34.html) — §5 "What the fold cost"

## Statement

> It bought something else. rh33 killed the quadrature lemma by modulating the weights at frequency n−1 in the *wrapped angle*: on the crystal that gives ρ = 1 − ε/2 exactly, driving the constant from 1 to 0.550 at ε = 0.9. The modulation could be placed at any frequency, because the fold makes every frequency below n available.

> Unwrapped, it has nowhere to stand. Apply the same ε = 0.9 modulation to the measure itself — W → W(1 + ε cos(v<sub>0</sub>γ)) — and the worst it achieves is a factor 0.707, at v<sub>0</sub> = log 2. The other gear rates cost between 8% and 29%. The four non-gear frequencies tried cost as little as 4.3%.

> The mechanism is not subtle: the only frequencies that couple to G are its own sampling points, and those are the gears. A modulation at a frequency that is not some log m has nothing to resonate with. rh33's counterexample was not a fact about atomic measures; **it was a fact about aliasing**, and it needed the fold to exist.

## Hypotheses and notation

- The modulation is W → W(1 + ε cos(v<sub>0</sub>γ)) with ε = 0.9, applied to the measure; γ runs over the ordinates.
- "On the crystal" is the mirrored lattice where rh33's counterexample was constructed; ρ = 1 − ε/2 there.
- The frequencies that couple to G are its own sampling points, the gear rates log m; four further non-gear frequencies were tried.

## Proof / evidence

Numerical, eleven frequencies: the wrapped modulation drives the constant from 1 to 0.550 at ε = 0.9; unwrapped, the worst factor is 0.707 at v<sub>0</sub> = log 2, the other gear rates cost 8–29%, and the four non-gear frequencies cost as little as 4.3%. The reading is the resonance argument: only the gear rates couple.

## Dependencies and related results

- [rh34-unwrapped-gram-and-dirichlet-polynomial](rh34-unwrapped-gram-and-dirichlet-polynomial.md) — G, the matrix the search is run on.
- rh32's quadrature lemma and rh33's refutation of it — the lemma this section reopens on G rather than revives.
- [rh35-quadrature-lemma-refuted-on-g](../rh35/rh35-quadrature-lemma-refuted-on-g.md) — the real search rh34 did not run, which kills the lemma on G as well.

## Notes


- The section's conclusion is explicitly *not* a revivial of the lemma: the source says the lemma it killed "is not dead in the unwrapped setting, merely unproven there", and that any future attempt should be made on G rather than on T<sub>n</sub>.
- rh35 §4 then refutes the lemma on G too by a search; this section's hand-tried eleven frequencies are superseded by that search.

- **Evidence absent (session-003 audit repair 3, 2025-10-06).** No script, log or other evaluator is named in the document or in the source it was harvested from. The number(s) above therefore rest on the source's prose alone: nothing committed in this repository computes them. The label carries `evidence absent` for that reason and for no other — it is **not** a claim that the result is wrong, and it is **not** a demotion of the mathematics. It is the qualifier the archive already uses well elsewhere: `research/twin-prime-parity/checks/06-numerical-checks.md:378` discloses in the same spirit that `explicit_formula.log` "DOES NOT EXIST".
