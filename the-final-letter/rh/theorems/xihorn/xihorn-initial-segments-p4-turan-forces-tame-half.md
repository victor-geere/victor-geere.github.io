# Proposition 4 (Turán forces the tame half)

**Kind:** Proposition
**Status:** PROVED (paper argument; 1 327 quadratic models scanned, 0 gaps)
**Area:** xi-horn
**Source:** [`xi-horn/initial-segments.md`](../../xi-horn/initial-segments.md) — §6 "The Turán refinement — what ξ's known coefficient facts do and do not repair"

## Statement

> **Proposition 4 (Turán forces the tame half).** In the same family with all
> a(m) > 0 and ν ≥ 1: if the center is right of ½ (b < −1), then E(2) ≠ ∅.
> Hence positivity + Turán ⟹ b ≥ −1 ⟹ (Proposition 3) every E(d) is an
> initial segment: **in the quadratic model, the Turán property repairs the
> initial-segment property.**

## Hypotheses and notation

- Same family as [Proposition 3](xihorn-initial-segments-p3-dichotomy-quadratic-model.md): `f(z) = (z² + bz + c)e^z`, all
  Taylor coefficients a(m) > 0, and ν ≥ 1.
- Center `x₀ = −b/2`; right of ½ means b < −1; `g := x₀ − β₀²`.
- `E(2) = ∅` is the **Turán property** of the sequence
  `a(m) = c_m = (x₀ − m)² + β₀² − m` (equivalently the Turán inequality
  a(m+1)² − a(m)a(m+2) ≥ 0 everywhere). For ξ the Turán inequalities hold
  unconditionally — Csordas–Norfolk–Varga 1986 ([turan-inequalities.pdf](../../xi-horn/turan-inequalities.pdf),
  restated as [GOR⁺] Theorem 2.1).
- Alive shifts, `D(n) = ⌊r(n)⌋ + 1`, `r(n) = 1 + x₀(n)²/β_n²`, as in
  [Proposition 3](xihorn-initial-segments-p3-dichotomy-quadratic-model.md).

## Proof / evidence

The source's proof, verbatim: "Write g = x₀ − β₀² and suppose E(2) = ∅, i.e.
x₀(n)² ≥ β_n² at every alive n.

(i) *The pair cannot cross the origin while alive.* Let n_c = ⌈x₀⌉ be the first
integer with x₀(n_c) ≤ 0; x₀ > ½ gives n_c ≥ 1 and x₀(n_c) ∈ (−1, 0]. If n_c
were alive, then β²_{n_c} > 0, so β²_{n_c−1} = β²_{n_c} + 1 > 1; but E(2) = ∅ at
n_c − 1 demands β²_{n_c−1} ≤ x₀(n_c−1)² = (x₀(n_c) + 1)² ≤ 1 — contradiction. So
ν ≤ ⌈x₀⌉.

(ii) *Positivity forces g < 0.* a(m) = c_m = (x₀ − m)² + β₀² − m is a quadratic
in m with real minimum −(g + ¼) at m = x₀ + ½ and sub-zero window of width
2√(g + ¼). If g > 0 the window is an open interval of length > 1, hence contains
an integer m with a(m) < 0. If g = 0 the window is (x₀, x₀ + 1): either it
contains an integer, or x₀ ∈ ℤ and a(x₀) = 0. All cases contradict a(m) > 0. So
g < 0, i.e. β₀² > x₀, and ν = ⌈β₀²⌉ ≥ ⌈x₀⌉.

(iii) With (i): ν = ⌈x₀⌉ exactly. At the last alive shift, u := x₀(ν−1) ∈ (0, 1],
and r(ν−1) − 1 = u²/(u + |g|) < u²/u = u ≤ 1, so r(ν−1) < 2 and ν − 1 ∈ E(2) —
contradicting E(2) = ∅. ∎"

Regression recorded in §6 and §9: 1 327 positive-data quadratic models scanned
exactly, 726 with E(2) = ∅, **0 gaps** among them — "and every gap witness the
searches ever produced in this family indeed carries a Turán failure."

## Dependencies and related results

- [Proposition 3](xihorn-initial-segments-p3-dichotomy-quadratic-model.md) (the tame half, b ≥ −1 ⟹ all E(d) initial).
- Csordas–Norfolk–Varga 1986, *The Riemann hypothesis and the Turán
  inequalities*, Trans. AMS **296** ([turan-inequalities.pdf](../../xi-horn/turan-inequalities.pdf), restated as [GOR⁺]
  Theorem 2.1) — the source of ξ's unconditional Turán inequalities.
- §6's boundaries on the repair: "**Log-concavity alone is nowhere near
  sufficient.** Over 4 000 random log-concave positive sequences (ratios
  a(n+1)/a(n) sorted decreasing), **3 923 have a gap** in some E(d), d ≤ 7";
  and "**In the class, a Turán-respecting gap was not found — and not for lack
  of looking.**"

## Notes

- The source flags explicitly that the consequent of this proposition is **only
  the quadratic model**: "**But the repair does not survive past the model.**"
  The refined class question is open: "whether it is a theorem or has a witness
  decides whether CNV86 buys ξ anything here."
- The 4 000-sequence scan "bounds the hypothesis, not the class", since those
  sequences need not be genus-1\* Taylor data.
- The status's numerical qualifier records the §9 regression only; the proof
  itself is the three-part argument above.
