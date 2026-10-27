# The cone residue, the Chowla target, and what a proof would need

*Ledger and verdict for goal 2 (deliverables 1d, 2, 3).  Companion to
[`cone-critical-pair-greedy.md`](cone-critical-pair-greedy.md) §6.6.*

**Labels used throughout.**  **MACHINE-CHECKED** = a Lean 4 + Mathlib theorem, named, in
`lean/ConeLean/` (no `sorry`, no new axioms).  **EXTERNAL** = a published or classical
result, cited, and *not* reproved here.  **ARGUMENT** = a structural argument written out
but not machine-checked.  **OPEN** = no proof known.  Nothing below is labelled
machine-checked unless it is.

---

## 1. The two objects

```
S(x) = Σ_{n≤x} λ(n)λ(n+2)                     (the target: the two-point Chowla statement)
C_f(p) = Σ_n f(n)·(n(n+2))^{−p},  f(n)=λ(n)λ(n+2)   (the cone pair transform)
residue = lim_{ε↓0} ε·C_f(1/2 + ε/2)           (the cone residue)
```

The residue is the **Abelian mean** of `f`, not the Cesàro mean: it is
`lim_{ε↓0} ε Σ f(n)n^{−1−ε}` up to an absolutely convergent correction (that correction is
deliverable (1c), see §5).

## 2. What is MACHINE-CHECKED

| result | declaration | file |
|---|---|---|
| discrete Abel summation `Σ_{n<N} f n w n = M(N)w(N−1) − Σ_{n<N−1}M(n+1)(w(n+1)−w(n))` | `sum_mul_eq` | `ResidueReduction.lean` |
| **Cesàro ⟹ Abel**: `Σ_{n≤x}f(n) = o(x)` (bounded `f`) ⟹ `lim ε Σ f(n)n^{−1−ε} = 0` | **`abelMean_tendsto_zero`** | `ResidueReduction.lean` |
| **log-average ⟹ Abel**: `Σ_{n≤N}f(n)/n = o(log N)` (bounded `f`) ⟹ `lim ε Σ f(n)n^{−1−ε} = 0` | **`abelMean_tendsto_zero_of_logAverage`** | `ResidueReduction.lean` |
| the intermediate bound `\|Σ' f(n)n^{−1−ε}\| ≤ εK + 8·lam/ε` | `abel_tsum_le_of_logAverage` | `ResidueReduction.lean` |
| the log-weighted tail constant `ε² Σ_{n≥X} log(n+1)n^{−1−ε} ≤ 8` | `sq_mul_log_tail_le` | `ResidueReduction.lean` |
| Abel summation in log form (the identity behind the previous line) | `log_abel` | `ResidueReduction.lean` |
| `S(x) = o(x)` ⟺ each of the four sign patterns of `(λ(n),λ(n+2))` has density `1/4`, given the one-point input | `chowlaSum_tendsto_iff_patCount_tendsto` | `ChowlaEquiv.lean` |
| `4·#{λ(n)=e₁,λ(n+2)=e₂} = (N−2) + e₁Σλ(n) + e₂Σλ(n+2) + e₁e₂S(N)` | `patCount_mul_four` | `ChowlaEquiv.lean` |
| **barrier for R3**: the correlation is not multiplicative, `f(9) = −1 ≠ 1 = f(3)²` | **`chowla_not_multiplicative`**, `lam_not_multiplicative` | `ChowlaEquiv.lean` |
| **(1c)**: `\|Σ_n f(n)((n(n+2))^{−p} − n^{−2p})\| ≤ 2Σ_n n^{−2}` for `1/2 < p ≤ 1`, `\|f\| ≤ 1` | **`coneTransform_sub_dirichlet_le`** | `ResidueReduction.lean` |
| the per-term input `\|(n(n+2))^{−p} − n^{−2p}\| ≤ 2n^{−2}` | `pairWeight_sub_le`, `rpow_neg_gap_two` | `ResidueReduction.lean` |

All six modules re-verify green with zero warnings; see
[`verify/lean_check.log`](verify/lean_check.log).

## 3. The logical geography

```
                     log-average  Σ_{n≤x} f(n)/n = o(log x)          ← MACHINE-CHECKED reduction
                              │                                        (external input: Tao 2015)
                              ▼
   Cesàro  Σ_{n≤x} f(n) = o(x) ──►  residue = 0  ◄──  (1c) the pair weight differs by O(1)
                              MACHINE-CHECKED
                              ▲
                              └── the converse FAILS (§4)
```

