# HANDOFF — OP-5/OP-6 Lean formalisation (current state)

**Directory** `research/twin-prime-parity/006/`
**Lean** `research/twin-prime-parity/006/lean/`
**Toolchain** Lean 4 `v4.35.0-rc2` + Mathlib at `$LEAN_PREFIX/mathlib4` (default `$LEAN_PREFIX = $HOME/lean`)
**Status** **COMPLETE** — all three asymptotic theorems proved; `./check.sh --all` → **9/9 OK**
(updated after the OPTODO passes: the development has since grown `FloorAsymptotic.lean` (O11)
and `PhiFourth.lean` (O10))
**Last verified** 9/9 `[check] OK`; **0 `sorry` anywhere** in the development; **0 `axiom` declarations**; **0 `native_decide`**

> This file records **only the current state**. Superseded claims, abandoned routes and the
> round-by-round development log have been removed. Where a correction is itself a result (the OP-5
> index form, §5) it is stated as a fact, not as history. The removed log is preserved at
> [`../open/HANDOFF.md`](../open/HANDOFF.md) — the single canonical copy — if the archaeology
> is ever needed.

---

## 1. The objective, verbatim

> Complete the OP-5/OP-6 Lean formalisation in `research/twin-prime-parity/open/lean`: prove
> `op5_threshold_asymptotic`, `op5_nmin_asymptotic` and `op6_reachable_fraction` in
> `Asymptotic.lean` with no `sorry` and no `axiom`, keeping `./check.sh --all` green. Follow the plan
> in `research/twin-prime-parity/open/HANDOFF.md` §7 (third-order expansion of Phi, Brown/threshold
> bridge, OP-6 composition), landing lemmas incrementally and never leaving a `sorry` in the
> deliverable file.

**All four clauses are met.** One clause required an amendment, agreed with the requester: the
statement of `op5_nmin_asymptotic` was **false as written** and was corrected from an `O(1/p)` to an
`O(1)` error term before being proved. See §5.

---

## 2. TL;DR state

| Part of the objective | Status |
|---|---|
| `op5_threshold_asymptotic` | ✅ **PROVED** |
| `op5_nmin_asymptotic` | ✅ **PROVED** — after **restating** it with the correct `O(1)` error (§5) |
| `op6_reachable_fraction` | ✅ **PROVED** |
| `./check.sh --all` green | ✅ **9/9** |
| No `axiom` declaration | ✅ none anywhere in the development |
| No `sorry` in the deliverable file (`Asymptotic.lean`) | ✅ 0 |
| No `sorry` anywhere | ✅ **0** — the last one (`Exact.lean`, `tailSum_integral_lower`) was discharged by repairing its hypothesis to `N + 2 ≤ M` and proving it (§6.1) |
| No `native_decide` in the axiom footprint | ✅ **none** — removed in item `O2` (§6.2) |

```
./check.sh --all        →  9/9 [check] OK
axiom declarations      →  none
Asymptotic.lean         →   8 declarations, 0 sorries      <-- the deliverable
PhiThird.lean           → 231 declarations, 0 sorries
PhiAsymptotic.lean      →  67 declarations, 0 sorries
Exact.lean              →  23 declarations, 0 sorries (incl. the former sorry, now proved)
Census.lean             →   3 declarations, 0 sorries
Defs.lean               →  11 declarations, 0 sorries
FloorAsymptotic.lean    →   the floor-asymptotic meta-theorem (O11), 0 sorries
PhiFourth.lean          →   the fourth-order auxiliary layer (O10), 0 sorries
total                   → 342+ declarations
```

---

## 3. How to build and verify

There is **no `lake` project file**. The build is a script that reconstructs `LEAN_PATH` from
`lake env` inside a Mathlib checkout and elaborates each module with `-R`/`-o` so that
`import Op56.X` resolves.

```bash
cd research/twin-prime-parity/006/lean
./check.sh --all                      # Defs, Exact, Census, PhiAsymptotic, PhiThird, Asymptotic, root
./check.sh Op56/PhiThird.lean         # one module
LEAN_PREFIX=/path/to/lean ./check.sh --all
```

Cold run: roughly 3–5 minutes for all seven modules.

For scratch files (outside the module tree):

```bash
HERE=/Users/victor/workspace/rh/research/twin-prime-parity/006/lean
BASE=$(cd $HOME/lean/mathlib4 && ELAN_HOME=$HOME/lean/elan $HOME/lean/elan/bin/lake env printenv LEAN_PATH)
LEAN_PATH="$HERE:$BASE" $HOME/lean/elan/toolchains/leanprover--lean4---v4.35.0-rc2/bin/lean /tmp/scratch.lean
```

To confirm the axiom footprint:

```lean
import Op56.Asymptotic
#print axioms Op56.op5_threshold_asymptotic
#print axioms Op56.op5_nmin_asymptotic
#print axioms Op56.op6_reachable_fraction
```

**Conventions.** Never `axiom`. The deliverable file is kept at 0 `sorry` at every round boundary: if a
lemma does not compile, it is **removed**, not left with `sorry`.

---

## 4. File map and key objects

