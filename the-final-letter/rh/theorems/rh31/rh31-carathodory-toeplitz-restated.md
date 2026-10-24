# Theorem (Carathéodory–Toeplitz, restated)

**Kind:** Theorem
**Status:** CITED (literature — Carathéodory–Toeplitz; restated with proof)
**Area:** rh-html
**Source:** [`rh31.html`](../../html/rh31.html) — §2 "The uniform content", boxed statement at lines 346–355

## Statement

> **Theorem (Carathéodory–Toeplitz, restated).** λ<sub>min</sub>(T<sub>n</sub>) is the largest c such that the row (E<sub>h</sub>(0) − c, E<sub>h</sub>(Δ′), …, E<sub>h</sub>((n−1)Δ′)) is still the moment sequence of a positive measure. *Proof:* T<sub>n</sub> − cI is Toeplitz with exactly that row; a Toeplitz matrix is PSD iff its row is a truncated moment sequence (Carathéodory–Toeplitz); and the largest c with T<sub>n</sub> − cI ⊰ 0 is λ<sub>min</sub> by definition. ∎

The source's measure-picture reading of it:

> λ<sub>min</sub> is the uniform content of μ at resolution n — the largest amount of uniform measure μ can shed, μ ≈ λ·U + ν, and still present the same first n moments with a positive remainder ν. Szegő (rh29 §4) is the n → ∞ limit: an atomic measure has no uniform part, so the content drains to zero.

## Hypotheses and notation

- T<sub>n</sub> is the Toeplitz section with row (E<sub>h</sub>(0), E<sub>h</sub>(Δ′), …, E<sub>h</sub>((n−1)Δ′)); I is the identity.
- "PSD" means positive semidefinite; ⊰ 0 denotes positive semidefiniteness in the source's notation.
- U is the uniform measure; λ·U + ν is the decomposition with positive remainder ν.

## Proof / evidence

The source gives a one-paragraph proof (reproduced verbatim above) reducing the statement to the classical Carathéodory–Toeplitz theorem on truncated moment sequences. The source states the theorem is classical and holds for any positive-definite Toeplitz matrix: "Two things are not [conditional on RH]: the theorem of §2 is classical and holds for any positive-definite Toeplitz matrix".

## Dependencies and related results

- [rh31-minimal-witness-measure](rh31-minimal-witness-measure.md) — the constructive witness at c = λ<sub>min</sub>.
- [rh29-lambda-min-tends-to-zero](../rh29/rh29-lambda-min-tends-to-zero.md) — the n → ∞ limit (Szegő).
- [rh32-void-identity](../rh32/rh32-void-identity.md) — reuses the same Toeplitz/PSD fact on the punctured crystal.

## Notes

- Status is CITED (literature) because the content is the classical Carathéodory–Toeplitz theorem; the document's contribution is the restatement in the row/eigenvalue language and the uniform-content reading.
- The source explicitly marks this as one of the two results in the document that do not depend on RH.
