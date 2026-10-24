# Out-of-reach items — the 2026 reassessment

**Source:** [`OP-01-04-16-17-18-tractability.md`](../../rh/research/twin-prime-parity/open/OP-01-04-16-17-18-tractability.md); [`research/open.md`](../../rh/research/open.md) §4–5.
**Verdict:** none of OP-1, OP-4, OP-16, OP-17 or OP-18 is newly tractable. OP-18 is reclassified as not well-posed as phrased.

## The structural fact

Every general tool that currently breaks the parity barrier produces a **logarithmic** average, an average over shifts/scales, or a conditional statement — not a natural-density statement for a fixed shift. Tao states the reason for the entropy-decrement method explicitly; Frantzikinakis–Lemańczyk–de la Rue show the structural property that makes the log-averaged theory work fails for Cesàro averages. The gap is structural, not quantitative.

## OP-1 — un-averaged two-point Chowla

`Σ_{n≤x} λ(n)λ(n+2) = o(x)`.

- Tao (2015) proves the **log-averaged** two-point statement.
- Matomäki–Radziwiłł–Tao average over shifts; the conjecture remains unproven for any fixed `k ≥ 2`.
- Helfgott–Radziwiłł get almost-all scales, not a fixed scale.
- Pilatte (2023) gives the best log-averaged bound; Klurman–Mangerel–Teräväinen get full upper logarithmic density; Jaskari–Sachpazis are conditional on a Landau–Siegel zero.
- 2026 unrefereed preprints (Guo, Hughes) are still logarithmic averages.

**Status:** OPEN, out of reach. The finite-prefix theorem (Lean-certified) shows no computation can decide it.

## OP-4 — k-point Chowla and Sarnak

`Σ λ(n+h₁)⋯λ(n+h_k) = o(x)` for distinct `h_i`.

- Un-averaged Chowla for all `k` implies Sarnak’s Möbius-disjointness.
- The only equivalence proved is **log-averaged** (Tao, Thm 1.8); the un-averaged equivalence is open.
- Even the log-averaged **even** `k ≥ 4` case is open; `k=1` is PNT, `k=2` log-averaged is Tao, odd `k` is Tao–Teräväinen.

**Status:** OPEN for `k ≥ 2`; out of reach.

## OP-16 — twin primes and Selberg’s parity barrier

`π₂(x) ≫ x/(log x)²`; the gap from Chen’s `P₂` to `P₁` is the parity barrier.

- Bounded gaps (`H₁ ≤ 246`, unrefereed `≤ 240`) are not twins.
- Friedlander–Iwaniec break parity only for a thin sequence with an extra Type-II/bilinear axiom, not for `(n,n+2)`.
- Tao–Teräväinen get twin-prime asymptotics only conditionally on a Siegel zero.

**Status:** OPEN, out of reach; parity unbroken for `(n,n+2)`.

## OP-17 — Sarnak’s Möbius-disjointness

Log-Sarnak holds for broad classes; un-averaged only for special classes. The Cesàro gap blocks the general case. **Status:** OPEN, out of reach in general.

## OP-18 — positive sign-blind coupling to Ω

Not well-posed as phrased. With `Σ 1_A λ = P_A − N_A`, “positive-density coupling to Ω-parity” collapses to non-vanishing of the λ-correlation, so on a fixed sign-blind class it is the existential dual of OP-19. Periodic and finite-exponential-sum classes are settled negative. A new exact experiment (`open/op18_coupling_equivalence.py`, sieve to `10⁸`, 6/6 PASS) verifies `S_A = (Σλ + C)/2` with `C = Σλ(n)λ(n+2)` the open correlation.

**Status:** OPEN (heuristic), reclassified; not independent of OP-19.

[Back to folder README](README.md) · [Back to the summary index](../README.md)