```
research/twin-prime-parity/006/
  index.html                 the paper (self-contained, no external links)
  handoff.md                 this file
  lean/
    check.sh                 build script (--all lists Defs Exact Census PhiAsymptotic PhiThird Asymptotic Op56)
    README.md                module table + status rows
    Op56.lean                umbrella import
    Op56/Defs.lean        ( 11 decl) term budget tailSum IsComplete Phi IsThreshold IsReachable
                                    reachableSet nminAsym thresholdAsym LAsym
    Op56/Exact.lean       ( 23 decl) discrete layer; 0 sorries (the former one proved)
    Op56/Census.lean      (  3 decl) census_measure_eq, census_ratio
    Op56/PhiAsymptotic.lean (67 decl) first- and second-order asymptotics of Phi
    Op56/PhiThird.lean    (231 decl) third-order layer + the whole OP-6 estimate chain
    Op56/Asymptotic.lean  (  8 decl) the three asymptotic theorems        <-- the deliverable
  notes/
    OP-05-nmin-asymptotic.md      the OP-5 problem statement (with correction banner)
    OP-06-reachable-fraction.md   the OP-6 problem statement
    linarith-agent-prompt.md      the arithmetic-tactic discipline used
    HANDOFF.md                    the full development log (superseded by this file for state)
  verify/
    op05_nmin_ceiling.py          falsification of O(1/p) + the exact ceiling law  (§5)
    op05_nmin.py                  numerical ground truth for c5
    op06_reachable_fraction.py    numerical ground truth for c6
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

**Indexing.** The notes are 1-based; Lean is 0-based. The bridge is
`n_min^{1-based} = nmin + 1`, which is why the constant is `−5/2` in Lean and `−3/2` in the notes.
`meas(S_1) = 2^{nmin p} * tailSum p (nmin p)`.

### The two `Op56` namespace blocks in `PhiThird.lean` — read this before editing

`PhiThird.lean` contains **two sibling `namespace Op56` blocks**: one opening at **line 43** and a
second at **line 5988**. Declarations in the second block are reached *from outside the file* as
**`Op56.Op56.<name>`**, not `Op56.<name>`. This is not a redundancy to remove — the Lean linter warns
about it (`linter.dupNamespace`) but the nesting is genuine and flattening it breaks the build.

The 40 affected declarations:

```
Op56.Op56.{L_bounded_abstract, L_bounded, L_decomp, PhiC_le,
           budget_lower, budget_upper, exp_neg_quarter_le, log_abs_one_add_le,
           log_budget_close, log_nmin_close, log_ratio_close, log_tailSum_close,
           log_tailSum_lower, log_tailSum_upper, nmin_K_bounds, nmin_hwK',
           nmin_ratio_close, nmin_upper_sharp_p, nmin_w_lower2x_p, nmin_w_sharp,
           nmin_w_stage1', nmin_window_high, nmin_window_low, nmin_wp_lower,
           stage2_lower_sharp_exp2, stage2_lower_sharp_exp, stage2_lower_sharp,
           stage2_upper_exp, stage2_upper_sharp_exp, stage2_upper_sharp,
           stage2_upper, tail2_le, tailSum_lower, tailSum_upper, uPhiS_le,
           uPhiS_lower_sharp3, uPhiS_lower_sharp, uPhiS_sharp,
           w_lower_from_exp, w_upper_from_exp}
```

Inside the file, unqualified names work. In `Asymptotic.lean` they must be qualified — e.g. the OP-5
index-form proof calls `Op56.log_nmin_close` and `Op56.PhiC_le`.

---

## 5. The three theorems, and the OP-5 correction

### 5.1 `op5_threshold_asymptotic` — PROVED

```lean
theorem op5_threshold_asymptotic (Pfun : ℕ → ℝ)
    (hP : ∀ n : ℕ, IsThreshold n (Pfun n)) :
    (fun n : ℕ => Pfun n - thresholdAsym n) =O[Filter.atTop]
      (fun n : ℕ => 1 / ((n : ℝ) + 1) ^ 2)
