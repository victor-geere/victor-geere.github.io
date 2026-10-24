# Phase B — transfer to zeta space: the no-go, and exactly how strong it is

Script: [`phaseB_transfer.py`](phaseB_transfer.py). Adjudicated with the two blind advisors
([`debate.md`](debate.md)).

Question: is there **any** legitimate operation carrying `D(s) = Σ_j s_j^{−s}` (or the
digit-map structure) into ζ's zeros? Verdict: **no for every operation that preserves
`Z(D)`, and the surviving gap is narrower than I first stated.**

## B.1 A theorem: no meromorphic factorisation

> **Theorem.** Let `g` be meromorphic and `≢ 0`. If `g·D(as+b)` had a meromorphic
> continuation across `Re s = 0`, then `D = (g·D(as+b))/(g(as+b))` would too. But `D` has a
> **natural boundary** at `Re s = 0` (Fabry's gap theorem: `λ_j = log s_j`, `λ_j/j → ∞`).
> Since `ζ` is meromorphic on all of `ℂ` and `D` is not, `ζ ≠ g·D(as+b)` for every affine
> map and every non-zero meromorphic `g`.

This kills the "exotic factorisation" route for meromorphic `Φ`. Note the correct input is
Fabry's gap theorem, **not** "the series diverges on the line" — the latter is a
non-sequitur (the alternating series diverges on `Re s = 0` and continues to `(1−2^{1−s})ζ`).

Independently, `Z(D) ⊄ Z(ζ)`: `D` has explicit off-strip zeros (e.g.
`0.954407453375382 + 7.544937313196741i`), while every ζ zero with `|Im s| ≤ 40` is simple
and on `Re s = 1/2` (van de Lune–te Riele, Platt). So no relation of the form `ζ = gD` can
hold where `g` is holomorphic.

**What survives:** only transfers that **do not preserve `Z(D)`** — multi-step or limit
constructions, of which every Euler product is one. See B.4.

## B.2 Dirichlet convolution is vacuous

`D = ζ * g` is **always solvable** (`g = D·μ`; e.g. `g(1)=0, g(2)=1, g(3)=1, g(4)=−1, …`),
so "write `D` in terms of `ζ`" carries no information: it can be done for any Dirichlet
series. Likewise `ζ = D * h` is a restatement, not a transfer, absent a zero-free `h`.

## B.3 The digit-correlation expansion: correct for cos, impossible for sin, and divergent

Expanding the exact product `P_n = Π_k (1 + δ_k(θ_n)(e^{iα_k}−1))` and separating the
`n`-dependent from the `k`-dependent parts:

```
Re η = Σ_S Re(c_S) · W_S ,   c_S = Π_{k∈S}(e^{iα_k} − 1)  (n-independent),
                             W_S = Σ_n (−1)^{n−1} n^{−σ} Π_{k∈S} δ_k(θ_n) .
```

This is the exact "split cos into greedy harmonic fractions" the programme asked for, and it
**does** separate for the cosine series. Two obstructions:

1. **Not absolutely convergent.** `Σ_{|S|max≤M} |c_S| = 2.41, 4.83, 8.52, 13.79, …, 264.66`
   for `M = 0…14`, growing like `Π_k(1 + π/(k+2)) ~ M^π`. Numerically the partial sums do not
   converge: at `s = 0.5 + 14.13i`, `N = 300`, they read `+0.0133, −0.1072, −0.0658,
   −0.1195, −0.0461, −0.1673, −0.0766` for `M = 2,4,…,14` against a true `Re η = −0.0146938`.
2. **The sine series does not separate at all.** `Im η = −Σ_n (−1)^{n−1}n^{−σ} ε_n Im P_n`,
   and the fold sign `ε_n` is **not a function of the word** `A_n`: among `n ≤ 399`, 27 of
   183 words (first two digits) are realised with *both* signs. So `ε_n` is extra data and the
   imaginary part does not factor into (word-only) × (`n`-only) pieces.

Both are fatal to the expansion as a computational route, and item 2 is a structural
statement, not a numerical accident.

## B.4 Statistics of the support: approximately `t`-free, with an unexplained tilt

An advisor's provable-core claim was that any statistic of the supports *alone* is an
empirical-measure functional of `θ_n`, which equidistributes to Lebesgue independently of
`t`, hence `t`-free. The other advisor **refuted the uniformity**: KS(empirical `θ/π` vs
Lebesgue) `= 0.0459 (t=14.13), 0.0258 (30), 0.0045 (100), 0.0006 (1000) ≈ 0.6/t`, i.e. `65×`
the sampling floor at `γ₁`.

My own check: unfolded-phase KS `= 0.0197 (t=14.13), 0.0162 (21.02), 0.0040 (100)` at
`N = 2·10⁵` — same direction, same decay in `t`. **Honest statement:** support-only
statistics are approximately `t`-free with a smooth `O(1/t)` tilt, and the tilt is not
understood. So the no-go for support statistics is *empirical*, not provable.

Net: the digit map discards exactly the pairing with `n` — and that pairing is where the
zero information lives. Supports alone lose it; supports **plus** pairing is literally `η`.

## B.4b Precision on the domain of `D` (added in [`salvage.md`](salvage.md) §3)

`D(s) = Σ_j s_j^{−s}` is **analytic on `Re s > 0` with a natural boundary at `Re s = 0`** —
it is *not* entire (an entire function has no boundary). The abscissa of convergence is `0`:
`s_j^{−σ} → 0` for every `σ > 0`, and the terms grow for `σ < 0`. Fabry's gap theorem
(`λ_j = log s_j`, `λ_j/j → ∞`) forbids continuation across `Re s = 0`. The
`ζ ≠ g·D(as+b)` no-go is unaffected and in fact strengthened: `ζ` is meromorphic on `ℂ`,
`D`'s continuation cannot cross `Re s = 0`.

## B.5 The one route that is not excluded

The joint law's entire content is the **exact multiplicative cocycle**

```
θ_{mn} = θ_m + θ_n        (t log is a homomorphism (ℕ,×) → (ℝ/2πℤ, +)),
```

which the digit map destroys (that is B.3's obstruction). Applying the numeration where the
cocycle actually lives — **to the primes**, `p ≤ X` — is therefore the only suggestion in
the debate not excluded by the equidistribution argument. Its falsifiable prediction: digit-
word statistics over `p ≤ X` show an explicit-formula-sized anomaly at `t = γ_k` that is
absent over all `n ≤ X`. **Not yet run.** Flagged as the next experiment.

Separately, the **Sylvester Euler product** `L_M(s) = Π_j (1 − s_j^{−s})^{−1}` genuinely
exists (the `s_j` are pairwise coprime) and is a natural-boundary L-function. It does not
meet ζ, but it refutes the folklore that Euler products cannot have natural boundaries.

*Status — THEOREM: no meromorphic factorisation of ζ through `D` (natural-boundary
permanence); vacuity of Dirichlet convolution. PROVED-NEGATIVE: the digit-correlation
expansion is not absolutely convergent; the sine series does not factor (fold sign). 
EMPIRICAL: the `O(1/t)` support tilt. OPEN: the prime-cocycle route; the rank obstruction
(`~log log λ` vs `O(n^ε)`) as the right form of "Fabry lacunarity is incompatible with
multiplicative closure".*
