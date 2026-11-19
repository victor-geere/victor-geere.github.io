# HST expansion and gap-bridge roadmap

This is the programme's forward plan after the source reconciliation. It separates
what is now proved, what can be expanded with finite work, and what would require a
new analytic construction. Nothing here is a claim that the Riemann Hypothesis or
GRH follows.

**Baseline.** The finite core has 150 ledger theorems and 14 exact computations.
The graph-backed support matrix for the remaining gaps is [`ROADMAP-SUPPORT.md`](ROADMAP-SUPPORT.md).
The finite items F3/F4 and the O1/O3/O4 descriptions are closed; O5–O7 and P5–P7
are research-programme blockers recorded there.
The source defects R1–R6 and R18 are resolved or refuted in
[`SOURCE-RECONCILIATION.md`](SOURCE-RECONCILIATION.md). The analytic claims R10–R12
remain archived claims.

## 1. Finite combinatorics — the cheapest expansion

These gaps are finite, exact and can be closed without new analysis. They are the
right place to spend the next effort.

### F1. Cylinder intervals and the split lemma — done

**Status.** Proved in Lean over \(\mathbb{Q}\) in the normalised coordinate
\(t=\theta/\pi\).  `Cyl` is a half-open interval \([lo,hi)\subseteq[0,1]\);
`partition n` splits each cylinder at \(lo+1/(n+2)\).  The proved statements are:

- `partition_tiles`: the depth-\(n\) list tiles \([0,1)\) in order;
- `partition_mesh`: every depth-\(n\) cylinder has length at most \(1/(n+1)\);
- `splitAt_left_length`, `splitAt_right_length`: at a split, the left child has
  length exactly \(1/(n+2)\) and the right child has the remainder;
- `partition_cover`: every \(x\in[0,1)\) lies in a depth-\(n\) cylinder;
- `partition_unique`: that cylinder is unique.

This closes F1 and repairs the structural gap behind R5–R7.  The source's
figure is correct; its prose is not.

### F2. Digit-one component law

**Gap.** C8 gives the exact interval decomposition of
`{θ : δₙ(θ)=1}` and its component counts, but no recurrence. Counts begin
`1,2,2,2,2,4,4,4,4,4,4,6,…` and jump to `14` at `n = 41`, so the naive `2k` law
fails.

**Bridge.** Derive a recurrence for the endpoints of the digit-one intervals from
the residual recursion; prove lower and upper bounds for the component count.

**Acceptance.** A proved recurrence, or explicit bounds with matching computed
data. This would close most of O4.

### F3. Relation between the two digit systems — closed by obstruction

**Status.** Closed as an explicit obstruction. The residual rule is harmonic and
binary; the floor rule is factorial and not binary. At `t = 9/10` the floor digits
are `1,2,1,3,0,0`, so the second floor digit is `2`, while every residual digit is
`0` or `1` (T18). The floor expansion is factorial,
`t = Σ δ_k/(k+2)! + r_n/(n+1)!`, not harmonic (T19); the harmonic partial through
five digits is `121/60 > 9/10`, while the factorial partial is exactly `9/10`
(C11).

This proves that no digitwise identification of the two systems can exist without
a carry rule. Finding such a carry rule remains an optional extension, not a gap
needed for the finite programme.

### F4. Cylinder measure and digit frequencies — measure closed, frequency open

**Status.** The exact measure formula is closed: a cylinder indicator integrates
to its length over `unitMeasure` (T55), and the mesh bound is T20/T23. C13 records
the exact digit-one measures for `n = 1,…,15`:
`1/3,1/6,1/10,1/15,2/21,1/14,1/18,2/45,2/55,1/33,1/26,3/91,1/35,1/40,3/136`. At `θ=0` every digit is zero (T124), and C14 records sample selected-digit counts `0,1,3,4` up to `n=200` at `t=0,1/3,9/10,99/100`.

**Remaining.** The limiting digit frequency for a.e. `θ` is not proved. The
digit-one measure decays roughly like `1/n`, so the average digit density is not
bounded away from zero; a frequency theorem needs a separate ergodic argument.

**Acceptance (remaining).** A proved limiting frequency, or an explicit
counterexample to universal frequency.

## 2. O1 — completeness of the Haar system

**Current state.** Separation (T11), cylinder diameter (T12), tiling, mesh,
split lengths, coverage and uniqueness (T20–T24) are proved.  The real lift
(T25–T28), the uniform oscillation bound (T29), cylinder-step approximation
(T30), uniform density of cylinder step functions (T31), the partition dimension count (T32), the local Haar algebra (T33–T35), the global cylinder-to-Haar span induction (T36), the indicator-span inclusion (T37), Haar-span density (T38), continuous \(L^2\) approximation (T39), \(L^2\) membership of the cylinder-step sums (T40), the `Lp`-distance approximation (T41–T43), full \(L^2\) density (T44–T45), Haar completeness (T46), the normalised wavelet span equality (T47), the global normalised span equality (T48–T50), the normalised norm/mean identities (T51–T52), the normalised support lemma (T53), the O3 selection-gap bound (T54), the cylinder-indicator integral (T55), the zero-integral Haar identities (T56–T57), the no-consecutive-selection corollary (T58), the O3 doubling bound (T59), the unit \(L^2\) norm of the normalised wavelet (T60–T61), the first digit-set component (T62), disjoint-support Haar orthogonality (T63–T64), nested-support orthogonality in both child configurations (T65–T67) are also proved.