```

with `thresholdAsym n = (n + 3/2)·log 2 + c/n`, `c = 3(log 2)² − (25/12)log 2 = −0.0026975844…`.

The analytic input is **`threshold_third_order_uniform`**, a uniform third-order expansion
`Φ_{un}(n) = (e^u−1)^{-1} + (u/2n)ΦS(u) + D(u)/n² + O(1/n³)`. The proof instantiates
`Pfun n = (Pfun n / n)·n`, extracts `u ∈ [1/2,1]` from `threshold_u_range`, converts the `1/n³`
error into the stated `1/(n+1)²` rate via `((n:ℝ)+1)² ≤ 4n²`, and closes with
`Asymptotics.IsBigO.of_bound (4C)`.

### 5.2 `op5_nmin_asymptotic` — CORRECTED, then PROVED

**The recorded statement was false.** It read

```
n_min(p) = p/log 2 − 3/2 + O(1/p)          i.e.   nmin p − nminAsym p = O(1/p).
```

`nmin p` is a natural number, so an `O(1/p)` error says that `p/log 2 − 5/2` lies within `C/p` of an
integer for every large `p`. Since `{p/log 2}` is equidistributed, that can hold only on a
density-zero set of `p`. The statement is false on arithmetical grounds alone.

Measured directly (`Φ_p(n) = Σ_{j≥0}(1+(j+1)/n)^{-p}`; `nmin p` = least `N` with `Φ_p(N+1) ≥ 1`):

| p | nmin p | p/log2 − 5/2 | gap | p·gap |
|---|---|---|---|---|
| 1000 | 1441 | 1440.195041 | 0.804959 | 804.96 |
| 2000 | 2883 | 2882.890082 | 0.109918 | 219.84 |
| 5000 | 7211 | 7210.975204 | 0.024796 | 123.98 |
| 10000 | 14425 | 14424.450409 | 0.549591 | 5495.91 |
| 20000 | 28852 | 28851.400818 | 0.599182 | 11983.64 |
| 50000 | 72133 | 72132.252044 | 0.747956 | 37397.78 |

`p·gap` grows like `p`. A wider sweep (76 values, `p = 200…3000`) found **zero** mismatches of

```
nmin p = ⌈p/log 2 − 5/2⌉,        so 0 < nmin p − (p/log 2 − 5/2) < 1,
```

confirmed at 40 decimal digits for `p = 1000, 5000, 12345, 30000`. **The correct error term is
`O(1)`, and no sharper.** The gap is a Diophantine quantity carried by `{p/log 2}`, not an error that
can be made small.

**The corrected theorem, proved:**

```lean
theorem op5_nmin_asymptotic :
    (fun p : ℕ => (nmin p : ℝ) - nminAsym p) =O[atTop] (fun _ : ℕ => (1 : ℝ))
```

The proof is short because the sharp discrete-crossing alignment was **already in the library**:

```lean
have h := Op56.log_nmin_close p hp6 hn hC1 hnK
-- h : |(nmin p : ℝ) * Real.log 2 - (p : ℝ)| ≤ 4

have h2 : (nmin p : ℝ) - nminAsym p
    = ((nmin p : ℝ) * Real.log 2 - (p : ℝ)) / Real.log 2 + 5/2 := by
  unfold nminAsym; field_simp; ring
rw [abs_one, mul_one, h2]
calc |((nmin p : ℝ) * Real.log 2 - (p : ℝ)) / Real.log 2 + 5/2|
    ≤ |((nmin p : ℝ) * Real.log 2 - (p : ℝ)) / Real.log 2| + |(5/2 : ℝ)| := abs_add_le _ _
  _ = |((nmin p : ℝ) * Real.log 2 - (p : ℝ)) / Real.log 2| + 5/2 := by
      rw [abs_of_nonneg (by norm_num : (0:ℝ) ≤ 5/2)]
  _ ≤ 4 / Real.log 2 + 5/2 := by
      rw [abs_div, abs_of_pos hL]
      linarith [div_le_div_of_nonneg_right h (le_of_lt hL)]
  _ ≤ 11 := by
      have h8 : 4 / Real.log 2 ≤ 8 := by rw [div_le_iff₀ hL]; linarith
      linarith
```

with constant **`11 = 8 + 5/2`** (from `4/log 2 ≤ 8` and `1/2 ≤ log 2`). The three eventual range
hypotheses (`2000000000 ≤ nmin p`, `3·ΦC ≤ 2p`, `10^40((2ΦC+1)²+1) ≤ nmin p`) come from
`nmin_ge_p : p ≤ nmin p` plus `Nat.le_ceil` at explicit thresholds — **no upper bound on `ΦC` is
needed for this theorem**.

> **Retraction.** An earlier internal diagnosis held that this theorem was *blocked on mathematics
> absent from the library* (specifically a discrete crossing alignment
> `|Φ_p(nmin) − 1| = O(1/n²)`, judged non-derivable from the continuous estimates available). That
> diagnosis was **wrong**. The sharp alignment `|nmin p · log 2 − p| ≤ 4` was present in the
> development; it is a *ceiling* statement, not a `1/n²` statement; and once the theorem's
> **statement** was corrected, the proof followed from already-landed lemmas.

### 5.3 `op6_reachable_fraction` — PROVED

```lean
theorem op6_reachable_fraction :
    (fun p : ℕ => L p - LAsym p) =O[atTop] (fun _ : ℕ => (1 : ℝ))
```

Equivalently `L(p) = p log p − (1 + log log 2)p + O(1)`, i.e.
`measure(S_1)/P(p) = p^{−p} e^{(1+log log 2)p}(1+o(1)) → 0`.

The proof is a chain of bounded-precision estimates. From

```lean
theorem L_decomp (p) (hp : 2 ≤ p) :
    L p = -((nmin p : ℝ)) * Real.log 2 - Real.log (tailSum p (nmin p)) + Real.log (budget p)
