# Lemma L1 carried to any window — truncating the archimedean integral drops a positive-semidefinite piece

**Kind:** Lemma
**Status:** PROVED (paper argument)
**Area:** rh-html
**Source:** [`rh22.html`](../../html/rh22.html) — §6 "The certificate, and what the gain buys"

## Statement

> Lemma L1 — that truncating the archimedean integral at R₀ drops a positive-semidefinite piece, because ψ̃ > 0 beyond r ≈ 2π — holds for *any* window, since the dropped form is (1/π)∫|ĥ|²ψ̃|Σc<sub>p</sub>e<sup>iprΔ</sup>|², so it carries over with no re-derivation.

## Hypotheses and notation

- R₀ is the truncation point of the archimedean integral.
- ψ̃ is the archimedean weight; the source's dictionary ("the digamma asymptotics behind ψ̃") and NIST DLMF §5 are the reference for it, and the standing assumption list names "libm's logarithm within one ulp".
- Σc<sub>p</sub>e<sup>iprΔ</sup> is the test-vector exponential sum at mesh Δ.
- ĥ is the transform of the composite window h of equation (1).

## Proof / evidence

The source gives the reason in one line, quoted verbatim above: the *dropped* form is a positive multiple (1/π)∫|ĥ|²ψ̃|Σc<sub>p</sub>e<sup>iprΔ</sup>|² of a non-negative integrand because ψ̃ > 0 beyond r ≈ 2π, so discarding it can only lower the section, i.e. it preserves positive semidefiniteness. The source states it as "carries over with no re-derivation" from rh17's interval kit.

## Dependencies and related results

- rh17 (interval kit, certified rows) is where the lemma originates in the arc.
- Restated identically in rh23 §5: "Lemma L1 — that truncating the archimedean integral at R₀ drops a positive-semidefinite piece — holds for any window, since the dropped form is (1/π)∫|ĥ|²ψ̃|Σc<sub>p</sub>e<sup>iprΔ</sup>|²."
- Used by [m₀ certified — (4)](rh22-certified-floors-m0.md) and by the certificate lanes of rh23 §5 ([rh23-certified-hat-n76.md](../rh23/rh23-certified-hat-n76.md)).

## Notes

- In rh22 this is a *labelled* lemma (L1) used as a rung of the certificate argument; the source supplies its one-line justification but no separate proof, and the lemma itself is inherited from rh17 rather than proved afresh here.
- The claim is stated for *any* window, which is exactly what lets the searched (non-hat) window reuse rh19's backend α unchanged.