**Status.** O1 is closed in density form (T45–T46). The normalised wavelet is identified with `haarDiff` and its span is proved
complete (T47–T50); `hst_isometry` is proved (T113–T115).  The precise route, Lean targets and risks are
in [O1-L2-BRIDGE.md](O1-L2-BRIDGE.md); that gives `haar_complete` and the HST
isometry.

**Bridge sequence.**

1. F1 (done): cylinders are intervals, the partition tiles, and coverage holds.
2. Real lift and mesh-to-zero (done: T25–T28).
3. Uniform approximation of continuous functions by cylinder step functions (done: T29–T31).
4. Density of continuous functions in `L²`, and the span identity
   `span{1, wavelets of depth < n} = {functions constant on depth-n cylinders}`.

**Acceptance.** `HST.haar_complete` and `HST.hst_isometry`, with the density step
proved, not assumed. This is the highest-value finite-plus-measure bridge in the
programme.

**Risk.** The half-open boundary convention; measure-zero endpoints; the fact that
some nodes are unsplit and pass through unchanged. None is conceptually deep, but
all require care.

The precise remaining isometry gap is recorded in
[`ISOMETRY-STATUS.md`](ISOMETRY-STATUS.md).

## 3. O3 — the correct digit statistics (closed)

**Current state.** The source's logarithmic law is contradicted at moderate `N`
(C6, R8). At `t = 99/100` the selections are `0,1,5,71,9016,…`. T54 proves a quadratic gap and T59 a doubling bound: after index 1, later
selections satisfy `2(n+2) ≤ m+2`. The count is therefore at most logarithmic
in `N`, not `log N`.

**Closed.** T123 proves the global bound `D(N,θ) ≤ log₂ N + 1`; T54/T59 give the
quadratic gap and doubling that force it. The exact asymptotic constant remains a
refinement.

**Bridge.** Derive the selection-index recursion from the residual inequality
`αₙ ≤ rₙ`. The data suggest a sparse, roughly Engel/Sylvester-type growth. A
useful first result would be a proved upper bound on the number of selections below
`N`, even if the exact constant is unknown.

**Acceptance.** A proved `D(N,θ) = o(log N)` or a sharp two-sided bound, with the
computed data as a check. A counterexample to a proposed law is also acceptable.

## 4. O4 — digit-set structure

**Current state.** C8 gives the exact interval decomposition. T62 characterises the first component exactly as \([\alpha_n,\alpha_{n-1})\) and
T69 the second-band component, and T70–T72 give the general component formula and converse for any first selected
index \(j<n\). The remaining work is the component count and ordering.

**Gap.** A closed description of `{θ : δₙ(θ)=1}` and its relation to earlier
digits.

**Bridge.** Combine F2 with the threshold theorem T5. The first component is
governed by the least threshold; later components should be expressible through
earlier digit words. Prove the endpoint recursion.

**Acceptance.** A finite formula for the endpoints, or a proved recurrence with a
closed component count. This closes O4.

## 5. O5 — the transfer operator and Fredholm determinant

**Current state.** The normalised greedy map, its recurrence, inverse branches and
Markov branch partition are proved (T125–T129); the continuing O5 formalisation
lives in [`../hst-transfer-operator`](../hst-transfer-operator/README.md). The archived operator's finite
truncation is defined, linear, evaluated on constants, bounded (T130–T133), the `k=1` divergence and `k≥3` summability thresholds are proved (T134, T136), the finite operators are uniformly bounded for `k≥3` (T138), the infinite
operator exists as the limit of its truncations, is linear on bounded functions and
inherits the uniform bound (T139–T148). Trace-classness, the determinant identity
and the analytic continuation remain archived claims (R10).

**Bridge sequence.**

1. Define the greedy map `T` on `[0,1]` and its inverse branches; prove the Markov
   partition is the cylinder partition (F1). **Partial:** the normalised
   remainder `x_n=(n+2)r_n/π` and its exact recurrence
   `x_{n+1}=(1+1/(n+2))(x_n-1_{x_n≥1})` are proved (T125–T126), and the two
   inverse branches and Markov branch partition are proved (T127–T129). The
   comparison with the cylinder partition and the operator construction remain.
2. Define `ℒ_s` on a suitable Banach space of holomorphic functions (or on a
   weighted `L²` space) and prove nuclear/trace-class for `Re s > 1`.
3. Compute `tr(ℒ_s^m)` from periodic orbits and compare with `ζ(ms)/ζ(2ms)`.
4. Prove the determinant identity on `Re s > 1`, then extend to `Re s > 1/2` via
   Hilbert–Schmidt estimates on `ℒ_s²`.
