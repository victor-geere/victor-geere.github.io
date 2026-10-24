# The order-½ witness G(z) = (z² + 1)·cosh(√z): E(d) = {0} for d ≥ 2, ν = 1

**Kind:** Claim
**Status:** CHECKED (exhaustive finite, exact real-root counting for d = 1 … 11 and n = 0 … 11; order ½ and positivity of the Jensen sequence argued)
**Area:** xi-horn
**Source:** [`xi-horn/gorz-gap.md`](../../xi-horn/gorz-gap.md) — §6 "The correction…" and §7.2 "The order-½ witness: G(z) = (z² + 1)·cosh(√z)"

## Statement

> **G(z) = (z² + 1)·cosh(√z)**. It is real entire of order ½ — the same order as ξ's F, in the same genus-1\* class the Jensen criterion quantifies over — with strictly positive Taylor data, and with exactly two non-real zeros, ±i. Its exception sets are
>
> ```
> E(1) = ∅ ,      E(d) = {0}  for every d ≥ 2,        so   sup_d N(d) = ν = 1.
> ```
>
> Uniformity with constant 1, and no hyperbolicity.

## Hypotheses and notation

- cosh(√z) = Σ_k z^k/(2k)! "lies in LP with zeros at −((2k+1)π/2)², and has order ½; multiplying by z² + 1 keeps the order and inserts one non-real pair."
- The model's Jensen sequence is a_m = m!·(1/(2m−4)! + 1/(2m)!), positive throughout: "a = 1, 1/2, 25/12, 361/120, 1681/1680, 5041/30240, …"
- E(d) := { n ≥ 0 : J_{d,n} is NOT hyperbolic }; N(d) := 1 + max E(d) (:= 0 if E(d) = ∅); ν := min{ n ≥ 0 : F^{(n)} ∈ LP } (equation (8)). LP is the Laguerre–Pólya class.

## Proof / evidence

The source reports the exact computation, verbatim: "Exact real-root counting, d = 1 … 11 and n = 0 … 11:

```
  d = 1   E(d) = ∅
  d ≥ 2   E(d) = {0}          nested at every step, #E(d) = N(d) = 1 = ν
```

Two further instances behave the same way: (z² + ¼)cosh√z gives E(d) = {0} for d ≥ 2, and (z² + 2z + 2)cosh√z gives E(d) = ∅ for d ≤ 2 and {0} for d ≥ 3 — the same picture with the witness degree shifted by one. This is the §6 object."

The source's §8 table records "order-½ witness (z²+1)cosh√z: E(d), d ≥ 2 | {0}; sup N(d) = ν = 1, G ∉ LP".

## Dependencies and related results

- The point of the witness is against the reading of [Theorem 3](xihorn-gorz-gap-t3-uniformity-constant.md): by (10) the uniformity (U) is ν < ∞, and RH is ν = 0. "Proving sup_d N(d) ≤ 17 would leave RH exactly where it is. The item is correctly filed as a *gap closure* and incorrectly filed as a *sufficient statement*, and the difference is the whole set {1, 2, 3, …}."
- The same model family is the (z²+bz+c)cosh(√z) of the source's §9 reproduction code.
- Related: [the exactly solvable e^z model](xihorn-gorz-gap-toy-model-closed-form.md), [the detection law](xihorn-gorz-gap-detection-law.md).

## Notes

- The source is explicit that this is not a statement about ζ: "What a witness like this does **not** do is say anything about ζ. There is no construction here of an ξ with off-line zeros, and none is possible by these means. The witness settles a question of logic — whether (U) implies (5) — and the answer is no."
- The whole-non-real-zero set is exactly {±i}; the source also states G is "real entire of order ½ … with strictly positive Taylor data".
- The computation is a finite exhaustive real-root count (d = 1 … 11, n = 0 … 11), not an analytic proof that E(d) = {0} for all d ≥ 2, so the status is recorded as an exhaustive finite check.
