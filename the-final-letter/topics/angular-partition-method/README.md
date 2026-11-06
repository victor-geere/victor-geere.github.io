# The angular partition method — exact radial and sectorial representations of infinite series

**Status:** **method proposal with a checked exact core**. The finite annular,
sectorial and general-measure identities, including the infinite annular
representation of any summable nonnegative series, are Lean-proved; the
computation layer is exact. Applications to \(\zeta\), Euler products, Bost–Connes periodic-orbit data,
the pole-term part of the explicit formula, and the continuation of the annular
Mellin integral two strips beyond the critical strip (to \(-3 < \Re s\), with
the \(s=-1\) pole explicit and cancelled) are Lean-proved. The finite Gaussian
Weil–Gram certificates are Lean-proved (O4, M0′), as are the first Weil rung,
the zero-side contour identity and the finite rank-one PSD theorem (§7.10); the
zero sum and Weil positivity remain **open** and are recorded as such. No
finite truncation is used in the core.

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
R_n^2=\sum_{k\ge n}(k+1)^{-\sigma},
\qquad
(n+1)^{-\sigma}=R_n^2-R_{n+1}^2,
\]

and the whole sum is \(R_0^2=\zeta(\sigma)\). Equivalently, the squared radius
is the Hurwitz zeta
\[
R_n^2=\zeta(\sigma,n+1)=\sum_{k=0}^{\infty}(n+1+k)^{-\sigma},
\]
so the depth index \(n\) is literally the Hurwitz-zeta parameter \(n+1\); for
\(\sigma=2\), \(R_n^2=\psi_1(n+1)\), the trigamma function. For example,
\(\zeta(2)=R_0^2=\pi^2/6\), so the disk has radius \(\pi/\sqrt6\) and the
annulus at \(n\) has normalized area \((n+1)^{-2}\). No truncation is involved.

**Integral representation and the continuous coil.** The Hurwitz-zeta
parameter admits the exact Mellin/Laplace representation

\[
\zeta(s,x)
=
\sum_{k=0}^{\infty}(k+x)^{-s}
=
\frac{1}{\Gamma(s)}
\int_0^{\infty}
\frac{t^{s-1}e^{-xt}}{1-e^{-t}}\,dt
\qquad(\Re s>1,\ x>0).
\]

Thus for \(x=n+1\),

\[
R_n^2=\zeta(\sigma,n+1),
\]

and the discrete depth index can be replaced by a continuous parameter
\(x\).  The discrete tail coil of §2.3 then becomes the continuous spiral

\[
Z(x):=\zeta(s,x),
\qquad
r(x):=|Z(x)|,
\qquad
\theta(x):=\arg Z(x),
\]

so that \(Z(x)=r(x)e^{i\theta(x)}\), the integer samples satisfy
\(Z(n+1)=Z_n\), and \(Z(x)\to0\) as \(x\to\infty\) for \(\Re s>1\).
The annuli \(A_n\) interpolate to a continuous annular field with squared
radius \(R^2(x)=\zeta(\sigma,x)\); the discrete coil is the integer
sampling of this continuous spiralling coil.

This integral is the Hurwitz-zeta form of the Mellin/Laplace representation in
§5.5.  It is formalised in [`lean/ContinuousCoil.lean`](lean/ContinuousCoil.lean):
`mellin_shiftedZetaKernel_eq` proves
\[
\operatorname{mellin}(\text{shiftedZetaKernel }x)(s)
=
\Gamma(s)\,\text{shiftedTail}(x,s)
\qquad(x>0,\ \Re s>1),
\]
and `continuousCoil_eq_integral` records the continuous coil as the normalized
integral.  Analytic continuation beyond \(\Re s>1\) is not claimed.

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

For Euler products this is formalised in [`lean/EulerProduct.lean`](lean/EulerProduct.lean):
the finite product-to-sum identity is `finite_eulerProduct_exp_log`; the prime
log-series is summable (`eulerLogSeries_summable`); its exponential is `ζ(s)`
for `\Re s>1` (`riemannZeta_eulerProduct_exp_log`); and after enumerating the
primes by `Nat.nth`, the log-series has the phase-carrying coil representation
`eulerLogSeries_coil`.

### 2.2 Complex terms and angular bookkeeping

For an absolutely summable complex series \(c_n=|c_n|e^{i\theta_n}\), apply the
annular construction to \(|c_n|\) and place a sector of area \(|c_n|\) at angle
\(\theta_n\) in the annulus \(A_n\). The result is a phase field on the disk,
and

\[
\sum_{n\ge0}c_n=\int_{D}e^{i\theta(z)}\,d\mu(z).
\]

The scalar sum is a vector-valued area integral. This is formalised in
[`lean/VectorArea.lean`](lean/VectorArea.lean): `vectorArea c` is a
`VectorMeasure ℕ ℂ`; its value on a measurable set is `∑' n in A, c n`, it is
countably additive, and its phase decomposition is
`vectorArea c A = ∑' n in A, phaseWeight c n`, where
`phaseWeight c n = ‖c n‖ exp(arg(c n) i)`. The total vector area is
`∑' n, c n`, bounded by the total area `∑' n, ‖c n‖`.

For a conditionally convergent series, the angular placement is a
**summation method**; rearrangements can change the value, so absolute
convergence (or a proved rearrangement-invariance statement) is required
before identifying it with the ordinary sum.

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
   series and is Lean-proved in `VectorArea.lean`.
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
R_n^2=\sum_{k=n}^{\infty}\frac{1}{(k+1)^2},
\qquad
\frac{1}{(n+1)^2}=R_n^2-R_{n+1}^2.
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

The pole-term part of this contour connection is formalised in
[`lean/ExplicitFormula.lean`](lean/ExplicitFormula.lean). For a test function
`h` holomorphic on a disk containing `0` and `1`,

```lean
theorem explicitFormula_poleContour :
  (∮ z in C(c, R), poleKernel z * h z) =
    (2 * π * I) * (h 1 - h 0)
```

with `poleKernel z = (z * (z - 1))⁻¹`. The companion
`explicitFormula_poleContour_residue_form` writes the same integral as
`2πi h(1) + 2πi (−h(0))`. This is the exact Cauchy-residue mechanism behind the
two pole terms. The sum over the actual zeros and the Weil-positivity statement
remain open.

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

### 5.7 The continuous integral version: the closed form and where it stops

The sentence in §7.4 — “for general \(n^{-\sigma}\) no such closed form is
known” — is a statement about the **discrete** sum. Its continuous analogue
does have an elementary closed form, and isolating it shows exactly where
discreteness enters.

**The integral.** For \(\sigma>1\),

\[
\zeta_{\mathrm c}(\sigma)
:=\int_1^\infty x^{-\sigma}\,dx
=\frac{1}{\sigma-1}.
\]

The continuous coil is the tail

\[
Z_{\mathrm c}(x)
:=\int_x^\infty t^{-\sigma}\,dt
=\frac{x^{1-\sigma}}{\sigma-1},
\qquad x>0,
\]

so \(Z_{\mathrm c}(1)=\zeta_{\mathrm c}(\sigma)\),
\(Z_{\mathrm c}(x)\to0\) as \(x\to\infty\), and

\[
-Z_{\mathrm c}'(x)=x^{-\sigma}.
\]

This is the exact continuous analogue of
\(a_n=R_n^2-R_{n+1}^2\): the term is the negative derivative of the tail, and
the total is the tail evaluated at the lower endpoint. *(Lean-checked: T81 —
`integral_Ioi_rpow_neg_eq_inv_sub_one`,
`integral_Ioi_rpow_neg_eq_continuousIntegralCoil`,
`hasDerivAt_continuousIntegralCoil`.)*

**Why the angular partition degenerates.** For real \(s=\sigma\),
\(Z_{\mathrm c}\) is real and positive, so it can serve as its own squared
radius:

\[
R^2(x):=Z_{\mathrm c}(x)=\frac{x^{1-\sigma}}{\sigma-1}.
\]

The annular density is then
\(-dR^2/dx=x^{-\sigma}\), and the total area is
\(R^2(1)=1/(\sigma-1)\). The phase is identically zero: every sector is the
same sector, and the “angular” partition collapses to the radial one. There is
nothing to partition — which is precisely why the continuous case is trivial.
The scaling is a pure power law, with logarithmic rates \(1-\sigma\) for the
radius and \(-\sigma\) for the term; the rate is set by \(\sigma\), as it must
be.

