# sin(x)/x with the greedy harmonic sine — research programme

**Status:** finite formal core and exact computation layer. The global convergence of the
greedy reconstruction is a **source claim** inherited from `harmonic-sine`; it is tested here
numerically and recorded as open, not proved. No Riemann-hypothesis claim is made.

**Exact-object reading (the inherited theorem).** The infinite greedy harmonic sine is exactly
`sin(x)` after the rescaling `y=x/π`. The replacement in `sin(x)/x` is therefore the identity,
and Euler's product, Basel, Wallis, the cotangent expansion and the `ζ(2k)` formulae hold
unchanged. See [The exact answer](#the-exact-answer). The finite-stage material below is an
optional study of truncations `S_N`, not a claim about the exact object.

**Source:** the sibling topic [`../harmonic-sine`](../harmonic-sine/README.md), whose source is
[`archive/maths/rh/research/harmonic-sine/harmonic-sine-rh.html`](../../archive/maths/rh/research/harmonic-sine/harmonic-sine-rh.html).
**Inventory:** a derived topic, not a separate [Scraps](../../scraps.html) entry; it descends from
item 15 (harmonic sine) and item 42 (sinc, sine kernel, moments). · [Topic index](../README.md).

## The question

The programme produces two different objects, and the distinction is the whole point:

- the **exact greedy harmonic sine** `G(x) = lim_N S_N(x)`, which is `sin(x)` after the rescaling
  `y = x/π`; and
- its **finite partial sums** `S_N(x)`, which are different functions.

The original question — what happens to `sin(x)/x` when its sine is replaced by the greedy
harmonic sine — is about the exact object. The answer is in [The exact answer](#the-exact-answer):
nothing changes. The rest of this dossier asks a narrower, optional question: what happens if the
sine is replaced by a finite partial sum `S_N`? For that question we use the normalised sinc of
the sibling topic [`../sinc-sine-kernel-moments`](../sinc-sine-kernel-moments/README.md),

\[
\operatorname{sinc}(x)=\frac{\sin(\pi x)}{\pi x}\quad(x\ne0),\qquad \operatorname{sinc}(0)=1,
\]

so that the truncated kernel is

\[
\operatorname{sinc}_N(x)=\frac{S_N(x)}{\pi x}\quad(x\ne0),\qquad \operatorname{sinc}_N(0)=0.
\]

The unnormalised kernel `sin(x)/x` is `sinc(x/π)`; every statement transfers by that rescaling.
The value at the origin for the truncation is determined by continuity: `S_N` vanishes on a whole
neighbourhood of `0`, so the continuous extension of `sinc_N` there is `0`, not `1`. For the exact
object the removable value is `1`, as for `sin(x)/x`.

## Provenance and what is being combined

- The archived harmonic-sine ebook defines the angle sequence, the greedy selection and the
  Pythagorean rotation. Its RH material is an **archived claim** and is not used here.
- The sibling [`harmonic-sine`](../harmonic-sine/README.md) reconstruction proves the finite
  rotation geometry (T1–T7 there) and records the convergence theorem `S_N → sin(πx)` as a
  **source claim**, tested but not formalised.
- The sibling [`sinc-sine-kernel-moments`](../sinc-sine-kernel-moments/README.md) fixes the
  normalised sinc and its elementary values; this topic reuses that normalisation.

This is therefore a **derived topic**. The exact object is the identity described above; the
finite-stage quotient `S_N(x)/(πx)` is studied only as an approximation, and every global limit
statement is explicitly conditional on the inherited reconstruction claim.

## The exact answer

Under the exact-object reading, `G(x) = lim_N G_N(x) = sin(x)`. Euler's product therefore applies
verbatim and the replacement is the identity. There is no new Euler product to discover.

**Taylor series.** For the exact object,

\[
\frac{\sin x}{x}=1-\frac{x^2}{3!}+\frac{x^4}{5!}-\cdots.
\]

For the exact reconstruction `θ(x)=x/π`, so substituting into the Taylor series of `sin` gives
the displayed series directly. Comparing it with the Euler product gives `−1/6 = −Σ1/n²`, hence
`ζ(2)=π²/6`. In the normalised variable `sinc(x)=sin(πx)/(πx)`, the coefficient is `−π²/6`.

The truncation is a different object. `G_N(x) = S_N(x/π)` vanishes on `|x| < π/(N+1)`, so
`G_N(x)/x` is identically zero on that interval and every Taylor coefficient at `0` is `0`.
Thus the `x²` coefficient of the truncation is `0` for every `N`, while the exact coefficient
is `−1/6`:

\[
\lim_{N\to\infty}[x^2]\Bigl(\frac{G_N(x)}{x}\Bigr)=0
\ne -\frac16=[x^2]\Bigl(\frac{\sin x}{x}\Bigr).
\]

Coefficient extraction and the greedy limit do not commute. That is a fact about the partial
constructions, not about the exact greedy harmonic sine. The exact object is unchanged.

## Truncation study (optional; not the greedy harmonic sine)

The original question is about the exact greedy harmonic sine. The answer is the exact-object
section above: there is no difference. Everything in this section is a separate study of the
finite partial sums `S_N`; it is not a claim about the greedy harmonic sine and should not be
read as one. The material is kept only because the sibling `harmonic-sine` programme and this
repository's Lean layer formalise the finite rotations.

### 1. Truncations lose the value at the origin

`θ_N` selects no step while the target is smaller than every available step. The first `N` steps
are `1/2, 1/3, …, 1/(N+1)`, all larger than `|x|` when `|x| < 1/(N+1)`, so the finite
reconstruction satisfies

\[
S_N(x)=0\qquad\text{for } |x|<\frac{1}{N+1},
\]

and therefore

\[
\operatorname{sinc}_N(x)=0\qquad\text{for } |x|<\frac{1}{N+1}.
\]

At every fixed stage the reconstructed kernel is **flat at the origin**, while `sinc(0)=1`. This
is a statement about the truncations, not about the exact greedy sine. The exact object is
formed by taking `G = lim_N S_N` first; then `G = sin` and `G(x)/x` has the removable value `1`.
The discrepancy is a double-limit artefact:

\[
\lim_{N\to\infty}\lim_{x\to0}\operatorname{sinc}_N(x)=0,
\qquad
\lim_{x\to0}\lim_{N\to\infty}\operatorname{sinc}_N(x)=1.
\]

**The two limits do not commute.** The sequence of continuous extensions `sinc_N` (with
`sinc_N(0)=0`) has pointwise limit `sinc(x)` for `x ≠ 0` and `0` at `x = 0`; the continuous
extension of the exact limit has value `1`. So the truncations do not converge uniformly to the
exact quotient at the origin. The exact object is still `sin(x)/x`; only the approximation loses
the removable value.

### 2. Truncations converge to sinc off the origin, but not uniformly

Conditional on the residual invariant `|θ_N(x) − x| ≤ 1/(N+1)` (the source's tested bound) and
the sine Lipschitz estimate, the quotient obeys

\[
\bigl|\operatorname{sinc}_N(x)-\operatorname{sinc}(x)\bigr|
\le \frac{1}{(N+1)|x|}\qquad(x\ne0).
\]

Hence convergence is uniform on every set `|x| ≥ a`, with rate `1/((N+1)a)`, but not on any
neighbourhood of the origin. At `x=0` the discrepancy is exactly `1` at every stage. Numerically
the sup-distance on `R` is at least `1` and does not tend to zero.

This also explains why the source's `O(1/N)` reconstruction rate is not a rate for sinc: dividing
by `x` converts an absolute error into a relative one, and the relative error near the origin is
`O(1/(N|x|))`, which is large precisely where sinc carries its value.

### 3. Finite stages do not share the zeros of sinc

The ordinary sinc vanishes at every non-zero integer. The finite reconstruction does not. At
`x=1`, the greedy word is `1,1,0,0,1` (take `1/2`, `1/3`, skip `1/4` and `1/5`, take `1/6`
exactly), so

\[
\theta_1(1)=\frac12,\quad
\theta_2(1)=\theta_3(1)=\theta_4(1)=\frac56,\quad
\theta_N(1)=1\ (N\ge5).
\]

Consequently, for odd integer `k`,

\[
\operatorname{sinc}_1(k)=\frac{1}{\pi k},\qquad
\operatorname{sinc}_N(k)=\frac{1}{2\pi k}\ (N=2,3,4),\qquad
\operatorname{sinc}_N(k)=0\ (N\ge5).
\]

For even `k` the reconstruction reduces to the zero branch and vanishes at every stage. Thus
the zeros at odd integers are recovered only after five steps, and in the meantime the
reconstructed kernel takes the non-zero values above at `x = ±π, ±3π, …`. The zeros of sinc are
simple and isolated; the zero set of `sinc_N` contains the interval `|x| < 1/(N+1)` and the
intervals on which `θ_N` is an integer, so it has interior and is not a discrete set.

There is a compensating exactness result. If `x` is rational, the greedy Egyptian expansion
terminates, so `θ_N(x)=x` for all sufficiently large `N` and `sinc_N(x)=sinc(x)` **exactly**.
Examples: `x=1/2` needs `N=1`; `x=1/3` needs `N=2`; `x=2/7` needs `N=27`; `x=3/7` needs `N=230`.
The required `N` blows up as `x → 0`, which is the pointwise face of the non-uniformity above.

### 4. The analytic structure is destroyed at every finite stage

`sinc` is entire, even, bandlimited (its Fourier transform is the indicator of `[-1/2,1/2]`),
and has the Euler product `sinc(x) = ∏_{n≥1}(1 − x²/n²)`.

At every finite `N`, `sinc_N` is a quotient of a step function by `x`:

- it is piecewise smooth with jumps at the greedy breakpoints (for `N=1`, a jump from `0` to
  `1/π` at `x=1/2`);
- it is not continuous, hence not entire;
- by the Paley–Wiener theorem it is **not bandlimited**: a compactly supported Fourier transform
  would make it entire;
- it is flat on a neighbourhood of `0`, so every derivative at the origin is `0`, whereas
  `sinc(x)=1−π²x²/6+…` has non-zero even Taylor coefficients;
- it has no product formula of the sinc type, because its zero set has interior.

So the replacement preserves (in the limit) the values away from `0`, but not the two structural
properties that make sinc useful: the removable singularity and bandlimitedness. In particular
the finite stages cannot serve as a sampling kernel.

### 5. The truncated integral approaches `1/2` slowly

The classical half-line integral is `∫₀^∞ sinc(x) dx = 1/2`. The reconstructed kernel is
integrable in the improper sense (one period has zero mean by the odd reflection), and the
numerical values are

| `N` | `∫₀^∞ sinc_N(x) dx` |
|---:|---:|
| 1 | 0.1103178001 |
| 2 | 0.2003381969 |
| 3 | 0.2563750717 |
| 4 | 0.2941763239 |
| 5 | 0.3211765328 |
| 6 | 0.3428623524 |

The values increase towards `1/2`, but very slowly: at `N=100` the integral is still about
`0.4856`, roughly `1.4×10⁻²` below `1/2`. The table is a numerical observation, not a proof of
convergence or of a rate; the slow approach is consistent with the loss of a fixed amount of
mass near the origin at each stage and its slow compensation by phase errors further out.

### 6. The Euler product does not survive truncation

The truncation question is whether `G_N` inherits the product. It does not; three finite-stage
facts show why.

Euler's product is the prototype of a factorization over zeros:

\[
\frac{\sin(\pi x)}{\pi x}=\prod_{n=1}^{\infty}\Bigl(1-\frac{x^2}{n^2}\Bigr).
\]

Write `P_M(x) = ∏_{n≤M}(1 − x²/n²)` for its truncation. Three finite-stage facts block an
Euler-type factorization of `sinc_N`.

**The constant term fails first.** `P_M(0)=1` for every `M`, while `sinc_N(0)=0` for every `N`.
The truncation therefore fails at the origin before any coefficient comparison is possible. Even if
`sinc_N(0)` were assigned the value `1`, the equality would fail on the punctured interval
`0 < |x| < 1/(N+1)`, where the product is non-zero and `sinc_N` vanishes. The obstruction is not
repairable by a normalising constant: `sinc_N` is identically zero on
`|x| < 1/(N+1)`, so its zero set has interior, whereas a normally convergent product of non-zero linear
factors has at most countably many zeros and no interval of them. There is no Euler-type factorization of
`sinc_N` over isolated zeros.

**The Basel coefficient comparison fails at finite stage.** Euler expands

\[
P(x)=1-\Bigl(\sum_{n=1}^{\infty}\frac1{n^2}\Bigr)x^2+\cdots
\]

and equates the `x²` coefficient with the Taylor coefficient `−1/6` of `sin(πx)/(πx)`, giving
`ζ(2)=π²/6`. But `sinc_N` is flat on a neighbourhood of `0`: all of its Taylor coefficients
there vanish. Applying Euler's rule at finite stage would give `Σ 1/n² = 0`, i.e. `ζ(2)=0`,
instead of the exact `−1/6` above. The only route to `π²/6` is the limit `N → ∞`, where
`sinc_N → sinc` and Euler's identity is recovered — but that is Euler's classical theorem, not a
new proof.

**Zeros and the cotangent expansion.** For `N ≥ 5`, `sinc_N(k)=0` at every non-zero integer. The
zeros are nevertheless not the simple isolated zeros of sinc. Around `0` (and every even
integer) there is an interval of zeros. At an odd integer the value is `0`, but the function
jumps across it: at `x=1`, `sinc_N(1)=0` while the left limit is `1/(2π)` and the right limit is
`−1/(2π)` for `N ≥ 5`. The zero at `x=1` therefore has no order of vanishing; it is not an
analytic zero. Correspondingly, the logarithmic derivative is not meromorphic: on the intervals
where `sinc_N` is non-zero, `d/dx log|sinc_N| = −1/x` plus delta contributions at the greedy
breakpoints. Euler's companion identity

\[
\pi\cot(\pi x)=\frac1x+\sum_{n=1}^{\infty}\Bigl(\frac1{x-n}+\frac1{x+n}\Bigr)
\]

is a meromorphic identity with no finite-stage analogue. The poles of the cotangent are a
feature of the limit, not of the approximation.

**What does survive: the Wallis point.** At `x=1/2` the first greedy step is exact:
`θ_N(1/2)=1/2` for every `N ≥ 1`, so

\[
\operatorname{sinc}_N\bigl(\tfrac12\bigr)=\frac{2}{\pi}
\]

exactly at every stage (T24–T26). This is the value of Wallis's product. The truncated Euler
products `P_M(1/2)` decrease to the same limit:

| `M` | `P_M(1/2)` |
|---:|---:|
| 1 | 0.75 |
| 2 | 0.703125 |
| 5 | 0.6661834717 |
| 10 | 0.6519534238 |
| 50 | 0.6397791175 |
| 200 | 0.6374140569 |
| `∞` | `2/π ≈ 0.6366197724` |

So the Wallis *value* survives at its special point even though the product identity does not.
The agreement at `1/2` is a pointwise coincidence of the limit, not a factorization of the
finite-stage function.

**What survives in the limit.** If `S_N → sin(πx)`, Euler's product is recovered, and with it
`ζ(2)`, the higher values `ζ(2k)`, Wallis and the cotangent expansion. But the harmonic sine
adds no independent proof: it reproduces Euler's theorem only after the limit. There is a
superficial resonance between the two constructions — the Weierstrass factorization behind
Euler's product has genus one because `Σ 1/n` diverges, and the greedy reconstruction needs the
divergence of `Σ 1/(n+2)` for its angle approximation — but they use the harmonic sequence for
different purposes. Euler's factors are indexed by the zeros `n`; the greedy steps are additive
angle increments. The resonance is not an identity.

**The cosine product is out of reach here.** The companion identity
`cos(πx) = ∏_{n≥0}(1 − 4x²/(2n+1)²)` has its zeros at the half-integers, exactly the points where
the greedy sine is exact at every stage. This is a suggestive coincidence, not a greedy cosine product: the
source defines no greedy cosine, and this reconstruction does not invent one. The companion
product is therefore left out of the ledger rather than tested against an undefined object.

**Number-theoretic reading.** Euler's sine product is not the Euler product of `ζ`; it evaluates
`ζ(2k)` by symmetric functions of the zeros, not by multiplicative factors over primes. The
greedy data is additive (a sum of unit fractions), so replacing the sine does not produce a
multiplicative Euler product and says nothing about the prime factorization of `ζ`. Any claim
that the harmonic sine "explains" `ζ(2k)` must pass through the sine product's zero
factorization, which the finite stages do not have.

| Feature | Euler product `P(x)` | Finite stage `sinc_N(x)` |
|---|---|---|
| Value at `0` | `1` | `0` |
| Zero set | simple zeros at non-zero integers | interval around `0` and even integers; isolated odd integers with jumps |
| Taylor at `0` | `1 − π²x²/6 + …` | all coefficients `0` (flat) |
| `x²` coefficient | `−π²/6` | `0` |
| Log derivative | `π cot(πx)` (meromorphic) | `−1/x` plus a delta comb (not meromorphic) |
| `x = 1/2` | `2/π` (Wallis) | `2/π` exactly |
| `x = 1` | `0` | `0` for `N ≥ 5`, with a jump; `1/(2π)` for `N = 2,3,4` |

## Reconstructed objects and notation

| Object | Definition |
|---|---|
| Harmonic step | `ε n = 1/(n+2)`, in units of `π` |
| Residual | `r₀ = y`, `r_{n+1} = r_n − ε_n` if `ε_n ≤ r_n`, else `r_n` |
| Selection | `δ_n(y) = ε_n` if `ε_n ≤ r_n`, else `0` |
| Greedy angle | `θ_N(y) = Σ_{n<N} δ_n(y)` |
| Reconstruction | `S_N(y) = sin(π θ_N(y))` |
| Extension | reduce `y` mod 2; on `(1,2)` use `S_N(2−u) = −S_N(u)` |
| Reconstructed sinc | `sinc_N(y) = S_N(y)/(π y)` for `y ≠ 0`, `sinc_N(0) = 0` |
| Reference sinc | `sinc(y) = sin(π y)/(π y)`, `sinc(0) = 1` |

The Python layer uses the same names in snake case (`harmonic_step`, `greedy_theta`,
`theta_ext`, `recon_sine`, `recon_sinc`, `sinc`, `error_bound`, `vanishing_radius`,
`greedy_breakpoints`, `period_pieces`, `integral_recon_sinc`, `integral_sinc`).

## Theorem ledger

Every row marked **Theorem** is proved in [`lean/Topic.lean`](lean/Topic.lean) with no `sorry`,
`axiom`, or `admit`. Every row marked **Computation** is tested in
[`tests/test_programme.py`](tests/test_programme.py).

| # | Kind | Statement | Lean / test name |
|---|---|---|---|
| T1 | Theorem | `0 < ε n` for every `n`. | `SinXOverX.eps_pos` |
| T2 | Theorem | `ε` is strictly antitone. | `SinXOverX.eps_strictAnti` |
| T3 | Theorem | `n ≤ m` implies `ε m ≤ ε n`. | `SinXOverX.eps_le_eps_of_le` |
| T4 | Theorem | One greedy step never increases the residual: `step r n ≤ r`. | `SinXOverX.step_le_self` |
| T5 | Theorem | The residual never increases: `r_n ≤ y`. | `SinXOverX.resid_le` |
| T6 | Theorem | If `r_n < ε n`, then `δ_n = 0`. | `SinXOverX.delta_eq_zero_of_resid_lt` |
| T7 | Theorem | If `y < ε n` for all `n < N`, then `θ_N(y) = 0`. | `SinXOverX.theta_eq_zero_of_forall_lt` |
| T8 | Theorem | If `y < ε N`, then `θ_{N+1}(y) = 0`. | `SinXOverX.theta_eq_zero_of_lt_eps` |
| T9 | Theorem | `greedySine 0 = 0`. | `SinXOverX.greedySine_zero` |
| T10 | Theorem | `greedySine k = 0` for every integer `k`. | `SinXOverX.greedySine_int` |
| T11 | Theorem | `greedySine θ = 0` iff `θ` is an integer. | `SinXOverX.greedySine_eq_zero_iff` |
| T12 | Theorem | `0 < θ < 1` implies `0 < greedySine θ`. | `SinXOverX.greedySine_pos` |
| T13 | Theorem | `greedySine (5/6) = 1/2`. | `SinXOverX.greedySine_five_six` |
| T14 | Theorem | If `|θ_N − y| ≤ 1/(N+1)`, then `|S_N(y) − sin(πy)| ≤ π/(N+1)`. | `SinXOverX.reconSine_error` |
| T15 | Theorem | If `y < ε N`, then `S_{N+1}(y) = 0`. | `SinXOverX.reconSine_eq_zero_of_lt_eps` |
| T16 | Theorem | If `y < ε N`, then `sinc_{N+1}(y) = 0` (the vanishing zone). | `SinXOverX.reconSinc_eq_zero_of_lt_eps` |
| T17 | Theorem | `θ₂(1) = 5/6`. | `SinXOverX.theta_one_two` |
| T18 | Theorem | `θ₅(1) = 1`. | `SinXOverX.theta_one_five` |
| T19 | Theorem | `S₂(1) = 1/2`: the second stage is non-zero at an integer. | `SinXOverX.reconSine_one_two` |
| T20 | Theorem | `S₅(1) = 0`: the fifth stage recovers the integer zero. | `SinXOverX.reconSine_one_five` |
| T21 | Theorem | `step 0 n = 0`: a zero residual is unchanged by every later step. | `SinXOverX.step_zero` |
| T22 | Theorem | `resid (1/2) (N+1) = 0`: the first half-step leaves zero residual. | `SinXOverX.resid_half` |
| T23 | Theorem | `delta (1/2) (N+1) = 0`: no later step is selected. | `SinXOverX.delta_half_zero` |
| T24 | Theorem | `θ_{N+1}(1/2) = 1/2`: the Wallis angle is exact at every stage. | `SinXOverX.theta_half` |
| T25 | Theorem | `S_{N+1}(1/2) = 1`. | `SinXOverX.reconSine_half` |
| T26 | Theorem | `sinc_{N+1}(1/2) = 2/π`: the Wallis value survives at every stage. | `SinXOverX.reconSinc_half` |
| C1 | Computation | The greedy word at `y=1` is `1,1,0,0,1,0`; `θ₂(1)=5/6`, `θ₄(1)=5/6`, `θ₅(1)=1`; exact harmonic steps are selected as expected. | `test_greedy_word_at_one_and_theta_values` |
| C2 | Computation | The residual invariant `|θ_N(y) − y| ≤ 1/(N+1)` holds exactly on a rational grid. | `test_residual_invariant_on_grid` |
| C3 | Computation | `sinc_N` vanishes strictly inside `|x| < 1/(N+1)`, and at the boundary `x=1/(N+1)` the last step is exact. | `test_vanishing_zone_and_boundary` |
| C4 | Computation | The integer defect is exact: `sinc_1(k)=1/(πk)` and `sinc_{2,3,4}(k)=1/(2πk)` for odd `k`; zero for `N ≥ 5`; even integers vanish at every stage. | `test_integer_defect_is_exact` |
| C5 | Computation | `sinc_N(0)=0` for every `N` while `sinc(0)=1`; the two iterated limits at the origin differ. | `test_origin_and_noncommuting_limits` |
| C6 | Computation | The pointwise bound `1/((N+1)|x|)` holds on a grid, and convergence is uniform on `|x| ≥ a`. | `test_pointwise_convergence_and_uniformity_away_from_zero` |
| C7 | Computation | Convergence is not uniform near the origin: at `x=1/(N+2)` the reconstruction is `0` while `sinc(x) → 1`. | `test_convergence_is_not_uniform_near_the_origin` |
| C8 | Computation | `S_N` is odd and 2-periodic; `sinc_N` is even. | `test_parity_and_periodicity` |
| C9 | Computation | The greedy breakpoints and the period pieces are the expected ones for `N=1,2`. | `test_breakpoints_and_period_pieces` |
| C10 | Computation | The integral values for `N=1,…,6` match the recorded table and increase towards `1/2`. | `test_integral_values_and_convergence_to_one_half` |
| C11 | Computation | The tail expansion is stable: doubling the number of integrated periods changes the integral by less than `10⁻¹⁴`. | `test_integral_truncation_stability` |
| C12 | Computation | Rational arguments are eventually exact: `2/7` needs `N=27`, `3/7` needs `N=230`, and at those stages `sinc_N = sinc` to `10⁻³⁸`. | `test_eventual_exactness_on_rationals` |
| C13 | Computation | The Euler product is `1` at the origin while `sinc_N(0)=0`, so no Euler-type truncation can equal the finite stage there. | `test_euler_product_origin_obstruction` |
| C14 | Computation | `sinc_N(1/2)=2/π` exactly at every stage, and the truncated Euler products decrease to the same value. | `test_euler_product_wallis_point` |
| C15 | Computation | The Euler product vanishes at integers; the finite stage vanishes at odd integers only from `N=5`, with a jump from `+1/(2π)` to `−1/(2π)` across `x=1`. | `test_euler_product_integer_zeros_and_jump` |
| C16 | Computation | The Euler coefficient `−Σ1/n²` is negative, while `sinc_N` is flat on its zero interval, so the finite-stage coefficient comparison would give `ζ(2)=0`. | `test_euler_coefficient_heuristic_is_vacuous` |
| C17 | Computation | The exact `sin(x)/x` has `x²` coefficient `−1/6` and the normalised sinc has `−π²/6`; the truncation is flat, so its coefficient is `0`. | `test_taylor_coefficient_exact_and_truncated` |

## Source claims (not promoted to theorems)

| Claim | Source status | Reconstruction note |
|---|---|---|
| `S_N(y) → sin(πy)` for the greedy harmonic reconstruction. | Source claim of `harmonic-sine`, tested numerically there and here; not formalised there or here. | The finite error bound T14 is conditional on the residual invariant. The limit itself is not proved. |
| The residual invariant `0 ≤ r_n ≤ 1/(n+1)` in units of `π` (the source states `π/(n+1)`). | Source claim, tested exactly in `harmonic-sine` and here. | Used only to motivate the conditional bound; not proved in Lean. |
| The source's `h_n = √((1 − cos ε_n)/2) = sin(ε_n/2)` is the step sine. | **Erratum** in `harmonic-sine`. | The reconstruction here uses the corrected step `sin ε_n`; the half-angle form is not used. |
| "Harmonic sheaf acyclicity implies RH." | **Archived claim**, superseded, from the harmonic-sine source. | Not used, not formalised, and not a premise of any statement here. |

## Open items and gaps

1. **Prove the reconstruction limit.** The central inherited gap: `θ_N(y) → y`, hence
   `S_N(y) → sin(πy)`, for all `y`. The Python suite tests the residual invariant and the error
   bound but does not prove convergence. Everything in the "Truncation study" section that takes
   `N → ∞` is conditional on this.
2. **Formalise the one-point limit function.** Once item 1 is available, prove
   `sinc_N(x) → sinc(x)` for `x ≠ 0` and `sinc_N(0) = 0`, and hence that the limit function is
   sinc with the origin deleted. The interesting content is the failure of uniform convergence,
   not the pointwise statement.
3. **Prove the integral convergence and determine its rate.** The numerical values approach
   `1/2`, but no rate is known here. The observed approach is much slower than `1/N`; whether
   `∫ sinc_N → 1/2` at all is open in this dossier.
4. **Formalise the zero set.** `sinc_N` has intervals of zeros and jumps; a precise description
   of its zero set as a union of greedy cylinder intervals is not written down.
5. **Bandlimitedness.** The Paley–Wiener argument that no finite stage is bandlimited is a
   short proof on paper but is not formalised. The Fourier transform of `sinc_N` and the decay
   of its tails are not computed.
6. **Termination of the greedy expansion.** The eventual exactness of rational arguments (C12)
   is tested, not proved. The standard greedy Egyptian-fraction termination argument would
   supply it.
7. **No number-theoretic content.** This topic says nothing about `ζ`, primes, or RH. The
   archived harmonic-sine RH claim is not used; the quotient `sin(x)/x` has no zeta role here.
8. **Euler product.** The finite-stage obstruction is a paper argument: an interval of zeros
   versus a discrete factorization. Formalising infinite-product zero sets is open, and no
   non-standard product over greedy breakpoints is proposed here.

## Python layer

[`python/programme.py`](python/programme.py) implements the finite objects exactly:

| Function | Purpose |
|---|---|
| `harmonic_step(n)` | `1/(n+2)` as a `Fraction` |
| `greedy_word(y, N)` | the selection word `δ_0 … δ_{N−1}` |
| `greedy_theta(y, N)` | `θ_N(y)` |
| `theta_ext(y, N)` | the period-two odd extension |
| `recon_sine(y, N)` | `S_N(y)` |
| `recon_sinc(y, N)` | `sinc_N(y)` with the value `0` at the origin |
| `sinc(y)` | the reference normalised sinc |
| `vanishing_radius(N)` | `1/(N+1)` |
| `error_bound(y, N)` | `1/((N+1)|y|)` |
| `greedy_breakpoints(N)` | all breakpoints of `θ_N` on `[0,1]` |
| `period_pieces(N)` | the step pieces of `S_N` on one period |
| `integral_recon_sinc(N)` | numerical `∫₀^∞ sinc_N` |
| `integral_sinc()` | `1/2` |
| `first_exact_steps(y)` | the first `N` with `θ_N(y)=y`, or an error |
| `euler_product_truncated(y, M)` | the finite Euler product `∏_{n≤M}(1 − y²/n²)` |

Run from the repository root:

```bash
python3 -m pytest the-final-letter/topics/sin-x-over-x/tests -q
```

Recorded result: **20 passed** in under a second. The integral quadrature uses the exact step
decomposition of one period and a truncated moment expansion for the tail; the last test checks
that the truncation parameters are stable.

## Lean layer

[`lean/Topic.lean`](lean/Topic.lean) imports Mathlib, opens `namespace SinXOverX`, and defines
`eps`, `step`, `resid`, `delta`, `theta`, `greedySine`, `reconSine`, and `reconSinc`. It proves
T1–T26 with no `sorry`, `axiom`, or `admit`.

```bash
the-final-letter/topics/sin-x-over-x/lean/check.sh
```

Recorded build: [`lean/BUILD.log`](lean/BUILD.log) — `[check] OK Topic.lean`. See
[`lean/README.md`](lean/README.md) for exactly what is and is not formalised.

## Verification

```bash
python3 -m pytest the-final-letter/topics/sin-x-over-x/tests -q
the-final-letter/topics/sin-x-over-x/lean/check.sh
```

The topic passes the **structural audit**: the required README, index, sympy computation layer,
pytest suite and Lean core are present, and the Lean file contains no `sorry`/`axiom`/`admit`.
That certifies the layout, not that the prose, ledger names and Lean statements agree.

## Provenance and links

- [Sibling topic: harmonic sine](../harmonic-sine/README.md)
- [Sibling topic: sinc, sine kernel, moments](../sinc-sine-kernel-moments/README.md)
- [Archived source: harmonic-sine-rh.html](../../archive/maths/rh/research/harmonic-sine/harmonic-sine-rh.html)
- [Scraps inventory](../../scraps.html) — items 15 and 42
- [Topic index](../README.md) · [The Final Letter](../../index.html)

[Back to the topic index](../README.md) · [Scraps](../../scraps.html) · [The Final Letter](../../index.html)
