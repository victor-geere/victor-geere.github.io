# The sub-cone problem

**Status:** research note. It records what is *proved* about the first structural
obstruction to a sub-cone theorem (`lean/SubCone.lean`, T24), what the numerics
say about the obstruction in practice, and what a sub-cone theorem would have to
look like. **No sub-cone theorem is proved here**, and nothing here is a
statement about the infinite Weil cone or a proof of RH.

**Parent dossier:** [`README.md`](README.md) · **Open item:**
[`HANDOFF-M0P-NEXT.md`](HANDOFF-M0P-NEXT.md) §4.3(3) · **Finite ladder:**
[`HANDOFF-M0P-NEXT.md`](HANDOFF-M0P-NEXT.md) §4.4 · **Kernel:**
[`WEIL-GRAM.md`](WEIL-GRAM.md) §2.

## 0. Short answer

The ladder has so far climbed by certifying *more basis elements*. §4.3(3) asks
for the other kind of step: positivity on a structured closed subspace of the
Gaussian Hilbert space, so that the statement is about infinitely many test
functions at once.

Three things are established below.

1. **The pole term is rank two and grows** (T24, `lean/SubCone.lean`). In closed
   form `poleTerm c σ = 4πσ² e^{σ²/4} cosh(c/2)`, so as a quadratic form on a
   finite family of centres it is
   `4πσ²e^{σ²/4} · u · v` with `u = Σ_a x_a e^{c_a/2}`, `v = Σ_a x_a e^{−c_a/2}`.
   It is unbounded in the separation. **Consequently no decay, Hilbert–Schmidt
   or diagonal-dominance argument can be applied to the Weil Gram matrix** — its
   entries grow.
2. **The growth is cancelled by the prime term** (numerics, §2.3). The entry stays
   of order `10⁻²` out to separation `10` because `−prime` tracks `+pole` to
   about one part in `10²`. So the obstruction is *not* the pole on its own: it
   is the residual, which is the zeros' contribution.
3. **All three obvious sub-cones fail, for different reasons.** The symbol/Toeplitz
   cone is positive iff RH (§2.1); the "sparse centres" cone is broken by the pole
   growth (§2.2); and the pole-free subspace of codimension two (§3.3) does not
   help either — annihilating the pole exactly leaves `λ_min` collapsing at the
   same exponential rate as the full Gram matrix (§5.1). The density form is not
   positive definite on it in any case, since its symbol is negative on
   `(0, t₀)`, `t₀ = 6.2898…` (§3.2).

## 1. What a sub-cone theorem would have to be

Let `H` be the complex Hilbert space of test functions for the Weil form and
`Q(f) = W(f ∗ f̌)` the quadratic form, so that `Q(f) = Σ_ρ |f̂(ρ)|²` under RH.
A *sub-cone theorem* would be a triple

* a closed subspace `H₀ ⊂ H`, described **without reference to the zeros**;
* a proof that `Q ≥ 0` on `H₀`;
* `H₀` infinite-dimensional, with the description giving test functions of
  unbounded complexity (otherwise it is just the ladder again).

It must not be vacuous (`H₀ = {0}`), and it must not be equivalent to RH. The
second condition is the hard one, and it is what kills route 2.1.

## 2. The three routes

### 2.1 The symbol / Toeplitz route — equivalent to RH

Take centres on a lattice of spacing `h → 0`. The Gram matrix converges to the
integral operator with kernel `K(a−b)`, i.e. the multiplication operator with
symbol

```
S(ξ) = pole-symbol + σ² e^{−σ²ξ²} Ω(ξ) − (prime symbol).
```

A convolution operator on `L²(ℝ)` is nonnegative iff its symbol is nonnegative
a.e. By the explicit formula the symbol is (up to a positive factor) `Ξ(ξ)`, so

```
Q ≥ 0 on the whole cone  ⟺  S ≥ 0  ⟺  all zeros on the critical line.
```

So the dense-lattice limit is not a sub-cone theorem, it is RH restated. This is
the reason the programme certifies finite bases instead.

### 2.2 The decay / diagonal-dominance route — false, and why (T24)

A tempting structured subspace is "centres separated by more than `L`". It works
only if the kernel decays, so that the matrix is diagonally dominant. It does
not:

```lean
theorem poleTerm_eq (c σ : ℝ) :
    poleTerm c σ = 4 * Real.pi * σ ^ 2 * Real.exp (σ ^ 2 / 4) * Real.cosh (c / 2)
theorem poleTerm_growth (c σ : ℝ) (hσ : 0 < σ) :
    4 * Real.pi * σ ^ 2 * Real.exp (σ ^ 2 / 4) / 2 * Real.exp (c / 2) ≤ poleTerm c σ
theorem poleTerm_unbounded (σ : ℝ) (hσ : 0 < σ) :
    ∀ M : ℝ, ∃ c : ℝ, M ≤ poleTerm c σ
```

