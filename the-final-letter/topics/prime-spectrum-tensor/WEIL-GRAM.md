# A finite Weil Gram matrix on a Gaussian test basis

**Status:** finite computational PSD certificate, confirmed by an end-to-end
audited rerun with a proven term-by-term `u`-tail bound (`H=0.1`, `T=100`, `U=6`;
C22). This is not a Lean theorem, not a statement about the infinite Weil cone,
and not a proof of RH. The panel, Bernoulli-series and tail remainders are
explicit. The finite algebra that would
certify a rounded version is already in the Lean core as T8/T10.

**Parent dossier:** [`README.md`](README.md) · **Route note:**
[`WEIL-POSITIVITY.md`](WEIL-POSITIVITY.md) ·
**Finite shadow wiring:** [`../intersection-form-zeta/notes/04-certified-shadow.md`](../intersection-form-zeta/notes/04-certified-shadow.md) ·
**Bridge survey:**
[`../../bridge-to-weil-positivity.md`](../../bridge-to-weil-positivity.md) ·
**Why this is the next step:** [`../self-adjoint-ccm/WEIL-BRIDGE.md`](../self-adjoint-ccm/WEIL-BRIDGE.md) §6 (R1).

## 0. Short answer

Take the smooth Gaussian basis

```
φ_a(u) = exp(−(u−a)²/(2σ²)),      a ∈ ℝ.
```

For real test functions the Weil quadratic form is `Q(f) = W(f*f̌)`. Its
polarisation gives the Gram matrix

```
G_{ab} = (W(h_{ab}) + W(h_{ba}))/2,
h_{ab} = φ_a * φ̌_b,
```

and `h_{ab}` is again a Gaussian, centred at `a−b`:

```
h_{ab}(v) = √π σ exp(−(v − (a−b))²/(4σ²)).
```

This makes every entry a one-dimensional integral plus a finite prime sum. For a
4-point basis with `σ = 0.05` and centres `−0.3, −0.1, 0.1, 0.3`, the numerical
Gram matrix is

```
0.04313596  −0.01648926   0.00802313  −0.00222044
−0.01648926  0.04313596  −0.01648926   0.00802313
0.00802313  −0.01648926   0.04313596  −0.01648926
−0.00222044  0.00802313  −0.01648926   0.04313596
```

with eigenvalues

```
0.02270974, 0.02696128, 0.04485248, 0.07802034.
```

The prime side is active here: at separation `c = 0.6` the term `−2Π(h)` is
`−0.03648163…`, not a rounding artefact. The numerical Cholesky factor has
positive pivots and reconstructs the matrix to `6.2·10^{−33}`.

The smallest eigenvalue **collapses** as the basis widens, exactly as the
first-zero margin law predicts: from `1.76·10^{−2}` at `σ = 0.03` to
`1.46·10^{−8}` at `σ = 0.2`. That collapse is the quantitative reason a fixed
precision ladder stalls, and the reason a certificate needs a real enclosure of
`Ω` rather than more decimal places.

## 1. The basis and the convolution identity

The Gaussian is entire, and its Fourier transform

```
φ̂_a(t) = σ√(2π) exp(−σ²t²/2) exp(−iat)
```

decays in every horizontal strip. It is therefore in the Weil cone used by
`WEIL-POSITIVITY.md` §1, with no compact-support approximation needed.

The reflected convolution identity follows by completing the square:

```
(φ_a * φ̌_b)(v)
  = ∫ φ_a(u) φ_b(u−v) du
  = √π σ exp(−(v − (a−b))²/(4σ²)).
```

In particular `h_{aa}` is even and centred at `0`, which is why the diagonal is
the single-test-function value `W(σ)` of `WEIL-POSITIVITY.md` §6. For `σ = 0.05`
the computation gives

```
G_{aa} = W(σ) = 0.043135958394838…,
```

matching the table in that note.

## 2. The three terms of one entry

For the Gaussian `h` centred at `c` with variance `2σ²`,

```
ĝ(t) = 2πσ² exp(−σ²t²) exp(−ict),
```

