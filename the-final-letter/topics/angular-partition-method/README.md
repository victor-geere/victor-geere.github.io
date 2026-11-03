# The angular partition method — exact radial and sectorial representations of infinite series

**Status:** **method proposal with a checked exact core**. The finite annular,
sectorial and general-measure identities, including the infinite annular
representation of any summable nonnegative series, are Lean-proved; the
computation layer is exact. Applications to \(\zeta\), Euler products and the
explicit formula are **open** and are recorded as such. No finite truncation is
used in the core.

**Source:** proposal from Victor Geere, 3 November 2026, following the
infinite-level obstruction in
[`../absolute-polarized-hodge-index-realization/`](../absolute-polarized-hodge-index-realization/README.md).
The proposal is to stop treating an infinite series only as a depth axis
(partial sum plus tail) and to represent it as an angular/radial partition of a
compact domain.

> **Scope.** This folder develops the method and its exact core. It does not
> prove the Riemann hypothesis, and it does not claim that every series has a
> closed-form sectorial representation. The method is a **transform**: it
> replaces a discrete infinite sum by a measure on a compact geometric object.
> Whether that measure evaluates in closed form is a separate question.

## 1. The depth axis and the angular axis

The standard treatment of a series is a truncation:

\[
S=\sum_{n=0}^{\infty}a_n
=\underbrace{\sum_{n<N}a_n}_{\text{partial sum}}
+\underbrace{\sum_{n\ge N}a_n}_{\text{tail}}.
\]

The [`partial-sum-plus-tail`](../partial-sum-plus-tail/README.md) topic is the
programme’s certified instrument for this axis. It is powerful, but it makes
the infinite object a limit of finite objects and makes the tail an external
residual.

The angular/radial method uses a different coordinate. Picture the unit tube
\(S^1\times[0,\infty)\). Cutting it **lengthwise** gives layers
\(0,1,2,\ldots\): that is the depth axis. Cutting it **crosswise** gives the
unit circle: that is the angular axis, and the sectors tile the whole circle at
once. The radial version cuts a disk into annuli; the angular version cuts the
circle into sectors. The two can be combined into annular sectors.

The point is not that the depth axis is wrong. The point is that **it is not the
only axis**, and some series become exact on the angular/radial axis when no
useful closed tail exists on the depth axis.

## 2. The general annular representation

Let \(a_n\ge0\) and suppose \(\sum_{n\ge0}a_n<\infty\). Define the **squared
tail radii**

\[
R_n^2:=\sum_{k\ge n}a_k.
\]

Then

\[
R_n^2-R_{n+1}^2=a_n,
\]

and the annuli

\[
A_n:=\{\,z\in\mathbb{C}:R_{n+1}<|z|\le R_n\,\}
\]

are pairwise disjoint and tile the disk of radius \(R_0\). If area is
normalized by \(\mu(A)=\operatorname{area}(A)/\pi\), then

\[
\mu(A_n)=R_n^2-R_{n+1}^2=a_n,
\qquad
\mu\!\left(\bigcup_{n\ge0}A_n\right)=R_0^2=\sum_{n\ge0}a_n.
\]

So **every summable nonnegative series is the total measure of an annular
partition of a disk**. No geometric ratio is assumed. The geometric series is
only the special case in which the radii themselves form a geometric
progression. This is formalised as
`AngularPartition.annular_representation`.

### 2.1 The radius is the depth

The sequence \(n\mapsto R_n\) is the exact bookkeeping index. It records how
much mass remains beyond depth \(n\). The term \(a_n\) is the area of the
annulus between two consecutive radii. This is a direct answer to “what is the
depth of \(n^{-\sigma}\)”: for \(\sigma>1\),

\[
R_n^2=\sum_{k\ge n}k^{-\sigma},
\qquad
n^{-\sigma}=R_n^2-R_{n+1}^2,
\]

and the whole sum is \(R_0^2=\zeta(\sigma)\). Equivalently, the squared radius
is the Hurwitz zeta
\[
R_n^2=\zeta(\sigma,n)=\sum_{k=0}^{\infty}(n+k)^{-\sigma},
\]
so the depth index \(n\) is literally the Hurwitz-zeta parameter; for
\(\sigma=2\), \(R_n^2=\psi_1(n)\), the trigamma function. For example,
\(\zeta(2)=R_0^2=\pi^2/6\), so the disk has radius \(\pi/\sqrt6\) and the
annulus at \(n\) has normalized area \(n^{-2}\). No truncation is involved.

For \(0<\sigma\le1\), \(R_0=\infty\): the disk is infinite. This is precisely
the divergence of the series, not a failure of the method. Analytic
continuation is a separate operation.