```

one writes `L p − LAsym p` as four pieces, each bounded with an explicit constant by a landed lemma:

| Piece | Lemma (as `Op56.Op56.*`) | Constant |
|---|---|---|
| `log(budget p) + p log 2` | `log_budget_close` | `log 3` |
| `log(tailSum p N) + p log(2N)` | `log_tailSum_close` | `log 9` |
| `nmin p · log 2 − p` | `log_nmin_close` | `4` |
| `p · (log(2·nmin p/p) − (log 2 − log log 2))` | `log_ratio_close` | `300` |

Summing gives `|L p − LAsym p| ≤ log 3 + log 9 + 4 + 300 ≤ 1000`.

The assembly is split deliberately: **`L_bounded_abstract`** is stated with the four bracket bounds
as *hypotheses* and proves the arithmetic; **`L_bounded`** is its instantiation at `N = nmin p`,
`B = budget p`, `T = tailSum p (nmin p)`. The bracket lemmas rest on `budget_lower`/`budget_upper`
(`2^{−p} ≤ budget p ≤ 3·2^{−p}`), `tailSum_lower`/`tailSum_upper`, the two-sided logarithmic window
`log_tailSum_upper`/`log_tailSum_lower` at `N = nmin p`, `log_abs_one_add_le`
(`|log(1+t)| ≤ 2|t|` for `|t| ≤ 1/2`), and `nmin_ratio_close`/`log_ratio_close`.

The final wrapper supplies the eventual range hypotheses required by `L_bounded`:

```lean
rw [Asymptotics.isBigO_iff]
refine ⟨1000, ?_⟩
filter_upwards [Filter.eventually_ge_atTop
  (max 5052 (max 2000000000 (10^40 * ((2*3368+1)^2 + 1))))] with p hp
...
exact Op56.L_bounded p hp16 hn hlarge hnK
```

Here `p ≥ 5052` makes `3·ΦC ≤ 3·3368 = 10104 ≤ 2p`, using the landed bound

```lean
lemma PhiC_le : PhiC ≤ 3368
```

whose chain is `exp_neg_quarter_le : exp(−k/4) ≤ (7/8)^k` (valid because `8/7 ≤ e^{1/4}` follows from
the **linear** Taylor bound at `x = 1/4`, since `1.25 > 8/7`), then `Summable.of_nonneg_of_le`,
`Summable.tsum_le_tsum`, and `Σ' k, k²(7/8)^k = r(1+r)/(1−r)³ = 840` via
`tsum_pow_mul_geometric_of_norm_lt_one 2`. Hence `ΦC ≤ 840/2 + 8 = 428 ≤ 3368`.

### 5.4 `leadingCoeff_forced` — PROVED (the anchor result)

```lean
theorem leadingCoeff_forced {x : ℝ} (hx0 : 0 ≤ x) (hx1 : x < 1)
    (h : HasSum (fun j : ℕ => x ^ (j + 1)) 1) : x = 1 / 2
```

The rate `log 2` is **not fitted**: it is the unique `x ∈ [0,1)` with `Σ_{j≥1} x^j = 1`, i.e.
`x = 1/2`, i.e. `1/c = log 2`.

### 5.5 Reference constants (all proved)

| quantity | value | lemma |
|---|---|---|
| `Σ k² 2^{−k}` | 6 | `PhiS_log_two` |
| `Σ k³ 2^{−k}` | 26 | `tsum_cube_half` |
| `Σ k⁴ 2^{−k}` | 150 | `tsum_four_half` |
| `Σ k² (7/8)^{−k}`… i.e. `Σ k²(7/8)^k` | 840 | via `tsum_pow_mul_geometric_of_norm_lt_one 2` |

`c5 = 3(log 2)² − (25/12)log 2 = −0.0026975844…` is closed form.
`c6 = −0.540509640658…` is **numerical**, not closed form (see §6.3).

---

## 6. What is NOT proved, and why

### 6.1 `tailSum_integral_lower` — the former `sorry`, now PROVED (hypothesis repaired)

A **negative result kept on purpose**: the antitone integral test is *insufficient* to prove
completeness, because the integral discards the discrete mass `T_{N+1} ≈ 2 b_{N+1}`. Existence was
proved discretely instead — `exists_isComplete`, witness `N = 4p`, via
`tailSum_ge_first_two`, `term_ratio` + `bernoulli`, and `bound_three_halves`. Note `N = 3p` does
**not** work: the chain would need `3/2 ≤ 1`.

The lemma is no longer a `sorry`. Its original hypothesis was **`N + 1 ≤ M`, and that
statement is false**: at `M = N + 1` the sum misses the term at `k = M`. Witness: `p = 2`,
`N = 0`, `M = 1` gives left side `0.25` while `tailSum 2 1 = 0.16123…`. The corrected
hypothesis is **`N + 2 ≤ M`** (the integral test is applied at test-index `N + 2`, since
`f(n + (N+2)) = term p (N+1+n)`), and the lemma is proved there with the helper
`integral_two_mul_rpow` (`∫_{Ioi M} (2x)^{-p} = (2M)^{-p}·M/(p−1)`). `#print axioms` is
`[propext, Classical.choice, Quot.sound]`. The lemma is used by nothing.

### 6.2 `native_decide` — REMOVED (item O2)

