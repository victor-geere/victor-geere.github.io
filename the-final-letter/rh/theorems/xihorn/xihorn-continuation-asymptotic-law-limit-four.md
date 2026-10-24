# |w|·(R(w) − 1) → 4, with the Lambert-W correction — the asymptotic law

**Kind:** Theorem
**Status:** PROVED (paper argument; verified numerically at w = 10⁷ to a relative 5.7e−8)
**Area:** xi-horn
**Source:** [`xi-horn/CONTINUATION.md`](../../xi-horn/CONTINUATION.md) — §4 "Into the complex plane — no zeros, and the reason", boxed derivation and equation (24a)

## Statement

> **|w|·(R(w) − 1) → 4, and the approach is logarithmic.** The creep is real — extended sixteenfold past the table above it reads 3.269, 3.337, 3.395, **3.445 at w = 9600**, a factor of 960 in w having bought 1.32 — and no extension was ever going to settle it. **G5 derives it instead.** Writing L = log Γ_Φ, (24) is R = exp(−Δ²L)·R_f with Δ²L = L(w+4) − 2L(w+2) + L(w); the two derivatives of L are moments of the tilted density ρ_w(v) ∝ e^{(w+1)v}Φ(e^v),
>
> ```
> L′(w) = ⟨v⟩_w,   L″(w) = Var_w(v),   Δ²L = ∫_{−2}^{2}(2−|s|)L″(w+2+s)ds
> ```
>
> all exact; Laplace on the saddle of (w+1)v + log Φ(e^v) gives Var_w(v) = 1/[(w+1)(1+2U) + 9U²] with 2πU·e^{2U} = w + 1 + (9/2)U; and that saddle equation is solved by **U = ½·W(w/π)**, W the Lambert function. So
>
> ```
> w·(R(w) − 1)  =  4  −  4/(1 + W(w/π))  +  O(1/w)                     (24a)
> ```
>
> **The limit is 4** — W(x) → ∞ — and the correction dies like 4/log w, which is exactly why the numerics crawled. Checked against the measured R over three and a half decades past where C3 stopped: at w = 10⁷ the derivation gives 3.7031210446 against a measured 3.7031208350, a relative 5.7e−8, and the residual falls like 1/w at every step, which is Watson's next term. C3's empirical a = 4 − 5.09/ln w was reading 4·ln w/(1 + W(w/π)) — a quantity that falls from 5.23 to 5.09 across C3's own range and keeps falling, so the fit was a local snapshot of something moving.
>
> **How far the limit is**: reaching 3.9 needs w ≈ 10¹⁹ and 3.99 needs w ≈ 10¹⁷⁶. Nothing computational was ever going to read this off, which is why it had to be derived.

## Hypotheses and notation

- Γ_Φ is the Mellin continuation of the moments (equation (21)); C(w) = Γ_Φ(w)/Γ(w+1) is entire (equation (23)).
- R(w) = C(w+2)²/(C(w)·C(w+4)) is the holomorphic margin (equation (24)); R_f is the factorial-gain factor (w+3)(w+4)/((w+1)(w+2)).
- L = log Γ_Φ; Δ²L = L(w+4) − 2L(w+2) + L(w) is the second difference at step 2.
- ρ_w(v) ∝ e^{(w+1)v}Φ(e^v) is the tilted density; L′(w) = ⟨v⟩_w and L″(w) = Var_w(v) are its first two moments.
- W is the Lambert function; the saddle U solves 2πU·e^{2U} = w + 1 + (9/2)U and is U = ½·W(w/π).
- The limit is taken in every direction in ℂ, as the source's headline states ("decays like 4/|w| in every direction in ℂ"); the displayed derivation (24a) is written along the real axis.

## Proof / evidence

The source attributes the derivation to **G5** and reproduces it: R = exp(−Δ²L)·R_f is algebra from (24); L′ and L″ are identified as the mean and variance of the tilted density ρ_w(v) ∝ e^{(w+1)v}Φ(e^v); Laplace's method on the saddle of (w+1)v + log Φ(e^v) gives Var_w(v) = 1/[(w+1)(1+2U) + 9U²] with the saddle equation 2πU·e^{2U} = w + 1 + (9/2)U solved by U = ½·W(w/π); substituting into R = exp(−Δ²L)·R_f yields (24a). Numerical confirmation quoted by the source: at w = 10⁷ the derivation gives 3.7031210446 against a measured 3.7031208350, a relative 5.7e−8, with the residual falling like 1/w. The measured creep values 3.269, 3.337, 3.395, 3.445 at w = 9600 are quoted from the same section.

## Dependencies and related results

- The holomorphic margin (24): [xihorn-continuation-holomorphic-margin.md](xihorn-continuation-holomorphic-margin.md).
- The continuation Γ_Φ: [xihorn-continuation-continuation-and-pole-string.md](xihorn-continuation-continuation-and-pole-string.md).
- The bounded scan that finds no zero of R − 1: [xihorn-continuation-no-zero-of-r-minus-one.md](xihorn-continuation-no-zero-of-r-minus-one.md).
- C3's empirical fit a = 4 − 5.09/ln w is cited as superseded by this derivation.

## Notes

- The source's headline says the decay 4/|w| holds "in every direction in ℂ", while the displayed derivation (24a) is written along the real axis; the file preserves both, and does not extend the derivation to the complex directions.
- The source is explicit that the limit is far away: reaching 3.9 needs w ≈ 10¹⁹ and 3.99 needs w ≈ 10¹⁷⁶.
- "Watson's next term" is named, not stated; no form for it is given beyond the assertion that the residual falls like 1/w.