**Product bookkeeping.** The same radii can index a product. The exact
identity
\[
\prod_{n=0}^{N}(1+a_n)=\exp\!\left(\sum_{n=0}^{N}\log(1+a_n)\right)
\]
turns a finite product into a sum of logarithms, which can itself be given an
annular representation. The ratios \(R_n/R_{n+1}\) are the natural
multiplicative bookkeeping weights, and
\(\prod_{n=0}^{N}R_n/R_{n+1}=R_0/R_{N+1}\) telescopes exactly. Sums and
products are two coordinate choices on the same radial data.

### 2.2 Complex terms and angular bookkeeping

For an absolutely summable complex series \(c_n=|c_n|e^{i\theta_n}\), apply the
annular construction to \(|c_n|\) and place a sector of area \(|c_n|\) at angle
\(\theta_n\) in the annulus \(A_n\). The result is a phase field on the disk,
and

\[
\sum_{n\ge0}c_n=\int_{D}e^{i\theta(z)}\,d\mu(z).
\]

The scalar sum is a vector-valued area integral. For a conditionally convergent
series, the angular placement is a **summation method**; rearrangements can
change the value, so absolute convergence (or a proved rearrangement-invariance
statement) is required before identifying it with the ordinary sum.

### 2.3 The phase-carrying tail coil

For an absolutely summable complex series \(c_n\), define the **complex tail**

\[
Z_n:=\sum_{k\ge n}c_k.
\]

Then \(c_n=Z_n-Z_{n+1}\), the finite sum is the chord

\[
\sum_{k=0}^{N-1}c_k=Z_0-Z_N,
\]

and \(Z_n\to0\) as \(n\to\infty\). The **coil** is the sequence
\(n\mapsto Z_n\) in \(\mathbb{C}\), with

\[
r_n:=|Z_n|,\qquad \theta_n:=\arg Z_n,
\]

so the cumulative tail sum is the radius and the phase is the angle. The
series starts at \(Z_0\), the whole sum, and spirals into the origin. This is a
**tail coil**, not a partial-sum truncation: \(Z_0\) is present from the start,
and the finite sums are chords between coil points.

The **unit coil** is

\[
w_n:=\frac{Z_n}{Z_0}\qquad(Z_0\ne0),
\]

so \(w_0=1\) and \(w_n\to0\). It is a normalized phase-carrying coil inside the
unit disk. For \(\zeta(s)\) in the convergence domain \(\Re s>1\), one may take
\(Z_n=\sum_{k\ge n}k^{-s}\) and \(Z_0=\zeta(s)\); the coil is exact, although
evaluating \(Z_0\) is still the original problem.

This is formalised as `phase_carrying_coil` (decomposition, polar form and
limit), `ctail_telescope` (the chord identity), and
`unitCoil_zero`/`unitCoil_tendsto_zero` (the normalized coil). The polar form
is the exact identity

\[
Z_n=r_n e^{i\theta_n},
\]

which is `Complex.norm_mul_exp_arg_mul_I` applied to the tail. At \(Z_n=0\)
the radius is \(0\) and the angle is immaterial.

**Alternative phase carriers.** Three other models were considered:

1. **Partial-sum coil.** \(S_N=\sum_{k<N}c_k\), with radius \(|S_N|\), angle
   \(\arg S_N\), and height \(N\). This is a conical helix whose limit is the
   sum. It uses the depth axis and is therefore a phase-carrying bookkeeping
   device, not a no-tail transform.
2. **Annular phase field.** Use the moduli \(|c_n|\) as annular areas and the
   arguments \(\arg c_n\) as angular sectors. The sum is the vector area
   integral \(\int e^{i\theta}\,d\mu\). This is exact for absolutely summable
   series; its infinite formalisation is open.
3. **Tuple model.** Carry \((r_n,\theta_n)\) or \((R_n,\Theta_n)\) as an exact
   pair, with addition/multiplication rules for phase and radius. This is the
   most flexible bookkeeping model; it is equivalent to the complex tail when
   \(r_n e^{i\theta_n}=Z_n\).

The tail coil is the preferred phase-carrying version because it is exact,
uses no finite truncation, and has a direct Lean formalisation.

### 2.4 The self-similar special case

If the unresolved part is an exact similarity copy of the whole,

\[
S=a_0+rS,
\]

then

\[
S=\frac{a_0}{1-r}.
\]

This is the closed-form case. It is a special case of the annular
representation, not a requirement of it. The general case uses the radii
\(R_n\) and the measure identity; the self-similar case is useful when it
collapses the whole computation to one fixed-point equation.