`#print axioms` on the three main theorems, and on `Phi_third_order`,
`threshold_third_order_uniform` and `tsum_pow6_exp_neg_half_le`, is now exactly
`[propext, Classical.choice, Quot.sound]`. The two `interval_cases j <;> native_decide` steps in
`tsum_pow6_exp_neg_half_le` were replaced by
`interval_cases j <;> norm_num [Nat.stirlingSecond]` / `[Nat.factorial]`, so **no `native_decide`
token occurs anywhere in the development** and the whole OP-5/OP-6 layer is axiom-clean.

### 6.3 OP-6's `1/p` coefficient — DONE (item O4), and the quoted constant was wrong

`LAsym`'s linear coefficient `−(1 + log log 2)` remains *given* (the theorem bounds the residual
rather than re-deriving it from first principles; it enters through `log_ratio_close` and the OP-5
second-order layer). But the `1/p` coefficient is now **derived in closed form**: it is the
*function*

    c(e) = −((ln 2)²/2)·(e² − e + 9/4) ,     e(p) = ⌈p/log 2 − 5/2⌉ − (p/log 2 − 5/2) ∈ [0,1) ,

ranging over `c ∈ [−(ln 2)², −(9/8)(ln 2)²] = [−0.480453…, −0.540510…]`. The numeral
`−0.540509640658…` is only the smooth-index (`e = 0`) specialisation. Verified to `3.5·10⁻¹⁴` at
`p = 10¹³` by `../open/op06_ceiling_coefficient.py`; the earlier constant-coefficient statement was
false.

### 6.4 The exact ceiling law is **FALSE** (found by continued-fraction search)

> **Update (O3).** `nmin p = ⌈p/log 2 − 5/2⌉` is **not a theorem**; it has (very sparse) counterexamples.
> The crossing index obeys `nmin p = ⌈y⌉ − 1` where `y = p/log 2 − 3/2`, and the real crossing is
> `n_*(p) = y + F` with `F = −b/(n_* log 2) + O(n_*^{-2}) > 0`, `b = 3(log 2)² − (25/12)log 2 < 0`
> (so `F ≈ 2.698·10^{-3}/p`). Hence `nmin p = ⌈p/log 2 − 5/2⌉` **iff** `1 − {y} > F`; it fails exactly
> when `1 − {y} < F`, i.e. when `2/log 2` has an exceptionally good rational approximation
> `(2m+5)/p` with odd numerator. The first such `p` found (451 decimal digits) gives
> `nmin p = ⌈p/log 2 − 5/2⌉ + 1`, verified at 1150 dps by
> [`verify/op05_nmin_ceiling_false.py`](verify/op05_nmin_ceiling_false.py)
> (`python3 verify/op05_nmin_ceiling_false.py`). The earlier "76 values, zero mismatches" sweep is
> correct but samples only the good set: the failure density up to `P` is `~ c/ln P`.
>
> Consequences: (i) **no sharpening of `Phi_window_low`/`Phi_window_high` can prove the law** — a window
> with fixed slack `K/n²` in `w = p/n − log 2` decides the crossing only when
> `1 − {y} > K/(n log 2)`, and the bad `p` are exactly those where this fails; (ii) the strongest true
> uniform statement is the disjunction `nmin p ∈ {⌈p/log 2 − 5/2⌉, ⌈p/log 2 − 5/2⌉ + 1}`
> (numerically `Φ_p(⌈A⌉) < 1` for all `50 ≤ p ≤ 20000` tested, so the lower half is safe); (iii) the
> exact law is replaced in Lean by the reduction `Op56.nmin_eq_of_Phi` /
> `Op56.nmin_eq_ceil_of_Phi_bounds` (`Op56/PhiThird.lean`), which shows the law is *equivalent* to the
> two pointwise `Φ`-inequalities, and by the documented warning in that file.
>
> The historical account below is retained for archaeology.

`nmin p = ⌈p/log 2 − 5/2⌉` was believed established numerically (76 values, 40 dps, zero
mismatches) but is **FALSE** — see the correction at the top of §6.4. It is not merely "not
yet a Lean theorem": no proof exists, and none can. The true uniform statement is the
disjunction `nmin p ∈ {⌈p/log 2 − 5/2⌉, ⌈p/log 2 − 5/2⌉ + 1}`. See §8.

---

## 7. Lean / Mathlib gotchas (current)

These cost many rounds; do not rediscover them.

### 7.1 Absences in Mathlib

| Missing | Workaround |
|---|---|
| Euler–Maclaurin, `summationByParts` | not needed — geometric comparison |
| `abs_tsum_le_tsum_abs` | prove **one-sided** bounds `f ≤ g` and `g ≤ f` separately, combine via `abs_le` |
| `Real`-valued `tsum_le_tsum` | `Summable.tsum_le_tsum` (see 7.2 for its binder order); `ENNReal.tsum_le_tsum` exists and is what Mathlib itself uses |
| `abs_add` | the name is **`abs_add_le`**, and it takes **two** arguments |
| `stirlingSecond` | **`Nat.stirlingSecond`** (namespaced) |
| top-level `isBigO_iff` | **`Asymptotics.isBigO_iff`** — needs `open Asymptotics` |
| `le_or_lt` | not an identifier; use `by_cases h : 0 ≤ t` + `push_neg`, or `le_total` |
| `Real.exp_le_one_iff` | `rw [← Real.exp_zero]; exact Real.exp_le_exp.mpr …` |
| `tsum_cube_mul_geometric_of_norm_lt_one` | use the general `tsum_pow_mul_geometric_of_norm_lt_one k`, then `norm_num [Nat.stirlingSecond, Finset.sum_range_succ]` |