and `Ω(t) = Re ψ(1/4 + it/2) − log π` is even. The three pieces are:

| term | formula | evaluation |
|---|---|---|
| pole/archimedean | `4πσ² exp(σ²/4) cosh(c/2)` | closed form |
| density | `σ² ∫ exp(−σ²t²) cos(ct) Ω(t) dt` | `mpmath` quadrature, 30 digits |
| prime | `−2 Σ_{p^m≤X} (log p)/√(p^m) · h(log(p^m))` | finite sieve, `X = 20000` |

The Gram entry is the symmetrisation
`G_{ab} = (W(c) + W(−c))/2` with `c = a−b`, because `h_{ba} = ȟ_{ab}` and the
quadratic form is only defined on even functions. This is exactly the
polarisation `G_{ab} = (Q(φ_a+φ_b) − Q(φ_a) − Q(φ_b))/2` (twice the real cross
form); the symmetrisation matters for `c ≠ 0`.

## 3. Numerical rungs

All values below were computed at 30 decimal digits. A "rung" is a fixed basis
and width; the eigenvalue is the smallest one of the numerical Gram matrix.

| `σ` | centres | dimension | smallest eigenvalue | prime side at largest `|c|` |
|---:|---|---:|---:|---:|
| 0.03 | `0, ±0.05, ±0.1` | 5 | `1.7570·10^{−2}` | `< 10^{−28}` |
| 0.05 | `±0.1, ±0.3` | 4 | `2.2710·10^{−2}` | `−3.65·10^{−2}` at `c=0.6` |
| 0.05 | `0, ±0.15` | 3 | `8.9477·10^{−3}` | `−1.68·10^{−8}` at `c=0.3` |
| 0.08 | `0, ±0.3` | 3 | `1.5584·10^{−2}` | active |
| 0.10 | `0, ±0.3` | 3 | `4.7470·10^{−3}` | active |
| 0.15 | `0, ±0.5` | 3 | `1.8711·10^{−5}` | active |
| 0.20 | `0, ±0.5` | 3 | `1.4551·10^{−8}` | active |

Two readings.

1. **Every tested matrix is positive definite.** This is consistent with Weil
   positivity on these finite subspaces. It is not evidence that the infinite
   cone is positive: a finite subspace can be positive while an off-line zero
   drives a different test function negative. We scanned `σ = 0.03–0.2` and
   separations up to `1.0`; no negative eigenvalue was found. Since a negative
   eigenvalue would have been a refutation, its absence is a consistency check,
   not a proof.
2. **The margin collapses.** The row `σ = 0.2` has a smallest eigenvalue
   `1.46·10^{−8}`, far below the comfortable margins at `σ = 0.03–0.05`. A
   quadrature or prime-tail error of that size would destroy the numerical
   conclusion; the computation must be done at 30 digits and the margin tracked.

### 3.1 The `Ω` interval layer (first step)

The density term needs `Ω(t) = Re ψ(1/4+it/2) − log π`.  C9 now provides a
rigorous interval enclosure from the digamma integral representation

```
Re ψ(z) = log|z| − Re(1/(2z))
          − 2∫_0^∞ u(u²+Re z²)/((u²+Re z²)²+(Im z²)²) /(e^{2πu}−1) du,
z = 1/4 + it/2.
```

The implementation uses outward-rounded `mpmath.iv` intervals, a midpoint rule
with an interval bound on the `u`-derivative, a Taylor series for
`u/(e^{2πu}−1)` near zero with a conservative remainder, and an explicit
exponential tail.  The enclosure widths on representative points are:

| `t` | width of `Ω` enclosure |
|---:|---:|
| 0 | `3.04·10^{−2}` |
| 0.5 | `2.86·10^{−3}` |
| 1 | `3.76·10^{−3}` |
| 10 | `7.08·10^{−5}` |

