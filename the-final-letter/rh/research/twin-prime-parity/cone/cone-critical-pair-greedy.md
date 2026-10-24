# The critical cone: radial decay as an index coordinate, the pair-greedy rule, and the residue at `p = 1/2`

**Twin-prime-parity programme · cone note 001.**
A standalone note on a real (complex-free) lift of the signed greedy expansion, the
radial-pair greedy rule it suggests, and the numerical location of the two-point
residue.

| | |
|---|---|
| **object** | the cone `C_n = (n^{−p} cos(t log n), n^{−p} sin(t log n), n) ∈ ℝ³` and its pair algebra |
| **new threshold** | the radial-pair completeness threshold `p_pair = 1.4740898895836146046…`, root of `ζ(p) = 2 + 2^{1−p}` |
| **ordering** | `pN < pP < p_pair < p* < q` (all five values certified at 50 dps) |
| **critical cone** | `p = 1/2`; the two-point mean value is the residue of the cone pair transform there |
| **numerical verdict** | the critical-cone pair series converges to `−0.8637…`; the residue estimate is `0` (finite range, `N = 10⁸`) |
| **formalisation** | `lean/ConeLean/` (Lean 4 + Mathlib): **machine-checked, no `sorry`, no new axioms** — cone core, one-power dichotomy, strict antitonicity of `Ψ`, the certified brackets and tails, `pP < p_pair < p*`, the pairing identity, Brown's `k = 0` condition `⟺ Ψ(p) ≥ 0`, the all-k conditions at `k ≥ 1`, the census mechanism with its gap lemma, the machine-checked equivalence of `Σλ(n)λ(n+2) = o(x)` with the four-density-`1/4` statement (conditional on the one-point input), and the Cesàro ⟹ Abel reduction for the cone residue |
| **status of the target** | the open statement `Σ_{n≤x} λ(n)λ(n+2) = o(x)` is **not** proved here |

---

## Abstract

The rh42 budgets live on a signed alphabet `α_n = (−1)^n (n+2)^{−p}`; the associated
helix has **unit** radius, so it carries no index coordinate and the word factors
through the height `sin(2πθ)`.  Replacing the unit radius by the radial decay
`n^{−p}` opens the helix into a **cone** whose reciprocal radius is the index `n`: the
helix is the degenerate `p = 0` cone, and the index becomes a geometric coordinate.
On the cone the additive shift `n ↦ n+2` is an exact radial map on the same ray, and a
pair acquires two canonical real invariants: the symmetric pair weight
`r_n r_{n+2} = (n(n+2))^{−p}` and the antisymmetric separation
`r_n − r_{n+2} ≤ 2p n^{−p−1}`.

Two consequences are proved or certified here.

1. **The one-power dichotomy.**  Differencing along the shift costs exactly one power
   of `n`, so the shift-antisymmetric channel is absolutely convergent for every
   `p > 0` and never sees the mean value; the mean value lives only in the
   undifferenced pair weight, whose critical exponent is `p = 1/2`.
2. **The pair-greedy threshold.**  Grouping the positive half-series into consecutive
   radial pairs gives the pair alphabet `a_k = (4k+2)^{−p} + (4k+4)^{−p}`.  Brown's
   first completeness condition is the binding one (verified for `k = 0..7`), and it
   reads `ζ(p) ≥ 2 + 2^{1−p}`.  Its root `p_pair = 1.4740898896…` slots strictly
   between the positive-endpoint threshold `pP = 1.4649845878…` and the positive-half
   completeness threshold `p* = 1.7286472390…`.

The ordering `pP < p_pair < p*` is now a **Lean theorem** (`ConeLean.pair_threshold_between`,
no `sorry`); the numerically certified inputs it consumes are the four brackets of
§3.2 and the constant of §3.3, all of which are proved inside the same development.

Numerically (real arithmetic only, `N = 10⁸`): the critical-cone pair series
`Σ λ(n)λ(n+2)/√(n(n+2))` **converges** to `−0.8637…`; the residue ladder
`K(ε) = ε Σ f(n)(n(n+2))^{−(1+ε)/2} → 0`; and the *majorant* of the same cone has
residue `1` regardless of the mean value.  That contrast is the parity obstruction
drawn on the cone: the only pole real-variable positivity can force at `p = 1/2` is
the spurious majorant pole.

---

## 1. The cone

Fix a real decay exponent `p > 0` and a real angular parameter `t`.  Place the `n`-th
term of a Dirichlet-type expansion at

```
C_n(t) = ( n^{−p} cos(t log n),  n^{−p} sin(t log n),  n )  ∈ ℝ³ ,   n = 1, 2, 3, …
```

with **sheet coordinates** `(r, φ, h) = (n^{−p}, t log n, n)`.  The points lie on the
cone `r = h^{−p}`.

> **Only real numbers are used.**  `cos`, `sin` and `n^{−p}` are real functions; no
> complex number, no analytic continuation and no phase `n^{it}` is required.  The
> signed (Tau) alphabet is the case `φ_n = πn + t log n`, since
> `cos(πn + ψ) = (−1)^n cos ψ`.

Three facts, all with short proofs (formalised in `lean/ConeLean/Cone.lean`).

**1.1 The index is a coordinate.**  The map `n ↦ C_n(t)` is injective, and the
readout is `n = r^{−1/p}` (for `p = 1`, `n = 1/r`).  Every term has its own radius, so
the expansion is decodable term by term.

*Proof.*  `(n^{−p})^{−1/p} = n^{(−p)(−1/p)} = n`, and `r_n = 0` only for `n = 0`. ∎

**1.2 The helix is the `p = 0` cone.**  At `p = 0`, `r ≡ 1` and the readout is
constant: no index information.  This is exactly rh42's "the word cannot see the
turns" — the helix is the zero-decay cone, and adding radial decay is what restores
the lost coordinate.

**1.3 Cone dictionary.**  The one-point weight is `n^{−p}` (the line `σ = p` of the
Dirichlet series); the pair weight is `(n(n+2))^{−p}` (the line `σ = 2p`).

