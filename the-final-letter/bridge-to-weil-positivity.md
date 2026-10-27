# Which topic can bridge Weil positivity?

**Status:** investigation note, responding to
[`handoff-helix-positivity.md`](handoff-helix-positivity.md). No theorem is claimed.
The question: *among the topic dossiers, which one can bridge Weil positivity, or has
the potential if further developed?*

**Short answer.** None is a bridge today. The helix is not one (the handoff says so and
§6 below explains why it cannot be). The best **potential** is
[`self-adjoint-ccm`](topics/self-adjoint-ccm/README.md) — bridge B4, a self-adjoint
operator with point interactions at the prime logarithms — landing in
[`prime-spectrum-tensor`](topics/prime-spectrum-tensor/README.md), which owns the form
`W`. The advertised Lee–Yang route is now **closed** by the geometric programme's own
off-critical polygon zeros; the Euler-product transfer routes are structurally right but
their load-bearing local identity is refuted in the dossiers themselves.

---

## 1. What the handoff establishes

The handoff is correct and useful: the Dirichlet terms form a logarithmic helix, the
phase is monotone, the steps shrink, and summation by parts gives magnitude bounds. It is
equally correct that this controls **rotation and magnitude, not the quadratic form**:

- the helix is built from `n^{-σ}` and `t log n`, so it is additive and applies verbatim
  to Davenport–Heilbronn; it fails the litmus (§3.5 of the handoff);
- a scalar bound `|Σ z_n| ≤ …` is not a positivity statement;
- the block cross terms `W_{j,k}` carry either sign.

So the helix can supply only two of the handoff's own requirements — an orthogonal block
bookkeeping (B2) and scalar summation-by-parts tails (part of B6). It cannot supply B1
(the `A_j`), B3 (the operator), B4 (the measure) or B5 (the Euler-product input). The
rest of this note looks for those.

## 2. The filter: what a bridge has to be

Two constraints sharpen the search.

1. **The uniform no-go.** Any mechanism that bounds `W` below uniformly on the cone is
   RH-equivalent (see [`WEIL-POSITIVITY.md`](topics/prime-spectrum-tensor/WEIL-POSITIVITY.md)
   §2): an off-line zero drives a modulated packet to `−∞` with bounded norm. A bridge
   therefore cannot be a soft estimate; it must be a **structural identity or
   construction** — a positive measure, a self-adjoint operator, or an exact
   sum-of-squares — whose positivity is built in.
2. **The DH litmus.** It must use the Euler product in a way that a sum of two `L`-functions
   mod 5 cannot reproduce.

Under those two filters, the handoff's B1–B7 reduce to one question: *which dossier contains
a construction that manufactures positivity and uses the primes?*

## 3. The map

