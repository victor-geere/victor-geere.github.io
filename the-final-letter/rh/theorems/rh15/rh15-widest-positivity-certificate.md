# The widest positivity certificate (support 6, mesh 0.015, 60-digit arithmetic)

**Kind:** Claim
**Status:** VERIFIED (numerical, 60-digit arithmetic; for a kernel correct to 10⁻⁹; evidence absent; the source is prose only, no committed evaluator)
**Area:** rh-html
**Source:** [`rh15.html`](../../html/rh15.html) — §5 "The equation: one inequality per node"

## Statement

> Support **6** at mesh **0.015** — 799 nodes, the kernel out to v = 11.97, gears to e¹² — run through (4) in **60-digit arithmetic**: all 799 prediction errors positive, max|ρ<sub>k</sub>| = 0.301754, σ<sub>798</sub>² = 2.14×10⁻⁵. Not "positive to within rounding": positive as a fact about the computed kernel, with the floating-point question removed from the discussion.

and the source's own honest form of a certificate (§6):

> the honest form of a certificate is *"the recursion at mesh Δ stays inside the unit disc to depth n, for a kernel correct to 10⁻⁹, with margin 0.40–0.70"* — a statement that would become unconditional under interval arithmetic on the same quadrature, which is a finite amount of engineering and no new mathematics.

## Hypotheses and notation

- The recursion is (4) of §5: σ₀² = E(0), ρ<sub>k</sub> = [E(kΔ) − ∑<sub>i&lt;k</sub>a<sub>k−1,i</sub>E((k−i)Δ)]/σ<sub>k−1</sub>², σ<sub>k</sub>² = σ<sub>k−1</sub>²(1 − ρ<sub>k</sub>²) > 0 ⟺ |ρ<sub>k</sub>| < 1.
- The kernel E is built from 18120 prime powers below 200000 and the archimedean transform on one uniform step to r = 12000; its own measured error bar is 1.6×10<sup>−9</sup> absolute against E(0) = 3.2×10<sup>−2</sup>, and its agreement with the zeros-side computation is 8.7×10<sup>−9</sup> to 6.4×10<sup>−7</sup> of scale.
- The certificate is a prefix of the sequence at one mesh; the widest here is 799 nodes.

## Proof / evidence

The source reports the 60-digit run: all 799 prediction errors positive, max|ρ<sub>k</sub>| = 0.301754, σ<sub>798</sub>² = 2.14×10<sup>−5</sup>, and notes the one check that the test has teeth: subtracting t copies of the γ₁ atom from the kernel and bisecting for the failure of positivity gives t* = 1.000245, where the recursion flags the boundary at the same place the eigenvalue crosses zero. It also measures the smallness of the claim (§6): the kernel's own error bar is 1.6×10<sup>−9</sup> absolute, and propagation moves eigenvalues above 10<sup>−10</sup> of scale by less than 2×10<sup>−3</sup> relative, those below by up to 9%, with the Schur margins moving by at most 2.8×10<sup>−6</sup>.

## Dependencies and related results

- [P1 — Schur/Levinson–Durbin equivalence](rh15-p1-schur-levinson-durbin-equivalence.md) — the theorem the certificate instantiates at a finite depth.
- [RH ⟺ the Schur sequence never leaves the open unit disc](rh15-rh-equivalent-schur-sequence.md) — the equivalence whose prefix this is.
- [The recursion prints the zeros (rh16 §2)](../rh16/rh16-inverse-map-zeros-from-primes.md) — rh16 turns the same recursion into a constructive map from primes to ordinates.
- [The merged kernel: one function, two theories](../rh14/rh14-merged-kernel-one-function.md) — E at the same construction.

## Notes


- The 60-digit arithmetic removes the floating-point question for the computed kernel, but the kernel itself is known only to the stated error bar (1.6×10<sup>−9</sup> absolute against E(0) = 3.2×10<sup>−2</sup>); the source says an interval-arithmetic version would make the statement unconditional.
- The source's summary: "Not 'positive to within rounding': positive as a fact about the computed kernel."

- **Evidence absent (session-003 audit repair 3, 2025-10-06).** No script, log or other evaluator is named in the document or in the source it was harvested from. The number(s) above therefore rest on the source's prose alone: nothing committed in this repository computes them. The label carries `evidence absent` for that reason and for no other — it is **not** a claim that the result is wrong, and it is **not** a demotion of the mathematics. It is the qualifier the archive already uses well elsewhere: `research/twin-prime-parity/checks/06-numerical-checks.md:378` discloses in the same spirit that `explicit_formula.log` "DOES NOT EXIST".
