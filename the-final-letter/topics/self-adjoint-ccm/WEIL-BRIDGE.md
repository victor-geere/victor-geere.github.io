# From the CCM compression to Weil positivity — a bridge ledger

**Status:** development note and no-go assessment. No theorem of this note asserts
RH, GRH or Weil positivity. The finite algebra it adds is proved in
[`lean/Topic.lean`](lean/Topic.lean) and tested in
[`tests/test_programme.py`](tests/test_programme.py).

**Parent dossier:** [`README.md`](README.md) · **Route survey:**
[`../../bridge-to-weil-positivity.md`](../../bridge-to-weil-positivity.md) ·
**Host of the form:** [`../prime-spectrum-tensor/README.md`](../prime-spectrum-tensor/README.md).

Propositions 1 and 2 are proved in the text. They are not ledger **Theorem** rows:
the ledger reserves that label for Lean declarations. The finite algebraic parts of
the compression are T8–T11; the analytic spectral statement of Proposition 1 is a
short proof, not a formalisation.

## 0. Short answer

The CCM point-interaction operator is still the right *shape* of a Weil-positivity
bridge: a self-adjoint operator whose spectrum is manufactured, with the arithmetic
entering through prime-power data. But the operator written in the blueprint,
equation (3), cannot supply that bridge as it stands.

1. With the stated constant matching condition
   `ψ(x_j⁺) = exp(i α_j) ψ(x_j⁻)`, the spectrum is an arithmetic progression
   `E_n = (Θ + 2πn)/L` (periodic) or `(Θ + (2n+1)π)/L` (antiperiodic), where
   `Θ = Σ_j α_j`. It does not depend on the positions `x_j`. No choice of
   prime positions can turn that lattice into the Riemann zeros.
2. The formal band-limited compression `Q_{kℓ} = ⟨e_k, D_λ e_ℓ⟩` has an explicit
   Hermitian formula. Its diagonal is `ε μ_k + S/L`, with `S = Σ_j α_j` fixed by
   `λ`, while `μ_{-N}` (or `μ_N`, depending on the sign convention) diverges
   linearly in `N`. Hence the corner entry is negative for every sufficiently
   large band limit. The compression is not positive semidefinite and cannot be
   the positive CCM Weil matrix.
3. The source's identification `Q = QW` is therefore not merely unproved: on the
   formal matrix it is false, and on the test-space side it is not yet well posed,
   because the half-integer modes are not in the Weil cone.

The honest verdict is **B4 is blocked as written, not open in the sense of a
missing estimate**. What survives is a finite Hermitian core (T8–T11) and a sharp
filter: any repaired CCM truncation must have a bounded diagonal and a
non-lattice spectrum. Section 6 gives the repair options; the recommended finite
step is a Weil Gram matrix on a smooth test basis, not a comparison of `Q_N` with
the zeros.

---

## 1. The bridge as a chain

Weil's criterion is the classical endpoint. For `g = f * f̌` in the cone,

```
W(g) = 2∫ g(u) cosh(u/2) du − 2 Σ_{n≥2} Λ(n)/√n g(log n)
       + (1/2π)∫ ĝ(t) Ω(t) dt,
Ω(t) = Re ψ(1/4 + it/2) − log π,
```

and positivity of `W(g)` for every cone function is equivalent to RH. The CCM
route proposes to reach this through an operator. The chain has five links, and
they are not interchangeable.

| link | statement | status in this dossier |
|---|---|---|
| L0 | `W(g) ≥ 0` on the Weil cone ⇔ RH | classical source theorem, not formalised |
| L1 | a self-adjoint operator `D` with spectrum `{γ_n}` | **source claim; the written `D_λ` has a lattice spectrum, not `{γ_n}`** |
| L2 | its spectral measure is `μ_D = Σ_n δ_{γ_n}` | would follow from L1 and a spectral theorem |
| L3 | `W(f*f̌) = ∫ ĝ dμ_D` for every cone test function | the actual bridge; **not proved** |
| L4 | `μ_D ≥ 0`, hence `W ≥ 0` | formal once L3 is available |