So the residue is **implied** by `o(x)` and **implied** by Tao's log-averaged theorem.  It
is a theorem, conditional on that published result — the residue is *not* open.  But it is
**strictly weaker** than `o(x)`: the arrow back fails, so the residue cannot be used to
reach the target.  That asymmetry is the single most useful thing established here.

## 4. (1d) The converse fails — EXTERNAL

For `θ ≠ 0` let `f(n) = cos(θ log n)`.  Then `|f| ≤ 1`, and the associated Dirichlet series
is `(ζ(s−iθ) + ζ(s+iθ))/2`, which is **holomorphic at `s = 1`** (its poles are at
`s = 1 ± iθ`).  Hence `lim_{ε↓0} ε Σ f(n)n^{−1−ε} = 0`: the Abelian mean vanishes.  But

```
Σ_{n≤x} cos(θ log n) = Re( Σ_{n≤x} n^{iθ} ) = Re( x^{1+iθ}/(1+iθ) ) + O(1),
```

whose absolute value is `≍ x/√(1+θ²)` — **not** `o(x)`.  So `residue = 0 ⇏ o(x)`.

*Status:* EXTERNAL, classical.  The example is the standard illustration that the
Dirichlet-series Abelian mean is not equivalent to the Cesàro mean for bounded sequences
(contrast the power-series case, where Hardy–Littlewood does give equivalence).  *Citation:*
the theory is in G. H. Hardy, *Divergent Series* (Oxford, 1949), and in the
Hardy–Littlewood Tauberian papers; **the specific page was not verified in this session**,
and the computation above is reproduced here as the reason the claim is true, not as a
proof.  This item is deliberately **not** machine-checked (the anti-derivative estimate
`Σ_{n≤x}n^{iθ} = x^{1+iθ}/(1+iθ) + O(1)` needs Euler–Maclaurin-type input that Mathlib
does not currently provide for this shape).

## 5. (1c) The pair weight versus the Dirichlet series — MACHINE-CHECKED

```
ConeLean.coneTransform_sub_dirichlet_le :
  (∀ n, |f n| ≤ 1) → 0 < p → 1/2 < p → p ≤ 1 →
  |∑' n, (f n * pairWeight p n − f n * ↑n ^ (-2 * p))| ≤ 2 * ∑' n, abelWeight 1 n
```

The pair transform at exponent `p` and the Dirichlet series at `2p` differ by an
absolutely convergent series whose bound `2Σ_n n^{−2} = π²/3` does **not** depend on `p`.
At `p = 1/2 + ε/2` this is `C_f(1/2+ε/2) = F(1+ε) + O(1)` uniformly in `ε ∈ (0,1]`: the
pair transform's residue is the Dirichlet-series residue.

The per-term input is `pairWeight_sub_le` — `|(n(n+2))^{−p} − n^{−2p}| ≤ 2n^{−2}` for
`1/2 ≤ p ≤ 1` — proved by the mean-value theorem on `x ↦ x^{−p}` over `[n, n+2]`
(`rpow_neg_gap_two`: `n^{−p} − (n+2)^{−p} ≤ 2p·n^{−p−1}`), with the dominating series the
`p`-series at `2`.  The earlier attempt at this item failed on real-power bookkeeping
(`(n·n)^{−p} = n^{−2p}` is where the rewrites bit); the working proof avoids it by
comparing `n^{−p}·(n+2)^{−p}` with `n^{−p}·n^{−p}` directly.

## 6. (2) The route ledger

Each route to `o(x)`, its precise missing ingredient, and what is known:

