# HANDOFF — Structural generalisation #6 (Dirichlet L-functions / character sum)

**Directory** `research/twin-prime-parity/007/`
**Lean** `research/twin-prime-parity/007/lean/`
**Toolchain** Lean 4 `v4.35.0-rc2` + Mathlib at `$LEAN_PREFIX/mathlib4` (default `$LEAN_PREFIX = $HOME/lean`)
**Status** **ATTACK COMPLETE (first round)** — algebraic core machine-checked, positive-direction asymptotics numerically established
**Last verified** `./check.sh --all` → **5/5 `[check] OK`**; **0 `sorry`**, **0 `axiom`**; footprint `[propext, Classical.choice, Quot.sound]` (no `native_decide`)

> This file records **only the current state**. The mathematical write-up is
> `notes/generalisation-06.md`; read it first. `index.html` is the rendered paper.

---

## 1. The objective, verbatim

> **Dirichlet L-functions** (`006/handoff.md` §11, item 6). Replace the parity
> sieve by a character sum, `a_k = χ(k)k^{−p}`, and study the twisted threshold
> function `Φ_χ(p,n) = n^p Σ_{j≥0} χ(n+j+1)(n+j+1)^{−p}`. The interesting question
> is how much of the OP-5 second-order expansion survives when `χ` is
> non-principal.

---

## 2. TL;DR

| item | status |
|---|---|
| `Φ_c(p,n) → F_r(e^{−a})`, `r = n mod q`, error `O(1/n)` | **NUMERICAL** (stable `n·err`) |
| regrouping `F_r = f_r/(1−x^q)` | **PROVED** — `Op57.F_eq_fblock` |
| forced leading equation `x^s = 1 − x^q` | **PROVED** — `Op57.leading_forced_of_hasSum_geom` |
| parity sieve constants `x = 1/√2` (even `r`), `x = (√5−1)/2` (odd `r`) | **PROVED** — `Op57.leading_forced_parity_{even,odd}[_eq]` |
| second-order deformation (OP-5′) | **NUMERICAL**, calibrates exactly to 006's `c₅` |
| `F_r(x) < 1` ∀`r`, ∀`x ∈ [0,1)` for `χ₃`, `χ₄` → **no threshold** | **PROVED** — `Op57.chi3_F_lt_one`, `Op57.chi4_F_lt_one` |
| threshold criterion `max_{[0,1)} F_r ≥ 1`; exhaustive scan `q ≤ 60` | **NUMERICAL** — `verify/03_character_scan.py` |

**The answer to the objective's question.** The OP-5 second-order expansion
survives **in full shape** wherever the twisted leading equation `F_r(x) = 1` has
a root: `p(n) = a n + g + c/n + O(1/n²)` with `a = −log x*` and character-twisted
moments `S_m(r)`. What is *not* automatic is the existence of that root. For the
trivial/principal coefficient, `F_r → +∞` and a root always exists; for a
non-principal character the coefficient has zero period mean, `F_r` is bounded on
`[0,1]`, and the root can fail to exist. It does fail for `χ₃` and `χ₄` (proved),
and it holds for example for `χ₁₁`, `r = 2`, and for 29.7 % of all `(χ,r)` pairs
with real `χ` mod `q ≤ 60`.

---

## 3. How to build and verify

```bash
cd research/twin-prime-parity/007/lean
./check.sh --all                       # Defs, Leading, Blocks, Obstruction, root
./check.sh Op57/Obstruction.lean       # one module
LEAN_PREFIX=/path/to/lean ./check.sh --all
```

There is no `lake` project file; `check.sh` reconstructs `LEAN_PATH` from
`lake env` inside a Mathlib checkout (copied from the 006 development).

Axiom footprint (all theorems):

```lean
import Op57
#print axioms Op57.F_eq_fblock
#print axioms Op57.chi3_F_lt_one
#print axioms Op57.leading_forced_parity_odd_eq
```

Numerics (Python 3, standard library + `mpmath`):