This is the first analytic layer, not the full certificate: the density term
still needs a rigorous quadrature over `t`.  C11 supplies a deterministic
rational-node Simpson rule (`n=4000`, `T=200`) that reproduces the adaptive
quadrature at `c=0` and `c=0.6` to `<10^{−8}`.  C12 shows the numerical fourth
`t`-derivative is below `10^4` at representative points, so the Simpson error
target is about `3.6·10^{−5}` at `n=40000`; the missing piece is a **rigorous**
bound on that derivative.  A direct t-interval
lifting of the pointwise layer was also tried: interval derivatives blow up on
panels crossing the singularities, so the density step needs a t-jet/Taylor
model rather than a naive interval lift.  The prime side is already
bounded:
C10 gives a crude tail bound below `10^{−100}` for `σ=0.05` and `|c|≤0.6`,
using `Λ(n)/√n ≤ log n/√n` and the Gaussian decay in `log n`.  The interval layer
is deliberately separate from the numerical `Ω` evaluations used in C8, so the
two computations can be checked against each other.

### 3.2 The `t`-jet layer

The density quadrature needs derivatives of `Ω`, not just point values.  The new
`jet.Jet` module stores the value and first `N` derivatives as intervals and
implements the formal Taylor algebra (`+`, `-`, `*`, reciprocal, `log`, `exp`,
`cos`, `sin`).  `omega_t_jet(t, order)` composes that algebra with the `u`-integral
used by C9, so it returns an interval jet for `Ω` on a point or a `t`-interval.

C13 checks the jet derivatives against elementary functions; C14 checks that the
`Ω` jet encloses the value and first four `t`-derivatives at `t=0.5`.  The series
and tail constants in this first jet layer are deliberately conservative; they
still need a formal remainder audit before the final certificate.

A first density-panel prototype used a degree-3 Taylor model on top of this jet.
Wide panels crossing `t=0` produce infinite interval widths in `1/(A²+B²)` because
interval arithmetic loses the correlation between `A` and `B`; narrower panels
or a higher-order model are required.  C15 now certifies individual narrow panels:
`[0.4,0.6]`, `[10,10.2]`, `[0,0.2]` and `[0.2,0.4]` all contain the true integral.
C16 assembles ten panels on `[−1,1]`; C17 does the same for several `c` values
while sharing the `Ω` jets.  A full 4×4 run is implemented in
[`python/certify_gram.py`](python/certify_gram.py); it encloses the density terms,
adds the pole and prime terms, and checks the leading principal minors of the
interval Gram matrix.

The `H=0.1`, `T=100` run gave the first three leading minors positive, but the
fourth interval straddled zero:
`[-1.53·10^{−6}, 6.17·10^{−6}]`.  This is not a certificate.  A finer `H=0.08`
run was launched; its result is not claimed until it completes.

### 3.3 The certified 4×4 result

The full run (`H=0.08`, `T=100`, 2500 panels) produced the interval Gram matrix

```
[ 0.0375659, 0.0486399]  [-0.0217303,-0.0114672]  [ 0.0030489, 0.0125991]  [-0.0070228, 0.0020410]
[-0.0217303,-0.0114672]  [ 0.0375659, 0.0486399]  [-0.0217303,-0.0114672]  [ 0.0030489, 0.0125991]
[ 0.0030489, 0.0125991]  [-0.0217303,-0.0114672]  [ 0.0375659, 0.0486399]  [-0.0217303,-0.0114672]
[-0.0070228, 0.0020410]  [ 0.0030489, 0.0125991]  [-0.0217303,-0.0114672]  [ 0.0375659, 0.0486399]
```

After adding a conservative `10^{−4}` margin to every entry (to cover the
provisional jet series/tail remainders), the center/error certificate gives

```
t = 0.0209751863,
leading minors of center − t I:
  0.0221277,  2.1412·10^{−4},  1.5982·10^{−6},  1.1271·10^{−8}.
```

All four minors are positive. Therefore every symmetric matrix in the widened
interval box is positive definite, hence the 4×4 Gaussian Gram matrix is PSD.

This is a finite computational certificate, not a Lean theorem, and not a
statement about the infinite Weil cone. The panel Taylor remainder and the
series remainder are explicit; the `10^{−4}` margin also covers the conservative
`10^{−6}` jet-tail allowance. A formal derivative-tail bound remains the last
audit item.