## 3. The halving-circle normalization

The halving sectors of the circle have angles

\[
\pi+\frac{\pi}{2}+\frac{\pi}{4}+\cdots=2\pi.
\]

In normalized turns the same partition is

\[
\frac12+\frac14+\frac18+\cdots=1.
\]

Both statements describe the same tiling; the radian total is \(2\pi\). The
Lean theorem `sector_angle_hasSum` records the radian form, and the computation
layer records both exact forms.

## 4. The method in six steps

1. **Choose the carrier.** A circle, disk, annulus, sphere, or a contour
   compactified to one of these. It must be finite-measure and the partition
   measurable.
2. **Choose the axis.** Radial annuli encode the modulus/depth; angular sectors
   encode the phase; annular sectors encode both.
3. **Identify the weights.** Prove \(a_n=\mu(X_n)\), exactly. In the general
   radial case this is the definition \(a_n=R_n^2-R_{n+1}^2\).
4. **Use exactness.** If the partition is self-similar, solve the fixed point.
   If the tail radii have a closed form, use it. If neither, keep the exact
   measure representation and state what is missing.
5. **Check summability and order.** Absolute convergence for complex terms;
   otherwise the angular construction is a summability method.
6. **Only then estimate.** If no exact transform is available, use certified
   partial-sum-plus-tail evaluation as a fallback. A finite estimate is an
   instrument, not a wall.

## 5. Worked exact examples

### 5.1 Geometric series as a self-similar cake

Take a disk of area \(A\), cut off a sector of area \(a_0\), and let the rest be
a copy scaled by \(r\). Then \(A=a_0+rA\), so \(A=a_0/(1-r)\). For
\(a_0=1\), \(r=1/2\), this is \(1+\frac12+\frac14+\cdots=2\).

### 5.2 The halving circle

The unit circle has total angle \(2\pi\). Sectors of angle
\(\pi,\pi/2,\pi/4,\ldots\) tile it, and

\[
\sum_{k=0}^{n-1}\frac{\pi}{2^k}
=2\pi\left(1-\frac{1}{2^n}\right).
\]

### 5.3 Arbitrary weights: \(n^{-2}\)

The annular representation of §2 gives

\[
R_n^2=\sum_{k=n}^{\infty}\frac{1}{k^2},
\qquad
\frac{1}{n^2}=R_n^2-R_{n+1}^2.
\]

The total normalized area is \(R_0^2=\zeta(2)=\pi^2/6\). The representation is
exact for every \(n\); the closed form at \(n=0\) is the classical Basel value.
This is the prototype of “the radius of decay is the depth of the term”.

### 5.4 Rational functions and contour integrals

For \(|z|<1\),

\[
\frac{1}{1-z}=\sum_{n\ge0}z^n.
\]

This is the boundary-value form of the geometric cake: the disk is partitioned
into self-similar annuli/sectors with ratio \(|z|\). The identity is exact for
\(|z|<1\) and extends to the boundary wherever the series converges.

### 5.5 The Mellin/Laplace radial representation (formalised)

For \(\Re s>0\),

\[
n^{-s}=\frac{1}{\Gamma(s)}\int_0^\infty t^{s-1}e^{-nt}\,dt.
\]

Summing over \(n\) and using the geometric series \(\sum_n e^{-nt}=1/(e^t-1)\)

\[
\Gamma(s)\zeta(s)=\int_0^\infty\frac{t^{s-1}}{e^t-1}\,dt
\]

for \(\Re s>1\). This is another exact radial representation: the discrete
index is traded for the continuous depth \(t\), and the geometric sum in \(t\)
is closed.

This is formalised in [`lean/Mellin.lean`](lean/Mellin.lean):

- `hasSum_zetaKernel` — the geometric sum \(1/(e^t-1)\);
- `hasSum_mellin_zetaKernel` — the Mellin series;
- `mellin_zetaKernel_eq_Gamma_mul_zeta` — the identity
  \(\Gamma(s)\zeta(s)=\operatorname{mellin}(1/(e^t-1))(s)\) for \(\Re s>1\);
- `completedRiemannZeta_eq_GammaR_mul_zeta` — the Gamma-factor relation
  \(\Lambda(s)=\Gamma_{\mathbb R}(s)\zeta(s)\) for \(\Re s>1\);
- `completedRiemannZeta_functional_equation` — the correct completed
  functional equation \(\Lambda(1-s)=\Lambda(s)\);