```bash
cd research/twin-prime-parity/007/verify
python3 02_leading_law.py       # limit law + forced constants + criterion
python3 03_character_scan.py    # exhaustive real characters mod q <= 60
python3 04_second_order.py      # OP-5' and the calibration to c5
python3 05_limit_rate.py        # the O(1/n) rate of the limit law
```

`01_twisted_threshold.py` is the exploratory first probe; `02`–`05` supersede it.

---

## 4. File map

```
research/twin-prime-parity/007/
  index.html                       the paper (self-contained)
  handoff.md                       this file
  notes/
    generalisation-06.md           the mathematical note (read this first)
  lean/
    check.sh                       build script
    Op57.lean                      umbrella import
    Op57/Defs.lean                 IsPeriodic PhiChi F fblock endpointValue;
                                   geom_term geom_norm_lt_one
    Op57/Leading.lean              forced leading constants (the anchor)
    Op57/Blocks.lean               periodic_mod; the regrouping F_r = f_r/(1-x^q);
                                   fblock_mod F_mod
    Op57/Obstruction.lean          chi3 chi4; block polynomials; F_r < 1;
                                   no leading threshold
  verify/
    01_twisted_threshold.py        first probe (superseded)
    02_leading_law.py              limit law, forced constants, criterion
    03_character_scan.py           exhaustive scan (187 chars, 4537 pairs)
    04_second_order.py             OP-5' deformation + c5 calibration
    05_limit_rate.py               O(1/n) rate
```

---

## 5. Key objects

```lean
def PhiChi (c : ℕ → ℝ) (p : ℝ) (n : ℕ) : ℝ :=
  ∑' j : ℕ, c (n + j + 1) * (1 + (((j : ℝ) + 1) / (n : ℝ))) ^ (-p)
def F (c : ℕ → ℝ) (r : ℕ) (x : ℝ) : ℝ := ∑' j : ℕ, c (r + j + 1) * x ^ (j + 1)
def fblock (c : ℕ → ℝ) (q r : ℕ) (x : ℝ) : ℝ :=
  ∑ s ∈ Finset.range q, c (r + s + 1) * x ^ (s + 1)
def IsPeriodic (c : ℕ → ℝ) (q : ℕ) : Prop := 0 < q ∧ ∀ m, c (m + q) = c m
def chi3 : ℕ → ℝ := fun m => if m % 3 = 1 then 1 else if m % 3 = 2 then -1 else 0
def chi4 : ℕ → ℝ := fun m => if m % 4 = 1 then 1 else if m % 4 = 3 then -1 else 0
```

The reusable general result is `Op57.F_eq_fblock`:

```lean
theorem F_eq_fblock {c : ℕ → ℝ} {q : ℕ} (hq : 0 < q) (hc : ∀ m, c (m + q) = c m)
    (r : ℕ) {x : ℝ} (hx0 : 0 ≤ x) (hx1 : x < 1) :
    F c r x = fblock c q r x / (1 - x ^ q)
```

Its proof reindexes `ℕ ≃ ℕ × Fin q` (`Nat.divModEquiv`), uses `HasSum.mul` for the
finite×infinite product, `Summable.of_norm_bounded` + `summable_sigma_of_nonneg`
for the product summability, and periodicity `periodic_mod`.

---

## 6. What is NOT proved, and why

1. **The limit law (LIMIT) and the second-order expansion (OP-5′) are numerical.**
   The proof of (LIMIT) is classical (Abel summation / Euler–Maclaurin; the
   `j`-sum is geometrically cut off by `e^{−aj}`, so the remainder is `O(1/n)`),
   and `05_limit_rate.py` exhibits the stable `n·err`. Formalising it needs
   `ℝ`-exponent manipulation and a uniform `O(1/n)` estimate, i.e. the same order
   of analysis as 006's `Phi_asymptotic` — out of scope for one round.
2. **The threshold criterion is proved only negatively** (for `χ₃`, `χ₄`, wholly
   in Lean). The positive direction (`max F_r ≥ 1` ⇒ a threshold with OP-5′)
   is not formalised.
