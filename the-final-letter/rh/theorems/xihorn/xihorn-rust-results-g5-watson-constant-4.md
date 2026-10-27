# G5 — done, and the answer is 4

**Kind:** Claim
**Status:** PROVED (paper argument; Laplace/Watson on the tilted density, with one Laplace approximation whose residual falls like 1/w and is measured; VERIFIED numerically to 5.66e−8 at w = 1.024×10⁷)
**Area:** xi-horn
**Source:** [`xi-horn/rust/RESULTS.md`](../../xi-horn/rust/RESULTS.md) — Summary, "G5 — done, and the answer is 4"

## Statement

> **G5 — done, and the answer is 4.** C3 measured the creep and could not settle
> it. The derivation: with L = log Γ_Φ, (24) is R = exp(−Δ²L)·R_f, and both
> derivatives of L are **moments of the tilted density** ρ_w ∝ e^{(w+1)v}Φ(e^v)
> — L′ = ⟨v⟩_w and **L″ = Var_w(v)**, exactly, with L″ > 0 being the
> Cauchy–Schwarz defect itself. Laplace on the saddle gives
> −P″ = (w+1)(1+2U) + 9U² with 2πU·e^{2U} = w+1+(9/2)U, and **that is solved by
> U = ½·W(w/π)** — Lambert's function, from **H5**. So
>
> ```text
> w·(R(w) − 1)  =  4  −  4/(1 + W(w/π))  +  O(1/w)
> ```
>
> **The limit is 4**, approached like 4/log w. Checked: L′ = ⟨v⟩ to 5.3e−19 …
> 2.3e−26; L″ = Var to **1.4e−15 at w = 1000**; Laplace's residual falling like
> 1/w over five decades (5.49e−2 → 2.22e−6 at w = 30 … 3×10⁶); and the whole
> prediction against measured R **three and a half decades past where C3
> stopped** — 3.7031210446 against 3.7031208350 at w = 1.024×10⁷, a relative
> 5.66e−8, the residual falling 4× per 4× in w. C3's fitted 4 − 5.09/ln w was a
> local snapshot of 4·ln w/(1+W(w/π)), which falls from 5.23 to 5.09 across C3's
> own range and keeps falling. **Reaching 3.9 needs w ≈ 10¹⁹ and 3.99 needs
> 10¹⁷⁶** — no computation was ever going to read this off.

## Hypotheses and notation

- R is the ratio (24); L = log Γ_Φ; Δ²L := L(w+4) − 2L(w+2) + L(w); R_f = (w+3)(w+4)/((w+1)(w+2)) = 1 + 4/w − 2/w² + …
- ρ_w(v) ∝ e^{(w+1)v}Φ(e^v) is the tilted density; L′ = ⟨v⟩_w and L″ = Var_w(v) are exact identities.
- The saddle: −P″ = (w+1)(1+2U) + 9U² with 2πU·e^{2U} = w + 1 + (9/2)U, U = e^{v\*}, solved exactly by U = ½·W(w/π).
- Driver `bin/g5_watson`; module `watson.rs`.

## Proof / evidence

The identities L′ = ⟨v⟩ and L″ = Var are "checked, not assumed": the first against a difference quotient to 5.3e−19 … 2.3e−26; the second to 1.4e−15 at w = 1000 and 1.3e−19 at w = 10⁴ under Richardson extrapolation. The one approximation is Laplace on Var_w(v); its residual is measured to fall like 1/w over five decades (5.49e−2, 8.61e−3, 1.19e−3, 1.52e−4, 1.87e−5, 2.22e−6 at w = 30 … 3×10⁶), and the closed form for −P″ against the full Φ falls like 1/w² (6.07e−3 down to 3.94e−11). The prediction against measurement at w = 1.024×10⁷: 3.7031210446 against 3.7031208350, relative 5.66e−8, residual falling 4× per 4× in w.

## Dependencies and related results

- [C3 — the phrasing does outrun the evidence](xihorn-rust-results-c3-asymptotic-constant.md) — the measurement this derivation supersedes.
- [H5 — the Lambert-W asymptotic](xihorn-rust-results-h5-lambert-w-asymptotic.md) — supplies Lambert's W (U = ½·W(w/π)).
- [E22 — the node count is the diagnostic, squared in the exponent](xihorn-rust-results-e22-node-count-error-law.md) — the by-product of the same saddle.
- [B3 — the widest scan](xihorn-rust-results-b3-widest-scan.md) — the 3.031 value at |w| ≈ 155 this formula explains.

## Notes

- The source is candid that exactly one step is an approximation: "**Every step but one is an identity.** … The one approximation is Laplace on Var_w(v)." Its residual and its 1/w behaviour are measured, not assumed.
- §4's claim "now rests on a derivation instead of on a creep", and A5's downgrade of it is superseded by (24a).
