# The minimal witness: (z² − 6z + 13)·e^z

**Kind:** Claim
**Status:** CHECKED (exhaustive finite, exact Sturm counts, d ≤ 50, n ≤ 12)
**Area:** xi-horn
**Source:** [`xi-horn/initial-segments.md`](../../xi-horn/initial-segments.md) — §4 "The minimal witness: (z² − 6z + 13)·e^z"

## Statement

> **(z² − 6z + 13)·e^z** has E(2) = {2, 3} and E(3) = {1, 2, 3}: the shift
> n = 0, which carries the hardest information, is *invisible* at degrees
> where later shifts have already failed.
>
> ```
> E(1) = ∅
> E(2) = {2, 3}            <-- 0, 1 ∉ E(2): not an initial segment
> E(3) = {1, 2, 3}         <-- 0 ∉ E(3):    not an initial segment
> E(d) = {0, 1, 2, 3}      for every 4 ≤ d ≤ 50   ( = E_∞ = [0, ν), ν = 4 )
>
> D(n) = 4, 3, 2, 2        n = 0, 1, 2, 3
> ```

## Hypotheses and notation

- `f(z) = (z² − 6z + 13)·e^z`, zeros `3 ± 2i` — one conjugate pair, **center
  x₀ = 3 in the right half-plane**, height β₀ = 2. This is [gorz-gap.md](../../xi-horn/gorz-gap.md)'s exactly
  solvable family §7.1 at (b, c) = (−6, 13).
- Taylor data `a(m) = c_m = m² − 7m + 13`:
  ```
  m      0   1   2   3   4   5   6   7   8
  a(m)  13   7   3   1   1   3   7  13  21      positive for every m (min 1)
  ```
- E(d), D(n), ν, E_∞ as in [Proposition 1](xihorn-initial-segments-p1-three-equivalences.md) / [gorz-gap.md](../../xi-horn/gorz-gap.md) §1.
- Closed form, from [gorz-gap.md](../../xi-horn/gorz-gap.md) (13), for alive shifts
  (Δ_n = −16 + 4n < 0):
  ```
  D(n) = ⌊r(n)⌋ + 1,   r(n) = 4c_n/|Δ_n| = 1 + x₀(n)²/β_n² ,
  x₀(n) = 3 − n  (the center, drifting left one unit per derivative),
  β_n²  = 4 − n  (the height, sinking to extinction at ν = 4).
  ```

## Proof / evidence

Exact tables for d ≤ 50, n ≤ 12, obtained by exact Sturm real-root counting on
the sequence (§10: "hyperbolic(p) ⟺ # distinct real roots of
p/gcd(p,p′) == deg(p/gcd(p,p′))", all arithmetic in Fractions); the closed form
(13) predicts every entry and "everything below is both predicted by its closed
form (13) and verified independently by exact Sturm real-root counting on the
sequence".

Closed form check: r(n) = 13/4, 7/3, 3/2, 1 — "the center **crosses the origin
at n = 3**, and while it crosses, the ratio x₀²/β² — the only thing degree-d
Jensen polynomials can see — collapses. The defect is *easiest* to detect just
before it dies and *hardest* at n = 0."

Two further checks recorded in §4 and §9:

- Turán margin `a(n+1)² − a(n)a(n+2)` for n = 0…5: `10, 2, −2, −2, 2, 10` —
  "fails exactly on E(2) = {2, 3}".
- `E_{f′}(2) = {1, 2} ⊄ E_f(2) = {2, 3}` with f′ = (z² − 4z + 7)e^z, "so
  differentiation *created* an exception at a shift where f had none";
  and `D(0) = D(2) + 2`, `D(1) = D(2) + 1` — "the staircase attained with
  equality".

## Dependencies and related results

- [gorz-gap.md](../../xi-horn/gorz-gap.md) §7.1 (the solvable family), closed form (13), and §7.5 (the question
  this witness answers).
- [Proposition 1](xihorn-initial-segments-p1-three-equivalences.md) (initial segment ⟺ D non-decreasing) and
  [Proposition 2](xihorn-initial-segments-p2-staircase.md) (the staircase, saturated here).
- Together with [Witness A](xihorn-initial-segments-witness-a-order-half.md) and
  [Witness B](xihorn-initial-segments-witness-b-final-segment.md) this is the file's answer: the
  initial-segment property fails inside the ambient class.

## Notes

- The source gives a **second instance one street over**, not harvested
  separately: `(z² − 8z + 21)·e^z` (zeros 4 ± i√5, a(m) = m² − 9m + 21, minimum
  3/4 at m = 4.5): exact tables give D(n) = 5, 4, 3, 2, 2 and E(2) = {3, 4},
  E(3) = {2, 3, 4}, E(4) = {1, 2, 3, 4} — "a longer anti-diagonal, same
  mechanism".
- This witness is an explicit counterexample to the initial-segment property
  **inside the ambient class** (real entire, genus 1\*, all Taylor coefficients
  positive) — "It does not [repair it]. The initial-segment property fails
  **inside the ambient class**."
- The source's honesty clause about trajectories elsewhere in the file applies
  to the cosh witnesses; this e^z witness's tables are exact Sturm counts.