L4 is never the hard step: a spectral measure of a self-adjoint operator is
positive by construction. The hard step is L3, the identification of the
operator's spectral measure with the Weil current. The dossier's T1–T7 are
bookkeeping for L1; none of them touches L3.

A second distinction matters. The blueprint uses the helix phase `φ`, which is
built from the zeros and assumes GRH. The bridge cannot use `φ`: that would put
the conclusion into the construction. The useful object is the prime-indexed
operator, not the zero-indexed curve. This note therefore stays with `D_λ` and
never uses `φ`.

---

## 2. The operator as written: a lattice spectrum

The blueprint's operator is

```
D_λ = i d/dx + Σ_{p^m ≤ λ²} α_{p^m} δ(x − m log p mod L),
α_{p^m} = c(p^m) p^{−m/2},   L = 2 log λ,   x ∈ [0,L],
```

with matching

```
ψ(x_j⁺) = exp(i α_j) ψ(x_j⁻)
```

at each scatterer `x_j = m log p mod L`, and with either periodic boundary
conditions (as the prose says) or half-integer Fourier modes (as the basis says).

**Proposition 1 (constant-matching spectrum).** Assume the matching phases
`α_j` are real and constant in the energy `E`. Choose an origin that is not a
scatterer. Then the spectrum of `D_λ` is

```
E_n = (Θ + 2πn)/L          (periodic),
E_n = (Θ + (2n+1)π)/L      (antiperiodic),
Θ = Σ_j α_j.
```

In particular, the positions `x_j` do not enter, and the spacing is always
`2π/L = π/log λ`.

*Proof.* On an interval between scatterers, `(D_λ − E)ψ = 0` is
`iψ′ = Eψ`, so `ψ(x) = A exp(−iEx)`. Crossing a scatterer multiplies `ψ` by
`exp(iα_j)`; propagating across an interval of length `ℓ` multiplies it by
`exp(−iEℓ)`. Going once around the circle therefore multiplies `ψ` by

```
exp(iΘ) exp(−iEL).
```

Periodicity requires this factor to be `1`; antiperiodicity requires it to be
`−1`. The two displayed spectra follow. Conversely, for any `E` satisfying the
condition, the piecewise exponential with the prescribed jumps is an
eigenfunction, so the condition is also sufficient. ∎

**Consequence.** The spectrum is a rigid translate of a lattice. The Riemann
zeros are not a lattice: the first gaps are approximately `6.887`, `3.986`,
`3.178`, …, and the counting function is `T log T / 2π + O(log T)`, not linear.
Matching the first zero by choosing `Θ` leaves the next spectral point at
`γ_1 + π/log λ`, not at `γ_2`. No `λ` and no `Θ` repair this.

The caveat is important. The proposition covers *constant* matching. A
matrix-valued but still constant matching gives a union of finitely many shifted
lattices, so it does not help either. An *energy-dependent* scattering matrix
would escape the argument, but a self-adjoint extension of a first-order
operator on a circle has constant boundary data; energy dependence has to come
from a different quantisation, not from the written `δ` matching. The blueprint
does not supply that extra structure.

This is a no-go for **S7** (the spectrum claim) and for using **S3** as a bridge;
it is not a proof that the operator fails to be self-adjoint, and not a disproof
of CCM. CCM's actual scaling operator is a different object; the helix operator
is the blueprint's geometric model of it, and the model has the wrong spectrum.

The same section also exposes a smaller inconsistency: the half-integer modes
`e_k(x) = exp(iμ_kx)`, `μ_k = (2π/L)(k+½)`, are antiperiodic, not periodic.
The dossier keeps both descriptions as source claims; a repair must choose one.

---

## 3. The finite compression: explicit formula and obstruction

The blueprint identifies the band-limited compression of `D_λ` with the CCM Weil
matrix. In the orthonormal basis `{e_k}_{|k|≤N}` the formal matrix is

```
Q_{kℓ} = ε μ_k δ_{kℓ}
          + (1/L) Σ_j α_j exp(i(μ_ℓ − μ_k) x_j),
```