- `mellin_zetaKernel_norm_le` — the vertical-strip growth bound
  \[
  \|\Gamma(s)\zeta(s)\|\le \|\Gamma(s)\|\sum_{n\ge0}\frac{1}{(n+1)^{\Re s}}
  \qquad(\Re s>1).
  \]

The growth bound is exact and requires no truncation. It is the estimate that
makes the Mellin integral converge absolutely and supports the analytic
continuation; the functional equation is the completed-zeta FE. The analytic
continuation itself is not re-proved in this folder; the FE is inherited from
Mathlib’s completed zeta.

### 5.6 Critical-strip regularization and explicit-formula poles

The raw Mellin/annular integral converges for \(\Re s>1\). The finite part

\[
M_{\mathrm{reg}}(s):=\Gamma(s)\zeta(s)-\frac{1}{s-1}+\frac{1}{2s}
\]

subtracts exactly the two pole terms. On the convergence domain it is the raw
annular total minus those poles:

\[
M_{\mathrm{reg}}(s)=\operatorname{mellin}\!\left(\frac{1}{e^t-1}\right)(s)
-\frac{1}{s-1}+\frac{1}{2s}.
\]

This is `regularizedMellin_eq_mellin_sub_poles`. The finite part is
differentiable in the critical strip \(0<\Re s<1\)
(`regularizedMellin_differentiableAt`), so it is the analytic continuation of
the annular total into the strip. The completed version

\[
\Lambda_0(s)=\Lambda(s)+\frac1s+\frac1{1-s}
\]

is entire and satisfies the functional equation
\(\Lambda_0(1-s)=\Lambda_0(s)\); this is
`completedRiemannZeta_finite_part` together with
`completedRiemannZeta₀_functional_equation`.

**Explicit-formula connection.** The two subtracted residues are exactly the
two pole terms of the explicit formula. The residue at \(s=1\) is \(1\)
(`regularizedMellin_residue_one`), and the residue at \(s=0\) is \(-1/2\)
(`regularizedMellin_residue_zero`). In the test-function formula