| cone `p` | one-point weight | pair weight | status |
|---|---|---|---|
| `p = 0` | `1` — the helix; no decay, no index | `1` | index invisible |
| `p = 1` | `σ = 1`, the pole/log line; `Σ λ(n)/n = 0` (PNT) | `σ = 2`, absolutely convergent | greedy mass `= x`; pair a computable number |
| `p = 1/2` | `σ = 1/2`, the critical line (rh43; `√N` error) | `σ = 1`, the log-average regime | log-average a theorem (Tao); the **residue** open |
| `p > 1` | `σ > 1`, the rh42 budget range | `σ > 1` | budgets, Brown's criterion, thresholds |
| `1/2 < p ≤ 1` | one-point divergent: **no budget theory** | pair convergent | a new window: the pair is computable where budgets are not |

On the harmonic cone `p = 1` the radii *are* the terms, so for a rational target
`Σ_{m∈A} 1/m = x` exactly; verified for `1 ↦ {2,3,6}`, `2/3 ↦ {2,6}`,
`7/11 ↦ {2,8,88}`, and four more targets (see §5).

---

## 2. The two channels, and the one-power dichotomy

The shift `n ↦ n+2` sends `h ↦ h+2`, `1/r ↦ 1/r + 2` (exact), `r ↦ r·(n/(n+2))^p`,
and on the Tau alphabet it preserves the sign: `(−1)^{n+2} = (−1)^n`.  So **`n` and
`n+2` lie on the same ray of the cone**, two sheets apart.  The pair has two canonical
real invariants.

| channel | invariant | contraction with `f(n) = λ(n)λ(n+2)` | behaviour |
|---|---|---|---|
| **symmetric** | pair weight `r_n r_{n+2} = (n(n+2))^{−p}` | `C_f(p) = Σ f(n)(n(n+2))^{−p}` | pole at the critical cone `p = 1/2` |
| **antisymmetric** | separation `r_n − r_{n+2} ≤ 2p n^{−p−1}` | `B(p) = Σ f(n)(r_n − r_{n+2})` | absolutely convergent for **every** `p > 0` |

**Lemma 1 (one-power dichotomy).**  For `p > 0` and `n ≥ 1`,

```
0 ≤ n^{−p} − (n+2)^{−p} = n^{−p}(1 − (1 + 2/n)^{−p}) ≤ 2p n^{−p−1} ,
```

so `Σ_n |n^{−p} − (n+2)^{−p}| < ∞` for every `p > 0`.

*Proof.*  The function `x ↦ (1+x)^{−p}` is convex on `[0,∞)`; its tangent at `0` is
`1 − px`, so `(1+2/n)^{−p} ≥ 1 − 2p/n`, giving the bound; `Σ n^{−p−1}` converges
because `p + 1 > 1`.  (Equivalently, the mean value theorem on `[n, n+2]` for
`x ↦ x^{−p}`: `|f(n+2) − f(n)| ≤ 2·sup|f′| = 2p n^{−p−1}`.)  ∎

**Corollary 2.**  For every bounded `f`, the shift-difference channel `B(p)` is
absolutely convergent for every `p > 0`, *before any cancellation in `f` is used*.
Hence:

> **the mean value of `λ(n)λ(n+2)` lives only in the undifferenced (symmetric) pair
> weight.**  Any statistic that differences along the shift has abscissa one lower and
> cannot see it.

At `p = 1` the two invariants coincide up to a factor: `1/n − 1/(n+2) = 2/(n(n+2))`,
so `B(1) = 2 C_f(1)` exactly (numerically `B(1) = −0.7855111755`,
`2C_f(1) = −0.7855111755`).

---

## 3. The pair-greedy rule, and a new threshold

### 3.1 The rule

**Definition 3 (radial-pair alphabet).**  The positive half-series is
`P(p) = Σ_{m even ≥ 2} m^{−p} = 2^{−p} ζ(p)`.  Group it into *consecutive radial
pairs* — the pairs `{2,4}, {6,8}, {10,12}, …` of even sheets, all of which lie on the
same ray of the cone:

```
a_k = (4k+2)^{−p} + (4k+4)^{−p} ,      k = 0, 1, 2, … ,      Σ_k a_k = P(p) .
```

*(Scalar form; for `t ≠ 0` replace each term by its vector
`v_n = n^{−p}(cos(t log n), sin(t log n))` and the pair by the resultant
`w_k = v_{4k+2} + v_{4k+4}`; for large `k` the pair is nearly radial and
`|w_k| → a_k`.)*

**Definition 4 (cone pair-greedy rule).**  Fix `p > 0` and a target `x ∈ [0, 1]`.
Put `r_0 = x`.  At pair index `k = 0, 1, 2, …`:

* **take** the pair iff `r_k ≥ a_k` (same ray, no overshoot), then `r_{k+1} = r_k − a_k`;
* otherwise **skip it permanently**, `r_{k+1} = r_k`.

The decision uses the pair's *radial coordinate* (its length and its position in the
pair sequence).  The rule is the greedy on the decreasing positive sequence `(a_k)`,
so its reachable set is the set of sub-sums of `(a_k)`.

### 3.2 The completeness threshold

**Brown's criterion.**  The sub-sums of a positive decreasing sequence `(a_k)` fill
`[0, Σ a_k]` iff `a_k ≤ Σ_{j>k} a_j` for every `k`.  For the pair alphabet the
condition at `k = 0` is the binding one, and this is now a **theorem** for
`1 < p ≤ 3/2` (`pair_brown_all_k` in
[`lean/ConeLean/PairCensus.lean`](../../../lean/ConeLean/PairCensus.lean): every
`k ≥ 1` condition holds), together with the equivalence
`a_0 ≤ Σ_{j≥1} a_j ⟺ Ψ(p) ≥ 0` (`pair_brown_zero_iff`).  Numerically the ratios
`a_k / Σ_{j>k} a_j` are `1.0000, 0.3173, 0.1896, 0.1353, …` at `p = p_pair`, so
`k = 0` is binding and later conditions are slack by a factor `≥ 3` (`3.15` at
`p = p_pair`):

