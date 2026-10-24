# (22) — the pole string of Γ_Φ (false as printed)

**Kind:** Claim
**Status:** REFUTED (the displayed identity is false as written: its derivation splits at u = 1, outside the radius of convergence π/4; every structural claim it makes is nevertheless true)
**Area:** xi-horn
**Source:** [`xi-horn/TODO.md`](../../xi-horn/TODO.md) — §G3 "Check CONTINUATION (22)'s pole string" and §E14

## Statement

> (22) claims Γ_Φ is meromorphic on ℂ with simple poles at w = −1, −3, −5, …
> **only** and residue 4c_{2k} at w = −(2k+1), where Φ(u) = Σ c_{2k}u^{2k};
> (23) that C(w) = Γ_Φ(w)/Γ(w+1) is entire. **No c_{2k} had ever been computed**,
> so none of it had ever been checked.

As printed, the identity reads

```text
Γ_Φ(w) = 4·Σ_{k≥0} c_{2k}/(w + 2k + 1)  +  4∫_1^∞ u^w Φ(u) du
```

and is obtained, the source says, by "splitting at u = 1 and using Φ's Taylor
series at the origin". The source's verdict:

> So the series in (22) **diverges** and the displayed identity is false as
> written. **The conclusion survives; only the derivation fails.**

## Hypotheses and notation

- Φ(u) = Σ c_{2k}u^{2k} is this directory's even weight; Γ_Φ(w) = 4∫₀^∞ u^w Φ(u)du; C(w) = Γ_Φ(w)/Γ(w+1).
- The claimed pole set is w = −1, −3, −5, … **only**, with residue 4c_{2k} at w = −(2k+1).
- The radius of convergence of Φ's Taylor series at the origin is π/4 = 0.7854 < 1, so the split point u = 1 lies outside it.

## Proof / evidence

The source both measures and diagnoses the failure. Measured: "G3 measures it: |c_m|^{1/m} runs 1.25–1.45 over 30 ≤ m ≤ 158, settling toward 4/π = 1.27324 from above, with the coefficients enclosed to 1e−118 relative so the structure is Φ's and not roundoff." Diagnosed: Φ(u) = 2e^{u/2}ω(e^{2u}) with ω built from θ, and θ has Re t = 0 as a natural boundary, so Φ is analytic exactly on |Im u| < π/4 and no further — at u = iπ/4 the shell sum's own terms are (2π²k⁴e^{9iπ/8} − 3πk²e^{5iπ/8})(−1)^k and do not decay at all.

The conclusion is separately verified: split anywhere inside the disc instead (G3 uses U₀ = e^{−2} = 0.135) and the same argument gives the same pole set, the same residues 4c_{2k}, and (23) entire — "All three are checked." The replacement evaluator agrees with `mellin::eval` to 8.8e−43 at w = 2, 4, 10.

## Dependencies and related results

- [(23) — C(w) = Γ_Φ(w)/Γ(w+1) is entire](xihorn-todo-23-c-is-entire.md) — the companion claim, which survives.
- [G3 — the pole string](xihorn-rust-results-g3-pole-string.md) — the Rust account of the same check.
- [(G1c) — the piece below V₀](xihorn-todo-g1c-piece-below-v0.md) — uses the closed-form tail that (22) also rests on.

## Notes

- **Fidelity note:** the source is explicit that this is a refutation of the *displayed derivation and identity*, not of the pole data: "**The conclusion survives; only the derivation fails.**" The wrong step is "splitting at u = 1"; §7's "For Re w ≤ −1 use the split (22)" must go with it, per E14.
- The source also flags **E15**: `mellin.rs`'s doc comment claimed meromorphic continuation below w = −1; at w = −1.5 the routine returns 2.14e4 where the answer is −7.74, an error attributed by prediction against measurement over fifty-one decades.