\[
\oint \frac{Z'}{Z}(z)\,h(z)\,dz
=2\pi i\left(\sum_\rho h(\rho)-h(0)-h(1)\right),
\]

the terms \(-h(0)-h(1)\) are the same pole contributions. Thus the
critical-strip finite part is the analytic-continuation side of the
explicit-formula contour: the pole subtraction matches the contour residues,
and the completed finite part supplies the functional equation that pairs the
zeros. This is a structural connection, not a new proof of Weil positivity.

**Convergence of the subtracted kernel.** Define

\[
h(t)=\begin{cases}
\dfrac{1}{e^t-1}-\dfrac1t+\dfrac12,&0<t<1,\\[4pt]
\dfrac{1}{e^t-1},&t\ge1.
\end{cases}
\]

For \(0<\sigma=\Re s<1\), the comparison bounds are

\[
|t^{s-1}h(t)|\le \frac32\,t^{\sigma-1}\quad(0<t<1),
\qquad
|t^{s-1}h(t)|\le 2\,t^{\sigma-2}\quad(t\ge1).
\]

The first is integrable on \((0,1)\) because \(\sigma>0\), and the second is
integrable on \((1,\infty)\) because \(\sigma<1\). Hence the subtracted
kernel integral converges for every \(s\) in the critical strip.

The bounds and their assembly are Lean-checked:
`norm_regularizedKernel_le`, `norm_zetaKernel_le_two_div`,
`integrableOn_regularizedKernel_Ioo`, `integrableOn_regularizedKernel_Ioi`,
and **`mellinConvergent_regularizedKernel`**, which proves
`MellinConvergent regularizedKernel s` for `0 < re s < 1`. The Mellin
transform is holomorphic on the whole right half-plane:
`differentiableAt_mellin_regularizedKernel`.

**Identification with \(M_{\mathrm{reg}}\).** For \(\Re s>1\), split the
integral at \(1\). On \((1,\infty)\) the kernels \(h\) and
\(1/(e^t-1)\) agree, so the difference is

\[
\operatorname{mellin}(h)(s)-\operatorname{mellin}\left(\frac1{e^t-1}\right)(s)
=\int_0^1 t^{s-1}\left(-\frac1t+\frac12\right)dt
=-\frac1{s-1}+\frac1{2s}.
\]

Using the Mellin representation of \(\Gamma(s)\zeta(s)\) gives

\[
\operatorname{mellin}(h)(s)
=\Gamma(s)\zeta(s)-\frac1{s-1}+\frac1{2s}
=M_{\mathrm{reg}}(s).
\]

Both sides are analytic in \(0<\Re s<1\) (the left by the convergence bound,
the right by `regularizedMellin_differentiableAt`), so the identity extends
from \(\Re s>1\) to the critical strip by analytic continuation. This is now
formalised in Lean: the upper and lower half-strips are handled by the
identity theorem, and the real axis by continuity. The final statement is
`mellin_regularizedKernel_eq_of_re_pos_of_lt_one`.

## 6. Exactitude first, estimation second

The methodological rule is:

> **Look for an exact transform before accepting a finite estimate as the
> representation of infinity.**

A finite estimate is not a failure; it is a fallback. The programme has two
complementary instruments:

| Axis | Object | Strength | Limit |
|---|---|---|---|
| depth | \(S_N+R_N\) | certified evaluator; handles arbitrary series with a tail bound | needs a closed tail or a bound; the tail can be wide |
| angular/radial | \(\mu(X)=\sum_n\mu(X_n)\) | exact algebraic/measure identity; no tail | needs a measurable partition; closed forms only in special cases |

The two are not in contradiction. The angular method can discover an exact
identity; the partial-sum-plus-tail layer can certify a numerical value when no
exact identity is known. A good programme uses both.

## 7. Scope, obstructions and the zeta wall

### 7.1 Absolute convergence and ordering

For a conditionally convergent series, rearranging terms can change the sum
(Riemann’s rearrangement theorem). An angular/radial construction groups terms
in a chosen geometric order, so it defines a **summability method**. It agrees
with the ordinary sum when the series is absolutely convergent, or when the
partition is proved to be a rearrangement-invariant grouping. For \(\zeta(s)\)
in the critical strip the Dirichlet series is not absolutely convergent, so this
point is essential.

### 7.2 Divergence is a radius, not a hidden tail

For \(a_n=n^{-\sigma}\), the squared tail radius
\(R_n^2=\sum_{k\ge n}k^{-\sigma}\) is finite exactly when \(\sigma>1\). At
\(\sigma\le1\), \(R_0=\infty\): the disk is infinite. The method therefore
locates the abscissa of convergence in the radius itself. It does not remove
the need for analytic continuation in the critical strip.

### 7.3 Phase and angular bookkeeping

For \(n^{-s}=n^{-\sigma}e^{-it\log n}\), the modulus is radially representable,
but the phase \(e^{-it\log n}\) is not constant on an annulus. One must either

- place angular sectors at the phases \(\theta_n=-t\log n\), which turns the
  sum into a vector area integral; or
- separate the sum into real and imaginary parts and apply the annular
  representation to each signed part (with a signed measure, not a positive
  one); or
- use a Mellin/Laplace representation, where the phase is carried by
  \(t^{s-1}\) and the geometric sum is exact.

This is the real bookkeeping problem for \(\zeta\), not polynomial versus
geometric decay. The phase-carrying tail coil of §2.3 gives one exact phase
representation; the area-field version and the evaluation of the total remain
open.

### 7.4 A representation is not automatically an evaluation

The annular identity gives

\[
\sum_{n\ge0}a_n=R_0^2.
\]

If \(R_0^2\) has a closed form, the series is evaluated. If it does not, the
identity is an exact **representation**, not a numerical value. For
\(n^{-2}\) the closed form is \(\pi^2/6\); for general \(n^{-\sigma}\) no such
closed form is known. The method does not manufacture closed forms.

### 7.5 The \(w=e^{-s}\) compactification is not required

If one additionally maps depth to radius by \(w=e^{-s}\), then
\(n^{-s}=w^{\log n}\), and \(w=0\) is an essential singularity/natural
boundary for the Dirichlet series. That is a real obstruction to a
finite-monodromy compactification. The annular representation of §2 does not
use this map: it uses the tail radii directly. The two constructions should not
be conflated.

### 7.6 What would be needed for the critical strip

- a **regularized annular representation** whose total area is the analytic
  continuation, not the divergent sum;
- a **phase-carrying measure** (vector-valued area) with a convergence theorem;
- a **Mellin/Laplace transform** with the correct functional equation and
  growth bounds, which is exact in \(\Re s>1\) and meromorphic beyond;
- for Euler products, the product-to-sum transform
  \(\prod(1+a_n)=\exp(\sum\log(1+a_n))\), followed by an annular
  representation of the log-series.

These are research targets. The method is a reusable framework for stating
them, not a proof of RH.

## 8. Reusable transforms

The topic is intended as a toolkit. The exact core contains the infinite
annular representation and the finite versions of the first three rows.

| Transform | Input | Output | Exact? |
|---|---|---|---|
| annular/area | nonnegative weights \(a_n\) | disk partition with \(\mu(A_n)=a_n\) | exact for summable weights |
| radius-index | weights \(a_n\) | squared radii \(R_n^2=\sum_{k\ge n}a_k\) | exact; \(a_n=R_n^2-R_{n+1}^2\) |
| self-similar fixed point | \(S=a+rS\) | \(S=a/(1-r)\) | exact when the copy is exact |
| layer-cake | \(a_n\ge0\) | \(a_n=\int_0^\infty 1_{t<a_n}dt\) | exact (Tonelli) |
| Mellin/Laplace | \(n^{-s}\) | \(\Gamma(s)\zeta(s)=\int t^{s-1}/(e^t-1)dt\) | exact in \(\Re s>1\), meromorphic beyond |
| product-to-sum | \(\prod(1+a_n)\) | \(\exp(\sum\log(1+a_n))\) | exact in the convergence domain |
| phase/angular | \(c_n=\lvert c_n\rvert e^{i\theta_n}\) | vector area integral \(\int e^{i\theta}d\mu\) | exact for absolutely summable \(c_n\) |

## 9. Theorem ledger

Every row marked **Theorem** is proved in [`lean/Topic.lean`](lean/Topic.lean)
with no `sorry`, `axiom` or `admit`.

| # | Kind | Statement | Lean name |
|---|---|---|---|
| T1 | Theorem | Finite geometric sector sum: \(\sum_{k<n}a r^k=a(1-r^n)/(1-r)\). | `AngularPartition.geom_sector_sum` |
| T2 | Theorem | The halving sector angles sum to a full turn: \(\sum_{n\ge0}\pi/2^n=2\pi\). | `AngularPartition.sector_angle_hasSum` |
| T3 | Theorem | The same identity in `tsum` form. | `AngularPartition.sector_angle_tsum` |
| T4 | Theorem | Self-similar no-tail fixed point: \(S=a+rS\), \(r\ne1\), implies \(S=a/(1-r)\). | `AngularPartition.self_similar_total` |
| T5 | Theorem | Reciprocal weights \(1/(n+1)\) are not constant-ratio. | `AngularPartition.inv_nat_not_geometric` |
| T6 | Theorem | Finite no-tail bookkeeping: head plus complementary sectors is the whole. | `AngularPartition.finite_partition_total` |
| T7 | Theorem | General finite measure partition: pairwise disjoint measurable sectors satisfy \(\mu(\bigcup X_i)=\sum\mu(X_i)\). | `AngularPartition.measure_partition_finset` |
| T8 | Theorem | Finite annular telescoping: \(\sum_{k<n}(r_k^2-r_{k+1}^2)=r_0^2-r_n^2\), for arbitrary radii. | `AngularPartition.annular_telescope` |
| T9 | Theorem | Any finite weight sequence given by squared-radius differences sums to the disk area. | `AngularPartition.annular_weight_sum` |
| T10 | Theorem | **Infinite annular representation:** for any summable nonnegative `a`, the squared tail radii satisfy `a n = R_n^2 - R_{n+1}^2` and `R_0^2 = ∑' n, a n`. | `AngularPartition.annular_representation` |
| T11 | Theorem | **Phase-carrying tail coil:** for summable complex `c`, `c n = Z_n - Z_{n+1}`, `Z_n = r_n e^{iθ_n}`, and `Z_n → 0`. | `AngularPartition.phase_carrying_coil` |
| T12 | Theorem | **Coil chord identity:** `∑_{k<n} c k = Z_0 - Z_n`. | `AngularPartition.ctail_telescope` |
| T13 | Theorem | **Unit coil:** `w_n = Z_n/Z_0` starts at `1` and tends to `0`. | `AngularPartition.unitCoil_zero`, `AngularPartition.unitCoil_tendsto_zero` |
| T14 | Theorem | **Mellin/Laplace representation:** `mellin (fun t => 1/(e^t-1)) s = Γ(s) ζ(s)` for `re s > 1`. | `AngularPartition.mellin_zetaKernel_eq_Gamma_mul_zeta` |
| T15 | Theorem | **Gamma-factor bridge:** `Λ(s) = Γ_ℝ(s) ζ(s)` for `re s > 1`. | `AngularPartition.completedRiemannZeta_eq_GammaR_mul_zeta` |
| T16 | Theorem | **Functional equation:** `Λ(1−s) = Λ(s)` for the completed zeta. | `AngularPartition.completedRiemannZeta_functional_equation` |
| T17 | Theorem | **Vertical-strip growth:** `‖Γ(s)ζ(s)‖ ≤ ‖Γ(s)‖ ∑ 1/(n+1)^(re s)` for `re s > 1`. | `AngularPartition.mellin_zetaKernel_norm_le` |
| T18 | Theorem | **Finite-part regularization:** `M_reg(s) = mellin(1/(e^t−1))(s) − 1/(s−1) + 1/(2s)` for `re s > 1`. | `AngularPartition.regularizedMellin_eq_mellin_sub_poles` |
| T19 | Theorem | **Critical-strip differentiability:** `M_reg` is differentiable for `0 < re s < 1`. | `AngularPartition.regularizedMellin_differentiableAt` |
| T20 | Theorem | **Completed finite part:** `Λ(s) = Λ₀(s) − 1/s − 1/(1−s)`. | `AngularPartition.completedRiemannZeta_finite_part` |
| T21 | Theorem | **Completed functional equation:** `Λ₀(1−s) = Λ₀(s)`. | `AngularPartition.completedRiemannZeta₀_functional_equation` |
| T22 | Theorem | **Pole residue at 1:** `(s−1)Γ(s)ζ(s) → 1`. | `AngularPartition.regularizedMellin_residue_one` |
| T23 | Theorem | **Pole residue at 0:** `sΓ(s)ζ(s) → −1/2`. | `AngularPartition.regularizedMellin_residue_zero` |
| T24 | Theorem | **Regularized-kernel bound near zero:** `‖h(t)‖ ≤ 3/2` for `0<t<1`. | `AngularPartition.norm_regularizedKernel_le` |
| T25 | Theorem | **Zeta-kernel bound at infinity:** `‖1/(e^t−1)‖ ≤ 2/t` for `t ≥ 1`. | `AngularPartition.norm_zetaKernel_le_two_div` |
| T26 | Theorem | **Mellin convergence in the critical strip:** `MellinConvergent regularizedKernel s` for `0 < re s < 1`. | `AngularPartition.mellinConvergent_regularizedKernel` |
| T27 | Theorem | **Holomorphy of the subtracted Mellin transform:** `DifferentiableAt ℂ (mellin regularizedKernel) s` for `0 < re s`. | `AngularPartition.differentiableAt_mellin_regularizedKernel` |
| T28 | Theorem | **Holomorphy of the finite part:** `DifferentiableAt ℂ regularizedMellin s` for `0 < re s` and `s ≠ 1`. | `AngularPartition.regularizedMellin_differentiableAt_of_ne` |
| T29 | Theorem | **Convergence on the right half-plane:** `MellinConvergent regularizedKernel s` for `0 < re s`. | `AngularPartition.mellinConvergent_regularizedKernel_of_pos` |
| T30 | Theorem | **Mellin linearity:** if both pieces are `MellinConvergent`, `mellin (f+g) = mellin f + mellin g`. | `AngularPartition.mellin_add` |
| T31 | Theorem | **Zeta-kernel convergence:** `MellinConvergent zetaKernel s` for `1 < re s`. | `AngularPartition.mellinConvergent_zetaKernel` |
| T32 | Theorem | **Cutoff convergence:** `MellinConvergent cutoff s` for `1 < re s`. | `AngularPartition.mellinConvergent_cutoff` |
| T33 | Theorem | **Cutoff integral:** `mellin cutoff s = −1/(s−1) + 1/(2s)` for `1 < re s`. | `AngularPartition.mellin_cutoff_eq` |
| T34 | Theorem | **Integral identity on `re s > 1`:** `mellin regularizedKernel s = regularizedMellin s`. | `AngularPartition.mellin_regularizedKernel_eq_of_one_lt_re` |
| T35 | Theorem | **Upper half-strip identity:** `mellin regularizedKernel = regularizedMellin` for `0 < re s` and `0 < im s`. | `AngularPartition.mellin_regularizedKernel_eqOn_upper` |
| T36 | Theorem | **Lower half-strip identity:** `mellin regularizedKernel = regularizedMellin` for `0 < re s` and `im s < 0`. | `AngularPartition.mellin_regularizedKernel_eqOn_lower` |
| T37 | Theorem | **Critical-strip identity:** `mellin regularizedKernel s = regularizedMellin s` for `0 < re s < 1`. | `AngularPartition.mellin_regularizedKernel_eq_of_re_pos_of_lt_one` |
| O1 | Closed | The integral identity `mellin h = M_reg` is proved in the critical strip by T37. | T37 |
| O2 | Open | Connect the formalised Mellin/critical-strip layer to the explicit-formula contour as a Lean theorem (the pole-term correspondence is currently text-proof). | — |
| O3 | Open | Product-to-sum annular representation for Euler products. | — |
| O4 | Open | Exact angular sums for Bost–Connes periodic-orbit data. | — |
| O5 | Open | Exactness audit for each infinite series in the programme. | — |

## 10. Computation ledger

Every row is checked by [`tests/test_programme.py`](tests/test_programme.py)
with exact rational arithmetic; no floating point and no truncation.

| # | Statement | Test |
|---|---|---|
| C1 | The finite halving-sector sum equals \(2-2/2^n\). | `test_sector_angle_sum` |
| C2 | The normalized half-turn sum equals \(1-2^{-n}\), below \(1\). | `test_normalized_half_turn_sum` |
| C3 | The self-similar fixed point \(a/(1-r)\) is exact. | `test_self_similar_total` |
| C4 | The finite geometric partial sum equals \(a(1-r^n)/(1-r)\). | `test_geometric_partial_sum` |
| C5 | Reciprocal weights do not have a constant ratio. | `test_reciprocal_weights_not_geometric` |
| C6 | A contraction ratio \(r=1\) is rejected. | `test_invalid_ratio_rejected` |
| C7 | A rational self-similar cake returns an exact rational value. | `test_rational_cake_value` |
| C8 | Squared tail radii encode arbitrary rational weights: \(a_k=R_k^2-R_{k+1}^2\). | `test_squared_radii_encode_weights` |
| C9 | Annular telescoping holds for arbitrary rational radii. | `test_annular_telescope` |
| C10 | The finite annular partition sum is the disk area. | `test_annular_weights_sum` |
| C11 | The complex tail telescope `∑_{k<n}c_k = Z_0 - Z_n` is exact. | `test_complex_tail_telescope` |
| C12 | The unit coil starts at `(1,0)` and ends at `(0,0)`. | `test_unit_coil` |
| C13 | The squared radius of a complex tail is exact, and a zero total is rejected. | `test_phase_carrying_tuple` |

## 11. Lean layer

[`lean/Topic.lean`](lean/Topic.lean) contains the exact core. It includes the
infinite annular representation, the phase-carrying tail coil, the general
finite measure-partition theorem and the arbitrary-radii annular telescoping,
not only the geometric special case. [`lean/Mellin.lean`](lean/Mellin.lean)
contains the Mellin/Laplace zeta representation, the Gamma-factor bridge, the
completed functional equation and the vertical-strip growth bound.
[`lean/CriticalStrip.lean`](lean/CriticalStrip.lean) contains the finite-part
regularization, its differentiability in `0 < re s < 1`, the pole residues, and
the completed finite-part functional equation. The file uses Mathlib’s measure theory,
infinite-sum and geometric-series lemmas; it does not assume RH, analysis of
\(\zeta\), or any unproved arithmetic statement.

[`lean/README.md`](lean/README.md) records what is and is not formalised. The
short version: the infinite annular representation and the finite
annular/sectorial/measure algebra are formalised; the phase-valued version, the
Mellin transform and the zeta application are not.

Run:

```bash
./lean/check.sh
python3 -m pytest tests -q
```

## 12. Open questions

1. **Critical strip.** The finite part \(M_{\mathrm{reg}}\) and its
   differentiability in the strip are formalised. Prove convergence of the
   subtracted-kernel Mellin integral and identify it with
   \(M_{\mathrm{reg}}\), giving the integral form of the analytic
   continuation.
2. **Mellin continuation.** The representation, Gamma-factor bridge, completed
   functional equation and vertical-strip growth bound are formalised. Connect
   them explicitly to the critical-strip and explicit-formula layers.
3. **Products.** Develop the product-to-sum annular representation for Euler
   products and for the completed zeta.
4. **Bost–Connes.** Periodic orbits have lengths \(\log p\); for one prime the
   angular method is exact, for all primes the logs are not commensurable.
   What is the correct finite-monodromy or regularized replacement?
5. **Exactness audit.** For each infinite series in the programme, decide
   whether an exact transform exists before assigning a finite evaluator. This
   is a methodological, not a numerical, question.

## 13. Links

- [Programme standard](../PROGRAMME-STANDARD.md)
- [Topics index](../README.md)
- [Depth-axis companion: partial sum plus tail](../partial-sum-plus-tail/README.md)
- [Absolute polarized Hodge-index dossier](../absolute-polarized-hodge-index-realization/README.md)
- [Programme memo](../absolute-polarized-hodge-index-realization/PROGRAMME-MEMO.md)
- [Periodic orbits](../periodic-orbits/README.md)
- [Scraps index](../../scraps.html)

**No RH proof yet.**
