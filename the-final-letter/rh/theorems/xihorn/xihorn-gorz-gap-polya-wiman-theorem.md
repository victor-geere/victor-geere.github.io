# The Pólya–Wiman theorem

**Kind:** Theorem
**Status:** CITED (literature; the source flags its attribution as from memory and asks that it be verified before publishing)
**Area:** xi-horn
**Source:** [`xi-horn/gorz-gap.md`](../../xi-horn/gorz-gap.md) — §5 "What ν is"

## Statement

> The middle line is the **Pólya–Wiman theorem**: *if f is a real entire function of order < 2 with only finitely many non-real zeros, then f^{(n)} has only real zeros for all sufficiently large n.* F has order ½, so it applies verbatim.

## Hypotheses and notation

- f real entire of order < 2 with only finitely many non-real zeros.
- f^{(n)} is the n-th derivative; the conclusion is that f^{(n)} has only real zeros for all sufficiently large n.
- Applied to F(z) = Σ_{n≥0} a(n)·z^n/n!, which "has order ½, so it applies verbatim".
- The source's use: it is what gives the entry "ν < ∞ ⟸ ξ has only finitely many non-real zeros" in the source's §5 display.

## Proof / evidence

The source cites, verbatim: "(Conjectured by Pólya; proved for order < 2 by Craven–Csordas–Smith, *Ann. of Math.* **125** (1987) 405–431 — **this attribution is from memory; verify it before publishing.** The related and definitely-local reference is Ki–Kim, *On the number of nonreal zeros of real entire functions and the Fourier–Pólya conjecture*, Duke Math. J. **104** (2000) 45–73, which is [KK00] in [O'S]'s bibliography.)"

No proof is reproduced in the source.

## Dependencies and related results

- Supplies the middle implication of the source's §5 display: "ν < ∞ ⟸ ξ has only finitely many non-real zeros", with ν := min{ n ≥ 0 : F^{(n)} ∈ LP } ([Theorem 2](xihorn-gorz-gap-t2-initial-segment.md)).
- Ki–Kim, Duke Math. J. **104** (2000) 45–73, is given as the local reference ([KK00] in [O'S]'s bibliography).

## Notes

- The source's own hedging is part of the statement's record: the Craven–Csordas–Smith attribution "**is from memory; verify it before publishing**". Do not cite it as verified.
- The source notes both remaining implications are one-way, and gives a witness in the ambient class: "f(z) = (1 + c) − cos z with c > 0 is real entire of order 1 with f′ = sin z ∈ LP, so ν = 1, while cos z = 1 + c has the infinite family of non-real solutions z = ±i·arccosh(1+c) + 2πk. Finiteness of the non-real zero count is sufficient for ν < ∞ and not necessary."