| dossier | mechanism | what is actually there | what is missing | verdict |
|---|---|---|---|---|
| [`iota-helix-function`](topics/iota-helix-function/README.md) | phase bookkeeping | helix coordinates, phase increment, radius monotonicity, finite eta positivity (T1–T7) | any quadratic form, any arithmetic input | **not a bridge** (additive) |
| [`prime-spectrum-tensor`](topics/prime-spectrum-tensor/README.md) | the form `W` itself | `W`'s definition and Theorem C (source claim); finite Gram PSD by Cholesky (T8/T10); DH-shaped negative witness (T9) | the infinite positivity — which *is* RH | **the host**, not the engine |
| [`self-adjoint-ccm`](topics/self-adjoint-ccm/README.md) | B4: self-adjoint point-interaction operator at `m log p` | matching unitarity (T5), frequency symmetry (T6), prime-power cutoff dictionary (T7), torsion/cylinder geometry (T1–T4) | rigorous operator and self-adjointness (Gap 2), WKB (3a), trace formula (3b), spectrum identification (Gap 4) | **best potential** |
| [`adelic-transfer-operator`](topics/adelic-transfer-operator/README.md), [`rh-mtc-padic`](topics/rh-mtc-padic/README.md) | B5: per-prime transfer operator, Euler factors | finite MTC data, positive local weights, Verlinde non-negativity, geometric-series bookkeeping | the local RT identity is **false** (a zero column; the dossier's own computation), and no operator exists | right shape, broken foundation |
| [`harmonic-categorical-hilbert-polya`](topics/harmonic-categorical-hilbert-polya/README.md) | B3/B4: Hermitian truncations `H_k`, determinant | finite Hermitian/spectral algebra | determinant identity, uniform convergence, Hurwitz passage; and the transfer operator is built from the greedy sine, which is additive | second-tier |
| [`geometric-dynamical-phase-transitions`](topics/geometric-dynamical-phase-transitions/README.md) | B3: Lee–Yang / ferromagnetic confinement | finite Ising Lee–Yang circle theorem (T55); transfer-matrix no-gos (B15/B18/B20) | F.4 itself — and the polygon zeros are **not** confined (below) | **closed** for F.4 |
| [`transfer-operator-proof`](topics/transfer-operator-proof/README.md) | B4 via a transfer operator | diagonal Euler-product model; Fredholm bookkeeping | the pairing is an **indefinite Krein form** (T7); the source's own audit calls the argument circular | dead |
| [`gdst`](topics/gdst/README.md), [`ghd-correlation-kernel`](topics/ghd-correlation-kernel/README.md), [`greedy-harmonic-decomposition`](topics/greedy-harmonic-decomposition/README.md) | B2 via PSD kernels | PSD Gram matrices by construction | the kernels are greedy/additive; the archive's `vanishing_result.md` says the greedy kernel gives **no** Fredholm determinant vanishing at the zeros | dead (DH-blind) |
| [`riemann-helix`](topics/riemann-helix/README.md), [`geometric-reformulation`](topics/geometric-reformulation/README.md), [`frozen-truths`](topics/frozen-truths/README.md) | torsion = prime measure; kernel positivity | finite torsion/geometry | distributional limit and the RH equivalence; the objects are additive | open, not positivity |
| [`qefe`](topics/qefe/README.md), [`topological-zeta`](topics/topological-zeta/README.md), [`periodic-orbits`](topics/periodic-orbits/README.md), [`factorisation-theta`](topics/factorisation-theta/README.md) | MTC/theta positivity | unitary `S`-matrices, positive quantum dimensions, theta positivity | the local RT identity is refuted; no map to `W` | speculative |

## 4. The recommendation: `self-adjoint-ccm`

**The construction.** The CCM blueprint's operator is

```
D_λ = i d/dx + Σ_{p^m ≤ λ²} c(p^m) p^{−m/2} δ(x − m log p mod L),   L = 2 log λ,
```

on `L²[0,L]` with periodic boundary conditions, where `c(p^m)` comes from `−L'/L(s)`; for
`ζ`, `c(p^m) = log p` for every `m ≥ 1`, matching `Λ(p^m)`. The matching condition is
unitary (T5), and the cutoff dictionary `p^m ≤ λ² ⇔ m log p ≤ 2 log λ` is proved (T7).

**Why it is the right shape.** The positivity is not estimated; it is manufactured:

```
D self-adjoint  ⇒  spectrum ⊂ ℝ  ⇒  μ = Σ δ_{γ_n} ≥ 0  ⇒  W(g) = Σ ĝ(γ_n) = ∫ ĝ dμ ≥ 0.
```

This is exactly bridge B4, and it satisfies both filters:

- **No uniform estimate is used**, so the §2 no-go is not violated: the identity is
  structural.
- **The arithmetic is essential.** The point interactions sit at `m log p` with
  Euler-product coefficients. DH has no Euler product, so `−L'/L` is not supported on
  prime powers and the operator has no such delta set. The litmus is passed by
  construction, not bolted on.

**What the dossier already has.** A finite core: the helix geometry and torsion identity
(T1–T4), unitarity of the matching condition (T5), conjugate-mode symmetry of the CCM
frequencies (T6), and the prime-power cutoff dictionary (T7). These are the pieces a finite
truncation `D_{λ,N}` needs.

**What is missing, in order.**

1. **Gap 2 — a rigorous operator.** The blueprint writes `D_λ` down; no domain, no
   self-adjointness proof exists. This is the real target. Point-interaction operators on a
   circle are a well-understood class (Krein/von Neumann extensions, or quadratic forms), so
   the question is the *density* of the points `m log p` and the size of the coefficients
   `Λ(p^m)p^{−m/2}`, not the class of operator.
2. **Gap 3a — WKB/resolvent asymptotics** near zero energy with many weak interactions.
3. **Gap 3b — the trace formula** (Krein spectral shift, error `O(L^{−1/3+ε})` in the
   source's expectation).
4. **Gap 4 — spectrum identification**, conditional on 3.

**A circularity to avoid.** The source's phase `φ` is defined by `φ(γ_n) = 2πn`, i.e. from
the zeros, and assumes GRH. The positivity route must use `D_λ` directly and **not** the
helix `φ`; otherwise the argument assumes what it proves. This is the precise sense in
which the handoff's helix is not the bridge: the useful object is the prime-indexed
operator, not the zero-indexed curve.

**Where it lands.** In `prime-spectrum-tensor`: the spectral measure of `W` is
`Σ δ_{γ_n}`; identifying `D`'s spectral measure with it is exactly `W ≥ 0`. The finite
Cholesky algebra (T8/T10) is the verifier for the finite truncations, and the DH-shaped
negative witness (T9) is the litmus in matrix form. `finite-explicit-formula` supplies the
identity that converts spectrum to `W`.

**Milestones.**

| step | content | nature |
|---|---|---|
| M0 | the finite truncation `D_{λ,N}` as an explicit Hermitian matrix; interval spectrum; compare with the first zeros | finite, falsifiable, formalisable with the existing `IBox` layer |
| M1 | self-adjointness of the limit (quadratic form / resolvent / KLMN) | the analytic crux |
| M2 | trace formula with explicit error (Krein) | analysis |
| M3 | identify the limit measure and land `W ≥ 0` | synthesis |

M0 alone is worth doing: a Hermitian finite matrix whose spectrum visibly approaches the
zeros is either the first honest positive-measure certificate or a clean refutation.

## 5. Runner-up: the adelic transfer operator

The per-prime transfer operator with Euler factors is the other structurally right
mechanism: a positive kernel gives a Perron–Frobenius eigenfunction, hence a positive
functional, and the local factors are the Euler product itself. But the dossiers'
foundation is broken: [`periodic-orbits`](topics/periodic-orbits/README.md) records that
the source retracts the local identity `RT(β) = p^{−n}`, and
[`rh-mtc-padic`](topics/rh-mtc-padic/README.md) computes the repair's "surviving sum" to
be identically zero (the column `S_{jℓ}` vanishes). A development would have to replace
the RT weight by a genuinely positive local transfer operator and prove its
Perron–Frobenius eigenfunction — a larger leap than M1, with a cleaner payoff.

## 6. The dead ends, with evidence

- **Lee–Yang / F.4 is closed.** The geometric programme certifies two zeros of the `N=2`
  polygon with real parts in disjoint intervals around `0.57802` and `0.80014`
  (`polygon_zero.py`, C46; recorded at B26 in
  [`BRIDGES.md`](topics/geometric-dynamical-phase-transitions/BRIDGES.md)), and the exact
  zero at `s=0` is off the line (T62/T63). So the polygon zeros are not confined to any
  single vertical line, and F.4's "zeros confined to a line for every `N`" is impossible
  for this object; the summary itself says the most one can expect is clustering. The
  finite Ising Lee–Yang theorem (T55) remains a true model, but it is not the polygon.
  B15/B18/B20 additionally no-go the register, upper-triangular and nonnegative
  transfer-matrix classes.
- **Helix.** Additive; identical for DH (handoff §3.5). It can supply block bookkeeping and
  scalar tails, not positivity.
- **Transfer-operator-proof.** The pairing is an indefinite Krein form (T7), and the
  source's own Part VI finds the argument circular.
- **Greedy/GHD/GDST.** The kernels are PSD by construction but greedy and additive; the
  archive's `vanishing_result.md` states the greedy kernel gives no Fredholm determinant
  vanishing at the zeros.
- **Nested spheres / continuous cone.** The decisive steps are withdrawn: the local
  diagonal with `c₁ = 1/2` is false (the canonical Lemma 6.3 gives `−1 + R∫φ²`), and the
  differential inequality is retracted.

## 7. One-paragraph conclusion

The handoff is right that the helix is bookkeeping. The bridge with the right mechanism is
the CCM point-interaction operator — the only dossier where positivity is manufactured by
self-adjointness and the arithmetic enters through the prime-power deltas — and it must
land in the Weil current of `prime-spectrum-tensor`, with `finite-explicit-formula`
supplying the identity. Its first concrete step, a finite Hermitian truncation whose
spectrum approaches the zeros, is small enough to try now and decisive either way. The
Lee–Yang alternative is closed by the programme's own off-critical polygon zeros, and the
Euler-product transfer alternative needs its local identity rebuilt from scratch.

**Note on provenance.** The handoff cites a "working status page §3.4 (kept outside this
folder)"; no such section exists in the repository's `status.html`. The assessment it
describes is now in `topics/prime-spectrum-tensor/WEIL-POSITIVITY.md` §2–§4.
