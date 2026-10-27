# The exactly solvable model G(z) = (z² + b z + c)·e^z — closed forms for E(d) and D(n)

**Kind:** Claim
**Status:** PROVED (paper argument; the factorization (12) verified symbolically for d = 2 … 6 and against brute-force real-root counting on 6 072 (d, n) pairs with 0 mismatches)
**Area:** xi-horn
**Source:** [`xi-horn/gorz-gap.md`](../../xi-horn/gorz-gap.md) — §7.1 "An exactly solvable model: G(z) = (z² + b z + c)·e^z", equations (11)–(13)

## Statement

> Real entire of genus 1 (hence genus 1\*), with exactly one conjugate pair of non-real zeros when Δ₀ := b² − 4c < 0. Differentiating, G^{(m)} = q_m(z)e^z with q_m = z² + b_m z + c_m and
>
> ```
> b_m = b + 2m ,   c_m = c + mb + m² − m ,   Δ_m = b_m² − 4c_m = Δ₀ + 4m       (11)
> ```
>
> so G^{(m)} ∈ LP ⟺ Δ_m ≥ 0, giving `ν = ⌈−Δ₀/4⌉`. The Jensen sequence is a_m = G^{(m)}(0) = c_m, a quadratic in m, and the whole family factors: for d ≥ 2,
>
> ```
> J_{d,n}(X) = (1 + X)^{d−2} · Q_{d,n}(X) ,   disc Q_{d,n} = d·( d·Δ_n + 4c_n ) (12)
> ```
>
> — an exact identity, verified symbolically for d = 2 … 6, and checked against brute-force real-root counting on 6 072 (d, n) pairs across 120 random parameter choices with **0 mismatches**. So
>
> ```
> n ∈ E(d)   ⟺   Δ_n < 0  and  d > 4c_n/|Δ_n| ,       D(n) = ⌊4c_n/|Δ_n|⌋ + 1  (13)
> ```
>
> — a threshold in d, which is Theorem 1 made visible.

## Hypotheses and notation

- b, c are real parameters with Δ₀ := b² − 4c < 0; q_m(z) = z² + b_m z + c_m; a_m = G^{(m)}(0) = c_m is the model's Jensen sequence.
- J_{d,n}(X) = Σ_{j=0}^{d} C(d,j)·a(n+j)·X^j (equation (4) of the source); E(d) := { n ≥ 0 : J_{d,n} is NOT hyperbolic }; D(n) := min{ d : n ∈ E(d) } (:= ∞ if none); ν := min{ n ≥ 0 : F^{(n)} ∈ LP } (equation (8)).
- LP is the Laguerre–Pólya class; disc is the discriminant; ⌈·⌉ and ⌊·⌋ are ceiling and floor.
- e^z is the model's exponential factor; the source's second model family (z²+bz+c)cosh(√z) is the [order-½ witness](xihorn-gorz-gap-order-half-witness.md).

## Proof / evidence

The source gives (11) and (12) directly, with the verification just quoted. Its exact-rational instance at b = 1, c = 3 (Δ₀ = −11, a_m = m² + 3, ν = 3):

```
   d      E(d)          #E(d)   N(d)
   1      ∅               0      0
   2      {0}             1      1
   3–9    {0,1}           2      2
  ≥10     {0,1,2}         3      3      = ν
```

"with D(0) = 2, D(1) = 3, D(2) = 10 as (13) predicts, nesting at every step, every exception below ν, and nothing new appearing through d = 10⁶."

A second instance at b = 100, c = 2525 (Δ₀ = −100, ν = 25, a_m = m² + 99m + 2525): "the witness degrees are D(0) = 102, D(1) = 110, D(2) = 119, D(3) = 129, D(4) = 140, D(5) = 153, …, D(24) = 5478, and D(n) = ∞ for n ≥ 25. So D\* = D(0) = 102: the n = 0 column is the earliest, J_{d,0} is hyperbolic for every d ≤ 101, and Corollary 5 certifies the whole triangle d + n ≤ 101 — ≈ 5 000 pairs from 101 one-dimensional checks. Confirmed: no exception inside that triangle, by the closed form for n < 40 and by brute force for d ≤ 11, n ≤ 7. Corollary 6's D(0) ≤ D(n) + n holds at every n < ν." (The source heads this §7.4 "Non-trivial column reduction".)

The source's §8 table records "toy (12)–(13) closed form vs brute force | 6 072 (d,n) pairs, **0** mismatches" and "toy b=1, c=3: ν / N(d) sequence | 3 / 0, 1, 2, 2, 2, 2, 2, 2, 2, 3, 3, …" and "toy b=1, c=3: D(0), D(1), D(2) | 2, 3, 10".

## Dependencies and related results

- Makes [Theorem 1 (nesting)](xihorn-gorz-gap-t1-nesting.md) visible as a threshold in d; instances confirm [Corollary 5](xihorn-gorz-gap-c5-column-reduction.md) and [Corollary 6](xihorn-gorz-gap-c6-hardest-shift-nearly-easiest.md).
- The same model is specialized in the [detection law](xihorn-gorz-gap-detection-law.md) (b = 2 − 1/K, c = 1).

## Notes

- This is a model statement, not a statement about ξ: the source's §10 says "**3. The witnesses are models, not zeta.** §7.1–7.3 construct entire functions with prescribed off-line pairs. They calibrate the *criterion* — what a Jensen scan can and cannot see, and at what degree. They say nothing about where ζ's zeros are".
- Symbolic verification of (12) was for d = 2 … 6 only; the source does not claim a general proof of the factorization beyond "an exact identity".
