# The silence of the main term — ∫ φ₁(w)·e^{w/2} dw = C(1)/2 = 0

**Kind:** Proposition
**Status:** PROVED (paper argument; C(s) carries the factor (s−1), verified numerically to −1.6×10⁻⁴⁴)
**Area:** xi-horn
**Source:** [`xi-horn/horn-helix-revisited.md`](../../xi-horn/horn-helix-revisited.md) — §3.2 "The silence of the main term", equation (9); §7 dictionary, term "the silence of the main term"

## Statement

> A smeared Chebyshev sum should flare: the prime number theorem puts ΣΛ(n) ≈ e^v mass under the bump at depth v, and the weight n^{−1/2} contributes e^{−v/2}, so Ψ(−v) should grow like e^{v/2}·∫φ₁(w)e^{w/2}dw. But that moment is **exactly zero**:
>
> ```
> ∫ φ₁(w)·e^{w/2} dw = C(1)/2 = 0        (numeric: −1.6e−44)                  (9)
> ∫ φ₁(w)·e^{−w/2} dw = C(0)/2 = −½      (numeric: −0.5, exact)
> ∫ φ₁(w)·e^{3w/2} dw = C(2)/2 = 1/2π    (numeric: 0.15915494)
> ```
>
> (9) vanishes because C(s) carries the factor (s−1) — **the very factor Riemann inserted to cancel ζ's pole**. The completion that makes ξ entire is, verbatim, the balance condition that silences the PNT flare in the prime horn. Nothing was tuned: the horn's own bump arrives pre-balanced.

with C(s) = ½s(s−1)π^{−s/2}Γ(s/2) and φ₁ the horn's n = 1 shell.

## Hypotheses and notation

- φ₁(w) = (2π²e^{9w/2} − 3πe^{5w/2})·e^{−πe^{2w}} is the horn's own bump (INTEGERS.md (14) at n = 1).
- C(s) = ½s(s−1)π^{−s/2}Γ(s/2) is the completion factor; the moments ∫φ₁(w)e^{kw/2}dw are the two-sided transforms evaluated at s = k (k = 0, 1, 2).
- The relation used is 2∫φ₁(u)e^{(s−½)u}du = C(s) (horn-helix.md (5) at n = 1).

## Proof / evidence

The source states the moment's vanishing and its reason in one line: "C(s) carries the factor (s−1)". The numeric values are quoted (∫φ₁e^{w/2} = −1.6e−44; ∫φ₁e^{−w/2} = −0.5 exact; ∫φ₁e^{3w/2} = 0.15915494 = 1/2π), and §6 repeats them ("∫φ₁e^{w/2} (the PNT-flare moment) | −1.6e−44 ≈ 0 = C(1)/2"). The source also states the mechanism's significance: the s = 1 residue is killed by (9) in the contour shift behind (10).

## Dependencies and related results

- [Shell *n* is gear *n*](xihorn-horn-helix-shell-n-is-gear-n.md) (horn-helix.md (5)) at n = 1 identifies C(s)/2 as the transform of φ₁.
- [The ring](xihorn-horn-helix-revisited-the-ring.md) (10) uses this vanishing to kill the s = 1 residue; the s = 0 point is regular and the first trivial zero sits at s = −2.
- The companion page [prime-horn.html](../../xi-horn/prime-horn.html) carries the same statement in a theorem box → [the silence — the main term cancels exactly](xihorn-prime-horn-silence-of-the-main-term.md), where it is marked as the source's classical recomputation.

## Notes

- The identity is a one-line consequence of the completion factor's (s−1); the source gives it as the explanation for why no PNT flare appears, not as a new theorem.
- The source's emphasis is that nothing was tuned: "the horn's own bump arrives pre-balanced."