| # | route | what it would supply | status |
|---|---|---|---|
| R1 | **Selberg parity / bounded-depth sieve** | an asymptotic count of a set defined by congruence conditions, without a bilinear input | **CLOSED** for this problem: Selberg's parity principle (dictionary `03` §2.1, T17) says bounded-depth sieves cannot distinguish `λ(n)λ(n+2) = −1` from `+1`; the target is not a sieving statement |
| R2 | **positivity / majorant** | a Landau- or Wiener–Ikehara-type pole forced at `p = 1/2` | **CLOSED** (ARGUMENT + numbers): the only pole a non-negative majorant can force is the *spurious* one — the majorant `Σ(n(n+2))^{−(1+ε)/2}` has residue `1` for every `ε`, independent of the mean value (cone note §4.3, §5.1) |
| R3 | **Euler product / ζ-machinery** | a Perron-type contour argument | **CLOSED — and MACHINE-CHECKED**: `n ↦ λ(n)λ(n+2)` is not multiplicative, witnessed at `n = m = 3` by `chowla_not_multiplicative` (`f(9) = −1` while `f(3)² = +1`); there is no Euler product to continue |
| R4 | **bilinear / spectral (Type II)** | a large-moduli equidistribution input (as in Bombieri–Friedlander–Iwaniec for primes) | **OPEN**: no known Type-II input sees `λ(n)λ(n+2)` at the required strength; this is the route the parity-breaking successes (dictionary T14–T16) used, and it has no analogue here yet |
| R5 | **entropy decrement** | the *log-averaged* statement | **THEOREM (external) and its limit is MACHINE-CHECKED**: Tao's log-averaged two-point Chowla is a theorem, and `abelMean_tendsto_zero_of_logAverage` shows it settles the **residue**; by §4 it *cannot* settle `o(x)` |
| R6 | **harmonic analysis of `h ↦ Σ_{n≤x}λ(n)λ(n+h)`** | control of the correlation sequence in `h` | **THEOREM on average (external: Matomäki–Radziwiłł–Tao, almost all shifts), OPEN for the prescribed shift `h = 2`** — and the gap is now **MACHINE-CHECKED to be structural**: `shift_average_does_not_control_single` exhibits a bounded sequence with total correlation mass `≤ 3` over `N` shifts (average `3/N → 0`) whose prescribed shift `h = 1` carries correlation exactly `1`.  No almost-all-shifts statement bounds a prescribed shift by itself |
| R7 | **almost-all-scales** | the un-averaged statement at almost every scale | **THEOREM (external: Tao–Teräväinen), OPEN at a prescribed scale**: `k = 2` un-averaged Chowla holds for all scales outside a set of zero logarithmic density, which gives nothing at a given `x` |

Two structural remarks that the machine-checked work makes precise:

* R5 shows that the *averaging* in the log-average is what makes the parity obstruction
  disappear, and `abelMean_tendsto_zero_of_logAverage` is the exact statement of how far
  that averaging reaches: precisely to the Abelian mean, no further.  The `1/ε²` growth of
  `Σ log(n+1)n^{−1−ε}` (tamed to the constant `8` by `sq_mul_log_tail_le`) is the
  quantitative trace of the averaging.
* R6 and R7 show that every known un-averaged statement about this correlation is
  *almost-everywhere* in a parameter (shift or scale).  The target is the single point
  `(h, x) = (2, x)`.

## 7. (3) The verdict

**What is proved here.**  The cone residue vanishes, conditional on Tao's log-averaged
two-point Chowla theorem — machine-checked, §2.  `o(x)` implies the residue vanishes —
machine-checked.  The residue does **not** imply `o(x)` — §4, external counterexample.  And
`o(x)` is equivalent to the four-density-`1/4` statement — machine-checked (goal 1).

**What is open.**  `Σ_{n≤x}λ(n)λ(n+2) = o(x)`: the two-point Chowla conjecture at shift 2
(dictionary `03` §3.3, OPEN 3.4).  No claim to the contrary is made anywhere in this
repository.  Equivalently (dictionary §4.2): the Dirichlet series `F(s) = Σ λ(n)λ(n+2)n^{−s}`
has no pole at `s = 1` **alone** does not suffice (§4); what is needed is that `F` continues
holomorphically to `Re s ≥ 1` with adequate growth bounds — that is the precise missing
analytic statement.

**What a proof would have to supply.**  From the ledger, a successful route must (i) bring a
*new arithmetic input* — not sieve, not positivity, not an Euler product (R1–R3 are closed)
— and (ii) hold *uniformly in the scale* (R7 shows almost-all-scales is insufficient) and at
the *prescribed shift* (R6 shows almost-all-shifts is insufficient).  The one route that
does break parity, entropy decrement (R5), provably stops at the Abelian mean.

**Goal-3 additions.**  Two modules, both MACHINE-CHECKED.