For complex \(s=\sigma+it\) the coil is instead the logarithmic spiral

\[
Z_{\mathrm c}(x)
=\frac{x^{1-\sigma}}{\sigma-1}\,e^{-it\log x},
\]

which is exactly self-similar. With \(\lambda=e^{2\pi/|t|}\),

\[
Z_{\mathrm c}(\lambda x)
=e^{-2\pi(\sigma-1)/|t|}\,Z_{\mathrm c}(x).
\]

This is Lean-checked as T82 (`continuousComplexCoil_selfSimilar`), with the
per-turn scalar factor isolated as `cpow_selfSimilar_factor`.

One full turn multiplies \(x\) by \(e^{2\pi/|t|}\) and the radius by
\(\rho=e^{-2\pi(\sigma-1)/|t|}\); the areas of successive turns form a
geometric sequence of ratio \(\rho^2\). The continuous coil is therefore the
exact self-similar case of §2.4, while the discrete coil is only a sampling of
it.

**Where the closed form stops.** The discrete series is not the integral.
Euler–Maclaurin in the Hurwitz parameter gives, for fixed \(\sigma\) as
\(x\to\infty\),

\[
\zeta(\sigma,x)
=\frac{x^{1-\sigma}}{\sigma-1}
+\frac{x^{-\sigma}}{2}
+\sum_{k\ge1}\frac{B_{2k}}{(2k)!}
(\sigma)_{2k-1}\,x^{-\sigma-2k+1},
\]

where \((\sigma)_m=\sigma(\sigma+1)\cdots(\sigma+m-1)\). At \(x=1\),

\[
\zeta(\sigma)
=\frac{1}{\sigma-1}
+\frac12
+\sum_{k\ge1}\frac{B_{2k}}{(2k)!}(\sigma)_{2k-1}.
\]

The odd Bernoulli numbers vanish, \(B_{2k+1}=0\) for \(k\ge1\), so only the
\(1/2\) boundary term and the even Bernoulli tail survive. That tail does not
terminate, and for fixed \(\sigma\) its terms grow without bound: it is an
asymptotic, not a convergent, series. The “adjustment” that turns the integral
into the sum is exactly this non-terminating even-Bernoulli series. Nothing in
the angular construction removes it, because the angular construction is exact
for both objects; the difference is the sampling of the power law at the
integers.

This is the precise sense in which the cases differ. The continuous integral
is elementary for every \(\sigma\); the discrete sum is elementary at the even
integers \(\sigma=2m\) (Bernoulli/Fourier, equivalently the functional equation
at the trivial zeros), but not for general real \(\sigma\) — no closed form is
known at \(\sigma=3\), for instance. Representing \(\zeta(\sigma)\) as an area
does not change which function of \(\sigma\) it is.

**Parity does not remove the tail.** Splitting the discrete series by parity
gives

\[
\sum_{n\ \mathrm{odd}}n^{-\sigma}=(1-2^{-\sigma})\zeta(\sigma),
\qquad
\sum_{n\ \mathrm{even}}n^{-\sigma}=2^{-\sigma}\zeta(\sigma),
\]

so \(\zeta(\sigma)\) survives on both sides, and parity is only a rescaling.
The continuous parity split does close, but only after shifting the argument:
the odd unit intervals give

\[
\sum_{k\ge0}\int_{2k+1}^{2k+2}x^{-\sigma}\,dx
=\frac{\eta(\sigma-1)}{\sigma-1},
\]

and the even intervals give
\(1-\eta(\sigma-1)/(\sigma-1)\), where \(\eta\) is the alternating zeta. At
\(\sigma=2\) these are \(\log 2\) and \(1-\log 2\). Thus parity produces a
shift \(\sigma\mapsto\sigma-1\) in the continuous case, not an elimination of
the value. Sampling the power law at the left endpoint \(x=n\), at the
geometric mean \(\sqrt{n(n+1)}\) (shifting one factor of
\(x^{-\sigma}=x^{-\sigma/2}x^{-\sigma/2}\)), or at the right endpoint
\(x=n+1\) (shifting both) moves only the \(1/2\) boundary term between the two
sides; it does not remove the even-Bernoulli tail.

**Numerical check (mpmath, 25 digits).** The integral identity is exact to
\(10^{-17}\) at \(\sigma=1.5,2,2.5,3,4.2\). The self-similarity ratio at
\((2.3,1.7)\) agrees to \(10^{-30}\). The Euler–Maclaurin partial sums bracket
\(\zeta(\sigma)\) and then diverge:

| \(\sigma\) | \(1/(\sigma-1)\) | \(\zeta(\sigma)\) | EM \(m=1\) | \(m=2\) | \(m=3\) |
|---|---|---|---|---|---|
| 2 | 1 | 1.64493406685 | 1.66666666667 | 1.63333333333 | 1.65714285714 |
| 3 | 0.5 | 1.20205690316 | 1.25 | 1.16666666667 | 1.25 |
| 4.5 | 0.285714285714 | 1.05470751076 | 1.16071428571 | 0.937276785714 | 1.27642299107 |

These are numerical checks, not a formalisation. They confirm the closed-form
identities above (the integral, coil and self-similarity statements are
Lean-checked, T81–T82) and the divergence of the even-Bernoulli tail.

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

### 6.1 The exactness audit (O6)

The audit is recorded in [`EXACTNESS-AUDIT.md`](EXACTNESS-AUDIT.md), with a
machine-readable matrix in [`python/audit.py`](python/audit.py). Each infinite
series or transform is classified **before** an evaluator is assigned:

| Class | Count | Meaning |
|---|---:|---|
| **E1** exact closed evaluation | 7 | exact transform and closed value |
| **E2** exact representation | 8 | exact transform, closed value separate |
| **E3** exact finite part | 5 | regularized value of a divergent raw series |
| **X** exact obstruction | 2 | exact divergence/obstruction diagnosis |
| **F** finite evaluator only | 1 | certified partial-sum-plus-tail fallback |
| **O** open | 2 | explicit-formula zero sum and general Bernoulli/full-plane |

The 25 audited objects include geometric, halving, annular, `p`-series,
complex, Dirichlet, Mellin, Euler-product, vector-area, pole-contour,
continuation and Bost–Connes cases.
No object with an exact transform is assigned a finite truncation as its
representation of infinity. The Lean fixes for the audit rows A4, A6, A16 and
A18 are T64–T67; the Bost–Connes fixes A23–A25 are T68–T72.

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

The continuous integral analogue is elementary (§5.7):
\(\int_1^\infty x^{-\sigma}dx=1/(\sigma-1)\). The gap between the integral and
the discrete sum is the Euler–Maclaurin sampling defect. Its odd Bernoulli
terms vanish, but its even tail does not terminate, so the defect is an
asymptotic series rather than a closed-form correction. The absence of a
closed form is therefore a property of the discrete sum, not of the angular
representation.

### 7.5 The \(w=e^{-s}\) compactification is not required

If one additionally maps depth to radius by \(w=e^{-s}\), then
\(n^{-s}=w^{\log n}\). This map is a covering \(\mathbb C\to\mathbb C^\times\),
not a coordinate change on the \(s\)-plane: it quotients by the period
\(2\pi i\). Two different statements are often conflated here.

**(i) Intrinsic monodromy.** As a function of \(s\), \(\zeta\) is single-valued
and meromorphic on \(\mathbb C\), with its only pole at \(s=1\); \(\eta\) is
entire; the harmonic series continues as the digamma function with poles at the
non-positive integers. Their monodromy in the \(s\)-plane is **trivial**. The
exception in the table below is Lerch zeta, which is multi-valued in its
parameter. So non-trivial monodromy is not the generic case for \(\zeta\)-type
objects.

**(ii) Monodromy of the \(w\)-quotient.** Because \(\zeta\) is **not**
\(2\pi i\)-periodic, it does not descend to a single-valued function on
\(\mathbb C^\times\). Going once around \(w=0\) sends \(s\mapsto s+2\pi i\) and
changes the value, so the descended function has infinite cyclic monodromy.
No finite cover makes it single-valued; its natural home is again the universal
(maximal abelian) cover, the \(s\)-plane. This is the real obstruction to a
finite-monodromy compactification — and it is a property of the quotient, not
of \(\zeta\)'s analytic continuation.