```
k = 0 :  a_0 ≤ P(p) − a_0   ⟺   2(2^{−p} + 4^{−p}) ≤ 2^{−p} ζ(p)
                            ⟺   ζ(p) ≥ 2 + 2^{1−p} .
```

**Proposition 5 (the pair threshold).**  The pair-greedy rule is complete at exponent
`p` iff (first condition) `ζ(p) ≥ 2 + 2^{1−p}`.  Since `ζ` is strictly decreasing and
the right side is strictly decreasing, the first condition is equivalent to
`p ≤ p_pair`, where

```
p_pair = 1.4740898895836146046…      (ζ(p_pair) = 2 + 2^{1−p_pair}, 50 dps)
```

*Location.*  The bracket `22/15 < p_pair < 3/2` holds, with certified values

| `p` | `Ψ(p) = ζ(p) − 2 − 2^{1−p}` | `P(p) = 2^{−p}ζ(p)` |
|---|---|---|
| `22/15 = 1.4666…` | `+0.0293334` | `0.9960715` |
| `147/100 = 1.47` | `+0.0160328` | `0.9883686` |
| `p_pair = 1.4740899` | `0` | `0.9790638` |
| `149/100 = 1.49` | `−0.0595115` | `0.9443281` |
| `3/2 = 1.5` | `−0.0947314` | `0.9236142` |

### 3.3 The five thresholds

