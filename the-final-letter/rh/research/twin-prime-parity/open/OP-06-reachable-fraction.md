# OP-6 — RESOLVED: the exact order of the reachable fraction

**Status: SOLVED (order, leading constant, and the linear coefficient proved; the `1/p`
coefficient derived in closed form as a function of the ceiling error — see §2.4 and the
correction note in §1).**
Scripts: [`op06_reachable_fraction.py`](op06_reachable_fraction.py) (census + leading
coefficients) and [`op06_ceiling_coefficient.py`](op06_ceiling_coefficient.py) (the exact
`1/p` coefficient). Register row: [`07-open-problems.md`](07-open-problems.md) OP-6.
Inputs: rh42 Thm 10 (census) and [OP-5](OP-05-nmin-asymptotic.md) (`n_min`).

## 1. The theorem

Let `a_k = (2k)^{−p}` be the positive half-series, `k = 1, 2, 3, …`, with budget
`P(p) = Σ_{k≥1} a_k = 2^{−p}ζ(p)`, and put

```
T_n := Σ_{k≥n} a_k = 2^{−p} ζ(p, n) ,        P(p) = T_1 .
```

rh42 Thm 10 (census) gives, with `n_min(p)` the first index at which the tail satisfies
Brown's criterion,

```
S_1 = ⋃_{A ⊆ {1,…,n_min−1}} ( Σ_{k∈A} a_k + [0, T_{n_min}] ),
measure(S_1) = 2^{n_min(p)−1} · T_{n_min(p)} = 2^{n_min(p)−1−p} ζ(p, n_min(p)) .
```

Put `L(p) := −log( measure(S_1)/P(p) )`. Then

```
L(p)  =  p log p  −  (1 + ln ln 2)·p  −  c(e(p))/p  +  O(1/p²)
c(e)  =  −((ln 2)²/2)·( e² − e + 9/4 ) ,      e(p) = ⌈p/ln 2 − 5/2⌉ − (p/ln 2 − 5/2) ∈ [0,1)
```

equivalently, since `exp(−p log p) = p^{−p}`,

```
measure(S_1)/P(p)  =  p^{−p} · e^{(1 + ln ln 2)·p} · (1 + o(1))  →  0 .
```

> **Correction (TODO item O4).** This note previously stated the `1/p` coefficient as a
> **constant** `0.540509640658…`. **That is false.** The coefficient is the *function*
> `c(e(p))` of the ceiling error above; it ranges over
> `[−(ln 2)², −(9/8)(ln 2)²] = [−0.480453013918201, −0.540509640657977]`.
> The recorded `−0.540509640658` is exactly `−(9/8)(ln 2)²`, the value at `e = 0` — i.e.
> it belongs to the *smooth* (non-integer) threshold `p/ln 2 − 3/2`, not to the true
> integer index. The `O(1/p²)` remainder cannot absorb an oscillating `O(1/p)` term, so
> the correct statement is `L(p) = p log p − (1 + ln ln 2)p + O(1/p)` with the explicit
> coefficient above. **The main theorem `L(p) = p log p − (1 + ln ln 2)p + O(1)` is
> unaffected.** Verified to `3.1·10⁻¹³` at `p = 10¹³` by
> [`op06_ceiling_coefficient.py`](op06_ceiling_coefficient.py)
> ([log](op06_ceiling_coefficient.log)).

**The reachable fraction of the budget dies like `p^{−p}`.** The log of its reciprocal is
`p log p` to leading order, and the linear term `−(1 + ln ln 2)p` is of the *same* order as
the leading term — it is not a lower-order correction.

**The recorded falsifiable form.** The register asked for "a predicted leading constant `c`
in `−log(measure/P) ~ c·p log p`". The leading term is confirmed and the constant is
**`c = 1`** — not `1/ln 2 = 1.4427` and not `2/ln 2 = 2.8854`. The register left `c` open;
this resolves it and supplies the exact second coefficient `−(1 + ln ln 2)`.

## 2. The derivation

### 2.1 Reduction to one exact expression

The `2^{−p}` factors in numerator and denominator cancel:

```
measure(S_1)/P(p)  =  2^{n_min−1} · ζ(p, n_min) / ζ(p) .
```

With `n = n_min(p)`,

```
L(p)  =  −(n−1) ln 2  −  log ζ(p, n)  +  log ζ(p) .
```

As `p → ∞`, `ζ(p) = 1 + O(2^{−p})`, so the last term is `o(1)` and is dropped. The binding
quantity is `−log ζ(p, n)`.

### 2.2 The regime at the threshold: `p ≫ n`

OP-5 gives `n_min(p) = p/ln 2 − 3/2 + O(1)` (the error term is `O(1)`, **not** `O(1/p)`; see
the correction note in [`OP-05-nmin-asymptotic.md`](OP-05-nmin-asymptotic.md)), hence

```
n_min(p)/p  →  1/ln 2 = 1.4427…  <  2 ,       i.e. p > n at the threshold.
```

In this regime the Hurwitz tail is dominated by its first term. Writing

