# Theorem 1 — the generator, and it is minimal

**Kind:** Theorem
**Status:** PROVED (paper argument)
**Area:** xi-horn
**Source:** [`xi-horn/positivity-generator.md`](../../xi-horn/positivity-generator.md) — §3 "Theorem 1 — the generator, and it is minimal"

## Statement

> **Theorem 1.** Let φ be a real even window whose transform Φ̂ is entire and
> zero-free on the closed strip `|Im z| ≤ ½` (the Gaussian qualifies; see §6).
> Let E be as in (5). Then the following are equivalent:
>
> **(i)** RH.
> **(ii)** E is a positive-definite function on ℝ.
> **(iii)** E is bounded on ℝ.
> **(iv)** W(f) ≥ 0 for every finite combination of translates of the single
> function φ.

## Hypotheses and notation

- Convention of [rh10](../../html/rh10.html) §1 and [horn-helix.md](../../xi-horn/horn-helix.md) §8: for an even test function *h* with Fourier
  partner *g*, `h(r) = ∫g(u)e^{iru}du`, and
  `Σ_ρ h(γ_ρ) = h(i/2) + h(−i/2) + (1/2π)∫ h(r)·[Re ψ(¼ + ir/2) − ln π] dr − 2 Σ_{n≥2} Λ(n)/√n · g(log n)` (1),
  with `γ_ρ = (ρ − ½)/i`.
- **W(f)** is the right-hand side of (1) evaluated at `h = |f̂|²`. Weil's
  criterion: `RH ⟺ W(f) ≥ 0 for every admissible f` (2).
- **E** is the Weil pairing of two translates of one window, a function of their
  separation alone:
  ```
  E(v) = 2Φ̂(i/2)²·cosh(v/2)
         + (1/2π)∫ Φ̂(r)²·cos(rv)·ψ̃(r) dr
         − Σ_{n≥2} Λ(n)/√n · [ G(log n − v) + G(log n + v) ]                 (5)
  ```
  with `ψ̃(r) = Re ψ(¼ + ir/2) − ln π` and `G` the inverse transform of `Φ̂²`.
- Translation orbit: for `f = Σ_m c_m·φ(u − a_m)`, `W(f) = Σ_{m,m'} c_m c_{m'} · E(a_m − a_{m'})` (4).
- Unconditional spectral form: `E(v) = Σ_ρ Φ̂(γ_ρ)²·cos(γ_ρ v)` (6).
- "Positive-definite function on ℝ" is in the Bochner sense: E is the cosine
  transform of a finite positive measure.

## Proof / evidence

The source proves the four implications in §3.

- *(ii) ⟺ (iv)* is the definition: by (4), W on the translation orbit of φ is
  the quadratic form of the kernel E, and nonnegativity of that form for all
  finite `{c_m, a_m}` is positive-definiteness of E.
- *(i) ⟹ (ii).* "Under RH every γ_ρ is real and `Σ_ρ w_ρ = E(0) < ∞`, so (6)
  exhibits E as the cosine transform of the finite positive measure
  `ν = Σ_ρ w_ρ δ_{γ_ρ}`. Bochner. ∎"
- *(ii) ⟹ (iii).* "A positive-definite function satisfies `|E(v)| ≤ E(0)`. ∎"
- *(iii) ⟹ (i).* Laplace-transform the arithmetic side (5) on `v ∈ (0,∞)`. The
  pole term gives `Φ̂(i/2)²[1/(z−½) + 1/(z+½)]`; the archimedean term gives
  `(1/2π)∫Φ̂(r)²ψ̃(r)·z/(z²+r²)dr`, analytic on Re z > 0; the comb gives, for
  Re z > ½,
  ```
   −Φ̂(−iz)²·(−ζ′/ζ)(z + ½)  +  (entire)                                    (7)
  ```
  So `L(z) = ∫₀^∞ E(v)e^{−zv}dv` is meromorphic on Re z > 0 with a pole at
  `z = ρ − ½` of residue `m_ρ·Φ̂(γ_ρ)² ≠ 0` for every zero ρ of multiplicity
  m_ρ, the residue being nonzero precisely because Φ̂ has no zero in the strip.
  The apparent pole at z = ½ cancels exactly: `−ζ′/ζ` has residue +1 at s = 1,
  contributing `−Φ̂(−i/2)² = −Φ̂(i/2)²`, against the pole term's `+Φ̂(i/2)²`. If
  E is bounded then `|L(z)| ≤ ‖E‖_∞/Re z` on Re z > 0, so L has no pole there,
  so no zero has β > ½; the functional equation's pairing ρ ↔ 1−ρ removes
  β < ½. ∎

Numerical cross-check recorded in §2.1: (5) against (6) at σ = 0.15 —
22,986 prime powers below 260,000 on one side, 30 ordinates on the other,
40 digits — max relative difference 1.9e−23.

## Dependencies and related results

- Weil's criterion (1952), the explicit formula of von Mangoldt (1895),
  Bochner's theorem (1932) — all cited in the §0 disclaimer as classical; (4)
  and (5) are built in §2; (6) is the horn-side twin of
  [horn-helix-revisited.md](../../xi-horn/horn-helix-revisited.md) §3.3's prime horn Ψ.
- [Theorem 2 (no finite family)](xihorn-positivity-generator-t2-no-finite-family.md) shows the generator cannot be taken finite;
  [Theorem 4 (the moment tower)](xihorn-positivity-generator-t4-moment-tower.md) ends by invoking this theorem; the window
  hypothesis is the subject of [the §6 window condition](xihorn-positivity-generator-window-laguerre-polya.md).
- The source states this answers [horn-helix-revisited.md](../../xi-horn/horn-helix-revisited.md) §4.4 item 4 in its
  "finitely-generated" reading, "with a single generator, which is as small as
  a generating set can be".

## Notes

- The source is explicit that this is an **equivalence, not a proof**: "The
  equivalence is exact and it is *circular in the useful direction*"; §8:
  "It moves no wall. Theorem 1 is an equivalence, not a proof." Boundedness of
  an almost-periodic signal is not decidable from a bounded window of it.
- **No margin.** Over `0.1 ≤ v ≤ 30`: `max |E(v)| / E(0) = 0.9999071296` at
  v = 25.56 (σ = 0.15) and `0.9391760521` at v = 17.345 (σ = 0.05); at σ = 0.15
  the kernel "comes within 9.3e−5 of violating its own bound".
- The hypothesis that Φ̂ is zero-free on the closed strip is load-bearing: the
  pole residue `m_ρ·Φ̂(γ_ρ)²` would vanish otherwise, and the family is then
  exactly blind (see the §6 window condition).
- §1.2's continuity inequality `|W(f)| ≤ C·N(f)²` ("W is continuous in N") is
  deliberately not harvested here: the source calls it "orientation rather than
  load-bearing" — "nothing downstream rests on §1.2: Theorem 1 is proved in §3
  by a Laplace transform, not by a density argument".