### 7.2 Binder orders — check with `#check`, do not guess

```lean
Summable.tsum_le_tsum : (∀ i, f i ≤ g i) → Summable f → Summable g → ∑' f ≤ ∑' g
Summable.of_nonneg_of_le : (∀ b, 0 ≤ g b) → (∀ b, g b ≤ f b) → Summable f → Summable g
```

Note `hle` comes **first**, and `of_nonneg_of_le` derives the *smaller* series' summability from the
larger's. `#check @Summable.tsum_le_tsum` settles this in one round; guessing at it costs several.

### 7.3 Tactic traps, with fixes

- **`field_simp` alone often closes the goal** → a trailing `ring` gives `No goals to be solved`.
  Use `try ring`, or drop it. (Recurred many times.)
- **`rw […]; ring` where `field_simp` already closed** → same failure.
- **`linarith` does not substitute through equalities** → `rw` first.
- **`linarith` will not chain `A ≤ B`, `B = C`, `C ≤ D`** → `h1.trans ((le_of_eq h2).trans h3)`.
- **`linarith` cannot lift an inequality through `×32`** → `mul_le_mul_of_nonneg_left h (by norm_num)`.
- **`linarith` cannot do `C ≤ C*n` from `1 ≤ n`, `C > 0`** → `mul_le_mul_of_nonneg_left h1n hCpos.le`.
- **`linarith` cannot mix ℕ and ℝ** → `exact_mod_cast` first.
- **`linarith` cannot see squaring monotonicity** → `pow_le_pow_left₀ h0 hle 2`, then `nlinarith`.
- **`nlinarith` cannot lift an inequality through `^3`** → `pow_le_pow_left₀`.
- **An inline `by linarith : (1:ℝ)+t ≠ 0` is malformed** (linarith on a `≠` goal) → use `hpos.ne'`.
- **An inline `by positivity : (0:ℝ) ≤ x` inside `abs_of_nonneg` gives `No goals to be solved`** →
  state the nonnegativity as its own `have` first.
- **`positivity` does not consult hypotheses** — it will not prove `0 < (1-r)^3` from `0 < 1-r` in
  context; use `pow_pos h1e 3` or `by linarith [h]`.
- **`div_le_iff₀` takes `0 < c`** (not `0 ≤ c`); `div_le_div₀` takes `(0 ≤ c) (a ≤ c) (0 < d) (d ≤ b)`.
- **`rw [div_le_iff₀]` does not fire when the division is on the right** → `le_div_iff₀`.
- **`one_div_le_one_div_of_le` reverses its arguments in the conclusion**; `inv_le_inv₀` is a `↔` —
  use it as `rw [inv_le_inv₀ ha hb]` then `exact`.
- **`inv_pow` direction**: `((8/7)^k)⁻¹` needs `rw [← inv_pow]`, not `inv_pow`.
- **`rw [← Real.exp_log …]` rewrites every occurrence of the numeral**, including constants inside
  fractions.
- **`Real.rpow_neg` takes `0 ≤ x`**, not `0 < x`.
- **`integrableOn_Ioi_rpow_of_lt {a c : ℝ} (ha : a < -1) (hc : 0 < c)`** — the exponent is the real
  `a`; there is no `1 < a` hypothesis.
- **`AntitoneOn.tsum_comp_add_le_integral (N) (anti) (integrable) (nonneg)`** — the `+1` in the
  conclusion is produced by the lemma.
- **Coercion `((1:ℕ):ℝ)` vs `(1:ℝ)`** are equal but not syntactically identical; the elaborator will
  not unify them in argument position. Bind `have h1 : (((1:ℕ):ℝ)) = (1:ℝ) := by norm_num` and `rw`.
- **`Set.mem_Ici.mp`** is required to use `a ∈ Set.Ici b` as `b ≤ a`.
- **Use `tsum_congr`, never `ext`,** for `∑'` equality goals (`ext` fails on `ℝ`).
- **`filter_upwards` needs `Filter` in scope** (or a qualified filter); in `Asymptotic.lean` an
  `open Filter` is required.
- **`convert … using n` followed by `; ring` applies the tactic to *all* goals** `convert` produces,
  including hypothesis-direction ones. Write explicit bullets instead.
- **`simpa` fails where `convert … using 2; ring` succeeds** on definitional differences such as
  `p - N*L` vs `-N*L + p`. Reach for `convert` when `simpa` reports a type mismatch "after
  simplification".
- **A `ring` identity can be a no-op**: if both sides are written with the *same* parenthesisation,
  `ring` proves a trivial identity and the `rw` changes nothing. `+` is left-associative, so
  `a+b+c+d` and `a+b+(c+d)` differ — **state the two sides with genuinely different association**,
  and if a `rw` "succeeds" without changing the goal, suspect a vacuous equality.