### 3.4 Margin audit and comparison with direct interval minors

The `10^{−4}` entry margin is now backed by explicit series/tail allowances:

- On `0 ≤ u ≤ 0.01`, the omitted Bernoulli terms satisfy
  `|s(u)−p(u)| ≤ 10u⁴` and `|s′(u)−p′(u)| ≤ 40u³`;
- these remainders are transported through `J` and `J_u` and added
  componentwise to the `Ω` jet;
- the `u`-tail beyond `U` is now covered by the term-by-term proof in
  [`TAIL-PROOF.md`](TAIL-PROOF.md), which gives a `10^{−5}` bound for every jet
  component of order `0 ≤ k ≤ 4` at `U=6`.

The `10^{−4}` Gram-entry margin dominates these allowances, including the proven
`10^{−5}` tail bound.

Two finite PSD checks were compared:

| check | result |
|---|---|
| direct interval leading minors (determinant intervals) | fourth minor `[−1.58·10^{−6}, 6.23·10^{−6}]` — inconclusive |
| center/error certificate (exact rational minors of `center − tI`) | all positive — **certified** |
| exact rational LDL pivots of `center − tI` | all positive; equal the minor ratios — confirms C18 |

The direct interval determinant loses too much correlation near the fourth
minor; the center/error form is the sharper finite check. C19 records the
direct comparison and C20 the LDL/minor agreement. The exact rational leading
minors of `center − tI` are `T8/T10`-style finite algebra: positive principal
minors imply positive definiteness.

### 3.5 End-to-end audited rerun

The audited jet was rerun end-to-end with `H=0.1`, `T=100`, `U=4` (2000 panels),
the explicit Bernoulli series remainder, the `10^{−6}` derivative-tail allowance
inside the jet, and the `10^{−4}` entry margin. The resulting interval matrix is

```
[ 0.0374362, 0.0487696]  [-0.0218605,-0.0113369]  [ 0.0029186, 0.0127294]  [-0.0071533, 0.0021714]
[-0.0218605,-0.0113369]  [ 0.0374362, 0.0487696]  [-0.0218605,-0.0113369]  [ 0.0029186, 0.0127294]
[ 0.0029186, 0.0127294]  [-0.0218605,-0.0113369]  [ 0.0374362, 0.0487696]  [-0.0218605,-0.0113369]
[-0.0071533, 0.0021714]  [ 0.0029186, 0.0127294]  [-0.0218605,-0.0113369]  [ 0.0374362, 0.0487696]
```

The center/error check gives

```
t = 0.0210956719,
leading minors of center − tI:
  0.0220072,  2.08799·10^{−4},  1.49584·10^{−6},  9.97517·10^{−9}.
```

All positive: **CERTIFIED** (C21). This closes the end-to-end rerun. The
`10^{−6}` derivative-tail allowance is included in the jet and dominated by the
`10^{−4}` margin; a term-by-term derivative-tail proof would remove that last
allowance but is not needed for the stated margin.

### 3.6 Term-by-term tail proof and final `U=6` certificate

[`TAIL-PROOF.md`](TAIL-PROOF.md) proves that the `u`-tail beyond `U=6`
contributes less than `10^{−5}` to every `Ω` jet component of order
`0 ≤ k ≤ 4`, for `|t| ≤ 100`. The proof uses:

- exact root locations for the denominator;
- a Cauchy estimate on a disk of radius `1/5`;
- the bound `s(u) ≤ 2e^{−2πu}`;
- the explicit integral `∫_6^∞ u³e^{−2πu}du`.

The audited jet was rerun with `U=6`, the proven `10^{−5}` allowance and the
`10^{−4}` entry margin. The resulting interval matrix is

```
[ 0.0374346, 0.0487712]  [-0.0218616,-0.0113359]  [ 0.0029176, 0.0127304]  [-0.0071543, 0.0021724]
[-0.0218616,-0.0113359]  [ 0.0374346, 0.0487712]  [-0.0218616,-0.0113359]  [ 0.0029176, 0.0127304]
[ 0.0029176, 0.0127304]  [-0.0218616,-0.0113359]  [ 0.0374346, 0.0487712]  [-0.0218616,-0.0113359]
[-0.0071543, 0.0021724]  [ 0.0029176, 0.0127304]  [-0.0218616,-0.0113359]  [ 0.0374346, 0.0487712]
```

