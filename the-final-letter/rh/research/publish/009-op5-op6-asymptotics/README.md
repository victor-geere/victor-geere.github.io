# publish/009 — OP-5 and OP-6: the resolved open problems

Ninth published edition. This folder packages **item §9 of `research/truths.md`**: the
two problems the `open/` directory was created to settle, with their Lean development,
the corrections that followed, and the numerical cross-checks.

## What the item is

**OP-5 — the index asymptotic.** For the greedy construction, `n_min(p)` is the index at
which the threshold series crosses. The programme proves

```
P_n = (n + 3/2) log 2 + c/n + O(1/n²),   c = 3(log 2)² − (25/12) log 2,
n_min(p) = p/log 2 − 3/2 + O(1).
```

The leading coefficient is **forced**: the equation `Σ_{j≥1} x^j = 1` has the unique root
`x = 1/2`, so the exponent rate is `log 2`.

**Corrections the item records.**

* The original write-up claimed an error term `O(1/p)`. That is **false**, and the
  meta-theorem `O11` proves *why*: if `α` is irrational, no integer sequence can satisfy
  `|n(p) − (αp + β)| ≤ C/p` for all large `p`. The correct term is `O(1)`.
* The **exact ceiling law** `n_min p = ⌈p/log 2 − 5/2⌉` is **false**. The crossing is
  `n_*(p) = p/log 2 − 3/2 + F(p)` with `F(p) ≈ 2.698·10⁻³/p > 0`, so the law holds only
  when `1 − {y} > F(p)` with `y = p/log 2 − 3/2`. It fails first at a **451-digit** `p`
  (independently reproduced at 1150 dps). The sharpest true uniform statement is the
  disjunction `n_min p ∈ {⌈A⌉, ⌈A⌉+1}`, which is **unproved**.
* **Other moduli (`O9`).** With `term(p,q,r,n) = (q(n+1)+r)^{−p}` the Brown criterion
  depends only on `N + 1 + r/q`. So `r = 0` is **exactly `q`-independent**, and the slope
  is `1/log 2` for every `q, r`. The recorded claim that the leading constant becomes
  `1/log q`-type data is **false**.

**OP-6 — the reachable fraction.** Composing the census law with OP-5,

```
L(p) = p log p − (1 + log log 2) p + O(1).
```

The `1/p` coefficient is **closed form but not a constant**:

```
c(e) = −((log 2)²/2)(e² − e + 9/4),   e(p) = ⌈p/log 2 − 5/2⌉ − (p/log 2 − 5/2) ∈ [0,1),
```

ranging over `[−0.480453, −0.540510]`. The formerly quoted constant
`−0.540509640658…` is only the `e = 0` (smooth-index) value; the earlier
constant-coefficient statement was **false**.

**Fourth order (`O10`).** `Phi_fourth_order` is proved, axiom-clean, with the explicit
constant `C = 11·10¹² + 2·10¹² + 7` and the error term
`E(u) = (u/4)ΦK4u − (u²/6)ΦK5u + (u³/48)ΦK6u`. The *threshold-form* fourth order
(`SFourth`) is **not** landed and is scoped as new analytic content.

**Floor asymptotics (`O11`).** If `α` is irrational, no integer sequence satisfies
`|n(p) − (αp + β)| ≤ C/p` for all large `p`. The `OP-5` instance is conditional on
`Irrational (Real.log 2)`, which Mathlib lacks.

## Contents