| threshold | equation | value | meaning |
|---|---|---|---|
| `pN` | `(1−2^{−p})ζ(p) = 2` | `1.3777851698375411838` | negative budget reaches `1`: `sin = −1` writable |
| `pP` | `2^{−p}ζ(p) = 1` | `1.4649845878051603837` | positive budget reaches `1`: `sin = +1` writable |
| **`p_pair`** | `ζ(p) = 2 + 2^{1−p}` | **`1.4740898895836146046`** | **the radial-pair greedy is complete** |
| `p*` | `ζ(p) = 2` | `1.7286472389981836181` | positive half complete (rh41's threshold) |
| `q` | `N(p) = 2·3^{−p}` | `2.0767751792106867148` | negative half complete |

> **`pN < pP < p_pair < p* < q`.**  Verified to 20 digits.  The cone contributes the
> middle entry: grouping the positive half into radial pairs is a *coarsening*, so the
> pair rule loses completeness strictly earlier than the single-term rule
> (`p_pair < p*`), but strictly later than the endpoint budget fails (`pP < p_pair`).

*Why the ordering is not free.*  `Ψ(p) = ζ(p) − 2 − 2^{1−p}` is a difference of two
decreasing functions, so monotonicity must be earned: `Ψ` is strictly decreasing on
`[7/5, 8/5]` because the one-power bound of Lemma 1 applied at `n = 3, 4` beats the
loss at `n = 2`:

```
Ψ(p) − Ψ(q) = Σ_{k≥0} [ (k+3)^{−p} − (k+3)^{−q} ] − (2^{−p} − 2^{−q})
            ≥ (q−p) [ log 3 · 3^{−8/5} + log 4 · 4^{−8/5} − log 2 · 2^{−7/5} ]  >  0 ,
```

the bracket being `≥ 0.1721 + 0.1086 − 0.2667 = 0.0140 > 0` on `[7/5, 8/5]`.
Strict antitonicity of `Ψ` on `[7/5, 8/5]`, the bracket `22/15 < p_pair < 3/2`, and
the endpoint comparison `P(22/15) < 1` then give `pP < p_pair < p*` by trichotomy.

---

## 4. The critical cone `p = 1/2`

### 4.1 The transform and its residue

Define the **cone pair transform**

```
C_f(p) = Σ_{n≥1} λ(n) λ(n+2) (n(n+2))^{−p} ,        absolutely convergent for p > 1/2 .
```

Partial summation with `S(x) = Σ_{n≤x} f(n)`, `f(n) = λ(n)λ(n+2)`, gives

```
C_f(p) = 2p ∫_1^∞ S(x) x^{−2p−1} (1 + O(1/x)) dx ,
```

hence, as `p ↓ 1/2` (write `ε = 2p − 1`):

* `S(x) ~ c x` (positive density) `⟹ C_f(p) ~ 2pc/ε`, i.e. `ε C_f(p) → c`;
* `S(x) = o(x)` `⟹ C_f(p) = o(1/ε)`, i.e. `ε C_f(p) → 0`.

> **The two-point mean value is the residue of the cone pair transform at the critical
> cone `p = 1/2`.**  In cone coordinates, two-point Chowla for the shift `2` is the
> statement *"the cone pair transform has no pole at `p = 1/2`"*.

### 4.2 What is a theorem on the critical cone

At `p = 1/2` the pair weight differs from the log-Chowla weight by an absolutely
summable error:

```
|1/√(n(n+2)) − 1/n| ≤ 1/n²     (because 1/(n+2) ≤ 1/√(n(n+2)) ≤ 1/n and
                                1/n − 1/(n+2) = 2/(n(n+2)) ≤ 2/n²),
```

so for bounded `f`, `Σ f(n)/√(n(n+2)) = Σ f(n)/n + O(1)`, and Tao's logarithmic
Chowla theorem gives

```
Σ_{n≤x} f(n)/√(n(n+2)) = o(log x) .
```

The antisymmetric channel is even better behaved (Lemma 1 and Corollary 2):
absolutely convergent.  So **everything readable on the critical cone is
theorem-level**; only the *residue* — the mean value — is open.

### 4.3 The parity obstruction, drawn on the cone

The majorant of the same cone is `Σ 1/√(n(n+2))`, which grows like `log x`
(§5: `0.9800 · log x` at `x = 10⁸`).  Its residue is `1`:

```
lim_{ε↓0} ε Σ_{n≥1} (n(n+2))^{−(1+ε)/2} = 1 ,
```

independently of the mean value of `f`.  So the only pole that non-negativity
arguments (Landau, Wiener–Ikehara) can force at `p = 1/2` is the **spurious majorant
pole**; the signed series need not have one, and numerically it does not.  This is the
parity obstruction in cone coordinates: the *positivity* is in the majorant, not in
the correlation.

---

## 5. Numerics (`N = 10⁸`, real arithmetic only)

`λ` is sieved as `(−1)^{Ω(n)}` by a prime-power sieve; `f(n) = λ(n)λ(n+2)`.  Script:
[`cone_critical_probe.py`](cone_critical_probe.py); log:
[`verify/cone_critical_probe.log`](verify/cone_critical_probe.log).

### 5.1 The residue ladder

`K(ε) = ε Σ_{n≤M} f(n) (n(n+2))^{−(1+ε)/2}`, with the rigorous truncation bar
`≤ M^{−ε}` (since `ε Σ_{n>M} n^{−2p} ≤ M^{−ε}`).  `K(ε) → c = lim S(x)/x`.

| `ε` | `p = 1/2 + ε/2` | `K(ε)` | bar `M^{−ε}` | majorant `K_maj(ε)` | plain `R(ε)` |
|---|---|---|---|---|---|
| `0.5` | `0.75` | `−0.28056916` | `1.0·10⁻⁴` | `0.86415674` | `−0.59599873` |
| `0.3` | `0.65` | `−0.19816356` | `4.0·10⁻³` | `0.91118155` | `−0.37222752` |
| `0.2` | `0.60` | `−0.14404386` | `2.5·10⁻²` | `0.91702033` | `−0.25457550` |
| `0.15` | `0.575` | `−0.11294057` | `6.3·10⁻²` | `0.89298136` | `−0.19368395` |
| `0.1` | `0.55` | `−0.07877129` | `1.6·10⁻¹` | `0.81185793` | `−0.13112225` |
| `0.07` | `0.535` | `−0.05667215` | `2.8·10⁻¹` | `0.70365750` | `−0.09268285` |
| `0.05` | `0.525` | `−0.04123152` | `4.0·10⁻¹` | `0.58687056` | `−0.06664674` |

Reading:

* the signed ladder `K(ε)` decreases to `0` roughly linearly in `ε`
  (`K(ε)/ε = C_f(1/2+ε/2) = −0.561, −0.661, −0.720, −0.753, −0.788, −0.810, −0.825`),
  i.e. **the residue estimate is `0`**: no pole at the critical cone;
* the majorant ladder stays of order `1` (`0.59 – 0.92`) — the spurious pole — and
  tends to `1` as `ε ↓ 0` (at `ε = 0.5` the plain majorant `ε ζ(1+ε) = 1.306` is
  already close to its limit `1`);
* the scale barrier is intrinsic: to see the residue at level `ε` one needs
  `M ≳ e^{1/ε}` (`M^{−ε} ≲ 1`).  At `M = 10⁸` this means `ε ≳ 0.055`; the ladder is
  quoted down to `ε = 0.05` with its bar, and not beyond.

### 5.2 The critical cone converges

Partial sums of the critical-cone pair series
`Σ_{n≤x} f(n)/√(n(n+2))` and of the log-Chowla series `Σ_{n≤x} f(n)/n`:

| `x` | `S(x)` | `S(x)/x` | `Σ f(n)/n` | `Σ f(n)/√(n(n+2))` |
|---|---|---|---|---|
| `10⁷` | `1246` | `1.25·10⁻⁴` | `−1.356313` | `−0.863657` |
| `2·10⁷` | `734` | `3.67·10⁻⁵` | `−1.356354` | `−0.863698` |
| `3·10⁷` | `−4108` | `−1.37·10⁻⁴` | `−1.356559` | `−0.863903` |
| `5·10⁷` | `−1960` | `−3.92·10⁻⁵` | `−1.356465` | `−0.863809` |
| `8·10⁷` | `32` | `4.0·10⁻⁷` | `−1.356447` | `−0.863791` |
| `10⁸−2` | `4632` | `4.63·10⁻⁵` | `−1.356396` | `−0.863740` |

The critical-cone series appears to **converge** (to `−0.8637…`, stable to `2·10⁻⁴`
over the last decade), which is stronger than the `o(log x)` guaranteed by Tao's
theorem.  This is a finite-range observation, not an asymptotic claim.

### 5.3 Convergent cone invariants (absolute error bars)

| quantity | value | bar |
|---|---|---|
| `C_f(1) = Σ f(n)/(n(n+2))` | `−0.3927555877` | `1.0·10⁻⁸` |
| `C_f(1.5)` | `−0.2145524256` | `< 10⁻⁶` |
| `C_f(2)` | `−0.1207675238` | `< 10⁻⁸` |
| `B(1) = 2C_f(1)` | `−0.7855111755` | — |
| majorant `Σ_{n≤10⁸} 1/√(n(n+2))` | `14.8972` | `= 0.9800 · log x` |

### 5.4 The cone mass of a greedy support

For the harmonic cone `p = 1` the radii are the terms; the greedy mass equals the
target exactly:

| `x` | support `A` | `Σ_{m∈A} 1/m` |
|---|---|---|
| `1/3` | `{3}` | `1/3` |
| `1/2` | `{2}` | `1/2` |
| `2/3` | `{2,6}` | `2/3` |
| `5/9` | `{2,18}` | `5/9` |
| `7/11` | `{2,8,88}` | `7/11` |
| `1` | `{2,3,6}` | `1` |

### 5.5 The reachable set of the pair rule (the rh42 census analogue)

The script [`pair_census.py`](pair_census.py) (log: [`verify/pair_census.log`](verify/pair_census.log))
computes the Brown ratios `r_k = a_k / T_k` (`T_k = Σ_{j>k} a_j`) and the resulting
census.

| `p` | `r_0` | `r_1` | `r_2` | `r_3` | `min_{k≥1} T_k/a_k` | census |
|---|---|---|---|---|---|---|
| `1.40` | `0.7986` | `0.2619` | `0.1578` | `0.1130` | `3.82` | 1 interval `[0, A]` |
| `1.45` | `0.9323` | `0.2990` | `0.1791` | `0.1280` | `3.34` | 1 interval `[0, A]` |
| **`p_pair`** | **`1.0000`** | `0.3173` | `0.1896` | `0.1353` | **`3.15`** | 1 interval `[0, A]` |
| `1.48` | `1.0169` | `0.3218` | `0.1922` | `0.1371` | `3.11` | 2 intervals, gap `0.00811` |
| `1.50` | `1.0753` | `0.3372` | `0.2009` | `0.1432` | `2.97` | 2 intervals, gap `0.03349` |
| `1.60` | `1.3913` | `0.4169` | `0.2456` | `0.1742` | `2.40` | 2 intervals, gap `0.12337` |
| `2.00` | — | `0.7844` | — | — | `1.27` | 2 intervals, gap `0.21377` |

Reading:

* **`k = 0` is exactly the binding condition**: `r_0 = 1.000000` at `p = p_pair` and
  `r_0 < 1` below it, while `r_k ≤ 0.32` for `k ≥ 1` — the numerical slack the note
  promised is `min_{k≥1} T_k/a_k = 3.15` at the critical exponent;
* **the census is `1` or `2` intervals, never more** (for `p ≤ 2`): since only the
  `k = 0` condition can fail, the reachable set is `[0, A]` below `p_pair` and
  `[0, T_1] ∪ [a_0, a_0 + T_1]` above it, with gap `2a_0 − A`.  In rh42's language the
  pair alphabet has `2^{n_min−1} = 2` intervals, i.e. `n_min = 2` — the smallest
  possible failure, in contrast to the single-term rule whose interval count grows;
* the measure drops from `A` (complete) to `2^j·Σ_{i≥j} a_i`, i.e. to `2(A − a_0)` at
  depth `j = 1`: at `p = 1.5`, `0.92361 → 0.89012`; at `p = 2`, `0.41123 → 0.19747`;
  at `p = 3` the depth is `j = 3` and the measure falls to `0.01177`.  The two tables
  agree term by term, which is a check on the script rather than on the mathematics.

At `p = 3` the depth rises to `j = 3` (`8` intervals) — the all-k theorem
(`pair_brown_all_k`) is stated for `p ≤ 3/2`, which is exactly the range where only
`k = 0` can fail.  The mechanism behind the census is machine-checked in §6.3; the
numbers in this table are the finite-range evidence for it.

---

## 6. Formalisation (Lean 4 + Mathlib) — complete

Development: [`lean/ConeLean/`](../../../lean/ConeLean/), built by

```
cd lean && ./check.sh ConeLean/Cone.lean ConeLean/PairThreshold.lean ConeLean/PairCensus.lean ConeLean.lean
```

— **all green, no `sorry`, no `admit`, no new axioms** (log:
[`verify/lean_check.log`](verify/lean_check.log)).

### 6.1 `ConeLean/Cone.lean` — the cone core (17 declarations)

| declaration | statement |
|---|---|
| `coneIndex_coneRadius` | the index readout `(n^{−p})^{−1/p} = n` |
| `coneRadius_injective` | the radius determines the index (fails at `p = 0`, the helix) |
| `ZetaR_eq_tsum_rpow_neg` | `ζ(p) = Σ n^{−p}` in the cone's exponent notation |
| `inv_add_two_le_critWeight`, `critWeight_le_inv` | the critical sandwich `(n+2)^{−1} ≤ (n(n+2))^{−1/2} ≤ n^{−1}` |
| `critWeight_error_le`, `summable_critWeight_error` | `1/n − (n(n+2))^{−1/2} ≤ 2/(n(n+2))` and its summability |
| `summable_critWeight_sub_inv_mul` | for bounded `f`, the critical-cone and log-Chowla transforms differ by an absolutely convergent series |
| `pairSeparation_eq` | `1/n − 1/(n+2) = 2·pairWeight 1 n` |
| `shiftDiff_nonneg`, `shiftDiff_le`, `summable_shiftDiff` | **Lemma 1 and Corollary 2** (the one-power dichotomy) |

### 6.2 `ConeLean/PairThreshold.lean` — the threshold theorem (27 declarations)

| stage | declarations |
|---|---|
| the difference identity | `Psi`, `Psi_sub` (via `TppLean.ZetaR_split` at `N = 2`) |
| the one-power bounds | `hasDerivAt_rpow_neg`, `rpow_sub_lower`, `two_rpow_sub_upper` (the fencing theorem) |
| the certified constant | `three_rpow_neg_eight_fifths_gt`, `four_rpow_neg_eight_fifths_gt`, `two_rpow_neg_seven_fifths_lt`, `pair_constant_pos` |
| **strict antitonicity** | **`Psi_strictAnti`** — `Ψ` strictly decreasing on `[7/5, 8/5]` |
| the floor-oracle brackets | `ZetaR_22_15_gt`, `ZetaR_22_15_lt`, `ZetaR_7_5_gt_three`, `ZetaR_8_5_lt`, `tail_22_15`, `tail_8_5` |
| the power certificates | `two_rpow_neg_22_15_lt`, `two_rpow_neg_7_15_lt`, `two_rpow_neg_half_gt`, `two_rpow_neg_three_fifths_gt` |
| the certified values | `Psi_22_15_gt`, `Psi_3_2_lt`, `BPos_22_15_lt_one` |
| the two tails | `ZetaR_eq_zero_of_le_one`, `Psi_pos_of_lt_seven_fifths`, `ZetaR_le_one_add`, `Psi_neg_of_eight_fifths_le` |
| **the theorem** | **`pair_threshold_between`** |

```lean
theorem pair_threshold_between {pP pPair pstar : ℝ}
    (hP : BPos pP = 1) (hpair : Psi pPair = 0) (hstar : ZetaR pstar = 2) :
    pP < pPair ∧ pPair < pstar
```

There are **no extra hypotheses**: the bracket `7/5 ≤ p_pair ≤ 8/5` that the earlier
reduction assumed is *derived* inside the proof from the two tail lemmas, and the
ordering then follows by trichotomy from `Psi_strictAnti` and the certified values.

### 6.3 `ConeLean/PairCensus.lean` — the pair alphabet, Brown's conditions, and the census (21 declarations)

| declaration | statement |
|---|---|
| `pairAlphabet`, `pairAlphabet_pos`, `pairAlphabet_antitone` | the pair alphabet `a_k = (4k+2)^{-p} + (4k+4)^{-p}` is positive and decreasing |
| **`tsum_even_add_odd_real`** | the even/odd splitting identity `Σ_k f(2k) + Σ_k f(2k+1) = Σ_j f j` for real series — **Mathlib has no such lemma for `ℝ`** (only `ℝ≥0∞`), and the rh42 paper records the split as having eluded its own elaboration; proved here by the block identity `Σ_{j<2n} f j = Σ_{k<n} f(2k) + Σ_{k<n} f(2k+1)` plus uniqueness of limits |
| **`tsum_pairAlphabet`** | **the pairing identity** `Σ_k a_k = BPos p = 2^{-p} ζ(p)` |
| **`pair_brown_zero_iff`** | **Brown's first condition** `a_0 ≤ Σ_{k≥1} a_k` ⟺ `0 ≤ Ψ(p)` ⟺ `p ≤ p_pair` |
| `tsum_rpow_inv_tail_ge` | the lower integral test `N^{1-p}/(p-1) ≤ Σ_k (k+N)^{-p}` (the mirror of `TppLean.tsum_tail_le`) |

`pair_brown_zero_iff` closes the gap between the note's claim and the formalisation:
the threshold `p_pair` defined in `PairThreshold.lean` by `Ψ(p) = 0` is *the same*
threshold as the pair alphabet's `k = 0` Brown condition.

The all-k conditions and the census are in the same file:

| declaration | statement |
|---|---|
| `pairAlphabet_le` | `a_k ≤ 2(4k+2)^{-p}` — for a negative exponent the *larger* base gives the *smaller* value, so both terms are dominated by `(4k+2)^{-p}` |
| `pairAlphabet_tail_ge` | `T_k ≥ 4^{-p}(k+2)^{1-p}/(p-1)` (the integral test on the second term of each pair) |
| `pair_key` | `2(p-1)·4^p·(4k+2)^{-p} ≤ (k+2)^{1-p}`, i.e. `2(p-1) ≤ (k+2)^{1-p}((2k+1)/2)^p` |
| **`pair_brown_all_k`** | **every Brown condition holds for `k ≥ 1` when `1 < p ≤ 3/2`**: `a_k ≤ Σ_{j≥0} a_{j+k+1}` |
| `SubSumIco` | finite sub-sum sets over an index window `[m,n)` |
| **`SubSumIco_succ`** | **the census recursion** `S_{[m,n)} = S_{[m+1,n)} ∪ (a_m + S_{[m+1,n)})` |
| **`SubSumIco_gap`** | **the gap lemma**: no sub-sum lies strictly between the tail total and `a_m` |
| `SubSumIco_glue` | Brown one step: tail fills `[0,T]` and `a_m ≤ T` ⟹ window fills `[0, a_m+T]` |
| **`SubSumIco_two_intervals`** | at the first failure the window is exactly `[0,T] ∪ [a_m, a_m+T]` |
| `SubSumIco_eq_Icc_of_brown` | finite Brown completeness: all conditions ⟹ the window fills `[0, Σa]` |
| **`pairAlphabet_subsum_gap`** | for the pair alphabet: `s ≤ Σ_{j≥1} a_j` or `a_0 ≤ s` — the reachable set has no point strictly between the tail total and `a_0` |

The proof of `pair_brown_all_k` is the chain
`a_k ≤ 2(4k+2)^{-p} ≤ 4^{-p}(k+2)^{1-p}/(p-1) ≤ T_k`.  The middle step is
`2(p-1)·4^p·(4k+2)^{-p} ≤ (k+2)^{1-p}` (`pair_key`), proved by

```
2(p-1)·(2/(2k+1))^p ≤ 2(p-1)·(2/(k+2))^p = 2(p-1)·2^p·(k+2)^{-p}
                    ≤ 3·(k+2)^{-p} ≤ (k+2)·(k+2)^{-p} = (k+2)^{1-p},
```

i.e. by the two rational facts `2(p-1)·2^p ≤ 3` for `p ≤ 3/2` (from
`2(p-1) ≤ 1` and `2^p ≤ 2^{3/2} ≤ 3`, the last certified by `8 ≤ 27`) and
`3 ≤ k+2` for `k ≥ 1`.  The margin over the sharp case `p = 3/2`
(`2(p-1)·2^p = 2.828 ≤ 3`) is a factor `1.06`; there is no appeal to a limit or to
numerics.

### 6.4 What is *not* formalised here

Two items remain outside the machine-checked statement, and neither is claimed:

* **the passage to the infinite alphabet.**  The census lemmas are stated for finite
  windows and for the infinite *tail* only through the gap lemma
  (`pairAlphabet_subsum_gap`).  Saying that the reachable set of the whole infinite
  pair alphabet *equals* `[0, A]` (for `p ≤ p_pair`) or `[0,T_1] ∪ [a_0, a_0+T_1]`
  (for `p_pair < p ≤ 3/2`) needs a closure/limit statement: every `s ∈ [0,A]` is a
  limit of finite sub-sums.  The greedy construction does this (the residual is
  dominated by the tail `Σ_{j>k}a_j → 0`), but it is not yet mechanised; §5.5 is the
  numerical evidence, not a proof;
* **the residue** `lim_{ε↓0} ε C_f(1/2+ε/2)`, which is open (§7 item 1) — the cone
  form of `Σ λ(n)λ(n+2) = o(x)`.

### 6.5 `ConeLean/ChowlaEquiv.lean` — the exact equivalent form of the target (10 declarations)

The one piece of the *open* target that is theorem-level (dictionary
[`03`](../dictionary/03-parity-problem.md) Theorem 3.5) is now machine-checked, so that
"`o(x)`" cannot silently drift between meanings:

| declaration | statement |
|---|---|
| `lam` | `λ(n)` as a real number (`ArithmeticFunction.liouville` coerced) |
| `chowlaSum` | `S(N) = Σ_{1 ≤ n ≤ N−2} λ(n)λ(n+2)` |
| `eqCount`, `patCount` | `#{n ≤ N−2 : λ(n) = λ(n+2)}` and `#{n ≤ N−2 : λ(n) = e₁, λ(n+2) = e₂}` |
| `lamSum`, `lamSumShift` | the two one-point sums `Σλ(n)`, `Σλ(n+2)` |
| **`chowlaSum_eq`** | **`S(N) = 2·#{λ(n) = λ(n+2)} − (N−2)`** |
| **`patCount_mul_four`** | **`4·#{λ(n)=e₁, λ(n+2)=e₂} = (N−2) + e₁Σλ(n) + e₂Σλ(n+2) + e₁e₂S(N)`** for `e₁² = e₂² = 1` |
| `tendsto_card_div` | `(N−2)/N → 1` |
| **`chowlaSum_tendsto_iff_patCount_tendsto`** | **given `Σ_{n≤x}λ(n) = o(x)` and `Σ_{n≤x}λ(n+2) = o(x)`, `S(x) = o(x)` ⟺ each of the four sign patterns has density `1/4`** |

The hypothesis in the last line is the one-point case of Chowla, which is PNT
(dictionary Theorem 3.3); the module does **not** prove `o(x)` itself, and its
statement is deliberately written as an implication so that the open content stays
visible.  Note also that this equivalence does *not* extend to the cone residue: the
residue is the **Abelian** mean `lim_{ε↓0} εΣf(n)n^{−1−ε}`, whose vanishing is implied
by `o(x)` but does not imply it (the bounded sequence `cos(θ log n)` has no pole at
`s = 1` yet is not `o(x)`), so the residue is a strictly weaker invariant.  That
asymmetry is the subject of the queued follow-up work on the residue (goal 2 in this
session): the residue limit is provable from Tao's log-averaged theorem by Abel
summation, and the two forms stand or fall together only under an extra
no-poles-on-the-line hypothesis.

### 6.6 `ConeLean/ResidueReduction.lean` — the Abelian mean, and the three reductions (37 declarations)

The residue `lim_{ε↓0} ε C_f(1/2+ε/2)` is the **Abelian** mean of `f`, and the first
half of the reduction between it and `o(x)` is machine-checked here (goal 2,
deliverable 1a):

| declaration | statement |
|---|---|
| `partSum` | `M(N) = Σ_{n<N} f n` |
| **`sum_mul_eq`** | **discrete Abel summation** `Σ_{n<N} f n · w n = M(N)w(N−1) − Σ_{n<N−1} M(n+1)(w(n+1)−w(n))` |
| `abelWeight` | the weight `w n = n^{−1−ε}` |
| `abelWeight_sub_le`, `abelWeight_gap_eq`, `sum_abelWeight_gap_le` | `w n − w(n+1) ≤ (1+ε)n^{−2−ε}`; the gaps telescope to `≤ 2` |
| `mul_abelWeight_pred_le`, `tsum_abelWeight_tail_le` | `N·w(N−1) ≤ 4` and `Σ_{n≥X} n^{−1−ε} ≤ (X−1)^{−ε}/ε` |
| `summable_abelWeight`, `summable_mul_abelWeight`, `abelMean` | summability for `ε > 0`, and the Abelian mean `ε Σ f(n)n^{−1−ε}` |
| **`abel_partial_bound`**, **`abel_tsum_bound`** | **the two-parameter bound** `\|ε Σ f(n)n^{−1−ε}\| ≤ ε(4δ + 2X) + 2(1+ε)δ(X−1)^{−ε}` whenever `\|f\| ≤ 1` and `\|M(n)\| ≤ δn` for `n ≥ X` |
| **`abelMean_tendsto_zero`** | **Cesàro ⟹ Abel**: `Σ_{n≤x}f(n) = o(x)` (for bounded `f`) implies `lim_{ε↓0} εΣ f(n)n^{−1−ε} = 0` |
| `logPartSum` | the log-average numerators `g(N) = Σ_{n<N} f n / n` |
| `rpow_neg_gap_le` | the gap bound for the log weight: `n^{−ε} − (n+1)^{−ε} ≤ ε n^{−1−ε}` |
| **`log_abel`** | **Abel summation in log form**: `Σ_{n<N} f n n^{−1−ε} = g(N)(N−1)^{−ε} + Σ_{n<N−1} g(n+1)(n^{−ε} − (n+1)^{−ε})` |
| `log_abel_partial_le` | the log-form partial bound: the Abel sum is controlled by `\|g\|` against the gaps of `n^{−ε}` |
| `log_abelWeight_le` | `log(m+1)·m^{−1−ε} ≤ (4/ε)·m^{−1−ε/2}` for `m ≥ 2` |
| **`sq_mul_log_tail_le`** | **the log-weighted tail bound**: `ε² Σ_{n≥X} log(n+1)·n^{−1−ε} ≤ 8` for `ε ≤ 1`, `X ≥ 2` |
| `tendsto_log_mul_rpow_neg` | the boundary term vanishes: `log N · N^{−ε} → 0` |
| **`abel_tsum_le_of_logAverage`** | **the log-average input bounds the Abel sum**: `\|g(m)\| ≤ lam·log m` for `m ≥ X` implies `\|Σ' f(n)n^{−1−ε}\| ≤ εK + 8·lam/ε`, `K = Σ_{n<X}\|g(n+1)\|/n` |
| **`abelMean_tendsto_zero_of_logAverage`** | **log-average ⟹ Abel (deliverable 1b)**: `Σ_{n≤N} f(n)/n = o(log N)` (bounded `f`) implies `lim_{ε↓0} εΣ f(n)n^{−1−ε} = 0` |
| `pairWeight_sub_le`, `rpow_neg_gap_two` | `\|(n(n+2))^{−p} − n^{−2p}\| ≤ 2n^{−2}` for `1/2 ≤ p ≤ 1`, by the mean-value theorem on `x ↦ x^{−p}` over `[n,n+2]` |
| **`coneTransform_sub_dirichlet_le`** | **(1c)**: `\|Σ_n f(n)((n(n+2))^{−p} − n^{−2p})\| ≤ 2Σ_n n^{−2}` — the pair transform's residue is the Dirichlet-series residue |

The Cesàro line is the direction that makes the residue **necessary** for `o(x)`; the
`log_abel` identity is the structural input for the *sufficient* direction (1b), which
runs through Tao's log-averaged theorem and is now complete: the constant
`ε² Σ log(n+1)n^{−1−ε} ≤ 8` is what stops the log-average from being destroyed by the
`1/ε²` growth of the tail, and the two-parameter assembly turns `g(N)/log N → 0` into
`ε Σ f(n)n^{−1−ε} → 0`.  **The cone residue is therefore a theorem conditional on the
published log-averaged two-point Chowla theorem** — it is *not* an open problem.  The
log-averaged theorem itself is an external input, named as such in the Lean docstring;
nothing in the module proves `o(x)`.  The
converse fails for bounded sequences (the `cos(θ log n)` example), so the residue is
strictly weaker than `o(x)`; and the *sufficient* direction — from the log-averaged
input `Σ_{n≤x}f(n)/n = o(log x)`, i.e. Tao's log-averaged two-point Chowla theorem —
is the remaining part of deliverable 1b.  Nothing in this module asserts, assumes or
approaches `o(x)` itself.

### 6.7 Trust accounting

The mathematical content is `Psi_strictAnti` — the one-power bound applied at `n = 3, 4`
against the loss at `n = 2` — together with the floor-oracle brackets inherited from
`TppLean`.  The numeric input is 13 `native_decide` invocations (the three large
`sumF` evaluations, the `ZetaR_lower`/`ZetaR_upper` side conditions, and five integer
power comparisons) plus Mathlib's `norm_num` and the log bounds
`Real.log_two_gt_d9`, `Real.log_two_lt_d9`, `Real.log_three_gt_d9`.  `native_decide`
rests on the Lean compiler (`Lean.ofReduceBool`), the same assumption `TppLean` and
Mathlib already make for large decidable computations; every other step is kernel
checked.  A reader who wants it removed can replace those invocations by `decide` at
the cost of a longer build.

## 7. What is open, and what would count as progress

1. **The residue is settled; `o(x)` is not.**  `S(x) = o(x)` is open; the cone
   localises it to the pole of `C_f` at `p = 1/2`.  Two things are now machine-checked
   (§6.6): the residue (the Abelian mean) **vanishes** whenever the log-average input
   `Σ_{n≤x}f(n)/n = o(log x)` holds — which is Tao's log-averaged two-point Chowla
   theorem — and the residue is *strictly weaker* than `o(x)` (the Cesàro direction
   `o(x) ⟹ residue 0` is `abelMean_tendsto_zero`, §6.6).  So the residue does not open
   the door to `o(x)`: it is implied by it, not equivalent to it.  (The *equivalence*
   of `o(x)` with the four-density-`1/4` statement is machine-checked, §6.5.)
   Finite data cannot decide it (finite-prefix indeterminacy), so the numerical
   verdict of §5 is evidence, not proof.
2. **The cone form of the barrier (OP-3).**  *No sign-blind cone statistic sees the
   residue.*  The natural next experiment is the pair-greedy support statistic:
   compute `C_{f,A}(p)` for the support `A` of the cone pair-greedy rule and compare
   its residue proxy against size-matched random supports (the rh47 B1 protocol
   applied to the pair channel).
3. **The infinite reachable set.**  The census *mechanism* is machine-checked
   (`SubSumIco_succ`, `SubSumIco_gap`, `SubSumIco_glue`, `SubSumIco_two_intervals`,
   `SubSumIco_eq_Icc_of_brown`, `pairAlphabet_subsum_gap`) and the numerics give
   `1` interval below `p_pair` and `2` above it, with the gap `2a_0 − A`; what is not
   formalised is the closure statement that identifies the reachable set of the
   *infinite* alphabet with those intervals (§6.4).
4. **Higher windows.**  Only the *first* failure is certified (`k = 0`); the numerics
   show the depth rising to `j = 3` at `p = 3`, and a per-`p` description of the
   interval count for large `p` is untouched.
5. **General shifts.**  Everything here is stated for the shift `2`; the cone algebra
   works for any shift `h`, and the pair alphabet generalises to `h`-tuples.  Whether
   the `h`-dependence of the threshold carries arithmetic information is open.

---

## Appendix A — constants

| constant | value | how established |
|---|---|---|
| `pN` | `1.3777851698375411838` | `N(p) = 1`, 50 dps |
| `pP` | `1.4649845878051603837` | `P(p) = 1`, 50 dps |
| **`p_pair`** | **`1.4740898895836146046`** | `ζ(p) = 2 + 2^{1−p}`, 50 dps |
| `p*` | `1.7286472389981836181` | `ζ(p) = 2`, 50 dps |
| `q` | `2.0767751792106867148` | `N(p) = 2·3^{−p}`, 50 dps |
| `Ψ(22/15)` | `0.02933340162` | 50 dps |
| `Ψ(147/100)` | `0.01603282242` | 50 dps |
| `Ψ(149/100)` | `−0.05951154722` | 50 dps |
| `P(22/15)` | `0.9960714819` | 50 dps |
| `C_f(1)` | `−0.3927555877` | `N = 10⁸`, absolute tail `10⁻⁸` |
| `C_f(1/2) ≈ Σ f(n)/√(n(n+2))` | `−0.8637 ± 0.0002` | finite range `N = 10⁸`, **not** an asymptotic claim |

## Appendix B — reproduction

```
cd research/twin-prime-parity/cone
python3 cone_critical_probe.py                 # sieves λ to 10⁸; ~30 s
python3 pair_census.py                         # Brown ratios + census; ~1 min
cd ../../../lean
./check.sh ConeLean/Cone.lean ConeLean/PairThreshold.lean ConeLean/PairCensus.lean ConeLean.lean
```

*Status legend — THEOREM: proved (Lean where noted); CERTIFIED: exact/numerical
certificate with stated precision; NUMERICAL: finite computation only, never a proof
of an asymptotic; OPEN: no proof known.*