and the form is exactly rank two:

```lean
theorem sum_poleTerm_eq (s : Finset ι) (c x : ι → ℝ) (σ : ℝ) :
    ∑ a ∈ s, ∑ b ∈ s, x a * x b * poleTerm (c a - c b) σ
      = 4 * Real.pi * σ ^ 2 * Real.exp (σ ^ 2 / 4) *
        ((∑ a ∈ s, x a * Real.exp (c a / 2)) * (∑ b ∈ s, x b * Real.exp (-(c b) / 2)))
```

Two consequences worth stating plainly:

* the pole form is **indefinite**: `u·v` changes sign with the weights, so a
  centre set containing two points far apart already has a negative direction
  (`u = e^{a/2} − e^{b/2}`, `v = e^{−a/2} − e^{−b/2}`, `uv < 0` for `a ≠ b`);
* any rank-one or Gershgorin argument is therefore unavailable: the matrix is
  dominated by a rank-2, exponentially growing piece.

### 2.3 What actually keeps the kernel small: pole–prime cancellation

The pole grows like `e^{c/2}`, yet the emitted kernel entries stay of order
`10⁻²` (`WEIL-GRAM.md` §0). The reason is that the prime term cancels the pole
almost exactly — the explicit formula in action. Computed at `σ = 1/20` with the
von Mangoldt sum over `n ≤ 4·10⁵`:

| separation `c` | pole | prime | pole + prime | density | entry |
|---:|---:|---:|---:|---:|---:|
| `0` | `0.03144` | `0` | `0.03144` | `0.01170` | `0.043136` |
| `1` | `0.03545` | `−0.02126` | `0.01419` | `−0.01106` | `0.003130` |
| `2` | `0.04851` | `−0.06087` | `−0.01236` | `−0.00589` | `−0.018249` |
| `4` | `0.11827` | `−0.09814` | `0.02013` | `−0.00213` | `0.018002` |
| `6` | `0.31648` | `−0.31872` | `−0.00224` | `−0.00078` | `−0.003023` |
| `8` | `0.85845` | `−0.83158` | `0.02687` | `−0.00029` | `0.026583` |
| `10` | `2.33283` | `−2.36318` | `−0.03035` | `−0.00300` | `−0.033355` |

The residual `pole + prime + density` is what the zeros contribute. So the
statement "the kernel does not decay (T24)" does **not** by itself rule out a
sub-cone; what it rules out is any argument that treats the entries as small with
a *monotone* bound. The residual has no monotone bound available without zero
information — which is the whole difficulty.

## 3. What is proved, and the pole-free subspace

### 3.1 The four theorems

`lean/SubCone.lean`, all audit-clean
(`[propext, Classical.choice, Quot.sound]`): `poleTerm_eq`, `poleTerm_growth`,
`poleTerm_unbounded`, `sum_poleTerm_eq`. See T24.

### 3.2 The density form is not positive definite

The density kernel has symbol `σ² e^{−σ²ξ²} Ω(ξ)`, and `Ω(0) = ψ(1/4) − log π =
−5.37218…`, with first zero at `t₀ = 6.28984…`. A convolution operator whose
symbol is negative on a set of positive measure is not positive definite, so the
density form is negative on some directions — regardless of the basis.

### 3.3 The pole-free subspace is codimension two

By `sum_poleTerm_eq`, the pole part vanishes on `{u = 0}` and on `{v = 0}`; the
intersection has codimension two. There the form is density plus prime:

```lean
theorem sum_poleTerm_eq_zero (s : Finset ι) (c x : ι → ℝ) (σ : ℝ)
    (hu : ∑ a ∈ s, x a * Real.exp (c a / 2) = 0) :
    ∑ a ∈ s, ∑ b ∈ s, x a * x b * poleTerm (c a - c b) σ = 0
```

This is the natural candidate for a *structured* subspace: it is closed, it is
described without zeros, and it is infinite-dimensional. What is missing is a
proof that density + prime `≥ 0` there, and §3.2 says the density half of that is
false in general — the two must cancel, exactly as in the finite certificates.

## 4. The next target, stated precisely

The weakest statement that would count as a first sub-cone theorem:

> **Target.** There exist `T₁ > t₀` and a codimension-two (or larger) closed
> subspace `H₀` of Gaussians whose Fourier support lies in `|ξ| ≥ T₁`, such that
> `Q ≥ 0` on `H₀`, with the proof using only (i) the symbol lower bound
> `σ²e^{−σ²ξ²}Ω(ξ) ≥ c(T₁) > 0` on `|ξ| ≥ T₁`, (ii) the pole rank-two identity
> (T24), and (iii) a truncated von Mangoldt bound `Σ_{p^m ≤ e^Λ}(log p)p^{−m/2} ≤ …`.