where `ε = +1` is the dossier's convention and `ε = −1` is the literal
`i d/dx` diagonal. `μ_k = (2π/L)(k+½)`, and `α_j` is the real coupling at
`x_j`. The second term is the distributional `δ` contribution; the first is the
free part.

**Proposition 2 (Hermiticity and diagonal).** For real `α_j`, `μ_k`, `x_j` and
`L ≠ 0`, the matrix `Q` is Hermitian and its diagonal is

```
Q_{kk} = ε μ_k + S/L,      S = Σ_j α_j.
```

Both statements are in the Lean core as `CCM.ccmMatrix_isHermitian` (T8) and
`CCM.ccmMatrix_diag` (T9). The prime positions cancel from the diagonal because
`exp(i(μ_k − μ_k)x_j) = 1`.

**The corner obstruction.** Take `ε = +1` and the corner mode `k = −N`:

```
Q_{−N,−N} = −(2π/L)(N − ½) + S/L.
```

At fixed `λ`, `S` is a finite sum over prime powers `p^m ≤ λ²`, independent of
`N`. Hence `Q_{−N,−N} < 0` for every

```
N > S/(2π) + ½.
```

For `ε = −1` the same argument applies at `k = +N`. In either convention the
compression has a negative diagonal entry at large band limit. Multiplying the
whole matrix by `−1` merely moves the obstruction to the other corner. Reversing
the sign of the delta term only replaces `S` by `−S`; the divergence in `N`
remains. Therefore the compression is not positive semidefinite, and its
smallest eigenvalue is negative. This
contradicts the source's `ε_N > 0` *if* the source's `Q` is this compression.

Numerical values from the computation layer (40-digit `mpmath`, C10–C11):

| `λ` | `N` | dimension | corner `Q_{−N,−N}` | smallest eigenvalue |
|---:|---:|---:|---:|---:|
| 5 | 5 | 11 | −6.459033 | −6.858106 |
| 5 | 10 | 21 | −16.218939 | −16.703135 |
| 5 | 20 | 41 | −35.738751 | −36.314685 |
| 20 | 50 | 101 | −45.685284 | −49.142276 |

The corner moves linearly with `N`, as predicted. The table is a finite
falsification of the identification of this `Q` with a positive Weil matrix; it
is not a statement about the zeros.

**What is positive.** The prime/delta part alone,

```
Q^{δ}_{kℓ} = (1/L) Σ_j α_j exp(i(μ_ℓ − μ_k)x_j),
```

is positive semidefinite whenever `α_j ≥ 0`: it is a sum of non-negative
multiples of rank-one matrices `v_j v_jᴴ`, or equivalently of squared norms
`|Σ_k z_k exp(iμ_kx_j)|²`. This is T10 (`CCM.deltaForm_nonneg`). The negative
inertia of `Q` comes entirely from the free diagonal, not from the arithmetic
part. That is the useful structural lesson: the primes supply a positive
finite-rank piece; the divergent free piece is what needs the renormalisation.

---

## 4. Why this compression is not the Weil form

Even if `Q` had been positive, three gaps would remain.

1. **Test-space mismatch.** The modes `e_k` are bounded periodic (indeed
   antiperiodic) functions; they are not Schwartz functions and not in the Weil
   cone. Their Fourier transforms are sums of delta atoms, so the explicit
   formula defining `W(e_k,e_ℓ)` does not apply without a regularisation. S4
   compares a compression of an operator on a circle with a quadratic form on
   decaying test functions. The objects live in different spaces.
2. **Domain and `δ` mismatch.** A first-order operator with a jump condition
   `ψ(x⁺) = e^{iα}ψ(x⁻)` is a self-adjoint extension, but it is not literally
   the operator `i d/dx + αδ(x)` on the same domain. The quadratic form of the
   extension carries a boundary term, and `e_k` does not satisfy the jump
   condition. The formula in §3 is the blueprint's formal compression, not a
   proof that the compression is the extension's matrix.
