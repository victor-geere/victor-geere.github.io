# The parity split, spent (the certificate issued per block)

**Kind:** Proposition
**Status:** PROVED (paper argument); VERIFIED (numerical, 3.81× saving)
**Area:** rh-html
**Source:** [`rh27a.html`](../../html/rh27a.html) — §3 "(b) The parity split, spent", eqs. (4)–(5)

## Statement

> The reason it can be is that the change of basis is *orthogonal*. With J the exchange matrix and
>
> U = (1/√2)[[I, J],[I, −J]]  (bordered by 1 at the centre when n is odd),   U U′ = I,   U T<sub>h</sub> U′ = diag(B₊, B₋),
>
> any perturbation E of T maps to U E U′, of exactly the same norm. So rh24's binned radius ρ — which bounds ‖E‖ through an ℓ¹ row-sum against the gear mass — applies to each block unchanged, with no factor to re-derive. And λ<sub>min</sub>(T) = min(λ<sub>min</sub>(B₊), λ<sub>min</sub>(B₋)), so a floor for each block is a floor for the section:
>
> λ<sub>min</sub>(T<sub>exact</sub>) ≥ min<sub>±</sub> ( s − ‖B<sub>±</sub> − sI − R′<sub>±</sub>R<sub>±</sub>‖ ) − ρ.
>
> Measured at three sizes the saving is 3.81× — 2(n/2)³ = n³/4, as arithmetic says it should be — and it is what makes the 1201-node section at the finest mesh affordable at all.

## Hypotheses and notation

- J is the exchange (half-turn) matrix; the section T<sub>h</sub> is exactly centrosymmetric (rh26 §2).
- U = (1/√2)[[I, J],[I, −J]], bordered by 1 at the centre when n is odd; U is orthogonal, U U′ = I.
- B₊ and B₋ are the even and odd blocks; s is a shift; R<sub>±</sub> is the Cholesky factor of B<sub>±</sub> − sI; ρ is rh24's binned radius bounding ‖E‖.
- The floor is issued per block and the section's floor is the smaller of the two.

## Proof / evidence

Paper argument: orthogonality of U makes the perturbation norm unchanged, so the binned radius transfers with no factor to re-derive; λ<sub>min</sub> of the section is the smaller of the two block minima and the verified floor of (5) follows. The saving is measured at three sizes (76, 151, 201) as 3.81×, matching n³/4. The source also records the negative side: the blocks are Toeplitz-plus-Hankel, so the O(n²) Levinson/Durbin recursion gains nothing, the saving is confined to the dense route (which is the one backend α uses), and the split moves the affordable section size by about 1.6×, "which was the difference between reaching depth 18 at Δ/16 and not".

## Dependencies and related results

- [rh26-half-turn-splits-every-section](../rh26/rh26-half-turn-splits-every-section.md) — the split, measured but not spent, in rh26.
- rh24's binned radius, rh17/rh19's backend α.
- It is what pays for [rh27a-three-certificates-at-depth-18](rh27a-three-certificates-at-depth-18.md).

## Notes

- The source's own qualification: "The split is a factor, not a reduction"; also carried over from rh26.
- Section numbers in (4)–(5) are quoted with the source's `<sub>`/`<sup>` markup transliterated.
