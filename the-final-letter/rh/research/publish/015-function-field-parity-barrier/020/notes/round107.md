# Round 107 — the envisioned path, and wild guess 48

*Written before any computation of this round.*

Round 107 opens phase 020. The 018 programme established the barrier; 019 sharpened and certified one step of
the last identity. Phase 020 asks a different question: **can the function-field zeta, read through degree
windows, supply the bilinear information that the parity theorem says the linear statistics lack?**

---

## 1. The envisioned path, from first principles

### 1.1 What is actually being counted

Twin primes over `𝔽_q[x]` are pairs `(f, f+2)` with both `f` and `f+2` monic irreducible. The temptation is to
call this a "point count on a variety". It is not: the pair `(f, f+2)` is a point of the line
`y = x + 2` for **every** `f`, and irreducibility is a condition on the *factorisation* of `f`, not a geometric
condition on `y = x+2`. Any approach that starts from a variety has already lost the question.

So the object to control is the **irreducible indicator**

```
1_Irr(f) = 1  if f is monic irreducible, 0 otherwise,
```

and the twin count is its correlation `Σ_{deg f = n} 1_Irr(f)·1_Irr(f+2)`.

### 1.2 Why the indicator cannot be a finite divisor sum — and what that leaves

The 018 parity theorem says: every bounded-support divisor sum is periodic, and the twin indicator is not. Hence
no expression of the form `1_Irr(f) = Σ_{d|f, d∈S} g(d)` with `S` finite can exist. **The support must grow
with the degree.** This is not an obstacle to be avoided; it is the specification of the only possible route.

The natural growing-support expression is the **Legendre sieve over small primes**. Let `P_y` be the product of
all monic irreducibles of degree `≤ y`, and put

```
S_y(f) := Σ_{d | gcd(f, P_y)} μ(d)      (μ the Möbius function on 𝔽_q[x]).
```

Then `S_y(f) = 1` exactly when `f` has no monic irreducible factor of degree in `[1, y]`, and `0` otherwise — it
is a genuine 0/1 indicator. For `deg f = n ≥ 2`, every reducible `f` has a factor of degree `≤ n/2`, so with
`y = n/2`:

```
S_{n/2}(f) = 1  ⟺  f is irreducible.
```

The correction matters: a sum over divisors of *bounded degree*, `Σ_{deg d ≤ y} μ(d)`, is **not** an indicator
(it is an inclusion–exclusion that does not close). What closes is the sum over divisors of `P_y`, whose support
grows like `y·π(y)` in degree. This is the precise sense in which the parity theorem leaves room: the support
must grow, and the Legendre sieve is the canonical growing-support object.

**Where the degree grading enters.** Over `ℤ` there is no canonical `y`: the hyperbola method has to choose
`√X` and the two regions are symmetric, which is exactly where the parity barrier bites. Over `𝔽_q[x]` the two
regions are `deg d ≤ n/2` and `deg e ≤ n/2`, and the split is canonical because the degree is an integer
statistic of the ring. This is the whole difference, and phase 020 is about exploiting it.

### 1.3 The twin sum as a finite Euler-type sum

At `y = n/2` the identity is exact, `T(n) = Σ_{deg f = n} S_y(f)·S_y(f+2)`. Expanding the two sums,

```
T(n) = Σ_{d, e | P_y} μ(d)μ(e) · #{f : deg f = n, d | f, e | f+2}.
```

By CRT, `#{f : deg f = n, d|f, e|f+2} = q^{n − deg d − deg e}` when `gcd(d,e) = 1`, and there are **no**
solutions when `gcd(d,e) ≠ 1` (the system would force `g | 2` for a nonconstant `g`). So the truncated sum is

```
T_y(n) = q^n · Σ_{gcd(d,e)=1, deg d, deg e ≤ y, deg d + deg e ≤ n} μ(d)μ(e) q^{−(deg d + deg e)},
```

a finite, computable object: a two-variable Euler product truncated by degree. The singular series `S(q)` is its
`y, n → ∞` limit. Everything in this formula is *linear data plus the grading* — no 2D equidistribution yet.

### 1.4 The window