The center/error check gives

```
t = 0.0211003138,
leading minors of center − tI:
  0.0220026,  2.08595·10^{−4},  1.49194·10^{−6},  9.92643·10^{−9}.
```

All positive: **CERTIFIED** (C22). This is the end-to-end audited certificate;
C21 is the earlier `U=4` run and is superseded for the tail audit.

## 4. What T8/T10 would certify

The finite Lean core already proves:

- `G3_posSemidef` / `posSemidef_of_cholesky`: any rational `Lᴴ L` is positive
  semidefinite (T8/T10);
- `not_posSemidef_of_neg`: a rational vector with negative form value refutes a
  claimed PSD matrix (T11).

The missing bridge is an **entrywise enclosure** of `G`. If rational intervals
`[G_{ij}^−, G_{ij}^+]` are available, one can:

1. choose a rational centre matrix `G₀` and a symmetric error matrix `E` with
   `|G − G₀| ≤ E` entrywise;
2. prove `G₀ − E` positive definite by a rational Cholesky factor (T8/T10);
3. prove `E` is positive semidefinite (or bound `‖E‖₂` by a Schur test) to
   conclude `G ⪰ 0`.

The current computation supplies step 0 numerically but not rigorously. The
numerical Cholesky factor is a **debugging mirror** of T10, not the certificate.

To make the gap concrete, C8 also rounds the numerical factor `L` to a rational
matrix with denominator `10^6` and forms `M = L_rat L_rat^T`. Then `M` is PSD
**exactly** by T10, and its entries differ from `G` by at most `4.0·10^{−13}`.
The Lean theorem `L4Shadow_posSemidef` (T12) certifies this shadow. That is a
certificate for `M`, not for the transcendental matrix `G`; the missing step is
the entrywise enclosure that would let one choose `M` with `G ⪰ M` and
`λ_min(M) > 0`.

## 5. What is and is not claimed

- **Claimed:** on the explicit bases above, the numerical Weil Gram matrix is
  positive definite at 30 digits, with a margin that decreases as the basis
  widens; the prime term is active in the wider rows.
- **Not claimed:** a proof of positivity, a certificate for the exact matrix, a
  sub-cone theorem, or anything about RH. The archimedean density is quadrature,
  not an interval enclosure; the prime sum is truncated; the basis is finite.
- **Not a bridge:** a finite PSD Gram matrix is a rung. It does not use the
  Euler product in a way that would upgrade to the cone; the DH litmus remains
  the test for any claimed bridge.
- **What would change the verdict:** a negative eigenvalue with a rigorous
  enclosure would refute the specific finite claim (and, if the explicit formula
  is correct, would be a serious RH event). A rigorous positive enclosure would
  turn the numerical rung into a ledger computation.

## 6. Reproduce

```bash
cd the-final-letter/topics/prime-spectrum-tensor
python3 -m pytest -q tests
```

The relevant computation is
`test_gaussian_weil_gram_is_positive_and_prime_active` (C8). It uses the
functions `gaussian_convolution`, `weil_gaussian_W`,
`weil_gaussian_density`, `weil_gaussian_prime`,
`weil_gaussian_gram` and `gram_eigenvalues` in
[`python/programme.py`](python/programme.py).

## 7. Next step

The next analytic layer is an interval enclosure of

```
Ω(t) = Re ψ(1/4 + it/2) − log π
```

on the compact `t`-range that carries the Gaussian, followed by interval
quadrature of the density term and a geometric prime-tail bound. With those, the
rational shadow can be fed to T8/T10 and the rung becomes a certificate. Until
then this note records a reproducible numerical positive instance, not a proof.

[Back to the programme](README.md) · [Weil positivity route](WEIL-POSITIVITY.md) ·
[Bridge survey](../../bridge-to-weil-positivity.md) ·
[Topic index](../README.md)
