# The window condition — zero-free in the strip, or blind by construction

**Kind:** Claim
**Status:** PROVED (paper argument)
**Area:** xi-horn
**Source:** [`xi-horn/positivity-generator.md`](../../xi-horn/positivity-generator.md) — §6 "The window condition — zero-free in the strip, or blind by construction"

## Statement

> Theorem 1 needed one hypothesis and it is checkable: **Φ̂ must not vanish on
> the closed strip `|Im z| ≤ ½`.** The strip is not chosen — §1.2's weight
> `e^{|u|/2}` forces it, and it is the critical strip in the *z*-coordinate.
>
> The failure mode is exact rather than approximate. If `Φ̂(z₀) = 0` with
> `|Im z₀| ≤ ½`, then every *f* in the closed span of φ's translates has
> `f̂(z₀) = 0`, so a zero of ζ at `ρ = ½ + iz₀` contributes **exactly zero** to
> W(f) for every member of the family. The family is not merely insensitive to
> such a zero; it cannot represent it at all.
>
> The condition has a clean name. Windows produce real entire Φ̂ of exponential
> type or Gaussian decay, and for those, zero-free off the real axis is exactly
> `Φ̂ ∈` Laguerre–Pólya — the same class RH asks Ξ to be in.
>
> > **A window can only test for Laguerre–Pólya failure if it is itself
> > Laguerre–Pólya.**
>
> **A window that is blind, exhibited.** Take the two-step window
> `φ = 1_{[−1,1]} + 0.46·1_{[−2,2]}`, a perfectly ordinary compactly supported
> even test function whose comb is a finite sum. Its transform factors:
>
> ```
> Φ̂(r) = (2/r)·(sin r + 0.46·sin 2r) = (2/r)·sin r·(1 + 0.92·cos r)          (9)
> ```
>
> The second factor vanishes when `cos r = −1/0.92`, which has no real solution
> and instead gives, at every odd multiple of π,
>
> ```
> z₀ = kπ ± i·0.414064518876 ,   k odd ,   |Im z₀| = 0.4141 < ½              (10)
> ```
>
> — inside the strip. Verified: `Φ̂(z₀) = 4.3e−43` at 40 digits, machine zero, at
> `γ = π, 3π, 5π, 7π, 9π, …`
>
> **So a certificate built on this window would be positive definite even if ζ
> had zeros at `ρ = 0.9140645189 + ikπ` for every odd k** — an infinite
> arithmetic progression of heights, at real part 0.914, contributing nothing
> whatsoever to the form. No amount of depth, mesh refinement, or interval
> rigour repairs it, because the blindness is exact and is a property of the
> window alone.

## Hypotheses and notation

- φ a real even window with Φ̂ its transform; the closed span of the translates
  `{φ(· − a)}`; W the Weil form of §1; `γ_ρ = (ρ − ½)/i`.
- `Φ̂` real entire of exponential type or Gaussian decay; `Φ̂ ∈` Laguerre–Pólya
  means real entire of genus 1\* with only real zeros (the class RH asks Ξ to be
  in).
- The weight `e^{|u|/2}` of the continuity norm `N(f)` is what forces the strip
  `|Im z| ≤ ½`; "it is the critical strip in the *z*-coordinate".

## Proof / evidence

- The failure mode is exact, not approximate: `Φ̂(z₀) = 0` implies
  `f̂(z₀) = 0` for every f in the closed span, hence an exact null contribution
  from any zero at `ρ = ½ + iz₀`.
- The exhibited window's off-axis zeros are computed exactly from (9): the
  factor `1 + 0.92·cos r` has no real root and vanishes at
  `r = kπ ± i·0.414064518876`, k odd; verified numerically to machine zero
  (`Φ̂(z₀) = 4.3e−43` at 40 digits).
- The source also explains rh19's notch as the harmless real-axis case of the
  same phenomenon: at `Δ* = 2π/γ₁ = 0.444521` the kernel's first null lands on
  the first zero, `|B(γ₁)|² = 4.6e−67`, and the certified margin drops by 35×.
- On the arc's own windows the source argues, from the r⁻⁴ decay quoted in
  rh30 §7, that the family is `ĥ = ψ̂²` with `ψ̂(r) = 2sin(ar)/r`, whose zeros
  `r = kπ/a` are all real — "so on that reading the arc's certificates have
  blind spots only *on* the critical line, where blindness is harmless for RH
  and costs only margin. That is an inference from a decay rate, not a check."

## Dependencies and related results

- [Theorem 1](xihorn-positivity-generator-t1-generator-minimal.md) needs exactly this hypothesis; the claim is the
  converse warning attached to it.
- rh19's notch (the real-axis case), rh30 §7 (the quoted r⁻⁴ decay), and rh34
  are the related arc documents.
- Build-list item 1 of the source is the missing check: "Run §6's zero-free test
  on every window in rh17–rh30 … Expected result: all real, all harmless. It is
  a day's work, it is the only thing in this file that could invalidate an
  existing certificate, and it has never been done." (An open `[ ]` item — not
  itself harvested.)

## Notes

- The source introduces this in the file's introduction as one of "Two further
  results [that] follow from the same frame … there is a checkable admissibility
  condition on windows that the arc has never applied", and states it under a §6
  heading rather than under a numbered theorem. It is harvested here as a Claim
  on that introduction's own billing; the two mathematical contents above (the
  exact blindness mechanism, and the exhibited blind window) are quoted
  near-verbatim from §6.
- The source is explicit about the scope (§8 item 4): "§6's blind window is a
  construction, not a discovery about ζ. It shows that an admissible-looking
  window can be exactly blind to an explicit progression of off-line zeros. It
  does not show that any window the arc used has that defect — §6.2 argues from
  the quoted decay rate that the arc's family passes, and that argument is an
  inference, not a check."
- "A window can only test for Laguerre–Pólya failure if it is itself
  Laguerre–Pólya" is presented by the source as a design rule ("The condition
  has a clean name"); no separate proof is given for that one-line reading
  beyond the exactness of the failure mode.