3. **Positivity of the wrong object.** A finite compression of a self-adjoint
   operator can have negative eigenvalues without contradicting self-adjointness:
   compression is not spectral projection. The source uses the compression as a
   *positive Weil matrix*; that requires an identification theorem (L3), not just
   Hermiticity. No such theorem is stated, and the corner obstruction shows that
   the naive object cannot be it.

The combination is decisive for the advertised M0: the finite truncation as
described is not a positive-measure certificate, and its spectrum is not the
zero set.

---

## 5. What survives, and what it is good for

The finite core is small but genuine:

- `matching_unitary` (T5) and `matchingProduct_unitary` (T11): each matching
  phase, and their product, has modulus one. This is necessary for the
  self-adjoint extension and for the total-phase formula.
- `ccmMatrix_isHermitian` (T8): the formal compression is Hermitian.
- `ccmMatrix_diag` (T9): the diagonal is exactly `ε μ_k + S/L`.
- `deltaForm_nonneg` (T10): the arithmetic part is positive semidefinite.

These are best read as a **filter on repairs**, not as progress toward L3. Any
candidate finite CCM matrix must at least:

1. have a diagonal bounded uniformly in `N` (otherwise the same corner argument
   applies);
2. possess a positive semidefinite limit, not merely a Hermitian one;
3. be defined on test functions for which `W` is actually defined.

The computed negative corner is a reusable refutation certificate: it is a
single entry, not a spectral computation, so it is easy to check and hard to
argue away.

---

## 6. Repairs, in order of honesty

### R1 — finite Weil Gram matrix on a smooth basis (recommended)

Drop the compression. Choose a finite set of smooth, compactly supported (or
rapidly decaying) test functions `g_1,…,g_m` in the Weil cone, set
`V(g) = W(g * ǧ)` (with `ǧ(u) = conj(g(−u))`), and form the Gram matrix

```
G_{ij} = V(g_i + g_j) − V(g_i) − V(g_j),
```

which is twice the real cross form. Certify `G ⪰ 0` by a rational Cholesky
factor, or refute it by a negative vector. This is the method already proved in
[`prime-spectrum-tensor`](../prime-spectrum-tensor/README.md) T8/T10, and the
prime side is finite for compactly supported `g`. It does not prove RH: a
finite PSD Gram matrix is a rung, not the cone. But it is a real certificate, and
it is the only one currently available. The archimedean enclosure is the
analytic work; `finite-explicit-formula` supplies the prime-side pattern.

This route uses CCM only as motivation. It does not need `D_λ`, the helix, or
Conjecture 1.

A first numerical instance now exists in
[`../prime-spectrum-tensor/WEIL-GRAM.md`](../prime-spectrum-tensor/WEIL-GRAM.md):
a 4×4 Gaussian basis at `σ = 0.05`, with an active prime term, has smallest
eigenvalue `2.271·10^{−2}` and a positive numerical Cholesky factor. It is a
numerical rung, not a certificate; the missing layer is an interval enclosure of
`Ω`, after which the rational shadow can be fed to T8/T10.

### R2 — a genuinely energy-dependent operator

Keep the operator idea, but replace the constant matching by a scattering matrix
`S(E)` derived from a second-order or higher-dimensional point interaction (or
from a boundary triple with a nontrivial spectral parameter). Then the spectral
condition is `det(1 − S(E)e^{iEL}) = 0`, which can have non-lattice zeros. The
tasks are: construct the self-adjoint extension, prove that the determinant's
zeros are the `γ_n`, and identify the spectral measure with `W`. This is a
different and harder construction than the blueprint's; it is not a repair of
the displayed equation.

### R3 — renormalised compression

Subtract the divergent free diagonal:

```
Q^{ren} = Q − ε diag(μ_k) = Q^{δ}.
```

This is positive semidefinite (T10), but it is finite rank, with at most one
rank per prime power. Its spectrum is finite (generically nonzero and not the
zeros). A naive subtraction therefore loses the spectral information. A useful
renormalisation would need an infinite-rank counterterm and a proof that the
renormalised operator is still self-adjoint; none is on the table.