Sum over a degree window `[n, n+L]` and exchange the order of summation. The main term is the Euler product;
the boundary is the set of pairs with `deg d + deg e` close to `n`. That boundary is exactly the bilinear
regime, and the programme's hope is that the boundary — not the main term — is where the 2D structure (Weil
bounds for the pair correlation, i.e. Frobenius eigenvalues of the pair variety) is needed and available.

**The honest reading of the vision.** The window does not *create* information. It organises the hyperbola by
degree. Therefore it can prove the function-field statement — where the grading exists — and it cannot, by
itself, transfer to `ℤ`, where the substitute for the grading is missing. What it *can* do is locate the
obstruction sharply enough that the missing ingredient over `ℤ` becomes a well-posed demand rather than a slogan.
That is the target of phase 020, and it is a legitimate one: a proof of the function-field twin asymptotic that
does **not** use Chebotarev would be new mathematics, and its failure mode would be a precise statement about the
barrier.

### 1.5 The five steps, summarised

1. Replace the geometric picture by the arithmetic indicator `1_Irr`.
2. Replace `1_Irr` by the degree-graded Möbius sieve `S_y` — the only route the parity theorem leaves open.
3. Expand the twin correlation into the coprime pair sum `T_y(n)`; this is exact for `y ≥ n/2` and an average
   before that.
4. Window the degree to separate the Euler-product main term from the bilinear boundary.
5. Read the boundary with 2D data (Frobenius of the pair), and measure how much of the count the boundary
   actually carries.

---

## 2. Wild guess 48

> **Wild guess 48.** The twin-qrime sequence `T_q(n)` is **spectral**: its ordinary generating function
> `Σ_n T_q(n) t^n` is rational, equivalently `T_q(n)` satisfies a linear recurrence with constant coefficients,
> equivalently `T_q(n) = Σ_i P_i(n) λ_i^n` for finitely many algebraic `λ_i` (the Frobenius eigenvalues of a
> 2D object attached to the pair).

**Why guess it.** Every error term the programme has met is a `q^{n/2}` oscillation (Weil), and every point
count on a variety has exactly this shape. If `T_q(n)` were spectral, three things would follow at once:

* the window method reduces to eigen-decomposition — the barrier would be crossed in the function-field model;
* the "missing non-periodic weight" of Target C acquires an explicit candidate, namely the eigenmeasure;
* the singular series would be the `λ = q` term of the spectrum, and the parity barrier would be the statement
  that the eigenmeasure is not a divisor sum.

**Falsification test.** Compute `T_q(n)` for `q = 3, 5, 7` over the largest range the segmented counter can
reach, and run Berlekamp–Massey on the integer sequence. A short recurrence that predicts held-out terms
confirms the guess; a linear complexity growing like `n/2` kills it.

**Why it is a wild guess.** `T` is a correlation of two indicators, not a point count; correlations of
multiplicative conditions are not obviously spectral, and there is no variety whose zeta has `T` as its
coefficient sequence.

---

## 3. The established path for this round

1. Build the segmented counter: enumerate monic `f` of degree `n` by base-`q` index, test irreducibility of `f`
   and of `f+2`, and validate `T_q(n)` against the 018 table (`q=3: n=3,5,9; q=5: n=3,5; q=7: n=2,3,5`).
2. Compute the window sums `W_q(N) = Σ_{n≤N} T_q(n)` and the normalised defect
   `D_q(n) = n² T_q(n)/q^n − S(q)`; check its growth against the `q^{−n/2}` prediction.
3. Implement `T_y(n)`, the truncated coprime-pair sieve, and measure `T_y(n)/T(n)` as `y` runs from `0` to
   `n/2`: this is the first direct measurement of how much of the twin count the small-divisor stratum carries.
4. Wild guess 48: Berlekamp–Massey on `T_q(n)`.

Results and verdict follow in §4.

---

## 4. Results and verdict

### 4.1 The counter works

