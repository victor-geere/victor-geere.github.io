# The crossing form: signature (25, 0, 0)

**Kind:** Theorem
**Status:** VERIFIED (numerical; evidence absent; the source is prose only, no committed evaluator)
**Area:** rh-html
**Source:** [`rh13.html`](../../html/rh13.html) — §3 "The crossing form: the pairing as a matrix, diagonalized", equation (1)

## Statement

> G[j,k] = W(f<sub>j</sub> ⸱ f<sub>k</sub>) = h<sub>jk</sub>(*i*/2) + h<sub>jk</sub>(−*i*/2) + (1/2π)∫ h<sub>jk</sub>[Re&#8202;ψ − ln π] d*r* − 2∑<sub>*n*</sub> (Λ(*n*)/√*n*) (f<sub>j</sub>&#8202;⋆&#8202;f<sub>k</sub>)(log *n*)
>
> — from **primes and the Γ-factor alone**, no zero consulted — and, independently, the same matrix from the 1517 zeros. The two agree across all 325 entries to 8.7×10<sup>−5</sup> of the largest … Then diagonalize.

and then:

> What the computation delivers is the theorem's **finite shadow, verified**: on the 25-dimensional slice … the signature is (25, 0, 0). No negative direction exists down to the softest eigenvalue the instrument can resolve, and the softest direction itself is identified and understood (it is the optimal window, the matched filter of the quietest gap).

## Hypotheses and notation

- The window space is rh12's frontier: even piecewise-linear profiles on [−1.5, 1.5], each a finite ℤ-weighted bundle of scale-circle windings, consulting 12 gears (25-dimensional).
- W is the Weil pairing of rh10 §1; f<sub>j</sub> ⋆ f<sub>k</sub> is the pair's convolution; h<sub>jk</sub> its transform.
- The bottom pair of eigenvalues is 3.7×10<sup>−8</sup> (arithmetic side) against 2.6×10<sup>−8</sup> (zeros side), below the entrywise noise bound 2.2×10<sup>−4</sup> but on the same side of zero.

## Proof / evidence

The source reports both computations and their agreement: the arithmetic-side matrix (primes and the Γ-factor alone) against the zeros-side matrix, all 325 entries to 8.7×10<sup>−5</sup> of the largest — "the arc's first *off-diagonal* explicit-formula identities, three hundred twenty-five of them at once" — then diagonalisation: every eigenvalue positive across seven decades, signature (25, 0, 0), bottom eigenvectors matching in order and direction, the softest eigenvector equal to rh12's optimal window with overlap 0.94. The closing audit adds the noise bound: "both Jacobi eigenspectra with the zeros side positive-definite by construction and the arithmetic side positive throughout, bottom eigenvalues 2.6×10⁻⁸ and 3.7×10⁻⁸, perturbation noise bound 2.2×10⁻⁴ stated wherever the bottom is quoted".

## Dependencies and related results

- [The optimal-window frontier D*(a) = 1/(b₀ᵀM⁻¹b₀)](../rh12/rh12-optimal-window-frontier.md) — the space and the extremal window.
- [The incidence numbers are the von Mangoldt weights](rh13-incidence-numbers-are-von-mangoldt.md) — the entries' arithmetic origin.
- [The Castelnuovo ledger, and every minor](rh13-castelnuovo-ledger-and-minors.md) — the minors of this matrix.
- [Weil positivity: W(h) ≥ 0 for every h = |f̂|²](../rh10/rh10-weil-positivity-criterion.md) — the criterion whose finite shadow this is.

## Notes


- The source states the limit of the claim: "RH ⟺ this form is positive on *every* window space (Weil). A surface with a Hodge index theorem would prove that positivity wholesale." The signature (25, 0, 0) is the finite shadow, and the source says "A single negative eigenvalue here, robust above noise, would have refuted the hypothesis this afternoon."

- **Evidence absent (session-003 audit repair 3, 2025-10-06).** No script, log or other evaluator is named in the document or in the source it was harvested from. The number(s) above therefore rest on the source's prose alone: nothing committed in this repository computes them. The label carries `evidence absent` for that reason and for no other — it is **not** a claim that the result is wrong, and it is **not** a demotion of the mathematics. It is the qualifier the archive already uses well elsewhere: `research/twin-prime-parity/checks/06-numerical-checks.md:378` discloses in the same spirit that `explicit_formula.log` "DOES NOT EXIST".