The point \(w=0\) is an isolated **essential** singularity of
\(w\mapsto\zeta(-\log w)\), not a natural boundary. The Dirichlet series
\(\sum_n w^{\log n}\) has radius of convergence \(e^{-1}\) (the image of
\(\Re s=1\)); each branch of the continued function is meromorphic on the cut
plane, with a pole at \(w=e^{-1}\). The series does not see the continuation past
\(|w|=e^{-1}\); that is a limitation of the representation, not a boundary of
the function.

| Object | Continuation in \(s\) | Monodromy in \(s\) | \(w=e^{-s}\) quotient |
|---|---|---|---|
| \(\zeta\) | meromorphic on \(\mathbb C\), pole at \(1\); \(\infty\) essential | trivial | infinite cyclic, \(s\mapsto s+2\pi i\) |
| \(\eta\) | entire | trivial | infinite cyclic |
| harmonic | digamma, poles at \(-\mathbb N_0\) | trivial | infinite cyclic |
| general Dirichlet | often meromorphic | usually trivial | infinite cyclic unless \(2\pi i\)-periodic |
| Lerch | multi-valued in the parameter | non-trivial | non-trivial; maximal abelian cover |

Caveat on the source table: \(\zeta\) is **not** meromorphic on the Riemann
sphere. A meromorphic function on \(\mathbb C\mathrm P^1\) is rational, whereas
\(\zeta\) has infinitely many zeros and an essential singularity at \(\infty\).
"Meromorphic on the sphere" should be read as "meromorphic on \(\mathbb C\),
with the finite pole at \(1\)".

The annular representation of §2 avoids the issue entirely: it uses the tail
radii directly and never quotients by \(2\pi i\). The two constructions should
not be conflated.

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

### 7.7 Bost–Connes periodic-orbit data

The Bost–Connes periodic orbits have lengths \(n\log p\). For a single prime
\(p\), the angular series is geometric:

\[
\sum_{n\ge0}\left(p^{-s}\right)^n=\frac1{1-p^{-s}}
\qquad(\Re s>0).
\]

This is `bostConnes_single_prime_angular` / `bostConnes_single_prime_tsum`.
For all primes the product of these single-prime sums is the zeta Euler
product (`bostConnes_all_primes_product` / `bostConnes_all_primes_tprod`) in
\(\Re s>1\).

The obstruction is exact: for distinct primes \(p,q\), the logs
\(\log p\) and \(\log q\) have no common positive period
(`log_primes_not_commensurable`). Hence the full prime data have no finite
monodromy; the Euler product is the exact replacement in the convergence
domain.

**Continuation beyond the convergence domain.** The continuation does not need
the general Bernoulli subtraction of O8; it is proved directly.

For a single prime the continued sum is
\[
F_p(s):=\frac1{1-p^{-s}}.
\]
It is meromorphic on the whole plane (`meromorphicOn_bostConnesSinglePrime`),
holomorphic away from the zeros of \(1-p^{-s}\)
(`differentiableAt_bostConnesSinglePrime`), and agrees with the convergent
angular series on \(\Re s>0\) (`bostConnes_single_prime_continuation`). Its
poles are exactly the periods
\[
p^{-s}=1
\iff
\exists k\in\mathbb Z,\quad s\log p=2\pi i k
\iff
s=\frac{2\pi i k}{\log p}
\qquad(k\in\mathbb Z),
\]
which is `bostConnesSinglePrime_pole_iff` (stated in the multiplied form
\(s\log p=2\pi ik\)). The pole spacing \(2\pi/\log p\) is the period of the
single-prime orbit, as expected.

For all primes, the Euler product agrees with \(\zeta\) on \(\Re s>1\), and
\(\zeta\) is the meromorphic continuation to the whole plane, holomorphic away
from its only pole at \(s=1\) (`bostConnes_all_primes_continuation`). This is
the Bost–Connes continuation: the periodic-orbit product continues to the
completed/global zeta function, not to a new object.

These three statements are T83–T85. They are independent of the general
\(k\)-th Bernoulli subtraction of O8; that construction is a separate
analytic-estimate problem and is not required for the continuation values.

### 7.8 Finite Gram positivity

The finite algebraic shadow of the positivity problem is formalised in
[`lean/Gram.lean`](lean/Gram.lean). For a finite family of real vectors `v i`
in an inner-product space, define

\[
G_{ij}=\langle v_i,v_j\rangle,\qquad
Q(c)=\sum_{i,j}c_iG_{ij}c_j.
\]

Then

\[
Q(c)=\left\|\sum_i c_i v_i\right\|^2\ge0,
\]

so every finite Gram matrix is positive semidefinite. This is the exact
finite PSD certificate. It applies to annular/sector indicator vectors, whose
Gram entries are the overlaps of the sectors.

This is **not** the analytic Weil positivity statement. It is the finite
algebra that any such test-vector model must satisfy. The specific finite
\(4\times4\) Gaussian Weil–Gram certificate is now Lean-proved (**O4 closed**,
§7.9), and the \(5\times5\) rung follows (**M0′ closed**); the infinite analytic
Gram matrix and its positivity over the actual zeta zeros remain open, with
the zero-side bridge and its progress recorded in §7.10.

### 7.9 The finite zero side and the O4 certificate (closed)

The finite zero side is Lean-proved in the local library rather than
re-proved here. In
[`absolute-polarized-hodge-index-realization/lean/ExplicitFormula.lean`](../absolute-polarized-hodge-index-realization/lean/ExplicitFormula.lean),
`test_function_explicit_formula` gives