The three ingredients are all available or nearly so: (ii) is proved, (iii) is a
finite sieve sum like the ones already used for the prime bands, and (i) needs
two inputs — the digamma asymptotics `Re ψ(1/4 + it/2) = log(t/2) + O(1/t)`,
which gives `Ω(ξ) > 0` for `ξ > t₀` and is **not yet in Lean**, and then a
one-line lower bound on the symbol.  The asymptotics is the real gap on the
analytic side. The obstruction is the *interaction*: band-limiting to `|ξ| ≥ T₁` makes
`f` non-integrable at infinity, so the prime sum `Σ (log p)p^{−m/2} f(log p^m)`
does not truncate; controlling it needs either a smooth window or a compactly
supported `f̂`, and both re-introduce low frequencies.

**This target has since been corrected.**  §5.2 shows that band-limiting cannot
control the pole at all (the pole reads `f̂(±i/2)`), so the two conditions must be
imposed together, `H₀ = {f : f̂(±i/2) = 0, f̂ supported in |ξ| ≥ T₁}`, and §5.1
shows the moment condition alone does not save the margin.  This is the concrete
reason no sub-cone theorem is proved here, and it is the place to start.

## 5. How to falsify the target quickly

Numerically, band-pass a Gaussian at `T₁`, compute `Q` from the three terms, and
check the sign and margin across `T₁`; if the margin is negative for every
`T₁ ≫ t₀`, the target's mechanism (density dominance) is wrong and the residual
must come from a different cancellation. A first check needs only the kernel
already validated in `WEIL-GRAM.md` — the implementation used for the table in
§2.3 reproduces the published `W(σ) = 0.043135958394838` to 15 digits.

### 5.1 The test that was run, and its verdict on the pole-free candidate

The cheapest structured subspace to test is the pole-free one of §3.3, `{u = 0}`,
restricted to the natural ladder of centres `0, 1/5, 2/5, …`.  Take the
`density + prime` kernel (the pole part is annihilated by the constraint) and
compute the smallest eigenvalue on `{u = 0}` for growing `n`:

| `n` | `λ_min` (full Gram) | `λ_min` on `{u = 0}` |
|---:|---:|---:|
| 6 | `1.671·10⁻²` | `1.693·10⁻²` |
| 10 | `6.600·10⁻⁴` | `1.397·10⁻³` |
| 14 | `1.955·10⁻⁴` | `2.102·10⁻⁴` |
| 20 | `3.549·10⁻⁵` | `3.561·10⁻⁵` |
| 26 | `1.632·10⁻⁶` | `1.905·10⁻⁶` |
| 34 | `1.419·10⁻⁸` | `1.439·10⁻⁸` |

**The pole-free subspace does not rescue the margin.**  Removing the pole
identically (not approximately — exactly) leaves `λ_min` collapsing at the same
rate as the full matrix: a factor `10³` between `n = 6` and `n = 20`, and `10¹⁰`
by `n = 34`.  So the codimension-two candidate of §3.3 is *numerically dead* for
the natural ladder: whatever is driving the collapse, it is not the pole.

That kills the simplest sub-cone, and it sharpens the question: the collapse must
come from the `density + prime` residual, i.e. from the zeros, exactly as §2.3
suggested.  A surviving sub-cone therefore has to control the residual, and no
known real-frequency or moment condition does that without zero information.

### 5.2 The obstacle the band-pass target under-estimates

There is a second, sharper reason the §4 target as stated cannot work.  The pole
term evaluates the test function at the *imaginary* frequencies `ξ = ±i/2`:

```
pole part of Q(f) = f̂(i/2) f̂(−i/2) = 2 |f̂(i/2)|².
```

A subspace defined by a condition on the *real*-frequency support (band-limiting,
which is multiplication by `1_{|ξ| ≥ T₁}` on the real line) says nothing about
`f̂(i/2)`: the indicator has no analytic continuation.  So band-limiting cannot
control the pole, and band-limiting plus the *moment* condition is the only
combination that can:

```
H₀ = { f : f̂(i/2) = f̂(−i/2) = 0  and  f̂ supported in |ξ| ≥ T₁ }.
```

On `H₀` the pole vanishes *and* the density symbol is positive.  What remains is
the prime side, which band-limiting does not truncate (the prime sum samples `f`
at `log p^m`, and a band-passed `f` is not small there).  That is the precise
form of the open problem, and it is where the next attempt should start.

## 6. What this note is not

It is not a sub-cone theorem, not a statement about the infinite Weil cone, not a
proof of RH, and not a claim that no route can succeed. It is the structural floor
that any attempt starts from: two obstructions proved (T24), one measured (§2.3),
one candidate ruled out numerically (§5.1), and one target corrected before it
was chased (§5.2).
