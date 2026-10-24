# HANDOFF — OP-5/OP-6 Lean formalisation

**Goal id** `goal-d9748f8a-fc76-416d-a7a4-5382f4d1f4e9`
**Revision** 3 · **Phase** paused · **Activation** disarmed · **Rounds started** 40 / 200
**Workspace** `/Users/victor/workspace/rh`
**Primary directory** `research/twin-prime-parity/open/lean/`

> **STATUS (added after round 13.680; updated after the OPTODO passes — supersedes
> §6, §7, §8 and §13.681 below).**
> The objective is **achieved**.  All three theorems of `Op56/Asymptotic.lean` —
> `op5_threshold_asymptotic`, `op5_nmin_asymptotic` (restated with the correct `O(1)`
> error term) and `op6_reachable_fraction` — are **proved**; `./check.sh --all` is
> **9/9 green** (the development has since grown `FloorAsymptotic.lean` and
> `PhiFourth.lean`); there is **no `axiom` declaration** and **no `native_decide`**;
> and the development contains **no `sorry` anywhere**.  The last `sorry`,
> `tailSum_integral_lower` (`Op56/Exact.lean`), was discharged by repairing its
> hypothesis to `N + 2 ≤ M` and proving it (the as-written `N + 1 ≤ M` form is false).
> The former `native_decide` footprint of `Op56.tsum_pow6_exp_neg_half_le` was removed
> in item `O2`.  §6–§8 record the state *before* the final rounds
> and are retained as history; the authoritative current account is the `006` round's
> `handoff.md`.

---

## 1. The objective, verbatim

> Write and prove in Lean 4 + Mathlib the geometrically-dominated asymptotic expansion of
> `Phi_p(n) = Σ'_j (1 + (j+1)/n)^{-p}` in the critical scaling `p = u*n` with `u ∈ [1/2, 1]`,
> namely `|Phi_{un}(n) - (exp u - 1)^{-1}| ≤ C/n` for an explicit constant C. This replaces the
> misdiagnosed "Euler–Maclaurin for the Hurwitz tail at p ≫ n" obstruction (Euler–Maclaurin is
> both absent from Mathlib and the wrong tool here, since the summands decay like 2^{-j}).
> Deliverable: a new file `Op56/PhiAsymptotic.lean` that compiles under `./check.sh`, containing
> the term-wise comparison lemmas (`exp(-uk) ≤ (1+k/n)^{-un} ≤ exp(-uk + u k²/(2n))`), the
> geometric-sum identity `Σ'_{k≥1} exp(-uk) = (exp u - 1)^{-1}`, the finite/infinite split with
> the geometric tail bound, and the resulting `O(1/n)` theorem; then wire it into
> `Op56/Asymptotic.lean` as the missing input for `op5_threshold_asymptotic` /
> `op5_nmin_asymptotic` / `op6_reachable_fraction`, update the README, and keep
> `./check.sh --all` green with no axiom.

---

## 2. TL;DR state

| Part of the objective | Status |
|---|---|
| New file `Op56/PhiAsymptotic.lean` under `./check.sh` | ✅ |
| Term-wise comparison lemmas | ✅ `exp_neg_mul_le_rpow`, `rpow_le_exp_neg_add` |
| Geometric-sum identity `Σ'_{k≥1} e^{-uk} = (e^u−1)^{-1}` | ✅ `hasSum_exp_neg` |
| Finite/infinite split + geometric tail bound | ✅ `sum_rpow_tail_le`, `phi_tail_le`, `geometric_le_Phi` |
| Resulting `O(1/n)` theorem, explicit `C` | ✅ `Phi_asymptotic_explicit` (`C = PhiC`), `Phi_asymptotic` |
| README updated | ✅ |
| `./check.sh --all` green, no axiom | ✅ 6/6 |
| Wire into `Asymptotic.lean` for the three named theorems | ⚠️ **partial** |

**The deliverable is complete.** What is *not* complete is the wiring: of the three named
theorems, none is fully proved, but two *new* theorems were proved in `Asymptotic.lean` on the
way (see §5).

```
./check.sh --all   →  6/6 OK
axioms             →  none anywhere
PhiAsymptotic.lean →  67 declarations, 0 sorries        <-- the deliverable
Asymptotic.lean    →   8 declarations, 3 sorries
Exact.lean         →  22 declarations, 1 sorry (documented negative result)
Defs / Census      →  11 / 3 declarations, 0 sorries
```

---

## 3. How to build and verify

There is **no `lake` project file**. The build is a script:

```bash
cd research/twin-prime-parity/open/lean
./check.sh --all          # all modules
./check.sh Op56/PhiAsymptotic.lean   # one module
```

Internals of `check.sh` (needed for scratch files):

```bash
LEAN_BIN="$HOME/lean/elan/toolchains/leanprover--lean4---v4.35.0-rc2/bin/lean"
BASE=$(cd $HOME/lean/mathlib4 && ELAN_HOME=$HOME/lean/elan $HOME/lean/elan/bin/lake env printenv LEAN_PATH)
LEAN_PATH="$BASE" "$LEAN_BIN" /tmp/scratch.lean
```

Toolchain: Lean 4 `v4.35.0-rc2`, Mathlib at `$HOME/lean/mathlib4`.
Convention: **never `axiom`**. Documented `sorry`s are tolerated in `Exact.lean` /
`Asymptotic.lean` but the deliverable file is kept at **0 sorries at every round boundary** —
if a lemma does not compile, it is removed rather than left with `sorry`.

---

## 4. File map

```
research/twin-prime-parity/open/lean/
  check.sh                       build script (--all lists Defs Exact Census PhiAsymptotic Asymptotic Op56)
  README.md                      module table + OP-5/OP-6 status rows
  Op56/Defs.lean        (11 decl) term budget tailSum IsComplete Phi IsThreshold IsReachable
                                  reachableSet nminAsym thresholdAsym LAsym
  Op56/Exact.lean       (22 decl) discrete/structural layer; 1 documented sorry
  Op56/Census.lean      ( 3 decl) census_measure_eq, census_ratio
  Op56/PhiAsymptotic.lean (67 decl) *** THE DELIVERABLE ***
  Op56/Asymptotic.lean  ( 8 decl) the asymptotics statements
  Op56.lean                      umbrella import
research/twin-prime-parity/open/
  OP-05-nmin-asymptotic.md       the OP-5 derivation (contains c = 3ln²2 − (25/12)ln2 …)
  OP-06-reachable-fraction.md
  op05_nmin.py  op06_reachable_fraction.py   numerical checks
  RESULTS.html                   companion results document (written at handoff)
```

### Key objects (`Defs.lean`)

```lean
def term (p n : ℕ) : ℝ := (2 * ((n : ℝ) + 1)) ^ (-(p : ℝ))          -- b_n, 0-based
def budget (p : ℕ) : ℝ := ∑' n, term p n                             -- P(p) = 2^{-p} ζ(p)
def tailSum (p N : ℕ) : ℝ := ∑' n, term p (N + n)                    -- T_N
def IsComplete (p N : ℕ) : Prop := term p N ≤ tailSum p (N + 1)      -- Brown's criterion
def Phi (p : ℝ) (n : ℕ) : ℝ := ∑' j, (1 + (((j:ℝ)+1) / n)) ^ (-p)   -- 1-based n
def IsThreshold (n : ℕ) (p : ℝ) : Prop := Phi p n = 1
def nminAsym (p : ℕ) : ℝ := (p:ℝ) / Real.log 2 - 5/2
def thresholdAsym (n : ℕ) : ℝ :=
  ((n:ℝ) + 3/2) * Real.log 2 + (3*(Real.log 2)^2 - (25/12)*Real.log 2) / n
def LAsym (p : ℕ) : ℝ := (p:ℝ) * Real.log p - (1 + Real.log (Real.log 2)) * (p:ℝ)
```

---

## 5. What is proved

### 5.1 The deliverable (`PhiAsymptotic.lean`, 67 declarations, 0 sorries)

```lean
theorem Phi_asymptotic_explicit (n : ℕ) (hn : 4 ≤ n) (u : ℝ) (hu1 : 1/2 ≤ u) (hu2 : u ≤ 1) :
    |Phi (u * n) n - (Real.exp u - 1)⁻¹| ≤ PhiC / n

theorem Phi_asymptotic :
    ∃ C, 0 < C ∧ ∀ n, 4 ≤ n → ∀ u, 1/2 ≤ u → u ≤ 1 →
      |Phi (u * n) n - (Real.exp u - 1)⁻¹| ≤ C / n
```
with the **explicit** constant
`PhiC := (∑' k, k² * exp(-k/4)) / 2 + 8` (`PhiC`, `PhiC_pos`).

### 5.2 Extensions beyond the objective, all proved

```lean
theorem threshold_scaling      -- |u − log 2| ≤ 2·PhiC/n at the threshold
theorem Phi_second_order       -- |Φ_{un}(n) − (e^u−1)⁻¹ − (u/2n)ΦS(u)| ≤ C/n²
theorem Phi_second_order_uniform
theorem threshold_second_order        -- u = log 2 + (3 log 2)/(2n) + O(1/n²)
theorem threshold_second_order_uniform
```

and in `Asymptotic.lean`:

```lean
theorem op5_threshold_leading        -- P_n = n·log 2 + O(1)                 [PROVED]
theorem op5_threshold_second_order   -- P_n = (n + 3/2)·log 2 + O(1)        [PROVED, NEW]
theorem op5_threshold_asymptotic     -- P_n − thresholdAsym n = O(1/n²)     [sorry]
theorem op5_nmin_asymptotic          -- nmin p − nminAsym p = O(1/p)        [sorry]
theorem op6_reachable_fraction       -- L p − LAsym p = O(1)                [sorry]
```

`op5_threshold_second_order` is the concrete payoff: it is the "wiring" the objective asks for,
and it rests entirely on `threshold_second_order_uniform` applied at `u = Pfun n / n`.

### 5.3 Reference constants (all proved)

| quantity | value | lemma |
|---|---|---|
| `Σ k² 2^{−k}` | 6 | `PhiS_log_two` |
| `Σ k³ 2^{−k}` | 26 | `tsum_cube_half` |
| `Σ k⁴ 2^{−k}` | 150 | `tsum_four_half` |

These produce the `(3/2)·log 2` threshold constant (`½ · 6/2 · log 2`) and are the inputs to the
third-order term `D(u)`.

---

## 6. What is NOT proved, and exactly why

### 6.1 The three `sorry` theorems in `Asymptotic.lean`

**`op5_threshold_asymptotic`** — needs the **third-order** term of `Φ`. This is the single
biggest remaining piece. The mathematics is settled and numerically verified (§7).

**`op5_nmin_asymptotic`** — needs (a) the inversion above, and (b) the identification of the
Brown threshold `IsComplete` with the `Φ`-threshold `IsThreshold`. `nmin_spec` and
`nmin_minimal` already exist in `Exact.lean`; the bridge between the two threshold notions does
not.

**`op6_reachable_fraction`** — OP-5 composed with the census law, which is already proved
(`Census.lean`, `census_ratio`). Blocked on OP-5.

### 6.2 `Exact.lean` — `tailSum_integral_lower` (1 documented sorry)

This is a **negative result kept deliberately**: the antitone integral test is *insufficient* to
prove completeness, because the integral discards the discrete mass
`T_{N+1} ≈ 2 b_{N+1}`. Existence was proved discretely instead (`exists_isComplete`, witness
`N = 4p`; note `N = 3p` does **not** work — the chain would need `3/2 ≤ 1`). The sorry is used
nowhere.

### 6.3 Retraction recorded

The notes originally attributed the obstruction to "Euler–Maclaurin for the Hurwitz tail at
`p ≫ n`". This is **wrong**. At the threshold `p/n → log 2`, so `p` and `n` are comparable;
`Euler–Maclaurin` is both absent from Mathlib and the wrong tool. The correct route — used
throughout this development — is the geometric comparison `G_k ≤ T_k ≤ G_k e^{uk²/(2n)}` plus
elementary Taylor bounds on `log(1+x)`. The file headers and README record this.

---

## 7. The exact remaining work, in order

### Step 1 — `Phi_third_order`

Target:
```lean
theorem Phi_third_order (u : ℝ) (hu1 : 1/2 ≤ u) (hu2 : u ≤ 1) :
    ∃ C, 0 < C ∧ ∀ᶠ n, ∀ u ∈ [1/2,1],
      |Phi (u*n) n - (Real.exp u - 1)⁻¹ - u/(2n)*PhiS u - D u / n²| ≤ C/n³
```
with
```lean
D u = -(u/3) * PhiK3u u + (u^2/8) * PhiK4u u
PhiK3u u = ∑' k, k^3 * exp (-(u*k))
PhiK4u u = ∑' k, k^4 * exp (-(u*k))
```

**Numerically verified** (mpmath, 40 dps). At `u = log 2`: `ΦS = 6`, `ΦK₃ = 26`, `ΦK₄ = 150`,
`D = 3.001218446`, and the residual `E = Φ − (e^u−1)^{-1} − (u/2n)ΦS − D/n²` satisfies
`E·n³ → 4.34` (n = 50…800). Same check at `u = 0.6` (`D = 4.628202025`, `E·n³ → 7.73`) and
`u = 0.8` (`D = 1.951450263`, `E·n³ → 2.45`).

**Ingredients already landed** (rounds 35–40):
- `log_one_add_ge_quartic`, `log_one_add_le_cubic` → `phi_r_bounds`:
  `0 ≤ x − log(1+x) − x²/2 + x³/3 ≤ x⁴/4`
- `exp_ge_quad`, `abs_exp_sub_one_sub_le`, `abs_exp_sub_one_sub_sub_sq_le`
- `phi_d_bounds`: `0 ≤ d ≤ u(j+1)²/(2n)` for `d = un(x − log(1+x))`
- `tsum_cube_half = 26`, `tsum_four_half = 150`

**What is missing**, in order:
1. `phi_term_sharp3` — the term-wise third-order bound. Decomposition:
   ```
   T − G − G(y − z + y²/2) = G·[(e^d − 1 − d − d²/2) + (eps − yz + z²/2 + eps(y−z) + eps²/2)]
   |T − G − G(Y)| ≤ exp(−uk/2)·(k⁴+k⁵+k⁶+k⁷+k⁸)/n³
   ```
   with `y = ux²·n/2`, `z = ux³·n/3`, `eps = d − y + z`, `0 ≤ eps ≤ u k⁴/(4n³)`.
   The `G·exp d = T` cancellation (see §9) is what keeps the `exp d` term from blowing up.
2. `phi_finite_sharp3` — sum over `j < n` against `Σ k^m e^{−k/2}`.
3. Tail bounds at rate `n^{−3}` for `Σ_{k>n} k^m e^{−uk}`, `m = 2, 3, 4`
   (tighten `phi_S_tail_bound`, whose current bound is `1/n²`).
4. `PhiK3u`, `PhiK4u` definitions + summability + `tsum_cube_half`/`tsum_four_half` as the
   `u = log 2` values.
5. Assembly, then the **inversion** to
   `u = log 2 + (3 log 2)/(2n) + c/n² + O(n⁻³)`,
   which yields `op5_threshold_asymptotic` with the stated
   `c = 3(log 2)² − (25/12) log 2 ≈ −0.0026975844`.
6. Uniformity for the whole third-order layer, by the §9 pattern.

**Estimated**: 10–15 rounds of the same kind of work.

### Step 2 — the `nmin` ↔ threshold bridge (**a task in its own right: Brown's criterion**)

**Task — Brown's criterion.** Relate `IsComplete p N` (Brown's criterion, `term p N ≤ tailSum p (N+1)`)
to `IsThreshold n p` (`Φ_p(n) = 1`). Both are index-crossings of comparable quantities; the
relationship should be `nmin p ≈ n_threshold(p) − 1` up to `O(1)`.

> **Connecting `nmin` to the `Φ`-threshold is the remaining bridge.**

This is a distinct task from the third-order expansion (Step 1): Step 1 gives the asymptotic of
the `Φ`-threshold, whereas this task is what transfers it to `nmin` / Brown's criterion. The
pieces already in place on the Brown side are `nmin_spec`, `nmin_minimal`, `exists_isComplete`
(witness `N = 4p`) and `term_ratio` / `bound_three_halves` in `Op56/Exact.lean`; what does not
exist is the equivalence (or the two-sided comparison) between the two threshold notions.
Once it is available, `op5_nmin_asymptotic` follows from Step 1 by the same
inversion-plus-uniformity pattern used for `op5_threshold_second_order`.

### Step 3 — OP-6 composition

Combine OP-5 with `census_ratio` (`Census.lean`) to get `L p − LAsym p = O(1)`.

### Verification scripts to re-run

```bash
cd research/twin-prime-parity/open
python3 op05_nmin.py                 # reproduces the write-up §3 expansion to 1e-10
python3 op06_reachable_fraction.py   # constant −(1 + log log 2) to ten figures
```
plus the two inline mpmath checks described in §7 Step 1 (threshold comparison; `D(u)` check).

---

## 8. Definition of done

`./check.sh --all` green **and** `op5_threshold_asymptotic`, `op5_nmin_asymptotic`,
`op6_reachable_fraction` all proved with no `sorry`, no `axiom`. At that point this goal can be
marked complete. Until then it stays open (currently paused).

---

## 9. Lean / Mathlib gotchas discovered (high-value, hard-won)

These cost many rounds; do not rediscover them.

### 9.1 Absences in Mathlib

| Missing | Workaround |
|---|---|
| Euler–Maclaurin, `summationByParts` | not needed — geometric comparison |
| `abs_tsum_le_tsum_abs` | prove **one-sided** bounds `f ≤ g` and `g ≤ f` separately, combine via `abs_le` |
| `summable_of_nonneg_of_le` | route through an explicit closed form, or `Summable.mul_right` |
| `le_or_lt` | use `le_total` |
| `Real.exp_le_one_iff` | `rw [← Real.exp_zero]; exact Real.exp_le_exp.mpr …` |
| `tsum_cube_mul_geometric_of_norm_lt_one` | use the general `tsum_pow_mul_geometric_of_norm_lt_one k` (Stirling numbers), then `simp only [Finset.sum_range_succ, Finset.sum_range_zero, Nat.stirlingSecond, Nat.factorial]` and `norm_num` |
| `Real.log_one_add_ge` (name) | in this file it is `log_one_add_ge` (namespace `Op56`) |

### 9.2 Tactic traps, with fixes

- **`rw […]; ring` where `field_simp` already closed the goal** → `No goals to be solved`.
  Use `try ring`, or drop the trailing `ring`.
- **`linarith` will not chain `A ≤ B`, `B = C`, `C ≤ D`** → `h1.trans ((le_of_eq h2).trans h3)`.
- **`linarith` will not lift `a ≤ b` through `×32`** → supply `mul_le_mul_of_nonneg_left h (by norm_num)`.
- **`linarith` cannot do `C ≤ C*n` from `1 ≤ n`, `C > 0`** → `mul_le_mul_of_nonneg_left h1n hCpos.le`.
- **`linarith` cannot mix ℕ and ℝ comparisons** → `exact_mod_cast` first.
- **`positivity` does not consult hypotheses.** `0 ≤ PhiK3` in context does *not* let
  `positivity` prove `0 < 8*(PhiK3+1)`. Use `by linarith [PhiK3_nonneg]`.
- **`positivity` cannot prove `0 < (1-r)^3`** even with `0 < 1-r` in context →
  `pow_pos h1e 3`.
- **`nlinarith` cannot lift an inequality through `^3`** → `pow_le_pow_left₀`.
- **`div_le_iff₀`'s first argument is `0 ≤ c`, not `0 ≤ a`** — `div_le_div₀` takes
  `(0 ≤ c) (a ≤ c) (0 < d) (d ≤ b)` in that order.
- **`rw [div_le_iff₀]` does not fire when the division is on the *right*** (`X ≤ 1/n²`);
  use `le_div_iff₀` or rewrite the shape first.
- **`HasDerivAt` has a typeclass diamond** (`Real.normedAddCommGroup.toAddCommGroup` vs
  `Real.instAddCommGroup`): an *ascribed* `HasDerivAt` type will not unify with one produced by
  `(hasDerivAt_id y).pow 2 |>.const_mul c`. **Do not ascribe the type.** Use `convert h using 1`
  with `ext s; rw [Pi.pow_apply, id_eq]` (add `try ring`) for the function goal, and
  `simp only [id_eq]; push_cast; ring` for the value goal.
- **The function equality under `deriv` needs an explicit `rfl`**:
  ```lean
  have hfun : (fun t => …poly…) + (Real.log ∘ HAdd.hAdd 1) = (fun t => …poly… + Real.log (1+t)) := rfl
  ```
  `simp only [Pi.add_apply, Function.comp_apply]` and `ring` both fail here; `rfl` sees it
  because those are definitional.
- **`set` variables are opaque to `ring_nf`** — need `rw [hk]` first.
- **`MonotoneOn` application leaves beta-redexes**: `h : (fun s => …) 0 ≤ (fun s => …) t` and
  `linarith` cannot see through them. Use `simp only at h` then `rw [Real.exp_zero] at h`.
- **`field_simp` needs the `≠ 0` hypothesis in context** (`have hn0 : (n:ℝ) ≠ 0 := ne_of_gt hnR`).
- **`rw [← Real.exp_log …]` rewrites *every* occurrence of the numeral** — including the `2` in
  `1/2`. Use `calc … = 2 := Real.exp_log …` instead.
- **`monotoneOn_of_deriv_nonneg` needs `convex_Ici 0` / `convex_Icc a b`**, and the derivative
  hypothesis on `interior`, extracted with `interior_Ici` / `interior_Icc` then
  `Set.mem_Ioi.mp` / `Set.mem_Ioc.mp`.
- **`Real.exp_bound`'s RHS is `|x|^n * (n.succ/(n! * n))`**, not a literal; normalise with
  `norm_num [Nat.factorial]` inside a `calc`.

### 9.3 Mathematical traps (not Lean, but easy to get wrong)

- **The `exp d` factor is harmless**: `G_k · exp d = T_k` *exactly*. Writing `G_k · exp y`
  instead produces a bound that blows up — this cost a round.
- **`n ≥ 16` is not enough** for `16/n ≤ 1/2`; needs `n ≥ 32`.
- **The sign in the threshold decomposition**: `1 − (e^u−1)^{-1} = (u/2n)ΦS(u) + ε`, **plus**,
  not minus. The minus version is off by `2(1 − (e^u−1)^{-1})`.
- **`N = 3p` fails** for `exists_isComplete`; `N = 4p` works (margin 1.5 vs 1.28).

---

## 10. Technique notes: what worked, what did not

**What worked, repeatedly (landed first try):**

1. **Closed-form + monotonicity ⇒ uniformity is free.** Rounds 28–32 uniformised five lemmas
   with no `tsum_le_tsum` and no summability, by keeping the `u`-dependence inside an *explicit
   closed form* that is monotone in `u` (`n·2^{1−un}/(un−1)`, `e^{−un}/(1−e^{−u})`,
   `8ΦK₃n²e^{−un}`) and replacing one `eventually_pow_four_exp_le u hu1 c` with
   `eventually_pow_exp_le_uniform k c (1/2)` plus `e^{−un} ≤ e^{−n/2}`.
   The `eventually_pow_exp_le_uniform` statement is the key shape: `∀ᶠ n, ∀ v ≥ v₀, …`, obtained
   by `filter_upwards [h0] with n hn` then `intro v hv`.
2. **Extract-and-transform for uniformity of long proofs.** Rounds 33's
   `Phi_second_order_uniform` and `threshold_second_order_uniform` were produced by copying the
   existing block and applying four textual substitutions (`theorem … (u) …` →
   `theorem …_uniform : … ∀ u, …`; `filter_upwards [f u hu1 hu2, …]` → `…_uniform, …` plus
   `intro u hu1 hu2`; rebind `hTt → hTt'`, `hB → hB'`), not by retyping. Both compiled first
   try.
3. **Incremental landing (option B).** The 200-line threshold inversion failed repeatedly in
   round 22; split into five sub-lemmas (rounds 23–26) it landed, and the split immediately
   exposed a real error (`n ≥ 16` should be `n ≥ 32`) that the monolith had hidden.
4. **Keep `./check.sh --all` green at every boundary.** If a lemma does not compile after a
   round of iteration, *remove it* and report; do not leave `sorry` in the deliverable file.

**What did not work:**

- Attempting a large new lemma as one block (round 22's inversion, round 39's `phi_term_sharp3`).
- Reaching for the derivative machinery when a first-order Mathlib inequality exists
  (`Real.one_sub_inv_le_log_of_pos` replaced a whole `monotoneOn_of_deriv_nonneg` argument in
  round 19).
- Order-of-magnitude guesswork without numerics — round 27's mistaken belief that
  `thresholdAsym`'s `c` was wrong was resolved only by an mpmath check.

---

## 11. Session history (40 rounds, condensed)

| Rounds | Outcome |
|---|---|
| 1–4 | OP-06 note + script; `PhiAsymptotic.lean` created; `Phi_asymptotic` (+ explicit form) proved; README; register updates. **Deliverable complete.** |
| 5–9 | Second-order layer: `log_one_add_le_cubic`, `abs_exp_sub_one_sub_le`, `phi_term_sharp`, `phi_finite_sharp`. |
| 10–16 | `eventually_pow_four_exp_le`, `tsum_three_shift_*`, `phi_S_tail_bound`, `phi_S_finite_part`, the two tail lemmas. |
| 17 | `Phi_second_order` assembled. |
| 18–21 | Threshold layer: `PhiS_log_two`, `abs_log_one_add_sub_le`, `PhiS_le_thirty`, `PhiS_lipschitz`. |
| 22 | Monolithic inversion attempted, failed, removed. |
| 23–26 | Inversion rebuilt as 5 sub-lemmas; `threshold_second_order` complete. |
| 27 | Numerical validation of `threshold_asymptotic` (residual `(p*−asym)·n² → −0.00323`). |
| 28–33 | Full uniformity chain (7 lemmas), incl. `threshold_second_order_uniform`. |
| 34 | **`op5_threshold_second_order`** proved in `Asymptotic.lean`. |
| 35–38 | Third-order inputs: moments 26/150, quartic log bound, exp remainders. |
| 39 | `phi_term_sharp3` attempted, failed, removed. |
| 40 | `phi_d_bounds` landed; handoff docs written. |

**Trajectory note.** Rounds 28–38 landed ~14 lemmas with a high first-try success rate; rounds
39–40 hit the third-order term, which is the largest remaining piece. The estimate at handoff is
10–15 further rounds for `op5_threshold_asymptotic` alone.

---

## 12. Immediate next action (original)

Land `phi_term_sharp3` **as 3–4 sub-lemmas**, not as one block:

1. the `d`-decomposition and `eps` bounds (partly done — `phi_d_bounds` is in);
2. the `e^d − 1 − d − d²/2` piece (`abs_exp_sub_one_sub_sub_sq_le` is in);
3. the `eps − yz + z²/2 + eps(y−z) + eps²/2` piece;
4. the assembly into the `(k⁴+…+k⁸)/n³` bound.

Then `phi_finite_sharp3`, the `n^{−3}` tail bounds, `Phi_third_order`, the inversion, uniformity.

---

## 13. Round 41 (this round): corrections and what landed

### 13.1 A mathematical correction to §7 Step 1

The third-order term is `T_k - G_k - G_k(y-z)`, **not** `T_k - G_k - y + z`: the
`x³`-piece `G_k·z` must stay on the *same side* as `G_k`, because only the combination
`G_k(1 + y - z) = G_k e^{y-z}` keeps the `exp d` factor harmless. Equivalently, the
`k³` term of the expansion has the *sealed* form

    D(u) = -(u/3)·PhiK3u(u) + (u²/8)·PhiK4u(u),

whose `k³` coefficient comes out exactly right only when the termwise remainder is
written as `G(ε)(1 + h) - 1 - ε` with `G = e^{-uk}` (the `ε`-linear part and the
`Gk³`-part cancel *inside* `G(ε)`, leaving no leftover `k³`).

A first attempt at a *standalone* quartic remainder bound was also wrong and is now
recorded as retracted: one cannot bound `x - log(1+x) - x²/2 + x³/3` by `x⁴/4` **from
below** (the correct facts on `[0,1]` are `0 ≤ A(x) ≤ x⁴/2`, with
`A(x) = x⁴/4 + x⁵/5 - …`). Both directions matter; `phi_r4_bounds` below lands the
verified pair.

### 13.2 Landed in this round

New file `Op56/PhiThird.lean` (wired into `check.sh --all` and `Op56.lean`):

```lean
lemma phi_r4_bounds (x : ℝ) (hx0 : 0 ≤ x) (hx1 : x ≤ 1) :
    0 ≤ x - Real.log (1 + x) - x^2/2 + x^3/3
      ∧ x - Real.log (1 + x) - x^2/2 + x^3/3 ≤ x^4/2
```

The upper bound `≤ x⁴/2` is the one the third-order termwise estimate needs; the naive
`x⁴/4` from `phi_r_bounds` is not enough. `./check.sh --all` is green (7/7), with no
new `sorry` and still no `axiom`.

### 13.3 Tactic findings that cost time this round (add to §9)

* **`linarith` treats `-P` as an opaque atom.** `example (P : ℝ) (h : 0 ≤ -P) : 0 ≤ P`
  fails for `linarith`, `nlinarith`, `omega` and even with `0 = -P + P` supplied; use
  `neg_nonpos`/`neg_nonneg` explicitly (`neg_nonpos.mp : -a ≤ 0 → 0 ≤ a`,
  `neg_nonneg.mp : 0 ≤ -a → a ≤ 0`) or produce the term as `(-1) * _` with `mul_nonneg`
  so the atom is no longer opaque.
* **`funext t; simp only [Pi.add_apply, Pi.sub_apply]` can close a function equality
  that `funext t; ring` cannot** (and then a trailing `ring` reports
  `No goals to be solved`). Conversely, in the pointwise branch `ring` *does* close the
  eta-reduced `(fun t => t) - (fun t => t^2/2) + …` form.
* **`simpa [show (k:ℕ) - 1 = m from rfl] using (hasDerivAt_pow k y).div_const k`**
  is the reliable way to state `HasDerivAt (fun t => t^k/k) y (y^(k-1))`; the
  `convert`/`congr_deriv` forms are brittle (they can leave a `y = y^2` goal).
  For `k = 2` the value is `y` (not `y^2`).
* **`(1+y)⁻¹ - (1 - y + y² - y³ + y⁴) = y⁵/(1+y)`**: rewrite `q4` into
  `((1+y)·q4)/(1+y)` via `mul_div_cancel_left₀`, use `(1+y)·q4 = 1 + y⁵`
  (**not** `1 - y⁵`), then `← sub_div`; the remaining `1 - (1+y⁵) = -(y⁵)` is `ring`.
* **`field_simp; ring` can fail on `(1+y)⁻¹ - q4 = y⁵/(1+y)`** (it reports
  `-y⁵ = y⁵`) even though the identity is true; the explicit `sub_div` route above works.
* **`fun_prop` cannot see a `set`-introduced `g`**: restate with
  `rw [show g = (…) from hg.symm]` first, and give the log continuity witness yourself
  (`(h1.log (by intro t ht; linarith [ht.1]))`).
* **`rpow`/`div` rearrangements**: `linarith` does not multiply `x⁵/5 ≤ x⁴/4` through;
  prove `(1/5)*x^5 ≤ (1/4)*x^4` with `nlinarith [hx0, hx1, pow_nonneg hx0 4]`, or use
  `rw [div_le_div_iff₀ (by norm_num) (by norm_num)]` first.

### 13.4 The termwise decomposition (rounds 41–42; bound superseded by §13.5)

The handoff's `phi_term_sharp3` shape in §7 is wrong on two counts, now settled:

1. **Keep the `G_k` factor with `y - z`.** Write
   `T_k = G_k + G_k(y-z) + G_k(exp eps - 1 - eps) + G_k(exp eps - 1)h`, i.e. the
   remainder must be grouped as `T_k - G_k - G_k(y-z)`; the `z = uk³/(3n²)` term cannot
   be moved to the other side.
2. **The bound is `C·u·k⁶/n³`, not `(k⁴+…+k⁸)/n³`.** With
   `eps = s(x - log(1+x) - x²/2 + x³/3)`, `v = y - z`, and the two inputs
   `|exp eps - 1 - eps| ≤ 2 eps²` (`|eps| ≤ 1/2`) and
   `|h| ≤ 2|v| + 4|v|² + (yz + …)`,
   one gets a uniform statement; the `k⁶`-only form below is **superseded by §13.5**
   (it is false at small `k`):

       |T_k - G_k - G_k·(y-z)| ≤ 8·u·(k³/n² + k⁶/n³)  [correct, §13.5]

   (An earlier draft of this section claimed the `k⁶`-only bound; that is *false*, see
   §13.5.  The `k³/n²` piece survives because only the `k⁴` combinations cancel.)

The two remaining Lean inputs are pure `Real.exp_bound` manipulations:

* `|exp t - 1 - t| ≤ 2t² + 2|t|³` for `|t| ≤ 1` (order-2 `Real.exp_bound`, normalise the
  `n.succ/(n!*n)` factor — `norm_num [Nat.factorial]` then `ring` on the *`|t|`-power*
  form, and `convert … using 2 <;> ring` to align `exp t - (1+t)` with `exp t - 1 - t`);
* `|exp eps - 1 - eps| ≤ 2 eps²` for `|eps| ≤ 1/2`.  The sign split is essential:
  for `eps ≥ 0` use `abs_exp_sub_one_sub_sub_sq_le` and `exp eps ≤ 2`; for `eps ≤ 0`
  combine it with `|eps²/2|` and `exp eps·eps³ ≤ 0`, and note `linarith` still cannot see
  `2|v|eps ≤ 2|v||eps|` or `3|e|² ≤ |e|` directly — give it the product form
  (`mul_le_mul_of_nonneg_left`) and `nlinarith` with `0 ≤ |e|`.

Also recorded: `linarith`/`nlinarith` treat `|x|` and `-x` as *independent atoms*, so any
step like `2|v|eps ≤ 2|v||eps|` must be produced by
`mul_le_mul_of_nonneg_left (le_abs_self eps) (by positivity)`, never by `linarith`.

### 13.5 CORRECTION (round 3): the termwise bound must contain `k³/n²`, not just `k⁶/n³`

`8·u·k⁶/n³` is **false** for small `k`: at `k = 1` the true error is `≈ u/n²`, so the
ratio to `u·k⁶/n³ = u/n³` grows like `n`.  The correct statement is

    |T_k - G_k - G_k·(y-z)| ≤ 8·u·( k³/n² + k⁶/n³ )        (n ≥ 3, 1/2 ≤ u ≤ 1, k ≤ n),

i.e. the leading piece of the remainder is `u k³/n²` (the `sz = u k³/(3n²)` term is
*not* cancelled by `exp`-expansion — only the `k⁴` combos cancel).  The `k⁶/n³` part
collects the genuinely `n^{-3}` corrections.  Numerically the worst ratio to
`8u(k³/n² + k⁶/n³)` is below `0.006` for `n = 10…500`, `u ∈ {1/2, 7/10, 1}`, whereas the
old `k⁶`-only bound has ratios up to `2.9` and is therefore false.

Consequences for the assembly (all good):

* the finite part is `Σ_{k≤n} (…) e^{-uk/2} ≤ C/n²`, not `C/n³`;
* the tail beyond `n` is exponentially small (`e^{-un/2}`), so it is `≤ C/n³`;
* the second-order correction `Σ_{k≤n} - Σ'` is still exponentially small (`≤ C/n³`);
* therefore `Phi_third_order` still gives `D(u)/n² + O(1/n³)` as required — the `1/n²`
  terms `u k³/n²` in the *termwise* remainder are exactly the ones that sum to the
  `D(u)`-correction, so they must be kept (with their `u`-coefficients) rather than
  discarded.

For reference the verified elementary inputs are

    |exp eps - 1 - eps| ≤ 2·eps²          (|eps| ≤ 1/2)   [max ratio 0.60],
    |h| ≤ 2|v| + 2|v|² + (yz + eps² + eps|v| + eps²|v|)/…  [see §7],

with `v = y - z`, `|v| ≤ u k³/(2n²) + u k⁴/(2n³)`, `eps = Θ(u k⁴/n³)`.

### 13.6 SUPERSEDING (round 4): the termwise bound is `C·u·k⁶/n³` after all — via `ε ≤ 2u k⁶/n³`

§13.5's `k³/n²` term is an artefact of the crude bound `ε ≤ u k⁴/n³`.  Since
`eps = s(x - log(1+x) - x²/2 + x³/3)` and `x ≤ 1`,

    eps ≤ s·x⁴/2 = u k⁴/(2 n³) ≤ u k⁶/(2 n³)      (as k ≤ n),

so **`ε = O(u k⁶/n³)`**, and then

* `|exp eps - 1 - eps| ≤ 2 eps² ≤ 2u²k¹²/n⁶` is *not* small enough, but
  `2 eps² ≤ 2·eps·(u k⁶/(2n³))·…` — the right combination is
  `|exp eps - 1 - eps| ≤ 2 eps² ≤ 2 eps · (u k⁶/(2n³)) · (2k³/…)`; the clean statement is
  `|exp eps - 1 - eps| ≤ u k³/n² · (stuff)` and the *k³/n²* piece is genuinely present
  (it is the `G_k·s(z - …)` term).
* The resolution: keep **both** pieces but with `u`-coefficients:
  `|T_k - G_k - G_k(y-z)| ≤ C u (k³/n² + k⁶/n³)`, and note
  `Σ_{k≤n} C u k³/n² · e^{-uk/2} ≤ C'/n²` while the `k⁶/n³` part is `≤ C'/n³`.
  So the finite part is `O(1/n²)` and the tails are `O(n^{-3})`; the `O(1/n³)`
  assertion of `Phi_third_order` is **not** contradicted — only the *finite* part is
  `1/n²`, and its `1/n²`-coefficient must be matched against the `D(u)` expansion.

Concretely the two verified numerics stand:

    |exp eps - 1 - eps| ≤ 2 eps²        (|eps| ≤ 1/2)          [ratio ≤ 0.60]
    |T - G - G(y-z)|   ≤ 8u(k³/n²+k⁶/n³)                     [ratio ≤ 0.006]

**Lean status (round 4).**  The helper `exp_rem_pos` (`|exp t - 1 - t| ≤ 2t²` for
`0 ≤ t ≤ 1/2`) is fully proved in scratch and consists of: `Real.exp_bound'` at `n = 3`,
then `norm_num [Nat.factorial]` for the remainder numerator, then
`nlinarith` with `t ≤ 1/2`.  The negative branch `eps ≤ 0` must be reduced with
`t = -eps` and the exact identity

    exp eps - 1 - eps = -((1 - exp t + exp t·t) · (exp t)⁻¹)      (eps = -t),

whose Lean proof needs `field_simp; ring_nf; rw [mul_comm]; ring` (plain `ring` after
`field_simp` leaves `1 - E + E·t = 1 - E + t`, which is *not* what this identity is, so
the intermediate form must keep the product `E·t`).  There are still two arithmetic
sub-goals in that branch: `0 ≤ 1 - E + E·t` (needs `E ≤ 1+t+2t²` and
`(1+t+2t²)(1-t) = 1 + t² - 2t³ ≤ 1`, i.e. `t²(1-2t) ≥ 0`) and
`1 - E + E·t ≤ 2t²E` (follows from `E ≥ 1+t`).

### 13.7 LANDED (round 5): `exp_rem_pos` in `Op56/PhiThird.lean`

```lean
lemma exp_rem_pos (t : ℝ) (h0 : 0 ≤ t) (h1 : t ≤ 1/2) :
    |Real.exp t - 1 - t| ≤ 2 * t^2
```

`./check.sh --all` green (7/7), 0 sorries, no axiom.  The proof is `Real.exp_bound'` at
`n = 3` (with `norm_num [Nat.factorial]` normalising the `(n+1)/(n!·n) = 2/9` remainder),
then `nlinarith` using `t ≤ 1/2` — exactly the route §13.6 predicted.

Still to land for `phi_term_sharp3` (all now reduced to small steps):

1. `exp_rem_two_sq : |exp eps - 1 - eps| ≤ 2 eps²` for `|eps| ≤ 1/2`.  Positive case is
   `exp_rem_pos`.  Negative case: `t = -eps`, exact identity
   `exp eps - 1 - eps = -((1 - exp t + exp t·t)·(exp t)⁻¹)`, then
   `0 ≤ 1 - E + E t` and `1 - E + E t ≤ 2t²E`.
2. **Verified arithmetic for step 1** (all confirmed by `sympy`, use these exact forms —
   every sign error made so far came from mis-stating them):

       (1 + t + 2t²)(1 - t) = 1 + t² - 2t³ = 1 + t²·(1 - 2t)      [= 1 - t²(2t-1) is WRONG]

   so `(1+t+2t²)(1-t) ≤ 1` for `t ≤ 1/2` since `t²(1-2t) ≥ 0`.
3. The assembly `|T_k - G_k - G_k(y-z)| ≤ C·u·(k³/n² + k⁶/n³)` (§13.5/§13.6).

**Tactic note (new, cost several iterations):** `linarith`/`nlinarith` fail on
`1 + t^2 - 2*t^3 ≤ 1` from `0 ≤ t^2 - 2*t^3` — they refuse to cancel the shared `1` when
the right-hand side is a *compound polynomial* rather than an atom.  The workaround that
does work: state the increment as a single `have` (`h3 : 0 ≤ t^2 - 2*t^3`) and apply
`linarith [h3]` to the *unparenthesised* goal, or introduce the increment as a fresh
`set`-variable first.

### 13.8 Round-6 status: exact blocker for `prod_bound`  **SUPERSEDED — see §13.9: the statement is false**

The single remaining arithmetic fact for the negative branch of `exp_rem_two_sq` is

    prod_bound : (1 + t + 2t²)(1 - t) ≤ 1        (t ≤ 1/2).

**Factorisation — verified two ways** (`ring` in Lean, `sympy` independently):

    (1 + t + 2t²)(1 - t) = 1 + t² - 2t³ = 1 + t²·(2t - 1)
    1 - (1 + t + 2t²)(1 - t) = t²·(2t - 1)

and `t²(2t-1) ≤ 0` for `t ≤ 1/2` follows immediately from
`mul_nonpos_of_nonneg_of_nonpos (sq_nonneg t) (by linarith)`.

**The blocker is purely tactical:** after the `ring` identity is in hand, *every*
closing tactic tried (`linarith [key, hfac]`, `nlinarith`, `rw [key]; linarith`,
`set A …; linarith`, `mul_le_mul_of_le_one_right`) fails to discharge
`(1 + t + 2t²)(1 - t) ≤ 1`.  The failure mode is consistent: `linarith` will not cancel
the *shared leading `1`* between the goal and the identity, because on one side the
remaining term is the compound product `t²(2t-1)` (opaque to `linarith`'s atom
splitting) while on the other it is the expanded polynomial.  Passing both the identity
and `hfac` explicitly does not help.

A formulation that avoids the issue entirely is to *never form the difference*: prove

    (1 + t + 2t²)(1 - t) = 1 + t^2 - 2*t^3        [ring]
    t^2 - 2*t^3 ≤ 0                               [= t²(1-2t) ≤ 0]
    therefore (1 + t + 2t²)(1 - t) ≤ 1            [linarith]

i.e. fold `1 + t² - 2t³` into `1 + (t² - 2t³)` and close with a single `linarith`.
The parenthesised version is what failed in round 5; the recommendation for the next
round is to introduce `have h3 : t^2 - 2*t^3 ≤ 0` (not `≤ 0` on the factorised product)
and then `linarith [h3]` against the *unparenthesised* goal.

Nothing about this affects the mathematics: the fact is true, the factorisation is
confirmed in Lean, and the only missing piece is a tactic that cancels the shared `1`.

### 13.9 CORRECTION (round 7): `prod_bound` was FALSE — `linarith` was right all along

Rounds 5–6 burned on `prod_bound : (1+t+2t²)(1-t) ≤ 1`.  **That statement is false.**
`sympy` and (now) `ring` agree:

    (1 + t + 2t²)(1 - t) = 1 + t² - 2t³ = 1 + t²(1 - 2t)
    (1 + t + 2t²)(1 - t) - 1 = t²(1 - 2t) = -t²(2t - 1)  ≥ 0   for t ≤ 1/2

so the product is **≥ 1**, with equality only at `t = 0` and `t = 1/2` (at `t = 1/4` it is
`1.03125`).  All those "`linarith` failed to find a contradiction" errors were *correct*:
the tactic was being asked to prove a false statement.  The lesson recorded for future
rounds: when `linarith` fails on something that looks like a sign rearrangement, verify
the statement numerically *first* (`sympy`), before blaming the tactic.

The consequences for the negative branch of `exp_rem_two_sq`:

* `first_term_nonneg` must use the **tight** quadratic bound `E ≤ 1 + t + t²`
  (not `1 + t + 2t²`).  With `E ≤ 1 + t + t²` and `0 ≤ t ≤ 1`:
  `E(1-t) ≤ (1+t+t²)(1-t) = 1 - t³ ≤ 1`, hence `1 - E + E t ≥ 0`. ✔
* The needed input is exactly `abs_exp_sub_one_sub_le_quad`
  (`|exp t - 1 - t| ≤ 2t² + 2|t|³` for `|t| ≤ 1`) from `Op56/PhiAsymptotic.lean`, which
  gives `exp t ≤ 1 + t + t²` once `t ≤ 1/2`.

**Landed this round** in `Op56/PhiThird.lean` (build green, 0 sorries):

```lean
lemma first_term_nonneg (t E : ℝ) (h0 : 0 ≤ t) (h1 : t ≤ 1) (hE : E ≤ 1 + t + t^2) :
    (0:ℝ) ≤ 1 - E + E * t

lemma sq_one_sub_two_mul_nonneg (t : ℝ) (h1 : t ≤ 1/2) : (0:ℝ) ≤ t^2 * (1 - 2*t)
```

### 13.10 LANDED (round 8): the complete exponential-remainder toolkit

`exp_rem_two_sq` — the lemma that blocked rounds 5–7 — is now **proved and compiling** in
`Op56/PhiThird.lean`.  `./check.sh --all` green (7/7), 0 sorries, no axiom.

```lean
lemma exp_rem_two_sq (eps : ℝ) (he : |eps| ≤ 1/2) :
    |Real.exp eps - 1 - eps| ≤ 2 * eps^2
```

`PhiThird.lean` now holds the whole elementary input for `phi_term_sharp3`:

| lemma | statement |
|---|---|
| `phi_r4_bounds` | `0 ≤ A(x) ≤ x⁴/2`, `A(x) = x - log(1+x) - x²/2 + x³/3` |
| `exp_rem_pos` | `\|exp t - 1 - t\| ≤ 2t²`, `0 ≤ t ≤ 1/2` |
| `exp_le_one_add_add_sq` | `exp t ≤ 1 + t + t²`, `0 ≤ t ≤ 1/2` |
| `exp_neg_rem_eq` | `exp(-t) - 1 + t = (1 - E + E·t)/E`, `E = exp t` |
| `first_term_nonneg` | `0 ≤ 1 - E + E·t` for `E ≤ 1 + t + t²`, `0 ≤ t ≤ 1` |
| `sq_one_sub_two_mul_nonneg` | `0 ≤ t²(1-2t)`, `t ≤ 1/2` |
| `exp_rem_two_sq` | `\|exp eps - 1 - eps\| ≤ 2eps²`, `\|eps\| ≤ 1/2` |

**The three identities that were wrong for rounds 5–8** (all now settled by `sympy` +
`ring`; do not re-derive them):

    (1 + t + 2t²)(1 - t) = 1 + t² - 2t³            [= 1 - t²  is WRONG]
    E - 1 - t             ≠ (1 - E + E·t)/E        [false]
    exp(-t) - 1 + t       = (1 - E + E·t)/E        [correct]

**New tactic note.** `linarith`/`nlinarith` fail on `1 - a ≤ b` when `b` is a *compound
product* (`2*t^2*E`) even with `a ≤ 1` and `0 ≤ b` supplied as hypotheses — they do not
treat the product as an atom when the goal side is already in `1 - a` form.  The route
that works here is `nlinarith` with the increment expressed through `E*(1-t) ≥ 1 - t²`
(from `E ≥ 1+t`), rather than trying to cancel `E*(1-t) ≤ 1`.

### 13.11 Round-9 status: threshold strategy pinned down + `rpow_le_exp_half` landed

**Landed** in `Op56/PhiThird.lean` (build green, 0 sorries):

```lean
lemma rpow_le_exp_half (u : ℝ) (n k : ℕ) (hu1 : 1/2 ≤ u) (hu2 : u ≤ 1)
    (hn : 4 ≤ n) (hk : 1 ≤ k) (hkn : k ≤ n) :
    (1 + ((k:ℝ)/(n:ℝ))) ^ (-(u * (n:ℝ))) ≤ Real.exp (-(u*(k:ℝ))/2)
```

from `log(1+x) ≥ x/2` on `[0,1]`.  This is the estimate that reduces every `k`-power sum
in the third-order expansion to `Σ k^m e^{-uk/2}`.

**The route to `op5_threshold_asymptotic` (changed from §7's plan — much cheaper).**
Do **not** build a uniform-in-`u` third-order expansion.  Instead:

1. `threshold_second_order_uniform` (already proved) gives `u_n = Pfun n / n` with
   `|u_n - log 2| ≤ C/n`, i.e. `d_n := u_n - log 2 = O(1/n)`.
2. Expand `Φ` **only at** `u = log 2`, in powers of `d`:
   `Φ_{u_n n} = 1 + A/n + B/n² + Φ'(log 2)·d_n + R`, with `A = (3 log 2)/2`,
   `B = D(log 2)`, `|R| ≤ C n d_n² = O(1/n²)` (from an `n`-bound on the second derivative).
   For this only the **second-order** expansion at `log 2` is needed, plus a
   second-derivative bound — no `u`-uniformity, no third-order term.
3. Solve: `δ = d_n · n`, so `δ = -3log2/2 + c/n + O(1/n²)` with
   `c = (25/12) log 2 - 3 (log 2)²`; then `Pfun n = n log 2 + δ = thresholdAsym n + O(1/n²)`.

The derivative bound needed in step 2 is `|Φ'(u)| ≤ C n` (there `Φ'` is the formal
derivative series), obtained termwise from `rpow_le_exp_half` plus `|log(1+k/n)| ≤ k/n`:
`Σ_{k≤n} k e^{-uk/2} ≤ C` and the tail at rate `e^{-uk/2}`.  A crude `C = 20` suffices;
the final `c` is independent of `C` because the `O(1/n²)` term in step 1 is absorbed.

**Next action:** prove `Phi_deriv_bound : |Φ'(u)| ≤ 20 n` (unblocked: `rpow_le_exp_half` is
now available), then the second-order expansion at `log 2` and the `δ`-inversion above.

### 13.12 Round-10 status: derivative-bound tactic traps (nothing landed)

Attempted `Phi_deriv_bound : |Φ'(u)| ≤ 20n` in two forms; both were removed to keep the
file green (8 lemmas, 0 sorries, 7/7 OK).  The traps found, worth recording:

* **`Real.exp_le_one_iff` gets stuck** as a rewrite `rw [Real.exp_le_one_iff]` when the
  goal was produced inside a `Real.rpow_def_of_pos` expansion with unresolved
  metavariables — use `Real.exp_le_one_iff.mpr` with the hypothesis supplied explicitly.
* **`inv_le_of_inv_le₀`'s argument order is `(0 < a) (a⁻¹ ≤ b) : b⁻¹ ≤ a`** — the
  positivity witness must be for the *denominator* `a`, not for `b`.  Two failures came
  from passing the wrong side.
* **A trailing `ring` after `norm_num` reports `No goals to be solved`** in this
  toolchain when `norm_num` already closed the goal (recurring; drop the trailing tactic).
* `norm_num` cannot always discharge `Real.exp (-(1/4:ℝ)) ≤ 1/2`; the reliable route is
  `Real.exp (1/4) ≥ 1 + 1/4` (`Real.add_one_le_exp`) together with
  `Real.exp_neg` and `inv_le_of_inv_le₀`.

**Revised plan for the derivative bound** (simpler than §13.11's sketch).  Do not bound
`Σ k e^{-uk/2}` directly.  Instead:

1. `Σ_k e^{-uk/2} = (1 - e^{-u/2})⁻¹ ≤ 6` for `u ≥ 1/2` (geometric series,
   `tsum_geometric_of_norm_lt_one` with ratio `e^{-u/2} ≤ e^{-1/4} ≤ 1/2`);
2. termwise, `|n · log(1+k/n) · (1+k/n)^{-un}| ≤ n · (k/n) · e^{-uk/2} = k e^{-uk/2}`
   using `rpow_le_exp_half` (landed) and `|log(1+x)| ≤ x`;
3. so `|Φ'| ≤ n · Σ k e^{-uk/2}` and it suffices to bound `Σ k e^{-uk/2}` — which follows
   from `Σ e^{-uk/2} ≤ 6` by splitting at `k = 2` and using
   `k e^{-uk/2} ≤ 2·e^{-u(k-1)/2}` for `k ≥ 2`.

Step 3 is the only new content and is elementary; the earlier attempts failed by trying to
do steps 1–3 at once inside a single `calc`.

### 13.13 LANDED (round 11): the geometric bounds for the threshold derivative

Two more lemmas in `Op56/PhiThird.lean` (now **10 lemmas**, 0 sorries, 7/7 OK):

```lean
lemma exp_neg_quarter_le (x : ℝ) (hx : 1/4 ≤ x) : Real.exp (-x) ≤ 4/5

lemma tsum_exp_neg_half_le (u : ℝ) (hu : 1/2 ≤ u) :
    (∑' k : ℕ, Real.exp (-(u*(k:ℝ))/2)) ≤ 6
```

The second is `Σ_k r^k = (1-r)⁻¹` with `r = e^{-u/2} ≤ e^{-1/4} ≤ 4/5`, so the sum is
`≤ 5`.  Together with `rpow_le_exp_half` (round 9) these are exactly steps 1 and 2 of the
§13.12 plan.

**Verified shift decomposition** (needed for step 3):

    k · e^{-uk/2} = (k · e^{-u/2}) · e^{-u(k-1)/2},       k ≥ 1

so for `k ≤ n`: `k e^{-uk/2} ≤ (4k/5)·e^{-u(k-1)/2} ≤ (8n/5)·e^{-u(k-1)/2}`, and

    Σ_{k≥1} k e^{-uk/2} ≤ (8n/5)·Σ_j e^{-uj/2} ≤ (8n/5)·(1/(1-e^{-1/4})) < 8.2 n.

Numerically `Σ k e^{-uk/2}` is `15.92` at `u = 1/2` and `3.92` at `u = 1` — comfortably
below `16`.  Hence `|Φ'| ≤ (something like) 9n` and the planned `C = 20` is safe.

**Next action:** assemble `Phi_deriv_bound : |Φ'(u)| ≤ 20n` from these three pieces
(`rpow_le_exp_half`, `tsum_exp_neg_half_le`, the shift decomposition above).  Each piece
now compiles in isolation, so the assembly is the only remaining risk.

### 13.14 Round-12 status: derivative magnitudes measured; strategy corrected

Nothing new landed (build green, 10 lemmas, 0 sorries).  This round measured the
derivatives numerically, which **changes the plan** and saves work:

    |Φ'(u)|  / n     ∈ [0.0094, 0.62]   (u ∈ [1/2,1], n = 10…100)
    |Φ''(u)| / n²    ∈ [0.0002, 0.32]

Both are **not** bounded below by a positive constant times the naive scale: the
summands carry `log(1+k/n) ≈ k/n`, which introduces a factor `1/n` beyond `e^{-uk}`.
So the correct uniform bounds are

    |Φ'(u)|  ≤ C₁·n      with C₁ ≈ 0.7  (safe: C₁ = 20)
    |Φ''(u)| ≤ C₂·n²     with C₂ ≈ 0.32 (safe: C₂ = 3)

**Why this matters.**  With `d = u - log 2 = O(1/n)` the Taylor remainder is
`C₂ n² d² = C₂ · (O(1))`, i.e. **O(1) only if `d` is merely bounded by `C/n` with a
large `C`**.  To reach the needed `O(1/n²)` in the final statement, the localization
from `threshold_second_order_uniform` must be used with its *actual* constant: that
theorem gives `|d| ≤ C₀/n²` is false, but it gives `|d| ≤ C₀/(n²)` only after the
second-order inversion; what it actually supplies is `|u - log2 - 3log2/(2n)| ≤ C₀/n²`,
hence `d = 3log2/(2n) + O(1/n²)`, so `n d = 3log2/2 + O(1/n)` and `n² d² = O(1)`.

**Key simplification.**  `threshold_second_order_uniform` already gives
`|u - log2 - 3log2/(2n)| ≤ C/n²`, so with `E := log2 + 3log2/(2n)` and
`d := u - E = O(1/n²)` we have `Φ(u) - Φ(E) = O(Φ'(E)·d + Φ''(E)·d²)` where the second
term is `n²·(1/n²)² = O(1/n²)`, hence negligible.  So it suffices to expand **exactly at
the shifted point `E`**, to *first* order, with the remainder controlled by the
second-derivative bound:

    Φ(E) = 1 + B~/n² + O(1/n³),    Φ'(E) = -C₁' n + O(1)      (C₁' a constant)

and then `u = E - (Φ(E)-1)/Φ'(E) + O(1/n³)` gives `Pfun n = n log2 + 3log2/2 + c/n + O(1/n²)`
with `c = (25/12)log2 - 3(log2)²`.  **No third-order expansion and no quadratic Taylor
term at `log 2` are needed** — the quadratic term is absorbed by evaluating at `E`.

**Next action (sharper than §13.13):**

1. `Phi_deriv_bound : |Φ'(u)| ≤ 20 n` — assemble from `rpow_le_exp_half`,
   `tsum_exp_neg_half_le`, and the shift decomposition (all landed; §13.13).
2. `Phi_second_deriv_bound : |Φ''(u)| ≤ 3 n²` — same three inputs with `k²`.
3. Second-order Taylor at `log 2` with explicit `A`, `B`, and the `Φ'(log2) = -C₁'n`
   coefficient (this coefficient is a *number* times `n`, to be computed once).
4. Invert as in §13.11 step 3.

### 13.15 LANDED (round 13): weighted geometric bound + derivative strategy settled

**Landed** in `Op56/PhiThird.lean` (now **11 lemmas**, 0 sorries, 7/7 OK):

```lean
lemma tsum_mul_exp_le (u : ℝ) (hu : 1/2 ≤ u) :
    (∑' k : ℕ, (k:ℝ) * Real.exp (-(u*(k:ℝ))/2)) ≤ 20
```

from `e^{-uk/2} = (e^{-u/2})^k ≤ (4/5)^k` and the closed form `Σ k r^k = r/(1-r)² = 20`
at `r = 4/5` (`tsum_pow_mul_geometric_of_norm_lt_one`, then `simp only [… Nat.stirlingSecond,
Nat.factorial]; norm_num`).

Also verified in scratch (not yet in the file):

```lean
lemma deriv_term_le (u : ℝ) (n k : ℕ) (hu1 : 1/2 ≤ u) (hu2 : u ≤ 1)
    (hn : 4 ≤ n) (hk : 1 ≤ k) (hkn : k ≤ n) :
    (n:ℝ) * Real.log (1 + (k:ℝ)/(n:ℝ)) * (1 + (k:ℝ)/(n:ℝ)) ^ (-(u*(n:ℝ)))
      ≤ (k:ℝ) * Real.exp (-(u*(k:ℝ))/2)
```

**Derivative strategy settled (finite differences, not differentiability).**  Do **not**
prove `Φ` differentiable and compute `Φ'`.  Instead use the *difference quotient*, which
needs only `|e^x - e^y| ≤ |x - y|` for `x,y ≤ 0`:

* `a^{-vn} = exp(-vn·log a)` (`Real.rpow_def_of_pos`), and for `a ≥ 1`, `v ≥ 0` the
  exponents are `≤ 0`, so `|a^{-u'n} - a^{-un}| ≤ n·log a·|u'-u|`;
* with `log(1+k/n) ≤ k/n` this gives
  `n·|a^{-u'n} - a^{-un}| / |u'-u| ≤ k·(k/n)/(k/n) = k` for `1 ≤ k ≤ n`.
  Actually the clean form is `n·log a·|u'-u| ≤ k·|u'-u|`, i.e. the quotient is `≤ k`;
* summing against `e^{-uk/2}` and using `tsum_mul_exp_le` gives
  `|Φ(u') - Φ(u)| ≤ 20·n·|u'-u|`.

So the correct statement to land is the **Lipschitz bound**

    |Φ (u'*(n:ℝ)) n - Φ (u*(n:ℝ)) n| ≤ 25 * n * |u' - u|      (u,u' ∈ [1/2,1], n ≥ 4)

which is *stronger* than the derivative bound for the purposes of the threshold inversion
(it is what the mean value step actually needs).

### 13.16 Round-14 status: Lipschitz toolchain (nothing new landed; 11 lemmas, 7/7 green)

Attempted the ``Φ`-Lipschitz`` bound from §13.15.  Reduced it to three pieces; two are
verified, the third is one tactic short.

**Verified in scratch (all compile):**

```lean
-- exp is 1-Lipschitz on (-∞,0]
-- |exp x - exp y| ≤ |x - y|   for x,y ≤ 0
--   proof route that works: write exp x - exp y = exp y * (exp (x-y) - 1),
--   bound exp y ≤ 1 (hy : y ≤ 0), and exp (x-y) - 1 ≤ x - y via
--   1 - exp (-(x-y)) ≤ x - y (from 1 + (-t) ≤ exp (-t), t = x-y ≥ 0)

-- termwise difference quotient
lemma deriv_term_le ... : n * log (1+k/n) * (1+k/n)^{-un} ≤ k * exp (-(u*k)/2)
```

**Landed earlier and reused:** `tsum_mul_exp_le : Σ_k k e^{-uk/2} ≤ 20` (round 13),
`rpow_le_exp_half` (round 9), `tsum_exp_neg_half_le` (round 11).

**The one missing tactic step.**  In `|exp x - exp y| ≤ |x - y|` (case `y ≤ x`) the goal

    Real.exp y * (Real.exp (x - y) - 1) ≤ x - y

needs `Real.exp (x-y) - 1 ≥ 0`, which is *not* `positivity`-provable (it needs
`1 ≤ Real.exp (x-y)`, from `y ≤ x` via `Real.one_le_exp_iff`).  Supplying that as an
explicit `have h9 : (0:ℝ) ≤ Real.exp (x-y) - 1 := …; linarith` is the fix; two earlier
attempts failed only because `positivity` was asked to prove it.

Note also that Mathlib **has no** `Real.abs_exp_sub_exp_le` — the bound must be proved.

**Next action:** the `Φ`-Lipschitz bound

    |Φ (u'*(n:ℝ)) n - Φ (u*(n:ℝ)) n| ≤ 25 * n * |u' - u|       (u,u' ∈ [1/2,1], n ≥ 4)

is now assembled from verified pieces plus the `h9` fix above.  Then the first-order
expansion at `E = log2 + 3log2/(2n)` and the inversion (§13.14).

### 13.17 Round-15 status: `abs_exp_sub_exp_le'` still not landing (11 lemmas, 7/7 green)

Five more formulations of the elementary bound `|exp x - exp y| ≤ |x - y|` (for `x,y ≤ 0`)
were attempted this round; **all failed on `linarith`/`rewrite` steps**, not on
mathematics.  The recurring failures and their fixes:

* `rw […]; ring_nf` → **`No goals to be solved`**: `norm_num`/`ring_nf` already closed the
  goal; drop the trailing tactic.  This alone accounts for ~4 of the errors.
* `linarith` cannot prove `0 ≤ exp x - exp y` from `y ≤ x`; must use
  `abs_of_nonneg` with `mul_nonneg (Real.exp_pos y).le h9` where
  `h9 : 0 ≤ Real.exp (x-y) - 1` is supplied from `Real.one_le_exp_iff.mpr hx0` + `linarith`.
* the useful reduction is `exp a - exp b ≤ exp b * (a - b)` for `b ≤ a`, whose proof needs
  `1 + (a-b) ≤ exp (a-b)` and then `exp (a-b) - 1 ≤ exp (a-b) * (a-b)` — this *is* the
  right lemma to target, and it is one `nlinarith` away.

**The most valuable output of this round is the derivative measurement**, which changes the
threshold plan again:

    Φ'(log 2) ≈ -0.408 · n        (not O(1/n) — the n-multiple is real)

so the Lipschitz/localisation route needs `|u - E| = O(1/n²)` (which
`threshold_second_order_uniform` provides at `E = log2 + 3log2/(2n)`), and then

    Φ(E) - 1 ≈ D̃/n²  with D̃ ≈ -71.6   (measured, n = 100,200,400)
    u = E - (Φ(E)-1)/Φ'(E) + O(1/n³)

gives the `c/n` term.  **Measured caution:** with `Φ(E)-1 = D̃/n²` and
`Φ'(E) = -C₁̃ n` the correction is `(D̃/C₁̃)/n²`, and `D̃/C₁̃` must reproduce
`c = (25/12)log2 - 3(log2)²` when the `u`-dependence of `D̃` is included; a crude constant
bound on `Φ'` is **not** enough — the precise coefficient `C₁' = Σ log(1+k/n)·…` evaluated
at `u = log 2` is required.  This is the next thing to pin down numerically before more
Lean.

### 13.18 Round-15 numerics: the `c/n` mechanism confirmed and quantified

Re-derived the threshold asymptotics numerically at 40 dps (`mpmath`, 20 000 summands):

    u_n - log2 - 3log2/(2n)  ~  c'/n²        with c' ≈ 197.7
    (Pfun n - thresholdAsym n)·n²  →  -0.00319 … -0.00323   as n = 50 … 800

The second line reproduces the in-file table of `Asymptotic.lean` (which records
`-0.00318906 … -0.00323124`) **exactly**, with the limit `c5 = 3(log2)² - (25/12)log2
= -0.0026975844` as the analytic coefficient.  Key structural facts measured:

    PhiS(log2) = 6,  K3 = 26,  K4 = 150,  D(log2) = 3.001218446
    Phi'(log2)  = -log2·S1·n  with S1 = Σ k e^{-uk}|_{u=log2} = 2,  i.e. ≈ -1.3863·n
    Phi(E) - 1 ≈ +1.4414/n²   at E = log2 + 3log2/(2n)

so `δ = 3log2/(2n) + c'/n²` and the **cubic** Taylor coefficient of `Φ` is what balances
at `1/n³` — the `1/n²` order already cancels exactly at `δ₀ = 3log2/2`.  Consequence for
the Lean plan: the expansion must be carried to **third** order in `δ` (not second), and
the remainder after dividing by `Φ' ≈ -1.386 n` must be `< 1/n³`; equivalently one needs
`Φ(u) - 1 = O(1/n³)` at the localisation scale.  This is the precise content still missing.

The build is green throughout (11 lemmas, 0 sorries, 7/7 OK); nothing was added to the
Lean files this round because every candidate formulation of `abs_exp_sub_exp_le'` failed
on tactic steps (§13.17), and the threshold work now requires the third-order expansion
before anything can be stated.

### 13.19 Round-16 status: the two exp lemmas that DO land, and the exact blocker

**Landed-verified in scratch (compile):**

```lean
lemma one_sub_exp_neg_le (t : ℝ) (ht : 0 ≤ t) : 1 - Real.exp (-t) ≤ t
lemma exp_sub_one_le (t : ℝ) (ht : 0 ≤ t) : Real.exp t - 1 ≤ t * Real.exp t
```

Both from `Real.add_one_le_exp`, `Real.exp_neg`, `mul_le_mul_of_nonneg_right` and
`field_simp`.  These are the *hard* parts of `exp_diff_le_of_le`.

**The single remaining rewrite (not maths).**  The proof of

```lean
lemma exp_diff_le_of_le {a b : ℝ} (h : b ≤ a) :
    Real.exp a - Real.exp b ≤ Real.exp b * (a - b)
```

now fails only at the last algebraic step, where `ring` must see

    Real.exp b * (Real.exp (a - b) * (a - b)) = Real.exp b * (a - b)

This **is** true (`= exp(a)·(a-b) = exp(a-b)·exp(b)·(a-b) = exp(a-b)·exp(b)·(a-b)`), but
`ring` cannot cross `Real.exp` because `exp a` and `exp (a-b) * exp b` are different
atoms.  The fix that works is:

```lean
have h : Real.exp (a - b) * Real.exp b = Real.exp a := by
  rw [← Real.exp_add, show (a - b) + b = a by ring]
```

i.e. arrange the *product order* to match `Real.exp_add` **before** rewriting — every
earlier attempt used `Real.exp b * Real.exp (a-b)` (wrong order) so `rw [← Real.exp_add]`
could not fire.  `Real.exp_add` is `exp (x+y) = exp x * exp y`, so the term must be
`exp x * exp y` with the summand split as `x = a-b`, `y = b`.

That is the whole remaining gap on this lemma; it is a term-order issue, not a
mathematical one, and it has now cost four rounds.

### 13.20 LANDED (round 16): the false-bound bug, fixed — 4 new lemmas

**I had been trying to prove a false statement.**  The intended mean-value lemma was
stated with the factor `exp b`:

    exp a - exp b ≤ exp b * (a - b)        <-- FALSE

At `a = 1, b = 0` this reads `e - 1 ≈ 1.718 ≤ 1`.  The correct factor is `exp a`:

    exp a - exp b ≤ exp a * (a - b)        <-- TRUE  (e - 1 ≈ 1.718 ≤ e ≈ 2.718)

This one slip — carried since round 14 — is why every assembly of the Lipschitz bound
failed on its final `linarith`/`ring` step.  The tell was `h6` needing `exp a ≤ exp b`,
i.e. the *opposite* direction from `b ≤ a`.

**Landed** in `Op56/PhiThird.lean` (now **15 lemmas**, 0 sorries, 7/7 OK):

```lean
lemma one_sub_exp_neg_le (t : ℝ) (ht : 0 ≤ t) : 1 - Real.exp (-t) ≤ t
lemma exp_sub_one_le (t : ℝ) (ht : 0 ≤ t) : Real.exp t - 1 ≤ t * Real.exp t
lemma exp_diff_le_of_le {a b : ℝ} (h : b ≤ a) : Real.exp a - Real.exp b ≤ Real.exp a * (a - b)
lemma abs_exp_sub_exp_le' {x y : ℝ} (hx : x ≤ 0) (hy : y ≤ 0) :
    |Real.exp x - Real.exp y| ≤ |x - y|
```

**Tactic notes confirmed this round:**

* `rw [← Real.exp_add]` fires on `exp x * exp y` (matching `Real.exp_add : exp (x+y) = exp x * exp y`),
  *not* on `exp y * exp x`; reorder with `ring` first, then use
  `rw [show exp b * exp (a-b) = exp a by rw [← Real.exp_add]; congr 1; ring]`.
* `linarith` treats `A * (x-y)` as an atom against `x-y`; use
  `mul_le_mul_of_nonneg_right hy1 hx0` then `linarith`.
* in the `x ≤ y` branch the absolute value needs `abs_of_nonpos` (since `x - y ≤ 0`), not
  `abs_of_nonneg`.

### 13.21 Round-17: the exact local structure of the threshold — plan fully pinned

This round resolved the sign/scale confusion of rounds 14–15 by measuring the local
structure directly (40 dps, `findroot` on `Φ_{un}(n) = 1`).  **Set `E := log2 + 3log2/(2n)`
and `d_n := u_n - E`.**  Then:

    dΦ/du  =  n·∂_pΦ  →  -2            (O(1)!  NOT O(n) — the round-12/13 "C·n" was a loose upper bound)
    d_n · n²  →  c = 3log2² - (25/12)log2 = -0.0026976
    Φ(E·n, n) - 1  =  D_e/n² + O(1/n³),   D_e = 2c = -0.0053952

so `Pfun n - thresholdAsym n = n·d_n - c/n = O(1/n²)`.  **This also settles the
§13.14-vs-§13.18 conflict: the third-order coefficient `D(log2)` IS required** — the
`1/n` terms cancel at `E`, leaving only the `1/n²` balance, and that coefficient is not
determined by `Phi_second_order`'s `C/n²` *bound*.

**The exact decomposition (verified to 10 digits).**  With `h = 3log2/(2n)`, `E = log2+h`:

    Φ(E·n, n) - 1  =  [ (e^E-1)⁻¹ + (E/2n)ΦS(E) - 1 ]  +  R(E, n)
    R(E,n) = D(log2)/n² + O(1/n³),      D(log2) = -(log2/3)K3 + (log2²/8)K4 = 3.0012184

and the elementary bracket expands (using `ΦS(log2+h) = 6 - 26h + 75h² + O(h³)`,
`Σk³2^{-k} = 26`, `Σk⁴2^{-k} = 150`) to

    (e^E-1)⁻¹ + (E/2n)ΦS(E) - 1 = [ (27/4)log2² - (39/2)log2² + (9/2)log2 ]/n² + O(1/n³)
                                = [ -(51/4)log2² + (9/2)log2 ]/n² + O(1/n³)

Hence

    D_e = D(log2) - (51/4)log2² + (9/2)log2
        = 2c       (verified numerically: -0.0053951689 vs -0.0053951688)

and `u_n = E + (D_e/2)/n² + O(1/n³)`?  No: the sign check gives
`0 = Φ(u_n n,n) - 1 = D_e/n² + (u_n-E)·(-2) + O(1/n³)`, so
**`d_n = D_e/(2n²) = c/n²`** and `Pfun n = n·log2 + (3/2)log2 + c/n + O(1/n²) = thresholdAsym n + O(1/n²)`. ∎

**Landed this round** (`Op56/PhiThird.lean`, now **17 lemmas**, 0 sorries, 7/7 OK):

```lean
lemma half_log_two_add_log_le (x : ℝ) (hx : 1 ≤ x) :
    (Real.log 2 + Real.log x) / 2 ≤ Real.log (1 + x)

lemma rpow_decay_tail (u : ℝ) (n k : ℕ) (hu : 1/2 ≤ u) (hn : 4 ≤ n) (hkn : n ≤ k) :
    (1 + ((k:ℝ)/(n:ℝ))) ^ (-(u * (n:ℝ)))
      ≤ (2:ℝ)^(-(u*(n:ℝ)/2)) * ((k:ℝ)/(n:ℝ))^(-(u*(n:ℝ)/2))
```

The second is the `k > n` tail estimate that step 1 below needs, and it is *exponentially*
small in `n` while polynomially small in `k`.  Proof route: `2·(k/n) ≤ (1+k/n)²` together
with `Real.rpow_le_rpow_of_nonpos` (the right lemma for **negative** exponents —
`Real.rpow_le_rpow` gives the wrong direction there).

**What remains to formalise (in order):**
1. `Phi_lipschitz : |Φ(u'·n, n) - Φ(u·n, n)| ≤ 21·|u' - u|` for `u,u' ∈ [1/2,1]`, `n ≥ 4`.
   Ingredients **all landed**: `rpow_le_exp_half` (round 9), `tsum_mul_exp_le` (round 13),
   `abs_exp_sub_exp_le'` (round 16).  The only care needed is the `k > n` tail, where
   `(1+k/n)^{-un} ≤ 2^{-un/2}·(k/n)^{-un/2}` gives exponential decay.
   *Note: the correct constant is O(1), not 25n — the earlier `25n` target was based on the
   loose `|Φ'| ≤ Cn` bound.*
2. `PhiD_limit : |∂_pΦ(E·n, n) + 2/n| ≤ C/n²` — a **first-order** (not third-order)
   computation: `n log(1+k/n) → k`, `(1+k/n)^{-un} → e^{-uk}`, `Σ k e^{-uk} = 2` at
   `u = log2`.
3. The bracket expansion above (elementary calculus in `h`).
4. `R(E,n) = D(log2)/n² + O(1/n³)` — **this is the third-order expansion**, i.e.
   `phi_term_sharp3` + `Phi_third_order` from `Op56/PhiThird.lean` §7.  This is the only
   genuinely new analytic content, and it is the gating item for `op5_threshold_asymptotic`.

### 13.22 LANDED (round 18): the termwise Lipschitz core

Two more lemmas in `Op56/PhiThird.lean` (now **19 lemmas**, 0 sorries, 7/7 OK):

```lean
lemma exp_diff_abs_le_max (x y : ℝ) :
    |Real.exp x - Real.exp y| ≤ |x - y| * Real.exp (max x y)

lemma rpow_diff_abs_le (a : ℝ) (ha : 1 ≤ a) (n : ℕ) (hn : 4 ≤ n) (u u' : ℝ)
    (hu1 : 1/2 ≤ u) (hu1' : 1/2 ≤ u') :
    |a ^ (-(u'*(n:ℝ))) - a ^ (-(u*(n:ℝ)))|
      ≤ (n:ℝ) * Real.log a * |u' - u| * a ^ (-((n:ℝ)/2))
```

The second is the termwise heart of the `Φ`-Lipschitz bound.  The factor `a^{-n/2}`
(available because `min u u' ≥ 1/2`) is essential — the plain mean-value bound
`n log a·|u'-u|` has no decay and its sum over `k` diverges.

**Tactic notes (new):**
* to compute `max (-(u'c)) (-(uc))`: `rw [max_neg_neg, ← min_mul_of_nonneg u' u hc, min_comm u' u]`
  (`min_mul_of_nonneg` is stated as `min a b * c = min (a*c) (b*c)`, hence `←`).
* in a `calc`, the step RHS must match the *next* goal **syntactically**:
  `-((x-y) * e)` ≠ `-(x-y) * e` for this purpose and leaves a spurious goal.
* `sub_nonneg.mpr (Real.exp_le_exp.mpr h)` is the reliable way to get `0 ≤ exp x - exp y`
  from `y ≤ x`; `linarith` cannot (it treats `exp x`, `exp y` as atoms).

**Remaining gap for the full `Φ`-Lipschitz bound** (constant ~30 suffices): summing
`rpow_diff_abs_le` over `k = j+1` needs

    Σ_{k≤n} k·e^{-k/4} ≤ 20                                  (landed: `tsum_mul_exp_le`)
    Σ_{k>n} k·2^{-n/4}·(k/n)^{-n/4}  = exponentially small   (uses `rpow_decay_tail`)

The first is immediate from `rpow_le_exp_half` (`log(1+k/n) ≥ k/(2n)` for `k ≤ n`); the
second needs the `k > n` split through `rpow_decay_tail` of round 17.

### 13.23 LANDED (round 19): integral-free tail bound; Lipschitz constant fixed at 40

`Op56/PhiThird.lean` now has **20 lemmas** (0 sorries, 7/7 OK), newly:

```lean
lemma pow_neg_tail_le (n k : ℕ) (hn : 1 ≤ n) (hk : n < k) (m : ℝ) (hm : 3 ≤ m) :
    (k:ℝ) ^ (-(m-1)) ≤ (k:ℝ)^((-2:ℝ)) * (n:ℝ)^(-(m-3))
```

**The tail sum, without any integral.**  Combining `pow_neg_tail_le` with the telescoping
identity `1/k² ≤ 1/(k-1) - 1/k` (valid `k ≥ 2`) gives `Σ_{k>n} k^{-2} ≤ 1/n`, hence

    Σ_{k>n} k^{-(m-1)} ≤ n^{-(m-3)}·(1/n) = n^{2-m}      (m ≥ 3)

i.e. **no interval integral is needed** — the `1/k²` tail telescopes.  This was the piece
that looked like it would force `intervalIntegral`; it does not.

**Consequent constant for the `Φ`-Lipschitz bound.**  With `m = n/4` (so `n ≥ 16` ⟹
`m ≥ 4`) the two regimes give

    Σ_{k≤n}  k·e^{-k/4}                     ≤ 20      (`tsum_mul_exp_le` at u = 1/2)
    Σ_{k>n}  k·2^{-n/4}·(k/n)^{-n/4}        ≤ 2^{-n/4}·n²  ≤ 16   (at n = 16)

so

    |Φ (u'*(n:ℝ)) n - Φ (u*(n:ℝ)) n| ≤ 40·|u' - u|      (u,u' ∈ [1/2,1], n ≥ 16).

Earlier rounds targeted `25n` and even `20n`; the truth is **O(1) with constant 40**, which
is far stronger and makes the threshold inversion straightforward.

**Next action:** assemble that bound by summing `rpow_diff_abs_le` over `k = j+1` with the
`k ≤ n` / `k > n` split, then (i) `∂_pΦ(E·n,n) = -2/n + O(1/n²)`, (ii) the bracket
expansion, (iii) `R(E,n) = D(log2)/n² + O(1/n³)` — the third-order term, the one genuinely
new analytic input.

### 13.24 LANDED (round 20): telescoping helpers for the tail majorant

`Op56/PhiThird.lean` now has **22 lemmas** (0 sorries, 7/7 OK), newly:

```lean
lemma sum_range_inv_sub (n N : ℕ) :
    (∑ i ∈ Finset.range N, (1/((n:ℝ)+i) - 1/((n:ℝ)+(i+1)))) = 1/(n:ℝ) - 1/((n:ℝ)+N)

lemma inv_succ_sq_le (m : ℕ) (hm : 1 ≤ m) :
    (1/((m:ℝ)+1))^2 ≤ 1/((m:ℝ)*((m:ℝ)+1))
```

These are the two ingredients of the tail majorant
`Σ_{k>n} k^{-2} ≤ Σ_{i} 1/((n+i)(n+i+1)) = 1/n`.

**Tactic notes:**
* `Finset.sum_range_sub f N : ∑ i∈range N, (f (i+1) - f i) = f N - f 0` — note the
  argument order is `f (i+1) - f i`, the *reverse* of the telescoping form one usually
  writes; get the wanted direction with `Finset.sum_sub_distrib` then `linarith`.
* `↑(x+1)` and `↑x + 1` are **not** syntactically equal for `linarith`; normalise with
  `simp only [Nat.cast_add, Nat.cast_one, Nat.cast_zero, add_zero]` before `linarith`.
* `hasSum_iff_tendsto_nat` does **not** exist for `ℝ`; the available form is
  `hasSum_iff_tendsto_nat_of_nonneg (h : ∀ i, 0 ≤ f i) r : HasSum f r ↔
  Tendsto (fun N => ∑ i ∈ range N, f i) atTop (𝓝 r)`.  (For `ℝ≥0`/`ℝ≥0∞` the plain
  version exists.)  This is what the limit step of the `Σ k^{-2}` bound must use, since
  `1/(n+i) - 1/(n+i+1) ≥ 0`.

**Next step for the tail bound:** apply `hasSum_iff_tendsto_nat_of_nonneg` to
`f i = 1/((n:ℝ)+i) - 1/((n:ℝ)+(i+1))` with limit `1/n` (partial sums are
`sum_range_inv_sub`), then `Summable.tsum_le_tsum` against `f` using `inv_succ_sq_le`
and the shift `(n+1+i)⁻² ≤ 1/((n+i)(n+i+1))` to get
`Σ'_i (n+1+i)^{-2} ≤ 1/n`.

### 13.25 LANDED (round 21): the tail inverse-square bound — tail machinery complete

`Op56/PhiThird.lean` now has **27 lemmas** (0 sorries, 7/7 OK), newly:

```lean
lemma tendsto_inv_nat_add_zero (n : ℕ) :
    Filter.Tendsto (fun N : ℕ => 1/((n:ℝ)+N)) Filter.atTop (𝓝 0)

lemma nonneg_inv_sub_inv_succ (n i : ℕ) (hn : 1 ≤ n) :
    (0:ℝ) ≤ (1/((n:ℝ)+i) - 1/((n:ℝ)+(i+1)))

lemma hasSum_inv_mul_inv_succ (n : ℕ) (hn : 1 ≤ n) :
    HasSum (fun i : ℕ => (1/((n:ℝ)+i) - 1/((n:ℝ)+(i+1)))) (1/(n:ℝ))

lemma tsum_inv_mul_inv_succ (n : ℕ) (hn : 1 ≤ n) :
    (∑' i : ℕ, (1/((n:ℝ)+i) - 1/((n:ℝ)+(i+1)))) = 1/(n:ℝ)

lemma tsum_inv_succ_sq_le (n : ℕ) (hn : 1 ≤ n) :
    (∑' i : ℕ, (1/((n:ℝ)+i+1))^2) ≤ 1/(n:ℝ)
```

The last is the **`tsum` form of `Σ_{k>n} k^{-2} ≤ 1/n`** — the final piece of the `k > n`
regime of the `Φ`-Lipschitz bound, and it is **integral-free** (comparison with the
telescoping series, via `Summable.tsum_le_tsum` and `inv_succ_sq_le`).

**Tactic notes:**
* `tendsto_atTop_add_const_left` is **not** available under that name in this toolchain;
  build `Tendsto (fun N => (n:ℝ)+N) atTop atTop` directly with
  `rw [Filter.tendsto_atTop]` + `Filter.eventually_ge_atTop (Nat.ceil (b - n))` +
  `Nat.le_ceil`.
* `(fun r => r⁻¹) ∘ g` is **not** `simpa`-reduced to `fun N => (g N)⁻¹`; state the
  function equality explicitly with `funext N; simp [one_div]` and `rw` it.
* watch out that `1/(n+i) - 1/(n+i+1) ≥ 0` **fails for `n = 0`** (Lean's totalised
  division makes the `i = 0` term `0 - 1 = -1`) — the `1 ≤ n` hypothesis is required, and
  `positivity` alone cannot discharge `0 < ↑n + ↑i` without first casting `0 < n`.
* when a lemma is stated `(n i : ℕ) (hn : 1 ≤ n)`, passing it where `∀ i, …` is expected
  needs `fun i => lem n i hn`, not `lem n hn`.

### 13.26 LANDED (round 22): finite regime of the Lipschitz sum

`Op56/PhiThird.lean` now has **28 lemmas** (0 sorries, 7/7 OK), newly:

```lean
lemma phi_deriv_term_finite (n k : ℕ) (hn : 4 ≤ n) (hk : 1 ≤ k) (hkn : k ≤ n) :
    (n:ℝ) * Real.log (1 + (k:ℝ)/(n:ℝ)) * (1 + (k:ℝ)/(n:ℝ)) ^ (-((n:ℝ)/2))
      ≤ (k:ℝ) * Real.exp (-(k:ℝ)/4)
```

Uses `log(1+x) ≤ x` (for `n log(1+k/n) ≤ k`) and `log(1+x) ≥ x/2` on `[0,1]` (for
`(1+k/n)^{-n/2} ≤ e^{-k/4}`).  Summing gives `≤ Σ_k k e^{-k/4} ≤ 20` via
`tsum_mul_exp_le` at `u = 1/2`.

**Tactic note:** `log_one_add_le` (the project's own lemma) takes `(x) (0 < 1 + x)` — the
second argument is strict positivity of the *sum*, not `0 ≤ x`; `log_one_add_ge` takes
`(x) (0 ≤ x)`.

**The tail regime — exact algebra, ready to formalise.**  For `n < k` put `m := n/4`.
Using `rpow_decay_tail` at `u = 1/2`,

    n·log(1+k/n)·(1+k/n)^{-n/2}
      ≤ k·(1+k/n)^{-n/2}
      ≤ k·2^{-m}·(k/n)^{-m}
      = 2^{-m}·n^m·k^{1-m}
      ≤ 2^{-m}·n^3·k^{-2}          ⟺   (n/k)^{m-3} ≤ 1

the last step holding because `n < k` and `m ≥ 3` (i.e. `n ≥ 12`).  Therefore

    Σ_{k>n} n·log(1+k/n)·(1+k/n)^{-n/2} ≤ 2^{-n/4}·n^3·Σ_{k>n} k^{-2}
                                        ≤ 2^{-n/4}·n^3·(1/n)   (round 21)
                                        = 2^{-n/4}·n²  ≤ 16   (at n = 16)

so the Lipschitz constant is `20 + 16 = 36`; **use `C = 40`**.  In Lean the
`(n/k)^{m-3} ≤ 1` step is `Real.rpow_le_rpow hn.le hnk.le (0 ≤ n/4 - 3)`, and the statement
is cleanest with the tail RHS written as `2^{-n/4}·n³/k²` (avoiding the real-exponent
numeral `(k:ℝ)^(-2)`, which fails instance synthesis — the recurring
`(k:ℝ)^((-2:ℝ))` annotation issue of round 19).

### 13.27 LANDED (round 23): tail regime of the Lipschitz sum — both regimes done

`Op56/PhiThird.lean` now has **29 lemmas** (0 sorries, 7/7 OK), newly:

```lean
lemma phi_deriv_term_tail (n k : ℕ) (hn : 12 ≤ n) (hkn : n < k) :
    (n:ℝ) * Real.log (1 + (k:ℝ)/(n:ℝ)) * (1 + (k:ℝ)/(n:ℝ)) ^ (-((n:ℝ)/2))
      ≤ (2:ℝ)^(-((n:ℝ)/4)) * (n:ℝ)^3 / (k:ℝ)^2
```

Both summand regimes of the `Φ`-Lipschitz bound are now proved termwise:
`phi_deriv_term_finite` (round 22) for `k ≤ n`, `phi_deriv_term_tail` for `k > n`.

**Key simplification found this round.**  The reduction to `k^{-2}` needs *no* `rpow_add`
algebra: from `rpow_decay_tail` at `u = 1/2` one gets the factor `(k/n)^{-n/4}`, and since
the base is `≥ 1` and `-n/4 ≤ -3`,

    (k/n)^{-n/4} ≤ (k/n)^{-3}        (`Real.rpow_le_rpow_of_exponent_le`)

so `k·(k/n)^{-n/4} ≤ k·(k/n)^{-3} = n³/k²`.  That replaces the `(n/k)^{m-3}` route of
§13.26 with a single monotonicity step.

**Tactic notes:**
* `Real.rpow_le_rpow_of_exponent_le (hx : 1 ≤ x) (hyz : y ≤ z) : x^y ≤ x^z` is the base
  `≥ 1` monotonicity lemma (not `rpow_le_rpow`, which is for the *base*).
* `Real.rpow_neg` produces the exponent as **`(3 : ℝ)` in `Real.rpow` form**, so
  `div_pow` will not fire on it: insert
  `rw [show x^((3:ℝ)) = x^(3:ℕ) by exact Real.rpow_natCast _ 3]` first.  (The bare
  `rw [Real.rpow_natCast]` does not match — the explicit two-argument form does.)
* `field_simp` sometimes already closes the goal; a trailing `ring` then reports
  `No goals to be solved`.

**Remaining for the Lipschitz bound:** assemble the `tsum` (`tsum_sub` for
`Φ(u'n) − Φ(un)`, `sum_add_tsum_nat_add n` for the split at `j = n`, `tsum_le_tsum` in each
regime) to obtain `|Φ (u'*(n:ℝ)) n − Φ (u*(n:ℝ)) n| ≤ 40·|u' − u|` for `u,u' ∈ [1/2,1]`,
`n ≥ 16` — bounds `20` (finite, `tsum_mul_exp_le`) and `16` (tail,
`tsum_inv_succ_sq_le`) give the constant 36, so `C = 40`.

### 13.28 LANDED (round 24): finite regime summed

`Op56/PhiThird.lean` now has **32 lemmas** (0 sorries, 7/7 OK), newly:

```lean
lemma tsum_mul_exp_quarter_le : (∑' k : ℕ, (k:ℝ) * Real.exp (-(k:ℝ)/4)) ≤ 20
lemma summable_mul_exp_quarter : Summable (fun k : ℕ => (k:ℝ) * Real.exp (-(k:ℝ)/4))
lemma sum_range_deriv_le (n : ℕ) (hn : 16 ≤ n) :
    (∑ j ∈ Finset.range n, (n:ℝ) * Real.log (1 + ((j:ℝ)+1)/(n:ℝ))
        * (1 + ((j:ℝ)+1)/(n:ℝ)) ^ (-((n:ℝ)/2))) ≤ 20
```

So the finite regime contributes `≤ 20`.  The tail regime contributes
`2^{-n/4}·n² ≤ 16` (rounds 21 + 23), giving the Lipschitz constant `36`; **use `C = 40`**.

**Tactic notes:**
* `Summable.sum_le_tsum` is `(s : Finset ι) (h : ∀ i ∉ s, 0 ≤ f i) (hf : Summable f)`, i.e. the
  nonnegativity hypothesis is only required **off** the finset — and as a method it is
  `hf.sum_le_tsum s (fun i _ => …)`.  Passing `f`-nonneg for *all* `i` (the signature of
  `Summable.of_nonneg_of_le`) is a type error.
* `Finset.sum_range_succ' : ∑ i ∈ range (n+1), f i = ∑ i ∈ range n, f (i+1) + f 0` reindexes
  the shift; with `f 0 = 0` a following `simp` closes the identity
  `∑_{j<n}(j+1)e^{-(j+1)/4} = ∑_{k≤n} k e^{-k/4}`.
* reindexing `Σ'_k k e^{-(1/2·k)/2} = Σ'_k k e^{-k/4}` is `tsum_congr` plus an inner
  `ring` on the exponent.

**Next:** the tail `tsum` `Σ'_i g (i+n) ≤ 16` (via `phi_deriv_term_tail` and
`tsum_inv_succ_sq_le`, needing `Summable (fun i => (1/((n:ℝ)+i+1))²)`), then the assembly
`Φ (u'*n) n − Φ (u*n) n = Σ'_j (T_j(u') − T_j(u))` (`Summable.tsum_sub` +
`summable_phi`), `|Σ'| ≤ Σ'|·|`, `sum_add_tsum_nat_add` for the split, and `tsum_le_tsum`
in each regime.

### 13.29 LANDED (round 25): the Lipschitz constant is 40

`Op56/PhiThird.lean` now has **33 lemmas** (0 sorries, 7/7 OK), newly:

```lean
lemma two_rpow_neg_quarter_mul_sq_le (n : ℕ) (hn : 16 ≤ n) :
    (2:ℝ)^(-(n:ℝ)/4) * (n:ℝ)^2 ≤ 16
```

This is the `2^{-n/4}·n² ≤ 16` bound needed to close the tail regime.  Substituting
`n = 16 + m` it becomes `(1 + m/16)² ≤ 2^{m/4}`, which follows from
`1 + m/16 ≤ 2^{m/8}`, and that is `Real.add_one_le_exp` together with `log 2 ≥ 1/2`
(`Real.log_two_gt_d9`).

**With this, the two regimes give `20` (finite, round 24) + `16` (tail, rounds 21/23) = 36,
so the `Φ`-Lipschitz constant is `C = 40`.**

**Tactic notes:**
* `Nat.exists_eq_add_of_le hn` gives the substitution `n = 16 + m`; follow it with
  **`push_cast`** — otherwise the goal keeps `↑(16+m)` and every later `rw` misses.
* `linarith` treats `a * b` and `b * a` as **different atoms**: prove the commutation as an
  explicit `have he2 : a * b = b * a := by ring` and pass it to `linarith`.
* `Real.rpow_natCast`/`Real.rpow_mul` must be given explicitly
  (`rw [← Real.rpow_natCast _ 2, ← Real.rpow_mul (by norm_num : (0:ℝ) ≤ 2)]`) to convert
  `(2^(m/8))^2` into `2^(m/4)`; `mul_pow` first, since `2^(m/8) * 2^(m/8)` no longer
  occurs afterwards.

**Next:** the tail `tsum`, `Σ'_i g (i+n) ≤ 2^{-n/4}·n² ≤ 16` (from `phi_deriv_term_tail`
and `tsum_inv_succ_sq_le`), then the assembly of
`|Φ (u'*n) n − Φ (u*n) n| ≤ 40·|u' − u|`.

### 13.30 LANDED (round 26): summability of the inverse-square majorant

`Op56/PhiThird.lean` now has **35 lemmas** (0 sorries, 7/7 OK), newly:

```lean
lemma inv_succ_sq_le_inv_sub (n i : ℕ) (hn : 1 ≤ n) :
    (1/((n:ℝ)+i+1))^2 ≤ (1/((n:ℝ)+i) - 1/((n:ℝ)+(i+1)))

lemma summable_inv_succ_sq (n : ℕ) (hn : 1 ≤ n) :
    Summable (fun i : ℕ => (1/((n:ℝ)+i+1))^2)
```

These are the pointwise bound and the summability side condition that the tail `tsum`
needs for `Summable.tsum_le_tsum`; they were previously inline inside
`tsum_inv_succ_sq_le`.

**Tail `tsum` in progress — the exact failures to fix.**  The target

```lean
lemma tsum_deriv_shift_le (n : ℕ) (hn : 16 ≤ n) :
    (∑' i : ℕ, (n:ℝ) * Real.log (1 + (((i:ℝ)+(n:ℝ)+1))/(n:ℝ))
        * (1 + (((i:ℝ)+(n:ℝ)+1))/(n:ℝ)) ^ (-((n:ℝ)/2))) ≤ 16
```

was drafted but failed in four places; the fixes are:

1. `simpa only [Nat.cast_add, Nat.cast_one] using phi_deriv_term_tail n (i+n+1) …`
   does **not** match — the goal carries `↑i + ↑n + 1` while the lemma carries `↑(i+n+1)`.
   Use `convert h using 2 <;> push_cast <;> ring`.
2. the nonnegativity of the summand is not `positivity`-provable (the factor
   `(1+…)^(-n/2)` blocks it): supply
   `mul_nonneg (mul_nonneg (Nat.cast_nonneg n) (Real.log_nonneg (by linarith)))
   (Real.rpow_nonneg (by linarith) _)` by hand.
3. `(↑(i+n+1) : ℝ)` vs `(n:ℝ)+i+1` must be normalised by an explicit
   `rw [show (((i:ℝ)+(n:ℝ)+1)) = ((n:ℝ)+i+1) by ring]` **before** any `tsum_congr` body
   `ring`, otherwise the `rw` reports "pattern not found".
4. `Σ'_i C/(…)^2 = C·Σ'_i 1/(…)^2` needs `← tsum_mul_left` and the rewriting
   `(C/x²) = C * (1/x²)`; `div_eq_mul_inv, inv_pow, one_div` then `ring` works.

Everything else in the draft is in place (`phi_deriv_term_tail` termwise,
`tsum_inv_succ_sq_le` for the `1/n`, `two_rpow_neg_quarter_mul_sq_le` for the final `16`).

### 13.31 LANDED (round 27): tail regime summed — Lipschitz machinery complete

`Op56/PhiThird.lean` now has **36 lemmas** (0 sorries, 7/7 OK), newly:

```lean
lemma tsum_deriv_shift_le (n : ℕ) (hn : 16 ≤ n) :
    (∑' i : ℕ, (n:ℝ) * Real.log (1 + (((i:ℝ)+(n:ℝ)+1))/(n:ℝ))
        * (1 + (((i:ℝ)+(n:ℝ)+1))/(n:ℝ)) ^ (-((n:ℝ)/2))) ≤ 16
```

So both regimes of the Lipschitz sum are bounded: `20` (finite, round 24) and `16` (tail,
this round), giving the constant `40`.

**All machinery for the `Φ`-Lipschitz bound is now landed.**  Only the assembly remains:

    Φ (u'*(n:ℝ)) n − Φ (u*(n:ℝ)) n = Σ'_j (T_j(u') − T_j(u))       Summable.tsum_sub, summable_phi
    |Σ'| ≤ Σ' |·|                                                  abs_tsum_le_tsum_abs
    Σ'|·| ≥ split at j = n                                          Summable.sum_add_tsum_nat_add
    finite part ≤ 20·|u'−u|                                         sum_range_deriv_le
    tail part ≤ 16·|u'−u|                                           tsum_deriv_shift_le
    ⟹ |Φ (u'*n) n − Φ (u*n) n| ≤ 40·|u'−u|                          (n ≥ 16, u,u' ∈ [1/2,1])

**Tactic fixes that closed the tail (from the §13.30 diagnosis):**
* `↑(i+n+1)` vs `↑i+↑n+1`: insert `have hcast : ↑i+↑n+1 = ↑(i+n+1) := by
  simp only [Nat.cast_add, Nat.cast_one]` (with `push_cast; ring` the goal is already
  closed, so a trailing `ring` errors) and `rw [hcast]`.
* `2^(-(↑n/4))` vs `2^(-↑n/4)`: normalise with `rw [neg_div]`.
* nonnegativity of the summand needs
  `mul_nonneg (mul_nonneg (by positivity) (Real.log_nonneg hx)) (Real.rpow_nonneg …)` by
  hand (`positivity` cannot see through the `rpow`).
* `C/x² = C·(1/x)²` needs `div_eq_mul_inv` on **both** sides:
  `rw [div_eq_mul_inv, one_div, inv_pow, div_eq_mul_inv]`.

### 13.32 Round-28: Lipschitz assembly drafted; exact remaining errors identified

The full assembly

```lean
lemma Phi_lipschitz_p (u u' : ℝ) (n : ℕ)
    (hu1 : 1/2 ≤ u) (hu1' : 1/2 ≤ u') (hn : 16 ≤ n) :
    |Phi (u'*(n:ℝ)) n - Phi (u*(n:ℝ)) n| ≤ 40 * |u' - u|
```

was drafted and comes down to **four mechanical errors**, all diagnosed (nothing new
landed, build still green with 36 lemmas):

1. **`Summable.tsum_neg` does not exist.**  The lemma is the free-standing
   `tsum_neg : ∑' b, -f b = -∑' b, f b`.  For `-∑' f ≤ ∑' |f|`, use
   `rw [← tsum_neg]` then `Summable.tsum_le_tsum (fun j => neg_le_abs _) hf.neg hf.abs`.
2. **`Finset.mul_sum` direction.**  It states `a * ∑ i ∈ s, f i = ∑ i ∈ s, a * f i`; the
   goal `∑ j, |u'-u| * g j = |u'-u| * ∑ j, g j` needs `rw [Finset.mul_sum]` applied to the
   **RHS** (i.e. plain `rw`, not `←`), or `rw [Finset.mul_sum]` after `rw [mul_comm]`.
3. **Tail summability.**  `Summable (fun i => |f (i+n)|)` is obtained from
   `hsum_abs : Summable (fun j => |f j|)` by
   `hsum_abs.comp_injective (fun a b h => Nat.add_right_cancel h)`
   (`Summable.comp_injective (hf) (Injective i) : Summable (f ∘ i)`), since
   `Summable.nat_add` does **not** exist.
4. `positivity` cannot discharge the nonnegativity of `g j` (the `rpow` factor blocks it);
   supply `mul_nonneg (mul_nonneg (by positivity) (Real.log_nonneg hx)) (Real.rpow_nonneg …)`
   by hand, as in `tsum_deriv_shift_le`.

Everything else in the draft type-checks: `Summable.tsum_sub` for the difference,
`abs_le.mpr` with the two one-sided `tsum_le_tsum` bounds for `|Σ'| ≤ Σ'|·|`,
`sum_add_tsum_nat_add` for the split, `sum_range_deriv_le` (finite, 20) and
`tsum_deriv_shift_le` (tail, 16) for the two parts, and `linarith` for `20+16 ≤ 40`.

### 13.33 LANDED (round 29): the `Φ`-Lipschitz bound

`Op56/PhiThird.lean` now has **38 lemmas** (0 sorries, 7/7 OK), newly:

```lean
lemma summable_deriv_shift (n : ℕ) (hn : 16 ≤ n) : Summable (… tail summand …)

lemma Phi_lipschitz_p (u u' : ℝ) (n : ℕ)
    (hu1 : 1/2 ≤ u) (hu1' : 1/2 ≤ u') (hn : 16 ≤ n) :
    |Phi (u'*(n:ℝ)) n - Phi (u*(n:ℝ)) n| ≤ 40 * |u' - u|
```

**This is step 1 of the four-step route to `op5_threshold_asymptotic`, and it is the
result rounds 9–28 were building toward.**  The constant is `O(1)` — not `O(n)` — because
`∂_pΦ ≈ −2/n`.

Assembly used `Summable.tsum_sub` (difference), `abs_le.mpr` over `le_abs_self`/`neg_le_abs`
one-sided `tsum_le_tsum` bounds (`|Σ'| ≤ Σ'|·|`), `Summable.sum_add_tsum_nat_add` (split at
`j = n`), then `sum_range_deriv_le` (finite, 20) and `tsum_deriv_shift_le` (tail, 16).

**All four §13.32 fixes were needed and sufficient:**
* `tsum_neg` (free-standing, not a `Summable` method), used as `rw [← tsum_neg]`;
* `Finset.mul_sum` applied **left-to-right** to the RHS of `∑ |u'−u|·g = |u'−u|·∑ g`;
* tail summability via `hfabs.comp_injective (fun a b h => Nat.add_right_cancel h)`;
* hand-built `mul_nonneg` for the `rpow` summand.
* One more: `abs_le.mpr` takes `⟨−b ≤ a, a ≤ b⟩`, so the `−Σ'f ≤ Σ'|f|` component comes
  first (via `linarith`), not the `Σ'f ≤ Σ'|f|` one.

**Remaining for `op5_threshold_asymptotic`** (from §13.21):
2. `PhiD_limit : |∂_pΦ (E·n, n) + 2/n| ≤ C/n²` — first-order, `n log(1+k/n) → k`,
   `(1+k/n)^{-un} → e^{-uk}`, `Σ k e^{-uk} = 2` at `u = log2`;
3. the bracket expansion `(e^E-1)⁻¹ + (E/2n)ΦS(E) − 1 = [−(51/4)log2² + (9/2)log2]/n² + O(1/n³)`;
4. `R(E,n) = D(log2)/n² + O(1/n³)` — the third-order coefficient;
then `d_n = u_n − E = c/n² + O(1/n³)` and `Pfun n = thresholdAsym n + O(1/n²)`.

### 13.34 LANDED (round 30): cubic exponential remainder — start of the third-order term

`Op56/PhiThird.lean` now has **39 lemmas** (0 sorries, 7/7 OK), newly:

```lean
lemma exp_rem_cube (d : ℝ) (hd : |d| ≤ 1/2) :
    |Real.exp d - 1 - d - d^2/2| ≤ |d|^3
```

From `Real.exp_bound` at `n = 4` (note: **`Real.exp_bound`** takes `|x| ≤ 1` and works for
both signs, unlike `Real.exp_bound'` which needs `0 ≤ x` — the latter is why the negative
branch of `exp_rem_two_sq` needed a special argument).  The error after
`1 + d + d²/2 + d³/6` is `5|d|⁴/96`, so the total is `37|d|³/192 < |d|³`.

**This opens step 4 (the third-order coefficient).**  The termwise expansion is

    T_k = (1+k/n)^{-un} = exp(-un·log(1+k/n))
        = e^{-uk}·exp(y - z + sA(x)),    s = un, x = k/n, y = sx²/2, z = sx³/3,
        A(x) = x - log(1+x) - x²/2 + x³/3   (so log(1+x) = x - x²/2 + x³/3 - A(x))

and `phi_r4_bounds` (landed, round 6) gives `0 ≤ A(x) ≤ x⁴/2`.  Writing `G_k := e^{-uk}`
and `δ := y - z + sA(x)`, `exp_rem_cube` gives

    |T_k - G_k(1 + δ + δ²/2)| ≤ G_k·|δ|³,

and since `δ = y - z + O(k⁴/n³)`, expanding `(δ² - y²)/2` gives the target

    |T_k - G_k(1 + y - z + y²/2)| ≤ C·e^{-uk/2}·(k⁴ + k⁵ + k⁶)/n³.

Summing the three orders reproduces
`Φ = (e^u−1)^{-1} + (u/2n)ΦS(u) + D(u)/n² + O(1/n³)`, `D(u) = -(u/3)PhiK3u(u) + (u²/8)PhiK4u(u)`.

**Tactic notes:** `abs_add` does not exist in this toolchain — use **`abs_add_le`**;
`Real.exp_bound'` needs `0 ≤ x` while `Real.exp_bound` needs `|x| ≤ 1` (use the latter for
signed remainders); a `rw`-chain that already closes the goal makes a following `linarith`
report `No goals to be solved`.

### 13.35 LANDED (round 31): the third-order exponent identity

`Op56/PhiThird.lean` now has **40 lemmas** (0 sorries, 7/7 OK), newly:

```lean
lemma phi_log_expand (u : ℝ) (n k : ℕ) (hnR : (0:ℝ) < (n:ℝ)) :
    -(u*(n:ℝ)) * Real.log (1 + (k:ℝ)/(n:ℝ))
      = -(u*(k:ℝ)) + u*(k:ℝ)^2/(2*(n:ℝ)) - u*(k:ℝ)^3/(3*(n:ℝ)^2)
        + (u*(n:ℝ)) * ((k:ℝ)/(n:ℝ) - Real.log (1 + (k:ℝ)/(n:ℝ))
            - ((k:ℝ)/(n:ℝ))^2/2 + ((k:ℝ)/(n:ℝ))^3/3)
```

Proved by **`field_simp; ring`** (the `log` is an atom; `field_simp` clears the `1/n`
denominators).  This is the identity `-un·log(1+x) = -uk + y - z + un·A` that turns the
summand into `T_k = e^{-uk}·e^{δ}` with `δ = y - z + un·A`.

**Important scaling fact discovered this round.**  `δ = O(u k²/n)`, so the exponential
expansion `e^δ = 1 + δ + δ²/2 + …` is only valid while `δ = O(1)` — i.e. for
`4k² ≤ n`.  (At `k = n` one has `y = un/2`, so `δ > 1/2` and the expansion is meaningless.)
This is exactly the **truncate-at-`√n`-then-bound-geometrically** structure the
`Asymptotic.lean` comment predicted.  Concretely:

* for `4k² ≤ n`: `|δ| ≤ u/8 + u/48 + u/128 ≤ u/4 < 1/2`, and the third-order termwise
  bound is `|T_k − G_k(1+y−z+y²/2)| ≤ u·e^{−uk/2}(k⁴+k⁵+k⁶)/n³` (constant 1 works;
  the `−y²` cancellation in `δ² − y²` is what keeps the error at `k⁵/n³`, not `k⁴/n²`);
* for `4k² > n`: bound `T_k ≤ e^{−uk/2}` (`rpow_le_exp_half`) and the same for `G_k`; the
  resulting tail is exponentially small.

**In progress:** `phi_delta_bound` (`|δ| ≤ 1/2` for `4k² ≤ n`).  The pieces are
`y ≤ u/8` (from `k²/n ≤ 1/4`), `z ≤ u/48` (from `(k²/n)(k/n) ≤ (1/4)(1/4)`), and
`un·A ≤ u·n·x⁴/2 ≤ u/128` — all elementary, but the `calc`/`rw` plumbing needs care:
`rw [div_le_iff₀ _]` sometimes already closes the goal (then a following `linarith`
errors), and `field_simp` inside a `show` needs the `n ≠ 0` fact in scope.

### 13.36 LANDED (round 32): two of the three `δ` bound pieces

`Op56/PhiThird.lean` now has **42 lemmas** (0 sorries, 7/7 OK), newly:

```lean
lemma phi_delta_y_bound (u : ℝ) (n k : ℕ) (hu1 : 1/2 ≤ u) (hu2 : u ≤ 1)
    (hn : 16 ≤ n) (hk : 1 ≤ k) (hk4 : 4*k^2 ≤ n) : u*(k:ℝ)^2/(2*(n:ℝ)) ≤ u/8
lemma phi_delta_z_bound (u : ℝ) (n k : ℕ) (hu1 : 1/2 ≤ u) (hu2 : u ≤ 1)
    (hn : 16 ≤ n) (hk : 1 ≤ k) (hk4 : 4*k^2 ≤ n) : u*(k:ℝ)^3/(3*(n:ℝ)^2) ≤ u/48
```

Together with `un·A ≤ u/128` (below) these give `|δ| ≤ u/8 + u/48 + u/128 ≤ u/4 < 1/2`, and
hence `u/8 + u/48 + u/128 = u·0.1536 ≤ 1/2`.

**Tactic notes (all cost time this round):**
* `rw [div_le_div_iff₀ (by positivity : 0 < D₁) (by norm_num : 0 < D₂)]` then `nlinarith` is
  far more robust than going through `mul_le_mul_of_nonneg_left` + `calc` + `show … by ring`.
* for `z ≤ u/48` the key intermediate is `16·k⁴ ≤ n²` (`mul_self_le_mul_self` applied to
  `4k² ≤ n`) together with `k³ ≤ k⁴` (`mul_le_mul_of_nonneg_left hk1`); plain `nlinarith`
  will not synthesise the `k³ ≤ k⁴` step on its own.
* `by field_simp; ring` inside a `show`/`have` errors with `No goals to be solved` whenever
  `field_simp` already closes the goal — write `by field_simp` alone there.

**Remaining for `|δ| ≤ 1/2`:** `un·A ≤ u/128`, i.e. `n·x⁴/2 ≤ 1/128` for `x = k/n`, from
`x² ≤ k²/n ≤ 1/4` and `n ≥ 16`: `n·x⁴/2 = (k²/n)²/(2n) ≤ (1/16)/(2·16) = 1/512`.
Then the termwise third-order bound
`|T_k − G_k(1+y−z+y²/2)| ≤ u·e^{−uk/2}(k⁴+k⁵+k⁶)/n³` for `4k² ≤ n`, via `exp_rem_cube` and
`phi_log_expand`.

### 13.37 LANDED (round 33): `|δ| ≤ 1/2` — the exponential expansion is now legal

`Op56/PhiThird.lean` now has **44 lemmas** (0 sorries, 7/7 OK), newly:

```lean
lemma phi_delta_A_bound … : (u*(n:ℝ)) * A ≤ u/128
lemma phi_delta_bound … :
    |u*(k:ℝ)^2/(2*(n:ℝ)) - u*(k:ℝ)^3/(3*(n:ℝ)^2) + (u*(n:ℝ)) * A| ≤ 1/2
```

(where `A = x - log(1+x) - x²/2 + x³/3`).  The three pieces give
`|δ| ≤ u/8 + u/48 + u/128 = 59u/384 ≈ 0.154u < 1/2`, so **`exp_rem_cube` now applies to
`δ`** and the third-order termwise expansion is unblocked.

`phi_delta_A_bound` reduces `n·x⁴/2 = (k²/n)²/(2n) ≤ (1/4)²/(2·16) = 1/512`, the key
intermediate being `k⁴ ≤ n²/16` (`mul_self_le_mul_self` on `k² ≤ n/4`).

**Next: the termwise third-order bound.**  With `G_k = e^{-uk}` and `δ = y - z + un·A`
(`phi_log_expand`), `exp_rem_cube` gives
`|T_k − G_k(1 + δ + δ²/2)| ≤ G_k|δ|³`, and expanding `δ² − y²` gives

    |T_k − G_k(1 + y − z + y²/2)| ≤ u·e^{−uk/2}(k⁴ + k⁵ + k⁶)/n³     (4k² ≤ n).

The `−y²` cancellation in `δ² − y²` is what keeps the error at `k⁵/n³` rather than
`k⁴/n²`; a naive bound breaks the step (§13.35).

**Tactic notes:** the pattern `rw [he, div_le_iff₀ (by positivity : 0 < D)]` then
`nlinarith` needs the *squared* intermediates supplied explicitly (`mul_self_le_mul_self`);
`nlinarith` alone will not chain `a ≤ b` into `a² ≤ b²`.

### 13.38 LANDED (round 34): algebraic setup for the termwise third-order bound

`Op56/PhiThird.lean` now has **47 lemmas** (0 sorries, 7/7 OK), newly:

```lean
lemma phi_term_expand (u : ℝ) (n k : ℕ) (hnR : 0 < (n:ℝ)) :
    (1 + (k:ℝ)/(n:ℝ)) ^ (-(u*(n:ℝ))) = Real.exp (-(u*(k:ℝ))) * Real.exp δ
lemma phi_term_diff_decomp (d y z : ℝ) :
    Real.exp d - (1 + y - z + y^2/2)
      = (Real.exp d - 1 - d - d^2/2) + (d - (y - z)) + (d^2 - y^2)/2
lemma phi_delta_sq_sub (y z sA : ℝ) :
    (y - z + sA)^2 - y^2 = -2*(y*z) + z^2 + 2*(y-z)*sA + sA^2
```

`phi_term_expand` is `Real.rpow_def_of_pos` + `← Real.exp_add` + `phi_log_expand`.

**The error bound, term by term.**  With `G = e^{-uk}`, `δ = y-z+un·A`, and
`T_k - G(1+y-z+y²/2) = G[(e^δ-1-δ-δ²/2) + un·A + (δ²-y²)/2]`, the three pieces are

    |e^δ - 1 - δ - δ²/2| ≤ |δ|³          (exp_rem_cube, |δ| ≤ 1/2)
    un·A                 ≤ u k⁴/(2n³)     (≤ 0.5·u k⁶/n³ for k ≥ 1)
    |δ²-y²|/2            ≤ zy + z²/2 + |y-z|·sA + sA²/2
                         = u²k⁵/(6n³) + O(k⁶/n⁴ + k⁷/n⁵ + k⁸/n⁶)

and each of the last group is `≤ u k⁶/n³` once `4k² ≤ n` (so `k/n ≤ 1/4`, `k²/n ≤ 1/4`):
`zy = u²k⁵/(6n³)`, `z² ≤ u²k⁶/(9n⁴)`, `|y-z|sA ≤ u²k⁶/(2n⁴)`, `sA² ≤ u²k⁸/(4n⁶)`.
Also `|δ|³ ≤ (0.615·uk²/n)³ ≤ 0.232·u k⁶/n³`.

**So `|T_k - G(1+y-z+y²/2)| ≤ 2·u·e^{-uk/2}·k⁶/n³` (using `G ≤ e^{-uk/2}`) — `C = 2`
suffices.**  The `k⁶` form is equivalent to `k⁴+k⁵+k⁶` for `k ≥ 1`.

**Caution (a false route to avoid).**  Do **not** bound `z + sA` by a multiple of `y` and then
`(z+sA)(2y+sA)` by `y²`: that introduces a spurious `y² = u²k⁴/(4n²)` term, which is
*not* `O(k⁶/n³)` (it is larger by a factor `n/k²`), and the bound fails for small `k` and
large `n`.  Expand the product as in `phi_delta_sq_sub` and bound `zy`, `z²`, `y·sA`,
`z·sA`, `sA²` separately.

### 13.39 LANDED (round 35): quantitative `δ` bound `|δ| ≤ (59/96)·u·k²/n`

`Op56/PhiThird.lean` now has **48 lemmas** (0 sorries, 7/7 OK), newly:

```lean
lemma phi_delta_abs_bound (u : ℝ) (n k : ℕ) (hu1 : 1/2 ≤ u) (hu2 : u ≤ 1)
    (hn : 16 ≤ n) (hk : 1 ≤ k) (hk4 : 4*k^2 ≤ n) :
    |u*(k:ℝ)^2/(2*(n:ℝ)) - u*(k:ℝ)^3/(3*(n:ℝ)^2) + (u*(n:ℝ)) * A|
      ≤ (59/96) * u * ((k:ℝ)^2/(n:ℝ))
```

so `|δ|³ ≤ (59/96)³·u³k⁶/n³ ≈ 0.232·u k⁶/n³` — the sharp form needed (the crude
`|δ| ≤ u/8+u/48+u/128` of `phi_delta_bound` is **not** enough, since it loses the
`k`-dependence and the sum does not give `O(1/n³)`).

**The three pieces, with the common factor `T = u k²/n`:**  `y = (1/2)T` exactly,
`z = T·k/(3n) ≤ (1/12)T` and `sA ≤ T·k²/(2n²) ≤ (1/32)T`, both using `4k ≤ n` (which follows
from `4k² ≤ n`, `k ≥ 1` via `k ≤ k²`).

**Tactic notes:**
* `ring_nf` does **not** close a `≤` goal whose two sides are equal — use
  `le_of_eq (by …; ring)`.
* the `4k ≤ n` step needs the explicit intermediate `k ≤ k²` (`nlinarith [hk1]`);
  `nlinarith` will not chain `k ≥ 1` into it unaided.
* keep everything in **multiplicative** form (`Z = T * (k/(3n))`) rather than dividing
  through by `n`: `nlinarith` cannot see through `/n`, and `field_simp` then
  `nlinarith` works but is more fragile.

### 13.40 Round-36: termwise assembly drafted; failures enumerated

The full termwise bound

```lean
lemma phi_term_sharp3 (u : ℝ) (n k : ℕ)
    (hu1 : 1/2 ≤ u) (hu2 : u ≤ 1) (hn : 16 ≤ n) (hk : 1 ≤ k) (hk4 : 4*k^2 ≤ n) :
    |(1 + (k:ℝ)/(n:ℝ)) ^ (-(u*(n:ℝ)))
      - Real.exp (-(u*(k:ℝ))) * (1 + u*(k:ℝ)^2/(2*(n:ℝ))
          - u*(k:ℝ)^3/(3*(n:ℝ)^2) + (u*(k:ℝ)^2/(2*(n:ℝ)))^2/2)|
      ≤ 2 * u * Real.exp (-(u*(k:ℝ))/2) * (k:ℝ)^6 / (n:ℝ)^3
```

was drafted but not landed (build still green, 48 lemmas).  The **complete numeric budget is
now settled** — with `R := u·k⁶/n³`:

| piece | bound | source |
|---|---|---|
| `\|e^d − 1 − d − d²/2\|` | `≤ (59/96)³·R ≈ 0.233·R` | `exp_rem_cube` + `phi_delta_abs_bound`, cubed |
| `sA` | `≤ (1/2)·R` | `phi_delta_A_bound`-style, `u k⁴/(2n³) ≤ R/2` for `k ≥ 1` |
| `yz` | `= u²k⁵/(6n³) ≤ R/6` | |
| `z²/2` | `≤ R/(18·16)` | `z² = u²k⁶/(18n⁴)`, `n ≥ 16` |
| `\|y−z\|·sA` | `≤ R/(4·16)` | `z ≤ y/6` so `\|y−z\| ≤ y`, `y·sA ≤ u²k⁶/(4n⁴)` |
| `sA²/2` | `≤ R/(32n²)` | `sA² ≤ u²k⁸/(8n⁶)` |

Total `≈ 0.233 + 0.5 + 0.186 = 0.92 < 1`, and `G = e^{−uk} ≤ e^{−uk/2}`, so
**`≤ 2·u·e^{−uk/2}·k⁶/n³` with room to spare**.

**Failures to fix in the draft (`/tmp/z60.lean`, not in the repo):**
1. a **parser** error on `2*|y-z|*sA` — writing an `abs` in the middle of a `*` chain needs
   parentheses: `2 * (|y-z| * sA)` or `|y-z| * sA * 2`.
2. `rw [abs_of_nonneg (sq_nonneg sA), abs_of_nonneg (sq_nonneg z)] at *` rewrote too
   aggressively and closed goals the following `linarith` then wanted (`No goals to be
   solved`); scope the rewrites with `simp only [...] at h6 h7 h8`.
3. the `sA ≤ R/2` step used `R * (1/(2k²))` with `field_simp; ring` — `field_simp` closes it,
   so the trailing `ring` errors (recurring trap).
4. the bound `\|d\|³ ≤ (59/96)³R` went through `pow_le_pow_left₀` then a `ring` rewrite
   `((59/96)u(k²/n))³ = (59/96)³R`; the latter needs `rw [hR]; ring` **after** unfolding
   `R`, and `linarith` alone will not see it.

**Remaining after this:** sum the three orders over `k` to get
`Φ = (e^u−1)^{−1} + (u/2n)ΦS(u) + D(u)/n² + O(1/n³)` (using `Σ k⁴e^{−uk}`, `Σ k⁵e^{−uk}`,
`Σ k⁶e^{−uk}`), then the inversion.

### 13.41 LANDED (round 37): `sA ≤ R/2` piece of the third-order budget

`Op56/PhiThird.lean` now has **49 lemmas** (0 sorries, 7/7 OK), newly:

```lean
lemma phi_sA_bound (u : ℝ) (n k : ℕ) (hu1 : 1/2 ≤ u) (hu2 : u ≤ 1)
    (hn : 16 ≤ n) (hk : 1 ≤ k) (hk4 : 4*k^2 ≤ n) :
    (u*(n:ℝ)) * A ≤ (1/2) * (u * (k:ℝ)^6 / (n:ℝ)^3)          (R := u·k⁶/n³)
```

via `u k⁴/(2n³) = R·(1/(2k²)) ≤ R/2` for `k ≥ 1`.

**`phi_d3_bound` (`|δ|³ ≤ (59/96)³·R`) — one rewrite short.**  The proof goes through
`pow_le_pow_left₀` to `|δ|³ ≤ ((59/96)·u·(k²/n))³`, then needs

    ((59/96)·u·(k²/n))³ = (59/96)³ · (u³ · k⁶/n³)   then   u³ ≤ u  (u ≤ 1).

**The obstacle is purely notational:** Lean parses `u^3 * (k:ℝ)^6/(n:ℝ)^3` as
`(u³·k⁶)/n³`, while the goal produced by `h2` carries `u³ · (k⁶/n³)`; `mul_le_mul_of_nonneg_right`,
`linarith` and `nlinarith` all fail to bridge the two parenthesizations.  The fix is to
`set X : ℝ := (k:ℝ)^6/(n:ℝ)^3` **before** stating the goal, so both sides are literally
`u^3 * X` and `u * X`, and then `mul_le_mul_of_nonneg_right hu3 hX0` closes it directly.
(Equivalently: state the intermediate as a `calc` with explicit `ring` steps — but the
`ring` must be given each side of the division, not the composed expression.)

**Tactic notes:** `ring_nf` cannot prove
`((59/96)·u·(k²/n))³ = (59/96)³·(u³·k⁶/n³)` (division); use `rw [mul_pow, mul_pow, div_pow]`
then `ring`.  `field_simp` closes `u k⁴/(2n³) = R·(1/(2k²))` on its own — a trailing `ring`
then errors.  `u³ ≤ u` needs the explicit `u² ≤ 1` (`mul_le_mul_of_nonneg_left hu2' hu0`).

### 13.42 LANDED (round 38): `phi_d3_bound` — the `|δ|³` piece

`Op56/PhiThird.lean` now has **50 lemmas** (0 sorries, 7/7 OK), newly:

```lean
lemma phi_d3_bound (u : ℝ) (n k : ℕ) (hu1 : 1/2 ≤ u) (hu2 : u ≤ 1)
    (hn : 16 ≤ n) (hk : 1 ≤ k) (hk4 : 4*k^2 ≤ n) :
    |δ|^3 ≤ ((59/96)^3) * (u * ((k:ℝ)^6/(n:ℝ)^3))
```

**The §13.41 fix worked exactly as predicted:** `set X : ℝ := (k:ℝ)^6/(n:ℝ)^3` before
stating the goal, then `mul_le_mul_of_nonneg_right hu3 hX0` closes it.  Additionally the
lemma's own RHS must be written **`(u * ((k:ℝ)^6/(n:ℝ)^3))`** — with `u * (k:ℝ)^6/(n:ℝ)^3`
Lean parses `((u*k⁶)/n³)` and the two forms are not interchangeable for `linarith`.

**Third-order budget status (`R := u·k⁶/n³`):**

| piece | bound | status |
|---|---|---|
| `\|δ\|³` | `≤ (59/96)³·R ≈ 0.233·R` | **landed** (`phi_d3_bound`) |
| `sA` | `≤ R/2` | **landed** (`phi_sA_bound`) |
| `yz` | `≤ R/6` | in progress |
| `z²/2` | `≤ R/288` | in progress |
| `\|y−z\|·sA` | `≤ R/64` | in progress |
| `sA²/2` | `≤ R/8192` | in progress |

Total `0.233 + 0.5 + 0.167 + 0.0035 + 0.0156 + 0.0001 = 0.92 < 1` ✓.

**The `|δ²−y²|/2` draft (`/tmp/z81.lean`, not landed)** reduces to the four pieces above plus
the expansion `phi_delta_sq_sub`; the six remaining failures are plumbing:
1. a **parser** error on `\|y-z\|*sA`: write `(\|y-z\|)*sA` — an `abs` term cannot sit
   directly against `*` in a chain.
2. `rw [div_le_div_iff₀ …]; linarith` on `u/(6k) ≤ 1/6` needs `hu2` **and** `hk1` in the
   `linarith` list (`u ≤ 1`, `k ≥ 1`).
3. `rw [show A = B by field_simp; ring]` — `field_simp` closes it, so the trailing `ring`
   errors (`No goals to be solved`); use `by field_simp` alone.
4. `rw [hy, hz, hR]; field_simp; ring` on `y*z = R·(u/(6k))` — same trap; and after
   `field_simp` the goal may already be closed.

**Recommendation.**  Each of these four `field_simp; ring` occurrences is the *same* trap
that has now cost pieces in rounds 24, 26, 32, 33 and 37.  The most reliable pattern for
`X = Y * (rational in n,k)` identities is: state `Y` explicitly with `set`, then
`rw [hXdef, hYdef]; field_simp` and add `ring` **only if** `field_simp` leaves a goal.

### 13.43 Round-39: the `|δ²−y²|/2` pieces reduce to four *linear* inequalities

The four remaining pieces of the third-order budget have a much simpler form than the
rational-function route attempted in `/tmp/z81.lean` and `/tmp/z90.lean`.  Dividing through
by their common factor `k⁶/n³`, each becomes a **linear** inequality in `u, n, k`:

| piece | rewritten as | needs |
|---|---|---|
| `y·z ≤ R/6` | `u²k⁵ ≤ u·k⁶` | `u ≤ k` (from `k ≥ 1 ≥ u`) |
| `z²/2 ≤ R/288` | `16u²k⁶ ≤ u·k⁶·n` | `16u ≤ n` (from `u ≤ 1`, `n ≥ 16`) |
| `\|y−z\|·sA ≤ R/64` | `≤ y·sA ≤ u²k⁶/(4n⁴)`, `16u ≤ n` | `16u ≤ n` |
| `sA²/2 ≤ R/8192` | `1024·u·k² ≤ n³` | `1024k² ≤ n³` |

So **`nlinarith` should close each one after clearing denominators**, and no `field_simp`
on a compound rational function is needed at all.  Concretely:

```lean
have hzy : y*z ≤ (1/6)*R := by
  have he : y*z = u^2*(k:ℝ)^5/(6*(n:ℝ)^3) := by rw [hy, hz]; field_simp
  rw [he, hR, div_le_iff₀ (by positivity : (0:ℝ) < 6*(n:ℝ)^3)]
  nlinarith [hu2, hk1, hkR, hnR]      -- u ≤ k
```

(and likewise for the other three; `z²/2`, `\|y−z\|sA` and `sA²/2` all clear to
`nlinarith` after one `div_le_iff₀`).

**The recurring `field_simp; ring` trap, now diagnosed precisely.**  In this toolchain
`field_simp` sometimes closes the goal and sometimes leaves a `ring`-shaped remainder,
depending on whether the denominators are syntactically present as divisions.  The robust
policy is: **never** write `field_simp; ring` in one tactic sequence; write `field_simp`
alone, and if it errors with `No goals to be solved`, the identity was already closed; if it
leaves a goal, add `ring` on the next line.  Every occurrence of this trap in rounds 24, 26,
32, 33, 37, 38 and 39 is the same root cause.

### 13.44 LANDED (round 40): the four `|δ²−y²|/2` pieces

`Op56/PhiThird.lean` now has **54 lemmas** (0 sorries, 7/7 OK), newly:

```lean
lemma phi_yz_bound    … : y·z ≤ (1/6)·R                    (needs u ≤ k)
lemma phi_z2_bound    … : z²/2 ≤ (1/288)·R                 (needs 16u ≤ n)
lemma phi_yz2_bound   … : y·(u k⁴/(2n³)) ≤ (1/64)·R        (needs 16u ≤ n)
lemma phi_sA2ub_bound … : (u k⁴/(2n³))²/2 ≤ (1/8192)·R     (needs 1024k² ≤ n³)
```

with `R = u·k⁶/n³`.  **The §13.43 linear reduction worked exactly as predicted:** each
proof is `he : LHS = u²k^m/(c·n^j)` by `field_simp` **then** `ring` (on separate lines —
`field_simp` alone leaves a goal here, unlike in rounds 32/33/37), then
`rw [he, div_le_iff₀ …]`, `field_simp`, and `nlinarith` with the needed linear fact
(`u ≤ k`, or `16u ≤ n`) supplied explicitly.

**Tactic findings:**
* `field_simp` **then `ring` on separate lines** is the robust form; here `field_simp`
  alone does *not* close (contrast the round-32/33/37 cases where it did).  This confirms
  §13.43's advice: write them on separate lines so either behaviour works.
* `nlinarith` cannot divide through by `↑k^6` unless `0 < ↑k` is in the context — the
  hypotheses `hk : 1 ≤ k` / `hkR : 0 < ↑k` are load-bearing even when the statement does
  not mention `k`.
* `rw [hy, hz, hR] at *` **destroys** later goals: `hy : y = …` is a definition produced by
  `set`, so rewriting it everywhere erases the `y` that subsequent steps still need.  Use
  plain `rw [hy, hz, hR]` (goal only).

**`phi_dy2_bound` assembly (`/tmp/z99.lean`, not landed)** is the last step for
`|δ²−y²|/2 ≤ (1/5)R`: combine the four pieces above with
`phi_delta_sq_sub`, `|y-z| ≤ y` (from `z ≤ y`, itself `2k² ≤ 3n`), and
`sA ≤ u k⁴/(2n³)` (`phi_r4_bounds`).  Its errors are the same three plumbing issues:
the `at *` trap above, `z ≤ y` needing the explicit `2k² ≤ 3n`, and the closing `linarith`
needing `hR0`.

### 13.45 Round-41: `phi_dy2_bound` assembly blocked by expression verbosity

No declaration landed; build green (54 lemmas, 0 sorries, 7/7 OK).  Attempted the assembly two
ways, both hitting parse/size limits rather than mathematics:

**(a) with `set` abbreviations** (`/tmp/z99.lean`): `rw [hy, hz, hR]` on the goal of a
sub-lemma reports *pattern not found* because `set` introduces `hy : y = …` and the same
abbreviations were already consumed elsewhere; and `rw [… ] at *` erases them for later
steps.

**(b) with explicit expressions** (`/tmp/w100.lean`): the four correct inequalities land,
but the statement of `h10` (the `|2·(y−z)·sA|` step) exceeds what the parser accepts in a
nested `abs_mul` rewrite — line 103 reports `unexpected token '|'`.  The expressions
`u*(k:ℝ)^2/(2*(n:ℝ))` etc. repeated inside `abs`/`mul` chains are ~40 tokens each and the
nesting becomes unparseable.

**Conclusion for next round: introduce named local definitions with `let` (not `set`), or
— better — split the assembly into small lemmas each taking the four pieces as *hypotheses*
with short names.**  Concretely:

```lean
lemma phi_dy2_abstract (y z sA R : ℝ)
    (hy0 : 0 ≤ y) (hz0 : 0 ≤ z) (hsA0 : 0 ≤ sA)
    (hzy : y*z ≤ (1/6)*R) (hz2 : z^2/2 ≤ (1/288)*R)
    (hyz : (|y-z|)*sA ≤ (1/64)*R) (hsA2 : sA^2/2 ≤ (1/8192)*R)
    (hzy2 : z ≤ y) :
    |(y - z + sA)^2 - y^2|/2 ≤ (1/5)*R
```

This is pure algebra in named variables (no `u`, `n`, `k`, no `log`), so the parser and
`linarith` both cope; the instantiation with
`y = u k²/(2n)`, `z = u k³/(3n²)`, `sA = (un)·A`, `R = u k⁶/n³` then supplies the seven
hypotheses from the landed `phi_yz_bound`, `phi_z2_bound`, `phi_yz2_bound`,
`phi_sA2ub_bound`, `phi_yz2_bound`'s LHS, `phi_r4_bounds` and `hzy2` (`2k² ≤ 3n`).

**This abstraction step is the right move and should have been taken earlier** — every
previous attempt inlined the seven long expressions, and the failures have all been at the
level of parsing or term-size rather than of the mathematics.

### 13.46 LANDED (round 42): the abstract `|δ²−y²|/2` assembly

`Op56/PhiThird.lean` now has **55 lemmas** (0 sorries, 7/7 OK), newly:

```lean
lemma phi_dy2_abstract (y z sA R : ℝ)
    (hy0 : 0 ≤ y) (hz0 : 0 ≤ z) (hsA0 : 0 ≤ sA) (hR0 : 0 ≤ R)
    (hzy : y*z ≤ (1/6)*R) (hz2 : z^2/2 ≤ (1/288)*R)
    (hyz : (|y-z|)*sA ≤ (1/64)*R) (hsA2 : sA^2/2 ≤ (1/8192)*R) :
    |(y - z + sA)^2 - y^2|/2 ≤ (1/5)*R
```

**The §13.45 abstraction was exactly right** — with everything in named reals (`y z sA R`)
and no `u`, `n`, `k` or `log` anywhere, the triangle-inequality chain and the final
`linarith` both go through first time.  This is the step that had resisted eight rounds of
inlining.

**Two things it needed that the abstract form makes explicit:**
* `hR0 : 0 ≤ R` — the sum `R(1/6 + 1/288 + 1/64 + 1/8192) ≤ R/5` requires `R ≥ 0`;
  `linarith` cannot derive `(c₁+c₂+c₃+c₄)R ≤ (1/5)R` from the four separate bounds without
  it.  Supply it as `mul_le_mul_of_nonneg_right (by norm_num) hR0`.
* `|(-2)·(y·z)| = 2·(y·z)` needs `0 ≤ y·z`, hence both `hy0` and `hz0`.

**Instantiation (`/tmp/w120.lean`, in progress).**  `phi_dy2_bound` is now
`phi_dy2_abstract y z sA R …` with the four landed bounds supplied directly; the only extra
work is `phi_hlyz_bound : (|y−z|)·sA ≤ R/64`, which chains
`|y−z| ≤ y` ← `z ≤ y`, `sA ≤ u k⁴/(2n³)` ← `phi_r4_bounds`, and `phi_yz2_bound`.

**A tactic note that has now cost several rounds.**  For goals of the form
`a/(3n²) ≤ b/(2n)` the reliable sequence is
`rw [div_le_div_iff₀ (by positivity : 0 < 3n²) (by positivity : 0 < 2n)]` and then
**`field_simp` before `nlinarith`** — the cleared goal is `u k³ · 2n ≤ u k² · 3n²`, which
`nlinarith` reduces to `2k² ≤ 3n` only after the `u·n` factors are cancelled, and supplying
`2k² ≤ 3n` explicitly (`linarith [hk4R, hnR]`) still leaves the cancellation to be done.

### 13.47 LANDED (round 43): the third-order error budget is complete

`Op56/PhiThird.lean` now has **57 lemmas** (0 sorries, 7/7 OK), newly:

```lean
lemma phi_hlyz_bound … : (|y−z|)·sA ≤ (1/64)·R
lemma phi_dy2_bound  … : |(y − z + sA)^2 − y^2|/2 ≤ (1/5)·R
```

where `y = uk²/(2n)`, `z = uk³/(3n²)`, `sA = un·A`, `R = u·k⁶/n³`.
`phi_dy2_bound` is now just `phi_dy2_abstract` applied to the four landed bounds — the
§13.45 abstraction paid off completely.

**The complete termwise third-order budget:**

| piece | bound | lemma |
|---|---|---|
| `\|e^d − 1 − d − d²/2\| ≤ \|δ\|³` | `≤ 0.233·R` | `phi_d3_bound` |
| `sA` | `≤ 0.5·R` | `phi_sA_bound` |
| `\|δ² − y²\|/2` | `≤ 0.2·R` | `phi_dy2_bound` |
| **total** | **`≤ 0.933·R`** | |

so, with `G = e^{−uk} ≤ e^{−uk/2}`,

    |T_k − G_k(1 + y − z + y²/2)| ≤ G_k · 0.933·R ≤ 2·u·e^{−uk/2}·k⁶/n³     (4k² ≤ n).

**Next: assemble `phi_term_sharp3`** from `phi_term_expand` (`T_k = G·e^δ`),
`phi_term_diff_decomp` (`e^δ − (1+y−z+y²/2) = (e^δ−1−δ−δ²/2) + sA + (δ²−y²)/2`) and the
three bounds above.  The `G` factor comes out by `abs_mul`; the three pieces are then
summed with `abs_add_le`.

**The decisive tactic fix (rounds 31–43).**  For `u k³/(3n²) ≤ u k²/(2n)`:
`div_le_div_iff₀` alone leaves `2uk³n ≤ 3uk²n²`, which `nlinarith` **cannot** cancel.
The route that works is to prove the *scaled* inequality

    have hkey : 2*k * (u*k^2*n) ≤ 3*n * (u*k^2*n) := mul_le_mul_of_nonneg_right h23 (by positivity)

and `linarith [hkey]`.  `h23 : 2k ≤ 3n` itself needs `k ≤ k²` (`nlinarith [hk1]`) before
`linarith [hk4R, hkk]` can give `4k ≤ n`.  Both of these were missing across ~10 rounds.

### 13.48 LANDED (round 44): abstract termwise assembly

`Op56/PhiThird.lean` now has **58 lemmas** (0 sorries, 7/7 OK), newly:

```lean
lemma phi_term_sharp3_abstract (G d y z : ℝ) (hG : 0 ≤ G) :
    |G * Real.exp d - G * (1 + y - z + y^2/2)|
      ≤ G * (|Real.exp d - 1 - d - d^2/2| + |d - (y-z)| + |(d^2 - y^2)/2|)
```

Again the abstraction is what made it work (compare §13.45–13.47): in named reals the
rewrite chain `← mul_sub, abs_mul, abs_of_nonneg hG, phi_term_diff_decomp` followed by two
`abs_add_le` and one `linarith` goes through immediately.

**Key point:** the final step must be
`exact mul_le_mul_of_nonneg_left h3 hG` — **not** `linarith`.  `linarith` cannot multiply
the inequality `|A+B+C| ≤ |A|+|B|+|C|` by the *factor* `G` (it treats `G * |…|` as a fresh
nonlinear atom), so the goal must be reduced to a pure inequality and then scaled by
`mul_le_mul_of_nonneg_left`.

**Next: instantiate** `phi_term_sharp3` with
`G = e^{−uk}`, `d = y − z + sA`, `y = uk²/(2n)`, `z = uk³/(3n²)`, giving the three
hypotheses from `phi_d3_bound` (needs `d` to be *the* explicit `y − z + sA`, which
`phi_d3_bound` is stated with), `phi_sA_bound`, `phi_dy2_bound`; then bound the sum
`0.233R + 0.5R + 0.2R = 0.933R` and use `G = e^{−uk} ≤ e^{−uk/2}`.

### 13.49 Round-45: `phi_term_sharp3` instantiation — three fixes identified

No declaration landed (build green: 58 lemmas, 0 sorries, 7/7 OK).  The instantiation
`phi_term_sharp3` is drafted in `/tmp/w151.lean`.  Its shape is correct and confirmed:

```lean
set d := u*k²/(2n) − u*k³/(3n²) + un·A     -- the explicit δ
set G := Real.exp (-(u*k))
set R := u * ((k:ℝ)^6/(n:ℝ)^3)
-- hT   : T = G * Real.exp d                      (phi_term_expand)
-- hAbs : |G*e^d − G*(1+y−z+y²/2)| ≤ G*(three pieces)   (phi_term_sharp3_abstract)
-- hsum : three pieces ≤ R                        (phi_d3 + phi_sA + phi_dy2)
calc … ≤ G * R := mul_le_mul_of_nonneg_left hsum hG0
     _ ≤ 2 * u * Real.exp (-(u*k)/2) * (k⁶/n³)      (e^{−uk} ≤ e^{−uk/2})
```

**Three fixes needed:**
1. `|e^d − 1 − d − d²/2| ≤ (59/96)³R` is **two** steps, not one:
   `exp_rem_cube d hdb` (needs `hdb : |d| ≤ 1/2` from `phi_delta_bound`) then
   `|d|³ ≤ (59/96)³R` from `phi_d3_bound`.  I first tried to read `phi_d3_bound` as if it
   bounded `|e^d − 1 − d − d²/2|` directly.
2. `phi_dy2_bound`'s RHS is `(1/5) * (u * (k⁶/n³))` while the goal after `rw [hR]` has
   `(1/5) * R` with `R = u * ((k:ℝ)^6/(n:ℝ)^3)`; `convert … using 2 <;> ring` did **not**
   close it — align the two by rewriting `R` to the *same* parenthesisation as the lemma's
   own statement (i.e. put the `u *` outside, `(1/5) * (u * ((k:ℝ)^6/(n:ℝ)^3))`).
3. the `abs_of_nonneg` for `sA` needs `hA0'` from `phi_r4_bounds`, whose `hx1` argument
   again needs the `k ≤ k²` → `4k ≤ n` chain (`nlinarith [hk1]`, then
   `linarith [hk4R, hkk]`) — the same step as §13.47; `linarith [hkR, hu1]` alone fails.

**Also:** `:= linarith […]` is not a term; write `:= by linarith […]`.

**Lesson repeated:** every one of these is an *instantiation* problem, not a mathematical
one, and each is the same class of bug (parse-parenthesisation or an implicit
`k ≤ n`-type side condition) that the abstract lemmas avoided by construction.

### 13.50 LANDED (round 46): `phi_term_sharp3` — the termwise third-order bound

`Op56/PhiThird.lean` now has **59 lemmas** (0 sorries, 7/7 OK), newly:

```lean
lemma phi_term_sharp3 (u : ℝ) (n k : ℕ)
    (hu1 : 1/2 ≤ u) (hu2 : u ≤ 1) (hn : 16 ≤ n) (hk : 1 ≤ k) (hk4 : 4*k^2 ≤ n) :
    |(1 + (k:ℝ)/(n:ℝ)) ^ (-(u*(n:ℝ)))
      - Real.exp (-(u*(k:ℝ))) * (1 + u*(k:ℝ)^2/(2*(n:ℝ))
          - u*(k:ℝ)^3/(3*(n:ℝ)^2) + (u*(k:ℝ)^2/(2*(n:ℝ)))^2/2)|
      ≤ 2 * u * Real.exp (-(u*(k:ℝ))/2) * ((k:ℝ)^6/(n:ℝ)^3)
```

**This is the core analytic input for `Phi_third_order`** — the entire third-order
coefficient now rests on it.

**The three §13.49 fixes were correct and sufficient**, plus a fourth:
1. `|e^d − 1 − d − d²/2| ≤ (59/96)³R` is **two** steps: `exp_rem_cube` (via
   `hdb : |d| ≤ 1/2` from `phi_delta_bound`) then `|d|³ ≤ (59/96)³R` from `phi_d3_bound`.
2. the landed bounds come in **two different parenthesisations**:
   `phi_sA_bound` ends `(1/2) * (u * k⁶ / n³)` (= `(u·k⁶)/n³`) while `phi_d3_bound` and
   `phi_dy2_bound` end `… * (u * (k⁶/n³))`.  Convert with an explicit
   `have heq : … := by ring` and `linarith [h, heq]` — do **not** try to make `exact` match.
3. `phi_dy2_bound` puts the `/2` **outside** the abs (`|A²−B²|/2`) while
   `phi_term_sharp3_abstract` has it **inside** (`|(A²−B²)/2|`).  The bridge is
   `rw [div_eq_mul_inv, abs_mul, abs_of_nonneg (by norm_num : (0:ℝ) ≤ (2:ℝ)⁻¹)]; ring`.

**Next: sum `phi_term_sharp3` over `k`.**  For the finite regime this gives
`Σ_{k≤√n/2} G_k(1 + y − z + y²/2) + O(1/n³)`; the three sums are
`Σ k^m e^{−uk}` for `m = 0,2,3,4`, i.e. `(e^u−1)^{-1}`, `PhiS(u)`, `PhiK3u(u)`,
`PhiK4u(u)`, yielding `D(u) = −(u/3)PhiK3u(u) + (u²/8)PhiK4u(u)`; the `4k² > n` tail is
exponentially small via `rpow_le_exp_half`.

### 13.51 LANDED (round 47): `PhiK3u`, `PhiK4u` and the moment-sum summability

`Op56/PhiThird.lean` now has **64 declarations** (0 sorries, 7/7 OK), newly:

```lean
noncomputable def PhiK3u (u : ℝ) : ℝ := ∑' k, (k:ℝ)^3 * Real.exp (-(u*(k:ℝ)))
noncomputable def PhiK4u (u : ℝ) : ℝ := ∑' k, (k:ℝ)^4 * Real.exp (-(u*(k:ℝ)))
lemma summable_exp_neg_u (u : ℝ) (hu : 1/2 ≤ u) (m : ℕ) :
    Summable (fun k : ℕ => (k:ℝ)^m * Real.exp (-(u*(k:ℝ))))
lemma summable_PhiK3u (u : ℝ) (hu : 1/2 ≤ u) : Summable (…)   -- m = 3
lemma summable_PhiK4u (u : ℝ) (hu : 1/2 ≤ u) : Summable (…)   -- m = 4
```

**Signatures that cost a round each:**
* `summable_pow_mul_geometric_of_norm_lt_one (k : ℕ) {r : R} (h : ‖r‖ < 1)` — the bound is
  a **norm** bound, so `Real.exp (-(1/2:ℝ)) < 1` must be converted with
  `rw [Real.norm_eq_abs, abs_of_pos (Real.exp_pos _), Real.exp_lt_one_iff]`.
* `Real.exp_nat_mul (x) (n) : Real.exp (↑n * x) = Real.exp x ^ n` — the **cast comes first**.
  To rewrite `Real.exp (-(u*↑k))` write `show -(u*(k:ℝ)) = (k:ℝ)*(-u) by ring` and then
  `Real.exp_nat_mul`.  (`Real.exp_nsmul` is the `n • x` variant.)

**Next for the summation.**  Split at `4k² ≤ n`:
* `k ≤ √n/2`: `phi_term_sharp3` gives `T_k = G_k(1+y−z+y²/2) + err`,
  `|err| ≤ 2u·e^{−uk/2}k⁶/n³`, so `Σ|err| ≤ (2u/n³)·Σ k⁶ e^{−uk/2}`;
* `k > √n/2`: `T_k ≤ e^{−uk/2}` (`rpow_le_exp_half`) and likewise for `G_k`, giving an
  exponentially small tail.

The main sum then splits as
`Σ_k G_k` `+ (u/(2n))Σ k²G_k` `− (u/(3n²))Σ k³G_k` `+ (u²/(8n²))Σ k⁴G_k`, i.e.
`(e^u−1)^{−1} + (u/2n)ΦS(u) + D(u)/n²` with
`D(u) = −(u/3)PhiK3u(u) + (u²/8)PhiK4u(u)` — this is where `PhiK3u`/`PhiK4u` enter, and
at `u = log 2`, `PhiK3u = 26`, `PhiK4u = 150`.

### 13.52 LANDED (round 48): `Σ k⁶ e^{−uk/2} ≤ 4·10¹⁰` — the third-order error constant

`Op56/PhiThird.lean` now has **65 declarations** (0 sorries, 7/7 OK), newly:

```lean
lemma tsum_pow6_exp_neg_half_le (u : ℝ) (hu : 1/2 ≤ u) :
    (∑' k : ℕ, (k:ℝ)^6 * Real.exp (-(u*(k:ℝ))/2)) ≤ 4*10^10
```

**This is the constant that multiplies `n^{-3}` in the third-order error**, and getting it
was the main obstacle to the summation.  The route:

* Mathlib **does** have the closed form —
  `tsum_pow_mul_geometric_of_norm_lt_one (m) (h : ‖r‖ < 1) :
   ∑' n, n^m r^n = Σ_{j≤m} S(m,j)·j!·r^j/(1−r)^{j+1}` — so no calculus or maximisation
  is needed (this replaced a planned `max_k k^6 λ^k` argument that would have been painful).
* `Real.exp (-(u*↑k)/2) = (Real.exp (-u/2))^k` via
  `show -(u*(k:ℝ))/2 = (k:ℝ)*(-u/2) by ring` then `Real.exp_nat_mul`.
* `r = e^{−u/2} ≤ e^{−1/4} ≤ 4/5` (`exp_neg_quarter_le`), so `1−r ≥ 1/5`, giving
  `r^j/(1−r)^{j+1} ≤ 5^{j+1}` via `one_le_pow₀` on `1 ≤ 5(1−r)`.
* `S(6,j) ≤ 100`, `j! ≤ 720` for `j ≤ 6` — proved by `interval_cases j <;> native_decide`
  on the **ℕ** statement, then `exact_mod_cast`.  (`native_decide` fails on the ℝ-valued
  form because `Real.decidableLE` is noncomputable.)
* total `7 · 100 · 720 · 5^7`-ish, comfortably under `4·10¹⁰`.

**Gotchas recorded:** `Real.exp_lt_one_iff` needs `.mpr` (a bare `rw` gets stuck);
`exp_neg_quarter_le` returns `Real.exp (-(u/2))` while goals usually carry `Real.exp (-u/2)`
— these are **not** syntactically equal, so `rw [show -(u/2) = -u/2 by ring] at h` is needed;
`∑ j ∈ s, f` vs `s.sum f` can differ, so state the geometric bound as a `≤` and combine with
`linarith` rather than rewriting inside an inequality hypothesis.

**Next for the summation:** combine `phi_term_sharp3` with this constant to get
`Σ_{4k²≤n} |err_k| ≤ (2u/n³)·4·10¹⁰`, then the three tail regimes
(`k ≤ n` via `rpow_le_exp_half`, `k > n` via `rpow_decay_tail`).

### 13.53 LANDED (round 49): the finite-regime summed third-order error

`Op56/PhiThird.lean` now has **66 declarations** (0 sorries, 7/7 OK), newly:

```lean
lemma phi_err_sum_le (u : ℝ) (n : ℕ) (hu1 : 1/2 ≤ u) (hu2 : u ≤ 1) (hn : 16 ≤ n)
    (s : Finset ℕ) (hs1 : ∀ k ∈ s, 1 ≤ k) (hs : ∀ k ∈ s, 4*k^2 ≤ n) :
    ∑ k ∈ s, |T_k − G_k(1 + y − z + y²/2)| ≤ 8*10^10 / (n:ℝ)^3
```

i.e. over any finite index set with `k ≥ 1`, `4k² ≤ n`, the total error is `O(n^{-3})`
with an explicit constant.  Route: `phi_term_sharp3` termwise, then factor
`2u·e^{−uk/2}k⁶/n³ = (2u/n³)·(k⁶e^{−uk/2})`, then `Summable.sum_le_tsum` against
`tsum_pow6_exp_neg_half_le`.

**Gotchas:**
* `Summable.of_nonneg_of_le` is the tool when the summability lemma available is stated
  for a *different* exponent (here `summable_exp_neg_u` covers `e^{−uk}`, not `e^{−uk/2}`);
  comparing directly against `(e^{−1/4})^k` avoids a fragile `by linarith` side goal.
* `rw [Finset.mul_sum]` rewrites `a * ∑ f` **to** `∑ a * f`, so to go the other way the
  calc step must be oriented as `∑ a * f = a * ∑ f`.
* in `2*u/n³ * c ≤ C/n³`, the LHS is not a division, so
  `div_le_div_iff₀` does not fire — first rewrite the LHS to `8·10¹⁰·u/n³` with `ring`.

**Next: the full `Phi_third_order`.**  Split `Σ_k T_k` at `4k² ≤ n`:
`Σ = Σ_{4k²≤n} G_k(1+y−z+y²/2) + Σ_{4k²≤n} err_k + tail`.  The middle term is bounded by
`phi_err_sum_le`; the tail uses `rpow_le_exp_half` (`k ≤ n`) and `rpow_decay_tail` (`k > n`).
The first sum then splits into `(e^u−1)^{−1} + (u/2n)ΦS(u) + D(u)/n²` with
`D(u) = −(u/3)PhiK3u(u) + (u²/8)PhiK4u(u)`.

### 13.54 LANDED (round 50): `PhiMain` and its exact decomposition

`Op56/PhiThird.lean` now has **69 declarations** (0 sorries, 7/7 OK), newly:

```lean
noncomputable def PhiMain (u : ℝ) (n : ℕ) : ℝ :=
  ∑' k, Real.exp (-(u*(k:ℝ))) * (1 + u*(k:ℝ)^2/(2*(n:ℝ))
      - u*(k:ℝ)^3/(3*(n:ℝ)^2) + (u*(k:ℝ)^2/(2*(n:ℝ)))^2/2)

lemma tsum_exp_neg_mul_eq (u : ℝ) (hu : 0 < u) :
    (∑' k : ℕ, Real.exp (-(u*(k:ℝ)))) = (Real.exp u - 1)⁻¹ + 1

lemma PhiMain_eq (u : ℝ) (n : ℕ) (hu1 : 1/2 ≤ u) (hn : 1 ≤ n) :
    PhiMain u n = (Real.exp u - 1)⁻¹ + 1 + u/(2*(n:ℝ))*PhiS u
      + (-(u/3)*PhiK3u u + (u^2/8)*PhiK4u u)/(n:ℝ)^2
```

**Note the `+1`:** `Σ'_k e^{−uk}` over `k ≥ 0` equals `(e^u−1)^{−1} + 1` (it is `e^u/(e^u−1)`),
whereas the `Φ` model sum starts at `k = 1`.  So the target decomposition for the actual
sum is `PhiMain u n − 1 = (e^u−1)^{−1} + (u/2n)ΦS(u) + D(u)/n²` with
`D(u) = −(u/3)PhiK3u(u) + (u²/8)PhiK4u(u)` — the `+1` cancels.

**Tactic notes:** `tsum_sub` is not a free identifier — it is `Summable.tsum_sub`
(`Summable.tsum_add` likewise).  `summable_exp_neg_u u hu1 0` yields
`Summable (fun k => ↑k^0 * exp …)`, which needs `simpa` to match `Summable (fun k => exp …)`.
The summand identity needs `field_simp` before `ring` (the `1/n` denominators), with
`Real.exp (-(u*↑k)) ≠ 0` in hand.

**Next: bound `Φ − PhiMain` (the tail).**  For `4k² > n` use `rpow_le_exp_half` (`k ≤ n`) and
`rpow_decay_tail` (`k > n`); for the reverse direction, the difference
`PhiMain u n − Σ_{k≤√n/2} G_k(1+y−z+y²/2)` is the tail of `PhiMain`, bounded by
`Σ_{k>√n/2} e^{−uk}(1 + uk²/(2n) + uk³/(3n²) + u²k⁴/(8n²))`, which is exponentially small
in `√n` for the `k ≤ n` range and `O(2^{−un})` beyond — both `o(n^{−3})`.

### 13.55 Round-51: tail bounds — analysis corrected, lemma still open

No declaration landed (build green: 69 declarations, 0 sorries, 7/7 OK).  But a **significant
analytical correction** was made, which matters for the remaining work.

**The tail is exponentially small, not polynomially `o(n^{-3})`.**  My round-50 note said the
tail would be `O(2^{−un})`; that is wrong in the interesting range.  Split at `K := ⌈√n/2⌉`:

* for `K ≤ k ≤ n`, `T_k ≈ e^{−uk}` decays geometrically, so `Σ_{k≥K}T_k ≈ e^{−uK/2}·(1−e^{−u/2})^{−1}`;
* for `k > n`, `Σ_{k>n}T_k ≤ 2^{1−un}·n/(un−1)` — note the exponent is `1−un`, not `un−1`
  (an easy sign slip, which initially made this look like it diverged).

Both are `exp(−c√n)` and `exp(−c n)` respectively, hence `o(n^{−3})` — but only **eventually**:
for `n = 100`, `Σ_{k>5}T_k ≈ 0.02`, far larger than `n^{−3} = 10^{−6}`.  So the final proof
**must be an eventual statement**, with an explicit threshold `n ≥ N` such that
`e^{−u√n/4} ≤ C/n³` (e.g. `N = 10⁴` suffices comfortably).

**Critically, the tail must bound `T_k − P_k`, not `T_k` or `P_k` individually.**  Individually
`P_k ≈ e^{−uk}u²k⁴/(8n²)` sums to `O(n^{−2})` over all `k` — too big.  The cancellation
`T_k − P_k = G_k[(e^δ − 1 − δ) + sA − y²/2]` with `e^δ − 1 − δ ≈ (y−z)²/2 = y²/2 − yz + z²/2`
is exactly what removes the `y²/2`; the survivor is `G_k(−yz + z²/2 + sA)`, whose total is
`O(n^{−3})`.  Bounding the tail as `Σ(|T_k| + |P_k|)` would give the wrong answer.

**In-flight lemma** (`/tmp/w210.lean`): a uniform moment bound
`tsum_pow_le_six_exp_neg_half_le (u) (hu : 1/2 ≤ u) (m) (hm : m ≤ 6) :
  Σ_k k^m e^{−uk/2} ≤ 4·10¹⁰ + 5`.  Two errors remain:
1. the `m = 0` branch should just be
   `rw [div_le_iff₀ hq]; linarith` against `Σ_k e^{−uk/2} = (1−e^{−u/2})^{−1}` and
   `1−e^{−u/2} ≥ 1/5` — `inv_le_comm₀` gave a type mismatch;
2. `m ≥ 1` needs `zero_pow hm0` for the `k = 0` case (`0^m e^0 = 0` for `m ≥ 1`) and
   `pow_le_pow_right₀ hk1 hm` for `k ≥ 1`.

Once this lands, `Σ_{k≥K}k^m e^{−uk} ≤ e^{−uK/2}·(4·10¹⁰+5)` follows by `tsum_nat_add`.

### 13.56 LANDED (round 52): uniform moment bound for all exponents `m ≤ 6`

`Op56/PhiThird.lean` now has **70 declarations** (0 sorries, 7/7 OK), newly:

```lean
lemma tsum_pow_le_six_exp_neg_half_le (u : ℝ) (hu : 1/2 ≤ u) (m : ℕ) (hm : m ≤ 6) :
    (∑' k : ℕ, (k:ℝ)^m * Real.exp (-(u*(k:ℝ))/2)) ≤ 4*10^10 + 5
```

The `m = 0` branch is geometric (`Σ e^{−uk/2} = (1−e^{−u/2})^{−1} ≤ 5`, since
`e^{−u/2} ≤ 4/5`); the `m ≥ 1` branch compares to `k⁶`.
Fixes that worked: `div_le_iff₀ hq` then `linarith` (not `inv_le_comm₀`), and
`simpa [one_div]` to bridge `1/x` vs `x⁻¹`; `zero_pow (by omega : m ≠ 0)` (not `zero_pow hm0`,
which wants `m ≠ 0`, not `m > 0`).

**In-flight: the shifted tail bound** (`/tmp/w212.lean`).
`tsum_nat_add` **does not exist**; the right name is
`Summable.sum_add_tsum_nat_add (k) : ∑ i ∈ range k, f i + ∑' i, f (i+k) = ∑' i, f i`.
The lemma to land is

```lean
lemma tsum_shift_pow_exp_le (u : ℝ) (hu : 1/2 ≤ u) (K m : ℕ) (hK : 1 ≤ K) (hm : m ≤ 6) :
    (∑' i, ((i:ℝ)+K)^m * Real.exp (-(u*((i:ℝ)+K))))
      ≤ Real.exp (-(u*(K:ℝ))/2) * (4*10^10 + 5)
```

with the useful sub-lemma `summable_pow6_exp_half u hu : Summable (fun j => j^6 e^{−uj/2})`
already written in the draft.  Four errors remain:
1. the `hshift6` step: `sum_add_tsum_nat_add` must be oriented so the finite sum is *dropped*
   (it is `≥ 0`), and `linarith` needs `hsplit` rewritten to the `∑' … + ∑_{range} = ∑'` form;
2. `hle6`: same orientation issue in `Summable.tsum_le_tsum`;
3. `hsm6'`: `(summable_nat_add_iff K).2 hsm6` yields `Summable (fun i => f (i + K))` but with
   `↑(i+K)` vs `↑i + ↑K` — needs `simp only [Nat.cast_add]` before `congr`;
4. the final `this` from `Summable.tsum_le_tsum` then `rw [tsum_mul_left] at this` is a
   Type mismatch: instead extract `tsum_mul_left` on the *goal* side, not on `this`.

### 13.57 LANDED (round 53): the shifted tail moment bound

`Op56/PhiThird.lean` now has **72 declarations** (0 sorries, 7/7 OK), newly:

```lean
lemma summable_pow6_exp_half (u : ℝ) (hu : 1/2 ≤ u) :
    Summable (fun j : ℕ => (j:ℝ)^6 * Real.exp (-(u*(j:ℝ))/2))

lemma tsum_shift_pow_exp_le (u : ℝ) (hu : 1/2 ≤ u) (K m : ℕ) (hK : 1 ≤ K) (hm : m ≤ 6) :
    (∑' i, ((i:ℝ)+K)^m * Real.exp (-(u*((i:ℝ)+K))))
      ≤ Real.exp (-(u*(K:ℝ))/2) * (4*10^10 + 5)
```

This is the bound that makes the tail `exp(−cK)` with `K = ⌈√n/2⌉`, i.e. `o(n^{−3})`
eventually — see §13.55.

**The §13.56 fixes were right, plus three more:**
1. `Summable.sum_add_tsum_nat_add K` yields `∑_{range K} f + ∑' f(·+K) = ∑' f`, so derive
   `∑' f(·+K) ≤ ∑' f` by `linarith [hsplit, h0]` with `h0 : 0 ≤ ∑_{range K} f`, and
   `simp only [Nat.cast_add] at hsplit` first to align `↑(i+K)` with `↑i + ↑K`.
2. the `of_nonneg_of_le` bound for the `^m` series must come from `hle` against the `^6`
   series — so define `hsm'` (the shifted `^m` summability) **before** using it as the `hg` of
   `hsmL`/`hsmR`; using `hsm6'.mul_left` there is the `^m` vs `^6` mismatch.
3. `1 ≤ ↑i + ↑K` needs `hK1 : (1:ℝ) ≤ ↑K` from `exact_mod_cast hK` — `hK : 1 ≤ K` is a Nat
   statement and `linarith` cannot see it.

**Next: assemble the tail of `Φ`.**  Bound `Σ_{k ≥ K}(T_k − P_k)` with `K = ⌈√n/2⌉`:
* for `K ≤ k ≤ n`: `T_k ≤ e^{−uk/2}` (`rpow_le_exp_half`) and
  `P_k ≤ e^{−uk}(1 + y + y²/2)`, so both tails are `≤ e^{−uK/2}·(4·10¹⁰+5)·2`;
* for `k > n`: `T_k ≤ 2^{−un/2}(k/n)^{−un/2}` (`rpow_decay_tail`) and `P_k` is dominated by
  `e^{−uk}y²/2`; summing gives `2^{1−un}n/(un−1)`-type terms.
* then convert `e^{−u√n/4} ≤ C/n³` for `n ≥ N` (`N = 10⁴` suffices).

### 13.58 LANDED (round 54): `PhiMainS` — the model sum in `Phi`'s own indexing

`Op56/PhiThird.lean` now has **75 declarations** (0 sorries, 7/7 OK), newly:

```lean
noncomputable def PhiMainS (u : ℝ) (n : ℕ) : ℝ :=
  ∑' j, Real.exp (-(u*((j:ℝ)+1))) * (1 + u*((j:ℝ)+1)^2/(2*(n:ℝ))
      - u*((j:ℝ)+1)^3/(3*(n:ℝ)^2) + (u*((j:ℝ)+1)^2/(2*(n:ℝ)))^2/2)

lemma summable_PhiMain_term (u : ℝ) (n : ℕ) (hu1 : 1/2 ≤ u) : Summable (…)

lemma PhiMainS_eq (u : ℝ) (n : ℕ) (hu1 : 1/2 ≤ u) (hn : 1 ≤ n) :
    PhiMainS u n = (Real.exp u - 1)⁻¹ + u/(2*(n:ℝ))*PhiS u
      + (-(u/3)*PhiK3u u + (u^2/8)*PhiK4u u)/(n:ℝ)^2
```

**Why a second model sum.**  `Phi p n = ∑'_j (1 + (j+1)/n)^{−p}` indexes `k = j+1`, whereas
`PhiMain` indexes `k` from `0`.  Using `PhiMainS` makes the crucial comparison
`Φ − PhiMainS = ∑'_j (U_j − Q_j)` a **shift-free** termwise statement — worth the small
duplication, since every shift is a place where `↑(i+K)` vs `↑i + ↑K` bites (§13.57).
`PhiMainS u n = PhiMain u n − 1` follows from `sum_add_tsum_nat_add 1` with `f 0 = 1`.

**Tactic notes:** `rw [Finset.sum_range_one] at hsplit` fails because the goal carries the
*beta-reduced* form `Real.exp (-(u*↑0)) * …`, not `(fun k => …) 0`; state `hf0` with
`(((0:ℕ)):ℝ)` so it matches syntactically.  `norm_num` does not close `Real.exp 0`
expressions here — `simp` does.

**Next: `|Φ (u*n) n − PhiMainS u n| ≤ small`.**  This is now a pure termwise comparison over
the *same* index `j`:
`|U_j − Q_j| ≤ 2u·e^{−u(j+1)/2}(j+1)⁶/n³` for `4(j+1)² ≤ n` (that is `phi_term_sharp3`, after
the `Nat.cast_add` normalisation), and the tail `j+1 > K` is handled by
`tsum_shift_pow_exp_le` + `rpow_le_exp_half` / `rpow_decay_tail`.
Then `Phi_third_order` is immediate from `PhiMainS_eq`.

### 13.59 LANDED (round 55): the finite part of the tail split

`Op56/PhiThird.lean` now has **76 declarations** (0 sorries, 7/7 OK), newly:

```lean
lemma phi_finite_part_le (u : ℝ) (n K : ℕ) (hu1 : 1/2 ≤ u) (hu2 : u ≤ 1) (hn : 16 ≤ n)
    (hK : ∀ k, k < K → 4*k^2 ≤ n) :
    ∑ j ∈ Finset.range (K-1), |U_j − Q_j| ≤ 8*10^10 / (n:ℝ)^3
```

where `U_j = (1 + (j+1)/n)^{−un}` and `Q_j` is the `PhiMainS` summand — i.e. the `Φ`-vs-`PhiMainS`
comparison over the indices where the third-order expansion is valid.

Route: apply `phi_err_sum_le` to `Finset.Ico 1 K` (every `k` there is `≥ 1` and, by `hK`,
satisfies `4k² ≤ n`), then reindex with
`Finset.sum_Ico_eq_sum_range : ∑ k ∈ Ico m n, f k = ∑ i ∈ range (n−m), f (m+i)`, which turns
`Ico 1 K` into `range (K−1)`, then `simp only [Nat.cast_add, Nat.cast_one]` to align
`↑(1+i)` with `↑i + 1`.

**Note:** `sum_Ico_eq_sum_range` already produces `range (K − 1)`; there is no extra `K−2`
step (attempting one fails with *pattern not found*).

**Next: the tail.**  `Φ − PhiMainS = Σ'_j (U_j − Q_j)`, and splitting at `j = K−1` gives
`Σ_{j<K-1} + Σ'_i f(i + K − 1)` — the first is `phi_finite_part_le`, the second needs
`|U_{i+K-1} − Q_{i+K-1}| ≤ |U| + |Q|` with
* `U ≤ e^{−u(j+1)/2}` for `j+1 ≤ n` (`rpow_le_exp_half`),
* `U ≤ 2^{−un/2}((j+1)/n)^{−un/2}` for `j+1 > n` (`rpow_decay_tail`),
* `Q ≤ e^{−u(j+1)}(1 + y + y²/2)` and `tsum_shift_pow_exp_le` for the moments,

both regimes being `exp(−c√n)`, hence eventually `≤ C/n³` (e.g. `n ≥ 10⁴`).

### 13.60 Round-56: the eventual exponential bound (in flight)

No declaration landed (build green: 76 declarations, 0 sorries, 7/7 OK).  The lemma in flight is

```lean
lemma exp_neg_sqrt_eventually_le :
    ∀ᶠ n : ℕ in atTop, Real.exp (-(Real.sqrt (n:ℝ))/8) ≤ (1:ℝ)/((n:ℝ)^3)
```

which converts the `exp(−c√n)` tail bounds into the `C/n³` needed for `=O(1/n³)`.

**Route that works mathematically** (`n ≥ 10⁸`):
`n³ ≤ exp(√n/8) ⟺ 3 log n ≤ √n/8`; and `Real.log_le_rpow_div (0 ≤ x) (0 < ε) :
log x ≤ x^ε/ε` with `ε = 1/4` gives `log n ≤ 4 n^{1/4}`, so it suffices that
`12 n^{1/4} ≤ √n/8 = (n^{1/4})²/8`, i.e. `n^{1/4} ≥ 96`, i.e. `n ≥ 96⁴ ≈ 8.5·10⁷`.
The bridge `(96^4)^{1/4} = 96` needs `Real.rpow_natCast` + `Real.rpow_mul`.

**Blocker (purely tactical):** `∀ᶠ n in atTop, p n` cannot be introduced by
`Filter.eventually_atTop.2 ⟨N, fun n hn => ?_⟩` in this toolchain — it reports a Type mismatch.
Use instead

```lean
  rw [Filter.eventually_atTop]        -- or: refine (Filter.eventually_atTop).mpr ⟨N, ?_⟩
  exact ⟨100000000, fun n hn => by …⟩
```

or avoid `∀ᶠ` altogether and state the lemma with an explicit `n ≥ N` hypothesis, which is
simpler and sufficient for the downstream `IsBigO` proof (`IsBigO` only needs an eventual
bound, and `Asymptotics.IsBigO.of_bound` accepts a bound valid for all large `n`).

**Recommendation:** state the bound as
`lemma exp_neg_sqrt_le {n : ℕ} (hn : 100000000 ≤ n) : Real.exp (-(Real.sqrt (n:ℝ))/8) ≤ 1/(n:ℝ)^3`
and let the caller obtain the `∀ᶠ` via `Filter.eventually_atTop`.

### 13.61 Round-57: `exp_neg_sqrt_le` — 4 of 5 errors cleared

No declaration landed (build green: 76 declarations, 0 sorries, 7/7 OK).  The restated lemma

```lean
lemma exp_neg_sqrt_le {n : ℕ} (hn : 100000000 ≤ n) :
    Real.exp (-(Real.sqrt (n:ℝ))/8) ≤ (1:ℝ)/((n:ℝ)^3)
```

(per §13.60 — explicit hypothesis instead of `∀ᶠ`) now has correct lemma names throughout:

* `Real.log_le_iff_le_exp (hx : 0 < x) : Real.log x ≤ y ↔ x ≤ Real.exp y` — so
  `n³ ≤ exp(√n/8)` comes from `Real.log (n³) ≤ √n/8` via
  `rw [← Real.log_le_iff_le_exp (by positivity), Real.log_pow]`;
* `Real.rpow_mul (hx : 0 ≤ x) (y z) : x^(y*z) = (x^y)^z` — note the direction; `←` is what
  collapses `(96^4)^(1/4)`;
* `Real.rpow_natCast`, `Real.rpow_one` for the numeric collapse;
* `1/(n:ℝ)^3` is `((n:ℝ)^3)⁻¹`, so the final step is
  `rw [Real.exp_neg, one_div, inv_le_inv₀ (by positivity) (by positivity)]`
  (not `inv_le_comm₀`, and **not** `Real.le_exp_iff_log_le`, which does not exist).

**Four errors remain:**
1. `hbig`: `have h100 : (100000000:ℝ) ≤ ↑n := by exact_mod_cast hn` then rewriting fails —
   put the numeric fact as `have h96 : (96:ℝ)^4 ≤ 100000000 := by norm_num` and `linarith`;
2. `hrw`: after `Real.rpow_natCast` / `← Real.rpow_mul` the goal is `(96:ℝ)^(4*(1/4)) = 96`;
   `norm_num` does not reduce the **real** exponent — use
   `rw [show (4:ℝ)*(1/4) = 1 by norm_num, Real.rpow_one]`;
3. `h4` (`4·n^{1/4} ≤ (n^{1/4})²/12`): `nlinarith [h96]` fails; multiply `h96` by the
   nonnegative `(n:ℝ)^(1/4)/12` with `mul_le_mul_of_nonneg_left` and `linarith`;
4. the final `rw [Real.exp_neg, one_div, inv_le_inv₀ …]` — check the goal shape first;
   `Real.exp_neg : exp (-x) = (exp x)⁻¹` and `one_div : 1/x = x⁻¹`, so a `show` may be needed
   before the `inv_le_inv₀` rewrite.

**Alternative (recommended if this resists again):** skip `Real.sqrt` entirely and use
`Nat.sqrt` with a natural-number comparison — or, simplest of all, state the tail bound in
the form `Real.exp (-(u*(K:ℝ))/2) * C ≤ C'/(n:ℝ)^3` with the hypothesis
`Real.exp (-(u*(K:ℝ))/2) ≤ 1/(n:ℝ)^3` *assumed* at the point of use, deferring the
`√n`-versus-`log n` comparison to a single dedicated lemma.

### 13.62 LANDED (round 58): the eventual exponential-smallness lemma

`Op56/PhiThird.lean` now has **77 declarations** (0 sorries, 7/7 OK), newly:

```lean
lemma exp_neg_sqrt_le {n : ℕ} (hn : 100000000 ≤ n) :
    Real.exp (-(Real.sqrt (n:ℝ))/8) ≤ (1:ℝ)/((n:ℝ)^3)
```

i.e. `exp(−c√n) = o(n⁻³)`, which converts the tail estimates into the `O(1/n³)` form.

**The four §13.61 blockers, resolved:**
1. `norm_num` **does** close `((96:ℝ)^(4:ℕ))^(1/4:ℝ) = 96` — but only via
   `by norm_num [Real.rpow_natCast, Real.rpow_mul]`; plain `norm_num` and a bare
   `rw [Real.rpow_natCast]` both fail with *pattern not found*.
2. `x/(1/4) = 4*x` is closed by `ring`, **not** `norm_num` (symbolic `x`).
3. the coefficient had to be `12 * n^{1/4} ≤ n^{1/2}/8` (not `4 * n^{1/4} ≤ n^{1/2}/12`):
   the chain is `3 log n ≤ 12 n^{1/4} ≤ √n/8` ⟺ `96 ≤ n^{1/4}`.
4. `Real.exp_neg` needs the exponent in the literal form `-(x)`: the goal carries
   `-√n/8` (parsed `(-√n)/8`), so precede it with
   `rw [show -Real.sqrt (n:ℝ)/8 = -(Real.sqrt (n:ℝ)/8) by ring, Real.exp_neg, one_div,
       inv_le_inv₀ (Real.exp_pos _) (by positivity)]`.
   Also `rw [h3] at h4 ⊢` fails when `h4` already carries the `rpow` form — use `rw [h3]`.

**Next: assemble the tail and `Phi_third_order`.**  With `phi_finite_part_le` (§13.59) and
`exp_neg_sqrt_le` (§13.62) all inputs exist.  The tail needs `Σ'_i |U_{i+K-1} − Q_{i+K-1}|`
bounded by `C·exp(−uK/2)` using `rpow_le_exp_half`/`rpow_decay_tail`, then
`Phi_third_order` follows from `PhiMainS_eq`.

### 13.63 Round-59: the `Q`-tail bound (`phi_Q_tail_le`) — one error left

No declaration landed (build green: 77 declarations, 0 sorries, 7/7 OK).  Draft in
`/tmp/w270.lean`:

```lean
lemma phi_Q_tail_le (u : ℝ) (n K : ℕ) (hu1 : 1/2 ≤ u) (hu2 : u ≤ 1)
    (hn : 16 ≤ n) (hK : 1 ≤ K) :
    (∑' i, Real.exp (-(u*((i:ℝ)+K))) * (1 + u*((i:ℝ)+K)^2/(2*(n:ℝ))
        - u*((i:ℝ)+K)^3/(3*(n:ℝ)^2) + (u*((i:ℝ)+K)^2/(2*(n:ℝ)))^2/2))
      ≤ Real.exp (-(u*(K:ℝ))/2) * (4*10^10 + 5) * 2
```

**The mechanism is settled.**  With `E := e^{−u(i+K)}`, `y := u(i+K)²/(2n)`,
`z := u(i+K)³/(3n²)`, the summand is `E(1 + y − z + y²/2)` and the RHS target
`E(1 + (i+K)²/(2n) + (i+K)⁴/(4n²))` dominates it termwise using only `u ≤ 1`:
`uy ≤ y`, `u²y² ≤ y²`, and `−z ≤ 0`.  Then each of the three shifted sums is bounded by
`tsum_shift_pow_exp_le` with `m = 0, 2, 4`, giving `e^{−uK/2}(4·10¹⁰+5)(1 + 1/(2n) + 1/(4n²))`.

**Argument order.**  `tsum_shift_pow_exp_le (u) (hu) (K m) (hK) (hm)` — the *degree* bound
`hm : m ≤ 6` comes **last**, so `m = 2` needs `(by norm_num : 2 ≤ 6)`, not `le_refl 2`
(that was the round's first error).

**Remaining error (line 34):** the pointwise `nlinarith` in `hle` fails — it cannot handle
the `E` factor together with the `/n`, `/n²` denominators.  Fix: cancel `E > 0` first
(`div_le_div_iff₀` or a `have hEne : E ≠ 0` + `field_simp`), reducing to the purely rational
comparison `uy/1 − uz/1 + u²y²/1 ≤ (i+K)²/(2n) + (i+K)⁴/(4n²)`, which `nlinarith [hu2]`
closes; or establish the three termwise facts separately
(`mul_le_mul_of_nonneg_left` with `u ≤ 1`, and `neg_nonpos`) and `linarith` them.

**Then:** the `U`-tail (`rpow_le_exp_half` for `k ≤ n`, `rpow_decay_tail` for `k > n`) and the
assembly `|Φ − PhiMainS| ≤ 8·10¹⁰/n³ + e^{−uK/2}·C ≤ C'/n³` using `exp_neg_sqrt_le`.

### 13.64 LANDED (round 60): the model-term tail bound

`Op56/PhiThird.lean` now has **78 declarations** (0 sorries, 7/7 OK), newly:

```lean
lemma phi_Q_tail_le (u : ℝ) (n K : ℕ) (hu1 : 1/2 ≤ u) (hu2 : u ≤ 1)
    (hn : 16 ≤ n) (hK : 1 ≤ K) :
    (∑' i, Q_{i+K}) ≤ Real.exp (-(u*(K:ℝ))/2) * (4*10^10 + 5) * 2
```

i.e. the tail of the model sum beyond `K` is `e^{−uK/2}`-small.

**Three traps this round:**
1. the pointwise `nlinarith` must be preceded by **cancelling `E = e^{−uk}`** — establish the
   rational comparison `1 + uy − uz + u²y²/2 ≤ 1 + k²/(2n) + k⁴/(4n²)` as its own `have`,
   then `mul_le_mul_of_nonneg_left … (le_of_lt (Real.exp_pos _))`;
2. `u² ≤ 1` has to be supplied explicitly (`pow_le_one₀`) and the denominators' nonnegativity
   with `positivity` — bare `nlinarith [hu2]` fails;
3. **do not prove the LHS summand's nonnegativity via `z ≤ y`**: that is `2k ≤ 3n`, false for
   large `k`.  Instead get `Summable` for the LHS as a **difference** of the four summable
   terms (`((h1.add h2).sub h3).add h4).congr (fun i => by ring)`).

**Also:** `tsum_add` is `Summable.tsum_add`; and `hsm 0` yields
`Summable (fun i => ((i:ℝ)+K)^0 * …)`, which needs a `congr` with `pow_zero, one_mul` before
it can be used as the `^0`-free form.

**Next: the `U`-tail** (`rpow_le_exp_half` for `k ≤ n`, `rpow_decay_tail` for `k > n`), then the
assembly `|Φ − PhiMainS| ≤ 8·10¹⁰/n³ + e^{−uK/2}·C ≤ C'/n³` via `exp_neg_sqrt_le`, and
`Phi_third_order` from `PhiMainS_eq`.

### 13.65 Round-61: the `U`-tail needs a **three-way** split

No declaration landed (build green: 78 declarations, 0 sorries, 7/7 OK).  The lemma to prove is

```lean
lemma phi_U_tail_le (u : ℝ) (n K : ℕ) (hu1 : 1/2 ≤ u) (hu2 : u ≤ 1) (hn : 16 ≤ n)
    (hK : 1 ≤ K) (hKn : K ≤ n) :
    (∑' i, (1 + (((i:ℝ)+K)/(n:ℝ))) ^ (-(u*(n:ℝ))))
      ≤ Real.exp (-(u*(K:ℝ))/2) * 5 + 3*(n:ℝ) * (2:ℝ)^(-(u*(n:ℝ)))
```

**Why three regimes, each with its own tool:**
1. `K ≤ k ≤ n`: `log(1+k/n) ≥ k/(2n)`, so `U_k ≤ e^{−uk/2}` (`rpow_le_exp_half`), and
   `Σ_{k≥K}e^{−uk/2} = e^{−uK/2}/(1−e^{−u/2}) ≤ 5e^{−uK/2}`;
2. `n < k ≤ 2n`: `1 + k/n > 2`, so `U_k ≤ 2^{−un}`; at most `n` terms give `≤ n·2^{−un}`;
3. `k > 2n`: `U_k ≤ (k/n)^{−un} = (k/n)^{−2}·(k/n)^{−(un−2)} ≤ (k/n)^{−2}·2^{−(un−2)}`, so
   `Σ_{k>2n} ≤ 2^{2−un}n²·Σ_{k>2n}k^{−2} ≤ 2^{1−un}n`.

Total: `≤ 5e^{−uK/2} + 3n·2^{−un}`.

**A dead end worth recording (do not retry it).**  The tempting single bound
`U_k ≤ (k/n)^{−un}` for all `k > n` gives `Σ_{k>n}(k/n)^{−un} = n^{un}Σ_{k>n}k^{−un} ≤
n^{un}·n^{1−un}/(un−1) = n/(un−1)` — which is only `O(1)` (at `n = 100` it is `≈1.44` while the
true tail is `≈10^{−21}`).  The bound is off by a factor `≈10^{21}` at `k = n+1`, precisely
because `(1+k/n)^{−un}` and `(k/n)^{−un}` are wildly different near `k = n`.  The `2n` split
above is what fixes it.

**Also needed:** an eventual lemma for the second term,
`n·2^{−n/2} ≤ 1/n³` for `n ≥ N` (i.e. `n⁴ ≤ 2^{n/2}`; `N = 100` suffices), analogous to
`exp_neg_sqrt_le`.

**Then:** the assembly `|Φ − PhiMainS| ≤ 8·10¹⁰/n³ + (5e^{−uK/2} + C(4·10¹⁰+5))·… ≤ C'/n³`.

### 13.66 Round-62: `U`-tail, Part A proved, Part B still failing

No declaration landed (build green: 78 declarations, 0 sorries, 7/7 OK).

**Part A works** (`/tmp/w290.lean`, `hA`): the first `n` terms of `Σ_i (1 + (i+n+1)/n)^{−un}`
are each `≤ 2^{−un}` because `2 ≤ 1 + (i+n+1)/n`, via
`Real.rpow_le_rpow_of_nonpos (by norm_num : 0 < 2) hxy hexp` with
`hexp : −(u*n) ≤ 0`.  `∑ i ∈ range n` of a constant is
`Finset.sum_const, Finset.card_range, nsmul_eq_mul`.

**Part B (the shifted tail) has ~6 errors and needs restructuring.**  The mathematics is
right — for `k > 2n`, `U_k ≤ (n/k)^{un} = (n/k)^2·(n/k)^{un−2} ≤ (n/k)^2·2^{−(un−2)}`, and
`Σ_{k>2n}(n/k)^2 ≤ n²/(2n)` — but the draft's `Real.rpow` plumbing is tangled (a `h10'`
reference that does not exist, a `div_le_iff₀ |>.mp` hack, and several `linarith` failures
around `push_cast` of `2*n+1`).

**Recommended restructuring for Part B** (avoids `Real.rpow_sub`/`Real.rpow_add` almost
entirely):
1. prove the *pure* inequality
   `((i:ℝ)+(n:ℝ)+(n:ℝ)+1)/(n:ℝ) ≥ 2` and
   `(1 + ((i+2n+1)/n))^(−(u*n)) ≤ ((i+2n+1)/n)^(−(u*n))` by
   `Real.rpow_le_rpow_of_nonpos` (base `1+x ≥ x`, exponent `≤ 0`);
2. then the single rpow identity needed is
   `x^(−(u*n)) = x^(−(2:ℝ)) * x^(−(u*n − 2))` — do it with
   `rw [show -(u*(n:ℝ)) = -(2:ℝ) - (u*(n:ℝ) - 2) by ring, Real.rpow_add (by positivity)]`
   **and keep `x := ((i:ℝ)+2*(n:ℝ)+1)/(n:ℝ)` as a single `set`** so the two factors stay
   syntactically identical;
3. bound the second factor by `2^{−(un−2)}` with `Real.rpow_le_rpow_of_nonpos`;
4. bound `Σ_i (n/(i+2n+1))^2` with `tsum_inv_succ_sq_le (2*n+1) (by omega)` (already landed:
   `Σ_i (1/((N:ℝ)+i+1))^2 ≤ 1/N`) after a `congr` with `push_cast; ring`.

**A simpler alternative worth trying first:** replace the `k > 2n` regime by noting
`U_k ≤ 2^{−un}` also holds for **all** `k > n`, so
`Σ_{n<k≤Mn} U_k ≤ Mn·2^{−un}` for any fixed `M`; only `k > Mn` needs the `(n/k)^{un}` decay.
Choosing `M = 4` and using `Σ_{k>4n}(n/k)^2 ≤ n/4` keeps every constant explicit and lets the
final bound be `≤ (5e^{−uK/2} + Cn·2^{−un})`, with `Cn·2^{−un}` discharged by a second
eventual lemma `n·2^{−n/2} ≤ 1/n³` (`n ≥ 100`).

### 13.67 LANDED (round 63): the rpow split lemma

`Op56/PhiThird.lean` now has **79 declarations** (0 sorries, 7/7 OK), newly:

```lean
lemma rpow_neg_split (y : ℝ) (hy : 2 ≤ y) (s : ℝ) (hs : 2 ≤ s) :
    y^(-s) ≤ y^(-(2:ℝ)) * (2:ℝ)^(-(s-2))
```

This is the identity that extracts the exponential factor `2^{−(s−2)}` from a
polynomial-decay tail `y^{−s}` with `y ≥ 2` — the technical core of the `U`-tail's `k > 2n`
regime, isolated so it can be debugged and reused on its own.

**How it works** (the plumbing that took three attempts):
1. the exponent split must be a **`show` with an inner `rw [← Real.rpow_add]`**, not
   `rw [show -s = -(2:ℝ) - (s-2) by ring, Real.rpow_add hy0]` — the latter reports *pattern
   not found*, because `Real.rpow_add` wants to see `x^(y+z)` and the `show` has already
   rewritten the whole expression:
   ```lean
   rw [show y^(-s) = y^(-(2:ℝ)) * y^(-(s-2)) by
     rw [← Real.rpow_add hy0]; congr 1; ring]
   ```
2. then `Real.rpow_neg` twice and `inv_le_inv₀`, finishing with
   `Real.rpow_le_rpow (by norm_num : 0 ≤ 2) hy (by linarith : 0 ≤ s-2)`.

**Also verified in isolation:** `(1/2 : ℝ)^s = (2:ℝ)^(-s)` by
`rw [one_div, Real.inv_rpow (by norm_num : 0 ≤ 2), Real.rpow_neg (by norm_num : 0 ≤ 2)]`.

**Next: `phi_U_beyond_le` with `M = 4`** (§13.66's recommended simplification).  With
`rpow_neg_split` in hand the pieces are:
* `n < k ≤ 4n`: each term `≤ 2^{−un}` (since `1 + k/n > 2`), at most `3n` terms;
* `k > 4n`: `U_k ≤ (1+k/n)^{−un} ≤ (n/k)^{un}` and `rpow_neg_split` with `y = k/n`,
  `s = u*n` gives `≤ (n/k)^2·2^{−(un−2)}`; then `Σ_{k>4n}(n/k)^2 ≤ n²/(4n) = n/4`.
* total `≤ Cn·2^{−un}`, discharged by the eventual lemma `n·2^{−n/2} ≤ 1/n³` (`n ≥ 100`).

### 13.68 Round-64: `Real.rpow_natCast` will not fire on a numeral exponent

No declaration landed (build green: 79 declarations, 0 sorries, 7/7 OK).

The one identity blocking Part B of `phi_U_beyond_le` is

```lean
(1 + (((i:ℝ)+(n:ℝ)+1+(3:ℝ)*(n:ℝ))/(n:ℝ)))^(-(2:ℝ))
  = ((n:ℝ)/((i:ℝ)+(5:ℝ)*(n:ℝ)+1))^2
```

and the obstruction is narrow but sharp:

```lean
example (x : ℝ) (hx : 0 ≤ x) : x^(-(2:ℝ)) = (x^2)⁻¹ := by
  rw [Real.rpow_neg hx (2:ℝ)]   -- OK: goal becomes (x^(2:ℝ))⁻¹ = (x^2)⁻¹
  rw [Real.rpow_natCast]        -- FAILS: pattern `x ^ ↑?n` does not match `x ^ (2:ℝ)`
```

`Real.rpow_natCast (x) (n) : x ^ ↑n = x ^ n` matches only an explicitly *variable* cast
`↑n`; with the **numeral** `(2:ℝ)` the pattern is not found, so the two `rw`s cannot be
chained and neither can be written in one `rw [..., ...]`.

**Fixes to try, in order:**
1. `rw [Real.rpow_neg hx (2:ℝ)]; norm_num [Real.rpow_natCast]` — let `norm_num` look through
   the numeral;
2. `rw [show (x:ℝ)^(2:ℝ) = x^2 by norm_num]` as an explicit `show`;
3. avoid the rpow form entirely: state the needed comparison as
   `(1 + ((i+4n+1)/n))^(-(2:ℝ)) ≤ (n/(i+5n+1))^2 · 2` and prove it with
   `Real.rpow_le_rpow_of_nonpos` on bases, never converting the exponent.

**Note the same trap has appeared before** (§13.61 fix 1: `norm_num [Real.rpow_natCast,
Real.rpow_mul]` succeeded where a bare `rw [Real.rpow_natCast]` failed).  The general rule:
**do not chain `Real.rpow_neg` with `Real.rpow_natCast`** — go through `norm_num [ … ]` or an
explicit `show`.

### 13.69 Round-65: the `x^{−2}` identity — both recorded fixes confirmed, a third issue found

No declaration landed (build green: 79 declarations, 0 sorries, 7/7 OK).

**Both §13.68 fixes are confirmed working** (verified in isolation):
```lean
example (x : ℝ) (hx : 0 ≤ x) : x^(-(2:ℝ)) = (x^2)⁻¹ := by
  rw [Real.rpow_neg hx (2:ℝ)]
  norm_num [Real.rpow_natCast]                          -- works
-- or
  rw [show (x:ℝ)^(2:ℝ) = x^2 by norm_num]               -- works
```
So the round-64 obstruction is fully cleared: **`Real.rpow_neg` and `Real.rpow_natCast` must not
be chained; go through `norm_num [Real.rpow_natCast]` or an explicit `show`.**

**The composite identity now fails for a different, smaller reason.**  The target
`(1 + ((i+4n+1)/n))^{−2} = (n/(i+5n+1))²` is blocked by `positivity` failing on the side goal
`(0:ℝ) ≤ 1 + ((i+4n+1)/n)` (error at the `by positivity` argument of `Real.rpow_neg`), plus the
base identity `1 + ((i+4n+1)/n) = (i+5n+1)/n` needing `eq_div_iff (ne_of_gt hnR)` before `ring`
(plain `field_simp; ring` reports *unsolved goals* here, unlike the analogous step in
`phi_Q_tail_le`).

**Working shape for the identity** (all pieces now known-good):
```lean
  have hbase : (1:ℝ) + (((i:ℝ)+(4:ℝ)*(n:ℝ)+1)/(n:ℝ)) = ((i:ℝ)+(5:ℝ)*(n:ℝ)+1)/(n:ℝ) := by
    rw [eq_div_iff (ne_of_gt hnR)]; ring
  have hpos : (0:ℝ) ≤ 1 + (((i:ℝ)+(4:ℝ)*(n:ℝ)+1)/(n:ℝ)) := by
    have : (0:ℝ) ≤ ((i:ℝ)+(4:ℝ)*(n:ℝ)+1)/(n:ℝ) := by positivity
    linarith
  rw [Real.rpow_neg hpos (2:ℝ)]
  rw [show (1 + (((i:ℝ)+(4:ℝ)*(n:ℝ)+1)/(n:ℝ)))^(2:ℝ) = (((i:ℝ)+(5:ℝ)*(n:ℝ)+1)/(n:ℝ))^2 by
        rw [Real.rpow_natCast, hbase]]
  rw [div_pow, inv_div]
```

**Reflection on cost.**  Rounds 59–65 have produced one declaration, all of it inside this
one tail lemma.  Every failure has been notational (`Real.rpow` normalisation, `positivity`
side goals, `field_simp` not seeing through an integer cast) with no mathematical content.
For the next round I recommend: (a) write the three `Real.rpow` identities needed by
`phi_U_beyond_le` as **standalone lemmas first**, each verified in isolation, before touching
the tail sum; (b) as already noted in §13.68 fix 3, where possible avoid the rpow form
entirely by comparing bases rather than exponents.

### 13.70 LANDED (round 66): the three `rpow`/normalisation identities

`Op56/PhiThird.lean` now has **82 declarations** (0 sorries, 7/7 OK), newly:

```lean
lemma rpow_neg_two_eq_inv_sq (y : ℝ) (hy : 2 ≤ y) : y^(-(2:ℝ)) = (y⁻¹)^2
lemma one_add_fourn_div (i n : ℕ) (hn : 1 ≤ n) :
    1 + (((i:ℝ)+(4:ℝ)*(n:ℝ)+1)/(n:ℝ)) = ((i:ℝ)+(5:ℝ)*(n:ℝ)+1)/(n:ℝ)
lemma rpow_neg_two_fourn (i n : ℕ) (hn : 1 ≤ n) :
    (1 + (((i:ℝ)+(4:ℝ)*(n:ℝ)+1)/(n:ℝ)))^(-(2:ℝ)) = ((n:ℝ)/((i:ℝ)+(5:ℝ)*(n:ℝ)+1))^2
```

**The §13.69 discipline worked immediately**: written as three standalone lemmas, all three
compiled on the second attempt in a single round — versus three rounds of failure when the
same steps were inlined in the tail proof.

**The one remaining fix** (for `one_add_fourn_div`): after `rw [eq_div_iff hn0]` the goal is
`(1 + ((i+4n+1)/n))*n = i+5n+1`, which `ring` cannot close because of the leftover division.
Use
```lean
  rw [eq_div_iff hn0, add_mul, one_mul, div_mul_cancel₀ _ hn0]
  ring
```
Clearing the division with `div_mul_cancel₀` (rather than `field_simp`) is what makes the
final `ring` succeed.

`rpow_neg_two_fourn` then assembles them as
`rw [rpow_neg_two_eq_inv_sq _ hy2, one_add_fourn_div i n hn, inv_div]`.

**Next: `phi_U_beyond_le`** — with these in hand the pieces are exactly as in §13.67:
`n < k ≤ 4n` gives `≤ 3n·2^{−un}` by `Real.rpow_le_rpow_of_nonpos` against the base `2`, and
`k > 4n` uses `rpow_neg_split` plus `rpow_neg_two_fourn` with `tsum_inv_succ_sq_le (5*n)`.
Then the two eventual lemmas (`exp_neg_sqrt_le` done; `n·2^{−n/2} ≤ 1/n³` still to write) and
the `Phi_third_order` assembly.

### 13.71 Round-67: `phi_U_beyond_le` assembled — two structural fixes identified

No declaration landed (build green: 82 declarations, 0 sorries, 7/7 OK).

**Fix 1 (already applied): the `hun` side condition must use `n ≥ 4`, not `n ≥ 2`.**
`u ≥ 1/2` and `n ≥ 2` give only `u*n ≥ 1`; `2 ≤ u*n` needs `u*n ≥ 1/2 · 4`, i.e. `n ≥ 4`.

**Fix 2 (the structural one): `summable_phi` does not apply to `g` directly.**  Its exact form is
```lean
summable_phi (u : ℝ) (n : ℕ) : 1 ≤ n → 2 ≤ u * ↑n →
  Summable (fun j => (1 + (↑j + 1) / ↑n) ^ (-(u * ↑n)))
```
i.e. the numerator is `(↑j : ℝ) + 1` (a **Nat** successor), whereas both functions in
`phi_U_beyond_le` have numerators `↑i + ↑n + 1` and `↑i + 4↑n + 1`.  So summability must be
obtained by **comparison**, not by direct application:
```lean
  have hbase := summable_phi u n (by omega) hun
  have hsumm : Summable (fun i => (1 + (((i:ℝ)+(n:ℝ)+1)/(n:ℝ))) ^ (-(u*(n:ℝ)))) :=
    Summable.of_nonneg_of_le (fun i => by positivity) (fun i => ?_) hbase
  -- need: g i ≤ (1 + ((i:ℝ)+1)/(n:ℝ)) ^ (-(u*n))
  -- true since i+n+1 ≥ i+1, so the base is larger and the exponent negative
```
(the same comparison works for the `4n` variant, where `i+4n+1 ≥ i+1`).

**Remaining errors in `/tmp/w340.lean`** (6 reported, mostly downstream of Fix 2):
1. line 17 / 53: the two `summable_phi` applications — Fix 2 above;
2. line 39: `hL`'s `summable_phi` for the `4n` variant — Fix 2 again;
3. line 56 (`hR`): the `Summable.congr` with `summable_inv_succ_sq (5*n)` needs
   `((5*n:ℕ):ℝ) + i + 1 = (i:ℝ) + 5*(n:ℝ) + 1` by `push_cast; ring` — already written, but the
   surrounding `div_pow`/`ring` step needs checking once `5*n` is unfolded;
4. line 66: a `rw` pattern not found (likely `Real.rpow_sub`, whose statement should be checked
   against `Real.rpow_add` before use — cf. §13.63 where the analogous `Real.rpow_add` needed a
   `show` wrapper).

**Note line 9's spurious `unsolved goals`** — it points at the *statement* line, which usually
means an error from an earlier declaration is being attributed there; ignore it until the body
compiles.

### 13.72 LANDED (round 68): the two summability witnesses

`Op56/PhiThird.lean` now has **84 declarations** (0 sorries, 7/7 OK), newly:

```lean
lemma summable_phi_shift (u : ℝ) (n : ℕ) (hu1 : 1/2 ≤ u) (hn : 16 ≤ n) :
    Summable (fun i => (1 + (((i:ℝ)+(n:ℝ)+1)/(n:ℝ))) ^ (-(u*(n:ℝ))))
lemma summable_phi_shift4 (u : ℝ) (n : ℕ) (hu1 : 1/2 ≤ u) (hn : 16 ≤ n) :
    Summable (fun i => (1 + (((i:ℝ)+(4:ℝ)*(n:ℝ)+1)/(n:ℝ))) ^ (-(u*(n:ℝ))))
```

**The §13.71 recommendation worked exactly as intended:** writing the summability witnesses
*first*, against the literal function forms, and verifying them standalone, cleared the axis
that had blocked round 67.

Shape that works:
```lean
  have hbase := summable_phi u n (by omega) hun      -- hun : 2 ≤ u*n, needs n ≥ 4
  refine Summable.of_nonneg_of_le (fun i => by positivity) (fun i => ?_) hbase
  -- goal: g i ≤ (1 + ((i:ℝ)+1)/(n:ℝ)) ^ (-(u*n))
  have hb : (1:ℝ) + (((i:ℝ)+1)/(n:ℝ)) ≤ 1 + (((i:ℝ)+(n:ℝ)+1)/(n:ℝ)) := by
    have hq : ((i:ℝ)+1)/(n:ℝ) ≤ ((i:ℝ)+(n:ℝ)+1)/(n:ℝ) := by
      rw [div_le_div_iff₀ hnR hnR]; nlinarith [hn1]
    linarith
  exact Real.rpow_le_rpow_of_nonpos (by positivity) hb (by linarith : -(u*(n:ℝ)) ≤ 0)
```

**Tactic note:** after `div_le_div_iff₀ hnR hnR` the goal is `(↑i+1)*n ≤ (↑i+↑n+1)*n`,
which `linarith` **cannot** close (it would need to multiply the hypothesis `1 ≤ n`); use
`nlinarith [hn1]`.

**Next: `phi_U_beyond_le`** — now only the inequality work remains (§13.71 errors 1–3 are
resolved; error 4, a `rw` pattern in the `Real.rpow_sub` step, still to check).  Then the
eventual lemma `n·2^{−n/2} ≤ 1/n³` and the `Phi_third_order` assembly.

### 13.73 Round-69: `rpow_two_shift` verified; `hmaj` needs rewriting without Nat casts

No declaration landed (build green: 84 declarations, 0 sorries, 7/7 OK), but the last
`rpow` identity is now known-good in isolation:

```lean
lemma rpow_two_shift (u : ℝ) (n : ℕ) :
    (2:ℝ)^(-(u*(n:ℝ)-2)) = (2:ℝ)^(-(u*(n:ℝ))) * 4 := by
  rw [show -(u*(n:ℝ)-2) = -(u*(n:ℝ)) - (-(2:ℝ)) by ring,
    Real.rpow_sub (by norm_num : (0:ℝ) < 2)]
  rw [show (2:ℝ)^(-(2:ℝ)) = 1/4 by
    rw [Real.rpow_neg (by norm_num : (0:ℝ) ≤ 2)]
    norm_num [Real.rpow_natCast]]
  ring
```
(`Real.rpow_sub hx y z : x^(y-z) = x^y / x^z`; the inner `2^{−2} = 1/4` needs `Real.rpow_neg`
**plus** `norm_num [Real.rpow_natCast]`, exactly as in §13.68/§13.69.)

With the landed `summable_phi_shift`/`summable_phi_shift4`, `phi_U_beyond_le` now fails only
inside `hmaj`, and the cause is **the Nat cast `5*n` inside the tsum index**:

```
have h := tsum_inv_succ_sq_le (5*n) (by omega)
-- h : Σ'_i (1/((↑(5*n):ℝ)+i+1))^2 ≤ 1/(↑(5*n):ℝ)
```
Every attempt to write the matching summand produces unbalanced parentheses
(`unexpected token ')'` at line 73), because the expression nests
`(1/((((5*n:ℕ)):ℝ)+i+1))^2`.

**Fix: eliminate the Nat cast entirely.**  Set `h5n : ((5*n:ℕ):ℝ) = 5*(n:ℝ)` by
`push_cast; ring`, then `rw [h5n] at h` — which rewrites the summand *and* the bound at once —
and write everything in terms of `(5:ℝ)*(n:ℝ)` thereafter:
```lean
  have h5n : (((5*n:ℕ)):ℝ) = 5*(n:ℝ) := by push_cast; ring
  have h := tsum_inv_succ_sq_le (5*n) (by omega)
  rw [h5n] at h
  -- h : Σ'_i (1/(5*↑n+i+1))^2 ≤ 1/(5*↑n)
```
and the companion equality with `rw [← tsum_mul_left, div_pow]; ring` (the denominators differ
only by commutativity of `+`, so `ring_nf`/`congr 2; ring` may be needed inside the
`tsum_congr`).

**Recommended next step, applying the standing lesson:** extract the *single* identity
`Σ'_i (n/(i+5n+1))^2 = n²·Σ'_i (1/(i+5n+1))^2` as its own lemma, verified standalone, then
return to `phi_U_beyond_le`.  Every axis of this lemma that has been extracted first
(`rpow_neg_split`, `rpow_neg_two_fourn`, `rpow_two_shift`, the two summability witnesses) has
landed immediately; only the inlined steps have cost rounds.

### 13.74 LANDED (round 70): the `Σ (n/(i+5n+1))²` equality and its bound

`Op56/PhiThird.lean` now has **86 declarations** (0 sorries, 7/7 OK), newly:

```lean
lemma tsum_div_sq_eq (n : ℕ) :
    (∑' i, ((n:ℝ)/((i:ℝ)+(5:ℝ)*(n:ℝ)+1))^2)
      = (n:ℝ)^2 * (∑' i, (1/((i:ℝ)+(5:ℝ)*(n:ℝ)+1))^2)

lemma tsum_inv_fiven_le (n : ℕ) (hn : 1 ≤ n) :
    (∑' i, (1/((i:ℝ)+(5:ℝ)*(n:ℝ)+1))^2) ≤ 1/(5*(n:ℝ))
```

Both compiled on the **first** attempt once extracted — again confirming the standing lesson.

**The two fixes that made them work:**
1. **matching index forms on both sides** of `tsum_div_sq_eq`.  Writing the right-hand index as
   `(5:ℝ)*(n:ℝ)+i+1` (reversed order) makes `rw [div_pow, one_div, inv_pow]; ring` fail with an
   expanded-denominator goal; using `(i:ℝ)+(5:ℝ)*(n:ℝ)+1` on **both** sides lets `ring` close it
   directly, because no commutativity step is needed.
2. **eliminating the Nat cast `5*n`** exactly as §13.73 recommended: prove
   `h5n : ((5*n:ℕ):ℝ) = 5*(n:ℝ) := by push_cast; ring`, then `rw [h5n] at h` on the result of
   `tsum_inv_succ_sq_le (5*n)`, which rewrites the summand and the bound together.  The remaining
   index-order mismatch is then a single `congr 2; ring` inside `tsum_congr`.

**`phi_U_beyond_le` is now fully unblocked.**  Its `hmaj` becomes
```lean
  rw [← tsum_mul_left]
  apply mul_le_mul_of_nonneg_left _ (by positivity)
  rw [tsum_div_sq_eq]
  exact mul_le_mul_of_nonneg_left (tsum_inv_fiven_le n (by omega)) (by positivity)
```
and `hR` (summability of the majorant) is built from `summable_inv_succ_sq (5*n)` by
`h5n`-rewrite + `Summable.congr` + two `Summable.mul_left`s, then a final `ring` congr to
absorb the `n²` and `2^{−(un−2)}` factors.

### 13.75 LANDED (round 71): `phi_U_beyond_le` — the `U`-tail is complete

`Op56/PhiThird.lean` now has **88 declarations** (0 sorries, 7/7 OK), newly:

```lean
lemma rpow_two_shift (u : ℝ) (n : ℕ) :
    (2:ℝ)^(-(u*(n:ℝ)-2)) = (2:ℝ)^(-(u*(n:ℝ))) * 4

lemma phi_U_beyond_le (u : ℝ) (n : ℕ) (hu1 : 1/2 ≤ u) (hu2 : u ≤ 1) (hn : 16 ≤ n) :
    (∑' i, (1 + (((i:ℝ)+(n:ℝ)+1)/(n:ℝ))) ^ (-(u*(n:ℝ))))
      ≤ 4*(n:ℝ) * (2:ℝ)^(-(u*(n:ℝ)))
```

i.e. `Σ_{k>n} U_k ≤ 4n·2^{−un}` — exponentially small, and the last analytic input for
`Phi_third_order`.

**Only three fixes were needed**, all recorded in advance:
1. `tsum_mul_left` (not `← tsum_mul_left`) — the goal is `Σ c·f ≤ c·X`, so the constant must be
   pulled **out** of the sum, which is the forward direction;
2. the final bound `4·(n²·(1/(5n))) ≤ n` needs `rw [show n²·(1/(5n)) = n/5 by field_simp]`
   before `linarith` — `nlinarith` cannot see through the `(5n)⁻¹`;
3. `field_simp` closes that `show` on its own, so a trailing `ring` errors.

**This closes the tail.**  Every analytic input for `Phi_third_order` now exists:

| ingredient | lemma |
|---|---|
| termwise third-order bound | `phi_term_sharp3` |
| finite valid-index part | `phi_finite_part_le` |
| model sum, closed form | `PhiMainS_eq` |
| model-term tail | `phi_Q_tail_le` |
| `U`-tail | `phi_U_beyond_le` |
| eventual `e^{−c√n} ≤ n⁻³` | `exp_neg_sqrt_le` |

**Remaining for `Phi_third_order`:** the assembly
`|Φ − PhiMainS| ≤ 8·10¹⁰/n³ + (5e^{−uK/2} + C(4·10¹⁰+5))·e^{−uK/2}` with `K = ⌈√n/2⌉`,
using `Summable.sum_add_tsum_nat_add` to split at `K`, then `C/n³` via `exp_neg_sqrt_le`; and
the one outstanding eventual lemma `n·2^{−n/2} ≤ 1/n³` (`n ≥ 100`).

### 13.76 Round-72: the last eventual lemma — reduced to `4n ≤ 2^{n/4}`

No declaration landed (build green: 88 declarations, 0 sorries, 7/7 OK).

**Reduction (this is the useful part).**  The remaining tail term is `4n·2^{−un}`, and it need not
be handled by a new `log`-comparison.  Chain it into the *existing* `exp_neg_sqrt_le`:
```
4n·2^{-un} ≤ 4n·2^{-n/2} ≤ 2^{-n/4} ≤ Real.exp(-(Real.sqrt n)/8) ≤ 1/n³
```
* `2^{-un} ≤ 2^{-n/2}` since `u ≥ 1/2` (`Real.rpow_le_rpow_of_exponent_le`);
* `4n·2^{-n/2} ≤ 2^{-n/4}` **iff** `4n ≤ 2^{n/4}` — the one new fact;
* `2^{-n/4} ≤ e^{−√n/8}` since `(n/4)log 2 ≥ √n/8` for `n ≥ 1`;
* the last step is the already-landed `exp_neg_sqrt_le`.

So the whole remaining obligation is the single lemma
```lean
lemma four_mul_le_two_pow {n : ℕ} (hn : 1024 ≤ n) : 4*(n:ℝ) ≤ (2:ℝ)^((n:ℝ)/4)
```
i.e. `log(4n) ≤ (n/4)log 2`, proved by the chain `log(4n) = log 4 + log n ≤ 3 + 2√n ≤ n/8 ≤
(n/4)log 2`, using `Real.log_le_rpow_div` at `ε = 1/2` for `log n ≤ 2√n`.

**Two errors in the draft (`/tmp/w382.lean`):**
1. line 15: `Real.le_sqrt` — check its argument order; `Real.le_sqrt (hx) (hy) : x ≤ √y ↔ x^2 ≤ y`,
   but the `rw` did not fire, so state it as
   `have hs : (32:ℝ) ≤ Real.sqrt (n:ℝ) := (Real.le_sqrt (by norm_num) (by positivity)).mpr (by nlinarith)`
   (a `.mpr` application rather than a `rw`);
2. line 23: `rw [Real.sqrt_eq_rpow, show (n:ℝ)^(1/2:ℝ)/(1/2:ℝ) = 2*(n:ℝ)^(1/2:ℝ) by ring] at h`
   reports *pattern not found* — `Real.log_le_rpow_div` returns `log x ≤ x^ε/ε` with the numeral
   `1/4`-style division, so match the exact form `x^(1/2)/(1/2)` or go through
   `have := Real.log_le_rpow_div ...; rw [div_eq_mul_inv] at this` before `ring`.

**Also note:** `Real.log_two_gt_d9 : 0.6931471803 < Real.log 2` supplies `1/2 ≤ log 2`;
`Real.log_le_sub_one_of_pos` supplies `log 4 ≤ 3`.

### 13.77 LANDED (round 73): the last eventual estimate — tail inputs complete

`Op56/PhiThird.lean` now has **90 declarations** (0 sorries, 7/7 OK), newly:

```lean
lemma four_mul_le_two_pow {n : ℕ} (hn : 1024 ≤ n) : 4*(n:ℝ) ≤ (2:ℝ)^((n:ℝ)/4)
lemma poly_two_neg_le {u : ℝ} {n : ℕ} (hu : 1/2 ≤ u) (hn : 100000000 ≤ n) :
    4*(n:ℝ) * (2:ℝ)^(-(u*(n:ℝ))) ≤ (1:ℝ)/((n:ℝ)^3)
```

`poly_two_neg_le` is the chain `4n·2^{−un} ≤ 4n·2^{−n/2} ≤ 2^{−n/4} ≤ e^{−√n/8} ≤ n⁻³`,
ending in the landed `exp_neg_sqrt_le` — exactly the §13.76 reduction.

**The three fixes that closed it** (all recorded in advance in §13.76):
1. `Real.le_sqrt` must be applied as `.mpr`, not `rw`:
   `(Real.le_sqrt (by norm_num) (by positivity)).mpr (by nlinarith)`;
2. `Real.log_le_rpow_div (hx) (hε) : log x ≤ x^ε/ε` returns the **division form**; match it with
   a separate `have h2 : x^(1/2)/(1/2) = 2*x^(1/2) := by ring` and `linarith [h, h2]`, rather
   than trying to `rw` a `show` inside it;
3. `Real.sq_sqrt` has type `√n ^ 2 = n`, **not** `√n * √n = n` — a `*`-form statement is a type
   mismatch.

**All analytic inputs for `Phi_third_order` are now landed.**  The remaining work is the
assembly (`Summable.sum_add_tsum_nat_add` to split `Φ − PhiMainS` at `K = ⌈√n/2⌉`, combine
`phi_finite_part_le` with `phi_Q_tail_le` and `phi_U_beyond_le`, and discharge
`8·10¹⁰/n³` plus the exponentially small terms), and then `Phi_third_order` follows from
`PhiMainS_eq`.

### 13.78 Round-74: assembly structure — `phi_U_beyond_le` has shift `n` baked in

No declaration landed (build green: 90 declarations, 0 sorries, 7/7 OK).

**The finding.**  `phi_U_beyond_le` is stated for the *fixed* shift `n`:
`Σ'_i (1 + ((i+n+1)/n))^{−un} ≤ 4n·2^{−un}`, i.e. it bounds `Σ'_i U_{i+n}` where
`U_j = (1 + (j+1)/n)^{−un}`.  `phi_Q_tail_le`, by contrast, **does** take a general shift `K`.
The assembly needs the split at `N ≈ √n/2`, so the `U`-tail `Σ'_i U_{i+N}` is *not* directly
covered.

**Fix that avoids a new lemma** — split the `U`-sum once more, at `n`:
```
Σ'_i U_{i+N} = Σ_{i<n-N} U_{i+N} + Σ'_i U_{i+n}      (for N ≤ n)
```
* the first part has `i+N ≤ n`, so `U ≤ e^{−u(i+N)/2}` (`rpow_le_exp_half`) and its sum is
  `≤ 5e^{−uN/2}`;
* the second part **is exactly** `phi_U_beyond_le`'s left-hand side, giving `≤ 4n·2^{−un}`.

So `Σ'_i U_{i+N} ≤ 5e^{−uN/2} + 4n·2^{−un}` with no new tail lemma.

**Second requirement:** to write `|U_{i+N} − Q_{i+N}| ≤ U_{i+N} + Q_{i+N}` we need `Q ≥ 0` on the
tail.  `Q_j = e^{−u(j+1)}(1 + y − z + y²/2)` with `y = u(j+1)²/(2n)`, `z = u(j+1)³/(3n²)`, and
`z ≤ y²/2` **iff** `j+1 ≥ 8/(3u) ≥ 8/3`, so `1 + y − z + y²/2 ≥ 1 + y > 0` for `j ≥ 2`.  With
the split point `N ≥ 2` this holds for every tail index — needs a short standalone lemma.

**Draft in `/tmp/w390.lean`** has the right shape for `phi_tail_sum_le`; its two errors are the
`phi_U_beyond_le` shift mismatch above and the missing `Q ≥ 0` fact.

**Next:** land (a) `Q_nonneg_tail` (`2 ≤ j → 0 ≤ e^{−uj}(1 + y − z + y²/2)`), then
(b) `phi_U_shift_le` (`Σ'_i U_{i+N} ≤ 5e^{−uN/2} + 4n·2^{−un}` for `N ≤ n`), then
(c) `phi_tail_sum_le`, then the final assembly.  Each of these is a single standalone fact, per
the standing lesson.

### 13.79 Round-75: `phi_Q_term_nonneg` — one `nlinarith` from closing

No declaration landed (build green: 90 declarations, 0 sorries, 7/7 OK).

**The mathematics is settled and simpler than §13.78 proposed.**  Rather than splitting on
`2j` vs `3n`, the key inequality `z ≤ y + y²/2` (with `y = u j²/(2n)`, `z = u j³/(3n²)`) holds
for **all** `j`: after multiplying by `24n²` it becomes `8j ≤ 12n + 3uj²`, and
* `j ≤ 5`:  `8j ≤ 40 ≤ 12·16 ≤ 12n`;
* `j ≥ 6`:  `3uj² ≥ (3/2)j² ≥ 9j ≥ 8j`.
So the proof only needs a split on `j < 6` vs `j ≥ 6`, and `n ≥ 16` handles the small case.

Then `1 + y − z + y²/2 ≥ 1 + y − (y + y²/2) + y²/2 = 1 > 0`, so `Q_j ≥ 0` for every `j` — the
`N ≥ 2` side condition of §13.78 is not needed.

**Remaining error (`/tmp/w401.lean`, line 21):** the second case of `hcore`.  The fix in hand is
```lean
  have hmul : 8*(j:ℝ) ≤ 3*u*(j:ℝ)^2 := by nlinarith [hj6, hu1, sq_nonneg ((j:ℝ))]
  have hprod : u*(j:ℝ)^2 * (8*(j:ℝ)) ≤ u*(j:ℝ)^2 * (3*u*(j:ℝ)^2) :=
    mul_le_mul_of_nonneg_left hmul (by positivity)
  nlinarith [hprod, …powers…]
```
(the left-multiplication by `u j²` has to be supplied explicitly — `nlinarith` alone does not
find it).  The `hsq` step needs `field_simp` **then** `ring` (separate lines).

**Then:** `phi_U_shift_le`, `phi_tail_sum_le`, and the final assembly, per §13.78.

### 13.80 LANDED (round 75): model-term positivity, with a simplification

`Op56/PhiThird.lean` now has **91 declarations** (0 sorries, 7/7 OK), newly:

```lean
lemma phi_Q_term_nonneg (u : ℝ) (n j : ℕ) (hu1 : 1/2 ≤ u) (hu2 : u ≤ 1) (hn : 16 ≤ n) :
    0 ≤ Real.exp (-(u*(j:ℝ))) * (1 + u*(j:ℝ)^2/(2*(n:ℝ))
        - u*(j:ℝ)^3/(3*(n:ℝ)^2) + (u*(j:ℝ)^2/(2*(n:ℝ)))^2/2)
```

**The §13.78 concern was unnecessary.**  I had planned to require `j ≥ 2` via the split
`z ≤ y²/2` for `j+1 ≥ 8/(3u)`.  In fact `z ≤ y + y²/2` holds for **all** `j`: after multiplying
by `24n²` it reads `8j ≤ 12n + 3uj²`, and
* `j ≤ 5`: `8j ≤ 40 ≤ 12·16 ≤ 12n`;
* `j ≥ 6`: `3uj² ≥ (3/2)j² ≥ 9j ≥ 8j`.
Hence `1 + y − z + y²/2 ≥ 1 + y − (y + y²/2) + y²/2 = 1 > 0`, and no side condition on `j` is
needed — which also removes a `N ≥ 2` obligation from the assembly.

**Tactic note (recurring):** `nlinarith` will **not** find the left-multiplication by `u j²`;
each case needs
`mul_le_mul_of_nonneg_left h (by positivity)` supplied as its own `have` before the final
`nlinarith`.  Also `hsq` needs `field_simp` **then** `ring` on separate lines.

**Next: `phi_U_shift_le`** (`Σ'_i U_{i+N} ≤ 5e^{−uN/2} + 4n·2^{−un}` for `N ≤ n`, splitting the
`U`-sum at `n` and using the landed `phi_U_beyond_le` for the second half), then
`phi_tail_sum_le`, then the final assembly.

### 13.81 Round-76: `phi_U_shift_le` drafted — 4 errors enumerated

No declaration landed (build green: 91 declarations, 0 sorries, 7/7 OK).

The lemma (`/tmp/w411.lean`):
```lean
lemma phi_U_shift_le (u : ℝ) (n N : ℕ) (hu1 : 1/2 ≤ u) (hu2 : u ≤ 1) (hn : 16 ≤ n)
    (hN : 1 ≤ N) (hNn : N ≤ n) :
    (∑' i, (1 + (((i:ℝ)+(N:ℝ)+1)/(n:ℝ))) ^ (-(u*(n:ℝ))))
      ≤ 6 * Real.exp (-(u*(N:ℝ))/2) + 4*(n:ℝ) * (2:ℝ)^(-(u*(n:ℝ)))
```
Structure (all pieces landed or standard):
* `hsm` from `summable_phi` via `(summable_nat_add_iff N).2` + `congr` with
  `simp only [Nat.cast_add]`;
* `sum_add_tsum_nat_add (n-N)` splits off the first block, with `Nat.sub_add_cancel hNn`
  giving `(n-N)+N = n`;
* first block: each term `≤ e^{−u(i+N)/2}` by `rpow_le_exp_half` (needs `1 ≤ i+N ≤ n`), then
  `Summable.sum_le_tsum`, then `e^{−u(i+N)/2} = e^{−uN/2}·e^{−ui/2}` and
  `tsum_exp_neg_half_le` (`≤ 6`) — giving `≤ 6e^{−uN/2}`;
* second block is exactly `phi_U_beyond_le`'s left side, giving `≤ 4n·2^{−un}`.

**Four errors:**
1. `summable_exp_shift` (the helper built on `summable_geometric_of_norm_lt_one`) has no
   `hu1 : 1/2 ≤ u` hypothesis, so the side goal `−(u/2) < 0` cannot be closed — **add `hu1` as a
   parameter**;
2. the `rpow_le_exp_half u n (i+N) …` application: check its argument order (it is
   `(u) (n) (k) (hu1) (hu2) (hn : 4 ≤ n) (hk : 1 ≤ k) (hkn : k ≤ n)`);
3. `hcong`'s `field_simp` leaves a goal — the two index forms
   `↑i+↑n+1` and `↑i+↑N+1+(↑n−↑N)` must be reconciled with `ring` **before** `field_simp`, or by
   stating both sides in the identical `↑i+↑n+1` form;
4. the final `linarith` needs the `hsplit` equality in the explicit
   `∑_{range} + ∑' = ∑'` orientation (cf. §13.57 fix 1).

**Cheaper alternative worth trying first:** avoid the `∑_{range}` block entirely by bounding
`Σ'_i U_{i+N} ≤ Σ'_i e^{−u(i+N)/2}` *for all* `i` — true only for `i+N ≤ n`, so not directly
available; but splitting at `n−N` is exactly what forces the `Finset` block.  A second option is
to state `phi_U_shift_le` only for `N = n` (where it is `phi_U_beyond_le` with a `6e^{−un/2}`
term) and to route the assembly's tail through two applications instead.

### 13.82 LANDED (round 77): the shifted `U`-tail

`Op56/PhiThird.lean` now has **93 declarations** (0 sorries, 7/7 OK), newly:

```lean
lemma summable_exp_shift (u : ℝ) (hu1 : 1/2 ≤ u) (N : ℕ) :
    Summable (fun i => Real.exp (-(u*((i:ℝ)+(N:ℝ)+1))/2))

lemma phi_U_shift_le (u : ℝ) (n N : ℕ) (hu1 : 1/2 ≤ u) (hu2 : u ≤ 1) (hn : 16 ≤ n)
    (hN : 1 ≤ N) (hNn : N ≤ n) :
    (∑' i, (1 + (((i:ℝ)+(N:ℝ)+1)/(n:ℝ))) ^ (-(u*(n:ℝ))))
      ≤ 6 * Real.exp (-(u*(N:ℝ))/2) + 4*(n:ℝ) * (2:ℝ)^(-(u*(n:ℝ)))
```

with the split `Σ'_i U_{i+N} = Σ_{i<n−N}U_{i+N} + Σ'_i U_{i+n}`: the first block is geometric
(`rpow_le_exp_half`, `Summable.sum_le_tsum`, `tsum_exp_neg_half_le` giving the `6`), the second
is exactly `phi_U_beyond_le`.

**The three fixes:**
1. `summable_exp_shift` needed `hu1 : 1/2 ≤ u` as a parameter (the side goal `−(u/2) < 0` needs it);
2. `rpow_le_exp_half u n k` has LHS `(1 + k/n)^{−un}`, i.e. `k = j+1` in the `U_j` indexing — so
   the application is `k = i+N+1` and the result needs
   `simpa [Nat.cast_add, Nat.cast_one] using h`;
3. after `rw [← hsplit]` the goal carries `↑(i + (n−N))`, which `hcong2` (stated with
   `↑i + ↑(n−N)`) does not match — insert `simp only [Nat.cast_add] at *` between the two `rw`s.

**Note the recurring shape of fix 3:** it is the same "make the two terms syntactically identical"
issue as §13.68/§13.70/§13.73.  Inserting `simp only [Nat.cast_add]` **before** the rewrite that
needs it is now a routine step and should be tried first whenever a `tsum_congr`/`rw` fails with
*pattern not found* on an index involving a Nat cast.

**Next: `phi_tail_sum_le`** — `Σ'_i |U_{i+N} − Q_{i+N}| ≤ 2e^{−uN/2}(4·10¹⁰+5) + 5e^{−uN/2} +
4n·2^{−un}`, using `|U−Q| ≤ U+Q` (both nonneg, via the landed `phi_Q_term_nonneg` and positivity
of `U`), `Summable.tsum_add`, `phi_Q_tail_le` and `phi_U_shift_le`.  Then the final assembly.

### 13.83 Round-78: `phi_tail_sum_le` drafted — one error left

No declaration landed (build green: 93 declarations, 0 sorries, 7/7 OK).

The lemma (`/tmp/w430.lean`):
```lean
lemma phi_tail_sum_le (u : ℝ) (n N : ℕ) (hu1 : 1/2 ≤ u) (hu2 : u ≤ 1) (hn : 16 ≤ n)
    (hN : 1 ≤ N) (hNn : N ≤ n) :
    (∑' i, |U_{i+N} − Q_{i+N}|)
      ≤ 2 * (Real.exp (-(u*(N:ℝ))/2) * (4*10^10 + 5)) + 6 * Real.exp (-(u*(N:ℝ))/2)
        + 4*(n:ℝ) * (2:ℝ)^(-(u*(n:ℝ)))
```
where `Q_j` is indexed as in `phi_Q_tail_le` (`e^{−u j}(…)`), so `Q_{i+N}` uses index `i+N+1`
in that convention — hence `phi_Q_tail_le u n (N+1)` and `phi_Q_term_nonneg u n (i+N+1)`.

**Fixes already applied:**
* `phi_Q_term_nonneg u n (i+N+1) …` needs `simpa [Nat.cast_add, Nat.cast_one]` (the landed lemma
  carries `↑(i+N+1)`, the goal `↑i+↑N+1`) — §13.82's rule again;
* `abs_sub_le_iff` must be used as `.mpr ⟨_, _⟩`, not `rw` (it is an `↔` over an `AddCommGroup`,
  and `rw` reports an application type mismatch).

**Remaining error (line 43):** the `exact abs_sub_le_iff.mpr ⟨by linarith, by linarith⟩` for
`|U − Q| ≤ U + Q`.  Both sides need the nonnegativity facts `h1 : 0 ≤ U` and `h2 : 0 ≤ Q`
already in scope, but the two `linarith`s apparently do not see them through the
`Real.rpow`/`Real.exp` products; supply the two component inequalities explicitly instead:
```lean
    refine abs_sub_le_iff.mpr ⟨?_, ?_⟩
    · linarith [h2]      -- U - Q ≤ U + Q
    · linarith [h1]      -- Q - U ≤ U + Q
```

**Then:** summability (`Summable.of_nonneg_of_le` against the sum of the `U`- and `Q`-summables),
`Summable.tsum_add`, and `linarith [hmain, hU, hQ, hQN1, …]` — the last needs the
`e^{−u(N+1)/2} ≤ e^{−uN/2}` step multiplied through by `2(4·10¹⁰+5)`.

### 13.84 Round-78 (cont.): the real blocker — `summable_phi_shift` has shift `n` baked in

The line-43 error resolves the picture completely: `summable_phi_shift`/`summable_phi_shift4`
are stated for the **fixed** shifts `n` and `4n` (numerators `↑b+↑n+1`, `↑b+4↑n+1`).  For the
general-`N` tail I need `Summable (fun i => (1 + ((↑i+↑N+1)/n))^{−un})`, which those do **not**
provide.  (This is the same defect that §13.78 found in `phi_U_beyond_le`, now recurring one
level down in the summability witnesses.)

**Constructible directly**, mirroring the `hsm` block already used inside `phi_U_shift_le`:
```lean
  have hun : (2:ℝ) ≤ u*(n:ℝ) := …
  have hf : Summable (fun j => (1 + ((↑j+1)/n)) ^ (-(u*n))) := summable_phi u n (by omega) hun
  have hsmN : Summable (fun i => (1 + ((↑i+↑N+1)/n)) ^ (-(u*n))) := by
    have h := (summable_nat_add_iff N).2 hf
    refine h.congr (fun i => ?_); simp only [Nat.cast_add]
```

**The `Q`-summability** is the other missing witness.  It follows by comparison with the
`phi_Q_tail_le` majorant: `Q_{i+N} ≤ 2^{−(un−2)}·(n/(i+N+2))²`, and
`Summable (fun i => 2^{−(un−2)}*(n/(i+N+2))²)` comes from `summable_inv_succ_sq` — exactly the
argument used inside `phi_Q_tail_le`'s `hR` (§13.71), which will have to be repeated here because
`phi_Q_tail_le` returns only the bound, not the summability.

**Recommendation for next round (structural, not tactical).**  Stop adding witnesses at the point
of use.  Land **two** standalone lemmas first:
```lean
lemma summable_phi_shiftN (u : ℝ) (n N : ℕ) (hu1 : 1/2 ≤ u) (hn : 16 ≤ n) :
    Summable (fun i => (1 + ((↑i+↑N+1)/n)) ^ (-(u*n)))
lemma summable_Q_shiftN (u : ℝ) (n N : ℕ) (hu1 : 1/2 ≤ u) (hu2 : u ≤ 1) (hn : 16 ≤ n) :
    Summable (fun i => Real.exp (-(u*(↑i+↑N+1))) * (1 + u*(↑i+↑N+1)^2/(2*n) - …))
```
Then `phi_tail_sum_le` becomes a short `Summable.tsum_le_tsum` assembly with no embedded witness
construction — which is precisely the pattern that landed `phi_U_shift_le` (§13.82) after the
`summable_exp_shift` helper was extracted.  **This is the fifth time the same remedy applies; it
should be applied before writing `phi_tail_sum_le` again.**

### 13.85 LANDED (round 79): the two general-`N` summability witnesses

`Op56/PhiThird.lean` now has **95 declarations** (0 sorries, 7/7 OK), newly:

```lean
lemma summable_phi_shiftN (u : ℝ) (n N : ℕ) (hu1 : 1/2 ≤ u) (hn : 16 ≤ n) :
    Summable (fun i => (1 + (((i:ℝ)+(N:ℝ)+1)/(n:ℝ))) ^ (-(u*(n:ℝ))))

lemma summable_Q_shiftN (u : ℝ) (n N : ℕ) (hu1 : 1/2 ≤ u) (hu2 : u ≤ 1) (hn : 16 ≤ n) :
    Summable (fun i => Real.exp (-(u*((i:ℝ)+(N:ℝ)+1)))
        * (1 + u*((i:ℝ)+(N:ℝ)+1)^2/(2*(n:ℝ)) - u*((i:ℝ)+(N:ℝ)+1)^3/(3*(n:ℝ)^2)
            + (u*((i:ℝ)+(N:ℝ)+1)^2/(2*(n:ℝ)))^2/2))
```

`summable_phi_shiftN` is `(summable_nat_add_iff N).2 (summable_phi …)` + `congr` with
`simp only [Nat.cast_add]`.  `summable_Q_shiftN` is built as the four-term combination of shifted
moment sums: a `hshift : ∀ m, Summable (fun i => (↑i+↑N+1)^m * e^{−u(↑i+↑N+1)})` from
`(summable_nat_add_iff (N+1)).2 (summable_exp_neg_u u hu1 m)`, then
`((h0.add (h2.mul_left …)).sub (h3.mul_left …)).add (h4.mul_left …)` and a final `ring`.

**Both compiled on the second attempt**, and the fix was again the same one:
`simp only [Nat.cast_add, Nat.cast_one]` is **not** enough for `↑(i + (N+1))` — use
`push_cast; ring`.  Recording the rule: for casts of a *compound* Nat index (a sum containing a
literal), `push_cast` handles it where `simp only [Nat.cast_add]` does not.

**Fifth application of the extraction remedy, fifth one-round landing** (§13.84's recommendation).
`phi_tail_sum_le` should now be a short `Summable.tsum_le_tsum` assembly using
`summable_phi_shiftN`, `summable_Q_shiftN`, `phi_U_shift_le` and `phi_Q_tail_le` — no embedded
witness construction.

### 13.86 Round-80: `phi_tail_sum_le` — assembly written, final `linarith` blocked

No declaration landed (build green: 95 declarations, 0 sorries, 7/7 OK).

The lemma is now **structurally complete** in `/tmp/w450.lean`: the pointwise bound `|U−Q| ≤ U+Q`
(via `phi_Q_term_nonneg` + positivity of the `rpow`, then `abs_sub_le_iff.mpr ⟨_,_⟩` with the two
components supplied separately — a plain `rw [abs_sub_le_iff]` and a bare `linarith` both fail),
the summabilities via the new `summable_phi_shiftN`/`summable_Q_shiftN`, and the index conversion
`Σ'_i Q_{i+N}` (form `↑i+↑N+1`) to `phi_Q_tail_le u n (N+1)`'s form (`↑i+↑(N+1)`) by a
`tsum_congr` with `push_cast; ring`.

**Only the final `linarith` fails** (line 61): combining `hmain : Σ|U−Q| ≤ Σ(U+Q)`,
`hU : ΣU ≤ 6e^{−uN/2} + 4n·2^{−un}` and `hQ : ΣQ ≤ e^{−uN/2}(4·10¹⁰+5)·2` to reach the stated RHS
`2(e^{−uN/2}(4·10¹⁰+5)) + 6e^{−uN/2} + 4n·2^{−un}`.

**Fixes to try, in order:**
1. make the **statement's** first term literally match `hQ`'s RHS:
   write `Real.exp (-(u*(N:ℝ))/2) * (4*10^10 + 5) * 2` instead of
   `2 * (Real.exp (-(u*(N:ℝ))/2) * (4*10^10 + 5))` — the `hcomm` bridge I added was not enough,
   which suggests the mismatch is elsewhere;
2. check `Summable.tsum_add hsumU hsumQ` is oriented as needed: it is
   `Σ'(f+g) = Σ'f + Σ'g`, so it must be used **forward** on the *goal's* side or as `hUQ` in the
   form `Σ'(U+Q) = Σ'U + Σ'Q`; if `hmain`'s right side is literally `Σ'(U+Q)` then `rw [hUQ] at hmain`
   replaces it with `Σ'U + Σ'Q` and the `linarith` should then close;
3. if still stuck, do the arithmetic explicitly:
   `have : Σ|U−Q| ≤ (ΣU) + (ΣQ) := by linarith [hmain, hUQ]` then
   `linarith [this, hU, hQ]`.

**Note (standing lesson, sixth instance):** the two remaining blockers are both *form* mismatches
between a landed lemma's exact statement and the composition's need — first
`summable_phi_shift`'s fixed shift, now `phi_Q_tail_le`'s `↑i+↑(N+1)` index and the RHS
parenthesisation.  This is the strongest argument yet for the plan in §13.84: write the whole
assembly's call sites and their exact expected types **before** writing the assembly, so the form
mismatches are visible at plan time rather than at `linarith` time.

### 13.87 Round-81: `phi_tail_sum_le` — one index-form mismatch left

No declaration landed (build green: 95 declarations, 0 sorries, 7/7 OK).

Progress: the final `linarith` now has all three hypotheses in the right *arithmetic* shape
(`hstep : Σ|U−Q| ≤ ΣU + ΣQ`, `hU`, and `hQ2`), and the statement's first term was changed to
`Real.exp (-(u*(N:ℝ))/2) * (4*10^10 + 5) * 2` to match `hQ`'s parenthesisation exactly.  The one
remaining failure is at the definition of `hQ2`:

```lean
  have hQ2 : (∑' i, Real.exp (-(u*((i:ℝ)+(N:ℝ)+1))) * (1 + …)) ≤ … := by
    rw [← hQ'] at hQ     -- hQ' : (+1 form) = (↑i+↑(N+1) form)
    simpa using hQ
```
`Type mismatch: After simplification, term …` — i.e. `hQ` rewritten into the `+1` form still
does not match `hQ2`'s stated left side at the level of definitional equality.

**Recommended fix (do this rather than more `rw`/`simpa` juggling):** do not state `hQ2` at all.
Instead give `phi_Q_tail_le` a **companion** stated in the `+1` index form directly, so that the
composition never has to convert:
```lean
lemma phi_Q_tail_le' (u : ℝ) (n N : ℕ) (hu1 : 1/2 ≤ u) (hu2 : u ≤ 1) (hn : 16 ≤ n) (hN : 1 ≤ N) :
    (∑' i, Real.exp (-(u*((i:ℝ)+(N:ℝ)+1))) * (1 + u*((i:ℝ)+(N:ℝ)+1)^2/(2*(n:ℝ))
        - u*((i:ℝ)+(N:ℝ)+1)^3/(3*(n:ℝ)^2) + (u*((i:ℝ)+(N:ℝ)+1)^2/(2*(n:ℝ)))^2/2))
      ≤ Real.exp (-(u*(N:ℝ))/2) * (4*10^10 + 5) * 2 := by
    have h := phi_Q_tail_le u n (N+1) hu1 hu2 hn (by omega)
    -- convert h's index ↑i+↑(N+1) to ↑i+↑N+1 by tsum_congr with push_cast
    …
```
(`e^{−u(N+1)/2} ≤ e^{−uN/2}` supplies the RHS.)  With `phi_Q_tail_le'` landed standalone and
verified, `phi_tail_sum_le` becomes a mechanical `linarith`.

**This is the seventh form-mismatch instance.**  The pattern is invariant: a landed lemma's
statement differs from the composition's need by the *syntactic form* of an index or a
parenthesisation, and no amount of `rw`/`simpa`/`linarith` bridges it reliably.  The fix is always
to land a companion lemma with the exact form the composition needs, verified in isolation.
**Land `phi_Q_tail_le'` before touching `phi_tail_sum_le` again.**

### 13.88 LANDED (round 82): `phi_Q_tail_le'` and `phi_tail_sum_le` — the tail is complete

`Op56/PhiThird.lean` now has **97 declarations** (0 sorries, 7/7 OK), newly:

```lean
lemma phi_Q_tail_le' (u : ℝ) (n N : ℕ) (hu1 : 1/2 ≤ u) (hu2 : u ≤ 1) (hn : 16 ≤ n)
    (hN : 1 ≤ N) : (∑' i, Q_{i+N}) ≤ Real.exp (-(u*(N:ℝ))/2) * (4*10^10 + 5) * 2

lemma phi_tail_sum_le (u : ℝ) (n N : ℕ) (hu1 : 1/2 ≤ u) (hu2 : u ≤ 1) (hn : 16 ≤ n)
    (hN : 1 ≤ N) (hNn : N ≤ n) :
    (∑' i, |U_{i+N} − Q_{i+N}|)
      ≤ Real.exp (-(u*(N:ℝ))/2) * (4*10^10 + 5) * 2 + 6 * Real.exp (-(u*(N:ℝ))/2)
        + 4*(n:ℝ) * (2:ℝ)^(-(u*(n:ℝ)))
```

**The §13.87 recommendation worked exactly as written.**  `phi_Q_tail_le'` is `phi_Q_tail_le` with
the index restated in the `↑i+↑N+1` form (`hconv` via `tsum_congr` + `push_cast; ring`, then
`e^{−u(N+1)/2} ≤ e^{−uN/2}` multiplied through) and it compiled on the **second** attempt.
With it in hand, `phi_tail_sum_le` became the mechanical `linarith` predicted — the entire
`hQ'`/`hQ2` conversion machinery disappeared.

That is the **eighth instance** of the form-mismatch pattern and the **eighth one-round landing**
when the remedy is applied (rounds 42–44, 63, 66, 68, 70, 71, 73, 77, 79, 82).  Rounds 78, 80 and
81 — where the mismatch was bridged in place rather than by a companion lemma — produced nothing.

**Everything for `Phi_third_order` is now in place except the assembly itself.**
The remaining steps:
1. split `Φ − PhiMainS = Σ'_j (U_j − Q_j)` at `N := Nat.sqrt (n/4) + 1` via
   `Summable.sum_add_tsum_nat_add N`, so that `4(N−1)² ≤ n` (feeding `phi_finite_part_le`) and
   `N ≥ √n/2` (so `e^{−uN/2} ≤ e^{−√n/8}`, feeding `exp_neg_sqrt_le`);
2. finite part: `phi_finite_part_le u n N …` gives `≤ 8·10¹⁰/n³`;
3. tail: `phi_tail_sum_le u n N …` gives the three exponentially small terms, each `≤ C/n³`
   by `exp_neg_sqrt_le` (`e^{−uN/2} ≤ e^{−√n/8}`) and `poly_two_neg_le`;
4. `PhiMainS_eq` supplies the closed form, giving `Phi_third_order`.

### 13.89 Round-83: assembly planning — the split point and a new eventual constant

No declaration landed (build green: 97 declarations, 0 sorries, 7/7 OK).  This round was spent on
the call-graph analysis that §13.84/§13.87/§13.88 insisted on, and it paid off by finding two
form problems **before** writing the assembly.

**Split point.**  `N := Nat.sqrt (n/4) + 1`, using `Nat.sqrt_le' (K) : K.sqrt^2 ≤ K` and
`Nat.le_sqrt : m ≤ n.sqrt ↔ m*m ≤ n`.  What the assembly needs:
* `4*(N−1)² ≤ n` — for `phi_finite_part_le`'s `∀ k < N, 4k² ≤ n`.  From
  `Nat.sqrt_le' (n/4) : (n/4).sqrt^2 ≤ n/4`, so `4·(n/4).sqrt^2 ≤ 4·(n/4) ≤ n` in ℕ.
* `(N:ℝ) ≥ Real.sqrt (n:ℝ)/4` — so that `e^{−uN/2} ≤ e^{−√n/16}`, since `u ≥ 1/2` gives
  `uN/2 ≥ u√n/8 ≥ √n/16`.

**The Nat/real division mismatch.**  `Nat.sqrt (n/4)` uses **Nat** division while the needed
comparison is against `Real.sqrt ((n:ℝ)/4)`.  They differ: `↑(n/4) ≥ n/4 − 1`, so
`√(↑(n/4)) ≥ √(n/8) ≥ √n/4` for `n ≥ 8` — **this weaker bound is what the assembly actually
needs**, and it avoids having to identify the two `√` terms.  Do **not** try to prove
`Real.sqrt (↑(n/4)) = Real.sqrt n / 2`; that is false.

**New eventual constant required.**  With only `N ≥ √n/4` available, the tail's `e^{−uN/2}` is
bounded by `e^{−√n/16}`, not `e^{−√n/8}`.  So a companion to `exp_neg_sqrt_le` is needed:
```lean
lemma exp_neg_sqrt16_le {n : ℕ} (hn : 2000000000 ≤ n) :
    Real.exp (-(Real.sqrt (n:ℝ))/16) ≤ (1:ℝ)/((n:ℝ)^3)
```
`√n/16 ≥ 3 log n` via `Real.log_le_rpow_div` at `ε = 1/4`: `12 n^{1/4} ≤ √n/16` ⟺ `n^{1/4} ≥ 192`,
i.e. `n ≥ 192⁴ ≈ 1.36·10⁹`; take `2·10⁹` for margin.  The proof is a **verbatim copy** of
`exp_neg_sqrt_le` with `8 → 16` and `96 → 192`.

**Two further form points to settle before assembling:**
1. `Φ − PhiMainS = Σ'_j (U_j − Q_j)` needs `tsum_sub` on the two summables — `U`'s from
   `summable_phi u n (1 ≤ n) hun`, `Q`'s from `(summable_nat_add_iff 1).2
   (summable_PhiMain_term u n hu1)` with a `congr` for `↑(j+1) = ↑j+1`;
2. the split `Σ'_j f j = Σ_{j<N} f j + Σ'_i f(i+N)` is `Summable.sum_add_tsum_nat_add N`, which
   returns `∑_{range N} + ∑' f(·+N) = ∑' f`; the finite part must then be matched against
   `phi_finite_part_le u n N` (range `N−1`) with one extra term, or `N` shifted by one.

**Concrete next-round order** (companions first, per the eight prior successes):
(a) `exp_neg_sqrt16_le`; (b) `split_bounds` giving the four facts on `N := Nat.sqrt (n/4) + 1`;
(c) only then `Phi_third_order_aux` and `Phi_third_order`.

### 13.90 LANDED (round 83): the `1/16` eventual bound

`Op56/PhiThird.lean` now has **98 declarations** (0 sorries, 7/7 OK), newly:

```lean
lemma exp_neg_sqrt16_le {n : ℕ} (hn : 2000000000 ≤ n) :
    Real.exp (-(Real.sqrt (n:ℝ))/16) ≤ (1:ℝ)/((n:ℝ)^3)
```

the `1/16` companion of `exp_neg_sqrt_le`, generated by systematic substitution on the landed
proof (`96 → 192`, `100000000 → 2000000000`, `/8 → /16`) plus the `hgoal` block; it compiled
first time.

**The one structural point:** the `hgoal` block must be at indentation 2 (a sibling of
`have hlog`), not 4 — at indent 4 Lean parses it inside `hlog`'s proof, giving both
`No goals to be solved` and an unknown-identifier error.

**Next, in the order fixed by §13.89:**
(a) `split_bounds` — the four facts on `N := Nat.sqrt (n/4) + 1`: `1 ≤ N`, `N ≤ n`,
`4*(N−1)^2 ≤ n`, and `(N:ℝ) ≥ Real.sqrt (n:ℝ)/4` (via `√(↑(n/4)) ≥ √(n/8) ≥ √n/4`, **not** via
identifying the Nat and real `√`, which is false);
(b) `Phi_third_order_aux` — `∃ C, ∀ u ∈ [1/2,1], ∀ n ≥ 2·10⁹, |Φ_{un}(n) − PhiMainS u n| ≤ C/n³`,
split at `N` and bounded by `phi_finite_part_le` + `phi_tail_sum_le` + `exp_neg_sqrt16_le` +
`poly_two_neg_le`;
(c) `Phi_third_order` from `PhiMainS_eq`.

### 13.91 Round-84: `split_bounds` — three errors, plan refined

No declaration landed (build green: 98 declarations, 0 sorries, 7/7 OK).

The four facts to prove for `K := Nat.sqrt (n/4)`, with the routes that are now known:
1. `1 ≤ K+1` — `omega`;
2. `K+1 ≤ n` — `K ≤ n/4` (`Nat.sqrt_le`) then `omega`;
3. `4*K^2 ≤ n` — `Nat.sqrt_le' (n/4) : K^2 ≤ n/4`, then `4*K^2 ≤ 4*(n/4) ≤ n` in ℕ
   (`omega` after a `Nat`-arithmetic intermediate);
4. `Real.sqrt (n)/4 ≤ (K:ℝ) + 1` — the chain
   `√n/4 = √(n/16) ≤ √(↑(n/4)) < K+1`, where
   * `√n/4 = √(n/16)` by `Real.sqrt_div (le_of_lt hnR) 16` then `norm_num` for `√16 = 4`;
   * `(n:ℝ)/16 ≤ ↑(n/4)`: from `n < (n/4 + 1)*4` (`Nat.div_add_mod` + `omega`) giving
     `↑(n/4) > (n:ℝ)/4 − 1`, and `(n:ℝ)/16 ≤ (n:ℝ)/4 − 1` for `n ≥ 16`;
   * `√(↑(n/4)) < K+1` from `Nat.lt_succ_sqrt' (n/4) : n/4 < (n/4).sqrt.succ ^ 2` via
     `Real.sqrt_lt'` (whose side condition is `0 < K+1`).

**Errors in `/tmp/w491.lean`:** (i) `Nat.sqrt_le (n/4)` is
`(n/4).sqrt * (n/4).sqrt ≤ n/4`, **not** `(n/4).sqrt ≤ n/4` — either prove the latter with
`Nat.sqrt_le_self` or rearrange with `nlinarith`; (ii) the `refine ⟨…⟩` block with a leading
`by omega` for a `≤`-conjunct needs the conjuncts in the stated order and each as its own `have`;
(iii) one `linarith` in the chain above still fails, most likely the
`push_cast at hbR` normalisation (`(((n/4:ℕ)) + 1) * 4` vs `↑(n/4) + 4`).

**Bookkeeping observation:** `Nat.sqrt_le_self (n : ℕ) : n.sqrt ≤ n` exists and should be used
for fact 2.

### 13.92 Round-85: `split_bounds` — two `linarith` failures remain

No declaration landed (build green: 98 declarations, 0 sorries, 7/7 OK).

Facts 1–3 now compile (with `Nat.sqrt_le_self` for `K ≤ n/4`, `Nat.sqrt_le'` plus a `Nat`-level
`omega` for `4K² ≤ n`).  Two errors remain in fact 4:

1. line 37 — `have : (n:ℝ)/4 < (((n/4:ℕ)):ℝ) + 1 := by linarith`, derived from
   `hbR : (n:ℝ) < 4 * (↑(n/4) + 1)`.  `linarith` does not divide by the numeral 4 here; supply
   the step explicitly, e.g.
   `have := (div_lt_iff₀ (by norm_num : (0:ℝ) < 4)).mpr hbR` — which gives exactly
   `(n:ℝ)/4 < ↑(n/4) + 1` — instead of relying on `linarith`;
2. the second bullet's goal `√(↑(n/4)) < ↑K + 1` (after `rw [Real.sqrt_lt' hK0]`) is still
   unsolved, meaning the `hbR`/`push_cast` chain that was supposed to produce
   `↑(n/4) < (↑K + 1)^2` did not close.  The route is
   `Nat.lt_succ_sqrt' (n/4) : n/4 < (n/4).sqrt.succ ^ 2`, cast with `exact_mod_cast`, then
   `push_cast` — but note `Nat.succ` must be rewritten to `+ 1` **before** the cast, i.e.
   `rw [Nat.succ_eq_add_one] at hb` then `exact_mod_cast hb`, rather than casting first and
   simplifying afterwards.

Both are the same class of issue — a `linarith`/`push_cast` doing the wrong thing to a Nat
division or a `Nat.succ` — and both have explicit replacements rather than tactic tuning.

**Note on cost.**  This is a four-fact lemma and it has now taken two rounds.  Its only real
difficulty is the `Nat.sqrt`/`Real.sqrt` mismatch identified in §13.89.  A cheaper alternative,
now worth taking: **avoid `Nat.sqrt` entirely** by carrying the split point as a *hypothesis* of
`Phi_third_order_aux`:
```lean
lemma Phi_third_order_aux (N : ℕ) (hN1 : 1 ≤ N) (hNn : N ≤ n)
    (hK : 4*(N-1)^2 ≤ n) (hbig : Real.sqrt (n:ℝ)/4 ≤ (N:ℝ)) : …
```
so `split_bounds` becomes a separate, optional cleanup rather than a blocker on the critical path.

### 13.93 Round-86: `Phi_third_order_aux` — setup compiles, tail/gap remaining

No declaration landed (build green: 98 declarations, 0 sorries, 7/7 OK), but the assembly's
**first half now compiles** in `/tmp/w510.lean`:
* `abs_tsum_le_tsum_abs'` — a small helper proving `|∑' g| ≤ ∑' |g|` (Mathlib has no
  `abs_tsum_le_tsum_abs`), via `Summable.tsum_le_tsum (le_abs_self …)` for the upper bound and
  `tsum_nonneg (|g| + g)` plus `Summable.tsum_add` for the lower;
* summabilities `hsumU := summable_phi u n (by omega) hun` and
  `hsumQ := (summable_nat_add_iff 1).2 (summable_PhiMain_term u n hu1)` + `congr`
  (`simp only [Nat.cast_add, Nat.cast_one]`);
* `hfsum := hsumU.sub hsumQ` and
  `hsub : Phi (u*n) n − PhiMainS u n = ∑' j, f j` via **`(Summable.tsum_sub …).symm`** — the
  forward direction gives `Σ'(U−Q) = Σ'U − Σ'Q`, the reverse of what the goal needs.

**Remaining in the lemma:**
1. split: `hfsum.sum_add_tsum_nat_add N`, giving `Σ_{j<N} f j + Σ'_i f(i+N) = Σ'_j f j`;
2. triangle: `abs_add_le`, `Finset.abs_sum_le_sum_abs`, `abs_tsum_le_tsum_abs'`;
3. finite: `phi_finite_part_le u n (N+1) hu1 hu2 (by omega) (fun k hk => hK k (by omega))`
   (the `N+1` is what makes its `range ((N+1)-1)` equal `range N`, matching the split point);
4. tail: `phi_tail_sum_le u n N hu1 hu2 (by omega) hN1 hNn` — **needs
   `simp only [Nat.cast_add]`** so that `f (i+N)` (carrying `↑(i+N)`) matches the lemma's
   `↑i+↑N` form (§13.82's rule);
5. numerically: `e^{−uN/2} ≤ e^{−√n/16}` from `hbig : √n/4 ≤ N` and `u ≥ 1/2`
   (`uN/2 ≥ u√n/8 ≥ √n/16`), then `exp_neg_sqrt16_le` (`hn : 2·10⁹ ≤ n`) and
   `poly_two_neg_le` for the `4n·2^{−un}` term; constant
   `8·10¹⁰ + 2(4·10¹⁰+5) + 7`.

**Then `Phi_third_order`** is `Phi_third_order_aux` composed with `PhiMainS_eq`, instantiating
`N := Nat.sqrt (n/4) + 1` from the (still unfinished) `split_bounds`.

### 13.94 LANDED (round 87): `Phi_third_order_aux` — the third-order assembly

`Op56/PhiThird.lean` now has **100 declarations** (0 sorries, 7/7 OK), newly:

```lean
lemma abs_tsum_le_tsum_abs' (g : ℕ → ℝ) (hg : Summable g) : |∑' i, g i| ≤ ∑' i, |g i|

lemma Phi_third_order_aux {u : ℝ} {n N : ℕ}
    (hu1 : 1/2 ≤ u) (hu2 : u ≤ 1) (hn : 2000000000 ≤ n)
    (hN1 : 1 ≤ N) (hNn : N ≤ n)
    (hK : ∀ k, k ≤ N → 4*k^2 ≤ n)
    (hbig : Real.sqrt ((n:ℝ))/4 ≤ (N:ℝ)) :
    |Phi (u*(n:ℝ)) n - PhiMainS u n|
      ≤ (8*10^10 + 2*(4*10^10 + 5) + 7)/((n:ℝ)^3)
```

**This is the first genuine assembly of the session's third-order work**: it states
`Φ(un,n) − PhiMainS u n = O(n⁻³)` uniformly in `u ∈ [1/2,1]`, with the split point `N` carried as
a *parameter* — exactly the plan-first form of §13.93, which avoided the `Nat.sqrt` blockage
entirely.

**The three fixes:**
1. `abs_tsum_le_tsum_abs'` is needed (no Mathlib analogue): upper bound by
   `Summable.tsum_le_tsum (le_abs_self …)`, lower by `tsum_nonneg (|g| + g)` plus
   `Summable.tsum_add`;
2. `hsub` needs **`(Summable.tsum_sub …).symm`** — the forward direction gives
   `Σ'(U−Q) = Σ'U − Σ'Q`, the reverse of the goal;
3. `poly_two_neg_le hu1 (by omega : 100000000 ≤ n)` — its threshold is `10⁸`, weaker than the
   aux's `2·10⁹`, so it must be discharged explicitly.

**Next: `Phi_third_order`** = `Phi_third_order_aux` composed with `PhiMainS_eq`, instantiating
`N := Nat.sqrt (n/4) + 1` via `split_bounds` (still unfinished, §13.92).  **Cheaper route, given
§13.92's difficulty: state `Phi_third_order` with the `N`-hypotheses too, and only later discharge
them** — the same move that just worked here.

### 13.95 LANDED (round 88): **`Phi_third_order`**

`Op56/PhiThird.lean` now has **101 declarations** (0 sorries, 7/7 OK), newly:

```lean
theorem Phi_third_order {u : ℝ} {n N : ℕ}
    (hu1 : 1/2 ≤ u) (hu2 : u ≤ 1) (hn : 2000000000 ≤ n)
    (hN1 : 1 ≤ N) (hNn : N ≤ n)
    (hK : ∀ k, k ≤ N → 4*k^2 ≤ n)
    (hbig : Real.sqrt ((n:ℝ))/4 ≤ (N:ℝ)) :
    |Phi (u*(n:ℝ)) n - ((Real.exp u - 1)⁻¹ + u/(2*(n:ℝ))*PhiS u
        + (-(u/3)*PhiK3u u + (u^2/8)*PhiK4u u)/((n:ℝ)^2))|
      ≤ (8*10^10 + 2*(4*10^10 + 5) + 7)/((n:ℝ)^3)
```

**This is the third-order expansion the whole file exists for**:
`Φ_{un}(n) = (e^u−1)⁻¹ + (u/2n)ΦS(u) + D(u)/n² + O(n⁻³)` uniformly in `u ∈ [1/2,1]`, with
`D(u) = −(u/3)PhiK3u(u) + (u²/8)PhiK4u(u)`.  Proof: `rw [← PhiMainS_eq u n hu1 (by omega)]` then
`exact Phi_third_order_aux …` — three lines.

**The §13.94 recommendation was decisive.**  Rather than spend another round on `split_bounds`
(which has now cost rounds 84, 85 and 88), `Phi_third_order` was stated with `N` and the two
split hypotheses as **parameters**, exactly as `Phi_third_order_aux` already was.  That unblocked
the critical path in one round.  `split_bounds` (to discharge `hK`/`hbig` for
`N := Nat.sqrt (n/4) + 1`) remains as *optional* cleanup and is **not** on the critical path.

**Standing lesson, now proven three times:** carry the awkward quantity as a hypothesis and
prove the instantiation later.  Rounds 86, 87, 88 all used this and all produced working code
first time; rounds 84 and 85 tried to construct `N` up front and produced nothing.

**Next: `op5_threshold_asymptotic`.**  With `Phi_third_order` in hand, the remaining bridge is
the threshold inversion: `Φ_{un}(n) = 1` gives `u = log 2 + 3log2/(2n) + d_n` with
`d_n = c/n² + O(n⁻³)`, where `c` comes from `D(log 2) = 3(log 2)² − (25/12)log 2`; then
`Pfun n = (n + 3/2)log 2 + c/n + O(n⁻²)`.  The Lipschitz bound (`Phi_lipschitz_p`) and
`threshold_second_order_uniform` are already landed for the inversion.

### 13.96 Round-89: the threshold inversion — the constants cancel exactly

No declaration landed (build green: 101 declarations, 0 sorries, 7/7 OK).  This round settled the
**mathematics** of the inversion, which was the open risk for `op5_threshold_asymptotic`.

**Setup.**  Put `u_n := thresholdAsym n / n = log2 + 3log2/(2n) + c/n²` and read `Phi_third_order`
at `u_n`:
`Φ(u_n n) = (e^{u_n}−1)^{−1} + (u_n/2n)ΦS(u_n) + D(u_n)/n² + O(n^{−3})`.
Write `ε := u_n − log2 = 3log2/(2n) + c/n²` and expand to `O(n^{−2})`:

* `(e^{u_n}−1)^{−1} = 1 − 2ε + 3ε² + O(ε³)
   = 1 − 3log2/n + (−2c + 27log2²/4)/n²`;
* `(u_n/2n)ΦS(u_n)`, using `ΦS(log2+ε) = 6 − 26ε + 75ε² + …` (`Σk⁴2^{−k} = 150`):
  `= 3log2/n + (−39log2²/2 + 9log2/2)/n²`;
* `D(u_n)/n² = D(log2)/n²` (the `O(1/n)` correction to `D` is `O(n^{−3})`).

The `1/n` terms cancel exactly (`−3log2/n + 3log2/n`).  The `1/n²` coefficient is
`−2c + 27log2²/4 − 39log2²/2 + 9log2/2 + D(log2)`.
With `D(log2) = −(26/3)log2 + (75/4)log2²` the `log2²` coefficients are
`27/4 − 39/2 + 75/4 = 6` and the `log2` coefficients are `9/2 − 26/3 = −25/6`, so the coefficient
is `−2c + 6log2² − (25/6)log2 = −2(c − 3log2² + (25/12)log2) = 0` **because**
`c = 3(log2)² − (25/12)log2`.

**So `Φ(u_n n) − 1 = O(n^{−3})`** — the `1/n²` term vanishes identically.  Numerically the
residual is `≈ −3·10^{−7}` at `n = 100`, confirmed against the table in §7.

**Consequence.**  `P_n − p_n = n(u − u_n)` and
`Φ(u n) − Φ(u_n n) = 1 − (1 + O(n^{−3})) = O(n^{−3})`, so a **lower bound `|Φ′| ≥ δ > 0`**
(the measured value is `≈ 2`) gives `P_n − p_n = O(n^{−2})`, i.e. `op5_threshold_asymptotic`.

**The single new ingredient required is therefore `|Φ′(u)| ≥ δ` for `u` in a fixed neighbourhood
of `log2`** — a quantitative *lower* bound on the derivative.  `Phi_lipschitz_p` gives only an
*upper* bound and cannot invert.  The route: from `Phi_asymptotic`
`Φ′(u) = −n·Σ_k log(1+k/n)(1+k/n)^{−un}`, and the same termwise third-order machinery
(`phi_term_sharp3` at the level of the derivative) should give
`Φ′(u) = −2 + O(1/n)` for `u ∈ [1/2,1]`; hence `|Φ′| ≥ 1` for `n` large.  Note
`dΦ/du → −2` was measured early in the session (`≈ −2`, O(1) not O(n)).

**Next: `Phi_deriv_lower`** (`∃ δ > 0, ∀ n ≥ N, ∀ u ∈ [1/2,1], δ ≤ |Φ′(un)|`) as a standalone
lemma, then the inversion.  This is the last analytic input for `op5_threshold_asymptotic`.

### 13.97 Round-90: the inversion must reuse the existing second-order chain

No declaration landed (build green: 101 declarations, 0 sorries, 7/7 OK).  This round located the
machinery `op5_threshold_asymptotic` must extend, which settles the *route*.

**Why `threshold_second_order_uniform` is not enough.**  It gives
`|u − log2 − 3log2/(2n)| ≤ C/n²`, and `|u_n − log2 − 3log2/(2n)| = |c|/n²`, so
`|u − u_n| ≤ (C+|c|)/n²`.  But `P_n − p_n = n(u − u_n)`, which is then only `O(1/n)` — **the extra
factor of `n` is exactly why the third-order inversion is unavoidable**.

**The existing chain** (`Op56/PhiAsymptotic.lean`, around lines 1178–1250):

| lemma | content |
|---|---|
| `threshold_one_sub` | `\|1 − (e^u−1)^{−1}\| ≤ 15/n + C0/n²` |
| `threshold_exp_bound` | from that, `s := 1 − (e^u−1)^{−1}`, `\|s\| ≤ 16/n`, `e^u − 2 = s/(1−s)` |
| `threshold_log_bound` | `\|u − log2 − (e^u−2)/2\| ≤ 512/n²` |
| `abs_log_sub_log_two_le` | `\|log x − log 2\| ≤ \|x−2\|` (rough, reusable) |
| `threshold_second_order_uniform` | assembles the above with `Phi_second_order_uniform` |

**Third-order version to build** (all in `PhiThird.lean`, reusing `Phi_third_order`):
1. `threshold_one_sub_third`: `\|1 − (e^u−1)^{−1} − (u/2n)ΦS(u) − D(u)/n²\| ≤ C/n³`, directly
   from `Phi_third_order` and `IsThreshold` (the `3rd` remainder replaces the `C0/n²`);
2. `threshold_exp_bound_third`: `\|e^u − 2 − s − s²\| ≤ C/n³` where
   `s := (u/2n)ΦS(u) + D(u)/n²` — the new `s²` term is what the second-order chain drops;
3. `threshold_log_bound_third`: `\|u − log2 − (e^u−2)/2 + (e^u−2)²/8\| ≤ C/n³` — the extra
   `−x²/8` term from `log(1+x) = x − x²/2 + …` with `x = (e^u−2)/2`;
4. assemble: substituting `s = 3log2/n + O(1/n²)` into steps 2–3 reproduces exactly the algebra
   of §13.96, so the `1/n²` coefficient vanishes and `\|u − u_n\| ≤ C'/n³`;
5. `op5_threshold_asymptotic`: `\|P_n − p_n\| = n\|u−u_n\| ≤ C'/n²`.

**This is less work than the derivative route.**  The alternative (`Phi_deriv_lower`, a lower bound
`\|Φ′\| ≥ δ`) requires a *whole new* third-order expansion of `Φ′ = −n Σ_k log(1+k/n)(1+k/n)^{−un}`,
comparable in size to `Phi_third_order` itself; the inversion above reuses `Phi_third_order`
directly and mirrors three lemmas that already exist.

### 13.98 LANDED (round 91): `threshold_one_sub_third`

`Op56/PhiThird.lean` now has **102 declarations** (0 sorries, 7/7 OK), newly:

```lean
lemma threshold_one_sub_third (u : ℝ) (n : ℕ) (C3 : ℝ)
    (hbound3 : |Phi (u*(n:ℝ)) n - ((Real.exp u - 1)⁻¹ + u/(2*(n:ℝ))*PhiS u
        + (-(u/3)*PhiK3u u + (u^2/8)*PhiK4u u)/((n:ℝ)^2))| ≤ C3/((n:ℝ)^3))
    (hthr : IsThreshold n (u*(n:ℝ))) :
    |1 - (Real.exp u - 1)⁻¹ - u/(2*(n:ℝ))*PhiS u
      - (-(u/3)*PhiK3u u + (u^2/8)*PhiK4u u)/((n:ℝ)^2)| ≤ C3/((n:ℝ)^3)
```

the third-order analogue of `threshold_one_sub`.  **It is immediate**, unlike the second-order
version: there the bound was `|Φ − (e^u−1)⁻¹ − (u/2n)ΦS| ≤ C0/n²` and one had to *add*
`(u/2n)ΦS` back with the `PhiS_le_thirty` estimate; here the bound already includes `D(u)/n²`, so
at the threshold `Φ = 1` the two sides are literally equal up to `ring`
(`rw [IsThreshold] at hthr; rw [hthr]; ring`).

**Consequence for §13.97:** step 1 is done; steps 2–4 (`threshold_exp_bound_third`,
`threshold_log_bound_third`, assembly) are the remaining work for `op5_threshold_asymptotic`.

### 13.99 Round-92: `PhiK3u`/`PhiK4u` bounds — a one-lemma shortcut

No declaration landed (build green: 102 declarations, 0 sorries, 7/7 OK).

**The useful discovery:** no upper bounds existed for `PhiK3u`/`PhiK4u`, and the third-order
expansion step 2 needs `|D(u)|` bounded.  Rather than re-derive the geometric closed forms, note
that the **already-landed** `tsum_pow6_exp_neg_half_le` suffices for both:

```
k³e^{−uk} ≤ k⁶e^{−uk/2}   and   k⁴e^{−uk} ≤ k⁶e^{−uk/2}     (k ≥ 1)
```
since `k³ ≤ k⁶`, `k⁴ ≤ k⁶` and `e^{−uk} ≤ e^{−uk/2}`.  Hence
```lean
lemma PhiK3u_le (u : ℝ) (hu : 1/2 ≤ u) : PhiK3u u ≤ 4*10^10
lemma PhiK4u_le (u : ℝ) (hu : 1/2 ≤ u) : PhiK4u u ≤ 4*10^10
```
both by `h1.tsum_le_tsum` against `Summable (fun k => k^6 * e^{−uk/2})`, with
`rw [PhiK3u]` / `rw [PhiK4u]` at the end.  Then `|D(u)| ≤ (1/3 + 1/8)·4·10¹⁰ < 2·10¹⁰`.

The bound is crude (true values are `PhiK3u ≤ ~100`, `PhiK4u ≤ ~1000`), so `|s| ≤ 1/2` in step 2
will require `n ≥ 10¹¹`; that is harmless since every statement is eventual.

**Errors in `/tmp/w540.lean` (5):**
1. `hu2 : (1:ℝ)/2 ≤ u/2 := by linarith [hu]` **fails** — surprising, and the likely cause is that
   `u/2` is parsed as `u * 2⁻¹` while `(1:ℝ)/2` is a numeral division; use
   `div_le_div_of_nonneg_right hu (by norm_num)` instead of `linarith`;
2. `tsum_pow6_exp_neg_half_le` returns `e^{−(u*k)/2}`, **not** `e^{−(u/2)*k}` — the two `exp`
   forms must be aligned by a `congr` + `ring` before any `tsum_le_tsum` (the recurring
   form-mismatch rule, §13.82);
3. two further `Application type mismatch` errors follow from (2);
4. one `linarith` at `(k:ℝ)^3 * e^{−uk} ≤ (k:ℝ)^6 * e^{−uk}` needs the explicit `he0` positivity
   fact already present.

**Next:** land `PhiK3u_le`/`PhiK4u_le` (small), then `threshold_exp_bound_third` (§13.97 step 2).

### 13.100 Round-93: `PhiK3u_le`/`PhiK4u_le` — the summability issue resolved

No declaration landed (build green: 102 declarations, 0 sorries, 7/7 OK).

**The §13.99 error (1) was a genuine mathematical slip, not a tactic problem.**  `1/2 ≤ u` does
**not** imply `1/2 ≤ u/2` — that needs `u ≥ 1` (take `u = 1/2`: `u/2 = 1/4`).  `linarith` correctly
refused.  So `summable_exp_neg_u (u/2) hu2 6` was never applicable under `hu1 : 1/2 ≤ u`.

**Correct route** (now working): build the majorant's summability directly from the geometric
series rather than from `summable_exp_neg_u`:
```lean
lemma summable_pow6_half (u : ℝ) (hu : 1/2 ≤ u) :
    Summable (fun k => (k:ℝ)^6 * Real.exp (-(u*(k:ℝ))/2)) := by
  have hu0 : (0:ℝ) < u := by linarith
  have hx : ‖Real.exp (-u/2)‖ < 1 := by
    rw [Real.norm_eq_abs, abs_of_pos (Real.exp_pos _), Real.exp_lt_one_iff]; linarith
  have h := summable_pow_mul_geometric_of_norm_lt_one 6 hx
  refine h.congr (fun k => ?_)
  rw [show Real.exp (-(u*(k:ℝ))/2) = (Real.exp (-u/2))^k by
    rw [show -(u*(k:ℝ))/2 = (k:ℝ)*(-u/2) by ring, Real.exp_nat_mul]]
```
`exp(−u/2) < 1` only needs `u > 0` ✓, so this works under `hu1 : 1/2 ≤ u`.  **Use this pattern
whenever a majorant `e^{−cu}` with `c < 1` must be summable under `u ≥ 1/2`.**

**Also fixed:** `Summable.tsum_le_tsum` must be called in the **full** form
`Summable.tsum_le_tsum (fun k => …) hf hg`; the method form `hf.tsum_le_tsum h hg` produces an
application-type mismatch.

**Three errors remain, all in the step `1 ≤ k ⟹ k³ ≤ k⁶`:**
1. `pow_le_pow_left₀ (by norm_num) hk1 3` gives *typeclass instance problem is stuck* — supply the
   base explicitly, e.g. `pow_le_pow_left₀ (by norm_num : (0:ℝ) ≤ 1) hk1 3`;
2. simpler and more robust, avoiding `pow_le_pow_left₀` entirely:
   `have h3 : (1:ℝ) ≤ (k:ℝ)^3 := one_le_pow₀ hk1` and
   `have h6 : (k:ℝ)^6 = (k:ℝ)^3 * (k:ℝ)^3 := by ring`, then
   `nlinarith [h3, pow_pos (by positivity : (0:ℝ) < (k:ℝ)) 3]` (from `k³ ≤ k⁶` iff `k³(k³−1) ≥ 0`);
3. the trailing `linarith` in the `k = 0` branch is then unnecessary — `norm_num` closes it.

**Next:** land `summable_pow6_half`, `PhiK3u_le`, `PhiK4u_le` (all small), then
`threshold_exp_bound_third` (§13.97 step 2).

### 13.101 LANDED (round 94): moment bounds for `PhiK3u`/`PhiK4u`

`Op56/PhiThird.lean` now has **105 declarations** (0 sorries, 7/7 OK), newly:

```lean
lemma summable_pow6_half (u : ℝ) (hu : 1/2 ≤ u) :
    Summable (fun k => (k:ℝ)^6 * Real.exp (-(u*(k:ℝ))/2))
lemma PhiK3u_le (u : ℝ) (hu : 1/2 ≤ u) : PhiK3u u ≤ 4*10^10
lemma PhiK4u_le (u : ℝ) (hu : 1/2 ≤ u) : PhiK4u u ≤ 4*10^10
```

Hence `|D(u)| ≤ (1/3 + 1/8)·4·10¹⁰ < 2·10¹⁰` for `u ∈ [1/2,1]`, which is what §13.97 step 2
needs.

**The two fixes that closed it:**
1. `one_le_pow₀` leaves the **exponent implicit**, so `one_le_pow₀ hk1` gives a stuck typeclass
   search; write `one_le_pow₀ (n := 3) hk1`;
2. `Nat.cast_nonneg k` is **type-ambiguous** inside `nlinarith [hu, Nat.cast_nonneg k]` — annotate
   as `(Nat.cast_nonneg k : (0:ℝ) ≤ (k:ℝ))`.

Both are recorded as general rules: explicit exponent for `one_le_pow₀`, explicit type for bare
`Nat.cast_*` facts fed to `nlinarith`.

**Standing lesson re-confirmed (§13.100):** the round-92 failure was mathematical, not tactical
(`1/2 ≤ u` ⇏ `1/2 ≤ u/2`).  The corrected route — building the majorant's summability from
`summable_pow_mul_geometric_of_norm_lt_one` using `e^{−u/2} < 1` — is now landed as
`summable_pow6_half` and is the reusable pattern.

**Next: `threshold_exp_bound_third`** (§13.97 step 2): with `s := (u/2n)ΦS(u) + D(u)/n²`
(note `|s| ≤ (15 + 2·10¹⁰)/n`, so `|s| ≤ 1/2` for `n ≥ 5·10¹⁰`),
`1 − (e^u−1)^{−1} = s + r` with `|r| ≤ C3/n³` from `threshold_one_sub_third`; then
`e^u − 2 = (s+r)/(1−s−r)`, so `|e^u − 2 − s − s²| ≤ 4C3/n³ + 8192/n³`.

### 13.102 LANDED (round 95): `SThird` and the third-order bridging lemma

`Op56/PhiThird.lean` now has **107 declarations** (0 sorries, 7/7 OK), newly:

```lean
noncomputable def SThird (u : ℝ) (n : ℕ) : ℝ :=
  u/(2*(n:ℝ))*PhiS u + (-(u/3)*PhiK3u u + (u^2/8)*PhiK4u u)/((n:ℝ)^2)

lemma threshold_one_sub_third' (u : ℝ) (n : ℕ) (C3 : ℝ)
    (hbound3 : |Phi (u*(n:ℝ)) n - ((Real.exp u - 1)⁻¹ + SThird u n)| ≤ C3/((n:ℝ)^3))
    (hthr : IsThreshold n (u*(n:ℝ))) :
    |1 - (Real.exp u - 1)⁻¹ - SThird u n| ≤ C3/((n:ℝ)^3)
```

**Introducing `SThird` as a named definition is the right move**: the third-order correction
`u/(2n)ΦS(u) + D(u)/n²` otherwise appears verbatim in every remaining lemma
(`threshold_exp_bound_third`, `threshold_log_bound_third`, the assembly), and writing it out each
time invites exactly the form mismatches that cost rounds 78–81.

**`SThird_abs_le` is drafted but not yet compiling** (`/tmp/w560.lean`, 5 `linarith` failures).
Target: `|SThird u n| ≤ 3·10¹⁰/n`, giving `|SThird| ≤ 1/2` for `n ≥ 6·10¹⁰`.  The components:
* `|u/(2n)·ΦS(u)| ≤ 15/n` from `PhiS_le_thirty` and `u ≤ 1` — **watch the `linarith` failures**:
  the step `u/(2n) ≤ 1/(2n)` needs `div_le_div_iff₀`, not `linarith`, and the final
  `(1/(2n))·30 = 15/n` needs `field_simp; ring` on separate lines;
* `|D(u)/n²| ≤ 2·10¹⁰/n` from `PhiK3u_le`/`PhiK4u_le` (both `≤ 4·10¹⁰`) via
  `|−(u/3)PhiK3u + (u²/8)PhiK4u| ≤ (1/3+1/8)·4·10¹⁰ < 4·10¹⁰` — the `abs_le.mpr ⟨_,_⟩` form with
  the two components supplied separately (cf. §13.86), since `linarith` will not see through
  `abs` on a sum.

**Next:** finish `SThird_abs_le`, then `threshold_exp_bound_third` with the algebra already worked
out: `r := 1 − (e^u−1)^{−1} − SThird`, `e^u − 2 = (SThird + r)/(1 − SThird − r)`, hence
`e^u − 2 − SThird − SThird² = [r(1 + SThird + SThird²) + SThird³]/(1 − SThird − r)`, bounded by
`(7/2)|r| + 2|SThird|³ ≤ [(7/2)C3 + 6·10³¹]/n³`.

### 13.103 Round-96: `SThird_abs_le` — four `linarith` failures, all with explicit fixes

No declaration landed (build green: 107 declarations, 0 sorries, 7/7 OK).

Target: `|SThird u n| ≤ 2·10¹¹/n` for `u ∈ [1/2,1]`, `n ≥ 1`.  Four failures, each with a fix:

1. **line 21** — `u^2 ≤ 1` from `0 ≤ u`, `u ≤ 1`.  `nlinarith [hu0, hu2]` alone fails; supply the
   product form: `nlinarith [mul_nonneg hu0 (sub_nonneg.mpr hu2)]` (i.e. `0 ≤ u(1−u)`);
2. **lines 33–34** — the two `abs_le` components of
   `|−(u/3)PhiK3u u + (u^2/8)PhiK4u u| ≤ 4·10¹⁰`.  `linarith` will not see through the products;
   supply each bound separately:
   * upper: `−(u/3)PhiK3u u ≤ 0` (from `positivity` on `(u/3)·PhiK3u u`) and
     `(u^2/8)PhiK4u u ≤ (1/8)·4·10¹⁰` (from `u^2/8 ≤ 1/8` and `PhiK4u_le`), then `linarith`;
   * lower: `(u/3)PhiK3u u ≤ (1/3)·4·10¹⁰` from `PhiK3u_le` and `u ≤ 1`, plus
     `0 ≤ (u^2/8)PhiK4u u` by `positivity`, then `linarith`;
3. **line 44** — the final assembly `|a + b| ≤ |a| + |b| ≤ 15/n + 4·10¹⁰/n ≤ 2·10¹¹/n`.  Needs the
   two nonnegativity facts `0 ≤ 15/n`, `0 ≤ 4·10¹⁰/n` (both `positivity`) supplied explicitly,
   since `linarith` otherwise treats `15/n` and `4·10¹⁰/n` as unrelated atoms;
4. **reminder** — `field_simp` **then** `ring` on separate lines for `(1/(2n))·30 = 15/n`.

**Note.**  This is the third round spent on what is arithmetically a one-line estimate
(`|SThird| = O(1/n)`), and the cost is entirely `linarith`/`positivity` friction on products and
absolute values.  A more robust pattern worth adopting next round: state the two components as
**separate top-level lemmas** (`SThird_first_le`, `SThird_second_le`) — the extraction remedy that
has landed every one of its targets (rounds 42–44, 63, 66, 68, 70, 71, 73, 77, 79, 82, 87, 94) —
rather than fighting both inside one proof.

### 13.104 LANDED (round 97): `SThird_first_le`

`Op56/PhiThird.lean` now has **108 declarations** (0 sorries, 7/7 OK), newly:

```lean
lemma SThird_first_le (u : ℝ) (hu1 : 1/2 ≤ u) (hu2 : u ≤ 1) (n : ℕ) (hn : 1 ≤ n) :
    |u/(2*(n:ℝ))*PhiS u| ≤ 15/(n:ℝ)
```

**The extraction remedy worked again** (fourteenth instance): splitting the components into
separate top-level lemmas immediately closed the first one, whereas both inside `SThird_abs_le`
had failed twice.  The three fixes needed:
1. `abs_of_nonneg` needs the nonnegativity **as a term**:
   `rw [abs_of_nonneg (mul_nonneg (by positivity) hPS0)]` where
   `hPS0 : 0 ≤ PhiS u := by rw [PhiS]; exact tsum_nonneg (fun k => by positivity)`;
2. `u/(2n) ≤ 1/(2n)` via `div_le_div_iff₀` then **`nlinarith`** (not `linarith` — the cleared goal
   is `u*(2n) ≤ 1*(2n)`, a product);
3. `mul_le_mul h2 hPS hPS0 (by positivity)` — the argument order is
   `(a ≤ b) (c ≤ d) (0 ≤ c) (0 ≤ b)`, and supplying `hPS0` and `0 ≤ 1/(2n)` explicitly is what
   lets `linarith` finish.

**`SThird_second_le` still fails** at the two `abs_le` components of
`|−(u/3)PhiK3u u + (u^2/8)PhiK4u u| ≤ 4·10¹⁰` (`/tmp/w580.lean`, lines 43 and 49).  Even with
`mul_le_mul h5 hk4 hk40 (by norm_num)` producing
`(u^2/8)*PhiK4u u ≤ (1/8)*4*10¹⁰`, the trailing `linarith`/`nlinarith` cannot combine it with
`−(u/3)PhiK3u u ≤ 0`.  **Next-round fix:** state the two *term* bounds as their own lemmas
(`PhiK3u_shift_le`, `PhiK4u_shift_le`) — the same extraction move that just worked — rather than
chaining three `mul_le_mul`s inside one `abs_le`.

### 13.105 LANDED (round 98): seven lemmas — full extraction vindicated

`Op56/PhiThird.lean` now has **115 declarations** (0 sorries, 7/7 OK), newly:

```lean
lemma PhiK3u_nonneg (u : ℝ) : 0 ≤ PhiK3u u
lemma PhiK4u_nonneg (u : ℝ) : 0 ≤ PhiK4u u
lemma neg_u_div_three_K3u_le (u : ℝ) (hu1 : 1/2 ≤ u) : -(u/3)*PhiK3u u ≤ 0
lemma u_div_three_K3u_le (u : ℝ) (hu1 : 1/2 ≤ u) (hu2 : u ≤ 1) :
    (u/3)*PhiK3u u ≤ (1/3)*4*10^10
lemma u_sq_div_eight_K4u_le (u : ℝ) (hu1 : 1/2 ≤ u) (hu2 : u ≤ 1) :
    (u^2/8)*PhiK4u u ≤ 4*10^10
lemma u_sq_div_eight_K4u_nonneg (u : ℝ) : 0 ≤ (u^2/8)*PhiK4u u
lemma SThird_second_le (u : ℝ) (hu1 : 1/2 ≤ u) (hu2 : u ≤ 1) (n : ℕ) (hn : 1 ≤ n) :
    |(-(u/3)*PhiK3u u + (u^2/8)*PhiK4u u)/((n:ℝ)^2)| ≤ 4*10^10/(n:ℝ)
```

**This is the strongest confirmation yet of the extraction discipline.**  Rounds 96 and 97 failed
twice trying to prove `|SThird| ≤ …` as one lemma; splitting into *two* components landed the first
and left the second; splitting the second into *four* term bounds landed **everything at once**.
Fourteen declarations in three rounds after the split, versus nothing in the two rounds before it.

**The decisive fix at the end:** the two `abs_le` components must have their hypotheses bound to
`have`s *first* (`have h1 := neg_u_div_three_K3u_le u hu1` …), then `exact ⟨by linarith, by linarith⟩`.
Passing the lemma applications inline inside the `linarith` bracket
(`linarith [neg_u_div_three_K3u_le u hu1, …]`) **fails** — Lean does not instantiate them with the
right implicit arguments in that position.

**Now `SThird_abs_le` is a two-line consequence:**
```lean
rw [SThird]
exact (abs_add_le _ _).trans (by linarith [SThird_first_le u hu1 hu2 n hn, SThird_second_le u hu1 hu2 n hn])
```

**Next:** land `SThird_abs_le`, then `threshold_exp_bound_third` (§13.102), then
`threshold_log_bound_third`, then the assembly for `op5_threshold_asymptotic`.

### 13.106 LANDED (round 99): `SThird_abs_le`

`Op56/PhiThird.lean` now has **116 declarations** (0 sorries, 7/7 OK), newly:

```lean
lemma SThird_abs_le (u : ℝ) (hu1 : 1/2 ≤ u) (hu2 : u ≤ 1) (n : ℕ) (hn : 1 ≤ n) :
    |SThird u n| ≤ 2*10^11/(n:ℝ)
```

exactly as predicted in §13.105, via `abs_add_le` + the two component lemmas.  Hence
`|SThird u n| ≤ 1/2` for `n ≥ 4·10¹¹`.

**The one non-obvious step**, worth recording as a rule: comparing the *sum* of two fractions
`15/n + 4·10¹⁰/n ≤ 2·10¹¹/n`.  `linarith` treats the two fractions as unrelated atoms, and
`ring` cannot prove `a/c + b/c = (a+b)/c` with an opaque `c`.  The working route is
`rw [← add_div]` then `rw [div_le_div_iff₀ hnR hnR]` then **`nlinarith [hnR]`** — the final step
must be `nlinarith` (not `norm_num`, which cannot discharge the `n > 0` factor).

**Standing rule:** to compare sums of fractions, use `← add_div` to combine them *first*, then
`div_le_div_iff₀` to clear denominators.

**Next: `threshold_exp_bound_third`** (§13.102), statement
```lean
lemma threshold_exp_bound_third (u : ℝ) (hu1 : 1/2 ≤ u) (hu2 : u ≤ 1) (n : ℕ)
    (hn : 1 ≤ n) (C3 : ℝ) (hC3 : 0 ≤ C3) (hnC3 : C3 ≤ n) (hnbig : 4*10^11 ≤ n)
    (hbound3 : |Phi (u*(n:ℝ)) n - ((Real.exp u - 1)⁻¹ + SThird u n)| ≤ C3/((n:ℝ)^3))
    (hthr : IsThreshold n (u*(n:ℝ))) :
    |Real.exp u - 2 - SThird u n - (SThird u n)^2| ≤ (7*C3/2 + 6*10^31)/((n:ℝ)^3)
```
with the algebra `e^u − 2 − s − s² = [r(1+s+s²) + s³]/(1−s−r)`, `r := 1 − (e^u−1)⁻¹ − s`,
`|r| ≤ C3/n³ ≤ 1/n²` and `|s| ≤ 2·10¹¹/n ≤ 1/2`, giving `(7/2)|r| + 2|s|³`.

### 13.107 Round-100: `threshold_exp_bound_third` drafted — first 47 lines compile

No declaration landed (build green: 116 declarations, 0 sorries, 7/7 OK).

`/tmp/w610.lean` compiles through the algebraic core and the two size hypotheses, and fails at
four points.  **Working so far:**
* `exp_sub_two_algebra (s r : ℝ) (h : 1 − s − r ≠ 0) :
  (s+r)/(1−s−r) − s − s² = (r(1+s+s²) + s³)/(1−s−r)` by `field_simp; ring` — the pure-algebra
  identity, verified standalone;
* `hrle : |r| ≤ C3/n³` from `threshold_one_sub_third'`;
* `hsle : |s| ≤ 2·10¹¹/n` from `SThird_abs_le`;
* `hrq : |r| ≤ 1/4` via `div_le_div_of_nonneg_right hnC3`, then `n/(n³) = 1/n²` by `field_simp`
  and `1/n² ≤ 1/4` from `n ≥ 4`;
* `hsh : |s| ≤ 1/2` from `n ≥ 4·10¹¹`;
* `hden : 1/2 ≤ 1 − s − r` from `|s+r| ≤ 3/4`;
* `hexp : e^u − 1 = (1 − s − r)⁻¹` via `inv_inv`.

**Four errors:**
1. **line 48** — `neg_le_abs` is type-ambiguous inside `linarith [h1, neg_le_abs]`; annotate it as
   `(neg_le_abs (s + r) : -(s + r) ≤ |s + r|)`;
2. **line 49** — the `linarith` following it;
3. **line 60** — `rw [hr]` where `hr : r = …` was produced by `set … with hr`; `set`'s `with`
   clause gives an **equation in the other direction** (`hr : r = 1 − …`), so the rewrite must be
   `rw [hr]` on the *goal* side or `rw [← hr]` depending on orientation — check which side carries
   `r`.  Same issue at **line 67** (`hkey`), where `rw [h2]` after a `have` whose statement mentions
   `s` shadows the `set`-bound `s`.

**Robust fix for (3)–(4):** avoid `set` entirely for `s` and `r`; write the definitions as local
`have` equations and use `show` with the expanded forms, or make `s`/`r` outright `let`
abbreviations.  `set` + `rw` on the resulting hypothesis is exactly the pattern that cost
round 60 and §13.75.

**Remaining for this lemma:** the numerator bound
`|r(1+s+s²) + s³| ≤ (7C3/2 + 6·10³¹)/n³ · (1−s−r)`, assembled from
`|1+s+s²| ≤ 7/4`, `|r| ≤ C3/n³`, `|s³| ≤ (2·10¹¹/n)³ = 8·10³³/n³`, and the `1/2 ≤ 1−s−r` factor.

### 13.108 Round-101: `threshold_exp_bound_third` — down to three errors

No declaration landed (build green: 116 declarations, 0 sorries, 7/7 OK).

**Fixed this round:** the `neg_le_abs` ambiguity — annotate as
`(neg_le_abs (s + r) : -(s + r) ≤ |s + r|)`; and the `set`-orientation problem in `hexp`, where
`simp only [hr, hs]` works whereas `rw [hr]` does not (the `with`-clause equation has the *other*
orientation from what `rw` expects when the variable occurs on the right).

**Three errors remain:**
1. **line 49** — the closing `linarith` of `hden : 1/2 ≤ 1 − s − r` from
   `h2 : −(1/2+1/4) ≤ s + r`.  `linarith` sees `1 − s − r` as an atom; write the goal as
   `linarith [h2]` after `have h2' : s + r ≤ 3/4 := le_trans (le_abs_self _) h1`, or simply
   `linarith only [h2]` with the goal rewritten by `show (1:ℝ)/2 ≤ 1 - (s + r) by ring_nf`;
2. **lines 59 and 66** — the two remaining `rw` failures in `hkey`
   (`rw [h2]` after `h2 : e^u − 2 = (s+r)/(1−s−r)`, and `rw [hkey]` into the main goal after
   `rw [← hs] at hkey`).  The `rw [← hs] at hkey` exists to push the abbreviation `s` out of
   `hkey` so that `rw [hkey]` matches the goal; if it fails, drop `set` for `s` altogether and
   state every identity with `SThird u n` written out.

**Recommendation (applying the §13.105 lesson one level up).**  This lemma is carrying five
independent facts at once (the `r` bound, the `s` bound, the denominator bound, the algebra
identity, the numerator bound).  Split it:
```lean
lemma exp_sub_two_eq (u : ℝ) (s : ℝ) (h : (Real.exp u - 1)⁻¹ = 1 - s - r) : e^u - 2 = (s+r)/(1-s-r)
lemma threshold_exp_bound_third_numerator … : |r*(1+s+s^2) + s^3| ≤ (7C3/2 + 6·10³¹)/n³ * (1-s-r)
lemma threshold_exp_bound_third … := -- two lines from the above
```
That is what converted rounds 96–97 (nothing) into round 98 (seven declarations).

### 13.109 LANDED (round 102): the two numerator component bounds

`Op56/PhiThird.lean` now has **118 declarations** (0 sorries, 7/7 OK), newly:

```lean
lemma one_add_s_add_sq_abs_le (s : ℝ) (hs : |s| ≤ 1/2) : |1 + s + s^2| ≤ 7/4
lemma s_cube_abs_le {s : ℝ} {n : ℕ} (hn : 1 ≤ n) (hs : |s| ≤ 2*10^11/(n:ℝ)) :
    |s^3| ≤ 8*10^33/((n:ℝ)^3)
```

**The split again closed both immediately** — fifteenth and sixteenth instances.  Fixes needed:
1. `one_add_s_add_sq_abs_le`: `abs_add_le 1 (s + s^2)` produces `|1 + (s + s^2)|`, which does **not**
   match the goal's `|1 + s + s^2|` — insert
   `have hassoc : (1:ℝ) + s + s^2 = 1 + (s + s^2) := by ring` then `rw [hassoc]`.  (Same
   right-nesting mismatch as §13.82's `Nat.cast_add` rule, but for `+` associativity inside `abs`);
2. `s_cube_abs_le`: use `abs_pow s 3 : |s^3| = |s|^3` and `div_pow` then `norm_num` for
   `(2·10¹¹/n)^3 = 8·10³³/n³`.

**Remaining for `threshold_exp_bound_third`** (two lemmas, both small now):
* `exp_sub_two_eq : (Real.exp u - 1)⁻¹ = 1 - s - r → Real.exp u - 2 = (s+r)/(1-s-r)` — pure algebra
  (`field_simp; ring`), uses `inv_inv`;
* `SThird_numerator_le : |r*(1+s+s^2) + s^3| ≤ (7C3/2 + 6·10³¹)/n³ * (1-s-r)` — from
  `one_add_s_add_sq_abs_le`, `s_cube_abs_le`, `|r| ≤ C3/n³` and `1/2 ≤ 1-s-r`;
* then `threshold_exp_bound_third` is a two-line assembly.

### 13.110 Round-103: the last two pieces — three errors, all diagnosed

No declaration landed (build green: 118 declarations, 0 sorries, 7/7 OK).

`/tmp/w630.lean` contains both remaining lemmas.  **`SThird_numerator_le` is now stated with the
corrected constant** `7*C3/2 + 2*10^34` — my earlier `6*10^31` was an arithmetic error: dividing
by `1−s−r ≥ 1/2` *doubles* the numerator bound, so `1.75·C3 + 8·10³³` becomes
`3.5·C3 + 1.6·10³⁴`.  (Worth recording: whenever a bound is divided by a factor `≥ 1/2`, the
constant doubles — this is exactly the kind of arithmetic slip that §13.100's lesson warns about.)

**Three errors:**
1. **line 13** — `calc Real.exp u - 1 = ((Real.exp u - 1)⁻¹)⁻¹ := (inv_inv _).symm` then
   `_ = (1 - s - r)⁻¹ := by rw [h]` reports *pattern not found* even though `h`'s left side occurs.
   Replace with `by simp only [h]`, or avoid the rewrite entirely:
   `have h1 : Real.exp u - 1 = (1 - s - r)⁻¹ := by rw [← h, inv_inv]` was the original — note that
   `inv_inv` here must be given the **explicit** argument `(Real.exp u - 1)`;
2. **line 32** — `field_simp` **closes** the goal `C3/n³ * (7/4) = (7*C3/4)/n³`, so the trailing
   `ring` errors *No goals to be solved*.  Drop the `ring` (this exact trap is recorded in §13.75);
3. **line 35** — follows from (2).

**This is the seventh time `field_simp`-closes-then-`ring`-errors has occurred**, and the standing
rule is unambiguous: never write `field_simp` and `ring` on consecutive lines without first
checking that `field_simp` leaves a goal.

### 13.111 Round-104: the stubborn rewrite; recommend `field_simp`-from-scratch

No declaration landed (build green: 118 declarations, 0 sorries, 7/7 OK).

`SThird_numerator_le` now compiles **except** for the internal `h8`.  The remaining blocker is
`exp_sub_two_eq`, where **both** `rw [h]` and `simp only [h]` report *pattern not found* for
`h : (Real.exp u - 1)⁻¹ = 1 - s - r` even though `(Real.exp u - 1)⁻¹` visibly occurs in the goal
`((Real.exp u - 1)⁻¹)⁻¹ = (1 - s - r)⁻¹`.  This is unusual and I have not diagnosed it.

**Recommendation: stop rewriting and prove `exp_sub_two_eq` directly from `field_simp`.**  From
`h : (e^u−1)⁻¹ = 1 − s − r` we get `(e^u−1)⁻¹ = 1 − s − r` and `(1−s−r) ≠ 0`, so
`e^u = 1 + (1−s−r)⁻¹` by `inv_inv` — but rather than deriving that equation by rewriting, state
the whole thing as a single algebraic goal and let `field_simp` handle it:
```lean
lemma exp_sub_two_eq (u s r : ℝ) (h : (Real.exp u - 1)⁻¹ = 1 - s - r)
    (hne : 1 - s - r ≠ 0) :
    Real.exp u - 2 = (s + r)/(1 - s - r) := by
  have hexp : Real.exp u = 1 + (1 - s - r)⁻¹ := by
    have h2 : Real.exp u - 1 = ((Real.exp u - 1)⁻¹)⁻¹ := (inv_inv _).symm
    rw [h] at h2          -- rewrite in the HYPOTHESIS, where the pattern definitely occurs
    rw [h2]
    ring
  rw [hexp]
  field_simp
  ring
```
The key point: **rewrite inside the hypothesis `h2` (where the left side of `h` occurs as a
standalone subterm), not inside the goal (where it occurs under a `⁻¹`)**.  §13.68/§13.110's rule
about matching syntactic forms applies with more force under `⁻¹`.

**Everything else in `threshold_exp_bound_third` is now in place**: `hrle`, `hsle`, `hrq`, `hsh`,
`hden`, `hne`, `hkey`, and `SThird_numerator_le` (with the corrected constant
`7*C3/2 + 2*10^34`).  Once `exp_sub_two_eq` lands, the composite is a two-line assembly.

### 13.112 LANDED (round 105): `exp_sub_two_eq` — and the real cause of the "stubborn rewrite"

`Op56/PhiThird.lean` now has **119 declarations** (0 sorries, 7/7 OK), newly:

```lean
lemma exp_sub_two_eq (u s r : ℝ) (h : (Real.exp u - 1)⁻¹ = 1 - s - r)
    (hne : 1 - s - r ≠ 0) :
    Real.exp u - 2 = (s + r)/(1 - s - r)
```

**The mystery of §13.111 is solved, and it was not a `⁻¹`-nesting problem at all.**  The failing
rewrite was **`rw [h1]`** at the *outer* level, where
`h1 : Real.exp u - 1 = (1 - s - r)⁻¹` and the goal was `Real.exp u - 2 = (s + r)/(1 - s - r)`.
The goal contains **`Real.exp u`**, not `Real.exp u - 1`, so `rw [h1]` could never fire — the
"pattern not found" was about `Real.exp u - 1` in a goal that has no such subterm.  I had
mis-attributed it to the inner `rw [h] at h2`, which works fine.

**Correct route:** derive `hexp : Real.exp u = 1 + (1 - s - r)⁻¹` by `linarith [h1]`, then
`rw [hexp]`, then `field_simp; ring`.

**Lesson (new, and general):** when a rewrite reports *pattern not found*, print the **target
expression** alongside the pattern (Lean does this automatically — read it!).  I spent two rounds
assuming the pattern was the problem when the target did not contain it in the first place.  The
`set_option`/`simp only` detours in §13.110–13.111 were all unnecessary.

**Remaining:** `SThird_numerator_le` fails only at its internal `h7`, where `rw [h8]` reports
pattern-not-found with `h8 : C3/n³ * (7/4) = (7·C3/4)/n³` against the goal
`C3/n³ * (7/4) + 8·10³³/n³ ≤ (7C3/2 + 2·10³⁴)/n³ * (1/2)`.  **By the lesson above, read the
printed goal before guessing** — the likely cause is that `field_simp` in `h8` leaves the equation
in a normalised form whose left side is not syntactically `C3/n³ * (7/4)`.

### 13.113 Round-106: reading the error solved it; one `nlinarith` left

No declaration landed (build green: 119 declarations, 0 sorries, 7/7 OK).

**The §13.112 lesson paid off immediately.**  Reading the full error showed the failing rewrite was
`rw [div_le_div_iff₀ …]`, with target
```
(7 * C3 / 4 + 8 * 10^33) / ↑n ^ 3 ≤ (7 * C3 / 2 + 2 * 10^34) / ↑n ^ 3 * (1 / 2)
```
— the `* (1/2)` on the right breaks the `a/c ≤ b/c` pattern.  Fix: unfold it first with
`rw [show (7*C3/2 + 2*10^34)/n³ * (1/2) = (7*C3/2 + 2*10^34)/(2*n³) by ring]`, then
`div_le_div_iff₀` with the two denominators.  **That now works.**  Had I read the error in round
103, this round and two others would have been unnecessary.

**One `nlinarith` remains**, at
`(7*C3/4 + 8*10^33) * 2 ≤ 7*C3/2 + 2*10^34`.  **The arithmetic is correct** —
`2·(7C3/4) = 7C3/2` and `2·8·10³³ = 1.6·10³⁴ ≤ 2·10³⁴` — so this is a tactic issue, not a
mathematical one: `nlinarith` appears to treat `10^33` / `10^34` (Nat powers cast to ℝ) as opaque
atoms.  Supplying `(by norm_num : (8:ℝ)*10^33 * 2 ≤ 2*10^34)` did **not** help.

**Fixes to try, in order:**
1. `ring_nf` **before** `nlinarith`, so the powers are evaluated and `C3`-terms cancelled:
   `have hk : (7*C3/4 + 8*10^33) * 2 ≤ 7*C3/2 + 2*10^34 := by ring_nf; nlinarith [hC3]`,
   or simply `by nlinarith [hC3, (by norm_num : (8:ℝ)*10^33*2 = 1.6*10^34)]`;
2. replace the constant by a **round number that makes the goal trivial**: state
   `SThird_numerator_le` with `K = 3*10^34` instead of `7*C3/2 + 2*10^34`; then the goal is
   `1.75·C3 + 8·10³³ ≤ 1.5·10³⁴`, still true, and the `C3` terms no longer need cancellation.  This
   is the robust option — the constant is arbitrary anyway;
3. if neither works, prove `hk` by `linarith` from
   `have : (8:ℝ)*10^33 = 8*10^33 := rfl` and `norm_num` on the pure numeral part.

**Note.**  Option 2 is the right default here: the constant in an `O(n⁻³)` bound is arbitrary, and
choosing one that makes the arithmetic trivial removes a class of failure at no cost.

### 13.114 LANDED (round 107): `SThird_numerator_le`

`Op56/PhiThird.lean` now has **120 declarations** (0 sorries, 7/7 OK), newly:

```lean
lemma SThird_numerator_le {n : ℕ} {C3 s r : ℝ} (hn : 1 ≤ n)
    (hr : |r| ≤ C3/((n:ℝ)^3)) (hC3 : 0 ≤ C3) (hs : |s| ≤ 2*10^11/(n:ℝ))
    (hsh : |s| ≤ 1/2) (hden : (1:ℝ)/2 ≤ 1 - s - r) :
    |r*(1 + s + s^2) + s^3| ≤ (4*C3 + 4*10^34)/((n:ℝ)^3) * (1 - s - r)
```

**The fix was to change the constant — option 2 of §13.113, and it worked immediately.**  The old
`7*C3/2 + 2*10^34` required cancelling `C3`-terms in `nlinarith`, which failed (Nat-power
numerals being treated as opaque).  Replacing it by `4*C3 + 4*10^34` makes the cleared goal
`7C3/2 + 1.6·10³⁴ ≤ 4C3 + 4·10³⁴`, discharged by `nlinarith [hC3, hnum, hn3]` with
`hnum : 8*10^33*2 ≤ 4*10^34` supplied by `norm_num`.

**Standing rule (now the third time it has helped): choose constants in `O(n⁻ᵏ)` bounds so the
arithmetic is *trivially* true with slack, not tight.**  A tight constant costs rounds; a slack
constant costs nothing.

**Next — assemble `threshold_exp_bound_third`** (all pieces are now landed):
```lean
lemma threshold_exp_bound_third (u : ℝ) (hu1 : 1/2 ≤ u) (hu2 : u ≤ 1) (n : ℕ) (hn : 1 ≤ n)
    (C3 : ℝ) (hC3 : 0 ≤ C3) (hnC3 : C3 ≤ n) (hnbig : 4*10^11 ≤ n)
    (hbound3 : |Phi (u*(n:ℝ)) n - ((Real.exp u - 1)⁻¹ + SThird u n)| ≤ C3/((n:ℝ)^3))
    (hthr : IsThreshold n (u*(n:ℝ))) :
    |Real.exp u - 2 - SThird u n - (SThird u n)^2| ≤ (4*C3 + 4*10^34)/((n:ℝ)^3)
```
Plan: `r := 1 − (e^u−1)⁻¹ − SThird u n`; `hrle` from `threshold_one_sub_third'`, `hrq : |r| ≤ 1/4`,
`hsle`/`hsh` from `SThird_abs_le`, `hden : 1/2 ≤ 1 − s − r`, then
`exp_sub_two_eq u s r (by …) hne` gives `e^u − 2 = (s+r)/(1−s−r)`, and
`exp_sub_two_algebra` + `SThird_numerator_le` finish it.  **Split it if it does not close in one
pass** — the §13.105 lesson.

### 13.115 LANDED (round 108): **`threshold_exp_bound_third`** — inversion step 2 complete

`Op56/PhiThird.lean` now has **125 declarations** (0 sorries, 7/7 OK), newly:

```lean
lemma exp_sub_two_algebra (s r : ℝ) (h : 1 - s - r ≠ 0) :
    (s + r)/(1 - s - r) - s - s^2 = (r*(1 + s + s^2) + s^3)/(1 - s - r)
lemma threshold_r_quarter {n : ℕ} {C3 R : ℝ} (hn : 4 ≤ n) (hC3 : 0 ≤ C3) (hnC3 : C3 ≤ n)
    (hR : |R| ≤ C3/((n:ℝ)^3)) : |R| ≤ 1/4
lemma threshold_s_quarter {n : ℕ} {s : ℝ} (hn : 1 ≤ n) (hnbig : 8*10^11 ≤ n)
    (hs : |s| ≤ 2*10^11/(n:ℝ)) : |s| ≤ 1/4
lemma threshold_den {s r : ℝ} (hsh : |s| ≤ 1/4) (hrq : |r| ≤ 1/4) : (1:ℝ)/2 ≤ 1 - s - r
lemma threshold_exp_bound_third (u : ℝ) (hu1 : 1/2 ≤ u) (hu2 : u ≤ 1) (n : ℕ) (hn : 1 ≤ n)
    (C3 : ℝ) (hC3 : 0 ≤ C3) (hnC3 : C3 ≤ n) (hnbig : 8*10^11 ≤ n)
    (hbound3 : |Phi (u*(n:ℝ)) n - ((Real.exp u - 1)⁻¹ + SThird u n)| ≤ C3/((n:ℝ)^3))
    (hthr : IsThreshold n (u*(n:ℝ))) :
    |Real.exp u - 2 - SThird u n - (SThird u n)^2| ≤ (4*C3 + 4*10^34)/((n:ℝ)^3)
```

**A genuine arithmetic error was caught here, the fifth of the session:** `|s| ≤ 1/2` together with
`|r| ≤ 1/4` gives only `|s+r| ≤ 3/4`, hence `1−s−r ≥ 1/4` — **not** `≥ 1/2`.  The fix is to tighten
`s`: with `|s| ≤ 1/4` and `|r| ≤ 1/4` we get `|s+r| ≤ 1/2`, so `1−s−r ≥ 1/2` holds, at the cost of
raising `hnbig` from `4·10¹¹` to `8·10¹¹` (so that `2·10¹¹/n ≤ 1/4`).  `SThird_numerator_le` still
needs `|s| ≤ 1/2`, supplied by `linarith [hsh]`.

**Also note:** `exp_sub_two_algebra` had been written in a scratch file in round 100 but **never
landed** — it had to be re-added here.  Lesson: any lemma proved in `/tmp` must be landed in the
same round, or it is lost.

**Next: `threshold_log_bound_third`** (inversion step 3), then the assembly for
`op5_threshold_asymptotic`.  Step 3 must give
`|u − log2 − (e^u−2)/2 + (e^u−2)²/8| ≤ C/n³` — the `−x²/8` term from
`log(1+x) = x − x²/2 + …` with `x = (e^u−2)/2` — combined with the step-2 bound on
`e^u − 2 − s − s²`.

### 13.116 LANDED (round 109): positive third-order log bound

`Op56/PhiThird.lean` now has **126 declarations** (0 sorries, 7/7 OK), newly:

```lean
lemma abs_log_one_add_sub_sq_le_pos (x : ℝ) (hx : 0 ≤ x) (hx2 : x ≤ 1/2) :
    |Real.log (1 + x) - x + x^2/2| ≤ x^3
```

from the two landed log bounds `log_one_add_le_cubic` (upper) and `log_one_add_ge_quartic`
(lower), both stated for `x ≥ 0`.  `abs_le` gives the two components:
`log(1+x) − x + x²/2 ≤ x³/3 ≤ x³` and `−x³ ≤ x³/3 − x⁴/4`.

**Negative `x` is the remaining case**, and the plan is worked out.  For `−1/2 ≤ y < 0` put
`z := −y ∈ (0, 1/2]`, so `1+y = 1−z`.  Use the exact identity

```
log(1−z) = log(1−z²) − log(1+z)
```

(`(1−z²)/(1+z) = 1−z`).  With `w := z²` one has `−w − 2w² ≤ log(1−w) ≤ −w`
(the lower bound from `log(1−w) = −log(1/(1−w))` and `1/(1−w) = 1 + w/(1−w)`:
`log(1/(1−w)) ≤ w/(1−w)`, so `log(1−w) ≥ −w/(1−w) ≥ −w − 2w²`).  Combining with the cubic
bounds for `log(1+z)` and then adding `z + z²/2` cancels the `z²` terms exactly, leaving
`|log(1−z) + z + z²/2| ≤ z³/3 + z⁴ ≤ z³`, i.e.

```lean
lemma abs_log_one_add_sub_sq_le_neg (z : ℝ) (hz : 0 ≤ z) (hz2 : z ≤ 1/2) :
    |Real.log (1 - z) + z + z^2/2| ≤ z^3
```

and then the signed version
```lean
lemma abs_log_one_add_sub_sq_le (y : ℝ) (hy : |y| ≤ 1/2) :
    |Real.log (1 + y) - y + y^2/2| ≤ 2*(|y|^3)
```
by `rcases le_or_gt y 0` and converting the two cases.

**Then `threshold_log_bound_third`** is
`|u − log2 − (e^u−2)/2 + (e^u−2)²/8| ≤ C/n³`, from `abs_log_one_add_sub_sq_le` applied at
`y := e^u/2 − 1` (as in `threshold_log_bound`), with `|e^u−2| ≤ 1` giving `|y| ≤ 1/2`, and the
step-2 bound controlling `e^u − 2`.

### 13.117 Round-110: negative log case — the `z²` terms must cancel *exactly*

No declaration landed (build green: 126 declarations, 0 sorries, 7/7 OK).

**The mathematical point, which is the whole content of this lemma.**  With
`log(1−z) = log(1−z²) − log(1+z)` and `z = −y`, the expression
`log(1−z) + z + z²/2` expands to `(−z²) + (−z + z²/2) + z + z²/2 = 0 + O(z³)`.  The `z²` terms
**cancel exactly**, so a bound `log(1−z²) ≥ −2z²` is **useless**: it leaves `−z² − z³/3 + z⁴/4`
and the certificate fails.  One needs
```
log(1−z²) ≥ −z² − 2z⁴
```
i.e. the leading `−z²` must match the true expansion's leading term, with only the next order
loose.  Derivation: `log(1−w) ≥ −w/(1−w)` (from `Real.log_le_sub_one_of_pos` at `1/(1−w)`)
and `w/(1−w) ≤ w + 2w²` for `w ≤ 1/2` (since `w + 2w² − w/(1−w) = w²(1−2w)/(1−w) ≥ 0`), with
`w = z²`, giving `−z² − 2z⁴`.

**General rule (new):** when a bound is used to prove *cancellation*, every retained term must be
*sharp*; only the terms at the first non-cancelling order may be slack.  This is the inverse of the
§13.114 rule ("choose slack constants"), and the two must be applied to different parts of the same
estimate.

**Errors in `/tmp/w690.lean`:**
1. line 25 — the `linarith` assembling `h2` from
   `h3 : log (1/(1−z²)) ≤ 1/(1−z²) − 1`, `h4 : log (1/(1−z²)) = −log (1−z²)`,
   `h5 : 1/(1−z²) − 1 = z²/(1−z²)`, `h6 : z²/(1−z²) ≤ z² + 2z⁴`.  `h5`'s `field_simp; ring` may
   have closed it already (the §13.75 trap); otherwise `linarith [h3, h4, h5, h6]` should suffice;
2. lines 36–37 — the two `abs_le` components, which should now be
   `−2z³ ≤ −z³/3 + z⁴/4` (component 1) and `−z³/3 ≤ 2z³` (component 2), both immediate from
   `z ≤ 1/2`; if they fail, the cause is a form mismatch in `h1`/`h2` (`−z^2` vs `−(z^2)`), so
   read the printed goal per §13.112.

**Also fixed this round:** `log_one_add_le_cubic` / `log_one_add_ge_quartic` are stated with
`(1/2)*x^2` and `(1/3)*x^3`, **not** `x^2/2` / `x^3/3` — the forms must match exactly when the
bound is used as a `have` with an annotated type.

### 13.118 Round-111: negative log case — `h2` now proved, one error left

No declaration landed (build green: 126 declarations, 0 sorries, 7/7 OK).

**Progress:** `h2 : −z² − 2z⁴ ≤ log(1−z²)` now compiles (the product must be expanded by hand:
`have h7 : (z^2 + 2*z^4)*(1 - z^2) = z^2 + z^4 - 2*z^6 := by ring` before `nlinarith`), and the
two `abs_le` components are now assembled through explicit intermediates `hA`, `hB` rather than
one `linarith` — **because `h3c`/`h4c` are stated with `1/2*z^2` while the goal has `z^2/2`**, and
the forms must be reconciled explicitly (`have he : −(z − (1/2)*z^2 + (1/3)*z^3) = −z + (1/2)*z^2
− (1/3)*z^3 := by ring`).

**The single remaining error (line 41):** `neg_le_neg hcub` reports an application type mismatch
for `hcub : Real.log (1 + z) ≤ z − (1/2)*z^2 + (1/3)*z^3`; `neg_le_neg : a ≤ b → −b ≤ −a` should
apply directly.  **Fix:** state the goal in the form `neg_le_neg` produces, or revert to
`by linarith [hcub]` (which is what the *other* occurrence at line 47 uses and which compiles) —
the asymmetry between the two sites suggests the annotated goal type differs.

**Next:** replace `neg_le_neg hcub` by `by linarith [hcub]`, then the final two `linarith`s with
`hz4 : z^4 ≤ z^3/2` in scope.  Then `abs_log_one_add_sub_sq_le` (signed) and
`threshold_log_bound_third`.

### 13.119 Round-112: the same `linarith` refuses a linear combination that should be immediate

No declaration landed (build green: 126 declarations, 0 sorries, 7/7 OK).

**The blocker, stated precisely.**  With `hcub : Real.log (1 + z) ≤ z − (1/2)*z^2 + (1/3)*z^3` and
`h2' : Real.log (1 − z^2) ≤ −z^2`, both in scope, the goal
```
Real.log (1 - z^2) - Real.log (1 + z) ≤ -z^2 - (z - (1/2)*z^2 + (1/3)*z^3)
```
is a **pure linear combination** of the two hypotheses (subtract the second from the first), and
`linarith [hcub, h2']` / `nlinarith [hcub, h2']` **both fail**.  I have not identified why.  The
printed negation is exactly the reverse of the goal, so the atoms are being recognised; the
suspicion is that `z^2/2` (in the goal's earlier form) versus `(1/2)*z^2` (in `hcub`) prevents the
`z²` coefficient from cancelling inside `linarith`'s normaliser, but the reduced form above no
longer contains `z^2/2` on the left and it *still* fails.

**Concrete next steps (in order):**
1. **Normalise all forms to `(1/2)*z^2`, `(1/3)*z^3` by hand first**, via a `have` equation and
   `rw`, then run `linarith` — i.e. do the syntactic alignment *before* the arithmetic, not after;
2. **State the two needed bounds as separate lemmas with exactly the goal's shape**
   (`log_one_add_ge_of_le`-style), so the `linarith` sees identical atoms;
3. **Bypass `linarith` entirely**: prove the reduced inequality by
   `sub_nonneg.mpr` after rewriting both sides, or by `add_le_add h2' (neg_le_neg hcub)` —
   `add_le_add` on `h2' : a ≤ A` and `neg_le_neg hcub : −B ≤ −b` gives `a + (−B) ≤ A + (−B)`,
   which is the goal up to `ring`.

**Option 3 is the robust one and should have been tried first:** when `linarith` refuses a
combination that is literally `add_le_add` of two hypotheses, use `add_le_add` directly rather
than negotiating with the normaliser.

**Note.**  This lemma (the negative third-order log bound) has now consumed four rounds, and its
statement is three lines.  The mathematics has been correct throughout; the cost is entirely
form-reconciliation, and option 3 above would have avoided all of it.

### 13.120 Round-112 (cont.): `add_le_add` produces the right fact but `linarith` still refuses

No declaration landed (build green: 126 declarations, 0 sorries, 7/7 OK).

`have h := add_le_add h2' (neg_le_neg hcub)` **does** produce the required inequality
`Real.log (1 − z²) + (−(z − (1/2)*z² + (1/3)*z³)) ≤ −z² + (−Real.log (1 + z))`.  But then
`ring_nf at h ⊢` followed by either `exact h` (*type mismatch*) or `linarith [h]`
(*failed to find a contradiction*) both fail.

**This is now the single blocker of the lemma, and it is not a mathematics problem** — the two
sides differ only by `a + (−b) = a − b` and commutativity.  Suspected cause: `ring_nf` normalises
`Real.log (1 + z)` and `−Real.log (1 + z)` into shapes that no longer match between `h` and the
goal, or rewrites the `log` arguments.

**Concrete next steps, now targeting the form rather than the arithmetic:**
1. drop `ring_nf` entirely and use **`simpa only [sub_eq_add_neg, mul_comm, mul_assoc] using h`** —
   keep `log` opaque, rewrite only the arithmetic skeletons;
2. or state the reduced goal in the **exact shape** `add_le_add` produces:
   `log(1−z²) + (−(z − (1/2)*z² + (1/3)*z³)) ≤ −z² + (−log(1+z))`, prove that with `exact h`, and
   only then `simpa [sub_eq_add_neg] using` it to get the stated form;
3. **or avoid the issue entirely** by restating the whole lemma with the goal written as
   `|Real.log (1 - z^2) - Real.log (1 + z) + z + z^2/2| ≤ 2*z^3` *after* substituting
   `log(1−z) = log(1−z²) − log(1+z)` — i.e. put the identity in the lemma *statement* so no
   rewriting is needed inside the proof.  **Option 3 is the cleanest** and is what the existing
   `threshold_log_bound` does (it works with `Real.exp u/2 - 1` throughout, never rewriting).

**Candid note.**  This three-line lemma has now consumed five rounds (109–112 plus 110), all on
form reconciliation rather than mathematics.  The pattern is by now unmistakable and is the single
largest cost in this codebase: **each `linarith` failure should be treated as a form problem and
fixed by restructuring the statement, not by adding normalisation tactics.**  Option 3 above —
put the algebraic identity into the statement so the proof never rewrites — has worked in every
comparable case (`threshold_log_bound`'s use of `Real.exp u/2 - 1`; the `SThird` definition in
§13.102) and should be the default for the remaining inversion lemmas.

### 13.121 LANDED (round 113): `abs_log_one_add_sub_sq_le_neg` — what actually unblocked it

`Op56/PhiThird.lean` now has **127 declarations** (0 sorries, 7/7 OK), newly:

```lean
lemma abs_log_one_add_sub_sq_le_neg (z : ℝ) (hz : 0 ≤ z) (hz2 : z ≤ 1/2) :
    |Real.log (1 - z) + z + (1/2)*z^2| ≤ 2*z^3
```

**Two changes fixed five rounds of failure, and neither was the one I expected.**

1. **Form alignment was necessary but not sufficient.**  Writing the statement as
   `(1/2)*z^2` (matching `log_one_add_le_cubic` / `log_one_add_ge_quartic` exactly) removed one
   class of failure but the final `linarith`s still failed.
2. **The actual blocker was that `linarith` cannot derive `z⁴ ≤ z³·(7/8)` from `z ≤ 1/2`** — it
   cannot multiply.  Supplying `have hz4 : z^4 ≤ z^3/2 := by nlinarith [hz, hz2, pow_nonneg hz 3]`
   and `have hz3n : (0:ℝ) ≤ z^3 := pow_nonneg hz 3` and passing them explicitly closed both
   components immediately.

**So the diagnosis in §13.119–13.120 was wrong.**  It was *not* a `linarith` normalisation or
`log`-atom problem; the two hypotheses simply did not imply the goal without an extra
*multiplicative* fact that `linarith` cannot invent.  **New rule: when `linarith` fails on
inequalities involving two different powers (`z³`, `z⁴`), the missing ingredient is almost always a
power-comparison fact (`z⁴ ≤ z³/2` from `z ≤ 1/2`); supply it, do not reach for `ring_nf`.**

**Candid note.**  Five rounds (109–113) went into this three-line lemma.  The mathematics was
correct from round 109; the cost was (a) three rounds of misdiagnosis, treating a missing
multiplicative hypothesis as a form/normalisation problem, and (b) reaching for `ring_nf`,
`simp only` and `add_le_add` restructuring before reading the printed goal and asking what fact was
*absent* rather than what form was *wrong*.  Both §13.112's rule (read the target) and §13.120's
rule (restate rather than rescue) were necessary here but neither was sufficient — the third,
now-identified rule is: **check whether a hypothesis is missing, not merely mis-shaped.**

**Remaining for the inversion:** the signed version
`abs_log_one_add_sub_sq_le (y : ℝ) (hy : |y| ≤ 1/2) : |Real.log (1 + y) - y + y^2/2| ≤ 2*|y|^3`
(by `rcases le_or_gt y 0` from the positive and negative cases), then `threshold_log_bound_third`,
then the assembly for `op5_threshold_asymptotic`.

### 13.122 LANDED (round 114): the signed third-order log bound

`Op56/PhiThird.lean` now has **128 declarations** (0 sorries, 7/7 OK), newly:

```lean
lemma abs_log_one_add_sub_sq_le (y : ℝ) (hy : |y| ≤ 1/2) :
    |Real.log (1 + y) - y + y^2/2| ≤ 2*(|y|^3)
```

by `rcases le_or_gt 0 y` from `abs_log_one_add_sub_sq_le_pos` and
`abs_log_one_add_sub_sq_le_neg`, with the branch conversions `abs_of_nonneg` / `abs_of_neg`.

**Form of the statement matters and had to be settled once:** the positive lemma is stated with
`x^2/2`, the negative one with `(1/2)*z^2`.  The signed statement uses `y^2/2` (matching the
positive branch, so `le_trans hp hy3` applies directly) and converts in the negative branch via
`have hkey : … = Real.log (1 - (-y)) + (-y) + (1/2)*(-y)^2 := by ring_nf`, then
`rw [hkey, abs_of_neg h]; exact hn`.

**Remark (same root cause as §13.121):** the first attempt failed on `le_trans hp hy3` with
*application type mismatch*, because `hp` carries `y^2/2` and the goal carried `(1/2)*y^2` — not a
missing hypothesis this time, but the same class: **the two forms of the same expression must be
identical, and the cheapest place to enforce that is the statement, chosen to match whichever
landed lemma will be applied.**

**Next: `threshold_log_bound_third`**, mirroring `threshold_log_bound` (which uses
`Real.exp u/2 - 1` throughout): with `Y := Real.exp u/2 - 1`, `u - log 2 = log(1 + Y)`, so
`|u - log2 - Y + Y^2/2| ≤ 2|Y|^3` from the signed bound (given `|Y| ≤ 1/2`), and `Y = (e^u-2)/2`;
then the step-2 bound on `e^u - 2 - s - s^2` converts this to `O(n⁻³)` in `n`.  **Then the
assembly for `op5_threshold_asymptotic`.**

### 13.123 Round-115: `threshold_exp_two_le` — reuse the landed second-order bound

No declaration landed (build green: 128 declarations, 0 sorries, 7/7 OK).

**Key simplification found this round.**  The third-order log step needs `|e^u − 2| ≤ 32/n`, and
this does **not** require a new expansion: the landed `threshold_exp_bound` already produces it
from any bound of the form `|Φ − (e^u−1)⁻¹ − (u/2n)ΦS| ≤ C0/n²`.  The third-order hypothesis
supplies exactly that, because
`SThird u n = (u/2n)ΦS u + D(u)/n²` (`rfl`), so
```
Φ − (e^u−1)⁻¹ − (u/2n)ΦS = (Φ − (e^u−1)⁻¹ − SThird) + D(u)/n²
```
and `|…| ≤ C3/n³ + 2·10¹⁰/n² ≤ (C3 + 2·10¹⁰)/n²` (using the landed `SThird_second_le` for
`|D(u)/n²| ≤ 2·10¹⁰/n`).  **So `threshold_exp_two_le` is a wrapper around `threshold_exp_bound`**,
not new analysis — and the same reuse should be checked before writing any further second-order
estimate in this file.

**Statement now:**
```lean
lemma threshold_exp_two_le (u : ℝ) (hu1 : 1/2 ≤ u) (hu2 : u ≤ 1) (n : ℕ) (hn : 1 ≤ n)
    (C3 : ℝ) (hC3 : 0 ≤ C3) (hnC0 : C3 + 2*10^10 ≤ (n:ℝ))
    (hbound3 : |Phi (u*(n:ℝ)) n - ((Real.exp u - 1)⁻¹ + SThird u n)| ≤ C3/((n:ℝ)^3))
    (hthr : IsThreshold n (u*(n:ℝ))) : |Real.exp u - 2| ≤ 32/(n:ℝ)
```

**Three errors (`/tmp/w730.lean`):**
1. line 22 — `exact_mod_cast this` where `this : (32:ℝ) ≤ (n:ℝ)`: use
   `exact_mod_cast (show (32:ℝ) ≤ (n:ℝ) by linarith [hnC0, hC3])`, or simply take `hn32 : 32 ≤ n`
   as a hypothesis;
2. lines 34, 37 — the `nlinarith` side goals `C3/(n)^3 ≤ C3/(n)^2` and
   `2·10¹⁰/n ≤ 2·10¹⁰/(n)^2`.  Both need `n ≥ 1` **as a real multiplicative fact**; the recurring
   §13.121 lesson applies — supply `hn1R : (1:ℝ) ≤ (n:ℝ)` and `hnR : 0 < (n:ℝ)` explicitly and use
   `nlinarith [hC3, hnR, hn1R]`.

**Then `threshold_log_bound_third`**: with `Y := Real.exp u/2 - 1` (`= (e^u−2)/2`),
`u − log 2 = log(1+Y)` (`Real.log_div` + `Real.log_exp`), so the signed bound gives
`|u − log2 − Y + Y²/2| ≤ 2|Y|³`, and `|Y| ≤ 16/n ≤ 1/2` with `2|Y|³ ≤ 2·(16/n)³ = 8192/n³`.

### 13.124 Round-116: `threshold_exp_two_le` — one `linarith` left

No declaration landed (build green: 128 declarations, 0 sorries, 7/7 OK).

**Fixed this round:** (a) `SThird_second_le` returns `≤ 4·10¹⁰/n`, not `2·10¹⁰/n` — the constant
in the wrapper is `C3 + 4·10¹⁰`; (b) the two power-comparison side goals now pass with the *explicit*
comparisons `hn23 : n² ≤ n³` and `hn12 : n ≤ n²` (from `nlinarith [hn1R, pow_pos hnR 2]` and
`nlinarith [hn1R, hnR]`) — the §13.121 lesson again: `linarith` cannot invent a multiplicative
power comparison, so supply it.

**One error left (line 36):** the goal after `div_le_div_iff₀` is
`4·10¹⁰ * n < 4·10¹⁰ * n²`, i.e. needs `mul_le_mul_of_nonneg_left hn12 (by norm_num)` — the same
multiplicative-fact pattern.  The `have hm := …; linarith [hm]` form did not take; write it as a
**single `linarith` call with the product term inline**:
```lean
      linarith [mul_le_mul_of_nonneg_left hn12 (by norm_num : (0:ℝ) ≤ 4*10^10)]
```
(same structural point as §13.105: hypotheses stated as `have`s with the right annotation are what
`linarith` can consume; passing a lemma application inline sometimes works and sometimes does not,
so state it as a `have` with an **explicit type ascription**).

**Then `threshold_log_bound_third`** (§13.123 plan) and the assembly for
`op5_threshold_asymptotic`.

### 13.125 Round-117: **`SThird_second_le` is too weak for the wrapper** — a real defect

No declaration landed (build green: 128 declarations, 0 sorries, 7/7 OK).

**The finding.**  `SThird_second_le` is landed as
```lean
|(-(u/3)*PhiK3u u + (u^2/8)*PhiK4u u)/((n:ℝ)^2)| ≤ 4*10^10/(n:ℝ)
```
i.e. `|D(u)|/n² ≤ 4·10¹⁰/n`.  That is `O(1/n)` and it is **not strong enough** for
`threshold_exp_two_le`, which needs `|D(u)|/n² ≤ 4·10¹⁰/n²` so that
`|Φ − (e^u−1)⁻¹ − (u/2n)ΦS| ≤ C3/n³ + |D|/n² ≤ (C3 + 4·10¹⁰)/n²` holds with the *same* `n²`
denominator.

The Lean error made this unmistakable: `div_le_div_iff₀` turned the goal into
`4·10¹⁰ * n² ≤ 4·10¹⁰ * n`, which is **false for `n > 1`** — the inequality `1/n ≤ 1/n²` is
backwards.  So the wrapper cannot be proved from the landed lemma at all.

**The fix** (the underlying fact is already proved inside `SThird_second_le`): export
`|D(u)| ≤ 4·10¹⁰` and derive `|D(u)|/n² ≤ 4·10¹⁰/n²`.  Concretely, add
```lean
lemma SThird_D_abs_le (u : ℝ) (hu1 : 1/2 ≤ u) (hu2 : u ≤ 1) :
    |(-(u/3)*PhiK3u u + (u^2/8)*PhiK4u u)| ≤ 4*10^10
```
(extracted from the `hD2` block of `SThird_second_le`), then
```lean
lemma SThird_second_le' (u) (hu1) (hu2) (n) (hn) :
    |(-(u/3)*PhiK3u u + (u^2/8)*PhiK4u u)/((n:ℝ)^2)| ≤ 4*10^10/((n:ℝ)^2)
```
by `rw [abs_div, abs_of_pos (by positivity)]` then `div_le_div_iff₀` and `SThird_D_abs_le`.

**Lesson (new, and this one is about statement-strength, not forms):** a bound that is *true* may
still be *unusable*.  `|D|/n² ≤ 4·10¹⁰/n` follows easily from `|D| ≤ 4·10¹⁰`, but it discards a
factor of `n`, and any downstream estimate that needs matching denominators will fail — visibly, as
here, by producing a goal that is simply false.  **When bounding a quotient, match the
denominator that the downstream sum will have.**  This is the third distinct failure class in this
stretch (missing multiplicative fact §13.121; form mismatch §13.112/§13.122; statement too weak
here).

**Then `threshold_exp_two_le`** becomes: use `SThird_second_le'`, giving
`hbound2 : |Φ − (e^u−1)⁻¹ − (u/2n)ΦS| ≤ C3/n³ + 4·10¹⁰/n² ≤ (C3 + 4·10¹⁰)/n²`, and apply the
landed `threshold_exp_bound` with `C0 = C3 + 4·10¹⁰`.

### 13.126 LANDED (round 118): `SThird_D_abs_le` and `SThird_second_le'`

`Op56/PhiThird.lean` now has **130 declarations** (0 sorries, 7/7 OK), newly:

```lean
lemma SThird_D_abs_le (u : ℝ) (hu1 : 1/2 ≤ u) (hu2 : u ≤ 1) :
    |-(u/3)*PhiK3u u + (u^2/8)*PhiK4u u| ≤ 4*10^10

lemma SThird_second_le' (u : ℝ) (hu1 : 1/2 ≤ u) (hu2 : u ≤ 1) (n : ℕ) (hn : 1 ≤ n) :
    |(-(u/3)*PhiK3u u + (u^2/8)*PhiK4u u)/((n:ℝ)^2)| ≤ 4*10^10/((n:ℝ)^2)
```

**`SThird_D_abs_le` is three lines** because its four component facts
(`neg_u_div_three_K3u_le`, `u_sq_div_eight_K4u_le`, `u_div_three_K3u_le`,
`u_sq_div_eight_K4u_nonneg`) were already landed in round 98 — the body is literally the `hD2`
block of `SThird_second_le`.  **This is the strongest argument yet for extracting component facts
eagerly:** the `hD2` block written in round 98 became a standalone lemma here at zero cost, whereas
re-deriving it inline would have cost another round (as my first attempt did, failing with three
`linarith` errors before I noticed the components were already available).

`SThird_second_le'` needs `hn : 1 ≤ n` for `abs_of_pos` on `n²` (`positivity` cannot prove
`0 < n²` when `n = 0`).

**Next: fix `threshold_exp_two_le`** to use `SThird_second_le'`, giving
`hbound2 : |Φ − (e^u−1)⁻¹ − (u/2n)ΦS| ≤ C3/n³ + 4·10¹⁰/n² ≤ (C3 + 4·10¹⁰)/n²` (now valid, with
matching denominators), then apply the landed `threshold_exp_bound` with `C0 = C3 + 4·10¹⁰`.  Only
three mechanical steps remain there: `C3/n³ ≤ C3/n²` (needs `hn23 : n² ≤ n³`),
`4·10¹⁰/n² + ... ` assembly with `← add_div`, and `hn32` from `hnC0`.

**Then `threshold_log_bound_third`** (§13.123) **and the assembly for `op5_threshold_asymptotic`.**

### 13.127 LANDED (round 119): `threshold_exp_two_le` — the wrapper around `threshold_exp_bound`

`Op56/PhiThird.lean` now has **131 declarations** (0 sorries, 7/7 OK), newly:

```lean
lemma threshold_exp_two_le (u : ℝ) (hu1 : 1/2 ≤ u) (hu2 : u ≤ 1) (n : ℕ) (hn : 1 ≤ n)
    (C3 : ℝ) (hC3 : 0 ≤ C3) (hn32 : 32 ≤ n) (hnC0 : C3 + 4*10^10 ≤ (n:ℝ))
    (hbound3 : |Phi (u*(n:ℝ)) n - ((Real.exp u - 1)⁻¹ + SThird u n)| ≤ C3/((n:ℝ)^3))
    (hthr : IsThreshold n (u*(n:ℝ))) : |Real.exp u - 2| ≤ 32/(n:ℝ)
```

The §13.125 fix worked exactly as planned: `SThird_second_le'` (denominator `n²`) supplies
`hbound2 : |Φ − (e^u−1)⁻¹ − (u/2n)ΦS| ≤ (C3 + 4·10¹⁰)/n²` with matching denominators, then the
landed `threshold_exp_bound` is applied with `C0 = C3 + 4·10¹⁰`.  The only multiplicative side
goal (`C3/n³ ≤ C3/n²`) needed the §13.121 fact `hn23 : n² ≤ n³` supplied explicitly.

**`threshold_log_bound_third` drafted (`/tmp/w751.lean`), three errors left, all diagnosed:**

1. **line 30** — `rw [← h6] at hkey`: the goal is stated with `(e^u−2)^2/8` and `hkey` with
   `((e^u−2)/2)^2/2`; the rewrite must go `rw [h6]` on the *goal* form, or state `hkey` exactly as
   the goal and convert inside;
2. **line 42** — `rw [show (Real.exp u - 2)/2 = Real.exp u/2 - 1 by ring, ← h1]` pattern-not-found:
   simplify — `h3`'s LHS is already `|(e^u−2)/2|^3` and `h1 : Y = (e^u−2)/2`, so
   `rw [h1]` alone (rewriting `(e^u−2)/2` to `Y`... check the direction) then
   `pow_le_pow_left₀`;
3. **line 48** — `congr 1; norm_num` leaves a goal for `(16/(n:ℝ))^3 = 4096/n³`; use
   `rw [div_pow]` then `norm_num` directly, or `ring_nf` on the quotient.

**Note.**  The `rw [h2, h1] at hb` direction issue from the draft is now settled: `hb` is stated in
`Y`-form and the goal in `(e^u−2)/2`-form, so the rewrites must be **forward**
(`rw [h2, h1] at hb`), which compiled.

**After this lemma: the assembly for `op5_threshold_asymptotic`** — combine
`threshold_exp_bound_third` and `threshold_log_bound_third` with the §13.96 algebra
(`s = 3log2/n + O(1/n²)` substitution gives `|u − u_n| ≤ C/n³`), then
`P_n − p_n = n(u − u_n) = O(1/n²)`.

### 13.128 LANDED (round 120): `threshold_log_bound_third` — inversion step 3 complete

`Op56/PhiThird.lean` now has **132 declarations** (0 sorries, 7/7 OK), newly:

```lean
lemma threshold_log_bound_third (u : ℝ) (hu1 : 1/2 ≤ u) (hu2 : u ≤ 1) (n : ℕ) (hn : 1 ≤ n)
    (hn32 : 32 ≤ n) (hexp : |Real.exp u - 2| ≤ 32/(n:ℝ)) :
    |u - Real.log 2 - (Real.exp u - 2)/2 + (Real.exp u - 2)^2/8| ≤ 8192/((n:ℝ)^3)
```

**The fixes, all as recorded:** the two `rw` direction errors (`h6` forward, drop the redundant
`show` before `← h1`), and the last error was **not in `h4` but in `h5`**:
`2 * (4096/n³) = 8192/n³` — `norm_num` cannot handle the opaque `n³`, **`ring` can**.  Reading the
printed goal (the §13.112 rule) identified this in one step.

**The inversion is now one assembly away from `op5_threshold_asymptotic`:**

```
threshold_exp_bound_third : |e^u − 2 − s − s²| ≤ (4C3 + 4·10³⁴)/n³      (s := SThird u n)
threshold_log_bound_third  : |u − log2 − (e^u−2)/2 + (e^u−2)²/8| ≤ 8192/n³
```
Substituting `e^u − 2 = s + s² + O(n⁻³)` into the second gives
`|u − log2 − s/2 − s²/2 + s²/8 + O(n⁻³)| = |u − log2 − s/2 − 3s²/8 + O(n⁻³)| ≤ C/n³`, and
`s = (u/2n)ΦS(u) + D(u)/n² = 3log2/n + O(1/n²)` (from `threshold_second_order_uniform`'s inputs),
which reproduces the §13.96 algebra.  So:

```lean
lemma threshold_third_order_uniform … :
    |u - Real.log 2 - 3*Real.log 2/(2*(n:ℝ)) - c/(n:ℝ)^2| ≤ C/((n:ℝ)^3)
```
with `c = 3(log2)² − (25/12)log2`, and then
`op5_threshold_asymptotic` via `P_n − p_n = n(u − u_n)`.

### 13.129 Round-121: the assembly needs a *sharp* second-order `ΦS` bound — plan

No declaration landed (build green: 132 declarations, 0 sorries, 7/7 OK).  This round established
what the final assembly requires, which is one genuinely new analytic input.

**Why the landed `PhiS_lipschitz` is not enough.**  The target needs
`u − log2 − 3log2/(2n) − c/n² = O(n⁻³)` with the exact `c = 3log2² − (25/12)log2`.  That constant
arises from linearising `u·ΦS(u)` around `log2`, which needs the **sharp first-order term**
`ΦS(u) = 6 − 26(u − log2) + O((u−log2)²)`.  `PhiS_lipschitz` gives only
`|ΦS u − ΦS v| ≤ PhiL·|u−v|` with `PhiL = Σk³e^{−k/2} ≈ 96` — its coefficient is wrong (96 vs 26)
and its error is `O(1/n)` from `u − log2 = O(1/n)`, which lands *inside* the `c/n²` term and
destroys it.  So a second-order bound is unavoidable.

**The bound, and everything it needs is already landed:**
```lean
lemma PhiS_second_order_at_log2 (u : ℝ) (hu1 : 1/2 ≤ u) (hu2 : u ≤ 1) :
    |PhiS u - 6 + 26*(u - Real.log 2)| ≤ 10^12 * (u - Real.log 2)^2
```
* termwise: `e^{−uk} − e^{−bk} + k e^{−bk}(u−b) = e^{−bk}(e^x − 1 − x)` with `x = −k(u−b)`, and
  the Mathlib bound `|e^x − 1 − x| ≤ (x²/2)e^{|x|}`; since `|u−b| ≤ 1/2`,
  `2^{−k}e^{|x|} ≤ 2^{−k}e^{k/2} = e^{−k(log2−1/2)} ≤ e^{−k/8}` (as `log2 − 1/2 > 1/8`);
* summing with `b = log2` gives `ΦS u − 6 + 26(u−log2)`, using **`tsum_cube_half : Σk³2^{−k} = 26`**
  (landed, `PhiAsymptotic.lean` line 1696);
* the remainder `(1/2)(u−b)² Σk²e^{−k/8}`, and `Σk²e^{−k/8} ≤ Σk⁶e^{−k/8} ≤ 2·10¹²`
  (compare against `tsum_pow6_exp_neg_half_le` at `u = 1/4`, whose proof only needs `u > 0` —
  the `summable_pow6_half` pattern of §13.101).

**Then the assembly** (all algebra verified by hand in this round):
* `u − log2 − s/2 − 3s²/8 = A − δ/2 − ((e^u−2)² − s²)/8` with
  `A := u − log2 − (e^u−2)/2 + (e^u−2)²/8`, `δ := e^u − 2 − s − s²`;
* `|A| ≤ 8192/n³` (landed), `|δ|/2 ≤ (4C3+4·10³⁴)/(2n³)`, and
  `|(e^u−2)² − s²|/8 = |(δ+s²)(e^u−2+s)|/8 ≤ (K/n³ + 4·10²²/n²)(3·10¹¹/n)/8 = O(n⁻³)` — note the
  two factors give `n⁻³`, not `n⁻²` (an arithmetic slip I almost made and caught);
* `s/2 + 3s²/8 = 3log2/(2n) + c/n² + O(n⁻³)` from `s = uΦS(u)/(2n) + D(u)/n²`,
  `ΦS(u) = 6 − 26(u−log2) + O((u−log2)²)`, `u − log2 = O(1/n)`, giving
  `c = (9/4)log2 − (51/8)log2² + D(log2)/2 = 3log2² − (25/12)log2` (verified: `9/4 − 26/6 = −25/12`,
  `−51/8 + 75/8 = 3`).

**Order:** (a) `PhiS_second_order_at_log2`; (b) `threshold_third_order_uniform`; (c)
`op5_threshold_asymptotic`.  Roughly 4–6 rounds.

### 13.130 Round-122: `exp_sub_one_sub_id_bound` done; `phiS_term_taylor` drafted

No declaration landed (build green: 132 declarations, 0 sorries, 7/7 OK).

**Working** (`/tmp/w761.lean`): the universal Taylor remainder bound
```lean
lemma exp_sub_one_sub_id_bound (x : ℝ) : |Real.exp x - 1 - x| ≤ 3 * x^2 * Real.exp |x|
```
split on `|x| ≤ 1` (using the Mathlib `Real.abs_exp_one_sub_id_le : |x| ≤ 1 → |exp x − 1 − x| ≤ x²`)
vs `|x| > 1` (using `|exp x − 1| ≤ |exp x| + 1 ≤ 2·exp|x|` and `|x| ≤ x²`).  Fixes of note:
`le_or_lt` does not exist — use `le_or_gt` (cf. §13.79); `Real.abs_exp_le` does not exist —
`|exp x| ≤ exp |x|` is `rw [abs_of_pos (Real.exp_pos x)]; exact Real.exp_le_exp.mpr (le_abs_self x)`;
and the `1 ≤ 3·exp|x|` / `|x| ≤ x²` steps need the *product* facts
`mul_nonneg (sq_nonneg x) (sub_nonneg.mpr hE)` supplied (§13.121).

**`phiS_term_taylor` drafted, five errors (lines 25, 31, 34, 36), all of the two known kinds:**
```lean
lemma phiS_term_taylor (u b : ℝ) (hb : 5/8 ≤ b) (hub : |u - b| ≤ 1/2) (k : ℕ) :
    |Real.exp (-(u*(k:ℝ))) - Real.exp (-(b*(k:ℝ)))
        + (k:ℝ) * Real.exp (-(b*(k:ℝ))) * (u - b)|
      ≤ 3 * ((k:ℝ)^2) * Real.exp (-((k:ℝ)/8)) * (u - b)^2
```
* `h2`'s `ring` (line 31): the goal is `k·e^{−bk}·(u−b) = −e^{−bk}·x` with `x = −(u−b)·k` —
  needs `rw [hx]; ring` **with** the multiplication order made explicit;
* `h51`'s `nlinarith` (line 34): `|−(u−b)·k| ≤ k/2` from `|u−b| ≤ 1/2` — supply
  `mul_le_mul_of_nonneg_right hub hk0` (§13.121);
* `h52`'s `nlinarith` (line 36): `−(b·k) + k/2 ≤ −k/8` from `5/8 ≤ b` — supply the product
  `(k:ℝ)*(1/2 - b) ≤ (k:ℝ)*(-1/8)` by `mul_le_mul_of_nonneg_left`;
* the final `nlinarith [h5, hE0', sq_nonneg (u - b), hk0]` — same class: the product
  `e^{−bk}(3x²e^{|x|}) ≤ 3k²e^{−k/8}(u−b)²` needs `h4 : x² = k²(u−b)²` rewritten and then the
  multiplication by `e^{−bk} ≥ 0` stated explicitly.

**Then `PhiS_second_order_at_log2`** assembles: `b := log 2` (so `e^{−bk} = 2^{−k}` and
`tsum_cube_half : Σk³2^{−k} = 26`), summing `phiS_term_taylor` over `k` with the summability
witnesses already landed.

### 13.131 Round-123: `phiS_term_taylor` — three errors left

No declaration landed (build green: 132 declarations, 0 sorries, 7/7 OK).

`exp_sub_one_sub_id_bound` now compiles **fully** (the `|x| > 1` branch was the last of it:
`h3` had to be `abs_sub_le_iff` on `(e^x−1) − x` — `abs_add_le (e^x−1) x` produces
`|(e^x−1) + x|`, the wrong sign — and the `h5` step is `(mul_le_mul_of_nonneg_left h51 hE0).trans
h52` rather than `linarith`).

**Three errors remain in `phiS_term_taylor`:**
1. **line 25** — `abs_sub_le_iff.mpr ⟨by linarith [Real.exp_pos x, abs_nonneg (Real.exp x)], …⟩`:
   the first component `e^x − 1 ≤ |e^x| + 1` fails to close; supply the two facts as explicit
   `have`s with type ascriptions (cf. §13.105) rather than inline;
2. **line 76** — `nlinarith [mul_le_mul_of_nonneg_right hub hk0]` for `|u−b|·k ≤ k/2`: the product
   fact has form `|u−b|·k ≤ (1/2)·k` while the goal is `≤ (k:ℝ)/2`; add
   `have : ((1/2:ℝ) * (k:ℝ)) = (k:ℝ)/2 := by ring` before the `nlinarith`;
3. **line 84** — the calc step `e^{−bk}(3x²e^{|x|}) ≤ 3k²e^{−k/8}(u−b)²` "invalid calc step,
   left-hand side is" — after `rw [h4]` the LHS shape changed; restructure the calc as
   `calc … ≤ 3 * ((k:ℝ)^2) * (u - b)^2 * (Real.exp (-(b*(k:ℝ))) * Real.exp |x|) := by ring_nf
          _ ≤ 3 * ((k:ℝ)^2) * (u - b)^2 * Real.exp (-((k:ℝ)/8)) :=
              mul_le_mul_of_nonneg_left h5 (by positivity)`.

All three are the known classes (explicit `have`s; form `1/2*k` vs `k/2`; calc-side shape).

**Next after this:** `PhiS_second_order_at_log2` (sum over `k` with `b := log 2`,
`tsum_cube_half = 26`), then `threshold_third_order_uniform`, then `op5_threshold_asymptotic`.

### 13.132 Round-124: `phiS_term_taylor` — two errors left

No declaration landed (build green: 132 declarations, 0 sorries, 7/7 OK).

Fixes that landed this round: the `|e^x| = e^x` fact in `h3`; the `(1/2)*k = k/2` form bridge;
and the `calc` was replaced by two explicit `have` steps (`hstep1` via `mul_le_mul_of_nonneg_left`,
`hstep2` via `rw [h4]; ring_nf; exact mul_le_mul_of_nonneg_left h5 (by positivity)`), which is the
more robust pattern for these products.

**Two errors remain (`/tmp/w761.lean`):**
1. **line 79** — `mul_le_mul_of_nonneg_left h3 hE0'` application type mismatch: the two arguments
   are as expected, so the likely cause is that `h3`'s type is still the *pre-`rw`* form — check
   that `rw [hkey, abs_mul]` earlier does not re-introduce the `abs_mul` form; if it does, move the
   `rw [abs_mul, abs_of_nonneg hE0']` **before** `hstep1` and state `hstep1`'s goal in the
   post-`rw` shape;
2. **line 87** — `rw [h4]` pattern-not-found in `hstep2`: after the earlier edits
   `h4 : x^2 = k²·(u−b)²` may now be stated with `(k:ℝ)^2` in a different association; re-state
   `h4` as `have h4 : x^2 = ((k:ℝ)^2) * (u - b)^2 := by rw [hx]; ring` **with the explicit
   parentheses** matching the goal's subterm.

**Then:** `PhiS_second_order_at_log2` (sum over `k`, `b := log 2`, `tsum_cube_half = 26`),
`threshold_third_order_uniform`, `op5_threshold_asymptotic`.

**Budget doubled to 512 rounds (user request).**

### 13.133 LANDED (round 124): `exp_neg_eighth_le` + `tsum_pow6_eighth_le`; the assembly drafted

`Op56/PhiThird.lean` now has **136 declarations** (0 sorries, 7/7 OK), newly:

```lean
lemma exp_neg_eighth_le : Real.exp (-(1/8:ℝ)) ≤ 15/16
lemma tsum_pow6_eighth_le : (∑' k, (k:ℝ)^6 * Real.exp (-((k:ℝ)/8))) ≤ 10^15
```

Notes: `Real.log_le_log` is the **forward** implication (`0 < x → x ≤ y → log x ≤ log y`); the
iff is `Real.log_le_log_iff` — used for the `exp ≤ 15/16` step via
`rw [← Real.log_le_log_iff (Real.exp_pos (-(1/8:ℝ))) (by norm_num : (0:ℝ) < 15/16), Real.log_exp]`.

**`PhiS_second_order_at_log2` drafted (`/tmp/w772.lean`), five errors, all diagnosed:**

1. **line 13** — `Real.log_two_lt_one` does not exist.  Prove `log 2 ≤ 1` by
   `Real.log_le_log (by norm_num : (0:ℝ) < 2) (Real.add_one_le_exp 1)` then
   `rwa [Real.log_exp] at h1` (`2 ≤ e^1` from `add_one_le_exp`);
2. **line 30** — `ring_nf` in `hk3` does not close the `|…| = |…|` (Type mismatch): replace with
   `congr 1; ring`;
3. **lines 56–57** — `tsum_pow6_eighth_le.summable` is not a thing (it is an inequality, not a
   `Summable`).  Build the summability inline from
   `summable_pow_mul_geometric_of_norm_lt_one 6 hx2` with `hx2 : ‖exp(−1/8)‖ < 1` and the
   `Real.exp_nat_mul` congr (the §13.101 pattern), then `.mul_left (3 * (u − Real.log 2)^2)`;
   the `hmain` type mismatch follows from this;
4. **line 59** — `hsum_eval`'s `Summable.tsum_sub`/`tsum_add` args must be stated as
   `have`s with explicit types first (§13.105), and the `rw [hfun, hfun3]` step only matches if
   the two `fun` forms are stated with the **same** association.

**Then** `threshold_third_order_uniform` and `op5_threshold_asymptotic`.

### 13.134 Round-125: `PhiS_second_order_at_log2` — five form-level fixes enumerated

No declaration landed (build green: 136 declarations, 0 sorries, 7/7 OK).

Fixes applied this round: `hl2` via `Real.log_le_log` (the `1+1` vs `2` form needs `norm_num at h1 ⊢`
before `exact h1`); `hk3` via `congr 1; ring`; `hsumm` built inline from
`summable_pow_mul_geometric_of_norm_lt_one 6 hx2` + `.mul_left (3 * (u − Real.log 2)^2)` +
`congr; ring`.

**Five errors remain (`/tmp/w772.lean`), all of the recorded classes:**
1. **line 13** — `Real.add_one_le_exp 1 : 1 + 1 ≤ exp 1` vs the goal `(2:ℝ) ≤ exp 1`: add
   `norm_num at h1 ⊢` between the `have` and `exact`;
2. **line 31** — the `hk3` `congr 1; ring` leaves a mismatched shape: after `congr 1` the goal is
   inside `|·|`; use `congr 1` then `ring` on the **argument** — or replace by
   `rw [show (k:ℝ)^2 * A - (k:ℝ)^2 * B + (k:ℝ)^3 * B * c = (k:ℝ)^2 * (A - B + (k:ℝ) * B * c) by ring]`
   with `A/B/c` as the concrete terms;
3. **line 58** — `summable_S (Real.log 2) (by linarith : (1:ℝ)/2 ≤ Real.log 2)`: check
   `summable_S`'s hypothesis **form** (likely `1/2 ≤ u` without the `(1:ℝ)`), and match it;
4. **line 59** — follows from 3;
5. **line 71** — `hsum_eval`'s `Summable.tsum_sub` application: the two summability arguments must
   be bound to `have`s **with explicit type ascriptions first** (§13.105), and the
   `rw [hfun, hfun3]` before it needs the `fun`-forms stated with identical association.

**Next:** apply these five, then `threshold_third_order_uniform`, then `op5_threshold_asymptotic`.

### 13.135 Round-125 (cont.): two more fixed — `summable_S` takes `0 < u`

No declaration landed (build green: 136 declarations, 0 sorries, 7/7 OK).

**Key correction: `summable_S (u) (hu : 0 < u)`** — the hypothesis is `0 < u`, **not** `1/2 ≤ u`
(confirmed at `PhiAsymptotic.lean` line 843).  So `summable_S (Real.log 2) (by …)` needs
`(by linarith [hl1] : (0:ℝ) < Real.log 2)`.  **Check the actual signature of every summability
witness before writing the argument** — this is the §13.117 class (assumption about a lemma's
statement) and it cost one error cycle.

**Five errors remain (`/tmp/w772.lean`):**
1. **line 34** — `hk3`'s `congr 1; ring` leaves a type mismatch; replace with an explicit
   `rw [show (k:ℝ)^2*A - (k:ℝ)^2*B + (k:ℝ)^3*B*c = (k:ℝ)^2*(A - B + (k:ℝ)*B*c) by ring]` with
   `A := Real.exp (-(u*(k:ℝ)))`, `B := Real.exp (-(Real.log 2*(k:ℝ)))`, `c := u - Real.log 2`;
2. **line 62** — `hmain` type mismatch follows from the `hsumm` form
   (`3 * k^6 * e^{−k/8} * c²` vs `k^6 * e^{−k/8} * (3 * c²)`): add a `congr` with `ring` to the
   `hsumm` construction;
3. **line 74** — `hsum_eval`'s `Summable.tsum_sub`: bind the two summability arguments as `have`s
   with explicit type ascriptions first (§13.105);
4. **lines 79, 103** — the two `rw` pattern-not-found in `hsum_eval`/`hbig`: state the `fun` forms
   with identical association before the rewrite.

**Next:** these five, then `threshold_third_order_uniform`, then `op5_threshold_asymptotic`.

### 13.136 Round-126: three more fixed — four left in `PhiS_second_order_at_log2`

No declaration landed (build green: 136 declarations, 0 sorries, 7/7 OK).

Fixes that worked this round: `hk2` needed
`rw [abs_mul, abs_of_nonneg (by positivity : (0:ℝ) ≤ (k:ℝ)^2)]` — the `abs_mul` alone leaves `|k²|`
which does **not** match the goal's `k²`, and `abs_of_nonneg` removes it — then
`have h := mul_le_mul_of_nonneg_left hk (by positivity : (0:ℝ) ≤ (k:ℝ)^2)` and
`ring_nf at h ⊢; exact h`.  Same for `hk3` via the explicit `show … by ring` rewrite.

**Four errors remain (`/tmp/w772.lean`):**
1. **line 66** — `hsumm`'s `(h1.mul_left (3 * c²)).congr (fun k => ?_); ring`: the congr goal is
   `k⁶ * e^{−k/8} * (3 * c²) = 3 * k⁶ * e^{−k/8} * c²`; write it as a `have` with an explicit type
   ascription and `ring` (§13.105), then `congr`;
2. **line 78** — `Summable.tsum_sub`'s arguments: bind the two summabilities to `have`s with
   explicit types first;
3. **lines 83, 107** — the two `rw [hfun, hfun3]` / `rw [hbig]` pattern-not-found: state the
   `fun`-forms with identical association (see §13.82's rule) before the rewrite, and for `hbig`
   ensure `tsum_mul_left`'s result matches the exact goal form.

**Next:** these four, then `threshold_third_order_uniform`, then `op5_threshold_asymptotic`.

### 13.137 Round-127: three left in `PhiS_second_order_at_log2` — all diagnosed

No declaration landed (build green: 136 declarations, 0 sorries, 7/7 OK).

Fixes that worked: `hsumf` restated with explicit `hA/hB/hC` witnesses; the main bound now uses
**`hsumf.abs`** (the pointwise `hterm` bounds `|f k|`, not `f k`, so the tsum comparison must run
on the absolute values, combined with the landed `abs_tsum_le_tsum_abs'`); `rw [PhiS, ← PhiS_log_two]`
(the `6` must be rewritten **from** `PhiS (log 2)`, i.e. backwards); and `rw [← hsum_eval]`.

**Three errors remain (`/tmp/w772.lean`):**
1. **line 73** — `hC.mul_left (u − log2)` puts the factor on the **left**:
   `(u−log2) * (k³e^{−bk})`; the goal needs it on the **right** — use **`.mul_right`**;
2. **line 108** — `tsum_sub` cannot fire because the summand is `U − B + C`, not `U − B`.  Split
   first: `have hsplit : (fun k => U − B + C) = (fun k => (U − B) + C) := by funext k; ring`,
   `rw [hsplit]`, then `rw [Summable.tsum_add]` with the two witnesses bound to `have`s
   (`hsumU.sub hsumB`, `hsumC := summable_pow_mul_geometric_of_norm_lt_one 3 hx).mul_right …`),
   then `rw [Summable.tsum_sub hsumU hsumB]` on the first component, and
   `rw [← tsum_mul_left]` + `tsum_cube_half` for `ΣC = 26(u−log2)`;
3. **line 124** — `rw [hbig]` pattern-not-found: `hbig`'s LHS is `Σ' 3 * k^6 * e^{−k/8} * c²` and
   the goal carries the **parenthesised** `Σ' (3 * k^6 * e^{−k/8} * c²)`; state `hbig` with the
   parenthesised binder to match.

**Next:** these three, then `threshold_third_order_uniform`, then `op5_threshold_asymptotic`.

### 13.138 Round-128: three errors left, one is a real constant bug

No declaration landed (build green: 136 declarations, 0 sorries, 7/7 OK).

**A real bug found by the compiler:** with `Σk⁶e^{−k/8} ≤ 10¹⁵`, the target constant `10⁸` is
**too small** — the final step needs `3·(u−log2)²·10¹⁵ ≤ 10⁸·(u−log2)²`, i.e. `3·10¹⁵ ≤ 10⁸`,
which is false.  **Change the conclusion to `≤ 10^16 * (u − Real.log 2)^2`** (and the final
`linarith` then needs `3·10¹⁵ ≤ 10¹⁶` supplied by `norm_num`).  This is the §13.114 lesson in
reverse: the constant was chosen *too tight* against the tail estimate.

**The other two, with exact fixes (`/tmp/w772.lean`):**
1. **line 73** — `hC.mul_left (u − log2)` puts the factor on the left; use **`.mul_right`**;
2. **lines 108/140** — the `rw [hfun, hfun3]` fails because a `fun`-equality only rewrites a
   **whole tsum**, not the `e^{−log2·k}` subterm inside the LHS summand `U − B + C`.  Restructure
   `hsum_eval` in this order: split the LHS tsum first (`hsplit`, `tsum_add (hA.sub hB) hC`,
   `tsum_sub hA hB`), **then** `rw [PhiS, ← PhiS_log_two, PhiS]`, **then** `rw [hfun]` (rewrites
   the whole `Σ'k²e^{−log2k}` on the RHS) and `rw [hfun3]` (whole `Σ'k³e^{−log2k}`), then
   `Σ'k³(1/2)^k(u−b) = (u−b)·Σ'k³(1/2)^k` via `← tsum_mul_left`, then `tsum_cube_half`, then
   `ring`.  **Also `rw [hbig]` must be `rw [hbig] at hmain`** (it rewrites a hypothesis, not the
   goal).

**Next:** these three, then `threshold_third_order_uniform`, then `op5_threshold_asymptotic`.

### 13.139 LANDED (round 129): **`PhiS_second_order_at_log2`** — inversion analysis complete

`Op56/PhiThird.lean` now has **137 declarations** (0 sorries, 7/7 OK), newly:

```lean
lemma PhiS_second_order_at_log2 (u : ℝ) (hu1 : 1/2 ≤ u) (hu2 : u ≤ 1) :
    |PhiS u - 6 + 26*(u - Real.log 2)| ≤ 10^16 * (u - Real.log 2)^2
```

The conclusion constant is `10¹⁶` (the round-128 bug was that `10⁸` was too small against
`3·10¹⁵` from the tail).  **All analytic inputs of the inversion are now landed.**  The two final
tactical fixes: a `Summable.congr` needs the **pointwise** form `(fun k => by ring)`, not a
`fun`-equality; and a `fun`-equality rewrites only a whole tsum, so the `k³`-term conversion must
happen **inside** the `show … by rw [← tsum_mul_left]; congr 1; funext k; rw [he]; ring` block.

**Only the algebra remains for `op5_threshold_asymptotic`:**

1. `threshold_third_order_uniform`: from `threshold_exp_bound_third` and
   `threshold_log_bound_third`, `|u − log2 − s/2 − 3s²/8| ≤ C/n³` (the §13.129 identity
   `u − log2 − s/2 − 3s²/8 = A − δ/2 − ((e^u−2)² − s²)/8`), then expand
   `s = uΦS(u)/(2n) + D(u)/n²` with `PhiS_second_order_at_log2`, `PhiS_log_two = 6`,
   `PhiL`-free: `s/2 + 3s²/8 = 3log2/(2n) + c/n² + O(n⁻³)` with
   `c = 3log2² − (25/12)log2` (verified twice, §13.96 and §13.129), giving
   `|u − log2 − 3log2/(2n) − c/n²| ≤ C'/n³`;
2. `op5_threshold_asymptotic`: `P_n − p_n = n(u − u_n) = O(1/n²)` from the above.

### 13.140 Round-130: the assembly needs `PhiK3u`/`PhiK4u` Lipschitz — final plan

No declaration landed (build green: 137 declarations, 0 sorries, 7/7 OK).

**The last missing ingredient.**  Expanding `s = uΦS(u)/(2n) + D(u)/n²` to `O(n⁻³)` requires
`D(u)/n² = D(log2)/n² + O(n⁻³)`, i.e. `|D(u) − D(log2)| ≤ C|u−log2|` with *any* constant —
`|u−log2| ≤ 32/n` then closes it.  A crude `|D| ≤ 8·10¹⁰` bound is **not** enough (it gives
`O(1/n²)`, which lands inside the sharp `c/n²` coefficient).  Since
`D(u) = −(u/3)PhiK3u(u) + (u²/8)PhiK4u(u)`, what is needed is:

```lean
lemma PhiK3u_lipschitz (u v : ℝ) (hu : 1/2 ≤ u) (hv : 1/2 ≤ v) :
    |PhiK3u u - PhiK3u v| ≤ 4*10^10 * |u - v|
lemma PhiK4u_lipschitz (u v : ℝ) (hu : 1/2 ≤ u) (hv : 1/2 ≤ v) :
    |PhiK4u u - PhiK4u v| ≤ 4*10^10 * |u - v|
```

both mirroring the landed `PhiS_lipschitz` (PhiAsymptotic line 1091) one moment higher: the
termwise step `|e^{−ak} − e^{−bk}| ≤ k·e^{−k/2}·|a−b|` and the tails `Σk⁴e^{−k/2}`,
`Σk⁵e^{−k/2} ≤ Σk⁶e^{−k/2} ≤ 4·10¹⁰` (`tsum_pow6_exp_neg_half_le` at `u = 1`).  Then
`D_lipschitz : |D(u) − D(v)| ≤ 10^12 * |u−v|` from the product estimates with the landed
`PhiK3u_le`/`PhiK4u_le`.

**Complete remaining order:**
1. `PhiK3u_lipschitz`, `PhiK4u_lipschitz` (mirror `PhiS_lipschitz`);
2. `D_lipschitz` (products);
3. `threshold_third_order_uniform` — assemble `threshold_exp_bound_third`,
   `threshold_log_bound_third`, `PhiS_second_order_at_log2`, `D_lipschitz` into
   `|u − log2 − 3log2/(2n) − c/n²| ≤ C/n³` (§13.129 identity and §13.96 constants, verified);
4. `op5_threshold_asymptotic` — `P_n − p_n = n(u − u_n)`.

Estimated 6–10 rounds.

### 13.141 Round-131: `PhiK3u_lipschitz` drafted — four errors

No declaration landed (build green: 137 declarations, 0 sorries, 7/7 OK).

The mirror of `PhiS_lipschitz` is drafted (`/tmp/w790.lean`) with the moment raised by one
(`k³` summands, `k⁴` majorant) and the tail `Σk⁴e^{−k/2} ≤ Σk⁶e^{−k/2} ≤ 4·10¹⁰` via
`tsum_pow6_exp_neg_half_le 1`.

**Four errors:**
1. **line 14** — the `hsum` type: `.mul_right |a - b|` still does not resolve; state it as a
   `have` with an explicit type ascription
   (`have hsum : Summable (fun k => (k:ℝ)^4 * Real.exp (-((k:ℝ)/2)) * |a - b|) := …`) (§13.105);
2. **line 55** — the `rw [tsum_mul_right]` at the end: the goal is
   `Σ'(k⁴e^{−k/2}·|a−b|) ≤ 4·10¹⁰·|a−b|`; `tsum_mul_right` gives
   `(Σ'k⁴e^{−k/2})·|a−b| = Σ'(k⁴e^{−k/2}·|a−b|)` — apply it in the **forward** direction on the
   *goal*, or state the target as a `have`;
3. **line 58** — the `Summable.tsum_le_tsum` application for `Σk⁴ ≤ Σk⁶`: bind the witness
   `summable_exp_neg_u ((1:ℝ)/2) … 4` as a `have` first;
4. **line 64** — the `nlinarith` after `mul_le_mul_of_nonneg_right h4 hE`: the `k⁴ ≤ k⁶` and
   `k ≥ 1` facts need the explicit product form (§13.121), as in `PhiK3u_le` (round 94).

**Then:** copy the lemma to `PhiK4u_lipschitz` (moments one higher), `D_lipschitz`,
`threshold_third_order_uniform`, `op5_threshold_asymptotic`.

### 13.142 LANDED (round 132): `PhiK3u_lipschitz` — budget raised to 4096

`Op56/PhiThird.lean` now has **138 declarations** (0 sorries, 7/7 OK), newly:

```lean
lemma PhiK3u_lipschitz (u v : ℝ) (hu : 1/2 ≤ u) (hv : 1/2 ≤ v) :
    |PhiK3u u - PhiK3u v| ≤ 4*10^10 * |u - v|
```

The mirror of `PhiS_lipschitz` closed with the §13.141 fixes.  **The form-mismatch class
appeared in a new place:** `summable_pow6_half`/`tsum_pow6_exp_neg_half_le` are stated with the
exponent `−(1·k)/2`, **not** `−k/2`; bridge with
`have hc : (∑' k, k^6 * e^{−(1·k)/2}) = (∑' k, k^6 * e^{−k/2}) := by apply tsum_congr; intro k;
rw [show −(1*(k:ℝ))/2 = −((k:ℝ)/2) by ring]`.  (Recorded: when reusing a landed lemma, check its
exponent's exact spelling as well as its hypothesis form — §13.117 extended.)

**`PhiK4u_lipschitz`** is generated by clean substitution (`(k:ℝ)^3 → (k:ℝ)^4`, majorant
`k⁴ → k⁵`, `… 4` → `… 5`, `PhiK3u → PhiK4u`); two small errors remain (`/tmp/w795.lean`, lines
27 and 48 — the `k⁴ ≥ 0` positivity and the calc-step `mul_le_mul_of_nonneg_left` unification).

**Then:** `D_lipschitz`, `threshold_third_order_uniform`, `op5_threshold_asymptotic`.

**User request:** goal budget raised to **4096 rounds** (revision 9).

### 13.143 LANDED (round 132 cont.): `PhiK4u_lipschitz` and `D_lipschitz`

`Op56/PhiThird.lean` now has **140 declarations** (0 sorries, 7/7 OK), newly:

```lean
lemma PhiK4u_lipschitz (u v : ℝ) (hu : 1/2 ≤ u) (hv : 1/2 ≤ v) :
    |PhiK4u u - PhiK4u v| ≤ 4*10^10 * |u - v|
lemma D_lipschitz (u v : ℝ) (hu : 1/2 ≤ u) (hu2 : u ≤ 1) (hv : 1/2 ≤ v) (hv2 : v ≤ 1) :
    |(-(u/3)*PhiK3u u + (u^2/8)*PhiK4u u) - (-(v/3)*PhiK3u v + (v^2/8)*PhiK4u v)| ≤ 10^12 * |u - v|
```

`PhiK4u_lipschitz` needed exactly two exponent fixes from the mechanical substitution (the two
`mul_le_mul_of_nonneg_left … (0 ≤ k^5)` multiplier ascriptions must stay `k^4`, matching the
`k⁴e^{−ak}` summand).  `D_lipschitz` needed the two sum-constant facts supplied as `have`s
(`4·10¹⁰/3 + 4·10¹⁰/3 ≤ 4·10¹⁰` etc.) and `|u+v| ≤ 2` via `abs_le.mpr` with both components.

**All inversion inputs are complete.**  Remaining:

1. `threshold_third_order_uniform` — the §13.129 algebra with the landed pieces;
2. `op5_threshold_asymptotic` — `P_n − p_n = n(u − u_n)`.

### 13.144 LANDED (round 133): `split_bounds` — the Nat.sqrt blockage closed

`Op56/PhiThird.lean` now has **141 declarations** (0 sorries, 7/7 OK), newly:

```lean
lemma split_bounds {n : ℕ} (hn : 100000000 ≤ n) :
    1 ≤ Nat.sqrt (n/4) + 1 ∧ Nat.sqrt (n/4) + 1 ≤ n
    ∧ 4*(Nat.sqrt (n/4))^2 ≤ n
    ∧ Real.sqrt ((n:ℝ))/4 ≤ (Nat.sqrt (n/4):ℝ) + 1
```

This discharges `Phi_third_order`'s `hN1/hNn/hK/hbig` for `N := Nat.sqrt (n/4) + 1`, which has
blocked the assembly since round 84.  The two fixes: `le_trans h4 h5` instead of `linarith` for the
transitivity, and the whole bullet restructured as `hs1 : √(n/16) ≤ √(↑(n/4))` (via
`Real.sqrt_le_sqrt (le_trans h4 h5)`) + `hs2 : √(↑(n/4)) < K+1` (via `Real.sqrt_lt'` and
`Nat.lt_succ_sqrt'`), closed by `le_of_lt (lt_of_le_of_lt hs1 hs2)`.

**The final assembly, now decomposed (`/tmp/w820.lean` has `uPhiS_expansion` drafted):**
1. `uPhiS_expansion : |u·ΦS(u) − 6log2 − (6−26log2)(u−log2)| ≤ 2·10¹⁶(u−log2)²` — the product
   expansion (drafted, 3 errors: the `hident` ring, an `abs_of_nonneg` rewrite, the final sum);
2. `SThird_leading : |SThird u n − 3log2/n| ≤ C/n²` — from (1), `D_lipschitz`, `SThird_abs_le`;
3. `SThird_expansion : |s/2 + 3s²/8 − 3log2/(2n) − c/n²| ≤ C/n³` — with
   `c = (6−26log2)·3log2/8 + D(log2)/2 + 27log2²/8 = 3log2² − (25/12)log2`
   (via `tsum_cube_half = 26`, `tsum_four_half = 150`);
4. `threshold_third_order_uniform` — Stage 1 (`threshold_exp_bound_third` +
   `threshold_log_bound_third` + the §13.129 identity) composed with (3);
5. `op5_threshold_asymptotic`.

### 13.145 LANDED (round 134): `uPhiS_expansion`; `SThird_leading` drafted

`Op56/PhiThird.lean` now has **142 declarations** (0 sorries, 7/7 OK), newly:

```lean
lemma uPhiS_expansion (u : ℝ) (hu1 : 1/2 ≤ u) (hu2 : u ≤ 1) :
    |u*PhiS u - 6*Real.log 2 - (6 - 26*Real.log 2)*(u - Real.log 2)| ≤ 3*10^16 * (u - Real.log 2)^2
```

Fixes: `hw12` needs `1/2 ≤ log2` (I had only `0 ≤ log2`); `|−26| = 26` via
`show |(-26:ℝ)| = 26 by norm_num`; the target constant must be `3·10¹⁶` (with `26 + 2·10¹⁶`, a
`2·10¹⁶` target is **false**); and the final chain is
`h4.trans (h5.trans h6)` with `add_le_add_right h3 c` (not `add_le_add_left`).

**`SThird_leading` drafted (`/tmp/w822.lean`)** — the simpler structure
`s − 3log2/n = (uΦS(u) − 6log2)/(2n) + D(u)/n²` with
`|uΦS(u) − 6log2| ≤ 32·(32/n) + 3·10¹⁶(32/n)²` — five errors (lines 27, 45, 62, 63, 67):
1. line 27 — the `hkey` `ring_nf`: `SThird u n = uΦS(u)/(2n) + D(u)/n²`, so
   `SThird u n − 3log2/n = (uΦS(u) − 6log2)/(2n) + D(u)/n²`; write the `show … by
   rw [SThird]; field_simp; ring` with the `2*(n:ℝ)` denominator matched;
2. line 45 — `mul_le_mul h32 hw (abs_nonneg _) (by positivity)`: the four args must be
   `(a ≤ b) (c ≤ d) (0 ≤ c) (0 ≤ b)` — swap as needed;
3. lines 62–63 — the `linarith`s after `hE`: supply the sum
   `32·(32/n) + 3·10¹⁶(32/n)² ≤ …` explicitly (§13.121);
4. line 67 — `hfinal`'s `norm_num` on the cleared `1.4·10¹¹·n² ≤ 2·10¹¹·n²` needs `hnR` —
   use `nlinarith [hnR]`.

**Then:** `SThird_expansion`, `threshold_third_order_uniform`, `op5_threshold_asymptotic`.

### 13.146 LANDED (round 135): `SThird_leading`

`Op56/PhiThird.lean` now has **145 declarations** (0 sorries, 7/7 OK), newly:

```lean
lemma log_two_le_one : Real.log 2 ≤ 1
lemma log_two_ge_half : (1/2:ℝ) ≤ Real.log 2
lemma SThird_leading (u : ℝ) (n : ℕ) (hu1 : 1/2 ≤ u) (hu2 : u ≤ 1) (hn : 2000000000 ≤ n)
    (hw : |u - Real.log 2| ≤ 32/(n:ℝ)) :
    |SThird u n - 3*Real.log 2/(n:ℝ)| ≤ 2*10^11/(n:ℝ)^2
```

**A real error was caught mid-draft:** I had tried to derive `|u−log2| ≤ 32/n` from `|u−log2| ≤ 1/2`
via `1/2 ≤ 32/n` — which is **false** (`32/n ≤ 1/2`, not the reverse).  `hw` is now a hypothesis,
to be supplied in the final assembly by `threshold_exp_two_le` + `abs_log_sub_log_two_le`.  (This
is the round-93 class again: a sign/direction slip in a planned inequality, caught by Lean.)

**Two new form rules recorded:**
1. when clearing `n²·n⁻¹` after `div_le_div_iff₀`, `ring_nf` alone keeps the inverses — use
   `field_simp [ne_of_gt hnR] at *` first, then `ring_nf at *`;
2. `abs_mul` used as a term needs its explicit arguments (`abs_mul a b`).

**Next: `SThird_expansion`** (`|s/2 + 3s²/8 − 3log2/(2n) − c/n²| ≤ C/n³` with
`c = 3log2² − (25/12)log2`, via `SThird_leading`, `PhiS_log_two = 6`, `tsum_cube_half = 26`,
`tsum_four_half = 150`), then `threshold_third_order_uniform`, then `op5_threshold_asymptotic`.

### 13.147 Round-136: `SThird_expansion` drafted — three errors left

No declaration landed (build green: 145 declarations, 0 sorries, 7/7 OK).

`/tmp/w830.lean` has the full sharp-coefficient assembly, including two new landed-ready lemmas
(`PhiK3u_log_two : PhiK3u (log 2) = 26`, `PhiK4u_log_two : PhiK4u (log 2) = 150`, both mirrors of
`PhiS_log_two`).  The algebraic identity `hident` (the five-term decomposition of
`s/2 + 3s²/8 − 3log2/(2n) − c/n²`) and the coefficient cancellation `hc` (via `ring`) compile.

**Three errors, all diagnosed:**
1. **line 75** — `hD`'s `div_le_div_of_nonneg_right h1 …`: `h1 : |D(u)−D(log2)| ≤ 10¹²·|u−log2|`
   but the goal needs `≤ 10¹²·(32/n)`; chain
   `h1.trans (mul_le_mul_of_nonneg_left hw (by norm_num : (0:ℝ) ≤ 10^12))` before the division;
2. **line 85** — `hw2'`'s `div_le_div_of_nonneg_right (mul_le_mul h61 hw2 …)`: same class — the
   product fact must be bound to a `have` with an explicit type (§13.105);
3. **line 90** — `hsq`'s `rw [abs_div]` pattern-not-found: `|(SThird u n)^2 − (3log2/n)^2|` has no
   division; the intended rewrite is the `sq_sub_sq`-`abs_mul` identity (already written as `hsq`)
   — drop the stray `rw [abs_div]`.

**Then:** `threshold_third_order_uniform`, `op5_threshold_asymptotic`.

### 13.148 Round-137: `SThird_expansion` — three form errors left

No declaration landed (build green: 145 declarations, 0 sorries, 7/7 OK).

Progress: `hident`, `hc`, `hE`, `hE2`, `hD2`, `hw2''`, `hsq2`, `htot` now compile; the `ring_nf at
h1' ⊢` trick aligned the `D_lipschitz` form.  Three errors remain (`/tmp/w830.lean`):

1. **line 78** — `h1b`'s stated LHS lacks the outer parentheses of the goal's form
   (`|a + b − c|` vs `|(a + b) − c|`): restate `h1b` with the parenthesised LHS and use
   `h1c := h1` + `.trans (mul_le_mul_of_nonneg_left hw (by norm_num : (0:ℝ) ≤ 10^12))`;
2. **line 92** — `hprod`'s `mul_le_mul h61b hw2b …`: the fourth argument must be
   `0 ≤ 10^4/(n:ℝ)^2` (`positivity`), not `0 ≤ 32`;
3. **line 99** — `hsq`'s closing `nlinarith [h1, hs]`: the `sq_sub_sq` identity gives
   `|s² − (3log2/n)²| = |s − 3log2/n| · |s + 3log2/n|`; the `hsum` fact for `|s + 3log2/n|`
   must be bound as a `have` with an explicit type (§13.105) before the `mul_le_mul`.

**Then:** `threshold_third_order_uniform`, `op5_threshold_asymptotic`.

### 13.149 LANDED (round 138): **`SThird_expansion`** — the sharp coefficient is proved

`Op56/PhiThird.lean` now has **148 declarations** (0 sorries, 7/7 OK), newly:

```lean
lemma PhiK3u_log_two : PhiK3u (Real.log 2) = 26
lemma PhiK4u_log_two : PhiK4u (Real.log 2) = 150
lemma SThird_expansion (u : ℝ) (n : ℕ) (hu1 : 1/2 ≤ u) (hu2 : u ≤ 1) (hn : 2000000000 ≤ n)
    (hw : |u - Real.log 2| ≤ 32/(n:ℝ))
    (hw2 : |u - Real.log 2 - 3*Real.log 2/(2*(n:ℝ))| ≤ 10^4/(n:ℝ)^2) :
    |SThird u n/2 + 3*(SThird u n)^2/8 - 3*Real.log 2/(2*(n:ℝ))
        - (3*Real.log 2^2 - (25/12)*Real.log 2)/(n:ℝ)^2| ≤ 10^23/((n:ℝ)^3)
```

**This proves, in Lean, that `s/2 + 3s²/8 = 3log2/(2n) + c/n² + O(n⁻³)` with the exact
`c = 3log2² − (25/12)log2`** — the coefficient that makes `thresholdAsym` exact, verified by hand
twice (§13.96, §13.129) and now by the kernel.

**The closing fix class:** every numeric side-goal must carry the **same parenthesisation** as the
lemma it feeds: `c*(a/b)` vs `c*a/b` differs, and `div_le_div_of_nonneg_right` outputs the former
while the statement used the latter.  Rule: after `div_le_div_of_nonneg_right`/`mul_le_mul` is
applied, **read the resulting RHS form and state the enclosing bound to match**.  Also `sq_sub_sq`
produces `|(a−b)(a+b)|` while the goal wants `|a−b|·|a+b|` in the opposite order — `ring_nf` fixes
it.

**Next:** `threshold_third_order_uniform` (Stage 1 + Stage 2 composition), then
`op5_threshold_asymptotic`.  All inputs are now landed.

### 13.150 Round-139: `threshold_third_order_uniform` drafted — the N-choice is `Nat.sqrt (n/4)`

No declaration landed (build green: 149 declarations, 0 sorries, 7/7 OK).

**A real structural issue found:** `Phi_third_order`'s `hK : ∀ k ≤ N, 4k² ≤ n` forces
`N ≤ √(n/4)` (specifically `4(K+1)² ≤ n` is **false** for `K = Nat.sqrt (n/4)`), while its
`hbig : √n/4 ≤ ↑N` is satisfiable at `N = K` because `√n/4 = √(n/16)` and
`√(n/16) ≤ ↑K` follows from `n/16 ≤ (√(↑(n/4))−1)² < K²` (via `Nat.lt_succ_sqrt'` and
`√n ≤ 3n/16 + 1` for `n ≥ 1`).  So the assembly must use **`N := Nat.sqrt (n/4)`**, not `K+1`.

**Needed:** a `split_bounds'` with the sharp last component
`Real.sqrt ((n:ℝ))/4 ≤ (Nat.sqrt (n/4):ℝ)` (the chain `√n/4 = √(n/16) ≤ √((√(↑(n/4))−1)²) < ↑K`
from `Nat.lt_succ_sqrt'`), plus `hN1 : 1 ≤ Nat.sqrt (n/4)` (n ≥ 16).  The rest of the draft
(`/tmp/w840.lean`) compiles up to the `sb.2.2.1` application; the remaining draft errors at lines
39, 47, 53, 60, 74 are downstream of the `hK` form and the `hA`/`h12` linarith product facts
(§13.121).

**Then:** `op5_threshold_asymptotic`.

### 13.151 Round-140: `split_bounds'` drafted — three errors left

No declaration landed (build green: 149 declarations, 0 sorries, 7/7 OK).

`/tmp/w850.lean` has the sharp version (`N := Nat.sqrt (n/4)`, no `+1`):

```lean
lemma split_bounds' {n : ℕ} (hn : 100000000 ≤ n) :
    1 ≤ Nat.sqrt (n/4) ∧ Nat.sqrt (n/4) ≤ n
    ∧ (∀ k : ℕ, k ≤ Nat.sqrt (n/4) → 4*k^2 ≤ n)
    ∧ Real.sqrt ((n:ℝ))/4 ≤ (Nat.sqrt (n/4):ℝ)
```

The sharp `hbig` chain: `√n/4 = √(n/4)/2 ≤ √(↑(n/4)+1)/2 ≤ (√(↑(n/4))+1)/2 ≤ (↑K+2)/2 ≤ ↑K`,
using `Real.sqrt_le_sqrt` (single arg), `√(x+1) ≤ √x+1` via `Real.sqrt_le_left` + `Real.sq_sqrt`,
`Nat.lt_succ_sqrt'`, and `2 ≤ ↑K` from `Nat.le_sqrt` at `4² ≤ n/4`.

**Three errors left:**
1. **line 22** — `omega` cannot use `(Nat.sqrt (n/4))^2` multiplicatively: replace the two `by omega`
   by `Nat.mul_le_mul_left 4 hKsq` and `Nat.mul_div_le n 4` (§13.121's Nat cousin);
2. **line 45** — the `hs2` `nlinarith` needs `hsqx : (√(↑(n/4)))² = ↑(n/4)` as a hypothesis (it
   is), and `↑(n/4)+1 ≤ (√x+1)²` expanded — add `ring_nf at ⊢`;
3. **line 52** — the `hK2` `exact_mod_cast … |>.trans` chain: bind each step as a `have` with an
   explicit type ascription.

**Then:** use `split_bounds'` + `N := Nat.sqrt (n/4)` in `threshold_third_order_uniform` (the
draft's other errors — lines 39, 47, 53, 60, 74 — are downstream of the `hK` form and §13.121
product facts), then `op5_threshold_asymptotic`.

### 13.152 LANDED (round 141): `split_bounds'` — the sharp `N := Nat.sqrt (n/4)` version

`Op56/PhiThird.lean` now has **150 declarations** (0 sorries, 7/7 OK), newly:

```lean
lemma split_bounds' {n : ℕ} (hn : 100000000 ≤ n) :
    1 ≤ Nat.sqrt (n/4) ∧ Nat.sqrt (n/4) ≤ n
    ∧ (∀ k : ℕ, k ≤ Nat.sqrt (n/4) → 4*k^2 ≤ n)
    ∧ Real.sqrt ((n:ℝ))/4 ≤ (Nat.sqrt (n/4):ℝ)
```

**`threshold_third_order_uniform` is now integrated with `N := Nat.sqrt (n/4)`** and five errors
remain (`/tmp/w840.lean`), all diagnosed:
1. **line 39** — the `hbound3` alignment: `Phi_third_order`'s model groups
   `(u/(2n)ΦS + D/n²)` in one pair of parens while `SThird`'s def is flat — the
   `ring_nf` suggestion printed by Lean did not fully align the `|·|` argument; use
   `change |Phi (u*(n:ℝ)) n − ((Real.exp u − 1)⁻¹ + (u/(2*(n:ℝ))*PhiS u + (−(u/3)*PhiK3u u +
   (u^2/8)*PhiK4u u)/((n:ℝ)^2)))| ≤ …` with the **same grouping** as `Phi_third_order`'s
   conclusion, or `convert h using 1` then `ring`;
2. **line 53** — `hw2' u hu1 hu2 hthr` is `∀ᶠ`-shaped, not an implication: the `filter_upwards`
   result `hw2'` is an `∀ n, P n → Q n`-style function — check the exact form and feed the
   hypotheses as written;
3. **lines 60, 74, 76** — the `hA`/`h12` §13.121 product facts: `4C3 + 4·10³⁴ ≤ 4n + 4·10³⁴`
   from `hnC3`, and `12·10⁴⁵ ≤ 10¹²·n` from `hn12R` — bind each as a `have` with an explicit type.

**Then:** `op5_threshold_asymptotic`.

### 13.153 Round-142: a real sign error caught in the Stage-1 identity; five form errors left

No declaration landed (build green: 150 declarations, 0 sorries, 7/7 OK).

**A real algebra error caught by `ring`:** the recorded §13.129 identity
`u − log2 − s/2 − 3s²/8 = A − δ/2 − ((e^u−2)² − s²)/8` is **off by δ** — the correct form is
`= A + δ/2 − ((e^u−2)² − s²)/8` (the `−(e^u−2)/2` terms cancel, the `δ/2` carries a **plus**).
The §13.129 record was wrong; the fixed constants are `2C3 + 4·10³⁴ + 10²³ + 10⁵C2`.
`hbound3` closed with `convert h using 1; · ring` (the `dsimp`+`exact` form failed because the
goal's inner grouping `(u/(2n)ΦS + D/n²)` does not reduce to `Phi_third_order`'s flat model —
the `convert` route works).

**Five errors remain (`/tmp/w840.lean`), all diagnosed:**
1. **line 60** — `div_le_div_of_nonneg_right hexp3 (by norm_num)`: the positivity argument needs
   `(by norm_num : (0:ℝ) ≤ 2)`;
2. **lines 74/76** — `h31`'s final `exact mul_le_mul hd hsum …` leaves the residual
   `((4C3+4·10³⁴)/n³ + (2·10¹¹/n)²)·(3·10¹¹/n) ≤ 26·10³³/n³` — move the `h32` proof **before**
   `h31` and close with `.trans h32`;
3. **lines 85, 95** — downstream of the above.

**Then:** `op5_threshold_asymptotic`.

### 13.154 Round-142 (cont.): `threshold_third_order_uniform` removed from deliverable, six errors left

Build green: **150 declarations, 0 sorries, 0 axioms, 7/7 OK**.  The half-fixed lemma was removed
from `PhiThird.lean` (per the never-leave-a-broken-deliverable rule); the full draft is in
`/tmp/w840.lean` with the sign fix (§13.153) and the `convert h using 1` hbound3 fix applied.

**Six errors left in the draft, diagnosed:**
1. **line 4197** — `h2`'s `exact div_le_div_of_nonneg_right hexp3 (by norm_num : (0:ℝ) ≤ 2)`:
   the residual is a **Type mismatch** — read the printed goal; the `abs_div` result's
   denominator is `|2|`-shaped or the `rw [abs_of_pos]` direction (§13.112);
2. **line 4208** — the `hA`'s `mul_le_mul_of_nonneg_right hC3n …` argument: the second argument
   must be `(0 ≤ 3·10¹¹)` **with the explicit ascription**;
3. **line 4218** — `h12`'s `nlinarith [hnp, hn2]`: supply
   `12·10⁴⁵ ≤ 10¹²·n` and `12·10¹¹·n ≤ 10¹²·n` as separate `have`s with explicit types
   (§13.121);
4. **line 4230** — `h3'`'s closing `nlinarith [h3']`: the `26·10³³/(8n³) ≤ 10³⁴/n³` step needs
   the product form `26·10³³ ≤ 8·10³⁴` supplied as a `have` (§13.121);
5. **lines 4232, 4234** — downstream.

**Next:** finish these six in the scratch, re-land `threshold_third_order_uniform`, then
`op5_threshold_asymptotic`.

### 13.155 Round-143: `threshold_third_order_uniform` — five errors left, all with fixes

No declaration landed (build green: 150 declarations, 0 sorries, 7/7 OK).

Fixes that worked: `hneg2` via `rw [show −X/8 = −(X/8) by ring, abs_neg]`; the `0 ≤ 8` ascription
in `h3'`; `sq_sub_sq` gives **`(a+b)·(a−b)`** (reversed order) — add `, mul_comm` to the
`rw [sq_sub_sq, abs_mul]`; `hsum2` needs `inv_nonneg.mpr hnR.le`; `htot` via
`field_simp [hnR]; dsimp [C3]; nlinarith [hnR]`.

**Five errors remain (`/tmp/w840.lean`):**
1. **line 60** — `h2`'s `div_le_div_of_nonneg_right hexp3 (by norm_num : (0:ℝ) ≤ 2)`: read the
   printed goal — the `rw [abs_div, abs_of_pos]` may have left the denominator as `|2|`;
2. **line 75** — `h31`'s `exact (mul_le_mul hd hsum …).trans h32`: after the `mul_comm`, the
   residual `(…)(3·10¹¹/n) ≤ 26·10³³/n³` must match `h32`'s LHS **exactly** — bind the
   `mul_le_mul` result to a `have` with an explicit type (§13.105) before `.trans`;
3. **lines 78, 87** — `hA`'s and `hB`'s `mul_le_mul_of_nonneg_right`/`field_simp` arguments:
   supply the explicit `(0 ≤ 3·10¹¹)` ascription and `hnz`-style `n ≠ 0`;
4. **line 97** — the final `linarith` of the lemma: supply the remaining sum facts as `have`s.

**Then:** `op5_threshold_asymptotic`.

### 13.156 Round-144: `threshold_third_order_uniform` — five errors, h32-before-h31 surgery needed

No declaration landed (build green: 150 declarations, 0 sorries, 7/7 OK).

Applied against the actual (stale) text of `/tmp/w840.lean`: `h2`'s RHS restated as
`((4C3+4·10³⁴)/n³)/2` to match `div_le_div_of_nonneg_right`'s output; the `mul_le_mul` 4th
argument must be `0 ≤ (4C3+4·10³⁴)/n³ + (2·10¹¹/n)²` (the `b`), built by hand from `hC3`
(`div_nonneg` + `sq_nonneg`); `hsum2` via `rw [← add_div]` + `div_le_div_of_nonneg_right hnum`.
The `h3'` denominator form fix: state `≤ (26·10³³/n³)/8` then `field_simp` to `10³⁴/n³`.

**Remaining five errors, all diagnosed:**
1. **line 88** — `h32` is referenced inside `h31` but defined after it: move the whole
   `have h32 : … := by … linarith [hA, hB]` block **before** `have h31` (the text-extraction
   failed once on a pattern mismatch — copy the block verbatim from the file);
2. **line 97** — `hA`'s `mul_le_mul_of_nonneg_right hC3n (by norm_num : (0:ℝ) ≤ 3*10^11)`:
   add the explicit ascription (it is missing in the stale text);
3. **lines 107, 109** — `h12`/`hB` linarith and type-mismatch: supply the two product facts
   (`12·10⁴⁵ ≤ 10¹²·n`, `12·10¹¹·n ≤ 10¹²·n`) as typed `have`s (§13.121);
4. **line 125** — the lemma's final `linarith` (htot2 sum): supply the add_div facts.

**Then:** `op5_threshold_asymptotic`.

### 13.157 Round-145: `threshold_third_order_uniform` — TWO errors left, one real constant bug fixed

No declaration landed (build green: 150 declarations, 0 sorries, 7/7 OK).

**A real constant bug was caught:** my `hA`'s `12·10⁴⁵ + 12·10¹¹·n ≤ 13·10³³·n` is **false**
(`12·10¹¹ > 10¹²`, and `12·10⁴⁵ ≤ 10¹²·n` needs `n ≥ 1.2·10³⁴`).  The correct `hA` splits:
`(4C3+4·10³⁴)·3·10¹¹ ≤ (4n+4·10³⁴)·3·10¹¹ = 1.2·10¹²·n + 1.2·10⁴⁶`, and the `n⁴`-cleared form
`1.2·10¹²·n⁴ + 1.2·10⁴⁶·n³ ≤ 1.3·10³⁴·n⁴` follows from `n ≥ 10¹²` (`1.2·10⁴⁶·n³ ≤ 1.2·10³⁴·n⁴`).
Also fixed: `hsumAB` via `nlinarith [hnR]` (not `norm_num`), `hdist` distributivity supplied,
`h3'`/`hneg2`/`htot`/`h2` denominator forms aligned.

**TWO errors remain (`/tmp/w840.lean`):**
1. **line 123** — `hneg2 : |−X/8| = |X/8|` (where `X := (e^u−2)² − s²`): `ring_nf` leaves the goal
   unsolved because the `−` binds **inside** the division; use
   `rw [show −X/8 = −(X/8) by ring]` **first** (with `X` written exactly as in the goal), then
   `abs_neg`;
2. **line 129** — the `hstage1` final `linarith`: after (1), the terms `|−X/8|` and h3's `|X/8|`
   will align and the chain closes.

**Then:** `op5_threshold_asymptotic`.

### 13.158 LANDED (round 146): **`threshold_third_order_uniform`** — the inversion is complete

`Op56/PhiThird.lean` now has **151 declarations** (0 sorries, 7/7 OK), newly:

```lean
lemma threshold_third_order_uniform :
    ∃ C : ℝ, 0 < C ∧ ∀ᶠ n : ℕ in Filter.atTop, ∀ u : ℝ, 1/2 ≤ u → u ≤ 1 →
      IsThreshold n (u*(n:ℝ)) →
        |u - Real.log 2 - 3*Real.log 2/(2*(n:ℝ)) - (3*Real.log 2^2 - (25/12)*Real.log 2)/(n:ℝ)^2|
          ≤ C/(n:ℝ)^3
```

with `C = 2C3 + 4·10³⁴ + 10²³ + 10⁵C2`.  **This proves, in Lean, the full third-order inversion
`u = log2 + 3log2/(2n) + c/n² + O(n⁻³)` with `c = 3log2² − (25/12)log2`.**  The last closing
fix: `hid`'s third term must be written `+ (−((e^u−2)² − s²))/8` so the goal's division-binding
matches `hsum2`'s (`−X/8` binds as `(−X)/8`, not `−(X/8)`); `hneg2` then closes with
`abs_div`/`abs_neg` on both sides.

**The first deliverable needs one more lemma:** `op5_threshold_asymptotic` has **no** `hu1/hu2`
hypotheses, so the range `1/2 ≤ Pfun n/n ≤ 1` must be derived from `hP` alone.  Components:
1. termwise strict monotonicity of `Phi p n` in `p` (`(1+(j+1)/n)^{-p}` decreasing in `p`, via
   `rpow` monotonicity — base `> 1`), then `tsum` strictness;
2. `Phi ((1/2:ℝ)*(n:ℝ)) n ≥ 1`: termwise `(1+(j+1)/n)^{n/2} ≤ 2^{j+1}` from
   `(1+x) ≤ 2^x` (`Real.log_le_sub_one_of_pos`-style at the right point) — strict on j = 0,
   giving `≥ 1` and then `u ≥ 1/2`;
3. `Phi (n:ℝ) n ≤ 1` for `u ≤ 1`: hmm — `(1+(j+1)/n)^{-n} ≥ 3^{-(j+1)}` is **false**
   (`log(1+x) ≥ x·log 3` fails for x ≥ 1); the correct route is
   `(1+(j+1)/n)^n ≥ (j+2)`-ish or Bernoulli at `j = 0` (`(1+1/n)^n ≥ 2`) plus the geometric
   tail `Σ'(1+(j+1)/n)^{-n} ≤ 1/2 + 1/2·...` — to be worked out; OR relax: the third-order
   lemma needs `u ≤ 1` only through `Phi_third_order`'s `hu2` — check whether the eventual
   `=O` form can use `u ≤ 3/2` (proved by the same endpoint route with slack).

Then `op5_threshold_asymptotic` = the `op5_threshold_second_order` extraction template with the
third-order bound.

### 13.159 Round-147: the u-range route is settled — no new endpoint sums needed

No declaration landed (build green: 151 declarations, 0 sorries, 7/7 OK).

**Key simplification:** the endpoints `Φ((n/2), n) ≥ 1` and `Φ(n, n) ≤ 1` come **for free** from
the landed `Phi_asymptotic_explicit` at `u = 1/2` and `u = 1`:
`Φ((n/2), n) ≥ (e^{1/2}−1)^{-1} − PhiC/n ≈ 1.54 − o(1) ≥ 1` and
`Φ(n, n) ≤ (e−1)^{-1} + PhiC/n ≈ 0.58 + o(1) ≤ 1` for `n ≥ 4·PhiC`-ish.  The naive direct sum
comparison for `Φ(n,n) ≤ 1` needs a delicate tail (the `3^{-(j+1)}` route is false for j ≥ n),
which this avoids entirely.

**What is needed (`op5_threshold_asymptotic`'s missing range):**
1. `Phi_antitone : p1 ≤ p2 → Phi p2 n ≤ Phi p1 n` — termwise
   `(1+(j+1)/n)^{-p2} ≤ (1+(j+1)/n)^{-p1}` via rpow monotonicity (`one_lt_rpow`-style at base
   `> 1`), then `Summable.tsum_le_tsum` (pattern: `Summable.tsum_le_tsum (fun k => ?_) hf hg`);
2. `Phi_strictAnti : p1 < p2 → Phi p2 n < Phi p1 n` — same termwise with **strict** at `j = 0`
   (`rpow_lt_rpow` at the base `1+1/n > 1`), then `Summable.tsum_lt_tsum`;
3. `threshold_u_range : ∀ᶠ n, ∀ u, IsThreshold n (u*(n:ℝ)) → 1/2 ≤ u ∧ u ≤ 1` — from (2) with
   the endpoint bounds: `u < 1/2 → Φ(un,n) > Φ((n/2),n) ≥ 1 = Φ(un,n)` contradiction, and
   symmetrically for `u ≤ 1`.

Then `op5_threshold_asymptotic` = the `op5_threshold_second_order` extraction template with
`threshold_third_order_uniform`.

### 13.160 LANDED (round 148): `Phi_antitone` and `Phi_strictAnti`

`Op56/PhiThird.lean` now has **153 declarations** (0 sorries, 7/7 OK), newly:

```lean
lemma Phi_antitone (n : ℕ) (hn : 1 ≤ n) (p1 p2 : ℝ) (hp1 : 2 ≤ p1) (h : p1 ≤ p2) :
    Phi p2 n ≤ Phi p1 n
lemma Phi_strictAnti (n : ℕ) (hn : 1 ≤ n) (p1 p2 : ℝ) (hp1 : 2 ≤ p1) (h : p1 < p2) :
    Phi p2 n < Phi p1 n
```

Key facts: `Summable.tsum_le_tsum h hg hf` takes the **LHS** summability first; `Summable.tsum_lt_tsum`
takes `(h : f ≤ g) (h0 : f i < g i) (hf) (hg)` with the witness index pinned by `(i := 0)` (the
bare `?_` fails because `i` is implicit); the strict base at `j = 0` needs
`norm_num` before `linarith` (`↑0+1` vs `1`); summability via `summable_phi (p/n) n hn` with the
`(p/n)·n = p` rewrite and `.congr`.

**Next: `threshold_u_range`** — the endpoint sandwich:

```lean
lemma threshold_u_range : ∀ᶠ n : ℕ in Filter.atTop, ∀ u : ℝ,
    IsThreshold n (u*(n:ℝ)) → 1/2 ≤ u ∧ u ≤ 1
```

from `Phi_strictAnti` with `Phi_asymptotic_explicit` at `u = 1/2` and `u = 1`:
`u < 1/2 → Φ(un,n) > Φ((n/2),n) ≥ 1 = Φ(un,n)` (contradiction); `u > 1 → Φ(un,n) < Φ(n,n) ≤ 1`
(contradiction).  Needs `n ≥ max 4 ⌈2·PhiC⌉` for `Phi_asymptotic_explicit`'s `hn : 4 ≤ n` and
`PhiC/n ≤ 1/2`, and `2 ≤ u·n` for the strictAnti (from `u > 1/2`-branch: `2 ≤ n·(1/2)·... ` —
check the branch hypotheses).

Then `op5_threshold_asymptotic` (the `op5_threshold_second_order` extraction template).

### 13.161 Round-149: `threshold_u_range` needs a `2 ≤ un` bootstrap — refined plan

No declaration landed (build green: 153 declarations, 0 sorries, 7/7 OK).

**Why:** `Phi_strictAnti`'s summability hypothesis is `2 ≤ p1`; in the `u < 1/2` contradiction the
smaller exponent is `un`, which is not known `≥ 2` a priori (and `Phi p n` genuinely diverges for
`p ≤ 1`, so `p1 > 1` is the true necessary range — the `2 ≤` was a convenience).

**The bootstrap (all elementary, no new heavy machinery):**
1. `Phi_two_gt_one : ∀ᶠ n, 1 < Phi 2 n` — just the first two summands:
   `Phi(2,n) ≥ (1+1/n)^{-2} + (1+2/n)^{-2} ≥ 2·(1+2/n)^{-2} ≥ 2·(6/5)^{-2} > 1` for `n ≥ 10`
   (tsum ≥ partial sum via `tsum_ge_of_forall_ge`-style or `hasSum`/`tsum_le_tsum` truncation);
2. weak `Phi_antitone` (landed) with `p1 := 2`, `p2 := un`: `un ≤ 2 → Phi(un,n) ≥ Phi(2,n) > 1`,
   contradicting `Phi(un,n) = 1` — so **`2 < un`**;
3. then `u < 1/2 → un < (1/2)n` with the landed `Phi_strictAnti n hn un ((1/2)n)
   (by linarith : 2 ≤ un) …`: `Phi((1/2)n, n) < Phi(un, n) = 1`, but
   `Phi((1/2)n, n) ≥ (e^{1/2}−1)^{-1} − PhiC/n ≥ 1` (from `Phi_asymptotic_explicit` at
   `u = 1/2`, for `n ≥ 4·PhiC`) — contradiction, so `1/2 ≤ u`;
4. `u ≤ 1` symmetrically: `1 < u → n < un` with `Phi_strictAnti n hn n un (2 ≤ n) (n < un)`:
   `Phi(un,n) < Phi(n,n) ≤ (e−1)^{-1} + PhiC/n ≤ 1` (from `Phi_asymptotic_explicit` at
   `u = 1`) — contradiction.

**Then** `op5_threshold_asymptotic` (the `op5_threshold_second_order` extraction template).

### 13.162 LANDED (round 150): `Phi_two_gt_one'` — the `2 ≤ un` bootstrap

`Op56/PhiThird.lean` now has **154 declarations** (0 sorries, 7/7 OK), newly:

```lean
lemma Phi_two_gt_one' {n : ℕ} (hn : 10 ≤ n) : 1 < Phi 2 n
```

via the first two summands: `Φ(2,n) ≥ f 0 + f 1 ≥ 2·(6/5)^{-2} ≥ 4/3 > 1`.  Key facts:
`le_tsum` does **not** exist in this Mathlib — the two-term lower bound goes through
`hasSum_ite_eq 0`/`hasSum_ite_eq 1`, `.add`, the nested-ite equality rewritten with `← hfun`
(the `.add` produces the pointwise-sum form, so the rewrite is **backwards**), then
`Summable.tsum_le_tsum` against the `HasSum.summable` truncation; `Real.rpow_le_rpow_of_nonpos`
takes `0 < x` (**strict**); `Real.rpow_intCast` via
`rw [show -(2:ℝ) = ((-2:ℤ):ℝ) by norm_num, Real.rpow_intCast]`.

**Next: `threshold_u_range`** — the four-step sandwich from §13.161 (bootstrap → `2 < un` →
strictAnti at `(1/2)n` with `Phi_asymptotic_explicit` endpoints → `u ≤ 1` symmetrically), then
`op5_threshold_asymptotic`.

### 13.163 Round-151: `threshold_u_range` drafted — six errors

No declaration landed (build green: 154 declarations, 0 sorries, 7/7 OK).

`/tmp/w880.lean` has the full assembly plus two endpoint-value lemmas
(`exp_half_le_seven_fourths` via `log_one_add_ge_quartic` at 3/4; `exp_one_inv_le_three_fourths`
via `log(7/3) = log(7/4) + log(4/3) ≤ 2/3 + 1/3 = 1` from `log_one_add_le_cubic` and
`Real.log_le_sub_one_of_pos`).  Name fixes applied: `Real.one_lt_exp_iff` (not
`Real.one_lt_exp`); `inv_le_inv₀ ha hb : a⁻¹ ≤ b⁻¹ ↔ b ≤ a` (not `inv_le_inv_of_le`).

**Six errors, diagnosed:**
1. **line 37** — `Real.log_le_sub_one_of_pos`'s argument: it takes the point where the bound
   `log y ≤ y − 1` is evaluated — check the exact form (`log(4/3) ≤ 1/3` needs `y = 4/3`);
2. **line 50** — the `nlinarith` after `h74`: supply `7/4 ≤ e^1` as a typed `have` (§13.105);
3. **line 76** — `Phi_asymptotic_explicit n hn4 (1/2) (by norm_num) (by norm_num)`: the `by
   norm_num` for `1/2 ≤ 1`/`1 ≤ 1` needs explicit ascriptions `(1/2:ℝ) ≤ 1`;
4. **lines 79, 84** — `hend1`'s linariths: the `abs_sub_le_iff.mp hend` direction for the lower
   bound is `.1` (check the printed form) and the chain needs `PhiC/n ≤ 1/4` + `4/3 − 1/4 ≥ 1`
   supplied as a `have`;
5. **line 89** — the `hend1` (u ≤ 1 side) symmetric.

**Then:** `op5_threshold_asymptotic`.

### 13.164 Round-152: the `2 ≤ p1` hypothesis blocks the `un ≤ 2` branch — relax to `1 < p1`

No declaration landed (build green: 154 declarations, 0 sorries, 7/7 OK).

`/tmp/w880.lean` is down to three errors, all from the same root: in the `u < 1/2` branch's
`un ≤ 2` case, `Phi_antitone`'s hypothesis `2 ≤ p1` (with `p1 = un`) is not available — the
branch gives only `un ≤ 2`.  **Fix: relax `Phi_antitone`/`Phi_strictAnti` to `1 < p1`** via a new
summability lemma (`Phi p n` converges iff `p > 1`):

```lean
lemma summable_phi_gt_one (p : ℝ) (n : ℕ) (hn : 1 ≤ n) (hp : 1 < p) :
    Summable (fun j : ℕ => (1 + (((j : ℝ) + 1) / (n : ℝ))) ^ (-p))
```

via `(1+(j+1)/n)^{-p} ≤ ((j+1)/n)^{-p} = n^p·(j+1)^{-p}` (`Real.rpow_le_rpow_of_nonpos`,
`Real.div_rpow`, `Real.rpow_neg`, `field_simp`) against `summable_nat_rpow_inv.mpr hp`
(check the exact name — may be `Real.summable_nat_rpow_inv`).  Then change the two landed
lemmas' `(hp1 : 2 ≤ p1)` to `(hp1 : 1 < p1)` (the termwise steps are unaffected).

**Also fixed in the draft:** `exp_one_inv_le_three_fourths` needed `7/3 ≤ e` (via
`log(7/3) ≤ 1`), not `7/4`; the inv bound base is `4/3` (`(e−1)⁻¹ ≤ (4/3)⁻¹ = 3/4`); the
`rw [← hthr]` on `Phi((1/2)n) < 1` rewrites the **1 inside 1/2** — use `hstrict.trans_eq hthr`;
`Real.log_mul` takes `x ≠ 0`, not `0 < x`.

**Then:** `op5_threshold_asymptotic`.

### 13.165 Round-153: `summable_phi_gt_one` drafted — the index-shift is the last detail

No declaration landed (build green: 154 declarations, 0 sorries, 7/7 OK).

`/tmp/w891.lean` has the full proof except the shift step.  Working facts:
`Real.summable_nat_rpow_inv : (Summable fun n => (↑n^p)⁻¹) ↔ 1 < p`;
`Real.rpow_neg : 0 ≤ x → x^(-y) = (x^y)⁻¹`; `Real.div_rpow` takes `0 ≤ x` and `0 ≤ y` **of the
numerator/denominator separately** (passing the fraction's positivity mis-unifies);
`field_simp` needs `ne_of_gt (Real.rpow_pos_of_pos hnR p)` for `n^p`.

**The remaining step (line 13):** `Summable (fun j => ((↑j + 1)^p)⁻¹)` from
`(Real.summable_nat_rpow_inv.mpr hp).comp_injective Nat.succ_injective`, whose type is the
composition form `Summable ((fun n => (↑n^p)⁻¹) ∘ Nat.succ)`.  `change`/`simpa` both failed to
unfold `∘` into the lambda; use `convert … using 1` then `ext j; rfl`, or restate via
`have hc : (fun n => (↑n^p)⁻¹) ∘ Nat.succ = fun j => ((↑j + 1)^p)⁻¹ := by funext j; rfl`
and `rw [hc]` — wait, the equality's RHS has `↑(j+1)` vs `↑j + 1` (definitional by
`Nat.cast_add`) — write the RHS as `((↑(j+1):ℝ)^p)⁻¹` to match, then `exact_mod_cast`-free `rfl`.

**Then:** change the two landed monotonicity lemmas' `2 ≤ p1` to `1 < p1` (their `summable_phi`
witnesses become `summable_phi_gt_one`), close `threshold_u_range`'s three errors, then
`op5_threshold_asymptotic`.

### 13.166 LANDED (round 154): `summable_phi_gt_one`; `Phi_antitone`/`Phi_strictAnti` relaxed to `1 < p1`

`Op56/PhiThird.lean` now has **155 declarations** (0 sorries, 7/7 OK), newly:

```lean
lemma summable_phi_gt_one (p : ℝ) (n : ℕ) (hn : 1 ≤ n) (hp : 1 < p) :
    Summable (fun j : ℕ => (1 + (((j : ℝ) + 1) / (n : ℝ))) ^ (-p))
```

and the two monotonicity lemmas now take `(hp1 : 1 < p1)`.  The shift step closed with a `funext`
equality whose RHS spells `((↑(j+1) : ℝ)^p)⁻¹` (then `convert … using 1; ext j; simp only
[Nat.cast_add]; norm_num`); `Real.div_rpow` takes the numerator/denominator positivities
separately.

**Remaining for `threshold_u_range`:** in the `un ≤ 2` branch, `Phi_antitone` still needs
`1 < un`, which is not yet available.  **Better route (no `1 < un` needed):** a two-term lower
bound at `p ≤ 2` — `Phi_le_two_gt_one {n} (hn : 10 ≤ n) (p) (hp : p ≤ 2) : 1 < Phi p n` — via the
termwise `(1+(j+1)/n)^{-2} ≤ (1+(j+1)/n)^{-p}` (from `−2 ≤ −p`, `rpow_le_rpow_of_exponent_le`)
and the `hasSum_ite_eq` truncation comparison; the `Summable` of the `p`-summand comes from
`hthr : ∑' f = 1` — check the reverse direction `tsum_eq_hasSum`-style (`∑' f = a ↔ HasSum f a`)
or bound via the two-term `HasSum` directly with `hasSum_ite_eq`.

Then `op5_threshold_asymptotic`.

### 13.167 Round-155: the `un ≤ 2` branch is fully designed — inline truncation + threshold summability

No declaration landed (build green: 155 declarations, 0 sorries, 7/7 OK).

**Key: `tsum_eq_zero_of_not_summable (h : ¬Summable f) : ∑' f = 0`** exists — so the threshold
`hthr : Phi (u*n) n = 1` forces `Summable (fp)` by contradiction (`Phi = 0` vs `= 1`), giving the
summability witness the truncation comparison needs, **without** any `1 < un` bootstrap.

**The `hu_ge` branch, restructured (inline in `/tmp/w880.lean`):** under `un ≤ 2`,
1. `hsumm : Summable fp` from `hthr` via `tsum_eq_zero_of_not_summable`;
2. termwise `f2 j ≤ fp j` (`rpow_le_rpow_of_exponent_le` with `−2 ≤ −un`);
3. `1 < f2 0 + f2 1` — extract `Phi_two_gt_one'`'s `htwo` block as a standalone
   `first_two_terms_gt_one {n} (hn : 10 ≤ n) : 1 < (1+1/n)^{-2} + (1+2/n)^{-2}`;
4. the `hasSum_ite_eq 0/1` truncation + `Summable.tsum_le_tsum hge htr.summable hsumm` +
   `htr.tsum_eq` — giving `fp 0 + fp 1 ≤ Phi (u*n) n = 1` — contradiction with (3).
Then `2 < un`, `Phi_strictAnti` (with `1 < un` by `le_of_lt h2un`) gives
`Phi((1/2)n) < Phi(un) = 1`, contradicting the `u = 1/2` endpoint.

**Then:** `op5_threshold_asymptotic`.

### 13.168 **LANDED (round 156): `op5_threshold_asymptotic` — THE FIRST DELIVERABLE IS PROVED**

`Asymptotic.lean`'s `op5_threshold_asymptotic` now has a complete proof (no `sorry`): **7/7 OK,
0 axioms; the only remaining `sorry`s are the two untouched targets** (`op5_nmin_asymptotic`,
`op6_reachable_fraction`).

```lean
theorem op5_threshold_asymptotic (Pfun : ℕ → ℝ) (hP : ∀ n : ℕ, IsThreshold n (Pfun n)) :
    (fun n : ℕ => Pfun n - thresholdAsym n) =O[Filter.atTop]
      (fun n : ℕ => 1 / ((n : ℝ) + 1) ^ 2) := by …
```

**This proves OP-5's threshold form `P_n = (n + 3/2)log 2 + c/n + O(1/n²)` with the exact
`c = 3(log 2)² − (25/12)log 2`, matching the mpmath verification `(p* − asym)·n² ≈ −0.00323`.**

Also landed this round (5 lemmas): `first_two_terms_gt_one`, `exp_half_le_seven_fourths`,
`exp_half_inv_ge`, `exp_one_inv_le_three_fourths`, **`threshold_u_range`** — the range
`1/2 ≤ Pfun n/n ≤ 1` derived from the threshold alone (the `2 < un` bootstrap via the two-term
bound at `p ≤ 2` + `tsum_eq_zero_of_not_summable` from `hthr`).

Form notes: `IsBigO.of_bound` needs the `∀ᶠ x in l` form spelled with the **same** filter
(`Filter.atTop` qualified throughout — the unqualified `atTop` in the theorem statement caused
the `mp_mem` mismatch); the `abs_sub_le_iff` projections: `.1` = upper (`a − b ≤ c`), `.2` =
lower; `first_two_terms_gt_one`'s casts need `simpa only [Nat.cast_zero, Nat.cast_one]`.

**Remaining: `op5_nmin_asymptotic` (OP-5 index form — invert `thresholdAsym` via `nmin`) and
`op6_reachable_fraction` (OP-6 — the Census law `ζ(p,n_min) = z(p) n_min^{-p}`, `z(p) → 2`).**

### 13.169 Round-157/158: **the `IsComplete` ↔ threshold bridge is EXACT and elementary**

No declaration landed (build green: 160 declarations, 7/7 OK, 0 axioms).

**The bridge the two remaining targets need** (previously assumed deep in the file's
"PROOF OBSTRUCTION" comments) is a termwise identity:

`tailSum p N = Σ_{n ≥ N} (2(n+1))^{-p} = 2^{-p} Σ_{m ≥ N+1} m^{-p}`, so
`IsComplete p N ⟺ (N+1)^{-p} ≤ Σ_{m ≥ N+2} m^{-p} ⟺ 1 ≤ Σ_{m ≥ N+2} ((N+1)/m)^p`,
and with `n := N+1` and `m = n+j` the right side is exactly
`Φ_p(n) = Σ_{j≥1} (n/(n+j))^p`.  Hence

```lean
lemma IsComplete_iff (p N : ℕ) : IsComplete p N ↔ 1 ≤ Phi (p : ℝ) (N + 1)
```

— pure `tsum` reindexing plus `Real.rpow` algebra, **no Hurwitz/Euler–Maclaurin input**.

**Consequences for `op5_nmin_asymptotic`:** with `Phi_strictAnti` (landed, decreasing in `p`) and
`Phi p n` **increasing in `n`** (the `(1+j/n)^{-p}` termwise monotonicity, not yet landed):
`1 ≤ Φ_p(n) ⟺ p ≥ P_n` where `P_n` is the (unique) real threshold `Φ_{P_n}(n) = 1`; thus
`nmin p + 1 = min{n : P_n ≤ p}`.  So the index form reduces to (**a**) `Phi_mono_n` (antitone in
`n` for the `1/2 ≤ u ≤ 1`-scaled form), (**b**) existence/uniqueness of `P_n` by IVT on
`p ↦ Φ_p(n)` (continuous in `p` — needs `HasSum`/`continuousOn_tsum`), (**c**) `P_n` increasing
in `n`, (**d**) the inversion of the landed `P_n = (n+3/2)log2 + c/n + O(1/n²)`.

**Then `op6_reachable_fraction`** uses `census_measure_eq` (a `rfl` — `reachableMeasure p =
2^{nmin p}·tailSum p (nmin p)`) plus `budget p = 2^{-p}ζ(p)` and the same `nmin` asymptotics.

### 13.170 LANDED (round 159): **`IsComplete_iff`** — the exact Brown/threshold bridge

`Op56/PhiThird.lean` now has **161 declarations** (0 sorries, 7/7 OK, 0 axioms), newly:

```lean
lemma IsComplete_iff (p N : ℕ) : IsComplete p N ↔ 1 ≤ Phi (p : ℝ) (N + 1)
```

proved by scaling both sides of the Brown criterion by the positive `2^p (N+1)^p`:
`key0 : 2^p (N+1)^p · term p N = 1` and
`key n : 2^p (N+1)^p · term p (N+1+n) = (1 + (n+1)/(N+1))^{-p}`, then
`tsum_congr` + `mul_le_mul_iff_of_pos_left`.

**Form facts learned:** `Real.mul_rpow` consumes the `(x*y)^{z}` pattern, so a following
`Real.rpow_neg` on the same product has nothing left — split the `rw` list; `Real.rpow_neg hx p`
infers `x` from `hx`, so pass `(by norm_num : (0:ℝ) ≤ 2)` **literally** (passing `h2.le : 0 ≤ 2^p`
silently targets `(2^p)^{-p}`); `mul_le_mul_left` in this Mathlib is the **right**-multiplication
form (`b ≤ c → b*a ≤ c*a`) — the `↔` cancellation is `mul_le_mul_iff_of_pos_left`;
`↑(N+1)` vs `↑N + 1` needs `simp only [Nat.cast_add, Nat.cast_one]` at the end.

**Next: `Phi_mono_n`** — `Phi p n` is **increasing in `n`** (termwise `(1+j/n)^{-p}` increases as
`n` grows for `p > 0`), giving `1 ≤ Φ_p(n) ⟺ p ≥ P_n` with `P_n` the real threshold; then the
`nmin` identification and `op5_nmin_asymptotic`.

### 13.171 LANDED (round 160): `Phi_mono_n`

`Op56/PhiThird.lean` now has **162 declarations** (0 sorries, 7/7 OK), newly:

```lean
lemma Phi_mono_n (p : ℝ) (hp : 1 < p) (n m : ℕ) (hn : 1 ≤ n) (hnm : n ≤ m) :
    Phi p n ≤ Phi p m
```

(first-try, via `div_le_div_of_nonneg_left` + `Real.rpow_le_rpow_of_nonpos`.)

**Together with `IsComplete_iff`:** `IsComplete p N ↔ 1 ≤ Φ_p(N+1)`, and `Φ_p` is **increasing in n**
(landed) and **strictly decreasing in p** (`Phi_strictAnti`, landed).  So for each large `n` the
threshold is the unique `p` with `Φ_p(n) = 1`, and `nmin p + 1 = min{n : p ≥ P_n}`.

**The remaining analytic block for `op5_nmin_asymptotic`:**
1. **Existence** — `threshold_exists : ∀ᶠ n, ∃ p, IsThreshold n p`, i.e. `∃ p, Φ_p(n) = 1`, by
   IVT in `p`: `p ↦ Φ_p(n)` is continuous (`continuousOn_tsum` with a compact-interval domination —
   the summand `(1+(j+1)/n)^{-p}` is `ContinuousOn` in `p` and dominated by
   `(1+(j+1)/n)^{-p₀}` on `p ∈ [p₀, M]`), `Φ_p → ∞` as `p ↓ 1⁺` (divergence) and `Φ_p → 0` as
   `p → ∞` (each term `→ 0`, dominated by a summable bound on `[M, ∞)`).
2. **Uniqueness/monotonicity of `P_n`** — from `Phi_strictAnti` (in p) and `Phi_mono_n` (in n):
   `n ↦ P_n` is increasing.
3. **Inversion** — feed the (unique) `P_n` to `op5_threshold_asymptotic` (any threshold function works)
   to get `P_n = (n+3/2)log2 + c/n + O(1/n²)`, then invert: `n = P_n/log2 - 3/2 + O(1/P_n)`,
   giving `nmin p + 1 = p/log2 - 3/2 + O(1/p)`.

Then `op6_reachable_fraction` composes `census_measure_eq` (`rfl`) + `budget p = 2^{-p}ζ(p)` with
the same `nmin` asymptotics and `LAsym`.

### 13.172 LANDED (round 161): `Phi_two_ge_one` — the lower IVT endpoint

`Op56/PhiThird.lean` now has **163 declarations** (0 sorries, 7/7 OK), newly:

```lean
lemma Phi_two_ge_one {n : ℕ} (hn : 4 ≤ n) : 1 ≤ Phi 2 n
```

via `Summable.sum_le_tsum (Finset.range n)` with the termwise `(1+(j+1)/n)^{-2} ≥ 1/4` for
`j < n` (`div_le_one` + `Real.rpow_le_rpow_of_nonpos`, **base argument first** — it infers `y`
from `hxy`, and passing `(0 < 2)` mis-targets).

**Remaining for `threshold_exists`** (then the `nmin` inversion):
1. **upper endpoint** `Phi_two_mul_le_one : ∀ᶠ n, Phi (2*(n:ℝ)) n ≤ 1` — split at `j < n`:
   `(1+(j+1)/n)^{-2n} ≤ 2^{-(j+1)}` (from `log(1+x) ≥ x·(log 2)/2` for `x ≤ 1`) gives
   `Σ_{j<n} ≤ 1 - 2^{-n}`, and the tail `Σ_{j≥n}(1+(j+1)/n)^{-2n} ≤ 4^{-n}·2`-ish (each term
   `((j+1)/(2n))^{-2n}`-bounded); total `< 1`;
2. **continuity** `ContinuousOn (fun p => Phi p n) (Set.Icc 2 (2n))` via `continuousOn_tsum`
   (domination `(1+(j+1)/n)^{-p} ≤ (1+(j+1)/n)^{-2}`, summable by `summable_phi_gt_one`);
3. **IVT** (`intermediate_value_Icc` / `isPreconnected_Icc`) giving `∃ p ∈ [2, 2n], Φ_p(n) = 1`.

### 13.173 Round-162: the upper IVT endpoint — concrete strategy with room to spare

No declaration landed (build green: 163 declarations, 7/7 OK, 0 axioms).

**The upper endpoint** `Phi_four_mul_le_one : ∀ᶠ n, Phi (4*(n:ℝ)) n ≤ 1` (used with the landed
`Phi_two_ge_one` and IVT on `p ∈ [2, 4n]`), split at `j < n`:

* **`j < n`:** `x := (j+1)/n ≤ 1` and `log(1+x) ≥ x/2` (from
  `Real.log_le_sub_one_of_pos` at `1/(1+x)`: `log(1+x) ≥ 1 − 1/(1+x) = x/(1+x) ≥ x/2`), so
  `(1+x)^{4n} = e^{4n log(1+x)} ≥ e^{2(j+1)}`, i.e. the term `≤ e^{-2(j+1)}`; hence
  `Σ_{j<n} ≤ Σ_{j≥0} e^{-2(j+1)} = 1/(e²−1) ≤ 1/2`.
* **`j ≥ n`:** **Bernoulli** `(1+x)^m ≥ 1 + mx` gives `(1+(j+1)/n)^{4n} ≥ 1 + 4(j+1)`, so the term
  `≤ (1+4(j+1))^{-2} ≤ (4(j+1))^{-2}`; hence `Σ_{j≥n} ≤ (1/16)Σ_{j≥n}(j+1)^{-2} ≤ 1/32` for `n ≥ 3`
  (the `j^{-2}`-tail integral bound).
* **Total `≤ 1/2 + 1/32 < 1`** — strict room ✓.

**Needed sub-lemmas:** (a) `log(1+x) ≥ x/2` on `[0,1]` (`one_sub_inv_le_log`-style, from
`log_le_sub_one_of_pos`); (b) `(1+x)^{4n} ≥ e^{2(j+1)}` (`Real.rpow` ↔ `exp` via
`Real.rpow_def_of_pos` + `Real.exp_le_exp`); (c) `one_add_mul_le_pow` (Mathlib, Bernoulli);
(d) the `j^{-2}` tail bound `Σ_{j≥K}(j+1)^{-2} ≤ 2/K` (integral comparison, pattern:
`AntitoneOn.integral_le_tsum_comp_add`, already referenced in `PhiAsymptotic.lean`'s header).

**Then:** continuity in `p` (`continuousOn_tsum`, domination `(1+(j+1)/n)^{-2}`), IVT, and the
`nmin` inversion for `op5_nmin_asymptotic`.

### 13.174 **STRATEGIC PIVOT (round 163): the IVT route is unnecessary** — use the
unconditional third-order expansion

Landed this round: `log_one_add_ge_half_mul {x} (hx0 : 0 ≤ x) (hx1 : x ≤ 1) : x/2 ≤ Real.log (1+x)`
(via `Real.log_le_sub_one_of_pos` at `1/(1+x)` plus the identity `x/(1+x) = 1 − 1/(1+x)`).
The upper-endpoint plan of §13.173 is therefore *available* — but **no longer needed**:

**`Phi_third_order` has NO `IsThreshold` hypothesis** (confirmed at `PhiThird.lean:2717`) — it is a
genuine unconditional expansion
`Φ(u·n) = (e^u−1)^{-1} + uΦS(u)/(2n) + D(u)/n² + O(n^{-3})` for `u ∈ [1/2,1]`.

**Therefore `op5_nmin_asymptotic` needs no threshold existence, no continuity, no IVT, and no
p-series tail bounds.**  The route:

1. `IsComplete_iff` + `Phi_mono_n` (both landed) give
   `nmin p + 1 = min{n ≥ 1 : 1 ≤ Φ_p(n)}` — the set is an up-set;
2. evaluate the landed expansion at `u = p/n`: with
   `g(u) := (e^u−1)^{-1} − 1` (so `g(log2) = 0`, `g ≤ 1`-linear near `log2`) and the landed
   `PhiS`/`D` estimates,
   * `u ≤ log2 + 3log2/(2n) − K/n² ⟹ Φ_p(n) > 1`,
   * `u ≥ log2 + 3log2/(2n) + K/n² ⟹ Φ_p(n) < 1`;
3. monotonicity in `n` turns these into `nmin p + 1 = p/log2 − 3/2 + O(1/p)`.

**Only new ingredient:** a quadratic-remainder linearization of `u ↦ (e^u−1)^{-1}` at `log2`:
`(e^u−1)^{-1} − 1 = −2(u−log2) + O((u−log2)²)` (from `g(u) = (e^u−1)^{-1} − 1`, `g(log2) = 0`,
`g'(log2) = −(e^u−1)^{-2}e^u|_{log2} = −2`).  **Crossing check (do not lose the factor):**
`−2(u−log2) + uΦS(u)/(2n) = 0  ⟹  u − log2 = uΦS(u)/(4n) = 6log2/(4n) = 3log2/(2n)` ✓ — which
matches the landed threshold `u = log2 + 3log2/(2n) + O(1/n²)` exactly.  (A first draft wrote
`3log2/(4n)` here; the factor 2 from `g' = −2` against the `/2` in `uΦS/(2n)` cancels.)

**This is the same algebra as `threshold_third_order_uniform` (already in the kernel), run without
the threshold hypothesis — so the remaining work is bounded and reuses landed machinery.**

### 13.175 Round-164: `exp_threshold_linear` drafted — four errors

No declaration landed (build green: 164 declarations, 7/7 OK, 0 axioms).

`/tmp/w960.lean` has the whole linearization
`|(e^u−1)^{-1} − 1 + 2(u−log2)| ≤ 500(u−log2)²` for `u ∈ [1/2,1]`, plus its supporting
`exp_half_ge_eleven_twentieths : 11/20 ≤ e^{-1/2}` (via `log_one_add_ge_quartic` at `9/11`,
which gives `log(20/11) ≥ 0.554 ≥ 1/2`).  The route: `e^u = 2e^w` with `w = u − log2`, so
`(e^u−1)^{-1} − 1 = 2(1−e^w)/(2e^w−1)`; then `|1−e^w+2we^w−w| ≤ 20w²` from the landed
`exp_sub_one_sub_id_bound` (`|e^w−1−w| ≤ 3w²e^{|w|} ≤ 6w²` for `|w| ≤ 1/2`) and the
`e^w ≥ 11/20` denominator bound (`2e^w−1 ≥ 1/10`).

**Four errors remaining, diagnosed:**
1. **line 17** — `rw [h4]` then `h5`/`linarith`: "No goals to be solved" — the `rw [← Real.exp_neg]`
   inside `h4`'s proof may be closing more than intended; restructure `h4` as
   `Real.exp (-(1/2)) = (Real.exp (1/2))⁻¹` via `Real.exp_neg` + `inv_eq_of_mul_eq_one`-style, or
   just replace the whole lemma by `Real.exp_neg` + `inv_anti₀` in one step;
2. **line 30** — `hw12`'s `abs_le` construction: `w` is a `set`-local, so `linarith` needs
   `hw : w = u − Real.log 2` rewritten (use `subst w` or `rw [hw]`);
3. **line 43** — `hkey`'s `field_simp; ring` on the `2(1−e^w)/(2e^w−1) + 2w` identity: the
   denominator `2e^w−1` must be supplied as ≠ 0 (`ne_of_gt hb`);
4. **line 46** — the `rw [hkey, abs_mul, …]` pattern: `hkey`'s LHS has the division form; make the
   `rw` target match exactly (print the goal).

**Then:** the two window bounds and `op5_nmin_asymptotic`.

### 13.176 Round-165: `exp_threshold_linear` reduced to three errors

No declaration landed (build green: 164 declarations, 7/7 OK, 0 axioms).

`/tmp/w961.lean` now has `exp_half_ge_eleven_twentieths` **compiling** (as
`rw [Real.exp_neg, ← h4]; exact h3` after `inv_anti₀`) and the linearization down to three errors.
Fixed this round: `heu` needs `u = log2 + w` as a `have` before `Real.exp_add` (the inline `show`
rewrote the wrong side); `h11`'s associativity needs `ring`; `h10'` needs
`|2w²| = 2w²` (`abs_of_nonneg`), not `exact h10`; and `exp(1/2) ≤ 2` via
`Real.exp_le_exp.mpr log_two_ge_half` + `Real.exp_log` (not `Real.exp_one_lt_d9.le`, which is not
a rewrite rule).

**Three errors left (`/tmp/w961.lean`):**
1. **line 75** — `hnum`'s closing `linarith [h7, hbnd, h12, sq_nonneg w]`: supply the two summand
   bounds as an explicit `have` (`|w|·|e^w−1−w| ≤ (1/2)·6w² = 3w²` needs the product form, §13.121);
2. **line 77** — `hkey`'s `field_simp [ne_of_gt hdenpos]; ring`: the `ring` reports unsolved at
   column 77 — read the printed goal; may need `field_simp` then `ring_nf`;
3. **line 80** — the `rw [hkey, abs_mul, …]`: print the goal and match the pattern exactly.

**Then:** the two window bounds (`Φ_p(n) ≷ 1`) and `op5_nmin_asymptotic`.

### 13.177 Round-166: `exp_threshold_linear` down to three form-alignment errors

No declaration landed (build green: 164 declarations, 7/7 OK, 0 axioms).

The `hnum` proof was rewritten cleanly via the decomposition
`1 − e^w + 2we^w − w = (w² + wR − R) + (w² + wR)` with `R := e^w − 1 − w` and `|R| ≤ 6w²`
(landed `exp_sub_one_sub_id_bound`), giving `|num| ≤ 14w² ≤ 20w²`.  Two alignment facts fixed:
`a − b` vs `a + (−b)` are **different atoms to `linarith`** (needs an explicit `ring` rewrite); and
the sum step needs `abs_add_le X Y` supplied as a named `have`.

**Three errors left (`/tmp/w961.lean`):**
1. **line 88** — the `hnum` closing `linarith [h1, h2, hsum]`: all three hypotheses are present, so
   print the goal — the `rw [hC, hA, hB]` may have left a differently-bracketed sum
   (`X + Y` vs `(X) + (Y)`); align with one more `ring`-rewrite;
2. **line 90** — `hkey`'s `field_simp [ne_of_gt hdenpos]; ring` (unsolved at col 77): print the
   post-`field_simp` goal and finish with `ring_nf`, or use `div_add'` + `add_div`;
3. **line 95** — the `rw [hkey, abs_mul, …]`: match the pattern to the printed goal.

**Then:** the two window bounds (`Φ_p(n) ≷ 1`) and `op5_nmin_asymptotic`.

### 13.178 LANDED (round 167): `exp_half_ge_eleven_twentieths` + `exp_threshold_linear`

`Op56/PhiThird.lean` now has **166 declarations** (0 sorries, 7/7 OK, 0 axioms), newly:

```lean
lemma exp_half_ge_eleven_twentieths : (11/20:ℝ) ≤ Real.exp (-(1/2))
lemma exp_threshold_linear (u : ℝ) (hu1 : 1/2 ≤ u) (hu2 : u ≤ 1) :
    |(Real.exp u - 1)⁻¹ - 1 + 2*(u - Real.log 2)| ≤ 500 * (u - Real.log 2)^2
```

**A real sign error was caught by the kernel:** the intermediate identity had `(−2)·N/D` where the
correct coefficient is `+2` (`(e^u−1)^{-1} − 1 = 2(1−e^w)/(2e^w−1)` and
`2(1−e^w)/(2e^w−1) + 2w = 2N/(2e^w−1)` with `N = 1−e^w+2we^w−w`); with the wrong sign the
`field_simp` residual was `X = −X`, which is how it surfaced.

**The crossing (re-derived, consistent with §13.174):** `Φ(u·n) − 1 ≈ −2w + uΦS(u)/(2n)` with
`w = u − log2`, so `w = uΦS(u)/(4n) → 6log2/(4n) = 3log2/(2n)` at `u = log2` ✓.

**Remaining for `op5_nmin_asymptotic`:**
1. **`Phi_third_order_window`** — for `u ∈ [1/2,1]` and `n ≥ 2·10⁹`:
   * `u ≤ log2 + 3log2/(2n) − K/n² ⟹ 1 < Φ(u·n)`;
   * `u ≥ log2 + 3log2/(2n) + K/n² ⟹ Φ(u·n) < 1`.
   Assembled from `Phi_third_order` (unconditional), `exp_threshold_linear`,
   `PhiS_second_order_at_log2`, `PhiS_le_thirty`, `SThird_D_abs_le` — the same algebra as
   `threshold_third_order_uniform`'s Stage 2, without the threshold hypothesis.
2. **Transfer to `nmin`** — with `IsComplete_iff` and `Phi_mono_n`:
   `nmin p + 1 = min{n : 1 ≤ Φ_p(n)}`, and (1) at `u = p/n` gives
   `nmin p + 1 ∈ p/log2 − 3/2 + [−K/p, K/p]`, hence `nmin p = nminAsym p + O(1/p)` ✓.

Then `op6_reachable_fraction`.

### 13.179 Round-168: `Phi_window_low` drafted — six linarith errors to tune

No declaration landed (build green: 166 declarations, 7/7 OK, 0 axioms).

`/tmp/w970.lean` has the full low-window assembly
`u ≤ log2 + 3log2/(2n) − 10¹³/n² ⟹ 1 < Φ(u·n)` for `u ∈ [1/2,1]`, `n ≥ 2·10⁹`, decomposing
`Φ(u·n) − 1 = g(u) + (−2w + uΦS(u)/(2n)) + D/n² + E` with `w = u − log2`, bounded by
`exp_threshold_linear` (`|g| ≤ 500w² ≤ 8000/n²` via `|w| ≤ 4/n`),
`PhiS_second_order_at_log2` (`uΦS(u) ≥ log2(6 − 26w − 10¹⁶w²)`, then
`≥ 3log2/n − 100/n²`), `SThird_D_abs_le` (`|D| ≤ 4·10¹⁰`) and `Phi_third_order`
(`|E| ≤ 10¹²/n³`); the total `≥ (2·10¹³ − 25 − 8000 − 4·10¹⁰ − 10¹²)/n² > 0` ✓.

**Note: there is no standalone `PhiS_nonneg`** — nonnegativity is inlined in the file as
`rw [PhiS]; exact tsum_nonneg (fun k => by positivity)`.

**Six linarith errors (lines 29, 41, 53, 55, 56, 57)** — all of the §13.121 class: each is a
product/division step where the needed fact must be a typed `have` (notably `|w| ≤ 4/n`
from `hlog1 : log2 ≤ 1`, the `uΦS` two-factor split, and the `> 0` numerator comparison).

**Then the symmetric `Phi_window_high` (`Φ < 1`), then the transfer to `nmin` via
`IsComplete_iff` + `Phi_mono_n`.**

### 13.180 Round-169: `Phi_window_low` — a **missing hypothesis** found; six errors → five

No declaration landed (build green: 166 declarations, 7/7 OK, 0 axioms).

**A real statement defect found:** the lemma as drafted claimed `|w| ≤ 4/n` from the one-sided
`w ≤ 3log2/(2n) − 10¹³/n²`, which is **false** — `w = u − log2` can be as negative as
`1/2 − log2 ≈ −0.19` (at `u = 1/2`), so `|w| ≤ 4/n` needs `u` near `log2`.  The fix is to take
`(hwabs : |u − Real.log 2| ≤ 4/(n:ℝ))` as a **hypothesis** (the caller supplies it when
evaluating near `p/log2`, exactly as §13.121's "missing multiplicative hypothesis" recommends);
`hw4` then follows by rewriting `w`.  Without it the `|g| ≤ 500w²` term is `≤ 125`, not
`≤ 8000/n²`, and the whole lower bound collapses — so this would have been a silently wrong proof.

**Two fixes applied:** `hq` needs `(4/n)² = 16/n²` as a named `have` before `nlinarith`; `hD'`'s
`rw [abs_div]` must be split from `abs_of_pos` (one rewrite per `rw`).

**Five errors left (`/tmp/w970.lean`):** line 33 (`hq`: `rw [h1b] at h1; nlinarith [h1]`),
lines 45–49 (`hcross`: the `uΦS` two-factor split and the `26w + 10¹⁶w²` bound need typed
`have`s), line 61 (`hD'`: restate as `|D|/n² ≤ 4·10¹⁰/n²` via `div_le_div_of_nonneg_right hD`
and align with `abs_div` at the use site).

**Then:** `Phi_window_high`, the `nmin` transfer, `op5_nmin_asymptotic`.

### 13.181 Round-170: the `hcross` margin must keep the `(6−26log2)w` term — use K = 10¹⁹

No declaration landed (build green: 166 declarations, 7/7 OK, 0 axioms).

**A margin subtlety found while tuning `hcross`.**  The lower bound
`−2w + uΦS(u)/(2n) ≥ 2K/n² − 25/n²` needs the **exact** first-order term of `uΦS(u)`:
writing `u = log2 + w` and `ΦS(u) = 6 − 26w + R` with `|R| ≤ 10¹⁶w²`,

`uΦS(u) = 6log2 + (6 − 26log2)w − 26w² + (log2 + w)R`.

Replacing `(6 − 26log2)w` by `−26w` (a `6w` slack) is **not** harmless: `w = O(1/n)`, so that
slack is exactly `O(1/n)` and its `/(2n)` contribution is `O(1/n²)` — the very order being
resolved.  With the exact term, `|(6−26log2)w/(2n)| ≤ 26/n²` and
`(26 + 2·10¹⁶)w²/n ≤ 2·10¹⁸/n³`.

**Constant choice:** take **`K = 10¹⁹`** in the window hypothesis, so every `1/n³` error
(`≤ 2·10¹⁸/n³ ≤ 2·10¹⁸/n²` for `n ≥ 1`) is absorbed at `1/n²` level with the `|g| ≤ 8000/n²` and
`|D| ≤ 4·10¹⁰/n²` terms, leaving margin `10¹⁹ − 2·10¹⁸ − 4·10¹⁰ > 0` ✓.

**Fixes still to apply in `/tmp/w970.lean`:** `hq` (`rw [h1b] at h1; nlinarith [h1]`), `hcross`
exact-term form as above, `hD'` restated as `|D|/n² ≤ 4·10¹⁰/n²` (align `abs_div` at the use
site), and the hypothesis constant changed to `10^19`.

**Then:** `Phi_window_high`, the `nmin` transfer, `op5_nmin_asymptotic`.

### 13.182 Round-171: `Phi_window_low` restructured with K = 10¹⁹ — seven errors

No declaration landed (build green: 166 declarations, 7/7 OK, 0 axioms).

`/tmp/w971.lean` is the restructured assembly: hypothesis constant `10^19`, the crossing term
`hcross` proved with the **exact** `(6 − 26log2)w` coefficient (`hlog_abs : |6 − 26log2| ≤ 20`,
`huPhiS` via `mul_le_mul` with both factors' nonnegativity), `hD'` restated as the `|D|/n²` form,
and the final margin `10¹⁹ − 8000 − 4·10¹⁰ − 10¹² > 0`.

**Seven errors remaining (`/tmp/w971.lean`):**
1. **line 21/28** — `rw [hwset]` in `hwle`: the `set`-equation is `hwset : w = u − log2`, so the
   rewrite direction is right but `linarith` does not see through it — use `subst`/`omega`-free
   `rw [hwset] at hw ⊢` or state `hwle` via `hwset ▸ hw`;
2. **line 37** — `hq`'s closing: the `h1b` alignment is a no-op; use
   `nlinarith [hw2, sq_nonneg w]` after `field_simp`-clearing the `1/n²`;
3. **line 48** — `h3`'s `mul_le_mul h1 hPSb h4 h7`: `h1 : u ≥ log2 + w` is the **wrong
   direction** for `mul_le_mul`'s first argument (needs `≤`); flip to
   `mul_le_mul_of_nonneg_right`/`_left` as appropriate;
4. **line 54** — `h8`'s `nlinarith`: expand `(log2+w)(6−26w−10¹⁶w²)` with `ring_nf` first;
5. **line 56** — `hcross`'s `h2`: the `div_le_iff₀` argument form — check the printed goal;
6. **lines 65, 70** — the two `rw` patterns (`h19`/`hwset` alignment) — print and match.

**This lemma has now consumed four rounds**; the errors remain of the recorded classes (direction,
association, atom identity) with two genuine defects already caught (the false `|w|` bound in
§13.180 and the lost `O(1/n²)` term in §13.181), which is the reason it is worth finishing
carefully rather than quickly.

### 13.183 Round-172: an unresolved `linarith` puzzle in `Phi_window_low`

No declaration landed (build green: 166 declarations, 7/7 OK, 0 axioms).

Six errors remain.  **One is genuinely puzzling and worth recording rather than guessing past:**
`hwle`'s step

```lean
have h' : u - Real.log 2 ≤ 3*Real.log 2/(2*(n:ℝ)) - 10^19/((n:ℝ)^2) := by linarith [hw]
```

fails, where `hw : u ≤ Real.log 2 + 3*Real.log 2/(2*(n:ℝ)) - 10^19/((n:ℝ)^2)` — a plainly
linear deduction.  The context printed by Lean shows exactly these two statements, so the
failure cannot be a missing hypothesis; the likely causes are (i) an atom mismatch between the
two `10^19 / ↑n^2` instances (rewrite the bound as a single `c := 3*log2/(2*n) - 10^19/n²` local
via `set` so both sides share it), or (ii) `Real.log 2` occurring under different transparent
wrappers in the two terms.  **Next action: introduce the combined local `c` and re-run — do not
re-tune the numerics.**

**The other five errors** are the previously listed direction/`mul_le_mul` (line 57), `h8`
`ring_nf` (line 55), and the three `rw`-pattern/`div_le_iff₀` alignment issues (lines 38, 49, 66).

**Note for the next session:** this lemma has now taken five rounds of *pure plumbing* on top of
correct mathematics (two real defects already caught and fixed).  If the `c`-local restructure does
not clear it in one round, the pragmatic alternative is to state the window lemma with the window
**hypothesis already normalised** — i.e. take `(hw' : u ≤ Real.log 2 + c/n - K/n²)` with `c`
opaque — since that is the only form the `nmin` transfer consumes.

### 13.184 **DIAGNOSIS (round 173): `linarith` is drowning in the context — use `linarith only [...]` with the right hypotheses**

The §13.183 puzzle is solved.  The isolated test

```lean
example (u n : ℝ) (hw : u ≤ Real.log 2 + 3*Real.log 2/(2*n) - 10^19/(n^2)) :
    u - Real.log 2 ≤ 3*Real.log 2/(2*n) - 10^19/(n^2) := by linarith [hw]
```

**passes**, while the same step fails inside `Phi_window_low`.  The cause is not the mathematics but
the **context**: the lemma's context carries `hPhi` (`Phi`), `hlin` (`Real.exp`), `hPS` (`PhiS`),
`hD` (`PhiK3u`/`PhiK4u`) and `sb` (`Nat.sqrt`), and `linarith`'s preprocessing of the full context
fails there.  **Rule: in this lemma, every `linarith`/`nlinarith` must be written
`linarith only [<the exact hypotheses needed>]`** — and, critically, the `only` list must contain
the *right* hypotheses: a first attempt wrote `nlinarith only [hn1]` for `4/n ≤ 1/2`, which
dropped the needed `hn`, and failed for the opposite reason (add `hn8 : 8 ≤ n` via `omega`).

**Current state (`/tmp/w971.lean`, six errors):** line 39 (`hq`: add `hnR` to the `only` list),
line 50 (`h3`'s `mul_le_mul` — a **direction** error: `h1 : u ≥ log2 + w`), line 56 (`h8`: try
`ring_nf` then `nlinarith only [...]`), line 58 (`h2`'s `div_le_iff₀` argument form), lines 62
and 67 (the two `rw` patterns).

**This is the round's real product:** the plumbing is not mysterious, it is context-induced, and
the fix is mechanical once written down.  Expect the remaining six to clear quickly now.

### 13.185 Round-174: `Phi_window_low` — `linarith only` applied, five errors left

No declaration landed (build green: 166 declarations, 7/7 OK, 0 axioms).

The §13.184 rule is now applied throughout: **every** `linarith`/`nlinarith` in the lemma carries an
explicit `only [...]` list, and several steps were additionally de-`linarith`-ed entirely
(`hq` via `mul_le_mul_of_nonneg_left` + `ring`; `h1` of `hcross` via the explicit
`hid : 2*(3log2/(2n)) = 3log2/n`).  The `mul_le_mul` **direction error** at `h3` is fixed
(`h1 : Real.log 2 + w ≤ u`, with `h4b : 0 ≤ u` in the 4th slot).

**Five errors left (`/tmp/w971.lean`):** line 58 (`h6`'s `sq_le_sq'` argument type),
line 60 (`h4`'s `linarith only [h5, h6]`), line 70 (`hcross`'s `h2`: a `No goals to be solved`,
i.e. a preceding tactic already closed it — drop the trailing step), line 71 (the same block's
`linarith only`), line 74 (`hD'`'s `rw [abs_div]` pattern).

**Rate note (for honest planning):** this single window lemma has now taken six rounds.  It has
yielded three real defects (false `|w|` bound, lost `O(1/n²)` term, wrong `mul_le_mul` direction)
and one systemic diagnosis (context-induced `linarith` failure).  The remaining work after it is
its mirror `Phi_window_high`, the `nmin` transfer, and `op6_reachable_fraction` — so the
projection is tens of rounds, not a handful, and I am not revising it down again until landing is
observed rather than inferred.

### 13.186 Round-175: `Phi_window_low` — `h4`'s bound was **false as written**; five errors left

No declaration landed (build green: 166 declarations, 7/7 OK, 0 axioms).

**Another real defect caught:** `h4 : 0 ≤ 6 − 26w − 10¹⁶w²` was derived from `w ≤ 1/2`, but at
`w = 1/2` the expression is `6 − 13 − 2.5·10¹⁵ < 0` — **false**.  The correct bounds are the
window ones (`|w| ≤ 4/n`): `26w ≤ 104/n ≤ 2` and `10¹⁶w² ≤ 1.6·10¹⁷/n² ≤ 1`, giving
`≥ 6 − 2 − 1 = 3 > 0`.  This is the third false statement caught in this lemma (after the `|w|`
bound and the `mul_le_mul` direction) — the pattern is that the *window* hypotheses must be used
everywhere, never the loose `w ≤ 1/2`.

Also fixed: the two product-division rewrites (`26·(4/n)` and `10¹⁶·(16/n²)` are products, so
`div_le_iff₀` needs a preceding `show … = 104/n` / `= (16·10¹⁶)/n²`), and the strong bound
`hn2e9 : 2000000000 ≤ n` (using `hn1 : 1 ≤ n` silently failed to prove `104/n ≤ 2`).

**Five errors left (`/tmp/w971.lean`):** lines 78–79 (`h2`'s `rw [ge_iff_le, div_le_iff₀ h3]`
reports *No goals to be solved*, i.e. a step already closed the goal — split the `rw` and inspect),
82 (`hcross`'s `h4`); 97 (the final `linarith only`); 122 (`hD''`'s `abs_le.mp`/`h19` argument).

**Then:** `Phi_window_high`, the `nmin` transfer, `op5_nmin_asymptotic`.

### 13.187 Round-176: **structural fix confirmed** — extract the arithmetic into a small-context lemma

No declaration landed (build green: 166 declarations, 7/7 OK, 0 axioms).

The §13.184 diagnosis is now acted on: `/tmp/w991.lean` extracts

```lean
private lemma window_arith (n : ℕ) (hn : 2000000000 ≤ n) (A B C : ℝ)
    (hA : -(8000/((n:ℝ)^2)) ≤ A)
    (hB : -3*log2/n + 2*10^19/n² + (3*log2/n - 25/n² - 2*10^17/n³) ≤ B)
    (hC : -(4*10^10/((n:ℝ)^2)) ≤ C) :
    (0:ℝ) < A + B + C - 10^12/((n:ℝ)^3)
```

**and it compiles on the first try** — with only `n`, `hn`, `A`, `B`, `C` in context, every
`linarith only`/`nlinarith only` step succeeds, exactly as the isolated experiment predicted.
`Phi_window_low` is then assembled around it: three bound derivations (`hA` from
`exp_threshold_linear`, `hB` from `hwle` + `huPhiS`, `hC` from `SThird_D_abs_le`) plus the
`window_arith` call.  **This is the right shape and the strategy is validated.**

**Six errors remain in the bound derivations** (`/tmp/w991.lean`, lines 91, 92, 130, 136, 139, 141):
1. **lines 91–92** — `h2`'s `rw [ge_iff_le, le_div_iff₀ h3]` and its `nlinarith`: simplifies to
   `rw [ge_iff_le, le_div_iff₀ h3]` then a chain of `div`-clears; better: split `h2` into the
   `huPhiS/(2n)` division step (`div_le_div_of_nonneg_right huPhiS`) plus a separate
   `(6−26log2)w/(2n) ≥ -40/n²` fact — **note the constant must be `-50/n²`, not `-25/n²`**
   (`20·(4/n)/(2n) = 40/n²`), so change `window_arith`'s `hB` hypothesis accordingly (the margin
   `2·10¹⁹ − 8000 − 50 − 4·10¹⁰ − 2·10¹⁷ − 10¹² > 0` is unaffected);
2. **line 130** — `h8b`'s `div_le_div_iff₀` argument types (both denominators as `0 < n²`);
3. **lines 136, 139** — the `show …= 80/n`/`= (16·10¹⁶)/n²` rewrites (make the LHS match the
   goal verbatim);
4. **line 141** — a `ring_nf; positivity` that is not a positivity goal — replace with
   `field_simp; ring` on the explicit identity.

**Then:** `Phi_window_high`, the `nmin` transfer, `op5_nmin_asymptotic`.

### 13.188 Round-177: `window_arith` gives the constant; `h2` still resists

No declaration landed (build green: 166 declarations, 7/7 OK, 0 axioms).

`window_arith` now carries the loosened `-50/n²` constant **and compiles**; the `hB` statement and
`h2`'s conclusion were aligned to it.  `h2` was rewritten as a clean split —
`hdiv` (`div_le_div_of_nonneg_right huPhiS`) plus three separate facts `e1` (the `3log2/n` term),
`e2` (`≥ -40/n²` via `|6−26log2| ≤ 20` and `|w| ≤ 4/n`) and `e3`
(`≤ 2·10¹⁷/n³` via `hw2`), combined by `linarith only`.

**Five errors left (`/tmp/w991.lean`):** lines 91–92 (`hB`'s closing `linarith only [h1, h2]`, and
line 91:83 "*No goals to be solved*" — a step inside `h2` already closed its goal, so one of the
`rw [ge_iff_le, le_div_iff₀ h3]` steps in `e2`/`e3` is redundant); line 139 (`h8b`'s
`div_le_div_iff₀` argument types); lines 154, 157 (the final `hkey`/`hfin` `linarith only` chain,
which must be checked against `window_arith`'s exact conclusion).

**Then:** `Phi_window_high` (the mirror, which will reuse `window_arith` with reversed signs),
the `nmin` transfer, `op5_nmin_asymptotic`.

### 13.189 Round-177 (cont.): `hid` fixed; five errors remain

No declaration landed (build green: 166 declarations, 7/7 OK, 0 axioms).

`hid : 2*(3log2/(2n)) = 3log2/n` now closes with `field_simp [ne_of_gt hnR]` alone (adding `; ring`
gives "No goals to be solved" — `field_simp` already finishes it, and that was the line-91 puzzle).

**Five errors left (`/tmp/w991.lean`):** line 93 (`h1`'s `linarith only [hwle, hid]` — the
`-2w ≥ …` step; if it will not go, expand `hwle` by hand into
`-2*w ≥ -2*(3log2/(2n)) + 2·10¹⁹/n²` as a named `have` first), line 140 (`h8b`'s
`div_le_div_iff₀` argument types), lines 155/158/159 (the `hkey`/`hfin` chain against
`window_arith`'s exact conclusion).

**Standing plan:** `Phi_window_high` (mirror, reusing `window_arith`), the `nmin` transfer,
`op5_nmin_asymptotic`, then `op6_reachable_fraction`.

### 13.190 Round-178: **all-`1/n²` rewrite** — `/tmp/w992.lean`, five errors

No declaration landed (build green: 166 declarations, 7/7 OK, 0 axioms).

**Decisive simplification:** every `1/n³` term was pushed to `1/n²` (legal since `n ≥ 1`):
`window_arith`'s `hB` now uses `-2·10¹⁷/n²` and the conclusion `-(10¹²/n²)`; `e3`'s bound and
`hE'` likewise.  This **deletes all the `n³`/`div_le_div_iff₀`-on-cubes machinery** — the
numerator is `2·10¹⁹ − 8000 − 50 − 4·10¹⁰ − 2·10¹⁷ − 10¹² > 0` ✓ — and `window_arith` compiles
with just three `1/n²` steps (`hval`, `hnum` via `div_pos`+`norm_num`, `heq` via
`field_simp; ring`).  The file is ~10 lines shorter and the arithmetic is homogeneous.

**Five errors left (`/tmp/w992.lean`):** 144 (`e2`'s closing `linarith only [h8a, h8c]` after
`rw [ge_iff_le, le_div_iff₀ h3]` — try `nlinarith only`), 149 (`field_simp; ring` on the
`h11` or `e1` identity reports *No goals* — split the `field_simp`), 152/154 (`e3`'s `h9`/`h10`
chain), and 163 — **diagnosed**: `abs_le.mp hD'` is applied to `|D|/n² ≤ 4·10¹⁰/n²`, which has no
outer `|·|`; the fix is `h20 : -(4·10¹⁰/n²) ≤ -(|D|/n²)` from `hD'` by `linarith only`, then
`h21 : -(|D|/n²) ≤ D/n²` via `neg_abs_le` after `rw [← habs]`.

**Then:** `Phi_window_high`, the `nmin` transfer, `op5_nmin_asymptotic`.

### 13.191 Round-179: `Phi_window_low` down to **ONE error**

No declaration landed (build green: 166 declarations, 7/7 OK, 0 axioms).

Cleared this round: `hC` via `neg_abs_le` (`h20` from `hD'` by `linarith only`, then
`h21 : -(|D|/n²) ≤ D/n²` after `rw [← habs]`); `e1`/`h10`'s `field_simp`/`ring` pairing (**`e1` needs
the `ring`, `h10` does not** — the two were swapped last round); `e2` with `nlinarith only`; `e3`
rewritten as `h9`/`h10`/`h11` with `le_trans h9 h11` (a *transitivity*, not a `linarith`).

**One error left (`/tmp/w992.lean:151`):** the `h2` closing step
`linarith only [hdiv, e1, e2, e3]` — the goal
`u*PhiS u/(2n) ≥ 3log2/n − 50/n² − 2·10¹⁷/n²` from `hdiv` (the `huPhiS` division),
`e1 : (6log2)/(2n) = 3log2/n`, `e2 : (6−26log2)w/(2n) ≥ -40/n²`,
`e3 : (26+2·10¹⁶)w²/(2n) ≤ 2·10¹⁷/n²`.  All the content is there, so this is the
association/atom-identity class again: **align `hdiv`'s `a + b - c` with the goal's form via an
explicit `have hsplit2 : … = … := by ring` and then `linarith only`** (or restate `hdiv`'s
right-hand side with the same bracketing as `e1 + e2 - e3`).

**Then:** once this clears, `Phi_window_low` is a declaration — the first landing in eleven rounds —
and `Phi_window_high` (mirror) plus the `nmin` transfer follow.

### 13.192 Round-179 (cont.): a **`linarith` division-form discovery** — `1/(n^2)` ≠ `(n^2)⁻¹` for the tactic

No declaration landed (build green: 166 declarations, 7/7 OK, 0 axioms).

`Phi_window_low` is at **one error**: the `h2` closing step, now isolated into
`hsum_arith` (a lemma with only `n, X, Y, Z, h1, h2, h3` in context — so *not* context bloat).
Bisection produced a genuine, reusable discovery:

* `example (hA : 0 < ((n)²)⁻¹) (h2 : Y ≥ -40*((n)²)⁻¹) … : Y - Z ≥ -50*((n)²)⁻¹ - …` **passes**;
* the same with `1/((n)²)` written as a **division literal** for `hA` **fails**.

So `linarith` does *not* treat `1/((n:ℝ)^2)` and `((n:ℝ)^2)⁻¹` as one atom, and it also cannot
derive `0 < 1/n²` from `0 < n²` (needs the inversion fact).  **Rule: in `linarith`-fed statements,
write every reciprocal in the `*((n)²)⁻¹` form (or make both sides syntactically identical), and
supply `0 < (n²)⁻¹` explicitly.**  Consequence: the `-50/n²` vs `-40/n²` comparison was removed by
making the goal's constant **exactly** `e2`'s (`-40/n²`) — `window_arith`'s `hB`/`hval`/`hnum`
were updated accordingly (numerator `2·10¹⁹ − 8000 − 40 − 4·10¹⁰ − 2·10¹⁷ − 10¹² > 0`).

**Remaining single error (`/tmp/w992.lean:36`):** `hsum_arith`'s
`linarith only [h1, h2, h3]` on `X + Y - Z ≥ 3log2/n − 40/n² − 2·10¹⁷/n²` — the goal is an *exact*
transposition of `h1` (`X = 3log2/n`), `h2` (`Y ≥ -40/n²`), `h3` (`Z ≤ 2·10¹⁷/n²`), so this should
close; the next step is the same reduction applied once more (rewrite all three hypotheses into
`*((n:ℝ)^2)⁻¹` form with a `ring_nf`-normalised restatement, then `linarith only`), or simply
`linarith` with the hypotheses destructured.

**This is the last step before the first landing in twelve rounds.**

### 13.193 Round-180: `hsum_arith` — two errors, both in the `neg_div` normalisation

No declaration landed (build green: 166 declarations, 7/7 OK, 0 axioms).

**The §13.192 discovery is now fully confirmed and is the key to this file's remaining plumbing:**
Lean parses `-40 / x` as `(-40) / x`, **not** as `-(40 / x)`; `Real.neg_div : -a / b = -(a / b)` is a
*lemma*, so the two are not interchangeable for `linarith` (which treats each division term as its
own atom).  Fixes applied: `hsum_arith`'s `h2` is now stated as `-(40/((n:ℝ)^2)) ≤ Y` and its
conclusion derived by `sub_le_sub` + `add_le_add_left` (**no `linarith` on the main step at all**);
the call site derives `e2' : -(40/((n:ℝ)^2)) ≤ …` by `rw [← neg_div]` (the **reverse** direction —
`neg_div`'s pattern is `-a/b`, which does *not* occur in `-(40/n²)`).

**Two errors left (`/tmp/w992.lean`):**
1. **line 40** — the final `simpa only [hgoal] using hsub` (Type mismatch): `hgoal` rewrites the
   explicit `3log2/n + (-(40/n²) - 2·10¹⁷/n²)` to the goal's `3log2/n - 40/n² - 2·10¹⁷/n²`; if
   `simpa` will not align, use `rw [hgoal] at hsub; exact hsub`, or drop `hgoal` and state
   `hsum_arith`'s conclusion in the **explicit** form (the caller can `linarith`/`ring` once);
2. **line 169** — `e3'`'s `linarith only [e3]` (the `-((26+2·10¹⁶)w²/(2n)) ≥ -2·10¹⁷/n²` step from
   `e3`) — same class: negate `e3` explicitly or restate in the `-(…)` form.

**Pragmatic alternative if these two do not clear in one more round:** state `hsum_arith`'s
conclusion in the **exact syntactic form** of `hdiv`'s right-hand side (so only `e1`/`e2`/`e3` and a
single `le_trans` are needed), and let the caller do the final `ring` — this removes the last two
syntactic-alignment steps entirely.

### 13.194 **LANDED (round 181): `window_arith` + `Phi_window_low`** — the window bound is proved

`Op56/PhiThird.lean` now has **168 declarations** (0 sorries, 7/7 OK, 0 axioms), newly:

```lean
private lemma window_arith (n : ℕ) (hn : 2000000000 ≤ n) (A B C : ℝ)
    (hA : -(8000/((n:ℝ)^2)) ≤ A)
    (hB : -3*log2/n + 2*10^19/n² + (3*log2/n - 40/n² - 2*10^17/n²) ≤ B)
    (hC : -(4*10^10/((n:ℝ)^2)) ≤ C) :
    (0:ℝ) < A + B + C - 10^12/((n:ℝ)^2)

lemma Phi_window_low (u : ℝ) (n : ℕ) (hu1 : 1/2 ≤ u) (hu2 : u ≤ 1) (hn : 2000000000 ≤ n)
    (hwabs : |u - Real.log 2| ≤ 4/(n:ℝ))
    (hw : u ≤ Real.log 2 + 3*Real.log 2/(2*(n:ℝ)) - 10^19/((n:ℝ)^2)) :
    1 < Phi (u*(n:ℝ)) n
```

**The winning move** was the one recorded as the pragmatic alternative: **drop `linarith` and
`neg_div` from the main step entirely** and build it from ordered lemmas —
`sub_le_sub` for `Y − Z`, `neg_le_neg` for the third term, `add_le_add`/`add_le_add_left` to
assemble, `le_trans` against `hdiv`, and a single `ring`-rw (`hA`) to normalise
`3log2/n − 40/n² − 2·10¹⁷/n²` into the `a + (-b) + (-c)` form.  **Every one of the errors that
consumed rounds 168–180 was a division-form / association issue inside `linarith`; removing
`linarith` from that step resolved the lemma immediately.**

**Lessons (all now in the recurring rules, and all cost multiple rounds to learn):**
1. `linarith` treats each `a/b` as a distinct atom; `(-40)/x` and `-(40/x)` are **not** the same
   term (`Real.neg_div` is a lemma, not defeq);
2. `linarith` in a large context (with `Phi`/`exp`/`PhiS`/`sqrt` present) can fail where the same
   step succeeds in isolation — **isolate the arithmetic into a small-context lemma**;
3. ordered lemmas (`sub_le_sub`, `add_le_add`, `neg_le_neg`, `le_trans`) are **more robust than
   `linarith`** for combining heterogeneous inequalities;
4. `field_simp` sometimes closes its goal, so a following `ring` errors with "No goals to be
   solved" — check before appending.

**Next: `Phi_window_high`** — the mirror (`Φ(u·n) < 1` for `u ≥ log2 + 3log2/(2n) + 10¹⁹/n²`),
which reuses `window_arith` with the signs reversed, then the `nmin` transfer.

### 13.195 **LANDED (round 182): `window_arith_high`** — 169 declarations

`Op56/PhiThird.lean` now has **169 declarations** (0 sorries, 7/7 OK, 0 axioms), newly:

```lean
private lemma window_arith_high (n : ℕ) (hn : 2000000000 ≤ n) (A B C : ℝ)
    (hA : A ≤ 8000/((n:ℝ)^2))
    (hB : B ≤ -3*log2/n - 2*10^19/n² + (3*log2/n + 50/n² + 3*10^17/n²))
    (hC : C ≤ 4*10^10/((n:ℝ)^2)) :
    A + B + C + 10^12/((n:ℝ)^2) < 0
```

— first try, by the ordered-lemma recipe (`add_le_add` chain, `field_simp; ring` for the
integration, `div_neg_of_neg_of_pos` + `norm_num` for the sign).  Numerator
`8000 + 50 + 3·10¹⁷ + 4·10¹⁰ + 10¹² − 2·10¹⁹ < 0` ✓.

`Phi_window_high` is drafted in `/tmp/w1000.lean` with **six errors** (lines 61, 101, 106, 139, 157,
158).  The mirror structure is in place: `hA` from `hlin`'s `.2`, `hB` from `hwge` + the `uΦS`
**upper** bound via `mul_le_mul le_rfl hPSb h6 hwpos` (using `u = log2 + w` **exactly**, so the
`6log2` term is retained — the crude `1·ΦS` bound loses the `log2` factor and leaves an
unabsorbable `O(1/n)` term: **do not use it**), `hC` from `hD` via `le_abs_self`, and `hE'` from
`hE`'s `.2`.  The six errors are the usual alignment/direction class, plus line 101 (`h6`'s
`nlinarith` — the `26w ≤ 6` bound) and 157/158 (`e2b`'s `show … = 40/n²` rewrite).

**Then the `nmin` transfer.**

### 13.196 Round-183: `Phi_window_high` down to ONE error

No declaration landed (build green: **169 declarations**, 7/7 OK, 0 axioms — `window_arith_high`
from §13.195 is in the file).

Cleared this round: `hwpos` (needs `4/n ≤ 1/2` supplied **explicitly** — `linarith` cannot relate
`4/n` to `4/2·10⁹` from `n ≥ 2·10⁹` alone, the division-atom issue again); `h3`
(`mul_le_mul_of_nonneg_left hPSb hwpos`, **not** `mul_le_mul` — the latter's `c ≤ d` slot wants the
opposite direction); `h8` (needs **both** `w ≥ -1/2` and `w ≤ 1/2` for the `1e16w³` term); `h9`
(clear `(16/n²)·n²` with an explicit `field_simp` `show` before `nlinarith`); `e2b` (proved as
`40·(1/n²) ≤ 50·(1/n²)` from `0 < 1/n²` explicitly — avoids the `40/n² ≤ 50/n²` atom problem).

**One error left (`/tmp/w1000.lean:168`, col 46):** the final
`le_trans (le_trans hdiv (le_of_eq hsplit)) hfin`.  `hdiv`'s RHS and `hsplit`'s LHS are *both*
`(6log2 + (6−26log2)w + (16·10¹⁶+26)w²)/(2n)` (confirmed in the printed types), yet Lean reports an
expected-type mismatch for `hsplit` — so the residual is an association difference inside that
common term (the `hsplit` identity was produced by `ring` from the three-term form).  **Next action:
replace the `le_of_eq hsplit` step with `le_of_eq hsplit` applied to a freshly `ring`-normalised
copy, or simply do `rw [hsplit] at hdiv` and then `exact le_trans hdiv hfin`.**

**Then the `nmin` transfer.**  With both window lemmas landed, the transfer is: `IsComplete_iff` +
`Phi_mono_n` give `nmin p + 1 = min{n ≥ 1 : 1 ≤ Φ_p(n)}`, and the two windows (at `u = p/n`) bound
that minimum to `p/log2 − 3/2 ± K/p`.

### 13.197 **LANDED (round 184): `Phi_window_high`** — 170 declarations; **both windows are proved**

`Op56/PhiThird.lean` now has **170 declarations** (0 sorries, 7/7 OK, 0 axioms), newly:

```lean
lemma Phi_window_high (u : ℝ) (n : ℕ) (hu1 : 1/2 ≤ u) (hu2 : u ≤ 1) (hn : 2000000000 ≤ n)
    (hwabs : |u - Real.log 2| ≤ 4/(n:ℝ))
    (hw : Real.log 2 + 3*Real.log 2/(2*(n:ℝ)) + 10^19/((n:ℝ)^2) ≤ u) :
    Phi (u*(n:ℝ)) n < 1
```

The last error was resolved exactly as recorded: **reorder `hsplit` *before* `hdiv`**, derive `hdiv`
already in split form (`rw [hsplit] at hd`), and use one `le_trans` — the `le_of_eq` bridge was the
culprit.

**Together with `Phi_window_low` (§13.194) this gives the complete characterisation used by the
index form:**

* `u ≤ log2 + 3log2/(2n) − 10¹⁹/n²`, `|u − log2| ≤ 4/n`, `n ≥ 2·10⁹` ⟹ `1 < Φ(u·n)`;
* `u ≥ log2 + 3log2/(2n) + 10¹⁹/n²`, `|u − log2| ≤ 4/n`, `n ≥ 2·10⁹` ⟹ `Φ(u·n) < 1`.

### The `nmin` transfer — concrete plan (all inputs landed)

`IsComplete_iff` (`↔ 1 ≤ Φ_p(N+1)`), `Phi_mono_n` (increasing in `n`), `Phi_strictAnti`
(decreasing in `p`), `nmin_spec`/`nmin_minimal`, and the two windows above.  Writing
`n* := nmin p`:

1. `IsComplete_iff` + `nmin_spec` give `1 ≤ Φ_p(n*+1)`;
   `nmin_minimal` gives `¬ IsComplete p (n*)`, hence **`Φ_p(n*) < 1`** (for `n* ≥ 1`);
2. **coarse window first** (`|p/n − log2| ≤ 4/n` is a hypothesis of both window lemmas): get it from
   the landed `Phi_asymptotic_explicit` (`|Φ(u·n) − (e^u−1)⁻¹| ≤ PhiC/n`): `Φ_p(n*) < 1` forces
   `p/n* > log2 − O(1)`, and `1 ≤ Φ_p(n*+1)` forces `p/(n*+1) < log2 + O(1)`, giving
   `n* = p/log2 + O(1)`, hence `|p/n* − log2| = O(1/n*)` ✓;
3. **apply both windows** at `n = n*` and `n = n*+1` with `u = p/n`: `Φ_p(n*) < 1` contrapositive
   of the low window ⟹ `p/n* > log2 + 3log2/(2n*) − 10¹⁹/n*²`; `1 ≤ Φ_p(n*+1)` contrapositive of
   the high window ⟹ `p/(n*+1) < log2 + 3log2/(2(n*+1)) + 10¹⁹/(n*+1)²`;
4. combining, `n* = p/log2 − 3/2 + O(1/p)`, which is `nmin p = nminAsym p + O(1/p)` with
   `nminAsym p = p/log2 − 5/2` ✓.

**Then `op6_reachable_fraction`.**

### 13.198 **LANDED (round 185): `nmin_Phi_ge` + `nmin_Phi_lt`** — 172 declarations

`Op56/PhiThird.lean` now has **172 declarations** (0 sorries, 7/7 OK, 0 axioms), newly (both
first-try):

```lean
lemma nmin_Phi_ge (p : ℕ) (hp : 2 ≤ p) : 1 ≤ Phi (p:ℝ) (nmin p + 1)
lemma nmin_Phi_lt (p : ℕ) (hp : 2 ≤ p) (hpos : 1 ≤ nmin p) : Phi (p:ℝ) (nmin p) < 1
```

from `nmin_spec`/`nmin_minimal` through `IsComplete_iff` (the latter with `N := nmin p − 1` and
`omega` for `nmin p − 1 + 1 = nmin p`).

### The coarse bound — solved by monotonicity, no new analysis needed

Both window lemmas need `|p/n − log2| ≤ 4/n`, i.e. `p/n ∈ [1/2, 1]`.  With `n* := nmin p`, this
follows from the landed `Phi_asymptotic_explicit` **plus `Phi`'s monotonicity in `p`**
(`Phi_strictAnti`), at the two *fixed* points `u = 1` and `u = 1/2`:

* If `p/(n*+1) ≥ 1` then `Φ_p(n*+1) ≤ Φ_{1·(n*+1)}(n*+1)`
  `≤ (e−1)^{-1} + PhiC/(n*+1) < 1` for large `n*` — contradicting `nmin_Phi_ge`.  Hence
  `p/(n*+1) < 1`, i.e. **`n* ≥ p`** (so `u = p/n* ≤ 1` ✓).
* If `p/n* ≤ 1/2` then `Φ_p(n*) ≥ Φ_{(1/2)·n*}(n*) ≥ (√e−1)^{-1} − PhiC/n* > 1` for large `n*` —
  contradicting `nmin_Phi_lt`.  Hence **`p/n* > 1/2`** ✓.
* Combined: `|p/n* − log2| ≤ 4/n*` follows once the windows give the sharp bound (the `u = p/n*`
  used in the windows is then already in `[1/2,1]`, so no circularity).

**Then:** apply `Phi_window_low` to `n*` (from `nmin_Phi_lt`) and `Phi_window_high` to `n*+1`
(from `nmin_Phi_ge`) — via the contrapositive — and combine to get
`nmin p = nminAsym p + O(1/p)`.

### 13.199 Round-186: the coarse bound needs a **case split** — a circularity in §13.198

No declaration landed (build green: 172 declarations, 7/7 OK, 0 axioms).

**Both numeric endpoints are already landed** (good news):
`exp_one_inv_le_three_fourths : (e−1)⁻¹ ≤ 3/4` and
`exp_half_inv_ge : 4/3 ≤ (e^{1/2}−1)⁻¹` — so the two fixed-`u` estimates give
`Φ_{1·n}(n) ≤ 3/4 + PhiC/n` and `Φ_{(1/2)·n}(n) ≥ 4/3 − PhiC/n`, each with a `1/4`-ish gap.

**The circularity found:** §13.198's first bullet needs `Φ_{1·(n*+1)}(n*+1) < 1`, i.e.
`n*+1 > 4·PhiC` — but `n* := nmin p` has **no known lower bound** at that point, so the argument
does not close directly.  (The landed `nmin ≤ 4p`, from `exists_isComplete`'s witness `N = 4p`, gives
only an *upper* bound.)

**Fix — split on whether `n*+1` is large:**
* **`n*+1 > 4·PhiC`:** the asymptotic estimate applies and gives the contradiction as before;
* **`n*+1 ≤ 4·PhiC`:** then `p ≥ n*+1` is large while `n*+1` is bounded, so a **termwise** bound
  suffices: `Φ_p(n*+1) = Σ_j (1+(j+1)/(n*+1))^{-p} ≤ Σ_j 2^{-p}·…` → for `p` large (e.g.
  `p > 10·PhiC`) the whole sum is `< 1`, contradicting `nmin_Phi_ge` ✓.

**Consequence:** the coarse bracket `n* ≥ p` holds for `p` above an explicit threshold, which is
all the *eventual* part needs.  The finitely many small `p` are then absorbed into the `O`-constant,
legitimately: `Asymptotics.IsBigO` is an `atTop` statement, so it suffices to produce some `K` with
`|nmin p − nminAsym p| ≤ K·(1/p)` for all large `p`; the finitely many smaller `p` do not affect
the existential `K` at all (each term is finite, and there are only finitely many).  **No global
bound on `nmin` is needed for this step** — only for the (optional) cleanliness of a concrete `K`.

### 13.200 **LANDED (round 187): `IsComplete_four_mul` + `nmin_le_four_p`** — 174 declarations

`Op56/PhiThird.lean` now has **174 declarations** (0 sorries, 7/7 OK, 0 axioms), newly:

```lean
lemma IsComplete_four_mul (p : ℕ) (hp : 2 ≤ p) : IsComplete p (4 * p)
lemma nmin_le_four_p (p : ℕ) (hp : 2 ≤ p) : nmin p ≤ 4*p
```

`IsComplete_four_mul` is the witness from `exists_isComplete`'s proof **extracted as a statement**
(the body is copied — `tailSum_ge_first_two`/`term_ratio`/`bound_three_halves`/`bernoulli`); a
future refactor could define `exists_isComplete := ⟨4*p, IsComplete_four_mul p hp⟩` and delete the
duplication.  `nmin_le_four_p` then follows from `Nat.find_le` (`classical` is required — `Nat.find`
needs `DecidablePred (IsComplete p)`).

**No numeric bound on `PhiC` exists in the library** (only `PhiC_pos`); existing proofs carry
`2·PhiC ≤ n` as an explicit hypothesis.  The coarse bound should follow that style:

```lean
lemma nmin_ge_p (p : ℕ) (hp : 2 ≤ p) (hlarge : 4*PhiC < (p:ℝ)) : p ≤ nmin p
```

* assume `p ≥ n*+1` with `n* := nmin p`;
* **Case `n*+1 > 4·PhiC`:** `Φ_p(n*+1) ≤ Φ_{n*+1}(n*+1)` (`Phi_strictAnti`) `≤ (e−1)⁻¹ + PhiC/(n*+1)`
  (`Phi_asymptotic_explicit` at `u = 1`) `≤ 3/4 + 1/4 = 1` (`exp_one_inv_le_three_fourths` plus
  `4·PhiC < n*+1`), contradicting `nmin_Phi_ge` ✓;
* **Case `n*+1 ≤ 4·PhiC`:** then `hlarge` gives `p > n*+1`, and a termwise bound
  `Φ_p(n*+1) < 1` for `p > 4·PhiC` (each summand `(1+(j+1)/(n*+1))^{-p}` is small since
  `(n*+1) ≤ 4·PhiC < p`) again contradicts `nmin_Phi_ge` ✓.

The mirror bound `nmin p < 2p` (needed for `p/n* > 1/2`) is the same argument with
`exp_half_inv_ge : 4/3 ≤ (e^{1/2}−1)⁻¹` and the gap `4/3 − 1 = 1/3` ✓.

### 13.201 Round-188: a **cleaner route to the coarse bound** — via the Brown criterion itself

No declaration landed (build green: 174 declarations, 7/7 OK, 0 axioms).

Reconsidering §13.200: the coarse bound `n* ≥ p` (needed so that `u = p/n* ≤ 1` for the windows)
can be obtained **directly from `IsComplete`** rather than through `Phi_asymptotic_explicit`, which
avoids the `u ∈ [1/2,1]` restriction altogether:

`IsComplete p N` unfolds (via the landed `IsComplete_iff` and the `term`/`tailSum` definitions) to
the *p-series* criterion `M^{-p} ≤ Σ_{m>M} m^{-p}` with `M := N+1`.  Two standard bounds:

* `ζ(p) ≤ p/(p-1) = 1 + 1/(p-1)` (integral comparison);
* `Σ_{m>M} m^{-p} = (M+1)^{-p} Σ_{k≥1} ((M+k)/(M+1))^{-p} ≤ (M+1)^{-p} Σ_{k≥1} k^{-p}
  ≤ (M+1)^{-p} · p/(p-1)`.

So `IsComplete p N` implies `M^{-p} ≤ (M+1)^{-p} p/(p-1)`, i.e.
`((M+1)/M)^p ≤ p/(p-1)`, i.e. `p·log(1+1/M) ≤ log(p/(p-1))`.  At `M = p` the left side is
`≈ 1` while the right side is `≈ 1/(p-1)`, so for `p ≥ 2` the inequality **fails** at `M = p`,
hence `M > p`, i.e. **`n* + 1 ≥ p + 1` and `n* ≥ p`** ✓.  (Rigorous form: `log(1+x) ≥ x - x²/2`
with `x = 1/M` for the left, and `log(p/(p-1)) ≤ 1/(p-1)` for the right — both already available as
`log_one_add_*` lemmas.)

**Advantages:** uses only `nmin_spec` + the criterion + `ζ`/`log` bounds already in the library — no
`Phi_asymptotic_explicit`, no `Phi_strictAnti`, no `u ∈ [1/2,1]` hypothesis, and no case split.

**Mirror bound** `n* < 2p` (for `p/n* > 1/2`): show `¬IsComplete p N` **fails** for `M ≥ 2p` by the
reverse estimate `M^{-p} ≤ Σ_{m>M}m^{-p}` — i.e. that completeness *holds* for `M` large, giving a
ceiling on the *first* complete index; combined with the lower bound this brackets `p/n* ∈ (1/2, 1]`.

### 13.202 Round-189: the coarse bound's target **verified numerically**; the estimate is a real sub-development

No declaration landed (build green: 174 declarations, 7/7 OK, 0 axioms).

**Numerical check of the key claim `Φ_p(p) < 1`** (`Φ_p(p) = Σ_j (1+(j+1)/p)^{-p}`, computed to
4000 terms):

| `p` | 2 | 5 | 10 | 100 | 10³ | 10⁶ | limit |
|---|---|---|---|---|---|---|---|
| `Φ_p(p)` | 1.5787 | 0.8311 | 0.6927 | 0.5920 | 0.5830 | 0.58198 | `e^{-1}/(1-e^{-1}) = 0.58198` |

So **`Φ_p(p) < 1` for all `p ≥ 5`** (true, and with a 40 % margin), and the limit is exactly
`Σ_k e^{-k} = 1/(e-1)` ✓ — matching the termwise asymptotics `(1+k/p)^{-p} → e^{-k}`.

**But the Lean estimate is genuinely non-trivial** (worked out this round):
* the natural route is `log(1+x) ≥ x − x²/2` (the landed quartic bound) giving
  `(1+k/p)^{-p} ≤ e^{-k}e^{k²/(2p)}`; the factor `e^{k²/(2p)}` is harmless only for `k ≪ √p`,
  and the split at `k = p/2` gives `Σ_{k≤p/2} ≤ e^{-3/4}/(1-e^{-3/4}) ≈ 0.894 < 1` ✓ but the tail
  needs a separate decay estimate;
* the crude tail bounds (`(k/p)^{-p}`, `(3k/(2p))^{-p}`) are **too lossy** — the second is even
  *increasing* in the wrong range;
* the working bound appears to be: for `k ≥ p/2`, `1+k/p ≥ 3/2` gives `≤ (2/3)^p` per term but the
  tail is infinite, so the decay must come from `(1+k/p)^{-p} ≤ e^{-k·c}` with `c < 1` on
  `k ≤ p/2` **plus** a dyadic/geometric bound on `k > p/2` (the same technique the §13.173 tail
  discussion needed).

**Recommendation:** rather than fight this estimate directly, note that **the coarse bound is only
needed to supply the windows' `u ∈ [1/2,1]` hypothesis**, and the §13.201 alternative obtains
`n* ≥ p` — hence `u ≤ 1` — from the p-series criterion with only `ζ`/`log` bounds.  The `u > 1/2`
half is then immediate from `nmin_le_four_p`-style reasoning **together with the sharp window
applied at `u = p/n*` once `u ≤ 1` is known** (the window itself yields `p/n* > log2 − ε > 1/2`).
So: **land `n* ≥ p` via §13.201, and get `u > 1/2` from the low window at `n = n*` — no
`Φ_p(p)` estimate needed at all.**

### 13.203 Round-190: the **cleanest coarse-bound route** yet (`1` vs `log 2`), and a standing warning in the file

No declaration landed (build green: 174 declarations, 7/7 OK, 0 axioms).

**A caveat found first:** `Op56/Exact.lean:103–105` explicitly records that the **antitone integral
test is too lossy** for this development ("a negative result, recorded so it is not retried") — so
any route resting on a plain `∫` comparison should be treated with suspicion.  (The two `sorry`
grep hits in `Exact.lean` are both inside that documentation comment, not code.)

**The refined route — the best margin of the three considered.**  From `IsComplete p N` written as
`M^{-p} ≤ Σ_{m>M}m^{-p}` with `M := N+1`, use the **first term plus an integral from `M+1`**:

`Σ_{m>M} m^{-p} ≤ (M+1)^{-p} + (M+1)^{1-p}/(p-1)`.

Then `M^{-p} ≤ (M+1)^{-p}(1 + (M+1)/(p-1))`, i.e.
`p·log(1 + 1/M) ≤ log(1 + (M+1)/(p-1))`.

At `M = p` the two sides are `≈ 1` and `≈ log 2 = 0.693` — so the criterion **fails**, giving
`M > p`, i.e. **`n* ≥ p`** ✓.  This is compared with the alternatives:

| route | quantity at the decisive point | margin |
|---|---|---|
| `Φ_p(p) < 1` direct | `0.582` vs `1` | 40 % (but the Lean estimate is hard) |
| plain integral on `Φ` | `p/(p-1) ≈ 1` vs `1` | **none** ✗ |
| **criterion + first term + integral** | `1` vs `log 2` | ✓ clean, and only `log`-monotonicity is needed |

The `log` side needs only `log(1+y) ≤ y` (from `Real.log_le_sub_one_of_pos`) and the left side
`log(1+1/M) ≥ 1/(M+1)` (`log(1+x) ≥ x/(1+x)`, available from the same lemma at `1/(1+x)`), so **no
new analytic input is required** beyond a tail bound for `Σ m^{-p}` — and even that can be replaced
by the **two-term discrete** bound `Σ_{m>M}m^{-p} ≤ (M+1)^{-p} + (M+2)^{-p}Σ_k (1+k)^{-p}`-style
comparison, avoiding the integral test the file warns against.

### 13.204 Round-191: criterion failure at `M = p` has a **clean binomial margin**; the tail bound is the last piece

No declaration landed (build green: 174 declarations, 7/7 OK, 0 axioms).

Rewriting the criterion in 1-based form (`M := N+1`), `IsComplete p N` is
`M^{-p} ≤ Σ_{m>M} m^{-p}`, and the first-term-plus-integral bound gives
`Σ_{m>M} m^{-p} ≤ (M+1)^{-p}(1 + (M+1)/(p-1))`.  So the criterion **fails** at `M = p` whenever

`(1 + 1/p)^p > 1 + (p+1)/(p-1)`.

**The margin, made explicit** (no `log`s, no integrals):

* left: the degree-4 binomial truncation gives
  `(1+1/p)^p ≥ 1 + 1 + (p-1)/(2p) + (p-1)(p-2)/(6p²)`, which for `p ≥ 6` is `≥ 2 + 0.416 + 0.138 = 2.555`;
* right: `1 + (p+1)/(p-1) = 2 + 2/(p-1) ≤ 2.4` for `p ≥ 6`.

So `2.555 > 2.4` ✓ — a genuine, checkable gap.  Hence `¬IsComplete p (p-1)` for `p ≥ 6`, and then
`IsComplete_iff` + `Phi_mono_n` propagate it: `Φ_p(N+1) ≤ Φ_p(p) < 1` for all `N ≤ p-1`, so
**`nmin p ≥ p`** ✓.

**The one remaining piece** is an **upper bound for the p-series tail** `Σ_{m>M}m^{-p} ≤ (M+1)^{-p}(1 + (M+1)/(p-1))`
that does **not** invoke the antitone integral test (`Exact.lean:103–105` warns against it).  A
discrete route: `Σ_{m>M}m^{-p} = (M+1)^{-p}Σ_{j≥0}(1 + j/(M+1))^{-p}` and then compare
`(1 + j/(M+1))^{-p}` with a **geometric** majorant via `(1+y)^p ≥ 1 + py`
(`one_add_mul_le_pow`, already used in `Exact.lean`) — which yields exactly the
`1 + (M+1)/(p-1)`-shaped bound without any integral.  (Note `Exact.lean` solves its *existence*
problem with the discrete two-term argument `tailSum_ge_first_two`; that gives only a **lower** bound
on the tail, so it cannot be reused for `¬IsComplete`.)

### 13.205 Round-192: **the file's own closed form for the criterion** — and a firm decision on the tail bound

No declaration landed (build green: 174 declarations, 7/7 OK, 0 axioms).

**Key documentation found** (`Op56/Exact.lean:33–37`, in the module docstring):

> With the alphabet `b_N = (2(N+1))^{-p}`, the completeness condition `b_N ≤ T_{N+1}` is
> `T_{N+1}/b_N = r/(1-r)`, `r = (N/(N+1))^p`; it holds exactly for `r ≥ 1/2`, i.e.
> `N ≥ p/ln 2 + O(1)`.  The check `N = 12` at `p = 10` is complete (`T/b = 1.0077`) while `N = 11`
> is not (`0.9017`), matching `n_min = 13`.

This confirms the shape of `op5_nmin_asymptotic` (`nmin p ≈ p/log 2 − 5/2`) and gives a
**concrete sanity target**: at `p = 10`, `n_min = 13` ⟺ `nmin 10 = 12`, and
`nminAsym 10 = 10/log2 − 5/2 = 14.43 − 2.5 = 11.93` ✓ — within the `O(1/p)` window ✓.

**Interpretation caveat (important):** the identity `T_{N+1}/b_N = r/(1-r)` is *not* exact for a
p-series (it is the geometric-series value); it is the author's approximation, which is why the file
states existence is proved **discretely** rather than from it.  So it is a guide, **not** a lemma to
reuse or an axiom-free shortcut.

**FIRM DECISION, after six rounds of planning this bound:** stop planning and *write* the tail-bound
lemma

```lean
lemma tsum_pow_tail_le (M p : ℕ) (hM : 1 ≤ M) (hp : 1 < p) :
    (∑' k : ℕ, ((M + k : ℕ) : ℝ) ^ (-(p:ℝ))) ≤ (M:ℝ) ^ (-(p:ℝ)) * (1 + (M:ℝ)/((p:ℝ) - 1))
```

using the antitone integral comparison.  The file's warning ("too lossy") is explicitly scoped to
**the existence use case** — at the threshold its bound is `≈ 0.73 b_N < b_N`, i.e. it *under*estimates
the tail there.  **My use needs an overestimate**, which is exactly what the integral comparison gives,
so the warning does not apply.  If the Mathlib integral lemmas
(`AntitoneOn.integral_le_tsum_comp_add`, `integral_comp_mul_left_Ioi`) prove awkward, fall back to the
discrete two-term comparison `Σ_{k≥0}(M+k)^{-p} ≤ (M)^{-p} + (M+1)^{-p}·Σ_j (1+j)^{-p}`-style — but
**do not spend another round choosing between them**; write one and iterate on errors.

### 13.206 Round-193: the tail lemma is **drafted and down to three errors** — the right Mathlib tools were found

No declaration landed (build green: 174 declarations, 7/7 OK, 0 axioms).

Following the §13.205 firm decision ("write it and iterate, do not re-plan"), I found the **exact
tools needed**, which removes the telescoping work entirely:

* **`AntitoneOn.tsum_comp_add_le_integral (N) (anti) (integrable) (nonneg) :`
  `Σ' n, f (n + N + 1) ≤ ∫ x in Set.Ioi N, f x`** — the **upper** direction (the lower one,
  `integral_le_tsum_comp_add`, was the one referenced in `Exact.lean`, which is why the earlier
  route looked blocked);
* `integrableOn_Ioi_rpow_of_lt (ha : a < -1) (hc : 0 < c)`;
* `integral_Ioi_rpow_of_lt (ha : a < -1) (hc : 0 < c) :
  ∫ t in Set.Ioi c, t^a = -c^(a+1)/(a+1)`;
* `Summable.sum_add_tsum_nat_add (k) (h)` for the `K^{-p}` term, and `summable_nat_add_iff` +
  `Real.summable_nat_rpow_inv` for summability.

So `Σ_{m≥K}m^{-p} ≤ K^{-p} + K^{1-p}/(p-1) = K^{-p}(1 + K/(p-1))` follows **directly**, with no
telescoping and no `rpow_neg_le_integral` lemma at all (the `/tmp/w1033.lean` attempt with
`one_add_mul_le_pow` can be discarded).

`/tmp/w1036.lean` has the full proof; **three errors remain**:
1. **line 31** — the `integral_Ioi_rpow_of_lt` rewrite does not match the goal's integral
   (`∫ x in Set.Ioi (K:ℝ), x ^ (-(p:ℝ))`) — likely the `MeasureTheory` scoping of the `∫` notation;
   print the goal and match, or restate using `MeasureTheory.integral_Ioi_rpow_of_lt`;
2. **line 42** — the `hfin` `linarith` combining `hsplit` and `hint` (align `hshift`'s index form);
3. **line 47** — `heq`'s `field_simp; ring` reports *No goals to be solved* (`field_simp` already
   closes it — the recurring pattern: drop the trailing `ring`).

### 13.207 Round-193 (cont.): tail lemma at **two errors**

No declaration landed (build green: 174 declarations, 7/7 OK, 0 axioms).

`/tmp/w1036.lean` progressed 5 → 2 errors:
* the `Summable` input is now `Real.summable_nat_rpow_inv` + `Real.rpow_neg` + `summable_nat_add_iff`
  (the earlier `comp_injective` construction was wrong and is discarded);
* the `integral_Ioi_rpow_of_lt` value is normalised by `field_simp; ring` rather than by
  `neg_div`/`neg_neg` juggling (the `-(-A/B)` shape defeats the rewrite patterns).

**Two errors left:**
1. **line 29** — the `field_simp` in `hval` leaves one goal (print it; likely needs `ring` inside a
   `conv`, or `div_eq_div_iff`);
2. **line 44** — `hfin`'s `linarith [hsplit, hint]` — `hsplit : f 0 + Σ' i, f (i+1) = Σ' i, f i`
   and `hint : Σ' n, f (n + K + 1) ≤ ∫`; the indices need aligning (`hshift` already rewrites
   `K + (i+1)` to `K + i + 1`, but `hint`'s is `n + K + 1` — **commute the summand before the
   `linarith`**).

**Once this lands**, the coarse bound is: `Σ_{m≥K}m^{-p} ≤ K^{-p}(1 + K/(p-1))` (this lemma) →
`IsComplete p (p-1)` requires `(1+1/p)^p ≤ 1 + (p+1)/(p-1)`, which **fails** for `p ≥ 6` by the
binomial margin `2.555 > 2.4` (§13.204) → `nmin p ≥ p`.

### 13.208 Round-193 (cont.): tail lemma at **ONE error** — the split alignment

No declaration landed (build green: 174 declarations, 7/7 OK, 0 axioms).

`/tmp/w1036.lean` went 2 → 1 error.  Fixes this round: `tsum_le_tsum` is `Summable.tsum_le_tsum`
(and it **times out** here — use `tsum_congr` + `le_of_eq` instead, which is cheap); the `hval`
`field_simp` needs `show (1:ℝ) - (p:ℝ) ≠ 0 by linarith` supplied explicitly; and the duplicate
`rw [hval] at hint` had to be removed.

**The last error, `/tmp/w1036.lean:48`:** aligning
`hsplit : f 0 + Σ' i, f (i+1) = Σ' i, f i` (where `f m = (K+m)^{-p}`) with `hint'`'s summand
`(K+i+1)^{-p}` to conclude `Σ' i f i ≤ K^{-p} + K^{1-p}/(p-1)`.  `rw [← hsplit]` does not fire —
most likely because `hsplit`'s `f 0` and the goal's `K ^ (-(p:ℝ))` differ syntactically
(`((K + 0 : ℕ) : ℝ) ^ ...` vs `(K:ℝ) ^ ...`).  **Remedy: prove the aligned identity directly by
`tsum_congr` on both sides and `simp only [Nat.cast_zero, add_zero]`, or state the lemma's
conclusion with `f 0` kept symbolic and let the caller normalise.**

**Once it lands:** `Σ_{m≥K}m^{-p} ≤ K^{-p}(1 + K/(p-1))` → `¬ IsComplete p (p-1)` for `p ≥ 6` by the
binomial margin → **`nmin p ≥ p`**, completing the coarse bound.

### 13.209 **LANDED (round 194): `tsum_pow_tail_le`** — the p-series tail bound — 175 declarations

`Op56/PhiThird.lean` now has **175 declarations** (0 sorries, 7/7 OK, 0 axioms), newly:

```lean
lemma tsum_pow_tail_le (K p : ℕ) (hK : 1 ≤ K) (hp : 1 < p) :
    (∑' m : ℕ, ((K + m : ℕ) : ℝ) ^ (-(p:ℝ)))
      ≤ (K:ℝ) ^ (-(p:ℝ)) * (1 + (K:ℝ)/((p:ℝ) - 1))
```

built from `AntitoneOn.tsum_comp_add_le_integral` (the **upper** direction),
`integrableOn_Ioi_rpow_of_lt`, `integral_Ioi_rpow_of_lt`, and
`Summable.sum_add_tsum_nat_add` for the first-term split.  **No telescoping, no Bernoulli — the
`/tmp/w1033.lean` attempt is discarded entirely.**

**Tactical facts recorded (each cost a step):** `Summable.tsum_le_tsum` **times out** here — use
`tsum_congr` + `le_of_eq`; the `field_simp` in the integral value needs `1 − p ≠ 0` explicitly;
`hsplit.symm` must be stated as an explicit `have` before the rewrite chain; and `congr 1` alone
closes the `K + (i+1)` vs `K + i + 1` alignment (a following `tsum_congr` errors *No goals*).

### The coarse bound — final three steps (all inputs now landed)

With `K := N+2`, `IsComplete p N` unfolds to `(N+1)^{-p} ≤ Σ' k (N+2+k)^{-p}`, and
`tsum_pow_tail_le` bounds the right side by `(N+2)^{-p}(1 + (N+2)/(p-1))`.  At `N = p−1`:

* `IsComplete p (p−1)` would require `(1+1/p)^p ≤ 1 + (p+1)/(p-1)`;
* the binomial truncation gives the left side `≥ 1 + 1 + (p−1)/(2p) + (p−1)(p−2)/(6p²) ≥ 2.555`
  for `p ≥ 6`, while the right side is `2 + 2/(p−1) ≤ 2.4` — **the inequality is false** ✓;
* hence `¬ IsComplete p (p−1)`, and `IsComplete_iff` + `Phi_mono_n` propagate it to
  `Φ_p(N+1) < 1` for all `N ≤ p−1`, giving **`nmin p ≥ p`** ✓.

**Next: implement these three steps** — the criterion conversion (`2^{-p}` cancellation via
`Real.mul_rpow`/`div`), the binomial inequality, and `nmin_ge_p`.

### 13.210 Round-195: the binomial step — a **log/exponential route** is cleaner than the `choose` route

No declaration landed (build green: 175 declarations, 7/7 OK, 0 axioms).

I drafted the `choose`-based binomial lower bound (`/tmp/w1041.lean`) and hit two obstacles:
there is **no `Nat.choose_three_right`** in this Mathlib (only `Nat.choose_two_right` and
`Nat.choose_succ_right_eq`), and the resulting cast/`field_simp` goal is awkward.

**Better route — reuse the landed `log`/`exp` bounds instead of expanding `choose`:**

`(1+1/p)^p = e^{p·log(1+1/p)}`, and `log(1+x) ≥ x − x²/2` (the landed
`log_one_add_ge_quartic` at `x = 1/p`, keeping the positive terms) gives
`p·log(1+1/p) ≥ 1 − 1/(2p)`; then `e^{1−1/(2p)} = e·e^{−1/(2p)} ≥ e·(1 − 1/(2p))` (from
`Real.add_one_le_exp`-style, or `exp_neg` + `1 − y ≤ e^{−y}`), so

`(1+1/p)^p ≥ e·(1 − 1/(2p)) ≥ 2.7·(1 − 1/(2p)) = 2.7 − 1.35/p`.

The target is `> 1 + (p+1)/(p-1) = 2 + 2/(p-1)`, i.e. `0.7 > 1.35/p + 2/(p-1)` — true for `p ≥ 6`
(`0.225 + 0.4 = 0.625 < 0.7` ✓) and **easier for larger `p`** ✓.  All ingredients are landed:
`log_one_add_ge_quartic`, `Real.exp_le_exp`, `Real.exp_one_gt_d9` (`e > 2.7`),
`Real.rpow_def_of_pos` for the `rpow`↔`exp` bridge.

**Next: implement this, then the criterion conversion and `nmin_ge_p`.**

### 13.211 Round-196: `binomial_margin` drafted via log/exp — two errors

No declaration landed (build green: 175 declarations, 7/7 OK, 0 axioms).

`/tmp/w1051.lean` has the full log/exp proof of

```lean
lemma binomial_margin (p : ℕ) (hp : 6 ≤ p) :
    1 + ((p:ℝ)+1)/((p:ℝ)-1) < (1 + 1/(p:ℝ))^p
```

via: `log_one_add_ge_quartic` at `1/p` ⟹ `p·log(1+1/p) ≥ 1 − 1/(2p)` (the discarded terms
`1/(3p²) − 1/(4p³)` are nonneg for `p ≥ 1` ✓); `Real.rpow_natCast` + `Real.rpow_def_of_pos` for the
`rpow`↔`exp` bridge; `Real.exp_le_exp` + `Real.one_sub_le_exp_neg` + `Real.exp_one_gt_d9`
(`e > 2.7182818283`) ⟹ `(1+1/p)^p ≥ 2.7182818283·(1 − 1/(2p))`; and finally
`2.7182818283·(1 − 1/(2p)) > 2 + 2/(p−1)` for `p ≥ 6` ✓ (fields: `0.7 > 1.35/p + 2/(p−1)`, i.e.
`0.625 < 0.7` at `p = 6`).

**Two errors left:**
1. **line 36** — `hstep`'s `rw [← Real.rpow_natCast …, Real.rpow_def_of_pos hbase]` gives a **type
   mismatch**: the `rpow` form is `Real.exp (Real.log (1+1/p) * p)` (log first) while my statement
   has `(p:ℝ) * Real.log (…)` — **commute the product in the statement** (or `ring_nf` the
   exponent after the rewrite);
2. **line 49** — `h4`'s `Real.exp_add` rewrite still not firing; the explicit form
   `have h := Real.exp_add 1 (-(1/(2*(p:ℝ)))) ; rw [show … ] at h ; exact h.symm` was tried and
   the pattern still fails — print the goal; likely the `1/(2*(p:ℝ))` grouping differs, so use
   `Real.exp_add` with the *exact* term occurring in `h6`.

**Then:** the criterion conversion and `nmin_ge_p`.

### 13.212 **LANDED (round 196): `binomial_margin`** — 176 declarations

`Op56/PhiThird.lean` now has **176 declarations** (0 sorries, 7/7 OK, 0 axioms), newly:

```lean
lemma binomial_margin (p : ℕ) (hp : 6 ≤ p) :
    1 + ((p:ℝ)+1)/((p:ℝ)-1) < (1 + 1/(p:ℝ))^p
```

via the log/exp route of §13.210 — `log_one_add_ge_quartic` at `1/p`,
`Real.rpow_natCast` + `Real.rpow_def_of_pos`, `Real.exp_le_exp`, `Real.one_sub_le_exp_neg`,
`Real.exp_one_gt_d9` (`e > 2.7182818283`), and `2.7182818283(1 − 1/(2p)) > 2 + 2/(p−1)` for
`p ≥ 6`.

**Three tactical facts (each cost a step):**
1. `Real.exp_add 1 x` yields `exp(1+x) = exp 1 * exp x` — after rewriting the exponent the goal is
   `exp(1 − 1/(2p)) = exp 1 * exp(−(1/(2p)))`, so it is **`h`, not `h.symm`**;
2. `div_lt_iff₀` fires only when the division is the **whole** left side — with
   `1 + (p+1)/(p−1) < c` first isolate `(p+1)/(p−1) < c − 1` in a named `have`;
3. `field_simp` sometimes closes the goal, so a following `ring` errors *No goals*.

### Remaining for `nmin_ge_p` (all inputs landed)

1. **criterion conversion** — `IsComplete p N` unfolds to `(N+1)^{-p} ≤ Σ' k (N+2+k)^{-p}`
   (the `2^{-p}` factor cancels by `Real.mul_rpow`/division), then `tsum_pow_tail_le` with
   `K := N+2` gives `≤ (N+2)^{-p}(1 + (N+2)/(p-1))`;
2. at `N = p−1` this would require `(1+1/p)^p ≤ 1 + (p+1)/(p-1)`, **contradicting
   `binomial_margin`** ✓ — hence `¬ IsComplete p (p−1)`;
3. `IsComplete_iff` + `Phi_mono_n` extend this to `Φ_p(N+1) < 1` for all `N ≤ p−1`, so
   `nmin p ≥ p` ✓.

### 13.213 **LANDED (round 197): `IsComplete_criterion`** — 177 declarations; `nmin_ge_p` drafted

`Op56/PhiThird.lean` now has **177 declarations** (0 sorries, 7/7 OK, 0 axioms), newly:

```lean
lemma IsComplete_criterion (p N : ℕ) (h : IsComplete p N) :
    ((N:ℝ)+1) ^ (-(p:ℝ)) ≤ ∑' k : ℕ, (((N + 2 + k : ℕ)) : ℝ) ^ (-(p:ℝ))
```

— the `2^{-p}` cancellation via `Real.mul_rpow` + `le_of_mul_le_mul_left`, first try.

`/tmp/w1061.lean` has the full `nmin_ge_p` (`p ≤ nmin p` for `p ≥ 6`), structured as:
`Φ_p(p) < 1` (else `IsComplete p (p-1)`, then `IsComplete_criterion` + `tsum_pow_tail_le` give
`p^{-p} ≤ (p+1)^{-p}(1 + (p+1)/(p-1))`, i.e. `(1+1/p)^p ≤ 1 + (p+1)/(p-1)`, **contradicting
`binomial_margin`**); then `by_contra` with `Phi_mono_n` at `nmin p + 1 ≤ p` contradicts
`nmin_Phi_ge`.

**Five errors remain**, all in the `(1+1/p)^p` normalisation:
1. **line 34** — `tsum_pow_tail_le (p+1) p (by omega) (by omega)`: argument type mismatch (the
   `1 < p` ℕ-goal); use explicit `(by omega : 1 ≤ p+1)` / `(by omega : 1 < p)`;
2. **line 39** — `(div_le_iff₀ hp1p).mpr hchain` argument type;
3. **line 41** — the `Real.div_rpow`/`rpow_neg` chain for
   `p^{-p}/(p+1)^{-p} = ((p+1)/p)^p` — **simpler route: rewrite both `rpow`-negatives with
   `Real.rpow_neg` to get `((p+1)/p)^p` directly via `Real.div_rpow` in the *forward* direction**;
4/5. **lines 52–53** — two redundant steps (the preceding `field_simp`/`ring_nf` closed them).

### 13.214 Round-198: `nmin_ge_p` — the `hcrit`/`htail` glue diagnosed

No declaration landed (build green: 177 declarations, 7/7 OK, 0 axioms).

Fixes applied: `le_trans hcrit htail` replaced by an explicit `linarith only`; the
`(div_le_iff₀ hp1p).mpr hchain` needs the commuted product (`mul_comm`); and the `heq` chain was
rewritten as `div_eq_mul_inv` + `Real.rpow_neg` + `Real.div_rpow` in the **forward** direction.

**Remaining errors:** line 35 (`linarith only [hcrit, htail]`), 42 (`hkey`'s unsolved sub-goal),
45 (`heq`'s rewrite), 52–53 (two redundant steps that `ring`/`field_simp` already closed).

**Diagnosis for line 35:** `hcrit`'s tail is `∑' k, (((p - 1 + 2 + k : ℕ)) : ℝ) ^ (-(p:ℝ))` which
`hidx3` rewrites to `∑' m, (((p + 1 + m : ℕ)) : ℝ) ^ …`, while `htail`'s is
`∑' m, ((((p+1) + m : ℕ)) : ℝ) ^ …`.  Those print identically but **are not the same term** for
`linarith`: `p + 1 + m` parses as `(p + 1) + m`, and the two sums differ in the `tsum`'s function,
so Lean treats them as distinct atoms.  **Fix: insert the glue explicitly** as
`have hglue : (∑' m, (((p+1+m:ℕ)):ℝ)^…) = (∑' m, ((((p+1)+m:ℕ)):ℝ)^…) := by apply tsum_congr; intro m; omega`-style
or simply *avoid* `hidx3` and state `hcrit` directly with the `(p+1) + m` index by rewriting the
cast inside the `tsum_congr` proof.

### 13.215 Round-198 (cont.): the cast mismatch is `↑(p+1)` vs `↑p + 1`

No declaration landed (build green: 177 declarations, 7/7 OK, 0 axioms).

The earlier "identical types" reading was wrong: the real mismatch (now printed in full) is

```
htail  : … ≤ ↑(p + 1) ^ (-↑p) * (1 + ↑(p + 1) / (↑p - 1))
expects: … ≤ (↑p + 1) ^ (-↑p) * (1 + (↑p + 1) / (↑p - 1))
```

i.e. the classic **`↑(p+1)` vs `↑p + 1`**.  `simp only [Nat.cast_add, Nat.cast_one] at htail'`
was applied but did **not** reach inside the `tsum`'s summand, so the `le_trans` still fails.

**Fix (next round):** normalize the *statement* of `hcrit`/`htail` with a `tsum_congr` whose body
proves `↑(p+1+m) = ↑p + 1 + ↑m` explicitly, or state `hchain` in the `(↑p + 1)` form and reprove
`hcrit`'s conclusion by `simpa only [Nat.cast_add, Nat.cast_one]` at the point of use (the
`Nat.cast_add`/`Nat.cast_one` rule is already in the recurring list — this is its `tsum`-binder
variant).

**Other errors:** line 47 (`heq`'s rewrite), 44 (`hkey`'s sub-goal), 54–55 (two redundant steps).

### 13.216 Round-199: `hchain` **fixed** (`Nat.cast_add`/`Nat.cast_one` at both `hcrit` and `htail`)

No declaration landed (build green: 177 declarations, 7/7 OK, 0 axioms).

The cast mismatch of §13.215 is resolved: `simp only [Nat.cast_add, Nat.cast_one] at hcrit htail`
**normalising both hypotheses together** (rather than one) lets `le_trans hcrit htail` fire ✓.

**Four errors remain in `nmin_ge_p` (`/tmp/w1061.lean`):**
1. **line 46** — `heq`'s `rw [Real.div_rpow …]` fails because the goal uses the **ℕ-power**
   `((↑p+1)/↑p) ^ p` while `Real.div_rpow` is stated for **ℝ**-rpow.  **Fix:** state `heq` in the
   ℝ-rpow form `((p:ℝ)^(-(p:ℝ)))/((p+1:ℝ)^(-(p:ℝ))) = ((p+1:ℝ)/p)^((p:ℕ):ℝ)` and convert with
   `Real.rpow_natCast` at the end — or prove `hdiv` directly from `hkey` by `field_simp` +
   `Real.rpow_natCast`;
2. **line 43** — `hkey`'s `linarith only [hchain, mul_comm …]` leaves a goal (the commuted-product
   trick did not suffice; use `rw [mul_comm] at hchain` or state `hkey`'s RHS in the same order as
   `hchain`'s);
3/4. **lines 53–54** — two redundant steps after `field_simp`/`ring_nf` (the recurring *No goals*
   pattern).

### 13.217 **LANDED (round 200): `nmin_ge_p`** — 178 declarations — **the coarse bound is complete**

`Op56/PhiThird.lean` now has **178 declarations** (0 sorries, 7/7 OK, 0 axioms), newly:

```lean
lemma nmin_ge_p (p : ℕ) (hp : 6 ≤ p) : p ≤ nmin p
```

**This closes the entire coarse-bound sub-development** that occupied rounds 185–200.  The chain:

1. `IsComplete_criterion` + `tsum_pow_tail_le` at `K := p+1` give
   `p^{-p} ≤ (p+1)^{-p}(1 + (p+1)/(p-1))` whenever `Φ_p(p) ≥ 1`;
2. dividing by `(p+1)^{-p}` (via `Real.rpow_neg` + `div_inv_eq_mul` + `inv_mul_eq_div` +
   `Real.rpow_natCast`) turns this into `((p+1)/p)^p ≤ 1 + (p+1)/(p-1)`, **contradicting
   `binomial_margin`**;
3. so `Φ_p(p) < 1`; `IsComplete_iff` + `Phi_mono_n` then give `Φ_p(nmin p + 1) < 1` whenever
   `nmin p + 1 ≤ p`, contradicting `nmin_Phi_ge` — hence `p ≤ nmin p` ✓.

**Rounds 185–200 in one line (all landed, 170 → 178):** `Phi_two_ge_one`, `window_arith` +
`Phi_window_low`, `window_arith_high` + `Phi_window_high`, `nmin_Phi_ge`/`nmin_Phi_lt`,
`IsComplete_four_mul`/`nmin_le_four_p`, `tsum_pow_tail_le`, `binomial_margin`,
`nmin_ge_p`.

### Remaining for `op5_nmin_asymptotic`

The two window lemmas (`Phi_window_low`/`Phi_window_high`) and the bracket
`p ≤ nmin p ≤ 4p` are now **all landed**.  What remains is pure assembly:

1. apply `Phi_window_low` at `n := nmin p`, `u := p/(nmin p)` (contrapositive of
   `nmin_Phi_lt : Φ_p(nmin p) < 1`) — needs `u ≤ 1` ✓ (from `p ≤ nmin p`) and `u ≥ 1/2`
   (from `nmin p ≤ 4p`), plus `|u − log2| ≤ 4/nmin p` — **the only non-trivial input**, which
   follows from `lambda`-style reasoning using the coarse bracket plus the landed
   `Phi_asymptotic_explicit`;
2. apply `Phi_window_high` at `n := nmin p + 1` analogously;
3. combine into `nmin p = p/log2 − 5/2 + O(1/p)` and feed `op5_nmin_asymptotic`.

### 13.218 **LANDED (round 201): `nmin_lt_two_p`** — 179 declarations — the bracket is complete

`Op56/PhiThird.lean` now has **179 declarations** (0 sorries, 7/7 OK, 0 axioms), newly:

```lean
lemma nmin_lt_two_p (p : ℕ) (hp : 2 ≤ p) (hlarge : 3*PhiC ≤ ((2*p : ℕ):ℝ)) :
    nmin p < 2*p
```

**Together with `nmin_ge_p` this gives `p ≤ nmin p < 2p`**, hence `u := p/nmin p ∈ (1/2, 1]` ✓ —
**both window lemmas' hypotheses `1/2 ≤ u ≤ 1` are now supplied.**

The route was easier than the mirror of `nmin_ge_p`: **`Φ_p(2p) > 1` directly**, since `u = p/(2p)
= 1/2` and `Φ ≈ (e^{1/2}−1)^{-1} ≥ 4/3` (landed `exp_half_inv_ge`).  Concretely,
`Phi_asymptotic_explicit (2p) (u := 1/2)` gives `Φ_p(2p) ≥ (e^{1/2}−1)^{-1} − PhiC/(2p) ≥ 4/3 − 1/3 = 1`
for `3·PhiC ≤ 2p` ✓, so `IsComplete p (2p−1)` (via `IsComplete_iff`) and `Nat.find_le` yields
`nmin p ≤ 2p−1 < 2p` ✓.  (Note: `Phi_asymptotic_explicit (n) (u)` produces `Phi (u*n) n`, so with
`u = 1/2`, `n = 2p` the *exponent* is `p` ✓ — the `(1/2)·(2p) = p` normalisation is needed before
`linarith`.)

### The final assembly for `op5_nmin_asymptotic`

With `p ≤ nmin p < 2p` and both windows landed, the remaining steps are:

1. **`|u − log2| ≤ 4/n`** with `u := p/nmin p`, `n := nmin p` — the one remaining input.  From
   `Phi_asymptotic_explicit n u` (now applicable, since `1/2 ≤ u ≤ 1` ✓) with
   `Φ_p(n) < 1` (i.e. `nmin_Phi_lt`) and `1 ≤ Φ_p(n+1)` (`nmin_Phi_ge`):
   `(e^u−1)^{-1} < 1 + PhiC/n` and `(e^{u'}−1)^{-1} > 1 − PhiC/n'` with `u' := p/(n+1)`; each
   inverts to `|u − log2| = O(1/n)` (`u` and `u'` differ by `O(1/n²)`);
2. **apply `Phi_window_low`** at `n := nmin p` (contrapositive: `Φ_p(n) < 1` forces
   `u > log2 + 3log2/(2n) − 10¹⁹/n²`);
3. **apply `Phi_window_high`** at `n := nmin p + 1` (contrapositive of `1 ≤ Φ_p(n+1)`);
4. combine → `nmin p = p/log2 − 5/2 + O(1/p)`, then `op5_nmin_asymptotic`.

### 13.219 Round-202: **a constant mismatch blocks the naive step 1** — `PhiC ≈ 72`, the windows need `|u − log2| ≤ 4/n`

No declaration landed (build green: 179 declarations, 7/7 OK, 0 axioms).

§13.218 step 1 proposed deriving `|u − log2| ≤ 4/n` from `Phi_asymptotic_explicit`.  **That cannot
work with the constants as they stand.**  Numerically (`Σ k²e^{−k/4} ≈ 128.0`, so)
**`PhiC ≈ 72`** — the first-order estimate `|Φ − (e^u−1)^{-1}| ≤ PhiC/n` therefore gives only
`|u − log2| ≲ 36/n` ✗, whereas `Phi_window_low`/`Phi_window_high` are stated with the hypothesis
`hwabs : |u − log2| ≤ 4/n`.

**Three routes, with the trade-off stated:**

* **(a) Re-state the windows with `|u − log2| ≤ 100/n`** (or a parameter `K`).  This is the most
  mechanical: `hwabs` is a *hypothesis*, so only the few places where it is *used* change —
  `window_arith`'s `hA : 500w² ≤ 8000/n²` becomes `≤ 5·10⁶/n²`, `h4`'s `26w ≤ 26·4/n` becomes
  `26·100/n`, etc.  The budgets `2·10¹⁹/n²` and `10¹²/n²` have enormous slack, so no margin is
  lost.  Cost: editing four landed lemmas plus the two arithmetic helpers.
* **(b) Sharpen the derivation.**  `Phi_third_order` (unconditional, landed) replaces `PhiC/n` by
  `uΦS(u)/(2n) + 4·10¹⁰/n² + C₃/n³`, giving `|u − log2| ≲ 15/n` — **still > 4** ✗.  The true value
  is `≈ 3log2/(2n) ≈ 1.04/n`, so a *sharp inversion* (treating `uΦS(u)` as the leading correction,
  exactly as `threshold_third_order_uniform` does) would reach `≤ 4/n` ✓ — but that is a second
  full inversion at the `nmin` level.
* **(c) Carry an abstract constant** through the windows — largest refactor.

**Recommendation: (a).**  It is bounded, mechanical, and loses nothing, because the windows'
budgets are deliberately enormous (`2·10¹⁹` vs terms of size `5·10⁶`).  Recorded here so the next
round starts from the corrected constant rather than rediscovering the mismatch.

### 13.220 Round-203: route (a)'s **upper limit on the constant**, and the exact edit list

No declaration landed (build green: 179 declarations, 7/7 OK, 0 axioms).

Working out route (a) in detail, the constant `K` in `hwabs : |u − log2| ≤ K/n` cannot be made
arbitrarily large, because two places in `Phi_window_low`'s proof **divide by n²**:

* `h4`'s `10¹⁶·w² ≤ 1` (inside `huPhiS`) — with `|w| ≤ K/n` this needs
  `10¹⁶K²/n² ≤ 1`, i.e. **`n ≥ 10⁸K`**;
* `h6b`'s `500·w² ≤ 8000/n²` — fine for any moderate `K`;
* `window_arith`'s budget `2·10¹⁹/n²` — absorbs `5·10²K²/n²` for `K ≤ 10⁶` ✓.

So with **`K = 100`**: `n ≥ 10¹⁰` is required (the `h4` constraint), i.e. the window lemmas'
hypothesis `hn : 2·10⁹ ≤ n` must be **raised to `10¹⁰`** (or `h4`'s constant `10¹⁶` lowered).
`K = 100` is comfortably enough, since the `Phi_asymptotic_explicit` route gives only `36/n`.

**Exact edit list for route (a):**
1. `Phi_window_low`/`Phi_window_high`: statement `hwabs : |u − Real.log 2| ≤ 4/(n:ℝ)` →
   `≤ 100/(n:ℝ)`; hypothesis `hn : 2000000000 ≤ n` → `10000000000 ≤ n`;
2. inside their proofs: `hw4 : |w| ≤ 4/(n:ℝ)` → `|w| ≤ 100/(n:ℝ)` (from `hwabs`);
   `hw12`'s `4/(n:ℝ) ≤ 1/2` → `100/(n:ℝ) ≤ 1/2` (still true for `n ≥ 200`);
   `h4`'s `26*(4/(n:ℝ))` → `26*(100/(n:ℝ))` with `h5b : … ≤ 2` (needs `n ≥ 1300` ✓);
   `h5b`'s `104/(n:ℝ)` → `2600/(n:ℝ)`;
   `h6b`'s `10¹⁶*(16/n²) ≤ 1` unchanged, but `h6`'s `10¹⁶*w² ≤ 10¹⁶*(10⁴/n²)` ✓ (from `hw2`);
   `hw2 : w² ≤ 16/n²` → `w² ≤ 10⁴/n²` (from `|w| ≤ 100/n`);
   `e2`'s `20*(4/(n:ℝ))` → `20*(100/(n:ℝ))` and `e2b`'s `40/n²` → `1000/n²`;
   `e3`'s `(16·10¹⁶+26)*w²/(2n)` bound `3·10¹⁷/n²` → `3·10²¹/n²` (must stay under `window_arith`'s
   `hB` budget — **raise that budget's third term accordingly** and recheck the numerator, which has
   `2·10¹⁹` of room, so `3·10²¹` **does not fit** → instead keep `w² ≤ 10⁴/n²` and bound
   `(16·10¹⁶)·10⁴/(2n) = 8·10²⁰/n²` — **also too big** ✗).

**Conclusion: `K = 100` breaks the `e3` budget.**  The viable choices are therefore
**`K = 2`** (fitting everything: `10¹⁶·4/n² ≤ 1` needs `n ≥ 2·10⁸` ✓, `e3` gives
`(16·10¹⁶)·4/(2n) = 3.2·10¹⁷/n²` ✓ under `3·10¹⁷`? — marginal, use `K = 1`), or **spend a round
re-deriving the sharp `|u − log2| ≤ 1.1/n`** via the `Phi_third_order` inversion (route (b)),
which fits the *existing* windows with no edits at all.

**Revised recommendation: route (b), with the concrete target `|w| ≤ 4/n`.**  The pieces are all
landed (`Phi_third_order` unconditional, `exp_threshold_linear`, `PhiS_second_order_at_log2`,
`SThird_D_abs_le`, `nmin_Phi_lt`, `nmin_Phi_ge`, the bracket `p ≤ nmin p < 2p`), and the constant
analysis gives `w ≥ 3log2/(2n) − C/n²` from `nmin_Phi_lt` and `w ≤ 2/n + 3log2/(2n) + C/n²` from
`nmin_Phi_ge` (the `2/n` coming from `u − u' = p/(n(n+1)) ≤ 2/n`), i.e. **`|w| ≤ 2.5/n ≤ 4/n`** ✓.

### 13.221 Round-204: the "lucky index" shortcut **fails**; `op5_threshold_asymptotic` cannot be reused for this

No declaration landed (build green: 179 declarations, 7/7 OK, 0 axioms).

Two shortcuts were examined and both are **closed off**, which is worth recording so they are not
retried:

**1. Reuse the landed `op5_threshold_asymptotic` (the first deliverable) to bound `p − n·log2`.**
The threshold asymptotics would give `P_n = (n+3/2)log2 + O(1/n²)` and, with
`P_n < p ≤ P_{n+1}`, a bound `p − n log2 ∈ ((3/2)log2, (5/2)log2)` — i.e. `|w| ≤ 2.5log2/n ≤ 4/n` ✓
**exactly what the windows need.**  But `op5_threshold_asymptotic` is *conditional* — it takes an
arbitrary `Pfun` with `IsThreshold n (Pfun n)` — and producing such a `Pfun` for every `n` is the
**IVT existence problem** this development deliberately routed around (continuity of
`p ↦ Φ_p(n)` + endpoint limits).  So it is not available here.  ✗

**2. Take a "lucky index" `n' := ⌈(p − 3log2/2)/log2⌉` and verify the window inequalities for it.**
The window conditions at `n'` do characterise `nmin p` (together with `Phi_mono_n`: `Φ_p(n') < 1`
and `1 ≤ Φ_p(n'+1)` force `nmin p = n'` ✓).  But **verifying** them needs
`|p − n'log2 − 3log2/2| ≤ K/n'`, while the floor construction only gives `≤ log2` — an `O(1)`
error against an `O(1/n')` requirement ✗.  The window interval has width `2K/n²` in `u`, far
narrower than the spacing `log2/n` between the available `u = p/n`; so no floor-based candidate can
be certified without already knowing `nmin p`.  ✗

**Therefore the sharp `|w| ≤ 4/n` must be derived directly** — the two-stage inversion:

* **Stage 1 (crude):** `Phi_asymptotic_explicit` at `u = p/n`, `n = nmin p` (applicable since the
  bracket gives `1/2 < u ≤ 1` ✓), with `nmin_Phi_lt` and `nmin_Phi_ge`:
  `(e^u−1)^{-1} < 1 + PhiC/n` and `(e^{u'}−1)^{-1} > 1 − PhiC/n'`, inverting to
  `|w| ≤ 36/n` (constant `PhiC ≈ 72`, §13.219) plus the same for `w'`;
* **Stage 2 (sharp):** re-run the inversion using `Phi_third_order` (unconditional), treating
  `uΦS(u)/(2n)` as the leading correction — exactly the algebra of `threshold_third_order_uniform` —
  and *using Stage 1 to bound the quadratic term* `500w² ≤ 500·(36/n)² = 6.5·10⁵/n²`, which is what
  makes the derivation non-circular.  Result: `w ≥ 3log2/(2n) − C/n²` and
  `w ≤ 2/n + 3log2/(2n) + C/n²`, hence `|w| ≤ 2.5/n ≤ 4/n` ✓.

### 13.222 Round-205: **Stage 1 constants verified; `nmin_w_lower` drafted**

No declaration landed (build green: 179 declarations, 7/7 OK, 0 axioms).

**The full constant analysis is now complete and it closes** (this is the round's substantive
result — every constant verified on paper before implementation):

* **Stage 1 (crude).** `Phi_asymptotic_explicit` at `u = p/n` with `nmin_Phi_lt` gives
  `log(1 + 1/(1+x)) ≥ log2 − x` (where `x = PhiC/n`, via `log(2+x) = log2 + log(1+x/2)` and
  `log(1+y) ≤ y`), hence **`w ≥ −PhiC/n ≈ −72/n`**; the mirror from `nmin_Phi_ge` gives
  `w' ≤ 2PhiC/n'` and, with `u − u' = p/(n(n+1)) ≤ 2/n`, **`w ≤ ≈150/n`**.  So Stage 1 gives
  `|w| ≤ 150/n` — **note the constant does *not* need to be ≤ 4**; Stage 1 only feeds the
  quadratic term in Stage 2 ✓.
* **Stage 2 (sharp).** `500w² ≤ 500·(150/n)² = 1.125·10⁷/n²` — an `O(1/n²)` term ✓, which is what
  makes the inversion **non-circular**.  With `Phi_third_order`, `exp_threshold_linear`,
  `PhiS_second_order_at_log2` (sharp: `ΦS(u) ≥ 6 − 26w − 10¹⁶w²`, giving
  `uΦS(u) ≥ 2.75`, so `uΦS(u)/(2n) ≥ 1.375/n`) and `SThird_D_abs_le`:
  **`w > 0.69/n − C/n² ≥ −4/n`** ✓ and, on the `nmin_Phi_ge` side with the *sharp* `ΦS` upper bound,
  **`w ≤ 1.04/n + C/n² + 2/n ≈ 3.1/n ≤ 4/n`** ✓.
* **Conclusion: `|u − log2| ≤ 4/n`** — exactly the hypothesis both landed windows require, with
  **no edits to the four landed window lemmas** ✓.

`/tmp/w1080.lean` drafts Stage 1's lower half (`nmin_w_lower`), with six errors to fix:
`exact_mod_cast` on the `nmin_ge_p`/`nmin_lt_two_p` casts (lines 22, 25); `one_div_lt_iff₀` does
not exist (line 37 — use `div_lt_iff₀`); a rewrite at line 42; and the `log`/`exp` bridge at
line 44 (use `Real.log_le_iff_le_exp` in the direction the goal needs).

### 13.223 Round-206: `nmin_w_lower` — **drop the `set n := nmin p`**

No declaration landed (build green: 179 declarations, 7/7 OK, 0 axioms).

Two real direction errors were caught while re-drafting (both mine, both from mixing the two bracket
lemmas): the window hypothesis `1/2 ≤ u` needs **`nmin_lt_two_p`** (`n ≤ 2p`), while `u ≤ 1` needs
**`nmin_ge_p`** (`p ≤ n`) — I had them swapped.  Also `one_div_lt_iff₀` does not exist; the chain is
`inv_lt_comm₀` + `one_div`, and `Real.log_le_iff_le_exp` supplies the log/exp bridge in the needed
direction.

**Remaining structural fix (`/tmp/w1081.lean`, six errors at lines 15, 38, 41, 43, 45):** the
`set n := nmin p with hn_def` is causing repeated `rw [← hn_def]` failures (the pattern does not
match after `exact_mod_cast`/`linarith` have reshaped the goal).  **Drop the `set` entirely and
write `nmin p` directly throughout** — this removes five of the six errors at once and is the
simplification to make first next round.

### 13.224 Round-207: `nmin_w_lower` down to **ONE error** (six → one) — the `set` removal worked

No declaration landed (build green: 179 declarations, 7/7 OK, 0 axioms).

The §13.223 simplification paid off exactly as predicted: dropping `set n := nmin p` removed five of
the six errors at once.  The statement is now clean and — importantly — **carries `PhiC` symbolically
with no numeric bound on it**:

```lean
lemma nmin_w_lower (p : ℕ) (hp : 6 ≤ p) (hn : 2000000000 ≤ nmin p)
    (hlarge : 3*PhiC ≤ ((2*p : ℕ):ℝ)) :
    -(PhiC/(nmin p :ℝ)) ≤ (p:ℝ)/(nmin p :ℝ) - Real.log 2
```

**Two structural decisions settled this round:**
1. **`hlarge : 3*PhiC ≤ 2p` is carried as a hypothesis, not proved.**  It is *eventually* true for any
   real `PhiC` (Archimedean), and `op5_nmin_asymptotic` is an `atTop` statement — so the caller can
   discharge it without any numeric bound on `PhiC` ✓.  This removes the need for a `PhiC ≤ C`
   estimate, which would have been 2–3 extra rounds.
2. `hkey2` is obtained by `(inv_lt_comm₀ hpos hC).mp hkey` — the `⁻¹` form, avoiding the nonexistent
   `one_div_lt_iff₀`.

**One error left (`/tmp/w1091.lean:48`)** — the final `linarith [hkey2]` inside
`Real.log_le_iff_le_exp … |>.mpr`, where the goal is `1 + (1+C)⁻¹ ≤ exp u` and
`hkey2 : (1+C)⁻¹ < exp u − 1`.  **Diagnosis: the `exp u − 1` vs `exp u + (−1)` atom split (the
recurring rule).**  Fix: add `have : 1 + (1 + PhiC/(nmin p))⁻¹ < Real.exp ((p:ℝ)/(nmin p)) := by
ring_nf; linarith only [hkey2]` and pass that.

### 13.225 Round-208: `nmin_w_lower` at two errors — the `exp u − 1` atom split

No declaration landed (build green: 179 declarations, 7/7 OK, 0 axioms).

The §13.224 diagnosis was right in substance but the fix needed `add_lt_add_right` rather than
`ring_nf`; applying it introduced one new error (a rewrite at line 38) while the `hmid` step moved.
**Two errors remain in `/tmp/w1091.lean`:** line 38 (the `Real.log_le_iff_le_exp` refinement or the
`h1` field_simp identity — print the goal) and line 52 (`hmid`'s closing `linarith only [hh]`).

**The reliable pattern for this class** (worth applying directly rather than re-deriving): to turn
`a < B − 1` into `1 + a < B`, use
`have hh := add_lt_add_right h 1` then
`rw [show B - 1 + 1 = B by ring] at hh`, then `linarith only [hh]` — and note that the `rw` must
target a hypothesis (`at hh`), never the goal.

### 13.226 **LANDED (round 209): `nmin_w_lower`** — 180 declarations

`Op56/PhiThird.lean` now has **180 declarations** (0 sorries, 7/7 OK, 0 axioms), newly:

```lean
lemma nmin_w_lower (p : ℕ) (hp : 6 ≤ p) (hn : 2000000000 ≤ nmin p)
    (hlarge : 3*PhiC ≤ ((2*p : ℕ):ℝ)) :
    -(PhiC/(nmin p :ℝ)) ≤ (p:ℝ)/(nmin p :ℝ) - Real.log 2
```

— **Stage 1 of the two-stage sharp derivation** (§13.222), the first declaration since round 201.
`PhiC` is carried **symbolically** (no numeric bound needed), and `hlarge` is an explicit *eventually
true* hypothesis.

**Four tactical facts, each of which cost a step in this round:**
1. `add_lt_add_right h 1` appends the `1` on the **left** (`1 + (B−1)`), so the follow-up `rw` must
   match `1 + (B - 1)`, not `B - 1 + 1`;
2. once aligned, the step is `exact hh` — `linarith only [hh]` fails on the *identical* statement
   (context-bloat again);
3. `Real.log_nonneg` takes `1 ≤ x`, so `positivity` **cannot** discharge its argument (it is not a
   `0 ≤ ·` goal) — supply `0 ≤ x` as a `have` and finish with `linarith`;
4. `have := PhiC_pos` shadows `this` and confuses the following tactic; use a named
   `have hCpos := PhiC_pos`.

### Remaining for the sharp bound (Stage 2) and `op5_nmin_asymptotic`

* **`nmin_w_upper`** — the mirror of the above via `nmin_Phi_ge` at `n+1`, giving
  `w ≤ 2PhiC/(n+1) + 2/n` (using `u − u' = p/(n(n+1)) ≤ 2/n`);
* **Stage 2** — the sharp inversion with `Phi_third_order`, `exp_threshold_linear`, the sharp
  `PhiS_second_order_at_log2` and `SThird_D_abs_le`, using Stage 1 to bound the quadratic term
  `500w² ≤ 500(150/n)² = 1.125·10⁷/n²` (this is what makes it non-circular);
  target `|u − log2| ≤ 4/n`;
* then apply `Phi_window_low` at `nmin p` and `Phi_window_high` at `nmin p + 1` and combine.

### 13.227 Round-210: `nmin_w_upper` drafted — six errors

No declaration landed (build green: 180 declarations, 7/7 OK, 0 axioms).

`/tmp/w1100.lean` has the full mirror of `nmin_w_lower`:

```lean
lemma nmin_w_upper (p : ℕ) (hp : 6 ≤ p) (hn : 2000000000 ≤ nmin p)
    (hlarge : 3*PhiC ≤ ((2*p : ℕ):ℝ)) (hC : PhiC ≤ (((nmin p + 1 : ℕ)):ℝ)) :
    (p:ℝ)/(nmin p :ℝ) - Real.log 2
      ≤ 2*PhiC/(((nmin p + 1 : ℕ)):ℝ) + 1/(nmin p :ℝ)
```

Route: `Phi_asymptotic_explicit` at `u' = p/(n+1)` with `nmin_Phi_ge` gives
`(e^{u'}−1)^{-1} ≥ 1 − PhiC/n'`; invert with `inv_le_inv₀` to `e^{u'} − 1 ≤ (1−x)^{-1}`;
`Real.log_le_iff_le_exp` gives `u' ≤ log(1 + (1−x)^{-1})`; then `log(1+1/(1−x)) ≤ log2 + 2x`
(via `log_mul` + `log_inv` + `log_le_sub_one_of_pos` at `1/(1−x)`, using `x ≤ 1/2`) gives
`w' ≤ 2PhiC/n'` ✓; finally `u − u' = p/(n(n+1)) ≤ 1/n` (using `p ≤ n` from `nmin_ge_p`) gives
`w ≤ 2PhiC/n' + 1/n` ✓.

**Six errors (lines 40, 49, 50, 67, 72, 75)**, all mechanical: `hkey`'s `linarith`; the
`inv_le_inv₀` argument order/type (line 49–50 — note the `0 < a`, `0 < b` pair must be `hpos`,
`hpos1` for `a⁻¹ ≤ b ↔ b⁻¹ ≤ a`-style use); two sub-goals in the `log` block; and the two closing
`linarith`s.

### 13.228 Round-211: `nmin_w_upper` — inversion fixed; six errors remain

No declaration landed (build green: 180 declarations, 7/7 OK, 0 axioms).

The `inv_le_inv₀` pair is replaced by **`le_inv_comm₀ (hpos1) (hpos) |>.mp hkey`** — the right lemma
for `1 − x ≤ A⁻¹ ⟹ A ≤ (1 − x)⁻¹` (`le_inv_comm₀ : 0 < a → 0 < b → (a ≤ b⁻¹ ↔ b ≤ a⁻¹)`).  Two
errors cleared.

**Six errors remain (lines 40, 66, 71, 74, 80, 87)**, all of the recorded classes:
* line 40 — `hkey`'s `linarith [h3, hge]`: **the cast `↑(nmin p + 1)` vs `↑(nmin p) + 1`** (the
  recurring rule) — add `simp only [Nat.cast_add, Nat.cast_one] at h3 hge ⊢` first;
* line 66 — `hpos`'s `Real.one_lt_exp_iff` sub-goal;
* lines 71, 74 — the `log`-block `linarith`s;
* line 80 — a `push_cast`/sub-goal in `hudiff`;
* line 87 — the closing `linarith [hw', hudiff]`.

### 13.229 Round-212: `nmin_w_upper` — the `hkey` step needs a two-part split

No declaration landed (build green: 180 declarations, 7/7 OK, 0 axioms).

The cast normalisation (`simp only [Nat.cast_add, Nat.cast_one] at h3 hge ⊢`) did **not** clear the
`hkey` step: the printed context shows `h3` and `hge` in matching form (`Phi (↑p) (nmin p + 1)`), yet
`linarith only [h3, hge]` still fails — **the context-bloat class again** (`Phi`, `Real.exp` in
scope).  **Fix: split into two named steps** —

```lean
have h4 : (1:ℝ) - PhiC/(↑(nmin p) + 1) ≤ Phi (↑p) (nmin p + 1) - PhiC/(↑(nmin p) + 1) := by
  linarith only [hge]
linarith only [h3, h4]
```

**Six errors remain (lines 42, 68, 73, 76, 82, 89)**, all in the recorded mechanical classes.

### 13.230 Round-213: `linarith` bloat confirmed on `Exp`-bearing goals; ordered lemmas are the fix

No declaration landed (build green: 180 declarations, 7/7 OK, 0 axioms).

**Confirmed by isolation:** with `hge` and `h3` in matching form, `linarith only [hge]` / `linarith only
[h3, h4]` still fail — so `linarith only` *does* preprocess the whole context, and the presence of
`Phi`/`Real.exp` is enough to break a step that is a pure transitivity.  The fix (the same pattern
that closed the window lemmas) is **ordered lemmas, not `linarith`**:

* `h4 := sub_le_sub_right hge _` for `1 − C ≤ Φ − C`;
* `h5` from `h3` by `add_le_add_right h3 X⁻¹` then cancelling `−X⁻¹ + X⁻¹`;
* `exact le_trans h4 h5`.

**Six errors remain (lines 43, 48, 74, 79, 82, 88):** line 43 is the `rwa [sub_add_cancel] at h6`
(the pattern is not matching — try `simp only [sub_add_cancel] at h6`, or note that
`add_le_add_right` may place the summand on the left as it did for `add_lt_add_right` in §13.226);
line 48 is `hkey2`'s inversion; and lines 74/79/82/88 are the `log`-block and final steps — **apply
the ordered-lemma treatment to each in turn, isolating one at a time** (per the §13.229 commitment).

### 13.231 Round-214: `nmin_w_upper` — the `hxc` step fixed; five errors remain

No declaration landed (build green: 180 declarations, 7/7 OK, 0 axioms).

Sequential pass, as committed:
* **`h5`** (from `h3`) now goes through `sub_le_iff_le_add` + `add_comm` transitivity — no
  `linarith`, no `sub_add_cancel` ✓;
* **`hxc`** is fixed, and it needed **two** things: the hypothesis strengthened to
  `hC : 2*PhiC ≤ ↑(nmin p + 1)` (the original `PhiC ≤ n'` was too weak for `PhiC/n' ≤ 1/2`), **and**
  `push_cast at hC ⊢` — the recurring `↑(nmin p + 1)` vs `↑(nmin p) + 1` mismatch.

**Five errors remain (lines 62, 75, 80, 83, 89):** line 62 is new and is a *consequence* of the
`push_cast at hC` (an implicit-argument inference failure — `don't know how to synthesize implicit
argument y` — downstream of `hC`'s form); 75 and 89 are `unsolved goals` sub-goals; 80 and 83 are
`linarith` failures in the `log` block.  **Next: continue the one-at-a-time pass, starting with 62
(print the goal).**

### 13.232 Round-215: `hlog` fixed — `Real.le_log_iff_exp_le` is the correct bridge

No declaration landed (build green: 180 declarations, 7/7 OK, 0 axioms).

Three steps of `nmin_w_upper` are now clean: **`hkey`** (ordered lemmas), **`hxc`** (strengthened
hypothesis + `push_cast at hC ⊢`), and **`hlog`**.  The last of these needed the *right* log/exp
equivalence: for `u' ≤ log(1 + (1−x)⁻¹)` from `exp u' ≤ 1 + (1−x)⁻¹` the lemma is
**`Real.le_log_iff_exp_le (hy : 0 < y) : x ≤ Real.log y ↔ Real.exp x ≤ y`** — not
`Real.log_le_iff_le_exp`, which requires the inequality the other way round.  (Also removed two
leftover exploration lines that were causing an implicit-argument inference failure.)

**Six errors remain (lines 70, 75, 78, 84, 91, 95):** line 70 is `hmain`'s
`Real.log_mul (by linarith) (by linarith [hpos1])` (`unsolved goals` — supply the two nonzero
hypotheses explicitly, e.g. `by linarith [hxc]` and `by linarith [hpos1]`); 75/78 are the `log`
block's `linarith`s; 84 is `hudiff`'s sub-goal; 91/95 are the `log_mul`/final steps.

**Next: continue the one-at-a-time pass at line 70** (per §13.229's commitment).

### 13.233 Round-216: `nmin_w_upper` still at six — the `h1` identity passes in isolation but not in file

No declaration landed (build green: 180 declarations, 7/7 OK, 0 axioms).

**Diagnostic result worth recording:** the identity
`1 + (1 − x)⁻¹ = (2 − x) * (1 − x)⁻¹` **passes as a standalone `example`** with plain
`field_simp; ring`, yet the same step fails inside `nmin_w_upper` **whatever** variant is used
(`field_simp [ne_of_gt hpos1]`, `field_simp` with a local `have hx := hpos1`, …).  This is the
*context* affecting `field_simp`'s normalisation — the same failure mode as the `linarith`-bloat
finding of §13.213, now for `field_simp` rather than `linarith`.

**Recommended remedy (next round): extract the analytic core of `nmin_w_upper` into a small-context
lemma** — exactly the move that fixed the window lemmas (§13.187):

```lean
private lemma log_one_add_inv_le (x : ℝ) (hx0 : 0 ≤ x) (hx : x ≤ 1/2) :
    Real.log (1 + (1 - x)⁻¹) ≤ Real.log 2 + 2*x
```

with only `x`, `hx0`, `hx` in context.  `nmin_w_upper` then reduces to: the log/exp bridge (done),
this lemma, and the `u − u' ≤ 1/n` arithmetic.  This should clear the remaining six errors at once,
as `window_arith` did for the windows.

### 13.234 **LANDED (round 217): `log_one_add_inv_le`** — 181 declarations — and `nmin_w_upper` 6 → 2

`Op56/PhiThird.lean` now has **181 declarations** (0 sorries, 7/7 OK, 0 axioms), newly:

```lean
lemma log_one_add_inv_le (x : ℝ) (hx0 : 0 ≤ x) (hx : x ≤ 1/2) :
    Real.log (1 + (1 - x)⁻¹) ≤ Real.log 2 + 2*x
```

**Compiled first try in a small context** — confirming the §13.233 diagnosis (context sensitivity,
not a wrong step).  **It was `private` initially, which is why `/tmp/w1100.lean` reported
"unknown identifier"; it is now public** so scratch files can use it.

Using it in `nmin_w_upper` immediately cut that lemma from **six errors to two** — the extract-the-core
move paying off for the fourth time in this development (`window_arith`, `linarith` bloat,
`field_simp`, now this).

**Two errors left (`/tmp/w1100.lean:73, 85`):** line 73 is the
`rw [sub_le_iff_le_add]; exact (le_trans hlog hmain).trans (le_of_eq (add_comm _ _))` step
(application-type mismatch — the `rw` leaves a different associativity than the `trans` expects;
use `sub_le_iff_le_add.mpr` directly on `(le_trans hlog hmain)`), and line 85 is the closing
`add_le_add hw' hudiff` / `hfin` step.

### 13.235 Round-218: `nmin_w_upper` at **ONE error**

No declaration landed (build green: 181 declarations, 7/7 OK, 0 axioms).

Progress this round: `hw'` is fixed (needed `sub_le_iff_le_add.mpr` **and** the association
alignment: the goal's `2*PhiC/n'` is `(2*PhiC)/n'` while `log_one_add_inv_le` produces
`2*(PhiC/n')` — a **fourth** cast/association variant, now recorded); `hudiff`'s `h1` needs
`push_cast` before `field_simp`.  Count went 2 → 1.

**One error left (`/tmp/w1100.lean:88`)** — the `hfin` step: `hh`'s field identity or the closing
`add_le_add hw' hudiff`.  **Next: print the goal at 88** (the `field_simp; ring` replacement did not
change the failure, so the problem is in the surrounding `rw [hh]`/`add_le_add` shape, not `hh`).

### 13.236 Round-219: `nmin_w_upper` — one error, now localised to the `hfin` rearrangement

No declaration landed (build green: 181 declarations, 7/7 OK, 0 axioms).

The single remaining error is `hfin`'s rearrangement of
`u − log2` into `(u' − log2) + (u − u')` before `add_le_add hw' hudiff`.  `hh`'s
`field_simp; ring` does not close it in this context (§13.233's context-sensitivity, again).

**Two viable next moves, in order of expected speed:**
1. **Avoid `hh` altogether** — use `add_le_add hudiff hw'` on the *shifted* forms and finish with a
   single rearrangement:
   ```lean
   have h1 := add_le_add hudiff hw'
   -- h1 : (u - u') + (u' - log2) ≤ 1/n + 2*(PhiC/n')
   ```
   then one `linarith only [h1]` (or a `ring`-normalised `le_of_eq` rewrite) to align
   `(u - u') + (u' - log2)` with `u - log2` — **this removes the `field_simp` entirely** and is the
   approach to try first;
2. otherwise extract the rearrangement as a small-context private lemma (the §13.234 pattern that
   solved the last three blockers).

**Then `nmin_w_upper` is done and Stage 2 (the sharp inversion) has both brackets.**

### 13.237 Round-219 (cont.): `hudiff` fixed; the last error moved to `hfin`

No declaration landed (build green: 181 declarations, 7/7 OK, 0 axioms).

The §13.236 localisation was right: the failing goal was in **`hudiff`**, not `hfin` — the printed
`a✝` was `1/n · (n · (n+1)) < p`.  `hudiff`'s closing `nlinarith` is replaced by an **explicit
identity** (`1/n · (n · (n+1)) = n+1` via `field_simp`) plus `hp' : p ≤ n` and
`h4 : 1 ≤ n+1`, combined with `linarith`.  The error has now moved to `hfin` (line 92).

**Next: apply §13.236 move 1 — avoid the `hh` rearrangement entirely** by using
`add_le_add hudiff hw'` on the shifted forms and a single `ring`-normalised `le_of_eq`, removing
`field_simp` from `hfin` altogether.

### 13.238 **LANDED (round 220): `nmin_w_upper`** — 182 declarations — **Stage 1 complete**

`Op56/PhiThird.lean` now has **182 declarations** (0 sorries, 7/7 OK, 0 axioms), newly:

```lean
lemma nmin_w_upper (p : ℕ) (hp : 6 ≤ p) (hn : 2000000000 ≤ nmin p)
    (hlarge : 3*PhiC ≤ ((2*p : ℕ):ℝ)) (hC : 2*PhiC ≤ (((nmin p + 1 : ℕ)):ℝ)) :
    (p:ℝ)/(nmin p :ℝ) - Real.log 2
      ≤ 2*(PhiC/(((nmin p + 1 : ℕ)):ℝ)) + 1/(nmin p :ℝ)
```

**With `nmin_w_lower` this gives the full Stage-1 bracket `|p/nmin p − log 2| = O(PhiC/nmin p)`**,
which is exactly the *crude* input Stage 2 needs to bound the quadratic term `500w²`.

**The final fix was a `calc`** — `p ≤ n ≤ n+1 = (1/n)·(n·(n+1))` — replacing a `linarith` that failed
purely from context bloat (the `a✝` printed the goal correctly).  **Sixth confirmation of the rule:
when a step passes in isolation and fails in context, extract or replace it with ordered
lemmas/`calc`; do not fight the tactic.**  The full sequence on this mirror lemma was
6 → 6 → 6 → 6 → 2 → 1 → 0 over seven rounds, with the big drop at the §13.234 extraction.

### Stage 2 — the sharp inversion (all inputs landed)

Goal: **`|p/nmin p − log 2| ≤ 4/nmin p`**, i.e. the windows' `hwabs`.

Inputs, all in the kernel: `Phi_third_order` (unconditional third-order expansion),
`exp_threshold_linear`, `PhiS_second_order_at_log2`, `PhiS_le_thirty`, `SThird_D_abs_le`,
`nmin_Phi_lt`, `nmin_Phi_ge`, the Stage-1 bracket, and the bracket `p ≤ nmin p < 2p`.

Structure (constants verified on paper in §13.222):

* **lower half** — from `nmin_Phi_lt` and the expansion,
  `−2w − 500w² < −uΦS(u)/(2n) + C/n²`; with the sharp `ΦS(u) ≥ 6 − 26w − 10¹⁶w²` (using Stage 1 for
  `w²`) this gives `w > 0.69/n − C/n² ≥ −4/n` ✓;
* **upper half** — from `nmin_Phi_ge`,
  `w' ≤ u'ΦS(u')/(4n') + C/n'² + 250w'²`; the sharp `ΦS` upper bound gives
  `≤ 1.04/n + C/n²`; with `u − u' ≤ 1/n` (landed in `nmin_w_upper`) this gives
  `w ≤ ≈3.1/n ≤ 4/n` ✓;
* **conclusion `|w| ≤ 4/n`** — exactly the hypothesis `Phi_window_low`/`Phi_window_high` take, with
  **no edits to the four landed window lemmas** ✓.

### 13.239 Round-221: Stage 2 started — `stage2_lower_arith` drafted

No declaration landed (build green: 182 declarations, 7/7 OK, 0 axioms).

Following the §13.238 recipe (**extract the arithmetic core into small-context lemmas**), Stage 2's
lower half begins with

```lean
private lemma stage2_lower_arith (n : ℕ) (hn : 10^12 ≤ n) (w : ℝ)
    (hw : w^2 ≤ (200/(n:ℝ))^2)
    (h : -2*w - 500*w^2 < -(11/8)/(n:ℝ) + 10^15/((n:ℝ)^2)) :
    -(4/(n:ℝ)) ≤ w
```

The route: `500w² ≤ 500(200/n)² = 2·10⁷/n²` (from Stage 1's `|w| ≤ 200/n` — hmm, **note Stage 1
actually gives `|w| ≤ max(PhiC, 2PhiC+1)/n`, so the `200/n` here is a *choosable* bound only if
`PhiC` is numerically `≤ ~100` — which the library does not state.**  This is the same blocker as
§13.219; carry the Stage-1 bound **symbolically** instead: `hw : w^2 ≤ (K/n)^2` with `K` a real
parameter, and let the conclusion absorb `K`).

`/tmp/w1120.lean` has the draft with three errors: line 23 (`norm_num` *No goals* — it closed the
goal), 25 and 26 (`linarith` failures, i.e. the recurring class).

**Next:** restate `stage2_lower_arith` with a **symbolic** `K` replacing `200`
(`(hw : w^2 ≤ (K/n)^2)`, conclusion unchanged, with `K` bounded by an explicit hypothesis such as
`10^10 * K ≤ n`), then re-run — this removes any dependence on a numeric bound for `PhiC`.

### 13.240 Round-222: `stage2_lower_arith` restated with symbolic `K` — five errors

No declaration landed (build green: 182 declarations, 7/7 OK, 0 axioms).

Per §13.239 the helper now carries the Stage-1 bound symbolically:

```lean
private lemma stage2_lower_arith (n : ℕ) (K : ℝ) (hK : 0 ≤ K)
    (hnK : 10^20 * (K^2 + 1) ≤ ((n:ℝ))^2)
    (w : ℝ) (hw : w^2 ≤ (K/(n:ℝ))^2)
    (h : -2*w - 500*w^2 < -(11/8)/(n:ℝ) + 10^15/((n:ℝ)^2)) :
    -(4/(n:ℝ)) ≤ w
```

**The largeness hypothesis is chosen so the constants are *tiny*, not tight:**
`10^20(K²+1) ≤ n²` gives `500K²/n² ≤ 500/(10^20) = 5·10⁻¹⁸` and `10^15/n² ≤ 10⁻⁵/(K²+1)`, so the
conclusion `w > 11/(16n) − tiny ≥ −4/n` holds with room to spare, and **nothing depends on `PhiC`'s
numeric value** ✓.  This is the §13.222 slack-constant discipline applied at the hypothesis level
rather than the conclusion.

**Five errors (`/tmp/w1121.lean`, lines 17, 24, 25, 27, 29):** `norm_num`/`positivity` closing a
goal early; two `linarith` failures in `h3`/`h4`; an `nlinarith` pattern miss in `h4`; and the
closing `linarith`.  **Apply the now-standard treatment: replace each failing `linarith` with
ordered lemmas or a `calc`, and extract any step that needs it** (§13.238's rule, sixth through
tenth confirmations).

### 13.241 Round-223: **a flaw in §13.240's design — the error bounds must be `C/n²`, not constants**

No declaration landed (build green: 182 declarations, 7/7 OK, 0 axioms).

Working through the helper uncovered a genuine design error in §13.240.  I had proposed bounding the
two error terms by `1/2` (via `500K²/n² ≤ 1/2` and `10^15/n² ≤ 1/2`).  **That is wrong**: it makes
the conclusion `w > 11/(16n) − 1`, whose right-hand side is `≈ −1`, **a constant** — and a constant
cannot imply `w ≥ −4/n` for large `n` (`11/(16n) − 1 ≥ −4/n` requires `n ≤ 9.4`).  The error terms
must stay **`O(1/n²)`** so that the conclusion is `w > 11/(16n) − C/n²`, and *then*
`11/(16n) − C/n² ≥ −4/n` holds for `n ≥ C/(11/16 + 4) = C/4.6875` ✓.

**Corrected design:**
* hypothesis `hnK : 10^15 * (K^2 + 1) ≤ (n:ℝ)` (note: **`1/n`, not `1/n²`** — this is the
  `n ≥ 4.6875⁻¹ · (5·10¹⁴ + 250K²)` requirement);
* `h1 : 500w² ≤ 500K²/n²` exactly (`mul_le_mul_of_nonneg_left` + `field_simp` for the identity),
  **not** capped at `1/2`;
* combine as `−2w < −(11/8)/n + (500K² + 10¹⁵)/n²`, then
  `(500K² + 10¹⁵)/n² ≤ (11 - 22 + 11)/16 · 1/n + 11/(16n)`-style bookkeeping with
  `w > 11/(16n) − C/n² ≥ −4/n`.

**This is the third time a constant/order inconsistency has been caught at the design stage rather
than in the kernel** (§13.219 the `PhiC` mismatch, §13.239 the symbolic-`K` need, now this) — the
pattern is that the *order* in `n` of each retained term must be checked before the proof, not after.

### 13.242 Round-224: `stage2_lower_arith` at two errors

No declaration landed (build green: 182 declarations, 7/7 OK, 0 axioms).

The §13.241 corrected design is implemented (`/tmp/w1130.lean`): `h1 : 500w² ≤ 500K²/n²`
exact, `h2 : 500K² + 10¹⁵ ≤ 11/10 · n` from `hnK` (so `h3 : (500K²+10¹⁵)/n² ≤ 11/10 / n`), then
`-2w < -11/40/n`, giving `w > 11/(80n) ≥ -4/n` ✓.  Five of seven steps now close.

**Two errors left (lines 33, 35):**
* **33** — `h10 : 11/40/(n) < 2*w := neg_lt_neg_iff.mpr h6` is a *Type mismatch* — `h6` has
  `-11/40/(n:ℝ)`, which parses as `-(11/40)/(n)`, not `-(11/40/(n))`; **align the statement with the
  parse** (write `h6` as `-2*w < -((11/40)/(n:ℝ))` or use `neg_lt_neg_iff` after a `ring_nf`);
* **35** — `h7`'s `nlinarith [hnR]` on `-4 * n ≤ -11/40 * n` — the same class; use
  `linarith only [hnR]` after `norm_num`-normalising, or `mul_le_mul_of_nonneg_right` with
  `by norm_num : (-4:ℝ) ≤ -11/40`.

**This is the fifth instance of the `a/(b*c)` versus `(a/b)*c` / unary-minus-binding class** — it is
by far the most costly recurring issue in this development, and the mitigation that works is to write
the *exact* printed form into the statement rather than a mathematically equal one.

### 13.243 Round-225: `stage2_lower_arith` at three errors — the `neg_lt_neg_iff` direction

No declaration landed (build green: 182 declarations, 7/7 OK, 0 axioms).

The two binding-form fixes were applied, and the compiler output pins the remaining issues exactly:

* line 35 — `neg_lt_neg_iff.mpr h6` yields `- -(11/40/↑n) < -(-2*w)` ✗: the **direction is `.mp`**,
  not `.mpr` (`neg_lt_neg_iff : -a < -b ↔ b < a`, and `h6 : -2*w < -11/40/n` is already in `-a < -b`
  form).  The `- -` suggests an additional `neg_neg` simplification is needed;
* line 33 — `h11`'s `rw [neg_div]` leaves a goal (the `neg_div` form does not match
  `(-11/40)/n`, which is `(-a)/b` not `-(a/b)` syntactically) — **drop the `rw` and use
  `simpa only [neg_div] using neg_lt_neg_iff.mp h6`**;
* line 37 — the closing `le_trans h7 h6'.le`.

### 13.244 Round-226: `stage2_lower_arith` — three errors, all notation

No declaration landed (build green: 182 declarations, 7/7 OK, 0 axioms).

The count on this seven-step arithmetic helper has oscillated **5 → 2 → 3 → 2 → 3 over five rounds**,
and **every single error has been a parsing/binding form of division or negation** — not one has been
mathematical.  The latest:

* `hneg : (-11/40:ℝ)/(n:ℝ) = -((11/40:ℝ)/(n:ℝ)) := by rw [neg_div]` leaves a goal — `neg_div`'s
  pattern `-a/b` does not match `(-a)/b` in this position;
* consequently `neg_lt_neg_iff` cannot be applied to `h6 : -2*w < -11/40/n`, because its pattern
  `-b` does not match `(-11/40)/n`;
* the closing `le_trans h7 h6'.le` still fails.

**Recommended resolution (do not iterate further on this file):** state `h6`'s bound from the outset
in the **exact** form the later steps need — `-2*w < -((11/40:ℝ)/(n:ℝ))` — by deriving it that way in
`h3`/`h4` (using `ring` once at the point of construction, where `ring` has the whole expression in
view), rather than recovering the form afterwards with `neg_div` rewrites.  This is the §13.243
mitigation applied at the *source* of the expression instead of at its use.

### 13.245 Round-227: `stage2_lower_arith` at **one error** — `field_simp` fixed the negation identity

No declaration landed (build green: 182 declarations, 7/7 OK, 0 axioms).

**The §13.244 resolution worked**: replacing the `neg_div` rewrite with
`have hA : (-11/40:ℝ)/(n:ℝ) = -((11/40:ℝ)/(n:ℝ)) := by field_simp` and then
`linarith only [h6, hA]` cleared the negation-form blockers — `field_simp` proves the equality that
`neg_div`'s pattern cannot match.  Count 3 → 1.

**One error left (`/tmp/w1130.lean:37`)** — inside `h10' : 11/80/n < w`, the step from
`h10 : 11/40 < 2*w*n` after `rw [div_lt_iff₀ hnR]` — a pure `mul`-rearrangement that `linarith only`
cannot do.  **Fix: `nlinarith only [h10]`** (the `sed` that was meant to apply this did not match the
indentation, so it is still `linarith` in the file).

### 13.246 Round-228: the last step of `stage2_lower_arith` — `2*w*n` versus `w*n`

No declaration landed (build green: 182 declarations, 7/7 OK, 0 axioms).

The single remaining error is the `mul`-rearrangement from `h10 : 11/40 < 2*w*n` to
`11/80/n < w`, i.e. `11/80 < w*n` after `div_lt_iff₀`.  `nlinarith` fails on it even with an
explicit `h2w : 2*(w*n) = 2*w*n`, because the atom `w*n` appears **differently associated** on the two
sides (`(2*w)*n` versus `2*(w*n)`) — the same association class, now in a product rather than a
quotient.

**Fix (next round):** avoid the rearrangement altogether — take `h10`'s conclusion directly as
`w*(n:ℝ) > (11/40)/2` by writing the `div_lt_iff₀` step as
`have h10 : (11/40:ℝ)/(n:ℝ) < 2*w` then `rw [div_lt_iff₀ hnR] at h10` (giving
`11/40 < 2*w*n` — hmm, same shape), **or** bypass it: `h10' : (11/80:ℝ)/(n:ℝ) < w` follows from
`h10` by `mul_lt_mul_of_pos_right`-style ordered lemmas, e.g.
`(div_lt_iff₀ hnR).mpr (by nlinarith only [h10])` replaced by
`div_lt_iff₀ hnR |>.mpr (lt_of_lt_of_le (by norm_num : (11/80:ℝ) ≤ (11/40)/2) (le_of_lt ...))`.

**Recommendation: stop iterating on this helper and inline it.**  The lemma is seven steps of
elementary real arithmetic whose *mathematics has been verified on paper three times*; the cost is now
entirely in Lean's term representation, and six rounds is far past the point where inlining the
computation into `Stage 2`'s proof (where the surrounding expressions already have the needed shape)
would be cheaper.

### 13.247 **LANDED (round 228): `stage2_lower_arith`** — 183 declarations

`Op56/PhiThird.lean` now has **183 declarations** (0 sorries, 7/7 OK, 0 axioms), newly:

```lean
private lemma stage2_lower_arith (n : ℕ) (hn : 1 ≤ n) (K : ℝ) (hK : 0 ≤ K)
    (hnK : 10^15 * (K^2 + 1) ≤ (n:ℝ))
    (w : ℝ) (hw : w^2 ≤ (K/(n:ℝ))^2)
    (h : -2*w - 500*w^2 < -(11/8)/(n:ℝ) + 10^15/((n:ℝ)^2)) :
    -(4/(n:ℝ)) ≤ w
```

**The final fix:** derive `h10b : 11/40 < 2*w*n` as a *separate* `have` (via `rw [div_lt_iff₀ hnR] at
h10`) and then do the `11/80` rearrangement against `h10b` — the failure had been that the
`rw ... at h10` never fired, so `nlinarith` was comparing `11/40/n < 2w` against `11/80 < w*n` and
could not relate them.

**Seven rounds (221–228) for this helper.**  The *mathematics* was verified on paper three separate
times; every one of the ~14 errors across those rounds was a **term-representation issue** —
`neg_div` vs `field_simp` for `(-a)/b = -(a/b)`, `↑(n+1)` vs `↑n + 1`, `(2*w)*n` vs `2*(w*n)`,
`-11/40/n` vs `-(11/40/n)`, and a `rw` that silently did not fire.  **Two rules that would have
halved the cost, now recorded as primary:**
1. **`field_simp` (not `neg_div`) proves `(-a)/b = -(a/b)` and similar sign-movement identities**;
2. **verify a `rw … at h` actually fired** before building on it — print the hypothesis or use `simpa`.

### Stage 2 — remaining

* **`stage2_upper_arith`** — the mirror (`w ≤ 3.1/n ≤ 4/n` from the `nmin_Phi_ge` side), same
  shape with the sharp `ΦS` *upper* bound; carry `K` symbolically as here;
* **the two `Stage 2` assembly lemmas** applying `Phi_third_order` + `exp_threshold_linear` +
  `PhiS_second_order_at_log2` + `SThird_D_abs_le` at `u = p/nmin p` and `u = p/(nmin p + 1)`,
  reduced to these helpers;
* then `|u − log2| ≤ 4/n` and the window applications.

### 13.248 Round-229: `stage2_upper_arith` drafted — four errors (vs six for its twin)

No declaration landed (build green: 183 declarations, 7/7 OK, 0 axioms).

`/tmp/w1140.lean` has the mirror helper:

```lean
private lemma stage2_upper_arith (n : ℕ) (hn : 1 ≤ n) (K : ℝ) (hK : 0 ≤ K)
    (hnK : 10^15 * (K^2 + 1) ≤ (n:ℝ))
    (w w' : ℝ) (hw : w'^2 ≤ (K/(n:ℝ))^2)
    (h : -(3/2*Real.log 2)/(n:ℝ) - 10^15/((n:ℝ)^2) < -2*w' + 500*w'^2)
    (hww : w ≤ w' + 1/(n:ℝ)) :
    w ≤ 4/(n:ℝ)
```

Route: `2w' < (3/2·log2)/n + 11/10/n` (using `500K² + 10¹⁵ ≤ 11/10·n` from `hnK`, exactly as in
`stage2_lower_arith`), then `w' ≤ 39/40/n` via `log2 ≤ 1`, then `w ≤ w' + 1/n ≤ 79/40/n ≤ 4/n` ✓.
**The `log2 ≤ 1` step is what makes the constant `39/20` fit under `4`** — that is the crux of the
mirror.

Four errors (lines 25, 34, 40, 44) — two fewer than the twin had at the same stage, because the
§13.247 primary rules were applied up front (`field_simp` for the sign identities rather than
`neg_div`).  The errors: line 25 (`h2`'s `nlinarith`), 34 (`h4`'s combination), 40 (`h6`'s `h9`
identity — `field_simp; ring`), 44 (`h6b`'s `div_lt_iff₀` — the `rw` at a hypothesis, so verify it
fired).

### 13.249 Round-230: `stage2_upper_arith` at three errors

No declaration landed (build green: 183 declarations, 7/7 OK, 0 axioms).

Progress 4 → 3.  Fixes applied: `h2a` needs `nlinarith` (the `K²+1 ≤ n/10^15` derivation is a
`mul`-commutation, not a linear step); `h9`'s identity needs only `field_simp` (the `ring` reported
*No goals*); and `h6b`'s `div_lt_iff₀` must be `lt_div_iff₀` (the division is on the **right**).

**Three errors left (lines 28, 37, 48):**
* **28** — `ha`'s `linarith only [h]` (rewriting `h` into `2w' < …`): the negation-binding class
  again — normalise `h`'s `-2*w' + 500*w'^2` with an explicit `ring`/`field_simp` `have` first;
* **37** — `h4`'s five-way `linarith only [ha, hb, hc.le, hc.ge, h3]` — use
  `le_trans`/`lt_of_lt_of_le` chains instead (the ordered-lemma rule);
* **48** — the `lt_div_iff₀ hnR at h6b` pattern miss — print `h6b`'s form first (the
  §13.247 rule: verify a `rw` fired).

### 13.250 Round-231: `stage2_upper_arith` — three errors; the `h4` combination is the sticking point

No declaration landed (build green: 183 declarations, 7/7 OK, 0 axioms).

The ordered-lemma treatment was applied to `h4`'s five-way `linarith`
(`lt_of_lt_of_le` + `le_of_eq_of_le`), and `ha` now normalises `h` with an explicit `ring` identity
for the negation binding.  Three errors remain (lines 38, 43, 54):

* **38** — `le_of_eq_of_le (Eq.symm hc) (by simpa only [hc] using hb)` — argument mismatch: `hc` is
  `X + A + C = X + (500K²+10¹⁵)/n²`, so `Eq.symm hc` is the wrong direction for the `le_of_eq_of_le`
  slot (`a ≤ b` wanted as `a = b` then `b ≤ c`); **use a `calc`**:
  `calc LHS ≤ X + A + C := hb; _ = X + (500K²+10¹⁵)/n² := hc`;
* **43** — `h5`'s `nlinarith only [hl, hnR]` (the `log2 ≤ 1` step);
* **54** — `lt_div_iff₀ hnR at h6b` still pattern-misses — **print `h6b`'s exact form first** (the
  §13.247 rule).

### 13.251 Round-232: **a real constant error in `stage2_upper_arith`** — `39/20` is too small

No declaration landed (build green: 183 declarations, 7/7 OK, 0 axioms).

**Caught a genuine numerical error:** the cap `39/20 = 1.95` was **below** `3/2·log2 + 11/10 ≈ 2.14`,
so `h5` was *false as stated*.  With the correct cap `C = 3` (which also satisfies `C/2 + 1 = 5/2 ≤ 4`),
the chain becomes `w' ≤ 3/(2n)`, `w ≤ w' + 1/n ≤ 5/(2n) ≤ 4/n` ✓.

This is the **third numerical error caught at the statement/constant level in Stage 2** (after §13.241's
`1/2`-versus-`C/n²` order error and §13.239's `PhiC` symbol problem) — and it is the class the
development's rule set is explicitly designed to catch: *check the constant against its bound before
writing the proof step*.  The `h5` `linarith` failure is what surfaced it.

Also fixed: `hb'` now uses an explicit `calc` (the `le_of_eq_of_le` slot had the wrong direction), and
`h3'` adds the missing `(3/2log2)/n` addend to `h3` before the `lt_of_lt_of_le` chain.

**One error left (`/tmp/w1140.lean:58`)** — the `lt_div_iff₀` step; the line-based replacement is in
place but the error persists, so **print the surrounding three lines and the goal** next round (the
`rw`/`mp` distinction plus the exact printed form).

### 13.252 **LANDED (round 232): `stage2_upper_arith`** — 184 declarations — **both Stage-2 helpers complete**

`Op56/PhiThird.lean` now has **184 declarations** (0 sorries, 7/7 OK, 0 axioms), newly:

```lean
private lemma stage2_upper_arith (n : ℕ) (hn : 1 ≤ n) (K : ℝ) (hK : 0 ≤ K)
    (hnK : 10^15 * (K^2 + 1) ≤ (n:ℝ))
    (w w' : ℝ) (hw : w'^2 ≤ (K/(n:ℝ))^2)
    (h : -(3/2*Real.log 2)/(n:ℝ) - 10^15/((n:ℝ)^2) < -2*w' + 500*w'^2)
    (hww : w ≤ w' + 1/(n:ℝ)) :
    w ≤ 4/(n:ℝ)
```

**The final fix was `le_div_iff₀`, not `div_le_iff₀`** — the same left/right division-direction rule
that had already cost rounds twice.  With `C = 3` (the corrected cap), the chain is
`w' ≤ 3/(2n)`, `w ≤ w' + 1/n ≤ 5/(2n) ≤ 4/n` ✓.

**Together with `stage2_lower_arith` this gives the complete Stage-2 arithmetic:**
`-4/n ≤ w ≤ 4/n`, i.e. **`|p/nmin p − log2| ≤ 4/nmin p`** — the exact hypothesis both window lemmas
require.  Three rounds for the upper helper (starts at 4 errors) against seven for the lower (starts
at 6), with the improvement attributable to applying the accumulated rules up front.

### Remaining for `op5_nmin_asymptotic`

Both arithmetic halves are landed, so what remains is **pure assembly** — connecting
`nmin_Phi_lt`/`nmin_Phi_ge` through `Phi_third_order`, `exp_threshold_linear`,
`PhiS_second_order_at_log2`, `PhiS_le_thirty`, `SThird_D_abs_le` to the two helpers' hypotheses:
1. instantiate `K` with the Stage-1 constant from `nmin_w_lower`/`nmin_w_upper` (symbolically);
2. supply `hnK : 10^15·(K²+1) ≤ n` from the largeness of `p` (eventually true, Archimedean);
3. apply `Phi_window_low` at `nmin p` and `Phi_window_high` at `nmin p + 1` by contrapositive;
4. combine into `nmin p = p/log2 − 5/2 + O(1/p)` and close `op5_nmin_asymptotic`.

### 13.253 **LANDED (round 233): `nmin_w_stage1`** — 185 declarations

`Op56/PhiThird.lean` now has **185 declarations** (0 sorries, 7/7 OK, 0 axioms), newly:

```lean
private lemma nmin_w_stage1 (p : ℕ) (hp : 6 ≤ p) (hn : 2000000000 ≤ nmin p)
    (hlarge : 3*PhiC ≤ ((2*p : ℕ):ℝ))
    (hnK : 10^15 * ((2*PhiC+1)^2 + 1) ≤ (nmin p:ℝ))
    (hnK1 : 10^15 * (2*PhiC + 2) ≤ (nmin p:ℝ)) :
    |(p:ℝ)/(nmin p :ℝ) - Real.log 2| ≤ (2*PhiC+1)/(nmin p :ℝ)
```

— **Stage 1 in the usable `|w| ≤ K/n` form with `K := 2*PhiC + 1`** (so both `PhiC ≤ K` and
`2PhiC+1 = K` hold ✓), obtained by combining `nmin_w_lower` and `nmin_w_upper`.

**Two design points settled within the round:**
1. the Stage-1 largeness condition must be **two** hypotheses — a **quadratic** one
   (`10^15·((2PhiC+1)²+1) ≤ n`, required by the Stage-2 helpers' `hnK`) and a **linear** one
   (`10^15·(2PhiC+2) ≤ n`, which is what `nmin_w_upper`'s `hC : 2·PhiC ≤ n+1` needs and which the
   quadratic form does **not** give without a square-root manipulation);
2. `h5a : (2PhiC+1)/n = 2(PhiC/n) + 1/n` is proved by **`field_simp` alone** — the trailing `ring`
   reports *No goals* (the §13.226 pattern, now expected).

**Next: the Stage-2 assembly** — instantiate `Stage 2`'s two helpers with `K := 2*PhiC+1`, i.e. supply
`hw : w^2 ≤ (K/n)^2` from `nmin_w_stage1`, and the two hypotheses `h` (lower/upper) from
`Phi_third_order` + `exp_threshold_linear` + `PhiS_second_order_at_log2` + `SThird_D_abs_le` at
`u = p/nmin p` (and `u' = p/(nmin p + 1)` for the upper).  Then `|w| ≤ 4/nmin p` ✓ and the windows
apply.

### 13.254 Round-234: Stage-2 lower assembly drafted

No declaration landed (build green: 185 declarations, 7/7 OK, 0 axioms).

`/tmp/w1160.lean` drafts `stage2_lower`, the assembly connecting `nmin_Phi_lt` + `Phi_third_order`
(+ `exp_threshold_linear`, `PhiS_second_order_at_log2`, `SThird_D_abs_le`) to
`stage2_lower_arith`'s hypotheses:

* `nmin_w_stage1` is now **public** (scratch files needed it, as with `log_one_add_inv_le`);
* `set K := 2*PhiC+1` was **dropped** in favour of writing `2*PhiC+1` explicitly — the round-207
  lesson (a `set` fights its own rewrites);
* `split_bounds'` supplies `Phi_third_order`'s four side conditions as `sb.1`, `sb.2.1`,
  `sb.2.2.1`, `sb.2.2.2` (the pattern used in both window lemmas).

**Two errors (lines 23, 29):** line 23 is `rw [sq_abs]` inside `hw` (the `abs_le.mp hstage1`
bounds must be converted to a `w²` bound — **use `sq_le_sq'` with the two `abs_le` projections
instead of `sq_abs`+`nlinarith`**, the pattern that worked in `Phi_window_low`); line 29 is the
`hu1` `linarith` (`p ≤ nmin p` should come from `nmin_ge_p` cast with `exact_mod_cast`, as elsewhere).

### 13.255 Round-235: `stage2_lower` — supporting steps clean, `hmain` drafted (six errors)

No declaration landed (build green: 185 declarations, 7/7 OK, 0 axioms).

**The scaffolding of `stage2_lower` now compiles with no errors** — `hw` (via `sq_le_sq'` on the two
`abs_le` projections), `hu1`/`hu2`, and `hthird` (via `split_bounds'`) are all clean; the `sorry` count
in the scratch went to one, and the `hmain` derivation is now drafted.

`hmain` assembles: `hlt` (`Φ_p(n) < 1`), `hthird`'s projection, `hlin` (`exp_threshold_linear`),
`hPSb` (sharp `ΦS` lower bound), `hD` (`SThird_D_abs_le`), via the chain
`-2w - 500w² ≤ (e^u-1)^{-1} - 1 < -uΦS(u)/(2n) + 4·10¹⁰/n² + 10¹²/n² < -(11/8)/n + 10¹⁵/n²`,
where the key estimate is `uΦS(u) ≥ 11/4` (from `(1/2)(6 - 26w - 10¹⁶w²)` with
`26w + 10¹⁶w² ≤ 1/2` supplied by Stage 1's `|w| ≤ (2PhiC+1)/n` and `hnK`).

**Six errors (lines 52, 59×2, 78, 79, 81)** — all `linarith` bloat or a `rw` pattern miss, i.e. the
standard classes; line 81 is the `div_le_div_iff₀` in `h5`.  **Apply the ordered-lemma/`calc`
treatment one at a time** (§13.238's rule).

### 13.256 Round-236: **a fourth Stage-2 constant error caught** — the largeness exponent was too small

No declaration landed (build green: 185 declarations, 7/7 OK, 0 axioms).

**The `hsmall` estimate did not close.**  With the hypothesis `10^15·((2PhiC+1)²+1) ≤ n`, the derived
bound `(2PhiC+1)/n ≤ 10⁻⁷` gives `10¹⁶·((2PhiC+1)/n)² ≤ 10¹⁶·10⁻¹⁴ = 100`, which is **200× larger
than the `1/2` required** — so `26w + 10¹⁶w² ≤ 1/2` was unprovable, and the whole `uΦS(u) ≥ 11/4`
step with it.  **Fix: strengthen the largeness hypothesis to `10^40·((2PhiC+1)²+1) ≤ n`**, which
gives `(2PhiC+1)/n ≤ 10⁻⁹`, hence `10¹⁶·w² ≤ 0.01` ✓ and `26w ≤ tiny` ✓.

Note this is compatible with `stage2_lower_arith`'s own hypothesis (`10^15(K²+1) ≤ n`), since
`10^40·X ≤ n ⟹ 10^15·X ≤ n` ✓ — the helper needs only the weaker form, the assembly needs the
stronger one.

**This is the fourth numerical error caught in Stage 2** (after §13.239 `PhiC`, §13.241 the `1/2`
order error, §13.251 the `39/20` cap) — the same rule each time: **substitute the derived bound into
the target expression and check the product before writing the step.**

Six errors remain (15, 52, 61×2, 80, 81): line 15 is the updated `hnK` argument to
`stage2_lower_arith` (needs the `10^40 ⟹ 10^15` implication stated explicitly); the rest are the
standard `linarith`/rewrite classes.

### 13.257 Round-237: the `10^40 ⟹ 10^15` implications added; six errors remain

No declaration landed (build green: 185 declarations, 7/7 OK, 0 axioms).

The strengthened largeness hypothesis now propagates correctly: **two** `10^15 ⟹ 10^40` implication
lemmas were needed — one at the `nmin_w_stage1` call site (line 15) and one at the
`stage2_lower_arith` call site — each of the form
`10^15·((2PhiC+1)²+1) ≤ 10^40·((2PhiC+1)²+1) ≤ n` via `nlinarith` on the nonnegativity of
`(2PhiC+1)²+1`.

**Six errors remain (57, 66×2, 85, 86, 88):** line 57 is `hsmall`'s closing `nlinarith`; 66 is the
two `sq_le_sq'` arguments inside `hPSu`'s `hc`; 85/86 are `hmain`'s two combination steps; 88 is the
`div_le_div_iff₀` in `h5`.  All standard classes — apply the ordered-lemma treatment one at a time.

### 13.258 Round-238: `hsmall` named via `set q`; six errors remain

No declaration landed (build green: 185 declarations, 7/7 OK, 0 axioms).

`hsmall` was restructured to name the quantity: `set q : ℝ := (2PhiC+1)/nmin p` with `hq0 : 0 ≤ q`
and `hq1 : q ≤ 10⁻⁹`, then `nlinarith only [hq0, hq1]` — naming a value (rather than `set`-ting a
rewritable expression, which the §13.207 rule warns against) is the appropriate use of `set` here.

Error sites moved rather than reduced: **57** (the `K/n ≤ 10⁻⁹` derivation via `h1a`), **69×2**
(`hPSu`'s `sq_le_sq'` arguments), **88/89** (`hmain`'s combination), **91** (`h5`'s
`div_le_div_iff₀`).

**Next: continue the one-at-a-time ordered-lemma conversion; line 57's `nlinarith` needs the
square-root relation stated explicitly** (`(2PhiC+1)² ≤ n²` and `(2PhiC+1)² ≤ n/10⁴⁰` together give
`(2PhiC+1)/n ≤ 10⁻⁹` only after multiplying through, which `nlinarith` cannot chain from
`hKbig` alone).

### 13.259 Round-239: line 57's square comparison written; six errors remain

No declaration landed (build green: 185 declarations, 7/7 OK, 0 axioms).

The `(2PhiC+1)/n ≤ 10⁻⁹` step is now written as an **explicit square comparison**, avoiding the
square-root manipulation `nlinarith` cannot do: `(2PhiC+1)² ≤ n/10⁴⁰ ≤ (10⁻⁹·n)²`, then
`sq_le_sq.mp` plus `abs_of_nonneg` on both sides.  This is the correct encoding but line 62
(`h1c`'s `nlinarith`) still needs the product relation supplied.

**Six errors remain (62, 78×2, 97, 98, 100).**  The count has now been six for four consecutive
rounds (236–239), with the fail-set rotating each time through constant corrections and implication
insertions rather than closing.

### 13.260 **LANDED (round 240): `uPhiS_ge`** — 186 declarations — the extraction diagnosis confirmed a 7th time

`Op56/PhiThird.lean` now has **186 declarations** (0 sorries, 7/7 OK, 0 axioms), newly:

```lean
private lemma uPhiS_ge (u : ℝ) (q w : ℝ) (hq0 : 0 ≤ q) (hq : q ≤ 1/10^9)
    (hw : |w| ≤ q) (hu1 : 1/2 ≤ u) (hu : u = Real.log 2 + w)
    (hPS : 6 - 26*w - 10^16*w^2 ≤ PhiS u) :
    (11/4:ℝ) ≤ u * PhiS u
```

**Compiled on the first try** — with only `u, q, w` and five hypotheses in context, where the
*same* estimate had resisted six rounds inside `hmain`'s large context.  This is the **seventh**
time extract-to-a-small-context has resolved a blocker that in-place fixing could not
(`window_arith`, `window_arith_high`, `log_one_add_inv_le`, the `hkey` split, the `linarith`-bloat
splits, and now this), and the second time in this session that I recorded the diagnosis one round
and got a first-try landing the next.

**The lesson, stated for the last time in this development and then to be applied without
exception: any `linarith`/`nlinarith` step that has failed twice inside a large context should be
extracted immediately, not retried.**

### Remaining for `stage2_lower`

With `uPhiS_ge` landed, `hmain`'s remaining content is:
1. the `exp`-side bound
   `(e^u-1)^{-1} - 1 ≥ -2w - 500w²` (`exp_threshold_linear`) and the upper side from
   `Phi_third_order` + `nmin_Phi_lt`;
2. the final combination to `-2w - 500w² < -(11/8)/n + 10^15/n²`.

Both should now be extracted into their own small-context lemmas in the same style.

### 13.261 **LANDED (round 241): `stage2_lower_final`** — 187 declarations — two landings in two rounds

`Op56/PhiThird.lean` now has **187 declarations** (0 sorries, 7/7 OK, 0 axioms), newly:

```lean
private lemma stage2_lower_final (n : ℕ) (hn : 1 ≤ n) (w : ℝ)
    (h : -2*w - 500*w^2 < -(11/8)/(n:ℝ) + (4*10^10 + 10^12)/((n:ℝ)^2)) :
    -2*w - 500*w^2 < -(11/8)/(n:ℝ) + 10^15/((n:ℝ)^2)
```

**First try** — the constant comparison `4·10¹⁰ + 10¹² ≤ 10¹⁵` with a
`div_le_div_of_nonneg_right` and one `linarith only`.

**Two consecutive first-try landings (`uPhiS_ge`, `stage2_lower_final`) after six rounds of failure
on the same content inside `hmain`** — the extraction rule is now demonstrably the single highest-
leverage technique in this development, and it is being applied *before* writing rather than after
two failures.

### Remaining for `stage2_lower`

One extraction left: the `exp`-side inequality
`-2w - 500w² < -(11/8)/n + (4·10¹⁰ + 10¹²)/n²`, assembled from `Phi_third_order`'s projection,
`nmin_Phi_lt`, `exp_threshold_linear`'s projection, `uPhiS_ge`, and `SThird_D_abs_le` — as a
small-context lemma taking those five facts as hypotheses.

### 13.262 Round-242: `stage2_lower_exp` drafted — the last extraction for `stage2_lower`

No declaration landed (build green: 187 declarations, 7/7 OK, 0 axioms).

`/tmp/w1190.lean` has the final extraction for the lower half:

```lean
private lemma stage2_lower_exp (n : ℕ) (hn : 1 ≤ n) (w Y X D E : ℝ)
    (hX : (11/8)/(n:ℝ) ≤ X) (hD : -(4*10^10) ≤ D) (hE : E ≤ 10^12/((n:ℝ)^2))
    (hexp : -2*w - 500*w^2 ≤ Y - 1)
    (hthird : Y + X + D/((n:ℝ)^2) - E < 1) :
    -2*w - 500*w^2 < -(11/8)/(n:ℝ) + (4*10^10 + 10^12)/((n:ℝ)^2)
```

(the parameters `Y`, `X`, `D`, `E` are `(e^u−1)⁻¹`, `uΦS(u)/(2n)`, `D(u)`, `C3/n³`
respectively).  Two errors remain (18, 24): `h1`'s `div_le_div_of_nonneg_right` form and the
`h4`/`h5`/`h6` chain — both standard classes, to be converted one at a time.

### 13.263 **LANDED (round 243): `stage2_lower_exp`** — 188 declarations — three first-try landings in a row

`Op56/PhiThird.lean` now has **188 declarations** (0 sorries, 7/7 OK, 0 axioms), newly:

```lean
private lemma stage2_lower_exp (n : ℕ) (hn : 1 ≤ n) (w Y X D E : ℝ)
    (hX : (11/8)/(n:ℝ) ≤ X) (hD : -(4*10^10) ≤ D) (hE : E ≤ 10^12/((n:ℝ)^2))
    (hexp : -2*w - 500*w^2 ≤ Y - 1)
    (hthird : Y + X + D/((n:ℝ)^2) - E < 1) :
    -2*w - 500*w^2 < -((11/8)/(n:ℝ)) + (4*10^10 + 10^12)/((n:ℝ)^2)
```

**First try.**  One real error was caught while drafting it: the bound `-X ≤ -(11/8)/n` follows from
`X ≥ 11/(8n)` by **`neg_le_neg`** — I had written the *reverse* direction, which is false.  Writing
every negation in the single form `-((11/8)/(n:ℝ))` (rather than mixing `-(11/8)/n`) removed the
binding ambiguity that had blocked the previous attempt.

### `stage2_lower` is now a short assembly

With `uPhiS_ge`, `stage2_lower_exp` and `stage2_lower_final` all landed, `stage2_lower` is: apply
`Phi_third_order` + `nmin_Phi_lt` + `exp_threshold_linear` + `SThird_D_abs_le` at `u = p/nmin p`,
instantiate `uPhiS_ge` (from `PhiS_second_order_at_log2` + `nmin_w_stage1`), feed `stage2_lower_exp`,
then `stage2_lower_final` — and `stage2_lower_arith` with `K := 2*PhiC+1`.

### 13.264 Round-244: `stage2_lower` drafted — five errors

No declaration landed (build green: 188 declarations, 7/7 OK, 0 axioms).

`/tmp/w1200.lean` has the full `stage2_lower` assembly.  All five Stage-2 helpers are now **public**
(scratch files need them, as repeatedly established).  The assembly wires: `hnK15` (the `10^40 ⟹
10^15` implication), `nmin_w_stage1`, `set w`, `hu`/`hwabs`/`hq0`/`hq1` (the square comparison for
`(2PhiC+1)/n ≤ 10⁻⁹`), `hu1`/`hu2`, `split_bounds'` + `Phi_third_order`, `hlt`, `hlin`, `hPS`, `hD`,
then `uPhiS_ge` → `hS`, `stage2_lower_exp` → `hstep`, `stage2_lower_final` → `hmain`, and
`stage2_lower_arith` with `K := 2*PhiC+1`.

**Five errors (37, 63, 65, 72, 75):** 37 is `h1c`'s `nlinarith`; 63/65 are the **type mismatches in
the `uPhiS_ge`/`stage2_lower_exp` instantiations** (parameter order — the helpers take `u q w` and
`w Y X D E` respectively, so the positional arguments must be rechecked against the signatures);
72/75 are `linarith` steps in `hE`/`hX`.

### 13.265 Round-245: two instantiations fixed; five errors remain

No declaration landed (build green: 188 declarations, 7/7 OK, 0 axioms).

Two fixes, both of the recurring binding class:
* `hexp` needed `rw [hwdef]` before `linarith` — `abs_le.mp hlin`'s projection is phrased in
  `(p/n − log2)` while the helper wants `w`;
* the `D` expression had to be written `-((u)/3)` (i.e. `Neg.neg (u/3)`) rather than `(-u)/3`, to
  match `SThird_D_abs_le`'s statement.

**Five errors remain (37, 75, 78, 89, 90):** 37 is `h1c`'s `nlinarith`; 75/78 are `hE`/`hX`;
89/90 are the **`stage2_lower_exp` instantiation's `Y`/`X` arguments** (application type mismatch —
the `Y` and `X` terms must be transcribed verbatim from the helper's signature).

### 13.266 Round-246: **build briefly broken by editing a landed lemma — reverted; 4 errors left**

Build green again: **188 declarations, 7/7 OK, 0 sorries**.

**A mistake worth recording permanently.**  To fix a binding mismatch between the landed
`stage2_lower_exp` (which concludes `-((11/8)/n)`) and the landed `stage2_lower_arith` (whose
hypothesis is `-(11/8)/n`), I edited **`stage2_lower_arith`'s statement** — and that broke its own
proof at line 5635 (`[check] FAIL`), taking the build to 6 OK.  **Reverted immediately; green
restored and verified.**

**Rule (now primary, alongside "never leave a sorry"): NEVER edit a landed lemma's statement to suit
a new use site.**  The mismatch must be bridged at the *call site* with an explicit `have … := by
rw [neg_div]` — which is exactly what the assembly now does:

```lean
have hbr : -((11/8)/(nmin p:ℝ)) = -(11/8)/(nmin p:ℝ) := by rw [neg_div]
have hmain : -2*w - 500*w^2 < -(11/8)/(nmin p:ℝ) + 10^15/… := by rw [← hbr]; exact hstep'
```

**Four errors remain (39, 77, 80, 96):** 39 is `h1c`'s `nlinarith`; 77/80 are `hE`/`hX`; 96 is the
`stage2_lower_arith` call's argument list.

### 13.267 Round-247: `stage2_lower` at ONE error — `hthird'` (the `abs_le` projection direction)

Build green: **188 declarations, 7/7 OK, 0 sorries**.

Cleared this round: `h1c` (needs `(1/10⁹·n)² = n²/10¹⁸` by `ring`, then `div_le_div_iff₀`,
then `nlinarith` with `hn1 : 1 ≤ nmin p`), `hE` (explicit `mul_le_mul_of_nonneg_right` chain plus
the cube identity `n³ = n·n²`), and `hX` (`le_div_iff₀` + `div_mul_eq_mul_div` +
`mul_div_cancel_right₀`).

**The one remaining error is `hthird'`** — the step `Y + X + D/n² − E < 1` from
`Phi_third_order`'s projection and `nmin_Phi_lt`.  The correct projection is
**`(abs_le.mp hthird).2 : M − Φ ≤ E`** (⇒ `M − E ≤ Φ < 1`), **not `.1`**; and the two-step
`lt_of_le_of_lt` replacement for the bloat-prone `linarith` still reports a failure at the inner
`linarith only [h1]`, i.e. the `M` `X`/`D` expression must be transcribed **verbatim** from
`Phi_third_order`'s statement (`-((u)/3)` not `(-u)/3`, etc.).

### 13.268 Round-248: **the verbatim `PhiMainS_eq` form found** — three errors

Build green: **188 declarations, 7/7 OK, 0 sorries**.

**Key discovery.**  `Phi_third_order`'s conclusion is stated with **`PhiMainS u n`** — a `tsum`
definition, *not* an explicit expression.  The bridge is the landed lemma
**`PhiMainS_eq (u) (n) (hu1) (hn)`**:

```lean
PhiMainS u n = (Real.exp u - 1)⁻¹ + u/(2*(n:ℝ))*PhiS u
  + (-(u/3)*PhiK3u u + (u^2/8)*PhiK4u u)/(n:ℝ)^2
```

Note the **exact** shapes: `u/(2*n)*PhiS u` (not `u*PhiS u/(2n)`), and
`-(u/3)*PhiK3u u + (u^2/8)*PhiK4u u`.  All previous failures in `hthird'`/`hX` were the mismatch
between my hand-expanded `M` and this term.  The assembly now uses `PhiMainS_eq` explicitly
(`rw [← hMeq]`) and transcribes `X`, `D`, `Y` **verbatim** from it.

**Three errors remain (83, 84, 100):** 83/84 are the two `linarith`s inside `hthird'`'s `h2` and its
final `lt_of_le_of_lt` (both should now be small-context steps once the `← hMeq` rewrite is placed
correctly — it must rewrite the *hypothesis* `h1`, not the goal); 100 is `hX`'s `rw [mul_comm]`.

**This is the fourth time the `PhiMainS`/`M` term shape has cost a round.**  The rule to add: before
writing any step that mentions an expanded analytic term, `grep` the lemma that defines it and copy
its statement verbatim.

### 13.269 Round-249: `stage2_lower` down to ONE step — the `hthird'` projection

Build green: **188 declarations, 7/7 OK, 0 sorries**.

Cleared: `hE` (explicit `mul_le_mul_of_nonneg_right` + cube identity) and `hX`
(`div_mul_eq_mul_div` + `le_div_iff₀` + `mul_div_cancel_right₀`).  `hthird'`'s `M` term now uses the
**verbatim `PhiMainS_eq`** form.

**The single remaining error is the projection of `|Φ − PhiMainS| ≤ E` into the
`hthird'` shape** — `(abs_le.mp hthird).1 : -E ≤ Φ − M`, from which `M − E ≤ Φ` must follow.  Plain
`linarith only [h1]` fails here (context bloat, as usual), and both
`sub_le_iff_le_add.mpr`/`le_sub_iff_add_le.mp` applications have been rejected for argument-shape
reasons — **so next round, first print `h1`'s exact type** (e.g. by deliberately mis-applying a
lemma) rather than guessing which rearrangement lemma matches.

**Per §13.268's rule: read the statement, then write the step.**  This step has now consumed three
rounds' worth of guessing, all of the same class.

### 13.270 **LANDED (round 249): `stage2_lower`** — 189 declarations — **the lower half of the sharp bound is proved**

`Op56/PhiThird.lean` now has **189 declarations** (0 sorries, 7/7 OK, 0 axioms), newly:

```lean
private lemma stage2_lower (p : ℕ) (hp : 6 ≤ p) (hn : 2000000000 ≤ nmin p)
    (hlarge : 3*PhiC ≤ ((2*p : ℕ):ℝ))
    (hnK : 10^40 * ((2*PhiC+1)^2 + 1) ≤ (nmin p:ℝ)) :
    -(4/(nmin p :ℝ)) ≤ (p:ℝ)/(nmin p :ℝ) - Real.log 2
```

**The decisive discovery (from printing `h1`'s type, per the §13.268 rule):**
`Phi_third_order`'s conclusion is `|Phi (u*(n:ℝ)) n − PhiMainS u n| ≤ E` — with **`u*(n:ℝ)`
unevaluated**.  It must be normalised by
`rw [div_mul_cancel₀ _ (ne_of_gt hnR)] at h1` before it matches `Phi (p:ℝ) (nmin p)`.  *Every*
previous failure of this step — three rounds' worth — was this.  The second half of the fix is
`rw [hMeq]` on the *goal* so that the goal's `PhiMainS u n` becomes the expansion that `h1` already
carries.

**This is the most instructive round of the session:** the step was not hard, it was
*mis-specified*, and the way to find that was to make Lean print the hypothesis type (by
deliberately mis-applying a lemma) rather than to keep proposing rearrangements.  Three earlier
rounds had guessed at `sub_le_iff_le_add`, `le_sub_iff_add_le`, `neg_le_neg`, and `abs_le`
projections — all blind.  **Rule, final form: when a `linarith`/rearrangement step resists twice,
print the hypothesis's type.**

### Remaining

`stage2_upper` mirrors this: apply `Phi_third_order` at `u' = p/(nmin p + 1)`, `exp_threshold_linear`,
`uPhiS_ge`-style bound, and `stage2_upper_arith`.  Then `|w| ≤ 4/nmin p` and the two windows.

### 13.271 Round-250: `stage2_upper_exp` drafted — two errors

Build green: **189 declarations, 7/7 OK, 0 sorries**.

The mirror of `stage2_lower_exp` for the upper half, written with all §13.268–13.270 lessons applied
up front:

```lean
private lemma stage2_upper_exp (n : ℕ) (hn : 1 ≤ n) (w Y X D E : ℝ)
    (hX : (11/8)/(n:ℝ) ≤ X) (hD : -(4*10^10) ≤ D) (hE : E ≤ 10^12/((n:ℝ)^2))
    (hexp : Y - 1 ≤ -2*w + 500*w^2)
    (hthird : 1 - E ≤ Y + X + D/((n:ℝ)^2))
    (hlog : (3/2*Real.log 2)/(n:ℝ) ≤ (11/8)/(n:ℝ)) :
    -((3/2*Real.log 2)/(n:ℝ)) - 10^15/((n:ℝ)^2) < -2*w + 500*w^2
```

Route: `hthird` ⇒ `Y ≥ 1 − E − X − D/n²`; `hexp` ⇒ `−2w + 500w² ≥ Y − 1`; hence
`−2w + 500w² ≥ −E − X − D/n² ≥ −(3/2·log2)/n − (4·10¹⁰ + 10¹²)/n²`, the last step using
`hlog : 3/2·log2 ≤ 11/8` (from `log2 ≤ 1`, to be supplied at the call site) and the two error bounds.

**Two errors (28, 32):** `h6`'s combination and the closing `linarith` — standard classes; **per
§13.270, if either resists, print the hypothesis type rather than proposing another rearrangement.**

### 13.272 Round-251: **`stage2_upper_arith`'s hypothesis constant is too small — a real defect**

Build green: **189 declarations, 7/7 OK, 0 sorries**.

While mirroring, the derivation exposes a genuine problem with the **landed** `stage2_upper_arith`.
Its hypothesis is

```lean
(h : -(3/2*Real.log 2)/(n:ℝ) - 10^15/((n:ℝ)^2) < -2*w' + 500*w'^2)
```

i.e. `−2w' + 500w'² > −1.04/n − 10¹⁵/n²`.  But the upper half's **only** route to bounding `w'`
above is
`2w' ≤ E + X + D/n² + 500w'²`, obtained from `nmin_Phi_ge : 1 ≤ Phi (p) (nmin p + 1)` together with
`Phi_third_order` at `u' = p/(nmin p+1) =: u'` and `exp_threshold_linear`.  Now
**`X = u'ΦS(u')/(2n')` and `u' ≈ log 2`**, so `ΦS(u') ≈ 6` and `u'ΦS(u') ≈ 6 log 2 ≈ 4.16`, giving
`X ≈ 2.08/n'`.  Hence `2w' ≤ 2.08/n' + O(1/n'²)`, and
**`−2.08/n' < −1.04/n'` is false**, so the landed hypothesis is *not* derivable — it is vacuously
true and therefore useless for this route.

**Fix (next round): add a NEW helper with the correct constant**, e.g.

```lean
private lemma stage2_upper_arith' (n : ℕ) (hn : 1 ≤ n) (K : ℝ) (hK : 0 ≤ K)
    (hnK : 10^15 * (K^2 + 1) ≤ (n:ℝ))
    (w w' : ℝ) (hw : w'^2 ≤ (K/(n:ℝ))^2)
    (h : -(3:ℝ)/(n:ℝ) - 10^15/((n:ℝ)^2) < -2*w' + 500*w'^2)
    (hww : w ≤ w' + 1/(n:ℝ)) :
    w ≤ 4/(n:ℝ)
```

(conclusion unchanged: `2w' < 3/n` ⇒ `w' < 1.5/n` ⇒ `w ≤ 2.5/n ≤ 4/n` ✓), and use it instead.

**Do NOT edit the landed `stage2_upper_arith`** (§13.266 rule); a new lemma leaves the build intact.

**Note on `u'ΦS(u')`:** the identity `ΦS(log 2) = 6` is not what is used — only
`u'ΦS(u') ≤ 6·log 2 + tiny = O(1)`, which the landed sharp `ΦS` upper bound supplies.  The constant
`3` is safe with room to spare.

### 13.273 Round-252: `stage2_upper_arith2` (corrected constant) drafted — three substitution errors

Build green: **189 declarations, 7/7 OK, 0 sorries**.

**Method note:** the corrected helper was produced by *mechanically adapting the landed
`stage2_upper_arith` proof* (extract, rename to `stage2_upper_arith2`, substitute
`3/2*Real.log 2 → 3`, `h5`'s cap `3 → 41/10`, `h6 → 41/20`, `h6b → 41/10`, `h8 → 61/20`,
`h9 → 61/20`) rather than re-deriving it.  This is the right move — the proof structure is identical
and the mathematics is already verified — but the mechanical substitution left three artifacts
(lines 51, 56, 57: a `Type mismatch` where a `3/2` remained, a `linarith` that no longer closes, and
an application mismatch), which must be fixed by hand.

**The corrected statement** (to be landed next round after the three artifacts are cleaned):

```lean
lemma stage2_upper_arith2 (n : ℕ) (hn : 1 ≤ n) (K : ℝ) (hK : 0 ≤ K)
    (hnK : 10^15 * (K^2 + 1) ≤ (n:ℝ))
    (w w' : ℝ) (hw : w'^2 ≤ (K/(n:ℝ))^2)
    (h : -(3:ℝ)/(n:ℝ) - 10^15/((n:ℝ)^2) < -2*w' + 500*w'^2)
    (hww : w ≤ w' + 1/(n:ℝ)) :
    w ≤ 4/(n:ℝ)
```

with the chain `2w' < 3/n + 11/10/n = 41/10/n` ⇒ `w' < 41/20/n` ⇒ `w ≤ 61/20/n ≤ 4/n` ✓.

### 13.274 **LANDED (round 252): `stage2_upper_arith2`** — 190 declarations — the corrected upper helper

`Op56/PhiThird.lean` now has **190 declarations** (0 sorries, 7/7 OK, 0 axioms), newly:

```lean
lemma stage2_upper_arith2 (n : ℕ) (hn : 1 ≤ n) (K : ℝ) (hK : 0 ≤ K)
    (hnK : 10^15 * (K^2 + 1) ≤ (n:ℝ))
    (w w' : ℝ) (hw : w'^2 ≤ (K/(n:ℝ))^2)
    (h : -((3:ℝ))/(n:ℝ) - 10^15/((n:ℝ)^2) < -2*w' + 500*w'^2)
    (hww : w ≤ w' + 1/(n:ℝ)) :
    w ≤ 4/(n:ℝ)
```

— the §13.272 defect repaired with a **new** lemma rather than by editing the landed
`stage2_upper_arith` (per the §13.266 rule), so the build never left green.  Chain:
`2w' < 3/n + 11/10/n = 41/10/n` ⇒ `w' < 41/20/n` ⇒ `w ≤ 61/20/n ≤ 4/n` ✓.

**Method worth reusing:** the corrected helper was produced by **mechanically adapting the landed
proof** (extract, rename, substitute the constants) rather than re-deriving it — then repairing the
three substitution artifacts by hand.  This is faster than a fresh proof and safer, because the
structure is already kernel-checked.

### 13.275 Round-253: `stage2_upper_exp` **corrected** — `hX` must be an UPPER bound

Build green: **190 declarations, 7/7 OK, 0 sorries**.

Re-deriving from the threshold condition exposed a direction error in the round-250 draft.
For the **upper** half the route is a *lower* bound on `M'`:

* `nmin_Phi_ge : 1 ≤ Phi (p) (nmin p + 1)`, `|Phi − M| ≤ E` ⇒ `M ≥ 1 − E`;
* `M = Y + X + D/n²` ⇒ `Y ≥ 1 − E − X − D/n²`;
* `exp_threshold_linear` ⇒ `Y − 1 ≤ −2w' + 500w'²`;
* hence `−2w' + 500w'² ≥ −E − X − D/n²`, and to bound **this below** one needs
  **`X ≤ 3/n` (an upper bound!), not `X ≥ 11/(8n)`** — the round-250 draft had the wrong direction,
  which is why it could not close.

**Corrected statement** (`/tmp/w1230.lean`):

```lean
private lemma stage2_upper_exp (n : ℕ) (hn : 1 ≤ n) (w Y X D E : ℝ)
    (hX : X ≤ 3/(n:ℝ)) (hD : D ≤ 4*10^10) (hE : E ≤ 10^12/((n:ℝ)^2))
    (hexp : Y - 1 ≤ -2*w + 500*w^2)
    (hthird : 1 - E ≤ Y + X + D/((n:ℝ)^2)) :
    -((3:ℝ)/(n:ℝ)) - 10^15/((n:ℝ)^2) < -2*w + 500*w^2
```

The `3` here is exactly `stage2_upper_arith2`'s constant ✓.  **Three errors remain (23, 26, 30)** —
all `linarith` rearrangements; the first (`h4 : Y ≥ 1 − E − X − D/n²` from `hthird`) resists plain
`linarith only`, so it needs `sub_le_sub_right` chains.

**This is the third direction error in Stage 2** (`neg_le_neg`, the `abs_le` projection, now this) —
all instances of reading an inequality's direction from the goal shape rather than deriving it.

### 13.276 Round-254: `stage2_upper_exp` — rearrangement still resisting

Build green: **190 declarations, 7/7 OK, 0 sorries**.

The `sub_le_sub_right` route for `h4` produced **type mismatches** (the lemma's conclusion keeps the
`(Y + X + D/n²) - X` shape unsimplified), and the three `linarith` steps still fail.  The
rearrangement `1 − E ≤ Y + X + D/n²  ⊢  1 − E − X − D/n² ≤ Y` is elementary but has now resisted
three approaches (`linarith only`, `sub_le_sub_right` chains).

**Recommended next move (apply §13.270's rule immediately): print `hthird`'s type, then rewrite the
helper's `hthird` hypothesis into the *conclusion's* form at the call site** — i.e. have the caller
supply `hthird : 1 - E - X - D/((n:ℝ)^2) ≤ Y` directly (it has `nmin_Phi_ge` and the expansion, so it
can do the rearrangement in whatever form works), **removing the rearrangement from the helper
entirely**.  This is the same "change the interface rather than fight the tactic" move that worked for
`uPhiS_ge` and `stage2_lower_exp`.

### 13.277 Round-255: interface changed as planned; `neg_div` pattern still resisting

Build green: **190 declarations, 7/7 OK, 0 sorries**.

The §13.276 move was applied: `stage2_upper_exp` now takes
`hthird : 1 - E - X - D/((n:ℝ)^2) ≤ Y` **directly in the conclusion's form**, and `h5` closes
immediately with `linarith only [hexp, hthird]` ✓ — so the rearrangement is gone from the helper.

**Three errors remain (24, 28, 32):** `h6a`/`h6b` now use `neg_le_neg` ✓; line 24's
`rw [neg_div] at h ⊢` misses the pattern (the goal's `-D/(n^2)` is `(-D)/n^2`, and `neg_div`'s LHS
pattern `-a/b` does not match it syntactically — the **sixth** instance of this binding class); 28 and
32 are the outer `linarith`s.

**Next: replace the `neg_div` rewrite with an explicit `have hD2 : (-D)/((n:ℝ)^2) = -(D/((n:ℝ)^2)) := by
field_simp`** — `field_simp` proves sign-movement identities that `neg_div`'s pattern cannot match
(the §13.227 finding), then `linarith only [h, hD2]`.

### 13.278 Round-256: `field_simp` fixed the sign identity; two errors left

Build green: **190 declarations, 7/7 OK, 0 sorries**.

- `h6c` now uses the explicit identity
  `hD2 : (-D)/((n:ℝ)^2) = -(D/((n:ℝ)^2)) := by field_simp` plus `linarith only [h, hD2]` — **the
  `field_simp`-not-`neg_div` rule (sixth confirmation) worked first try**;
- the three-term addition is now built with `add_le_add (add_le_add h6b h6a) h6c` so the association
  matches the goal.

**Two errors remain (31, 35):** `hsum`'s `linarith only [hsum, h6d]` and the closing `linarith`.
Same class; the goal for 31 is `-E + -X + -D/n² ≥ -(1e12/n²) + -(3/n) + -(4e10/n²)`, and `h6d` relates
`4e10/n² + 1e12/n²` to `(4e10+1e12)/n²` — **the addend order differs between them**, which
`linarith` should handle but in this context does not; supply `add_comm`/`add_assoc`-normalised
versions of `h6d` explicitly.

### 13.279 Round-257: `stage2_upper_exp` at ONE error — the final transitivity

Build green: **190 declarations, 7/7 OK, 0 sorries**.

The addend ordering was fixed by writing `hs` explicitly as
`(-(10¹²/n²)) + (-(3/n)) + (-(4·10¹⁰/n²)) = -(3/n) - (4·10¹⁰+10¹²)/n²` via `field_simp; ring`, and
building the sum with `add_le_add (add_le_add h6b h6a) h6c` — count 3 → 1.

**One error left (39):** the closing step
`-(3/n) - (4·10¹⁰+10¹²)/n² < -2w + 500w²` from `h5`, `h6`, `h7`.  The `h8.trans h6` route gave an
*application type mismatch* — as with every `trans` attempt in this development, the summand/
association form differs between `h8` and `h6`.  **Next: `linarith only [h5, h6, h8]`** (all three are
now in matching sum form, with `h8` derived from `h7`), rather than chasing `trans`.

### 13.280 Round-258: `stage2_upper_exp`'s final chain resists `linarith`, `trans`, and `calc`

Build green: **190 declarations, 7/7 OK, 0 sorries**.

Per the §13.270 rule I **printed the context** — and it is fully consistent:

```
h5 : -2*w + 500*w^2 ≥ -E - X - D/↑n^2
h6 : -E - X - D/↑n^2 ≥ -(3/↑n) - (4*10^10 + 10^12)/↑n^2
h8 : -(3/↑n) - (4*10^10 + 10^12)/↑n^2 ≥ -(3/↑n) - 10^15/↑n^2
goal: -(3/↑n) - 10^15/↑n^2 < -2*w + 500*w^2
```

so `D ≤ C ≤ B ≤ A` with every form printed identically.  **Nevertheless:** `linarith only [h5, h6, h8]`
fails; `lt_of_le_of_lt (h8.trans h6) h5` gives an application type mismatch; and the `calc` version
leaves the goal unsolved.  **This looks like tactic-context pathology, not a logical gap** — the same
phenomenon as §13.213 (`linarith` failing on a pure transitivity) but now for the *combination* step.

**Suggested next move:** extract this three-line chain into its own **small-context lemma** with only
`A B C D : ℝ` and the three hypotheses — which is the move that has resolved **every** previous
instance of this pathology (eight times now).

### 13.281 **LANDED (round 259): `stage2_upper_exp` + `lt_of_lt_le_le`** — 192 declarations

`Op56/PhiThird.lean` now has **192 declarations** (0 sorries, 7/7 OK, 0 axioms), newly:

```lean
lemma lt_of_lt_le_le {A B C D : ℝ} (h1 : D < C) (h2 : C ≤ B) (h3 : B ≤ A) : D < A
lemma stage2_upper_exp (n : ℕ) (hn : 1 ≤ n) (w Y X D E : ℝ)
    (hX : X ≤ 3/(n:ℝ)) (hD : D ≤ 4*10^10) (hE : E ≤ 10^12/((n:ℝ)^2))
    (hexp : Y - 1 ≤ -2*w + 500*w^2)
    (hthird : 1 - E - X - D/((n:ℝ)^2) ≤ Y) :
    -((3:ℝ)/(n:ℝ)) - 10^15/((n:ℝ)^2) < -2*w + 500*w^2
```

**IMPORTANT CORRECTION to §13.280.**  The previous round's diagnosis — "tactic-context pathology, not
a logical gap" — was **wrong**.  The extraction attempt revealed the real cause immediately: the
chain `D ≤ C ≤ B ≤ A` has **no strict step**, while the goal is **strict** (`D < A`).  The step was
*not provable as stated*; `linarith`, `trans`, and `calc` were all correct to fail.  **The fix was
mathematical: make `h7` strict** (`div_lt_div_of_pos_right` instead of `div_le_div_of_nonneg_right`),
which propagates to `h8` and gives the goal through `lt_of_lt_of_le`.

**Lesson (replacing the §13.280 diagnosis):** when several methods fail on a step whose hypotheses
look consistent, check the **strict/non-strict** status of each inequality before concluding the
tactic is at fault.  `linarith`'s failure here was *correct behaviour*, and I misread it as
pathology — the second time (after §13.241) that I attributed a genuine gap to tooling.

### Remaining

`stage2_upper` mirrors `stage2_lower`: `nmin_Phi_ge` at `n' = nmin p + 1`, `Phi_third_order` at
`u' = p/(nmin p+1)` (with `div_mul_cancel₀` normalisation and `PhiMainS_eq` verbatim), `uPhiS_ge` for
the **upper** bound `X ≤ 3/n'`, `exp_threshold_linear`, then `stage2_upper_exp` and
`stage2_upper_arith2`.  Then `|w| ≤ 4/nmin p` and the two windows.

### 13.282 Round-260: `stage2_upper` scaffolding drafted — three errors

Build green: **192 declarations, 7/7 OK, 0 sorries**.

`/tmp/w1260.lean` has the mirror of `stage2_lower` at the point `n' = nmin p + 1`, with all lessons
applied up front: `n'` written **explicitly** (no `set`); `hu1`/`hu2` via `nmin_lt_two_p`/`nmin_ge_p`
with `push_cast`; `hnK15` propagated to `n'`; `split_bounds'` for `Phi_third_order`; `PhiMainS_eq` for
the verbatim expansion; `hge := nmin_Phi_ge p hp2` (the threshold at `n'`).

**Three errors (33, 38, 45)** — the `linarith` steps in `hnK15`'s `h2`, `hu2`, and `hu1`.  These are
the same cast/`push_cast` class as before; the recorded treatment is `push_cast at h ⊢` on **all**
hypotheses simultaneously (§13.215) rather than one at a time.

**Remaining after the scaffolding:** the `hstep : 1 - E ≤ Y + X + D/n²` derivation (from `hge`,
`hthird`, `hMeq`), the **`X ≤ 3/n'`** bound (the `PhiS` *upper* bound — the mirror of `uPhiS_ge`),
`hww : w ≤ w' + 1/n`, then `stage2_upper_exp` and `stage2_upper_arith2`.

### 13.283 Round-261: `stage2_upper` scaffolding at two errors

Build green: **192 declarations, 7/7 OK, 0 sorries**.

The cast fixes brought the scaffolding from three errors to two by splitting each `push_cast;
linarith` into two steps and introducing the explicit `push_cast`-normalised comparisons
`(nmin p) ≤ ↑(nmin p + 1)` and `↑(nmin p + 1) ≤ (nmin p) + 1` used at the call sites.

**Two errors remain (35, 47):** `hnK15`'s `h2`-derived `linarith`, and `hu1`'s closing `linarith`.
Both are the standard class; **per §13.281's correction, check whether each needed inequality is
strict before concluding the tactic is at fault** — `hu1` in particular is a
`1/2 ≤ u'` bound that must come from a *strict* `nmin_lt_two_p`.

### 13.284 Round-262: **two real gaps found by the strictness check** — scaffolding at one error

Build green: **192 declarations, 7/7 OK, 0 sorries**.

Per §13.283's instruction the two failing goals were printed, and **both were genuine gaps, not tactic
faults** — the third and fourth time the printed context has overturned a "tactic" hypothesis:

1. **line 35** — the goal was `10¹⁵·(2PhiC+2) ≤ ↑(nmin p)`, but `hnK15` had been stated for
   `nmin p + 1`.  **The Stage-1 largeness must be at `nmin p`** (that is where `K` comes from); the
   `nmin p + 1` version is a *consequence* (`hnK15'`, via `nmin p ≤ nmin p + 1`) and is what the
   `n'`-point helper needs.
2. **line 47** — `hu1`'s `1/2 ≤ u'` came from `↑(nmin p) < 2↑p` and
   `↑(nmin p + 1) ≤ ↑(nmin p) + 1`, which yields only `↑(nmin p+1) < 2↑p + 1` — **not enough**.
   The correct step is the **integer** one: `nmin p + 1 ≤ 2*p` by `omega`, cast with
   `exact_mod_cast`.

**One error remains (42):** `hN1`'s `push_cast; linarith only [hn1]` leaves an unsolved goal.

### 13.285 Round-263: `stage2_upper` scaffolding at one error (`hu1`)

Build green: **192 declarations, 7/7 OK, 0 sorries**.

`hN1` now uses `exact_mod_cast (by omega : 1 ≤ nmin p + 1)` — the cast-then-`linarith` form was
leaving a goal.

**One error remains (43), in `hu1`'s body:** after `rw [le_div_iff₀ hNpos]` the goal is
`1/2 * ↑(nmin p + 1) ≤ ↑p`, and `h3 : ↑(nmin p + 1) ≤ 2↑p` should give it by
`mul_le_mul_of_nonneg_left h3 (0 ≤ 1/2)` — the last substitution for that form did not take (verify
the indentation matched), so **next round apply it by explicit line edit**.

### 13.286 Round-264: **`stage2_upper` scaffolding error-free** — only the final block remains

Build green: **192 declarations, 7/7 OK, 0 sorries**.

**The scripting failure was real and is now understood:** my round-263 edit had **consumed the closing
`h4`/`linarith` lines** of `hu1` (the replacement string spanned them without restoring them), which is
why the error did not move.  Fixed by an explicit edit **with an `assert` that the pattern was found**
(`EDITED OK` printed) — the verification step recorded in §13.286 and skipped last round.

With that, `stage2_upper`'s scaffolding compiles to the final `sorry`: `hn1`/`hN1`/`hNpos`/`hnK15`/
`hnK15'`/`hstage1`/`hu1`/`hu2`/`sb`/`hthird`/`hge`/`hMeq` all clean.

**Remaining final block:**
1. `set w := (p:ℝ)/(nmin p:ℝ) - Real.log 2`, `set w' := (p:ℝ)/((nmin p+1):ℝ) - Real.log 2`;
2. `hstep : 1 - E ≤ Y + X + D/((n:ℝ)^2)` from `hge`, `hthird`, `hMeq` (via `div_mul_cancel₀` on the
   `u'*(n:ℝ)` argument, as in `stage2_lower`);
3. `hX : X ≤ 3/((n':ℝ))` — the **`PhiS` upper bound** (the mirror of `uPhiS_ge`);
4. `hexp` from `exp_threshold_linear`;
5. `hww : w ≤ w' + 1/(n:ℝ)`;
6. `stage2_upper_exp` then `stage2_upper_arith2` with `K := 2*PhiC+1`.

### 13.287 Round-265: `uPhiS_le` (the upper mirror of `uPhiS_ge`) drafted — two errors

Build green: **192 declarations, 7/7 OK, 0 sorries**.

**Key constant check first:** `u ΦS(u) ≈ log2 · 6 ≈ 4.16`, so the upper bound must be **`≤ 5`**, not
`≤ 3` — the `3` of `hX : X ≤ 3/n'` arises *after* dividing by `2n'` (`X = u'ΦS(u')/(2n')`).  Getting
this backwards was the round-250 error; checking it first is the difference.

The helper is written as the exact mirror of `uPhiS_ge` (same `h1` bound on `26w + 10¹⁶w²`, same
`sq_le_sq'` route), with `Real.log 2 ≤ 3/4` from `Real.log_two_lt_d9` and the product bounded by
`mul_le_mul_of_nonneg_left`.

**Two errors (23, 24):** `hl`'s `linarith` from `Real.log_two_lt_d9` and the `mul_le_mul_of_nonneg_left`
application (needs the nonnegativity argument stated in the exact form the goal requires).

### 13.288 Round-266: `uPhiS_le` at one error

Build green: **192 declarations, 7/7 OK, 0 sorries**.

- `hl : Real.log 2 ≤ 3/4` needed `have h := Real.log_two_lt_d9; norm_num at h; linarith only [h]` —
  **`linarith` alone does not consume the decimal literal `0.6931471808`**, but `norm_num at h`
  converts it to a rational first (a reusable micro-rule);
- `h3` needed `rw [hu] at hPS ⊢` — rewriting `u → log2 + w` in the **hypothesis** as well as the
  goal, since `mul_le_mul_of_nonneg_left hPS hpos` requires `hPS` in the rewritten form.

**One error remains (24):** the product bound
`(log2 + w)·(6 - 26w + 10¹⁶w²) ≤ 5` by `nlinarith` — a genuinely nonlinear step.  **Next: reduce it
in two stages** — bound `6 - 26w + 10¹⁶w² ≤ 7` (from `26w + 10¹⁶w² ≤ 1/2`) and
`log2 + w ≤ 3/4 + q`, then multiply: `(3/4+q)·7 ≤ 5` needs `q ≤ 1/28`, which `hq : q ≤ 10⁻⁹` gives
easily.  This avoids asking `nlinarith` to multiply the two-variable polynomial in one step.

### 13.289 Round-267: `uPhiS_le` restructured into the two-stage product reduction — four errors

Build green: **192 declarations, 7/7 OK, 0 sorries**.

The single `nlinarith` product bound is replaced by the recorded five-step reduction:
`hb : 6 - 26w + 10¹⁶w² ≤ 7`; `ha : log2 + w ≤ 3/4 + q`; the two nonnegativity facts; the product via
`mul_le_mul`; and `hq2 : (3/4 + q)·7 ≤ 5` from `q ≤ 10⁻⁹`.

**Four errors (21, 26, 28, 32)** — the `linarith` steps in `hl`, `hb`, `hbpos`, and `ha`.  All are of
the class where the printed form differs from the written one; **per §13.284's pattern, print each goal
before adjusting** — in particular `hb` (`6 - 26w + 10¹⁶w² ≤ 7` from `26w + 10¹⁶w² ≤ 1/2`) is a pure
`linarith` and should close once the summand order matches.

### 13.290 Round-268: **a constant error caught while reading the goal** — `uPhiS_le` at one error

Build green: **192 declarations, 7/7 OK, 0 sorries**.

Printing the four goals gave three fixes and **one genuine constant error**:

* `hb` needed `(abs_le.mp hw).1 : -q ≤ w` (the bound `6 - 26w + 10¹⁶w² ≤ 7` requires `26w ≥ -1/2`);
* `hapos` needed the **lower** log bound `Real.log_two_gt_d9`;
* **`ha : log2 + w ≤ 3/4` was too weak** — `(3/4)·7 = 5.25 > 5`, so the product bound was *false as
  stated*.  Corrected to `≤ 7/10` (from `log2 ≤ 694/1000` and `w ≤ 10⁻⁹`), giving `0.7 · 7 = 4.9 ≤ 5`.

**One error remains (43):** the `h3` step (`u·ΦS(u) ≤ (log2+w)(6-26w+10¹⁶w²)` via
`mul_le_mul_of_nonneg_left`, with the `rw [hu] at hPS ⊢` hypothesis rewrite).  The `le_trans h3 h2`
substitution appears not to have taken at that line — **apply by explicit line edit with an assertion**.

### 13.291 **LANDED (round 268): `uPhiS_le`** — 193 declarations — all `stage2_upper` pieces now exist

`Op56/PhiThird.lean` now has **193 declarations** (0 sorries, 7/7 OK, 0 axioms), newly:

```lean
lemma uPhiS_le (u : ℝ) (q w : ℝ) (hq0 : 0 ≤ q) (hq : q ≤ 1/10^9)
    (hw : |w| ≤ q) (hu2 : u ≤ 1) (hu : u = Real.log 2 + w)
    (hPS : PhiS u ≤ 6 - 26*w + 10^16*w^2) :
    u * PhiS u ≤ 5
```

**Three facts about the decimal log bounds, now recorded once:**
1. `linarith` does **not** consume `Real.log_two_lt_d9 : Real.log 2 < 0.6931471808` directly —
   `norm_num at h` first;
2. **upper** bounds on `log2` use `Real.log_two_lt_d9`; **lower** bounds (for positivity of `log2 + w`)
   use `Real.log_two_gt_d9`;
3. the constant matters: `log2 + w ≤ 3/4` gives `0.75·7 = 5.25 > 5` — **a false bound** — while
   `≤ 7/10` gives `4.9 ≤ 5` ✓.  This is the sixth constant corrected before/at the statement.

**With this, `stage2_upper`'s final block has every ingredient:** `hstep`, `hX` (from `uPhiS_le`,
`X ≤ 3/n'`), `hexp`, `hww`, and the landed `stage2_upper_exp` + `stage2_upper_arith2`.

### 13.292 Round-269: `stage2_upper` final block — `w`/`w'` bounds written, two errors

Build green: **193 declarations, 7/7 OK, 0 sorries**.

The final block now contains: `set w`, `set w'`, the Stage-1 bound `hwabs : |w| ≤ (2PhiC+1)/n`, the
difference bound **`hdiff : |p/(n+1) − p/n| ≤ 1/n`**, and **`hwabs' : |w'| ≤ (2PhiC+2)/n`** via
`abs_add` + `add_le_add`.

**Two errors (68, 93):**
* **93** — `abs_add` is not the identifier (check `abs_add`/`abs_add_le`/`abs_add'` in this Mathlib);
  the triangle inequality used elsewhere in this file should be copied from there;
* **68** — `rw [abs_of_nonneg, abs_of_nonneg]` does not match; **state the two nonnegativity facts as
  `have`s and rewrite them by name**, rather than relying on `abs_of_nonneg` to synthesise the
  side conditions.

### 13.293 Round-270: `w`/`w'` block **compiles** — `stage2_upper`'s final block half-written

Build green: **193 declarations, 7/7 OK, 0 sorries**.

Both fixes landed, and the block now compiles to its remaining `sorry`:

* `abs_add_le` is the triangle inequality (**not** `abs_add` — verified by `#check`, and the same name
  is already used at line 976 of the file);
* `hdiff` was rewritten with `abs_of_nonpos` + `neg_sub` (the difference is negative, so the abs
  flips), then the `div_le_iff₀` step finished by a **`calc`** (`p ≤ n ≤ n+1 = (1/n)·(n·(n+1))`) —
  the identical pattern that closed `nmin_w_upper` in round 220, rather than another `nlinarith`.

So `hwabs : |w| ≤ (2PhiC+1)/n`, `hdiff : |p/(n+1) − p/n| ≤ 1/n`, and
`hwabs' : |w'| ≤ (2PhiC+2)/n` are all proved.

**Remaining in the final block:** `hq' : (2PhiC+2)/n ≤ 10⁻⁹`; `hstep : 1 − E ≤ Y + X + D/n'²` from
`hge`+`hthird`+`hMeq` (with `div_mul_cancel₀`); `hX : X ≤ 3/n'` from `uPhiS_le`; `hexp` from
`exp_threshold_linear`; `hww : w ≤ w' + 1/n`; then `stage2_upper_exp` and `stage2_upper_arith2`.

### 13.294 Round-271: `hq'` and `hstep` written — three errors

Build green: **193 declarations, 7/7 OK, 0 sorries**.

`hstep : 1 − E ≤ Y + X + D/n'²` is now written with the round-249 lesson applied: the `hthird'`
restatement, then `rw [div_mul_cancel₀ _ (ne_of_gt hNpos)] at h1` to normalise `u' * ↑n'` to `↑p`, then
`linarith only [h1, hge]`, then `rw [hMeq] at h2`.

**Three errors (96, 99, 109):**
* **96** — `hq'` referenced **inside its own proof** (a typo from the mechanical edit) — the `h4`
  step should use the hypothesis names in scope, not the goal;
* **99** — a type mismatch in the `hthird'` restatement;
* **109** — a `linarith` in `hstep`.

### 13.295 Round-272: **two more real gaps found by printing** — `stage2_upper` at one error

Build green: **193 declarations, 7/7 OK, 0 sorries**.

1. **`hq'`** — the goal `2PhiC+2 ≤ 10⁻⁹·n` does **not** follow from `2PhiC+2 ≤ n` (since
   `10⁻⁹ < 1`); it needs `10⁹·(2PhiC+2) ≤ 10¹⁵·((2PhiC+1)²+1) ≤ n`, which `nlinarith` on `0 < PhiC`
   supplies.  **A factor-of-10⁹ slip caught before it propagated.**
2. **`hstep` used the wrong `abs_le` projection** — the upper half needs a **lower** bound on `M`, i.e.
   `Phi - E ≤ PhiMainS`, which is `(abs_le.mp hthird).2`, **not `.1`**.  This is the mirror of the
   `stage2_lower` choice (which correctly uses `.1` for an upper bound on `M`) — and the **fourth**
   direction/projection error in Stage 2.

**One error remains (102):** `hstep`'s `linarith only [h1, hge]`.

### 13.296 Round-273: `hstep`'s last step — `h1`'s normalised form must be read, not assumed

Build green: **193 declarations, 7/7 OK, 0 sorries**.

`hstep`'s final step is `1 - E ≤ PhiMainS u' n'` from
`h1 := (abs_le.mp hthird).2` and `hge : 1 ≤ Phi (p:ℝ) (nmin p + 1)`.  The outer
`rw [div_mul_cancel₀ _ (ne_of_gt hNpos)] at h1` **is already applied**, so the extra `h3` rewrite
failed (*pattern not found*) — a sign the normalisation is in place — yet `linarith only [h1, hge]`
still fails.

**Next: print `h1`'s type with a deliberate mis-application** (the §13.270 technique — e.g.
`exact absurd h1 (by simp)`, which displays it in the error) **before** any further attempt.  This has
found the cause every time it has been used (rounds 249, 251, 262, 272) and the previous attempt this
round was reverted without reading it.

### 13.297 Round-274: **`hstep` compiles** — the type display found it immediately

Build green: **193 declarations, 7/7 OK, 0 sorries**.

**The §13.270 technique worked the moment I actually used it.**  Printing `h1`'s type showed

```
h1 : Phi (↑p) (nmin p + 1) - (EXPANDED M) ≤ 10^15-ish
```

— i.e. **`h1` carries the *expanded* `M`, while the goal is stated with `PhiMainS`**.  They are
equal by `hMeq` but not syntactically, which is exactly why `linarith` failed with every hypothesis in
scope and consistent.  Fixed by `rw [hMeq]` on the **goal** inside `hA` (mirroring the `stage2_lower`
fix), then `linarith only [h1]`.

With that, `hstep : 1 − E ≤ Y + X + D/n'²` **compiles together with `hq'`, and the whole
`w`/`w'`/`hstep` portion of the final block is clean**.

**Remaining:** `hX : X ≤ 3/n'` from `uPhiS_le`; `hexp` from `exp_threshold_linear`; `hww : w ≤ w' + 1/n`;
then `stage2_upper_exp` and `stage2_upper_arith2`.

### 13.298 Round-275: `stage2_upper`'s final block **fully written** — three errors

Build green: **193 declarations, 7/7 OK, 0 sorries**.

The block now contains every remaining ingredient: `hlin`/`hPS`/`hD` (the three sharp-bound
instantiations at `u'`), `hu'`, `hPSu` (via `(abs_le.mp hPS).2` + `rw [hwdef']`), `hS` from
`uPhiS_le`, `hexp` (via `.2`), `hDup` (via `.2`), `hX` (with the `div_mul_eq_mul_div` normalisation),
`hww` (from `hdiff`), `hE'`, then `stage2_upper_exp` and `stage2_upper_arith2`.

**Three errors (119, 121, 10):**
* **121** — `uPhiS_le` reported *unknown identifier*: **check whether it landed `private`** (the
  `grep` above shows the declaration line); if so make it public like the other Stage-2 helpers;
* **119** — `rw [abs_of_nonpos]` in `hww` misses (needs the nonpositivity fact supplied by name, the
  §13.292 pattern);
* **10** — an `unsolved goals` attributed to the declaration line, i.e. a body goal not yet closed.

### 13.299 Round-276: **the recent helpers landed inside a doubly-nested `Op56.Op56` namespace**

Build green: **193 declarations, 7/7 OK, 0 sorries**.

**Root cause of the "unknown identifier" for `uPhiS_le`:** the file contains **two**
`namespace Op56` blocks, and the second is *nested inside* the first (the first `end Op56` does not
occur before it).  Hence the recent helpers have the name

```
Op56.Op56.uPhiS_le      -- confirmed by #check
```

while `Op56.uPhiS_le` does not exist.  This affects **every helper landed after the second
`namespace Op56` opened** (`uPhiS_le`, and any others in that block).

**Two possible fixes (next round):**
1. **In the scratch**: refer to the qualified name `Op56.Op56.uPhiS_le` — zero risk to the
   deliverable;
2. **In the file** (preferred, cosmetic): remove the redundant inner `namespace Op56`/`end Op56`
   pair so the helpers sit at `Op56.*` like everything else.  This requires a full `check.sh`
   re-verification.

`stage2_upper_exp` was made public by `sed` this round; its qualified name must also be re-checked.

### 13.300 Round-277: **build broken and restored** — the inner `namespace Op56` is NOT redundant

Build green again (**verified twice: 7/7 OK, 0 sorries, 193 declarations**).

**What happened.** Believing §13.299's option 2 (remove the "redundant" inner `namespace Op56`), I
deleted line 5987.  The build **failed**: `Unexpected name 'Op56' after 'end': The current section is
unnamed` — because the outer `namespace Op56` (line 43) is closed *before* line 5987, so the inner
block is a **genuine second top-level `Op56`**, and its `end Op56` at line 6069 is its own.  Removing
the header orphaned that `end`.  **Restored the line; green re-verified.**

**Corrected understanding (replaces §13.299's option 2):** the file legitimately has two sibling
`Op56` namespace blocks, so the recent helpers really are named **`Op56.Op56.uPhiS_le`**, etc.  That
is *not* a defect to fix; it is the name to use.

**Therefore the fix is option 1 only:** in the scratch, refer to `Op56.Op56.uPhiS_le` and
`Op56.Op56.stage2_upper_exp`.

### 13.301 Round-278: name resolution fixed — `stage2_upper`'s block at five real errors

Build green: **193 declarations, 7/7 OK, 0 sorries**.

Qualifying the two names as `Op56.Op56.uPhiS_le` and `Op56.Op56.stage2_upper_exp` **resolved the
"unknown identifier" errors**, confirming §13.300's corrected understanding.  The remaining errors are
now genuine proof issues rather than resolution failures:

* **119, 126** — `rw` pattern misses (the `rw [hwdef'] at h` steps in `hPSu`/`hexp` — the hypothesis
  form must be read, per §13.297);
* **146** — a type mismatch in `hww`'s `abs_of_nonpos` route;
* **159** — a `linarith` in `hE'`;
* **166** — an application mismatch at the `stage2_upper_exp` call.

### 13.302 Round-279: printed all five goals — diagnosis for `hE'` and the two rewrites

Build green: **193 declarations, 7/7 OK, 0 sorries**.

Printed output:
* **159** (`hE'`) — `a✝ : ?m.3440 < 10^12`, i.e. a **metavariable** in the negated goal.  This means
  the `hb : (8*10^10 + 2*(4*10^10+5) + 7 : ℝ) ≤ 10^12 := by norm_num` step is not being given a type
  before use — **the fix is `have hb : … := by norm_num` with the `: ℝ` ascription already present,
  so check `nlinarith`'s argument list rather than `hb` itself** (the `?m` arises from the
  `nlinarith only [hn1'']` inside `le_trans hb …`);
* **119, 126** — `rw` pattern misses (`rw [hwdef'] at h`): the hypothesis `h` is in terms of
  `(u - Real.log 2)`, and `hwdef'` states `w' = …` — **the rewrite must be `rw [← hwdef'] at h`**,
  i.e. replace `Real.log 2`-form with `w'`, not the reverse;
* **146, 166** — type/application mismatches, to be printed next.

### 13.303 Round-280: two fixes landed; **a real `n`/`n'` mismatch identified in `stage2_upper_arith2`**

Build green: **193 declarations, 7/7 OK, 0 sorries**.

* **119/126 fixed** — the rewrite really was `rw [← hwdef'] at h` (the hypothesis carries
  `u − log2`, so the arrow must go *from* the unfolded form *to* `w'`).  §13.302's diagnosis was
  correct and this was the seventh confirmation of the "which side carries the unfolded form" rule.
* **146 fixed** — `abs_of_nonpos` on `p/n' − p/n` yields `−(p/n' − p/n)`; adding `neg_sub` to the
  rewrite gives the needed `p/n − p/n'`.
* **166 — a genuine structural mismatch, not a notation issue.**  `hX` is proved with `n' = nmin p + 1`
  (`3/↑(nmin p + 1)`), but `stage2_upper_exp` was called with `n = nmin p`, so its conclusion is
  `−(3/n) − 10¹⁵/n² < …` while `hX` supplies the `n'` version.  **They cannot both be at the same
  `n`:** `hX` needs `n'` (the threshold point), while `hww : w ≤ w' + 1/n` and the conclusion
  `w ≤ 4/n` need `n = nmin p`.  The fix applied: call `stage2_upper_exp` at `n'` and **bridge** with
  `−(3/n) − 10¹⁵/n² < −(3/n') − 10¹⁵/n'²` (valid since `n < n'`), then call
  `stage2_upper_arith2` at `n = nmin p`.

That bridge is written but has five errors of its own (159, 166, 172, 179–180): `hbridge`'s
`sub_lt_sub_iff_right` rewrite, the unknown identifier `hw` (renamed in the restructure), and two
application mismatches.  **Next: print each, per §13.297 — do not rearrange.**

### 13.304 Round-281: `K = 2*PhiC+2` for the upper call — five errors remain

Build green: **193 declarations, 7/7 OK, 0 sorries**.

The `hw`-unknown error is resolved by supplying `K := 2*PhiC+2` (larger than the Stage-1 constant, which
is harmless since `stage2_upper_arith2` uses `hw` only to bound `500w'²`), with
`hwK : w'^2 ≤ ((2PhiC+2)/n)^2` from `hwabs'` and `hnKK : 10¹⁵·((2PhiC+2)²+1) ≤ n` derived from `hnK15`.

**Five errors remain (159, 166, 172, 183, 184):** `hE'`'s `nlinarith` (with the metavariable seen in
§13.302), the `stage2_upper_exp` application mismatch (166), `hbridge`'s
`sub_lt_sub_iff_right` rewrite (172), and two `linarith`s (183, 184).  **All are to be printed first
per §13.297.**

### 13.305 Round-282: **one-at-a-time works** — two errors fixed, count 5 → 4

Build green: **193 declarations, 7/7 OK, 0 sorries**.

Worked strictly one error per edit, re-running after each, as committed:

1. **159 (`hE'`) fixed** by transcribing the **landed `stage2_lower` `hE` pattern** verbatim
   (`hbig := le_trans hb (by nlinarith only [hn1''])`, the `hcube` rewrite, `mul_le_mul_of_nonneg_right`,
   and the `heq` association identity with `linarith only [hmul, heq.le, heq.ge]`).  This is the
   fifth time a landed mirror-step has closed its twin on the first attempt.
2. **190 (`hbridge` in the `lt_trans`) fixed** — the mismatch was exactly
   `-(3 / ↑n)` versus `-3 / ↑n` (the unary-minus binding class, now the **seventh** instance).
   Restating `hbridge` with the *printed* form `-(3:ℝ) / (nmin p:ℝ)` closed it.

**Four errors remain (170, 176, 187, 188):** the `stage2_upper_exp` application (170), `hbridge`'s
`sub_lt_sub_iff_right` rewrite (176), and two `linarith`s (187, 188).  **Continue one at a time.**

### 13.306 Round-283: three fixes, count 4 → 3

Build green: **193 declarations, 7/7 OK, 0 sorries**.

One at a time, re-running after each:

1. **170 fixed** — `stage2_upper_exp`'s interface takes `hthird : 1 − E − X − D/n² ≤ Y`, but `hstep`
   was stated in the *other* form (`1 − E ≤ Y + X + D/n²`).  **Restated `hstep` in the helper's form
   directly** rather than converting at the call site — cleaner, and it removes the need for any
   rearrangement lemma.
2. **101/110 fixed** — once `hstep`'s statement changed, the `h2`/`rw [hMeq]` scaffolding was both
   redundant *and* inapplicable (`hMeq` has nothing to rewrite, since the goal's `Y` is already the
   `exp` term and `h1` already carries the expansion).  **Deleted the scaffolding**; `hstep` is now
   four lines: `(abs_le.mp hthird).2`, the `div_mul_cancel₀` rewrite, and `linarith only [h1, hge]`.

**Three errors remain (167, 178, 179):** `hbridge`'s `sub_lt_sub_iff_right` rewrite (167) and two
`linarith`s (178, 179).

### 13.307 Round-284: `hbridge` restructured; count 3 → 5 (new errors in the restructure)

Build green: **193 declarations, 7/7 OK, 0 sorries**.

The printed error showed `rw [sub_lt_sub_iff_right]` cannot match
`?a - c < ?b - c` because the two subtrahends differ (`10¹⁵/n²` vs `10¹⁵/n'²`).  Replaced the rewrite
with the direct analytic proof: `h4 : 10¹⁵/n'² < 10¹⁵/n²` via `div_lt_div_iff₀` + `nlinarith`, and
`h5 : 3/n' < 3/n` as before, then `linarith`.

**Five errors now (170, 173, 174, 179, 180)** — three inside the new `hbridge` and two in the call.
The count rose because `h4`'s `div_lt_div_iff₀` goal needs the `nlinarith` hints in the exact printed
form.  **Honest note: this is the batching failure mode returning** — I replaced one rewrite with two
new steps and did not isolate them.  **Next round: fix `h4` alone, re-run, confirm, then `h5`.**

### 13.308 Round-285: **three fixes, count 5 → 2** — the strictness check paid twice

Build green: **193 declarations, 7/7 OK, 0 sorries**.

One at a time, re-running after each:

1. **`h4` fixed** — the printed goal was `10¹⁵·n² < 10¹⁵·n'²`, **strict**, while `h1 : n ≤ n'` is
   non-strict.  Adding `h1s : (nmin p:ℝ) < ↑(nmin p + 1)` (by `push_cast; linarith`) closed it.
   **This is the §13.281 strictness check firing again — eighth confirmation.**
2. **`h5` fixed** by the same substitution (`nlinarith only [h1s]` instead of `[h1]`).
3. **`hbridge`'s closing step fixed** — `linarith only [h4, h5]` failed on the unary-minus binding
   (`-3/↑n` vs `-(3/↑n)`), so two explicit `ring` identities `e1`/`e2` were supplied: the **eighth**
   instance of that class.

**Two errors remain (182, 183):** the `hnKK` proof's `nlinarith`s.

### 13.309 **LANDED (round 286): `stage2_upper`** — 194 declarations — **BOTH HALVES OF STAGE 2 COMPLETE**

`Op56/PhiThird.lean` now has **194 declarations** (0 sorries, 7/7 OK, 0 axioms), newly:

```lean
private lemma stage2_upper (p : ℕ) (hp : 6 ≤ p) (hn : 2000000000 ≤ nmin p)
    (hlarge : 3*PhiC ≤ ((2*p : ℕ):ℝ))
    (hnK : 10^40 * ((2*PhiC+1)^2 + 1) ≤ (nmin p:ℝ)) :
    (p:ℝ)/(nmin p :ℝ) - Real.log 2 ≤ 4/(nmin p :ℝ)
```

**The final fix was the `hnKK` derivation** — restated along the `hnK15` pattern
(`10¹⁵·((2PhiC+2)²+1) ≤ 10⁴⁰·((2PhiC+1)²+1) ≤ n`), replacing a `h2` whose goal was a sum-to-itself
comparison that `linarith` could not clear.  **No errors on the run that followed** — a clean landing.

**With `stage2_lower` this gives the complete Stage-2 arithmetic:**
**`−4/nmin p ≤ w ≤ 4/nmin p`, i.e. `|p/nmin p − log2| ≤ 4/nmin p`** — exactly the hypothesis both
window lemmas (`Phi_window_low`, `Phi_window_high`) require.

### Remaining for `op5_nmin_asymptotic`

1. **`nmin_w_sharp`** — a two-line lemma applying `stage2_lower` and `stage2_upper` to get
   `|p/nmin p − log2| ≤ 4/nmin p` (both hypotheses `hnK` are already carried);
2. apply `Phi_window_low` at `nmin p` and `Phi_window_high` at `nmin p + 1` by contrapositive;
3. combine into `nmin p = p/log2 − 5/2 + O(1/p)` and close `op5_nmin_asymptotic`;
4. then `op6_reachable_fraction`.

### 13.310 **LANDED (round 287): `nmin_w_sharp`** — 195 declarations — **STAGE 2 COMPLETE**

`Op56/PhiThird.lean` now has **195 declarations** (0 sorries, 7/7 OK, 0 axioms), newly:

```lean
lemma nmin_w_sharp (p : ℕ) (hp : 6 ≤ p) (hn : 2000000000 ≤ nmin p)
    (hlarge : 3*PhiC ≤ ((2*p : ℕ):ℝ))
    (hnK : 10^40 * ((2*PhiC+1)^2 + 1) ≤ (nmin p:ℝ)) :
    |(p:ℝ)/(nmin p :ℝ) - Real.log 2| ≤ 4/(nmin p :ℝ)
```

— the **sharp** Stage-2 bound, obtained as `abs_le.mpr ⟨stage2_lower …, stage2_upper …⟩`.

**Note:** `stage2_lower`/`stage2_upper` were made public by `sed`, but `#check` from a scratch file still
reports them unknown — the names are, however, **in scope within `PhiThird.lean`**, which is why
`nmin_w_sharp` was added to the file itself and verified by `check.sh`.  (The scratch-visibility puzzle
is not worth further rounds; the deliverable is verified.)

### Remaining for `op5_nmin_asymptotic`

1. **Apply the two window lemmas.**  `Phi_window_low` / `Phi_window_high` take `hwabs : |u − log2| ≤
   4/n`, `hn : 2·10⁹ ≤ n`, and constants `10¹⁹`.  With `n := nmin p` and `u := p/nmin p`,
   `nmin_w_sharp` supplies `hwabs` **exactly** — **no edits to the four landed window lemmas**;
2. combine the two windows into `nmin p = p/log2 − 5/2 + O(1/p)`;
3. close `op5_nmin_asymptotic` (the `sorry` in `Asymptotic.lean`);
4. then `op6_reachable_fraction`.

### 13.311 **LANDED (round 288): `nmin_window_low`** — 196 declarations — **first-try landing**

`Op56/PhiThird.lean` now has **196 declarations** (0 sorries, 7/7 OK, 0 axioms), newly:

```lean
lemma nmin_window_low (p : ℕ) (hp : 6 ≤ p) (hn : 2000000000 ≤ nmin p)
    (hlarge : 3*PhiC ≤ ((2*p : ℕ):ℝ))
    (hnK : 10^40 * ((2*PhiC+1)^2 + 1) ≤ (nmin p:ℝ)) :
    Real.log 2 + 3*Real.log 2/(2*(nmin p:ℝ)) - 10^19/((nmin p:ℝ)^2)
      < (p:ℝ)/(nmin p:ℝ)
```

— the contrapositive of `Phi_window_low` against `nmin_Phi_lt`, with `hwabs` supplied by
`nmin_w_sharp` and the `div_mul_cancel₀` normalisation of `Phi`'s `u*(n:ℝ)` argument.  **Landed on the
first run** — the whole point of having every ingredient already in the kernel.

### ⚠️ Structural obstacle to the UPPER window (must be solved before `nmin_window_high`)

`Phi_window_high` must be applied at `n' = nmin p + 1`, because the threshold fact at that point is
`nmin_Phi_ge : 1 ≤ Phi p (nmin p + 1)`, and the window concludes `Phi (u*n) n < 1` — so `u := p/n'`,
`n := n'`, and **`hwabs` is required at `n'`: `|p/n' − log2| ≤ 4/n'`.**

But `nmin_w_sharp` gives `|p/n − log2| ≤ 4/n` at `n`, and the only bridge is
`|p/n' − p/n| ≤ 1/n`, yielding `|p/n' − log2| ≤ 5/n` — and **`5/n ≤ 4/(n+1)` is FALSE**.  So the
coarse constant `4` does not propagate.

**Two viable fixes (next round):**
1. **Add `stage2_upper_arith3`** concluding `w ≤ 3/n` (the landed `stage2_upper_arith2` already proves
   the intermediate `w ≤ 61/20/n = 3.05/n` — a constant-`3` variant needs the same chain with
   `3` in place of the `4` in the final `h9`); then `|p/n' − log2| ≤ 3/n + 1/n = 4/n ≤ 4/n'` ✓.
   **But careful:** `4/n ≤ 4/n'` is FALSE — the needed form is `|p/n' − log2| ≤ 4/n'`, which follows
   from `|p/n − log2| ≤ 3/n` **and** `|p/n' − p/n| ≤ 1/n` only if `3/n + 1/n ≤ 4/n'` — again false.
   **So fix 1 alone is insufficient; the correct requirement is `|p/n' − log2| ≤ 4/n'` directly.**
2. **Re-derive Stage 2 at `n'` directly** (`nmin_w_sharp'` at `nmin p + 1`), either by re-running the
   two Stage-2 halves with `n := nmin p + 1` (the helpers take `n` generically — only `nmin_Phi_ge`
   supplies the threshold at `n'`), or by observing that the upper half's chain already uses `n'` for
   `hX`/`hstep` and only `hww`/the conclusion use `n`.

**Option 2 is the principled route and is likely one round:** `stage2_upper_arith2` concludes
`w ≤ 4/n` where `w` is *any* real satisfying `hww : w ≤ w' + 1/n` — so feeding it `n := nmin p + 1`
and `w := p/n' − log2` directly gives `|p/n' − log2| ≤ 4/n'` (the lower half already holds at `n'` for
free with `-(4/n') ≤ ·`).

### 13.312 Round-289: the upper-window obstacle is now **exactly** characterised

Build green: **196 declarations, 7/7 OK, 0 sorries**.

I worked the propagation algebra through completely, and the conclusion is sharper than §13.311's:

* the sharpest available bridge is `u − u' = p/(n·n') ≤ 1/n'` (**not** `1/n` — this uses `p ≤ n`, so
  `p/(n·n') ≤ n/(n·n') = 1/n'` ✓);
* hence `|u' − log2| ≤ 4/n + 1/n'`, and `4/n + 1/n' ≤ 4/n'` requires `4n' ≤ 3n` — **false**.

**So the coarse Stage-2 constant `4` genuinely cannot be propagated to `n'` at all.**  The true value
is `≈ 1.04/n`, so any constant `≤ 3` would work, but `stage2_lower_arith`/`stage2_upper_arith2` hard-code
`4`.

**The real fix** is therefore to **re-run the upper arithmetic with `n := nmin p + 1`**, and the earlier
hope that this is "a copy" is *not* quite right either: `hwK : w'^2 ≤ ((2PhiC+2)/n)^2` is stated at `n`,
and at `n'` it needs the Stage-1-style bound **at `n'`** (`|w'| ≤ (2PhiC+2)/n'`), which is *not*
available from `hwabs'` (that is `≤ (2PhiC+2)/n`, a **weaker** bound at the larger `n'`).

**Recommended next step (concrete):** prove
`nmin_w_stage1' : |p/n' − log2| ≤ (2PhiC+3)/n'` by a **short direct argument** —
`|p/n' − log2| ≤ |p/n − log2| + |p/n − p/n'| ≤ (2PhiC+1)/n + 1/n'`
and then `(2PhiC+1)/n + 1/n' ≤ (2PhiC+3)/n'` (from `n < n'` and `1/n < 1/n'`).  That supplies `hwabs'`
and `hwK` for the `n'`-point upper arithmetic, after which the rest of `stage2_upper`'s body applies
verbatim with `n := n'`.

### 13.313 **LANDED (round 290): `nmin_w_stage1'`** — 197 declarations — **first try, from the written plan**

`Op56/PhiThird.lean` now has **197 declarations** (0 sorries, 7/7 OK, 0 axioms), newly:

```lean
lemma nmin_w_stage1' (p : ℕ) (hp : 6 ≤ p) (hn : 2000000000 ≤ nmin p)
    (hlarge : 3*PhiC ≤ ((2*p : ℕ):ℝ))
    (hnK : 10^40 * ((2*PhiC+1)^2 + 1) ≤ (nmin p:ℝ)) :
    |(p:ℝ)/(((nmin p + 1 : ℕ)):ℝ) - Real.log 2| ≤ (2*PhiC+3)/(((nmin p + 1 : ℕ)):ℝ)
```

Three ingredients, each of a form already used elsewhere in the file: the **sharper** difference
bound `|p/n − p/n'| ≤ 1/n'` (via `p ≤ n`, not the earlier `≤ 1/n`), the triangle inequality
`abs_sub` applied after an explicit `ring` identity, and the constant step
`(2PhiC+1)/n + 1/n' ≤ (2PhiC+3)/n'` (needing `2PhiC+1 ≤ n`, which `hnK15` gives).

**Landed on the first run** — the fourth first-try landing in five rounds, all of them from plans
written before the code.

### Next: `nmin_window_high`

`nmin_w_stage1'` supplies the **`K`** for the `n'`-point Stage-2 helpers (they take `K` symbolically),
which is exactly what §13.312 identified as missing.  So the route is now fully determined:

1. `hwabs' : |p/n' − log2| ≤ (2PhiC+3)/n'` (landed);
2. `hwK' : w'^2 ≤ ((2PhiC+3)/n')²` from it via `sq_le_sq'`;
3. `hnKK' : 10¹⁵·((2PhiC+3)²+1) ≤ n'` from `hnK` (as in `hnKK`);
4. re-run `stage2_upper_exp` at `n'` (the `hstep` derivation is already structured at `n'`), then
   `stage2_upper_arith2` with `n := n'`, `K := 2PhiC+3`, and `hww := le_add_of_nonneg_right (0 ≤ 1/n')`
   — giving **`p/n' − log2 ≤ 4/n'`**;
5. the lower side is free: `−(4/n') ≤ p/n' − log2` from `nmin_w_sharp`'s lower bound at `n` plus
   `n ≤ n'`;
6. `abs_le.mpr` gives `hwabs` for the window, then `Phi_window_high` contrapositive with
   `nmin_Phi_ge`: **`nmin_window_high`**.

### 13.314 Round-291: `nmin_upper_sharp2` adaptation prepared (not yet landed)

Build green: **197 declarations, 7/7 OK, 0 sorries**.

Prepared (in `/tmp/adapt.txt`) a mechanical adaptation of the landed `stage2_upper` body to the `n'`
point, per §13.313's route:

* renamed `nmin_upper_sharp2`, conclusion about `w := p/n' − log2`;
* `set w := (p:ℝ)/↑(nmin p + 1) − Real.log 2`;
* final call changed to
  `stage2_upper_arith2 (nmin p + 1) _ (2*PhiC+3) _ hnKK w' w' hwK hstep' (le_add_of_nonneg_right (by positivity))`
  — i.e. `n := n'`, `K := 2PhiC+3`, and `hww` trivial;
* `hbridge` dropped (no longer needed, since both sides are at the same `n`).

**Deliberately NOT landed this round.**  The adaptation still has unverified pieces — `hstage1`/`hwabs`
inside the body refer to `n`, `hdiff` is stated with `≤ 1/n'`, and `hwK`/`hnKK` must be re-derived with
`K := 2PhiC+3` at `n'` — and pasting a 10 000-character adapted body without isolating those is exactly
the batching pattern that cost rounds 275–284.

**Next round: land the adaptation in ≤ 3 pieces, verifying `check.sh` after each** — (a) `hwK'`/`hnKK'`
at `K := 2PhiC+3`, (b) the `hstage1`/`hwabs` re-pointing, (c) the adapted final call.

### 13.315 **LANDED (round 292): `nmin_K_bounds` + `nmin_hwK'`** — 199 declarations — **two first-try landings**

`Op56/PhiThird.lean` now has **199 declarations** (0 sorries, 7/7 OK, 0 axioms), newly:

```lean
lemma nmin_K_bounds (p : ℕ) (hp : 6 ≤ p) (hn : 2000000000 ≤ nmin p)
    (hnK : 10^40 * ((2*PhiC+1)^2 + 1) ≤ (nmin p:ℝ)) :
    (10^15:ℝ) * ((2*PhiC+3)^2 + 1) ≤ (((nmin p + 1 : ℕ)):ℝ)

lemma nmin_hwK' (p : ℕ) (hp : 6 ≤ p) (hn : 2000000000 ≤ nmin p)
    (hlarge : 3*PhiC ≤ ((2*p : ℕ):ℝ))
    (hnK : 10^40 * ((2*PhiC+1)^2 + 1) ≤ (nmin p:ℝ)) :
    ((p:ℝ)/(((nmin p + 1 : ℕ)):ℝ) - Real.log 2)^2
      ≤ ((2*PhiC+3)/(((nmin p + 1 : ℕ)):ℝ))^2
```

— **pieces (a) and (b) of the three-part plan**, both landed on the first run.  `nmin_K_bounds` is the
largeness condition for `K := 2PhiC+3` at `n'`; `nmin_hwK'` is the `w'²` bound from `nmin_w_stage1'`
via `sq_le_sq'`.

**Piece (c) remains:** the adapted final call — `stage2_upper_arith2 (nmin p + 1) _ (2*PhiC+3) _ (nmin_K_bounds …) w' w' (nmin_hwK' …) hstep' (le_add_of_nonneg_right (by positivity))` — where `hstep'` is `stage2_upper_exp`'s conclusion at `n'`, which in turn needs the `hX`/`hstep` derivations re-pointed to `n'` (they are already *stated* at `n'` inside `stage2_upper`).

### 13.316 Round-293: **insertion broke the build; reverted and re-verified green**

Build green again (**verified: 7/7 OK, 0 sorries, 199 declarations**).

**What happened.** I generated the adapted `nmin_upper_sharp2` (the whole 10 000-character
`stage2_upper` body with the final call changed to `n := nmin p + 1`, `K := 2*PhiC+3`, using the
landed `nmin_K_bounds`/`nmin_hwK'`) and inserted it in one edit.  **Four errors** appeared
(type mismatch at 6415, unsolved goals at 6435, `linarith` at 6497, application mismatch at 6541) —
exactly the pieces §13.314 flagged as unverified (`hstage1`/`hwabs`/`hdiff` still referring to `n`).
**Reverted immediately; green re-verified.**

**This is the §13.314 prediction confirmed.**  I had written that pasting the adapted body without
isolating those pieces "is exactly the batching pattern that cost rounds 275–284" — and then did it
anyway.  The two pieces I *did* isolate (`nmin_K_bounds`, `nmin_hwK'`) both landed first try.

**Next round — the correct decomposition of piece (c), in order:**
1. extract `hstep'` for the upper half as **its own lemma at `n'`** — i.e. a lemma
   `nmin_hstep' : 1 − E' − X' − D'/n'² ≤ (exp(p/n') − 1)⁻¹`, whose body is *exactly* the `hstep`
   block already written inside `stage2_upper` (which is already stated at `n'`);
2. likewise extract `hX : X' ≤ 3/n'` as `nmin_hX'` (body = the `hX` block, already at `n'`);
3. **only then** the three-line `nmin_upper_sharp'` assembling them through
   `stage2_upper_exp (nmin p + 1) …` and `stage2_upper_arith2 (nmin p + 1) … (nmin_K_bounds) w' w'
   (nmin_hwK') hstep'' (le_add_of_nonneg_right _)`.

Each of 1–3 is a separate round step with `check.sh` between.

### 13.317 Round-294: piece (c)'s decomposition assessed — the extracted statements are very large

Build green: **199 declarations, 7/7 OK, 0 sorries**.

Working out step 1 of §13.316's plan (`nmin_hstep'`) showed the obstacle is **statement size**, not
mathematics: the `hstep` block inside `stage2_upper` depends on `hu1`, `hu2`, `hthird`, `hge`, `hMeq`,
and each of those — especially `hthird` (`|Phi (u'·n') n' − PhiMainS u' n'| ≤ E`) and `hMeq` (the full
verbatim `PhiMainS_eq` expansion) — must appear **verbatim** in the extracted lemma's signature.  That
is a ~15-line statement for a 4-line body, repeated for `nmin_hX'`.

**Better decomposition (next round):** do **not** extract `hstep`/`hX`.  Instead write
`nmin_upper_sharp'` as a lemma whose *statement* is short —

```lean
lemma nmin_upper_sharp' (p : ℕ) (hp : 6 ≤ p) (hn : 2000000000 ≤ nmin p)
    (hlarge : 3*PhiC ≤ ((2*p : ℕ):ℝ))
    (hnK : 10^40 * ((2*PhiC+1)^2 + 1) ≤ (nmin p:ℝ)) :
    (p:ℝ)/(((nmin p + 1 : ℕ)):ℝ) - Real.log 2 ≤ 4/(((nmin p + 1 : ℕ)):ℝ)
```

— and **build its body incrementally inside the file**: insert the body in ≤ 4 chunks, running
`check.sh` after each, so that the intermediate states are green (Lean reports errors but `check.sh`
counts `OK` per file; a partially-written lemma with `sorry`-free but failing steps must instead be
built by *appending* verified `have`s to a lemma that ends in `sorry` temporarily in the **scratch**,
then pasting once green).

**Cleanest concrete route:** put the lemma into the *file* with the body reduced to
`by sorry` **only in a scratch copy**, develop the body in the scratch by pasting `stage2_upper`'s
verified blocks, and paste the finished body into the file in one edit — accepting that this is one
batched paste, but of **already-verified** text rather than adapted text.

### 13.318 Round-295: the adaptation's four issues reproduced **in the scratch** (at zero cost)

Build green: **199 declarations, 7/7 OK, 0 sorries** — the deliverable was never touched.

`/tmp/w1320.lean` holds `nmin_upper_sharp7`, the `stage2_upper` body adapted to `n'` with the new
`nmin_K_bounds`/`nmin_hwK'`.  It **reproduces the same four errors** as round 293's in-file paste
(type mismatch, unsolved goals, `linarith`, application mismatch) — but in the scratch, where the
round costs nothing and the deliverable stays green.

**This is the right place to do the adaptation**, and the four issues are now isolated to a file that
can be edited freely.  The first (line 60) is the next target.

**Note on the route:** the four failures confirm that the `n'`-point blocks are *not* drop-in —
something in `hstage1`/`hwabs`/`hdiff` (all stated at `n`) is genuinely used at `n'`.  Once located,
the fix is likely to be `nmin_hwK'`-style: replace that block with the landed `n'`-point lemmas.

### 13.319 Round-296: first scratch fix landed — `hwabs` repointed to `nmin_w_stage1'`

Build green: **199 declarations, 7/7 OK, 0 sorries**.

The printed error confirmed §13.318's prediction exactly: after `hwdef` was changed to
`w = p/n' − log2`, the line `have hwabs : |w| ≤ (2PhiC+1)/n := by rw [hwdef]; exact hstage1`
no longer type-checked (`rw [hwdef]` rewrites to the `n'` form, but `hstage1` is the `n` bound).
**Fixed by repointing to the landed `n'`-point lemma:**

```lean
have hwabs : |w| ≤ (2*PhiC+3)/((nmin p + 1 : ℕ):ℝ) := by
  rw [hwdef]
  exact Op56.nmin_w_stage1' p hp hn hlarge hnK
```

— precisely the "replace with the landed `n'`-point lemmas" route §13.318 anticipated.

**Remaining in the scratch (82, 88, 144, 188, 191):** one new application mismatch from the repointing
(88), the `unsolved goals` at 82, a `linarith` at 144, the final call at 188, and a **syntax error at
191** (an `end` misplaced when the scratch file was assembled — cosmetic, fix by hand).

### 13.320 Round-297: scratch adaptation reduced to four errors

Build green: **199 declarations, 7/7 OK, 0 sorries**.

Three fixes in the scratch, each verified by re-running:

1. **syntax error fixed** — the extracted body had picked up a trailing doc-comment from the slice
   boundary (`/-- Stage 2 conclusion … -/`), which made the file's `end` unexpected; stripped it.
2. **`hwabs'`/`hq'` redefined at `n'`** — I first *deleted* them as obsolete, but the re-run showed
   they are still consumed by the `hS` (`uPhiS_le`) call, so they were reinstated at the `n'` point:
   `hwabs' := nmin_w_stage1' …` and `hq' : (2PhiC+3)/n' ≤ 10⁻⁹` via `hnK15` and `n ≤ n'`.
3. the superseded `hwK`/`hnKK` blocks **were** removable, since the final call now uses the landed
   `nmin_K_bounds`/`nmin_hwK'`.

**Four errors remain (103, 110, 139, 177):** the two `hS`-call constant mismatches (103/110 — the
`uPhiS_le` application now needs its `q`/`hw` arguments in the `2PhiC+3`/`n'` form), the `linarith` at
139, and the final call at 177.

### 13.321 **LANDED (round 298): `nmin_upper_sharp_p`** — **200 declarations** — the `n'`-point upper bound

`Op56/PhiThird.lean` now has **200 declarations** (0 sorries, 7/7 OK, 0 axioms), newly:

```lean
lemma nmin_upper_sharp_p (p : ℕ) (hp : 6 ≤ p) (hn : 2000000000 ≤ nmin p)
    (hlarge : 3*PhiC ≤ ((2*p : ℕ):ℝ))
    (hnK : 10^40 * ((2*PhiC+1)^2 + 1) ≤ (nmin p:ℝ)) :
    (p:ℝ)/(((nmin p + 1 : ℕ)):ℝ) - Real.log 2 ≤ 4/(((nmin p + 1 : ℕ)):ℝ)
```

— developed **entirely in the scratch** (five verified edits, error count 5 → 4 → 2 → 1 → 0) and pasted
into the file only once green.  The final fixes were `hwabs'`/`hq'` redefined at `n'`, the `hS` call's
`q` retyped to `2PhiC+3`, `hww` proved by `le_add_of_nonneg_right`, the binding identity
`-((3)/(n')) = -(3)/(n')` supplied for `hstep''`, and the **lemma statement's evaluation point**
corrected to `4/↑(nmin p + 1)`.

**The scratch route worked exactly as §13.318 predicted:** round 293's identical adaptation, pasted
in-file, broke the build and cost a round; this one, developed in the scratch, landed clean.

### Remaining: `nmin_window_high` (now a short assembly)

1. `stage2_lower` at `n'` for the **lower** side: `−(4/n') ≤ p/n' − log2` follows from `nmin_w_sharp`'s
   lower bound at `n` plus `n ≤ n'` (monotonicity, no new arithmetic);
2. `abs_le.mpr ⟨…, nmin_upper_sharp_p …⟩` gives `hwabs` for the window;
3. `Phi_window_high`'s contrapositive against `nmin_Phi_ge` (with `u := p/n'`, `n := n'`) gives
   **`nmin_window_high`**.

### 13.322 Round-299: **a genuine gap in the upper-window route** — the lower half at `n'`

Build green: **200 declarations, 7/7 OK, 0 sorries**.

Writing `nmin_window_high` in the scratch (errors now isolated: the name resolution needed
`Op56.Op56.…`, then two real errors) exposed a **mathematical** gap, not a notational one:

`Phi_window_high` needs `hwabs : |p/n' − log2| ≤ 4/n'`.  The **upper** half is landed
(`nmin_upper_sharp_p`).  The **lower** half, `−(4/n') ≤ p/n' − log2`, is the problem:

* from `nmin_w_sharp` at `n`: `w ≥ −4/n`; and `w' = w − (u − u')` with `u − u' = p/(n·n') ≤ 1/n'`;
* so `w' ≥ −4/n − 1/n'`, and `−4/n − 1/n' ≥ −4/n'` requires `3n ≥ 4n'` — **false**;
* the natural alternative (`div_le_div_of_nonneg_left`) is also the *wrong direction*: `n ≤ n'` gives
  `p/n ≥ p/n'`, not `≤`.

**And there is no direct lower-bound argument at `n'` either:** the Stage-2 lower half needs
`Phi p n' < 1`, but at `n'` we have exactly the opposite (`nmin_Phi_ge : 1 ≤ Phi p n'`).  So
`w' ≥ −4/n'` is **true** (the true value is `≈ 0.35/n > 0`) but is not reachable from the landed
lemmas.

**Consequence:** `nmin_window_high` as specified needs either
1. a **stronger Stage-1/lower bound** at `n` — e.g. `w ≥ −2/n`, which propagates
   (`−2/n − 1/n' ≥ −4/n'` ⟸ `2n ≥ 3n'` ✓ for `n ≥ 2`), or
2. **`stage2_lower` re-run at `n'` with the *upper* threshold fact** — note the lower half's chain uses
   `nmin_Phi_lt`, but the *same* expansion with `1 ≤ Phi p n'` gives
   `Y' ≥ 1 − E − X' − D'/n'²` ⇒ `−2w' + 500w'² ≥ …` which is the **upper** bound for `w'` (already
   landed); the lower bound genuinely requires `Phi p n' ≤ 1 + something`, which no landed lemma gives.

**Recommended next step:** strengthen `nmin_w_sharp`'s lower half to `−2/nmin p ≤ w` by re-running
`stage2_lower`'s arithmetic with the constant `2` (its chain proves `w ≥ 11/(16n) − C/n²`, so `−2/n`
is comfortably within reach), then the propagation `−2/n − 1/n' ≥ −4/n'` holds.  This is a
**constant-tightening**, not new analysis.

### 13.323 Round-300: two concrete routes for the `n'`-point lower bound identified

Build green: **200 declarations, 7/7 OK, 0 sorries**.

**Route A (simplest — from the landed `nmin_window_low`).**  That lemma gives
`w > 3log2/(2n) − 10¹⁹/n²`, so
`w ≥ −2/n` follows from `3log2/2 − 10¹⁹/n ≥ −2`, i.e. `10¹⁹ ≤ (3log2/2 + 2)·n`, which `hnK`
supplies comfortably.  Then `w' ≥ w − 1/n' ≥ −2/n − 1/n' ≥ −4/n'` ✓ (the last step needs
`2n ≥ 3n'`... **check: `−2/n − 1/n' ≥ −4/n'` ⟺ `2/n ≤ 3/n'` ⟺ `2n' ≤ 3n` ✓ for `n ≥ 2`**).

**Route B (from the Stage-2 arithmetic).**  `stage2_lower_arith`'s internal chain already proves
`w > 11/(80n) − C/n²`, so a constant-`2` variant (`stage2_lower_arith2`, conclusion `−2/n ≤ w`) is a
mechanical adaptation; likewise `stage2_lower` → `stage2_lower2`.

**Route A is preferred** — no new Stage-2 lemma, and `nmin_window_low` is already landed and green.

**Next round:** prove `nmin_w_lower2 : −(2/nmin p) ≤ p/nmin p − log2` by Route A (scratch first), then
`nmin_window_high` proceeds as written with the strengthened lower bound.

### 13.324 Round-301: `nmin_w_lower2` written, file broke, **reverted to green**, scratch set up

Build green: **200 declarations, 7/7 OK, 0 sorries** (verified after the revert).

I wrote `nmin_w_lower2` (Route A) directly into the file, which produced four errors — a syntax slip
(`by positivity : T` inside a term is not valid in that position) plus three arithmetic failures.
**Removed the lemma, re-verified green, and moved the body to `/tmp/w1340.lean`** (with
`nmin_window_low` qualified as `Op56.Op56.nmin_window_low` and the syntax slip fixed).

The scratch now has **5 errors** to work through, all in the new lemma — and the deliverable is
untouched.

**Lesson re-confirmed:** even a *new* lemma written straight into the file risks the build; the
revert cost is a round.  Writing it in the scratch first is the rule, and the only reason it was not
followed here is that the qualified names are awkward from the scratch — which is not a reason.

**Next round:** fix the five scratch errors (19, 26, 37, 39, 41), then paste.

### 13.325 Round-302: `nmin_w_lower2` simplified; scratch at three errors; **a real constant insight**

Build green: **200 declarations, 7/7 OK, 0 sorries**.

Two simplifications and one real finding:

1. **`hn1e19 : 10¹⁹ ≤ nmin p` follows directly from `hnK`** — since `(2PhiC+1)²+1 ≥ 1`,
   `10⁴⁰ ≤ 10⁴⁰·((2PhiC+1)²+1) ≤ n`, so `n ≥ 10⁴⁰ ≫ 10¹⁹`.  **No bound on `PhiC` is needed** — my
   first attempt tried to derive it from `(2PhiC+1)² ≥ 10⁴`, which would have required `PhiC ≥ 49.5`
   and is *not* available (the library only gives `PhiC > 0`).  This is the **seventh** time a
   constant/route check caught a requirement the library cannot supply.
2. `hmain` rewritten with an explicit numerator identity
   `log2 + 3log2/(2n) − 10¹⁹/n² = (log2·n² + 3log2/2·n − 10¹⁹)/n²`, then `le_div_iff₀` — removing the
   `sub_le_iff_le_add` rewrites that would not match.

**Three errors remain in the scratch (21, 25, 26):** `field_simp` closed its goal early (the
`ring` after it reports *No goals*), and two `linarith`s.

### 13.326 Round-303: scratch down to one error; the final `linarith` needs the goal shape re-checked

Build green: **200 declarations, 7/7 OK, 0 sorries**.

Cleared in the scratch: the premature `field_simp` (its trailing `ring` reported *No goals*), the
`hmain` numerator identity, and two binding identities (`-(2/n) = -2/n`).

**One error remains (30):** the final `linarith only [hlow, hmain2, e2]`.  The printed negated goal is
`A < log2 + -(2/n)` — i.e. the goal at that point is `log2 - 2/n ≤ A`, **not** the lemma's conclusion
`-(2/n) ≤ p/n − log2`.  So `hmain2` (which I inserted for the shift) is being used where the *main*
goal should be — **the `hmain2` step and the final step have been conflated**.

**Next: restore the intended two-step structure** — `hmain2 : log2 − 2/n ≤ log2 + A` (from `hmain`),
then `linarith only [hlow, hmain2]` against the lemma's actual conclusion
`-(2/n) ≤ p/n − log2`.  This is a *goal-shape* check, the class that has produced eight of the last
ten fixes.

### 13.327 **LANDED (round 304): `nmin_w_lower2x_p`** — 201 declarations — the strengthened lower bound

`Op56/PhiThird.lean` now has **201 declarations** (0 sorries, 7/7 OK, 0 axioms), newly:

```lean
lemma nmin_w_lower2x_p (p : ℕ) (hp : 6 ≤ p) (hn : 2000000000 ≤ nmin p)
    (hlarge : 3*PhiC ≤ ((2*p : ℕ):ℝ))
    (hnK : 10^40 * ((2*PhiC+1)^2 + 1) ≤ (nmin p:ℝ)) :
    -(2/(nmin p:ℝ)) ≤ (p:ℝ)/(nmin p :ℝ) - Real.log 2
```

— **`w ≥ −2/n`**, derived from the landed `nmin_window_low` (Route A).  **Developed entirely in the
scratch** and pasted once green.

**The decisive fix was a statement error, not a tactic error:** `hmain` had been stated as
`−(2/n) ≤ log2 + A'` when the final step needs `−(2/n) ≤ A'` — the leading `log2` was spurious, and
every apparent arithmetic failure followed from it.  The printed goal showed
`A < log2 + −(2/n)` (a shifted comparison), which is the signature of a **statement** mismatch rather
than a tactic one.  This is the **ninth** goal-shape/binding instance, and the fifth where the fix was
to correct a statement.

### Next: `nmin_window_high` is now unblocked

With `w ≥ −2/n` (this lemma) and `w' ≥ w − 1/n'`:
`w' ≥ −2/n − 1/n' ≥ −4/n'` — the last step needs `2n' ≤ 3n` ✓ for `n ≥ 2`.
Together with the landed `nmin_upper_sharp_p` this gives `|p/n' − log2| ≤ 4/n'`, i.e. `hwabs` for
`Phi_window_high` at `n'`.  Then contrapositive with `nmin_Phi_ge` gives **`nmin_window_high`**, and
`stage2_lower` + `stage2_upper` + the two windows complete the sharp bound.

### 13.328 Round-305: `nmin_window_high` written in the scratch — two errors

Build green: **201 declarations, 7/7 OK, 0 sorries**.

The lemma is fully written (in `/tmp/w1360.lean`): the contrapositive of `Phi_window_high` against
`nmin_Phi_ge`, with `hu1`/`hu2` at `n'`, `hwabs` assembled from the landed
`nmin_w_lower2x_p` (lower) and `nmin_upper_sharp_p` (upper), and the `div_mul_cancel₀` normalisation
of `Phi`'s argument.  **Two errors remain:**

* **40** — `rw [ge_iff_le, div_add_div …]` in the auxiliary `hB` (the step `−4/n' ≤ −2/n − 1/n'`,
  equivalent to `2n' ≤ 3n`) — the rewrite does not match; **the recorded fix is to state `hB` with an
  explicit numerator identity** (`numerator/(n·n')` via `field_simp; ring`), then `le_div_iff₀` and
  `nlinarith`, exactly as in `nmin_w_lower2x_p`;
* **46** — a `linarith` in the same chain.

### 13.329 Round-306: `nmin_window_high` scratch down to ONE error

Build green: **201 declarations, 7/7 OK, 0 sorries**.

Cleared in `hB` (`−4/n' ≤ −2/n − 1/n'` ⟺ `2n' ≤ 3n`): the explicit numerator identity, the redundant
`ring` after `field_simp`, the product identity `−4/n'·(n·n') = −4n`, and the two numeric facts
`2 ≤ n` and `n' ≤ n + 1` (needed because `2n' ≤ 3n` requires `n ≥ 2` and `n' = n + 1`).

**One error remains (53):** the final `linarith only [hA, hB, hC, e4]` in the `hwabs` lower half.  The
three hypotheses are `hA : w ≥ −2/n`, `hB : −4/n' ≤ −2/n − 1/n'`,
`hC : p/n' − log2 ≥ p/n − log2 − 1/n'` and the goal is `−4/n' ≤ p/n' − log2` — **a pure transitivity**,
which `linarith` is failing on for the usual context reason.  **Recorded fix: replace with an explicit
chain** `lt_of_le_of_lt`/`le_trans` or the `e4`-style normalisation, and if it resists twice, **print
the hypotheses** (the §13.297 rule).

### 13.330 **LANDED (round 307): `nmin_window_high`** — 202 declarations — **BOTH WINDOW BOUNDS COMPLETE**

`Op56/PhiThird.lean` now has **202 declarations** (0 sorries, 7/7 OK, 0 axioms), newly:

```lean
lemma nmin_window_high (p : ℕ) (hp : 6 ≤ p) (hn : 2000000000 ≤ nmin p)
    (hlarge : 3*PhiC ≤ ((2*p : ℕ):ℝ))
    (hnK : 10^40 * ((2*PhiC+1)^2 + 1) ≤ (nmin p:ℝ)) :
    (p:ℝ)/(((nmin p + 1 : ℕ)):ℝ)
      < Real.log 2 + 3*Real.log 2/(2*(((nmin p + 1 : ℕ)):ℝ)) + 10^19/((((nmin p + 1 : ℕ)):ℝ)^2)
```

**Together with the landed `nmin_window_low`:**

```
log2 + 3log2/(2n) − 10¹⁹/n²  <  p/n           (lower, at n = nmin p)
p/n' < log2 + 3log2/(2n') + 10¹⁹/n'²          (upper, at n' = nmin p + 1)
```

**The decisive fix was again a *statement* error found by printing:** the failing step was `hC`
(`p/n' − log2 ≥ p/n − log2 − 1/n'`), which had been justified from `hle : p/n' ≤ p/n` alone — but that
only gives `p/n' − log2 ≥ p/n − log2`, **without the `−1/n'`**.  The quantitative bound
`p/n − p/n' ≤ 1/n'` (via `p ≤ n`) is required, exactly as in `nmin_w_stage1'`.  **Tenth** goal-shape
instance, sixth statement-level fix.

### Remaining for `op5_nmin_asymptotic`

1. combine the two windows into `nmin p = p/log2 − 5/2 + O(1/p)`;
2. close the `sorry` in `Asymptotic.lean`;
3. then `op6_reachable_fraction`.

### 13.331 Round-308: the target statement read; the combination needs the *precise* expansion

Build green: **202 declarations, 7/7 OK, 0 sorries**.

`Op56/Asymptotic.lean:224` states

```lean
theorem op5_nmin_asymptotic :
    (fun p : ℕ => (nmin p : ℝ) - nminAsym p) =O[atTop] (fun p : ℕ => 1 / (p : ℝ))
```

with `nminAsym p = p/log 2 − 5/2`.  So the required statement is
`nmin p − (p/log2 − 5/2) = O(1/p)` — i.e. the **constant parts must cancel exactly**, and the two
window bounds (which give the leading `±3log2/(2n)` term) are not by themselves enough.

**Sketch of what is needed.**  With `w = p/n − log2` and `n = nmin p`:
`n = p/(log2 + w) = p/log2 − p·w/log2² + O(p·w²)`, and `p·w² = O(1/p)`;
so the `O(1/p)` target requires
`p·w/log2² = p/log2 − 5/2 + O(1/p)`, i.e. `w = log2²/n − 5log2²/(2p) + O(1/p²)`.
Since `p/n → log2`, the leading term is `log2²/n ≈ log2³/p`, and the windows give the coefficient
`3log2/2` for `1/n` — so the identity `log2²·(p/n) = …` must be tracked **through `p/n` rather than
`n`** to get the exact cancellation.

**This is a genuine algebraic task, not notation:** it is the OP-5 asymptotic-equivalence argument in
§7, and the constants have been verified numerically (the `-5/2` is chosen for exactly this
cancellation).

### 13.332 Round-309: **the combination must be done on `n' = nmin p + 1`, not on `nmin p`**

Build green: **202 declarations, 7/7 OK, 0 sorries**.

§7's plan (line 6553, from round 185) records the combination as
`n* = p/log2 − 3/2 + O(1/p)`, and then asserts this equals `nmin p = nminAsym p + O(1/p)` with
`nminAsym p = p/log2 − 5/2`.

**That last step is off by one as written.**  If `nmin p = p/log2 − 3/2 + O(1/p)` then
`nmin p − nminAsym p = 1 + O(1/p)`, which is **not** `O(1/p)`.  The correct reading is that the
`−3/2` estimate is for **`n' = nmin p + 1`** (the point at which the *high* window is applied):
`nmin p + 1 = p/log2 − 3/2 + O(1/p)`, hence `nmin p = p/log2 − 5/2 + O(1/p)` ✓.

**Consequence for the proof:** the `O(1/p)` estimate must be derived by expanding **at `n'`** —
i.e. from
`p/n' < log2 + 3log2/(2n') + 10¹⁹/n'²` — and then subtracting `1`, *not* by combining the two
one-sided bounds at `n`.  This is a **constant/evaluation-point check of exactly the kind that has
caught seven errors in Stage 2**, and it was caught here by arithmetic on paper rather than in the
kernel.

**Next round:** derive `|n' − (p/log2 − 3/2)| ≤ K/p` from the upper window at `n'` plus the lower
window at `n` (which gives `p/n > log2 + …`, hence `n < p/log2 + …`), then conclude
`|nmin p − nminAsym p| ≤ K/p` and close the `=O` statement in `Asymptotic.lean`.

### 13.333 **CORRECTION to §13.332** — §7's plan is right; my "off-by-one" claim was an arithmetic slip

Build green: **202 declarations, 7/7 OK, 0 sorries**.

Re-doing the expansion carefully:

`log2 + 3log2/(2n') = log2·(1 + 3/(2n'))`, so
`n' = p/u' = p/(log2·(1 + 3/(2n')))·(1 + o(1)) = (p/log2)·(1 − 3/(2n')) = p/log2 − 3p/(2n'·log2)`,
and since `p/n' → log2`, the correction is `−3log2/(2log2) = −3/2` ✓.

**So §7's `n* = p/log2 − 3/2 + O(1/p)` is correct as written**, and `nmin p = n* − 1 = p/log2 − 5/2 + O(1/p)` ✓.

**My §13.332 finding was wrong**: I evaluated the correction as `−3/(2log2) ≈ −2.164` instead of
`−3log2/(2log2) = −3/2`, which produced a spurious `1 + O(1/p)` obstruction.  The lesson is *not* that
the plan is defective; it is that **my on-paper arithmetic is as fallible as the kernel's, and needs
the same verification** — here, re-deriving the substitution rather than trusting the first pass.

**Corrected plan for the combination:** expand at `n'` to get `n' = p/log2 − 3/2 + O(1/p)`, then
subtract the `1` to obtain `nmin p = p/log2 − 5/2 + O(1/p)`, i.e.
`|nmin p − nminAsym p| ≤ K/p`, and close the `=O` statement.

### 13.334 Round-311: the two windows alone give only `O(1)`, not `O(1/p)` — the sharp step needs more

Build green: **202 declarations, 7/7 OK, 0 sorries**.

Working the combination through with the landed windows:

* **lower bound on `n'`** — from `p/n' < log2 + 3log2/(2n') + 10¹⁹/n'²`, multiplying by `n'`:
  `p < log2·n' + 3log2/2 + 10¹⁹/n'`, hence
  `n' > p/log2 − 3/2 − O(1/p)` ✓;
* **upper bound** — from the *low* window contrapositive at `n = n'−1`:
  `p/n > log2 + 3log2/(2n) − 10¹⁹/n²`, so
  `n < p/(log2 + 3log2/(2n) − 10¹⁹/n²) = p/log2 − 3/2 + O(1/n)`,
  and `n' = n + 1` gives **`n' ≤ p/log2 − 3/2 + 1 + O(1/n)`**.

**So the two windows alone bound `n' − (p/log2 − 3/2)` only to `O(1)`, not `O(1/p)`** — the gap is the
`+1` from `n' = n + 1`.  (Numerically `nmin p ≈ p/log2 − 5/2` to high precision, so the sharp statement
is true; the bounds are simply too coarse.)

**The sharp argument must come from the direction the windows do not use**: `n'` is the *least* index
with `Φ ≥ 1` (`nmin_spec` + `nmin_minimal`), so the high window at `n'` is *sharp* at the threshold —
using `Φ_p(n') ≥ 1` together with the second-order expansion (`Phi_third_order`, `exp_threshold_linear`)
at `n'` gives `w' ≤ 3log2/(2n') + c/n'²` **without** the `n' = n+1` slack.  That is the `stage2_upper`
chain, which is already landed and gives the *sharp* `w' ≤ 4/n'`.

**Consequence: the `O(1/p)` step should be derived from the SHARP `w'` bound (`stage2_upper` /
`nmin_upper_sharp_p` at `n'`, `|w'| ≤ 4/n'`) plus the exact algebra
`n' = p/(log2 + w') = p/log2 − p·w'/log2² + O(p·w'²)`, where `p·w' = O(1)` and `p·w'² = O(1/p)`.**

### 13.335 Round-312: the exact algebra — and why the constant needs the second-order terms

Build green: **202 declarations, 7/7 OK, 0 sorries**.

**The exact identity.**  With `w' = p/n' − log2`:

```
n' − p/log2 = p/(log2 + w') − p/log2 = −p·w' / (log2·(log2 + w'))
```

and `log2 + w' ≥ log2 − 4/n' > log2/2` for large `n'`, so `|n' − p/log2| = O(p·|w'|)`.  Since
`|w'| = O(1/n')` and `p/n' → log2`, this is `O(1)` — so the `−3/2` comes from the **value** of `p·w'`,
not from any bound:

```
n' − p/log2 = −3/2 + O(1/p)   ⟺   p·w'/(log2·(log2 + w')) = 3/2 + O(1/p)
                                      ⟺   p·w' = 3log2²/2 + O(1/p)   ⟺   w' = 3log2/(2n') + O(1/n'²).
```

**So the sharp statement needs `w' = 3log2/(2n') + O(1/n'²)` — i.e. the *leading asymptotic*, not a
bound.**  The landed bounds give only `|w'| ≤ 4/n'` (upper, from `stage2_upper`) and
`w' > 3log2/(2n') − O(1/n')` (lower, from `nmin_window_low` at `n`) — a range of width `O(1/n')`, which
does **not** pin the constant.

**Consequence:** the `op5_nmin_asymptotic` proof needs one more sharp input — the **second-order
expansion at `n'`** (the `O(1/n'²)` term of `w'`), which is what §7's step 4 actually uses.  The
natural source is the landed `Phi_third_order` + `exp_threshold_linear` chain evaluated at `n'` and
solved for `w'` to `O(1/n'²)` — i.e. an *inversion* of `stage2_upper`'s inequality, not just its
combination with `stage2_lower`.

**This is the genuine remaining difficulty of OP-5**, and it is analytic rather than notational.
It should be planned on paper (as here) before any Lean is written.

### 13.336 Round-313: **the paper derivation of `w' = 3log2/(2n') + O(1/n'²)` — §7's plan confirmed**

Build green: **202 declarations, 7/7 OK, 0 sorries**.

Contrary to §13.335's pessimism, **both** one-sided bounds on `w'` *are* available, and the `O(1/n'²)`
sharpness comes out.  Writing `n = nmin p`, `n' = n + 1`, `w = p/n − log2`, `w' = p/n' − log2`:

**Upper bound on `w'` (sharp).**  `nmin_Phi_ge : 1 ≤ Phi p n'`, `Phi_third_order` at `n'`, and
`exp_threshold_linear` give (exactly as in the landed `stage2_upper`)
`−2w' + 500w'² ≥ −E − X' − D'/n'²`, and the sharp `ΦS` bound gives `X' = 3log2/(2n') + O(1/n'²)`;
with `500w'² = O(1/n'²)`:
**`w' ≤ 3log2/(2n') + O(1/n'²)`** ✓.

**Lower bound on `w'` (sharp).**  `nmin_minimal` gives `¬ IsComplete p n`, i.e. `Phi p n < 1`, and the
low window (or the same chain at `n`) gives `w > 3log2/(2n) − O(1/n²)`.  Now
`u − u' = p/(n·n')`, and
`3log2/(2n) = 3log2/(2n') + 3log2/(2n·n')`, so
`w' = w − (u − u') > 3log2/(2n') + (3log2/2 − p/n)/(n·n') − O(1/n²)`,
and `p/n = log2 + w` with `w = O(1/n)` gives `3log2/2 − p/n = log2/2 − w > 0` for large `n`.  Hence
**`w' ≥ 3log2/(2n') − O(1/n'²)`** ✓.

**Therefore `w' = 3log2/(2n') + O(1/n'²)`**, and the exact identity of §13.335
(`n' − p/log2 = −p·w'/(log2·(log2 + w'))`) yields
**`n' = p/log2 − 3/2 + O(1/p)`**, hence `nmin p = p/log2 − 5/2 + O(1/p)` ✓ — §7's plan, confirmed.

**Key realisation:** the two components are *already landed* — the upper is `stage2_upper`'s chain
(`nmin_upper_sharp_p` at `n'`), and the lower is `nmin_window_low` at `n` plus the `1/(n·n')`
bookkeeping.  What is missing is only the **assembly with the `O(1/n'²)` terms tracked**.

### 13.337 Round-314: the Lean plan for the `O(1/p)` assembly (three lemmas)

Build green: **202 declarations, 7/7 OK, 0 sorries**.

§13.336's paper derivation decomposes into **three landable lemmas**, each with all inputs already in
the kernel:

**(a) `uPhiS_sharp'`** — the sharp `ΦS` estimate at `n'`:
```lean
u' * PhiS u' ≤ 3*Real.log 2 + K/(n':ℝ)   --  and the matching lower bound
```
from `PhiS_second_order_at_log2` with `w' = O(1/n')` (supplied by `nmin_w_stage1'`).  This is the
refinement of `uPhiS_ge`/`uPhiS_le`, whose constants (`11/4`, `5`) are too crude for the `O(1/n'²)`
term.  The true value is `u'ΦS(u') = 3log2 + O(1/n')` (note `ΦS(log2) = 6`, so `log2·6/2 = 3log2`).

**(b) `nmin_w_sharp2'`** — `|w' − 3log2/(2n')| ≤ K/n'²`, by combining
* the **upper** side from `Phi_third_order` at `n'` + `nmin_Phi_ge` + `exp_threshold_linear`
  (the `stage2_upper` chain with `X'` sharpened via (a)), and
* the **lower** side from `nmin_window_low` at `n` plus the exact bookkeeping
  `u − u' = p/(n·n')` and `3log2/(2n) = 3log2/(2n') + 3log2/(2n·n')`.

**(c) `nminAsym_bound`** — `|nmin p − nminAsym p| ≤ K/p`, by the exact identity
`n' − p/log2 = −p·w'/(log2·(log2 + w'))` with (b) and `p/n' → log2`; then
`nmin p = n' − 1`, and `nminAsym p = p/log2 − 5/2` absorbs the `−1`.

**Then** `op5_nmin_asymptotic` follows by `Asymptotics.IsBigO` from (c) with the standard eventual
bound (`p ≥ p₀` and the finitely many smaller `p` handled by the `=O` filter).

**Development rule (unchanged):** scratch first, one edit at a time, `check.sh` before and after the
single paste.

### 13.338 Round-315: `uPhiS_sharp` drafted in the scratch — errors in the `abs_le` constructions

Build green: **202 declarations, 7/7 OK, 0 sorries**.

Lemma (a) is drafted in `/tmp/w1370.lean`:

```lean
lemma uPhiS_sharp (u q w : ℝ) (hq0 : 0 ≤ q) (hq : q ≤ 1/10^9)
    (hw : |w| ≤ q) (hu : u = Real.log 2 + w)
    (hPS : |PhiS u - 6 + 26*w| ≤ 10^16 * w^2) :
    |u * PhiS u - 6*Real.log 2| ≤ 100 * q
```

**Method:** split `u·ΦS(u) = (log2 + w)(6 − 26w) + (log2 + w)(ΦS u − 6 + 26w)`, bound the second term by
`2·10¹⁶w²` (using `|log2 + w| ≤ 2`), and the first by `40q` (the `w·(6 − 26log2)` and `−26w²` pieces),
then add — giving `≤ 100q` since `2·10¹⁶q² ≤ 60q` for `q ≤ 10⁻⁹`.

**Current errors** are all in the `abs_le` side-condition constructions
(`constructor <;> linarith` at lines 25, 35, 37) — i.e. the `|log2 + w| ≤ 2` and `|6 − 26log2| ≤ 40`
bounds, whose two halves need the printed goals (the §13.297 rule).

### 13.339 Round-316: `uPhiS_sharp` — the `abs_le` halves still resisting

Build green: **202 declarations, 7/7 OK, 0 sorries**.

The printed output shows `case left` of the `abs_le` construction, with the context intact but the goal
not resolved by `linarith` — the same absolute-value bookkeeping class.  Rather than iterate on it,
**the recorded simplification is to avoid `abs_le` side conditions entirely**:

1. rearrange `hPS` directly to `|PhiS u - (6 - 26*w)| ≤ 10¹⁶w²` and introduce `e := PhiS u - (6 - 26*w)`
   with `|e| ≤ 10¹⁶w²`;
2. write `u·ΦS u − 6log2 = w·(6 − 26log2) − 26w² + (log2 + w)·e` (`ring`);
3. bound each piece with `abs_add_le`/`abs_sub_le` and `nlinarith` using
   `|w| ≤ q`, `q ≤ 10⁻⁹`, `|log2| ≤ 1` — **no `abs_le` introductions at all**.

The constants are generous (`12q + 26q² + 2·10¹⁶q² ≤ 100q`), so no tightness is needed.

### 13.340 Round-317: `uPhiS_sharp` rewritten without `abs_le` introductions — five `linarith` steps remain

Build green: **202 declarations, 7/7 OK, 0 sorries**.

The rewritten lemma (`/tmp/w1380.lean`) uses the recorded decomposition directly:
`u·ΦS(u) − 6log2 = (w·(6 − 26log2) − 26w²) + (log2 + w)·(ΦS u − (6 − 26w))`, with each piece bounded by
`abs_add_le`/`abs_sub_le` and `nlinarith`, and **no `abs_le` introductions except the two tiny
constant bounds** (`|6 − 26log2| ≤ 40`, `|log2 + w| ≤ 2`) whose halves are supplied as explicit
`⟨…, …⟩` pairs.

**Five `linarith` errors remain (29, 34, 44×2, 47)** — all in numeric bound steps
(`26q² ≤ 10q`, `2·10¹⁶q² ≤ 50q`, the `abs_le` halves).  These are the standard class; the constants
are generous, so each should close with the right hypotheses supplied.

### 13.341 Round-318: one `abs_le` removed; four remain plus the numeric steps

Build green: **202 declarations, 7/7 OK, 0 sorries**.

The `|6 − 26log2| ≤ 40` bound is now derived **without `abs_le`**:
`|Real.log 2| ≤ 1` (from `log_two_le_one` + `abs_of_pos`), then
`|6 − 26log2| ≤ |6| + |26log2| = 6 + 26|log2| ≤ 32 ≤ 40` via `abs_sub` and `abs_mul`.

**Five errors remain (32, 37, 47×2, 50):** the `26q² ≤ 10q` step, a `linarith` in `h1`, the two
`abs_le` halves of `|log2 + w| ≤ 2`, and the `2·10¹⁶q² ≤ 50q` step — all numeric, all with generous
constants, to be worked one at a time per the established rule.

### 13.342 Round-319: two more `abs_le`/numeric fixes; `uPhiS_sharp` at two errors

Build green: **202 declarations, 7/7 OK, 0 sorries**.

* `|log2 + w| ≤ 2` is now `abs_add_le` + `|log2| ≤ 1` + `|w| ≤ q ≤ 1` — **no `abs_le`**;
* the second `q²` bound now uses `hq` directly.

**Two errors remain (32, 53):** `26q² ≤ 10q` (needs `26q ≤ 10` supplied — the naive `nlinarith` with
`hq0, hq, 26·10⁻⁹ ≤ 10` still does not close, so the product form `q·26 ≤ 26·10⁻⁹` must be supplied
explicitly), and `2·10¹⁶q² ≤ 50q` (same shape).

**Both are the same step**, so a single helper lemma
`q^2 * C ≤ c * q` for `q ≤ ε` would close them together — worth writing rather than repeating the
rearrangement twice.

### 13.343 Round-320: the constant `100q` was too tight — relaxed to `10¹⁸q`

Build green: **202 declarations, 7/7 OK, 0 sorries**.

**A real constant error found by checking the bound:** `2·10¹⁶q² ≤ 50q` requires `q ≤ 2.5·10⁻¹⁵`, but
only `q ≤ 10⁻⁹` is available — so the original conclusion `≤ 100q` was **unprovable**.  Since the
caller only needs `|uΦS(u) − 6log2| = K·q` for *some* constant, the conclusion is relaxed to
**`≤ 10¹⁸·q`**, which makes both `q²` steps immediate (`26q² ≤ 10¹⁷q` and `2·10¹⁶q² ≤ 10¹⁷q` for
`q ≤ 10⁻⁹`).

**Four errors remain (32, 42, 52, 56)** — the `q²` steps plus two `linarith` combinations, all now with
room to spare.

**This is the eighth constant/route defect caught before it propagated**, and the second in this lemma
alone — the first being the `abs_le` construction, this one the tightness of `100q`.

### 13.344 Round-321: `q²` steps still resisting — the exact hypothesis forms need printing

Build green: **202 declarations, 7/7 OK, 0 sorries**.

Supplying the explicit product forms (`26q ≤ 26·10⁻⁹`, `2·10¹⁶q ≤ 2·10¹⁶·10⁻⁹`, and the numeric
caps) did **not** close the two `q²` steps, nor the two `linarith` combinations.

**Four errors remain (32, 45, 58, 62).**

**Per the §13.297 rule — which this lemma has now resisted three times — the next action is to PRINT
each goal rather than propose another hypothesis form.**  The pattern that has worked everywhere else
in this file is: print the negated goal, read which term is shaped differently from the hypothesis,
and supply *that* identity explicitly.

**If a fourth attempt fails, the recorded fallback is to abandon the sharp constant entirely** and
state `uPhiS_sharp` in the *strictly weaker* form that the caller actually needs — e.g.
`|u*PhiS u - 3*(2*Real.log 2)| ≤ 10^18 * q` hmm, or more simply: **prove the needed `X'` estimate
directly as `|X' - 3*Real.log 2/n'| ≤ K/n'^2` by combining the landed `uPhiS_le`/`uPhiS_ge`
constants (`5`, `11/4`) with the sharp `PhiS_second_order`**, avoiding this bookkeeping entirely.

### 13.345 **LANDED (round 322): `uPhiS_sharp`** — 203 declarations — lemma (a) of the three

`Op56/PhiThird.lean` now has **203 declarations** (0 sorries, 7/7 OK, 0 axioms), newly:

```lean
lemma uPhiS_sharp (u q w : ℝ) (hq0 : 0 ≤ q) (hq : q ≤ 1/10^9)
    (hw : |w| ≤ q) (hu : u = Real.log 2 + w)
    (hPS : |PhiS u - 6 + 26*w| ≤ 10^16 * w^2) :
    |u * PhiS u - 6*Real.log 2| ≤ 10^18 * q
```

— the **sharp** `ΦS` estimate (`uΦS(u) = 6log2 + O(q)`), the refinement that makes the `O(1/n'²)`
term possible.  Developed in the scratch across rounds 315–322 and pasted once green.

**The decisive fix — found by printing, exactly as the §13.297 rule prescribes:** the failing
`linarith` was blocked because `|(6:ℝ)|` was **un-normalised** in the `abs_sub` bound, so
`linarith` could not see `|6| = 6`.  Adding `have h11 : |(6:ℝ)| = 6 := by norm_num; rw [h11] at h10`
closed it — and then the two `q²` steps fell immediately (they had been failing only because the
constants downstream of `h2` were wrong).

Three constants were also corrected during development: `100q → 10¹⁸q` (the original was
**unprovable**, needing `q ≤ 2.5·10⁻¹⁵`), `hb1`'s `50q → 3·10¹⁷q` (needed to absorb the `40q` term),
and the final sum `3·10¹⁷q + 10¹⁷q ≤ 10¹⁸q`.

**Honest note:** this one-line lemma took seven rounds (315–322), and four of them were spent
re-arranging hypotheses for `q² ≤ Cq` **without ever printing the goal** — the rule I had recorded,
confirmed eight times, and repeatedly applied elsewhere.  When I finally printed, the cause
(`|6|` un-normalised) was visible immediately and the remaining errors collapsed in the same round.

### Remaining (b) and (c)

`nmin_w_sharp2'` (the `|w' − 3log2/(2n')| ≤ K/n'²`) and `nminAsym_bound` (`|nmin p − nminAsym p| ≤
K/p`), both as planned in §13.337.  **Apply the print-first rule from the first failure.**

### 13.346 Round-323: lemma (b) scaffolding compiles in the scratch

Build green: **203 declarations, 7/7 OK, 0 sorries**.

`/tmp/w1390.lean` now has `nmin_w_sharp2`'s statement and scaffolding:

```lean
lemma nmin_w_sharp2 (p : ℕ) (hp : 6 ≤ p) (hn : 2000000000 ≤ nmin p)
    (hlarge : 3*PhiC ≤ ((2*p : ℕ):ℝ))
    (hnK : 10^40 * ((2*PhiC+1)^2 + 1) ≤ (nmin p:ℝ)) :
    |(p:ℝ)/(((nmin p + 1 : ℕ)):ℝ) - Real.log 2 - 3*Real.log 2/(2*(((nmin p + 1 : ℕ)):ℝ))|
      ≤ 10^25/((((nmin p + 1 : ℕ)):ℝ)^2)
```

with `hnR`, `hNpos`, `hp2`, `h1N`, the `nmin_window_low` reference (**qualified
`Op56.Op56.nmin_window_low`**, per the doubled-namespace rule), and `hu1`/`hu2` at `n'` all clean.

**Remaining in (b):** the two halves —
* **upper**: `nmin_Phi_ge` + `Phi_third_order` at `n'` + `exp_threshold_linear` + the new
  `uPhiS_sharp` (to sharpen `X'` to `3log2/n' + O(1/n'²)`), giving `w' ≤ 3log2/(2n') + K/n'²`;
* **lower**: `nmin_window_low` at `n` plus the bookkeeping
  `u − u' = p/(n·n')` and `3log2/(2n) = 3log2/(2n') + 3log2/(2n·n')`.

The constant `10^25` is deliberately generous, so no tightness is needed.

### 13.347 Round-324: lemma (b)'s lower half written — four errors

Build green: **203 declarations, 7/7 OK, 0 sorries**.

The lower half of `nmin_w_sharp2` is now written in the scratch:

* `hn2`, `hnl`, `hnd : n' ≤ 2n`, `hp'`;
* `hw' : p/n' − log2 = (p/n − log2) − p/(n·n')` (`field_simp; ring`);
* `h3l : 3log2/(2n) = 3log2/(2n') + 3log2/(2n·n')`;
* `hpos : 0 ≤ 3log2/2 − p/n` (from `p/n ≤ 1` and `log2 > 0`);
* `hlowb` — the bound `−10²⁵/n'² ≤ w' − 3log2/(2n')`, assembled from `nmin_window_low` plus
  `10¹⁹/n² ≤ 10²⁵/n'²` (valid since `n' ≤ 2n`).

**Four errors remain (42, 48, 55, 60):** two `field_simp`-style `unsolved goals` (42, 48 — the `hw'`
and `h3l` identities), a `linarith` (55), and a `rw` pattern miss (60).

**Next: print each (the §13.297 rule, applied from the first failure).**

### 13.348 Round-325: printed goal shows the `rw` shape; `field_simp` still leaving goals

Build green: **203 declarations, 7/7 OK, 0 sorries**.

**The printed output is informative for error 60:** `rw [h3l]` cannot match because the target has
`3·log2/(2·↑(nmin p))` sitting **inside a subtraction chain** —
`p/n − log2 − p/(n·n') − 3log2/(2n')` — while `h3l` rewrites the term in isolation.  So `h3l` should be
applied as a `linarith` hypothesis rather than a rewrite, or the goal restated before rewriting.

**Errors 42/48 (`field_simp` unsolved) were unchanged** by supplying `ne_of_gt hnR`/`ne_of_gt hNpos`
explicitly, so the leftover goal is not a nonzero condition — **the next action is to print those two
leftover goals directly** (they are `unsolved goals`, so the goal text is already available at the
error site and needs only `tail` rather than inference).

### 13.349 Round-326: the `field_simp` leftovers were a **cast** issue — `push_cast` fixed both

Build green: **203 declarations, 7/7 OK, 0 sorries**.

Reading the leftover goal (as committed) showed the residual expression contained `↑(1 + nmin p)`
rather than `↑(nmin p) + 1` — **the cast form, again** — and adding `push_cast` between `field_simp`
and `ring` closed both `hw'` and `h3l` at once.  (Lean's `ring_nf` suggestion was a red herring: the
identity was true and provable, but only after normalising the cast.)  Count 4 → 2.

**Two errors remain (57, 62):** a `linarith` in the `hkey`/`h1` area, and the `rw [h3l]` pattern miss
already diagnosed in §13.348 (the target has `3log2/(2n)` inside a subtraction chain, so `h3l` must be
used as a `linarith` hypothesis rather than a rewrite).

### 13.350 Round-327: `hpos` needed `log2 ≥ 2/3`; `hlowb` restructured — one error left

Build green: **203 declarations, 7/7 OK, 0 sorries**.

* **`hpos : 0 ≤ 3log2/2 − p/n`** did **not** follow from `log2 > 0` (it needs `3log2/2 ≥ 1`, i.e.
  `log2 ≥ 2/3`) — supplied via `Real.log_two_gt_d9` + `norm_num`, the **ninth** constant/bound check
  to catch a missing hypothesis rather than a tactic error;
* **`hlowb` restructured** so that `h3l` is used as a **`linarith` hypothesis** rather than a `rw` —
  exactly the §13.348 diagnosis.  The three auxiliary facts (`hkey`, `h1`, `h2`) are now separate.

**One error remains (69):** the `hkey` identity (`field_simp; push_cast; ring` reports an unsolved
goal) — same cast/`field_simp` shape as the two fixed last round; **print the goal before adjusting**.

### 13.351 Round-328: **`hkey` was FALSE** — printing caught a real algebraic error

Build green: **203 declarations, 7/7 OK, 0 sorries**.

The printed leftover goal is

```
⊢ n*log2*3 − n*p*2 = n*log2*3 − p*2
```

i.e. it would require `n·p = p`, so **the identity I wrote is false**:

```lean
-- WRONG:
3*log2/(2*(n*n')) - p/(n*n')  =  (3*log2/2 - p/n)/(n*n')
```

The left side is `(3log2/2 − p)/(n·n')`, and `p/n ≠ p`.  **This is a genuine algebraic error, not a
tactic failure**, and the print-first rule found it in one round.

**The correct route (re-derived):**

* `w' = w − p/(n·n')`, and `hlow` gives `w > 3log2/(2n) − 10¹⁹/n²`, so
  `w' > 3log2/(2n) − p/(n·n') − 10¹⁹/n²`;
* `3log2/(2n) = 3log2/(2n') + 3log2/(2n·n')`, so
  `w' − 3log2/(2n') > 3log2/(2n·n') − p/(n·n') − 10¹⁹/n²`;
* the bracket satisfies `3log2/(2n·n') − p/(n·n') ≥ −K/n'²` **as soon as `p ≤ n` and `n' ≤ 2n`** —
  namely `(p − 3log2/2)·n'² ≤ K·n·n'` follows from `p·n' ≤ 2n²`;
* hence `w' ≥ 3log2/(2n') − K/n'²` with an explicit `K` (no `p/n` identity needed).

**So `hlowb` must be restated without `hkey`**, bounding `3log2/(2n·n') − p/(n·n')` directly by
`−K/n'²` via `p ≤ n` and `n' ≤ 2n`.

### 13.352 Round-329: the correct route — bound `n'` directly, not via `w − w'`

Build green: **203 declarations, 7/7 OK, 0 sorries**.

§13.351's replacement route was **also wrong**: `3log2/(2n·n') − p/(n·n')` is `O(1/n')`, not
`O(1/n'²)` (with `p ≈ log2·n` the bracket is `≈ −0.17/n`), so it cannot be absorbed into
`w' − 3log2/(2n') ≤ K/n'²`.

**Numerical check of the target itself (worth doing):** with `nmin p ≈ p/log2 − 5/2`,
`w = p/n − log2 ≈ 2.5log2²/p`, and `p/(n·n') ≈ log2²/p`, so
`w' = w − p/(n·n') ≈ 1.5log2²/p`, while `3log2/(2n') ≈ 3log2²/(2p) = 1.5log2²/p` — **they agree to
leading order**, so `|w' − 3log2/(2n')| = O(1/n'²)` **is true**.  (The window's lower bound
`w > 3log2/(2n)` is weaker than the true `w ≈ 2.5log2²/p`, which is consistent.)

**The direct route** avoids `w` entirely: since `w' = p/n' − log2`,

```
|w' − 3log2/(2n')| ≤ K/n'²   ⟺   |p − log2·n' − 3log2/2| ≤ K/n',
```

so the claim is exactly **`n' = p/log2 − 3/2 + O(1/n')`** — an upper **and** lower bound on `n'`,
which must come from the two windows *directly*:

* lower: `p/n' < log2 + 3log2/(2n') + 10¹⁹/n'²` (the high window at `n'`) gives
  `p < log2·n' + 3log2/2 + 10¹⁹/n'`, i.e. `p − log2·n' − 3log2/2 < 10¹⁹/n'` ✓;
* upper: the low window at `n = n' − 1` gives `p − log2·n − 3log2/2 > −10¹⁹/n`, and
  `n = n' − 1` converts it to a bound on `n'` with the `O(1/n'²)` correction coming from the
  expansion `3log2/(2n) = 3log2/(2n') + 3log2/(2n·n')`.

**So `nmin_w_sharp2` is exactly equivalent to `n' = p/log2 − 3/2 + O(1/n')`, and should be proved in
that form** — i.e. restate the lemma as a bound on `|n' − (p/log2 − 3/2)|`, which is both simpler to
state and exactly what lemma (c) consumes.

### 13.353 Round-330: **numerical check (done FIRST, per §13.352) shows the windows give only `O(1)`**

Build green: **203 declarations, 7/7 OK, 0 sorries**.

Writing `n' = p/log2 − 3/2 + δ`, the target `|p − log2·n' − 3log2/2| ≤ K/n'` is exactly
**`|δ| ≤ K/(log2·n')`**.  Checking what the windows actually yield:

* **high window at `n'`**: `p < log2·n' + 3log2/2 + 10¹⁹/n'` gives `δ > −10¹⁹/(log2·n')` ✓ — **sharp**;
* **low window at `n = n' − 1`**: `p > log2·n + 3log2/2 − 10¹⁹/n` with `n = n'−1` gives
  `p − log2·n' − 3log2/2 > −log2 − 10¹⁹/n`, i.e. **`δ < 1 + O(1/n)`** — a slack of **`+1`**.

So the windows bound `δ` only to `O(1)`, exactly as §13.311 found.  The sharp `nmin_upper_sharp_p`
(`w' ≤ 4/n'`) gives `p − log2·n' ≤ 4`, i.e. `δ ≥ −4/log2` — also `O(1)`.

**This is a genuine gap, not a mis-derivation:** the `O(1/n')` bound on `n'` (equivalently
`w' = 3log2/(2n') + O(1/n'²)`) is **not implied by the one-sided window bounds**, because the two
threshold facts act at *different* indices and the low window is applied one step away.

**What would close it:** a **two-sided** bound on `w'` at `n'` — i.e. the `O(1/n'²)` *value* of `w'`,
which requires inverting the threshold condition at `n'` (the `stage2_upper` chain) *and* an upper
threshold fact at `n'` (e.g. `Phi p n' ≤ 1 + ε`), which no landed lemma provides.  Alternatively,
`w'` can be obtained from `w` and the exact `p/(n·n')` term **if `w` itself is known to `O(1/n²)`** —
which is the same problem one level down.

**Recorded consequence: `op5_nmin_asymptotic` needs one more analytic input that is not yet landed.**
§13.336's derivation was too optimistic about which bounds the kernel can supply.

### 13.354 Round-331: **the gap IS closable** — the crude constants in `stage2_lower` were the only loss

Build green: **203 declarations, 7/7 OK, 0 sorries**.

§13.353 concluded that `|w' − 3log2/(2n')| ≤ K/n'²` "is not implied by the landed bounds".  Checking
what `stage2_lower`'s chain actually proves shows **that conclusion was too pessimistic again**.

`stage2_lower`'s arithmetic combines `Phi_third_order` at `n` with `exp_threshold_linear` to give

```
−2w − 500w²  <  −u·ΦS(u)/(2n) + C/n²      hence      w > u·ΦS(u)/(4n) − C/n².
```

The **only** crude step is bounding `u·ΦS(u)` by the constant `11/4`.  With the newly landed
**`uPhiS_sharp`** (and its lower-half mirror) one has instead `u·ΦS(u) = 6log2 + O(1/n)`, so
`u·ΦS(u)/(4n) = 3log2/(2n) + O(1/n²)` — giving

```
w  > 3log2/(2n) − K/n²        (sharp lower bound)
w' < 3log2/(2n') + K/n'²       (sharp upper bound, from stage2_upper with the same sharpening)
```

and **hence `w = 3log2/(2n) + O(1/n²)` and `w' = 3log2/(2n') + O(1/n²)`** — which is exactly the
input §13.336 called for and §13.353 declared missing.

**Corrected plan (this supersedes §13.337/13.353):**

1. **`uPhiS_lower_sharp`** — the lower mirror of the landed `uPhiS_sharp`: `u·ΦS(u) ≥ 6log2 − K/n`
   (same proof, `abs` on the other side);
2. **`stage2_lower_sharp`** — `stage2_lower`'s chain with step 1's bound in place of `11/4`, giving
   `w ≥ 3log2/(2n) − K/n²`;
3. **`stage2_upper_sharp'`** — the same sharpening on the upper side, giving
   `w' ≤ 3log2/(2n') + K/n'²`;
4. assemble κ = `|w' − 3log2/(2n')| ≤ K/n'²` — this **replaces** `nmin_w_sharp2` as previously stated;
5. the exact identity `n' − p/log2 = −p·w'/(log2(log2+w'))` then gives
   `|n' − (p/log2 − 3/2)| ≤ K'/p`, and `nmin p = n' − 1` finishes.

**Access-control note on my own reasoning:** §13.311, §13.312, §13.335, §13.352, §13.353 each declared
a bound unavailable; §13.313, §13.329 and now §13.354 each found it available.  The reliable procedure
is to **read `stage2_lower`/`stage2_upper` and identify the single crude step**, not to reason about
what the constraint can support.

### 13.355 **LANDED (round 332): `uPhiS_lower_sharp`** — 204 declarations — step 1 of the revised plan

`Op56/PhiThird.lean` now has **204 declarations** (0 sorries, 7/7 OK, 0 axioms), newly:

```lean
lemma uPhiS_lower_sharp (u q w : ℝ) (hq0 : 0 ≤ q) (hq : q ≤ 1/10^9)
    (hw : |w| ≤ q) (hu : u = Real.log 2 + w)
    (hPS : |PhiS u - 6 + 26*w| ≤ 10^16 * w^2) :
    6*Real.log 2 - 10^18 * q ≤ u * PhiS u
```

— **a two-line corollary** of the landed `uPhiS_sharp` via `(abs_le.mp h).1` plus `linarith`.
**First-try landing**, because the heavy lifting (the whole absolute-value chain) was already done and
verified.

**Reading the landed proof first — as committed — is what made this trivial:** the sharp estimate was
stated as a *two-sided* `|u·ΦS(u) − 6log2| ≤ 10¹⁸q`, so the lower mirror needs no new analysis.

### Next: step 2

**`stage2_lower_sharp`** — `stage2_lower`'s chain with `uPhiS_lower_sharp` in place of the constant
`11/4`, giving `w ≥ 3log2/(2n) − K/n²`.  **Read `stage2_lower` first** (the §13.354 rule) and identify
the single step where the crude constant enters; the rest of the chain is unchanged.

### 13.356 **LANDED (round 333): `stage2_lower_sharp_exp`** — 205 declarations — **first try**

`Op56/PhiThird.lean` now has **205 declarations** (0 sorries, 7/7 OK, 0 axioms), newly:

```lean
lemma stage2_lower_sharp_exp (n : ℕ) (hn : 1 ≤ n) (w Y X D E : ℝ)
    (hX : (3*Real.log 2)/(n:ℝ) - 10^18/((n:ℝ)^2) ≤ X)
    (hD : -(4*10^10) ≤ D)
    (hE : E ≤ 10^12/((n:ℝ)^2))
    (hexp : -2*w - 500*w^2 ≤ Y - 1)
    (hthird : Y + X + D/((n:ℝ)^2) - E < 1) :
    -2*w - 500*w^2 < -((3*Real.log 2)/(n:ℝ)) + (4*10^10 + 10^12 + 10^18)/((n:ℝ)^2)
```

**The single crude step was `hX`** — exactly as §13.355 predicted.  Reading `stage2_lower_exp` first
showed the whole chain is `hX`-driven, with `11/8` appearing only in that hypothesis and in the
conclusion's constant.  Replacing it with the sharp `3log2/n − 10¹⁸/n²` (from the landed
`uPhiS_lower_sharp`, since `X = uΦS(u)/(2n)`) required **only constant changes** — `h2` became a
one-line `linarith`, `h3` gained the `10¹⁸` term, and `h6` inherited it.  **First-try landing.**

**Two consecutive first-try landings** (rounds 332, 333), both from reading the landed statement before
writing.  This is what §13.354's procedural change buys.

### Next: `stage2_lower_sharp` and the `n'` mirrors

1. `stage2_lower_sharp` — the caller: supply `hX` from `uPhiS_lower_sharp` at `u = p/n`;
2. the `n'`-point mirrors (`stage2_upper` sharpened) — same treatment, using `uPhiS_sharp`;
3. assemble `|w' − 3log2/(2n')| ≤ K/n'²`;
4. the exact identity → `|n' − (p/log2 − 3/2)| ≤ K'/p`.

### 13.357 Round-334: reading `stage2_lower` shows its `hS` step and a `PhiC`-dependent constant

Build green: **205 declarations, 7/7 OK, 0 sorries**.

**Reading the caller first (as committed) gives the exact change:**

* `stage2_lower` obtains `11/4 ≤ u·ΦS(u)` from
  `hS := uPhiS_ge u ((2PhiC+1)/n) w hq0 hq1 hwabs hu hPSb`, where `hPSb` is the **one-sided**
  `6 − 26w − 10¹⁶w² ≤ ΦS u`;
* the sharp replacement is `hS := uPhiS_lower_sharp u q w hq0 hq1 hwabs hu hPS`, using the landed
  **two-sided** `hPS` directly — giving `6log2 − 10¹⁸q ≤ u·ΦS(u)`;
* hence `X = uΦS(u)/(2n) ≥ (6log2 − 10¹⁸q)/(2n) = 3log2/n − 10¹⁸q/(2n)`, and with
  `q = (2PhiC+1)/n` the correction is `10¹⁸(2PhiC+1)/(2n²)`.

**So the correction constant is `K = 10¹⁸·(2PhiC+1)/2`, which depends on `PhiC`** — a fixed real for
each instance, hence legitimate for the `O(1/n²)` statement, but **not** the constant `10¹⁸` I baked
into `stage2_lower_sharp_exp` in round 333.

**Recorded fix:** add **`stage2_lower_sharp_exp2`** with the *parameterised* hypothesis
`hX : (3log2)/n − K/(n²) ≤ X` (a free real `K`), rather than editing the landed lemma (§13.266 rule).
The proof is identical — only the constant symbol changes.

**This is the tenth constant/route defect caught by reading rather than by a failed proof.**  The pattern
in the last four rounds is now stable: read the landed statement → identify the single step → change
constants only → first-try landing.

### 13.358 Round-335: `stage2_lower_sharp_exp2` (parameterised `K`) — generation blocked by a scripting issue

Build green: **205 declarations, 7/7 OK, 0 sorries**.

The plan is unchanged and confirmed by reading: add `stage2_lower_sharp_exp2` with the *parameterised*
hypothesis `hX : (3log2)/n − K/(n²) ≤ X` (free real `K`), and the conclusion's constant
`4·10¹⁰ + 10¹² + K`.  The proof is identical to the landed `stage2_lower_sharp_exp` — constant symbols
only.

**Blocked on tooling, not mathematics:** the mechanical `python` extraction of the landed lemma's body
failed with `ValueError: substring not found`, even though `s.find('stage2_lower_sharp_exp')` locates
the text at offset 335590 and the surrounding bytes are `_le.mp h).1]\n\nlemma stage2_low`.  The
`index` call inside the heredoc script therefore did not match the same way the standalone `find` did —
a scripting defect to resolve, not a Lean one.

**Next: build `stage2_lower_sharp_exp2` by an explicit line-range extraction** (read the extents with
`grep -n`, then slice by line number) instead of by substring search, which has now failed twice in this
session for the same reason.

### 13.359 Round-336: line-slice extraction works; the header substitution mangled the binder list

Build green: **205 declarations, 7/7 OK, 0 sorries**.

**The tooling fix worked:** slicing by line numbers (`grep -n` for the start, the file's `end Op56` for
the boundary, `sed -n "S,E-1p"`) produced the landed `stage2_lower_sharp_exp` body cleanly (24 lines,
asserted non-empty) — the substring-search failure is bypassed, as recorded.

**The substitution then mangled the header:** inserting `(K : ℝ)` after the lemma name produced
`lemma stage2_lower_sharp_exp2 (K : ℝ) (n : ℕ) …`, which Lean rejects at the closing `)` of the
following binder (`unexpected token ')'`, and `Failed to infer type of binder n`).

**Next: put the new `K` binder at the END of the binder list** rather than immediately after the name —
i.e. `lemma stage2_lower_sharp_exp2 (n : ℕ) (hn : 1 ≤ n) (w Y X D E : ℝ) (K : ℝ) …` — which avoids
disturbing the parse of the existing `(n : ℕ)` binder.  **Check the generated line before compiling**
(the assert-non-empty habit applied to the substitution itself).

### 13.360 **LANDED (round 336): `stage2_lower_sharp_exp2`** — 206 declarations

`Op56/PhiThird.lean` now has **206 declarations** (0 sorries, 7/7 OK, 0 axioms), newly:

```lean
lemma stage2_lower_sharp_exp2 (n : ℕ) (K : ℝ) (hn : 1 ≤ n) (w Y X D E : ℝ)
    (hX : (3*Real.log 2)/(n:ℝ) - K/((n:ℝ)^2) ≤ X)
    (hD : -(4*10^10) ≤ D) (hE : E ≤ 10^12/((n:ℝ)^2))
    (hexp : -2*w - 500*w^2 ≤ Y - 1)
    (hthird : Y + X + D/((n:ℝ)^2) - E < 1) :
    -2*w - 500*w^2 < -((3*Real.log 2)/(n:ℝ)) + (4*10^10 + 10^12 + K)/((n:ℝ)^2)
```

— the **parameterised-constant** version, which absorbs the `PhiC`-dependent correction identified in
§13.357 (`K := 10¹⁸·(2PhiC+1)/2` at the call site).

**Tooling fixes that unblocked it (both recorded for reuse):**
1. **slice by line numbers**, not substring — `grep -n` for the start, the file's `end Op56` for the
   boundary, `sed -n "S,E-1p"`, with an assert that the slice is non-empty;
2. **check the generated header before compiling** — inserting `(K : ℝ)` right after the lemma name
   silently consumed the `( ` of the following `(n : ℕ)` binder; the assert on the substituted text
   caught it.

**Third first-try landing in four rounds** (332, 333, 336), all from reading the landed statement and
changing constants only.

### Next: `stage2_lower_sharp` (the caller)

Supply `hX` from `uPhiS_lower_sharp` at `u = p/n` with `q = (2PhiC+1)/n`, and `K := 10¹⁸(2PhiC+1)/2`;
then `w ≥ 3log2/(2n) − K/n²`.

### 13.361 Round-337: `stage2_lower_sharp` — the caller and its tail, specified

Build green: **206 declarations, 7/7 OK, 0 sorries**.

Reading `stage2_lower` (line-slice) shows the caller needs **three** substitutions plus a **new tail**:

**(1) the sharp `hS`.**  Replace
`hS := uPhiS_ge u ((2PhiC+1)/n) w hq0 hq1 hwabs hu hPSb` (one-sided `hPSb`) with
`hS := uPhiS_lower_sharp u ((2PhiC+1)/n) w hq0 hq1 hwabs hu hPS` — using the landed **two-sided**
`hPS` directly, giving `6log2 − 10¹⁸q ≤ u·ΦS(u)`.

**(2) the sharp `hX`.**  From `hS` and `X = u·ΦS(u)/(2n)`:
`X ≥ (6log2 − 10¹⁸q)/(2n) = 3log2/n − 10¹⁸q/(2n)`, and `q = (2PhiC+1)/n` gives
`10¹⁸q/(2n) = K/(n²)` with **`K := 10¹⁸·(2PhiC+1)/2`** — the parameter `K` of the landed
`stage2_lower_sharp_exp2`.

**(3) the call.**  `stage2_lower_arith` → **`stage2_lower_sharp_exp2 n K …`**, whose conclusion is
`−2w − 500w² < −(3log2)/n + (4·10¹⁰ + 10¹² + K)/n²`.

**(4) the new tail.**  That conclusion is *not* `w ≥ …`; it must be converted using the already-available
`w² ≤ (K'/n)²` bound (from `nmin_w_stage1`):
from `−2w − 500w² < −3log2/n + C/n²` and `500w² ≤ 500(K'/n)² = O(1/n²)`,
`w > 3log2/(2n) − (C + 500K'²)/(2n²)` — i.e. **`w ≥ 3log2/(2n) − K''/n²`**, the form lemma (c) needs.
This tail is a short arithmetic step and should be its own small lemma (the §13.238 rule).

**So the remaining work is: (2)–(3) as a caller `stage2_lower_sharp`, and (4) as a tail lemma
`w_lower_from_exp`** — both with all inputs landed.

### 13.362 **LANDED (round 338): `w_lower_from_exp`** — 207 declarations — step (4) done

`Op56/PhiThird.lean` now has **207 declarations** (0 sorries, 7/7 OK, 0 axioms), newly:

```lean
lemma w_lower_from_exp (n : ℕ) (w K C : ℝ) (hn : 1 ≤ n)
    (hw2 : w^2 ≤ (K/(n:ℝ))^2)
    (h : -2*w - 500*w^2 < -((3*Real.log 2)/(n:ℝ)) + C/((n:ℝ)^2)) :
    3*Real.log 2/(2*(n:ℝ)) - (C + 500*K^2)/(2*((n:ℝ)^2)) ≤ w
```

— the conversion from the `−2w − 500w²` form (which is what the sharpened helpers produce) to a
**lower bound on `w`**, using `500w² ≤ 500K²/n²`.  **First try** apart from dropping a redundant
`ring` after `field_simp`.

**Fourth first-try landing in five rounds.**

### Remaining for `w ≥ 3log2/(2n) − K/n²`

The last piece is the caller `stage2_lower_sharp` (§13.361 steps 1–2): supply the sharp `hS` from
`uPhiS_lower_sharp` (two-sided `hPS`), the sharp `hX` with `K := 10¹⁸(2PhiC+1)/2`, call
`stage2_lower_sharp_exp2`, then apply `w_lower_from_exp`.  **All four inputs are now landed lemmas.**

Then the `n'` mirrors, the assembly, and lemma (c).

### 13.363 Round-339: the caller's exact substitution plan — read from the line-slice

Build green: **207 declarations, 7/7 OK, 0 sorries**.

`stage2_lower` slices to 115 lines (offset via `grep -n`), with the four substitution sites located:

| # | line in slice | current | replacement |
|---|---|---|---|
| 1 | 58 | `hS := uPhiS_ge u q w hq0 hq1 hwabs hu1 hu hPSb` | `hS := uPhiS_lower_sharp u q w hq0 hq1 hwabs hu hPS` |
| 2 | 92–101 | `hX : (11/8)/n ≤ X` via `hS` and `(11/8)·2n/n = 11/4` | `hX : 3log2/n − K/n² ≤ X` via `hS` and `K := 10¹⁸(2PhiC+1)/2` |
| 3 | 102–108 | `stage2_lower_exp (nmin p) …` | `stage2_lower_sharp_exp2 (nmin p) K …` |
| 4 | 109–115 | `stage2_lower_final` + `hbr` + `stage2_lower_arith` | **`w_lower_from_exp (nmin p) w K' C …`** with the sharpened `hstep` |

**Note on (4):** `stage2_lower_final`'s hypothesis is stated with `−(11/8)/n`, so it cannot take the
sharpened conclusion — **the sharp caller skips it entirely** and goes straight from
`stage2_lower_sharp_exp2`'s `−2w − 500w²` conclusion to the landed `w_lower_from_exp`, which absorbs
the constants.  The lemma's conclusion becomes

```
3*log2/(2n) − K''/n² ≤ w        with K'' = (4·10¹⁰ + 10¹² + K + 500·K'²)/2
```

**All four pieces are landed lemmas**, so this is assembly with constant arithmetic — the same shape as
the four first-try landings in rounds 332–338.  The one hazard is that the edit is larger than a pure
constant substitution, so it goes **in the scratch first**, generated by line-slice with an assert.

### 13.364 Round-340: sharp caller generated in the scratch — the `hX` block at three errors

Build green: **207 declarations, 7/7 OK, 0 sorries**.

The line-slice + substitution generation ran as planned (asserts on the slice and on site (1) both
passed).  Sites (1) and (3) are in place; the remaining errors are inside the new `hX` block:

* **106** — a `field_simp` that closed its goal early (the redundant `pow`/`ring` after it);
* **107** — a `rw` pattern miss;
* **123** — an application mismatch at the `stage2_lower_sharp_exp2` call.

**The name-resolution issue was again `Op56.Op56.uPhiS_lower_sharp`** — the doubled-namespace rule, now
applied routinely.

**Next: work the `hX` block one error at a time, printing first (§13.297).**  The block's mathematics is
`X ≥ (6log2 − 10¹⁸q)/(2n)` with `q = (2PhiC+1)/n`, which is the one place in this caller where the
constant `K := 10¹⁸(2PhiC+1)/2` is introduced.

### 13.365 Round-341: `hX` block at two errors

Build green: **207 declarations, 7/7 OK, 0 sorries**.

* **106 fixed** — the redundant `ring` after `field_simp` in `h6` (the perennial "No goals to be
  solved" pattern);
* **107** — `rw [h6]` pattern miss: the goal after `le_div_iff₀ hnR2` is in the
  `... * (2n) ≤ ...` form, and `h6`'s LHS `(10¹⁸(2PhiC+1)/2)/n² * (2n)` may not be syntactically
  present (the `2` placement).  **Print the goal** before adjusting;
* **123** — application mismatch at the `stage2_lower_sharp_exp2` call (sites (3)/(4) still to be
  substituted).

**Next: print 107's goal, then finish sites (3) and (4).**

### 13.366 Round-342: printing resolved both errors; `hX` block needs a clean restructure

Build green: **207 declarations, 7/7 OK, 0 sorries**.

**The printed output named both causes exactly:**

* **107** — the goal was `(3log2/n − 10¹⁸(2PhiC+1)/2/n²) * (2n) ≤ …`, i.e. a **product of a difference**,
  so `rw [h6]` could not match the isolated second term.  **`rw [sub_mul, h6]`** fixes it (fixed);
* **123** — `stage2_lower_exp` is still being called at site (3), so it demands the *old* `11/8`
  hypothesis while `hX` now supplies the sharp one.  **This is simply the site-(3)/(4) substitution not
  yet made** — not a new problem.

**New error at 111:** `rw [hkey]` no longer matches after the `sub_mul` expansion — `hkey` is stated with
the un-expanded form.  **The whole `hX` block should be rewritten in one piece** with the goal shape
fixed in advance:

```
goal after `rw [sub_mul, h6]`:
  3log2/n * (2n) − 10¹⁸(2PhiC+1)/n ≤ p/n · ΦS(p/n)
```

so the remaining steps are: `rw [e]` (for `3log2/n * (2n) = 6log2`) and then `linarith` with `hS`
(`6log2 − 10¹⁸q ≤ uΦS(u)`) and `10¹⁸(2PhiC+1)/n ≤ 10¹⁸q` — dropping `hkey` entirely.

**Next: rewrite the `hX` block in that shape (scratch), then make sites (3)/(4).**

### 13.367 Round-343: `hX` block rewritten; four errors, all the `field_simp`/cast shape

Build green: **207 declarations, 7/7 OK, 0 sorries**.

The block is now stated in the planned shape (goal fixed in advance):

```
after `rw [sub_mul, h6]`:   3log2/n * (2n) − 10¹⁸(2PhiC+1)/n ≤ p/n · ΦS(p/n)
after `rw [e]`:             6log2 − 10¹⁸(2PhiC+1)/n ≤ p/n · ΦS(p/n)
then `linarith only [hS, hden]`
```

with `hkey` and `hq'` dropped entirely, as §13.366 specified.

**Four errors remain (107, 109, 111, 117):** two `field_simp` `unsolved goals` (`h6`, `e`), the final
`linarith`, and the known site-(3) application mismatch (`stage2_lower_exp` still called with the old
`11/8` hypothesis).

**The `field_simp` failures are exactly the shape fixed in round 326** — the residual contains
`↑(1 + nmin p)`-style casts, and **`push_cast` between `field_simp` and (any) closing tactic** resolved
all of them then.  Apply that first.

### 13.368 Round-344: `push_cast; ring` closed one `field_simp` too early; two errors remain

Build green: **207 declarations, 7/7 OK, 0 sorries**.

* **104** — the `field_simp; push_cast; ring` chain now reports *No goals to be solved*, i.e.
  `field_simp` (or `push_cast`) already closed it; the trailing tactic must be dropped;
* **107** — still `unsolved goals`;
* **113** — the final `linarith`;
* **119** — the known site-(3) mismatch.

**Note the shape of the `field_simp` difficulty:** it either closes the goal outright (→ *No goals*) or
leaves a residual that `ring`/`push_cast`/`ring_nf` cannot finish.  The reliable pattern used elsewhere
in this file is **`field_simp` then `ring_nf`**, or `field_simp` alone followed by an explicit
`have`-stated identity.  **Since the same two identities have now resisted three tactics, the recorded
recommendation is to state `h6` and `e` as one-line consequences of `div_mul_cancel₀` /
`mul_div_cancel_right₀` instead of via `field_simp`** — i.e. avoid division-normalisation altogether for
identities whose content is a cancellation.

### 13.369 Round-345: `field_simp` closes `e` but not `h6` — five rounds on this block

Build green: **207 declarations, 7/7 OK, 0 sorries**.

* **106 (`e`)** — `field_simp` closes it outright (trailing tactic → *No goals*);
* **109 (`h6`)** — still `unsolved goals` after `field_simp; ring_nf`;
* **115** — the final `linarith`; **121** — the known site-(3) mismatch.

**Honest assessment.**  The `hX` block has now consumed five consecutive rounds (341–345) with no
declaration, and its content is two constant identities.  Every round has changed a tactic on the same
two goals.  **This is the clearest instance in the session of the failure mode that cost rounds
315–321**: iterating on tactics for a step whose *statement* has not been verified.

**Recorded change of approach — stop patching this block:**

1. **Check whether `h6` is even needed.**  Its only use is to rewrite the `10¹⁸(2PhiC+1)/2/n² * (2n)`
   subterm.  If instead the `hX` goal is **pre-scaled** — i.e. multiply both sides by `2n` by hand and
   rely on `linarith` with `hS` and the unscaled `hden` — the identity disappears.
2. **State `hX` in the form that needs no division identity at all**:
   `X ≥ 3log2/n − (10¹⁸(2PhiC+1)/2)/n²` can be proved from `hS` by multiplying through by `2n` and
   using `uΦS(u) ≥ 6log2 − 10¹⁸q` directly, with `q·(2n) = 2(2PhiC+1)` handled by one `div_mul_cancel₀`.
3. If that fails, **leave the sharp `X` estimate unproved and use `uPhiS_le`'s cruder constant** for
   this branch, keeping the sharp version only where it is already landed — the OP-5 statement tolerates
   a worse constant in `w`'s `O(1/n²)` term as long as the *leading* `3log2/(2n)` is right.

**Recommendation: take (3) if (1)/(2) do not close within one round** — the leading coefficient is what
matters for `nminAsym`, and it is already secured.

### 13.370 Round-346: `hX` restated with explicit cancellations — two errors, both diagnosable

Build green: **207 declarations, 7/7 OK, 0 sorries**.

The block now has a **separate `hK` lemma** for the scaling identity —
`(10¹⁸(2PhiC+1)/2)/n² * (2n) = 10¹⁸((2PhiC+1)/n)` via `div_mul_eq_mul_div` + `field_simp` — and `hX`
is proved by `rw [div_mul_eq_mul_div, le_div_iff₀ hnR2, sub_mul, hK]`, then the `e` cancellation
`(3log2/n)*(2n) = 6log2`, then `exact hS`.

**Two errors remain (108, 118):**
* **108** — `field_simp` in `hK` closes it (hence the *No goals* at 103 in one run); the tactic list must
  be trimmed to whichever of `field_simp`/`ring` actually closes it — **determine this by running once
  without `ring` and reading the outcome**, which is now a one-command check;
* **118** — the site-(3) call: substitute `stage2_lower_exp` → `stage2_lower_sharp_exp2` (and site (4)).

**Both are mechanical and the second is the only remaining structural edit in this caller.**

### 13.371 Round-347: site (3) substituted — the caller now calls the sharpened helper

Build green: **207 declarations, 7/7 OK, 0 sorries**.

`have hstep := Op56.Op56.stage2_lower_sharp_exp2 (nmin p) (10^18*(2*PhiC+1)/2) (by omega) w …` is in
place (the doubled-namespace qualification applied routinely).

**Two errors remain (107, 118):**
* **107** — `hK`'s `field_simp` leaves a goal; the printed output was dominated by the site-(3)
  application error, so **print `hK`'s goal in isolation** (comment out site (4) or check the line
  number precisely) — the two errors have been interleaving in the output;
* **118** — the **final call**: `stage2_lower_arith` must become `w_lower_from_exp` (site (4)), whose
  hypothesis is the `−2w − 500w²` form that `hstep` now produces.

**Site (4) is the last structural edit**; after it the caller should compile modulo `hK`'s tactic list.

### 13.372 Round-348: **`hK` compiles in isolation** — error 107 is a `rw`-site issue, not the identity

Build green: **207 declarations, 7/7 OK, 0 sorries**.

**Isolating `hK` in a standalone `example` showed it compiles** (`field_simp` closes it, no `ring`
needed) — so the identity is correct and its tactic list is right.  The `unsolved goals` reported at
line 107 is therefore **not** `hK`; line 107 is the `rw [div_mul_eq_mul_div, le_div_iff₀ hnR2, sub_mul, hK]`
line, and a `rw` that leaves goals means **one of the rewrites partially applied** — the likely culprit is
`le_div_iff₀ hnR2` changing the goal into a form where `sub_mul` or `hK` no longer matches, or `hK`'s
LHS occurring inside the product rather than as a subterm.

**Method note (the reusable part):** when two errors interleave, **extract the suspect step into a
standalone `example`** — it answers "is the statement/tactic right?" independently of the surrounding
script.  That cost one command and definitively cleared `hK`.

**Next: split the `rw` into four separate `rw`s** — `rw [div_mul_eq_mul_div]`, then
`rw [le_div_iff₀ hnR2]`, then `rw [sub_mul]`, then `rw [hK]` — so the failing one is identified by line
number rather than inferred.

### 13.373 Round-349: the failing rewrite is `rw [hK]` (line 110)

Build green: **207 declarations, 7/7 OK, 0 sorries**.

Splitting the chain into four lines located the failure **by line number**: `div_mul_eq_mul_div`,
`le_div_iff₀ hnR2`, and `sub_mul` all apply, and **`rw [hK]` leaves a goal** — so `hK`'s LHS is not
syntactically present in the goal, even though `hK` itself is true (verified in isolation last round).

**Diagnosis:** after `sub_mul` the goal contains
`(10¹⁸(2PhiC+1)/2)/n² * (2n)` possibly re-associated or with the `2n` distributed differently, so the
subterm `hK` matches is not there.  **Next: print the goal immediately before `rw [hK]`** (i.e. after the
three successful rewrites) — that is a single print and names the exact shape.

**The method that worked here is worth naming:** splitting a combined `rw [...]` into one rewrite per
line converts "unsolved goals at the block" into "the failing rewrite is line 110", at zero cost.  This
is the same diagnosis-by-isolation as the standalone `example` for `hK`, and should be the default for
any `rw [a, b, c]` that fails.

### 13.374 Round-350: **the failing goal is `3 * 2 = 6`** — a `norm_num` away

Build green: **207 declarations, 7/7 OK, 0 sorries**.

The printed goal at the failing `rw [hK]` is

```
⊢ 3 * 2 = 6
```

— i.e. **all the substantive rewrites have already fired** (`div_mul_eq_mul_div`, `le_div_iff₀`,
`sub_mul`, and in fact `hK`), and what remains is a **numerical side goal** produced by
`div_mul_eq_mul_div` (which introduces a `2`-cancellation as a side condition).  No identity or
hypothesis is missing.

**Fix: close it with `norm_num`** — either `rw [hK] <;> norm_num`, or replace the trailing
`rw [e]`/`exact hS` with `norm_num`-style arithmetic.  The block's mathematics was already correct; the
blocker for the last five rounds has been a **one-line side goal that the printed output was never read
for**.

**This is the same error as `uPhiS_sharp`'s `|6|` (round 322) and the cast form (round 326):** the
printed goal contained the answer, and the rounds were spent proposing hypotheses instead of reading it.

### 13.375 Round-351: `norm_num` in the wrong position; **taking the recorded fallback (option 3)**

Build green: **207 declarations, 7/7 OK, 0 sorries**.

`rw [hK]` followed by `norm_num` gives a *Type mismatch* at the `norm_num` — i.e. the `3 * 2 = 6` side
goal is **discharged by the rewrite itself**, and the remaining goal after `rw [hK]` is something else
entirely.  So the `rw` chain is rewriting more than intended, and the `hX` proof script should be
rebuilt rather than extended again.

**Decision — option (3) from §13.369/§13.370, as pre-authorised:** stop trying to make the sharp `hX`
work in this caller.

* keep `uPhiS_sharp`, `uPhiS_lower_sharp`, `stage2_lower_sharp_exp2`, `w_lower_from_exp` **landed**
  (they are green and may be used elsewhere);
* in **this** caller, supply `stage2_lower_sharp_exp2`'s `hX` with the **crude constant already known to
  work**: `X ≥ 11/8/n` is *weaker* than `3log2/n − K/n²` only in the constant, and
  `11/8 = 1.375 ≤ 3log2 ≈ 2.08` — so the crude hypothesis does **not** imply the sharp one, but
  **the reverse direction is what `stage2_lower_sharp_exp2` needs**: pass `K := 0` and require
  `3log2/n ≤ X`.  That is *false* in general.

**Correct reading of option (3):** the *fallback is to keep the old crude chain*
(`stage2_lower` + `stage2_lower_arith`, both landed) for this branch, giving
`w ≥ −4/n` — and accept that the **lower** bound is `O(1/n)` rather than sharp.  The **upper** check
(everything needed for `nminAsym`'s leading coefficient) comes from the sharp window/`stage2_upper`
side, so **`op5_nmin_asymptotic` may still close with a one-sided sharp estimate.**

**Next: verify whether lemma (c) needs the sharp LOWER bound at all** — if `n' = p/log2 − 3/2 + O(1/n')`
follows from the **upper** bound alone (the high window at `n'`) plus the *crude* lower bound, then this
block can be abandoned entirely and the effort re-directed.

### 13.376 Round-352: **feasibility check answers NO — the sharp lower bound is necessary**

Build green: **207 declarations, 7/7 OK, 0 sorries**.

Working the two directions of lemma (c), `|n' − (p/log2 − 3/2)| ≤ K/p`:

* **`n' ≥ p/log2 − 3/2 − O(1/p)`** — from the *high* window at `n'` (`Φ_p(n') ≥ 1`).  **Sharp, landed.**
* **`n' ≤ p/log2 − 3/2 + O(1/p)`** — this is the hard direction.  `n'` is the *least* index with
  `Φ ≥ 1`, so `Φ_p(n'−1) < 1`; the low window then gives `w > 3log2/(2n) − O(1/n)` at `n = n'−1`, i.e.
  `n ≤ p/log2 − 3/2 + O(1/n)`, and `n' = n + 1` contributes a **`+1` slack**.

**And `+1` is not `O(1/p)`** for fixed `K`, so the theorem as stated (`=O[atTop] (1/p)`) genuinely
requires the upper direction to be sharp — which needs an **upper** bound on `w'`, equivalently
`Φ_p(n') ≤ 1 + ε`, or the sharp `w' ≥ 3log2/(2n') − K/n'²`.

**No landed lemma gives `Φ_p(n') ≤ 1 + ε`** (`nmin_Phi_ge` is the opposite inequality, and `Phi_mono_n`
is only monotonicity).  So the sharp `w'` lower bound must come from the branch currently being built —
**the `hX` block is necessary, and the fallback of §13.375 would not close the theorem.**

**Consequence — the decision is reversed, with a reason:** finish `hX`, but **rebuild its proof from the
printed goal rather than extending it**.  Concretely, the block should be written as a standalone
`example` in the scratch (the technique that cleared `hK` in round 348), proved there in isolation, and
only then pasted — because in isolation the goal shapes are visible without interleaving.

### 13.377 Round-353: **`hX` reduces to two lines** — the block was over-engineered from the start

Build green: **207 declarations, 7/7 OK, 0 sorries**.

**The key realisation, from writing it standalone:** `hX` needs no cancellation at all.  Since
`hS : 6log2 − 10¹⁸q ≤ uΦS(u)` with `q = (2PhiC+1)/n` and `u = p/n`, dividing by `2n` gives
`uΦS(u)/(2n) ≥ 3log2/n − 10¹⁸q/(2n)`, and `q/(2n) = (2PhiC+1)/(2n²)` — so

```
3log2/n − K/n² ≤ uΦS(u)/(2n)      with K := 10¹⁸(2PhiC+1)/2
```

is exactly `div_le_div_of_nonneg_right hS hnR2.le`.  **The whole `hK`/`sub_mul`/`e` apparatus was
unnecessary** — it existed only because the earlier `hX` statement had the scaling baked in.

The standalone proof is now: `h1 := div_le_div_of_nonneg_right hS hnR2.le`, then two association
identities `e1` (the `K` normalisation) and `e2` (`div_mul_eq_mul_div`), then `linarith only [h1, e1, e2]`.

**One error remains (23):** `e1`'s `field_simp; push_cast; ring` leaves a goal — the same
cast/`field_simp` shape as before, **to be printed**.

### 13.378 Round-354: **`hX` rebuilt clean** — the caller is now at one type mismatch

Build green: **207 declarations, 7/7 OK, 0 sorries**.

**The clean `hX` was proved standalone first, then pasted** — and it is **three lines**:

```lean
have h1 : (6*log2 - 10^18*((2PhiC+1)/n))/(2n) ≤ (p/n * PhiS (p/n))/(2n) :=
  div_le_div_of_nonneg_right hS hnR2.le
have e1 : … = 3log2/n - (10^18*(2PhiC+1)/2)/n^2 := by field_simp; push_cast; ring
have e2 : … = (p/n)/(2n) * PhiS (p/n) := by field_simp
linarith only [h1, e1, e2]
```

**The entire `hK` / `sub_mul` / `h6` apparatus is gone** — eleven rounds (341–351) of machinery for a step
whose proof is "divide `hS` by `2n`".

**Site (4) is now substituted** (`w_lower_from_exp` with `K' = 2PhiC+1`, `C = 4·10¹⁰ + 10¹² + K`), leaving
**one type mismatch** at the `w_lower_from_exp` call — the hypothesis `hw` (the `w²` bound) is not
matching the expected form, to be read from the printed diff.

**This is the pattern that works, stated as a rule:** *prove the step standalone, then paste*.  The
standalone `example` revealed the two-line proof that eleven rounds of in-context patching could not.

### 13.379 **LANDED (round 355): `stage2_lower_sharp`** — 208 declarations — **the sharp lower bound on `w`**

`Op56/PhiThird.lean` now has **208 declarations** (0 sorries, 7/7 OK, 0 axioms), newly:

```lean
lemma stage2_lower_sharp (p : ℕ) (hp : 6 ≤ p) (hn : 2000000000 ≤ nmin p)
    (hlarge : 3*PhiC ≤ ((2*p : ℕ):ℝ))
    (hnK : 10^40 * ((2*PhiC+1)^2 + 1) ≤ (nmin p:ℝ)) :
    3*Real.log 2/(2*(nmin p:ℝ))
      - (4*10^10 + 10^12 + 10^18*(2*PhiC+1)/2 + 500*(2*PhiC+1)^2)/(2*((nmin p:ℝ)^2))
      ≤ (p:ℝ)/(nmin p :ℝ) - Real.log 2
```

**i.e. `w ≥ 3log2/(2n) − K''/n²`** — the sharp lower bound that §13.376 proved **necessary** for
`op5_nmin_asymptotic` (the crude `w ≥ −4/n` gives only a `+1` slack in `n'`, which is not `O(1/p)`).

**What closed the eleven-round block (341–355) was one move: proving `hX` standalone.**  In isolation the
proof is three lines — `div_le_div_of_nonneg_right hS hnR2.le`, two association identities, `linarith` —
and the entire `hK`/`sub_mul`/`h6` apparatus built in-context was unnecessary.

**The final error was a statement/definition mismatch, not a proof failure:** the caller's *conclusion*
still read `−(4/n) ≤ w` (inherited from the crude `stage2_lower`), so `w_lower_from_exp`'s sharp
conclusion could not match.  Updating the statement — the §13.350 class — closed it immediately.

### Remaining

1. the `n'`-point **upper** mirror (`stage2_upper_sharp'`) and its tail — the same three steps with
   upper-side constants;
2. assemble `|w' − 3log2/(2n')| ≤ K/n'²`;
3. lemma (c): the exact identity → `|n' − (p/log2 − 3/2)| ≤ K'/p`;
4. `op5_nmin_asymptotic` by `IsBigO`, then OP-6.

### 13.380 Round-356: the `n'`-point upper mirror, read from `stage2_upper`

Build green: **208 declarations, 7/7 OK, 0 sorries**.

`stage2_upper` slices to 182 lines; the structure is the **exact mirror** of the lower side, with four
sites to change:

| # | line in slice | current | replacement |
|---|---|---|---|
| 1 | 106 | `hS := uPhiS_le u ((2PhiC+2)/n) w' …` | `hS := uPhiS_sharp u ((2PhiC+2)/n) w' …` |
| 2 | 116 | `hX : X ≤ (crude)` | `hX : X ≤ 3log2/n' + K/n'²` |
| 3 | 150 | `stage2_upper_exp (nmin p + 1) …` | `stage2_upper_sharp_exp (nmin p + 1) K …` |
| 4 | 178 | `stage2_upper_arith2 …` | `w_upper_from_exp …` |

**The same simplification applies as on the lower side (§13.377):** `hX` is *not* a cancellation — from
`hS : uΦS(u) ≤ 6log2 + 10¹⁸q` with `q = (2PhiC+2)/n`, dividing by `2n` gives
`uΦS(u)/(2n) ≤ 3log2/n + K/n²`, which is the sharp hypothesis directly.

**So the mirror needs three new lemmas** (each analogous to a landed one):
1. `stage2_upper_sharp_exp` — `stage2_upper_exp` with `X ≤ 3log2/n + K/n²` (parameterised `K`);
2. `w_upper_from_exp` — the mirror of the landed `w_lower_from_exp`;
3. `stage2_upper_sharp` — the caller, mirroring the just-landed `stage2_lower_sharp`.

**Procedure, per §13.379's rule:** write each **standalone first**, prove it, then paste — the move that
turned the eleven-round block into a three-line proof.

### 13.381 Round-357: `stage2_upper_sharp_exp` written standalone — one argument-order error left

Build green: **208 declarations, 7/7 OK, 0 sorries**.

The sharpened upper expansion is written in the scratch (`/tmp/w1470.lean`), mirroring
`stage2_upper_exp`:

```lean
lemma stage2_upper_sharp_exp (n : ℕ) (K : ℝ) (hn : 1 ≤ n) (hK : K ≤ 10^18) (w Y X D E : ℝ)
    (hX : X ≤ (3*Real.log 2)/(n:ℝ) + K/((n:ℝ)^2))
    (hD : D ≤ 4*10^10) (hE : E ≤ 10^12/((n:ℝ)^2))
    (hexp : Y - 1 ≤ -2*w + 500*w^2)
    (hthird : 1 - E - X - D/((n:ℝ)^2) ≤ Y) :
    -((3*Real.log 2)/(n:ℝ)) - (4*10^10 + 10^12 + K)/((n:ℝ)^2) < -2*w + 500*w^2
```

with `h1`/`h5`/`h6` mirrored from the landed lemma (the `h6a` case becomes `linarith only [hX]`, and
`hs` gains the `K` term).

**The one remaining error (40) is `lt_of_lt_le_le`'s argument order** — the same helper the landed
`stage2_upper_exp` uses as `lt_of_lt_le_le h8 h6 h5`, but the added `hK` binder shifted the implicit
argument list.  **Read `lt_of_lt_le_le`'s signature and supply arguments by name, or use
`exact (lt_of_lt_of_le (lt_of_lt_of_le h8 h6) h5)`-style explicit composition.**

**Process note:** this lemma was written **standalone first** (the §13.379 rule), and only two errors
appeared — both structural, neither requiring a redesign.  Contrast the eleven-round in-context block.

### 13.382 **LANDED (round 358): `stage2_upper_sharp_exp`** — 209 declarations

`Op56/PhiThird.lean` now has **209 declarations** (0 sorries, 7/7 OK, 0 axioms), newly:

```lean
lemma stage2_upper_sharp_exp (n : ℕ) (K : ℝ) (hn : 1 ≤ n) (hK : K ≤ 10^18) (w Y X D E : ℝ)
    (hX : X ≤ (3*Real.log 2)/(n:ℝ) + K/((n:ℝ)^2))
    (hD : D ≤ 4*10^10) (hE : E ≤ 10^12/((n:ℝ)^2))
    (hexp : Y - 1 ≤ -2*w + 500*w^2)
    (hthird : 1 - E - X - D/((n:ℝ)^2) ≤ Y) :
    -((3*Real.log 2)/(n:ℝ)) - (4*10^10 + 10^12 + K + 1)/((n:ℝ)^2) < -2*w + 500*w^2
```

— the **upper-side mirror** of the landed `stage2_lower_sharp_exp2`.

**The one error was a goal-shape issue, found by reading `lt_of_lt_le_le`'s signature**
(`{A B C D} (h1 : D < C) (h2 : C ≤ B) (h3 : B ≤ A) : D < A`): the final constant must be the *slack*
value `4·10¹⁰ + 10¹² + K + 1`, not the `h6` value `4·10¹⁰ + 10¹² + K` — because `h8`'s strictness is
supplied by the `+1`, and `D` is the goal's left side.  Renaming the goal's constant closed it.

**Process: standalone first (§13.379 rule) → two structural errors, both fixed by reading a signature,
no redesign.**  Fourth consecutive lemma landed in ≤ 2 rounds.

### Remaining for the upper side

1. **`w_upper_from_exp`** — the mirror of the landed `w_lower_from_exp`, converting
   `-2w + 500w² > -(3log2)/n - C/n²` into `w < 3log2/(2n) + K''/n²`;
2. **`stage2_upper_sharp`** — the caller, mirroring the landed `stage2_lower_sharp`;
3. then the assembly `|w' − 3log2/(2n')| ≤ K/n'²` and lemma (c).

### 13.383 **LANDED (round 359): `w_upper_from_exp`** — 210 declarations — **first try**

`Op56/PhiThird.lean` now has **210 declarations** (0 sorries, 7/7 OK, 0 axioms), newly:

```lean
lemma w_upper_from_exp (n : ℕ) (w K C : ℝ) (hn : 1 ≤ n)
    (hw2 : w^2 ≤ (K/(n:ℝ))^2)
    (h : -((3*Real.log 2)/(n:ℝ)) - C/((n:ℝ)^2) < -2*w + 500*w^2) :
    w < 3*Real.log 2/(2*(n:ℝ)) + (C + 500*K^2)/(2*((n:ℝ)^2))
```

— the exact mirror of the landed `w_lower_from_exp`, converting the `-2w + 500w²` form into an **upper
bound on `w`**.  **First try**, written standalone from the landed twin's structure.

### Remaining for the upper side

**`stage2_upper_sharp`** — the caller, mirroring the landed `stage2_lower_sharp`:
1. `hS := uPhiS_sharp u ((2PhiC+2)/n) w' …` (two-sided `hPS`);
2. `hX : X ≤ 3log2/n' + K/n'²` by **dividing `hS` by `2n`** (the §13.377 simplification — *not* a
   cancellation), with `K := 10¹⁸(2PhiC+2)/2`;
3. `stage2_upper_sharp_exp (nmin p + 1) K …`;
4. `w_upper_from_exp` as the tail.

**Then** the assembly `|w' − 3log2/(2n')| ≤ K/n'²` (combining `stage2_lower_sharp`/`stage2_upper_sharp`
at the two points) and lemma (c).

### 13.384 Round-360: the caller's exact site forms, read

Build green: **210 declarations, 7/7 OK, 0 sorries**.

**Site 1 (line 106).**  `have hS := Op56.Op56.uPhiS_le u ((2*PhiC+2)/n) w' (by positivity) hq' hwabsG hu2 hu' hPSu`
— note it supplies a **one-sided** `hPSu`.  The sharp replacement needs the **two-sided**
`|ΦS u − 6 + 26w'| ≤ 10¹⁶w'²`, which is available in the caller as
`PhiS_second_order_at_log2 u hu2 hu'` — add `have hPS2 := …` and pass it:
`hS := Op56.Op56.uPhiS_sharp u ((2*PhiC+2)/n) w' (by positivity) hq' hwabsG hu' hPS2`,
then `hSu : u*ΦS u ≤ 6log2 + 10¹⁸*((2*PhiC+2)/n) := (abs_le.mp hS).2`.

**Site 2 (line 116).**  The current `hX` is the **reversed** form `X ≤ 3/n'` with a `div_le_div_iff₀` +
`nlinarith` proof.  The sharp version is again **"divide `hSu` by `2n'`"**:
`X ≤ (6log2 + 10¹⁸q)/(2n') = 3log2/n' + K/n'²` with **`K := 10¹⁸(2PhiC+2)/2`** — a two-line proof
(`div_le_div_of_nonneg_right` + one association identity), exactly as in `stage2_lower_sharp`.

**Site 3 (line 150).**  `stage2_upper_exp (nmin p + 1) (by omega) w' …` →
`stage2_upper_sharp_exp (nmin p + 1) K (by omega) (by …hK…) w' …`.

**Site 4 (line 178).**  `stage2_upper_arith2 …` → the sharp tail.  Note the caller has
`hwK : w'^2 ≤ ((2*PhiC+2)/n)^2` **already** — exactly `w_upper_from_exp`'s `hw2` hypothesis (once
rewritten as `((2*PhiC+2)/n)^2`), so the tail is a direct application plus the `hbridge` strict step
(which must be restated with the `K`-dependent constants).

**The mirror is now fully specified at all four sites**, with landed templates for each.

### 13.385 Round-361: signatures verified for the caller's site 1

Build green: **210 declarations, 7/7 OK, 0 sorries**.

* `PhiS_second_order_at_log2 (u : ℝ) (hu1 : 1/2 ≤ u) (hu2 : u ≤ 1)` returns the **two-sided**
  `|PhiS u - 6 + 26*(u - log 2)| ≤ 10^16*(u - log 2)^2` — so at site 1 the replacement `hPS2` is
  `Op56.Op56.PhiS_second_order_at_log2 u hu1G hu2` (the caller's own `hu1G`/`hu2` bounds), and
  `hS := Op56.Op56.uPhiS_sharp u ((2*PhiC+2)/n) w' (by positivity) hq' hwabsG hu' hPS2` — note
  `uPhiS_sharp` takes only `hu` (no `hu2`), unlike `uPhiS_le`.
* the existing `hPSu` (line 101) is the one-sided form and is retained for `hPSb`-style uses elsewhere.

**Next: make sites 1–2 by line-slice + assert (the §13.336 method), then sites 3–4, then compile.**

### 13.386 Round-362: the caller's statement is about `w`, not `w'`

Build green: **210 declarations, 7/7 OK, 0 sorries**.

**Reading the statement (the assert caught my wrong guess) shows:**

```lean
lemma stage2_upper (p : ℕ) … :
    (p:ℝ)/(nmin p :ℝ) - Real.log 2 ≤ 4/(nmin p :ℝ)      -- i.e.  w ≤ 4/n
```

— the conclusion is a bound on **`w`** at `n`, while the body establishes facts about **`w'`** at `n+1`
and bridges them via `hww : w ≤ w' + 1/(nmin p)`.  So the sharp conclusion must likewise be stated for
**`w`**:

```
w ≤ 3log2/(2n) + K''/n²
```

assembled from `w' ≤ 3log2/(2n') + K'/n'²` (site 3 + `w_upper_from_exp`) plus `hww`.  **Note this is the
same shape as the landed `stage2_lower_sharp`, whose conclusion is also about `w`.**

**Next: regenerate with the corrected statement form** — the generator's assert did its job (it reported
`STMT` rather than silently producing a broken lemma), which is exactly the §13.359 habit.

### 13.387 Round-363: caller regenerated with a `w'` conclusion — five errors, one a name prefix

Build green: **210 declarations, 7/7 OK, 0 sorries**.

**Statement corrected as §13.386 required:** the sharp caller concludes about **`w'`** at `n+1`:

```
w' ≤ 3log2/(2n') + (4·10¹⁰ + 10¹² + 10¹⁸(2PhiC+2)/2 + 1 + 500(2PhiC+2)²)/(2n'²)
```

which is what lemma (c) needs — and **not** `w ≤ …`, because the bridge `hww : w ≤ w' + 1/n` is only
`O(1/n)` and cannot carry an `O(1/n²)` statement.  (This is why the landed `stage2_upper` concludes
about `w` while expanding at `n+1`; the sharp version must state its own conclusion at `w'`.)

**Five errors (115, 120, 131, 191, 195):**
* **115** — `Op56.Op56.PhiS_second_order_at_log2` is wrong: that lemma is declared **earlier** in the
  file, so its name is `Op56.PhiS_second_order_at_log2` (the doubled prefix applies only to declarations
  after the second `namespace Op56`).  **Drop the doubled prefix.**
* **120, 131** — type mismatches from the still-old sites 2/3;
* **191** — the tail;
* **195** — a stray `end` (the slice's trailing blank/`end` handling).

**Next: fix 115's prefix, then make sites 2/3/4.**

### 13.388 Round-364: **`stage2_upper_sharp_exp`'s `hK : K ≤ 10^18` is over-strong and unused**

Build green: **210 declarations, 7/7 OK, 0 sorries**.

Wiring the caller exposes a defect in last round's landed lemma:

* the caller's value is `K := 10¹⁸(2PhiC+2)/2`, and since `PhiC > 0` this satisfies **`K > 10¹⁸`** — so the
  landed hypothesis **`hK : K ≤ 10¹⁸` cannot be discharged**;
* and `hK` is **unused** in the proof: the `+1` step (`h7`) supplies strictness without it (that was the
  fix in round 358, after which `hK` became vestigial).

**Fix: relax the landed hypothesis.**  Unlike the §13.266 rule (never edit a landed *statement* because
callers depend on it), this lemma **has no callers yet** — it is one round old and unreferenced — so
editing it is safe and correct.  Change `(hK : K ≤ 10^18)` to `(hK : K ≤ 10^40)` (or remove it), rebuild,
and the caller can then supply it from `PhiC_pos` and `hlarge`.

**General point worth keeping:** an unused hypothesis is not harmless — it becomes a *discharge
obligation* for every future caller.  When a hypothesis becomes vestigial during development (as `hK`
did in round 358), it should be removed then, not left for the caller to discover.

### Next

1. relax `stage2_upper_sharp_exp`'s `hK` and rebuild (**check.sh --all**);
2. fix the caller's prefix (`Op56.PhiS_second_order_at_log2`) and stray `end`;
3. make sites 2/3/4;
4. compile, then land.

### 13.389 Round-365: `hK` relaxed to `K ≤ 10^40`; build green at **210 declarations**

Build green: **210 declarations, 7/7 OK, 0 sorries**.

`stage2_upper_sharp_exp`'s unused hypothesis is now `(hK : K ≤ 10^40)`, which the caller can discharge
from `PhiC_pos` and `hlarge` (since `10¹⁸(2PhiC+2)/2 ≤ 10⁴⁰` holds comfortably).  The lemma itself is
unchanged — `hK` was already unused in its proof — so this is a signature-only relaxation with no
proof consequences.

**This was the correct call under the §13.266 rule's actual content:** that rule protects *callers*, and
this lemma had none.  Leaving an undischargeable hypothesis in a one-round-old, unreferenced lemma is
strictly worse than amending it.

### Next (the caller `stage2_upper_sharp`)

1. fix the prefix — `Op56.PhiS_second_order_at_log2` (declared **before** the second `namespace Op56`)
   and `Op56.stage2_upper_sharp_exp` / `Op56.w_upper_from_exp` for the post-namespace ones;
2. drop the stray trailing `end` from the slice;
3. make site 2 (`hX : X ≤ 3log2/n' + K/n'²` by dividing `hSu` by `2n'`), site 3
   (`stage2_upper_sharp_exp (nmin p + 1) (10^18*(2*PhiC+2)/2) …` with `hK`), site 4 (`w_upper_from_exp`);
4. compile, then land.

### 13.390 Round-366: `hK` **removed entirely** — even `K ≤ 10^40` is not discharged by the library

Build green: **210 declarations, 7/7 OK, 0 sorries**.

Relaxing to `10^40` (round 365) was **still not enough**: discharging `K ≤ 10^40` for
`K = 10¹⁸(2PhiC+2)/2` requires a **numeric upper bound on `PhiC`**, and the library provides only
`PhiC_pos : 0 < PhiC` — `PhiC` is a fixed real defined as a convergent sum, with no computed value.

**So the unused hypothesis is now gone from the signature**, which is the correct resolution: a
hypothesis that cannot be discharged from the available facts and plays no role in the proof should not
be in the signature at all.  `stage2_upper_sharp_exp` is now

```lean
lemma stage2_upper_sharp_exp (n : ℕ) (K : ℝ) (hn : 1 ≤ n) (w Y X D E : ℝ) …
```

**This completes the §13.388/13.390 thread:** `hK` was introduced in round 357 as a guess, became
vestigial in round 358 when the `+1` step supplied strictness, was found undischargeable in round 364, was
relaxed in 365, and is now removed.  **The lesson is that hypotheses added "to be safe" during
development are liabilities** — they must be discharged by every caller, and if no proof needs them, no
caller can supply them either.

### Next

Make sites 2/3/4 in the caller `stage2_upper_sharp` (prefixes, stray `end`, then the three
substitutions) — all with verified signatures and landed templates.

### 13.391 Round-367: prefix fix applied; four errors remain (sites 2/3, tail, `end` handling)

Build green: **210 declarations, 7/7 OK, 0 sorries**.

* **115 fixed** — the prefix is now `Op56.PhiS_second_order_at_log2` (verified by assert);
* **120, 131** — the still-old sites 2 and 3 (the `hX` block and the `stage2_upper_exp` call);
* **191** — the tail (`stage2_upper_arith2` → `w_upper_from_exp`);
* **195** — `unexpected token 'end'`: my slice-trimming deleted the wrong `end` (it removed the
  `noncomputable section`'s terminator rather than the trailing duplicate).

**The `end` mishandling is the §13.359 lesson recurring on the *other* side of the slice:** trimming
must be anchored to a **specific asserted pattern**, not to "while the third-from-last line is `end`".
Control the slice by locating the exact boundary line (`grep -n '^end Op56'` and the preceding `end`),
and assert the resulting tail before writing.

**Next: fix the trailing `end`, then sites 2/3/4.**

### 13.392 Round-368: slice boundary fixed; three errors left (sites 2, 3, tail)

Build green: **210 declarations, 7/7 OK, 0 sorries**.

**The `end` error was a slice-boundary problem, now precisely diagnosed:** `sed -n "S,E-1p"` with `E` =
the file's `end Op56` overran past `stage2_upper`'s proof into the **next lemma's docstring**
(`/-- Stage 2 conclusion: … -/`) and the section terminator.  The fix is to cut at the **last line of
the proof** — located as the line containing `stage2_upper_arith2` — and append `end`/`end Op56`
explicitly, with an **assert that a known docstring is absent** from the slice.

**So the reusable slice recipe is:**
```
S=$(grep -n '^lemma NAME ' f | cut -d: -f1)
K=$(awk -v s=$S 'NR>s && /^end Op56/{print NR; exit}' f)      # upper bound, still too far
… slice S..K-1, then TRIM to the last line matching a known proof-final token,
   assert an absent sentinel, then append the namespace terminators.
```

**Three errors remain (120, 131, 191):** sites 2 and 3 (old `hX` block and `stage2_upper_exp` call) and
the tail (`stage2_upper_arith2` → `w_upper_from_exp`).

### 13.393 Round-369: sites 2 and 3 substituted — three errors

Build green: **210 declarations, 7/7 OK, 0 sorries**.

* **site 2** — the `hX` block is now the sharp **"divide `hSu` by `2n'`"** form: `h3` rewrites the LHS via
  `div_mul_eq_mul_div`, `h4` is the `K` normalisation (`field_simp; ring`), then
  `div_le_div_of_nonneg_right hSu h2.le`;
* **site 3** — the call is now
  `Op56.stage2_upper_sharp_exp (nmin p + 1) (10^18*(2*PhiC+2)/2) (by omega) w' …`.

**Three errors remain (120, 138, 194):**
* **120** — a type mismatch at the head of the new `hX` block (the substitution's target may have
  included an older text — **print it**);
* **138** — `h4`'s `field_simp; ring` leaves a goal (the familiar cast shape — `push_cast`);
* **194** — the tail, site 4 (`stage2_upper_arith2` → `w_upper_from_exp`), still to be made.

### 13.394 Round-370: `hSu` fixed by `linarith`; two errors left (`h4`, tail)

Build green: **210 declarations, 7/7 OK, 0 sorries**.

* **120 fixed** — the printed diff showed `(abs_le.mp hS).2` gives
  `u·ΦS(u) − 6log2 ≤ 10¹⁸q`, not `u·ΦS(u) ≤ 6log2 + 10¹⁸q`; one `linarith only [h]` bridges the
  rearrangement.  (Same shape as the `diff`-projection class throughout this file.)
* **site 3 substituted** (`stage2_upper_sharp_exp`) and **site 4 substituted**
  (`Op56.w_upper_from_exp … hwK (lt_trans hbridge hstep')`);
* **two errors remain (140, 198):** `h4`'s `field_simp` (now with `push_cast`) still leaves a goal, and
  the tail's application has an argument mismatch — both to be printed.

### 13.395 Round-371: the sharp tail does **not** need `hbridge`; two errors left

Build green: **210 declarations, 7/7 OK, 0 sorries**.

**Error 198's printed diff was decisive:** `hbridge` has the *crude* type
`−3/n − 10¹⁵/n² < −3/n' − 10¹⁵/n'²` (it existed only to bridge the crude `stage2_upper_exp` conclusion
across the `n → n+1` change), while the expected argument is the **sharp** form.  The sharp tail needs
**no bridge at all** — `stage2_upper_sharp_exp` already concludes at `n+1`:
`w_upper_from_exp (nmin p) w' (2PhiC+2) C … hwK hstep'` is the whole tail.

**Two errors remain (140, 178):**
* **140** — `h4`'s `field_simp; push_cast; ring` still leaves a goal;
* **178** — an application mismatch at the restructured tail (likely the `C` constant or `hwK`'s form).

**Note:** removing `hbridge` also removed `hwK`, which it depended on — restored as its own `have`.

### 13.396 Round-372: tail index corrected to `n+1`; `hwK`'s form still off

Build green: **210 declarations, 7/7 OK, 0 sorries**.

**Error 178's printed diff was exact:** `hstep'` lives at **`n+1`**
(`-(3log2/↑(nmin p + 1)) - C/↑(nmin p + 1)^2 < -2*w' + 500*w'^2`), so `w_upper_from_exp` must be called
with **`n = nmin p + 1`** and `w = w'` — not with `nmin p`.  Likewise `hwK`'s `w²` bound must be stated at
`n+1`: `w'^2 ≤ ((2PhiC+2)/↑(nmin p + 1))^2` — which is exactly `hwabs'`'s form (the caller's own bound),
so `sq_le_sq' (abs_le.mp hwabs').1 …` should give it directly.

**Three errors (140, 176, 177)** — the `hwK` restatement (176) and consequent mismatch (177), plus
`h4`'s `field_simp` (140).  **Both remaining classes are one print away.**

### 13.397 Round-373: the `w'` bound must be at `n+1`, not at `n`

Build green: **210 declarations, 7/7 OK, 0 sorries**.

**Error 176's diff names the whole issue:**

```
(abs_le.mp hwabs').left  has type   -((2*PhiC+2)/↑(nmin p))   ≤ w'
but is expected to have type        -((2*PhiC+2)/↑(nmin p+1)) ≤ w'
```

`w_upper_from_exp`'s `hw2 : w^2 ≤ (K/n)^2` ties `K` to the *same* `n` as the conclusion, so calling it at
`n+1` requires **`|w'| ≤ (2PhiC+2)/(n+1)`** — and the caller's `hwabs'` is stated at **`n`**.  Since
`n < n+1`, the `n`-bound is *weaker* and **does not imply** the `n+1` bound.

**Two resolutions, both mechanical:**
1. **preferred** — derive `|w'| ≤ (2PhiC+2)/(n+1)` from the high window (`Phi_window_high` at `n+1`),
   which is the natural source and is already in the caller's toolkit; **or**
2. call `w_upper_from_exp` with `n = nmin p` and **bridge `hstep'` from `n+1` to `n`** — reintroducing a
   bridge, which the sharp chain was meant to avoid.

**Note:** the crude `stage2_upper` avoided this by using `stage2_upper_arith2 (nmin p)` and `hbridge`;
its `hwK` is at `n` throughout.  The sharp version's conclusion at `n+1` (round 363) is what forces the
`n+1` bound.

**Also: `h4`'s goal (140) printed no `⊢` line** — the grep for it returned nothing, so it must be read
directly before adjusting.

### 13.398 Round-374: why the `n`-bound cannot be reused — and the two real options

Build green: **210 declarations, 7/7 OK, 0 sorries**.

**Reading `hwabs'`'s proof (lines 81–90) shows it is intrinsically an `n`-bound:** it combines
`hwabs : |w| ≤ (2PhiC+1)/n` with `hdiff : |p/n' − p/n| ≤ 1/n`, giving `(2PhiC+2)/n`.  There is no
`n+1` analogue available by the same route.

**And the `n`-bound cannot be transported upward:** `A(n) = 3log2/(2n) + C/n²` is *decreasing* in `n`, so
`w' < A(n)` does **not** give `w' < A(n+1)` — the direction needed.  (This is the opposite of the usual
monotonicity intuition and is worth noting: for an *upper* bound with a *decreasing* majorant, a larger
index needs a *fresh* bound.)

**So the two genuine options are:**

* **(a)** derive `|w'| ≤ (2PhiC+2)/(n+1)` from `Phi_window_high` at `n+1` (the natural source: it gives
  `|p/n' − log2| ≤ 4/n'`, and `4/n'` is comparable to `(2PhiC+2)/n'` for large `n`), then `hwK` at `n+1`
  follows and the tail is unchanged; **or**
* **(b)** restate the landed `w_upper_from_exp` with a **free** `K` (hypothesis `w² ≤ K²` instead of
  `w² ≤ (K/n)²`), which removes the index coupling entirely — the lemma only uses the bound to control
  `500w²`, so the `n` in `(K/n)²` is not essential.

**(b) is the cleaner fix and matches §13.388's lesson** (do not couple hypotheses to indices they need not
depend on): `w_upper_from_exp`'s `K` should be a free constant, exactly as `w_lower_from_exp`'s already
is.  The same change should be made to `w_lower_from_exp` for symmetry if any caller needs it.

### 13.399 Round-375: **option (b) was mis-framed** — the `n²` coupling is essential; reverted

Build green: **210 declarations, 7/7 OK, 0 sorries** (reverted intact).

**Why (b) fails:** the conclusion is `w < 3log2/(2n) + (C + 500K²)/(2n²)`, so the proof needs
`500w² ≤ 500K²/n²` — which requires `w² ≤ K²/n²`, i.e. **exactly the coupling** the option was meant to
remove.  Dropping it to `w² ≤ K²` makes the step `500K² ≤ 500K²/n²`, which is **false** for `n > 1`
(the inequality goes the other way).  §13.398's claim that "the `n` in `(K/n)²` is not essential" was
**wrong**: the `n²` in the conclusion is what makes it essential.

**So option (a) is the only route:** derive `|w'| ≤ (2PhiC+2)/(n+1)` at `n+1` — from `Phi_window_high`
at `n+1`, which is the natural source and is in the caller's toolkit — giving `hwK` at `n+1`, after which
the sharp tail applies directly.

**Reverted with `check.sh --all` green, as required.**  This is the second time in three rounds that a
proposed "simplification" was wrong on inspection (after §13.375's fallback), and both were caught by
**actually making the edit and running the build** rather than by further paper reasoning — the correct
order.

### 13.400 Round-376: locating the source of a `n+1`-indexed `w'` bound

Build green: **210 declarations, 7/7 OK, 0 sorries**.

**Read:** the caller sets `w := p/n − log2`, `w' := p/n' − log2`, and gets its `n`-indexed bound as
`have hwabs : |w| ≤ (2*PhiC+1)/(n:ℝ) := by rw [hwdef]; exact hstage1` — i.e. **from the caller's own
hypothesis `hstage1`** (a `Phi_window`-style bound at `n`).  The `n'`-indexed bound required by option (a)
must come from the corresponding **high-window** hypothesis at `n'` (in `stage2_upper` this is the
`Phi_window_high` fact, giving `|p/n' − log2| ≤ 4/n'`), which the caller already has among its
hypotheses for use at site 1.

**Next:** identify the caller's high-window hypothesis (grep the hypothesis list for the `n'`-indexed
`|p/n' − log2| ≤ 4/n'` fact), and derive

```
have hwabsN : |w'| ≤ (2*PhiC+2)/((nmin p + 1 : ℕ):ℝ)
```

from it — the `n'`-indexed analogue of `hwabs'`.  Then `hwK` at `n+1` follows by `sq_le_sq'`, and the
sharp tail applies unchanged.

### 13.401 Round-377: **the `n'`-indexed bound is derivable after all** — with a larger constant

Build green: **210 declarations, 7/7 OK, 0 sorries**.

**Reading shows the caller has no high-window hypothesis:** its only source is
`hstage1 := nmin_w_stage1 p hp hn hlarge hnK15`, giving `|w| ≤ (2PhiC+1)/n` at **`n`**.  So option (a)
must construct the `n'`-bound rather than fetch it.

**And it can, with a larger constant.**  Since `w' = w − p/(n·n')`:

* `|w| ≤ (2PhiC+1)/n`;
* `|p/(n·n')| ≤ 1/n'` (because `p ≤ n`);
* `n' ≤ 2n` implies `(2PhiC+1)/n ≤ 2(2PhiC+1)/n'`;

so `|w'| ≤ (2(2PhiC+1) + 1)/n' = (4PhiC+3)/n'`.  **That is a valid `n'`-indexed bound**, obtained without
any window hypothesis.

**Consequence for the tail:** `hwK : w'^2 ≤ ((4*PhiC+3)/(n':ℝ))^2`, and `w_upper_from_exp` is called with
`K := 4PhiC+3`, `C := 4·10¹⁰ + 10¹² + 10¹⁸(2PhiC+2)/2 + 1`.  The conclusion's `500K²` becomes
`500(4PhiC+3)²` — larger, but the statement only needs *some* explicit constant, so this is harmless.

**This resolves the index obstruction of §13.398/13.399 without a bridge.**

### 13.402 Round-377: the `n'`-bound drafted — two helpers must be added in the caller

Build green: **210 declarations, 7/7 OK, 0 sorries**.

The bound `hwabsN : |w'| ≤ (4*PhiC+3)/n'` is written, routed through
`w' = w − p/(n·n')` (`abs_sub`), `|p/(n·n')| ≤ 1/n'` (the `p ≤ n` step), and the `n' ≤ 2n` slack.  The
tail now calls `w_upper_from_exp` with `K := 4PhiC+3`, and `hwK` is restated at `n+1`.

**Five errors, two trivial:**
* **182, 188** — `hp'` and `hnd` are **not in scope** in the caller (they exist in `stage2_lower`): `hp'`
  should be `hp2`-style from `nmin_ge_p` (`p ≤ n`), and `hnd` is the `n' ≤ 2n` fact, which in this caller
  must be derived (`nmin p + 1 ≤ 2·nmin p`, from `nmin p ≥ 2` via `nmin_lt_two_p` or `push_cast`).
* **140** — `h4`'s `field_simp; push_cast; ring` (the long-standing one).
* **176, 191** — consequent mismatches.

**Fix:** add the two local facts in this caller —
`have hp' : (p:ℝ) ≤ (nmin p:ℝ) := by exact_mod_cast (nmin_ge_p p hp)` and
`have hnd : (((nmin p + 1 : ℕ)):ℝ) ≤ 2*(nmin p:ℝ) := by push_cast; linarith only [hn2]`
(with `hn2 : 2 ≤ nmin p`).  These are exactly the helper forms already used in `stage2_lower_sharp`.

### 13.403 Round-378: `hp'`/`hnd` added — four errors

Build green: **210 declarations, 7/7 OK, 0 sorries**.

Added in this caller (mirroring `stage2_lower_sharp`):
`hn2 : 2 ≤ nmin p`, `hp' : p ≤ nmin p` (from `nmin_ge_p`), and
`hnd : ↑(nmin p + 1) ≤ 2·↑(nmin p)` (by `push_cast; linarith only [hn2]`).

**Four errors remain:**
* **140** — `h4`'s identity (`field_simp; push_cast; ring`) — the long-running one;
* **181** — `h2 : |p/(n·n')| ≤ 1/n'`: the `div_le_div_iff₀` + `nlinarith` step leaves a goal.  Its content is
  `p·n' ≤ n·n'` from `p ≤ n` and `n' > 0` — **supply `hp'` explicitly and use `mul_le_mul_of_nonneg_right`**;
* **193** — a `linarith` in the `≤ (4PhiC+3)/n'` step (needs `hCpos`-based algebra);
* **196** — the consequent type mismatch.

**All four are arithmetic-shape issues in the same class**; each has a landed template (the corresponding
lines in `stage2_lower_sharp`).

### 13.404 Round-379: `push_cast`/`ring_nf` did not close `h4` or `h2`; four errors persist

Build green: **210 declarations, 7/7 OK, 0 sorries**.

**The printed residuals name the shape:**

* **140** (`h4`) — `⊢ 2·10¹⁸ + Real.log 2 * ↑(nmin p) * 6 + Real.log 2 * ↑(nmin p)^2 * 6 + ↑(nmin p) * 2·10¹⁸ + …`
  — a **polynomial goal in `↑(nmin p)`** that `ring` cannot close because `↑(nmin p) ^ 2` appears with
  both `Real.log 2` coefficients; `ring_nf` also failed.  This needs the goal **restated as an
  explicit identity in `A := (nmin p:ℝ)`** (a `set` + `ring`), or proved by `field_simp` on the *scaled*
  form.
* **181** (`h2`) — `⊢ ↑p * ↑(nmin p) - ↑(1 + nmin p) * Real.log 2 * ↑(nmin p) = …` — **`Real.log 2`
  has appeared**, which means my `h2` statement does not match what the rewrite chain produced: the goal
  is an *equality*, so a `rw` in `he`'s proof left an unfinished identity rather than the inequality.
  **Print `h2`'s exact goal in isolation.**
* **193** — `linarith` (the `≤ (4PhiC+3)/n'` step).
* **197** — the consequent mismatch.

**Note:** two of the four are now known to be **statement-shape** problems, not tactic problems (§13.350
class) — `h2`'s proof is producing an equality where an inequality was expected.  The §13.379 rule
applies: **isolate each in a standalone `example`** before another tactic change.

### 13.405 Round-380: `h2` located (not the same `h2`) — isolating next

Build green: **210 declarations, 7/7 OK, 0 sorries**.

**A `grep`-scope trap:** the caller contains **two different `h2`s** — one in the `hstage1`/`hnK15`
derivation (`(nmin p:ℝ) ≤ ↑(nmin p + 1)`), and the new one inside `hwabsN`
(`|p/(n·n')| ≤ 1/n'`).  `grep -n 'have h2 :' | head -1` returned the *first*, which is not the failing
one.  **Locate by line number from the error (181), not by grep-first.**

**Next: isolate the failing `h2` (at the line 181 site) in a standalone `example`**:

```lean
example (p : ℕ) (hn : 2000000000 ≤ nmin p) (hp' : (p:ℝ) ≤ (nmin p:ℝ)) :
    |(p:ℝ)/((nmin p :ℝ) * (((nmin p + 1 : ℕ)):ℝ))| ≤ 1/(((nmin p + 1 : ℕ)):ℝ)
```

— and prove it there (`abs_of_nonneg`, `div_le_div_iff₀`, `mul_le_mul_of_nonneg_right` from `hp'`).
Then the same for `h4` (`set A := (nmin p:ℝ)` + `ring`).  **Both are statement-shape problems and both
should be settled standalone before any further in-context edit.**

### 13.406 Round-381: **`h2` proves standalone** — so error 181 is a context/rewrite issue

Build green: **210 declarations, 7/7 OK, 0 sorries**.

The isolated `example` for the failing `h2` —

```lean
example (p : ℕ) (hn : 2000000000 ≤ nmin p) (hp' : (p:ℝ) ≤ (nmin p:ℝ)) :
    |(p:ℝ)/((nmin p :ℝ) * (((nmin p + 1 : ℕ)):ℝ))| ≤ 1/(((nmin p + 1 : ℕ)):ℝ) := by
  rw [abs_of_nonneg (by positivity)]
  rw [div_le_div_iff₀ (by positivity) hNpos]
  push_cast
  nlinarith only [hp', hnR, hNpos]
```

— **compiles with no errors.**  So the statement and tactic are right, and the failure at line 181 comes
from the **surrounding context**: specifically, the residual goal printed there was an *equality*
involving `Real.log 2`, which is the shape of `he`'s proof

```lean
have he : w' = w - (p:ℝ)/((nmin p :ℝ) * (((nmin p + 1 : ℕ)):ℝ)) := by
  rw [hwdef, hwdef']; field_simp; ring
```

— i.e. **line 181 may be inside `he`, not `h2`** (the line numbers shifted when `hn2`/`hp'`/`hnd` were
added).  **Read line 181 directly and fix `he`'s proof** (`field_simp; push_cast; ring`, or restate `he`
with `set`).

**The isolation paid off exactly as in §13.379:** one command cleared the statement and re-pointed the
diagnosis at the surrounding rewrite.

### 13.407 Round-382: error 181 was **`he`**, not `h2` — fixed by `push_cast`; three errors left

Build green: **210 declarations, 7/7 OK, 0 sorries**.

**The isolation diagnosis was right:** `h2` was already correct, and line 181 was the **`he` identity**
(`w' = w − p/(n·n')`), whose `rw [hwdef, hwdef']; field_simp; ring` left a cast-laden residual
(`↑(1 + nmin p)`).  Adding `push_cast` between `field_simp` and `ring` **closed it** — the same fix as
rounds 326, 353, and 379.

**Three errors remain (140, 197, 200):**
* **140** — `h4`'s polynomial-in-`↑(nmin p)` goal (still the `Real.log 2` coefficients); **restate with
  `set A := (nmin p:ℝ)` and `ring`**;
* **197** — the `linarith` in the `≤ (4PhiC+3)/n'` step;
* **200** — the consequent mismatch.

**Method note:** the standalone `example` for `h2` was the second time this session that isolating a step
revealed the *neighbouring* line as the true culprit (§13.379's `hX` was the first).  **When an error's
line number is adjacent to a `have`, check whether the error belongs to that `have` rather than the
next one.**

### 13.408 Round-383: `h4`'s residual is now a clean polynomial in `A` — order matters

Build green: **210 declarations, 7/7 OK, 0 sorries**.

**Two findings from the isolated `example`:**

1. **`set` must come *after* `push_cast`.**  With `set A := (nmin p:ℝ)` first, the later `push_cast`
   re-introduced a literal `↑(nmin p)` (from `↑(nmin p + 1)`), leaving a goal mixing **both** `A` and
   `↑(nmin p)` — unclosable by `ring`.  Reordering to `push_cast; set A …; field_simp; ring` gives a
   **clean polynomial in `A`**:
   `⊢ 2·10¹⁸ + Real.log 2 * A * 6 + Real.log 2 * A^2 * 6 + A * 2·10¹⁸ + …`
2. The remaining step is now a **pure polynomial identity** in one variable — `ring`/`ring_nf` territory,
   with `Real.log 2` and `PhiC` as atoms.  If plain `ring` still fails, the goal is a *difference* and
   needs `ring_nf` or a `linear_combination`-style normalisation.

**This is the third distinct fix in the `field_simp`/cast family this stretch**, and the ordering rule
(`push_cast` before `set`) is new — worth recording alongside the earlier `push_cast`-after-`field_simp`
rule.

### 13.409 Round-384: **the `hX` constant is wrong** — `K := 10¹⁸(2PhiC+2)/2` is too small

Build green: **210 declarations, 7/7 OK, 0 sorries**.

`ring_nf` did not close `h4` either, and re-deriving the step **on paper** shows why the identity is
false-shaped:

```
hSu :  u·ΦS(u) ≤ 6log2 + 10¹⁸q          with q = (2PhiC+2)/n
goal:  X = u·ΦS(u)/(2n') ≤ 3log2/n' + K/n'²
```

Dividing `hSu` by `2n'` gives `X ≤ 3log2/n' + 10¹⁸q/(2n')`, and
`10¹⁸q/(2n') = 10¹⁸(2PhiC+2)/(2·n·n')` — **a `1/(n·n')` term, not `1/n'²`**.  The goal's `K/n'²` can absorb
it only if

```
K ≥ 10¹⁸(2PhiC+2)·n'/(2n),
```

and since `n' ≤ 2n` this needs **`K ≥ 10¹⁸(2PhiC+2)`** — i.e. **twice** the value `10¹⁸(2PhiC+2)/2` I have
been using.  (Same on the lower side: `stage2_lower_sharp` used `K = 10¹⁸(2PhiC+1)/2` and survived only
because its `hSu` was at the *same* index `n`, where `n/n = 1`.)

**So the fix is a constant, not a tactic:** `K := 10¹⁸*(2*PhiC+2)` in site 2's `hX` statement (and the
corresponding `K` at site 3 need not change — `stage2_upper_sharp_exp` only consumes `hX`).

**This is the eleventh constant error caught by re-deriving on paper**, and the first in several rounds
that is genuinely mathematical rather than a tactic/scope issue.

### 13.410 Round-385: `K` corrected in both `hX` and site 3 — three errors left

Build green: **210 declarations, 7/7 OK, 0 sorries**.

* `hX`'s constant is now **`10¹⁸*(2*PhiC+2)`** (was `/2`), as §13.409 derived;
* site 3's `K` **must match it** — `stage2_upper_sharp_exp (nmin p + 1) (10^18*(2*PhiC+2)) …` — since the
  lemma rewrites the very `hX` it is given.  (Mismatched `K`s produced error 174, now resolved.)

**Three errors remain (140, 197, 201):**
* **140** — the `h4` identity, which should now be *true* with the corrected constant (the isolated
  `example` had the old `/2` value, so it must be re-run with `10¹⁸(2PhiC+2)`);
* **197** — the `linarith` in `≤ (4PhiC+3)/n'`;
* **201** — the consequent mismatch at `w_upper_from_exp` (its `C` must include the **new** `K`).

**Re-run the isolated `h4` example with the corrected constant** rather than editing in-context — the
§13.379 rule.

### 13.411 Round-386: **no constant `K` can satisfy the `/n'²` form** — the hypothesis shape is wrong

Build green: **210 declarations, 7/7 OK, 0 sorries**.

Re-running the isolated `h4` with the corrected `K = 10¹⁸(2PhiC+2)` **still fails**, and the algebra shows
why the *shape* is wrong, not just the constant.  Working with `A := (nmin p:ℝ)`:

```
LHS = (6log2 + 10¹⁸(2PhiC+2)/A)/(2(A+1)) = 3log2/(A+1) + 10¹⁸(2PhiC+2)/(2A(A+1))
RHS = 3log2/(A+1) + K/(A+1)²
```

so `h4` holds **iff `1/(2A(A+1)) = 1/(A+1)²`**, i.e. iff `A = 1` — **false for every real `nmin p` in our
range**.

**Conclusion: the landed `stage2_upper_sharp_exp`'s hypothesis `hX : X ≤ 3log2/n' + K/n'²` is not
satisfiable by any constant**, because the true bound has a `1/(n·n')` term:
`X ≤ 3log2/n' + 10¹⁸(2PhiC+2)/(2·n·n')`.

**The correct hypothesis form is a `1/n` term:**

```
hX : X ≤ 3log2/n' + K/n        -- absorbable since 1/(n·n') ≤ 1/n for n' ≥ 1
```

with `K := 10¹⁸(2PhiC+2)/2`.  Then `stage2_upper_sharp_exp`'s conclusion gains a `K/n` error, and the
tail's `C` becomes `C := 4·10¹⁰ + 10¹² + K·n` (allowed — `C` is a term in the conclusion, not a literal).

**So the landed `stage2_upper_sharp_exp` must be re-stated** (it has no callers yet — the §13.388/13.390
precedent applies), with `hX : X ≤ 3log2/n + K/n` and conclusion
`-(3log2)/n - (4·10¹⁰ + 10¹²)/n² - K/n_0 …` — the exact form to be fixed when re-deriving.

**Twelfth constant/shape error caught by paper re-derivation**, and the second in two rounds on this same
step.

### 13.412 Round-387: **`stage2_upper_sharp_exp` re-stated with a `1/n` hypothesis**; build green

Build green: **210 declarations, 7/7 OK, 0 sorries**.

New statement (replacing the unsatisfiable `/n'²` form):

```lean
lemma stage2_upper_sharp_exp (n : ℕ) (K : ℝ) (hn : 1 ≤ n) (w Y X D E : ℝ)
    (hX : X ≤ (3*Real.log 2)/(n:ℝ) + K/(n:ℝ))
    (hD : D ≤ 4*10^10) (hE : E ≤ 10^12/((n:ℝ)^2))
    (hexp : Y - 1 ≤ -2*w + 500*w^2)
    (hthird : 1 - E - X - D/((n:ℝ)^2) ≤ Y) :
    -((3*Real.log 2)/(n:ℝ)) - (4*10^10 + 10^12 + 1)/((n:ℝ)^2) - K/(n:ℝ)
      < -2*w + 500*w^2
```

with `h6a : -X ≥ -3log2/n - K/n` (a one-line `linarith` from `hX`, replacing the previous
`-X ≥ -3log2/n - K/n²`), `hs` adjusted, and strictness from the `+1` in `n²` (as in round 358).

**This makes the hypothesis satisfiable:** with `X = u·ΦS(u)/(2n')` and `u·ΦS(u) ≤ 6log2 + 10¹⁸q`,
`q = (2PhiC+2)/n`, the true bound is `X ≤ 3log2/n' + 10¹⁸(2PhiC+2)/(2·n·n') ≤ 3log2/n' + K/n'` **with
`K := 10¹⁸(2PhiC+2)/2`** — since `n ≥ 1` gives `1/(n·n') ≤ 1/n'`.

**Next (caller):** site 2's `hX` becomes `X ≤ 3log2/n' + K/n'` (a **divide-by-`2n'` step only** — the
normalisation `h4` is now the *true* identity, because the RHS has `1/n'` not `1/n'²`), site 3 passes the
matching `K`, and the tail's `C` becomes `C := 4·10¹⁰ + 10¹² + 1 + 500K²` **times `n'`** as needed by
`w_upper_from_exp`'s `C/n²` form.

### 13.413 Round-387: the caller's three edits, with the key inequality identified

Build green: **210 declarations, 7/7 OK, 0 sorries**.

**Site 2** — `hX` becomes `X ≤ 3log2/n' + K/n'` with `K := 10¹⁸(2PhiC+2)/2`.  The proof is
`X = uΦS(u)/(2n')` (`div_mul_eq_mul_div`) and `div_le_div_of_nonneg_right hSu (by positivity)`, then a
**single inequality** (no longer an equality):

```
(6log2 + 10¹⁸·(2PhiC+2)/n)/(2n')  ≤  3log2/n' + (10¹⁸(2PhiC+2)/2)/n'
```

which reduces exactly to `1/(n·n') ≤ 1/n'` — **true because `n ≥ 1`**.  This is the step that was
impossible in the `/n'²` form: the `≤` (not `=`) is what makes `K` absorb the `1/(n·n')` term, and it is
precisely the slack that disappeared when the target had `n'²`.

Concretely, after `div_le_div_of_nonneg_right` the residual is `1/n ≤ 1`, so the closing step is
`one_div_le_one_div_of_le` (or `div_le_div_of_nonneg_left` with `hn1 : 1 ≤ n`).

**Site 3** — pass the **matching** `K := 10¹⁸(2PhiC+2)/2`.

**Site 4** — `w_upper_from_exp`'s `C` must now include the `K/n'` error: since `K/n'` must be written as
`C/n'²`, take **`C := (4·10¹⁰ + 10¹² + 1)·n' + K·n'`** — allowed, because `C` is a term in the conclusion,
not a literal.

**With these three edits the caller should compile** — every remaining piece is a landed lemma plus
`1/n ≤ 1`.

### 13.414 Round-388: site-2 stub drafted (scratch only); the inequality's closing step identified

Build green: **210 declarations, 7/7 OK, 0 sorries** — **the `sorry` markers are in `/tmp/w1490.lean`
only**, never in the deliverable; `check.sh --all` is unaffected.

The site-2 rewrite is a stub with two `sorry`s, kept deliberately in the scratch.  What it establishes:

* `hX`'s statement is now the **correct** form
  `X ≤ 3log2/n' + (10¹⁸(2PhiC+2)/2)/n'`;
* `h4` is the key **inequality**
  `(6log2 + 10¹⁸(2PhiC+2)/n)/(2n') ≤ 3log2/n' + (10¹⁸(2PhiC+2)/2)/n'`, to be proved by
  `rw [div_le_iff₀ …]; rw [← sub_nonneg]` and then reducing to `1/n ≤ 1`.

**The closing step is `1/n ≤ 1`** — from `hn1 : 1 ≤ (nmin p:ℝ)` via `one_div_le_one_div_of_le` or by
`div_le_one`-style rewriting.  **One line, and the exact hypotheses are in scope (`hn1` from `omega`).**

**Note:** an accidental garbage token entered the stub during editing; since it is scratch-only and the
deliverable is untouched, this is harmless — but it is a reminder that scratch edits should be **compiled
before being described**, which is the same rule that governs pasting.

### 13.415 Round-389: caller regenerated cleanly — five errors, all localized

Build green: **210 declarations, 7/7 OK, 0 sorries**.

`/tmp/w1520.lean` is a fresh, complete regeneration of `stage2_upper_sharp` (no stubs, no stray tokens)
with all corrections: the `w'`-conclusion statement, `hPS2`/`hSu`, the `1/n'`-form `hX`, site 3 with
`K := 10¹⁸(2PhiC+2)/2`, the `hwabsN`/`hwK` block at `n+1`, and the tail with
`C := (4·10¹⁰ + 10¹² + 1) + K·n'`.

**Five errors (142, 144, 215, 220):**
* **142** — `h4`'s `rw [div_add_div …]`: pattern miss (the goal was already rearranged by the preceding
  `rw`s) — **print it**;
* **144** — `rw [← h4]` is invalid: **`h4` is now an *inequality*** (`≤`), so it must be used as a
  `linarith` hypothesis, not a rewrite.  **This is a direct consequence of the shape fix** and is the one
  structural edit remaining in site 2.
* **215** — `linarith` in `hwabsN`'s `≤ (4PhiC+3)/n'` step;
* **220** — the tail's application mismatch.

**Next: fix 144 (`linarith` instead of `rw`), then print 142 and the rest.**

### 13.416 Round-390: `h4`'s consumption fixed (`linarith`); four errors left

Build green: **210 declarations, 7/7 OK, 0 sorries**.

**Error 144 resolved** exactly as diagnosed: since `h4` is now an *inequality*, the site-2 proof uses
`h5 := div_le_div_of_nonneg_right hSu h2.le` (the `hSu` division) and then **`linarith only [h5, h4]`** —
no `rw`.

**Four errors (142, 218, 223):**
* **142** — `h4`'s **proof**: `rw [div_add_div _ _ …]` does not match (the goal's denominators are
  `2n'` and `n'`, so `div_add_div`'s pattern is wrong), and the subsequent `positivity` fails for the same
  reason.  **Print `h4`'s goal and use `field_simp` + `push_cast` + `nlinarith`** on the difference
  `10¹⁸(2PhiC+2)/n/(2n') - (10¹⁸(2PhiC+2)/2)/n' ≤ 0` — equivalently `1/(n·n') ≤ 1/n'`, i.e. `1/n ≤ 1`.
* **218** — the `linarith` in `hwabsN`'s `≤ (4PhiC+3)/n'` step;
* **223** — the tail's application mismatch (likely `hwK`'s or `C`'s form).

**Next: rewrite `h4`'s proof around the explicit `1/n ≤ 1` step.**

### 13.417 Round-391: **`h4` proved** — site 2 complete; two errors left

Build green: **210 declarations, 7/7 OK, 0 sorries**.

`h4` (the key inequality) now closes with:

```lean
have hn1 : (1:ℝ) ≤ (nmin p:ℝ) := by exact_mod_cast (by omega : 1 ≤ nmin p)
rw [div_le_iff₀ (by positivity : (0:ℝ) < 2*(((nmin p + 1 : ℕ)):ℝ))]
push_cast
field_simp
nlinarith only [hn1, hNpos, hCpos]
```

— i.e. **`push_cast` then `field_simp` then `nlinarith` with `1 ≤ n`**, which is exactly the
`1/(n·n') ≤ 1/n'` reduction.  **Site 2 is therefore complete**, and with it the whole `hX` chain: the
`1/n`-form hypothesis is satisfiable *and* satisfied.

**Two errors remain (220, 225):**
* **220** — the `linarith` in `hwabsN`'s `≤ (4PhiC+3)/n'` step (`nlinarith only [hnd, hnR, hNpos, hCpos]`);
* **225** — the tail's application mismatch.

**Both are in the `hwabsN`/tail block and both should print cleanly.**

### 13.418 Round-392: error 225 diagnosed — `hstep'` needs re-association into `C/n'²`

Build green: **210 declarations, 7/7 OK, 0 sorries**.

**225's printed type:**

```
hstep' :  -(3log2/↑(nmin p+1)) - (4·10¹⁰ + 10¹² + 1)/↑(nmin p+1)^2
            - 10¹⁸(2PhiC+2)/2 / ↑(nmin p+1)   <   -2*w' + 500*w'^2
```

while `w_upper_from_exp`'s `h` is syntactically `-3log2/n - C/n^2 < …`.  The **`-K/n'` term must be
re-written as part of the `C/n'²` term** — i.e. use `K/n' = (K·n')/n'²` — before the lemma is applied:

```lean
have hstep'' : -((3*Real.log 2)/(((nmin p + 1 : ℕ)):ℝ))
      - ((4*10^10 + 10^12 + 1) + (10^18*(2*PhiC+2)/2)*(((nmin p + 1 : ℕ)):ℝ))/((((nmin p + 1 : ℕ)):ℝ)^2)
      < -2*w' + 500*w'^2 := by
  have h : ... = ... := by field_simp; ring
  linarith only [hstep', h.le, h.ge]
```

— a pure re-association, exactly as `h4` was.  The `C` I already pass is the right value; it is the
**shape of `hstep'`** that must be normalised first.

**Error 220** (`linarith` in `hwabsN`) still to be printed properly — its context was cut off in this
output.

### 13.419 Round-393: `hstep''` re-association added; two errors left

Build green: **210 declarations, 7/7 OK, 0 sorries**.

`hstep''` now rewrites `-K/n'` into `-(K·n')/n'²` (via `field_simp; ring`), so `w_upper_from_exp` receives a
syntactically matching `h`.  **The tail then reduced to a type mismatch at the outer `exact` (237)** —
likely the `hwK` form or `C`'s parenthesis.

**Error 220** (the `linarith` in `hwabsN`'s `≤ (4PhiC+3)/n'` step) **still unprinted** — its context has
been cut off twice by the `grep -A4` window.  **Print it with a wider window or by isolating the step.**

**These are the last two errors in the caller.**

### 13.420 Round-394: 220's context printed — `hnd`'s role in the `nlinarith` step

Build green: **210 declarations, 7/7 OK, 0 sorries**.

**Printed context at 220** includes `hnR`, `hCpos`, `hNpos`, `hnK15`, `hnK15'` — and the step is
`nlinarith only [hnd, hnR, hNpos, hCpos]` in

```
_ ≤ (4*PhiC+3)/((nmin p + 1 : ℕ):ℝ)
```

**The mathematics of that step:** from `(2PhiC+1)/n + 1/n' ≤ (4PhiC+3)/n'` — i.e.
`(2PhiC+1)·n' + n ≤ (4PhiC+3)·n` — which follows from **`n' ≤ 2n`** alone (no `PhiC` bound needed):
`(2PhiC+1)·2n + n = (4PhiC+3)·n` ✓.  So the `nlinarith` needs `hnd` **plus the fact that `(2PhiC+1)` is
positive** (`hCpos` gives `2PhiC+1 > 1`).

**Next: isolate this step standalone** (the §13.379 rule) — it is a pure two-variable inequality in
`PhiC, n, n'` with `n' ≤ 2n`.

**Error 237** (tail type mismatch) also remains.

### 13.421 Round-395: 220's exact step read — the `nlinarith` needs `n' ≤ 2n` and nothing else

Build green: **210 declarations, 7/7 OK, 0 sorries**.

**The step, in full:**

```lean
_ ≤ (2*PhiC+1)/(nmin p:ℝ) + 1/(((nmin p + 1 : ℕ)):ℝ) := add_le_add hwabs h2
_ ≤ (4*PhiC+3)/(((nmin p + 1 : ℕ)):ℝ) := by
  rw [div_add_div _ _ (ne_of_gt hnR) (ne_of_gt hNpos), div_le_div_iff₀ (by positivity) hNpos]
  nlinarith only [hnd, hnR, hNpos, hCpos]
```

**The inequality is true and elementary:** `(2PhiC+1)/n + 1/n' ≤ (4PhiC+3)/n'` ⟺
`(2PhiC+1)·n' + n ≤ (4PhiC+3)·n` ⟸ `n' ≤ 2n` (giving `(2PhiC+1)·2n + n = (4PhiC+3)·n` exactly ✓).

So `nlinarith` has everything it needs **in principle**; its failure means the `rw` chain produced a
goal whose normal form `nlinarith` cannot linearise — most likely because **`div_add_div` re-associated
the denominators** differently than assumed.

**Next: isolate this step in a standalone `example`** (the rule that has resolved every such case) and, if
needed, replace the `rw` chain with a direct `field_simp`-based proof of the difference.

### 13.422 Round-396: the step **fails standalone too** — so it is the proof route, not the context

Build green: **210 declarations, 7/7 OK, 0 sorries**.

The isolated `example`

```lean
example (PhiC n n' : ℝ) (hnR : 0 < n) (hNpos : 0 < n') (hC : 0 < PhiC) (hnd : n' ≤ 2*n) :
    (2*PhiC+1)/n + 1/n' ≤ (4*PhiC+3)/n' := by
  rw [div_add_div _ _ (ne_of_gt hnR) (ne_of_gt hNpos), div_le_div_iff₀ (by positivity) (by positivity)]
  nlinarith only [hnd, hnR, hNpos, hC]
```

**fails with `⊢ False`** — reproducing error 220 exactly.  So the context is fine and the **`rw` chain's
normal form is not what `nlinarith` needs.**

**The mathematical fact is certain** (`n' ≤ 2n` gives `(2PhiC+1)n' + n ≤ (4PhiC+3)n`), so this is purely a
normalisation problem.  **Recorded replacement route:**

```lean
  have h1 : (2*PhiC+1)/n ≤ 2*(2*PhiC+1)/n' := by
    rw [div_le_div_iff₀ hnR hNpos]; nlinarith only [hnd, hC]
  have h2 : (2*PhiC+1)/n + 1/n' ≤ 2*(2*PhiC+1)/n' + 1/n' := by linarith only [h1]
  have h3 : 2*(2*PhiC+1)/n' + 1/n' = (4*PhiC+3)/n' := by ring
  linarith only [h2, h3]
```

— separating the `PhiC` part (from `n' ≤ 2n`) from the `1/n'` part, which avoids the compound
denominator entirely.

### 13.423 Round-397: **replacement route worked** — the caller is at ONE error

Build green: **210 declarations, 7/7 OK, 0 sorries**.

Error 220 is resolved by separating the `PhiC` part from the `1/n'` part:

```lean
have hb1 : (2*PhiC+1)/n ≤ 2*(2*PhiC+1)/n' := by
  rw [div_le_div_iff₀ hnR hNpos]; nlinarith only [hnd, hCpos]
have hb3 : 2*(2*PhiC+1)/n' + 1/n' = (4*PhiC+3)/n' := by ring
linarith only [hb1, hb3]
```

— the compound denominator that defeated `nlinarith` never appears, because each half is a division by a
single positive quantity.

**One error remains (241): the tail's `Type mismatch`** — the last error in `stage2_upper_sharp`.
**Print it in full and fix.**

### 13.424 **LANDED (round 397): `stage2_upper_sharp`** — 211 declarations — **both sharp callers done**

`Op56/PhiThird.lean` now has **211 declarations** (0 sorries, 7/7 OK, 0 axioms), newly:

```lean
lemma stage2_upper_sharp (p : ℕ) (hp : 6 ≤ p) (hn : 2000000000 ≤ nmin p)
    (hlarge : 3*PhiC ≤ ((2*p : ℕ):ℝ))
    (hnK : 10^40 * ((2*PhiC+1)^2 + 1) ≤ (nmin p:ℝ)) :
    (p:ℝ)/(((nmin p + 1 : ℕ)):ℝ) - Real.log 2
      ≤ 3*Real.log 2/(2*(((nmin p + 1 : ℕ)):ℝ))
        + (4*10^10 + 10^12 + 1 + (10^18*(2*PhiC+2)/2)*(((nmin p + 1 : ℕ)):ℝ)
            + 500*(4*PhiC+3)^2)/(2*((((nmin p + 1 : ℕ)):ℝ)^2))
```

i.e. **`w' ≤ 3log2/(2n') + K''/n'²`** — the **sharp upper bound at `n+1`**, the mirror of the landed
`stage2_lower_sharp`.

**Together with `stage2_lower_sharp` (round 355), this gives the two-sided sharp estimate at `n'`:**

```
3log2/(2n') − K''/n'²  ≤  w'  ≤  3log2/(2n') + K''/n'²
```

— **exactly the input §13.336/13.354 identified as necessary for lemma (c)** and that §13.353 wrongly
declared unavailable.

**The final error was a statement/consumer mismatch** (241): the statement's numerator had
`(4·10¹⁰+10¹²+1)·n'` while `w_upper_from_exp` produces `(4·10¹⁰+10¹²+1) + K·n' + 500K²`; correcting the
statement and wrapping in `le_of_lt` (the lemma is strict) closed it.

### Remaining

1. **assemble `|w' − 3log2/(2n')| ≤ K/n'²`** from the two landed callers (a two-line
   `abs_sub_le_iff`-style combination);
2. **lemma (c)** — the exact identity `n' − p/log2 = −p·w'/(log2(log2 + w'))` with (1), giving
   `|n' − (p/log2 − 3/2)| ≤ K'/p`;
3. **`op5_nmin_asymptotic`** by `IsBigO`, then **OP-6**.

### 13.425 Round-398: the assembly's constant must be `PhiC`-dependent (the `hK` lesson)

Build green: **211 declarations, 7/7 OK, 0 sorries**.

**Drafting `nmin_w_sharp2`** from the two landed callers:

```
h1 := stage2_lower_sharp …   --  3log2/(2n') − K₁/n'² ≤ w'
h2 := stage2_upper_sharp …   --  w' ≤ 3log2/(2n') + K₂/n'²
goal: |w' − 3log2/(2n')| ≤ K/n'²
```

with
`K₁ = 4·10¹⁰ + 10¹² + 10¹⁸(2PhiC+1)/2 + 500(2PhiC+1)²` and
`K₂ = 4·10¹⁰ + 10¹² + 1 + (10¹⁸(2PhiC+2)/2)·n' + 500(4PhiC+3)²`.

**Neither is a numeric constant — both grow with `PhiC`.**  So **`K` cannot be a literal like `10²⁰`**:
proving `K₁ ≤ 10²⁰` needs a bound on `PhiC`, which the library does not provide (the round-364 lesson).
The assembly must therefore use a **`PhiC`-dependent explicit term**:

```
K := 4·10¹⁰ + 10¹² + 10¹⁸(2PhiC+2) + 500·(2PhiC+1)² + 500·(4PhiC+3)²
```

and the statement is `|w' − 3log2/(2n')| ≤ K/n'²` — which is all lemma (c) needs, since any *fixed*
constant works there (it feeds an `O(1/p)` estimate and `PhiC` is a fixed real per instance).

**So the assembly is:** `hL : -(K/n'²) ≤ w' − 3log2/(2n')` from `h1` and `K₁ ≤ K`; `hR : … ≤ K/n'²` from
`h2` and `K₂ ≤ K`; then `abs_le.mpr ⟨hL, hR⟩`.  The `K_i ≤ K` steps are `nlinarith` with `hCpos`.

**Next: rewrite the draft properly (no stubs) with the `PhiC`-dependent `K`.**

### 13.426 Round-399: the assembly's `K` must be **linear in `n'`** — design fixed

Build green: **211 declarations, 7/7 OK, 0 sorries**.

Checking the two requirements for `K := …·n'`:

* **lower side:** `K₁ ≤ K/n'` needs
  `4·10¹⁰+10¹²+10¹⁸(2PhiC+1)/2+500(2PhiC+1)² ≤ 4·10¹⁰+10¹²+1+10¹⁸(2PhiC+2)+500(2PhiC+1)²+500(4PhiC+3)²`
  — true, since `10¹⁸(2PhiC+1)/2 ≤ 10¹⁸(2PhiC+2)` ✓;
* **upper side:** `K₂ ≤ K` needs
  `… + (10¹⁸(2PhiC+2)/2)·n' + 500(4PhiC+3)² ≤ (… + 10¹⁸(2PhiC+2) + …)·n'`
  — true for `n' ≥ 1`, since every term with `n'` is dominated and the constant terms satisfy
  `c ≤ c·n'` ✓.

So take

```
K := ((4*10^10 + 10^12 + 1) + 10^18*(2*PhiC+2) + 500*(2*PhiC+1)^2 + 500*(4*PhiC+3)^2)
       * (((nmin p + 1 : ℕ)):ℝ)
```

and the statement is `|w' − 3log2/(2n')| ≤ K/n'²`.  **`K` is a term, not a literal** — the round-364/398
rule — and the two `K_i ≤ K` steps are `nlinarith` with `hCpos`, `n' ≥ 1`.

**This completes the design of the assembly**; it is now a finite, fully specified lemma with both
hypotheses landed.

### 13.427 Round-400 (milestone): the assembly's concrete proof script, written out

Build green: **211 declarations, 7/7 OK, 0 sorries**.

```lean
lemma nmin_w_sharp2 (p : ℕ) (hp : 6 ≤ p) (hn : 2000000000 ≤ nmin p)
    (hlarge : 3*PhiC ≤ ((2*p : ℕ):ℝ))
    (hnK : 10^40 * ((2*PhiC+1)^2 + 1) ≤ (nmin p:ℝ)) :
    |(p:ℝ)/(((nmin p + 1 : ℕ)):ℝ) - Real.log 2 - 3*Real.log 2/(2*(((nmin p + 1 : ℕ)):ℝ))|
      ≤ (((4*10^10 + 10^12 + 1) + 10^18*(2*PhiC+2) + 500*(2*PhiC+1)^2 + 500*(4*PhiC+3)^2)
          * (((nmin p + 1 : ℕ)):ℝ))/((((nmin p + 1 : ℕ)):ℝ)^2) := by
  have h1 := stage2_lower_sharp p hp hn hlarge hnK
  have h2 := stage2_upper_sharp p hp hn hlarge hnK
  have hN1 : (1:ℝ) ≤ N := …          -- N := ↑(nmin p + 1), from omega
  have hCpos : (0:ℝ) < PhiC := PhiC_pos
  rw [abs_le]
  constructor
  · -- lower:  -(K·N/N²) ≤ w' − 3log2/(2N)
    --   from h1 and K₁ ≤ K·N/N²  (K₁ as in §13.425)
  · -- upper:  w' − 3log2/(2N) ≤ K·N/N²
    --   from h2 and K₂ ≤ K·N/N²  (K₂ as in §13.425)
```

**Both remaining steps are `linarith` with a single `nlinarith` constant comparison each:** `K₁ ≤ K·N/N²`
(needs `10¹⁸(2PhiC+1)/2 ≤ 10¹⁸(2PhiC+2)` and `n' ≥ 1`) and `K₂ ≤ K·N/N²` (needs the `n'`-weighted terms
dominated, `n' ≥ 1`).

**Everything is now specified**: hypotheses landed (`stage2_lower_sharp`, `stage2_upper_sharp`), the
combining constant designed and both comparisons verified on paper (§13.426), and the proof skeleton
above.  **This is a single-lemma task with no remaining design decisions.**

### 13.428 Round-401: assembly written — down to two `linarith` steps

Build green: **211 declarations, 7/7 OK, 0 sorries**.

**The simplification that removed four errors:** the goal is
`-(K·N/N²) ≤ w' − 3log2/(2N)`, and since `K·N/N² = K/N`, the needed comparison is simply
**`K₁ ≤ K·N`** (and `K₂ ≤ K·N`) — no multiply-back, no `div_mul_cancel₀`.  The `hdiv` identity
(`(K·N)/N² = K/N` by `field_simp`) then lets `linarith` combine with `h1`/`h2`.

**Two errors remain (34, 48)** — the two `linarith only [h1, hK1, hNpos]` /
`linarith only [h2, hK2, hNpos]` steps.  Both should follow from
`h1 : 3log2/(2N) − K₁/N² ≤ w'` plus `K₁ ≤ K·N` and `N > 0`, giving
`w' − 3log2/(2N) ≥ −K₁/N² ≥ −K/N` — **a pure `linarith` rearrangement**; print the goals if it resists.

**Two `linarith` steps from landing the assembly.**

### 13.429 Round-402: 34's `linarith` — the hypothesis text needs reading in full

Build green: **211 declarations, 7/7 OK, 0 sorries**.

The printed context shows `h1`, `hK1`, `hdiv` present and `⊢ False` — i.e. `linarith` searched for a
contradiction and failed.  The grep window again truncated the hypothesis **types**, which is what
matters here.

**Recorded reading:** print `h1`'s and `hK1`'s **types** (not names) — e.g. by
`have hh := h1; have hk := hK1` with `trace_state`, or by reading the full `sed` range without grep.

**The expected shape** is
`h1 : 3log2/(2N) − K₁/N² ≤ w'` and `hK1 : K₁ ≤ K·N`, with goal `−(K·N/N²) ≤ w' − 3log2/(2N)`.  If
`h1`'s minorant is written with `N²` in a different association (e.g. `(N^2)⁻¹` vs `/N^2`), the
`linarith` cannot see it; supplying `K₁/N² = K₁ * (N^2)⁻¹`-style identities explicitly will fix it.

### 13.430 Round-403: `hKN` added; the trailing `linarith` still resists

Build green: **211 declarations, 7/7 OK, 0 sorries**.

**Reading 34's negation in full gave the exact goal:**
`p/N − log2 − 3log2/(2N) < −(K/N)`, i.e. `linarith` must derive `K/N ≥ K₁/N²` from `h1` (which says
`3log2/(2N) − K₁/N² ≤ w'`).  So an explicit `hKN : K₁/N² ≤ K/N` was added, proved by
`div_le_div_iff₀` + `nlinarith only [hK1]`.

**Two `linarith` errors remain (39, 53)** — the steps that combine `h1`/`h2` with `hKN`.  Since the
division comparison is now a *hypothesis*, the remaining failure must be an **association difference**:
`h1`'s minorant likely reads `3log2/(2N) − K₁/N²` while the goal needs `−(K₁/N²)` moved across — a
one-line `linarith` in principle.

**Next: print 39's full context and check whether `h1`'s and `hKN`'s terms share the same syntactic
shape** (the `div_mul_eq_mul_div`/`inv` question that has recurred throughout).

### 13.431 Round-404: **the two callers act at different indices** — `w` at `n` vs `w'` at `n+1`

Build green: **211 declarations, 7/7 OK, 0 sorries**.

**Printing `h1`'s type resolves the mystery:**

```
h1 : 3log2/(2·↑(nmin p)) − K₁/(2·↑(nmin p)^2) ≤ p/↑(nmin p) − log2
```

— i.e. **`stage2_lower_sharp` concludes about `w` at `n`, not about `w'` at `n+1`.**  (It follows
`stage2_lower`, whose expansion is at `n` because the threshold fact `nmin_Phi_lt` lives there.)
Meanwhile `stage2_upper_sharp` concludes about `w'` at `n+1`.

**So the two landed callers cannot be combined directly**, and the lower bound on `w'` obtainable from
`h1` via `w' = w − p/(n·n')` is only `3log2/(2n') + 3log2/(2n·n') − 1/n' − K/n²` — **an `O(1/n)`
bound, not `O(1/n'²)`**, because of the `−1/n'` term.

**Consequence: a `stage2_lower_sharp'` at `n+1` is needed** — i.e. `stage2_lower`'s chain re-run with
the threshold fact at `n+1`.  But `nmin_Phi_lt` gives `Φ_p(n) < 1` **at `n`**; at `n+1` we only have
`Φ_p(n+1) ≥ 1` (`nmin_Phi_ge`), which yields an **upper** bound on `w'`, not a lower one.

**This is the same obstruction §13.353 identified and §13.354/§13.376 thought resolved — it is not
resolved.**  `|w' − 3log2/(2n')| ≤ K/n'²` needs a *two-sided* threshold fact at `n+1`, and only one side
exists there.

**Next: re-examine whether `op5_nmin_asymptotic` truly needs the two-sided `w'` bound** — perhaps the
exact identity of lemma (c) can be run at `n` (where `w` *is* two-sided via `stage2_lower_sharp` and
`stage2_upper_sharp`-at-`n`-analogue), which would sidestep the index mismatch.

### 13.432 Round-404: what is actually available, at each index

Build green: **211 declarations, 7/7 OK, 0 sorries**.

Enumerating the landed threshold facts and their indices:

| index | fact | consequence |
|---|---|---|
| `n` | `nmin_Phi_lt : Φ_p(n) < 1` | **lower** bound on `w` (via `stage2_lower_sharp`): `w ≥ 3log2/(2n) − K/n²` |
| `n+1` | `nmin_Phi_ge : 1 ≤ Φ_p(n+1)` | **upper** bound on `w'` (via `stage2_upper_sharp`): `w' ≤ 3log2/(2n') + K/n'²` |

**Both landed sharp callers are therefore one-sided, and their sides are *opposite* relative to the
`3log2/(2x)` profiles** (lower at `n`, upper at `n'`).  To conclude `w' = 3log2/(2n') + O(1/n'²)` one
needs the **lower** bound at `n'`, which requires `Φ_p(n') < 1 + ε` — an *upper* threshold fact at `n'`
that does not follow from `Φ_p(n) < 1` without a quantitative `Φ`-difference bound.

**And the length-monotonicity route does not give it:** from `1 ≤ Φ_p(n')` and `Φ_p(n) < 1`,
`Φ_p(n') − Φ_p(n) > 0`, and the third-order expansion yields
`−2(w' − w) + O(1/n²) > −O(1/n³)`, i.e. `w' − w < O(1/n²)` — but `w' − w = −p/(n·n') ≈ −log2/n`, so this
is **trivially true and carries no information** (the quadratic term `500(w'² − w²)` is of the same
`1/n²` order as the signal).

**So the honest position is: `n' = p/log2 − 3/2 + O(1/p)` requires a two-sided `w'` estimate, only the
upper half is landed, and the lower half needs either (a) a quantitative `Φ`-difference bound between
`n` and `n+1`, or (b) the sharper `nmin_Phi_ge`-based chain re-run at `n+1` with an *upper* threshold
fact.**  Neither is currently available.

**Next: check whether the library already has a quantitative `Φ`-difference/monotonicity lemma** (grep
for `Phi_mono_n`'s neighbourhood and any `Φ`-Lipschitz statement) — if not, this is the genuine remaining
mathematical input.

### 13.433 Round-405: **no quantitative `Φ`-difference lemma exists** — and the obvious one is too weak

Build green: **211 declarations, 7/7 OK, 0 sorries**.

**Grep result:** the file has 20 `Phi` lemmas, and the only monotonicity statement is
`Phi_mono_n (hp : 1 < p) (hn : 1 ≤ n) (hnm : n ≤ m) : Phi p n ≤ Phi p m` — **qualitative**.  There is no
`Phi`-difference or Lipschitz lemma.

**Deriving one from `Phi_third_order` at both indices:** with `M` the third-order main term,
`|Φ_p(x) − M(x)| ≤ C/x³`, so `Φ_p(n') − Φ_p(n) = M(n') − M(n) + O(1/n³)`, and
`M(n') − M(n) = −2(w' − w) + 500(w'² − w²) + O(1/n²)`.  Since `w' − w = −p/(n·n') ≈ −log2/n`, the
**leading term is `+2log2/n` — of order `1/n`, not `1/n²`.**

**So the difference bound is `O(1/n)`, and feeding it into the threshold chain gives the lower bound
`w' ≥ 3log2/(2n') − O(1/n)` — an `O(1/n)` error, not `O(1/n'²)`.**  The target
`n' = p/log2 − 3/2 + O(1/p)` needs `O(1/n'²)`.

**Conclusion: neither (a) an upper threshold fact at `n+1` nor (b) a `Φ`-difference bound suffices.**
The `O(1/n'²)` lower bound on `w'` requires an input that is **strictly finer than the difference
between consecutive `Φ` values** — because the consecutive difference itself is `O(1/n)`.

**What would suffice:** a **two-sided threshold statement** at `n'` — e.g. `Φ_p(n') ≤ 1 + O(1/n'²)` —
which is exactly the kind of statement the crude `Phi_asymptotic_explicit` (`|Φ − (e^u−1)^{-1}| ≤ PhiC/n`)
cannot give either.

**Next: reassess whether `op5_nmin_asymptotic`'s `=O[atTop] (1/p)` can be proved from the *one-sided*
upper bound alone by a different route** — e.g. bounding `nmin p` from above using `Φ_p(nmin p) < 1`
together with the **exact** invertibility of the `n ↦ Φ_p` crossing (a `Nat`-induction/minimality
argument), rather than an analytic two-sided estimate.

### 13.434 Round-406: **the upper bound on `nmin p` may be available after all — at the right order**

Build green: **211 declarations, 7/7 OK, 0 sorries**.

**Re-examining the goal vs what the low window gives.**  The goal is
`|nmin p − (p/log2 − 5/2)| ≤ K/p`, i.e. an **upper** bound on `n = nmin p`.  The low window at `n`
(where `nmin_Phi_lt` gives `Φ_p(n) < 1`) yields `w > 3log2/(2n) − 10¹⁹/n²`, hence

```
n < p/(log2 + 3log2/(2n) − 10¹⁹/n²).
```

**Crucially the next-order term is `O(1/n)`, and `n ≈ p/log2` makes `O(1/n) = O(1/p)` — the same
order as the goal's tolerance.**  Expanding:

```
n < p/log2 · (1 − (3log2/(2n))/log2 + ...) = p/log2 − 3/2 + 9p/(4n²)·... + O(1/n²),
```

with `9p/(4n²) ≈ 9log2/(4n) = O(1/n)`.  So `n ≤ p/log2 − 3/2 + C/n + O(1/n²)`, and since
`1/n ≤ log2/(p − ...)`, this is `n ≤ p/log2 − 3/2 + C'/p` — **`O(1/p)`, exactly the goal's error**.

**The `−3/2` vs `−5/2` reconciliation:** the low window is applied at `n` and the *crossing point* of
`Φ_p(x) = 1` sits at `x* ≈ p/log2 − 3/2`, with `n = x* − 1 + O(1)`.  The `−1` is absorbed by the `O(1/p)`
slack as long as the constant `C'` allows it — but **the `−1` is `O(1)`, not `O(1/p)`**, so the statement
`n ≤ p/log2 − 5/2 + O(1/p)` needs the bound at `x*` itself, i.e. `n + 1`.

**Conclusion: run the low-window argument at `n+1`** — where `Φ_p(n+1) ≥ 1` is *false* — **or accept
`n ≤ p/log2 − 3/2 + C/p` and re-derive `nminAsym`'s constant from that.**  The second is the practical
route: combine the upper bound at `n` (this round) with the **landed upper bound on `w'`** to get both
sides at the same index.

**Next: write the upper bound `n ≤ p/log2 − 3/2 + C/p` from the low window, and check numerically
against `nmin p ≈ p/log2 − 5/2`.**

### 13.435 Round-407: **numerics confirm `−5/2` — and expose a coefficient discrepancy in my expansion**

Build green: **211 declarations, 7/7 OK, 0 sorries**.

**Direct computation of `nmin p`** (summing `Φ_p(n)` until the first `n` with `Φ_p(n+1) ≥ 1`):

| `p` | `nmin p` | `nmin p − p/log2` | `nmin p + 1 − p/log2` |
|---|---|---|---|
| 24 | 33 | **−1.625** | −0.625 |
| 48 | 67 | **−2.249** | −1.249 |
| 96 | 136 | **−2.499** | −1.499 |

**So `nmin p → p/log2 − 5/2` and `n' = nmin p + 1 → p/log2 − 3/2` — both confirmed**, and
`nminAsym p = p/log2 − 5/2` is the right constant.  (Also `nmin p + 1 − p/log2 → −1.5`, matching the
crossing at `−3/2`.)

**But my low-window expansion predicted `n < p/log2 − 2.16` (i.e. `−3/(2log2)`), a bound that *holds*
(`−2.5 < −2.16`) yet is too weak** — it leaves a gap of `0.34` and cannot give `O(1/p)`.

**Worse, the same discrepancy appears in the analytic model:** with
`Φ ≈ (e^u−1)^{-1} + u·ΦS(u)/(2n) + D/n²`, `exp_threshold_linear` gives `(e^u−1)^{-1} ≈ 1 − 2w`, so at the
crossing `Φ = 1` one gets `2w ≈ u·ΦS(u)/(2n)`, i.e. `w ≈ 3log2/(2n)` if `uΦS(u) ≈ 6log2` — predicting
`nmin p − p/log2 ≈ −3/(2log2) = −2.16`, **not `−2.5`**.

**So either `u·ΦS(u)` at the crossing is larger than `6log2`, or the `D/n²` term is not `O(1/n²)`.**  The
numerics say the total second-order coefficient is `2.5log2`, not `1.5log2`.

**Next: evaluate `u·ΦS(u)` and `D` at the crossing numerically** (with `u = p/nmin p`) to locate the
missing `log2` coefficient — this decides whether `stage2_lower_sharp`'s leading constant (`3log2/2`) is
simply too small, which would explain the `O(1)` gap directly.

### 13.436 Round-408: numeric script has a bug — `PhiS` under-counts by ≈3×

Build green: **211 declarations, 7/7 OK, 0 sorries**.

**`PhiS`'s definition confirmed:** `PhiS u = ∑' k, (k:ℝ)^2 * Real.exp (-(u * (k:ℝ)))` (from
`Op56/PhiAsymptotic.lean:841`) — i.e. `Σ_{k≥1} k² e^{−uk} = x(1+x)/(1-x)³` with `x = e^{−u}`.

**My python loop gave `u·ΦS(u) ≈ 1.32–1.36` at `u ≈ 0.71`**, implying `ΦS(u) ≈ 1.85` — but the closed form
gives `ΦS(0.71) ≈ 5.6` (and `ΦS(log2) = 6` exactly).  **So the loop under-counts by roughly 3×** — the
script's early-break condition is wrong (it stops while the *last added* term is small, but the term
index and the exponent are not advancing as intended).

**Sanity check on the missing coefficient:** with `ΦS ≈ 5.6`, one gets `u·ΦS(u) ≈ 4`, so
`X = uΦS/(2n) ≈ 2/n`, `n·X ≈ 2` — and the crossing condition `2w ≈ X` gives `n·w ≈ 1`, i.e.
`w ≈ 1/n`, hence `nmin p ≈ p/log2 − 1` ✗ — **still not `−2.5`**.  With `ΦS(log2) = 6`,
`uΦS ≈ 4.16`, `n·X ≈ 2.08`, `n·w ≈ 1.04` → `w ≈ 1.04/n`, `nmin ≈ p/log2 − 1.04`.

**So the model `2w = X` predicts ≈ `−1` to `−1.2`, while the true value is `−2.5`** — the discrepancy is
not in `ΦS`'s value but in **the crossing equation itself**, most likely because
`exp_threshold_linear`'s quadratic term `500w²` and the `D/n²` term contribute at the **same `1/n`
order** once `w = O(1/n)`.

**Next: fix the loop (use the closed form `x(1+x)/(1-x)^3` to avoid summation bugs) and re-check the
crossing equation term by term** — including `500w²` (which is `500·(1/n)²`, genuinely `O(1/n²)`) and
`D/n²`.

### 13.437 Round-409: **the crossing balances — my previous check used the BOUND, not the VALUE**

Build green: **211 declarations, 7/7 OK, 0 sorries**.

Using the closed forms (`ΦS(u) = x(1+x)/(1−x)³` etc., `x = e^{−u}`) and the **true** `Y = (e^u−1)^{−1}`:

| `p` | `n` | `(Y−1) + X + D/n²` | `n·w` | `u·ΦS(u)` |
|---|---|---|---|---|
| 24 | 33 | ≈ 0 | 1.126 | 3.777 |
| 48 | 67 | ≈ 0 | 1.559 | 3.893 |
| 96 | 136 | ≈ 0 | 1.732 | 4.010 |

**The crossing equation balances to numerical precision.**  The previous round's apparent
"`−2w + 500w²` ≫ `X + D/n²`" was my error: **`exp_threshold_linear` gives the *bound*
`|Y − 1 + 2w| ≤ 500w²`, and I substituted the bound (`500w²`) for the value** (`3w²`, from the exact
`1/(1+2w+w²+…)` expansion).  With the value, the equation closes.

**And `n·w → log2·2.5 = 1.733`** (the `p = 96` value is `1.732`), consistent with
`nmin p → p/log2 − 5/2`.  Meanwhile `u·ΦS(u) → 6log2 = 4.159` ✓ (the values approach it from below),
so `n·X = uΦS(u)/2 → 3log2/2 = 2.08` — while `n·(−2w) = −3.47`.  The balance `−3.47 + 2.08 + n·D = −1.4`
**does not close**, so `D/n²` must carry `≈ 1.4/n` — i.e. **`D = O(n)`, not `O(1)`**, contrary to the
`hD : -(4·10¹⁰) ≤ D` hypothesis in `stage2_lower_sharp`/`stage2_upper_sharp`.

**Next: evaluate `D = −(u/3)ΦK3u + (u²/8)ΦK4u` numerically at the crossing** and compare with `4·10¹⁰`'s
role — this decides whether the `D` term is genuinely `O(1)` (as the landed lemmas assume) or grows.

### 13.438 Round-410: **RESOLUTION — `O(1/n)` and `O(1/p)` are the same order; the obstruction dissolves**

Build green: **211 declarations, 7/7 OK, 0 sorries**.

**Numerics (closed forms, true `Y`):**

| `p` | `n = nmin p` | `(Y−1)+X+D` | `n·w` | `u·ΦS(u)` | `n·X` | `n·D` |
|---|---|---|---|---|---|---|
| 24 | 33 | −5.3e−3 | 1.126 | 3.777 | 1.889 | 0.079 |
| 48 | 67 | −1.5e−2 | 1.559 | 3.893 | 1.946 | 0.041 |
| 96 | 136 | −1.0e−2 | **1.732** | **4.010** | 2.005 | 0.021 |

* `n·w → 2.5·log2 = 1.733` ✓ — confirming `nmin p = p/log2 − 5/2 + O(1/p)` with the **correct** constant;
* `u·ΦS(u) → 6log2 = 4.159` ✓ (approached from below) — consistent with `ΦS(log2) = 6`;
* `X = uΦS(u)/(2n) → 3log2/(2n)`, so at the crossing (`n+1`) one has `2w' ≈ X + D`, giving
  `w' ≈ 3log2/(2n')` **and** `w = w' + p/(n·n') ≈ 3log2/(2n') + log2/n' = 5log2/(2n)` ✓ — matching
  `n·w → 1.733`.  **The model is fully consistent.**

**The decisive observation:** the lower bound available from `stage2_lower_sharp` **at `n`** is

```
w' ≥ 3log2/(2n') + 3log2/(2n·n') − 1/n' − K/n²  =  3log2/(2n') + (3log2/2 − 1)/n' − K/n²,
```

and `3log2/2 − 1 = 1.0397 − 1 = 0.0397 > 0`.  So **`w' ≥ 3log2/(2n') − O(1/n)`** — an `O(1/n)` error.

**And `O(1/n) = O(1/p)`**, since `n ≈ p/log2`.  **The goal's tolerance is `O(1/p)`.  Therefore the
`O(1/n)` lower bound SUFFICES**, and no two-sided `w'` estimate at `n+1` is needed at all.

**This dissolves the §13.353/13.376/13.404/13.431 obstruction.**  The error term I spent a hundred rounds
trying to remove is already the right *order*; only the constant differs, and the constant is free.

### 13.439 Round-411: the final assembly plan at `O(1/n)` precision — both directions

Build green: **211 declarations, 7/7 OK, 0 sorries**.

Write `n = nmin p`, `n' = n + 1`, `L = log 2`, `w = p/n − L`, `w' = p/n' − L`.

**Lower bound on `n'`** (from `stage2_upper_sharp`, which is *already* stated at `n'`):
`w' ≤ 3L/(2n') + K₂/n'²` ⟹ `p/n' ≤ L + 3L/(2n') + K₂/n'²` ⟹
`n' ≥ p/(L + 3L/(2n') + K₂/n'²) = p/L − 3/2 − O(1/n)`.  ✓ (a lower bound)

**Upper bound on `n'`** (from `stage2_lower_sharp` at `n`, plus `w' = w − p/(n·n')`):
`w ≥ 3L/(2n) − K₁/n²` and `3L/(2n) = 3L/(2n') + 3L/(2n·n')` give

```
w' ≥ 3L/(2n') + (3L/2 − p/n)/n' − K₁/n²,
```

and `p/n = L + w` with `w = O(1/n)` makes `3L/2 − p/n = L/2 − w ≥ L/4` for large `n` — **positive** —
so `w' ≥ 3L/(2n') + L/(4n') − K₁/n²`.  Then `n' ≤ p/(L + w')` ⟹
`n' ≤ p/L − 3/2 + O(1/n)`.  ✓ (an upper bound)

**Both errors are `O(1/n)`**, and with `n ≈ p/L` that is `O(1/p)` — **exactly the goal's tolerance for
`op5_nmin_asymptotic`'s `=O[atTop] (1/p)`**.

**So the two landed callers suffice as stated**, with no re-indexing and no two-sided `w'` estimate:
`stage2_upper_sharp` gives the lower bound on `n'` directly, and `stage2_lower_sharp` (at `n`) gives the
upper bound on `n'` via the `L/4` slack.

**Next: write this as a single lemma `nmin_pow_bound : |n' − (p/L − 3/2)| ≤ C/n`** (hence `≤ C·L/p`),
using the two landed callers and the `p/n = L + w` identity.

### 13.440 Round-411: `nmin_pow_bound` — the exact step list

Build green: **211 declarations, 7/7 OK, 0 sorries**.

```lean
lemma nmin_pow_bound (p : ℕ) (hp : 6 ≤ p) (hn : 2000000000 ≤ nmin p)
    (hlarge : 3*PhiC ≤ ((2*p : ℕ):ℝ))
    (hnK : 10^40 * ((2*PhiC+1)^2 + 1) ≤ (nmin p:ℝ)) :
    |(((nmin p + 1 : ℕ)):ℝ) - ((p:ℝ)/Real.log 2 - 3/2)| ≤ C/(nmin p:ℝ)
```
with `C` a `PhiC`-dependent explicit term (per §13.398/13.425 — never a bare literal).

**Steps:**

1. `h1 := stage2_lower_sharp p hp hn hlarge hnK` — `3L/(2n) − K₁/n² ≤ w`;
2. `h2 := stage2_upper_sharp p hp hn hlarge hnK` — `w' ≤ 3L/(2n') + K₂/n'²`;
3. `hw' : w' = w − p/(n·n')` (from `w = p/n − L`, `w' = p/n' − L`);
4. lower for `w'`: `w' ≥ 3L/(2n) − K₁/n² − p/(n·n')`;
5. `h3 : 3L/(2n) = 3L/(2n') + 3L/(2n·n')`, so
   `w' ≥ 3L/(2n') + (3L/2 − p/n)/n' − K₁/n²`;
6. `h4 : 3L/2 − p/n ≥ L/4` — needs `p/n ≤ 5L/4`, i.e. `w ≤ L/4`, from `nmin_w_sharp` (`|w| ≤ 4/n`
   gives `w ≤ 4/n ≤ L/4` for `n ≥ 16/L`), hence
   `w' ≥ 3L/(2n') + L/(4n') − K₁/n²`;
7. **upper bound on `n'`:** `n' = p/(L + w')`, so
   `n' ≤ p/(L + 3L/(2n') + L/(4n') − K₁/n²)`, and since `n' ≥ n`, the denominator is
   `≥ L + 7L/(8n) − K₁/n²`; expanding, `n' ≤ p/L − 3/2 + C/n`;
8. **lower bound on `n'`:** from (2), `n' ≥ p/(L + 3L/(2n') + K₂/n'²)`, expanding with `n' ≥ n`:
   `n' ≥ p/L − 3/2 − C'/n`;
9. combine: `|n' − (p/L − 3/2)| ≤ C''/n`.

**Every input is landed** (`stage2_lower_sharp`, `stage2_upper_sharp`, `nmin_w_sharp`,
`nmin_ge_p`).  Steps 7–8 are the arithmetic cores; each is a `div_le_div` + `nlinarith` with the
denominator bounded below by `L/2` (positive).

**Next: code steps 1–6 first (the `w'` bounds), compile, then steps 7–9.**

### 13.441 Round-412: coding approach for the `w'` bounds (steps 1–6)

Build green: **211 declarations, 7/7 OK, 0 sorries**.

**Rather than one lemma with a long conjunction, the `w'` bounds go in two small lemmas** (the §13.238
rule — one small piece, one landing):

```lean
-- (i) lower bound on w'
lemma nmin_wp_lower (p : ℕ) (hp : 6 ≤ p) (hn : 2000000000 ≤ nmin p)
    (hlarge : 3*PhiC ≤ ((2*p : ℕ):ℝ))
    (hnK : 10^40 * ((2*PhiC+1)^2 + 1) ≤ (nmin p:ℝ)) :
    3*Real.log 2/(2*N) - C₁/((nmin p:ℝ)^2) ≤ p/N - Real.log 2

-- (ii) upper bound on w'  (already landed as stage2_upper_sharp)
```

**Key point: (ii) is `stage2_upper_sharp` verbatim** — so only **(i)** is new, and its proof is exactly
steps 1–6 of §13.440.  Its structure:

* `h1 := stage2_lower_sharp …` (lower bound on `w` at `n`);
* `hw' : p/n' − L = (p/n − L) − p/(n·n')`;
* `h3 : 3L/(2n) = 3L/(2n') + 3L/(2n·n')`;
* `h4 : 3L/2 − p/n ≥ L/4` from `nmin_w_sharp` (`|w| ≤ 4/n`) and `n ≥ 16/L`;
* combine with `linarith`.

**`C₁` must be `PhiC`-dependent and multiplied by `n'`** (since the combination produces a `1/(n·n')`
term that must be dominated by `C₁/n'²`) — exactly as in `stage2_upper_sharp`'s constant, §13.426.

**Next: write `nmin_wp_lower` in the scratch (single lemma, no conjunction), compile, then land.**

### 13.442 Round-413: `nmin_wp_lower`'s proof skeleton, written out for coding

Build green: **211 declarations, 7/7 OK, 0 sorries**.

```lean
lemma nmin_wp_lower (p : ℕ) (hp : 6 ≤ p) (hn : 2000000000 ≤ nmin p)
    (hlarge : 3*PhiC ≤ ((2*p : ℕ):ℝ))
    (hnK : 10^40 * ((2*PhiC+1)^2 + 1) ≤ (nmin p:ℝ)) :
    3*Real.log 2/(2*N)
      - C₁*N/(N^2)                     -- N := ↑(nmin p + 1)
      ≤ (p:ℝ)/N - Real.log 2 := by
  have h1 := stage2_lower_sharp p hp hn hlarge hnK
  -- abbreviations: n := ↑(nmin p), N := ↑(nmin p + 1), hNn : N = n + 1
  have hw' : (p:ℝ)/N - Real.log 2 = ((p:ℝ)/n - Real.log 2) - (p:ℝ)/(n*N) := by
    rw [hNn]; field_simp; ring
  have h3 : 3*Real.log 2/(2*n) = 3*Real.log 2/(2*N) + 3*Real.log 2/(2*(n*N)) := by
    rw [hNn]; field_simp; ring
  have h4 : Real.log 2/4 ≤ 3*Real.log 2/2 - (p:ℝ)/n := by
    -- from nmin_w_sharp : |w| ≤ 4/n  ⟹  p/n ≤ L + 4/n ≤ 5L/4  (n ≥ 16/L)
    sorry_placeholder
  -- combine: w' ≥ 3L/(2N) + (L/4)/N − K₁/n², then dominate 1/(n·N) terms by C₁·N/N²
```

**`C₁ := 10²⁰ + 10¹⁸(2PhiC+2) + 500(2PhiC+1)²`** — `PhiC`-dependent, **multiplied by `N`** in the
statement so the `1/(n·N)` and `1/n²` terms are absorbed by `C₁·N/N² ≥ C₁/(n·N)` (using `n ≤ N`).

**Step `h4` is the only place needing `nmin_w_sharp`** (the crude `|w| ≤ 4/n`), and it requires
`n ≥ 16/log2` — available from `hn : 2000000000 ≤ nmin p`.

**The placeholder `sorry_placeholder` above is NOT to be pasted** — it marks the one sub-step still to be
written (bounding `p/n` by `L + 5L/4`).  The scratch must compile clean before pasting (§13.359).

**Next: write it in the scratch with `h4` completed.**

### 13.443 Round-414: `nmin_w_sharp`'s signature checked; `h4`'s derivation written out

Build green: **211 declarations, 7/7 OK, 0 sorries**.

**`nmin_w_sharp`** has the form needed for `h4`:
`nmin_w_sharp (p : ℕ) (hp : 6 ≤ p) (hn : 2000000000 ≤ nmin p) (hlarge : …) (hnK : …) :
  |(p:ℝ)/(nmin p:ℝ) − Real.log 2| ≤ 4/(nmin p:ℝ)`
— i.e. **directly `|w| ≤ 4/n`**, which is exactly what `h4` consumes.

**`h4`'s derivation** (`L/4 ≤ 3L/2 − p/n`), in full:

* from `(abs_le.mp hwsh).2`: `p/n − L ≤ 4/n`, so `p/n ≤ L + 4/n`;
* so `3L/2 − p/n ≥ 3L/2 − L − 4/n = L/2 − 4/n`;
* and `L/2 − 4/n ≥ L/4` **iff `4/n ≤ L/4`, i.e. `n ≥ 16/L`** — which holds since
  `n ≥ 2·10⁹` and `16/L ≈ 23.1`.

So `h4` reduces to `n ≥ 16/log2`, discharged by `norm_num` + `hnR`.  **No new mathematics** — just the
`n ≥ 16/L` numeric step, which is the one place the magnitude hypothesis `hn : 2000000000 ≤ nmin p` is
used.

**Next: write the lemma with `h4` closed by that numeric step, then the `linarith` combination.**

### 13.444 Round-415: `nmin_wp_lower` written — four errors, all localized

Build green: **211 declarations, 7/7 OK, 0 sorries**.

The lemma is written in `/tmp/w1560.lean` with the full skeleton: `h1 := stage2_lower_sharp`, the
definitions `n := ↑(nmin p)`, `N := ↑(nmin p + 1)` with `hNn : N = n + 1` (`push_cast; ring`), `h4` from
`nmin_w_sharp` (with the `n ≥ 16/log2` numeric step via `Real.log_two_gt_d9`), `hw'` and `h3` (the two
`field_simp; ring` identities), `hnN : n ≤ N`, `hK1` (the constant comparison), and the final `nlinarith`
with the `hK1` normalisation.

**Fix applied:** `rw [← hn'] at hwsh` (the `set` gives `hn' : n = ↑(nmin p)`, so the rewrite must go the
**other** way to replace `↑(nmin p)` by `n`).

**Four errors remain (32, 41, 46, 47):**
* **32** — the `linarith` in the `hn16` numeric step (`16 ≤ n·log2`);
* **41** — `No goals to be solved` (a closing tactic in one of the `field_simp; ring` identities ran
  past the goal);
* **46** — the `nlinarith` in `hK1`;
* **47** — a `rw [div_mul_cancel₀ …]` pattern miss (the `hK1` LHS is `K₁ ≤ C·N`, and dividing both sides
  by `N` needs the RHS shape `C·N/N`).

**Next: work them one at a time, printing first.**

### 13.445 Round-416: error 32 fixed by `exact_mod_cast`; three errors left

Build green: **211 declarations, 7/7 OK, 0 sorries**.

**The printed context named it immediately:** `hn : 2000000000 ≤ nmin p` is a **`ℕ` proposition**, so
`linarith` cannot coerce it to `ℝ` (this is the same class as `hp'`/`hn2` in the caller, round 379).
Fix:

```lean
have hnR2 : (2000000000:ℝ) ≤ (nmin p:ℝ) := by exact_mod_cast hn
nlinarith only [hnR2, hgt]
```

**Three errors remain (42, 47, 48):**
* **42** — `No goals to be solved`: one of the `field_simp; ring` identities (`hw'` or `h3`) is closed by
  `field_simp` alone, so a trailing tactic must be dropped — **check which, then trim**;
* **47** — the `nlinarith` in `hK1`;
* **48** — the `div_mul_cancel₀` pattern miss after `rw [hw', h3]`.

**Next: fix 42 (drop the redundant tactic), then 47/48.**

### 13.446 Round-417: the three remaining errors diagnosed from the source

Build green: **211 declarations, 7/7 OK, 0 sorries**.

**Reading lines 38–50:**

* **42** — the `ring` after `field_simp` in `h3` (`3L/(2n) = 3L/(2N) + 3L/(2n·N)`): `field_simp` closes it,
  so **drop the `ring`** (the recurring "No goals to be solved");
* **47** — `nlinarith only [hCpos, sq_nonneg (2*PhiC+1), hNpos']` in `hK1`: needs **`1 ≤ N`** as well
  (the RHS is `C·N` and `C ≥ 10²⁰ > 0`), so add `hN1 : (1:ℝ) ≤ N`;
* **48** — the tail `rw [div_mul_cancel₀ _ (ne_of_gt hNpos')] at hK1` misses because after
  `rw [hw', h3]` the goal contains `K₁/(n·N)` and `C·N/N²`, **not** `K₁` and `C·N` separately.

**Recorded tail rewrite:** rather than reusing `hK1` in its `K₁ ≤ C·N` form, divide it by `N` first in a
`have`:

```lean
have hK1b : (4*10^10 + 10^12 + 10^18*(2*PhiC+1)/2 + 500*(2*PhiC+1)^2)/(N)
    ≤ (10^20 + 10^18*(2*PhiC+2) + 500*(2*PhiC+1)^2) := by
  rw [div_le_iff₀ hNpos']
  linarith only [hK1]
```

then `nlinarith` with `h1`, `hK1b`, `h4`, `hnR'`, `hNpos'`, `hnN`, `hL` — matching the goal's shapes
(`K₁/(n·N) ≤ K₁/N ≤ C` using `n ≤ N`, and `C ≤ C·N/N²·N`).

**Next: apply the three fixes.**

### 13.447 Round-418: three fixes applied — `nmin_wp_lower` at ONE error

Build green: **211 declarations, 7/7 OK, 0 sorries**.

* **42 fixed** — dropped the redundant `ring` in `h3`;
* **47 fixed** — added `hN1 : (1:ℝ) ≤ N` (by `exact_mod_cast` + `omega`) and passed it to `hK1`'s
  `nlinarith`;
* **48 fixed** — restructured the tail with `hK1b : K₁/N ≤ C` (by `div_le_iff₀ hNpos'` and
  `linarith only [hK1]`) plus the `hCnn` equality for the `C·N/N²·N` shape;
* **one error remains (49)** — `rw [div_le_iff₀ hNpos']` inside `hK1b` cannot find the pattern, because
  `hK1b`'s LHS is `K₁/N` but the goal after `rw [hw', h3]` context may already have normalised the
  division — **print it**.

**`nmin_wp_lower` is one rewrite away from compiling**, and it is the last new lemma before the two `n'`
bounds and the `IsBigO` wrapper.

### 13.448 Round-419: error 49 was a **rewrite-target** mistake; two errors left

Build green: **211 declarations, 7/7 OK, 0 sorries**.

**Printed diagnosis:** `rw [h3]` looked for `3·log2/(2·n)` in a goal whose LHS is already
`3·log2/(2·N) − C·N/N²` — because the **statement** is written in the `N` form.  So `h3` must be applied
**to `h1`** (which is in the `n` form), not to the goal:

```lean
rw [hw']
rw [h3] at h1        -- h1 : 3L/(2N) + 3L/(2n·N) − K₁/n² ≤ p/n − L
```

**Two errors remain (56, 59):**
* **56** — the `hCnn` equality (`C ≤ C·N/N²·N`) — `field_simp; ring` leaves a goal;
* **59** — the final `nlinarith` over `h1, hK1b, h4, hnR', hNpos', hnN, hL, hCnn`.

**Both are the familiar arithmetic-shape class**; `hCnn` may not even be needed once the goal's shape is
matched directly.

**Next: print 56 and 59, then close the lemma and land it.**

### 13.449 Round-420: tail restructured with `hCeq`/`hfin` — one error left

Build green: **211 declarations, 7/7 OK, 0 sorries**.

The tail is now:

```lean
have hCeq : C * N / (N*N) = C / N := by field_simp
rw [hCeq]
have hfin : K₁/(n*N) ≤ C/N := by
  rw [div_le_div_iff₀ (by positivity : (0:ℝ) < n*N) hNpos']
  nlinarith only [hK1b, hnR', hNpos', hnN]
linarith only [h1, hfin, h4, hnR', hNpos', hnN, hL]
```

**One error remains (58)** — `rw [hCeq]` cannot find its pattern: the goal's `C·N/N²` may already be
normalised differently by the preceding `rw [hw']`.  **Print the goal immediately before line 58**, which
is the same diagnosis-by-reading that resolved round 419's rewrite-target issue.

**`nmin_wp_lower` is one `rw` from compiling**, then it lands and the `n'` bounds follow.

### 13.450 Round-421: error 58 was `N^2` vs `N*N` — two `linarith` errors left

Build green: **211 declarations, 7/7 OK, 0 sorries**.

**Printed diagnosis:** the goal contains `C·N/N^2` while `hCeq`'s pattern was `C·N/(N*N)` — **the power
form differs from the product form**, so the rewrite could not match.  Restating `hCeq` with `N^2` fixed
it.  (This is the same class as the `div_add_div`/`div_mul_eq_mul_div` association issues.)

**Two errors remain (62, 63):**
* **62** — `hfin`'s `nlinarith only [hK1b, hnR', hNpos', hnN]` — the comparison
  `K₁/(n·N) ≤ C/N` after `div_le_div_iff₀` gives `K₁·N ≤ C·(n·N)`, needing `K₁ ≤ C·n ≤ C·N`;
* **63** — the final `linarith` over `h1, hfin, h4, hnR', hNpos', hnN, hL`.

**Both are `linarith` on products** — the fix pattern established throughout is to **supply the product
comparison explicitly** (e.g. `K₁ ≤ C·n` from `hK1b` and `n ≤ N`, then multiply), rather than expecting
`linarith` to find the nonlinear step.

**Next: supply the product steps explicitly, then land `nmin_wp_lower`.**

### 13.451 Round-422: product step supplied (`hK1C`); two `linarith` errors persist

Build green: **211 declarations, 7/7 OK, 0 sorries**.

**Reduction identified:** `hfin : K₁/(n·N) ≤ C/N` is equivalent to `K₁ ≤ C·n`, and since `n ≥ 1` it
suffices that **`K₁ ≤ C`** — which holds because `500(2PhiC+1)²` dominates `10¹⁸(2PhiC+1)/2` for
`PhiC ≥ 1`, so the added `hK1C : K₁ ≤ C` is provable by `nlinarith` with `hCpos` and
`sq_nonneg (2*PhiC+1)`.

**Two `linarith` errors remain (66, 67)** — inside `hfin` and the final step.  Both are
**print-required**: the recorded remedy is to read the negated goal (which names exactly which product
comparison `linarith` is missing), as in rounds 402/419.

**Next: print 66's context, add the named product comparison it asks for, then close and land.**

### 13.452 Round-423: `hC0` added; two `linarith` errors persist — goal text still needed

Build green: **211 declarations, 7/7 OK, 0 sorries**.

Added `hC0 : 0 ≤ C` (the `nlinarith` in `hstep` needs it to derive `C·N ≤ C·n·N` from `1 ≤ n`), and
`hstep` is now stated explicitly as `K₁·N ≤ C·(n·N)`.

**Two errors persist (70, 72)** — the `nlinarith` inside `hstep` and the final `linarith`.  The
**negated goal text has not yet been read** (the `grep` in this round printed hypothesis *names* only).

**Recorded remedy, applied without deviation:** print **`a✝`** (the negated goal) in full — it names the
exact monomial `linarith` cannot connect.  In rounds 402 and 419 this resolved the step in one attempt
after two rounds of hypothesis guessing, which is precisely the pattern here.

**Next: print `a✝` for error 70.**

### 13.453 Round-424: **the negated goal shows the error term is under-scaled**

Build green: **211 declarations, 7/7 OK, 0 sorries**.

**Printed `a✝`:**

```
p/n − log2 − p/(n·N)  <  3log2/(2N) − C/N
```

With `h1 : 3L/(2N) + 3L/(2n·N) − K₁/n² ≤ p/n − L` (after `rw [h3] at h1`) and
`hfin : K₁/(n·N) ≤ C/N`, the required conclusion is

```
p/(n·N) − 3L/(2n·N) + K₁/n² ≤ C/N.
```

Now `p/n = L + w` with `|w| ≤ 4/n`, so `p/(n·N) ≤ L/N + 4/(n²N)`, and the LHS is
`≈ L/N − 3L/(2n·N) + K₁/n² = L(n − 3/2)/(n·N) + K₁/n²`.

**So the needed bound is `C/N ≥ L·n/N + K₁/n²`, i.e. `C ≥ L·n + K₁/n` — and `L·n` is UNBOUNDED**
(`n = nmin p ≈ p/log2`, so `L·n ≈ p`).  A **fixed** `C` cannot dominate it.

**Fix: the statement's error term must scale with `n`.**  Replace `C·N/N²` by **`(C·n)·N/N²`**, i.e.
state the error as `10²⁰·n/N` — then `C·n/N ≥ 10²⁰·n/(2n) = 5·10¹⁹ ≫ L·n/N` for the relevant range, and
the goal closes.  (Equivalently: the error constant must be proportional to `n`, exactly as in the
`stage2_upper_sharp` constant which carries an explicit `N` factor.)

**Next: restate `nmin_wp_lower` with the `n`-scaled error term and re-derive the tail.**

### 13.454 Round-425: the corrected statement for `nmin_wp_lower`

Build green: **211 declarations, 7/7 OK, 0 sorries**.

**Working out the required error term exactly.**  From `h1` (after `rw [h3] at h1`):

```
p/N − L ≥ 3L/(2N) + 3L/(2n·N) − K₁/n² − p/(n·N)
```

and the goal `p/N − L ≥ 3L/(2N) − ERR` needs

```
ERR ≥ K₁/n² + p/(n·N) − 3L/(2n·N).
```

Using `p/n = L + w` and `|w| ≤ 4/n`, `p/(n·N) ≤ L/N + 4/(n²N)`, so

```
ERR ≥ K₁/n² + (L/2)/(n·N) + 4/(n²N)  —  and since n ≥ 1, (L/2)/(n·N) ≤ L/2·(1/n) ≤ 1/n.
```

**So `ERR` must dominate `K₁/n² + O(1/n)`, i.e. it must be `Θ(1/n)`** — not `Θ(1/n²)`.  The natural
choice is

```
ERR := C·N/N²      with C a PhiC-dependent term — so ERR = C/N  — hmm, that is Θ(1/N), NOT Θ(1/n).
```

**Correct:** since `N = n + 1 ≤ 2n`, `1/N ≥ 1/(2n)`, so `C/N ≥ C/(2n)` — and `K₁/n² ≤ K₁/(2n)·(2/n)`
needs `C ≥ K₁` for large `n`.  **So `ERR := C/N` with `C := K₁`-dominating works**: take
`C := 10²⁰ + 10¹⁸(2PhiC+2) + 500(2PhiC+1)²`, then `C/N ≥ C/(2n) ≥ (K₁/n²) + L/(2n·N) + 4/(n²N)` for
`n ≥ 1` — **because `C ≥ K₁` (the `hK1C` fact) and `1/N ≥ 1/(2n) ≥ 1/n²` and `1/N ≥ 1/(2n·N)`.**

**So the statement is UNCHANGED in form** — `3L/(2N) − C/N ≤ p/N − L` — and only the proof's final
`linarith` needs the explicit steps

```
C/N ≥ K₁/n²  (from hK1C and 1/N ≥ 1/n² … hmm: needs C ≥ K₁·N/n², and N ≥ n gives N/n² ≥ 1/n)
```

**Next: supply `C/N ≥ K₁/n² + L/(2n·N) + 4/(n²·N)` as one explicit `have` and then `linarith`.**

### 13.455 Round-426: **standalone test refutes §13.454's retraction — §13.453 was right**

Build green: **211 declarations, 7/7 OK, 0 sorries**.

**Testing the §13.454 claim** (that `C/N ≥ K₁/n²` holds without an `n` factor in `C`):

```lean
example (PhiC n N : ℝ) (hn : 1 ≤ n) (hN : n + 1 ≤ N) (hC : 0 < PhiC) :
    K₁/n^2 ≤ C/N := by
  rw [div_le_div_iff₀ … ]; nlinarith only [hC, sq_nonneg (2*PhiC+1), sq_nonneg (2*PhiC+2), hn, hN]
```

**fails** — with `⊢ False` and a positivity failure.  **So §13.454's "the statement is unchanged in form"
was wrong**, and §13.453's conclusion stands:

```
C/N ≥ K₁/n²   requires   C ≥ K₁·N/n² ,
```

and `K₁/n² ≈ (2PhiC+1)/4` while `C/N ≈ 5·10¹⁰`, so the inequality is **false for large `PhiC`**.  A fixed
`C` cannot work; the error term needs an **`n` factor**.

**Correct form (from §13.453):** `ERR := C·n/N` with
`C := 10²⁰ + 10¹⁸(2PhiC+2) + 500(2PhiC+1)²`.  Then `C·n/N ≥ C·n/(2n) = C/2`, and `C/2 ≥ K₁/n²` needs
`n²·C/2 ≥ K₁`, i.e. `C ≥ 2K₁/n² ≈ (2PhiC+1)/4` — **true** since `C ≥ (2PhiC+1)/4` for `PhiC ≥ 1`.

**Lesson recorded sharply: the standalone test settled in ONE command what two rounds of paper
disagreement could not.**  §13.453 said `n`-scaled; §13.454 retracted it; §13.455 (this round) refutes the
retraction.  **The paper reasoning was wrong twice; the kernel was right immediately.**

### 13.456 Round-427: TEST B (n-scaled) — first `rw` fires, second pattern misses

Build green: **211 declarations, 7/7 OK, 0 sorries**.

The standalone test of the **`n`-scaled** claim:

```lean
example (PhiC n N : ℝ) (hn : 1 ≤ n) (hN : n + 1 ≤ N) (hC : 0 < PhiC) :
    K₁/n^2 ≤ (C*n)/N := by
  rw [div_le_iff₀ (by positivity : (0:ℝ) < n^2)]     -- fires: goal becomes K₁*n^2 ≤ C*n/N
  rw [le_div_iff₀ hNpos]                              -- MISSES
  nlinarith […]
```

**The first rewrite succeeded** (the printed goal is `K₁ ≤ …`-scaled), and the second misses because after
`div_le_iff₀` the goal's division is on the **right** of a *product* `K₁*n^2 ≤ (C*n)/N`, whose shape
`le_div_iff₀` did not match directly.

**Recorded fix for the test:** avoid the second `rw` entirely — use
`field_simp` (or `rw [le_div_iff₀ hNpos]` before the first rewrite) and then `nlinarith`.  The point of
the test is the **inequality's truth**, not the rewrite choreography; clearing denominators with
`field_simp` and closing by `nlinarith` is the shortest reliable route.

**If TEST B passes, the `n`-scaled statement is correct and `nmin_wp_lower` can be restated accordingly.**

### 13.457 Round-428: `field_simp` fires; `nlinarith` still fails — the `N = n+1` fact is missing

Build green: **211 declarations, 7/7 OK, 0 sorries**.

TEST B with `field_simp; nlinarith only [hC, sq_nonneg (2*PhiC+1), hn, hN]` gives `⊢ False` — the
`nlinarith` cannot close.  **The hypothesis is `hN : n + 1 ≤ N`, but the needed fact is `N = n + 1`** (or
at least `N ≤ n + 1`), because `C·n/N ≥ C/2` requires `n/N ≥ 1/2`, i.e. `N ≤ 2n`, which does **not**
follow from `n+1 ≤ N` — that direction gives `N ≥ n+1`, the opposite of what is needed.

**So the test hypothesis is wrong, not the inequality.**  With `N = n + 1` (as in the actual lemma, where
`N := ↑(nmin p + 1)`), we get `n/N = n/(n+1) ≥ 1/2` for `n ≥ 1`, and the inequality follows.

**Next: re-run TEST B with `hN : N = n + 1`.**  This is a small correction to the *test*, and it is worth
noting that the same directional slip (`≤` where `=` was meant) has appeared before — e.g. the `hnd`
form in the caller.

### 13.458 Round-429: **both fixed and `n`-scaled error terms are FALSE — `K₁` must appear**

Build green: **211 declarations, 7/7 OK, 0 sorries**.

TEST B with the correct `hN : N = n + 1` **still fails** (`⊢ False`).  Checking the required inequality
numerically at `n ≈ 2·10⁹`:

* `K₁/n² ≈ (10¹⁸(2PhiC+1)/2)/(4·10¹⁸) = (2PhiC+1)/8`;
* `C·n/N ≈ C/2 ≈ 5·10¹⁹` (for `C ≈ 10²⁰`).

So the claim `(2PhiC+1)/8 ≤ 5·10¹⁹` is **false for large `PhiC`** — **no `PhiC`-polynomial times a power
of `n` smaller than `n·K₁` can dominate `K₁/n²`**, because `K₁` itself contains `500(2PhiC+1)²`.

**Correct error term: include `K₁` explicitly.**

```
ERR := (C + K₁)/N        with C := 10²⁰ + 10¹⁸(2PhiC+2) + 500(2PhiC+1)²
```

Then `ERR ≥ K₁/N ≥ K₁/(2n)` (using `N ≤ 2n`), and **`K₁/(2n) ≥ K₁/n²` since `n ≥ 2`** — which discharges
the `K₁/n²` term exactly.  The `L/(2n·N)` and `4/(n²N)` terms are `≤ C/N` for the same `N ≤ 2n` reason.

**So the statement becomes `3log2/(2N) − (C + K₁)/N ≤ p/N − log2`, and the proof's `linarith` has
`ERR ≥ K₁/n² + L/(2n·N) + 4/(n²N)` available in three explicit steps.**

**The general lesson, now confirmed twice by the kernel:** the error term must be able to absorb **every
term appearing on the RHS of the needed bound**, and those terms are `K₁/n²` (from `h1`) plus `1/n`-order
pieces — so a purely numeric constant, however large, cannot do it when a `PhiC`-polynomial sits in the
numerator.

### 13.459 Round-430: TEST C (`(C+K₁)/N`) — `nlinarith` still fails after `field_simp`

Build green: **211 declarations, 7/7 OK, 0 sorries**.

TEST C with the `K₁`-inclusive error term, plus explicit `hK10 : 0 ≤ K₁` and `hC0 : 0 ≤ C`:

```lean
example (PhiC n N : ℝ) (hn : 2 ≤ n) (hN : N = n + 1) (hC : 0 < PhiC) :
    K₁/n^2 ≤ (C + K₁)/N := by
  have hnR : 0 < n := …
  have hNpos : 0 < N := …
  have hK10 : 0 ≤ K₁ := …
  have hC0 : 0 ≤ C := …
  field_simp
  nlinarith only [hC, hK10, hC0, sq_nonneg (2*PhiC+1), hn, hN]   -- ⊢ False
```

**The mathematics is right:** after clearing denominators the claim is `K₁·(n+1) ≤ (C+K₁)·n²`, i.e.
`K₁·n + K₁ ≤ C·n² + K₁·n²`, which holds since `K₁·n² ≥ K₁·n + K₁` for `n ≥ 2` (as `n² ≥ n+1`) and
`C·n² ≥ 0`.

**So the failure is `nlinarith`'s** — it cannot see the needed product decomposition of `K₁·n²` versus
`K₁·n + K₁` (a degree-4 polynomial goal in `PhiC, n`).

**Recorded remedy (the pattern that has worked for every nonlinear `linarith` in this file): split the
target into named pieces FIRST:**

```lean
have hA : K₁*(n+1) ≤ K₁*n^2 := by nlinarith only [hK10, hn]           -- n^2 ≥ n+1
have hB : K₁*n^2 ≤ (C + K₁)*n^2 := by nlinarith only [hK10, hC0, hn]  -- C*n^2 ≥ 0
linarith only [hA, hB]
```

**Next: run TEST C with the `hA`/`hB` split.**

### 13.460 Round-431: `hA` proved by `mul_le_mul_of_nonneg_left` — TEST C at one rewrite error

Build green: **211 declarations, 7/7 OK, 0 sorries**.

**`hA` needed the product lemma, not `nlinarith`:**

```lean
have h1 : n + 1 ≤ n^2 := by nlinarith only [hn]
exact mul_le_mul_of_nonneg_left h1 hK10
```

— because `K₁(n+1) ≤ K₁n²` is exactly `K₁·(n+1) ≤ K₁·n²` with `K₁ ≥ 0` and `n+1 ≤ n²`, and
`nlinarith` cannot extract the scalar fact `(n+1) ≤ n²` from the product form.

**One error remains (26)** — the first `rw [div_le_iff₀ …]` misses.  The printed goal is already
`K₁ ≤ …`-scaled, meaning **an earlier rewrite consumed the `K₁/n²` division**; **print the goal directly
before line 26**.

**This is the recurring "the rewrite fired somewhere I did not expect" shape**, resolved each time by
reading the goal at that line.

### 13.461 Round-432: the needed final step is `K₁·N ≤ (C+K₁)·n²` — already `hA`+`hB`

Build green: **211 declarations, 7/7 OK, 0 sorries**.

**Re-deriving the target:** `K₁/n² ≤ (C+K₁)/N` ⟺ `(C+K₁)·n² ≥ K₁·N` with `N = n+1`, i.e.

```
C·n² + K₁·n² ≥ K₁·n + K₁,
```

true because `K₁·n² ≥ K₁·n + K₁` for `n ≥ 2` (since `n² ≥ n+1`) and `C·n² ≥ 0`.  **This is exactly `hA`
(`K₁(n+1) ≤ K₁n²`) combined with `hB` (`K₁n² ≤ (C+K₁)n²`)** — so the two named pieces already give the
required inequality, and only the division choreography is left.

**Correct tail:**

```lean
rw [div_le_iff₀ (by positivity : (0:ℝ) < n^2)]
have hfrac : K₁ * n^2 ≤ ((C + K₁)/N) * n^2 := by
  rw [div_mul_eq_mul_div]
  rw [le_div_iff₀ hNpos]
  linarith only [hA, hB, hN]
exact hfrac
```

The `div_mul_eq_mul_div` converts `((C+K₁)/N)·n²` into `((C+K₁)·n²)/N` so that `le_div_iff₀` matches.

**The earlier `hN2` attempt failed because it asserted `K₁ ≤ (C+K₁)/N`, which is FALSE** (that needs
`K₁·n ≤ C`).  The correct intermediate is the *ratio with the `n²` already present*, which is why the
`hA`/`hB` product forms are the right level.

### 13.462 Round-433: `div_le_div_iff₀` is the right lemma — TEST C at one `linarith`

Build green: **211 declarations, 7/7 OK, 0 sorries**.

**The correct reduction:** `K₁/n² ≤ (C+K₁)/N` is `a/b ≤ c/d`, so **`div_le_div_iff₀`** (not
`div_le_iff₀` followed by `le_div_iff₀`) gives directly

```
K₁·N ≤ (C+K₁)·n²,
```

which follows from `hA : K₁(n+1) ≤ K₁n²` and `hB : K₁n² ≤ (C+K₁)n²` with `N = n+1`.

**The earlier attempt failed because chaining `div_le_iff₀` then `le_div_iff₀` double-applies the
scaling** — producing `K₁·n²·N ≤ (C+K₁)·n²` and hence the false `K₁·N ≤ C+K₁`.  **One
`div_le_div_iff₀` replaces both and keeps the `n²` on the correct side.**

**One error remains (29)** — the final `linarith only [hA, hB, hN]`, whose goal is
`K₁·N ≤ (C+K₁)·n²`.  Since `hA` and `hB` chain to exactly that, the residual is an association or
`N = n+1` substitution — **print it**.

**Next: print 29's goal, then TEST C is done and `nmin_wp_lower` can be restated.**

### 13.463 Round-434: **TEST C PASSES** — `ERR := (C + K₁)/N` is confirmed

Build green: **211 declarations, 7/7 OK, 0 sorries**.

The standalone test now compiles with **no errors**:

```lean
example (PhiC n N : ℝ) (hn : 2 ≤ n) (hN : N = n + 1) (hC : 0 < PhiC) :
    K₁/n^2 ≤ (C + K₁)/N := by
  have hnR : 0 < n := …
  have hNpos : 0 < N := …
  have hK10 : 0 ≤ K₁ := …
  have hC0 : 0 ≤ C := …
  have hA : K₁*(n+1) ≤ K₁*n^2 := by
    have h1 : n + 1 ≤ n^2 := by nlinarith only [hn]
    exact mul_le_mul_of_nonneg_left h1 hK10
  have hB : K₁*n^2 ≤ (C + K₁)*n^2 := by nlinarith only [hK10, hC0, hn]
  rw [div_le_div_iff₀ (by positivity : (0:ℝ) < n^2) hNpos, hN]
  linarith only [hA, hB]
```

**So `ERR := (C+K₁)/N` dominates `K₁/n²` — the statement design is settled**, after four rounds of
proposing and refuting candidates (fixed `C`; `n`-scaled `C·n`; and the false intermediate
`K₁ ≤ (C+K₁)/N`).

**The final fix was `rw [.., hN]`** — the goal contains `N` while `hA`/`hB` are stated with `n+1`, and
**`linarith` does not rewrite by equalities**, so the substitution must be made explicitly.

**Next: restate `nmin_wp_lower` with `ERR := (C+K₁)/N`** and re-derive its tail using exactly the
`hA`/`hB`/`div_le_div_iff₀` pattern validated here.

### 13.464 Round-435: `nmin_wp_lower` restated; the tail's `hERR` plan

Build green: **211 declarations, 7/7 OK, 0 sorries**.

**Statement restated:**

```lean
lemma nmin_wp_lower … :
    3*log2/(2*N) - (C + K₁)/N ≤ p/N - log2
```
with `C := 10²⁰ + 10¹⁸(2PhiC+2) + 500(2PhiC+1)²` and
`K₁ := 4·10¹⁰ + 10¹² + 10¹⁸(2PhiC+1)/2 + 500(2PhiC+1)²`.

**The tail's requirement, after `rw [hw']` and `rw [h3] at h1`:**

```
h1  : 3L/(2N) + 3L/(2n·N) − K₁/n² ≤ p/n − L
goal: 3L/(2N) − (C+K₁)/N ≤ (p/n − L) − p/(n·N)
```

so it suffices to prove **`hERR`**:

```lean
have hERR : K₁/n^2 + p/(n*N) - 3*log2/(2*(n*N)) ≤ (C + K₁)/N := by …
linarith only [h1, hERR]
```

**`hERR` decomposes into the three pieces validated by TEST C and the `hwsh` bound:**

1. `K₁/n² ≤ (C+K₁)/N` — **TEST C, proved** (via `hA`/`hB` + `div_le_div_iff₀` + `rw [hN]`);
2. `p/(n·N) ≤ log2/N + 4/(n²·N)` — from `hwsh : |p/n − L| ≤ 4/n`;
3. `4/(n²·N) ≤ C/N` — from `C ≥ 1` and `n ≥ 1`.

**Next: write `hERR` by combining (1) with (2)+(3), then `linarith only [h1, hERR]` closes the lemma.**

### 13.465 Round-436: `nmin_wp_lower` tail written — two `linarith` errors

Build green: **211 declarations, 7/7 OK, 0 sorries**.

The tail is now written with the planned decomposition:

* `hK1C`, `hK10`, `hC0` — the constant nonnegativities and the `K₁ ≤ C` comparison;
* `h2n : 2 ≤ n`, `hA` (`K₁(n+1) ≤ K₁n²` via `mul_le_mul_of_nonneg_left`), `hB`;
* **`hC1`** — `K₁/n² ≤ (C+K₁)/N` by `div_le_div_iff₀ … , hNn` then `linarith only [hA, hB]` — **the
  TEST C pattern, transplanted**;
* `hw4` — `p/n − L ≤ 4/n` from `hwsh`;
* **`hC2`** — `1/(n²·N) ≤ (C+K₁)/N`;
* final `nlinarith`.

**Two errors remain (76, 77)** — `hC2`'s `nlinarith` and the final combination.  Both are the usual
product-structured `linarith` shape; **print the goals** and supply the missing product comparisons
explicitly (the pattern that has closed every such step).

**Next: print 76, fix, then the final `nlinarith` — and `nmin_wp_lower` lands.**

### 13.466 Round-437: `hC2`'s goal analysed — needs `C+K₁ ≥ 1`, not just `≥ 0`

Build green: **211 declarations, 7/7 OK, 0 sorries**.

**`hC2 : 1/(n²·N) ≤ (C+K₁)/N` reduces, via `div_le_div_iff₀`, to**

```
1·N ≤ (C + K₁)·(n²·N)      i.e.      1 ≤ (C + K₁)·n²,
```

which holds because `C + K₁ ≥ 1` (indeed `C ≥ 10²⁰`) and `n² ≥ 1` (from `n ≥ 2`).

**So the missing hypothesis is `1 ≤ C + K₁`**, not merely `0 ≤ C`, `0 ≤ K₁` — the `nlinarith` cannot
combine the two nonnegativity facts into a strict lower bound.  Supply explicitly:

```lean
have hC1' : (1:ℝ) ≤ 10^20 + 10^18*(2*PhiC+2) + 500*(2*PhiC+1)^2 := by nlinarith only [hC0]
have hC2 : 1/(n^2*N) ≤ (C + K₁)/N := by
  rw [div_le_div_iff₀ (by positivity : (0:ℝ) < n^2*N) hNpos']
  nlinarith only [hC1', hK10, hnR', hNpos', h2n]
```

**This is the same class as round 416's `hnR2` and round 422's `hK1C`**: `linarith` needs the *lower
bound with the right constant* supplied directly, not derivable from `0 ≤`-style hypotheses by
combination.

**Next: add `hC1'`, fix `hC2`, then the final `nlinarith`.**

### 13.467 Round-438: `hC1'` added; two `linarith` errors persist

Build green: **211 declarations, 7/7 OK, 0 sorries**.

Added `hC1' : 1 ≤ C + K₁` (by `nlinarith only [hC0, hK10]`) and passed it to `hC2`'s `nlinarith`.

**Two errors persist (79, 80)** — `hC2`'s `nlinarith` and the final combination.  The `hC2` goal after
`div_le_div_iff₀` is `1·N ≤ (C+K₁)·(n²·N)`, and the available facts are `hC1'`, `hK10`, `hnR'`, `hNpos'`,
`h2n`.  **The needed chain is `1 ≤ (C+K₁)·n²` then multiply by `N`** — a product decomposition
`nlinarith` typically cannot perform in one step.

**Recorded fix (the standard split):**

```lean
have hP : (1:ℝ) ≤ (C + K₁)*n^2 := by
  have hn2 : (1:ℝ) ≤ n^2 := by nlinarith only [h2n]
  exact one_le_mul_of_one_le_of_one_le hC1' hn2
have hC2 : … := by
  rw [div_le_div_iff₀ … ]
  exact mul_le_mul_of_nonneg_right hP hNpos'.le
```

**Next: apply the split, then the final `nlinarith`.**

### 13.468 Round-439: `hC2` via `calc` — the calc's endpoint shapes are off

Build green: **211 declarations, 7/7 OK, 0 sorries**.

The `hC2` proof now uses the recorded split:

```lean
have hP : 1 ≤ (C + K₁)*n^2 := by
  have hn2 : 1 ≤ n^2 := by nlinarith only [h2n]
  exact one_le_mul_of_one_le_of_one_le hC1' hn2
calc (1:ℝ)*N ≤ ((C+K₁)*n^2)*N := mul_le_mul_of_nonneg_right hP hNpos'.le
  _ = (C+K₁)*(n^2*N) := by ring
```

**Three errors (83, 86, 88):** the `calc`'s left-hand side (`1*N`) does not match the goal's shape, and
its right-hand side does not match the goal's denominator grouping `n^2*N` versus the goal's
`n^2*N` ordering.

**`calc` requires each step's endpoints to be syntactically at the stated positions**; the standard fix is
to **write the goal in the exact shape first** (`rw`/`simp` to expose `1*N` and `(C+K₁)*(n²*N)`), or to
avoid `calc` and finish with

```lean
have := mul_le_mul_of_nonneg_right hP hNpos'.le
nlinarith only [this, hnR']
```

**Next: replace the `calc` with the explicit `have` + `nlinarith`, then the final step.**

### 13.469 Round-440: `calc` replaced by `have` + `nlinarith`; two errors persist

Build green: **211 declarations, 7/7 OK, 0 sorries**.

`hC2`'s proof is now:

```lean
have hP : 1 ≤ (C + K₁)*n^2 := by
  have hn2 : 1 ≤ n^2 := by nlinarith only [h2n]
  exact one_le_mul_of_one_le_of_one_le hC1' hn2
have hstep := mul_le_mul_of_nonneg_right hP hNpos'.le
nlinarith only [hstep, hnR', hNpos']
```

**Two errors persist (83, 84)** — `hC2`'s `nlinarith` and the final combination.  Since `hstep` is an
inequality on `(1*N)` versus `((C+K₁)*n²)*N` and the goal is `1*N ≤ (C+K₁)*(n²*N)`, the failure is again
**the association `(A*n²)*N` versus `A*(n²*N)`** — `nlinarith` does not re-associate products.

**Recorded fix: supply the reassociation as an equality and use it:**

```lean
have hassoc : ((C+K₁)*n^2)*N = (C+K₁)*(n^2*N) := by ring
linarith only [hstep, hassoc]
```

**Next: add the reassociation equality to `hC2`, then close the final step.**

### 13.470 Round-441: reassociation added; two errors persist — print required

Build green: **211 declarations, 7/7 OK, 0 sorries**.

`hassoc` was added as a `ring` equality between the two groupings, and `linarith only [hstep, hassoc]`
still fails (87, 88).

**At this point the shape-guessing must stop and the goal must be read.**  Three rounds (439–441) have
been spent on `hC2`'s grouping, each time supplying a plausible reassociation and each time failing.  The
recorded rule — **print `a✝`, not the hypotheses** — has resolved every such case (rounds 402, 419, 424)
and has not yet been applied to 87.

**Next: print 87's `a✝` in full, with no name filter, and supply exactly the missing equality.**

**Lesson for the record:** `hC2` is a *syntactic* side-condition (`1/(n²·N) ≤ (C+K₁)/N`), not a
mathematical one — its content is `1 ≤ (C+K₁)n²`, already proved as `hP`.  When a step is this trivial
and keeps failing, the obstacle is the *goal's presentation*, and only reading it will say which
reassociation is missing.

### 13.471 Round-442: **printing found the missing piece — the `p/(nN)` term**

Build green: **211 declarations, 7/7 OK, 0 sorries**.

**Printed `a✝` (the final goal):**

```
p/n − log2 − p/(n·N)  <  3log2/(2N) − (C+K₁)/N
```

with `h1 : 3L/(2N) + 3L/(2n·N) − K₁/n² ≤ p/n − L`, this needs

```
(C+K₁)/N ≥ K₁/n² + p/(n·N) − 3L/(2n·N).
```

**`hC1` covers `K₁/n²` and `hC2` covers the `1/(n²N)` piece — but nothing covered `p/(n·N)`.**  That is
the missing term, and it is exactly the kind of term the round-435 plan listed as piece (2) but which was
never written.

**Added `hC3 : p/(n·N) − 3L/(2n·N) ≤ (C+K₁)/N`** via `hwsh` (`p/n − L ≤ 4/n` ⟹ `p ≤ n(L + 4/n)`) and
`hCL : L ≤ C+K₁`.

**Four errors (87, 90, 94, 102)** — the constants' shapes and the `div_sub_div_same` pattern.  To be
worked one at a time, printing first.

**The print paid for itself immediately:** three rounds of guessing at `hC2`'s *reassociation* failed,
while the actual gap was an **entirely absent term**.  Reading the goal named it in one command.

### 13.472 Round-443: `div_sub_div_same` cannot apply — the denominators differ

Build green: **211 declarations, 7/7 OK, 0 sorries**.

**Printed goal (87, 94):**

```
p/(n·N) − 3log2/(2·(n·N))  ≤  (C+K₁)/N
```

`hC3`'s proof applied `div_sub_div_same`, which requires the **same** denominator `c` in both fractions —
but here they are `n·N` and `2·(n·N)`.  **So the rewrite cannot fire.**

**Recorded fix: use `field_simp` (or multiply through by `n·N`) instead of `div_sub_div_same`:**

```lean
have hC3 : … := by
  rw [div_le_div_iff₀ (by positivity : (0:ℝ) < n*N) hNpos']
  -- goal: (p*(n*N) - (3*log2/2)*(n*N)/(n*N)*…) — clear denominators with field_simp
  field_simp
  …
```

or, more simply, **prove `p/(n·N) − 3L/(2(n·N)) = (p − 3L/2)/(n·N)`** as a `field_simp` identity first and
then compare to `(C+K₁)/N` by `div_le_div_iff₀`.

**Next: rewrite `hC3` with the identity route, then fix 87 (`hC2`) and 102 (final).**

### 13.473 Round-444: `hC3` rewritten with the identity — four errors, all localised

Build green: **211 declarations, 7/7 OK, 0 sorries**.

`hC3` now uses the identity route:

```lean
have hid : p/(n*N) − 3L/(2*(n*N)) = (p − 3L/2)/(n*N) := by field_simp; ring
rw [hid, div_le_div_iff₀ (by positivity : 0 < n*N) hNpos']
have hp  : p ≤ n*(L + 4/n)      -- from hwsh
have hL4 : L + 4/n ≤ C + K₁     -- from hCL
nlinarith only [hp, hL4, hnR', hNpos', hL]
```

**Four errors (87, 90, 96, 100):**
* **87** — `hC2`'s `nlinarith` (`hP`/`hassoc` chain, still not closing);
* **90** — `hCL`'s `nlinarith only [hC1']`;
* **96** — `No goals to be solved`: `field_simp` already closed `hid`, so the `ring` is redundant;
* **100** — `hC3`'s final `nlinarith`.

**Next: fix 96 (drop `ring`), then print 87/90/100 and supply the missing product steps.**

**Progress note:** the `hC3` structure is now right (`hid` + `div_le_div_iff₀` + `hp`/`hL4`), so the
remaining errors are the familiar product-decomposition class.

### 13.474 Round-445: `ring` dropped; four `linarith` errors remain, all the product class

Build green: **211 declarations, 7/7 OK, 0 sorries**.

Dropping the redundant `ring` in `hid` (96) leaves **four `linarith` failures (87, 90, 99, 102)**:

* **87** — `hC2`'s `nlinarith` (goal `1/(n²·N) ≤ (C+K₁)/N`);
* **90** — `hCL`'s `nlinarith only [hC1']`;
* **99** — `hL4`'s `nlinarith`;
* **102** — the final combination.

**All four are the same class**, and the standard remedy is uniform: **supply the product/scalar
comparison each one needs as its own `have`, then `linarith`.**  Concretely:

* **87**: `1 ≤ (C+K₁)·n²` (from `hC1'` and `1 ≤ n²`) then `mul_le_mul_of_nonneg_right … hNpos'.le`;
* **90**: `hCL` needs `L ≤ C` — but `hC1' : 1 ≤ C + K₁` alone gives only `L ≤ C+K₁`; the goal is stated
  with `C + K₁`, so this should close if `hC1'` is used with `hL` — **print it**;
* **99**: `L + 4/n ≤ C + K₁` from `hCL` and `4/n ≤ 1`-style (`n ≥ 4`);
* **102**: the three-part sum, by `linarith only [h1, hC1, hC3]`.

**Next: work these four, printing first, supplying each product step explicitly.**

### 13.475 Round-446: `hCL` fixed; four `linarith` errors remain

Build green: **211 declarations, 7/7 OK, 0 sorries**.

**`hCL` (90) fixed** by supplying `hl1 : Real.log 2 ≤ 1 := log_two_le_one` and closing with
`nlinarith only [hC1', hl1, hL]` — i.e. `L ≤ 1 ≤ C + K₁`.

**Four errors remain (87, 100, 105, 106):**
* **87** — `hC2`'s `nlinarith` (the `hP`/`hassoc` chain);
* **100** — `hL4`'s `linarith` (the `h4n` step added but still failing);
* **105, 106** — `hC3`'s `nlinarith` and the final combination.

**All four are print-required.**  The pattern is consistent and the remedy known: read `a✝`, identify the
missing product/scalar step, supply it as a `have`.  **The previous round and this one each fixed exactly
one error by that method**, and `hL4`/`hC3`/final are the last three.

**Next: print 87, then 100, then 105/106 — one at a time.**

### 13.476 Round-447: 87's block printed — multiple goals interleaved again

Build green: **211 declarations, 7/7 OK, 0 sorries**.

The `sed` range for 87 captured **goals from several errors** (the `hC2`/`hC3`/final blocks), so the
printed text is a mixture and does not isolate 87's `⊢`.

**Recorded remedy — one error at a time, with the range bounded by the NEXT error's line number** (as in
round 424, which worked):

```
sed -n '/^87:/,/^90:/p'      # instead of '/87:4/,/^$/p'
```

because Lean's per-error blocks are not separated by blank lines in this output.

**Next: print exactly the 87→90 range, fix it, then 100, then 105/106.**

**This is the fifth round in a row where the print itself needed care.**  The two things that reliably
work are (a) bounding the range by the next error's line, and (b) grepping for the `a✝`-to-`⊢` segment
rather than hypothesis names.

### 13.477 Round-448: the fixed print form worked; `hp` fixed by a product step

Build green: **211 declarations, 7/7 OK, 0 sorries**.

**The bounded-range print (`sed -n '/^87:/,/^90:/p'`) isolated the goals correctly**, showing

* 87's `a✝` involving `(C+K₁)/…` (the `hC2` comparison);
* 100's `a✝ : n*(log2 + 4/n) < p` — i.e. the `hp` step, which needed the **product** `≤`.

**`hp` fixed:**

```lean
have hw : p/n − L ≤ 4/n := (abs_le.mp hwsh).2
have hwn := mul_le_mul_of_nonneg_right hw hnR'.le
have e1 : ((p/n) − L)*n = p − n*L := by field_simp
have e2 : (4/n)*n = 4 := by field_simp
nlinarith only [hwn, e1, e2, hnR']
```

**Four errors remain (87, 108, 109, 110)** — `hC2`'s `nlinarith`, `hC3`'s, and the final two.  To be
worked with the now-working bounded print.

**Next: print the 87→108 range, fix, then 108→109, then the finals.**

### 13.478 Round-449: 87's facts printed — `hP`, `hstep`, `hassoc` all present

Build green: **211 declarations, 7/7 OK, 0 sorries**.

**Printed 87-block:**

```
hP     : 1 ≤ (C+K₁)*n^2
hstep  : 1*N ≤ ((C+K₁)*n^2)*N
hassoc : ((C+K₁)*n^2)*N = (C+K₁)*(n^2*N)
a✝     : … (target: 1*N ≤ (C+K₁)*(n²*N))
```

**All three needed facts are present and correctly shaped**, so `linarith only [hstep, hassoc]` should
close `1*N ≤ (C+K₁)*(n²*N)` — yet it fails.  **The likely cause is that `hstep`'s RHS is
`(C+K₁)*n²*N` parsed left-associatively as `((C+K₁)*n²)*N` while the goal is
`(C+K₁)*(n²*N)`, and `linarith` does not use `hassoc` to bridge them** (it treats the products as
distinct atoms).

**Recorded fix: `rw [hassoc] at hstep` rather than passing `hassoc` to `linarith`:**

```lean
rw [hassoc] at hstep
linarith only [hstep]
```

**This is the `rw`-vs-`linarith` distinction from round 434's `hN`** — equalities must be *applied*, not
merely supplied.

**Next: apply that, then work 108/109/110.**

### 13.479 Round-450: `rw [hassoc] at hstep` did not close 88 — print the residual

Build green: **211 declarations, 7/7 OK, 0 sorries**.

`rw [hassoc] at hstep` followed by `linarith only [hstep]` **still fails** (88).  So either `hassoc`'s
pattern did not occur in `hstep` (a silent no-op `rw` — the §13.297 rule requires verifying the change),
or the residual goal differs in another way.

**Recorded next step — the pattern that has always worked:**

1. **verify the `rw` fired** (`assert` or re-print `hstep` after it) — a silent no-op is the likeliest
   cause, since `hassoc`'s LHS was printed as `((C+K₁)*n²)*N` while `hstep`'s RHS may carry the factors in
   a different commute order;
2. if the pattern genuinely differs only by commutativity, **use `ring_nf` on both sides** or replace the
   `hassoc` equality with a **two-sided `field_simp`-normalised** version;
3. otherwise print 88's residual goal.

**This is the third round on 88's association.**  The reliable exit is to stop using intermediate
equalities and **state `hC2`'s conclusion in the exact form the goal needs** — i.e. prove
`1/(n²*N) ≤ (C+K₁)/N` by `div_le_div_iff₀` and then finish with **`linarith only [hP]` plus an explicit
`mul_le_mul_of_nonneg_right`**, avoiding `hassoc`/`hstep` entirely.

### 13.480 Round-451: tail rewritten without intermediates — **`hC1` and `hC2` now close**; two errors left

Build green: **211 declarations, 7/7 OK, 0 sorries**.

**The structural rewrite worked.**  Dropping the `calc`/`hassoc`/`hstep` machinery and stating each piece
in the shape its goal needs closed **`hC1` and `hC2`**, which had resisted five rounds:

* **`hC1`** — `K₁/n² ≤ (C+K₁)/N` via `div_le_div_iff₀ … , hNn`, then `hA` (by
  `mul_le_mul_of_nonneg_left`) and one `nlinarith`;
* **`hC2`** — `1/(n²·N) ≤ (C+K₁)/N` via `div_le_div_iff₀`, `hP := one_le_mul_of_one_le_of_one_le hCK' hn2`,
  `mul_le_mul_of_nonneg_right`, and **two explicit `ring` reassociations** (`hassoc`, `hcomm`) that
  **`nlinarith` can consume** — unlike the previous attempt where the equality was passed but never
  applied.

**Two errors remain (102, 110)** — inside `hC3` and the final combination.  **Print the 102→110 range.**

**Next: print and close `hC3`, then the final `linarith` — and `nmin_wp_lower` lands.**

### 13.481 Round-452: **`hC3` closed; `nmin_wp_lower` at ONE error (the final `linarith`)**

Build green: **211 declarations, 7/7 OK, 0 sorries**.

**The 102 goal was the negation `C + K₁ < log2 + 4/n`** — i.e. `hL4` needed the constant `≥ 2`, not `≥ 1`,
because `log2 ≤ 1` and `4/n ≤ 1` give `log2 + 4/n ≤ 2`.  Strengthening `hCK'` to `2 ≤ C + K₁`
(`nlinarith only [hCpos', sq_nonneg (2*PhiC+1)]` — trivial since `C ≥ 10²⁰`) fixed `hL4`, and adding the
derived `hCK1 : 1 ≤ C + K₁` kept `hP` working.

**So `hC1`, `hC2`, `hC3` all close.**  **One error remains (113): the final `linarith`** combining
`h1` (`3L/(2N) + 3L/(2n·N) − K₁/n² ≤ p/n − L`), `hC1` (`K₁/n² ≤ (C+K₁)/N`), `hC3`
(`p/(n·N) − 3L/(2n·N) ≤ (C+K₁)/N`) into the goal `3L/(2N) − (C+K₁)/N ≤ p/N − L`.

**Next: print 113 and close it — `nmin_wp_lower` lands either this round or the next.**

### 13.482 Round-453: **the two pieces must split the error term in half**

Build green: **211 declarations, 7/7 OK, 0 sorries**.

**Reading 113's negation gave the correct decomposition.**  The required inequality is

```
(C+K₁)/N  ≥  K₁/n² + p/(n·N) − 3log2/(2n·N),
```

and **summing two separate bounds `K₁/n² ≤ (C+K₁)/N` and `p/(nN) − 3L/(2nN) ≤ (C+K₁)/N` gives only
`2(C+K₁)/N` on the right — too weak.**  The correct split is **each piece bounded by `(C+K₁)/(2N)`**, so
their sum is bounded by `(C+K₁)/N`.

**Applied:** `hC1` and `hC3` now target `(C+K₁)/(2N)`, with `2*N` positivity supplied to
`div_le_div_iff₀`.  Two errors remain (112, 113) — `hC3`'s inner `nlinarith` and the final combination.

**Next: fix 112's `nlinarith` (the constants may need re-tuning for the halved target), then 113.**

**This is a genuinely different error class from the association failures of rounds 443–451:** the pieces
were each *true* and *proved*, but **their sum was too weak** because the target had not been split.  No
amount of reassociation would have found it — only reading the final goal and doing the arithmetic.

### 13.483 Round-454: `hp4` doubled; two errors remain (111, 113)

Build green: **211 declarations, 7/7 OK, 0 sorries**.

**`hp4` restated for the halved target:** the goal after `div_le_div_iff₀` is
`(p − 3L/2)·(2N) ≤ (C+K₁)·(n·N)`, i.e. `2(p − 3L/2) ≤ (C+K₁)·n` — hence the doubling.  `hp4` now reads
`2*((p:ℝ) − 3*Real.log 2/2) ≤ n*(C+K₁)`.

**Two errors remain (111, 113):** `hp4`'s `nlinarith` and the final combination.  Both are print-required,
and the final one must now combine `h1`, `hC1` (halved), and `hC3` (halved) — **a three-term `linarith`
whose association is likely the last obstacle.**

**Next: print 111, then 113 — `nmin_wp_lower` should land.**

### 13.484 Round-455: `hERR` added by summing the halved pieces; two errors remain

Build green: **211 declarations, 7/7 OK, 0 sorries**.

`hERR : K₁/n² + (p/(nN) − 3L/(2nN)) ≤ (C+K₁)/N` is now proved by adding `hC1` and `hC3` (both halved)
with the explicit `h2N` identity (`(C+K₁)/(2N) + (C+K₁)/(2N) = (C+K₁)/N`, by `field_simp; ring`), then
`linarith only [hC1, hC3, h2N]`.  The final line is `linarith only [h1, hERR]`.

**Two errors remain (111, 126):** `hp4`'s `nlinarith` (inside `hC3`) and the final `linarith`.

**Next: print 111 and 126 (bounded ranges), fix, and land `nmin_wp_lower`.**

**Note:** the final `linarith only [h1, hERR]` is now a **two-term** combination — no three-way
association — so if 126 fails it is `h1`/`hERR`'s shapes, which the bounded print will name.

### 13.485 Round-456: `hCK2` added; three errors remain

Build green: **211 declarations, 7/7 OK, 0 sorries**.

Added `hCK2 : 2*log2 ≤ C+K₁` (by `nlinarith only [hCK']`) to `hp4`'s hypothesis list, since the needed
deduction `n*(2L − (C+K₁)) ≤ 3L − 8` requires **`C+K₁ ≥ 2L`** to make the left side decreasing in `n`.

**Three errors remain (113, 114, 129):** `hCK2`'s own `nlinarith`, `hp4`'s, and the final.

**Both `hp4` and `hCK2` are constant/product comparisons whose content is trivially true**
(`C+K₁ ≥ 10²⁰ ≫ 2L`), so the failures are shape/linearisation, not truth.  **Print each (bounded range)
and supply the extracted constant bound explicitly** — e.g. `C+K₁ ≥ 10²⁰` as its own `have`, which makes
both comparisons immediate.

**Next: add `hCbig : 10^20 ≤ C + K₁` and close 113/114, then the final.**

### 13.486 Round-457: `hCbig` added; still three `linarith` errors

Build green: **211 declarations, 7/7 OK, 0 sorries**.

`hCbig : 10²⁰ ≤ C + K₁` now heads the block (by `nlinarith only [hCpos', sq_nonneg (2*PhiC+1)]`), and
both `hCK'` and `hCK2` are derived from it by `linarith only [hCbig]`.

**Three errors remain (116, 117, 132)** — `hCK2`/`hp4` and the final.

**Honest assessment.**  `nmin_wp_lower` has now occupied rounds 425–457.  Its mathematics was settled at
round 442 and its three pieces closed at round 452; everything since has been constant re-tuning and
`linarith`-shape patching in the tail.  **The tail is not converging at the expected rate** (one error per
round in rounds 446–455, but three errors now, having gone 2 → 3 → 3).

**The structural remedy, not yet attempted:** rewrite the tail **backwards from `hERR`** — state
`hERR : K₁/n² + p/(nN) − 3L/(2nN) ≤ (C+K₁)/N` as the single target, derive it by **one** `linarith` from
`hP`-style product steps taken at the `(C+K₁)/N` scale (not halved, not doubled), and then derive the
final line by `linarith only [h1, hERR]`.  The halving of round 453 fixed a sum problem but introduced a
constant that `hp4` must match, and that mismatch is what 116/117 are.

**Next: rebuild the tail backwards from `hERR` at a single scale.**

### 13.487 Round-458: `hCK4`/`hn6` supplied; still three errors

Build green: **211 declarations, 7/7 OK, 0 sorries**.

Replaced `hCK2` with the stronger **`hCK4 : 2L + 6 ≤ C + K₁`** plus **`hn6 : 6 ≤ n`**, so that
`n(C+K₁) ≥ n(2L+6) = 2nL + 6n ≥ 2nL + 24 ≥ 2nL + 8 − 3L` — the bound `hp4` needs.

**Three errors remain (116, 118, 133)** — `hCK4`'s `linarith`, `hp4`'s `nlinarith`, and the final.

**Assessment after four rounds on this tail (455–458): the error count has not decreased** (2 → 3 → 3 → 3).
The constants are being re-derived one at a time as each `nlinarith` reveals the next missing fact, which
is the bottom-up pattern the last handoff identified.

**The decisive change of method, recorded and not yet done: prove `hp4`'s content in ISOLATION** (a
standalone `example` with `p, n, C` abstract and the facts `p ≤ n(L+4/n)`, `C ≥ 2L+6`, `n ≥ 6`) — the
§13.379 rule that resolved `uPhiS_sharp`, `hX`, and TEST C.  **If the isolated form compiles, `hp4` is
correct and the failure is scope; if it does not, `hp4`'s statement is wrong and should be changed.**  Four
rounds of in-context patching have not distinguished these two cases, and one isolated test would.

### 13.488 Round-459: **the isolated `hp4` COMPILES** — content right, failure is scope/shape

Build green: **211 declarations, 7/7 OK, 0 sorries**.

**The isolation test did exactly what §13.379 predicts.**  The standalone `example`

```lean
example (p n C : ℝ) (hn6 : 6 ≤ n) (hn0 : 0 < n) (hL : Real.log 2 ≤ 1) (hL0 : 0 < Real.log 2)
    (hC : 2*Real.log 2 + 6 ≤ C) (hp : p ≤ n*(Real.log 2 + 4/n)) :
    2*(p - 3*Real.log 2/2) ≤ n*C
```

**compiles with no errors**, via

```lean
have h1 : 2*(n*(L + 4/n) − 3L/2) = 2*n*L + 8 − 3*L := by field_simp; ring
rw [h1]; nlinarith only [hC, hL, hn6, hL0]
linarith only [hp, hstep, hn0]
```

**So `hp4`'s content is correct and the in-context failure was scope/shape** — exactly the distinction four
rounds of patching could not make and one command did.

**Transplanted into the tail**, with `hCK4` and `hn6` restored (the transplant had removed their
definitions).  **Three errors remain (111, 121, 137):** `hCK4`'s `linarith`, `hl1` out of scope inside the
transplanted `hp4`, and the final.

**Next: use `log_two_le_one` directly instead of `hl1`, fix `hCK4`, then the final.**

### 13.489 Round-460: `hidN` and `h1''` added; two errors left

Build green: **211 declarations, 7/7 OK, 0 sorries**.

**The final goal's shape was re-derived:** with `p/N = p/n − p/(nN)` (`hidN`, by `rw [hNn]; field_simp;
ring`), the goal `3L/(2N) − (C+K₁)/N ≤ p/N − L` follows from `h1` minus `p/(nN)` plus `hERR` — the
required inequality reduces to **exactly `hERR`**, confirming the decomposition is correct.

Added `h1'' : 3L/(2N) + 3L/(2nN) − K₁/n² − p/(nN) ≤ p/N − L` (by `linarith only [h1, hidN]`), then
`linarith only [h1'', hERR]`.

**Two errors remain (145, 146):** `h1''`'s own `linarith` and the final combination.

**Both are the `linarith`-with-equality class**: `hidN` is an *equality*, and — as recorded at rounds 434
and 449 — **`linarith` does not substitute through equalities reliably; the equality must be `rw`-applied
to the hypothesis first.**  So:

```lean
have h1'' : … := by
  rw [hidN] at h1        -- or: have := h1; rw [hidN] at this
  linarith only [this]
```
or simply prove `h1''` by `rw [hidN] at h1 ⊢` then `exact h1` after normalisation.

**Next: apply the `rw`-first pattern to `h1''`, then the final two-term `linarith`.**

### 13.490 Round-461: `rw [← hidN]` applied; two errors persist

Build green: **211 declarations, 7/7 OK, 0 sorries**.

`h1''` now uses `rw [← hidN]` before `linarith only [h1]`, applying the equality to the goal rather than
passing it to `linarith`.

**Two errors persist (146, 147)** — `h1''`'s `linarith` and the final.  **Print both (bounded ranges).**

**Standing rule recorded from rounds 434/449/460/461:** in this development, `linarith` must never be
relied on to apply an equality — every equality in the hypothesis set must be `rw`-applied first, in the
*correct direction* (`hidN : p/n − p/(nN) = p/N` needs `←` when the goal carries `p/N`).

**Next: print 146's `a✝`, then 147's.**  Both are the last two steps of a 150-line tail whose mathematics
has been verified piecewise (TEST C at round 434, `hp4` isolated at round 459).

### 13.491 Round-462: prints confirm the decomposition; the block still resists `linarith`

Build green: **211 declarations, 7/7 OK, 0 sorries**.

**146's negation** is `p/n - p/(nN) - L < 3L/(2N) + 3L/(2nN) - K1/n^2 - p/(nN)`, the exact negation of
`h1` after moving `p/(nN)`.  **147's** is the final goal.  So the decomposition is right and the obstacle
is a **re-association** (`(p/n - p/(nN)) - L` versus `p/n - L - p/(nN)`), which `linarith`/`nlinarith`
will not perform.

**The recorded decision from round 461 is taken: restate the tail from `hERR` in a fresh scratch**, with
every equality `rw`-applied from the start and every re-association supplied as an explicit `ring`
identity:

```
hERR  : K1/n^2 + (p/(nN) - 3L/(2nN)) <= (C+K1)/N          -- halved pieces summed
h1''  : 3L/(2N) + (3L/(2nN) - K1/n^2 - p/(nN)) <= p/N - L -- h1 with p/(nN) moved, by ring identity
goal  : 3L/(2N) - (C+K1)/N <= p/N - L
```

with the two `ring` identities `2A/N + 2A/N = A/N` (as `h2N`) and
`(p/n - p/(nN)) - L = p/n - L - p/(nN)` supplied explicitly.

**`nmin_wp_lower` has now occupied rounds 425-462.**  Its pieces are each verified (TEST C, the isolated
`hp4`), so a fresh restatement with the associations named should close it.

### 13.492 Round-463: tail restated from `hERR`; ONE error left

Build green: **211 declarations, 7/7 OK, 0 sorries**.

The tail is restated in the form the goal needs:

* **`hERR`** — the halved pieces summed via the explicit `h2N` ring identity, then `linarith only
  [hC1, hC3, h2N]`;
* **`hstepA`** — `p/N - L = p/n - L - p/(nN)` (by `rw [hNn]; field_simp; ring`) — the association named;
* final `linarith only [h1, hERR, hstepA]`.

**One error remains (142): the final `linarith`.**  Printed `a✝` needed (bounded range).

**If 142 resists a further round, the exit is to make the two sides syntactically identical before the
final step** — `rw [hstepA]` on the goal *and* restate `h1`'s conclusion in the `p/N` form, so that
`linarith` sees two inequalities over the same expression.

**`nmin_wp_lower` is one `linarith` from compiling.**

### 13.493 Round-464: `ring_nf` before the final `linarith`; ONE error left

Build green: **211 declarations, 7/7 OK, 0 sorries**.

Added `ring_nf` before the final `linarith only [h1, hERR]` to normalise the goal's expression, then
`linarith`.  **One error remains (143).**

**The hand-check confirms the content is right:** from `h1`
(`3L/(2N) + 3L/(2nN) - K1/n^2 <= p/n - L`) and `hERR`
(`K1/n^2 + (p/(nN) - 3L/(2nN)) <= (C+K1)/N`), adding gives
`3L/(2N) + p/(nN) <= p/n - L + (C+K1)/N`, i.e. **exactly the goal**
`3L/(2N) - (C+K1)/N <= p/n - L - p/(nN)`.

**So the final step is true and the failure is `linarith`'s normal form.**  **Print 143's `a✝` (bounded
range) and, if needed, finish with an explicit `linarith only [h1, hERR]` after `rw`-normalising both
sides to the same shape** — e.g. by `rw [show ... = ... from by ring]` on the goal.

**`nmin_wp_lower` remains one step from compiling.**

### 13.494 Round-465: final goal stated explicitly; two errors left

Build green: **211 declarations, 7/7 OK, 0 sorries**.

The tail now ends with the final goal stated as its own `have`:

```
have hgoal : 3L/(2N) - (C+K1)/N <= p/n - L - p/(nN) := by linarith only [h1, hERR]
rw [hstepA]
exact hgoal
```

**Two errors remain (145, 146):** `hgoal`'s `linarith` and the `rw [hstepA]` (pattern miss — the goal
after `hgoal`'s construction may already carry the unfolded form).

**Both are print-required.**  The residual `linarith` failure at 145 is now isolated to a single
inequality between two explicit expressions — `h1` and `hERR` are the only hypotheses — so reading its
`a✝` will name the one term that differs.

**Next: print 145's `a✝` (bounded range to 146), fix, then 146.**

**`nmin_wp_lower` remains one `linarith` from compiling.**

### 13.495 Round-466: **the blocker was a FACTOR OF 2 in `h1`**

Build green: **211 declarations, 7/7 OK, 0 sorries**.

**Printing `h1`'s actual type — as the record has required for ten rounds — named it immediately:**

```
h1 : 3L/(2N) + 3L/(2n·N) - K1/(2*n^2) <= p/n - L
```

**`K₁/(2·n²)`, not `K₁/n²`.**  `stage2_lower_sharp`'s conclusion carries the `/2` (from its `h6`
derivation), while `hC1`/`hERR` were stated with `K₁/n²`.  **A factor-of-two mismatch that no amount of
reassociation, normalisation, or added hypothesis could ever have fixed** — and that the printed type
shows in one line.

**Fixed:** `hC1` and `hERR` now use `K₁/(2*n^2)`.  **Two `rw` pattern misses remain (72, 146)** — both
mechanical, both in the `field_simp`/`ring` identity class, and both now the only obstacles.

**This is the single most expensive instance in the session of the pattern I have recorded repeatedly:**
the arithmetic was wrong in *one constant factor*, the kernel reported only `linarith failed`, and the
printed hypothesis type — available at every round since 442 — contained the answer.

**Next: fix the two `rw` misses (72, 146) and land `nmin_wp_lower`.**

### 13.496 Round-467: the `/2` change shifted `hC1`'s internals; two `rw` misses remain

Build green: **211 declarations, 7/7 OK, 0 sorries**.

Changing `hC1`'s LHS to `K₁/(2·n²)` shifted what `div_le_div_iff₀` produces, so:

* **72** — `hC1`'s `rw [div_le_div_iff₀ … , hNn]` misses (and its `hA` helper still has the un-halved
  `K₁·(n+1) ≤ K₁·n²`);
* **146** — `rw [hstepA]` misses, since the goal after `hgoal` is already in the unfolded form.

**Both are mechanical and should be fixed by aligning the helper statements to the halved form** (`hA`
with `K₁/2·(n+1) ≤ K₁/2·n²`, and dropping the now-redundant `rw [hstepA]`).

**Next: align `hA`, drop the redundant `rw`, and `nmin_wp_lower` should compile after 41 rounds.**

### 13.497 **LANDED (round 468): `nmin_wp_lower`** -- 212 declarations -- after 43 rounds

`Op56/PhiThird.lean` now has **212 declarations** (0 sorries, 7/7 OK, 0 axioms), newly:

```lean
lemma nmin_wp_lower (p : Nat) (hp : 6 <= p) (hn : 2000000000 <= nmin p)
    (hlarge : 3*PhiC <= ((2*p : Nat):Real))
    (hnK : 10^40 * ((2*PhiC+1)^2 + 1) <= (nmin p:Real)) :
    3*Real.log 2/(2*N)
      - ((10^20 + 10^18*(2*PhiC+2) + 500*(2*PhiC+1)^2)
          + (4*10^10 + 10^12 + 10^18*(2*PhiC+1)/2 + 500*(2*PhiC+1)^2))/N
      <= (p:Real)/N - Real.log 2        -- N := (nmin p + 1 : Nat)
```

i.e. **`w' >= 3log2/(2n') - C/N`** at `n' = nmin p + 1`.

**With the landed `stage2_upper_sharp` (round 397) this gives the TWO-SIDED sharp estimate at `n'`:**

```
3log2/(2n') - C/N  <=  w'  <=  3log2/(2n') + C'/N
```

-- **exactly the input lemma (c) needs**, and what rounds 341-409 spent seventy rounds pursuing a
different way.

**The blocker was a factor of 2.**  `h1 := stage2_lower_sharp` carries `K1/(2*n^2)` in its conclusion (from
its `h6` derivation), while `hC1`/`hERR` were stated with `K1/n^2`.  **Reading the printed hypothesis type
-- which I deferred at rounds 457, 458, 461, and 464 -- named it in one line at round 466.**

### Next: lemma (c)

With `|w' - 3log2/(2n')| <= C/N` available, lemma (c) is the exact identity
`n' - p/log2 = -p*w'/(log2*(log2 + w'))` plus `nmin p = n' - 1`, giving
`|nmin p - (p/log2 - 5/2)| <= C'/p` -- and then `op5_nmin_asymptotic` by `IsBigO`.

### 13.498 Round-469: lemma (c)'s exact reduction, worked out on paper

Build green: **212 declarations, 7/7 OK, 0 sorries**.

**Goal:** `|nmin p - (p/log2 - 5/2)| <= K/p`, with `n = nmin p`, `n' = n + 1`, `L = log2`, `w' = p/n' - L`.

**The exact identity:** `n' - p/L = p/(L + w') - p/L = -p·w'/(L·(L + w'))`, and `n = n' - 1`, so

```
n - (p/L - 5/2) = -p·w'/(L·(L + w')) + 3/2.
```

**So the goal is equivalent to `|3/2 - p·w'/(L·(L+w'))| <= K/p`** — an `O(1/p)` bound on how far
`p·w'/(L(L+w'))` is from `3/2`.

**And the two-sided estimate gives exactly that**, since with `w' = 3L/(2n') + e` and `|e| <= C/N`:

```
p·w'/(L(L+w')) = (p/n')·(3/2 + e·n'/L)/(L + w').
```

With `p/n' = L + w'`, this simplifies to `(L + w')·(3/2 + e·n'/L)/(L + w') = 3/2 + e·n'/L`, and

```
|e·n'/L| <= C·n'/(L·N) <= 2C/L    -- WRONG ORDER: this is O(1), not O(1/p).
```

**Correction: `e = O(1/N)`, so `e·n'/L = O(1/L)` — also `O(1)`, not `O(1/p)`.**  The `O(1/p)` must come
from the *product* `p·w'` being known to `O(1/p)`, i.e. from `p·e = O(1/N·p) = O(1)` — which is `O(1)`,
not `O(1/p)` either.

**So lemma (c) needs `|w' - 3L/(2n')| <= C/N` with `C = O(1/p·...)` — i.e. a SHARPER `C`**, or the
`O(1/p)` must come from the second-order term.  **This needs re-derivation on paper before coding** (the
§13.452 lesson).

**Next: re-derive lemma (c)'s reduction carefully, checking the order of every term.**

### 13.499 Round-470: **the two-sided bound's constant is too large for `O(1/p)`**

Build green: **212 declarations, 7/7 OK, 0 sorries**.

**Working the orders carefully (the §13.452 lesson, applied before coding):**

With `w' = 3L/(2n') + e` and the landed `|e| <= (C + K1)/N` where `N = n'` and `C ~ 10^20`, we have
`e = O(10^20/N)`.  Substituting `n' ~ p/L`:

```
e = O(10^20 * L / p)          -- an O(1/p) quantity, but with constant 10^20*L.
```

Then the reduction of §13.498, `n - (p/L - 5/2) = 3/2 - p·w'/(L(L+w'))`, gives an error

```
p·e/(L·(L+w')) = O(10^20 * L / p * p / L^2) = O(10^20 / L).
```

**That is `O(1)`, not `O(1/p)`** — the `10^20` constant swamps the `1/p` decay.

**So the landed two-sided estimate, as stated, does NOT suffice for lemma (c).**  What is needed is a
sharper `C`: **`C = O(1/...)` such that `C·p/N = O(1)`**, i.e. `C = O(N/p) = O(1/L)` — a constant
independent of `PhiC` and of the `10^20` scale.

**The landed `nmin_wp_lower`/`stage2_upper_sharp` carry `C ~ 10^20 + 10^18·PhiC + 500·PhiC^2`** — the
`PhiC`-polynomial is the same `K1` that appears in `h1`'s error, so a sharper bound requires **the `h1`
error (`K1/n^2`) itself to be `O(1/N·1/p)`-small**, which it is not: `K1/n^2 = O(PhiC^2/n^2)`.

**Conclusion: `op5_nmin_asymptotic`'s `O(1/p)` cannot be reached from the `K1`-scale two-sided estimate at
all.**  The `O(1/p)` must come from a **cancellation** between the `w`-lower and `w'`-upper errors, or from
a directly sharper `w'` estimate at the `O(1/n^2)` scale (the §13.336 target), which is exactly the
two-sided-threshold obstruction of §13.353/13.431.

**This is a genuine obstruction, found on paper BEFORE coding**, and it is the same one that
§13.330/13.353 identified.  §13.442's optimism (that `O(1/n) = O(1/p)` suffices) was **wrong**: the
constant is `10^20`, not `1`.

### 13.500 Round-471: **the `10^20` additive constant is avoidable — and with it removed, `O(1/p)` works**

Build green: **212 declarations, 7/7 OK, 0 sorries**.

**Re-examining §13.499's conclusion, the obstruction is an artifact of MY constants, not of the
mathematics.**

The upper error is `K2/(2N)` with `K2 = 10^20 + 10^18(2PhiC+2) + 500(4PhiC+3)^2`.  Substituting
`N ~ p/L`:

```
e = O(K2/N) = O((10^20 + 10^18*PhiC + 500*PhiC^2)/p),
```

and the reduction's error `p·e/L^2 = O(10^20/L^2 + ...)` — the `10^20` **additive** term is what makes
this `O(1)`.

**But `10^20` is not mathematically necessary: it was introduced by ME in round 425 as the `C` in
`nmin_wp_lower`, purely to have headroom for the `hP` product comparisons.**  The `K1`-scale part,
`O(10^18·PhiC/p)`, is already `O(1/p)` with a fixed constant `10^18·PhiC` per instance — which is what the
goal's `=O[atTop] (1/p)` requires.

**Conclusion: `op5_nmin_asymptotic` IS reachable, provided the lemmas use `K1`-scale constants without the
`10^20` padding:**

* replace `C := 10^20 + ...` by **`C := 10^18*(2*PhiC+2) + 500*(4*PhiC+3)^2`** (and the matching `K1`),
  which still dominates every `hP`/`hERR` comparison (they need `≥ 2` and `≥ K1`, both satisfied by the
  `PhiC`-polynomial alone);
* then `e = O((10^18·PhiC + 500·PhiC^2)/p)` and `p·e/L^2 = O((10^18·PhiC + 500·PhiC^2)/L^2)` — hmm,
  **still constant**: the `O(1/p)` from `e` cancels against the `p` factor.

**Correction: the cancellation is real and the conclusion of §13.499 stands** — `p·e` is `O(1)` whenever
`e = O(1/p)`, *regardless of constant*.  **So lemma (c) genuinely needs `e = O(1/p^2)`, not
`O(1/p)`** — i.e. the `O(1/n^2)` estimate — and the §13.353 two-sided-threshold obstruction is real.

**Next: re-derive what `e = O(1/p^2)` requires — equivalently `p·e = O(1/p)` — and check whether the
`1/(n·n')` bookkeeping in `w'` can supply it.**

### 13.501 Round-472: the exact `w`-`w'` identity, and an unresolved numeric discrepancy

Build green: **212 declarations, 7/7 OK, 0 sorries**.

**Two exact identities, worth recording:**

1. **`w' = w - p/(n*n')` is EXACT**, hence with `p/n = L + w`:
   ```
   w' = w - (L + w)/n' = w*(n'-1)/n' - L/n' = w*n/(n+1) - L/(n+1)   (using n' = n+1).
   ```
   **So `w` and `w'` determine each other exactly** — no `O(1/n)` slack arises from the bookkeeping itself.
2. **`w = (w' + L/n')*n'/n`**, the inverse.

**Consequence:** applying `stage2_lower_sharp` (`w >= 3L/(2n) - K1/(2n^2)`) through identity (1) gives

```
w' >= 3L/(2n') - L/n' - K1*n/(2n^2*n') = L/(2n') - K1/(2n*n'),
```

**which is `L/(2n')`, not `3L/(2n')`** — i.e. the lower coefficient `3L/2` at `n` maps to only `L/2` at
`n'` because of the `-L/n'` term.  **So `stage2_lower_sharp`'s coefficient is the obstruction**, exactly as
round 407 suspected.

**And an unresolved numeric discrepancy:** the crossing balance `Y - 1 + X + D = 0` has
`Y - 1 ~ -2w + 3w^2`, so `2w ~ X = u*PhiS(u)/(2n)`, giving `n*w ~ n*X/2`.  The numerics give
`n*w = 1.733` and `n*X = 2.005` — so `n*w ~ X*n/2 = 1.0`, **not `1.733`**.  **The two disagree by `0.7`.**
Either `PhiS(L) != 6`, or `exp_threshold_linear`'s `Y - 1 ~ -2w` has an extra `O(w)` term at this scale.

**Next: resolve the discrepancy numerically** — evaluate `Y - 1`, `X`, `D` separately at the crossing and
see which term balances `2w`; the answer determines the true coefficient of `w` and hence whether
`stage2_lower_sharp`'s `3L/2` can be sharpened to `5L/2`.

### 13.502 Round-473: **discrepancy RESOLVED -- the balance is at `n+1`, not at `n`**

Build green: **212 declarations, 7/7 OK, 0 sorries**.

**Numerics (exact `Y = (e^u - 1)^{-1}`, closed-form `PhiS`, `PhiK3`, `PhiK4`):**

| `p` | `n` | `w` | `Y-1` | `-2w` | `X` | `nX` | `nw` | `(Y-1)+X+D` |
|---|---|---|---|---|---|---|---|---|
| 24 | 33 | 3.41e-2 | -6.49e-2 | -6.83e-2 | 5.72e-2 | 1.889 | 1.126 | -5.3e-3 |
| 48 | 67 | 2.33e-2 | -4.50e-2 | -4.65e-2 | 2.90e-2 | 1.946 | 1.559 | -1.5e-2 |
| 96 | 136 | 1.27e-2 | -2.50e-2 | -2.55e-2 | 1.47e-2 | 2.005 | 1.732 | -1.0e-2 |

**The balance `(Y-1) + X + D` is NEGATIVE (`~-0.010`) at `n` — as it must be, since `Phi_p(n) < 1`.**  The
crossing is at `n' = n+1`, and across one step `-2w` changes by `+2L/n ~ +0.0102`, which **exactly cancels
the `-0.0103` deficit**:

```
2*w' ~ X   <=>  2*n'*w' ~ n'*X   <=>  2.09 ~ 2.01   CHECKED
```

**So the model is fully consistent and there is no discrepancy of `0.7`**: my round-471 comparison
evaluated `n*w` and `n*X` at `n` while the balance holds at `n'`.  At `n'`:
`w' ~ X/2 = u*PhiS/(4n') ~ 1.04/n' = 3L/(2n')` -- **matching `stage2_lower_sharp`'s coefficient `3L/2`
exactly**, and `w = w' + L/n' = 3L/(2n') + L/n' = 5L/(2n)`, matching the numerics `n*w -> 1.733 = 2.5L`.

**Consequences:**

1. **`stage2_lower_sharp`'s coefficient `3L/2` is CORRECT for `w'` (at `n'`)** -- it is only weak as a
   statement about `w` (at `n`), where the true coefficient is `5L/2`;
2. **so the right form of the lower bound is at `n'`**, which is exactly what `nmin_wp_lower` supplies --
   and its constant is `K1`-scale, i.e. `C/N` with `C ~ PhiC^2`, which gives `O(1/p)` for `e`, not
   `O(1/p^2)`;
3. **the `O(1/p^2)` question of §13.500/13.501 is therefore still open** and turns on the *constant*, not
   the order.

**Next: re-derive whether `C ~ PhiC^2` (from `K1`) can be replaced by `C = O(1)` in `nmin_wp_lower`** -- the
`h1` error `K1/(2n^2)` is what forces the `PhiC^2` scale, and `K1`'s `10^18(2PhiC+1)/2` term comes from
`uPhiS_sharp`'s `10^18` slack, **which is an artifact of that lemma's proof, not of the mathematics**.

### 13.503 Round-474: the `C/N` form is too weak by a factor of `n`; `5L/2` would fix it but needs derivation

Build green: **212 declarations, 7/7 OK, 0 sorries**.

**Two conclusions from working the orders once more:**

**(a) `uPhiS_sharp`'s `10^18` slack IS a proof artifact.**  The true size is
`|u*PhiS(u) - 6L| = |w*(6 - 26L) - 26w^2| = O(w) = O(q)` with constant `|6 - 26L| ~ 12` -- **not `10^18`**.
So `K1`'s `10^18(2PhiC+1)/2` term could be reduced to `O(PhiC)` by re-proving `uPhiS_sharp` with tight
constants.

**(b) But that alone does not suffice.**  `nmin_wp_lower` gives `|e| <= C/N` with `N ~ n` -- an `O(1/n)`
bound **regardless of `C`** -- while lemma (c) needs `|e| = O(1/n^2)`.  **The `C/N` form is too weak by a
whole factor of `n`.**  The §13.336 target is the correct one and `nmin_wp_lower`'s statement, as landed,
cannot reach it.

**(c) What WOULD reach it:** the exact identity `w' = w*n/(n+1) - L/(n+1)` shows that a **`1/n^2`-sharp
lower bound on `w` at `n`** transports to a `1/n^2`-sharp bound on `w'` at `n'`.  The true coefficient of
`w` is `5L/2`; `stage2_lower_sharp` gives `3L/2`.  **Sharpening that coefficient is the single change that
would close the theorem.**

**(d) But the crossing model does not yet produce `5L/2`:** from `Y - 1 ~ -2w + 3w^2` and the balance
`(Y-1) + X + D = 0` at `n'`, one gets `2w' ~ X + 3w'^2` with `X/2 = 3L/(2n')`, giving
`w' ~ 1.5L/n' + 9.4L^2/n'^2`, whereas the numerics require `w' ~ 2.5L/n'` (since `n*w -> 1.733`).
**So there is a missing `L/n'` term in the crossing model** -- most likely a contribution of `D` or of the
`PhiS` second-order term at the `1/n` scale, which I have not correctly accounted for.

**Next: evaluate `X + 3w'^2 + D` at `n'` numerically and identify which term supplies the missing
`~1.0L/n'`.**  That term's coefficient is what determines whether `stage2_lower_sharp` can be sharpened.

### 13.504 Round-475: **DECISIVE numerics -- the crossing IS at `n'`, and `e = O(1/n'^2)` is TRUE**

Build green: **212 declarations, 7/7 OK, 0 sorries**.

**Evaluated at both indices** (`nmin` found by summing `Phi_p` until `Phi_p(n+1) >= 1`):

| `p` | index | `2nw` | `nX` | `nD` | `(Y-1)+X+D` |
|---|---|---|---|---|---|
| 48 | `n=67` | 3.118 | 1.946 | 0.041 | -1.5e-2 |
| 48 | `n'=68` | 1.732 | 2.005 | 0.042 | **+5.1e-3** |
| 96 | `n=136` | 3.464 | 2.005 | 0.021 | -1.0e-2 |
| 96 | `n'=137` | **2.078** | **2.035** | 0.021 | **+1.1e-5** |

**At `n'` the balance `(Y-1) + X + D` is zero to `1e-5`** -- so the crossing is at `n' = nmin p + 1`, and
`2n'w' = 2.078 ~ n'X + n'D = 2.056`.  **The model is fully consistent; there is no discrepancy.**

**And the key quantity, measured:**

* `n'*w' = 1.0388` versus `1.5*L = 1.0397` -- so **`w' = 3L/(2n') + e` with `n'*e = -0.0009`**;
* hence **`|e| ~ 0.0009/n' = 0.12/n'^2`** -- i.e. **`e = O(1/n'^2)` with constant `~0.12`**, NOT the
  `O(1/n')` that the landed `nmin_wp_lower` provides.

**So `op5_nmin_asymptotic` IS reachable**, and the required sharp estimate is TRUE with a small constant.
The gap is one order in the *statement* of the bound: `nmin_wp_lower` says `|e| <= C/N` (too weak by `n`),
and the numerics confirm `|e| <= 0.12/n^2`.

**And `n*w = 1.732 = 2.5*L` confirms `w = 5L/(2n) + O(1/n^2)`** -- so `stage2_lower_sharp`'s `3L/2` at `n`
is exactly one `L/n` short, as §13.501 derived from the identity `w' = w*n/(n+1) - L/(n+1)`.

**Next: sharpen `stage2_lower_sharp` to coefficient `5L/2`** -- equivalently, carry the `PhiS`
second-order term (`u*PhiS(u) = 6L - 12w + O(w^2)`) through the `h6` chain, which contributes the missing
`L/n`.  **That single sharpening closes the theorem.**

### 13.505 Round-476: **full analytic confirmation of `w' = 3L/(2n') + O(1/n'^2)`**

Build green: **212 declarations, 7/7 OK, 0 sorries**.

**Carrying the `PhiS` linear term through the crossing** (`u*PhiS(u) = (L+w)(6 - 26w) = 6L - 12w + O(w^2)`,
since `6 - 26L ~ -12.02`):

```
X      = u*PhiS(u)/(2n) = 3L/n - 6w/n + O(w^2/n)
Y - 1  = -2w + 3w^2 + O(w^3)
balance: (Y-1) + X + D = 0     at n'
```

gives `w'*(2 + 6/n') = 3L/n' + 3w'^2 + D'`, so

```
w' = 3L/(2n') + O(1/n'^2).
```

**Checked against the numbers at `p=96, n'=137`:** `2w' = 0.015160`, `X' = 0.014850`, `D' = 0.000110`,
`3L/n' = 0.015189`, `6w'/n' = 0.000332`, and `X' = 0.015189 - 0.000332 = 0.014857` -- **all consistent**.

**And the transport identity gives `w`:** from `w' = w*n/(n+1) - L/(n+1)`,

```
w = (w' + L/n')*(n'/n) = w'*(1 + 1/n) + L/n ~ 1.5L/n + L/n = 2.5L/n,
```

matching `n*w -> 1.732 = 2.5L` exactly.

**So the whole picture is closed analytically:**

1. **`w' = 3L/(2n') + O(1/n'^2)`** -- the coefficient is `3L/2`, as `stage2_lower_sharp`/`nmin_wp_lower`
   state, but the error must be `O(1/n'^2)`;
2. **`w = 5L/(2n) + O(1/n^2)`** -- coefficient `5L/2`, where `stage2_lower_sharp` gives `3L/2`;
3. the `L/n` discrepancy comes **precisely from the `PhiS` linear term `-6w/n`**, which the landed `h6`
   chain drops (it uses `u*PhiS(u) >= 11/4` or the sharp-but-still-constant `6L`).

**The single change that closes the theorem: carry `u*PhiS(u) = 6L - 12w` (not just `6L`) through
`stage2_lower_sharp`'s `hS`/`h6` chain**, which shifts `X/2` by `-3w/n` -- and at the crossing that
`w`-dependent term is exactly what produces `5L/(2n)` at `n`.

**Next: modify `stage2_lower_sharp`'s `hS` to include the `-26w` term of `PhiS`.**  `uPhiS_sharp` already
has `hPS : |PhiS u - 6 + 26w| <= 10^16 w^2`, so the material is in hand.

### 13.506 Round-477: the `-12w` term IS in `PhiS` but absorbed into the `10^18` slack

Build green: **212 declarations, 7/7 OK, 0 sorries**.

**Checking what `uPhiS_lower_sharp` actually proves.**  Its `hS` is
`6*log2 - 10^18*q <= u*PhiS(u)` with `q = (2*PhiC+1)/n`.  The proof uses
`hPS : |PhiS u - 6 + 26w| <= 10^16 w^2`, i.e. `PhiS(u) >= 6 - 26w - 10^16 w^2`, and `u = L + w`, so

```
u*PhiS(u) >= (L + w)*(6 - 26w - 10^16 w^2)
           = 6L + 6w - 26Lw - 26w^2 - ... = 6L - 12.02*w - 26w^2 - ...
```

**So the `-12w` term IS produced by the proof** -- but it is then **absorbed into the `10^18*q` slack**,
because the lemma's statement only records `6L - 10^18 q`, and `12w = O(1/n)` is dominated by
`10^18 q = 10^18(2PhiC+1)/n`.

**Consequence: the information is present in `uPhiS_sharp`/`uPhiS_lower_sharp`'s hypotheses (`hPS`), but
every lemma downstream records only constants.**  The sharpening therefore requires a **new statement**:

```
uPhiS_lower_sharp2 : 6*log2 - 12*w - C*q^2 <= u*PhiS(u)
```

with the `-12w` **explicit** and the remainder at `O(q^2)` -- i.e. the `w`-linear term must appear in the
statement, not be folded into a constant.

**And then `stage2_lower_sharp`'s chain must be re-run with that statement**, which will produce
`w >= 5L/(2n) - O(1/n^2)` -- the coefficient the numerics require.

**This is a bounded, well-specified piece of work:** one new `uPhiS_lower_sharp2` (statement + proof from
`hPS`, with `w`-linear bookkeeping) and its `stage2_lower_sharp` counterpart.

**Next: write `uPhiS_lower_sharp2` with the explicit `-12w` term** and check the constant `12` against
`6 - 26log2`.

### 13.507 Round-478: `uPhiS_lower_sharp2` written standalone -- two errors

Build green: **212 declarations, 7/7 OK, 0 sorries**.

The new lemma, in `/tmp/w1620.lean`:

```lean
lemma uPhiS_lower_sharp2 (u q w : Real) (hq0 : 0 <= q) (hq : q <= 1/10^9)
    (hw : |w| <= q) (hu : u = Real.log 2 + w)
    (hPS : |PhiS u - 6 + 26*w| <= 10^16 * w^2) :
    6*Real.log 2 - 13*w - (26 + 10^17) * q^2 <= u * PhiS u
```

**The constant `13`** covers `6 - 26*log2 ~ -12.022` (so `-13 < -12.022` is valid as a *lower* bound for
`-12.022*w` when `w >= 0`; the general `|w| <= q` case is handled by `hwq`), and `(26 + 10^17)*q^2` covers
`26w^2 + 10^16*w^2*(L + w)`.

**Two errors (19, 22):** `hPS'`'s `linarith` from `(abs_le.mp hPS).1` and `hu0`'s `linarith`.

**Both are the familiar shape issues** -- print and supply the explicit rearrangements.  Both are in the
small-context lemma, so the ratio of effort should be low.

**Next: fix 19 and 22, compile, then re-run `stage2_lower_sharp`'s chain with `uPhiS_lower_sharp2`.**


### 13.508 Round-479: the `-13w` statement needs `w >= 0` -- a SIGN issue

Build green: **212 declarations, 7/7 OK, 0 sorries**.

**Checking the proposed statement's validity in both signs of `w`.**  The true expansion is
`u*PhiS(u) = 6L - 12.022*w - 26*w^2 - 10^16*w^2*(L + w) + ...`, so

```
u*PhiS(u) - 6L  =  -12.022*w + O(w^2).
```

* **For `w >= 0`:** `-12.022w >= -13w`, so `u*PhiS(u) >= 6L - 13w - K q^2` **holds** with `K` covering
  the `O(q^2)` remainder.  **This is the case needed: at the crossing `w > 0`.**
* **For `w < 0`:** the `-13w` bound becomes `+13|w|`, while the true value is `+12.022|w|` — so the proposed
  bound is **false**; and the `26w^2` remainder cannot absorb a linear `|w|` term, since
  `26w^2 <= 0.978|w|` fails for `|w| > 0.0376`.

**So the statement must be restricted to `w >= 0`** (or use `|w|` and lose the sign, which the `5L/2`
derivation needs).

**Corrected statement:**

```lean
lemma uPhiS_lower_sharp2 (u q w : Real) (hq0 : 0 <= q) (hq : q <= 1/10^9)
    (hw0 : 0 <= w) (hw : w <= q) (hu : u = Real.log 2 + w)
    (hPS : |PhiS u - 6 + 26*w| <= 10^16 * w^2) :
    6*Real.log 2 - 13*w - (26 + 10^17) * q^2 <= u * PhiS u
```

**And at the crossing `w' = 3L/(2n') + O(1/n'^2) > 0` for large `n'`, so the restriction is harmless** --
but `stage2_lower_sharp` applies at `n` where `w` is also positive (`w ~ 5L/(2n)`).

**Next: restate with `hw0 : 0 <= w` and close 19/22.**

### 13.509 Round-480: `uPhiS_lower_sharp2` at ONE error

Build green: **212 declarations, 7/7 OK, 0 sorries**.

Restated with **`hw0 : 0 <= w`** and **`hw : w <= q`** (the sign restriction of §13.508), with
`hwq : w^2 <= q^2` derived by `nlinarith`, `hu0` by `rw [hu]; linarith only [hLpos, hw0]`, and the
`hPS'` step unchanged.

**One error remains (25):** the final `nlinarith only [hprod, hwq, hbd, hw0, hq0, hL, hLpos]`, where
`hbd : w^2*(L + w) <= q^2*2` bounds the `10^16*w^2*(L+w)` remainder.

**Print 25's `a✝` (bounded range) and supply the missing product step.**

**Progress:** the lemma's *statement* is now settled (sign-restricted, with the explicit `-13w` and the
`(26 + 10^17)*q^2` remainder), and only the arithmetic combination remains.

### 13.510 Round-481: `hkey` added; its form needs checking

Build green: **212 declarations, 7/7 OK, 0 sorries**.

**Printed 25's negation:** `(L+w)*PhiS(L+w) < 6L - 13w - (26+10^17)q^2`.  With
`hprod : (L+w)*(6 - 26w - 10^16w^2) <= (L+w)*PhiS(L+w)`, the needed comparison is
`6L - 13w - Kq^2 <= (L+w)*(6 - 26w - 10^16w^2)`, whose expansion uses `6 - 26L ~ -12.022`.

**Added `hkey : 6 - 26*log2 <= -12`** (from `Real.log_two_gt_d9`), and passed it to the final
`nlinarith`.

**Two errors (25, 27):** `hkey`'s own type mismatch (the bound from `Real.log_two_gt_d9` needs
`norm_num` before use -- the standard pattern) and the final `nlinarith`.

**Next: fix `hkey` (add `norm_num at`), then the final `nlinarith`.**

### 13.511 Round-482: `hkey` fixed; expansion supplied; still one error

Build green: **212 declarations, 7/7 OK, 0 sorries**.

* `hkey` fixed by `have hLg := Real.log_two_gt_d9; norm_num at hLg` (the standard pattern);
* added `hexp` -- the `ring` expansion
  `(L+w)(6 - 26w - 10^16w^2) = 6L + w(6-26L) - 26w^2 - 10^16*(w^2*(L+w))`;
* added `hrem` -- `10^16*(w^2*(L+w)) <= 10^16*(q^2*2)` via `mul_le_mul_of_nonneg_left hbd`.

**One error remains (32): the final `nlinarith`.**  The comparison is now fully expanded in the context,
so the residual is a single linear/polynomial combination -- **print 32's `a✝`**.

**Next: print 32, close it, and `uPhiS_lower_sharp2` lands.**

### 13.512 Round-483: 32's goal re-read -- the reduction is one `nlinarith` on expanded forms

Build green: **212 declarations, 7/7 OK, 0 sorries**.

**Printed 32's negation:** `(L+w)*PhiS(L+w) < 6L - 13w - (26+10^17)q^2`.

With `hexp` and `hprod`, the required comparison reduces to

```
Kq^2  >=  -13w - w*(6 - 26L) + 26w^2 + 10^16*(w^2*(L+w)).
```

**Checking each term for `0 <= w <= q`, `q <= 10^-9`:**

* `-13w - w*(6-26L) = -w*(19 - 26L)`, and `19 - 26L ~ 0.98 > 0`, so this is **negative** -- harmless;
* `26w^2 <= 26q^2` (from `hwq`);
* `10^16*(w^2*(L+w)) <= 10^16*(2q^2)` (from `hbd`/`hrem`, since `L + w <= 2`);
* so the RHS is `<= (26 + 2*10^16)*q^2`, and `K = 26 + 10^17 >= 26 + 2*10^16` **holds**.

**So the comparison is true and every ingredient is in the context** -- the residual is `nlinarith` failing
to combine `hprod`, `hexp`, `hrem`, `hkey` into the expanded form.

**Recorded remedy: replace the final `nlinarith` by `linarith` after `rw [hexp] at hprod`**, so that
`hprod` is literally the needed inequality and no polynomial normalisation is required.

**Next: apply the `rw [hexp] at hprod` route.**

### 13.513 Round-484: `rw [hexp] at hprod` applied; still one error

Build green: **212 declarations, 7/7 OK, 0 sorries**.

The final step is now `rw [hexp] at hprod` then `linarith only [hprod, hrem, hwq, hkey, hw0, hq0, hL, hLpos]`.

**One error persists (33).**  The residual is a `linarith` over `hprod` (now expanded), `hrem`
(`10^16*(w^2*(L+w)) <= 10^16*(q^2*2)`), `hwq`, and `hkey` (`6 - 26L <= -12`) -- all the ingredients
needed, yet `linarith` fails.

**Recorded remedy, per §13.379 (the rule that has resolved every such case): isolate the final step in a
standalone `example`** with abstract `w, q, L, PhiS` and the four facts, and see whether it closes there.
If it does, the in-context failure is a scope/shape issue; if not, the four facts are insufficient and one
more is needed (most likely `0 <= w*(19 - 26L)`, i.e. the sign of the `-13w - w(6-26L)` term).

**Next: isolate the final step standalone.**

**Note:** this lemma is 25 lines and has now taken 7 rounds (478-484), all on the final `linarith`.  The
isolation test is the recorded exit and has not yet been used for it.

### 13.514 Round-485: **the isolated final step FAILS too** -- a fact is missing

Build green: **212 declarations, 7/7 OK, 0 sorries**.

**The isolation test (the §13.379 rule, run at last) answered in one command:**

```lean
example (w q L F : Real) (hq0 : 0 <= q) (hq : q <= 1/10^9) (hw0 : 0 <= w) (hwq : w^2 <= q^2)
    (hL : L <= 1) (hLpos : 0 < L) (hkey : 6 - 26*L <= -12) (hwq' : w <= q)
    (hbd : w^2*(L + w) <= q^2*2)
    (hrem : 10^16*(w^2*(L + w)) <= 10^16*(q^2*2))
    (hprod : 6*L + w*(6 - 26*L) - 26*w^2 - 10^16*(w^2*(L + w)) <= (L + w)*F) :
    6*L - 13*w - (26 + 10^17)*q^2 <= (L + w)*F := by linarith only [...]
```

**FAILS** with `linarith failed` / `⊢ False` -- so **the four facts as stated are insufficient** and the
in-context failure was structural, not a matter of scope.  (This is the mirror of the `hp4` case, where
the isolated form compiled and the difference was scope.)

**The missing fact is the product `w*(6 - 26L) <= -12*w`** -- `linarith` cannot multiply `hkey` by `w`
because `w*(6-26L)` is a *product atom*.  Supplied as `hkey2` and passed in.

**One error remains (35).**  If `linarith` still fails, the next candidates are
`0 <= w*Real.log 2` or the explicit expansion of the `-13w` grouping.

**Next: print 35 and supply the next product fact.**

**Note:** the isolation test again answered a question that several in-context rounds could not, and it
was recorded as the next step three times before being run.

### 13.515 Round-486: `hkey2` added; still one error -- isolate again

Build green: **212 declarations, 7/7 OK, 0 sorries**.

Printed 35's negation is unchanged: `(L+w)*PhiS(L+w) < 6L - 13w - (26+10^17)q^2`.  With `hprod` expanded
and `hkey2 : w*(6-26L) <= -12w`, the needed comparison reduces to

```
Kq^2  >=  -w + 26w^2 + 10^16*(w^2*(L+w)),
```

which follows from `hw0` (`-w <= 0`), `hwq` (`26w^2 <= 26q^2`), `hrem`
(`10^16*(...) <= 10^16*2q^2`) and `2*10^16 <= 10^17`.  **All present, yet `linarith` fails.**

**Recorded remedy: re-run the ISOLATION TEST with `hkey2` included**, and this time also include the two
scaled facts (`26*w^2 <= 26*q^2` and `-w <= 0`) as explicit hypotheses.  If it then compiles, the
in-context fix is to supply those scalings as `have`s; if it still fails, a further product fact is
missing.

**Next: re-run the isolated test with `hkey2` and the two scalings.**

**Note:** the isolation test for `uPhiS_lower_sharp2` has now been run once (round 483) and answered
decisively; re-running it with the added fact is the same method applied one step further, and is
cheaper than another in-context `linarith`.

### 13.516 Round-487: `hneg26` supplied; still one error -- the missing fact is elsewhere

Build green: **212 declarations, 7/7 OK, 0 sorries**.

**The re-isolation test also failed** (round 486), showing that even with `hkey2`, `h26` and `hneg`, the
combination does not close.  Working the reduction again by example (`w = q = 0.01`, `L = 0.693`):

* goal LHS `6L - 13w - Kq^2 = 4.159 - 0.13 - 1e13` -- dominated by `-Kq^2`;
* the chain needs `1e16*(w^2(L+w)) + 26w^2 - w <= Kq^2`, i.e. **`26w^2 <= w`** (the `-w` term).

**Supplied `hneg26 : 26*w^2 <= w`** (from `26w <= 1`, itself from `hw : w <= q` and `hq : q <= 1/10^9`).

**One error remains (38).**  So a further fact is still missing -- candidates: `10^16*(q^2*2) <= K*q^2`
(i.e. `2*10^16 <= 26 + 10^17`, a `norm_num` fact), which `linarith` may not extract from the literal `K`.

**Recorded remedy: supply `hKbig : 2*10^16 <= 26 + 10^17` explicitly** (by `norm_num`) and pass it.

**Next: add `hKbig`, re-check.**

### 13.517 Round-488: structural restatement applied -- one error, isolated to `hmid`

Build green: **212 declarations, 7/7 OK, 0 sorries**.

**The structural alternative from §13.516 is now in place**, replacing the single large final `linarith`:

```lean
have hkey2  : w*(6 - 26L) <= -12*w                       -- product fact
have hneg26 : 26*w^2 <= w                                -- from 26w <= 1
have hrem2  : 10^16*(w^2*(L+w)) <= 10^17*q^2            -- from hbd and q >= 0
have hmid   : 6L - 12.1w - (26 + 10^17)q^2 <= (L+w)*PhiS(L+w)   -- ONE nlinarith from hprod et al.
have hconst : 6L - 13w - (26 + 10^17)q^2 <= 6L - 12.1w - (26 + 10^17)q^2  -- immediate from w >= 0
linarith only [hmid, hconst]
```

**This is the shape §13.516 prescribed**: the comparison is split into the `PhiS`-bounding step (`hmid`)
and a pure constant/sign step (`hconst`), so no single `linarith` must handle both the product
rearrangements and the constant comparison at once.

**One error remains (45): `hmid`'s `nlinarith only [hprod, hkey2, hneg26, hrem2, hLg, hw0, hq0, hL]`.**

**Next: print 45 and close `hmid`; `hconst` and the final are then immediate.**

### 13.518 Round-489: `hw26` added; its sub-steps need `norm_num` -- one error

Build green: **212 declarations, 7/7 OK, 0 sorries**.

`hmid` needed one further product relation, `hw26 : 0.9*w <= 26*q^2`, derived from `hw : w <= q`,
`hq : q <= 1/10^9` and `26q <= 0.9`.  That last is a numeric fact needing `norm_num at`.

**One error remains (49): `h2`'s `linarith`** inside `hw26`.  The remaining sub-steps (`h2`, `h3`) are the
same class -- `w <= q`, `0.9q <= 26q*q` -- and should close with the same `norm_num`/explicit-product
treatment.

**Next: fix 49 and 50 (the `/512` pattern), then `hmid` closes and the lemma lands.**

**Pattern note:** this lemma has now taken rounds 478-489 (eleven rounds) and every round has added one
more product fact (`hkey2`, `hneg26`, `hrem2`, `hw26`, ...) that `linarith` cannot synthesise.  **The
structure of §13.517 (split into `hmid`/`hconst`) helped locate the failures but did not reduce their
number** -- the product facts are genuinely needed, and each is a two-line `have`.

**Recorded for the next lemma of this kind: state the auxiliary product facts FIRST (from `hw`, `hq`,
`hq0`), then the main comparison.**  Building them on demand has cost one round each.

### 13.519 Round-490: `hw26` removed (the `-0.1w` term is negative); `hmid` still fails

Build green: **212 declarations, 7/7 OK, 0 sorries**.

**Re-deriving `hmid`'s requirement:** from `hprod` expanded,

```
hmid  <=>  Kq^2 >= -0.1w + 26w^2 + 10^16*(w^2*(L+w)).
```

The first term `-0.1w` is **negative** for `w >= 0`, so it drops out and it suffices that
`Kq^2 >= 26w^2 + 10^16*(w^2(L+w))`, which follows from `hwq` (`26w^2 <= 26q^2`), `hrem2`
(`<= 10^17 q^2`) and `K = 26 + 10^17`.  **So `hw26` was unnecessary and has been removed.**

**One error remains (45)** -- `hmid`'s `nlinarith` still fails despite `hprod`, `hkey2`, `hrem2`, `hwq`,
`hneg26` all being present and the reduction being verified by hand.

**Next: run the ISOLATION TEST for `hmid`** (the rule that answered decisively at rounds 459 and 483):
a standalone `example` with abstract `w, q, L, F` carrying `hprod`, `hkey2`, `rem2`, `hwq`, `w >= 0`,
`q >= 0`.  If it compiles, the failure is scope; if not, a fact is still missing.

**Note:** this lemma has now taken rounds 478-490 (thirteen rounds).  **The isolation test has been the
decisive tool twice in this session and has not yet been applied to `hmid`.**

### 13.520 Round-491: **`hmid`'s isolation FAILS** -- one product fact still missing

Build green: **212 declarations, 7/7 OK, 0 sorries**.

**The isolation test for `hmid`** (abstract `w, q, L, F` with `hprod`, `hkey2`, `hrem2`, `hwq`, `hw0`,
`hq0`) **fails with both `linarith` and `nlinarith`** -- so the five facts are genuinely insufficient, and
the in-context failure is structural rather than a scope issue.

**Numerical check of the implication by example** (`L = 0.693`, `w = q = 0.01`):

* `hprod.LHS = 4.159 - 0.12 - 0.0026 - 7.03e11 = -7.03e11`;
* `hmid.LHS  = 4.159 - 0.121 - 1e13 = -1e13`;
* `(L+w)F = 3.94` (with `F ~ 5.6`).

The implication `hprod.LHS <= (L+w)F` ⟹ `hmid.LHS <= (L+w)F` requires
`Kq^2 >= 10^16*(w^2(L+w)) + 26w^2 + 0.1w`.  In the example the slack is `1e13 - 7.03e11 = 9.3e12` and
`0.1w = 1e-3`, so it **holds comfortably** -- yet neither tactic finds it.

**The likely missing fact is `0.1*q <= 10^17*q^2`** (true since `0.1 <= 10^17*q` for `q <= 10^-9`), which
would bound the `0.1w` term.  Supplying it makes the combination linear:

```
0.1w <= 0.1q <= 10^17*q^2,   26w^2 <= 26q^2,   10^16*(...) <= 10^17*q^2,
hence  Kq^2 = (26 + 10^17)q^2 >= 26w^2 + 10^16*(...) + 0.1w.
```

**Next: add `h01 : (0.1:ℝ)*q <= (10^17:ℝ)*q^2` to the isolated test; if it compiles, transplant.**

### 13.521 Round-492: `h01` and `hw` added; isolation STILL fails -- the statement must split

Build green: **212 declarations, 7/7 OK, 0 sorries**.

Added `hw : w <= q` and `h01 : 0.1*q <= 10^17*q^2` (and `h01w` from them) to the isolated test for
`hmid`.  **It still fails** with `linarith failed` at both steps.

**So the fact list is still incomplete -- the fourth consecutive isolation failure for this step.**  Each
isolation round has added one more product fact and each has failed, which is now conclusive evidence of
the structural diagnosis recorded at §13.520:

> **When a twenty-five-line lemma needs many product facts for its final step, the lemma's statement is
> doing too much work in one place.**

**The remedy, recorded and not yet applied: split the STATEMENT, not the proof.**

```
-- L1: the PhiS bound, with an abstract constant
lemma uPhiS_lower_sharp3 (u q w : Real) (hq0 : 0 <= q) (hq : q <= 1/10^9)
    (hw0 : 0 <= w) (hw : w <= q) (hu : u = Real.log 2 + w)
    (hPS : |PhiS u - 6 + 26*w| <= 10^16 * w^2) :
    6*Real.log 2 - 13*w - (10^18)*q^2 <= u * PhiS u
```

i.e. **a single constant `10^18` in the error term**, chosen so that ONE `nlinarith` with
`hprod`, `hwq`, `hbd`, `hkey` closes it -- no chain of `hkey2`/`hneg26`/`hrem2`/`h01`.  Then the consumer
needs only the constant comparison `13w + Kq^2 >= 12.1w + 10^18 q^2`, which is immediate.

**Next: write `uPhiS_lower_sharp3` with the single-constant error term and close it by one `nlinarith`.**

### 13.522 **LANDED (round 493): `uPhiS_lower_sharp3`** -- 213 declarations -- **FIRST TRY**

`Op56/PhiThird.lean` now has **213 declarations** (0 sorries, 7/7 OK, 0 axioms), newly:

```lean
lemma uPhiS_lower_sharp3 (u : Real) (q w : Real) (hq0 : 0 <= q) (hq : q <= 1/10^9)
    (hw0 : 0 <= w) (hw : w <= q) (hu : u = Real.log 2 + w)
    (hPS : |PhiS u - 6 + 26*w| <= 10^16 * w^2) :
    6*Real.log 2 - (26*Real.log 2 - 6)*w - 10^18*q^2 <= u * PhiS u
```

**The decisive realisation: the linear coefficient must be EXACT (`26*log2 - 6 ~ 12.022`), not a rounded
constant like `13`.**  With a rounded coefficient the statement is **false** for small `q` (the `1.0w`
slack cannot be absorbed by `Cq^2`), and every attempt to patch it added another product fact
(`hkey2`, `hneg26`, `hrem2`, `h01`, ...).  With the exact coefficient the `w`-terms cancel identically
(`6L + w(6 - 26L) = 6L - (26L-6)w`), leaving only `26w^2 + 10^16 w^2(L+w)` to absorb by `10^18 q^2` -- and
**one `nlinarith` closes it with no auxiliary product facts at all.**

**This is the resolution of rounds 478-492 (fifteen rounds).**  The value being sought,
`6 - 26*log2`, was in `hPS`'s own statement the whole time.

**Next: re-run `stage2_lower_sharp`'s chain with `uPhiS_lower_sharp3`** to obtain
`w >= 5L/(2n) - O(1/n^2)` -- the coefficient the numerics require (§13.504).

### 13.523 Round-494: how to use `uPhiS_lower_sharp3` in the chain

Build green: **213 declarations, 7/7 OK, 0 sorries**.

**Checking what the sharpened bound gives for `X = u*PhiS(u)/(2n)`:**

```
u*PhiS(u)  >=  6L - (26L - 6)*w - 10^18*q^2
X          >=  3L/n - ((26L-6)/2)*(w/n) - 10^18*q^2/(2n).
```

The landed `stage2_lower_sharp_exp2` consumes `hX : X >= 3L/n - K/n^2` -- **which drops the
`w`-dependent term**.  That term is exactly what the crossing needs: at the crossing
`w ~ 5L/(2n)`, so

```
((26L-6)/2)*(w/n)  ~  (12.022/2)*(5L/(2n^2))  =  30L/(4n^2)  =  7.5L/n^2,
```

i.e. **the `w`-term contributes `-7.5L/n^2` to `X`**, which is `O(1/n^2)` -- the order required.

**So the sharpened chain needs `stage2_lower_sharp_exp2`'s hypothesis in the form**

```
hX : X >= 3L/n - ((26L-6)/2)*(w/n) - K/n^2
```

with the `w`-dependent term present, and `w` itself is the unknown being bounded -- making this a
**self-referential** step: `w` appears on the right of a bound on `w`.

**Resolution: it is a quadratic, not an equation.**  From `-2w - 500w^2 < -X + ...` and
`X >= 3L/n - 7.5w/n - ...`, one gets `2w - 7.5w/n <= 3L/n + 500w^2 + K/n^2`, i.e.

```
w*(2 - 7.5/n) <= 3L/n + 500w^2 + K/n^2,
```

and with `w = O(1/n)` the `500w^2` term is `O(1/n^2)`, giving
**`w <= (3L/2)/n + O(1/n^2)`** -- hmm, still `3L/2`, not `5L/2`.

**So the `5L/2` must come from the `-2w` vs `-X` balance differently than I have modelled.**  This needs
re-derivation on paper with the `w`-dependent `X` before any coding (the §13.452 rule).

**Next: re-derive the `w`-lower bound on paper with `X >= 3L/n - 7.5w/n - K/n^2`.**

### 13.524 Round-495: **RESOLUTION -- the `1/n^2` error IS available from the landed lemma**

Build green: **213 declarations, 7/7 OK, 0 sorries**.

**The `L/n` gap in §13.523 is not an error; it is the transport.**  Working the paper derivation again:

* the crossing is at `n'`, and there `2w' ~ X'` gives **`w' = 3L/(2n') + O(1/n'^2)`** (the `(6-26L)/(2n')`
  correction contributes only `O(1/n'^2)`);
* the **exact** transport `w = w' + p/(n*n')` then gives `w = 3L/(2n') + L/n' + O(1/n'^2) = 5L/(2n) + O(1/n^2)`
  -- matching the numerics `n*w -> 1.733 = 2.5L`.

**So there is no missing `L/n` in the crossing; my §13.523 model compared `w` at `n` with an `X` at `n'`.**

**And the decisive consequence for `w'`:** transporting the LANDED `stage2_lower_sharp`
(`w >= 3L/(2n) - K/n^2`) through the exact identity `w' = w - p/(n*n')` gives

```
w'  >=  3L/(2n) - K/n^2 - p/(n*n')
    =  3L/(2n') + 3L/(2nn') - p/(nn') - K/n^2
    =  3L/(2n') + (3L/2 - p/n)/n' - K/n^2,
```

and `p/n = L + w` with `w = 5L/(2n) + O(1/n^2)` makes `3L/2 - p/n = L/2 - w >= L/4` for large `n`.
**So `w' >= 3L/(2n') + L/(4n') - K/n^2` -- and since `n' = n+1`, `K/n^2 = K/n'^2 (1 + o(1))`.**

**Therefore `w' = 3L/(2n') + O(1/n'^2)`, with the error at the `1/n'^2` order REQUIRED**, and this is
derivable from the landed `stage2_lower_sharp` (at `n`) plus the exact transport.

**So the `C/N` form of the landed `nmin_wp_lower` is indeed too weak -- but the sharper form is available
without any new analytic input.**  The remaining work is to re-prove `nmin_wp_lower` with the error term
`C/N^2`, using `stage2_lower_sharp` at `n` and `w' = w - p/(n*n')` exactly.

**Next: write `nmin_wp_lower2` with `1/N^2` error from the landed `stage2_lower_sharp`.**

### 13.525 Round-496: the `1/N^2` plan -- LOWER side available, UPPER side needs sharpening too

Build green: **213 declarations, 7/7 OK, 0 sorries**.

**LOWER side (`w' >= 3L/(2n') - O(1/n'^2)`): AVAILABLE.**  From §13.524's computation,
`w' >= 3L/(2n') + L/(4n') - K/n^2`, and since `n' = n + 1`,
`K/n^2 = K/n'^2 * (n'^2/n^2) = K/n'^2 * (1 + 1/n)^2 <= 2K/n'^2` for `n >= 3`.  So
**`w' >= 3L/(2n') - 2K/n'^2`** directly from the landed `stage2_lower_sharp`.

**UPPER side (`w' <= 3L/(2n') + O(1/n'^2)`): NEEDS THE SHARPENING.**  The landed `stage2_upper_sharp`
consumes `hX : X <= 3L/n + K/n` -- an `O(1/n)` error.  But `uPhiS_sharp`'s `hPS` gives
`u*PhiS(u) <= 6L + K'*q` with `q = O(1/n)`, so `X <= 3L/n + K'*q/(2n) = 3L/n + O(1/n^2)`.
**So `hX : X <= 3L/n + K/n^2` is available**, and with it `stage2_upper_sharp` yields the `O(1/n^2)`
upper bound.

**So the required work is two sharpened lemmas, both fed by `hPS`:**

1. **`nmin_wp_lower2`** -- `w' >= 3L/(2n') - C/N^2`, from `stage2_lower_sharp` at `n` + exact transport
   (no new analytic input);
2. **`stage2_upper_sharp2`** -- the same chain as `stage2_upper_sharp` but with
   `hX : X <= 3L/n + K/n^2`, from `uPhiS_sharp`'s `hPS`.

**Next: write `nmin_wp_lower2` first** (it needs no new analytic input, only the transport).

### 13.526 Round-497: **CORRECTION -- the transport of `stage2_lower_sharp` gives only `L/(2N)`**

Build green: **213 declarations, 7/7 OK, 0 sorries**.

**Re-doing the transport arithmetic carefully (and this reverses §13.524's conclusion).**  From
`stage2_lower_sharp` at `n`, `w >= 3L/(2n) + 3L/(2nN) - K/(2n^2)`, and `w' = w - p/(nN)`:

```
w' >= 3L/(2n) + 3L/(2nN) - K/(2n^2) - p/(nN)
```

Using `3L/(2n) = 3L/(2N)*(1 + 1/n) = 3L/(2N) + 3L/(2nN)` and `p/n = L + w`:

```
w' >= 3L/(2N) + 3L/(nN) - K/(2n^2) - (L + w)/N
    = 3L/(2N) - L/N + 3L/(nN) - K/(2n^2) - w/N
    = L/(2N) + 3L/(nN) - K/(2n^2) - w/N.
```

**The leading term is `L/(2N)`, NOT `3L/(2N)`.**  Since `3L/(nN) ~ 3L/N^2` and `w/N ~ 2.5L/N^2`, this gives
`w' >= L/(2N) + O(1/N^2)` -- **short of `3L/(2N)` by exactly `L/N`.**

**Why §13.524 was wrong:** it treated the transport as subtracting `L/N` from the TRUE `w = 5L/(2n)`
(which does give `3L/(2N)`), but `stage2_lower_sharp` provides only `w >= 3L/(2n)`, and **a weak lower
bound transports to a weak lower bound.**

**Consequence: the `5L/2` coefficient IS genuinely needed** -- confirming §13.504 and reversing §13.524.
And `uPhiS_lower_sharp3` (landed, 213 declarations) is **precisely the input that supplies it**, via the
`w`-dependent `X` at the crossing.

**Corrected plan:** build `stage2_lower_sharp`'s sharpened counterpart directly from
`uPhiS_lower_sharp3`, i.e. re-run the `hS`/`h6` chain with the `X >= 3L/n - 7.5w/n - K/n^2` input of
§13.523, and resolve the self-reference on paper first.

**Next: write the sharpened `hS` statement (with the `w`-dependent term) and check the self-reference.**

### 13.527 Round-498: `hlin`'s direction gives an UPPER on `w`; the LOWER needs the other side

Build green: **213 declarations, 7/7 OK, 0 sorries**.

**Checking what `exp_threshold_linear`'s hypothesis actually provides.**  The landed `hlin` is used in the
form

```
-3L/n - C/n^2 < -2w + 500w^2,
```

which rearranges to `2w - 500w^2 < 3L/n + C/n^2` -- **an UPPER bound on `w`** (it is what
`stage2_upper_sharp` consumes).  Combined with `X >= 3L/n - 7.5w/n - K/n^2` it yields
`w <= 3L/(2n) + O(1/n^2)`.

**For the LOWER bound on `w` the inequality must be used in the opposite direction** -- i.e.
`-2w + 500w^2 > -X + ...`, which is what a *lower* bound on `X` fed into the *upper* side of the linear
form gives.  Concretely, the chain needs:

```
2w - 500w^2 > X - C/n^2,   X >= 3L/n - 7.5w/n - K/n^2
  ==>  2w + 7.5w/n > 3L/n - K/n^2 - C/n^2 - 500w^2
  ==>  w > (3L/n - K/n^2 - 500w^2)/(2 + 7.5/n)  =  3L/(2n) - O(1/n^2).
```

**Still `3L/2`, not `5L/2`.**  So the `5L/2` does NOT come from feeding `X`'s `w`-term into this crossing
either -- **the crossing balance I have modelled is not the one that produces the true coefficient.**

**This is now the third distinct model of the crossing that fails to produce `5L/2`** (§13.505 gave
`3L/2 + 9.4L^2/n^2`; §13.523 and this round give `3L/2`).  Meanwhile the numerics (`n*w -> 1.733 = 2.5L`)
and the exact transport (`w = w' + L/n'`, `w' = 3L/(2n')`) both REQUIRE it.

**So there is an internal inconsistency in my understanding of the crossing that three paper models have
not resolved.**  Rather than code a fourth, the recorded next step is **numerical**: evaluate each term of
`exp_threshold_linear`'s identity at the true crossing (`p = 96`, `n' = 137`) and read off which term
balances `2w'`.

**Next: numerically decompose the crossing identity term by term.**

### 13.528 Round-499: **DECISIVE numerics -- `2w = X + D` exactly, and `w = 3L/(2n+6)`**

Build green: **213 declarations, 7/7 OK, 0 sorries**.

**Term-by-term decomposition at the true crossing (`p = 96`, `n' = 137`):**

| quantity | value | `n ×` it |
|---|---|---|
| `2w` | `1.5165e-2` | **2.0777** |
| `X + D` | `1.5006e-2` | **2.0558** |
| `Y - 1` | `-1.4995e-2` | `-2.0543` |
| `Phi_p(n) - 1` (true) | `1.2612e-5` | `0.0017` |
| model error (true − model) | `1.6300e-6` | `0.0002` |

**So `2w = X + D` holds to better than 1%, and `Y - 1 = -X - D` (the crossing identity).**  The model
error is `O(1/n^2)` (`n^2 × diff ~ 0.03`).

**Solving the balance:** `X = 3L/n - 6w/n + O(w^2/n)`, `D = O(1/n^2)`, so

```
2w + 6w/n = 3L/n + D      ==>      w = (3L/n + D)/(2 + 6/n) = 3L/(2n + 6) + O(1/n^3).
```

**And `3L/(2n+6) = 3L/(2n)·(1 - 3/n + O(1/n^2)) = 3L/(2n) - 9L/(2n^2) + O(1/n^3)`** -- so

```
w' = 3L/(2n') - (9L/2)/n'^2 + O(1/n'^3),
```

**confirming `|w' - 3L/(2n')| = O(1/n'^2)` with a small constant** (`9L/2 ~ 3.1` from the leading
correction; the measured value from §13.504 was `~17` including higher terms).

**And the `5L/2` at `n` follows from the exact transport:** `w = w' + L/n' = 1.5L/n' + L/n' = 2.5L/n`.

**So the whole picture is now closed NUMERICALLY and ANALYTICALLY:**

1. `w' = 3L/(2n') - O(1/n'^2)` -- the coefficient `3L/2` IS correct at `n'` (as `nmin_wp_lower` states),
   but the error must be `O(1/N^2)`, not `O(1/N)`;
2. `w = 5L/(2n) - O(1/n^2)` -- at `n`, which is why transporting `stage2_lower_sharp`'s `3L/2` is weak;
3. **`X`'s `w`-dependent term (`-6w/n`) is what makes the balance `2w + 6w/n = 3L/n`** -- and
   `uPhiS_lower_sharp3` (landed) supplies exactly that term.

**Next: write the sharpened `w'`-lower bound using `uPhiS_lower_sharp3`'s `w`-dependent `X`.**

### 13.529 Round-500: **the missing ingredient is the threshold gap `Phi_p(n) = 1 - 2L/n + O(1/n^2)`**

Build green: **213 declarations, 7/7 OK, 0 sorries**.

**The balance `2w = X + D` holds at `n'`, NOT at `n`.**  At `n` the measured deficit is
`(Y-1) + X + D = -0.0101`, while `2L/n = 0.0101` -- **so at `n` the identity is**

```
2w - 3w^2 = X + D + 2L/n + O(1/n^2),
```

equivalently **`Phi_p(nmin p) = 1 - 2L/n + O(1/n^2)`** -- an `O(1/n)` threshold gap, exactly what one
expects from the discreteness of `nmin`.

**Feeding this into the sharpened `X`** (`X >= 3L/n - 7.5w/n - K/n^2`):

```
2w + 7.5w/n  >=  3L/n + 2L/n - K/n^2   ==>   w(2 + 7.5/n) >= 5L/n - K/n^2
  ==>  w >= 5L/(2n) - K'/n^2.
```

**`5L/(2N)` -- the coefficient the numerics require, now DERIVED.**

**So the chain is:**

1. `Phi_p(nmin p) <= 1 - c/n` (threshold gap; `c = 2L` numerically) -- **NOT YET IN THE LIBRARY**;
2. `X >= 3L/n - 7.5w/n - K/n^2` -- **from the landed `uPhiS_lower_sharp3`**;
3. `Y - 1 >= -2w` -- from the landed `exp_threshold_linear`;
4. combining gives `w >= 5L/(2n) - K'/n^2`;
5. transport by `w' = w - p/(n n')` then gives `w' >= 3L/(2N) - K''/N^2` (using `5L/(2n) - L/N =
   3L/(2N) + O(1/n^2)`).

**So ONE new input is needed: the threshold gap `Phi_p(nmin p) <= 1 - C/n`.**  This is the OP-5
"threshold" statement -- and `op5_threshold_asymptotic` is already PROVED.

**Next: read `op5_threshold_asymptotic`'s statement and check whether it supplies the `-2L/n` gap.**

### 13.530 Round-501: the threshold gap comes from MINIMALITY, and needs no new input

Build green: **213 declarations, 7/7 OK, 0 sorries**.

**Reading `op5_threshold_asymptotic`:** it is

```lean
theorem op5_threshold_asymptotic (Pfun : Nat -> Real) (hP : forall n, IsThreshold n (Pfun n)) :
    (fun n => Pfun n - thresholdAsym n) =O[atTop] (fun n => 1/((n:Real)+1)^2)
```

-- a statement about the **threshold in the `u`-direction**, not the gap at integer `n`.  So it does not
directly supply `1 - Phi_p(nmin p)`.

**But the gap needs no new input at all -- it comes from `nmin`'s MINIMALITY.**

The measured deficit at `n = nmin p` is `delta = 1 - Phi_p(n) = 0.0101 = 2L/n`.  And since `nmin p` is the
**least** `n` with `Phi_p(n+1) >= 1`:

```
Phi_p(nmin p + 1) >= 1   and   Phi_p(nmin p) < 1,
```

so `delta <= Phi_p(nmin p) - Phi_p(nmin p + 1)` (an UPPER bound on `delta`, from monotonicity).

**For the LOWER bound needed by the chain, use the minimality at `n - 1`:** `Phi_p(nmin p - 1) >= 1`
whenever `nmin p >= 1` (else `nmin p - 1` would already satisfy the definition), hence

```
delta = 1 - Phi_p(n)  >=  Phi_p(n-1) - Phi_p(n)  =  the step at n-1.
```

**And the step is `O(1/n)` with a definite constant**: `Phi_p(n) - Phi_p(n+1)` measured `= 0.0101 = 2L/n`
at `n = 137`.  (Consistent with the sum: `~n` terms each changing by `~p/n^2` gives `~p/n = L`.)

**So: `delta >= c/n` for a positive constant `c`, from `nmin`'s minimality and the step estimate.**
The available library lemma is `nmin_Phi_ge : 1 <= Phi p (nmin p + 1)` (the upper side); **the lower side
`Phi p (nmin p - 1) >= 1` must be derived from `nmin`'s definition** (`Nat.find` minimality).

**Next: derive `Phi p (nmin p - 1) >= 1` from the definition of `nmin`, then the step bound
`Phi p m - Phi p (m+1) >= c/m`.**

### 13.531 Round-502: **CORRECTION -- minimality gives an UPPER bound on `delta`, not a lower**

Build green: **213 declarations, 7/7 OK, 0 sorries**.

**The definitions, read directly:**

```lean
def IsComplete (p N : Nat) : Prop := term p N <= tailSum p (N + 1)
def Phi (p : Real) (n : Nat) : Real := sum' j, (1 + ((j:Real)+1)/(n:Real)) ^ (-p)
lemma Phi_mono_n (p) (hp : 1 < p) (n m) (hn : 1 <= n) (hnm : n <= m) : Phi p n <= Phi p m
lemma nmin_spec     (p) (hp : 2 <= p) : IsComplete p (nmin p)
lemma nmin_minimal  (p) (hp : 2 <= p) {N} (hN : N < nmin p) : not (IsComplete p N)
```

**`Phi` is MONOTONE INCREASING in `n`** (larger `n` shrinks `(j+1)/n`, so each term grows).  Hence
`IsComplete p N` is increasing in `N`, and `nmin` is its least index.

**So the library gives `Phi p (nmin p) < 1 <= Phi p (nmin p + 1)`, and the gap satisfies**

```
delta = 1 - Phi_p(n)  <=  Phi_p(n+1) - Phi_p(n)  = the step.
```

**That is an UPPER bound on `delta`.**  (Minimality at `N = nmin p - 2` gives
`Phi p (nmin p - 1) < 1`, which is *below* `1` -- the opposite side.)

**§13.530's claim was WRONG:** I asserted `Phi_p(nmin p - 1) >= 1` from minimality, but monotonicity
places `nmin p - 1` BELOW the crossing, so `Phi_p(nmin p - 1) < 1`.  **There is no lower bound on `delta`
from minimality** -- `delta` could in principle be arbitrarily small (if `Phi_p` jumped across `1`).

**Consequence for the chain:** with `delta >= 0` only, `2w = X + D + delta + 3w^2` gives
`w >= 3L/(2n) - O(1/n^2)` -- **still `3L/2`, not `5L/2`**.  The measured `delta = 2L/n` is *generically*
true but is not forced by the definitions.

**So the `5L/2` remains unobtained, for a NEW reason: `delta` has no lower bound in the library.**

**Next: determine whether `delta >= c/n` is derivable from `nmin_Phi_lt` + `nmin_Phi_ge` + the STEP
estimate in the opposite direction** (i.e. `Phi_p(n+1) - Phi_p(n) >= c/n` alone does not bound `delta`
below, but a *quantitative* version of the crossing might).

### 13.532 Round-503: **the `O(1/n^2)` precision requires `|Phi_p - 1| = O(1/n^2)` at the crossing -- an alignment not derivable**

Build green: **213 declarations, 7/7 OK, 0 sorries**.

**What the goal actually requires.**  `nminAsym p = p/L - 5/2`, so `n = p/L - 5/2 + O(1/p)`, hence
`p/n = L*(1 + (5/2)/(p/L - 5/2)) + O(1/p^2) = L + (5L/2)/n + O(1/n^2)`, i.e.

```
w = p/n - L = 5L/(2n) + O(1/n^2).        (*)
```

**So the `5L/2` coefficient is REQUIRED**, and the error must be `O(1/n^2)` -- confirming the numerics.

**Why every route so far fails.**  The crossing identity is `2w = X + D + delta + 3w^2` with
`delta = 1 - Phi_p(n)`.  Working at `n'` instead gives `2w' = X' + D' + delta' + 3w'^2` with
`delta' = 1 - Phi_p(n') <= 0`.

* At `n`: `delta in [0, Delta]`, an `O(1/n)` window;
* at `n'`: `-delta' in [0, Delta']`, also an `O(1/n')` window.

**In both cases the gap's size is only known to `O(1/n)`, while the numerics show it is `O(1/n^2)`**
(`delta = 1.44/n` at `p=96`; `|delta'| = 1.26e-5` at `n'=137`, versus `Delta' ~ 2L/n' ~ 0.01`).

**So the sharp `O(1/n^2)` precision requires the crossing to be *nearly aligned* with an integer --
i.e. `|Phi_p(nmin p) - 1| = O(1/n^2)`.  That is NOT a consequence of the definitions** (monotonicity gives
only `Phi_p(n) < 1 <= Phi_p(n+1)` and the `O(1/n)` step); it is an additional property of this particular
sequence.

**This is the precise form of the OP-5 nmin obstruction, and it is the same obstruction §13.353/13.431
identified.**  The `O(1/n^2)` alignment must come from somewhere outside the definitions I have.

**Next: check whether `Op56/Exact.lean` contains a quantitative crossing lemma**
(`|Phi_p(nmin p) - 1| <= C/n^2` or a `tailSum`-level equivalent), since `nmin` is defined there via
`IsComplete` and the `IsComplete`/`Phi` bridge may carry more than monotonicity.

### 13.533 Round-504: **`Exact.lean` has ONE pre-existing `sorry`, and it is `used nowhere`**

Build green: **213 declarations, 7/7 OK, 0 sorries in `PhiThird.lean`**.

**Sorries in the tree:**

| file | count | what |
|---|---|---|
| `Asymptotic.lean` | 2 | `op5_nmin_asymptotic` (line 227), `op6_reachable_fraction` (241) -- **the targets** |
| `Exact.lean` | 1 | `tailSum_integral_lower` (line 118) -- **pre-existing, "used nowhere"** |
| all others | 0 | |

**The `Exact.lean` lemma is inert.**  Its own docstring says so:

> "...At the threshold `n_min ~ p/ln 2` this bound is **below** `b_N = (2N)^{-p}` from `p ~ 10` on
> (`bound/b_N = 1.33, 1.03, 0.836, 0.748, 0.733` at `p = 2, 5, 10, 50, 100`), because the integral discards
> the discrete mass `T_{N+1} ~ 2 b_{N+1}` that the sum carries in its first terms.  So this estimate
> **cannot** prove `IsComplete`, and existence must be shown discretely (see `exists_isComplete`).  The
> statement is kept because the bound is true; **it is used nowhere**."

**Two consequences:**

1. **It does not supply the missing alignment input** -- it is an *upper* bound on the tail from below,
   and strictly weaker than the discrete facts;
2. **It is a separate deliverable risk**: the goal asks for the `Asymptotic.lean` sorries, and
   `check.sh` passes with this one, but a strict "no `sorry` anywhere" reading would require it too.

**And the docstring independently confirms §13.532's diagnosis:** the integral estimate fails precisely
because **"the integral discards the discrete mass ... that the sum carries in its first terms"** -- i.e.
the discrete alignment of the crossing is exactly what matters, and exactly what no continuous estimate
provides.

**Next: search `PhiThird.lean` for the discrete step lemmas around the crossing**
(`Phi_mono_n`, `IsComplete_iff`, and anything bounding `Phi p (n+1) - Phi p n`), since the alignment must
come from a discrete estimate if it is available at all.

### 13.534 Round-505: **no discrete step lemma exists -- and a strategic reallocation**

Build green: **213 declarations, 7/7 OK**.

**Search result: `PhiThird.lean`/`Exact.lean` contain only `Phi_antitone` (in `p`) and `Phi_mono_n`
(in `n`).  There is NO step estimate** -- nothing bounding `Phi p (n+1) - Phi p n`, and nothing relating
`Phi p (nmin p)` to `1` beyond `< 1 <= Phi p (nmin p + 1)`.

**So the alignment input §13.532 requires (`|Phi_p(nmin p) - 1| = O(1/n^2)`) is absent from the library,
and no landed lemma derives it.**  Combined with §13.533's confirmation that the continuous/integral
route *cannot* supply it (the integral discards the discrete mass), the `op5_nmin_asymptotic` route via
`nmin_wp_lower` is **not closable from the current library**.

**Re-derivation of what the goal needs, to be sure:**  `nminAsym p = p/L - 5/2` and
`n - p/L = -p*w/(L*(L+w)) ~ -p*w/L^2`, so

```
|n - nminAsym p| = |p*w/L^2 - 5/2| + O(...) = (p/L^2)*|w - 5L^2/(2p)| = (p/L^2)*|w - 5L/(2n)*... |
```

**so `op5_nmin_asymptotic` genuinely requires `|w - 5L/(2n)| = O(1/n^2)`** -- the sharp form, and hence
the alignment.  **Confirmed.**

**Decision: reallocate to `op6_reachable_fraction`.**

Rationale: (a) it is one of the three named targets and is **completely untouched**; (b) it is
independent of the `nmin` obstruction; (c) the session has spent ~75 rounds on `op5_nmin_asymptotic`
without landing a proof, and the remaining gap there needs new analysis rather than assembly.

**Next: read `op6_reachable_fraction`'s statement (`Asymptotic.lean:241`) and the OP-6 plan in §7 of
`../HANDOFF.md`, then assess what it needs.**

### 13.535 Round-506: OP-6 read -- and it inherits the same `nmin` dependence

Build green: **213 declarations, 7/7 OK**.

**The definitions (`Defs.lean`, `Exact.lean`):**

```lean
def term      (p n : Nat) : Real := (2*(n:Real))^(-(p:Real))      -- (b_n)
def budget    (p : Nat)   : Real := sum' n, term p n
def tailSum   (p N : Nat) : Real := sum' n, term p (N+n)
def reachableMeasure (p : Nat) : Real := 2^(nmin p) * tailSum p (nmin p)
def reachableFraction (p : Nat) : Real := reachableMeasure p / budget p
def L       (p : Nat) : Real := -Real.log (reachableFraction p)
def LAsym   (p : Nat) : Real := p*Real.log p - (1 + Real.log (Real.log 2))*p
```

**The target is**

```lean
theorem op6_reachable_fraction :
    (fun p => L p - LAsym p) =O[atTop] (fun _ => 1)
```

i.e. **`L p - LAsym p` is BOUNDED** -- equivalently
`reachableFraction p / (p^{-p} * exp((1+log log 2)*p))` is bounded above and below.

**Key observation: `reachableMeasure` contains `2^(nmin p) * tailSum p (nmin p)` -- so `L` depends on
`nmin` DIRECTLY, through both the prefactor and the index.**  Since `LAsym` is a smooth function of `p`
and `nmin` jumps by 1, the bounded-difference statement requires the `nmin`-dependence to cancel between
the `2^nmin` factor and `tailSum` at `nmin`.  **That cancellation is a genuine mathematical content, and
it is where the work lies.**

**The docstring's own diagnosis:** "Given OP-5, the remaining input is the `p >> n` regime identity
`zeta(p, n_min) = z(p) n_min^{-p}` with `z(p) -> 2`, which needs the same Hurwitz-tail input."

**So OP-6 is NOT independent of the `nmin` difficulty** -- it needs `nmin`'s location to the precision at
which `2^nmin * tailSum` becomes a smooth function of `p`.  **This is a weaker requirement than OP-5's**
(an `O(1)` bound rather than `O(1/n^2)`), and the cancellation structure has not been analysed before.

**Next: determine numerically how `L p - LAsym p` behaves** (does it converge, oscillate, or drift?) --
the answer decides whether the bounded-difference statement has a cancellation proof or needs `nmin`
precisely.

### 13.536 Round-507: **DECISIVE -- OP-6 needs only `nmin = p/L + O(1)`, which is ALREADY LANDED**

Build green: **213 declarations, 7/7 OK**.

**Paper decomposition of `L p = -log(reachableFraction p) = -log(2^(nmin p) * tailSum p (nmin p) / budget p)`:**

```
L p = -nmin*log2 - log(tailSum p (nmin p)) + log(budget p).
```

* `budget p = sum_n (2n)^{-p} = 2^{-p} * zeta(p)`, and `zeta(p) -> 1` faster than any power, so
  **`log(budget p) = -p*log2 + o(1)`**;
* `tailSum p N = sum_{n>=N} (2n)^{-p}` is dominated by its first terms at `N = nmin p ~ p/log2`, so
  `log(tailSum) = -p*log(2N) + O(1)` with `2N ~ 2p/log2`, giving

```
-log(tailSum p (nmin p)) = p*log p + p*(log 2 - log log 2) + O(1).
```

* Putting these together, and using **`nmin p = p/log2 - 5/2 + O(1)`**:

```
L p = -nmin*log2 - [p log p + p(log2 - loglog2)] - p log2 + O(1)
    = -p + (5/2)log2 - p log p - p log 2 + p loglog2 - p log 2 + O(1)   -- hmm, collect carefully
    = p log p - (1 + loglog2) p + (5/2)log2 + O(1).
```

**So `L p - LAsym p = (5/2)log2 + O(1)` -- BOUNDED, exactly as the theorem requires.**  (The docstring's
`-(1+loglog2)` matches the `LAsym` coefficient.)

**And the ONLY input used about `nmin` is `nmin p = p/log2 + O(1)`** -- because `L` contains `-nmin*log2`
LINEARLY, so a bounded error in `nmin` produces a bounded error in `L`.

**That is precisely what the LANDED `nmin_w_sharp` provides:**
`|p/(nmin p) - log2| <= 4/(nmin p)`, i.e. `nmin p = p/log2 + O(1)`.

**So `op6_reachable_fraction` needs NO alignment, NO `O(1/n^2)` precision, and NO new analytic input --
only the `O(1)`-precision `nmin` estimate that is already in `PhiThird.lean`.**

**This makes OP-6 genuinely the shorter path, for a reason opposite to §13.535's:** not because it escapes
`nmin`, but because it depends on `nmin` only to `O(1)` precision, where `op5_nmin_asymptotic` needs
`O(1/n^2)`.

**Next: identify the `O(1)`-bounds needed for `tailSum`/`budget` (two-sided, since `L` needs both directions)
and check which are landed.**

### 13.537 Round-508: the library has almost NO `tailSum`/`budget` bounds -- OP-6 is reachable but must be built

Build green: **213 declarations, 7/7 OK**.

**Search result -- the entire library contains only TWO `tailSum` lemmas and NO `budget` lemma:**

```
Op56/Exact.lean:116  tailSum_integral_lower  -- SORRIED, and "used nowhere"
Op56/Exact.lean:121  tailSum_ge_first_two
```

**So the `O(1)` two-sided estimates on `budget p` and `tailSum p (nmin p)` that §13.536's decomposition
requires DO NOT EXIST and must be built.**  That is a real development, not assembly:

1. **`budget p = sum_n (2n)^{-p}`** -- need `log(budget p) = -p*log2 + O(1)`, i.e. `zeta(p)` bounded
   above and below by constants near 1.  This is `1 + 2^{-p} + 3^{-p} + ... <= zeta(p) <= 1 + 2^{-p}*C`,
   elementary but not in the file;
2. **`tailSum p N` at `N = nmin p ~ p/log2`** -- need the sum dominated by its first `O(1)` terms, i.e.
   `c1*(2N)^{-p} <= tailSum p N <= c2*(2N)^{-p}` with `c1, c2` absolute constants.  This is a ratio-type
   estimate (`tailSum p N / (2N)^{-p} -> 1` as `N,p -> infinity` with `N ~ p/log2`), elementary but
   absent.

**So OP-6's remaining work is: ~2-4 new elementary sum estimates, then the `L`-decomposition algebra, then
the `IsBigO` wrapper.**  All bounded-precision, none needing the crossing alignment.

**Assessment: this is a genuine, bounded development path, and it is the one target of the three where the
required inputs are elementary rather than deep.**  But it is NOT a small edit -- it is a new section of
`PhiAsymptotic.lean`-style material, and §13.536's decomposition, while correct, is a paper argument that
must be compiled.

**Next: write `budget_bounds` -- `p >= 2 -> 1 <= zeta(p) <= 2` in the form
`2^(-p) <= budget p <= 2*2^(-p)` -- as the first new lemma.**

### 13.538 Round-509: the OP-6 sum estimates sketched; the telescoping core identified

Build green: **213 declarations, 7/7 OK**.

**`budget p = sum_n (2n)^{-p}` and `term p 0 = 0`, so `budget p = sum_{n>=1} (2n)^{-p}
= 2^{-p} * sum_{n>=1} n^{-p}`.**  For `p >= 2` the inner sum is at most `1 + sum_{n>=1}(n+1)^{-2}`, and
that tail **telescopes**: `(n+1)^{-2} <= 1/(n(n+1)) = 1/n - 1/(n+1)`, so the tail is `<= 1`.

**Hence `1 <= sum_{n>=1} n^{-p} <= 2`, i.e. `2^{-p} <= budget p <= 2*2^{-p}` -- the first needed estimate.**

**Sketched (compiles as a statement):**

```lean
lemma inv_sq_le_telescope (N : Nat) (hN : 1 <= N) :
    sum' n : Nat, ((N + n : Nat) : Real) ^ (-(2:Real)) <= 1 / (N : Real)
```

**The proof needs three ingredients, all Mathlib-level:**

1. `n^{-2} <= 1/((n-1)*n)` for `n >= 2` -- pure algebra;
2. the telescoping sum `sum' n, (1/(N+n-1) - 1/(N+n)) = 1/N` -- `tsum` of a telescoping sequence;
3. `Summable` of `n^{-2}` for the comparison -- `summable_nat_add_iff` + the `p`-series at `p = 2`.

**So the first OP-6 lemma is a standard `tsum`-comparison proof.**  This is ordinary Lean work of the kind
`PhiAsymptotic.lean` already contains (it has `uPhiS`-style sum estimates), so the patterns are in-tree.

**Next: implement `inv_sq_le_telescope` (or find the equivalent already in `PhiAsymptotic.lean`), then
`budget_bounds`.**

**Note:** `PhiAsymptotic.lean` has 0 sorries and contains `PhiS`/`uPhiS` sum bounds -- **check there first
for a `n^{-2}`-tail or `zeta`-style estimate already proved**, which would skip step 1-3 entirely.

### 13.539 Round-510: **MAJOR -- the `tailSum`/`budget` bounds are ALREADY LANDED; OP-6 is assembly**

Build green: **213 declarations, 7/7 OK**.

**`PhiAsymptotic.lean` (0 sorries) contains `sum_rpow_tail_le`:**

```lean
lemma sum_rpow_tail_le (n : Nat) (s : Real) (hs : 1 < s) (hn : 1 <= n) :
    (sum' m : Nat, (((m + 2*n + 1 : Nat) : Real)) ^ (-s)) <= ((2*(n:Real)) ^ (1 - s)) / (s - 1)
```

i.e. **`sum_{m} (m + 2n + 1)^{-s} <= (2n)^{-s} * (2n)/(s-1)`.**

**This is exactly the `p`-series tail estimate §13.538 wanted, and it was already in the file.**  With
`s = p` and `n` chosen so that `2n + 1 ~ N = nmin p`, the factor `(2n)/(s-1)` is **bounded**:
`2n ~ N ~ p/log2`, so `(2n)/(p-1) -> 1/log2 ~ 1.44`.  **So the upper bound on `tailSum p N` is
`(2N)^{-p} * (1/log2 + o(1))` -- an absolute constant.**

**And the lower bound is the first term: `tailSum p N >= (2N)^{-p}`.**

**For `budget`:** `budget p = 2^{-p} * sum_{m>=0} (m+1)^{-p} = 2^{-p}*(1 + 2^{-p} + sum_{m>=0}(m+3)^{-p})`,
and `sum_{m>=0}(m+3)^{-p} <= 2^{1-p}/(p-1)` by `sum_rpow_tail_le` with `n = 1`.  So

```
2^{-p}  <=  budget p  <=  2^{-p} * (1 + 1/4 + 2/(p-1))  <=  2.25 * 2^{-p}   (p >= 3).
```

**So ALL the inputs §13.536's decomposition needs are available from LANDED lemmas:**

1. `tailSum p (nmin p)` between `(2N)^{-p}` and `(2L/log2)*(2N)^{-p}` -- first term + `sum_rpow_tail_le`;
2. `budget p` between `2^{-p}` and `2.25*2^{-p}` -- first term + `sum_rpow_tail_le`;
3. `nmin p = p/log2 + O(1)` -- the LANDED `nmin_w_sharp`.

**OP-6 is therefore genuine ASSEMBLY over landed material, not a new development** -- reversing §13.538's
assessment.  The remaining work is the `log` algebra of `L = -nmin*log2 - log(tailSum) + log(budget)`
and the `IsBigO` wrapper.

**Next: prove `budget_bounds` (`2^{-p} <= budget p <= 2.25*2^{-p}` for `p >= 3`) from `sum_rpow_tail_le`
plus the first-term lower bound.**

### 13.540 Round-511: `term` is 1-based; `budget_bounds` statement compiles

Build green: **213 declarations, 7/7 OK**.

**`term`'s definition (correcting an assumption I had carried):**

```lean
def term (p n : Nat) : Real := (2 * ((n : Real) + 1)) ^ (-(p : Real))
```

**It is 1-BASED** -- `term p 0 = 2^{-p}` -- so

```
budget p = sum_n (2(n+1))^{-p} = 2^{-p} * sum_{m>=1} m^{-p} = 2^{-p} * zeta(p),
```

exactly as `Defs.lean`'s docstring states.

**The target statement compiles:**

```lean
example (p : Nat) (hp : 3 <= p) : budget p <= 2.25 * 2^(-(p:Real))
```

**Proof ingredients, all identified:**

* lower `2^{-p} <= budget p`: the `n = 0` term is `2^{-p}` and all terms are positive;
* upper: `budget p = 2^{-p}*(1 + 2^{-p} + sum_{m>=0}(m+3)^{-p})` and
  `sum_{m>=0}(m+3)^{-p} <= 2^{1-p}/(p-1)` by the LANDED `sum_rpow_tail_le` (with `n = 1`, `s = p`);
  hence `budget p <= 2^{-p}*(1 + 1/4 + 2/(p-1)) <= 2.25*2^{-p}` for `p >= 3`.

**Next: implement `budget_bounds` (`p >= 3 -> 2^(-p) <= budget p /\ budget p <= 2.25*2^(-p)`), splitting
the `tsum` at the first term and shifting the tail into `sum_rpow_tail_le`'s shape `(m + 2*1 + 1)^{-p} =
(m+3)^{-p}`.**

**Note on `PhiAsymptotic.lean` (62 declarations, now listed in full):** it contains `Phi_second_order`,
`threshold_second_order`, all the uniform variants, `PhiS_lipschitz`, `sum_rpow_tail_le`, and the
`log_one_add` family -- **so the `L`-decomposition's `log` algebra is likely covered too.**  The OP-6
assembly should draw on this file heavily.

### 13.541 Round-512: `budget_lower` written; `summable_term` is landed

Build green: **213 declarations, 7/7 OK**.

**Found: `Exact.lean:89  summable_term (p : Nat) (hp : 2 <= p) : Summable (term p)` -- landed.**

**`budget_lower` (straightforward):**

```lean
lemma budget_lower (p : Nat) (hp : 2 <= p) : 2^(-(p:Real)) <= budget p := by
  have hs := summable_term p hp
  have h0 : term p 0 = 2^(-(p:Real)) := by unfold term; norm_num
  rw [← h0, budget]
  exact hs.le_tsum 0 (fun i _ => by unfold term; positivity)
```

**`budget_upper` plan** (`p >= 3`): split the sum at the first two terms,
`sum_n (n+1)^{-p} = 1 + 2^{-p} + sum_n (n+3)^{-p}`, then apply the LANDED
`sum_rpow_tail_le (1) (p)` which gives exactly `sum_m (m + 3)^{-p} <= 2^{1-p}/(p-1)`.  Hence

```
budget p <= 2^{-p} * (1 + 2^{-p} + 2^{1-p}/(p-1)) = 2^{-p} * (1 + 2^{-p} + 2*2^{-p}/(p-1))
         <= 2^{-p} * (1 + 1/8 + 1/4) = 1.375 * 2^{-p} <= 2.25 * 2^{-p}    (p >= 3).
```

**So `budget_bounds` follows with the constant `2.25` (the actual bound is `<= 1.375`), from two landed
lemmas and two `tsum` splits.**

**Next: implement `budget_lower` + `budget_upper`, then the `tau` two-sided `tailSum` estimate.**

### 13.542 **LANDED (round 513): `budget_lower`** -- 214 declarations -- first try

`Op56/PhiThird.lean` now has **214 declarations** (0 sorries, 7/7 OK, 0 axioms), newly:

```lean
lemma budget_lower (p : Nat) (hp : 2 <= p) : 2^(-(p:Real)) <= budget p
```

proof: `summable_term p hp` then `hs.le_tsum 0` with `term p 0 = 2^{-p}` by `norm_num`.

**This is the first landed lemma of the OP-6 assembly**, and the first declaration added since
`uPhiS_lower_sharp3` (round 491).

**Next: `budget_upper` -- `p >= 3 -> budget p <= 2.25 * 2^(-p)`**, splitting `budget` at the first two terms
and applying `sum_rpow_tail_le (1) (p)` for `sum_m (m+3)^{-p} <= 2^{1-p}/(p-1)`.

### 13.543 Round-514: `budget_upper` -- the tail step works up to the index form

Build green: **214 declarations, 7/7 OK, 0 sorries**.

**Progress on `budget_upper`:** the key step -- factoring `2^{-p}` out of the tail and applying
`sum_rpow_tail_le 1 p` -- reduces to

```lean
have htail : (sum' m, (2 * ((m:Real) + 3)) ^ (-(p:Real)))
    <= 2^(-(p:Real)) * ((2:Real)^(1 - (p:Real)) / ((p:Real) - 1))
```

and the first error showed the only mismatch is **the index form**:
`sum_rpow_tail_le 1 p` produces `sum' m, ((m + 2 + 1 : Nat) : Real) ^ p)⁻¹` while the target has
`((m + 3 : Nat) : Real) ^ (-(p:Real))`.  These are the same object, but the cast/rpow/neg forms differ.

**My first repair attempt was over-complicated (three `congr`/`ext` steps for what is a cast identity)
and introduced two new errors.**  The recorded clean route:

1. state the extracted factor with **the exact index form `(m + 2 + 1 : Nat)`** and let `norm_num`/`push_cast`
   handle `2 + 1` inside the cast -- no `congr`/`ext` needed;
2. convert `x ^ (-(p:Real))` to `(x ^ p)⁻¹` **once, on the whole `tsum`**, via
   `Real.rpow_neg` under `tsum_congr`, rather than per-term inside a `congr 1` block.

**Next: rewrite the tail step with the exact index form and a single `tsum_congr` for the `rpow_neg`
conversion.**

### 13.544 Round-515: `budget_upper` -- the `rpow_neg` conversion is the sticking point

Build green: **214 declarations, 7/7 OK, 0 sorries**.

**Where it stands:** the factoring step is correct and applied,
`hfac : (2*(m+3))^(-p) = 2^(-p) * ((m + 2*1 + 1 : Nat):Real)^(-p)`, and `sum_rpow_tail_le 1 p` supplies
`Sigma'_m ((m + 2*1 + 1 : Nat):Real)^(-p) <= 2^(1-p)/(p-1)`.  The mismatch is only
`x ^ (-(p:Real))` versus `(x ^ p)^-1`.

**My attempts to convert it were wrong in two ways:**

* `tsum_inv` is **not a Mathlib name** (unknown identifier);
* trying to do the conversion per-term inside a `calc` left unsolved goals and a `positivity` failure.

**The clean conversion, recorded:** `sum_rpow_tail_le`'s conclusion is already in the `x^(-s)` form with
`s = p` -- Mathlib's `x ^ (-(p:Real))` IS `(x ^ p)^-1` definitionally via `Real.rpow_neg`, but the two
PRINT differently.  So:

```lean
have htail0 := sum_rpow_tail_le 1 p hp1 (le_refl 1)
have htail0' : (sum' m : Nat, (((m + 2*1 + 1 : Nat) : Real)) ^ (-(p:Real)))
    <= (2:Real) ^ (1 - (p:Real)) / ((p:Real) - 1) := by
  convert htail0 using 2 with m
  rw [Real.rpow_neg (by positivity)]      -- or: rw [← Real.rpow_neg]; ring_nf
```

**i.e. use `convert` (or `tsum_congr` + `Real.rpow_neg`) ONCE, on the whole `tsum` -- not per-term inside
a `calc`, and not via `tsum_inv`.**

**Next: apply `convert` on the whole `tsum` to get `htail0'`, then finish with the first-two-terms split
and the constant arithmetic `1 + 1/8 + 1/4 = 1.375 <= 2.25`.**

### 13.545 Round-516: the `convert` route WORKS; only the `tsum` split remains

Build green: **214 declarations, 7/7 OK, 0 sorries**.

**The `rpow_neg` conversion is solved, and the solution is simpler than the recorded plan:**

```lean
have htail0' : (∑' m : ℕ, (((m + 2*1 + 1 : ℕ)):ℝ) ^ (-(p:ℝ)))
    ≤ (2:ℝ)^(1 - (p:ℝ)) / ((p:ℝ) - 1) := by
  convert htail0 using 2 with m
  · norm_num          -- closes BOTH the base `(2*1)^(1-p) = 2^(1-p)` and the term-wise `rpow_neg`
```

**A single `norm_num` closes the whole `convert`** -- no `Real.rpow_neg`, no second bullet.  (My first
attempt added a second bullet for the term-wise goal and got "No goals to be solved", which is how I
learned `norm_num` had already handled it.)

**Also proved in the scratch: `htail`** -- the tail sum `Σ'_m (2*(m+3))^(-p) <= 2^(-p) * (2^(1-p)/(p-1))` --
via `hfac` (`Real.mul_rpow`), `tsum_mul_left`, and `mul_le_mul_of_nonneg_left htail0'`.

**Remaining for `budget_upper`:** the two-term split
`budget p = term p 0 + term p 1 + Σ'_m term p (m+2)` (two applications of `Summable.tsum_eq_zero_add`,
or `tsum_eq_zero_add` twice), then

```
budget p <= 2^{-p} + 2^{-p}*2^{-p} + 2^{-p}*(2^{1-p}/(p-1))
         = 2^{-p}*(1 + 2^{-p} + 2*2^{-p}/(p-1)) <= 2^{-p}*(1 + 1/8 + 1/4) = 1.375*2^{-p} <= 2.25*2^{-p}.
```

**Next: implement the two-term split and the constant arithmetic to finish `budget_upper`.**

### 13.546 Round-517: `budget_upper` structure in place; three sub-steps unsolved

Build green: **214 declarations, 7/7 OK, 0 sorries**.

**The proof now has the right shape** -- `htail0'` (single `norm_num`), `htail`, the two-term split via
`Summable.tsum_eq_zero_add`, `h0`/`h1` for the first two terms, and `h2'` converting `sum_m term p (m+2)`
into `htail`'s form.  **Errors at lines 31, 36, 40:**

* **36: "No goals to be solved"** -- a trailing `norm_num` after the split already closed the goal
  (the same phenomenon as §13.545);
* **31 and 40: unsolved goals** in the split's inner `rw` and in the final arithmetic.

**Recorded next steps for each:**

* line 31: after `rw [budget, hs.tsum_eq_zero_add]`, the shape is
  `term p 0 + Sigma'_n term p (n+1)`; apply `hs1.tsum_eq_zero_add` **to the second summand only**
  (`rw [hs1.tsum_eq_zero_add]` may need `conv_lhs` to target it), then `norm_num` closes -- drop the
  trailing `norm_num`;
* line 40: the final arithmetic needs `2^(-p) <= 2^(-3) = 1/8` (from `p >= 3` and
  `Real.rpow_le_rpow_of_exponent_le` with base `2 >= 1`), plus `2^(-p) * 2^(-p) <= 2^(-p) * 1/8`, then
  the constant `1 + 1/8 + 1/8 = 1.25 <= 2.25`.

**Next: fix the split (target the second summand) and the constant arithmetic.**

### 13.547 Round-518: `budget_upper` -- the `tsum` split keeps shifting form

Build green: **214 declarations, 7/7 OK, 0 sorries**.

**Three more errors, all in the split/rewrite plumbing:**

* **35: "No goals to be solved"** -- the `congr 1; ext b; ring_nf` closed more than intended;
* **42: unsolved goal** in the inner `rw`;
* **49: `rw` cannot find `term p 0`** -- because the `hsplit` rewrite never fired, so the goal is still
  `budget p <= 2.25 * 2^(-p)`.

**The root difficulty: `Summable.tsum_eq_zero_add` produces `1 + (b + 1)` where the target wants `b + 2`,
and each repair attempt shifts the mismatch rather than removing it.**

**Recorded cleaner route (avoid the split entirely):** compare `budget` to an explicit summable majorant
with `tsum_le_tsum`:

```lean
have hmaj : Summable (fun n : Nat =>
    if n = 0 then term p 0 else if n = 1 then term p 1 else (2 * ((n:Real) + 1)) ^ (-(p:Real)))
```

i.e. bound term-by-term with `budget p <= term p 0 + term p 1 + Sigma'_n (2(n+1))^(-p)` as a
`tsum_le_tsum` of the shifted series -- **no `tsum_eq_zero_add`, no index arithmetic**.

**Alternative (and the session's standard exit): state the whole `budget_upper` in a fresh scratch with the
split as a standalone `lemma budget_split`**, prove that in isolation, then use it.  Isolation has resolved
every comparable stall (rounds 459, 483).

**Next: isolate `budget_split` as its own lemma and prove it standalone.**

### 13.548 Round-519: **avoid the split entirely -- use the integral comparison on `budget` directly**

Build green: **214 declarations, 7/7 OK, 0 sorries**.

**The `tsum_eq_zero_add` split is avoidable.**  `sum_rpow_tail_le` proves its estimate by
`AntitoneOn.tsum_comp_add_le_integral`, and **the same tool applies to `budget` directly**:

```
budget p = sum_{n>=0} (2(n+1))^{-p}
         = term p 0 + sum_{n>=1} (2(n+1))^{-p}
         <= term p 0 + integral_{x >= 2} x^{-p} dx        -- antitone comparison from x = 2
         = 2^{-p} + 2^{1-p}/(p-1)
         = 2^{-p} * (1 + 2/(p-1))
         <= 2^{-p} * 2                     (p >= 3)
         <= 2.25 * 2^{-p}.
```

**Key point: the comparison starts at `x = 2`, which is the value of `2(n+1)` at `n = 1`.**  So the sum
from `n = 1` is majorised by the integral from 2, and there is **no index arithmetic at all** -- just
`term p 0` split off by `Summable.tsum_eq_zero_add` **once**, then the integral bound.

**And `2/(p-1) <= 1` for `p >= 3`, so the constant is `2`, comfortably below the stated `2.25`.**

**Recorded implementation:** mirror `sum_rpow_tail_le`'s own proof body (which is in
`PhiAsymptotic.lean`, lines 442-465), replacing its `AntitoneOn.tsum_comp_add_le_integral` argument's
lower limit `2*n` by `2` with `n = 1`.  **Do not use `tsum_eq_zero_add` twice; use it once and let the
integral absorb the rest.**

**Next: write `budget_upper` via the direct integral comparison.**

### 13.549 Round-520: the integral route needs `open MeasureTheory`; signature check pending

Build green: **214 declarations, 7/7 OK, 0 sorries**.

**Attempted `budget_upper` via the direct integral comparison** (starting at `x = 1` for the inner sum
`sum_{m>=1} m^{-p}`, split once from `budget` by `tsum_eq_zero_add`).  Errors:

* **14: `Unknown identifier IntegrableOn`** -- the scratch needs `open MeasureTheory` (or the qualified
  `MeasureTheory.IntegrableOn`).  `PhiAsymptotic.lean`'s own proof works, so the name exists; my scratch's
  namespace is the problem;
* **15/19: signature mismatches** around `integrableOn_Ioi_rpow_of_lt` and
  `AntitoneOn.tsum_comp_add_le_integral`.

**Recorded fix: copy `sum_rpow_tail_le`'s proof body verbatim (`PhiAsymptotic.lean:442-465`) and change
only `2*n` to `1`.**  That body already has the correct namespaces, the correct `hanti`/`hint`/`hnn`
argument shapes, and the correct `integral_Ioi_rpow_of_lt` application -- re-deriving them from memory is
what produced these three errors.

**Also revise the target constant:** with the inner sum bounded by `1 + 1/(p-1)`, the estimate is
`budget p <= 2^{-p}*(2 + 1/(p-1))`, which at `p = 3` is `2.5*2^{-p}` -- **so the stated `2.25` is too
tight; use `3`** (or `2.5`).

**Next: copy `sum_rpow_tail_le`'s body into the OP-6 section with `2*n -> 1`, state the constant as `3`,
and finish.**

### 13.550 Round-521: the scaling point -- `sum_rpow_tail_le`'s body needs `f x = (2x)^{-p}`

Build green: **214 declarations, 7/7 OK, 0 sorries**.

**Transcribing `sum_rpow_tail_le`'s body requires one substantive change, not just `2*n -> 1`:**

`sum_rpow_tail_le` applies `AntitoneOn.tsum_comp_add_le_integral` to `f x = x ^ (-s)` with shift `2*n`,
giving the sum `Σ'_m f(m + 2n) = Σ'_m (m + 2n)^{-s}`.

**For `budget` the summand is `(2(m+1))^{-p}`, i.e. `2^{-p} * (m+1)^{-p}` -- so the correct substitution is
`f x = (2*x) ^ (-(p:Real))` with shift `1`, giving `Σ'_m f(m+1) = Σ'_m (2(m+1))^{-p} = budget p`.**

**So the transcription is:**

```lean
have hanti : AntitoneOn (fun x : Real => (2*x) ^ (-(p:Real))) (Set.Ici (1:Real)) := ...
have hint  : IntegrableOn (fun x : Real => (2*x) ^ (-(p:Real))) (Set.Ioi (1:Real)) volume := ...
have hnn   : forall t in Set.Ioi (1:Real), 0 <= (2*t) ^ (-(p:Real)) := ...
have h := AntitoneOn.tsum_comp_add_le_integral (f := fun x : Real => (2*x) ^ (-(p:Real))) 1 hanti hint hnn
-- h : budget p <= integral_{Ioi 1} (2x)^{-p} dx
-- integral = 2^{-p} * 1/(p-1), so budget p <= 2^{-p} * (1 + 1/(p-1)) <= 3 * 2^{-p}
```

**The integral value:** `∫_{Ioi 1} (2x)^{-p} dx = 2^{-p} * ∫_{Ioi 1} x^{-p} dx = 2^{-p}/(p-1)` (the `2^{-p}`
factors out by `integral_comp_mul_left`-style scaling).

**Next: write `budget_upper` with `f x = (2x)^{-p}` and shift `1`, computing the scaled integral.**

### 13.551 Round-522: checking the integral-test form -- and the `a = 2` substitution

Build green: **214 declarations, 7/7 OK, 0 sorries**.

**Checking `AntitoneOn.tsum_comp_add_le_integral`'s exact shape against a known value.**  For
`p = 3`, `n = 1`, `sum_rpow_tail_le` gives `Σ_{m>=0}(2m+3)^{-3} <= 2^{-2}*2/2 = 0.25`, and the true value is
`1/27 + 1/125 + ... = 0.045` -- **consistent**, so the lemma's bound has no extra `f(a)` term; it is
`Σ_m f(m + a) <= ∫_{Ioi a} f` with `a = 2n`.

**For `budget` the summand is `(2(m+1))^{-p}`, which at `m = 0` is `2^{-p}` -- so the natural `a` is `2`,
not `1`:** with `a = 2`, `Σ'_m f(m + 2) = Σ_{k>=2} (2k)^{-p}` and `∫_{Ioi 2} x^{-p} dx = 2^{1-p}/(p-1)`.
Hence

```
budget p = term p 0 + Σ_{k>=2} (2k)^{-p}
         <= 2^{-p} + 2^{1-p}/(p-1)
         = 2^{-p} * (1 + 2/(p-1))
         <= 2^{-p} * 3          (p >= 3)
```

**but note: `a = 2` is not of the form `2n` for integer `n`** -- the lemma's shift is `2*n`, so with
`s = p` it produces `m + 2n`.  **The substitution that fits is `f x = (2x)^{-p}` with `a = 1`** (as
§13.550 recorded), because `2*(m+1) = 2m+2` and the lemma's `a` then plays the role of the *index shift*,
not the lower limit.

**Two candidate transcriptions, to be decided by compiling:**

1. `f x = x^(-p)`, `a = 2` -- but the lemma takes `a = 2*n` in ℕ, so this needs `n = 1` and gives `m + 2`,
   **which is exactly right**: `Σ'_m f(m + 2*1) = Σ_{k>=2} k^{-p}` with `f x = x^{-p}`.  **This is the
   cleanest**;
2. `f x = (2x)^{-p}`, `a = 1`.

**Next: use transcription 1 -- `sum_rpow_tail_le`-style body with `f x = x^(-p)`, `n = 1`, giving
`Σ_{k>=2} k^{-p} <= 2^{1-p}/(p-1)` -- then `budget p <= 2^{-p}*(1 + 2^{1-p}/(p-1)) <= 2^{-p}*(1 + 1) = 2*2^{-p}`.**

### 13.552 Round-523: **CORRECTION -- `sum_rpow_tail_le`'s summand carries `+1`, so it gives `k >= 3`**

Build green: **214 declarations, 7/7 OK, 0 sorries**.

**Re-reading the statement:**

```lean
lemma sum_rpow_tail_le (n : Nat) (s : Real) (hs : 1 < s) (hn : 1 <= n) :
    (sum' m : Nat, (((m + 2*n + 1 : Nat) : Real)) ^ (-s)) <= ((2*(n:Real)) ^ (1 - s)) / (s - 1)
```

**The summand is `m + 2*n + 1`, not `m + 2n`** -- so with `n = 1` the lemma bounds `Σ_{m>=0} (m+3)^{-p}`, i.e.
the tail from **`k = 3`**, with value `2^{1-p}/(p-1)`.

**§13.551's transcription 1 was therefore wrong:** `Σ_{k>=2} k^{-p}` is NOT what the lemma provides.

**And `budget p = 2^{-p} * Σ_{k>=1} k^{-p}`**, whose first two terms are `1` and `2^{-p}`.  So the correct
chain is

```
Σ_{k>=1} k^{-p} = 1 + 2^{-p} + Σ_{k>=3} k^{-p} <= 1 + 2^{-p} + 2^{1-p}/(p-1),
budget p <= 2^{-p} * (1 + 2^{-p} + 2*2^{-p}/(p-1)) <= 2^{-p} * (1 + 1/8 + 1/4) = 1.375*2^{-p} <= 3*2^{-p},
```

**so the two-term `tsum` split IS needed** -- but only one, and the terms are peeled with
`Summable.tsum_eq_zero_add` twice on the `k`-indexed series (or once plus a shift).

**Next: implement with the split, peeling `k = 1, 2` and then applying `sum_rpow_tail_le (1) (p)`.**

**Note:** this is the third consecutive round in which my reading of a landed lemma's index was off by
one (`m + 2n` vs `m + 2n + 1` at 519; `2*n -> 1` at 517).  **The statement should be re-read verbatim
immediately before each transcription, not from a previous round's summary.**

### 13.553 Round-524: read the proof body verbatim; two mechanical fixes remain

Build green: **214 declarations, 7/7 OK, 0 sorries**.

**Read `PhiAsymptotic.lean:442-465` directly** (as the previous round's note required).  The decisive line is

```lean
have h := AntitoneOn.tsum_comp_add_le_integral (f := fun x : Real => x ^ (-s)) (2*n) hanti hint hnn
```

and the statement's summand is `(m + 2*n + 1)`.  **So Mathlib's lemma concludes
`Σ'_m f(m + a + 1) <= ∫_{Ioi a} f`** -- the `+1` is produced by the lemma, which is why the statement has it.

**So for `budget` the correct instantiation is `f x = x^(-(p:Real))` and `a = 1`**, giving
`Σ'_m f(m + 2) = Σ_{k>=2} k^(-p) <= ∫_{Ioi 1} x^(-p) = 1/(p-1)`.  Then
`Σ_{k>=1} k^(-p) = 1 + Σ_{k>=2} k^(-p) <= 1 + 1/(p-1)`, and
`budget p = 2^(-p) * Σ_{k>=1} k^(-p) <= 2^(-p)*(1 + 1/(p-1)) <= 2^(-p)*3` for `p >= 3`.  **This matches
the `budget_upper` statement exactly.**

**Two errors, both mechanical:**

* **`Unknown identifier IntegrableOn`** -- the scratch lacks `open MeasureTheory` (the source file has it);
  **fix: add `open MeasureTheory` to the scratch**, or use the qualified `MeasureTheory.IntegrableOn`;
* **`AntitoneOn.tsum_comp_add_le_integral` signature mismatch** on `hanti` -- the argument order differs
  from my call; **fix: copy the call verbatim from line 455 and change only the shift to `1`**.

**Then the split:** `Σ'_m f(m+1) = 1 + Σ'_m f(m+2)` by `Summable.tsum_eq_zero_add` with
`f(m) = ((m:Real)+1)^(-(p:Real))`; the term-wise `Real.mul_rpow` factorisation and `tsum_mul_left` are
already verified (round 513).

**Next: add `open MeasureTheory`, copy the `tsum_comp_add_le_integral` call verbatim, and finish.**

### 13.554 Round-525: `open MeasureTheory` fixes the integral names; two forms found in SumIntegralComparisons

Build green: **214 declarations, 7/7 OK, 0 sorries**.

**`open MeasureTheory` resolves `IntegrableOn`** (the source file has it at line 59, alongside
`import Mathlib.Analysis.SumIntegralComparisons`).

**Reading `Mathlib/Analysis/SumIntegralComparisons.lean` gives the exact signature and a SIMPLER lemma:**

```lean
theorem AntitoneOn.tsum_comp_add_le_integral (N : Nat) (anti : AntitoneOn f (Ici (N:Real)))
    (integrable : IntegrableOn f (Ioi (N:Real))) (nonneg : forall t in Ioi (N:Real), 0 <= f t) : ...

theorem AntitoneOn.tsum_add_one_le_integral (anti : AntitoneOn f (Ici 0))
    (integrable : IntegrableOn f (Ioi 0)) (nonneg : forall t in Ioi 0, 0 <= f t) :
    (sum' n, f (n + 1)) <= integral x in Ioi 0, f x        -- NO `N` argument
```

**So the cleanest instantiation for `budget` is `f x = x ^ (-(p:Real))` with
`AntitoneOn.tsum_comp_add_le_integral (N := 1)`,** whose sum runs over `f(i+1)` for `i >= 1`, i.e.
`Σ_{k>=2} k^(-p)`, bounded by `∫_{Ioi 1} x^(-p) = 1/(p-1)`.

**Current error:** `Invalid argument name 'f' for integrableOn_Ioi_rpow_of_lt` -- that lemma takes `a`, and
its function is fixed.  **Fix: use `f := fun x => x^(-(p:Real))` throughout (no `+1` shift), and handle the
constant `2^{-p}` separately by `tsum_mul_left`** -- which is verified to work (round 513's `hfac`/`htail`).

**Next: `f x = x^(-p)`, `N := 1`, `integrableOn_Ioi_rpow_of_lt` for integrability, then the split and
`tsum_mul_left`.**

### 13.555 Round-526: **the lemma's conclusion read exactly -- `Sigma'_n f(n + N + 1) <= integral_{Ioi N} f`**

Build green: **214 declarations, 7/7 OK, 0 sorries**.

**Read `SumIntegralComparisons.lean:253-256` directly:**

```lean
theorem AntitoneOn.tsum_comp_add_le_integral (N : Nat) (anti : AntitoneOn f (Ici (N : Real)))
    (integrable : IntegrableOn f (Ioi (N : Real))) (nonneg : forall t in Ioi (N : Real), 0 <= f t) :
    sum' (n : Nat), f (n + N + 1 : Nat) <= integral x in Ioi (N : Real), f x
```

**With `N = 1` and `f x = x^(-(p:Real))` this gives `Σ'_n f(n+2) = Σ_{k>=2} k^(-p) <= ∫_{Ioi 1} x^(-p) = 1/(p-1)`**
-- exactly the fragment §13.555 wanted.  **The statement's shape is now known verbatim, not recalled.**

**Remaining error: `hanti` is rejected as an argument.**  `hanti : AntitoneOn (fun x => x^(-↑p)) (Set.Ici 1)`
does not match the expected type.  The likely cause is the **implicit `f`**: I passed
`(f := fun x : Real => x ^ (-(p:Real)))`, and the `hanti`/`hint`/`hnn` I built are about
`fun x => x ^ (-(p:Real))` -- the same term, but the elaboration may be unifying `f` against a
fresh metavariable before my `(f := ...)` binds.

**Recorded fix: state `f` via a local `set f : Real -> Real := fun x => x ^ (-(p:Real)) with hf` BEFORE
building `hanti`/`hint`/`hnn`, and pass `(f := f)` to the lemma call.**  That is the pattern that removed
the analogous mismatch for `hp4` at round 459 (isolate, then name the object once).

**Next: apply `set f ... with hf`, rebuild `hanti`/`hint`/`hnn` about `f`, and call the lemma with
`(f := f)`.**

### 13.556 Round-527: `Set.Ici 1` vs `Set.Ici ↑1` is a DELABORATION artifact; real mismatch elsewhere

Build green: **214 declarations, 7/7 OK, 0 sorries**.

**The full error message names the mismatch:**

```
hanti' has type  AntitoneOn g (Set.Ici 1)
but is expected to have type  AntitoneOn g (Set.Ici ↑1)
```

**Annotating `(1:Real)` explicitly did NOT change the displayed form** -- so both sides are `1 : Real`
and the difference is a delaboration artifact, not a genuine type difference.  **The real mismatch must be
in `g` itself**: `set g : Real -> Real := fun x => x ^ (-(p:Real)) with hg` introduces `g` as an opaque
abbreviation, and the lemma's implicit `f` may be unifying against `x ^ (-(p:Real))` unfolded rather than
against `g`.

**Recorded fix: do NOT use `set`; pass the function literally and let `hanti`/`hint`/`hnn` be built about
the SAME literal term, i.e. use `show` to fix the goal's `f`:**

```lean
refine AntitoneOn.tsum_comp_add_le_integral 1 ?_ ?_ ?_
```

with the three goals discharged by `hanti`, `hint`, `hnn` built from the same
`(fun x : Real => x ^ (-(p:Real)))` literal.  **Or, more robustly: prove the fragment as a STANDALONE
lemma with `f` as an explicit parameter** -- `lemma tail2_le (p) (hp) : ...` -- and let the elaborator
unify `f` from the goal rather than from a `set`.

**Next: build `hanti`/`hint`/`hnn` inline (no `set`, no `g`) and call the lemma with three `?_` goals.**

**Note: `budget_upper` is now nine rounds old and its smallest fragment still does not compile.**  The
fragment is ~20 lines; the obstacle is elaboration of one implicit argument.

### 13.557 Round-528: the lemma application now TYPE-CHECKS; only the helper sub-proofs fail

Build green: **214 declarations, 7/7 OK, 0 sorries**.

**The `set`-free version works.**  Passing `(f := fun x : Real => x ^ (-(p:Real)))` with the three
hypotheses built inline (no `set`, no `g`) **removed the application type mismatch** -- so §13.557's
diagnosis was right: the opaque `set` abbreviation was what blocked unification.

**Two errors remain, both inside the helper sub-proofs:**

* **15:63** -- `integrableOn_Ioi_rpow_of_lt`'s argument: `0 < 1` where it expects the bound hypothesis
  (argument order);
* **14:44** -- `linarith failed` in the `hanti` proof, at
  `(by linarith [Set.mem_Ici.mp ha] : (0:Real) < a)`.

**Recorded fixes:**

* `hanti`: `a ∈ Set.Ici (1:Real)` gives `(1:Real) <= a` by `Set.mem_Ici.mp ha`; write
  `have ha1 : (1:Real) <= a := ha` (membership in `Ici` IS the inequality, so `ha` can be used directly)
  and then `linarith only [ha1]` for `0 < a`;
* `integrableOn_Ioi_rpow_of_lt`: swap the arguments -- it takes `(h : -a < -1)` then `(hx : 0 < x)`, so
  `integrableOn_Ioi_rpow_of_lt (by linarith : (-(p:Real)) < -1) (by norm_num : (0:Real) < 1)` should be
  correct; if the error persists the parameter names are `a` and `x`, so use them explicitly.

**And the final step is written:** `convert h using 2 with k; · norm_num` -- the same one-liner that closed
the `rpow_neg` conversion at round 513.

**Next: fix the two sub-proofs; `tail2_le` should then compile, and `budget_upper` follows from it.**

**Note: `budget_upper` is ten rounds old.**  This round is the first where the lemma APPLICATION
type-checks; the remaining errors are in two three-line helper proofs.

### 13.558 Round-529: the two sub-proofs -- `Set.Ici ↑1` needs `Set.mem_Ici.mp`, and `a := p` is wrong

Build green: **214 declarations, 7/7 OK, 0 sorries**.

**Both recorded fixes were wrong in detail:**

* **14:30** -- `ha : a in Set.Ici ↑1` is NOT accepted as `(1:Real) <= a`: `Set.Ici ↑1` and `Set.Ici 1`
  delaborate differently and the coercion defeats the definitional unfolding.  **Fix: use
  `Set.mem_Ici.mp ha` (which is what round 521 had) and pass it to `linarith`.**
* **16:42** -- `integrableOn_Ioi_rpow_of_lt (a := p)` is wrong: the hypothesis `-(p:Real) < -1` is not
  what it expects.  Its parameters are `(a : Real)` and `(x : Real)` with the function `fun t => t ^ (-a)`,
  so the exponent argument is a **REAL**, not the natural `p`.  **Fix: `(a := (p:Real))`** -- or omit the
  named argument and let it infer, since `-(p:Real) < -1` determines `a = (p:Real)`.

**Next: `hanti` with `Set.mem_Ici.mp ha`; `integrableOn_Ioi_rpow_of_lt` with `(a := (p:Real))` (or
inferred).**

**Note: `budget_upper` is eleven rounds old; its twenty-line fragment still does not compile.**  Rounds
517-529 have produced ten diagnoses and no compiled line on this lemma.  **The recorded fallback -- state
`tail2_le` in a scratch with `f` as an EXPLICIT parameter and the integral bound as the only goal, with
NO helper hypotheses inline -- has not been tried.**

### 13.559 Round-530: **THE FRAGMENTS COMPILE STANDALONE** -- and the assembly fails on `Set.Ici 1` vs `Set.Ici ↑1`

Build green: **214 declarations, 7/7 OK, 0 sorries**.

**The minimal-fragment approach found the correct forms, both confirmed by compiling:**

```lean
-- antitone: works, and `Set.mem_Ici.mp` is what makes `ha` usable
intro a ha b hb hab
have ha1 : (1:Real) <= a := Set.mem_Ici.mp ha
exact Real.rpow_le_rpow_of_nonpos (by linarith only [ha1] : (0:Real) < a) hab (by linarith)

-- integrability: the signature is `{a c : Real} (ha : a < -1) (hc : 0 < c)`, NOT `1 < p`
integrableOn_Ioi_rpow_of_lt (a := -(p:Real)) (c := 1) (by linarith : -(p:Real) < -1) (by norm_num)
```

**Read from `ImproperIntegrals.lean:130`:**
`theorem integrableOn_Ioi_rpow_of_lt {a c : Real} (ha : a < -1) (hc : 0 < c) :
IntegrableOn (fun t => t ^ a) (Ioi c)` -- **the exponent is the real `a`, and there is no `1 < a`
hypothesis.**  This is what three rounds of guessed argument orders were working around.

**But the ASSEMBLED `tail2_le` still fails at the lemma call:**

```
hanti has type  AntitoneOn (fun x => x ^ (-↑p)) (Set.Ici 1)
but is expected to have type  AntitoneOn ... (Set.Ici ↑1)
```

**So the lemma's `N : Nat` is coerced (`↑1`) while my annotation's `1` is a real literal; the two are
equal but not syntactically identical, and the application is not up to definitional unfolding here.**

**Fix: pass `(N := 1)` explicitly AND state `hanti`/`hint`/`hnn` at `Set.Ici ((1:Nat):Real)`,** so both
sides carry the same coercion.  **Or use `refine ... (N := 1) ?_ ?_ ?_` and discharge the three goals,
letting each goal's expected type drive elaboration.**

**Next: `refine AntitoneOn.tsum_comp_add_le_integral (N := 1) ?_ ?_ ?_` with the three goals discharged
individually.**

### 13.560 Round-531: the coercion is the whole obstacle; full types now visible

Build green: **214 declarations, 7/7 OK, 0 sorries**.

**The full error messages make the obstruction exact:**

```
?m.75 has type  0 < 1
but is expected to have type  0 < ↑1
in the application  integrableOn_Ioi_rpow_of_lt ?m.68 ?m.75

ha has type  a ∈ Set.Ici ↑1
```

**`0 < 1` (the real literal) versus `0 < ↑1` (the coercion of `(1 : Nat)`).**  These are equal but not
syntactically identical, and **the elaborator will not unify them in this argument position.**

**The complete fix -- annotate EVERY occurrence with the coercion form:**

```lean
-- integrability
(integrableOn_Ioi_rpow_of_lt (a := -(p:Real)) (c := ((1:Nat):Real))
  (by linarith [hpR] : -(p:Real) < -1) (by norm_num : (0:Real) < ((1:Nat):Real)) : _)
-- antitone hypothesis stated at the same Ici
(by intro a ha b hb hab
    have ha1 : (((1:Nat):Real)) <= a := ha
    exact Real.rpow_le_rpow_of_nonpos (by linarith only [ha1] : (0:Real) < a) hab (by linarith))
-- nonneg
(by intro t ht
    exact Real.rpow_nonneg (le_of_lt (by linarith [Set.mem_Ioi.mp ht] : (0:Real) < t)) _)
```

**and the integral's `c` must likewise be `((1:Nat):Real)` in `integral_Ioi_rpow_of_lt`.**

**Next: annotate all five occurrences (`integrableOn`'s `c` and `hc`, `integral_Ioi`'s `c`, the `Ici`
hypothesis, and the `Ioi` hypothesis) with `((1:Nat):Real)`, then `tail2_le` compiles.**

### 13.561 Round-532: the `h1 : ((1:Nat):Real) = 1` rewrite clears the coercion; two goals left

Build green: **214 declarations, 7/7 OK, 0 sorries**.

**Introducing `have h1 : (((1:Nat):Real)) = (1:Real) := by norm_num` and `rw [h1]` at each site clears the
coercion mismatch.**  With that, the four-argument application to
`AntitoneOn.tsum_comp_add_le_integral` type-checks, and only two goals remain:

* **26:80** -- the integrability sub-goal (the `rw [h1]` there does not make the inner
  `integrableOn_Ioi_rpow_of_lt` call's type match);
* **34:2** -- the final `convert`/`norm_num`.

**Recorded fixes:**

* for 26: move the `rw [h1]` INSIDE the `exact`, i.e.
  `exact (integrableOn_Ioi_rpow_of_lt (a := -(p:Real)) (c := 1) ... : IntegrableOn _ (Set.Ioi (1:Real)))`
  and then `simpa [h1]` to convert to the `↑1` form the goal carries; or state the goal after `show`;
* for 34: the `convert h using 2 with k` may need `· ring_nf` or `· push_cast; ring` instead of
  `norm_num`, since the index is `k + 1 + 1` versus `k + 2`.

**Next: fix the two goals by `simpa [h1]` on the integrability term and `ring_nf` on the index.**

**Progress: the application now type-checks; two goals remain, both single-tactic.**

### 13.562 **LANDED (round 533): `tail2_le`** -- 215 declarations -- after 13 rounds

`Op56/PhiThird.lean` now has **215 declarations** (0 sorries, 7/7 OK, 0 axioms), newly:

```lean
lemma tail2_le (p : Nat) (hp : 2 <= p) :
    (sum' k : Nat, (((k:Real) + 2)) ^ (-(p:Real))) <= 1 / ((p:Real) - 1)
```

**The proof, in the form that finally compiled:**

```lean
have h1 : (((1:Nat):Real)) = (1:Real) := by norm_num
have h := AntitoneOn.tsum_comp_add_le_integral (f := fun x : Real => x ^ (-(p:Real))) (1:Nat)
  (by intro a ha b hb hab; rw [h1] at ha; have ha1 : (1:Real) <= a := ha
      exact Real.rpow_le_rpow_of_nonpos (by linarith only [ha1] : (0:Real) < a) hab (by linarith))
  (by simpa [h1] using (integrableOn_Ioi_rpow_of_lt (a := -(p:Real)) (c := 1)
        (by linarith [hpR] : -(p:Real) < -1) (by norm_num : (0:Real) < 1) :
          IntegrableOn (fun x : Real => x ^ (-(p:Real))) (Set.Ioi (1:Real))))
  (by intro t ht; rw [h1] at ht
      exact Real.rpow_nonneg (le_of_lt (by linarith [Set.mem_Ioi.mp ht] : (0:Real) < t)) _)
have hval : ... := by ... field_simp
rw [hval] at h
convert h using 2 with k
· push_cast; ring
```

**Also required: `open MeasureTheory` added to BOTH `namespace Op56` blocks of `PhiThird.lean`** -- the
file has two sibling blocks (lines 43 and 5987) and neither had it.

**All four obstacles, recorded for the remaining OP-6 work:**

1. **`Set.mem_Ici.mp ha`** is required to use a membership hypothesis as an inequality;
2. **`integrableOn_Ioi_rpow_of_lt {a c : Real} (ha : a < -1) (hc : 0 < c)`** -- the exponent is the REAL
   `a` (so `(a := -(p:Real))`), and there is no `1 < a` hypothesis;
3. **coercion: `((1:Nat):Real)` and `(1:Real)` are equal but not syntactically identical**, and the
   elaborator will not unify them in argument position -- **fix by a `h1` rewrite or `simpa [h1]`**;
4. **`convert h using 2 with k; · push_cast; ring`** for the index `k + 1 + 1` vs `k + 2`.

**Next: `budget_upper` from `tail2_le` + the round-513 `hfac`/`htail` machinery.**

### 13.563 Round-534: `budget_upper` -- the split's statement is right; two pieces to name

Build green: **215 declarations, 7/7 OK, 0 sorries**.

**The split, stated:**

```lean
example (p : Nat) (hp : 2 <= p) :
    (sum' k : Nat, (((k:Real) + 1)) ^ (-(p:Real)))
      = 1 + (sum' k : Nat, (((k:Real) + 2)) ^ (-(p:Real))) := by
  rw [hs.tsum_eq_zero_add]     -- hs : Summable (fun n => ((n:Real)+1)^(-(p:Real)))
  congr 1
  · norm_num                    -- f 0 = 1^(-p) = 1
  · apply tsum_congr; intro n; push_cast; ring    -- f(n+1) = (n+2)^(-(p:Real))
```

**Two pieces to supply:**

1. **`tsum_congr` (not `ext`)** for the second `congr 1` goal -- `ext` fails on `Real`; the error
   `No applicable extensionality theorem found for type Real` names it.  Fix recorded above;
2. **`hs : Summable (fun n : Nat => (((n:Real)+1)) ^ (-(p:Real)))`** -- the `p`-series summability.
   Candidates: `Real.summable_nat_rpow_inv` (for `1 < p`) or `summable_nat_add_iff 1` applied to
   `summable_term p hp` after factoring `2^(-(p:Real))` out by `Real.mul_rpow`/`tsum_mul_left`.

**Then `budget_upper`:**

```lean
budget p = 2^(-(p:Real)) * (sum' k, ((k:Real)+1)^(-(p:Real)))
         <= 2^(-(p:Real)) * (1 + 1/((p:Real)-1))        -- by the split and tail2_le
         <= 2^(-(p:Real)) * 2                          -- 1/(p-1) <= 1 for p >= 2
         <= 3 * 2^(-(p:Real)).
```

with `budget p = 2^(-(p:Real)) * Σ ...` by `Real.mul_rpow` + `tsum_mul_left` (the round-513 `hfac`
pattern, already verified).

**Next: find the `p`-series `Summable`, use `tsum_congr` for the split, then assemble `budget_upper`.**

### 13.564 **LANDED (round 535): `budget_upper`** -- 216 declarations -- `budget_bounds` COMPLETE

`Op56/PhiThird.lean` now has **216 declarations** (0 sorries, 7/7 OK, 0 axioms), newly:

```lean
lemma budget_upper (p : Nat) (hp : 2 <= p) : budget p <= 3 * 2^(-(p:Real))
```

**With `budget_lower` (round 513) this completes the `budget` two-sided estimate:**

```
2^(-p)  <=  budget p  <=  3 * 2^(-p).        (p >= 2)
```

**The proof, in the form that compiled:**

```lean
-- the p-series summability, from the landed `summable_term` by scaling
have h := (summable_term p hp).mul_left ((2:Real) ^ (p:Real))
refine h.congr (fun n => ?_)
rw [show ((2:Real)^(p:Real)) * term p n = ((n:Real)+1)^(-(p:Real)) from by
  unfold term
  rw [Real.mul_rpow ...]            -- (2*(n+1))^{-p} = 2^{-p} * (n+1)^{-p}
  rw [← mul_assoc, ← Real.rpow_add ...]
  rw [show (p:Real) + (-(p:Real)) = 0 by ring, Real.rpow_zero, one_mul]]
-- the split, via `Summable.tsum_eq_zero_add` and `tsum_congr`
-- the equality `budget p = 2^{-p} * Σ (n+1)^{-p}` by `Real.mul_rpow` + `tsum_mul_left`
-- then `tail2_le`, `div_le_one`, and `nlinarith`
```

**New obstacles recorded (reusable):**

1. **`tsum_congr` (never `ext`) for `tsum` equality goals** -- `ext` fails on `Real`;
2. **`Summable.mul_left` + `Summable.congr`** turns the landed `summable_term` into `p`-series
   summability; `Real.mul_rpow` then `← mul_assoc, ← Real.rpow_add` closes the term identity;
3. **the doubled namespace prefix** -- `budget_upper` sits in the SECOND `namespace Op56` block, so from a
   scratch importing `Op56.PhiThird` the name is **`Op56.Op56.tail2_le`**, not `Op56.tail2_le`.

**Next: the two-sided `tailSum p (nmin p)` estimate, then the `L`-decomposition.**

### 13.565 **LANDED (round 536): `tailSum_lower`** -- 217 declarations -- first try

`Op56/PhiThird.lean` now has **217 declarations** (0 sorries, 7/7 OK, 0 axioms), newly:

```lean
lemma tailSum_lower (p N : Nat) (hp : 2 <= p) : term p N <= tailSum p N
```

proof:

```lean
have hs : Summable (fun n : Nat => term p (N + n)) := by
  have h := (summable_nat_add_iff N).mpr (summable_term p hp)
  refine h.congr (fun n => ?_); ring_nf
rw [tailSum]
exact hs.le_tsum 0 (fun i _ => by unfold term; positivity)
```

**This is the lower half of the `tailSum p (nmin p)` two-sided estimate**, and it compiled on the first
attempt using only landed material (`summable_term`, `Summable.le_tsum`, `summable_nat_add_iff`,
`Summable.congr`).

**Next: `tailSum_upper`** -- `tailSum p N <= C * (2N)^{-p}` for `N` in the `nmin` range -- by the same
`AntitoneOn.tsum_comp_add_le_integral` route as `tail2_le` (round 533), now with all four obstacles
already recorded (§13.562): `Set.mem_Ici.mp`, the `{a c : Real}` signature, the `((1:Nat):Real)`
coercion, and `tsum_congr`.

### 13.566 Round-537: `tailSum_upper`'s core works -- ONE error left

Build green: **217 declarations, 7/7 OK, 0 sorries**.

**`tailSum_upper` stated as**

```lean
lemma tailSum_upper (p N : Nat) (hp : 2 <= p) (hN : 0 < N) :
    tailSum p N <= (2 * (N:Real)) ^ (-(p:Real)) * ((N:Real) / ((p:Real) - 1))
```

**and its whole analytic core compiles except one `linarith`** at line 29:

* `hfac` -- `term p (N+n) = 2^{-p} * (N + (n+1))^{-p}` by `unfold term`, `push_cast; ring`,
  `Real.mul_rpow` -- WORKS;
* `AntitoneOn.tsum_comp_add_le_integral (N := N)` with `f x = x^{-p}`, the three hypotheses via
  `Set.mem_Ici.mp` / `integrableOn_Ioi_rpow_of_lt (a := -(p:Real)) (c := (N:Real))` / `Real.rpow_nonneg`
  -- the APPLICATION type-checks;
* `hval : integral_{Ioi N} x^{-p} = N^{1-p}/(p-1)` via `integral_Ioi_rpow_of_lt` -- WORKS.

**Single remaining error: the `linarith` proving `-(p:Real) < -1` from `hpR : 2 <= (p:Real)`** inside the
integrability argument -- a trivial goal that needs the hypothesis in scope explicitly.

**Fix: `by linarith [hpR]` -> `by linarith only [hpR]`** or supply `show -(p:Real) < -1 from by linarith`.

**Then the assembly:** `tailSum p N = 2^{-p} * Σ'_n (N + (n+1))^{-p}` by `hfac` + `tsum_mul_left`, the sum
bounded by `∫_{Ioi N} x^{-p} = N^{1-p}/(p-1)` from `h`, and
`2^{-p} * N^{1-p}/(p-1) = (2N)^{-p} * N/(p-1)` by `Real.mul_rpow`/`ring`.

**Next: fix the `linarith`, then finish the assembly.**

### 13.567 Round-538: `tailSum_upper` assembly written; two `linarith` goals remain

Build green: **217 declarations, 7/7 OK, 0 sorries**.

**The assembly is in place:**

```lean
rw [hval] at h                      -- h : sum_{n} (N + (n+1))^{-p} <= N^{1-p}/(p-1)
rw [tailSum]; simp_rw [hfac]; rw [tsum_mul_left]
have hkey : 2^(-p) * (N^{1-p}/(p-1)) = (2*N)^(-p) * (N/(p-1)) := by
  rw [Real.mul_rpow ...]; have hN1 : N^(-p) * N = N^(1-p) := ...; rw [← hN1]; ring
linarith only [h, hkey]
```

**Two errors:** 29 (`linarith [hpR]` for `-(p:Real) < -1`) and 39 (the final `linarith only [h, hkey]`).

**Recorded fixes:**

* **29**: that `linarith` sits inside a term where `hpR` may not be in the local context; **use
  `by exact_mod_cast (by omega : 1 < p)`-style or state `have hpR' : (1:Real) < (p:Real) := by
  exact_mod_cast (by omega : 1 < p)` immediately before the argument, and pass `hpR'`**;
* **39**: the final comparison needs `h`'s conclusion in the same form as the goal's left side; **print
  the goal** (`linarith` failures here have consistently been shape mismatches) and supply the missing
  `Real.mul_rpow`/`ring` identity explicitly.

**Next: state `hpR'` locally for 29, print the goal at 39, and land `tailSum_upper`.**

**Progress:** the lemma's analytic content is fully written; the two errors are a scoping issue and a
shape mismatch.

### 13.568 Round-539: `Real.rpow_one` fixed the `hN1` step; two errors remain

Build green: **217 declarations, 7/7 OK, 0 sorries**.

**Printed goal 39:** `↑N ^ (-↑p) * ↑N = ↑N ^ (-↑p) * ↑N ^ 1` -- the `← hN1` rewrite left `N^1` on the
right.  **Fix: `rw [..., Real.rpow_one]` in `hN1`** (applied).

**Two errors remain (29, 43):**

* **29** -- the `linarith` inside the antitone sub-proof producing `-(p:Real) < -1` from `hpR`.  Note this
  is the SAME site the previous round identified; `hpR` IS in the context (the error listing shows it), so
  the issue is that `linarith [hpR]` needs the explicit form
  `by have hp1 : (1:Real) < (p:Real) := by linarith only [hpR]; linarith`;
* **43** -- the final `linarith only [h, hkey]`; the negation is needed.

**Next: print 29's and 43's negated goals (bounded ranges) and supply the explicit constants.**

**Note: `tailSum_upper` is now the fifth consecutive round with the analytic content complete and only
`linarith`/shape errors remaining.**

### 13.569 Round-540: `hval`'s goal printed -- it is the `field_simp` identity; the edit hit the wrong site

Build green: **217 declarations, 7/7 OK, 0 sorries**.

**Printed goal 29 (the `hval` sub-proof):**

```
hfac : forall n, term p (N + n) = 2^(-p) * (N + (n+1))^(-p)
h    : sum'_n (n + N + 1)^(-p) <= integral_{Ioi N} x^(-p)
⊢ -N^(1-p)/(1-p) = N^(1-p)/(p-1)
```

**So error 29 is the SAME identity that `tail2_le` closed with `field_simp`** (`-A/(1-p) = A/(p-1)`).

**But my `field_simp` edit landed on the FIRST `integral_Ioi_rpow_of_lt` occurrence** -- the one inside the
integrable argument -- rather than on `hval`'s.  **The file has two occurrences.**

**Fix: apply `field_simp` (after `have hp2 : 0 < (p:Real) - 1 := by linarith [hpR]`) inside `hval`'s proof
block specifically**, which is the one whose goal is the `-A/(1-p) = A/(p-1)` identity.

**And error 45 is the final `linarith only [h, hkey]`** -- print its negation next.

**Next: move the `field_simp` into `hval` (the second `integral_Ioi_rpow_of_lt` site), then print 45.**

### 13.570 Round-541: `tailSum_upper` -- ONE error, an index-form mismatch one `simpa` short

Build green: **217 declarations, 7/7 OK, 0 sorries**.

**Progress through the round:**

* **`hval` closed** by `rw [show (1:Real) - (p:Real) = -((p:Real)-1) by ring, neg_div_neg_eq]` -- the
  `field_simp` alone did not (the `rpow` blocks it), and `neg_div_neg_eq` is the step that does it;
* **the final `linarith`** was fixed in two stages -- first by
  `mul_le_mul_of_nonneg_left h (by positivity)` to lift `h` through `2^{-p}`, then by **`rw [hkey] at hm`**
  (the `rw`-before-`linarith` rule, for the SIXTH time this session) -- and `hm` now has exactly the
  goal's shape;
* **one error remains**: `simpa only [add_comm, add_assoc, add_left_comm] using hm` leaves
  `hm : 2^{-p} * sum'_n (N + (n+1))^{-p} <= (2N)^{-p} * (N/(p-1))`, which after `simpa` still reports a
  type mismatch -- so the residual difference is in the `sum'`'s BINDER (the goal's `x` versus `hm`'s
  `n`) or in the `2`-exponent's coercion.

**Recorded fix:** replace the `simpa` by an explicit
`tsum_congr`-based conversion, or state the whole final step in the goal's exact form and use
`convert hm using 1` then discharge the residual with `ring`.

**Next: `convert hm using 1` and close the residual.**

**Progress:** `tailSum_upper` is one `convert` from landing; `budget_bounds` and `tailSum_lower` are
already in the file (217 declarations).

### 13.571 **LANDED (round 542): `tailSum_upper`** -- 218 declarations -- `tailSum` bounds COMPLETE

`Op56/PhiThird.lean` now has **218 declarations** (0 sorries, 7/7 OK, 0 axioms), newly:

```lean
lemma tailSum_upper (p N : Nat) (hp : 2 <= p) (hN : 0 < N) :
    tailSum p N <= (2 * (N:Real)) ^ (-(p:Real)) * ((N:Real) / ((p:Real) - 1))
```

**With `tailSum_lower` this gives the two-sided `tailSum` estimate:**

```
term p N  <=  tailSum p N  <=  (2N)^{-p} * (N/(p-1)).
```

**And with `budget_bounds` (`2^{-p} <= budget p <= 3*2^{-p}`) that is TWO of OP-6's four pieces.**

**New fix recorded:** the final step needed `convert hm using 1` followed by **`congr 1`** and then
`tsum_congr` -- the constant factor `2^{-p}` prevents `tsum_congr` from applying directly, so the `congr 1`
is required to strip it first.

**Also confirmed for the sixth time:** `rw [hkey] at hm` before `exact`, not `linarith only [..., hkey]`.

**Next: the `L`-decomposition.**  `L p = -nmin p * log2 - log(tailSum p (nmin p)) + log(budget p)`, with

* `nmin p = p/log2 + O(1)` -- landed `nmin_w_sharp`;
* `budget p` two-sided -- landed;
* `tailSum p (nmin p)` two-sided -- now landed;

giving `L p = p log p - (1 + log log 2) p + (5/2) log 2 + O(1)`.

### 13.572 Round-543: the `L`-decomposition plan

Build green: **218 declarations, 7/7 OK, 0 sorries**.

**The target:** `(fun p => L p - LAsym p) =O[atTop] (fun _ => 1)`, i.e. **`L p - LAsym p` is bounded**.

**The decomposition:**

```
L p = -log(reachableFraction p)
    = -log(2^(nmin p) * tailSum p (nmin p) / budget p)
    = -nmin p * log2 - log(tailSum p (nmin p)) + log(budget p).
```

**Each term, with the landed bounds (writing `N = nmin p`, `L = log2`):**

* `-nmin p * log2 = -p + (5/2)L + O(L/p)` -- from the landed `nmin_w_sharp`
  (`nmin p = p/log2 + O(1)`);
* `-log(tailSum p N)`: from the landed two-sided `tailSum` estimate,
  `log(tailSum p N) = log((2N)^{-p}) + O(1) = -p*log(2N) + O(1)`, and `2N = 2p/L + O(1)`, so
  `-log(tailSum p N) = p*log p + p*(log2 - loglog2) + O(1)`;
* `log(budget p) = -p*log2 + O(1)` -- from the landed `budget_bounds`.

**Summing:**

```
L p = p log p + p(log2 - loglog2) - p log2 - p + (5/2)log2 + O(1)
    = p log p - (1 + loglog2) p + (5/2)log2 + O(1)
    = LAsym p + (5/2)log2 + O(1),
```

**so `L p - LAsym p` is bounded -- the theorem.**

**First fragment to compile:** the log-transfer from the two-sided bound,

```lean
lemma log_tailSum_close (p N : Nat) (hp : 2 <= p) (hN : 0 < N) (hNp : (N:Real) <= (p:Real)) :
    |Real.log (tailSum p N) - Real.log ((2 * (N:Real)) ^ (-(p:Real)))| <= Real.log 4
```

using `Real.log_le_sub_one_of_pos`/`Real.log_le_iff_le_exp` on the two-sided estimate
`term p N <= tailSum p N <= (2N)^{-p} * (N/(p-1))` with `N/(p-1) <= 2` under `N <= p`.

**Next: write `log_tailSum_close` as the first fragment.**

### 13.573 Round-544: the ratio bounds for `log_tailSum_close` worked out

Build green: **218 declarations, 7/7 OK, 0 sorries**.

**From the two landed bounds, with `N = nmin p`, `2 <= p`:**

```
(2(N+1))^{-p}  = term p N  <=  tailSum p N  <=  (2N)^{-p} * (N/(p-1)).
```

**Dividing by `(2N)^{-p}` the ratio lies in**

```
[ ((N+1)/N)^{-p} ,  N/(p-1) ].
```

**Upper end:** with `N <= p` (from `nmin_w_sharp`), `N/(p-1) <= p/(p-1) <= 2`, so `log <= log 2`.

**Lower end:** `((N+1)/N)^{-p} = exp(-p*log(1 + 1/N)) >= exp(-p/N)`, and `p/N <= L + o(1) < 1`, so
the lower end is `>= exp(-1) = 1/e > 1/4`.

**Hence `|log(tailSum p N) - log((2N)^{-p})| <= log 4`** -- the statement recorded at §13.572 -- **provided
`p <= N <= 2p`**, which `nmin_w_sharp` supplies in the `nmin` range.

**Needed auxiliary facts (all elementary):**

* `Real.log_le_sub_one_of_pos` for `log x <= x - 1`, hence `log(x y) = log x + log y` bounds;
* `Real.log_le_iff_le_exp` or simply `Real.log_le_log` on positive reals for the two-sided bound;
* `N <= p` and `p/N <= 2` from `nmin_w_sharp` (whose conclusion is `|p/N - log2| <= 4/N`).

**Next: write `log_tailSum_close` with these hypotheses; it is the first fragment of the
`L`-decomposition.**

### 13.574 **LANDED (round 545): `log_tailSum_upper`** -- 219 declarations -- first try

`Op56/PhiThird.lean` now has **219 declarations** (0 sorries, 7/7 OK, 0 axioms), newly:

```lean
lemma log_tailSum_upper (p N : Nat) (hp : 2 <= p) (hN : 0 < N) (hNp : (N:Real) <= (p:Real)) :
    Real.log (tailSum p N) <= Real.log ((2 * (N:Real)) ^ (-(p:Real))) + Real.log 2
```

proof: `tailSum_lower` for positivity, `tailSum_upper` for the bound, `N/(p-1) <= 2` from `N <= p`,
`Real.log_le_log` twice and `Real.log_mul`.

**This is the first `L`-decomposition fragment**, and it is the UPPER half of

```
|log(tailSum p N) - log((2N)^{-p})| <= log 2      (upper half; lower half is log 4 - log 2)
```

**The lower half** -- `log(tailSum p N) >= log((2N)^{-p}) - log 2` -- follows from
`term p N <= tailSum p N` and `(2(N+1))^{-p} >= (2N)^{-p} * (1/2)` under `p <= N`; it needs
`Real.log_le_log` on `(2N)^{-p}/2 <= (2N+1)^{-p}*...`, i.e. the `exp(-p/N) >= 1/2` estimate of §13.573.

**Next: `log_tailSum_lower`, then the `nmin`-range assembly and the `IsBigO` wrapper.**

### 13.575 Round-546: `log_tailSum_lower`'s statement compiles; the proof needs `nmin_w_sharp`'s hypothesis

Build green: **219 declarations, 7/7 OK, 0 sorries**.

**The statement, which compiles:**

```lean
lemma log_tailSum_lower (p N : Nat) (hp : 2 <= p) (hN : 8 <= N) (hNp : (N:Real) <= (p:Real)) :
    Real.log ((2 * (N:Real)) ^ (-(p:Real))) - Real.log 4 <= Real.log (tailSum p N)
```

**The proof's chain:**

1. `term p N <= tailSum p N` (landed `tailSum_lower`) and `0 < term p N`, so
   `log(term p N) <= log(tailSum p N)`;
2. `term p N = (2(N+1))^{-p} = (2N)^{-p} * (1 + 1/N)^{-p}`, and
   `(1 + 1/N)^{-p} = exp(-p*log(1+1/N)) >= exp(-p/N)`,
   using the LANDED `log_one_add_le` (`PhiAsymptotic.lean:64`);
3. **the needed hypothesis is `nmin_w_sharp`'s conclusion** --
   `(p:Real)/(N:Real) <= Real.log 2 + 4/(N:Real)` -- which gives `p/N <= 1` for `N >= 8`, hence
   `exp(-p/N) >= exp(-1) > 1/4`, so `term p N >= (2N)^{-p}/4`;
4. `log` monotonicity then gives the statement.

**So `log_tailSum_lower` must take the `nmin_w_sharp` bound as an explicit hypothesis:**

```lean
lemma log_tailSum_lower (p N : Nat) (hp : 2 <= p) (hN : 8 <= N) (hNp : (N:Real) <= (p:Real))
    (hpn : (p:Real) / (N:Real) <= 2) :
    Real.log ((2 * (N:Real)) ^ (-(p:Real))) - Real.log 4 <= Real.log (tailSum p N)
```

**Next: write `log_tailSum_lower` with `hpn : (p:Real)/(N:Real) <= 2` as the hypothesis, then apply it at
`N = nmin p` with `nmin_w_sharp` supplying `hpn`.**

### 13.576 Round-547: the constant is `log 9`; `Real.exp_one_lt_three` is the bound to use

Build green: **219 declarations, 7/7 OK, 0 sorries**.

**The lower half's constant, determined:**

`(1 + 1/N)^p <= exp(p*log(1 + 1/N)) <= exp(p/N) <= exp 2 = (exp 1)^2 < 9`, using the LANDED
`log_one_add_le` (`log(1+x) <= x`) and **`Real.exp_one_lt_three : Real.exp 1 < 3`**
(`Mathlib/Analysis/Complex/ExponentialBounds.lean:44`).

**Hence `term p N = (2N)^{-p} * (1 + 1/N)^{-p} >= (2N)^{-p}/9`,** and with `tailSum p N >= term p N`:

```lean
lemma log_tailSum_lower (p N : Nat) (hp : 2 <= p) (hN : 8 <= N) (hNp : (N:Real) <= (p:Real))
    (hpn : (p:Real) / (N:Real) <= 2) :
    Real.log ((2 * (N:Real)) ^ (-(p:Real))) - Real.log 9 <= Real.log (tailSum p N)
```

**So the two halves are:** upper `+ log 2` (landed), lower `- log 9`.

**Names to use:** `Real.log_one_add_le`-equivalent is the in-tree `log_one_add_le` (PhiAsymptotic:64);
`Real.exp_one_lt_three`; `Real.log_le_log`; `Real.log_mul`; `Real.log_div`.

**Next: write `log_tailSum_lower` with `log 9`, using `Real.exp_one_lt_three` and the landed
`log_one_add_le`.**

**Note:** `Op56/PhiAsymptotic.lean` already has `log_one_add_le` at line 64 with exactly the statement
`Real.log (1 + x) <= x` for `0 < 1 + x` -- so the `exp(p/N)` step is a one-liner from in-tree material.

### 13.577 Round-548: `log_tailSum_lower` written; three shape errors

Build green: **219 declarations, 7/7 OK, 0 sorries**.

**Correct fixes already applied:**

* `(1+1/N)^p` needs **`Real.rpow_def_of_pos`** (not `← Real.exp_log`), which rewrites it to
  `exp(p * log(1+1/N))` -- then `Real.exp_le_exp` applies;
* `div_le_iff₀` on `A/9 <= A * ((1+1/N)^p)⁻¹` needs a `mul_comm` first.

**Three errors remain:**

* **29** -- `h9 : (1+1/N)^p <= 9` from `hpow <= exp 2`: use
  `have h9' : Real.exp 2 < 9 := by rw [show (2:Real) = 1+1 by norm_num, Real.exp_add];
  nlinarith [Real.exp_one_lt_three, Real.exp_pos 1]` then `linarith [hpow, h9']`;
* **32/33** -- `Real.rpow_def_of_pos hN1` argument type; the lemma wants `0 < x` for `x ^ y`'s base, and
  `hN1 : 0 < 1 + N⁻¹` should match -- the error says otherwise, so pass the base explicitly or use
  `Real.rpow_neg`/`Real.rpow_natCast` decomposition instead.

**Next: fix 29 with the explicit `exp 2 < 9`, then inspect 33's expected type.**

### 13.578 Round-549: `exp 2 < 9` fixed; `rpow_def_of_pos` argument and the ordering still off

Build green: **219 declarations, 7/7 OK, 0 sorries**.

**Fixed:** `h9' : Real.exp 2 < 9` by `rw [show (2:Real) = 1+1 by norm_num, Real.exp_add]` then
`nlinarith [Real.exp_one_lt_three, Real.exp_pos 1]`, and `h9 := le_trans hpow h9'.le`.

**Three errors remain:**

* **33/34** -- `Real.rpow_def_of_pos hN1`: `hN1 : 0 < 1 + N^{-1}` is rejected.  `Real.rpow_def_of_pos`
  takes `(hx : 0 < x)` for `x ^ y`; the error suggests it wants a different form -- check whether the goal's
  `(1 + N^{-1}) ^ (p:Real)` has the base already normalised.  **Fix: `rw [Real.rpow_def_of_pos (by
  positivity : (0:Real) < 1 + (N:Real)⁻¹)]` with the base written out.**
* **41** -- `le_inv_comm₀` does not see `9 <= ?⁻¹`; the goal after `div_le_iff₀` and `mul_comm` is
  `(2N)^{-p} <= ((1+N^{-1})^p)⁻¹ * (2N)^{-p} * 9`, so **`linarith [h9, hbase]` should close it directly
  without `le_inv_comm₀`** -- drop that step.

**Next: drop the `le_inv_comm₀` step at 41 and pass the base explicitly at 33.**

### 13.579 Round-550: `Real.mul_rpow` wanted `<=` not `<`; two goals left in `hterm_eq`

Build green: **219 declarations, 7/7 OK, 0 sorries**.

**Fixed:** `Real.mul_rpow (by positivity) hN1.le` -- the lemma's second argument is `0 <= y`, not `0 < y`;
and `show ... by ring_nf` for the base identity `2*((N:Real)+1) = (2*N)*(1 + N^{-1})`.

**Two goals remain, both inside `hterm_eq`:**

```lean
have hterm_eq : term p N = (2 * (N:Real)) ^ (-(p:Real)) * ((1 + (N:Real)⁻¹) ^ (p:Real))⁻¹ := by
  unfold term
  rw [show (2 * ((N:Real) + 1)) = (2 * (N:Real)) * (1 + (N:Real)⁻¹) by ring_nf]
  rw [Real.mul_rpow (by positivity) hN1.le]
  rw [Real.rpow_neg (by positivity), inv_mul_eq_div]
  ring                                    -- <-- fails
```

**31/33 are the `ring_nf` and the final `ring`.**  After `Real.mul_rpow` the term is
`(2N)^{-p} * (1+N^{-1})^{-p}` (with `-(p)` the exponent), and after `Real.rpow_neg` it becomes
`(2N)^{-p} * ((1+N^{-1})^p)^{-1}` -- which IS the target, so the final `ring` should be `rfl` or
`rw [mul_comm]`; the `inv_mul_eq_div` step is likely wrong here and should be dropped.

**Next: drop `inv_mul_eq_div` and replace the final `ring` with `rfl` (or remove it).**

### 13.580 Round-551: `hterm_eq`'s residual is one `rpow_neg`; `hge` needs an explicit `inv` bound

Build green: **219 declarations, 7/7 OK, 0 sorries**.

**Printed goal 31:**

```
h9 : (1 + N^{-1})^p <= 9
⊢ ((2*N)^p)^{-1} * (1 + N^{-1})^(-p) = ((2*N)^p)^{-1} * ((1 + N^{-1})^p)^{-1}
```

**So the only missing step is `(1 + N^{-1})^(-p) = ((1 + N^{-1})^p)^{-1}`** -- i.e. one more
`rw [Real.rpow_neg (by positivity)]`.  (My earlier `rw [Real.rpow_neg]` targeted the `(2*N)` factor only.)

**Printed goal 40 (the `hge` step):**

```
a✝ : ((1 + N^{-1})^p)^{-1} * (2*N)^(-p) * 9 < (2*N)^(-p)
```

**i.e. the goal is `1 <= ((1+N^{-1})^p)^{-1} * 9`, equivalently `(1+N^{-1})^p <= 9` -- which IS `h9`.**
**The missing fact is the reciprocal implication `9^{-1} <= ((1+N^{-1})^p)^{-1}`**, which `nlinarith` cannot
build from `h9` alone; **supply it explicitly**:

```lean
have hinv : ((1 + (N:Real)⁻¹) ^ (p:Real))⁻¹ >= (9:Real)⁻¹ :=
  inv_le_inv₀ (by norm_num) (by positivity) |>.mpr h9
```

then `nlinarith [hinv, hbase]`.

**Next: add the missing `Real.rpow_neg` at 31 and the explicit `inv_le_inv₀` bound at 40.**

### 13.581 Round-552: two errors left; `positivity` cannot see `0 < 1 + N^{-1}` without `hNpos`

Build green: **219 declarations, 7/7 OK, 0 sorries**.

**The extra `Real.rpow_neg` was applied** at the `(1 + N^{-1})` factor.

**Two errors remain (33, 35):**

* **35** -- `positivity` fails on `(0:Real) < 1 + (N:Real)^{-1}`: `N` is a NATURAL cast, so `positivity`
  cannot rule out `N = 0` on its own.  **Fix: `have hNpos : (0:Real) < (N:Real) := by exact_mod_cast
  (by omega : 0 < N)` is already in scope -- use `by linarith [hNpos, inv_pos_of_pos hNpos]` or
  `by have := hNpos; positivity`.**  (`positivity` does use local hypotheses of the right shape; the
  error shows it tried `add_pos'` with `(1:Real)` and then failed at the `N^{-1}` term.)
* **33** -- the `hterm_eq` goal after the two `rpow_neg` rewrites; **print it**.

**Next: replace that `positivity` by `by have := hNpos; positivity`, then print 33.**

### 13.582 Round-553: the `rpow_neg` base argument wants a different form; print the expected type

Build green: **219 declarations, 7/7 OK, 0 sorries**.

**`add_pos one_pos (inv_pos.mpr hNpos)` has type `0 < 1 + (N:Real)^{-1}`, but the lemma expects
something else** -- the error truncates the expected type.

**Likely cause: `Real.rpow_neg`'s statement is `x ^ (-y) = (x ^ y)^{-1}` for `x ≠ 0` (`hx : x ≠ 0`) in
this Mathlib version, not `0 < x`.**  `Real.rpow_neg` in recent Mathlib takes `(hx : x ≠ 0)`.

**Fix: `Real.rpow_neg (ne_of_gt (by exact add_pos one_pos (inv_pos.mpr hNpos)))`,** or simply
`Real.rpow_neg (by positivity)` if the `≠ 0` form lets `positivity` work.

**Next: read `Real.rpow_neg`'s signature (`#check` or grep in Mathlib) and pass the argument in the
expected form.**

**Note:** the same `Real.rpow_neg (by positivity)` is used elsewhere in the file and works, so the shape
is `x ≠ 0` there or `0 < x`; the error will name it once the expected type is printed in full.

### 13.583 **LANDED (round 554): `log_tailSum_lower`** -- 220 declarations -- `log(tailSum)` bounds COMPLETE

`Op56/PhiThird.lean` now has **220 declarations** (0 sorries, 7/7 OK, 0 axioms), newly:

```lean
lemma log_tailSum_lower (p N : Nat) (hp : 2 <= p) (hN : 8 <= N) (hNp : (N:Real) <= (p:Real))
    (hpn : (p:Real) / (N:Real) <= 2) :
    Real.log ((2 * (N:Real)) ^ (-(p:Real))) - Real.log 9 <= Real.log (tailSum p N)
```

**With `log_tailSum_upper` (`+ log 2`) this is the full two-sided `log(tailSum)` estimate.**

**Three signatures read this round, all now recorded:**

1. **`Real.rpow_neg {x : Real} (hx : 0 <= x) (y : Real) : x ^ (-y) = (x ^ y)^{-1}`**
   (`Pow/Real.lean:260`) -- **`0 <= x`, NOT `0 < x`, and `y` is explicit.**  This is why
   `Real.rpow_neg (by positivity)` works at `0 <`-shaped goals but not when the argument is built as
   `add_pos ...`; use `le_of_lt` or a `0 <=`-typed term.
2. **`field_simp` closes `2 + N*2 = N*2 + N*N^{-1}*2` outright** (from `N ≠ 0`) -- the trailing `ring` was
   superfluous.
3. `Real.exp_one_lt_three` gives `exp 2 < 9` by `Real.exp_add` and `nlinarith`.

**Next: the `L`-decomposition assembly** -- apply `log_tailSum_upper`/`log_tailSum_lower` at
`N = nmin p` with `nmin_w_sharp` supplying `hpn` and `hNp`, then bound `nmin p * log2` and
`log(budget p)`, then the `IsBigO` wrapper.

### 13.584 Round-555: the `L`-decomposition fragment sketched

Build green: **220 declarations, 7/7 OK, 0 sorries**.

**The statement, which compiles:**

```lean
lemma L_decomp (p : Nat) (hp : 2 <= p) :
    L p = -((nmin p : Real)) * Real.log 2 - Real.log (tailSum p (nmin p))
      + Real.log (budget p)
```

**The proof chain:**

1. `reachableFraction p = reachableMeasure p / budget p` and
   `reachableMeasure p = 2^(nmin p) * tailSum p (nmin p)` (both by `unfold`), so
   `L p = -Real.log (2^(nmin p) * tailSum p (nmin p) / budget p)`;
2. `log_mul`, `log_div`, and **`Real.log_pow`** (`log (2^n) = n * log 2`) split it into
   `-nmin*log2 - log(tailSum) + log(budget)`;
3. positivity: `0 < 2^(nmin p)`, `0 < tailSum p (nmin p)` (from `tailSum_lower` and `0 < term`),
   `0 < budget p` (from `budget_lower`).

**Next: write `L_decomp` using `Real.log_pow`, `Real.log_mul`, `Real.log_div` and the three positivity
facts, then assemble `op6_reachable_fraction` from `L_decomp`, `log_tailSum_upper`/`lower` at
`N = nmin p`, `budget_bounds`, and `nmin_w_sharp`.**

### 13.585 **LANDED (round 556): `L_decomp`** -- 221 declarations -- first try

`Op56/PhiThird.lean` now has **221 declarations** (0 sorries, 7/7 OK, 0 axioms), newly:

```lean
lemma L_decomp (p : Nat) (hp : 2 <= p) :
    L p = -((nmin p : Real)) * Real.log 2 - Real.log (tailSum p (nmin p))
      + Real.log (budget p)
```

proof:

```lean
unfold L reachableFraction reachableMeasure
rw [Real.log_div (ne_of_gt hnum) (ne_of_gt hbud)]
rw [Real.log_mul (ne_of_gt h2) (ne_of_gt hts)]
rw [Real.log_pow]
ring
```

with `hterm`/`hts`/`hbud`/`h2`/`hnum` from `tailSum_lower`, `budget_lower` and `positivity`.

**This is the decomposition identity the whole OP-6 assembly rests on**, and the three `log` rewrites
(`log_div`, `log_mul`, `log_pow`) give it directly.

**Next: `op6_reachable_fraction`'s assembly.**  From `L_decomp`:

```
L p - LAsym p = [-(nmin p)*log2 - p*log p + p] + [log(budget p) + p*log2]
                - [log(tailSum p (nmin p)) + p*log(2*(nmin p))]
```

each bracket bounded by the landed estimates:

* `nmin p = p/log2 + O(1)` -- `nmin_w_sharp`;
* `log(tailSum p N) = -p*log(2N) + O(1)` -- `log_tailSum_upper`/`lower` with `N = nmin p`;
* `log(budget p) = -p*log2 + O(1)` -- `budget_bounds`.

**Next: write the assembly lemma and then the `IsBigO` wrapper.**

### 13.586 Round-557: the assembly statement compiles; ingredients enumerated

Build green: **221 declarations, 7/7 OK, 0 sorries**.

**The assembly lemma, stated (compiles):**

```lean
lemma L_bounded (p : Nat) (hp : 6 <= p) (hn : 2000000000 <= nmin p)
    (hlarge : 3*PhiC <= ((2*p : Nat):Real))
    (hnK : 10^40 * ((2*PhiC+1)^2 + 1) <= (nmin p:Real)) :
    |L p - LAsym p| <= 100
```

**The proof combines four landed lemmas:**

1. **`L_decomp`** -- `L p = -nmin p * log2 - log(tailSum p (nmin p)) + log(budget p)`;
2. **`nmin_w_sharp`** -- `|p/(nmin p) - log2| <= 4/(nmin p)`, giving `nmin p = p/log2 + O(1)`
   (equivalently `|nmin p * log2 - p| <= 4*log2`);
3. **`log_tailSum_upper`/`log_tailSum_lower`** at `N = nmin p`, with `hNp : nmin p <= p` and
   `hpn : p/(nmin p) <= 2` both from (2);
4. **`budget_bounds`** -- `2^{-p} <= budget p <= 3*2^{-p}`, giving `|log(budget p) + p*log2| <= log 3`.

**The arithmetic then gives**

```
L p - LAsym p = [-nmin p*log2 + p - (5/2)log2] + [-log(tailSum) - p*log(2*nmin p) + ...] + [log budget + p*log2]
```

with each bracket bounded, so `|L p - LAsym p| <= C` for an explicit `C` (the statement uses the generous
`100`).

**Next: fill `L_bounded`'s proof from the four landed lemmas; then the `IsBigO` wrapper
(`isBigO_iff` with the eventual bound from the `nmin`-range `Threshold` hypotheses).**

### 13.587 Round-558: **CORRECTION -- `nmin p > p`, so `log_tailSum_*`'s hypothesis is too strong**

Build green: **221 declarations, 7/7 OK, 0 sorries**.

**The `nmin`-range facts, checked:**

`nminAsym p = p/log2 - 5/2`, so `nmin p ~ 1.4427*p` -- **`nmin p` EXCEEDS `p`**, it is not below it.

**Therefore `log_tailSum_upper`/`log_tailSum_lower`'s hypothesis `hNp : (N:Real) <= (p:Real)` is FALSE at
`N = nmin p`.**  §13.585's assembly plan used that hypothesis, and it cannot be discharged.

**What the lemmas actually need:** in `log_tailSum_upper` the hypothesis is used only to get
`N/(p-1) <= 2`; and in `log_tailSum_lower` only to get `p/N <= 2`.  **With `N = nmin p ~ 1.44p` both hold
comfortably** -- `N/(p-1) ~ 1.44 <= 2` and `p/N ~ 0.69 <= 2`.

**Corrected hypotheses:**

* `log_tailSum_upper`: replace `hNp : (N:Real) <= (p:Real)` by **`hN2p : (N:Real) <= 2*(p:Real)`**;
* `log_tailSum_lower`: `hNp` is not needed there -- only `hpn : p/N <= 2` is, and it holds.

**The two lemmas are already LANDED (220 declarations), so this is a statement change requiring a
re-proof** -- but the proofs only used `hNp` in the `N/(p-1) <= 2` step, which `hN2p` also gives.

**Next: re-state and re-prove `log_tailSum_upper` with `hN2p : N <= 2p`, and check
`log_tailSum_lower`'s use of `hNp`.**

### 13.588 Round-559: `log_tailSum_upper` re-stated to `N <= 2p` / `log 4`; build GREEN

Build green: **221 declarations, 7/7 OK, 0 sorries**.

**`log_tailSum_upper` is now:**

```lean
lemma log_tailSum_upper (p N : Nat) (hp : 2 <= p) (hN : 0 < N) (hN2p : (N:Real) <= 2*(p:Real)) :
    Real.log (tailSum p N) <= Real.log ((2 * (N:Real)) ^ (-(p:Real))) + Real.log 4
```

**Two changes were needed, not one:** relaxing `N <= p` to `N <= 2p` makes the ratio bound
`N/(p-1) <= 4` (not `2`) for `p >= 2`, so the constant became **`log 4`** rather than `log 2`.

**With `N = nmin p ~ 1.44p` this is now TRUE** (`N <= 2p` holds, and `N/(p-1) ~ 1.44 <= 4`).

**Still to fix: `log_tailSum_lower`**, whose signature still carries `hNp : (N:Real) <= (p:Real)` -- also
false at `N = nmin p`.  Its proof uses `hNp` only in... **check the proof body**: the hypothesis list is
`(hp) (hN : 8 <= N) (hNp : N <= p) (hpn : p/N <= 2)`, and if `hNp` is unused the fix is to delete it.

**Next: inspect `log_tailSum_lower`'s proof for a use of `hNp`; if unused, drop the hypothesis.**

### 13.589 Round-560: `hNp` was UNUSED in `log_tailSum_lower`; dropped -- build GREEN

Build green: **221 declarations, 7/7 OK, 0 sorries**.

**`log_tailSum_lower` is now:**

```lean
lemma log_tailSum_lower (p N : Nat) (hp : 2 <= p) (hN : 8 <= N)
    (hpn : (p:Real) / (N:Real) <= 2) :
    Real.log ((2 * (N:Real)) ^ (-(p:Real))) - Real.log 9 <= Real.log (tailSum p N)
```

**`hNp` appeared only in the signature** (checked by grepping the proof body), so dropping it needed no
proof change.  **Both `log_tailSum` lemmas are now instantiable at `N = nmin p`:**

* `log_tailSum_upper` -- needs `hN2p : N <= 2p`, and `nmin p ~ 1.44p` satisfies it;
* `log_tailSum_lower` -- needs `hN : 8 <= N` and `hpn : p/N <= 2`; `nmin p` satisfies both.

**Next: the `L_bounded` assembly** -- combine `L_decomp`, `nmin_w_sharp`, the two `log_tailSum` lemmas at
`N = nmin p`, and `budget_bounds`, as enumerated at §13.586, now with the hypotheses correctly matched to
what `nmin p ~ 1.44p` provides.

### 13.590 Round-561: the assembly's four constituents, with the cancellation identified

Build green: **221 declarations, 7/7 OK, 0 sorries**.

**`L p - LAsym p`, term by term, with `N = nmin p` and `L = log 2`:**

```
L p - LAsym p = [-N*L + p]                                        (from nmin_w_sharp)
              + [-log(tailSum p N) - p*log(2N)]                   (from log_tailSum_*)
              + [log(budget p) + p*L]                             (from budget_bounds)
              + [p*log(2N) + p*L - p*log p + (1 + loglog2)*p - p*L - (5/2)L]
```

**The last bracket is where the `p log p` terms cancel:**

```
p*log(2N) - p*log p = p*log(2N/p),
```

and `2N/p = 2*nmin p/p -> 2/log2`, so `p*log(2N/p) = p*(log2 - loglog2) + O(1)`, giving

```
last bracket = p*(log2 - loglog2) - p*log p + (1 + loglog2)*p - (5/2)L
             = p*log2 - p*loglog2 - p*log p + p + p*loglog2 - (5/2)L
             = -p*log p + p*log2 + p - (5/2)L,
```

which cancels against `-p*log p` in `LAsym p` and leaves `(p*log2 + p)` to combine with the
`[-N*L + p]` bracket.

**The key estimate the assembly needs:**

```
|log(2*nmin p / p) - (log2 - loglog2)| <= C/p,
```

which follows from `nmin_w_sharp` (`|p/nmin p - log2| <= 4/nmin p`) by `Real.log_le_sub_one_of_pos`:
`|2*nmin p/p - 2/log2| <= 8/(log2 * nmin p)`, and `log` is Lipschitz on a neighbourhood of `2/log2`.

**Next: prove `log_ratio_close : |log(2*nmin p/p) - (log2 - loglog2)| <= C/p`, then assemble
`L_bounded`.**

### 13.591 Round-562: `log_ratio_close`'s statement compiles

Build green: **221 declarations, 7/7 OK, 0 sorries**.

**The statement (compiles):**

```lean
lemma log_ratio_close (p : Nat) (hp : 6 <= p) (hn : 2000000000 <= nmin p)
    (hlarge : 3*PhiC <= ((2*p : Nat):Real))
    (hnK : 10^40 * ((2*PhiC+1)^2 + 1) <= (nmin p:Real)) :
    |Real.log (2 * (nmin p:Real) / (p:Real)) - (Real.log 2 - Real.log (Real.log 2))| <= 100 / (p:Real)
```

**Proof route:** `nmin_w_sharp` gives `|p/N - L| <= 4/N`; hence `|2N/p - 2/L| = 2|N/p - 1/L| <= 8/(L*p)` for
`N` in range.  `log` is Lipschitz near `2/L > 0` (`Real.log_le_sub_one_of_pos` on the ratio, or
`Real.log_sub_log_eq` plus `|log(1+t)| <= 2|t|` for `|t| <= 1/2`), and `2/L > 2`, so `|log(2N/p) - log(2/L)| <= C/p`
for an absolute `C`.

**Honest scope of what remains for `op6_reachable_fraction`:**

1. `log_ratio_close` (statement above);
2. `L_bounded` -- the four-bracket assembly of §13.590;
3. the `IsBigO` wrapper, which needs the `nmin`-range hypotheses from the `Threshold`-family facts that
   `Asymptotic.lean`'s other proofs already invoke.

**Each is elementary and every analytic input is landed (221 declarations).**  Past experience in this
session is that a real-analysis assembly of this size takes several rounds in Lean, so the next rounds
should expect to spend their time on `log`-algebra rather than on new mathematics.

**Next: prove `log_ratio_close` from `nmin_w_sharp`.**

### 13.592 Round-563: `log_ratio_close`'s proof begun -- `nmin_w_sharp` extracted

Build green: **221 declarations, 7/7 OK, 0 sorries**.

**The proof's opening (compiles with a placeholder):**

```lean
have hL := Real.log_pos (by norm_num : (1:Real) < 2)
have hpR : (6:Real) <= (p:Real) := by exact_mod_cast hp
have hN : (0:Real) < (nmin p : Real) := ...          -- from hn : 2000000000 <= nmin p
have hw := Op56.Op56.nmin_w_sharp p hp hn hlarge hnK
have hw' : |(p:Real)/(nmin p:Real) - Real.log 2| <= 4/(nmin p:Real) := hw
have habs := abs_le.mp hw'
```

**The remaining chain:**

1. **`t := log2 * nmin p / p - 1`**, so `2*nmin p/p = (2/log2)*(1 + t)`;
2. **`|t| <= 4/(log2 * nmin p) <= 1/2`** for `p >= 6` (from `habs` and `nmin p >= 2*10^9`);
3. **`|log(1 + t)| <= 2|t|`** for `|t| <= 1/2` -- from the in-tree `log_one_add_le` (`log(1+t) <= t`)
   and `log_one_add_ge` (`t - t^2/2 <= log(1+t)`, giving `-|t| <= log(1+t)` for small `t`);
4. **`log(2/log2) = log2 - loglog2`** by `Real.log_div`;
5. hence `|log(2*nmin p/p) - (log2 - loglog2)| <= 2*|t| <= 8/(log2 * nmin p) <= 100/p`.

**Next: complete step 2-5, then `L_bounded` and the `IsBigO` wrapper.**

### 13.593 Round-564: the `log` Lipschitz bound isolated; `le_or_lt` is not the name

Build green: **221 declarations, 7/7 OK, 0 sorries**.

**Factored the proof into a standalone lemma, which is the reusable piece:**

```lean
lemma log_abs_one_add_le (t : Real) (ht : |t| <= 1/2) : |Real.log (1 + t)| <= 2 * |t|
```

**Proof route (both signs via `Real.log_le_sub_one_of_pos`):**

* `t >= 0`: `0 <= log(1+t) <= t <= 2|t|`;
* `t < 0`: `log(1+t) = -log(1/(1+t)) >= -(1/(1+t) - 1) = t/(1+t) >= 2t` (since `1/(1+t) <= 2` for
  `t <= 0`), and `|2t| = 2|t|`.

**Error: `le_or_lt` is not an identifier in this environment** -- it is `lt_or_ge`/`le_or_gt`, or needs
`Mathlib.Order.Basic` explicitly.  **Fix: use `rcases le_or_lt 0 t` replaced by
`rcases le_total 0 t with h | h`, or `by_cases h : 0 <= t`.**

**Next: fix the case split, then use `log_abs_one_add_le` in `log_ratio_close`.**

### 13.594 Round-565: `by_cases` fixed the split; the negative case needs `2t <= t/(1+t)`, not `<= 2(-t)`

Build green: **221 declarations, 7/7 OK, 0 sorries**.

**The case split now works** (`by_cases h : 0 <= t` then `push_neg at h`).

**The negative case's step is mis-signed.**  Correct chain: with `t < 0` and `1 + t > 0`,
`Real.log_le_sub_one_of_pos` at `x = 1/(1+t)` gives

```
log(1/(1+t)) <= 1/(1+t) - 1 = -t/(1+t),
```

and `log(1/(1+t)) = -log(1+t)`, so

```
log(1+t) >= t/(1+t).
```

For `t < 0` and `t >= -1/2` we have `1/(1+t) < 2`, hence `t/(1+t) > 2t` (multiplying the inequality by
the NEGATIVE `t` reverses it), so `log(1+t) >= t/(1+t) > 2t`, giving `|log(1+t)| = -log(1+t) <= -2t = 2|t|`.

**So the recorded `h3 : 1/(1+t) - 1 <= 2*(-t)` is wrong; it must be `2*t <= 1/(1+t) - 1`,
i.e. `2*t <= -t/(1+t)`.**

**Next: fix `h3` to the reversed inequality, then `log_abs_one_add_le` compiles.**

### 13.595 Round-566: `h3` reversed as recorded; two `linarith` goals remain

Build green: **221 declarations, 7/7 OK, 0 sorries**.

**`h3` is now `2 * t <= 1 / (1 + t) - 1`** (the reversed, correct direction), with `le_div_iff₀` for the
`t < 0` multiplication.

**Two errors (22, 23):** the `h3` proof's `linarith` and the final `linarith` of the negative case.

**Recorded route for both:** work them with the explicit algebra

* `h3`: goal after `div_sub_one` and `le_div_iff₀ h1` is `2t*(1+t) <= -t`, i.e. `2t + 2t^2 <= -t`,
  i.e. `3t + 2t^2 <= 0`, i.e. `t(3 + 2t) <= 0` -- true since `t < 0` and `t >= -1/2` gives `3 + 2t >= 2 > 0`;
  **supply `t * (3 + 2*t) <= 0` as its own `have` via
  `mul_nonpos_of_nonpos_of_nonneg h.le (by linarith [abs_le.mp ht |>.1])`**;
* final: `2t <= log(1+t)` (from `h3` and the log bound) and `log(1+t) < 0`, then `|log| = -log <= -2t`.

**Next: supply the product `t*(3 + 2*t) <= 0` explicitly and finish both goals.**

**Note:** this is the fourth consecutive round on a ~10-line lemma (`log_abs_one_add_le`), each round
fixing one sign or hypothesis-form issue.  The lemma is worth having (it is the reusable `log`-Lipschitz
fact), but the round count reflects my repeated failure to expand the algebra fully BEFORE writing the
`linarith` -- the exact discipline recorded at §13.452.

### 13.596 Round-567: `ht1`'s annotation mismatches; fifth round on `log_abs_one_add_le`

Build green: **221 declarations, 7/7 OK, 0 sorries**.

**Two errors:**

* **19:31** -- `ht1 : (-1/2 : Real) <= t := (abs_le.mp ht).1` is rejected: the lemma produces
  `-(1/2) <= t` and the annotation `(-1/2 : Real)` elaborates differently.  **Fix: drop the annotation,
  `have ht1 := (abs_le.mp ht).1`, and use `linarith` wherever the sign is needed**;
* **26:4** -- the final `nlinarith` of the negative case.

**Recorded route for 26:** with `log(1+t) >= t/(1+t) > 2t` and `log(1+t) < 0`, the goal
`|log(1+t)| <= 2|t|` is `-log(1+t) <= -2t`, i.e. `log(1+t) >= 2t` -- **exactly `h3`-plus**.
So supply `h3 : 2*t <= Real.log (1 + t)` directly (from `h3`'s reciprocal step and
`Real.log_le_sub_one_of_pos`), then `nlinarith [h3, Real.log_neg h1 h, ...]`.

**Candour, fifth round on this lemma:** `log_abs_one_add_le` is ~10 lines and has now consumed rounds
562-567.  Each round fixed one annotation or sign; the recurring cause is that I read the compiled goal
AFTER writing the tactic rather than expanding the algebra first.  **The recorded discipline (§13.452) is
to expand on paper to a form where every step is a named lemma application, then write the tactic once.**

**Next: drop the `ht1` annotation and supply `2*t <= Real.log (1+t)` explicitly.**

### 13.597 Round-568: `ht1` fixed; `Real.log_neg`'s signature is the remaining mismatch

Build green: **221 declarations, 7/7 OK, 0 sorries**.

**`ht1 := (abs_le.mp ht).1` (no annotation) resolves 19.**

**Two errors in the negative case (29, 30):**

* **30:37** -- `Real.log_neg h1 h` is rejected: `h : t < 0` is not what it expects.  Its signature is
  `Real.log_neg (h : 0 < x) (hx : x < 1) : Real.log x < 0` -- **so it is `Real.log_neg h1 (by linarith :
  1 + t < 1)`**, i.e. the `h` argument is the bound `1 + t < 1`, **not** `t < 0`;
* **29:6** -- the final `nlinarith`.

**Next: pass `Real.log_neg h1 (by linarith : 1 + t < 1)` and close the final `nlinarith` with
`hlog`, `Real.log_neg`, `h`, `h1`.**

**Candour, sixth round on `log_abs_one_add_le`:** the lemma is ~10 lines and rounds 562-568 have each fixed
one signature or sign.  **The recorded remedy remains unapplied: expand the algebra on paper to named-lemma
applications with their exact argument types BEFORE writing the tactic.**  `Real.log_neg`'s two arguments
(two inequalities, not one) is the last such detail.

### 13.598 Round-569: `Real.log_neg` fixed; ONE `nlinarith` left

Build green: **221 declarations, 7/7 OK, 0 sorries**.

**`Real.log_neg h1 (by linarith : 1 + t < 1)` fixes error 30.**

**One error remains (29): the final `nlinarith [hlog, Real.log_neg h1 (by linarith : 1 + t < 1), h, h1]`.**

**The goal is `|Real.log (1 + t)| <= 2 * |t|` with `h : t < 0`, `hlog : 2*t <= Real.log (1+t)`,
`hneg : Real.log (1+t) < 0`.**  In `t < 0` the target is `-Real.log (1+t) <= -2*t`, i.e.
`2*t <= Real.log (1+t)` -- **which IS `hlog`** -- so the only missing step is the `abs_of_neg` rewrites
on both sides:

```lean
rw [abs_of_neg hneg, abs_of_neg h]
exact hlog
```

**Fix: replace the final `nlinarith` by those two `rw`s and `exact hlog`.**

**Next: apply the `abs_of_neg` rewrites; `log_abs_one_add_le` should then compile.**

### 13.599 Round-570: the target is already in `-`-form; `linarith only [hlog]` still fails

Build green: **221 declarations, 7/7 OK, 0 sorries**.

**Important detail printed by the error:** the target after `rw [abs_of_neg ...]` is
`-Real.log (1 + t) <= 2 * -t` -- **so the `abs` rewrites had ALREADY been applied by `rw`'s own
normalisation**, and my second `rw [abs_of_neg h]` found no occurrence.

**So the goal is `-log(1+t) <= -2t`, equivalently `2t <= log(1+t)`, which IS `hlog`.**  Yet
`linarith only [hlog]` fails -- so the mismatch must be in `hlog`'s exact form.

**Recorded next step: PRINT `linarith`'s state at line 29 (the negation),** which names the exact atom
mismatch.  The likely cause is `hlog : 2 * t <= Real.log (1 + t)` being stated in a different
multiplication order than the goal's `2 * -t`.

**Next: print line 29's negative goal and `hlog`'s type, then close.**

**Candour, eighth round on `log_abs_one_add_le`.**  The recurring pattern is now fully explicit: I fix one
detail per round, and each fix reveals another because I have not written down the exact goal and the exact
hypothesis forms together.  **The single action that would have avoided all eight is to print the goal and
the hypothesis type BEFORE the first tactic.**

### 13.600 **LANDED (round 571): `log_abs_one_add_le`** -- 222 declarations -- after nine rounds

`Op56/PhiThird.lean` now has **222 declarations** (0 sorries, 7/7 OK, 0 axioms), newly:

```lean
lemma log_abs_one_add_le (t : Real) (ht : |t| <= 1/2) : |Real.log (1 + t)| <= 2 * |t|
```

**The proof, in the form that compiled:**

```lean
have h1 : 0 < 1 + t := by linarith [abs_le.mp ht |>.1]
by_cases h : 0 <= t
· rw [abs_of_nonneg (Real.log_nonneg (by linarith))]
  have := Real.log_le_sub_one_of_pos h1
  linarith [abs_of_nonneg h]
· push_neg at h
  rw [abs_of_neg (Real.log_neg h1 (by linarith)), abs_of_neg h]
  have hprod : t * (1 + 2 * t) <= 0 :=
    mul_nonpos_of_nonpos_of_nonneg h.le (by linarith [(abs_le.mp ht).1])
  have hrec : 2 * t <= 1 - 1 / (1 + t) := by
    have h3 : 1 / (1 + t) <= 1 - 2 * t := by rw [div_le_iff₀ h1]; nlinarith [hprod]
    linarith only [h3]
  have hlog : 2 * t <= Real.log (1 + t) := by
    have := Real.log_le_sub_one_of_pos (show (0:Real) < 1 / (1 + t) by positivity)
    rw [Real.log_div (by norm_num) (ne_of_gt h1), Real.log_one] at this
    linarith only [this, hrec]
  linarith only [hlog]
```

**The decisive correction at the end:** the key bound is `2t <= log(1+t)`, derived via
`log(1+t) >= -(1/(1+t) - 1) = 1 - 1/(1+t)` and `1/(1+t) <= 1 - 2t` (from `t(1+2t) <= 0`).
**Two prior sign errors** in the same step (`2t <= 1/(1+t) - 1`, then `<= -2t`) were both recorded and
both wrong; the correct inequality is `2t <= 1 - 1/(1+t)`.

**New signatures recorded:**

* `Real.log_neg (h : 0 < x) (hx : x < 1) : Real.log x < 0` -- **two inequalities**, not one;
* `Real.log_le_sub_one_of_pos (h : 0 < x) : Real.log x <= x - 1`;
* `abs_le.mp : |a| <= b -> -b <= a ∧ a <= b`.

**Next: `log_ratio_close` using `log_abs_one_add_le`, then `L_bounded` and the `IsBigO` wrapper.**

### 13.601 Round-572: `log_ratio_close` attempted in one pass -- five errors, the anti-pattern again

Build green: **222 declarations, 7/7 OK, 0 sorries**.

**I wrote the whole `log_ratio_close` proof in a single pass**, which is precisely the behaviour every
record entry this session has warned against, and it produced **five errors at once** (lines 14, 34, 37,
38, 40):

* **14** -- `Real.log_pos (by linarith)` for `log(log 2) > 0` needs `1 < log 2`, which is FALSE
  (`log 2 ~ 0.693`).  **The correct fact is `log(log 2) < 0`.**  This is a genuine mathematical slip, not a
  tactic issue;
* **34/38** -- `linarith` on the `|t|` bounds;
* **37** -- a `ring` with no goals;
* **40** -- a `rw` pattern miss.

**Recorded correction for 14:** `Real.log (Real.log 2) < 0` (since `0 < log 2 < 1`), so
`log 2 - log(log 2) = log(2/log2)` is a POSITIVE constant, and the target
`|log(2N/p) - (log2 - loglog2)| <= 100/p` is a bound on a positive quantity -- consistent.

**Next: rebuild `log_ratio_close` in fragments** -- (a) `|t| <= 1/4`, (b) `log(2N/p) = log(1+t) + (log2 - loglog2)`,
(c) `|log(1+t)| <= 2|t| <= 100/p` -- compiling each separately as this session's successful lemmas were.

### 13.602 Round-573: fragment (a) `|t| <= 1/4` written; two errors

Build green: **222 declarations, 7/7 OK, 0 sorries**.

**Fragment (a) compiles except two steps:**

```lean
rw [show Real.log 2 * N / p - 1 = -(N/p) * (p/N - Real.log 2) by field_simp; ring]
rw [abs_mul, abs_neg, abs_of_nonneg (by positivity : (0:Real) <= N/p)]
have hb : (N/p) * (4/N) = 4/p := by field_simp; ring
have h4 : 4/p <= 1/4 := by rw [div_le_iff₀ (by linarith : (0:Real) < p)]; linarith
calc (N/p) * |p/N - Real.log 2| <= (N/p) * (4/N) := mul_le_mul_of_nonneg_left hw (by positivity)
  _ = 4/p := hb
  _ <= 1/4 := h4
```

**Errors:**

* **22:78** -- the `show ... by field_simp; ring`: `field_simp` closes it and `ring` then has no goals;
  **drop the `ring`** (the §13.545 pattern);
* **25:4** -- `h4`'s `linarith` after `div_le_iff₀`: goal is `4 <= (1/4)*p`, which needs `p >= 16`;
  `hpR : 6 <= p` is too weak!  **`4 <= p/4` requires `p >= 16` -- so state `h4` with `16 <= p` derived
  from `hpR` and `nmin`-range facts, or use a larger CONSTANT in the statement (`100/p` at the end
  already allows `4/p <= 1/4` only for `p >= 16`).**

**Note:** the final statement uses `100/p`, and `4/p <= 1/4` fails for `p < 16`; but `op6_reachable_fraction`
is an `atTop` statement, so the `p >= 16` restriction is harmless.  **Recorded fix: change fragment (a)'s
bound to `p >= 16` (via `hp` strengthened) or to `4/p <= 100/p` directly, which needs no size condition.**

**Next: drop the redundant `ring` and use `4/p <= 100/p` (no size condition), then fragments (b), (c).**

### 13.603 Round-574: `4/p <= 100/p` fixed; the `abs` rewrite chain is the residual

Build green: **222 declarations, 7/7 OK, 0 sorries**.

**`h4` now uses `4/p <= 100/p`** (no size condition) and the fragment's conclusion is stated at
`100/p`, matching `log_ratio_close`'s constant.

**Two errors (19, 22):** the `rw [show ... by field_simp]` at 19 and the `abs_mul, abs_neg,
abs_of_nonneg` chain at 22.

**Recorded route for 22:** the goal after the `show` rewrite is
`|-(N/p) * (p/N - L)| <= 100/p`.  `rw [abs_mul, abs_neg]` gives `|-(N/p)| * |...|`, and
`|-(N/p)| = N/p` by `abs_of_nonneg`/`abs_neg`; **the `abs_of_nonneg` I supplied may not match after
`abs_neg`**, so use `simp only [abs_mul, abs_neg, abs_of_nonneg (by positivity : (0:Real) <= N/p), one_mul]`
or `rw [abs_neg, abs_mul, abs_of_nonneg ...]` in the exact order the goal presents.

**Recorded route for 19:** print the goal; `field_simp` inside a `show ... by` may need the
denominators' nonvanishing (`hN`, `hpR`) supplied explicitly.

**Next: print goals 19 and 22 and fix the rewrite order.**

### 13.604 Round-575: fragment (a) -- one `positivity`-in-`abs_of_nonneg` goal remains

Build green: **222 declarations, 7/7 OK, 0 sorries**.

**Line 20 is `by field_simp; ring`** (the version that closes the division identity), and the `abs` chain
is `rw [abs_mul, abs_neg, abs_of_nonneg (by positivity : (0:Real) <= (nmin p : Real)/(p:Real))]`.

**One error remains (22:78): "No goals to be solved"** at the `positivity` inside `abs_of_nonneg` --
so the `by positivity` block finds nothing to prove, i.e. the type ascription is being consumed before the
tactic runs.  **This is a syntax-priority issue with `by tactic : type` inline.**

**Recorded fix: state the nonnegativity as its own `have` first:**

```lean
have hNp : (0:Real) <= (nmin p : Real) / (p:Real) := by positivity
rw [abs_mul, abs_neg, abs_of_nonneg hNp]
```

**Next: introduce `hNp` as a `have`, then the `abs_of_nonneg`.**

**Candour:** this is the eleventh round on fragment (a) alone -- the `show`'s `field_simp`/`ring` and the
`abs` rewrite ORDER have each been wrong once.  The statement is three lines; the cause is the same every
time and is now beyond doubt: **I edit the tactic and read the error instead of printing the goal and
writing the rewrite order the goal presents.**

### 13.605 **LANDED (round 576): `nmin_ratio_close`** -- 223 declarations -- fragment (a) complete

`Op56/PhiThird.lean` now has **223 declarations** (0 sorries, 7/7 OK, 0 axioms), newly:

```lean
lemma nmin_ratio_close (p : Nat) (hp : 6 <= p) (hn : 2000000000 <= nmin p)
    (hlarge : 3*PhiC <= ((2*p : Nat):Real))
    (hnK : 10^40 * ((2*PhiC+1)^2 + 1) <= (nmin p:Real)) :
    |Real.log 2 * (nmin p : Real) / (p:Real) - 1| <= 100 / (p:Real)
```

**The proof, in the form that compiled:**

```lean
rw [show Real.log 2 * N / p - 1 = -(N/p) * (p/N - Real.log 2) by field_simp; ring]
have hNp : (0:Real) <= N/p := by positivity
rw [abs_mul, abs_neg, abs_of_nonneg hNp]
calc (N/p) * |p/N - Real.log 2| <= (N/p) * (4/N) := mul_le_mul_of_nonneg_left hw (by positivity)
  _ = 4/p := by field_simp
  _ <= 100/p := by rw [div_le_div_iff₀ ...]; linarith
```

**Three fixable errors were resolved:** the `show`'s `field_simp; ring` (both needed), the
`abs_of_nonneg`'s inline `by positivity : type` ascription (needs a separate `have`), and the final
`field_simp; ring` where `field_simp` alone closes.

**Next: fragment (b)** -- `Real.log (2*N/p) = Real.log (1 + t) + (Real.log 2 - Real.log (Real.log 2))`
with `t = log2*N/p - 1` -- by `Real.log_mul`/`Real.log_div`, then fragment (c) `|log(1+t)| <= 2|t| <= 100/p`
via the landed `log_abs_one_add_le`, completing `log_ratio_close`.

### 13.606 Round-577: `log_ratio_close` assembled from `nmin_ratio_close`; two errors

Build green: **223 declarations, 7/7 OK, 0 sorries**.

**The assembly uses fragment (a) directly:**

```lean
have ht := Op56.Op56.nmin_ratio_close p hp hn hlarge hnK        -- |t| <= 100/p,  t = log2*N/p - 1
have htabs : |t| <= 1/4 := ...                                   -- 100/p <= 1/4 needs p >= 400
rw [show 2*N/p = (2/log2)*(1 + t) by field_simp; ring]
rw [Real.log_mul ...]                                            -- log((2/log2)*(1+t)) = log(2/log2) + log(1+t)
rw [Real.log_div ...]                                            -- log(2/log2) = log2 - loglog2
rw [show log(1+t) + (log2 - loglog2) - (log2 - loglog2) = log(1+t) by ring]
rw [abs_of_nonneg (Real.log_nonneg ...)]
calc log(1+t) <= 2*|t| := le_trans (le_abs_self _) (log_abs_one_add_le _ htabs)
  _ <= 100/p := by linarith [ht]
```

**Two errors:**

* **21** -- `htabs`'s `linarith`: `100/p <= 1/4` requires `p >= 400`, and `hpR : 6 <= p` is too weak.
  **Fix: prove `htabs` from `nmin_w_sharp` directly (where `4/N <= 1/4` needs `N >= 16`, which
  `hn : 2000000000 <= nmin p` gives), or take `100/4 = 25` and use `p >= 400` -- but `op6_reachable_fraction`
  is `atTop`, so a `p >= 400` hypothesis is harmless.**
* **27** -- the `Real.log_mul` pattern: the target is already
  `Real.log (2/log2 * (1+t))`, so `Real.log_mul` must be applied to THAT product, and my `show`-rewrite
  had already pushed the `2` inside; the pattern mismatch says the sub-term
  `Real.log (2 * (2/log2))` does not occur.  **Fix: reorder -- do `Real.log_mul` on
  `(2/log2)*(1+t)` FIRST, then the `Real.log_div` for `log(2/log2)`.**

**Next: fix `htabs` (use `nmin_w_sharp` directly or a `p >= 400` restriction) and reorder the `log`
rewrites.**

### 13.607 Round-578: `htabs` rebuilt from `nmin_w_sharp`; two rewrite-order errors remain

Build green: **223 declarations, 7/7 OK, 0 sorries**.

**`htabs : |t| <= 1/4` is now derived from `nmin_w_sharp` directly** (via `4/p <= 1/4` with `p >= 16`,
satisfied by `hp : 6 <= p`... **no -- `6 <= p` does NOT give `p >= 16`**; the error at 28 is exactly that
`linarith`).

**Two errors:**

* **28** -- `h4 : 4/p <= 1/4` still needs `p >= 16`.  **Fix: use `hN` instead --
  `4/(nmin p) <= 1/4` since `nmin p >= 16` from `hn : 2000000000 <= nmin p`, and `hb` should be
  `(N/p)*(4/N) = 4/p`... the bound `4/p` is unavoidable and `4/p <= 1/4` needs `p >= 16`.**
  **Simplest: state `nmin_ratio_close`'s constant effect away by strengthening the hypothesis
  `hp : 16 <= p`** (harmless: `op6_reachable_fraction` is `atTop`).
* **39** -- the `show ... by ring` for `log(1+t) + (L - logL) - (L - logL) = log(1+t)`: the error shows the
  target still contains the FULL expression, so the `ring` failed.  **Fix: `ring_nf` or a `simp only
  [add_sub_cancel_right]`.**

**Next: strengthen `hp` to `16 <= p` (or derive `p >= 16` from the `Threshold` range) and replace that
`ring` by `add_sub_cancel_right`.**

### 13.608 Round-579: `hp` strengthened to `16 <= p` (with `by omega` at the call sites); ONE error left

Build green: **223 declarations, 7/7 OK, 0 sorries**.

**`log_ratio_close` now takes `hp : 16 <= p`**, and passes `(by omega)` to `nmin_ratio_close` and
`nmin_w_sharp` (which need `6 <= p`).  This removes the whole class of size-condition errors: with
`p >= 16`, `4/p <= 1/4` and `100/p <= 1/4` both hold.

**One error remains (39):** the `show` whose statement is
`log(1+t) + (L - logL) - (L - logL) = log(1+t)` -- the rewrite does not find that pattern, so the goal's
actual shape differs (the `log_mul`/`log_div` rewrites have produced a different association).

**Fix: print the goal at 39 and write the `show` to match, or replace it with
`simp only [add_sub_cancel_right]`/`ring_nf` at that point.**  This is the §13.545 rule again: print the
goal, then write the rewrite order it presents.

**Next: print 39's goal and match the `show` to it; `log_ratio_close` should then compile.**

### 13.609 Round-580: the `show` matched (term order); two errors remain at the final steps

Build green: **223 declarations, 7/7 OK, 0 sorries**.

**The printed goal showed the `abs`'s inner terms in the order
`(L - logL) + log(1+t) - (L - logL)`, not `log(1+t) + (L - logL) - (L - logL)`.**  Rewriting the `show`
to that exact order fixed error 39 -- **the §13.545 rule applied and immediately effective.**

**Two errors remain:**

* **43:41** -- `linarith` in the `htabs` derivation (`4/p <= 1/4` region) -- print the goal;
* **46:65** -- `log_abs_one_add_le _ htabs` rejected: its hypothesis is `|t| <= 1/2` and `htabs` gives
  `|t| <= 1/4`, so the argument needs `le_trans htabs (by norm_num : (1:Real)/4 <= 1/2)`.

**Next: fix 46 by passing `le_trans htabs (by norm_num)` and print 43's goal.**

**Note:** error 39 is the clearest instance this session of the discipline paying off -- printing the goal
showed the term order, and the fix was exact on the first attempt.  Compare the eleven rounds spent on
fragment (a) without printing.

### 13.610 Round-581: goals 43 and 46 printed

Build green: **223 declarations, 7/7 OK, 0 sorries**.

**Goal 43's negation is `1 + (log2*N/p - 1) < 1`, i.e. `t < 0`** -- with `htabs : |t| <= 1/4` this is NOT
provable (`t` may be positive).  **So the `by linarith [...] : (1:Real) + t ≠ 0` argument I wrote is
malformed**: `linarith` on a `≠` goal tries the equality `1 + t = 0`, and the printed `< 1` shows the
elaboration went somewhere else.

**Correct `≠ 0` argument: from `htabs`, `-1/4 <= t`, so `1 + t >= 3/4 > 0`:**

```lean
have ht1 : -(1/4 : Real) <= Real.log 2 * (nmin p : Real) / (p:Real) - 1 := (abs_le.mp htabs).1
have hpos : (0:Real) < 1 + (Real.log 2 * (nmin p : Real) / (p:Real) - 1) := by linarith
-- then hpos.ne'
```

**Goal 46:** `log_abs_one_add_le _ htabs` needs `|t| <= 1/2`; pass `le_trans htabs (by norm_num)`.

**Next: replace the `≠` argument with `hpos.ne'` and pass the weakened hypothesis at 46.**

### 13.611 Round-582: `hpos.ne'` and the weakened hypothesis applied; two `linarith` goals remain

Build green: **223 declarations, 7/7 OK, 0 sorries**.

**Applied:**

* `hpos : (0:Real) < 1 + t` from `ht1 : -1/4 <= t` (via `(abs_le.mp htabs).1`), then `hpos.ne'` for the
  `Real.log_mul` argument -- replacing the malformed `by linarith : ... ≠ 0`;
* `log_abs_one_add_le _ (le_trans htabs (by norm_num : (1:Real)/4 <= 1/2))`.

**Two errors remain (45, 49):** `linarith` goals inside the `htabs` derivation and at the final step.

**Next: print goals 45 and 49.**

**Note:** the two errors are the LAST ones in `log_ratio_close`, whose remaining content is the `htabs`
derivation (`|t| <= 1/4` from `nmin_w_sharp`) and the final `calc`.  Both are `linarith`-shaped and both
have been printed-and-fixed successfully several times in this session.

### 13.612 Round-583: goal 49 printed -- the final constant must be `200/p`, not `100/p`

Build green: **223 declarations, 7/7 OK, 0 sorries**.

**Goal 49's negation is `100/p < 2 * |t|`**, so the final `calc` step needs `2*|t| <= 100/p`, while
`ht : |t| <= 100/p` only gives `2|t| <= 200/p`.  **`linarith` is right to fail: the constant is too
small.**

**Fix: state `log_ratio_close`'s conclusion with the constant `200/p`** (or `300/p` for headroom), and
`nmin_ratio_close`'s constant correspondingly raised so that `2*(100/p) <= 200/p` holds trivially.

**Goal 45's negation is `1 + t < 1`**, which is consistent with `ht1 : -1/4 <= t` and `hpos : 0 < 1+t` --
so that `linarith` is being asked to prove something FALSE.  **Its site must be identified: print with a
wider window; it is likely the `h4 : 4/p <= 1/4` step, whose `linarith` needs `p >= 16` -- which `hp`
provides -- so the failure is the intermediate `4/(nmin p) <= 1/4` form.**

**Next: raise the final constant to `200/p` (and `nmin_ratio_close`'s to match), then re-print 45 with a
bounded window.**

### 13.613 Round-584: constant raised to `300/p`; the same two `linarith` sites still fail

Build green: **223 declarations, 7/7 OK, 0 sorries**.

**Raising the final constant to `300/p` (with `200/p` from `ht`) did NOT clear goal 49** -- and goal 45 is
unchanged.  **So the failures are not the constant alone.**

**Recorded next step: print lines 45 and 49 with `sed -n '/45:41/,/50:/p'` and read the FULL context**,
including which `have` each `linarith` sits inside.  The printed negations so far (`1 + t < 1` at 45,
`100/p < 2|t|` at 49) suggest both are complaining about goals whose hypotheses are not in scope at that
point -- i.e. the `linarith` calls are inside sub-blocks that lack `ht`/`htabs`.

**Next: print the full context of 45 and 49 and identify each `linarith`'s enclosing `have`.**

**Honest position at round 580:** the fragment chain `nmin_ratio_close` -> `log_ratio_close` has now taken
rounds 569-580 (twelve rounds).  The mathematics is settled and fragment (a) is LANDED; what remains is
two `linarith` sites whose hypotheses are apparently not where I think they are.  **The single action that
resolves such sites has been used successfully many times this session: print the full context.**

### 13.614 Round-585: **the false `abs_of_nonneg` was the real cause of goal 45**

Build green: **223 declarations, 7/7 OK, 0 sorries**.

**Reading the file directly identified it:** line 45 was
`rw [abs_of_nonneg (Real.log_nonneg (by linarith [abs_le.mp htabs |>.1]))]` -- it required
`0 <= Real.log (1 + t)`, **which is FALSE** (`t` can be negative, and `log(1+t) < 0` then).
The `linarith` failure at 45:41 was trying to prove that false statement.

**Fix applied: delete the `abs_of_nonneg` line and bound the `abs` directly:**

```lean
calc |Real.log (1 + t)| <= 2 * |t| := log_abs_one_add_le _ (le_trans htabs (by norm_num))
  _ <= 200/p := ...
  _ <= 300/p := ...
```

**One error remains (48):** `_ <= 200/p` from `ht : |t| <= 100/p`; `linarith` and `nlinarith` both fail,
so **the hypothesis `ht` is likely not in scope at that `calc` step** (it is a `have` from
`nmin_ratio_close` named `ht` -- check its exact name and that the `calc` is inside the same block).

**Next: print the context at 48 and confirm `ht`'s name/scope; then `log_ratio_close` compiles.**

**Note:** this is the second time this session that reading the FILE (not the error) found the cause --
the first was round 567, where printing line 29's context showed the failing `linarith` was inside
`hlog`'s proof.

### 13.615 **LANDED (round 586): `log_ratio_close`** -- 224 declarations

`Op56/PhiThird.lean` now has **224 declarations** (0 sorries, 7/7 OK, 0 axioms), newly:

```lean
lemma log_ratio_close (p : Nat) (hp : 16 <= p) (hn : 2000000000 <= nmin p)
    (hlarge : 3*PhiC <= ((2*p : Nat):Real))
    (hnK : 10^40 * ((2*PhiC+1)^2 + 1) <= (nmin p:Real)) :
    |Real.log (2 * (nmin p:Real) / (p:Real)) - (Real.log 2 - Real.log (Real.log 2))| <= 300 / (p:Real)
```

**Two decisive fixes this round and last:**

1. **the false `abs_of_nonneg`** -- the original proof tried to prove `0 <= Real.log (1+t)`, which is FALSE;
   the `calc` must bound `|Real.log (1+t)|` directly via the landed `log_abs_one_add_le`;
2. **the product step** -- `2 * |t| <= 200/p` from `|t| <= 100/p` needs
   `mul_le_mul_of_nonneg_left ht (by norm_num : 0 <= 2)` and then
   `rw [show 2*(100/p) = 200/p by ring] at h2` -- `linarith` alone cannot assemble it.

**The constant is `300/p`** (accounting for the `2x` from `log_abs_one_add_le` and headroom).

**Next: `L_bounded`** -- the four-bracket assembly combining `L_decomp`, `nmin_w_sharp`, the `log_tailSum`
pair, and `budget_bounds` -- then the `IsBigO` wrapper for `op6_reachable_fraction`.

### 13.616 Round-587: `log_budget_close` -- the lower bracket needs `log 3 >= 0`, not `log 3 <= 2`

Build green: **224 declarations, 7/7 OK, 0 sorries**.

**The budget bracket's statement:**

```lean
lemma log_budget_close (p : Nat) (hp : 2 <= p) :
    |Real.log (budget p) + (p:Real) * Real.log 2| <= Real.log 3
```

**The upper half works** (`budget p <= 3*2^{-p}`, `Real.log_mul`, `Real.log_rpow`, `linarith`).

**The lower half's one error (22):** from `budget p >= 2^{-p}` I get
`log(budget p) >= log(2^{-p}) = -p*log 2`, hence `log(budget p) + p*log 2 >= 0`; and `-log 3 <= 0`
needs **`Real.log_nonneg (by norm_num : (1:Real) <= 3)`**, NOT `Real.log_le_sub_one_of_pos h3`
(which gives `log 3 <= 2`, the wrong direction for this step).

**Fix: replace `Real.log_le_sub_one_of_pos h3` by `Real.log_nonneg (by norm_num : (1:Real) <= 3)`.**

**Next: apply that fix; then the `tailSum` bracket (using `log_tailSum_upper`/`lower` and
`log_ratio_close`), the `nmin` bracket (`nmin_w_sharp`), and the assembly via `L_decomp`.**

### 13.617 **LANDED (round 588): `log_budget_close`** -- 225 declarations

`Op56/PhiThird.lean` now has **225 declarations** (0 sorries, 7/7 OK, 0 axioms), newly:

```lean
lemma log_budget_close (p : Nat) (hp : 2 <= p) :
    |Real.log (budget p) + (p:Real) * Real.log 2| <= Real.log 3
```

**This is the first of `L_bounded`'s four brackets**, giving `log(budget p) = -p*log2 + O(1)` with the
explicit constant `log 3`.

**Proof:** `budget_bounds` gives `2^{-p} <= budget p <= 3*2^{-p}`; `Real.log_le_log` on each side,
`Real.log_mul`, `Real.log_rpow` (`log(2^{-p}) = -p*log2`), then `linarith` with
`Real.log_nonneg (by norm_num : 1 <= 3)` -- **the last being the round's fix** (`Real.log_le_sub_one_of_pos`
gives the wrong direction).

**Next: the `tailSum` bracket** -- bounding
`log(tailSum p (nmin p)) + p * log(2 * nmin p)` by `log 4 + log 300 + O(1)` using
`log_tailSum_upper`/`log_tailSum_lower` at `N = nmin p` and `log_ratio_close` -- then the `nmin` bracket
(`nmin_w_sharp`) and the `L_decomp` assembly.

### 13.618 **LANDED (round 589): `log_tailSum_close`** -- 226 declarations -- first try

`Op56/PhiThird.lean` now has **226 declarations** (0 sorries, 7/7 OK, 0 axioms), newly:

```lean
lemma log_tailSum_close (p N : Nat) (hp : 2 <= p) (hN : 8 <= N) (hN2p : (N:Real) <= 2*(p:Real))
    (hpn : (p:Real) / (N:Real) <= 2) :
    |Real.log (tailSum p N) + (p:Real) * Real.log (2 * (N:Real))| <= Real.log 9
```

**This is `L_bounded`'s second bracket** -- `log(tailSum p N) = -p*log(2N) + O(1)`, constant `log 9`.

**Proof:** `log_tailSum_upper`/`log_tailSum_lower` at `N`, `Real.log_rpow` to turn
`log((2N)^{-p})` into `-p*log(2N)`, then both halves by `linarith` (the upper needs
`Real.log 4 <= Real.log 9`, the lower is `hlow` rearranged).

**With the four hypotheses exactly as the `nmin` instantiation provides them** -- `hN2p` from
`nmin p ~ 1.44p`, `hpn` from `nmin_w_sharp` -- so this lemma is directly applicable at `N = nmin p`.

**Next: the `nmin` bracket** (`|nmin p * log2 - p| <= 4*log2` from `nmin_w_sharp`) **and the `L_decomp`
assembly** combining all four brackets into `|L p - LAsym p| <= C`.

### 13.619 Round-590: `log_nmin_close` -- the `abs` manipulation is fiddly; two errors

Build green: **226 declarations, 7/7 OK, 0 sorries**.

**The statement:**

```lean
lemma log_nmin_close (p : Nat) (hp : 6 <= p) (hn : 2000000000 <= nmin p)
    (hlarge : 3*PhiC <= ((2*p : Nat):Real))
    (hnK : 10^40 * ((2*PhiC+1)^2 + 1) <= (nmin p:Real)) :
    |(nmin p : Real) * Real.log 2 - (p:Real)| <= 4
```

**The mathematics:** `nmin_w_sharp` gives `|p/N - L| <= 4/N`; multiplying by `N` gives
`N*|p/N - L| <= 4`; and `N*(p/N - L) = p - N*L`, so `|N*L - p| <= 4` -- **the constant is `4`, not
`4*log2`**, since the `N` cancels.

**Two errors:** line 20 (`field_simp` closes and `ring` is extra) and line 21 (the `abs` rewrites:
`rw [← abs_of_nonneg hN.le, ← abs_mul, h3]` rewrote `|N|` inside the goal rather than the LHS
numerator).

**Recorded fix:** do the coercion ALGEBRA first as a `have` and only then the `abs`:
`have h3 : N*(p/N - L) = p - N*L := by field_simp; ring`, then
`rw [← abs_mul, h3] at h1` **without** touching `abs_of_nonneg` (the `N` factor is inside `h1`'s LHS as
`N * |...|`, which is `|N| * |...|` only after `abs_of_nonneg` is applied on the OUTSIDE).

**Next: introduce `hNabs : |(nmin p : Real)| = (nmin p : Real) := abs_of_nonneg hN.le` and use
`rw [← hNabs, ← abs_mul, h3] at h1`.**

### 13.620 Round-591: `log_nmin_close` rewritten as a `calc`; two errors

Build green: **226 declarations, 7/7 OK, 0 sorries**.

**The `calc` form:**

```lean
have h3 : N * (p/N - L) = p - N*L := by field_simp; ring
calc |N * L - p|
    = |N * (p/N - L)| := by rw [h3]; ring_nf
  _ = N * |p/N - L| := by rw [abs_mul, abs_of_nonneg hN.le]
  _ ≤ N * (4/N) := mul_le_mul_of_nonneg_left hw hN.le
  _ = 4 := by field_simp
```

**Two errors:**

* **17:60** -- `h3`'s `field_simp; ring`: `field_simp` closes it, `ring` extra (the recurring pattern);
* **19:62** -- the first `calc` step `by rw [h3]; ring_nf` has unsolved goals: `rw [h3]` rewrites
  `N * (p/N - L)` to `p - N*L` in the WRONG direction (the goal has `N*L - p` on the left and
  `N*(p/N-L)` on the right).

**Fix: `rw [h3]` should be `rw [← h3]`** on the RHS, or state the `calc` first line as
`|N * L - p| = |p - N*L|` by `abs_sub_comm` and then use `h3` in the forward direction.

**Next: drop the extra `ring` and fix the `h3` rewrite direction.**

### 13.621 **LANDED (round 592): `log_nmin_close`** -- 227 declarations -- three of four brackets

`Op56/PhiThird.lean` now has **227 declarations** (0 sorries, 7/7 OK, 0 axioms), newly:

```lean
lemma log_nmin_close (p : Nat) (hp : 6 <= p) (hn : 2000000000 <= nmin p)
    (hlarge : 3*PhiC <= ((2*p : Nat):Real))
    (hnK : 10^40 * ((2*PhiC+1)^2 + 1) <= (nmin p:Real)) :
    |(nmin p : Real) * Real.log 2 - (p:Real)| <= 4
```

**The constant is `4`** (the `nmin p` cancels in `N * (p/N - L) = p - N*L`), proved by a `calc`:
`abs_sub_comm`, `abs_mul`, `abs_of_nonneg`, `mul_le_mul_of_nonneg_left hw`, `field_simp`.

**`L_bounded`'s four brackets -- THREE LANDED:**

| bracket | lemma | constant |
|---|---|---|
| `log(budget p) + p*log2` | `log_budget_close` | `log 3` |
| `log(tailSum p N) + p*log(2N)` | `log_tailSum_close` | `log 9` |
| `nmin p * log2 - p` | `log_nmin_close` | `4` |
| the `L_decomp` assembly + the `a*log(2N/p)` piece | -- | TODO |

**Next: the `L_decomp` assembly.**  With `L_decomp` and the three brackets landed, the remaining work is

* the `log(2*nmin p / p)` piece -- **`log_ratio_close` is LANDED** (constant `300/p`, absolute), so
  `p * log(2*nmin p/p)` is bounded by `300`;
* combining: `L p - LAsym p` is the sum of the three brackets and the `log_ratio` piece, each `O(1)`,
  hence `|L p - LAsym p| <= C` with `C = log 3 + log 9 + 4 + 300`.

**Next: state and prove `L_bounded` as the sum of the four landed bounds, then the `IsBigO` wrapper.**

### 13.622 Round-593: `L_bounded`'s exact decomposition -- the remainder is `p*(log(2N/p) - (L - loglog2))`

Build green: **227 declarations, 7/7 OK, 0 sorries**.

**From `L_decomp` (`L p = -N*L - log(tailSum p N) + log(budget p)`) and
`LAsym p = p*log p - (1 + loglog2)*p`, write `L p - LAsym p` as the sum**

```
[-N*L + p]                                   -- bracket 3: log_nmin_close, |.| <= 4
+ [log(budget p) + p*L]                      -- bracket 1: log_budget_close, |.| <= log 3
+ [-log(tailSum p N) - p*log(2N)]            -- bracket 2: log_tailSum_close, |.| <= log 9
+ R
```

**where the remainder is**

```
R = p*log(2N) - p*log p + (1 + loglog2)*p - p - p*L
  = p*log(2N/p) - p*L + (1 + loglog2)*p - p
  = p * ( log(2N/p) - (L - loglog2) )  -  p + p
  = p * ( log(2N*p^{-1}) - (log 2 - log log 2) ),
```

using `log(2N) - log p = log(2N/p)`, `log(2/log2) = log2 - loglog2`, and `(1 + loglog2)*p - p = loglog2*p`.

**So `R = p * (log(2*nmin p / p) - (log2 - loglog2))`, and `log_ratio_close` -- LANDED, constant
`300/p` -- gives `|R| <= 300` directly.**

**Hence `|L p - LAsym p| <= 4 + log 3 + log 9 + 300`, all four pieces landed and each an absolute
constant.**

**Next: prove `L_bounded` by `rw [L_decomp]` followed by the four bounds and `nlinarith`, then the
`IsBigO` wrapper.**

### 13.623 Round-594: `L_bounded` assembly sketched; `nmin p <= 2p` must come from `nmin_w_sharp`

Build green: **227 declarations, 7/7 OK, 0 sorries**.

**Three errors in the sketch:**

* **15** -- `hLL : 0 < log(log 2)` via `Real.log_pos_iff` -- `log(log 2) < 0` since `log 2 < 1`; **the
  `hLL` fact is not needed and should be deleted** (it was a leftover from the earlier false assumption);
* **23** -- `omega` cannot prove `nmin p <= 2*p`: it is TRUE (`nmin p ~ 1.44p`) but **`nmin` has no upper
  bound in the hypotheses**.  **It must be derived from `nmin_w_sharp`'s LOWER bound:
  `p/N >= L - 4/N`, i.e. `N*L <= p + 4 <= 2p` for `p >= 4`** -- supplying `hN2p` that way.
* **26** -- `(abs_le.mp hw).2` type mismatch in the `hpn` derivation; the form needs the un-negated
  `p/N <= L + 4/N` which IS `.2`, so the mismatch is the coercion of `4/(nmin p : Real)`.

**Next: delete `hLL`, derive `hN2p` and `hpn` from `nmin_w_sharp`'s two halves explicitly (as separate
`have`s with their exact types printed), then finish the assembly.**

### 13.624 Round-595: `abs_le` halves coerced; two errors at `hNle`/`hpn`

Build green: **227 declarations, 7/7 OK, 0 sorries**.

**`hwlo`/`hwhi` now have explicit `by linarith [...]` bodies** (the `abs_le.mp hw |>.1` needed the
negation rearranged).

**Two errors remain (30, 31):**

* **30** -- `hNle : (nmin p : Real) <= 2*p`'s `nlinarith`: from
  `N * (L - 4/N) <= N * (p/N) = p` we get `N*L - 4 <= p`; with `N*L >= N*(1/2)` (since `L > 1/2`) and
  `p >= 16`, this gives `N/2 - 4 <= p`, i.e. `N <= 2p + 8` -- **NOT quite `N <= 2p`**.  The constant
  `2` needs the slack `p + 4 <= 2p` (true for `p >= 4`), so the chain is
  `N*L <= p + 4 <= 2p` and **`N*L <= p + 4` requires `N*L - 4 <= p` with the `N*(-4/N) = -4`.**  The
  `nlinarith` must see `hmul`'s LHS expanded: supply `N*(L - 4/N) = N*L - 4` as its own `have` first.
* **31** -- `hpn`'s `linarith`: `p/N <= L + 4/N <= L + 1 <= 2` needs `L <= 1`, available as
  `log_two_le_one`.

**Next: supply `N*(L - 4/N) = N*L - 4` explicitly for `hNle`, and pass `log_two_le_one` to `hpn`.**

### 13.625 Round-596: `he2`/`log_two_le_one` supplied; the same two goals still fail

Build green: **227 declarations, 7/7 OK, 0 sorries**.

**Applied:** `he2 : N*(L - 4/N) = N*L - 4` (by `field_simp`) rewritten into `hmul`, with
`hL12 : 1/2 < log 2` and `hpR`; and `hpn` now uses `log_two_le_one`.

**Two errors remain (33, 36)** -- `hNle`'s `nlinarith` and one more inside `hpn`.

**Recorded next step: print goals 33 and 36.**  `hNle : N <= 2p` from `N*L - 4 <= p`:
with `L > 1/2` this gives `N/2 - 4 <= p`, i.e. `N <= 2p + 8`; **the extra `8` means the target `N <= 2p`
is NOT implied by these facts** -- it needs `p + 4 <= 2p` AND `N*L <= p + 4` to combine as
`N <= 2(p+4)/1` hmm.  Concretely: `N <= (p+4)/L < 2(p+4) = 2p + 8`.  **So `N <= 2p` is likely FALSE
with the constants available; `hN2p` in `log_tailSum_close` should be RELAXED to `N <= 3p`**
(which holds: `2p + 8 <= 3p` for `p >= 8`), **and `log_tailSum_close`'s constant raised correspondingly
(`N/(p-1) <= 6` giving `log 6`, or simply use `log 9`/`log 16` headroom).**

**Next: relax the `N <= 2p` requirement to `N <= 3p` (and re-check `log_tailSum_close`'s constant), then
finish.**

### 13.626 Round-597: **`log_tailSum_upper` relaxed to `N <= 3p` / `log 6`** -- build GREEN

Build green: **227 declarations, 7/7 OK, 0 sorries**.

**Changes:**

* `log_tailSum_upper`'s hypothesis `hN2p : N <= 2p` -> **`hN3p : N <= 3p`**, and its constant
  `log 4` -> **`log 6`** (since `N/(p-1) <= 3p/(p-1) <= 6` for `p >= 2`);
* `log_tailSum_close`'s hypothesis and call site updated to `hN3p`, and its internal comparison
  `Real.log 4 <= Real.log 9` -> `Real.log 6 <= Real.log 9`.

**Why `N <= 2p` was unattainable:** `nmin_w_sharp` gives `N*L - 4 <= p`, hence `N <= (p+4)/L < 2p + 8`
-- **`2p + 8`, not `2p`** -- so the constant had to come from the lemma rather than from the asymptotic
`N ~ 1.44p`.

**With `N <= 3p` the estimation chain is closed:** `nmin_w_sharp` gives `N <= 2p + 8 <= 3p` for `p >= 8`,
which `hp : 16 <= p` provides.

**Next: finish `L_bounded` -- the four brackets plus the `log_ratio_close` remainder -- then the `IsBigO`
wrapper for `op6_reachable_fraction`.**

### 13.627 Round-598: `L_bounded`'s assembly written; three errors

Build green: **227 declarations, 7/7 OK, 0 sorries**.

**The assembly is written in full:**

```lean
have hkey : L p - LAsym p
    = (-N*L + p) + (log(budget p) + p*L)
      + (-log(tailSum p N) - p*log(2N))
      + p * (log(2N/p) - (log2 - loglog2)) := by rw [hdecomp]; unfold LAsym; rw [Real.log_div ...]; ring
rw [hkey]
have hsum : |...| <= 4 + log 3 + log 9 + 300 := by
  have h4 : |p * (log(2N/p) - (log2 - loglog2))| <= 300 := ...
  linarith [abs_add ..., abs_add ..., h4, hb1, hb2, hb3]
linarith [hsum]
```

**Three errors:**

* **13** -- `hLL : 0 < log(log 2)` via `Real.log_pos (by norm_num)` -- again FALSE; **delete it**
  (leftover from the earlier false assumption, and unused);
* **35** -- `hNle`'s `nlinarith` (the `N <= 3p` derivation);
* **50** -- `hkey`'s `Real.log_div` does not match: after `unfold LAsym` the target has
  `-N*L - log(tailSum) + log(budget) - (p*log p - ...)`, so the `log(2N/p)` term must be
  **INTRODUCED by `ring_nf`/`field_simp` on `log_div`'s statement rather than rewritten into it**.
  **Fix: prove `hkey` with `have h7 : Real.log (2*N/p) = Real.log (2*N) - Real.log p := Real.log_div ...`
  then `rw [h7]` AFTER `ring_nf` has produced the `log(2N/p)` subterm.**

**Next: delete `hLL`, fix `hNle`'s `nlinarith`, and restructure `hkey` to introduce `log(2N/p)` after
normalisation.**

### 13.628 Round-599: `h7`/`hdecomp` fixed; `abs_add` is not in scope

Build green: **227 declarations, 7/7 OK, 0 sorries**.

**Applied:** `hLL` deleted; `hkey` restructured to introduce `h7 : log(2N/p) = log(2N) - log p` and
`rw [hdecomp, h7]` before `ring` -- **this fixed error 50**.

**Four errors remain:**

* **34** -- `hNle`'s `nlinarith` (the `N <= 3p` derivation) -- print it;
* **64/65** -- **`Unknown identifier abs_add`**: the triangle inequality is named
  **`abs_add`** in Mathlib but needs `open` (it lives in a namespace) -- **check the exact name; the
  candidates are `abs_add`, `abs_add_le`, `AbsoluteValue.abs_add`**; the standard form is
  `abs_add x y : |x + y| <= |x| + |y|`, possibly requiring `Mathlib.Algebra.Order.AbsoluteValue`
  (already imported via `PhiAsymptotic`);
* **73** -- the final `linarith`.

**Fix: use `abs_add_le` (or `abs_add`) with the right namespace; and for the `hsum` step, note that
`|a + b + c + d| <= |a| + |b| + |c| + |d|` is `abs_add` twice plus `linarith`, and I have already
supplied `abs_add` terms -- so the identifier is the only blocker.**

**Next: resolve `abs_add`'s namespace and print the `hNle`/final goals.**

### 13.629 Round-600: `h4N`/`h6` fixes applied; the `abs_add_le` calls have the wrong arity

Build green: **227 declarations, 7/7 OK, 0 sorries**.

**Applied:** `h4N : 4/N <= 1` for `hpn`; `h5`/`h6` (`p*(300/p) = 300`) for the `h4` remainder bound.

**Two errors remain:**

* **69:14** -- `abs_add_le` takes TWO arguments, not four:
  `abs_add_le a b : |a + b| <= |a| + |b|`.  My `linarith` list calls it with a 4-term sum.
  **Fix: build the triangle chain with TWO nested `abs_add_le` applications:**
  `abs_add_le (a+b) (c+d)` then `abs_add_le a b`, `abs_add_le c d`, and `linarith`.
* **77:2** -- the final `linarith [hsum]`.

**Next: replace the `abs_add_le` terms by properly-arity applications, then close the final `linarith`.**

### 13.630 Round-601: `abs_neg` needs the `ring` normalisation first; two errors left

Build green: **227 declarations, 7/7 OK, 0 sorries**.

**The nested `abs_add_le` chain now compiles** (`abs_add_le a b`, `abs_add_le c d`,
`abs_add_le (a+b) (c+d)`, then `linarith`).

**The sign fixes:** `ha' : |a| <= 4` and `hc' : |c| <= log 9` both needed the `ring` normalisation
`a = -((N*L - p))` before `abs_neg` could fire -- `abs_neg` does not see `-x + y` as `-(x - y)`.

**Two errors remain:**

* **90** -- the final `linarith [h1, habs, ha', hb', hc']`;
* **11** -- an unsolved goal at the `hpR` declaration line.

**Next: print both, then `L_bounded` should compile.**

**Note:** `L_bounded`'s assembly has now consumed rounds 590, 594-601 (nine rounds) on plumbing alone.
All four bracket bounds are LANDED; the assembly's obstacles have been `nlinarith` products,
`abs_add_le` arity, and `abs_neg` normalisation -- each named by the compiler and each fixed in one round.

### 13.631 Round-602: errors 11 and 90 printed

Build green: **227 declarations, 7/7 OK, 0 sorries**.

**Error 11:** `hpR : (6:Real) <= (p:Real) := by exact_mod_cast (by omega : 6 <= p)` is unsolved.  With
`hp : 16 <= p` the `omega` step is trivial, so the failure is in `exact_mod_cast`.  **Fix: use
`by have hp' : (6:ℕ) ≤ p := by omega; exact_mod_cast hp'` or simply
`by exact_mod_cast (show 6 ≤ p by omega)`.**

**Error 90:** the goal's LHS `4 + log 3 + log 9 + 300` is compared with a sum whose ASSOCIATION differs
from `h1`'s (`|a + b + (c + d)|` vs the goal's `|a + b + c + d|`).  **Fix: supply the association identity
`a + b + c + d = a + b + (c + d)` explicitly (`by ring`) and `rw` it before `linarith`, or state `h1`
with the goal's association.**

**Next: fix `hpR`'s cast and align `h1`'s association with the goal.**

**Note:** both remaining errors are the two most-repeated classes of this session -- a `push_cast`/
`exact_mod_cast` form, and an association mismatch in a final `linarith`.  Both have been fixed many
times; both are named by the compiler.

### 13.632 Round-603: `hassoc` added; `hpR` and error 81 remain

Build green: **227 declarations, 7/7 OK, 0 sorries**.

**Applied:** `hassoc : a + b + c + d = a + b + (c + d)` with `rw [hassoc]` before the triangle chain; and
`hpR` rewritten as `by have hp' : (6:Nat) <= p := by omega; exact_mod_cast hp'`.

**Two errors remain (11, 81):**

* **11:30** -- still at the `hpR` region; the `exact_mod_cast` line is unchanged in effect, so the
  unsolved goal is likely at a LATER use of `hpR` (e.g. inside `hNle`'s `nlinarith`);
* **81:4** -- `linarith` in the triangle chain (`h1`'s proof after `rw [hassoc]`).

**Next: print 11 and 81 with their full context -- the `hpR` line's unsolved goal and the `h1` proof's
remaining obligation.**

**Honest note:** the assembly has now taken rounds 590, 594-603 (eleven rounds).  Every error has been a
`cast`/`association`/`arity` detail, all of which the compiler names.  **Neither error requires
mathematics; both require printing the goal at the exact site**, which is the action that has resolved
each comparable case this session.

### 13.633 Round-604: the printed goal is the FINAL `linarith`; `hassoc` must be in `hsum`'s STATEMENT

Build green: **227 declarations, 7/7 OK, 0 sorries**.

**The `⊢` printed at the failure is**

```
|-N*L + p + (log(budget p) + p*L) + (-log(tailSum p N) - p*log(2N))
   + p*(log(2N/p) - (log2 - loglog2))| <= 1000
```

**i.e. the FINAL `linarith [hsum]` goal**, whose LHS association is `a + b + c + d` (left-nested), while
`hsum`'s statement is `a + b + (c + d)`.  **The `hassoc` I added was INSIDE `h1`'s proof, not in
`hsum`'s statement -- so the statement's association still differs from the goal's.**

**Fix: state `hsum` with the goal's association `a + b + c + d` (left-nested), or `rw [hassoc]` on the
GOAL before `linarith [hsum]`.**

**Next: move the association fix to the goal (before the final `linarith`) or restate `hsum`.**

**Position at round 600:** 227 declarations, 7/7 green, 0 sorries, one of three targets proved.  The
OP-6 assembly needs this association fix plus the `hpR` issue, then `L_bounded` and the `IsBigO` wrapper.

### 13.634 Round-605: `hassoc2` added; errors 81 and 11 persist

Build green: **227 declarations, 7/7 OK, 0 sorries**.

**`hassoc2` -- the full explicit association identity from the goal's left-nested form to `hsum`'s
right-nested form -- was added and `rw [hassoc2]` applied before `linarith [hsum]`.**

**Errors 81 and 11 persist.**  Both are `linarith` failures inside `L_bounded`'s assembly.

**Recorded next step: print 81 and 11 with FULL context (hypotheses included), since the previous print
showed the GOAL but not which hypotheses `linarith` had.**  For 81 the enclosing `have` must be identified
(`h1`'s proof, or `hsum`'s).

**Honest position:** `L_bounded` has consumed rounds 590, 594-605 (thirteen rounds) and the last four have
been association/arith plumbing without landing.  **The build has stayed green throughout and the four
bracket lemmas are landed (227 declarations), but the assembly itself is not converging at one fix per
round.**

**The recorded remedy, applied successfully elsewhere this session: rebuild `L_bounded` from scratch as a
SHORT lemma -- state it with the four bracket bounds as HYPOTHESES (not proved inside), prove it in ten
lines, then instantiate.**  That separates the assembly's arithmetic from the four proofs, which is where
the term-level noise is coming from.

### 13.635 Round-606: **the abstract assembly compiles except ONE `linarith`**

Build green: **227 declarations, 7/7 OK, 0 sorries**.

**The rebuild worked.**  Stating the assembly with ABSTRACT `N M B T : Real` and the four bracket bounds as
HYPOTHESES (`h1`..`h4`) plus `hdecomp`, `hasym`, `hlog`:

```lean
have hkey : L p - LAsym p = (-(N*L) + p) + (log B + p*L) + (-(log T) - p*log(2N))
    + p*(log(2N/p) - (L - loglog2)) := by rw [hdecomp, hasym, hlog]; ring
rw [hkey]
linarith [abs_add_le ..., abs_add_le ..., h1, h2, h3, h4, Real.log_nonneg ..., ...]
```

**Two fixes took it from five errors to one:** `hkey` is `rw [hdecomp, hasym, hlog]; ring` (not
`linarith`), and the final step needs the two `Real.log_nonneg` facts.

**ONE error remains (27): the final `linarith`.**  Print it.

**Next: print 27's goal, close it, then instantiate the abstract assembly at
`N = nmin p`, `B = budget p`, `T = tailSum p (nmin p)` using the four landed bracket lemmas.**

**This confirms the recorded remedy:** separating the assembly's arithmetic from the four long proofs
reduced a fifteen-round stall to one `linarith` in a single round.

### 13.636 Round-607: the abstract assembly's triangle chain written; ONE `linarith` left

Build green: **227 declarations, 7/7 OK, 0 sorries**.

**Goal 27's negation printed:**

```
a✝ : 1000 < |-(N*L) + p + (log B + p*L) + (-log T - p*log(2N)) + p*(log(2N/p) - (L - loglog2))|
```

-- the target `|a + b + c + d| <= 1000` with LEFT-nested association.  **The `linarith`'s `abs_add_le`
terms had the wrong association.**

**Applied: `hassoc` (explicit left-nesting) + `hA`, `hB`, `hC` as three separate `abs_add_le`
applications, each matching the goal's association.**

**One error remains (40): the final `linarith`.**

**Next: print 40's goal and hypotheses; the two `Real.log_nonneg` facts and the four bracket bounds are
all supplied, so the residual is once more association or a missing `linarith`-visible term.**

**Method note -- the rebuild is validated:** the abstract assembly went from 5 errors to 1 in two rounds,
after fifteen rounds of in-place patching produced none.  **Stating the four long proofs as hypotheses is
what made the difference.**

### 13.637 Round-608: **ALL the facts are present; the `linarith` still fails**

Build green: **227 declarations, 7/7 OK, 0 sorries**.

**Printed context at error 40:**

```
h1 : |-(N*L) + p| <= 4
h2 : |log B + p*L| <= log 3
h3 : |-log T - p*log(2N)| <= log 9
h4 : |p*(log(2N/p) - (L - loglog2))| <= 300
hA : |a+b+c+d| <= |a+b+c| + |d|
hB : |a+b+c| <= |a+b| + |c|
hC : |a+b| <= |a| + |b|
a✝ : 1000 < |a+b+c+d|
```

**Every fact needed is present and correctly shaped:** `hA`+`hB`+`hC` give
`|a+b+c+d| <= |a|+|b|+|c|+|d|`, and `h1`..`h4` give `|a|+|b|+|c|+|d| <= 4 + log3 + log9 + 300 <= 1000`.

**So the `linarith` failure is a term-level mismatch between `hA`'s LHS and the goal's LHS** (likely the
last association step, since `hassoc` rewrote the goal and `hA` was stated before it).

**Fix: restate `hA` AFTER the `hassoc` rewrite, or `exact` the chain by `calc`:**

```lean
calc |a + b + c + d| <= |a| + |b| + |c| + |d| := by linarith [hA, hB, hC]
  _ <= 4 + Real.log 3 + Real.log 9 + 300 := by linarith [h1, h2, h3, h4]
  _ <= 1000 := by linarith [Real.log_nonneg (by norm_num : (1:Real) <= 3), ...]
```

**Next: replace the final `linarith` by that `calc`, which isolates each step.**

**Honest position:** `L_bounded` has now consumed rounds 590, 594-608 (sixteen rounds).  The abstract
rebuild (round 606) is one `linarith` from compiling, and the `calc` above is the recorded exit.

### 13.638 Round-609: the `calc` is in place; ONE step fails

Build green: **227 declarations, 7/7 OK, 0 sorries**.

**The `calc` was applied with four steps:**

```lean
calc |a + b + c + d|
    ≤ |a + b + c| + |d| := by rw [hassoc]; exact abs_add_le _ _
  _ ≤ (|a + b| + |c|) + |d| := by linarith [abs_add_le (a+b) c, h4]
  _ ≤ ((|a| + |b|) + |c|) + |d| := by linarith [abs_add_le a b, h3, h4]
  _ ≤ 1000 := by linarith [h1, h2, h3, h4, Real.log_nonneg ..., ...]
```

**One error remains (48), in the third step.**  That step's `linarith` has
`abs_add_le a b : |a+b| <= |a|+|b|` plus `h3`, `h4`, but the goal's association
`((|a| + |b|) + |c|) + |d|` differs from what the previous step produced.

**Fix: replace that `linarith` by `linarith only [abs_add_le a b]` plus an explicit `ring_nf`-normalised
statement, or add the two association identities (`(|a|+|b|)+|c| = |a|+(|b|+|c|)` etc.) as `have`s.**

**Next: supply the association identities for the third `calc` step, then the fourth closes it.**

**Method note:** the `calc` made the failure LOCAL to one step (previously the single `linarith` failed
with all seven facts in scope and no indication of which pairing was wrong).  This is the second
consecutive round in which restructuring -- rather than patching -- moved the proof forward.

### 13.639 Round-610: the third `calc` step still fails with `linarith only`

Build green: **227 declarations, 7/7 OK, 0 sorries**.

**The third step is now `linarith only [abs_add_le (-(N*L) + p) (log B + p*L)]`** and still fails (48).

**So the mismatch is not extra hypotheses but the TERM FORM of the goal's `|a+b|` versus
`abs_add_le`'s LHS.**  The step's goal is
`(|a + b| + |c|) + |d| <= ((|a| + |b|) + |c|) + |d|` -- and `abs_add_le a b` gives
`|a + b| <= |a| + |b|`; `linarith` must transport it through `+ |c|` and `+ |d|`, which it does for
linear goals, so a residual syntactic difference in `a` or `b` is the cause.

**Fix: prove that step by `add_le_add_right`-style monotonicity instead of `linarith`:**

```lean
  _ ≤ ((|a| + |b|) + |c|) + |d| := by
        have h := abs_add_le a b
        linarith only [h]
```
**or, more robustly, `gcongr` / `exact add_le_add_right (add_le_add_right h _) _`.**

**Next: replace that `linarith only` by `add_le_add_right`-based monotonicity.**

**Position:** `L_bounded` (rounds 590, 594-610, seventeen rounds) -- abstract rebuild done, `calc` in
place, one step's transport remaining.  Build green throughout at 227 declarations.

### 13.640 Round-611: `add_le_add_right` has the wrong shape for the goal's association

Build green: **227 declarations, 7/7 OK, 0 sorries**.

**The error shows** `add_le_add_right` produced `?m.914 + (?m.913 + |a+b|) <= ...` -- **it places the added
term on the LEFT of the sum**, while the goal's association is `((|a+b| + |c|) + |d|)`.

**Recorded fix:** the two additions must be
`add_le_add_right (add_le_add_right (abs_add_le a b) |c|) |d|` **with the `+`-association made explicit by
`show`**, or simply prove the step by `nlinarith [abs_add_le a b]` after `ring_nf`-normalising both sides.

**Simplest robust form:** state the step's two sides as separate `have`s with explicit parenthesisation and
close by `linarith`.

**Next: normalise the association in that `calc` step and close it.**

**Position at round 611:** `L_bounded` (rounds 590, 594-611 -- eighteen rounds).  Build green at 227
declarations.  The four bracket lemmas are landed; the assembly's last obstacle is one `calc` step's
association.

### 13.641 Round-612: `linarith only [h]` on the transport step still fails

Build green: **227 declarations, 7/7 OK, 0 sorries**.

**The step's proof is now**

```lean
_ ≤ ((|-(N*L) + p| + |log B + p*L|) + |-log T - p*log(2N)|) + |p*(...)|
    := by
      have h := abs_add_le (-(N * L) + p) (log B + p*L)
      linarith only [h]
```

**and still fails (49).**  Since `h` is exactly `|a+b| <= |a|+|b|` and the goal compares
`(|a+b| + |c|) + |d|` with `((|a|+|b|) + |c|) + |d|`, **`linarith` must handle the `+`-association
`(|a+b| + |c|) + |d|` versus `|a+b| + (|c| + |d|)`** -- and it cannot.

**Recorded fix: prove the step with `show` to fix the association explicitly, then `linarith`:**

```lean
_ ≤ ((|-(N*L) + p| + |log B + p*L|) + |-log T - p*log(2N)|) + |p*(...)| := by
      have h := abs_add_le (-(N * Real.log 2) + (p:Real)) (Real.log B + (p:Real) * Real.log 2)
      have hassoc' : (|-(N*L) + p + (log B + p*L)| + |c|) + |d|
          = (|-(N*L) + p + (log B + p*L)|) + (|c| + |d|) := by ring
      rw [hassoc']
      linarith only [h]
```

**Next: supply the association identity inside the step and close it.**

**Position:** `L_bounded` (rounds 590, 594-612 -- nineteen rounds).  Build green, 227 declarations.
The remaining obstacle is one `calc` step's `+`-association.

### 13.642 Round-613: the association identity inside the step; still ONE error

Build green: **227 declarations, 7/7 OK, 0 sorries**.

**Applied `hA2` -- the explicit `+`-association identity for that `calc` step -- with `rw [hA2]` before
`linarith only [h]`.**  **Error 55 persists.**

**So the mismatch is NOT the `+`-association either.**  With `h : |a+b| <= |a|+|b|`, the goal after the
association rewrite is `|a+b| + (|c|+|d|) <= (|a|+|b|) + (|c|+|d|)`, and `linarith only [h]` should close
it.  **That it does not means `h`'s `a`/`b` differ syntactically from the goal's** -- most likely because
the goal's `|a+b|` carries the FULL sum `-(N*L) + p + (log B + p*L)` while `h`'s is
`abs_add_le (-(N*L)+p) (log B+p*L)` with different parenthesisation of the INNER sum.

**Fix: state `h` with the goal's exact parenthesisation:**

```lean
have h := abs_add_le (-(N * Real.log 2) + (p:Real) + (Real.log B + (p:Real) * Real.log 2) - 0) 0
```

**or, simplest: print the goal at 55 and copy its `|...|` argument verbatim into the `abs_add_le` call.**

**Next: print goal 55 and match `abs_add_le`'s arguments to it exactly.**

**Position:** `L_bounded` (rounds 590, 594-613 -- twenty rounds).  One `calc` step; build green at 227
declarations.  **Every fix so far has been inferred rather than printed; the recorded remedy is to PRINT
the goal at the failing step and copy its subterms.**

### 13.643 Round-614: **`hassoc` is a NO-OP (both sides identical)**

Build green: **227 declarations, 7/7 OK, 0 sorries**.

**Printing 55's context showed the real defect:**

```
hassoc :
  -(N*L) + p + (log B + p*L) + (-log T - p*log(2N)) + p*(...)
  =
  -(N*L) + p + (log B + p*L) + (-log T - p*log(2N)) + p*(...)
```

**Both sides are IDENTICAL** -- `ring` produced a trivial identity, so `rw [hassoc]` at the first `calc`
step was a NO-OP, and the goal never acquired the `a + b + (c + d)` association that `abs_add_le _ _`
needs.

**Root cause: `+` on `Real` is left-associative, so writing `a + b + c + d` and
`a + b + (c + d)` unaided gives DIFFERENT terms -- but my `hassoc` statement happened to be printed with
the SAME parenthesisation on both sides because I wrote them identically.**

**Fix: state `hassoc` with the association EXPLICIT on both sides:**

```lean
have hassoc : (-(N*L) + p + (log B + p*L) + (-log T - p*log(2N)) + p*(...))
    = ((-(N*L) + p + (log B + p*L)) + (-log T - p*log(2N))) + (p*(...)) := by ring
```

and use the association that the FIRST `calc` step's goal presents.

**Next: rewrite `hassoc` with the two different parenthesations (so `ring` proves a non-trivial identity)
and use it to feed `abs_add_le`.**

**Position:** `L_bounded` (rounds 590, 594-614 -- twenty-one rounds).  This round FOUND the cause by
printing, after nine rounds of inference.

### 13.644 Round-615: `hassoc` corrected to a non-trivial identity; error 55 persists

Build green: **227 declarations, 7/7 OK, 0 sorries**.

**`hassoc` now has genuinely different parenthesations on the two sides** (left: fully left-nested; right:
`(a + b + c) + d`), so `ring` proves a NON-trivial identity.

**Error 55 persists.**  So the failing `linarith` is NOT fed by `hassoc` at all -- the `calc` step it sits
in is a LATER step (the third), whose goal is
`(|a+b| + |c|) + |d| <= ((|a|+|b|) + |c|) + |d|`, and the `hA2` identity I added there has the same
no-op problem as `hassoc` did.

**Recorded next step: PRINT the goal at 55 and the `hA2` I added, comparing them term by term.**  The
`hassoc` defect was invisible until printed; the same is likely true of `hA2`.

**Position:** `L_bounded` (rounds 590, 594-615 -- twenty-two rounds).  Build green at 227 declarations.
**The recorded diagnosis for the previous no-op applies unchanged: verify that each `ring` identity is
non-trivial by printing both sides.**

### 13.645 **LANDED (round 616): `L_bounded_abstract`** -- 228 declarations -- ONE `have` was the obstacle

`Op56/PhiThird.lean` now has **228 declarations** (0 sorries, 7/7 OK, 0 axioms), newly:

```lean
lemma L_bounded_abstract (p : Nat) (N M B T : Real)
    (hdecomp : L p = -N * Real.log 2 - Real.log T + Real.log B)
    (hN : N * Real.log 2 - (p:Real) = -(-(N * Real.log 2) + (p:Real)))
    (hasym : LAsym p = (p:Real) * Real.log (p:Real) - (1 + Real.log (Real.log 2)) * (p:Real))
    (h1 : |-(N * Real.log 2) + (p:Real)| <= 4)
    (h2 : |Real.log B + (p:Real) * Real.log 2| <= Real.log 3)
    (h3 : |-(Real.log T) - (p:Real) * Real.log (2*N)| <= Real.log 9)
    (h4 : |(p:Real) * (Real.log (2*N/(p:Real)) - (Real.log 2 - Real.log (Real.log 2)))| <= 300)
    (hlog : Real.log (2*N/(p:Real)) = Real.log (2*N) - Real.log (p:Real)) :
    |L p - LAsym p| <= 1000
```

**The FINAL obstacle was a `have` I had mis-stated:** the last `calc` step needed UPPER bounds
`log 3 <= 2`, `log 9 <= 8` (from `Real.log_le_sub_one_of_pos`), and I had supplied `Real.log_nonneg`
(LOWER bounds) instead -- **wrong direction, so `linarith` could never close it.**

**Printing the goal (round 614 for `hassoc`, this round for 55) is what found both defects, after ten
rounds of inference.**

**Next: instantiate `L_bounded_abstract` at `N = nmin p`, `B = budget p`, `T = tailSum p (nmin p)` using
the four landed bracket lemmas, giving `L_bounded`; then the `IsBigO` wrapper.**

### 13.646 Round-617: instantiating `L_bounded_abstract`; one type mismatch

Build green: **228 declarations, 7/7 OK, 0 sorries**.

**The instantiation is written:**

```lean
refine Op56.Op56.L_bounded_abstract p (nmin p : Real) (budget p) (tailSum p (nmin p))
    (Op56.Op56.L_decomp p (by omega : 2 <= p)) ?_ rfl
    (Op56.Op56.log_nmin_close p (by omega : 6 <= p) hn hlarge hnK) ?_ ?_ ?_ ?_
```

**One error:** the `hdecomp` argument's type is
`L p = -↑(nmin p) * Real.log 2 - Real.log (tailSum p (nmin p)) + Real.log (budget p)`,
while `L_bounded_abstract` expects `L p = -N * Real.log 2 - Real.log T + Real.log B` with
`N = (nmin p : Real)` -- **the `↑(nmin p)` versus `(nmin p : Real)` coercion form again** (the pattern
recorded at round 598 for `hpR`).

**Fix: `simpa using Op56.Op56.L_decomp p (by omega : 2 <= p)`, or bind `N` via `set`.**

**Also note:** `hNle` was RELAXED from `3p` to `6p` and `hpn` to `3` in this draft, to leave slack -- the
`log_tailSum_close` call then needs `hN3p`/`hpn` consistent with ITS constants.

**Next: `simpa using L_decomp ...`, then close the two remaining bracket arguments.**

### 13.647 Round-618: `simpa` applied; the coercion/association mismatch persists in two places

Build green: **228 declarations, 7/7 OK, 0 sorries**.

**Two errors:**

* **35** -- after `simpa`, `L_decomp` gives
  `L p = -(↑(nmin p) * Real.log 2) - Real.log (tailSum p (nmin p)) + Real.log (budget p)`
  while `L_bounded_abstract`'s `hdecomp` is `L p = -N * Real.log 2 - log T + log B` -- **the difference is
  `-(↑N * log 2)` versus `-(N * log 2)`** (a definitional/no-op distinction again, not a real gap);
* **36** -- `log_nmin_close`'s type is `|↑(nmin p) * Real.log 2 - ↑p| ≤ 4` while `h1` is
  `|-(N * Real.log 2) + (p:Real)| ≤ 4` -- **`-N*L + p` versus `N*L - p`, opposite signs**, needing
  `abs_sub_comm`/`abs_neg`.

**Recorded fix:** pass `N` as `-(nmin p : Real)` or adjust `L_bounded_abstract`'s parameter to
`N := (nmin p : Real)` with the `h1` form `|N * log 2 - p| <= 4` -- **i.e. state the abstract lemma's
`h1` in the SAME form `log_nmin_close` provides, avoiding the sign flip.**

**Next: align `L_bounded_abstract`'s `h1` form with `log_nmin_close`'s conclusion, then re-instantiate.**

**Position:** `L_bounded` instantiation -- two sign/coercion alignments.  The abstract lemma is LANDED
(228 declarations) and its statement's forms are the only thing needing adjustment.

### 13.648 Round-619: `abs_sub_comm` applied; two `simpa` mismatches remain

Build green: **228 declarations, 7/7 OK, 0 sorries**.

**Two errors, both "After simplification, term h has type ..." i.e. `simpa` did not close:**

* **35** -- `L_decomp`'s type `L p = -(↑(nmin p) * Real.log 2) - log (tailSum p (nmin p)) + log (budget p)`
  versus `hdecomp`'s `-N * Real.log 2 - log T + log B` with `N = (nmin p : Real)`;
* **39** -- `abs_sub_comm` gave `|↑p - ↑(nmin p) * Real.log 2| <= 4`, while `h1` is
  `|-(N * Real.log 2) + (p:Real)| <= 4` -- **`p - N*L` versus `-N*L + p`**.

**Both are definitional/associativity differences that `simpa` alone does not bridge.**  **Recorded fix:
use `convert` with explicit goals:**

```lean
(by convert Op56.Op56.L_decomp p (by omega : 2 <= p) using 2; ring)
...
(by convert Op56.Op56.log_nmin_close p (by omega : 6 <= p) hn hlarge hnK using 2; ring)
```

**Next: replace the two `simpa`s by `convert ... using 2; ring`.**

**Position:** `L_bounded` instantiation -- two `convert`-style alignments.  Abstract lemma LANDED
(228 declarations); build green throughout.

### 13.649 Round-620: `convert ... using 2` has a goal-order/syntax issue

Build green: **228 declarations, 7/7 OK, 0 sorries**.

**Two errors:**

* **35** -- `Op56.L_decomp p ?m.516` has sort `Prop` but is expected to have another type: the
  `(by convert ... using 2; ring)` block's `; ring` applies to ALL goals `convert` produces, including the
  hypothesis-direction ones, so the block fails before returning a term;
* **36** -- an unsolved goal in the same block.

**Fix: write the `convert` block with explicit goals:**

```lean
(by
  convert Op56.Op56.L_decomp p (by omega : 2 <= p) using 2
  · ring
  )
```

**or avoid `convert` entirely by stating `L_bounded_abstract`'s `hdecomp` in the exact
coercion/association form `L_decomp` produces** -- which is the approach that made `log_tailSum_close`
instantiable directly.

**Next: fix the `convert` block's bullet structure, or restate `L_bounded_abstract`'s `hdecomp`/`h1` to
match the providers exactly.**

**Position:** `L_bounded` instantiation, two term-shape alignments.  Build green, 228 declarations.

### 13.650 Round-621: `convert` block still fails; the `refine`'s ARGUMENT ORDER must be checked

Build green: **228 declarations, 7/7 OK, 0 sorries**.

**Two errors persist (36, 38).**

**Recorded diagnosis: `L_bounded_abstract`'s argument order is
`(p) (N M B T) (hdecomp) (hN) (hasym) (h1) (h2) (h3) (h4) (hlog)`.**  My `refine` passes
`(hdecomp) ?_ rfl (h1) ?_ ?_ ?_ ?_` -- **so `?_` #1 is `hN` (currently unsolved) and `rfl` is `hasym`.**
The unsolved `hN` and the `convert` failure may be the same problem: the `hN` I omitted is not `rfl`.

**Fix: supply `hN` explicitly** -- its statement is
`N * Real.log 2 - (p:Real) = -(-(N * Real.log 2) + (p:Real))`, provable by `ring`.

**Next: add `(by ring : ...)` for `hN` in the `refine`, then re-check the two `convert` blocks.**

**Honest position:** the `L_bounded` instantiation has now taken rounds 613-621 (nine rounds) on argument
alignment alone, while the abstract lemma itself was landed in one round (616).  **The mismatch is
increasingly likely to be the `refine`'s positional arguments rather than the `convert`s**, and the
recorded remedy is to write the instantiation with NAMED arguments
(`(hdecomp := ...) (hN := ...) (hasym := ...) ...`) so no mis-ordering is possible.

### 13.651 Round-622: explicit positional arguments; three errors

Build green: **228 declarations, 7/7 OK, 0 sorries**.

**The instantiation is now fully explicit:**

```lean
exact Op56.Op56.L_bounded_abstract p (nmin p : Real) (budget p) (tailSum p (nmin p))
  (Op56.Op56.L_decomp p (by omega : 2 <= p))     -- hdecomp
  (by ring)                                      -- hN
  rfl                                            -- hasym
  (log_nmin_close ...) (log_budget_close ...) (log_tailSum_close ...) (log_ratio_close ...)
  (Real.log_div ...)
```

**Three errors:**

* **35** -- `hdecomp`'s type is `L p = -↑(nmin p) * Real.log 2 - ...` versus the abstract lemma's
  `-N * Real.log 2 - ...`: **these ARE the same with `N := (nmin p : Real)`**, so the mismatch indicates
  the coercion is being elaborated at a different type (likely `NNReal`/`Nat` rather than `Real`);
* **41** -- `hpn : p/(nmin p) <= 3` versus the abstract lemma's expectation -- **`log_tailSum_close`'s
  `hpn` hypothesis is `p/N <= 2`, not `<= 3`**;
* **36** -- an unsolved goal.

**Recorded next step: print the goal at 35 and 41 in full and copy the EXPECTED types verbatim into the
arguments.**  The pattern of the last ten rounds is that each argument's expected type is inferable from
the error but I have been rewriting rather than reading.

**Position:** `L_bounded` instantiation (rounds 613-622).  Abstract lemma LANDED; build green at 228
declarations.  **The recommended restart: write `L_bounded` with `have` statements for each argument, each
with its type printed by the compiler, then a single `exact`.**

### 13.652 Round-623: **THE MISSING `M` ARGUMENT was the main defect** -- two errors left

Build green: **228 declarations, 7/7 OK, 0 sorries**.

**`L_bounded_abstract` takes `(p) (N M B T)`, and my `refine` passed only THREE reals** -- `N`, `B`, `T`
-- so every subsequent argument was off by one position.  **Passing `M := 0` fixed the entire
`hdecomp`/`hN`/`hasym` block**, which had resisted nine rounds.

**This also explains the earlier `convert`/`simpa` "failures": they were not form mismatches at all --
the arguments were being matched to the wrong hypotheses.**

**Two errors remain, both SIGN normalisations:**

* **41** -- `h : |↑p - ↑(nmin p) * Real.log 2| <= 4` versus `h1 : |-(N*L) + (p:Real)| <= 4`:
  `simpa [sub_eq_add_neg, add_comm] using h`;
* **43** -- `log_tailSum_close` gives `|log T + p*log(2N)| <= log 9` versus `h3`'s
  `|-(log T) - p*log(2N)| <= log 9`: `simpa [neg_add_rev] using ...` or `abs_neg`.

**Also fixed:** `hNle`'s use for the `log_tailSum_close` `hN3p` argument (`by omega` could not prove
`nmin p <= 3p`; `linarith [hNle]` does).

**Next: apply `simpa [sub_eq_add_neg, add_comm]` and `abs_neg`-based fixes, then `L_bounded` compiles.**

### 13.653 Round-624: `h4` needs the `p *` factor; two sign/simplification errors remain

Build green: **228 declarations, 7/7 OK, 0 sorries**.

**Applied `h4`'s derivation:** `log_ratio_close` gives `|log(2N/p) - (L - loglog2)| <= 300/p`, while the
abstract lemma's `h4` is `|p * (log(2N/p) - (L - loglog2))| <= 300`; the fix multiplies by `p` via
`rw [abs_mul, abs_of_nonneg ...]` and `p*(300/p) = 300`.

**Two errors remain (45, 46):**

* **45** -- inside the `log_nmin_close` `simpa` block;
* **46** -- after simplification, `h` has type
  `|↑p * Real.log (2 * ↑(nmin p)) + Real.log (tailSum p (nmin p))| <= Real.log 9`, but `h3` expects
  `|-(log T) - p*log(2N)| <= log 9` -- **the summand order is reversed**, needing
  `simpa [add_comm, neg_add_rev]`.

**Next: fix 45 and 46 with the exact `simp` lemma sets (print both goals).**

**Position:** `L_bounded` instantiation (rounds 613-624).  With the `M` fix (round 619) the argument
POSITIONS are correct; the residual is two sign/order normalisations inside `simpa` blocks, each of which
the compiler names.  Build green at 228 declarations throughout.

### 13.654 Round-625: `← abs_mul` ordering fixed; two `linarith` goals remain

Build green: **228 declarations, 7/7 OK, 0 sorries**.

**Applied the `h4` derivation correctly this time:**

```lean
have h := Op56.Op56.log_ratio_close p hp hn hlarge hnK
have h2 := mul_le_mul_of_nonneg_left h (by linarith : (0:Real) <= (p:Real))
rw [← abs_of_nonneg (by linarith : (0:Real) <= (p:Real)), ← abs_mul] at h2
have h6 : (p:Real) * (300 / (p:Real)) = 300 := by field_simp
linarith [h2, h6]
```

-- the `← abs_mul` (not `abs_mul`) is what merges `p * |...|` into `|p * ...|`.

**Two errors remain (45, 55), both `linarith`.**

**Next: print 45 and 55 and close them.**

**Position:** `L_bounded` instantiation (rounds 613-625).  All argument POSITIONS are now correct (the
`M` fix); the residual is `linarith` at `h1`'s `simpa` block (45) and the `h4` block (55).  Build green at
228 declarations throughout.

### 13.655 Round-626: `hNle`'s constant fixed to `3p`; ONE error left (`← abs_mul` shape)

Build green: **228 declarations, 7/7 OK, 0 sorries**.

**Both printed goals were decisive:**

* **45** -- `a✝ : 3 * p < nmin p`, so `hNle`'s `6p` was TOO WEAK.  **Fixed by adding `hpR2 : 8 <= p` and
  stating `hNle : nmin p <= 3p`** -- the derivation `N*(L - 4/N) <= p`, `L > 1/2` gives
  `N/2 <= p + 4 <= 2p` for `p >= 8`;
* **55** -- `h2 : |p * (.../|p|) - ...| <= |p| * (300/|p|)` showed the `|p|` came from an unwanted
  `abs_of_nonneg`; dropping it leaves the target `p * |...| <= p * (300/p)`.

**ONE error remains (54):** `← abs_mul` cannot fire because the target's LHS is `p * |...|` (the `p` is not
yet `|p|`).  **Fix: `rw [← abs_of_nonneg (by linarith : (0:Real) <= (p:Real))]` FIRST (turning `p` into
`|p|`), THEN `← abs_mul`** -- i.e. the two rewrites in that order, which is what I had before but with the
FIRST one also touching the RHS's `300/p`.

**Next: order the two `rw`s as `← abs_of_nonneg` then `← abs_mul`, both under `at h2`, then `linarith`.**

**Position:** `L_bounded` instantiation (rounds 613-626) -- ONE rewrite away.  Build green at 228
declarations.

### 13.656 **LANDED (round 627): `L_bounded`** -- 229 declarations -- only `IsBigO` remains for OP-6

`Op56/PhiThird.lean` now has **229 declarations** (0 sorries, 7/7 OK, 0 axioms), newly:

```lean
lemma L_bounded (p : Nat) (hp : 16 <= p) (hn : 2000000000 <= nmin p)
    (hlarge : 3*PhiC <= ((2*p : Nat):Real))
    (hnK : 10^40 * ((2*PhiC+1)^2 + 1) <= (nmin p:Real)) :
    |L p - LAsym p| <= 1000
```

**This completes the OP-6 estimate chain.**  `L_bounded` instantiates `L_bounded_abstract` at
`N = nmin p`, `B = budget p`, `T = tailSum p (nmin p)` with the four landed bracket lemmas.

**The instantiation's defects, all found by printing:**

1. **a MISSING `M` argument** (round 619) -- off-by-one in the `refine`, which made every subsequent
   argument match the wrong hypothesis and produced nine rounds of spurious `convert`/`simpa` failures;
2. **`hNle`'s constant `6p` was too weak** (round 622) -- `3p` is what `nmin_w_sharp` supports, and `6p`
   could not serve `log_tailSum_close`'s `hN3p`;
3. **`h4`'s `p *` factor** -- `log_ratio_close` gives `|.| <= 300/p`, and the abstract lemma's `h4` needs
   `|p * .| <= 300`, via `← abs_mul` after making `p = |p|`.

**Next: the `IsBigO` wrapper for `op6_reachable_fraction`.**  From `L_bounded`:
`(fun p => L p - LAsym p) =O[atTop] (fun _ => 1)` follows by `isBigO_iff` with the eventual bound
`|L p - LAsym p| <= 1000` on the `nmin`-range (which `Asymptotic.lean`'s `Threshold`-family hypotheses
provide).

### 13.657 Round-628: the `IsBigO` wrapper's missing ingredient -- the eventual range hypotheses

Build green: **229 declarations, 7/7 OK, 0 sorries**.

**Search result:** `hn : 2000000000 <= n` is a HYPOTHESIS throughout `PhiThird.lean` (e.g.
`exp_neg_sqrt16_le`, lines 2602-3799), and **`op6_reachable_fraction` has NO hypotheses** -- so the
wrapper must produce

```
forall-asymptotically p, 2000000000 <= nmin p     (and 3*PhiC <= 2p, 10^40*(...) <= nmin p)
```

from the library.  **No such lemma was found by grepping `nmin` for `ge|large|eventual|bound` in
`Exact.lean`.**

**So the wrapper needs `nmin p -> infinity`** -- i.e. a growth/unboundedness statement for `nmin`, or an
eventual constant bound.  **Candidates to search:** `Filter.Tendsto` statements about `nmin` in
`Exact.lean`/`PhiThird.lean`; or derive it from `nmin_spec`/`IsComplete` (the criterion is satisfiable
only above a threshold).

**Next: search `PhiThird.lean`/`Exact.lean` for a `nmin`-growth or eventual-bound lemma; if absent, derive
`2000000000 <= nmin p` eventually from `nmin_w_sharp` (`nmin p ~ p/log2`).**

**Position:** 229 declarations, 7/7 green.  `op6_reachable_fraction` = `L_bounded` + this eventual-range
fact + `isBigO_iff`.

### 13.658 Round-629: **`nmin_ge_p : p <= nmin p` IS LANDED** -- the wrapper is straightforward

Build green: **229 declarations, 7/7 OK, 0 sorries**.

**Search found the range lemmas:**

```lean
lemma nmin_ge_p     (p : Nat) (hp : 6 <= p) : p <= nmin p        -- PhiThird:5360
lemma nmin_le_four_p (p : Nat) (hp : 2 <= p) : nmin p <= 4*p     -- PhiThird:5221
```

**So ALL THREE range hypotheses are EVENTUAL from `nmin_ge_p`:**

* `2000000000 <= nmin p` -- holds for `p >= 2000000000`, since `p <= nmin p`;
* `3*PhiC <= ((2*p : Nat):Real)` -- holds for `p` large (linear growth);
* `10^40 * ((2*PhiC+1)^2 + 1) <= (nmin p : Real)` -- holds for `p` large, since `p <= nmin p`.

**Hence `op6_reachable_fraction` follows from `L_bounded` + `isBigO_iff` + `filter_upwards` with a
sufficiently large `p`-threshold.**

**Next: write the wrapper:**

```lean
theorem op6_reachable_fraction :
    (fun p : Nat => L p - LAsym p) =O[atTop] (fun _ : Nat => (1 : Real)) := by
  rw [isBigO_iff]
  refine ⟨1000, ?_⟩
  filter_upwards [Filter.eventually_ge_atTop N] with p hp
  have hp16 : 16 <= p := le_trans (by norm_num : 16 <= N) hp
  have hlarge : 3*PhiC <= ((2*p : Nat):Real) := ...
  have hn : 2000000000 <= nmin p := le_trans (by norm_num) (nmin_ge_p p (by omega))
  have hnK : ... := le_trans ... (nmin_ge_p ...)
  have h := L_bounded p hp16 hn hlarge hnK
  simpa using h
```

**This is the LAST piece of `op6_reachable_fraction`.**

### 13.659 Round-630: the wrapper's shape written; `isBigO_iff` is not in scope

Build green: **229 declarations, 7/7 OK, 0 sorries**.

**The wrapper sketched:**

```lean
rw [isBigO_iff]
refine ⟨1000, ?_⟩
filter_upwards [Filter.eventually_ge_atTop (max 16 (max 2000000000 1))] with p hp
have hp16 : 16 <= p := le_trans (le_max_left _ _) hp
have hn : 2000000000 <= nmin p := ... (nmin_ge_p p hp6)
have hlarge : 3*PhiC <= ((2*p : Nat):Real) := ...
have hnK : 10^40 * ((2*PhiC+1)^2 + 1) <= (nmin p:Real) := ...
have h := L_bounded p hp16 hn hlarge hnK
simpa [Real.norm_eq_abs] using h
```

**Error: `Unknown identifier isBigO_iff`** -- the `IsBigO` API needs the right import/namespace.
**Candidates: `Asymptotics.IsBigO`, `isBigO_iff`, `isBigO_iff'`, `Asymptotics.isBigO_iff`, or the
`IsBigOWith`/`isBigOWith_iff` family.**  The statement's `=O[atTop]` notation comes from
`Mathlib.Analysis.Asymptotics.Defs`, which `Asymptotic.lean` already imports.

**Also needed: `hlarge` and `hnK` as eventual facts** -- both follow from `nmin_ge_p` for `p` beyond an
explicit threshold; `hlarge` needs `3*PhiC <= 2p`, i.e. `p >= ceil(3*PhiC/2)`, and `hnK` needs
`10^40*((2*PhiC+1)^2+1) <= p`, both satisfiable by `Filter.eventually_ge_atTop N` for a suitable `N`.

**Next: find the correct `IsBigO` unfolding lemma, then close `hlarge`/`hnK` with explicit thresholds.**

### 13.660 Round-631: `Asymptotics.isBigO_iff` found; three threshold errors

Build green: **229 declarations, 7/7 OK, 0 sorries**.

**The `IsBigO` API is `Asymptotics.isBigO_iff`** (`Mathlib/Analysis/Asymptotics/Defs.lean:96`):
`f =O[l] g <-> exists c, forall-asymptotically x in l, ‖f x‖ <= c * ‖g x‖`.  **Needs `open Asymptotics`**
-- adding it removed the "unknown identifier".

**Three errors remain:**

* **22** -- `exact_mod_cast (by omega : 0 <= p)` gives `0 <= p`, not `PhiC <= p`; the `PhiC <= p` step needs
  its own derivation (`PhiC` is a numeric constant, so `p >= 16` should suffice via `norm_num` bounds);
* **24** -- `hlarge`'s `linarith` (the `push_cast` produced a form the `h2`/`linarith` combination does
  not close);
* **28** -- `hnK`'s `linarith` (the `hle` is still a `sorry` and `nmin_ge_p p hp6` is `p <= nmin p`, a NAT
  inequality needing `exact_mod_cast`).

**Next: derive `3*PhiC <= 2p` and `10^40*((2*PhiC+1)^2+1) <= nmin p` with explicit numeric bounds and
`exact_mod_cast` on the `nmin_ge_p` step.**

**Position:** `op6_reachable_fraction` wrapper -- API resolved, three numeric-threshold goals remain.
Build green at 229 declarations.

### 13.661 Round-632: `PhiC`'s definition found; its numeric bound is the wrapper's last ingredient

Build green: **229 declarations, 7/7 OK, 0 sorries**.

**`PhiC` is `noncomputable def PhiC : Real := (sum' k, k^2 * exp(-(k/4)))/2 + 8`**
(`PhiAsymptotic.lean:1929`), and `PhiC_pos : 0 < PhiC` is at 1931.

**So `hlarge : 3*PhiC <= ((2*p : Nat):Real)` needs an UPPER bound on `PhiC`** -- e.g.
`PhiC <= 100` (the series is dominated by its first terms plus 8), giving `p >= 150`.  **Search for an
existing `PhiC_le`/`PhiC_lt` lemma in `PhiAsymptotic.lean` first**; if absent, derive `PhiC <= 100` by
bounding the `tsum` (`sum' k, k^2 e^{-k/4} <= sum' k, k^2 (1/2)^k` or a crude `Real.exp` bound).

**Similarly `hnK` needs `10^40 * ((2*PhiC+1)^2 + 1) <= nmin p`**, which with `PhiC <= 100` becomes
`10^40 * 40401 <= p` -- a hard numeric threshold for `eventually_ge_atTop`.

**Next: search `PhiAsymptotic.lean` for a `PhiC` upper bound; if absent, prove `PhiC <= 100` by bounding
the `tsum`.**

**Position:** `op6_reachable_fraction` wrapper -- the LAST ingredient is a numeric upper bound on `PhiC`,
then three threshold derivations.  Build green at 229 declarations.

### 13.662 Round-633: **NO `PhiC` upper bound exists in the library** -- it must be proved

Build green: **229 declarations, 7/7 OK, 0 sorries**.

**Grepping `PhiC_le|PhiC_lt|PhiC_bound|PhiC <|<= PhiC` found only USES of `PhiC` (as a constant in error
terms), NOT any upper bound.**  So `PhiC <= 100` must be proved here.

**Route:** `PhiC = (sum' k, k^2 * exp(-(k/4)))/2 + 8`, so it suffices to bound the series.  Split at
`k = k0`:

* finite part: `sum_{k<k0} k^2` -- computed by `norm_num`/`Finset.sum_range`, giving an explicit number;
* tail: for `k >= 1`, `exp(-(k/4)) <= 960/k^3` (from the Taylor bound `exp x >= x^5/120` with `x = k/4`,
  i.e. `exp(k/4) >= (k/4)^5/120 = k^5/122880`, so `exp(-k/4) <= 122880/k^5`, and
  `k^2 * 122880/k^5 = 122880/k^3`).  **Thus the tail is `<= 122880 * sum' k, 1/k^3 <= 122880 * zeta(3)`,
  and `zeta(3) <= 2` is available/derivable.**

**Alternatively, a cruder route avoiding `zeta`:** bound `exp(-(k/4)) <= 2^{-k}` for `k >= 3` fails
(`e^{-1/4} = 0.778 > 0.5`), but `exp(-(k/4)) <= (3/4)^k` holds for `k >= 1` since
`e^{1/4} = 1.284 < 4/3`; then `k^2 (3/4)^k` has a closed-form `tsum`.

**Next: prove `PhiC <= 100` (or any explicit bound `PhiC <= C_0`) via the geometric route
`exp(-(k/4)) <= (3/4)^k` for `k >= 1`, then `tsum k^2 r^k = r(1+r)/(1-r)^3` at `r = 3/4`.**

**Position:** `op6_reachable_fraction`'s LAST ingredient is a numeric upper bound on `PhiC`.  Everything
else (all estimates, `L_bounded`, the wrapper skeleton) is in place.  Build green at 229 declarations.

### 13.663 Round-634: the geometric step's STATEMENT compiles; its proof is the next fragment

Build green: **229 declarations, 7/7 OK, 0 sorries**.

**The key step is stated and well-formed:**

```lean
example (k : Nat) (hk : 1 <= k) : Real.exp (-((k:Real)/4)) <= ((3:Real)/4)^k
```

**Proof route (recorded):** `e^{-k/4} <= (3/4)^k` is equivalent to `(4/3)^k <= e^{k/4}`, and
`e^{k/4} = (e^{1/4})^k` (`Real.exp_nat_mul`), so it suffices that `4/3 <= e^{1/4}`
(`Real.exp_one_div_four_gt`-style, or `Real.exp_pos` + `Real.one_lt_exp_iff` with `1/4 > 0` and
`norm_num` giving `e^{1/4} >= 1 + 1/4 = 5/4 > 4/3`).

**Then:** `sum' k, k^2 * (3/4)^k = r(1+r)/(1-r)^3` at `r = 3/4`, i.e. `84`, so
`PhiC <= 84/2 + 8 = 50 <= 100`.

**Hmm -- one subtlety:** `Real.exp x >= 1 + x` gives `e^{1/4} >= 5/4 = 1.25`, but `4/3 = 1.333 > 1.25`,
so the LINEAR Taylor bound is insufficient.  **Use the quadratic or cubic term:**
`e^{1/4} >= 1 + 1/4 + (1/4)^2/2 = 1.28125` -- still below `4/3`.  **The cubic term:
`1 + 1/4 + 1/32 + 1/384 = 1.314...` -- still below.**  **The quartic:
`+ 1/6144 = 1.31445` -- still below.**  **The quintic:
`+ 1/122880 = 1.314538` -- still below `1.3333`.**  **The ninth term is needed**
(`1/4^9/9! ~ 4e-9`), so use `Real.exp_bound` or `Real.sum_le_exp` with enough terms, or prove
`e^{1/4} >= 4/3` numerically via `Real.exp_one_div_four_gt`.

**Alternative avoiding this entirely: use `(7/8)^k` instead of `(3/4)^k`** -- `e^{-1/4} = 0.7788 < 7/8 = 0.875`
holds, and `sum' k, k^2 (7/8)^k = r(1+r)/(1-r)^3` at `r = 7/8` is `7*15/8/ (1/8)^3 = 105*512/8 = 6720`,
so `PhiC <= 6720/2 + 8 = 3368` -- **a larger but still explicit constant**, and `e^{1/4} <= 8/7 = 1.1428`
is TRUE with `Real.exp_le_one_add`-type bounds (`e^{1/4} <= 1/(1 - 1/4) = 4/3` is too weak; but
`e^{1/4} <= 1 + 1/4 + ... ` easy).

**Next: derive `exp(-(k/4)) <= (7/8)^k` for `k >= 1` (needs only `e^{1/4} <= 8/7`, i.e. a few Taylor
terms), then the `tsum` closed form, giving `PhiC <= 3368`.**

### 13.664 Round-635: the `(7/8)^k` bound compiles except two API details

Build green: **229 declarations, 7/7 OK, 0 sorries**.

**The proof is written:**

```lean
lemma exp_neg_quarter_le_tmp (k : Nat) : Real.exp (-((k:Real)/4)) <= ((7:Real)/8)^k := by
  have h1 : (8:Real)/7 <= Real.exp (1/4) := by
    have := Real.add_one_le_exp (1/4 : Real)   -- 1 + x <= exp x
    linarith                                    -- 1 + 1/4 = 1.25 > 8/7 = 1.1428
  have h2 : ((8:Real)/7)^k <= (Real.exp (1/4))^k := pow_le_pow_left₀ (by norm_num) h1 k
  have h3 : (Real.exp (1/4))^k = Real.exp ((k:Real)/4) := by rw [← Real.exp_nat_mul]; congr 1; ring
  rw [h3] at h2
  ...
```

**The LINEAR Taylor bound SUFFICES for `8/7`** (`1.25 > 8/7 = 1.1428`), unlike the `4/3` route --
**this is why `7/8` was the right choice.**

**Two errors:**

* **21** -- `Unknown identifier inv_le_inv_of_le` -- the correct name is
  **`one_div_le_one_div_of_le`** or `inv_le_inv_of_le'`/`inv_le_inv₀`;
* **23** -- the `calc`'s first step: `Real.exp (-(↑k/4)) = (Real.exp (↑k/4))⁻¹` needs
  `Real.exp_neg` applied as `rw [Real.exp_neg]` BEFORE the `calc`, not as a `ring_nf; rfl`.

**Next: use `one_div_le_one_div_of_le` (or rewrite `^k` as repeated `inv_mul`), and replace the `calc`'s
first step by `Real.exp_neg`.**

### 13.665 Round-636: `one_div_le_one_div_of_le`'s argument type; two errors

Build green: **229 declarations, 7/7 OK, 0 sorries**.

**Two errors:**

* **20** -- `one_div_le_one_div_of_le (by positivity) h2` -- TYPE MISMATCH: the lemma's form is
  `one_div_le_one_div_of_le (h : 0 < a) (hle : a <= b) : 1/b <= 1/a` (note the ARGUMENT ORDER is
  reversed in the conclusion), so `positivity` must supply `0 < (8/7)^k`, and the goal
  `(exp (k/4))⁻¹ <= ((8/7)^k)⁻¹` matches with `a = exp (k/4)`, `b = (8/7)^k`.  **Use
  `one_div_le_one_div_of_le (Real.exp_pos _) h2`** and check the goal's orientation;
* **23** -- `rw [inv_pow]` does not match `((8/7)^k)⁻¹`: the pattern is `?a⁻¹ ^ ?n`, but the goal has
  `((8/7)^k)⁻¹`.  **Use `rw [← inv_pow]`** or `field_simp`/`norm_num` directly.

**Next: fix the two `inv` argument orders.**

**Position:** the `PhiC` bound's key step (rounds 634-636).  Build green at 229 declarations.
`one_div_le_one_div_of_le` is `Mathlib.Algebra.Order.Field.Basic`; the alternative
`inv_le_inv_of_le`/`inv_le_inv₀` may have the orientation I want.

### 13.666 **LANDED (round 637): `exp_neg_quarter_le`** -- 230 declarations

`Op56/PhiThird.lean` now has **230 declarations** (0 sorries, 7/7 OK, 0 axioms), newly:

```lean
lemma exp_neg_quarter_le (k : Nat) : Real.exp (-((k:Real)/4)) <= ((7:Real)/8)^k
```

**Proof:** `8/7 <= exp(1/4)` from the LINEAR Taylor bound `1 + x <= exp x` at `x = 1/4`
(**`1.25 > 8/7`** -- this is why `7/8` was chosen over `3/4`, where the linear bound is insufficient);
`pow_le_pow_left₀`; `(exp(1/4))^k = exp(k/4)` by `Real.exp_nat_mul`; then `inv_le_inv₀` (with the `↔`
rewrite putting the goal in the `b <= a` form) and `← inv_pow`.

**Two API details fixed this round:** `inv_le_inv₀` used as a `↔` (`rw [inv_le_inv₀ ha hb]` then `exact`),
and `← inv_pow` (not `inv_pow`).

**This is the `PhiC` bound's hard step.**  What remains for `PhiC <= C`: the `tsum` closed form
`sum' k, k^2 r^k = r(1+r)/(1-r)^3` at `r = 7/8` giving `3368`, so `PhiC <= 3368`.

**Next: prove `PhiC <= 3368` (or `<= 10000` for headroom) using `exp_neg_quarter_le`, `tsum` comparison,
and the closed form `sum' k, k^2 (7/8)^k = 6720`.**

### 13.667 Round-638: the `tsum` API for `sum' k, k^2 r^k`

Build green: **230 declarations, 7/7 OK, 0 sorries**.

**Relevant Mathlib API found:**

* `hasSum_pow_mul_geometric_of_norm_lt_one` (`Mathlib/Analysis/SpecificLimits/Normed.lean:639`) -- the
  closed form for `sum' k, k^n * r^k`-type series;
* `hasSum_geom_series_inverse`, `tsum_pow_mul_one_sub`, `hasSummableGeomSeries_iff_summable_pow`.

**Rather than the exact closed form `6720`, a CHEAPER bound suffices** since any explicit `PhiC <= C`
works: bound `k^2 r^k` termwise by a geometric sequence.  With `r = 7/8`,

```
k^2 * r^k <= r^(k/2)   for k large,
```

or more robustly split at `k = 400`: for `k >= 400`, `k^2 <= (1/r)^(k/2)` (since `(8/7)^(k/2)` grows
exponentially while `k^2` is polynomial), giving `k^2 r^k <= r^(k/2)`; then
`sum' k, r^(k/2) <= sum' k, (sqrt r)^k = 1/(1 - sqrt(7/8))` -- also explicit.

**Simplest documented route:** use `hasSum_pow_mul_geometric_of_norm_lt_one` for the exact `6720`, or
`Summable` + `Finset.sum_le_tsum` with a finite prefix and the tail bound above.

**Next: land `PhiC <= 3368` via `exp_neg_quarter_le` + the geometric `tsum` bound, then the wrapper.**

**Position:** 230 declarations, 7/7 green.  `op6_reachable_fraction` = `PhiC` bound + 3 thresholds +
`isBigO_iff`.  All estimates are landed.

### 13.668 Round-639: the `PhiC` bound's skeleton; `tsum_le_tsum` not in scope

Build green: **230 declarations, 7/7 OK, 0 sorries**.

**The proof skeleton is written:**

```lean
have hsum : (sum' k, (k:Real)^2 * Real.exp (-((k:Real)/4))) <= (sum' k, (k:Real)^2 * ((7:Real)/8)^k) := by
  apply tsum_le_tsum
  · intro k; exact mul_le_mul_of_nonneg_left (exp_neg_quarter_le k) (sq_nonneg _)
  ...
have hclosed : (sum' k, (k:Real)^2 * ((7:Real)/8)^k) = 6720 := by ...
unfold PhiC; rw [hclosed] at hsum; linarith
```

**Error: `Unknown identifier tsum_le_tsum`** -- the comparison lemma for `tsum` has another name/namespace.
**Candidates: `Summable.tsum_le_tsum`, `tsum_le_tsum_of_nonneg`, `ENNReal.tsum_le_tsum`, or use
`Summable.of_nonneg_of_le` + `tsum_le_tsum_of_hasSum`.**  Also `No goals to be solved` at `intro k`
suggests `apply tsum_le_tsum` already unified oddly.

**Also needed:** `hclosed`'s exact value via `tsum_pow_mul_geometric_of_norm_lt_one' 2` with `r = 7/8`
(the `stirlingSecond` sum evaluates to `r(1+r)/(1-r)^3 = 6720` by `norm_num`).

**Next: find the correct `tsum` comparison lemma name and close `hclosed` with
`tsum_pow_mul_geometric_of_norm_lt_one'`.**

**Position:** 230 declarations, 7/7 green.  `op6_reachable_fraction` = `PhiC` bound + 3 thresholds +
`isBigO_iff`.

### 13.669 Round-640: `tsum_le_tsum` exists only for `ENNReal`; use `Summable.tsum_le_tsum`

Build green: **230 declarations, 7/7 OK, 0 sorries**.

**Search: the only `tsum_le_tsum` found is `ENNReal.tsum_le_tsum` (protected,
`InfiniteSum/ENNReal.lean:116`)**, which does not apply to `Real`-valued series.

**For `Real`, the comparison lemmas are in `Summable`-form** -- e.g.
`Summable.tsum_le_tsum : Summable f -> Summable g -> (forall n, f n <= g n) -> sum' f <= sum' g`,
or `tsum_le_tsum_of_nonneg`/`Summable.of_nonneg_of_le`.  **Exact names to try:**
`Summable.tsum_le_tsum`, `tsum_le_tsum_of_nonneg`, `sum_le_tsum`.

**Also:** since both sides are `tsum` of NONNEGATIVE terms and the pointwise comparison is proved,
`Summable.of_nonneg_of_le`/`Summable.of_nonneg_of_le` variants carry BOTH summability and the comparison.

**Next: use `Summable.tsum_le_tsum` (or the `of_nonneg_of_le` form), then `hclosed` via
`tsum_pow_mul_geometric_of_norm_lt_one' 2`.**

**Position:** 230 declarations, 7/7 green.  One comparison lemma name and one closed form away from
`PhiC <= 3368`, then the three thresholds and the wrapper.

### 13.670 Round-641: **Mathlib already HAS an `exp_neg_quarter_le`** -- with a different statement

Build green: **230 declarations, 7/7 OK, 0 sorries**.

**The error is decisive:**

```
The argument exp_neg_quarter_le ↑k has type
  1 / 4 ≤ ↑k → Real.exp (-↑k) ≤ 4 / 5
```

**So a Mathlib (or earlier-file) `exp_neg_quarter_le` exists and my reference resolved to IT, not to the
`Op56.exp_neg_quarter_le` landed at round 637.**  **Fix: qualify as `Op56.exp_neg_quarter_le`, or rename
mine to avoid the clash (e.g. `Op56.exp_neg_quarter_le_seven_eighths`).**

**Second error: `hsum_le_tsum_of_nonneg` unknown.**

**Recorded next step: (a) qualify/rename the landed lemma; (b) find the correct `tsum` comparison name --
candidates `tsum_le_tsum_of_nonneg`, `Summable.tsum_le_tsum`, `summable_of_nonneg_of_le`.**

**Next: fix the shadowing, then the comparison lemma name.**

**Position:** 230 declarations, 7/7 green.  `PhiC` bound's two remaining hurdles: a name collision and a
comparison lemma.  Then 3 thresholds and the wrapper.

### 13.671 Round-642: `Order.lean` has no `tsum_le`; the comparison is elsewhere

Build green: **230 declarations, 7/7 OK, 0 sorries**.

**`Mathlib/Topology/Algebra/InfiniteSum/Order.lean` (420 lines) contains NO `tsum_le`/`sum_le_tsum`/
`of_nonneg_of_le`.**  The earlier repo-wide grep showed `tsum_le_tsum` USED in
`Mathlib/Analysis/SpecificLimits/Basic.lean` and `Mathlib/Analysis/SpecialFunctions/Trigonometric/Series.lean`
-- so the lemma's home is likely `Mathlib/Topology/Algebra/InfiniteSum/Basic.lean` (as
`Summable.tsum_le_tsum` or `tsum_le_tsum`), or `Mathlib/Analysis/SpecificLimits/Basic.lean`.

**Next: grep those two files for the exact binder name, then APPLY it in the `PhiC` bound (with
`Op56.exp_neg_quarter_le` qualified to defeat the Mathlib namesake).**

**Position:** 230 declarations, 7/7 green at every boundary.  The `PhiC` bound needs (a) the qualified
reference and (b) this comparison lemma; then `hclosed` via `tsum_pow_mul_geometric_of_norm_lt_one' 2`,
then 3 thresholds and the wrapper.

### 13.672 Round-643: **there is NO `Real`-valued `tsum_le_tsum`** -- the `ENNReal` route is required

Build green: **230 declarations, 7/7 OK, 0 sorries**.

**`ENNReal.tsum_le_tsum` is USED even inside `Mathlib/Analysis/SpecificLimits/Basic.lean:661`** -- i.e.
Mathlib itself lifts to `ENNReal` for `tsum` comparisons.  **No `Real`-valued `tsum_le_tsum` exists in the
tree** (repo-wide grep found the identifier only in `ENNReal.lean` and as USES elsewhere).

**The route for `Real`:**

```lean
have h1 : ENNReal.ofReal (sum' k, f k) = sum' k, ENNReal.ofReal (f k) :=
  ENNReal.ofReal_tsum_of_nonneg (fun k => ...)   -- needs `Summable` of the ofReal series
have h2 : (sum' k, ENNReal.ofReal (f k)) <= (sum' k, ENNReal.ofReal (g k)) :=
  ENNReal.tsum_le_tsum (fun k => ENNReal.ofReal_le_ofReal (hle k))
-- then ENNReal.ofReal_le_ofReal_iff + ofReal_tsum to descend
```

**Candidates for the lift: `ENNReal.ofReal_tsum_of_nonneg`, `ENNReal.tsum_ofReal`, or prove
`Summable f` and use `Summable.tsum_le_tsum` if it exists under a qualified name.**

**Next: try `Summable.tsum_le_tsum` (qualified) FIRST; if absent, use the `ENNReal.ofReal` route above.**

**Position:** 230 declarations, 7/7 green.  `PhiC` bound: (a) qualify `Op56.exp_neg_quarter_le`,
(b) `tsum` comparison, (c) `hclosed` via `tsum_pow_mul_geometric_of_norm_lt_one' 2`.  Then 3 thresholds +
wrapper.

### 13.673 Round-644: **`Summable.tsum_le_tsum` EXISTS** -- only its argument order differs

Build green: **230 declarations, 7/7 OK, 0 sorries**.

**The error is only about `hle`'s position:**

```
The argument hle has type
  forall k, k^2 * exp(-(k/4)) <= k^2 * (7/8)^k
```

**So `Summable.tsum_le_tsum` exists and takes MORE arguments before `hle`** -- most likely
`Summable.tsum_le_tsum (hf : Summable f) (hle : forall n, f n <= g n)` with `g`'s summability derived, or
`(hf : Summable f) (hg : Summable g) (hle : ...)`.

**Also applied: `Op56.exp_neg_quarter_le`** (qualified), which fixed the shadowing from round 641.

**Next: grep `Summable.tsum_le_tsum`'s exact binder list and apply it; then `hclosed` via
`tsum_pow_mul_geometric_of_norm_lt_one' 2`.**

**Position:** 230 declarations, 7/7 green.  Two API positions from `PhiC <= 3368`.

### 13.674 Round-645: **the exact binders of `Summable.tsum_le_tsum` and `Summable.of_nonneg_of_le`**

Build green: **230 declarations, 7/7 OK, 0 sorries**.

**`#check` output:**

```lean
Summable.tsum_le_tsum : (forall i, f i <= g i) -> Summable f -> Summable g -> sum' f <= sum' g
Summable.of_nonneg_of_le : (forall b, 0 <= g b) -> (forall b, g b <= f b) -> Summable f -> Summable g
```

**So `hle` comes FIRST (not last, as I assumed), and `of_nonneg_of_le` derives the SMALLER series'
summability from the LARGER's.**  Applied to the `PhiC` bound with
`f = fun k => k^2 (7/8)^k` (larger) and `g = fun k => k^2 exp(-k/4)` (smaller):

```lean
have hg : Summable (fun k : Nat => (k:Real)^2 * Real.exp (-((k:Real)/4))) :=
  Summable.of_nonneg_of_le (fun k => mul_nonneg (sq_nonneg _) (Real.exp_pos _).le)
    (fun k => mul_le_mul_of_nonneg_left (Op56.exp_neg_quarter_le k) (sq_nonneg _)) hf
exact Summable.tsum_le_tsum (fun k => mul_le_mul_of_nonneg_left (Op56.exp_neg_quarter_le k) (sq_nonneg _)) hg hf
```

where `hf : Summable (fun k => k^2 (7/8)^k)` comes from the geometric series.

**Next: apply the two lemmas with the correct binder order, and close `hclosed` with
`tsum_pow_mul_geometric_of_norm_lt_one' 2`.**

**Position:** 230 declarations, 7/7 green.  `PhiC <= 3368` is one binder order + one closed form away;
then 3 thresholds and the wrapper.

### 13.675 Round-646: the `PhiC` bound's skeleton compiles except two steps

Build green: **230 declarations, 7/7 OK, 0 sorries**.

**Applied** (with the round-645 binders): `hbig` (geometric summability via
`hasSum_pow_mul_geometric_of_norm_lt_one 2`), `hle`, `hsmall`
(`Summable.of_nonneg_of_le hnn hle hbig`), `hsum` (`Summable.tsum_le_tsum hle hsmall hbig`), and
`hclosed` via `tsum_pow_mul_geometric_of_norm_lt_one 2`.

**Two errors:**

* **13** -- `convert h using 2 with n; push_cast; ring` gives "No goals to be solved" -- `convert` already
  closed it, so the `push_cast; ring` must be dropped (the recurring pattern);
* **21** -- `hclosed`'s `norm_num [Finset.sum_range_succ]` has unsolved goals: the `stirlingSecond` sum
  `sum j in range 3, S(2,j) j! r^j (1-r)^{-j-1}` needs evaluating at `r = 7/8`; **`norm_num` alone does
  not unfold `stirlingSecond`** -- supply `stirlingSecond_two` or use `decide`/`norm_num [stirlingSecond]`.

**Next: drop the extra `push_cast; ring`, and evaluate the `stirlingSecond` sum (or find the
`Stirling`-free closed form `r(1+r)/(1-r)^3`).**

**Position:** 230 declarations, 7/7 green.  `PhiC <= 3368` is two `norm_num`-level steps from landing;
then 3 thresholds and the wrapper.

### 13.676 Round-647: `stirlingSecond` is `Nat.stirlingSecond`; `hclosed` still open

Build green: **230 declarations, 7/7 OK, 0 sorries**.

**Applied:** the extra `push_cast; ring` dropped from `hbig` (fixing error 13).

**Error 23: `Unknown identifier stirlingSecond`** -- it is **`Nat.stirlingSecond`** (namespaced).

**Error 19/21: `hclosed` still unsolved.**  `tsum_pow_mul_geometric_of_norm_lt_one 2` at `r = 7/8` gives
`sum j in range 3, Nat.stirlingSecond 2 j * j.factorial * r^j * (1-r)^{-j-1}`; with the `Nat.` prefix and
`norm_num [Nat.stirlingSecond]` this should evaluate to `6720 = (7/8)(15/8)/(1/8)^3`.

**Alternative avoiding `stirlingSecond` entirely: prove `sum' k, (k:Real)^2 r^k = r(1+r)/(1-r)^3` directly
by differentiating the geometric series, or simply bound the sum crudely** (any explicit `C` suffices for
`PhiC <= C`, e.g. `sum' k, k^2 (7/8)^k <= sum' k, (15/16)^k * C'`).

**Next: use `Nat.stirlingSecond` + `norm_num`, or replace `hclosed` with a cruder explicit bound.**

**Position:** 230 declarations, 7/7 green.  `PhiC <= C` = one closed-form evaluation (or a crude bound),
then 3 thresholds and the wrapper.

### 13.677 **FALSIFICATION: `op5_nmin_asymptotic`'s `O(1/p)` is FALSE -- the truth is `O(1)`**

Build green: **230 declarations, 7/7 OK, 0 sorries**.

**The deliverable statement**

```lean
theorem op5_nmin_asymptotic :
    (fun p : Nat => (nmin p : Real) - nminAsym p) =O[atTop] (fun p : Nat => 1 / (p : Real))
```

**with `nminAsym p = p/log 2 - 5/2` (`Defs.lean:65`), is FALSE.**

**Numerical evidence** (direct evaluation of `Phi p n = sum' j, (1 + (j+1)/n)^{-p}` and
`nmin p` = least `N` with `Phi p (N+1) >= 1`, the `IsComplete_iff` characterisation):

| p | nmin p | p/log2 - 5/2 | difference | p*difference |
|---|---|---|---|---|
| 1000 | 1441 | 1440.1950 | 0.80496 | 805 |
| 2000 | 2883 | 2882.8901 | 0.10992 | 220 |
| 3000 | 4326 | 4325.5851 | 0.41488 | 1245 |
| 5000 | 7211 | 7210.9752 | 0.02480 | 124 |
| 10000 | 14425 | 14424.4504 | 0.54959 | 5496 |
| 20000 | 28852 | 28851.4008 | 0.59918 | 11984 |
| 50000 | 72133 | 72132.2520 | 0.74796 | 37398 |

**`p * (nmin p - nminAsym p)` is UNBOUNDED (it grows like `p`), so
`|nmin p - nminAsym p| = O(1/p)` fails by a factor of `p`.**

**The TRUE relation, verified at 40 decimal digits (mpmath) for 76 values of `p` with ZERO
mismatches:**

```
nmin p = ceil(p/log2 - 5/2),
```

i.e. **`0 < nmin p - nminAsym p < 1`**: `nmin p` is the CEILING of the continuous threshold.
(The gap is equidistributed in `(0,1)`; at `p = 1000` it is `0.80496`, at `p = 5000` it is
`0.02480` -- a Diophantine quantity, not an `O(1/p)` error.)

**Consequences.**

1. **The correct theorem is**

```lean
theorem op5_nmin_asymptotic :
    (fun p : Nat => (nmin p : Real) - nminAsym p) =O[atTop] (fun _ : Nat => (1 : Real))
```

   with the sharp form `0 <= (nmin p : Real) - nminAsym p /\ (nmin p : Real) - nminAsym p < 1`.

2. **The "discrete crossing alignment" that is absent from the library is therefore the CEILING
   ALIGNMENT**, not an `O(1/p)` identity: the continuous crossing point of `Phi_p` sits within
   `O(1/p)` of `p/log2 - 5/2`, and `nmin p` is its ceiling.

3. **The two-sided window inputs exist**: `Phi_window_low` (PhiThird:4787),
   `Phi_third_order_aux` (2653), `threshold_third_order_uniform` (4147), `threshold_u_range` (4476).

**This is a RETRACTION of the round-501/502 conclusion "blocked on absent mathematics": the
mathematics is not absent, the STATEMENT is wrong.**

### 13.678 **LANDED: `op5_nmin_asymptotic` PROVED (corrected to `O(1)`)** -- 2 of 3 targets done

Build green: **7/7 OK**.  `Asymptotic.lean` now has only ONE `sorry` tactic
(`op6_reachable_fraction`); `Exact.lean:118` keeps its pre-existing unused one.

**The theorem, corrected and proved:**

```lean
theorem op5_nmin_asymptotic :
    (fun p : Nat => (nmin p : Real) - nminAsym p) =O[atTop] (fun _ : Nat => (1 : Real)) := by
  rw [Asymptotics.isBigO_iff]
  refine ⟨11, ?_⟩
  ...
```

**The proof is SHORT and uses only landed lemmas:**

1. `Op56.log_nmin_close p hp6 hn hC1 hnK : |(nmin p : Real) * Real.log 2 - (p:Real)| <= 4`
   -- **this IS the discrete crossing alignment, in sharp form, and it was already landed**
   (round 588, 227 declarations);
2. `nmin_ge_p p hp6 : p <= nmin p` gives `2000000000 <= nmin p` and `K <= nmin p` eventually;
3. `Nat.le_ceil` + `push_cast` give `3*PhiC <= 2p` and `10^40*((2*PhiC+1)^2+1) <= nmin p`
   **eventually, with no `PhiC` upper-bound lemma needed**;
4. `field_simp; ring` turns `nmin p - nminAsym p` into
   `((nmin p)*log2 - p)/log2 + 5/2`;
5. `abs_add_le`, `abs_div`, `abs_of_pos`, `div_le_div_of_nonneg_right`, and
   `log_two_ge_half` give the constant `4/log2 + 5/2 <= 8 + 5/2 = 10.5 < 11`.

**Two corrections made to the file:** `open Filter` added (for `filter_upwards`), and
`log_nmin_close` referenced as `Op56.log_nmin_close` (it lives in `PhiThird`'s SECOND
`Op56` block).

**NOTE on axioms:** `#print axioms Op56.op5_nmin_asymptotic` lists `propext`,
`Classical.choice`, `Quot.sound` plus `native_decide` axioms inherited from
`Op56.tsum_pow6_exp_neg_half_le` in `PhiThird.lean` (pre-existing; `op5_threshold_asymptotic`
has the same).  **No `axiom` declaration was added.**  Worth a separate pass if the
"no axiom" requirement is read as excluding `native_decide`.

**Remaining:** `op6_reachable_fraction` (its `PhiC` upper bound `PhiC <= 3368` is in flight at
`/tmp/w2090.lean`, needing only the `hclosed` evaluation `sum' k, k^2 (7/8)^k = 6720`), and the
pre-existing `Exact.lean:118`.

### 13.679 **LANDED: `PhiC_le : PhiC <= 3368`** -- 231 declarations, 7/7 green

Build green: **7/7 OK**.  `Op56/PhiThird.lean` now has **231 declarations** (0 sorries), newly:

```lean
lemma PhiC_le : PhiC <= 3368
```

**Proof chain (all landed):**

1. `Op56.exp_neg_quarter_le k : Real.exp (-(k/4)) <= (7/8)^k` -- valid because
   `8/7 <= exp(1/4)` follows from the LINEAR Taylor bound `1 + x <= exp x` (**`1.25 > 8/7 = 1.1428`**;
   the `3/4` route needs the ninth Taylor term and was abandoned);
2. `Summable.of_nonneg_of_le` derives summability of the `exp` series from the geometric one;
3. `Summable.tsum_le_tsum hle hsmall hbig` (**note the binder order: `hle` FIRST**) gives
   `sum' k, k^2 exp(-k/4) <= sum' k, k^2 (7/8)^k`;
4. `tsum_pow_mul_geometric_of_norm_lt_one 2` at `r = 7/8` evaluates to
   `r(1+r)/(1-r)^3 = 840` (**not 6720 -- that was an arithmetic slip, corrected this round**);
5. hence `PhiC = (sum' ...)/2 + 8 <= 840/2 + 8 = 428 <= 3368`.

**Two `#check`-resolved API facts:** `Summable.tsum_le_tsum (hle) (hf) (hg)` and
`Nat.stirlingSecond` (the `Nat.` namespace).

**Remaining for `op6_reachable_fraction`:** only the `IsBigO` wrapper.  It now has
everything: `L_bounded` (round 623), `PhiC_le` (this round), `nmin_ge_p` for the eventual range
hypotheses, and the `Asymptotics.isBigO_iff` unfolding (found at `Asymptotics/Defs.lean:96`,
needs `open Asymptotics`).

### 13.680 **OBJECTIVE ACHIEVED: all three `Asymptotic.lean` theorems PROVED** -- 7/7 green

Build green: **7/7 `[check] OK`**.  **`Op56/Asymptotic.lean` contains ZERO `sorry` tactics.**

| theorem | status |
|---|---|
| `op5_threshold_asymptotic` (line 182) | PROVED |
| `op5_nmin_asymptotic` (line 232) | **PROVED this session** (statement corrected to `O(1)`) |
| `op6_reachable_fraction` (line 287) | **PROVED this session** |

**`op6_reachable_fraction`'s proof** (the last piece): `Asymptotics.isBigO_iff`, constant `1000`,
`filter_upwards` at
`max 5052 (max 2000000000 (10^40 * ((2*3368+1)^2 + 1)))`, then
`Op56.L_bounded p hp16 hn hlarge hnK` with
`hn` from `nmin_ge_p`, `hlarge` from `PhiC_le` (`3*3368 = 10104 <= 2*5052`), and
`hnK` from `nmin_ge_p` + `PhiC_le` + `pow_le_pow_left₀` (the squaring monotonicity that
`nlinarith` could not see on its own).

**Evidence gathered:**

1. `grep -rn '^\s*sorry\s*$' Op56/` -- **exactly one**: `Op56/Exact.lean:118`, which is the
   PRE-EXISTING documented negative result (`tailSum_integral_lower`, the antitone integral test
   that is deliberately insufficient; **used nowhere**).  `Asymptotic.lean`: none.
2. `grep -rn '^\s*axiom\s' Op56/` -- **NONE**; no `axiom` declaration exists anywhere.
3. `./check.sh --all` -- **7 `[check] OK`**.
4. `#print axioms` -- `propext`, `Classical.choice`, `Quot.sound`, plus **`native_decide`** axioms
   inherited from `Op56.tsum_pow6_exp_neg_half_le` in `PhiThird.lean` (PRE-EXISTING;
   `op5_threshold_asymptotic` has the same).  **No new axiom was introduced.**

**Remaining gap, if "no sorry" is read project-wide rather than per-file:** `Exact.lean:118`.
It is out of `Asymptotic.lean`'s scope and is a documented deliberate omission, not an open step.

### 13.681 Immediate next action

> **CORRECTION (added after 13.680).**  This entry is **stale**: it was written before
> the final round and is superseded by §13.680 above.  All three `Asymptotic.lean`
> theorems are proved, `./check.sh --all` is 7/7 green, and the only `sorry` remaining
> is the deliberately-unused `tailSum_integral_lower` (`Op56/Exact.lean:118`).  The
> paragraph below is retained as the historical record of the pre-final state.

Still `phi_term_sharp3` as 3–4 sub-lemmas, but now with the corrected bookkeeping of
§13.1: build the termwise identity as `G(ε)·(1 + h)` and keep the `G` factor with the
`y - z` piece throughout. The `eps` bounds available are
`0 ≤ eps ≤ u k⁴/(4n³)` (from `phi_d_bounds` + `phi_r4_bounds`), and the `x³`-coefficient
must be read off the *cubic* log bound, the `x⁴` one off `phi_r4_bounds`.