\[
\oint_{\partial R}\frac{Z'}{Z}(z)\,h(z)\,dz
=2\pi i\Bigl(\sum_{\rho\in S}h(\rho)-h(0)-h(1)\Bigr)
\]

for a finite zero set \(S\) in a rectangle, simple and exhaustive there. The
terms \(-h(0)-h(1)\) are the same pole residues as T51–T52.

The truncation error is
[`TailBound.lean`](../absolute-polarized-hodge-index-realization/lean/TailBound.lean),
`zero_sum_tail_bound`: for two rectangles with zero sets \(S,S'\) (nested when
read as a tail) and \(\|(Z'/Z)h\|\le M\) on both boundaries,

\[
\Bigl|\sum_{\rho\in S'}h(\rho)-\sum_{\rho\in S}h(\rho)\Bigr|
\le\frac{M}{2\pi}\bigl(\mathrm{perimeter}'+\mathrm{perimeter}\bigr).
\]

The finite Gram route (M0′) is in
[`prime-spectrum-tensor`](../prime-spectrum-tensor/README.md).  The
entrywise-to-Loewner transfer `posDef_of_entry_bound` uses the correct norm (an
entrywise margin \(\varepsilon\) perturbs the spectrum by at most
\(n\varepsilon\), not by \(\varepsilon\)), and `gramCentre4_sub_posDef`
proves by exact rational \(LDL^{\top}\) arithmetic that the rounded numerical
Gram matrix minus \(\tfrac{227}{10000}I\) is positive definite; the assembly
`gaussianGram4_posDef_of_enclosure` then reduces the exact matrix to an
entrywise enclosure with \(\varepsilon<0.005675\).

That entrywise enclosure is now supplied.  The finite certificate is
**complete** (2026-11-05):

- the pole, prime and density enclosures (`PoleEnclosure.lean`,
  `PrimeEnclosure.lean`) and the assembly
  `gaussianGram4_posDef_of_density_enclosure_loose`
  ([`Assembly.lean`](../prime-spectrum-tensor/lean/Assembly.lean)), which turns
  the target into four `densityTerm` bands of half-width \(3.5\cdot10^{-3}\);
- the generated density certificates
  [`DensityC0_0.lean`](../prime-spectrum-tensor/lean/DensityC0_0.lean) …
  [`DensityC3_8.lean`](../prime-spectrum-tensor/lean/DensityC3_8.lean)
  (36 chunk files; 1305 graded panels for each of
  \(c=0,\tfrac15,\tfrac25,\tfrac35\)), each proving
  `IntersectionForm.density (1/20) c ∈ Set.Icc LO HI` with explicit rationals,
  to a per-panel error \(K=\sum_p E_p+10^{-4}\approx1.45\cdot10^{-3}\);
- [`DensityCertificates.lean`](../prime-spectrum-tensor/lean/DensityCertificates.lean),
  which converts the four intervals into the assembly's bands and proves

\[
\texttt{(gaussianGram4 (1/20)).PosDef}
\]

  with no `sorry`, `axiom` or `admit`, and only Lean's three standard axioms
  (`#print axioms`: `propext`, `Classical.choice`, `Quot.sound`).

The numerical layer is a certified computation: \(\Omega\) is enclosed at the
midpoint of each panel by `IntersectionForm.omega_mem_scaled` (a scaled-log
version of the shared library's enclosure, \(N=4\), \(M=45\)), the node
values \(w(m)=\tfrac1{400}e^{-m^2/400}\cos(cm)\) by `Real.exp_bound` and the
local cos Taylor remainder, the panels are glued by the cumulative
`panel_step`, and the tail \(t>60\) is bounded by `density_tail_le`.

The rational shadow `L4Shadowᴴ * L4Shadow` still certifies only the rounded
shadow; what changed is that the *exact* transcendental matrix is now also
certified, by the entrywise enclosure above.  The analytic chain that feeds it
was already machine-checked in
[`prime-spectrum-tensor/lean`](../prime-spectrum-tensor/lean/) (no `sorry`,
only Lean's three standard axioms):

- the bridge `densityTerm c σ = 2·density σ c` to the shared library's
  `omega_mem` pointwise enclosure of `Ω`;
- two Lipschitz bounds for `Ω` (`|Ω′| ≤ 6/t` for `t ≥ 1`, and `|Ω′| ≤ 10` for all
  `t`), the global bound `|Ω(t)| ≤ log(t+2) + 24`, and the continuity and
  differentiability of `Ω`;
- a **midpoint rule with a second-derivative remainder** (Mathlib has no
  quadrature rule at all), the weight \(w(t)=\sigma^2e^{-\sigma^2t^2}\cos(ct)\)
  with `|w″| ≤ 1/400` and the rational decay bound `|w(t)| ≤ (1/400)/(1+a²/400)`;
- the **per-panel signed bound** `panel_certificate_decay`, its accumulation
  `panel_step`, the `Ioi` split, the Gaussian moment
  `∫_T^∞ (1/400)x·e^{−x²/400} = e^{−T²/400}/2`, the tail bound
  `|∫_{60}^∞ w·Ω| ≤ 10⁻⁴`, and the capstone `density_approx_error`;
- a **cos Taylor remainder** for `|x| ≤ 1` (Mathlib has none) plus its
  doubling step, i.e. the transcendental machinery for the node values.

The infinite zero sum \(\sum_\rho h(\rho)\) and the analytic Weil-positivity
statement are **not** part of O4 and remain open.

**The 5×5 rung (M0′, closed 2026-11-05).**  The same machinery extends one
step, to the five centres \(-0.4,-0.2,0,0.2,0.4\) at \(\sigma=1/20\).  The
only new separation is \(c=4/5\); the other four are already certified.  The
new density chunks
[`DensityC4_0.lean`](../prime-spectrum-tensor/lean/DensityC4_0.lean) …
[`DensityC4_8.lean`](../prime-spectrum-tensor/lean/DensityC4_8.lean), the pole
bound `poleTerm_mem_c4`, the prime bound `primeTerm_mem_four_fifths` (using
\(e^{-100(x-4/5)^2}\le e^{-8x}\) for \(x\ge\log 3\)), and the exact
rational transfer
[`GaussianGram5.lean`](../prime-spectrum-tensor/lean/GaussianGram5.lean) feed
[`DensityCertificates5.lean`](../prime-spectrum-tensor/lean/DensityCertificates5.lean),
which proves

\[
\texttt{(gaussianGram5 (1/20)).PosDef}.
\]

The numerical smallest eigenvalue is \(0.0214238\); the entry budget is
\(\varepsilon=0.0036\) against \(5\varepsilon<0.02\).  The scoping record is
[`HANDOFF-M0P-5X5.md`](../prime-spectrum-tensor/HANDOFF-M0P-5X5.md).  This too is
a finite statement, not the infinite Weil cone.

### 7.10 Towards Weil positivity: the zero-side bridge

The finite certificates of §7.9 are the entrywise side.  The other half of the
Weil explicit formula is the zero side.  For the Gaussian bump
\(h_c(v)=\sqrt{\pi}\,\sigma\,e^{-(v-c)^2/(4\sigma^2)}\), the zero-side test
function is

\[
H_c(s)=2\pi\sigma^2 e^{\sigma^2(s-1/2)^2}e^{-c(s-1/2)},
\]

whose critical-line values are the Fourier transform
\(H_c(1/2+it)=2\pi\sigma^2e^{-\sigma^2t^2}e^{-ict}\), and whose pole values
sum to the pole term
\(H_c(0)+H_c(1)=4\pi\sigma^2e^{\sigma^2/4}\cosh(c/2)\).

Two pieces are now Lean-checked
([`GaussianZeroSide.lean`](../absolute-polarized-hodge-index-realization/lean/GaussianZeroSide.lean)):

* the contour identity
  \[\oint_{\partial R}\frac{Z'}{Z}(s)\,H_c(s)\,ds
    =2\pi i\Bigl(\sum_{\rho\in S}H_c(\rho)-H_c(0)-H_c(1)\Bigr)\]
  for a finite zero set \(S\) in a rectangle;
* the rank-one factorization
  \(H_{a-b}(1/2+i\gamma)=\varphi_a(\gamma)\overline{\varphi_b(\gamma)}\)
  with \(\varphi_a(\gamma)=\sigma\sqrt{2\pi}e^{-\sigma^2\gamma^2/2}e^{-ia\gamma}\).
  Consequently, for any finite family of critical-line frequencies
  \(\gamma_k\), the real zero-side Gram matrix
  \[G_{ij}=\sum_k 2\pi\sigma^2e^{-\sigma^2\gamma_k^2}
    \cos((a_i-a_j)\gamma_k)\]

  is positive semidefinite (`zeroSideGramReal_posSemidef`).  This is the
  spectral explanation of the finite certificates: the zero side is a Gram
  matrix of real cosine/sine modes.

Numerically, the first 40 non-trivial zeros reproduce the five 5×5 Gram entries
to \(3.5\cdot10^{-18}\) (C25).  The margin-scaling audit shows that the fixed
spacing-`0.2` ladder stalls at \(n=9\)
([`MARGIN-SCALING.md`](../prime-spectrum-tensor/MARGIN-SCALING.md)).

The remaining analytic gap is the prime/archimedean evaluation of the same
contour integral, together with the infinite-zero limit; an off-line zero
contributes an indefinite term and is the precise obstruction.  The scoping
note is
[`ZERO-SIDE-BRIDGE.md`](../prime-spectrum-tensor/ZERO-SIDE-BRIDGE.md).

This is not Weil positivity on the cone and not RH.  The full work breakdown,
including the prime/archimedean evaluation, the contour shift, the infinite-zero
limit and the off-line obstruction, is in
[`HANDOFF-O2.md`](HANDOFF-O2.md).

#### O2 status: the precise reduction

O2 is the infinite zero sum and Weil positivity.  Its unconditional closure is
**RH-equivalent**: the programme's own assessment
([`WEIL-POSITIVITY.md`](../prime-spectrum-tensor/WEIL-POSITIVITY.md) §2) shows
that any uniform lower bound on the Weil form, and hence positivity on the whole
cone, rules out every off-line zero.  So O2 cannot be marked closed without
proving the Riemann hypothesis.  What can be formalised is the reduction.

The state of the reduction is:

| Component | Status |
|---|---|
| pole-term contour connection (T51–T52) | Lean-checked |
| zero-side Gaussian `H_c` and the finite-zero-set contour identity | Lean-checked (`GaussianZeroSide.lean`) |
| rank-one factorization and finite zero-side PSD | Lean-checked (`zeroSideGramReal_posSemidef`); the named statement `ZeroSideWeilPositivity` is proved |
| pole term `= H_c(0)+H_c(1)` on the Gram side | Lean-checked (`poleTerm_eq_zeroSideGaussian_pole`) |
| numerical zero-side bridge, first 40 zeros | checked to `3.5·10⁻¹⁸` (C25) |
| prime/archimedean evaluation of the contour integral | partial: the Gaussian vertical-line integral `integral_exp_gaussian_line`, the critical-line phase integral `integral_critical_line_phase`, its mass corollary `integral_critical_line_zero_phase`, the centre/frequency symmetry `integral_critical_line_phase_swap`, the weighted form `integral_phase_weighted`, the termwise von Mangoldt contribution `integral_vonMangoldt_term_critical_line`, the finite-sum linearity `integral_finset_sum_phase`, the truncated von Mangoldt sum `integral_finset_sum_vonMangoldt`, its integrability lemma `integrable_phase_weighted`, the general vertical phase integral `integral_vertical_phase`, the zero-frequency vertical integral `integral_gaussianZeroTest_vertical` (and its `Re s = c` case `integral_gaussianZeroTest_vertical_self`), the termwise vertical prime term `integral_vonMangoldt_term_vertical`, the finite vertical prime side `integral_finset_sum_vonMangoldt_vertical`, its integrability lemma `integrable_phase_vertical`, the **unconditional** finite vertical prime side `integral_finset_sum_vonMangoldt_vertical_all`, the unconditional truncated prime side `integral_finset_sum_vonMangoldt_all`, the infinite prime-side reduction `hasSum_integral_vonMangoldt`, the right-side prime/archimedean decomposition `integral_logDeriv_gaussianZeroTest_right_side`, its general form `integral_logDeriv_gaussianZeroTest_right_side'`, the rectangle assembly `rectIntegral_gaussian_right_side`, the reflection `gaussianZeroTest_one_sub` (with its norm form `gaussianZeroTest_one_sub_norm` evenness `gaussianZeroTest_one_sub_zero`, pole swap `gaussianZeroTest_one_eq_neg_zero`, `gaussianZeroTest_zero_eq_neg_one`, the vertical-integral limit `tendsto_vertical_integral`, the Gaussian horizontal limit `tendsto_exp_neg_sq_zero`, the horizontal vanishing `tendsto_horizontal_integral_zero`, the rectangle-limit assembly `tendsto_rectIntegral_of_sides`, the weighted vertical limit `tendsto_vertical_integral_logDeriv`, the explicit-formula assembly `explicit_formula_assembly` its Gaussian specialisation `explicit_formula_gaussianZeroTest`, the archimedean/prime capstone `explicit_formula_gaussianZeroTest_arch_prime`, the right-side limit identification `right_limit_eq_arch_prime`, the left-side limit identification `left_limit_eq_arch_prime`, the Gaussian-sum summability `summable_exp_neg_sq`, its linear-bound form `summable_exp_neg_sq_of_abs_ge` (a model; the actual zeros grow sublinearly), the named zero-tail input `ZeroTailSummable`, the inverse-square comparison `summable_of_eventually_le_inv_sq`, the sublinear zero-tail reduction `summable_exp_neg_div_log_sq_of_le`, the log-cube growth limit `tendsto_log_cube_div_sq_zero`, the sublinear domination `eventually_exp_neg_div_log_sq_le_inv_sq`, the unconditional `n/log n` tail summability `summable_exp_neg_div_log_sq`, the zero-tail reduction `zeroTailSummable_of_ge_div_log`, the named vertical-integrability input `VerticalLogDerivIntegrable`, and the named W4 bound `FullBlockWithin`), the pointwise functional-equation reflection `logDeriv_mul_gaussianZeroTest_one_sub`, the integrated left-side reflection `integral_logDeriv_gaussianZeroTest_left_eq_neg_right`, and its symmetric case `integral_logDeriv_gaussianZeroTest_left_eq_neg_right_zero` are Lean-checked; the `Re s > 1` L-series sum and contour shift are open |
| vertical-line modulus, phase, mass and real value of `H_c` | Lean-checked (`gaussianZeroTest_vertical_norm`, `gaussianZeroTest_norm`, `gaussianZeroTest_vertical_form`, `gaussianZeroTest_real`, `gaussianZeroTest_real_norm`, `gaussianZeroTest_zero_norm`, `gaussianZeroTest_one_norm`, `gaussianZeroTest_pole_norm_mul`, `integral_vertical_norm`, `integral_norm_general`) |
| vertical/horizontal integrability of `H_c` | Lean-checked (`intervalIntegrable_gaussianZeroTest_vertical`, `_horizontal`) |
| horizontal-side decay | Lean-checked (`norm_horizontal_integral_le`): `exp(−σ²T²)` |
| infinite-zero limit and tail | open |
| off-line obstruction / no-go | partial: the quadruple `offLineQuad`, its `γ ↦ −γ`/`c ↦ −c` symmetries, the **closed forms** `offLineQuad_re`/`offLineQuad_re_exp`, and the **unconditional 2×2 obstruction** `offLineQuad_obstruction_unconditional` (via `exists_offLineQuad_gt`) are Lean-checked; the domination by the other zeros and the `γ = 0` case are open |

Concretely, the remaining formal obligations are:

1. prove that the contour integral of `(Z'/Z)H_c` over a contour enclosing the
   critical strip equals `−2πi(density(c)+prime(c))` (the sign to be pinned by
   the `c=0` case), using the integrated prime-side identity already in
   `ExplicitFormula.lean` and the archimedean identity;
2. pass from finite zero sets `S` to the full non-trivial zero set, using
   `zero_sum_tail_bound` and a polynomial growth bound for `Z'/Z` on the
   rectangle boundary (the Gaussian factor decays like `e^{−σ²T²}`);
3. quantify the off-line obstruction: for a zero with `β ≠ 1/2`, the
   symmetrised contribution grows like `e^{|c||β−1/2|}` and eventually dominates
   the bounded contribution of the on-line zeros, making a sufficiently wide
   Gaussian Gram matrix indefinite.

Items 1–2 are analysis; item 3 is the arithmetic heart.  Until they are done, O2
stays **Partial — advanced**, not closed.

### What this is — and is not

The target is a **finite, purely numerical statement about one explicit 4×4
matrix**: the Weil-Gram matrix of the Gaussian test function at `σ = 0.05` with
centres `−0.3, −0.1, 0.1, 0.3` is positive definite.  Its numerical truth is not
in doubt (`λ_min ≈ 0.0227097`), and its proof is a certified computation.

It is **not** a statement about the infinite Weil form, and it is **not** a step
towards the Riemann Hypothesis: positive definiteness of a finite Gram matrix on
a four-dimensional test-function space constrains nothing about the zeta zeros.
The dossier records the finite certificate because it is a fully explicit,
checkable instance of the machinery of T73–T76 — no more.

The full scoping, Lean work breakdown and acceptance criteria are in
[`HANDOFF-O4.md`](HANDOFF-O4.md).  The finite certificate is Lean-proved, so
**O4 is Closed**; the infinite Weil-positivity statement is a separate
question and remains open.

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
| product-to-sum | \(\prod(1+a_n)\) | \(\exp(\sum\log(1+a_n))\) | exact; Euler-product case Lean-proved |
| phase/angular | \(c_n=\lvert c_n\rvert e^{i\theta_n}\) | vector area integral \(\int e^{i\theta}d\mu\) | exact for absolutely summable \(c_n\); Lean-proved |

## 9. Theorem ledger

Every row marked **Theorem** is proved in the Lean files under
[`lean/`](lean/) with no `sorry`, `axiom` or `admit`.

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
| T38 | Theorem | **Finite Euler product-to-sum:** `∏ p∈P, (1−p^(−s))⁻¹ = exp(∑ p∈P, −log(1−p^(−s)))` when the factors are nonzero. | `AngularPartition.finite_eulerProduct_exp_log` |
| T39 | Theorem | **Summability of the Euler log-series:** `−log(1−p^(−s))` is summable over primes for `1 < re s`. | `AngularPartition.eulerLogSeries_summable` |
| T40 | Theorem | **Euler product-to-sum for `ζ`:** `exp(∑' p, −log(1−p^(−s))) = ζ(s)` for `1 < re s`. | `AngularPartition.riemannZeta_eulerProduct_exp_log` |
| T41 | Theorem | **Combined product-to-sum statement:** summability of the log-series together with the zeta identity. | `AngularPartition.riemannZeta_eulerProduct_product_to_sum` |
| T42 | Theorem | **Prime-enumerated log-series:** summability after enumerating primes by `Nat.nth`. | `AngularPartition.eulerLogSeries_summable_nth` |
| T43 | Theorem | **Annular/coil representation of the Euler log-series:** the tail-coil decomposition, radius/phase representation and convergence to zero. | `AngularPartition.eulerLogSeries_coil` |
| T44 | Theorem | **Phase weight reconstructs the term:** `phaseWeight c n = c n`. | `AngularPartition.phaseWeight_eq` |
| T45 | Theorem | **Vector-area evaluation:** `vectorArea c A = ∑' n : A, c n` for summable `c` and measurable `A`. | `AngularPartition.vectorArea_apply` |
| T46 | Theorem | **Countable additivity:** the vector area is a vector measure on disjoint measurable unions. | `AngularPartition.vectorArea_iUnion` |
| T47 | Theorem | **Total vector area:** `vectorArea c univ = ∑' n, c n`. | `AngularPartition.vectorArea_univ` |
| T48 | Theorem | **Coil identification:** the total vector area is the initial point `ctail c 0` of the phase coil. | `AngularPartition.vectorArea_univ_eq_ctail` |
| T49 | Theorem | **Total-area bound:** `‖vectorArea c univ‖ ≤ ∑' n, ‖c n‖`. | `AngularPartition.norm_vectorArea_univ_le` |
| T50 | Theorem | **Phase decomposition of the area field:** `vectorArea c A = ∑' n : A, phaseWeight c n`. | `AngularPartition.vectorArea_eq_phase_sum` |
| T51 | Theorem | **Pole-term contour connection:** `∮ h(z)/(z(z−1)) dz = 2πi(h(1)−h(0))` for `h` holomorphic on a disk containing `0,1`. | `AngularPartition.explicitFormula_poleContour` |
| T52 | Theorem | **Residue-form contour connection:** the same contour integral as `2πi h(1) + 2πi(−h(0))`. | `AngularPartition.explicitFormula_poleContour_residue_form` |
| T53 | Theorem | **Sharp first-order bound:** the once-subtracted kernel satisfies `0 ≤ h(t) ≤ t/12` for `t > 0`, with `1/12 = B₂/2` the next Laurent coefficient. | `AngularPartition.regularizedReal_nonneg`, `AngularPartition.regularizedReal_le_div_twelve` |
| T54 | Theorem | **Convergence and holomorphy on the doubled strip:** the annular Mellin integral converges and is holomorphic for `−1 < re s`. | `AngularPartition.mellinConvergent_regularizedKernel_of_neg_one_lt`, `AngularPartition.differentiableAt_mellin_regularizedKernel_of_neg_one_lt` |
| T55 | Theorem | **Extended integral identity:** `mellin regularizedKernel s = regularizedMellin s` on `−1 < re s`, `s ∉ {0, 1}`. | `AngularPartition.mellin_regularizedKernel_eq_of_neg_one_lt_re` |
| T56 | Theorem | **Completed annular part:** the completed finite part built from the annular integral and pole terms equals the entire function `Λ₀` on the doubled strip. | `AngularPartition.completedMellinPart_eq_completedRiemannZeta₀` |
| T57 | Theorem | **Functional equation as an integral identity:** the completed annular integral is symmetric under `s ↦ 1 − s` on the critical strip. | `AngularPartition.completedMellinPart_one_sub` |
| T58 | Theorem | **Second subtraction pole term:** the Mellin transform of the linear cutoff `−t/12` below `1` is `−1/(12(s+1))` for `−1 < re s`. | `AngularPartition.hasMellin_linCutoff` |
| T59 | Theorem | **Sharp second-order bound:** the twice-subtracted kernel satisfies `‖h₂(t)‖ ≤ t³/720` for `0 < t < 1`, with `1/720 = −B₄/4!`. | `AngularPartition.regularizedReal_sub_div_twelve_ge`, `AngularPartition.norm_regularizedKernel₂_le` |
| T60 | Theorem | **Convergence and holomorphy on the tripled strip:** the twice-subtracted annular integral converges and is holomorphic for `−3 < re s`. | `AngularPartition.mellinConvergent_regularizedKernel₂`, `AngularPartition.differentiableAt_mellin_regularizedKernel₂` |
| T61 | Theorem | **Tripled-strip identity:** `mellin regularizedKernel₂ s = regularizedMellin₂ s` on `−3 < re s` away from `−2, −1, 0, 1`. | `AngularPartition.mellin_regularizedKernel₂_eq_of_neg_three_lt_re` |
| T62 | Theorem | **Overlap identity:** on `−1 < re s` the two kernels' integrals differ exactly by the new pole term `−1/(12(s+1))`. | `AngularPartition.mellin_regularizedKernel₂_sub` |
| T63 | Theorem | **Pole cancellation at `s = −1`:** `(s+1)·regularizedMellin₂ s → 0` as `s → −1`; the subtracted term cancels the pole of `Γ(s)ζ(s)` (residue `1/12`). | `AngularPartition.regularizedMellin₂_residue_neg_one` |
| T64 | Theorem | **Normalized halving-sector total:** `∑' n, (1/2)^(n+1) = 1`. | `AngularPartition.half_turn_sector_hasSum`, `AngularPartition.half_turn_sector_tsum` |
| T65 | Theorem | **Exact divergence of reciprocal weights:** `∑ 1/(n+1)` is not summable. | `AngularPartition.not_summable_inv_nat_succ` |
| T66 | Theorem | **Infinite complex geometric series:** for `‖z‖ < 1`, `∑' n, z^n = (1−z)⁻¹`. | `AngularPartition.geometric_hasSum_complex`, `AngularPartition.geometric_tsum_complex` |
| T67 | Theorem | **Layer-cake representation:** for `a_n ≥ 0`, `ENNReal.ofReal (a n) = ∫⁻ t in Ioi 0, 1_{t < a n}`. | `AngularPartition.layer_cake` |
| T68 | Theorem | **Single-prime Bost–Connes angular sum:** `HasSum (fun n => (p^(-s))^n) (1−p^(-s))⁻¹` for `Re s > 0`. | `AngularPartition.bostConnes_single_prime_angular` |
| T69 | Theorem | **Single-prime Bost–Connes `tsum`:** the same closed form in `tsum` form. | `AngularPartition.bostConnes_single_prime_tsum` |
| T70 | Theorem | **All-prime Bost–Connes product:** the Euler product `HasProd` converges to `ζ(s)` for `Re s > 1`. | `AngularPartition.bostConnes_all_primes_product` |
| T71 | Theorem | **All-prime product in `tprod` form.** | `AngularPartition.bostConnes_all_primes_tprod` |
| T72 | Theorem | **Prime-log incommensurability:** `m log p ≠ n log q` for distinct primes and positive `m,n`. | `AngularPartition.log_primes_not_commensurable` |
| T73 | Theorem | **Gram quadratic form is a squared norm:** `∑ᵢⱼ cᵢ cⱼ ⟪vᵢ,vⱼ⟫ = ‖∑ᵢ cᵢ • vᵢ‖²`. | `AngularPartition.gramQuad_eq_norm_sq` |
| T74 | Theorem | **Finite Gram positivity:** every finite Gram quadratic form is nonnegative. | `AngularPartition.gramQuad_nonneg` |
| T75 | Theorem | **Gram matrix PSD:** every finite Gram matrix is positive semidefinite. | `AngularPartition.gramMatrix_posSemidef` |
| T76 | Theorem | **Gram matrix quadratic form:** the matrix form is nonnegative. | `AngularPartition.gramMatrix_quadForm_nonneg` |
| T77 | Theorem | **Shifted zeta kernel series:** for `x,t > 0`, the geometric series `Σ n, exp(−(x+n)t)` sums to `e^(−xt)/(1−e^(−t))`. | `AngularPartition.hasSum_shiftedZetaKernel` |
| T78 | Theorem | **Shifted Mellin series:** for `x > 0`, `Re s > 1`, the shifted Mellin series converges to `mellin (shiftedZetaKernel x) s`. | `AngularPartition.hasSum_mellin_shiftedZetaKernel` |
| T79 | Theorem | **Hurwitz-zeta integral representation:** `mellin (shiftedZetaKernel x) s = Γ(s) · shiftedTail(x,s)` for `x > 0`, `Re s > 1`. | `AngularPartition.mellin_shiftedZetaKernel_eq` |
| T80 | Theorem | **Continuous coil as a normalized integral:** `continuousCoil(s,x) = Γ(s)⁻¹ · mellin (shiftedZetaKernel x) s`. | `AngularPartition.continuousCoil_eq_integral` |
| T81 | Theorem | **Continuous integral closed form:** for `σ > 1`, `∫_1^∞ x^(−σ) dx = 1/(σ−1)`; the power-law coil `Z_c(x) = x^(1−σ)/(σ−1)` is the tail integral and `−Z_c′(x) = x^(−σ)`. | `AngularPartition.integral_Ioi_rpow_neg_eq_inv_sub_one`, `AngularPartition.integral_Ioi_rpow_neg_eq_continuousIntegralCoil`, `AngularPartition.hasDerivAt_continuousIntegralCoil` |
| T82 | Theorem | **Complex coil self-similarity:** for `s = σ + it` with `σ > 1` and `t ≠ 0`, the complex coil `Z_c(x) = x^(1−s)/(s−1)` satisfies `Z_c(e^(2π/|t|) x) = e^(−2π(σ−1)/|t|) Z_c(x)` for `x > 0`. | `AngularPartition.continuousComplexCoil_selfSimilar`, `AngularPartition.cpow_selfSimilar_factor` |
| T83 | Theorem | **Single-prime continuation:** `1/(1−p^(−s))` is meromorphic on `ℂ`, holomorphic where `p^(−s) ≠ 1`, and agrees with the angular series on `Re s > 0`. | `AngularPartition.meromorphicOn_bostConnesSinglePrime`, `AngularPartition.differentiableAt_bostConnesSinglePrime`, `AngularPartition.bostConnes_single_prime_continuation` |
| T84 | Theorem | **Bost–Connes pole set:** `p^(−s) = 1 ↔ ∃ k : ℤ, s log p = 2πik`, i.e. the poles are `s = 2πik/log p`. | `AngularPartition.bostConnesSinglePrime_pole_iff` |
| T85 | Theorem | **All-prime continuation:** the Euler product equals `ζ` on `Re s > 1`, and `ζ` is differentiable at every `s ≠ 1`; the periodic-orbit product continues to `ζ`, with its only pole at `s = 1`. | `AngularPartition.bostConnes_all_primes_continuation` |
| T86 | Theorem | **Kernel analyticity at zero (O8 foundation):** `1/(e^z−1) − 1/z` has a removable singularity at `0`; its extension is analytic at `0` (hence `C^∞` and Taylor-expandable to every order). | `AngularPartition.analyticAt_generalKernelC_zero`, `AngularPartition.norm_generalKernelC_le`, `AngularPartition.norm_exp_sub_one_ge` |
| T87 | Theorem | **Taylor remainder:** for every `n` there is a power series at `0` whose `n`-th partial sum approximates the analytic kernel with remainder `O(‖z‖^n)`. | `AngularPartition.exists_taylorRemainder` |
| T88 | Theorem | **Coefficient form:** `p.partialSum n z = Σ_{k<n} p.coeff k · z^k`. | `AngularPartition.partialSum_eq_sum_coeff` |
| T89 | Theorem | **Subtracted-kernel bound:** the `n`-th subtracted real kernel is `O(t^n)` at `0`, the hypothesis of `mellinConvergent_of_isBigO_rpow_exp`. | `AngularPartition.subtractedKernel_isBigO_zero` |
| T90 | Theorem | **Cutoff transform:** for `Re s > 1`, the Mellin transform of the polynomial cutoff `1/t + P_n(t)` on `(0,1]` is `1/(s−1) + Σ_{k<n} p.coeff k/(s+k)`; finite sums of Mellin transforms are handled by `hasMellin_finset_sum`. | `AngularPartition.hasMellin_cutoffN`, `AngularPartition.hasMellin_finset_sum` |
| T91 | Theorem | **Finite-part identity (convergence domain):** for `Re s > 1` and every `n`, `mellin K_n(s) = Γ(s)ζ(s) − 1/(s−1) − Σ_{k<n} p.coeff k/(s+k)`. | `AngularPartition.mellin_subtractedKernel_eq`, `AngularPartition.zetaKernelR_eq_zetaKernel` |
| T92 | Theorem | **Convergence on `Re s > −n`:** the subtracted kernel is locally integrable on `(0,∞)`, decays like `e^(−t)`, and its Mellin transform converges for `−n < Re s` (via `mellinConvergent_of_isBigO_rpow_exp`). | `AngularPartition.locallyIntegrableOn_subtractedKernel`, `AngularPartition.subtractedKernel_isBigO_atTop`, `AngularPartition.mellinConvergent_subtractedKernel` |
| T93 | Theorem | **Holomorphy on `Re s > −n`:** `mellin K_n` is complex differentiable for `−n < Re s`. | `AngularPartition.mellin_differentiableAt_subtractedKernel` |
| T94 | Theorem | **Formal Bernoulli core:** `(e^X−1)/X` is the reciprocal of the Bernoulli power series, and `(B(X)−1)/X` has coefficients `bernoulli (k+1)/(k+1)!`. | `AngularPartition.X_mul_expm1DivX`, `AngularPartition.bernoulliPowerSeries_mul_expm1DivX`, `AngularPartition.gSeries_coeff` |
| T95 | Theorem | **Kernel and formal identities:** `z(e^z−1)g(z) = z−(e^z−1)` and its formal counterpart `X(e^X−1)(B−1)/X = X−(e^X−1)`. | `AngularPartition.kernel_mul_identity`, `AngularPartition.X_mul_exp_sub_one_mul_gSeries` |
| T96 | Theorem | **Cauchy product of summable scalar series:** if `a,b` are absolutely summable with sums `A,B`, the range convolution has sum `A·B` (the `HasSum` form of Mathlib's Cauchy product theorem). | `AngularPartition.hasSum_mul_range` |
| T97 | Theorem | **Product of scalar power series:** if `f,g` have scalar power series `a,b` at `0`, then `f·g` has the Cauchy-product series. This supplies the `HasFPowerSeriesAt.mul` that Mathlib lacks. | `AngularPartition.hasFPowerSeriesAt_mul_ofScalars` |
| O1 | Closed | Vector-valued area field is proved for absolutely summable `c` by T44–T50. | T50 |
| O2 | Partial — advanced | **Weil positivity / the infinite zero sum.** Lean-proved: the zero-side Gaussian test function and finite-zero contour identity (`gaussian_zero_side_contour`); the rank-one factorization, finite zero-side PSD (`zeroSideGramReal_posSemidef`) and its named form `zeroSideWeilPositivity`; the pole-term identity (`poleTerm_eq_zeroSideGaussian_pole`); the **prime side** (Gaussian phase integrals, termwise von Mangoldt term, unconditional truncated prime side, finite vertical prime side); the **archimedean/prime decomposition** of the right vertical side (`integral_logDeriv_gaussianZeroTest_right_side'`); the **left-side reflection**; the **horizontal vanishing**; the **rectangle assembly**; the **infinite explicit formula** (`explicit_formula_assembly`, `explicit_formula_gaussianZeroTest`) and its **archimedean/prime capstone** (`explicit_formula_gaussianZeroTest_arch_prime`); and the **full 2×2 off-line obstruction** (`offLineQuad_obstruction_all`) with the conditional full-block domination (`offLineQuad_fullBlock_not_posSemidef`). Numerical: the first 40 zeros reproduce the five 5×5 Gram entries to `3.5·10⁻¹⁸` (C25). Remaining **named analytic inputs** (no further reductions): `ZeroTailSummable` (zero-counting lower bound `|γ_n| ≥ c·n/log n`), `VerticalLogDerivIntegrable` (integrability of `(Z'/Z)·H_c` on a vertical line), and `FullBlockWithin` (W4 zero-density entrywise bound). Unconditional O2 is RH-equivalent (`WEIL-POSITIVITY.md` §2). | T51–T52; T20; §7.10; [handoff](HANDOFF-O2.md) |
| O3 | Closed | Product-to-sum annular representation for Euler products is proved by T38–T43. | T43 |
| O4 | Closed | The finite zero sum and the pole terms are Lean-proved in the local library: `test_function_explicit_formula` gives `∮(Z'/Z)h = 2πi(Σ_{ρ∈S}h(ρ) − h(0) − h(1))` for a finite zero set `S` in a rectangle, and `zero_sum_tail_bound` bounds the zero sum in a larger rectangle by `(M/2π)(perimeter' + perimeter)` when `‖(Z'/Z)h‖ ≤ M` on both boundaries. The infinite analytic Gram/positivity statement remains open (it is not part of the finite O4 certificate). | T73–T76; local library `absolute-polarized-hodge-index-realization/lean/ExplicitFormula.lean`, `TailBound.lean`; [handoff](HANDOFF-O4.md). **W1 (2026-11-04):** `posDef_of_entry_bound` (correct `n·ε` transfer) and the exact rational `LDLᵀ` certificate `(gramCentre4 − (227/10000)I).PosDef` are Lean-checked in `prime-spectrum-tensor/lean/Transfer.lean`. **2026-11-05:** the whole analytic chain of the density term is Lean-checked (no `sorry`, standard axioms only) — the `density = 2·IntersectionForm.density` bridge, `\|Ω′\| ≤ 6/t` and `\|Ω′\| ≤ 10`, `\|Ω\| ≤ log(t+2)+24`, the **midpoint rule with remainder** (Mathlib has none), the weight's derivatives and bounds, the **per-panel signed bound** `panel_certificate`, the panel sum, the Gaussian moment tail, `\|∫_{60}^∞ w·Ω\| ≤ 10⁻⁴`, the capstone `density_approx_error`, and a **cos Taylor remainder with its doubling step**. The pole and prime terms are enclosed, and `gaussianGram4_posDef_of_density_enclosure_loose` reduces O4 to four density intervals of half-width `3.5·10⁻³`. **Closed (2026-11-05):** the numerical generation is complete — 36 generated chunk files `DensityC{0..3}_{0..8}.lean` (1305 graded panels per `c`) and [`DensityCertificates.lean`](../prime-spectrum-tensor/lean/DensityCertificates.lean), whose `gaussianGram4_posDef` proves `(gaussianGram4 (1/20)).PosDef` and depends only on `propext`, `Classical.choice`, `Quot.sound`. The infinite zero sum and Weil positivity remain open and are not part of O4. |
| O5 | Closed | Exact angular sums for Bost–Connes data: single-prime geometric sum, all-prime Euler product, prime-log commensurability obstruction (T68–T72), and meromorphic continuation beyond the convergence domain: single-prime poles (T83–T84) and all-prime continuation to `ζ` (T85). | T68–T72, T83–T85 |
| O6 | Closed | Exactness audit completed: 25 objects classified, with `EXACTNESS-AUDIT.md`, `python/audit.py` and `AUDIT-LOG.md` as the durable record. | A1–A25 |
| O7 | Closed | Continuation beyond the critical strip is Lean-proved through the doubled strip `−1 < re s` (T53–T55), the completed functional equation as an integral identity (T56–T57), and the second subtraction to `−3 < re s` with the explicit, cancelled `s = −1` pole (T58–T63). | T53–T63 |
| O8 | Partial | General `k`-th Bernoulli subtraction and the full-plane finite part beyond the tripled strip. Lean-proved: kernel analyticity (T86); Taylor remainder (T87); coefficient form (T88); subtracted-kernel bound (T89); cutoff transform (T90); finite-part identity on `Re s > 1` (T91); local integrability, Mellin convergence and holomorphy on `Re s > −n` (T92–T93); the formal Bernoulli reciprocal identity (T94), the matching kernel/formal identities (T95), the Cauchy-product brick (T96), and the product theorem for scalar power series (T97). Remaining: apply T97 to `(e^z−1)` and the kernel, identify the product series with `1−(e^X−1)/X`, and compare coefficients with `(B−1)/X`; then extend the identity from `Re s > 1` to `Re s > −n`. The Bost–Connes continuation (T83–T85) is independent. | T86–T97 |

## 10. Computation ledger

Every row is checked by [`tests/test_programme.py`](tests/test_programme.py)
with exact rational arithmetic; no floating point and no truncation. The audit
matrix is checked separately by [`tests/test_audit.py`](tests/test_audit.py).

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
the completed finite-part functional equation. [`lean/RegularizedIntegral.lean`](lean/RegularizedIntegral.lean)
contains the comparison bounds, the cutoff splitting and the critical-strip
identity. [`lean/Continuation.lean`](lean/Continuation.lean) extends the same
method beyond the strip: the sharp bounds `0 ≤ h(t) ≤ t/12` and
`‖h₂(t)‖ ≤ t³/720`, convergence and holomorphy of the annular Mellin integral
on `−1 < re s` and `−3 < re s`, the extended identities on both strips, the
completed functional equation as an integral identity
(`completedMellinPart = Λ₀`, symmetric under `s ↦ 1 − s`), and the explicit
`−1/(12(s+1))` pole term of the second subtraction with its cancellation at
`s = −1`. [`lean/EulerProduct.lean`](lean/EulerProduct.lean) contains the
finite Euler product-to-sum identity, the zeta log-series, the product-to-sum
theorem and the annular/coil representation of the Euler log-series.
[`lean/VectorArea.lean`](lean/VectorArea.lean) contains the vector-valued area
field, and [`lean/ExplicitFormula.lean`](lean/ExplicitFormula.lean) contains the
pole-term contour connection. The Lean files use Mathlib’s measure theory,
infinite-sum and geometric-series lemmas; they do not assume RH, analysis of
\(\zeta\), or any unproved arithmetic statement.

[`lean/README.md`](lean/README.md) records what is and is not formalised. The
short version: the infinite annular representation, the finite
annular/sectorial/measure algebra, the phase-carrying coil and vector area, the
Mellin/Laplace layer, the critical-strip finite-part identity, the continuation
of the annular Mellin identity to `−1 < re s` and (with the second subtraction)
to `−3 < re s` including the completed functional equation as an integral
identity, the Euler product-to-sum/coil, and the pole-term contour connection
are formalised, together with the finite \(4\times4\) Gaussian Weil–Gram
certificate; the general Bernoulli subtraction scheme, the full-plane
finite part, and the infinite explicit-formula zero sum / Weil positivity
are not.

Run:

```bash
./lean/check.sh
python3 -m pytest tests -q
```

## 12. Open questions

1. **The infinite zero sum and Weil positivity** (not O4, which is closed).
   The finite \(4\times4\) Gaussian Weil–Gram certificate is Lean-proved
   (`gaussianGram4_posDef`), and the pole-term contour connection and the
   finite Gram positivity shadow (T73–T76) are formalised, but the sum over
   the actual zeros, \(\sum_\rho h(\rho)\), and the analytic Weil-positivity
   statement remain open.
2. **O8 — General Bernoulli subtraction / full-plane finite part.** The
   doubled and tripled strips are complete (O7). The general \(k\)-th
   Bernoulli subtraction and the full-plane Hadamard finite part are **in
   progress**. Lean-proved: the analytic extension of \(g(t)=1/(e^t-1)-1/t\)
   at \(0\) (T86); the power-series remainder \(O(\|z\|^n)\) for every \(n\)
   (T87); the coefficient form of the partial sums (T88); the real
   \(n\)-th subtracted kernel \(O(t^n)\) at \(0\) (T89); the cutoff transform
   (T90); the finite-part identity on the convergence domain \(\Re s>1\)
   (T91); and local integrability, Mellin convergence and holomorphy on
   \(\Re s>-n\) (T92–T93). The Bost–Connes continuation is *not* blocked by
   this: it is proved independently by T83–T85.
   Remaining: extend the identity itself from \(\Re s>1\) to \(\Re s>-n\).
   This requires the agreement between the Taylor coefficients
   \(p.\mathrm{coeff}\ k\) and the residues of \(\Gamma\zeta\) at \(-k\),
   i.e. the Bernoulli/zeta value relation.

## 13. Links

- [Programme standard](../PROGRAMME-STANDARD.md)
- [Exactness audit (O6)](EXACTNESS-AUDIT.md)
- [Audit and change log](AUDIT-LOG.md)
- [Topics index](../README.md)
- [Depth-axis companion: partial sum plus tail](../partial-sum-plus-tail/README.md)
- [Absolute polarized Hodge-index dossier](../absolute-polarized-hodge-index-realization/README.md)
- [Programme memo](../absolute-polarized-hodge-index-realization/PROGRAMME-MEMO.md)
- [Periodic orbits](../periodic-orbits/README.md)
- [Scraps index](../../scraps.html)

**No RH proof yet.**