### R4 — return to CCM's actual spectral triple

The CCM scaling operator, not the helix model, is the object the programme
actually wants. The finite CCM matrix `QW` is defined by the Weil form on a
suitable finite-dimensional space; the bridge should prove that this matrix is
the compression of the scaling operator after a specified renormalisation. The
helix is a visualisation of the zeros, not the operator. This is the most
faithful repair, and it makes the L3 identification the primary target rather
than an afterthought.

---

## 7. Revised milestones

| step | content | status |
|---|---|---|
| M0 | explicit compression `Q_{λ,N}`, Hermiticity, diagonal, negative corner | **done; the advertised positive certificate fails** |
| M1 | smooth test basis and finite Weil Gram matrix `G`; rational PSD or negative certificate | next finite step; uses `prime-spectrum-tensor` T8/T10 |
| M2 | prove or refute an operator whose spectral measure is `Σ δ_{γ_n}`; constant matching is excluded by Proposition 1 | open; needs R2 or R4 |
| M3 | identify `W` with the spectral measure (L3) | open, and the actual bridge |
| M4 | uniform control / cone positivity | RH-equivalent; not attempted |

M0 is still worth having: it is a clean, finite refutation of a concrete proposed
certificate, and it prevents the next researcher from spending time on a
spectrum comparison that cannot work.

---

## 8. Ledger additions

| # | Kind | Statement | Lean / test name |
|---|---|---|---|
| T8 | Theorem | The finite CCM compression is Hermitian. | `CCM.ccmMatrix_isHermitian` |
| T9 | Theorem | Its diagonal is `ε μ_k + S/L`. | `CCM.ccmMatrix_diag` |
| T10 | Theorem | The prime/delta part is positive semidefinite for non-negative couplings. | `CCM.deltaForm_nonneg` |
| T11 | Theorem | The product of the matching phases is unitary. | `CCM.matchingProduct_unitary` |
| C9 | Computation | `Q` is Hermitian to `< 10^{−30}`, its corner is negative, and the delta part is PSD to `< 10^{−25}` at `λ=5, N=5` (40 digits). | `test_ccm_compression_is_hermitian_with_negative_corner` |
| C10 | Computation | The smallest eigenvalue is negative and deepens linearly: `−6.8581` at `N=5`, `−16.7031` at `N=10` for `λ=5`. | `test_ccm_compression_is_not_positive_and_corner_scales` |
| C11 | Computation | The constant-matching spectrum is equally spaced, with phase `−1` (antiperiodic) or `+1` (periodic), to `< 10^{−30}`. | `test_uniform_matching_spectrum_is_equally_spaced` |

Run:

```bash
cd the-final-letter/topics/self-adjoint-ccm
python3 -m pytest -q tests
./lean/check.sh
```

The Python suite now has 11 passing tests; the Lean build is recorded in
[`lean/BUILD.log`](lean/BUILD.log).

---

## 9. What would change this verdict

Any one of the following would reopen B4:

1. an energy-dependent matching condition with a proof that the resulting
   self-adjoint operator has spectrum `{γ_n}` (R2), or
2. a renormalised compression with a bounded diagonal and an infinite-rank
   positive limit whose spectral measure is `W` (R3/R4), or
3. a proof that the half-integer modes are being used only as a convenient
   basis, with a separate smoothing argument that puts them in the Weil cone and
   an identification theorem L3.

Absent one of these, the honest summary is:

> The CCM operator is the right *shape* of bridge — self-adjointness manufactures
> positivity, and the primes enter through point interactions. But the operator
> in the blueprint has a lattice spectrum, and its finite compression has a
> negative corner that grows with the band limit. The first concrete M0 target
> is therefore a refutation, not a certificate. The finite way forward is a Weil
> Gram matrix on a smooth test basis; the operator way forward needs a different,
> energy-dependent quantisation.

[Back to the programme](README.md) · [Bridge survey](../../bridge-to-weil-positivity.md) ·
[Topic index](../README.md) · [Scraps](../../scraps.html)