All eight oracle values from the 018 table are reproduced exactly:
`T(3;3)=1`, `T(3;5)=6`, `T(3;9)=105`, `T(5;3)=10`, `T(5;5)=98`, `T(7;2)=7`, `T(7;3)=35`, `T(7;5)=560`.
The segmented counter (`lib/qrime_window.py`) enumerates monic polynomials by base-`q` index and tests
irreducibility of `f` and `f+2`; the whole of the table is now a unit test.

The sequences themselves:

```
q=3:  T(1..12) = 3, 0, 1, 0, 6, 6, 15, 36, 105, 216, 585, 1506
q=5:  T(1..8)  = 5, 0, 10, 20, 98, 240, 1140, 4500
q=7:  T(1..6)  = 7, 7, 35, 112, 560, 2667
```

### 4.2 Wild guess 48 is refuted

Fit a linear recurrence to the first half of each sequence (Berlekamp–Massey over `ℚ`) and ask whether it
predicts the held-out half.

| `q` | fit on first | linear complexity | predicts held-out terms |
|---|---|---|---|
| 3 | 6 of 12 | 3 | **no** |
| 5 | 4 of 8 | 2 | **no** |
| 7 | 3 of 6 | 2 | **no** |

Fitting the whole sequence raises the complexity with the length (3 at `n=6`, 6 at `n=12`), which is the
signature of a sequence that is *not* eventually a finite exponential sum. So `T_q(n)` is **not spectral** in
the sense of wild guess 48.

This is a useful negative result. It says the twin-qrime count is not the trace sequence of a single variety:
there is no finite set of Frobenius eigenvalues whose powers give `T_q(n)`. The object that a zeta-based method
must control therefore has **infinitely many** eigenvalues — i.e. it is a genuine `L`-function with infinitely
many zeros, not a rational generating function. Any "window" method has to live with an infinite spectrum, which
is exactly the content of an explicit formula, and it rules out the eigen-decomposition shortcut that motivated
the guess.

### 4.3 The sieve expansion does not yet reproduce the count

The pointwise identity of §1.2 is correct and verified: at `y = n/2` the Legendre indicator equals
irreducibility for every `f` tested (`q = 3,5`, `n ≤ 5`), and the twin count computed from it equals the
brute-force count.

The **expansion** into coprime pairs does not. The two sides are required by linearity to agree, and they do not:

| `q, n` | pointwise count | brute force | coprime-pair expansion |
|---|---|---|---|
| 3, 4 | 0 | 0 | −3 |
| 3, 5 | 6 | 6 | −33 |
| 3, 6 | 6 | 6 | −155 |
| 5, 5 | 98 | 98 | −557 |

Each individual `#{f : d|f, e|f+2}` was checked against `q^{n−deg d−deg e}` for coprime `d,e` and matches; the
truncation and the Möbius signs were checked. So the discrepancy is a genuine (small) bug in the expansion as
implemented, *not* a mathematical obstruction — linearity is not in doubt. `sieve_twin_count` and `strata` are
marked **UNVERIFIED** in the library and are the first item of round 108.

Honest reading: the round produced a working counter, a refuted wild guess, a verified pointwise identity, and
one open bug. It did not yet produce a window measurement, because the window measurement rests on the expansion
that is currently wrong.

### 4.4 Lean

`lean/LocalDensity.lean` proves the local-factor count for the pair `(f, f+h)`:

```lean
theorem LocalDensity.card_avoid_two {F : Type*} [Field F] [Fintype F] [DecidableEq F]
    {h : F} (hh : h ≠ 0) :
    (univ.filter (fun a : F => a ≠ 0 ∧ a + h ≠ 0)).card = Fintype.card F - 2
```

i.e. at a prime of norm `Q` the density of residues avoiding both `0` and `−h` is `(Q−2)/Q`, which is the local
factor `(1−2/Q)` of the singular series. Axioms: the standard three (`Verify.lean`).

### 4.5 Next round (108)

1. Find the expansion bug — with the pair-by-pair trace as the test (O3).
2. Once exact, compute the stratum decomposition and the window sums `W_q(N)` (O1).
3. Measure the defect `n²T(n)/q^n − S(q)` and compare its growth with `q^{−n/2}` (O1).
4. Decide whether the boundary stratum needs 2D input, and state the transfer demand (O5).
