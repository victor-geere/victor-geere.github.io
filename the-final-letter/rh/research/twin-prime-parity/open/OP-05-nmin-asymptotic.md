# OP-5 — RESOLVED: the asymptotic of `n_min(p)`

**Status: SOLVED (leading law, constant, and remainder order), with the recorded guess refuted.**
Script: [`op05_nmin.py`](op05_nmin.py) — reproduces every number below.
Register row: [`07-open-problems.md`](07-open-problems.md) OP-5.
Recorded guess corrected: [`rh42/truths.md:453`](../rounds/rh42/truths.md).

> **Correction (error term).** An earlier revision of this note stated the index form
> with error `O(1/p)` in both `n_min` (1-based) and `nmin` (0-based). **That is false.**
> `nmin p` is an integer and `p/ln 2 − 5/2` is irrational-linear in `p`, so the error
> cannot beat the Diophantine gap: `nmin p − nminAsym p ∈ [0,1)` and
> `p·(nmin p − nminAsym p)` is unbounded. The correct error term is **`O(1)`**, as now
> stated below and as proved in Lean (`Op56.op5_nmin_asymptotic`, restated). The threshold
> form `P_n = (n + 3/2)ln 2 + c/n + O(1/n²)` is unaffected. See
> [`../006/handoff.md`](../006/handoff.md) §5.2 and
> [`../006/verify/op05_nmin_ceiling.py`](../006/verify/op05_nmin_ceiling.py).

> **Correction (the exact ceiling law is FALSE — item O3).** This note and
> `../006/handoff.md` §6.4 previously quoted the *exact* law
> `nmin p = ⌈p/ln 2 − 5/2⌉`. **That is not a theorem: it has counterexamples.** The real
> crossing index is `n_*(p) = p/ln 2 − 3/2 + F(p)` with
> `F(p) = −b/(n_* ln 2) + O(n_*⁻²) > 0`, `b = 3(ln 2)² − (25/12)ln 2 ≈ −2.6976·10⁻³`
> (so `F ≈ 2.698·10⁻³/p`). Hence `nmin p = ⌈p/ln 2 − 5/2⌉` **iff** `1 − {y} > F(p)` with
> `y = p/ln 2 − 3/2`; it fails for the (sparse) continued-fraction denominators of
> `2/ln 2`. First counterexample: the 451-digit
> `p = 1831818673613185754746818686991356738383131544534391214519013360…1508975`, where
> `nmin p = ⌈p/ln 2 − 5/2⌉ + 1` (verified at 1150 dps by
> [`../006/verify/op05_nmin_ceiling_false.py`](../006/verify/op05_nmin_ceiling_false.py)).
> The sharpest true uniform statement is the disjunction
> `nmin p ∈ {⌈p/ln 2 − 5/2⌉, ⌈p/ln 2 − 5/2⌉ + 1}`, equivalently
> `0 < n_*(p) − (p/ln 2 − 3/2) < 1`. See [`../006/handoff.md`](../006/handoff.md) §6.4.

## 1. The theorem

With `n_min(p) = min{ n : ζ(p, n+1) ≥ n^{−p} }` (equivalently `Σ_{k>n}k^{−p} ≥ n^{−p}`, the form
in which rh42 proves the single sign change), and with the **thresholds** `P_n` defined by
`n_min(p) = n ⟺ P_{n−1} < p ≤ P_n`:

```
n_min(p)  =  p/ln 2  −  3/2  +  O(1)          (corrected: was stated O(1/p))

P_n       =  (n + 3/2)·ln 2  +  c/n  +  O(1/n²) ,

c         =  3(ln 2)²  −  (25/12)·ln 2  =  −0.0026975844119484539513…
```

**The recorded guess `n_min(p) ≈ p + O(1)` is false.** The slope is `1/ln 2 = 1.4426950408…`,
not 1: measured `n_min/p = 1.4200, 1.4400, 1.4420, 1.4424` at `p = 50, 200, 1000, 5000`; and
`n_min − p` grows without bound (21, 88, 442, 2212 at those `p`).

## 2. The derivation (Euler–Maclaurin / dual side — the license of PERMISSION 114)

Divide the boundary condition by `n^{−p}`:

```
Φ_p(n) := Σ_{j≥1} (1 + j/n)^{−p}  ≥  1 ,        Φ_p increasing in n,
```

so the threshold is the single equation `Φ_p(n) = 1`. Put `p = a n + g` and expand
`p·log(1+j/n) = a j + C₁/n + C₂/n² + …` with

```
C₁ = g j − a j²/2 ,          C₂ = a j³/3 − g j²/2 .
```

With `x = e^{−a}` and `S_m = Σ_{j≥1} j^m x^j` (`S₁ = 2`, `S₂ = 6`, `S₃ = 26` at `x = 1/2`):

```
Φ − 1 = (1/n) Σ x^j C₁ + (1/n²) Σ x^j (C₂ + C₁²/2) + O(1/n³) .
```

1. **Leading order.** `Σ_{j≥1}x^j = x/(1−x) = 1` forces **`a = ln 2`**.
2. **First correction.** `Σx^j C₁ = a S₂/2 − g S₁ = 3a − 2g`, so vanishing of the `1/n`
   coefficient forces **`g = (3/2)a = (3/2)ln 2`** — i.e. `P_n = (n + 3/2)ln 2 + O(1/n)`.