- **Count the parameters** of a lemma before instantiating it. An argument list short by one shifts
  every subsequent argument onto the wrong hypothesis and produces a cascade of spurious
  mismatches.
- **Name shadowing is real**: unqualified references can resolve to a *different* Mathlib lemma with
  the same name. Qualify (`Op56.exp_neg_quarter_le`) when a statement behaves unexpectedly.
- **`set` variables are opaque to `ring_nf`** — `rw [hk]` first.
- **`MonotoneOn` application leaves beta-redexes** — `simp only at h` first.
- **`field_simp` needs the `≠ 0` hypothesis in context** (`have hn0 : (n:ℝ) ≠ 0 := ne_of_gt hnR`).

### 7.4 Mathematical traps

- **The `exp d` factor is harmless**: `G_k · exp d = T_k` *exactly*. Writing `G_k · exp y` instead
  produces a bound that blows up.
- **The sign in the threshold decomposition** is **plus**: `1 − (e^u−1)^{-1} = (u/2n)ΦS(u) + ε`.
  The minus version is off by `2(1 − (e^u−1)^{-1})`.
- **`N = 3p` fails** for `exists_isComplete`; `N = 4p` works.
- **`nmin p` has no upper bound except from the estimate itself.** It is a `Nat.find`; nothing
  bounds it above. Derive `nmin p ≤ 3p` from `nmin_w_sharp`, not from `omega`.
- **Take size constants from the hypotheses, not from the asymptotic.** `nmin_w_sharp` yields
  `N ≤ (p+4)/log 2 < 2p + 8`, so `N ≤ 2p` is *false* while `N ≤ 3p` holds; similarly the Taylor
  bound `1 + x ≤ e^x` suffices for `8/7 ≤ e^{1/4}` but **not** for `4/3 ≤ e^{1/4}` (which needs the
  ninth term). Choosing the weaker statement deliberately is often cheaper than the sharp one.
- **An `O(1/p)` error in an index asymptotic is impossible** whenever the threshold is an irrational
  linear function of the parameter: the index is an integer, so the error cannot beat the
  Diophantine gap. This generalises beyond this problem.

---

## 8. Technique notes: what worked, what did not

**What worked, repeatedly.**

1. **Restating an assembly with abstract hypotheses.** A 22-round sequence of failed in-place
   patches to `L_bounded` produced nothing; restating the arithmetic as `L_bounded_abstract`, with
   the four bracket bounds as *hypotheses*, took it from five errors to one immediately.
2. **Replacing a monolith by a `calc`.** A single opaque `linarith` failure with seven facts in
   scope became a four-step `calc` in which each step failed locally and legibly.
3. **Printing instead of inferring.** `#check @lemma` for binder orders; `sed -n '/LINE/,/NEXTLINE/p'`
   for goal context. Every one of the four substantive defects in this stretch was found by
   printing: a `hassoc` that was a **no-op**, an argument list **short by one**, a `log 3`/`log 9`
   bound supplied in the **wrong direction** (`log_nonneg` where `log_le_sub_one_of_pos` was
   needed), and the `nmin p ≤ 2p` constant.
4. **Closed-form + monotonicity ⇒ uniformity is free.** Keeping the `u`-dependence inside an explicit
   closed form that is monotone in `u` uniformises a lemma with no `tsum_le_tsum` and no summability.
5. **Incremental landing.** Splitting a long lemma into 3–5 sub-lemmas has repeatedly exposed real
   errors (a wrong exponent, a wrong threshold) that the monolith had hidden.
6. **Keep `./check.sh --all` green at every boundary.** If a lemma does not compile after a round of
   iteration, *remove it* and report; never leave `sorry` in the deliverable file.

**What did not work.**

- Attempting large new lemmas as one block.
- Adjusting `linarith`'s hypothesis list when the goal does not change shape — restructure instead.
- Reaching for derivative machinery when a first-order Mathlib inequality exists.
- Order-of-magnitude guesswork without numerics: two of the corrections in this development (the
  `O(1/p)` error term and the `6720` vs `840` series value) were plain arithmetic slips caught only
  by computing.

---

## 9. Verification scripts

```bash
cd research/twin-prime-parity/006/verify
python3 op05_nmin_ceiling.py        # falsifies O(1/p)
python3 op05_nmin_ceiling_false.py  # falsifies the exact ceiling law (451-digit counterexample)
python3 op05_nmin.py                # threshold constant c5
python3 op06_reachable_fraction.py  # reachable fraction, c6
```

`op05_nmin_ceiling.py` uses only the Python standard library.

---

## 10. Definition of done — met

`./check.sh --all` is **9/9 green**, all three named theorems are **proved**, there is **no `axiom`
declaration**, and the development has **no `sorry` anywhere** — the last one
(`tailSum_integral_lower`, `Exact.lean`) was discharged in §6.1 by repairing its hypothesis to
`N + 2 ≤ M` and proving it. The goal is complete.

