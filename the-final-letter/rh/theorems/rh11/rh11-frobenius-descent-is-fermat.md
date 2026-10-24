# Frobenius descent to 𝔽₁ is Fermat's little theorem

**Kind:** Claim
**Status:** CITED (literature, Borger)
**Area:** rh-html
**Source:** [`rh11.html`](../../html/rh11.html) — §5 "Spec ℤ over 𝔽₁: the determinant dream, computed"

## Statement

> <b>The Frobenius.</b> Borger's proposal makes "descent to 𝔽₁" precise: an 𝔽₁-structure on a ring is a Λ-ring structure — a coherent family of commuting lifts of all the Frobenii x ↦ x<sup>p</sup>. On ℤ itself the lifts are forced to be the identity map, and the condition that the identity *is* a p-Frobenius lift is the congruence ψ<sub>p</sub>(n) ≡ n<sup>p</sup> (mod p) — that is, <b>Fermat's little theorem is the statement that Spec ℤ descends to 𝔽₁</b>.

## Hypotheses and notation

- A Λ-ring structure is a coherent family of commuting lifts of all the Frobenii; Borger's proposal identifies an 𝔽₁-structure with it.
- ψ<sub>p</sub> is the p-th power operation of the Λ-ring structure; on ℤ the lifts are forced to be the identity.
- The congruence ψ<sub>p</sub>(n) ≡ n<sup>p</sup> (mod p) is then Fermat's little theorem.

## Proof / evidence

The source cites Borger's proposal and gives no proof. It reports a finite verification on the grid: n<sup>p</sup> ≡ n (mod p) for the first ten primes and n ≤ 200 — two thousand congruences, no exception. Its reading: "arithmetic already carries all its Frobenii — the structure Weil's proof leans on exists over ℚ — but they act invisibly, with no cohomology to leave fingerprints on, no graph in a surface to self-intersect."

## Dependencies and related results

- [GL_n(𝔽₁) = S_n](rh11-gl-n-over-f1-equals-symmetric-group.md) and [Soulé's ζ over 𝔽₁](rh11-soule-zeta-over-f1.md) — the other 𝔽₁ shadows of the same section.
- rh16's archive ledger (§5) lists this item among rh11's computed results.

## Notes

- The Λ-ring/Frobenius statement is Borger's cited proposal; the "two thousand congruences" are an exhaustive check of Fermat's congruence on a finite grid, not a proof of the proposal.
