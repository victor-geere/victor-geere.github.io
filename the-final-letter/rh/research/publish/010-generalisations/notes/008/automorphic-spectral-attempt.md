# Attempting an automorphic/spectral input for the twin-prime parity problem

**Package** `research/twin-prime-parity/008/`
**Route** dictionary `03` §5.4, item 3 ("Automorphic / spectral input"), applied to the
shift-2 Liouville correlation `S(x) = Σ_{n≤x} λ(n)λ(n+2)`.

**Status** the input is located exactly, machine-checked at the arithmetic core,
exhibited in the setting where it is *known to work* (function fields), and shown
over ℚ to be blocked at the same parity barrier — now localised to two named gaps.
Nothing here proves `S(x) = o(x)` or the twin prime conjecture.

---

## 0. Verdict in one paragraph

The automorphic/spectral input is **not a hypothetical**: over `𝔽_q[T]` the
analogous parity barrier *is* broken, by geometric methods (Sawin–Shusterman,
[arXiv:1808.04001](https://arxiv.org/abs/1808.04001),
[arXiv:2008.09905](https://arxiv.org/abs/2008.09905)). The engine there is a
**trace function / ℓ-adic sheaf** attached to the Möbius function, plus
**Deligne's square-root cancellation**, plus a genuinely geometric ability to
**"mimic the Möbius function by Dirichlet characters on special subspaces"**.
Over ℚ the sequence has **no attached automorphic object at all**
(`L(s, λ) = ζ(2s)/ζ(s)` is a ratio of ζ, with no Hecke eigenvalues and no
monodromy), and every sign that the number-field spectral toolkit can detect is a
**Dirichlet character**, i.e. periodic in `n mod q`, hence parity-blind. The
attempt therefore **fails over ℚ**, and the failure is no longer a vague "parity
barrier": it is the absence of (i) a spectral/sheaf object for `λ` and (ii) a
non-periodic parity-breaking sign. The one genuinely new piece of arithmetic
geography produced here is that the whole open content of `S(x) = o(x)` is a sum
of `λ` over a **quadratic polynomial**, `Σ_{k≤K} λ(4k²−1)` — exactly the shape
both the function-field and the number-field spectral methods attack.

---

## 1. The reduction: the open core is a quadratic-polynomial sum

Writing (as in the shift-2 audit) `S_h(x) = Σ_{n≤x} λ(n)λ(n+h)`, and using only
**complete multiplicativity** of `λ` (valid for all `m, n`, no coprimality):

```
(R1)   S_2(x) = S_1(⌊x/2⌋) + C(⌊(x+1)/2⌋) ,        S_1(y) = Σ_{m≤y} λ(m)λ(m+1)
(R2)   C(K)   = Σ_{k≤K} λ(4k² − 1)
(R3)   λ((2k−1)(2k+1)) = λ(2k−1) λ(2k+1)
```

`(R1)` splits the even part (`λ(2m)λ(2m+2) = λ(m)λ(m+1)`, since `λ(2)² = 1`) from
the odd part; `(R3)` is complete multiplicativity; `(R2)` is `(2k−1)(2k+1) = 4k²−1`.

**Machine-checked** (`lean/Op58`): `liouville_mul`, `even_shift`,
`sum_range_even_odd`, `Ccore_eq_poly`, **`Sh2_split`** — all `0 sorry`, `0 axiom`,
footprint `propext, Classical.choice, Quot.sound`.

**Verified numerically with discrepancy exactly 0** (`verify/01_reduction.py`,
sieve to `2·10⁶`):

| x | `S_2(x)` | `S_1(⌊x/2⌋)` | `C(⌊(x+1)/2⌋)` | diff |
|---|---|---|---|---|
| 10³ | −30 | 12 | −42 | **0** |
| 10⁴ | 12 | 72 | −60 | **0** |
| 10⁵ | 258 | 146 | 112 | **0** |
| 10⁶ | 68 | 36 | 32 | **0** |
| 1999998 | −940 | −1109 | 169 | **0** |

The point of `(R2)` is that it **removes the "no Euler product" obstruction**
(dictionary F3/F8) as an excuse: although `n ↦ λ(n)λ(n+2)` is not multiplicative,
the open core is a sum of the multiplicative `λ` over the quadratic polynomial
`k² − 1`. Sums `Σ μ(f(n))`, `Σ λ(f(n))` for quadratic `f` are *the* classical
targets of spectral methods, over both ℚ and `𝔽_q[T]`.

---

## 2. What the automorphic/spectral input has to supply

Abstracting the two known realisations (Friedlander–Iwaniec over ℚ;
Sawin–Shusterman over `𝔽_q[T]`), a parity-breaking automorphic/spectral input has
three components:

**(S1) A spectral/geometric object attached to the sequence.**
Over ℚ: an automorphic form whose Hecke eigenvalues are the sequence
(e.g. `x²+y⁴ = N(x+iy²)` in ℚ(i), giving a weight-1 Eisenstein series and its
Grössencharacter — dictionary T14/T15).
Over `𝔽_q[T]`: a **trace function**, i.e. the trace of Frobenius on an ℓ-adic
sheaf, attached to the Möbius function (Sawin–Shusterman 2008.09905).

**(S2) Square-root cancellation for that object.**
Over ℚ: spectral equidistribution / Kuznetsov–Petersson (the Hecke eigenvalue
input).
Over `𝔽_q[T]`: **Deligne's Weil II bound** — the function-field Riemann
hypothesis. This is the cleanest form of the input, and `verify/03_function_field.py`
exhibits it exactly:

| `p` | `max\|K(a,b)\|` (Kloosterman) | `2√p` | `max\|Gauss\|` | `√p` |
|---|---|---|---|---|
| 101 | 19.287313 | 20.099751 | 10.049876 | 10.049876 |
| 211 | 28.976853 | 29.051678 | 14.525839 | 14.525839 |
| 1009 | 62.114892 | 63.529521 | 31.764760 | 31.764760 |

Kloosterman sums obey the Weil bound and Gauss sums are exactly `√p`. **There is
no such statement for `Σ_{n≤x} λ(n)` over ℚ**; its square-root cancellation would
already be a RH-strength input.

**(S3) A parity-breaking sign, invisible to the sieve.**
This is the decisive component, and the one with no number-field realisation.
Over `𝔽_q[T]`, Sawin–Shusterman prove that *"when restricted to certain special
subspaces, the Möbius function over `𝔽_q[T]` can be mimicked by Dirichlet
characters"* (their abstract, verbatim). Over ℚ, the only completely
multiplicative signs that any `L`-function detects are **Dirichlet characters**,
which are periodic modulo `q` and therefore parity-blind (dictionary Theorem 2.2);
the index-parity instance is even *identically* invisible to the shift-2
correlation (dictionary Theorem 5.5). A sign that is not periodic is exactly what
the bounded-depth class cannot use (dictionary Definition 1.11 / Theorem 2.1), and
no such sign is known to exist for `λ`.

---

## 3. The input is realised over `𝔽_q[T]` (it is not hypothetical)

Sawin–Shusterman, *On the Chowla and twin primes conjectures over `𝔽_q[T]`*
([arXiv:1808.04001](https://arxiv.org/abs/1808.04001)): using geometric methods
(trace functions, a function-field Burgess bound, and the character-mimicking of
`μ`), they obtain a **level of distribution close to 1** for `μ` in arithmetic
progressions, **resolve Chowla's `k`-point correlation conjecture** with large
uniformity in the shifts, and **establish the twin prime conjecture in
quantitative form** over `𝔽_q[T]`. The companion paper
([arXiv:2008.09905](https://arxiv.org/abs/2008.09905)) resolves the `𝔽_q[u]`-analog
of Chowla's conjecture on **Möbius sums over polynomial sequences** and of
Bateman–Horn in degree 2, via cancellation in short sums of trace functions.

`verify/03_function_field.py` exhibits the consequences numerically. For `𝔽_q[T]`,
with `Ch(n) = Σ_{deg f = n} μ(f)μ(f+1)` and `Tw(n) = #{f : f, f+1 both irreducible}`:

| q, n | `q^n` | `#irred` | `Ch(n)` | `\|Ch\|/q^n` | `Tw(n)` | `q^n/n²` |
|---|---|---|---|---|---|---|
| 3, 8 | 6561 | 810 | −30 | 0.0046 | 36 | 102.5 |
| 5, 4 | 625 | 150 | −20 | 0.0320 | 25 | 39.1 |
| 5, 5 | 3125 | 624 | 24 | 0.0077 | 98 | 125.0 |

The Chowla correlation cancels (`|Ch|/q^n → 0`) and twin irreducibles exist at the
Bateman–Horn scale — both **theorems** there. Over ℚ the analogous statements
(`Σ_{n≤x} λ(n)λ(n+1) = o(x)`, twin primes) are **open** (Matomäki–Radziwiłł give
only `≤ 1−δ`; dictionary T5, shift-2 audit).

*Char-2 caveat, recorded honestly.* Over `𝔽_2` the shift `f ↦ f+1` is degenerate
(every irreducible of degree `≥ 2` has nonzero constant term, so `f+1` is
divisible by `T`), and `Tw(n) = 0` for all `n` — the script shows this. This is a
concrete instance of the "simple condition on the finite field" in the
Sawin–Shusterman abstract.

---

## 4. Why it does not transfer to ℚ

**(O1) No spectral object.** `L(s, λ) = ζ(2s)/ζ(s)` is a ratio of `ζ`. `λ` is not
the sequence of Hecke eigenvalues of any cusp form or Eisenstein series in a way
that supports a Kusnetsov/Petersson bilinear input; the toy `x²+y⁴` works because
the polynomial *factors in ℚ(i)* and the representation numbers are Fourier
coefficients of an Eisenstein series with an explicit Grössencharacter. The
polynomial `k² − 1` factors only over ℤ, giving no new field, no Hecke character,
no sheaf.

**(O2) The number-field spectral toolkit is parity-blind here.** Dictionary `04`
§6: every `ζ`-based structure in the programme (budgets, Brown completeness, the
balance split, smoothing, the explicit formula) is *"either sign-blind (index
parity) or additive in `log n`"*. The explicit formula sees `Λ(n)`, i.e. prime
powers, through zeros of `ζ` — an additive (in `log n`) object. A Dirichlet
character twist is periodic. Neither detects Ω-parity at positive density.

**(O3) The function-field engine has no number-field counterpart.** The
Sawin–Shusterman proof uses that the relevant cohomology is **finite-dimensional
over a finite field**, so the Frobenius eigenvalues are algebraic integers of
bounded modulus (Weil II) and the ℓ-adic monodromy group is a *geometric* object.
Over ℚ there is no Frobenius, no monodromy group for `μ`, and no
finite-dimensionality to exploit.

**(O4) The missing quantitative input, measured.** The linear (twin-prime) sieve
needs a level of distribution `θ > 1/2`. `verify/02_level_and_growth.py`
(`x = 10⁶`, `M(x;q) = max_a |Σ_{n≤x, n≡a (q)} λ(n)|`) shows the crossover exactly
at `q ≈ x^{1/2}`:

| q | q/√x | `M(x;q)` | trivial `x/q` | `M/(x/q)` |
|---|---|---|---|---|
| 2 | 0.00 | 916 | 500000 | 0.0018 |
| 100 | 0.10 | 274 | 10000 | 0.0274 |
| 1000 | 1.00 | 106 | 1000 | 0.1060 |
| 5000 | 5.00 | 56 | 200 | 0.2800 |
| 50000 | 50.00 | 18 | 20 | 0.9000 |

Cancellation is excellent for `q ≪ √x` and disappears for `q ≫ √x`: the empirical
level of distribution is `1/2`, exactly the barrier. (A finite range proves nothing
— dictionary F4, finite-prefix indeterminacy — but it locates the wall.)

**(O5) The quadratic-polynomial Mertens function cancels surprisingly well.**
`C(K) = Σ_{k≤K} λ(4k²−1)` (`verify/02`, section A):

| K | `C(K)` | `max\|C\|` on `[1,K]` | `max\|C\|/√K` |
|---|---|---|---|
| 10³ | −42 | 61 | 1.93 |
| 10⁴ | −6 | 98 | 0.98 |
| 10⁵ | 366 | 369 | 1.17 |
| 10⁶ | 32 | 488 | 0.49 |

The numerical shape is `O(√K)` or better, i.e. square-root cancellation — the same
phenomenon the function-field proof *theorems*. Over ℚ this is unproved (it would
give `C = o(K)` and hence `S_2 = o(x)`). It is the sharpest available numerical
target for the spectral route: **the automorphic/spectral input over ℚ must
explain square-root cancellation in `Σ_{k≤K} λ(k²−1)`.**

---

## 5. The conditional transfer statement

The attempt can be stated as a precise implication. Let

> **(H_θ)** (level of distribution for λ) `Σ_{q ≤ x^θ} max_{a mod q} |Σ_{n≤x, n≡a (q)} λ(n)| ≪_A x (log x)^{-A}` for some `θ > 1/2`.

(A hypothesis of the same strength, and *equivalent for the purpose of the
conclusion* by `(R1)`, is the pair of statements `C(K) = o(K)` and
`S_1(y) = o(y)`. The equivalence of the *conclusions* is a theorem; the
equivalence of these two *hypotheses* is not claimed.)

Then the standard linear-sieve argument (dictionary T8/T13; Sawin–Shusterman's
function-field analogue) gives `S_2(x) = o(x)` and a positive lower bound for twin
primes. **`(H_θ)` for any `θ > 1/2` is open over ℚ**, and:
- `(H_θ)` is *attainable* over `𝔽_q[T]` (Sawin–Shusterman, geometric input);
- over ℚ, the only mechanisms that supply `(H_θ)` are Type-II/bilinear
  (Friedlander–Iwaniec asymptotic sieve) or equidistribution to large moduli
  (Bombieri–Friedlander–Iwaniec), i.e. route 1 or 2 of dictionary §5.4 — not
  route 3 in isolation;
- the number-field "spectral" structures available for `λ` are parity-blind
  (O2), and the parity-breaking sign (S3) is exactly what has no ℚ-analogue (O3).

So the honest outcome of the attempt: **route 3 reduces to routes 1–2 over ℚ.** The
automorphic/spectral language does not add a new input for the pair `(n, n+2)`; it
*identifies* the input (a trace/sheaf object with square-root cancellation and a
non-periodic sign) and shows that over ℚ that object is absent.

---

## 6. Status table

| item | status |
|---|---|
| `(R1) S_2 = S_1(⌊x/2⌋) + C(⌊(x+1)/2⌋)` | **PROVED** (Lean `Op58.Sh2_split`), numerical diff 0 |
| `(R2) C(K) = Σ λ(4k²−1)`, `(R3)` complete multiplicativity | **PROVED** (Lean `Op58.Ccore_eq_poly`, `liouville_mul`) |
| Weil/Deligne square-root cancellation over `𝔽_p` | **VERIFIED** numerically (exact) |
| `𝔽_q[T]`: Chowla cancellation, twin irreducibles | **THEOREM** (Sawin–Shusterman, cited) + **VERIFIED** numerically |
| no automorphic object for `λ` over ℚ | **STRUCTURAL** (O1), no proof attempted |
| number-field spectral toolkit is parity-blind | **THEOREM** (dictionary 04 §6, 03 Thm 2.2), cited |
| level of distribution `≈ 1/2` for `λ` over ℚ | **NUMERICAL** (crossover at `q ≈ √x`) |
| `C(K) = O(√K)` numerically | **NUMERICAL**; `o(K)` **OPEN** |
| transfer `(H_θ) ⟹ S_2 = o(x)` | **CONDITIONAL** (standard linear sieve, cited) |
| breaking the barrier over ℚ | **NOT ACHIEVED** |

---

## 7. Citations

Verified in this round (abstracts read):
- W. Sawin, M. Shusterman, *On the Chowla and twin primes conjectures over
  `𝔽_q[T]`*, [arXiv:1808.04001](https://arxiv.org/abs/1808.04001) — geometric
  methods; `μ` "mimicked by Dirichlet characters" on special subspaces; level of
  distribution near 1; Chowla `k`-point and quantitative twin primes over
  `𝔽_q[T]`.
- W. Sawin, M. Shusterman, *Möbius cancellation on polynomial sequences and the
  quadratic Bateman–Horn conjecture over function fields*,
  [arXiv:2008.09905](https://arxiv.org/abs/2008.09905) — short sums of trace
  functions; `𝔽_q[u]`-Chowla over polynomial sequences; degree-2 Bateman–Horn.

From the programme's verified ledger (dictionary `03`): Friedlander–Iwaniec
`X²+Y⁴` (T14) and the asymptotic sieve (T15); Polymath8b parity ceiling (T8);
Matomäki–Radziwiłł (T5); Tao–Teräväinen structure/pretentiousness (T6, T7, T13).
Classical and not re-verified here: W. Duke, J. Friedlander, H. Iwaniec,
*Equidistribution of roots of a quadratic congruence to prime moduli*, Ann. of
Math. (2) **141** (1995) 423–441 — **unverified citation**, recorded as the
number-field prototype of the spectral method for quadratic-polynomial sums.