The former `native_decide` caveat is gone: item `O2` removed the footprint entirely (§6.2).

---

## 11. Further research

**Immediate, concrete.**

1. ~~**Formalise the exact ceiling law.**~~ **CLOSED (O3): the law is FALSE.** `nmin p = ⌈p/log 2 − 5/2⌉`
   fails at a 451-digit `p` (see §6.4); the failure set is the set of `p` for which `2/log 2` is
   approximated to within `~ (2.7·10^{-3})/p²`. The correct target is now the disjunction
   `nmin p ∈ {⌈p/log 2 − 5/2⌉, ⌈p/log 2 − 5/2⌉ + 1}`, equivalently `0 < n_*(p) − (p/log 2 − 3/2) < 1`
   for the *real* crossing `n_*`. Provable from a sharpened window with slack `~ |b|/n²`
   (`|b| = 2.698·10^{-3}`); the existing `10^19/n²` slack is the obstruction. The reduction
   `Op56.nmin_eq_of_Phi` makes the remaining analytic work explicit.
   <details><summary>old text (superseded)</summary>

   `nmin p = ⌈p/log 2 − 5/2⌉` is numerically established but not
   proved. The two halves needed are `Φ_p(⌊A⌋) < 1` and `Φ_p(⌊A⌋+1) ≥ 1` at
   `A = p/log 2 − 5/2`, both reachable from `Phi_window_low`/`Phi_window_high` — **but those carry a
   `10^19/n²` slack that is `O(1)` (not negligible) at `n ≈ 2.9·10^9`. Sharpening those windows is
   the concrete next task**, and would convert a numerically established law into a theorem.
   </details>
2. ~~**Discharge `Exact.lean:118`**~~ — **DONE (§6.1).** The `sorry` is gone: the statement was
   **false** as written (`N + 1 ≤ M`; witness `p=2, N=0, M=1`), and it is now **proved** under the
   corrected hypothesis `N + 2 ≤ M`, with the helper `integral_two_mul_rpow`.
3. ~~**Remove the `native_decide` dependencies**~~ — **DONE (O2)**: replaced by explicit
   `interval_cases`/`norm_num`; no `native_decide` remains.
4. ~~**Make `c6` closed form**~~ — **DONE (O4)**: the exact `1/p` coefficient is the *function*
   `c(e) = −((ln 2)²/2)(e²−e+9/4)` of the ceiling error, not the constant `−0.540509640658…`
   (which is the smooth-index `e = 0` value). See `../open/op06_ceiling_coefficient.py`.

**Structural generalisations.**

5. ~~**Other moduli.**~~ **DONE (O9), and the guessed law is FALSE.** With
   `term(p,q,r,n) = (q(n+1)+r)^{−p}` the Brown criterion depends only on `N + 1 + r/q`, so `r = 0`
   is *exactly* `q`-independent and the slope is `1/log 2` for every `q, r`:
   `nmin(p;q,r) = p/log 2 − 1 − r/q + O(1)`. See `../open/OP-09-other-moduli.md`.
6. **Dirichlet L-functions.** Replace the parity sieve by a character sum,
   `a_k = χ(k)k^{−p}`, and study the twisted threshold function
   `Φ_χ(p,n) = n^p Σ_{j≥0} χ(n+j+1)(n+j+1)^{−p}`. The interesting question is how much of the OP-5
   second-order expansion survives when `χ` is non-principal.
7. **Higher-order expansions.** `PhiThird.lean` already contains the third-order layer; a fourth
   order would give the `1/p²` term of the index form — the natural sharpening *below* the ceiling
   correction.
8. **A meta-theorem on floor asymptotics.** An `O(1/p)` error in an index asymptotic is impossible
   for any family whose threshold is an irrational linear function of the parameter (§7.4). This
   looks statable and provable in general.

**Programme-level.**

9. **Sign-blindness as a theorem.** The results here are consistent with Selberg's parity barrier but
   do not formalise it. A Lean statement of the parity principle in the restricted setting of weight
   families generated by small-prime residue conditions is a natural target.
10. **The `k = 1` Chowla equivalence.** The `k = 1` case is equivalent to the prime number theorem
    and is *not* open; a formalised proof would remove a persistent source of mislabelling.
11. **Logarithmic averaging.** The logarithmically averaged Chowla conjecture for all `k` is a
    theorem; far beyond present scope, but structured enough to be a plausible long-term Lean target.

---

## 12. Provenance

- `index.html` — the paper, self-contained, with abstract, proofs, glossary, applicability,
  relations to zeta/L-functions, twin-prime parity and Brown's criterion, further research and
  citations.
- [`../open/HANDOFF.md`](../open/HANDOFF.md) — the full development log (681 round entries),
  now the single canonical copy (the former `notes/HANDOFF.md` duplicate is a pointer).
  Superseded by this file as a statement of state; retained for archaeology.
- `notes/OP-05-nmin-asymptotic.md`, `notes/OP-06-reachable-fraction.md` — the original problem
  statements, each with a correction banner where the recorded error term was wrong.
- `notes/linarith-agent-prompt.md` — the arithmetic-tactic discipline used throughout.
