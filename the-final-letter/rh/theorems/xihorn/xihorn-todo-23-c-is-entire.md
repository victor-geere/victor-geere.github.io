# (23) — C(w) = Γ_Φ(w)/Γ(w+1) is entire

**Kind:** Claim
**Status:** VERIFIED (numerical; agreement to 1e−25 at w = −1, −3, −5; simple zeros at −2, −4, −6 of size 3e−77, 4e−75, 8e−73)
**Area:** xi-horn
**Source:** [`xi-horn/TODO.md`](../../xi-horn/TODO.md) — §G3 "Check CONTINUATION (22)'s pole string"

## Statement

> (23) that C(w) = Γ_Φ(w)/Γ(w+1) is entire … **(23), which is the sharp test.**
> C(−(2k+1)) = 4·(2k)!·c_{2k}, because Γ_Φ's pole meets 1/Γ(w+1)'s zero.
> Measured against predicted at w = −1, −3, −5: **1.79e0, −3.35e1, 1.62e3**,
> agreeing to 1e−25. And C(−2), C(−4), C(−6) = 3e−77, 4e−75, 8e−73 — the simple
> zeros. Every structural claim (22) and (23) make is true.

## Hypotheses and notation

- Γ_Φ(w) = 4∫₀^∞ u^w Φ(u)du; C(w) = Γ_Φ(w)/Γ(w+1); c_{2k} are the even Taylor coefficients of Φ, Φ(u) = Σ c_{2k}u^{2k}.
- The mechanism claimed: Γ_Φ's simple pole at w = −(2k+1) meets the zero of 1/Γ(w+1), giving the **finite** value C(−(2k+1)) = 4·(2k)!·c_{2k}; and C has simple zeros at w = −2, −4, −6.
- The c_{2k} are computed exactly in `rust/src/series.rs` — truncated power series over intervals, two recurrences (e^{αu} → α^m/m!, and F = e^G ⟹ m·f_m = Σ i·g_i·f_{m−i}), no quadrature anywhere — with the shell truncation majorised by a Cauchy estimate on |u| = 3/10 (G3a). Values recorded: c_0 = 0.4466969004671234440870, c_2 = −4.182625193675814216698, c_4 = 16.92005903032133932308, c_6 = −35.23314299039473379539.

## Proof / evidence

Numerical: predicted C(−(2k+1)) = 4·(2k)!·c_{2k} at w = −1, −3, −5 gives 1.79e0, −3.35e1, 1.62e3 against the measured values, agreeing to 1e−25; C(−2), C(−4), C(−6) come out 3e−77, 4e−75, 8e−73. The first residue also agrees with the **1.7867876** that (22) prints, to the nine digits it prints. Every odd coefficient encloses zero — Φ's evenness, which is the theta functional equation, arriving through arithmetic rather than being imposed.

## Dependencies and related results

- [(22) — the pole string of Γ_Φ](xihorn-todo-22-pole-string-identity-refuted.md) — the companion claim, whose displayed identity is false as printed while this one survives.
- [G3 — the pole string](xihorn-rust-results-g3-pole-string.md) — the Rust account, with the same table and the same 1e−25 agreement.

## Notes

- The source's summary: "the residues … agree … Every structural claim (22) and (23) make is true. … **the derivation is not**."
- This verification does **not** repair (22)'s derivation; it is one of the claims re-derived in G3 from a split inside the disc of convergence (U₀ = e^{−2} = 0.135).