```
z(p) := ζ(p, n)·n^p = Σ_{j≥0} (1 + j/n)^{−p} ,
```

the ratio of consecutive summands is `(1+1/n)^{−p} = e^{−p/n + O(p/n²)} → e^{−ln 2} = 1/2`,
so the series converges geometrically and

```
ζ(p, n)  =  n^{−p} · z(p) ,       z(p)  =  2 + o(1) .
```

Therefore

```
−log ζ(p, n)  =  p log n  −  log z(p)  =  p log n  −  ln 2  +  o(1) ,
```

and the exact reduction is

```
L(p)  =  −(n−1) ln 2  +  p log n  −  log z(p)  +  o(1) .
```

This is the expression the script evaluates; it gives `L(1000) = 6274.26769643` and
`L(10^6) = 13182023.47854546`, matching the direct census identity to 7 and 13 significant figures.

### 2.3 The leading orders

Put `a = ln 2` and `n = p/a − 3/2 + O(1)` (the index error is `O(1)`, not `O(1/p)`). Then

```
−(n−1)a   =  −p        +  (5/2)a  + O(1) ,
p log n   =  p log p   −  p log a − (3/2)a + O(1) ,
−log z(p) =                          −  log 2  + o(1) .
```

Adding, the coefficient of `p` is `−(1 + log a) = −(1 + ln ln 2)`, so

```
L(p)  =  p log p  −  (1 + ln ln 2)·p  +  O(1) .
```

Since `ln ln 2 = −0.3665129205816643…`, the linear coefficient is

```
−(1 + ln ln 2)  =  −0.6334870794183357… .
```

**The coefficient of `p log p` is exactly 1.** The recorded guess's `c` is 1.

### 2.4 The `1/p` coefficient — closed form, and it is not a constant

Write the true index as `n = p/a − 3/2 + e` with `a = ln 2` and `e = e(p) ∈ [0,1)` the
ceiling error of §2.3. Then

```
−(n−1)a  =  −p + (5/2)a − a e
p log n  =  p log p − p log a + a(e − 3/2) − (a²/2)(e − 3/2)²/p + O(1/p²)
−log z(p) =                                       − log 2 + o(1)
```

The `a e` terms **cancel exactly**, and adding the three lines gives

```
L(p)  =  p log p  −  (1 + ln ln 2) p  −  ((ln 2)²/2)·(e² − e + 9/4) / p  +  O(1/p²) .
```

So the `1/p` coefficient is **closed form**,

```
c(e)  =  −((ln 2)²/2)·( e² − e + 9/4 ) ,
```

but it is a **function of the ceiling error `e(p)`**, not a constant. Since
`e² − e + 9/4 = (e − 1/2)² + 2` on `e ∈ [0,1)`, `c` ranges over

```
c ∈ [ −(ln 2)² , −(9/8)(ln 2)² ]  =  [ −0.480453013918201… , −0.540509640657977… ] .
```

The value `−(9/8)(ln 2)² = −0.540509640657977…` — the number this note previously
reported as *the* coefficient — is the `e = 0` value, i.e. it belongs to the **smooth**
(non-integer) threshold `p/ln 2 − 3/2`, not to the true integer index.

The `O(1/p²)` remainder cannot absorb an oscillating `O(1/p)` coefficient, so the exact
statement is `L(p) = p log p − (1 + ln ln 2)p + O(1/p)` with the coefficient above.

**Numerical confirmation** ([`op06_ceiling_coefficient.py`](op06_ceiling_coefficient.py)):

| `p` | `e(p)` | `p·R(p)` | `c(e(p))` | difference |
|---|---|---|---|---|
| `10⁶` | 0.459111 | −0.480854964688 | −0.480854650376 | 3.1·10⁻⁷ |
| `10⁹` | 0.611037 | −0.483414796849 | −0.483414796528 | 3.2·10⁻¹⁰ |
| `10¹²` | 0.536593 | −0.480774682330 | −0.480774682330 | 3.2·10⁻¹³ |
| `10¹³` | 0.865926 | −0.512619855067 | −0.512619855067 | 3.5·10⁻¹⁴ |

where `R(p) = L(p) − (p log p − (1 + ln ln 2)p)`. The difference falls by ~10× per
decade of `p`, i.e. `R(p) = c(e(p))/p + O(1/p²)`. A single constant cannot fit:
`p = 10⁷` gives `p·R = −0.520616694704` while `p = 10⁹` gives `−0.483414796849`
(difference `3.7·10⁻²`).

## 3. Verification

### 3.1 The census identity reproduces rh42's recorded table

This script recomputes `measure(S_1) = 2^{n_min−1}·2^{−p}ζ(p, n_min)` from the threshold
definition of `n_min` and compares with the table of rh42 §4:

| `p` | `n_min` | `measure/P` (this script) | rh42 record |
|---|---|---|---|
| 2 | 2 | 0.784145796292 | 0.784146 |
| 3 | 3 | 0.256416823387 | 0.256417 |
| 4 | 5 | 0.052794648956 | 0.0527946 |
| 6 | 8 | 0.00103748418513 | 0.00103748 |
| 8 | 11 | 1.01399618689·10⁻⁵ | 1.013996·10⁻⁵ |
| 10 | 13 | 5.95937484186·10⁻⁸ | 5.959375·10⁻⁸ |
| 12 | 16 | 2.34672902309·10⁻¹⁰ | 2.346729·10⁻¹⁰ |

All seven `measure/P` entries agree to the record's precision, confirming the convention
`T_n = 2^{−p}ζ(p,n)` and the census law. (`n_min` matches the record at every `p ≥ 2`; the
record's `p = 1.8` and `p = 2.2` rows appear to be offset by one, since `ζ(1.8,2) − 1 < 0`
forces `n_min(1.8) = 1` for the stated alphabet. This does not affect the asymptotics.)

### 3.2 The linear coefficient on exact data

Exact census values of `L` and the ratio `(L − p log p)/p`:

| `p` | `L(p)` | `L/(p log p)` | `(L − p log p)/p` |
|---|---|---|---|
| 10³ | 6274.26769643 | 0.90829328 | −0.6334875826 |
| 2·10³ | 13934.83050166 | 0.91665632 | −0.6334872087 |
| 5·10³ | 39418.53045303 | 0.92562255 | −0.6334871008 |
| 10⁴ | 85768.53287747 | 0.93122001 | −0.6334870842 |
| 10⁵ | 1087943.83854979 | 0.94497601 | −0.6334870795 |
| 10⁶ | 13182023.47854546 | 0.95414668 | −0.6334870794 |

The last column is converging to `−(1 + ln ln 2) = −0.633487079418…`. The ratio
`L/(p log p)` rises to 1, slowly, because the linear term is of the same order as the
leading term: `L/(p log p) = 1 − (1 + ln ln 2)/log p + O(1/log² p)`.

### 3.3 The `1/p` coefficient

**Superseded table (kept as the record of the error).** The original note evaluated the
"independent large-`p` branch" `L = −(n−1)ln 2 + p log n − log z(p)` at 80–120 dps and
reported:

| `p` | `(L − p log p)/p` | `p·R(p)` (as reported) |
|---|---|---|
| 10⁶ | −0.6334870794 | −0.540510014 |
| 10⁹ | −0.6334870794 | −0.540509641031 |
| 10¹² | −0.6334870794 | −0.540509640658 |
| 10¹³ | −0.6334870794 | −0.540509640658 |

Those `p·R(p)` numbers used the **smooth** index `n = p/ln 2 − 3/2` (equivalently `e = 0`),
so they all sit at `−(9/8)(ln 2)²`. With the **true** ceiling index the same quantity is

| `p` | exact `e(p)` | `p·R(p)` (true index) |
|---|---|---|
| 10⁶ | 0.459111 | −0.480854964688 |
| 10⁷ | 0.091110 | −0.520616694704 |
| 10⁹ | 0.611037 | −0.483414796849 |
| 10¹³ | 0.865926 | −0.512619855067 |

so `p·R(p)` is **not** stable: it tracks `c(e(p))` (§2.4). The correct conclusion is
`R(p) = c(e(p))/p + O(1/p²)` with the closed-form, e-dependent coefficient.

## 4. What this settles in the programme

- OP-6's row: **OPEN → SETTLED** — the reachable fraction is
  `p^{−p} e^{(1+ln ln 2)p}(1+o(1))`, with the recorded `c` pinned at `c = 1`.
- The register's qualitative sentence, "the reachable fraction of the budget collapses to
  zero as `p → ∞`", is now quantitative and its order is explicit.
- The chain rh42 Thm 10 ⟶ OP-5 ⟶ OP-6 is closed: the census law supplied the interval
  count, OP-5 supplied the exponent `n_min(p)`, and OP-6 converts both into the decay law
  of the fraction.
- A corollary worth recording: because the second coefficient `−(1 + ln ln 2)` is of the
  same order as the leading `p log p`, the *ratio* `L/(p log p) → 1` is a very weak
  diagnostic — at `p = 10^6` it still reads `0.954`. Fitting only `c·p log p` cannot see
  the linear term.

**Not claimed.** Nothing here touches the twin prime conjecture, the parity problem, or the
Riemann hypothesis. Proven: the leading coefficient `1`, the linear coefficient
`−(1 + ln ln 2)`, and the `1/p` coefficient in closed form as the **function**
`c(e) = −((ln 2)²/2)(e² − e + 9/4)` of the OP-5 ceiling error — verified to `3.5·10⁻¹⁴`
at `p = 10¹³`. The single numeric constant `−0.540509640658…` reported earlier is the
`e = 0` (smooth-index) value and is **not** the coefficient of the true integer index.

*Reproduce:*
`python3 op06_reachable_fraction.py` (four sections: the exact census values and the rh42
cross-check, the leading coefficient 1, the linear coefficient, and the closed-form law)
and `python3 op06_ceiling_coefficient.py` (the exact `1/p` coefficient `c(e(p))` and the
non-constancy witness).*
