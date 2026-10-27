# `open/lean` — Lean 4 formalisation of OP-5 and OP-6

Machine-checked Lean 4 + Mathlib development for the two resolved open problems of
`research/twin-prime-parity/open/`:

* **OP-5** — the asymptotic of the completeness threshold `n_min(p)`:
  `n_min(p) = p/ln 2 − 3/2 + O(1)` (the error term is `O(1)`, **not** `O(1/p)`), thresholds
  `P_n = (n + 3/2)ln 2 + c/n + O(1/n²)`, `c = 3(ln 2)² − (25/12)ln 2`.
* **OP-6** — the exact order of the reachable fraction:
  `measure(S_1)/P(p) = p^{−p} e^{(1+ln ln 2)p}(1+o(1)) → 0`, i.e.
  `L(p) = p ln p − (1 + ln ln 2)p + O(1)`.

Toolchain: Lean `v4.35.0-rc2`, Mathlib at `$HOME/lean/mathlib4` (same as the other
rounds' Lean developments).  No `lake` project file is needed: `check.sh` rebuilds
`LEAN_PATH` from `lake env` inside Mathlib.

## Building

```
cd research/lean
./check.sh --all                 # every module, then the root
./check.sh Op56/Exact.lean       # one module
LEAN_PREFIX=/path/to/lean ./check.sh --all
```

All modules elaborate; `.olean` files are written next to the sources.

## What is proved

`./check.sh --all` is **9/9 green**.  There is **no `sorry` anywhere** in the development.

| file | contents |
|---|---|
| `Op56/Defs.lean` | the alphabet `term p n = (2(n+1))^{−p}`, `budget`, `tailSum`, `IsComplete`, `nmin`, `Phi`, `IsThreshold`, the reachable set, `reachableMeasure`, `reachableFraction`, `L`, and the asymptotic expressions `nminAsym`, `thresholdAsym`, `LAsym` |
| `Op56/Exact.lean` | `term` positive and decreasing; `summable_term` for `p ≥ 2`; the budget split `budget = b_0 + T_1`; `tailSum_succ_le`; `tailSum_ge_first_two`; `log_bound`; `bernoulli` (`1 − p·x ≤ (1+x)^{−p}`); `term_ratio`; `bound_three_halves`; **`exists_isComplete` — the threshold exists, with the explicit witness `N = 4p`**; `nmin_spec`, `nmin_minimal` (both for `p ≥ 2`); `integral_two_mul_rpow` and the (unused, negative-result) `tailSum_integral_lower`, **proved** under its honest hypothesis `N + 2 ≤ M` |
| `Op56/PhiAsymptotic.lean` | the geometrically-dominated asymptotics of `Phi`: the log bounds, the two-sided term comparison, summability, the **integral-comparison tail bound** (`sum_rpow_tail_le`, `phi_tail_le`, `nat_le_two_rpow_half`, `phi_tail_le_div`), the **finite part** (`phi_term_diff_le`, `phi_finite_le`), `hasSum_exp_neg`, `geometric_le_Phi`, and the main **`Phi_asymptotic`**: `∃ C > 0, ∀ n ≥ 4, ∀ u ∈ [1/2,1], \|Phi_{un}(n) − (exp u − 1)⁻¹\| ≤ C/n`. **No `sorry`.** |
| `Op56/Census.lean` | `reachableSum`; `census_measure_eq` (the census identity, by construction of `reachableMeasure`); `census_ratio` |
| `Op56/Asymptotic.lean` | **all three asymptotic theorems PROVED, 0 `sorry`**: `op5_threshold_asymptotic`, `op5_nmin_asymptotic` (restated with the correct `O(1)` error term) and `op6_reachable_fraction`; also **`leadingCoeff_forced`** (the leading rate of OP-5 is *forced* — `Σ_{j≥1}x^j = 1` has the unique solution `x = 1/2`, i.e. the exponent rate is `log 2`), **`op5_threshold_leading`** and **`op5_threshold_second_order`** |
| `Op56/FloorAsymptotic.lean` | the **floor/Diophantine meta-theorem** (TODO O11): `no_index_asymptotic_error` — an integer index cannot track an irrational affine function `α·p + β` to within `O(1/p)` — plus its `ℕ`-valued form `no_index_asymptotic_error_nat`, the packaged form `irrational_not_eventually_error_inv`, and the concrete instances `log_two_inv_no_index_asymptotic` / `nmin_error_not_bigO_inv` (`α = 1/log 2`, `β = −5/2`).  **0 `sorry`**; axioms `[propext, Classical.choice, Quot.sound]`.  The `log 2` instances assume `Irrational (Real.log 2)` (Lindemann–Weierstrass — not in Mathlib) explicitly. |
| `Op56.lean` | root module |

### The `N = 4p` existence proof (the last gap that was closed)

Writing `t₁ = term p (4p+1)` and `t₂ = term p (4p+2)`:

* `tailSum_ge_first_two`: `t₁ + t₂ ≤ T_{4p+1}`;
* `term_ratio p (4p)`: `t₂ = t₁·(1 + 1/(4p+2))^{−p}`, and `bernoulli` gives
  `t₂/t₁ ≥ 1 − p/(4p+2) ≥ 2/3` for `p ≥ 0`;
* `term_ratio p (4p−1)` plus `bound_three_halves`:
  `b_{4p}/t₁ = (1 + 1/(4p+1))^p ≤ 3/2`;

hence `b_{4p} ≤ (3/2)t₁ ≤ t₁ + t₂ ≤ T_{4p+1}`, i.e. `IsComplete p (4p)`.  The three
lever-arch facts (`3/2`, `2/3`, `3/2 ≤ 5/3`) were each verified numerically for
`p = 2 … 1000` before formalisation, and the sharp bound `(1+1/(4p+1))^p ≤ 3/2` is
proved by `p·log(1+1/(4p+1)) ≤ p/(4p+1) ≤ 1/4 < log(3/2)`.

### The `Phi` asymptotics (`Op56/PhiAsymptotic.lean`)

The threshold has `p/n → log 2`, so `p` and `n` are *comparable* (`n ≈ p/log 2`), and the
summands `(1+(j+1)/n)^{-p}` decay by a factor `→ 1/2`.  **Euler–Maclaurin is therefore
neither available in Mathlib nor the right tool** (its series diverges here) — an earlier
note in this repository misdiagnosed the gap as needing it.  The proved route is:

* **tail**: the ratio `(1+1/(n+k))^{-un} → 1`, so the tail decays *polynomially*; it is
  bounded by an integral, `AntitoneOn.tsum_comp_add_le_integral` +
  `integral_Ioi_rpow_of_lt`, giving `≤ n·2^{1-un}/(un-1)`, then `n ≤ 2^{n/2}` gives `8/n`;
* **finite part**: `T_k − e^{-uk} ≤ u k² e^{-uk/2}/(2n)`, summed against
  `tsum_sq_mul_geometric_of_norm_lt_one`;
* **assembly** with `hasSum_exp_neg`, `geometric_le_Phi`, `tsum_sub`,
  `sum_add_tsum_nat_add`.

### The threshold bridge

`Op56/PhiAsymptotic.lean` also proves `threshold_scaling`: if `Phi_{un}(n) = 1` with
`u ∈ [1/2,1]`, then `|u − log 2| ≤ 2·PhiC/n` (via the log-Lipschitz bound
`|log x − log 2| ≤ |x − 2|` for `x ≥ 1`).  Hence the OP-5 threshold index satisfies
`P_n = n·log 2 + O(1)` — this is `op5_threshold_leading` in `Op56/Asymptotic.lean`, the
leading term of `thresholdAsym`.

**On `p < 2`:** the half-series diverges there, Mathlib's `tsum` is `0`, and
`IsComplete p N` is *false* for every `N`; the all-`p` statement is therefore not
provable as written.  `exists_isComplete_all` takes `2 ≤ p`, and `nmin` is made total
by a junk value `0` outside that range (`nmin_spec`/`nmin_minimal` both require `2 ≤ p`).

## The floor-asymptotic meta-theorem (TODO O11, `Op56/FloorAsymptotic.lean`)

`op5_nmin_asymptotic` gives the error term `O(1)`; `Op56/FloorAsymptotic.lean` proves the
error term **cannot be improved to `O(1/p)`** — and isolates the reason, which is purely
Diophantine and needs no input from `Phi` or the census law:

> **`no_index_asymptotic_error`.**  If `α` is irrational, `β : ℝ`, `n : ℕ → ℤ`, `C : ℝ`,
> `P : ℕ` and `|n p − (α p + β)| ≤ C / p` for every `p ≥ P`, then `False`.

The proof is elementary and uses **no** density/equidistribution input.  Comparing the
hypothesis at `p` and `p + 1`:

    |(n (p+1) − n p) − α| ≤ C/(p+1) + C/p ≤ 2|C|/p ,

and the left side is `|z − α|` for the **integer** `z = n (p+1) − n p`.  Since the
right side is `o(1)`, those integers are eventually constant, equal to some `z`; squeezing
the same bound against arbitrarily large `p` gives `α = z`, so `α` is rational — a
contradiction.  (`C` is not required to be nonnegative: the argument runs with `|C|`.)

Consequences formalised alongside:

* `no_index_asymptotic_error_nat` — the `ℕ`-valued form;
* `irrational_not_eventually_error_inv` — `¬ ∃ C P, ∀ p ≥ P, |n p − (α p + β)| ≤ C/p`;
* `log_two_inv_no_index_asymptotic` — the instance `α = 1/log 2` with arbitrary `β`;
* `nmin_error_not_bigO_inv` — the OP-5 instance (`α = 1/log 2`, `β = −5/2`, against `nmin`
  and `nminAsym`): `|nmin p − nminAsym p| ≤ C/p` on a tail is impossible.

**Hypothesis kept explicit.**  `Irrational (Real.log 2)` is Lindemann–Weierstrass
(`exp (log 2) = 2` is algebraic and `≠ 0, 1`); Mathlib `v4.35.0-rc2` formalises only the
*analytic part* of Lindemann–Weierstrass
(`Mathlib/NumberTheory/Transcendental/Lindemann/AnalyticalPart.lean`), not the
transcendence conclusion, so the `log 2` instances take it as a hypothesis and transport it
to `1/log 2` by `Irrational.inv`.  The general meta-theorem is unconditional.

## The former `sorry` — now proved

There are **no `sorry`s left** in the development. The last one was
`tailSum_integral_lower`, and it was discharged by **repairing the statement**:

| theorem | statement | status |
|---|---|---|
| `tailSum_integral_lower` | `T_{N+1} ≥ (2M)^{-p}·M/(p−1)` for **`M ≥ N+2`** | **PROVED** (0 `sorry`). The bound is a documented *negative result* — too lossy to prove existence, since at the threshold it is `≈0.73·b_N < b_N` (checked `p=2,5,10,50,100`): the integral discards the discrete mass `T_{N+1} ≈ 2b_{N+1}`. It is used nowhere. |

The original hypothesis was **`N + 1 ≤ M`, and that statement is false** — at
`M = N+1` the sum misses the term at `k = M`. Witness: `p = 2`, `N = 0`, `M = 1` gives
left side `0.25` while `tailSum 2 1 = 0.16123…`. The correction is `M ≥ N+2` (the
integral test has to be applied at test-index `N+2`, because `f(n + (N+2)) = term p (N+1+n)`).
The supporting helper `integral_two_mul_rpow`
(`∫_{Ioi M} (2x)^{-p} = (2M)^{-p}·M/(p−1)`) is also proved, via
`MeasureTheory.integral_comp_mul_left_Ioi` + `integral_Ioi_rpow_of_lt`.

`op5_threshold_asymptotic`, `op5_nmin_asymptotic` and `op6_reachable_fraction` were
**subsequently proved** (they were `sorry`-stated in an earlier revision of this
development); the earlier note that `op5_nmin_asymptotic` had error `O(1/p)` was
**false** and the theorem is now stated with the correct `O(1)` error.  `exists_isComplete_all`
also has no `sorry` (it takes `2 ≤ p`; see the `p < 2` note below).

**No `axiom` is declared anywhere, and no `native_decide` either.**  Item `O2` replaced the
two `interval_cases j <;> native_decide` steps in `Op56.tsum_pow6_exp_neg_half_le`
(`Op56/PhiThird.lean`) by `interval_cases j <;> norm_num [Nat.stirlingSecond]` /
`[Nat.factorial]`, so every probed theorem — the three headline theorems included — now has
`#print axioms` exactly `[propext, Classical.choice, Quot.sound]`.

## How the asymptotics are proved here

An earlier revision of this file (and of `Op56/Asymptotic.lean`) attributed the gap to
"Euler–Maclaurin for the Hurwitz tail at `p ≫ n`".  That diagnosis was **wrong**: at the
threshold `p/n → log 2`, so `p` and `n` are *comparable*, and Euler–Maclaurin is both
absent from Mathlib and the wrong tool (its series diverges here).  The route actually
used is the geometric comparison `G_k ≤ T_k ≤ G_k e^{uk²/(2n)}` plus elementary Taylor
bounds on `log(1+x)`, refined to third order in `Op56/PhiThird.lean`.  See
`../../006/handoff.md` §7 for the technique notes.

## Numeric cross-check

The numeric content of the two asymptotic theorems is verified independently to ten
significant figures by the Python ground truth in the parent directory:

* `../op06_reachable_fraction.py` — exact census values, the linear coefficient
  `−(1 + ln ln 2) = −0.633487079419` matching `(L − p ln p)/p` to ten figures at
  `p = 10⁶`, and the `1/p` coefficient `−0.540509640658` stable to twelve figures over
  `p = 10⁹…10¹³`.
* `../op05_nmin.py` — the OP-5 thresholds and the closed-form constant `c`.

## Layout

| file | contents |
|---|---|
| `Op56/Defs.lean` | definitions (no proofs) |
| `Op56/Exact.lean` | exact layer, proved up to the integral test |
| `Op56/PhiAsymptotic.lean` | the geometrically-dominated asymptotics of `Phi`: the log bounds, the two-sided term comparison, summability, the **integral-comparison tail bound** (`sum_rpow_tail_le`, `phi_tail_le`, `nat_le_two_rpow_half`, `phi_tail_le_div`), the **finite part** (`phi_term_diff_le`, `phi_finite_le`), `hasSum_exp_neg`, `geometric_le_Phi`, and the main **`Phi_asymptotic`**: `∃ C > 0, ∀ n ≥ 4, ∀ u ∈ [1/2,1], \|Phi_{un}(n) − (exp u − 1)⁻¹\| ≤ C/n`. **No `sorry`.** |
| `Op56/Census.lean` | census structure |
| `Op56/Asymptotic.lean` | OP-5 / OP-6 asymptotic theorems — **all three proved, 0 `sorry`** |
| `Op56/FloorAsymptotic.lean` | the floor/Diophantine meta-theorem (O11) — `O(1/p)` error is impossible against an irrational linear threshold |
| `Op56.lean` | root |
| `check.sh` | elaboration script |