5. Only then discuss zeros and spectral flow.

**Acceptance.** `HST.transfer_traceClass` and
`HST.fredholm_identity` on `Re s > 1`, plus a numerical check of the first zeros.
The entire factor `P(s)` must be constructed, not asserted.

**Risk.** The greedy map is not the Gauss map; the source's “one branch per
positive integer” description and its `Tₙ'` formula are underspecified. The only
archived bridge is the later proof's assertion
`L_s = V G_s V^{-1} + K_s` with trace-class `K_s`
([`hst-further-research-results.tex`](../../archive/maths/rh/research/harmonic-sine-transform/hst-further-research-results.tex)),
and no live topic proves it. [`../proof-99-global-harmonic-framework`](../proof-99-global-harmonic-framework/README.md)
is the only live Gauss/Mayer–Ruelle topic, but it reconstructs finite algebra
only and records the Mayer–Ruelle similarity as unproved. [`../angular-partition-method`](../angular-partition-method/README.md)
is about Gaussian test functions, not the Gauss map, and
[`../greedy-harmonic-transfer-operator`](../greedy-harmonic-transfer-operator/README.md)
is an empty-source weighted-shift placeholder. The first task is still to fix
the greedy map precisely and then test whether a conjugacy/similarity to the
Gauss map exists.

## 6. O6 — the explicit formula

**Current state.** The greedy harmonic zeta `Φ(θ,s)` is defined, summable for integer `s ≥ 2`
(T131) and bounded by the corresponding `p`-series (T144). No test-function class and no weights `W_f(n)` yet (R11).

**Bridge.** Construct a dense class `S` for which the HST coefficients decay;
derive the weights from the Haar expansion; apply Perron and contour shift; verify
the residue pairing numerically at the first zeros.

**Acceptance.** A proved identity for a dense class, with the weights explicit and
a numerical residue check. This is downstream of O5.

## 7. O7 — Hilbert–Pólya and the GRH route

**Current state.** The self-adjoint family, spectral flow and GRH paper are
archived claims (R12, R13). Nothing in this reconstruction bears on RH or GRH.

**Bridge.** After O5, construct a self-adjoint family with a trace-class
resolvent, prove the eigenvalue-1 correspondence, and prove reality of the
spectrum. This is the programme's summit, not a near-term step. No RH or GRH
claim should be made before the self-adjointness and trace-class statements are
theorems.

## 8. Categorical side — P5–P7

**Current state.** The greedy–MTC bijection is contradicted inside the corpus
(R14); the `SU(2)_k` limit and universal-attractor claims are unproved.

**Bridge.** First decide R14. Then check the `SU(2)_k` quantum-dimension limit
against the HST Dirichlet series numerically, and only then attempt the
equidistribution argument.

**Priority.** Low until R14 is settled; the categorical route is independent of
the finite HST core.

## 9. Suggested order

| Order | Gap | Work | Tractability | Payoff |
|---|---|---|---|---|
| 1 | F1 | **Done**: tiling, mesh, split lengths, coverage, uniqueness (T20–T24). | — | Supplies O1, repairs R5–R7 |
| 2 | O1 | **Done**: completeness and isometry (T25–T46, T113–T115). | — | HST isometry |
| 3 | F2/O4 | **Done**: accumulator identity, selection criterion and general component criterion (T117–T120). Count formula remains an extension (C12). | — | Closes O4 description |
| 4 | O3 | **Done**: `D(N,θ) ≤ log₂ N + 1` (T123). | — | Replaces the refuted log law |
| 5 | F3 | **Closed by obstruction** (T18–T19, C11). | — | Clarifies the corpus |
| 5b | F4 | **Done**: exact measure (T55, C13), zero frequency (T124), sample data (C14), uniform density bound `O(log N/N)` (T123). | — | Digit statistics |
| 6 | O5 | Transfer operator and determinant | Hard | Spectral programme |
| 7 | O6 | Explicit formula | Hard | Arithmetic bridge |
| 8 | O7 | Self-adjoint operator; finite HP cores exist in `greedy-harmonic-hilbert-polya`, `harmonic-categorical-hilbert-polya`, `self-adjoint-ccm` | Very hard | Hilbert–Pólya |
| 9 | R14/P5–P7 | R14 resolved: no tree bijection; transfer-operator route only | Hard/independent | Categorical branch |

## 10. What would count as a bridge

A gap is bridged only when the named statement is a Lean theorem with no `sorry`,
`axiom` or `admit`, and the numerical computation agrees with it. In particular:

- O1 is bridged by `haar_complete`, not by a density sketch.
- O5 is bridged by a constructed operator and a proved determinant identity on a
  half-plane, not by the archived identity.
- O7 is bridged by a self-adjoint operator whose spectrum is proved to be the
  zeros; even then, the GRH extension is a separate statement.

Everything else remains a source claim or an open problem, and should be labelled
as such in the dossier.
