# The Gram matrix as a fold of the kernel

**Kind:** Proposition
**Status:** PROVED (paper argument; VERIFIED numerically)
**Area:** rh-html
**Source:** [`rh14.html`](../../html/rh14.html) — §3 "The merge: nothing lost, and the frontier continued", equation (2)

## Statement

> G[j,k] = 2[E(y<sub>j</sub>−y<sub>k</sub>) + E(y<sub>j</sub>+y<sub>k</sub>)]
>
> (halved once per zero index), to **8.1×10⁻⁵ of scale, worst entry** — the whole crossing form of rh13, refolded out of one curve.

and, in the same paragraph: "at support a = 3 (gears to log n ≤ 6, the sieve out to n = 403), **D*(3) = 1.15×10⁻⁸**, two and a half decades past rh12's endpoint, with the same certified positivity."

## Hypotheses and notation

- y<sub>j</sub> are the window positions of rh13's even-pair Gram matrix; E is the merged kernel of equation (1).
- G[j,k] is rh13's Gram matrix entry W(f<sub>j</sub> ⸱ f<sub>k</sub>), all 325 entries of which were computed there by 325 separate double-quadratures.
- D*(a) is rh12's optimal-window dip; "halved once per zero index" refers to the normalisation of the fold.

## Proof / evidence

The source reports that the fold reproduces rh13's entire 25×25 even-pair Gram matrix — all 325 entries — to 8.1×10<sup>−5</sup> of scale, worst entry; that rh12's optimal window re-evaluates inside the merged system to its stated dip (the D* consistency check passes at rh12's own tolerance); and that the frontier machinery on the merged form gives D*(3) = 1.15×10<sup>−8</sup>. The closing audit: "rh13's 325 arithmetic-side Gram matrix entries … the whole crossing form of rh13, refolded out of one curve."

## Dependencies and related results

- [The merged kernel: one function, two theories](rh14-merged-kernel-one-function.md) — equation (1), the function being folded.
- [The crossing form: signature (25, 0, 0)](../rh13/rh13-crossing-form-signature.md) — the matrix being reproduced.
- [The optimal-window frontier D*(a) = 1/(b₀ᵀM⁻¹b₀)](../rh12/rh12-optimal-window-frontier.md) — whose frontier is continued to a = 3.
- [The nested-slice exhaustion is positive](rh14-nested-slice-exhaustion-positive.md) — the Toeplitz slices used later.

## Notes

- The source's reading: "The matrix the arc built by 325 quadratures is one curve worn 325 ways."
- D*(3) = 1.15×10<sup>−8</sup> is a floating-point frontier value on the merged kernel, with the same certified positivity the source reports for rh12's frontier; rh15 §4 later qualifies the D* frontier as arithmetic but unconverged at every reachable mesh.