`ShiftBarrier.lean` — the (b2) barriers (`spike`, `corr`, `sum_abs_corr_spike_le`,
`shift_average_does_not_control_single`), plus the **scale-side analogue**:
`scale_average_does_not_control_prescribed` exhibits a bounded sequence whose partial sums vanish
at every scale up to `N/2`, equal `N − N/2` at the prescribed scale `N`, and are `O(1)` from `N`
onward — a conspiracy confined to one window of scales, invisible to any almost-all-scales
statement.  (Witness: the block indicator `[N/2, N)`, with `sum_block_eq` computing its partial
sums as `min x N − N/2`.)

`SpectralStructure.lean` — (b1), the finite **Wiener–Khinchin identity**: for
`Φ : ZMod N → ℂ` with autocorrelation `autocorr Φ h = Σ_j Φ (j+h)·conj (Φ j)`,

```
dft_autocorr : 𝓕 (autocorr Φ) k = (𝓕 Φ k) * conj (𝓕 Φ k)
```

so the Fourier transform of the correlation sequence *is* the power spectrum.  With it, the
equivalence the deliverable asks for:

```
dft_mul_star_dft_eq_of_corr_eq_zero : (∀ j ≠ 0, autocorr Φ j = 0)
    → ∀ k, (𝓕 Φ k) * conj (𝓕 Φ k) = autocorr Φ 0        -- vanishing correlations ⟹ flat spectrum
corr_eq_zero_of_dft_mul_star_dft_eq : (∀ k, (𝓕 Φ k) * conj (𝓕 Φ k) = c)
    → ∀ j ≠ 0, autocorr Φ j = 0                          -- flat spectrum ⟹ vanishing correlations
```

The second direction is where the arithmetic content of route R6 actually sits: it uses
Fourier inversion together with the orthogonality of the standard additive character
(`AddChar.sum_mulShift` + primitivity of `stdAddChar`), i.e. it is exactly the step that says
"no periodic/pretentious component" — which is the shape (c3) tests for numerically.  The
only non-Mathlib ingredient is `star_stdAddChar` (`conj` inverts the character), proved via
`Circle.coe_inv_eq_conj`.

`LogAverageBarrier.lean` — (b3), MACHINE-CHECKED: a logarithmic average is blind to sets of
zero *harmonic* density.  The squares are the witness, and the mechanised content is

```
sum_inv_sq_le_zeta_two     : ∑_{n≤N} 1/n² ≤ π²/6            (ζ(2); Mathlib's hasSum_zeta_two)
tendsto_sum_inv_sq_div_log : (∑_{n≤N} 1/n²) / log N → 0
```

so the harmonic weight of the squares is bounded while (ARGUMENT, not mechanised: there are `C+1`
squares among `0,…,C²`) their counting function is unbounded.  This is the quantitative reason a
log-averaged theorem cannot certify a prescribed scale: the log-average's weight is `1/n`, so a set
of zero harmonic density is invisible to it however many elements it has.  It is the exact
counterpart of goal 2's (1b): Tao's theorem controls the Abelian mean, and this says why that
control stops where it does.

`ParityObstruction.lean` — (c1), MACHINE-CHECKED: the correlation sequence has none of the
algebraic structure the parity-breaking methods consume.

```
chowlaAF_one                : f 1 = -1                      -- multiplicativity forces f 1 = 1
chowlaAF_not_multiplicative : ¬ f.IsMultiplicative
chowlaAF_not_conv           : ¬ ∃ g h, g.IsMultiplicative ∧ h.IsMultiplicative ∧ g * h = f
```

`chowlaAF` is `n ↦ λ(n)λ(n+2)` as an `ArithmeticFunction ℤ`; the last line says the classical
Type-II/convolution shape (`Λ = μ * log` is the model) is closed for `f`, because a convolution of
multiplicative functions is multiplicative.  This upgrades R3 from "closed by citation" to
"closed, with the algebra machine-checked".

The (c3) item is reported in §9.

**Machine-checked inventory, updated.**  (1a), (1b), (1c) and the four-density equivalence
are machine-checked; (1d) is an external counterexample as the deliverable specifies; the
R3 barrier is machine-checked; R1/R2 are cited or argued, as labelled in §6.

**What this document does not do.**  It does not prove `o(x)`, it does not claim that
`o(x)` is false, and it does not identify a route that is known to work.  It records, with
labels, exactly where the machine-checked work stops and what would have to be added.


---

## 8. (c2) What structure would suffice — provably absent versus merely unknown

The point of (c1) is not that a route is hard but that a *hypothesis is false*.  Separating the
four candidates by epistemic status:

| structure | what it would buy | status |
|---|---|---|
| **Euler product** (multiplicativity of `f`) | `ζ`/Perron contours, functional equation, spectral interpretation of the coefficients | **PROVABLY ABSENT** — `chowlaAF_not_multiplicative`: `f 1 = −1` while multiplicativity forces `f 1 = 1` |
| **Dirichlet convolution of multiplicative functions** (the Type-II shape, model `Λ = μ * log`) | Selberg/Friedlander–Iwaniec asymptotic sieve | **PROVABLY ABSENT** — `chowlaAF_not_conv`, since a convolution of multiplicative functions is multiplicative |
| **Automorphy** (`f` as the coefficients of an automorphic `L`-function) | continuation, functional equation, spectral theory, amplification | **OPEN, and badly supported** (ARGUMENT): automorphic coefficient sequences come with an Euler product, so the machine-checked failure of multiplicativity is evidence against this route existing — but "no automorphic form has these coefficients" is *not* proved here |
| **Spectral positivity** (a Hilbert-space realisation in which the correlation is a matrix coefficient) | vanishing of the mean value from positivity, which is the shape of the parity-breaking successes (bilinear forms, amplification) | **OPEN** — genuinely unknown; nothing here closes it, and this is the only candidate on the list that is not contradicted by a machine-checked fact |
| **A non-multiplicative Type-II summand** `f = a * b` | bilinear equidistribution without multiplicativity | **OPEN** — `chowlaAF_not_conv` excludes only the *multiplicative* summands; the general case is untouched |

Two things this table is meant to make visible:

1. Three of the five candidates are not "unexplored" but **contradicted**: `f` has no Euler product,
   and no multiplicative factorisation of the classical shape.  Any future attempt that assumes
   either is dead on arrival, and now provably so.
2. What survives is exactly **positivity** — spectral or otherwise.  That is also the historical
   pattern: parity has been broken by inputs that supply positivity or bilinear structure
   (Friedlander–Iwaniec), not by better averaging.  So the honest statement of where a proof would
   have to come from is: a positivity mechanism for the shift-2 correlation, or a non-multiplicative
   bilinear input.  Neither exists, and (c1) explains why the obvious multiplicative versions cannot.

**Caveat, stated plainly.**  This table classifies *hypotheses of known methods*, not the truth of
the conjecture.  The absence of an Euler product does not make `o(x)` false; it only removes the
tools that need one.  And nothing here suggests a route that *would* work.


---

## 9. (c3) Finite-range diagnostic — HEURISTIC, and labelled as such

[`parity_diagnostic.py`](parity_diagnostic.py) (log: [`verify/parity_diagnostic.log`](verify/parity_diagnostic.log))
tests the three shapes a parity-visible conspiracy could take in `f(n) = λ(n)λ(n+2)`:

| shape | statistic | result at `N = 2²²` | white-noise expectation |
|---|---|---|---|
| periodic | max of the periodogram `\|F(k)\|²` | `13.76` (at `k = 1802079`) | `~ log M = 15.25` |
| pretentious | `max_t \|Σ_{n≤N₀} f(n)n^{−it}\|/√N₀`, `t ∈ [0,60]` | `2.32` | control (random ±1): `2.40` |
| single shift | `max_{h≠0} \|C(h)\|` | `1.009e4` = `0.89 ×` expected max | `1.131e4` |
| **the Chowla shift** | `C(2)/(rms·√M)` | **`+0.27`** | `O(1)` |

The computation uses the cyclic autocorrelation — the exact object formalised in (b1) — and the
script *verifies Wiener–Khinchin on real data*: `Σ_h C(h)²` and `(1/M)Σ_k|F(k)|⁴` agree to a
relative `3.5 × 10^{−10}`.  That is (b1) confirmed numerically on the sequence that matters, not
just as an abstract identity.

**What this does and does not say.**  Everything above is consistent with white noise, and the
shift-2 correlation in particular shows nothing.  But this is **finite-range evidence only**.  No
finite computation can decide `o(x)` — the archive's F4 records that finite prefixes cannot
distinguish the truth of Chowla from its negation — so a clean diagnostic is consistent with the
conjecture *and* with many alternatives, and is **not** evidence for the conjecture.  Its value is
the opposite direction: it would have caught a *gross* conspiracy (a periodic or pretentious
component strong enough to be visible in `10⁶` terms), and there is none.  Nothing here bears on
the limit.
