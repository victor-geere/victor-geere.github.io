# Theorem 3 (the uniformity constant)

**Kind:** Theorem
**Status:** PROVED (paper argument, structural; the value of ν is left open)
**Area:** xi-horn
**Source:** [`xi-horn/gorz-gap.md`](../../xi-horn/gorz-gap.md) — §3 "The three theorems", Theorem 3 (equations (9), (10))

## Statement

> **Theorem 3 (the uniformity constant).** With ν as in (8):
>
> ```
> sup_{d≥1} N(d)  =  sup_{d≥1} #E(d)  =  ν ,                                  (9)
> ```
>
> both suprema attained when ν < ∞. Hence
>
> ```
> (U) holds   ⟺   ν < ∞   ⟺   some derivative of F is hyperbolic.            (10)
> ```

## Hypotheses and notation

- ν := min{ n ≥ 0 : F^{(n)} ∈ LP } ∈ {0, 1, 2, …} ∪ {∞} (equation (8), [Theorem 2](xihorn-gorz-gap-t2-initial-segment.md)).
- E(d) := { n ≥ 0 : J_{d,n} is NOT hyperbolic }; N(d) := 1 + max E(d) (:= 0 if E(d) = ∅), GORZ's threshold; D(n) := min{ d : n ∈ E(d) } (:= ∞ if none) (§1.3).
- (U) is the uniformity "sup_{d≥1} N(d) < ∞" (§1.3).
- F(z) = Σ_{n≥0} a(n)·z^n/n! = Ξ(√−z), real entire of order ½; LP is the Laguerre–Pólya class.

## Proof / evidence

The source's proof, verbatim: "E(d) ⊆ E_∞ = [0, ν) by Theorem 2, so #E(d) ≤ N(d) ≤ ν for every d. For the reverse: if ν < ∞, every n < ν has a finite witness degree D(n), and at d = max_{n<ν} D(n) Theorem 1 gives E(d) ⊇ {D(n) ≤ d} = [0, ν), so E(d) = [0, ν) exactly, #E(d) = N(d) = ν. If ν = ∞, the same argument at d = max_{n<K} D(n) gives #E(d) ≥ K for every K. ∎"

The source reads (9) against the literature: "**Read (9) against [GOR⁺] Theorem 1.1.** Their bound is N(d) ≤ ce^d. The truth is that N(d) is *monotone and bounded*, increasing to ν. The exponential is therefore never tight for large d — it is an artifact of the certificate, not a feature of the family."

## Dependencies and related results

- [Theorem 1 (nesting)](xihorn-gorz-gap-t1-nesting.md) and [Theorem 2 (initial segment)](xihorn-gorz-gap-t2-initial-segment.md) are the whole input.
- Cited [GOR⁺] Theorem 1.1 ([harvested](xihorn-gorz-gap-gorplus-theorem-11.md)) is the bound being sharpened structurally.
- The source's status table: "N(d) non-decreasing, sup N(d) = ν | **Theorems 1–3 above**"; "Theorems 1–3 are structural; they identify the uniformity constant and prove it is one integer, not that the integer is finite."

## Notes

- The source's §10 warning: "**1. It does not prove ν < ∞.** Theorems 1–3 are structural; they identify the uniformity constant and prove it is one integer, not that the integer is finite. Finiteness would follow from ξ having finitely many non-real zeros, which is open."
- The source's correction of a misfiling is separate from the theorem (see the [order-½ witness](xihorn-gorz-gap-order-half-witness.md)): "By (10) the uniformity is ν < ∞, and RH is ν = 0. Proving sup_d N(d) ≤ 17 would leave RH exactly where it is."