| Path | What it is |
|---|---|
| [`TRUTHS.md`](TRUTHS.md) | **The item**: the §9 ledger from `research/truths.md`, links re-pointed into this folder. |
| [`Op56/Asymptotic.lean`](Op56/Asymptotic.lean) | The headline theorems: `leadingCoeff_forced`, `op5_threshold_leading`, `op5_threshold_second_order`, `op5_threshold_asymptotic`, `op5_nmin_asymptotic`, `op6_reachable_fraction`. |
| [`Op56/PhiAsymptotic.lean`](Op56/PhiAsymptotic.lean), [`Op56/PhiThird.lean`](Op56/PhiThird.lean), [`Op56/PhiFourth.lean`](Op56/PhiFourth.lean) | The `Φ` expansions: first order, the third-order ceiling-law reduction (`nmin_eq_iff_Phi_bounds`), and the proven fourth order. |
| [`Op56/Exact.lean`](Op56/Exact.lean), [`Op56/Census.lean`](Op56/Census.lean), [`Op56/Defs.lean`](Op56/Defs.lean) | Completeness, the census identity (with its recorded caveat), and the definitions. |
| [`Op56/FloorAsymptotic.lean`](Op56/FloorAsymptotic.lean) | The floor-asymptotic meta-theorem `O11` and its `OP-5` instance. |
| [`Op56.lean`](Op56.lean), [`check.sh`](check.sh), [`LEAN-README.md`](LEAN-README.md) | Root module, build script, and the development's own guide. |
| [`notes/OP-05-nmin-asymptotic.md`](notes/OP-05-nmin-asymptotic.md), [`notes/OP-06-reachable-fraction.md`](notes/OP-06-reachable-fraction.md) | The two write-ups. |
| [`notes/OP-09-other-moduli.md`](notes/OP-09-other-moduli.md) | The `O9` falsification. |
| [`notes/OP-05-nmin-exposition.html`](notes/OP-05-nmin-exposition.html), [`notes/OP-06-reachable-fraction.html`](notes/OP-06-reachable-fraction.html), [`notes/RESULTS.html`](notes/RESULTS.html) | The rendered expositions and results page. |
| [`notes/07-open-problems.md`](notes/07-open-problems.md) | The programme's open-problems register, for context. |
| [`op05_nmin.py`](op05_nmin.py), [`op06_reachable_fraction.py`](op06_reachable_fraction.py) | The OP-5 and OP-6 numerics. |
| [`op06_ceiling_coefficient.py`](op06_ceiling_coefficient.py) | The `O4` closed form for the `1/p` coefficient. |
| [`op09_moduli.py`](op09_moduli.py) | The `O9` other-moduli falsification. |
| [`verify-006/`](verify-006) | `006`'s verification layer: `op05_nmin_ceiling.py`, **`op05_nmin_ceiling_false.py`** (the 451-digit counterexample), and recomputations. |
| [`HANDOFF-006.md`](HANDOFF-006.md) | `006`'s handoff, the cleaned authoritative statement of current state. |
| [`logs/`](logs) | `op06_ceiling_coefficient.log` (verified to `3.5·10⁻¹⁴` at `p = 10¹³`) and `op09_moduli.log` (60 cases, `q ≤ 11`). |

## What is proved, and what is not

* **Proved in Lean, axiom-clean** — the six headline theorems above; the `Φ` first-order
  asymptotic; `exists_isComplete`; the census identity; the integral test (as a negative
  result, with the **corrected** hypothesis `N + 2 ≤ M` — the as-written `N + 1 ≤ M` form
  is false at `p=2, N=0, M=1`); and the `O11` meta-theorem.
* **Derived + verified numerically** — `O9` (60 dps, 60 cases, `q ≤ 11`); `O4`
  (`3.5·10⁻¹⁴` at `p = 10¹³`).
* **Refuted** — the `O(1/p)` error term; the exact ceiling law `n_min p = ⌈p/log 2 − 5/2⌉`;
  the constant `1/p` coefficient; the `1/log q` reading of `O9`.
* **Open** — the disjunction `n_min p ∈ {⌈A⌉, ⌈A⌉+1}` (unproved); the threshold-form
  fourth order (`SFourth`).
* **A recorded caveat, not stale text** — `census_measure_eq` holds *by construction*:
  `reachableMeasure` is defined as `2^{n_min p}·tailSum p (n_min p)`, the right-hand side
  of the census law. The strictly geometric statement — that the `2^{n_min}` translates
  are pairwise disjoint with union exactly the sub-sum set — is **not** formalised;
  `Op56/Census.lean` states this as the remaining "census counting" gap. The arithmetic
  is verified numerically to `3.9·10⁻⁶²` for thirteen exponents.

## Running the checks

```sh
./check.sh --all                       # Lean 4 + Mathlib, 9 files, exits 0 (~5 min)
python3 op05_nmin.py                   # the threshold law and its bracket
python3 op06_reachable_fraction.py     # the reachable fraction
python3 op06_ceiling_coefficient.py    # the closed-form 1/p coefficient
python3 op09_moduli.py                 # the other-moduli falsification
python3 verify-006/op05_nmin_ceiling_false.py   # the 451-digit counterexample
```

`Op56/PhiThird.lean` and `Op56/PhiFourth.lean` take 78 s and 121 s respectively; the rest
are under 35 s.

## Dependencies

Everything needed is in this folder. The only external dependencies are **Mathlib**
(Lean) and **mpmath** (for the high-precision numerics in `verify-006/` and the `O9`
script). The `006/lean/Op56` copy of this development is **not** duplicated here: it is
byte-identical, and [`HANDOFF-006.md`](HANDOFF-006.md) records which is canonical.

## Provenance

Produced in the programme's `open/` and `006/` folders; see `research/truths.md` §9.
Sources are reproduced unmodified except that markdown links have been re-pointed into
this folder.