3. **Second correction.** At `g = 3a/2` the `1/n²` coefficient is
   `D₀ = −(−a S₃/3 + g S₂/2) + (1/2)Σ x^j C₁² = −25a/6 + 6a²`, and since
   `Φ′ = −Σ j x^j /n = −2/n` the threshold shift is `ε = D₀/(2n)`, giving

```
c = D₀/2 = 3a² − (25/12)a = 3(ln 2)² − (25/12)·ln 2 .
```

**A correction to this goal's own premise.** The goal asserted that the naive expansion gives the
wrong constant `3(ln2)/2` instead of `3/2`. That was a **units error of mine**: `3(ln2)/2 = 1.0397`
is the constant in *`p`-units* (i.e. `p = n ln2 + 1.0397`), while `3/2` is the constant in
*`n`-units* (i.e. `P_n = (n+1.5)ln2`). **They are the same statement.** The naive expansion is
correct; the one genuine trap is the `g j²/2` term in `C₂`, whose omission produces
`−26a/3 + 3a²/2 ≈ −2.9` in place of `−0.0054` for `D₀` — a factor 578 too large, exactly the
discrepancy that first looked like a failure of the method.

## 3. Verification (script output)

| `n` | `P_n − (n+3/2)ln 2` | `n × (that)` |
|---|---|---|
| 1000 | −2.70081484198580963·10⁻⁶ | −0.002700814841986 |
| 5000 | −5.39646169101494713·10⁻⁷ | −0.002698230845507 |
| 10000 | −2.69790765044714151·10⁻⁷ | −0.002697907650447 |
| 20000 | −1.34887301831373753·10⁻⁷ | −0.002697746036627 |

Richardson fit of `n·d_n = c + c₁/n` on the last four points:
`c_fit = −0.002697584512` against `c_pred = −0.002697584412` — **agreement to 1·10⁻¹⁰**.

**Remainder order.** `|P_n − ((n+3/2)ln2 + c/n)|` is
`3.230·10⁻⁹, 3.232·10⁻¹¹, 3.233·10⁻¹³, 3.233·10⁻¹⁵` at `n = 10³, 10⁴, 10⁵, 10⁶` — a factor
exactly `10²` per decade of `n`, so the remainder is `O(1/n²)` with coefficient `0.00323`
(finite and stable to four digits over six decades of `n`). **This is where the catch of
PERMISSION 114 is discharged: the truncated side owes an error, and the error is exhibited,
bounded, and stable rather than asserted.**

## 4. The exceptional set of the closed form

`n_min(p) = ⌈p/ln 2 − 3/2⌉` fails exactly on `p ∈ ⋃_n (P_n, (n+3/2)ln 2)`, each component of width

```
(n + 3/2)ln 2 − P_n = −c/n + O(1/n²)  →  +0.0026975844…/n ,
```

verified: ratio to `−c/n` is `1.0119, 1.0012, 1.0001` at `n = 100, 1000, 10000`. This is exactly
the observed pattern — the closed form holds on 20 382 of 20 396 tested `p ∈ [1.729, 20000]`, the
14 exceptions sitting just below `p = (m+3/2)ln 2`.

## 5. The `n = 1` boundary

`P_1` is the root of `ζ(p) = 2`, and the script returns **`1.72864723899818362`**, matching the
programme's own constants `p* = 1.7286472389981836` (`ζ(p*) = 2`) to 18 digits. So the asymptotic
family contains the register's `p*` as its `n = 1` member — an internal consistency check the
recorded guess never had.

### 5b. Why the `O(1/n²)` remainder is controlled (the analytic point)

The exponent truncation is **not** uniformly small in `j` — the coefficient of `n^{−k}` in
`p·log(1+j/n)` is a polynomial in `j` of degree `k+1`, so at `j ~ √n` the `k = 3` term is `O(1/n)`.
The naive "sum the error over the `~√n` such terms" argument would then give only `O(1/√n)`, which is
**not** what happens. The resolution is that the `j`-sum carries the weight `x^j = 2^{−j}`, so the
effective number of contributing terms is `O(1)`, not `√n`: the total error is bounded by a
`C/n³` multiple of the **finite moments** `S₅ = Σ j⁵2^{−j}`, `S₆ = …`, and the terms at `j ~ √n`
carry weight `2^{−√n}`. Hence `Φ − 1` has a genuine `O(1/n³)` remainder, `ε = D₀/(2n) + O(1/n²)`, and
`P_n` has a genuine `O(1/n²)` remainder — matching the measured `0.00323/n²`, stable to four digits
over `n = 10³ … 10⁶`. (The constant in that `O(1/n²)` term is the one quantity not written out here.)

## 6. What this settles in the programme

- OP-5's row: **OPEN → SETTLED** (leading law, constant, remainder order, exceptional set).
- The recorded `rh42/truths.md:453` suggestion `n_min ≈ p + O(1)` is **wrong** and is corrected.
- `n_min` is the exponent in the census law `measure(S_1) = 2^{n_min−1}·T_{n_min}` (rh42 Thm 10),
  which is the whole content of **OP-6** (ranked directly below OP-5). The closed form
  `n_min(p) = p/ln2 − 3/2 + O(1)` can therefore be substituted into that ratio to attack OP-6's
  `2^{n_min−1}`-versus-`T_{n_min}` balance. **That is now the natural next move, and it was
  blocked before this round.**

*Reproduce: `/opt/homebrew/Caskroom/miniforge/base/bin/python3 op05_nmin.py`. Five sections:
slope refutation, threshold law + closed-form constant, `O(1/n²)` bracket, exceptional-set width,
`n = 1` boundary. All independent of the earlier session's ad-hoc computations.*