3. **The general inequality `F_r < 1` for all non-principal `χ`** is **FALSE** —
   see `03_character_scan.py` (e.g. `q = 47` attains `5.0`). There is no uniform
   character barrier; solvability of (LEAD) is genuinely character-dependent.
   This was the single largest mid-course correction: the first conjecture of the
   round was the uniform bound, and the scan refuted it.
4. **Complex characters** are not treated. For complex `χ`, `Φ_χ` is complex and
   `Φ_χ = 1` is a complex equation; the natural objects are `Re Φ_χ` or
   `|Φ_χ|`. All characters in the numerics are **real** (principal and the
   `±1`-valued quadratic characters), which is the setting in which a real
   threshold equation is meaningful.

---

## 7. Technique notes (contrast with 006)

**What worked.**

1. **Numerics before framing.** The initial framing ("non-principal characters
   destroy the threshold") was checked by an exhaustive scan and refuted; the
   corrected statement (a criterion, not a barrier) is the real result. The
   calibrated check `04_second_order.py` reproducing 006's `c₅` to 40 dps was the
   strongest single piece of evidence that the deformation formula is right.
2. **Stating the regrouping generally.** `F_eq_fblock` is proved once for
   arbitrary periodic `c` and reused for every character, rather than reproving
   closed forms per character.
3. **`#check` before writing.** Every Mathlib name used
   (`hasSum_geometric_of_norm_lt_one`, `HasSum.mul`, `Summable.of_norm_bounded`,
   `summable_sigma_of_nonneg`, `Nat.divModEquiv_symm_apply`,
   `Nat.add_mul_mod_self_right`, `Fin.sum_univ_eq_sum_range`) was printed first.

**Tactic traps hit in this round.**
- `rw [h]` where `h : 1 = …` rewrites the numeral `1` **inside `1 - x^q`** and
  destroys the goal. Fix: `congrArg (· * (1 - x^q)) h`.
- `rw [hmq]` with `hmq : m = (m-q)+q` rewrites `m` inside the RHS `c (m-q)`.
  Fix: `conv_lhs => rw [hmq]`.
- `rw [← Nat.div_add_mod r q]` rewrites every `r`, including inside `r % q`.
  Fix: `have hr : r = r%q + r/q*q := by rw [eq_comm, add_comm, mul_comm (r/q) q]; exact Nat.div_add_mod r q`.
- `omega` handles `%` with a **literal** modulus poorly and with a symbolic one
  not at all in this setting; use `Nat.add_mul_mod_self_right` explicitly.
- `Nat.div_add_mod r q` is stated as `q * (r/q) + r%q = r` (left factor `q`),
  not `r/q * q + …`; mind the `mul_comm`.
- `simp only [Nat.divModEquiv_symm_apply]` cannot fire until `NeZero q` is in
  scope; add `haveI : NeZero q := ⟨by omega⟩`.

---

## 8. Concrete next steps

1. **Formalise (LIMIT)** for `q = 2` (the parity sieve) as the minimal analytic
   step; the `j`-sum is geometrically cut off, so a `Tendsto` statement at fixed
   `a` is plausible with the 006 `PhiAsymptotic` toolkit.
2. **Formalise the positive criterion** and (OP-5′) under explicit hypotheses,
   then derive the parity-sieve second-order constants `g`, `c` as a corollary.
3. **Extend to complex characters** via `Re Φ_χ` and `|Φ_χ|`; decide which of the
   two is the right threshold functional.
4. **Classify the criterion**: a useful target is a closed-form description of
   `{ (χ, r) : max_{[0,1)} F_r ≥ 1 }` in terms of `−f_r'(1)/q` and the interior
   maximum. The scan suggests the boundary `= 1` is common (marginal thresholds).
5. **Connect to `L`-values.** `F_r(1⁻) = −q^{-1}Σ_s s χ(r+s)` is a generalised
   Bernoulli number `B_{1,χ}`-type quantity; the criterion may have a clean
   `L(0, χ)`-form.
