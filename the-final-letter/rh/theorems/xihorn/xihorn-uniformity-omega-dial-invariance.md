# The Ω-dial invariance: the all-d conjunction at fixed shift is the same at every Ω

**Kind:** Claim
**Status:** PROVED (paper argument, one line from the cited [O'S] Theorem 3.5)
**Area:** xi-horn
**Source:** [`xi-horn/uniformity-in-the-jensen-degree-d.md`](../../xi-horn/uniformity-in-the-jensen-degree-d.md) — §5 "The criterion is the free parameter — and what it cannot buy"

## Statement

> **And here is the invariance that bounds the dial.** Fix the shift n and apply Theorem 3.5 to Φ = the shifted series itself (c_j = γ(n+j)): for *every* Ω ∈ LP,
>
> ```
> { Ω-family hyperbolic at (n, d) for all d ≥ 1 }   ⟺   ξ^(n)-hyperbolicity,
> ```
>
> and the right-hand side does not mention Ω.

## Hypotheses and notation

- Ω ranges over the Laguerre–Pólya class LP; the Ω-family at (n, d) is the polynomial family of [O'S] Theorem 3.5, Σ_{j=0}^{d} C(d,j)·c_j·g*_{d−j}(Ω; x), with Φ taken to be the shifted series, c_j = γ(n+j).
- ξ^(n) is the n-th derivative of the Riemann xi function; ξ^(n)-hyperbolicity is the right-hand side.
- The shift n is fixed; the quantifier on the left is over all d ≥ 1.
- γ is the papers' γ(n) = the directory's a(n) (no rescaling, source §1).

## Proof / evidence

The source's derivation, verbatim: "Fix the shift n and apply Theorem 3.5 to Φ = the shifted series itself (c_j = γ(n+j)): for *every* Ω ∈ LP, { Ω-family hyperbolic at (n, d) for all d ≥ 1 } ⟺ ξ^(n)-hyperbolicity, and the right-hand side does not mention Ω. The all-d conjunction at fixed n is the same statement at every setting of the dial."

Its consequences in the source: "Instances re-price (Corollary 3.8's strict implication; H2's twelve decades of measured slack); the conjunction is a gauge invariant, and the conjunction is the hard direction." And: "No Ω closes the corner. Ω chooses how cheaply the wedge is certified, and that is all it chooses."

## Dependencies and related results

- Cited [O'S] Theorem 3.5 ([harvested](xihorn-uniformity-osullivan-theorem-35.md)); [O'S] Corollary 3.2 ([harvested](xihorn-uniformity-osullivan-corollary-32.md)); [O'S] Corollary 3.8 ([harvested](xihorn-uniformity-osullivan-corollary-38.md)).
- The dial's other settings: Ω = 1 (J family, [O'S] Theorem 1.1), Ω = e^{−z²} (Hermite/P family, [O'S] Theorem 1.2), Ω = 𝒥_ν ([O'S] Theorem 3.9).
- The source ties it to `[CONTINUATION.md](../../xi-horn/CONTINUATION.md)` §8.2: "the Ω-families are coefficient multipliers on the y-series of the one two-variable function F(w, y)".

## Notes

- This is the file's own result, not a quotation: it is stated as the invariance that bounds [O'S] Theorem 3.5's dial, and the source marks the `[-]` item "Any assault on the fixed-n, all-d direction through this machinery" as "Invariant under Ω (§5)".
- The source hedges nothing here, but the status is recorded as a paper argument resting on the cited theorem.
