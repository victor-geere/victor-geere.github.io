# G3 — done. Every claim CONTINUATION (22) makes is true; the derivation that produced them is not

**Kind:** Claim
**Status:** VERIFIED (numerical; coefficients enclosed to 1e−118 relative, structural agreements to 1e−25)
**Area:** xi-horn
**Source:** [`xi-horn/rust/RESULTS.md`](../../xi-horn/rust/RESULTS.md) — Summary, "G3 — done. Every claim CONTINUATION (22) makes is true; the derivation that produced them is not"

## Statement

> **G3 — done. Every claim CONTINUATION (22) makes is true; the derivation that
> produced them is not.** (22) asserts Γ_Φ meromorphic with simple poles at
> w = −1, −3, −5, … only, residue 4c_{2k} at w = −(2k+1), and (23) that
> C(w) = Γ_Φ(w)/Γ(w+1) is entire. Nothing had ever computed a c_{2k}.
> `series.rs` computes them exactly — truncated power series over intervals, two
> recurrences, no quadrature — with the shell truncation majorised by a Cauchy
> estimate on |u| = 3/10:
>
> ```text
> c_0 =  0.4466969004671234440870      c_4 =  16.92005903032133932308
> c_2 = -4.182625193675814216698       c_6 = -35.23314299039473379539
> ```
>
> Every odd coefficient encloses zero: Φ's evenness — the theta functional
> equation — arriving through arithmetic rather than being imposed.

| claim | predicted | measured |
|---|---|---|
| Res at w = −1 | (22) prints 1.7867876 | 1.786787601868493776 — agrees to all nine |
| C(−1) = 4·0!·c₀ | 1.78678760186849378e0 | same, rel 8.6e−26 |
| C(−3) = 4·2!·c₂ | −3.34610015494065137e1 | same, rel 1.8e−25 |
| C(−5) = 4·4!·c₄ | 1.62432566691084858e3 | same, rel 2.0e−25 |
| C(−2), C(−4), C(−6) | 0 (simple zeros) | 3e−77, 4e−75, 8e−73 |

> **But (22)'s derivation splits at u = 1 and integrates Φ's Taylor series over
> [0, 1], and the radius of convergence is π/4 = 0.785.** Φ = 2e^{u/2}ω(e^{2u})
> with ω built from θ, and θ has Re t = 0 as a natural boundary, so Φ is analytic
> exactly on |Im u| < π/4; at u = iπ/4 the shell terms are (…)(−1)^k and do not
> decay. Measured, with the coefficients enclosed to 1e−118 relative so the
> structure is Φ's and not roundoff:
>
> ```text
>     m            |c_m|      |c_m|^(1/m)
>    20        6.29951e3         1.548693
>    60        1.32282e8         1.365710
>   100       4.34227e12         1.337757
>   158       3.07147e19         1.328427      → 4/π = 1.27324
> ```
>
> |c_m|^{1/m} ∈ [1.25, 1.45] over 30 ≤ m ≤ 158, settling toward 4/π from above.
> The series in (22) **diverges**. The conclusion survives — split anywhere
> inside the disc and the same argument gives the same poles and residues — but
> the displayed identity is false as written, and §7's "For Re w ≤ −1 use the
> split (22)" with it. **E14.**
>
> The replacement evaluator (split at V₀ = −2, whole Taylor series below,
> Romberg above) agrees with `mellin::eval` to **8.8e−43** at w = 2, 4, 10 — two
> independent routes to the same number.
>
> **And `mellin::eval` is not a continuation below w = −1**, which its doc
> comment claimed. At w = −1.5 it returns 2.14e4 for −7.74. The cause is
> identified rather than observed: below −1 the integrand *grows* as v → −∞, so
> V₀ = −50 — chosen to make it negligible for Re w > −1 — makes it enormous, and
> Euler–Maclaurin's boundary term is amplified by e^{(w+1)V₀}. Measured against
> (h²/12)·|w+1|·e^{(w+1)V₀}·Φ(0):
>
> ```text
>       w   measured   predicted
>    -0.5   2.27e-18    2.27e-18
>    -1.5     2.77e3      2.77e3
>    -2.0    3.14e14     3.14e14
>    -2.9    1.33e33     1.33e33
> ```
>
> Three significant figures across **fifty-one decades**. Independently, the A3
> tail approximates Φ(e^v) by Φ(0) and so carries the pole at w = −1 and no
> other. **E15.**

## Hypotheses and notation

- Φ(u) = Σ c_{2k}u^{2k}; Γ_Φ(w) = 4∫₀^∞ u^w Φ(u)du; C(w) = Γ_Φ(w)/Γ(w+1).
- The exact coefficients come from `rust/src/series.rs`: truncated power series over intervals, two recurrences (e^{αu} → α^m/m!, and F = e^G ⟹ m·f_m = Σ i·g_i·f_{m−i}), no quadrature; the shell truncation is majorised by a Cauchy estimate on |u| = 3/10.
- Driver `bin/g3_poles [len] [digits] [levels]`.

## Proof / evidence

Numerical, with the coefficients enclosed to 1e−118 relative: the three structural claims of (22)/(23) are confirmed (residues, C at −1, −3, −5 to 1e−25, simple zeros at −2, −4, −6 of size 3e−77/4e−75/8e−73), and the failure of the derivation is measured (|c_m|^{1/m} ∈ [1.25, 1.45] over 30 ≤ m ≤ 158, settling toward 4/π = 1.27324 from above). The replacement evaluator agrees with `mellin::eval` to 8.8e−43 at w = 2, 4, 10.

## Dependencies and related results

- [22) — the pole string of Γ_Φ (false as printed](xihorn-todo-22-pole-string-identity-refuted.md) and [(23) — C(w) is entire](xihorn-todo-23-c-is-entire.md) — the two claims adjudicated here.
- [A3 — Γ_Φ near w = 0](xihorn-rust-results-a3-gamma-phi-near-zero.md) — the same closed form and the same pole at w = −1.
- [G6 — the truncation law](xihorn-rust-results-g6-k-req-law.md) — the other flow measurement.

## Notes

- **Fidelity note:** the source separates the two verdicts carefully — the *claims* are true, the *derivation* is not; E14's own words are "The conclusion survives; only the derivation fails."
- Three implementation points recorded: Romberg rather than trapezoid above the split (Euler–Maclaurin leaves a relative 1.3e−7 at U₀ = 0.135); the split point must be specified as V₀ and not U₀ (7e−17 that no number of Romberg levels removes); and the w = 0 residual belongs to `Mellin::standard`'s own boundary term (halving h quarters it, measured ratio 4.00).
