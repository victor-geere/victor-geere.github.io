# rh43 — HANDOFF: the partial sums of ζ at Re(S) = 0, and the equal split

**Created:** the round that follows rh42.
**Working directory:** `../../..`.
**Status:** rh43 open, question answered, proofs and certificates in place.  The
round's object is the **finite partial sum of the zeta Dirichlet series on the
critical line**, and the question is whether its positive and negative parts can be
split into two equal positive and two equal negative pieces.

**The one-paragraph version.**  Put `S_N(t) = Σ_{n≤N} n^{-it}` and split every term
by the sign of its real part into `P_N(t) ≥ 0` and `M_N(t) ≤ 0`.  The split is an
identity, `P_N + M_N = Re S_N(t)`, and "two equal positive and two equal negative
parts" is exactly `P_N = |M_N|`, i.e. `Re S_N(t) = 0` — one real equation.  (Read at
the level of the *terms* — can the positive terms be partitioned into two equal
halves? — the answer is no at the balance points, and this is a different question;
the exact subset-sum defect is `0.16996…` at `N = 6`.  See §2.5.)  **The
answer is yes for every `N ≥ 2`**: `N = 2` is balanced *exactly* at `t = π/log 2`
(a tangential zero, invisible to a sign-change scan), `N = 3` is balanced with the
explicit witness `t = 5/2` (`Re S_3(5/2) = -0.0843…`, the intermediate value
theorem gives the root — this is PROVED in Lean, no `sorry`), `N = 4` with
`t = 12/5`, and certified 47-digit root brackets exist for `N = 3..50`.  `N = 1` is
the only degenerate case (`Re S_1 ≡ 1`).  Three traps were found and are recorded:
the `N = 2` tangential zero; the *complex* partial sum, which vanishes exactly at
`N = 2` but provably never at `N = 3`; and the divergence, which is **linear**
(`|S_N| ~ N/√(1+t²)`), not `√N` as the neighbouring round's intuition suggests —
so only *finite* partial sums make the question well posed.

---

## 1. Where rh43 sits

| round | object | outcome |
|---|---|---|
| `rh40` | the factor-complexity law `p(L)` of the greedy word | K1 plateau + C1 regime (computation) |
| `rh41` | the same law, closed | Theorems 1–12, Lean development, no `sorry` |
| `rh42` | the signed (Tau) alphabet and the helix budgets | budgets, Brown's criterion, exact reachable sets, Lean |
| **`rh43`** | **the partial sums of ζ at `Re(S) = 0` and the equal split** | **this document + [truths.md](../../../../../geometric-dynamical-phase-transitions/truths.md) + `lean/`** |

Unlike the earlier rounds, rh43 does not inherit a greedy word: it goes back to the
Dirichlet series itself and asks what a "positive part" and a "negative part" can
mean on the critical line.  The answer is the real-part split of §2, and the round's
job is to say precisely what that buys and what it does not.

---

## 2. The object, the question, and the answer

### 2.1 The object

`S = i t` with `t` real, and

```
S_N(t) = Σ_{n=1}^{N} n^{-it} = Σ_{n=1}^{N} exp(-i t log n) ∈ ℂ          (S_N(0) = N)
P_N(t) = Σ_{cos(t log n) > 0} cos(t log n) ≥ 0        "the positive parts"
M_N(t) = Σ_{cos(t log n) < 0} cos(t log n) ≤ 0        "the negative parts"
```

### 2.2 The question and its readings

"Can the partial sum be separated into two equal positive parts and two equal
negative parts, using only the positive parts and the negative parts with normal
summation?"  The readings, and their fates:

| reading | statement | answer |
|---|---|---|
| **R1** the split balances | `P_N(t) = \|M_N(t)\|` | **yes, every `N ≥ 2`** (T3–T8) |
| **R2** all four pieces equal | `P/2 = \|M\|/2` | same as R1 (the equality is automatic once `P = \|M\|`) |
| **R2′** the positive *terms* split into two equal sub-sums | strictly stronger than R1 | **no** at the certified balance points: the exact subset-sum misses `P/2` (defect `0.16996…` at `N = 6`), structurally because `cos(t log 1) = 1` exceeds `P/2` whenever `P < 2` (T11′) |
| **R3** the complex partial sum vanishes | `S_N(t) = 0` | different question: `N = 2` yes (exactly), `N = 3` provably no, `N ≥ 4` open (T10–T11) |

### 2.3 The reduction, and the answer

```
P_N + M_N = Re S_N = 1 + Σ_{n=2}^{N} cos(t log n)        (identity)
P_N = |M_N|  ⟺  Re S_N(t) = 0                            (one real equation)
```

**Yes.**  `Re S_N(t) = 0` is attained for every `N ≥ 2`:

* `N = 2`: `t = π/log 2` gives `1 + cos π = 0` **exactly**.  The zero is tangential
  (`1 + cos(t log 2) ≥ 0` everywhere), so a sign-change search misses it — this was
  the round's first error and is now proved in Lean (`balanced_two`).
* `N = 3`: `Re S_3(0) = 3 > 0`, `Re S_3(5/2) < 0` (certified `-0.084335758298…`),
  so IVT gives a root.  **PROVED** in
  [`lean/Rh43/Balance.lean`](../lean/Rh43/Balance.lean), 38 theorems, no `sorry`, no
  new axiom; the two inputs are the trigonometric bounds
  `cos((5/2)log 2) < -0.16`, `cos((5/2)log 3) < -0.92`, derived from Mathlib's
  `log`/`π` bounds and the sine/cosine Taylor inequalities.
* `N = 4`: `Re S_4(12/5) = -0.9506772… < 0`, same route.
* `N = 3, …, 50`: certified root brackets, 47 digits each (the auditor's
  independent engine), reproduced by the round's own `ivmath` engine.
* every `N ≥ 3`: existence is **PROOF-SKETCH + VERIFIED** (equidistribution), and a
  self-contained proof is the main open item (§6).

### 2.4 The three traps

1. **The `N = 2` tangential zero.**  `Re S_2 ≥ 0` with zeros at `(2k+1)π/log 2`.
   The first draft of both the script and the Lean file said "`N = 2` has no root";
   the auditor's certified enclosure killed it.  The corrected Lean now contains
   `realPartial_two_pi_div_log_two`, `balanced_two`, `exists_balanced_two`.
2. **The complex sum is a different question.**  `S_2(π/log 2) = 0` exactly, while
   `S_3(t) ≠ 0` for *every* real `t` — proved in Lean
   (`zetaPartial_three_ne_zero`) by reducing to `m log 2 = n log 3`, i.e. `3^|n| = 2^|m|`.
   A blanket "the complex partial sum never vanishes" is false and was removed.
3. **The divergence is linear.**  `|S_N(t)|/N → 1/√(1+t²)` (certified:
   `|S_{10^4}(1)| = 7071.771405`), so the series is not ordinarily summable at
   `Re(S) = 0` and the question is only well posed for finite `N`.  The `√N` picture
   belongs to `Re(S) = 1/2`.

### 2.5 The term-level reading, and why it fails

The question can also be read at the level of the *terms*: "two equal positive parts"
= the positive terms partition into two subsets of equal sum.  That is strictly
stronger than `P = |M|` and it is **false** at the balance points: `cos(t log 1) = 1`
is the first positive term and it exceeds `P/2` whenever `P < 2`, which holds at the
smallest positive root for every `N` tested (`P = 1.00, 1.28, 1.48, 1.66, 2.02,
2.40, 2.74` for `N = 3,4,5,6,8,10,12`), and an exhaustive subset-sum confirms the
defect.  At `N = 3` it is starkest: the positive side is the single term `{1}`, which
cannot be split at all, while the *numbers* `P/2 = 1/2` and `M/2 = -1/2` pair up
perfectly.  So the two readings of the round's question have opposite answers, and
[truths.md](../../../../../geometric-dynamical-phase-transitions/truths.md) §3/§5 records both (`T9`, `T9′`, `F7`).

---

## 3. The evidence, in the rh40/41/42 house style

| evidence | what it is | result |
|---|---|---|
| [`zeta_split.py`](../python/zeta_split.py) | the round's main numerics: the split, the witnesses, the roots, the four-part split, the divergence | [`verify/zeta_split.log`](../../../twin-prime-parity/rounds/rh43/verify/zeta_split.log) |
| [`ivmath.py`](../python/ivmath.py) | the rigorous engine: `Num` = value + guaranteed error at 400 dps; `π` by Machin, `log n = 2 atanh((n-1)/(n+1))` over the prime factors, `cos`/`sin` by Taylor with explicit remainder bounds and argument halving | validated on 918 rational points + 198 logarithms, 0 containment failures |
| [`verify/independent_check.py`](../../../twin-prime-parity/010/verify/independent_check.py) | the auditor's independent route: fixed-point directed rounding, its own π/atanh/Taylor engine, nothing imported from the round | **102/102 checks pass** |
| [`lean/Rh43/Balance.lean`](../lean/Rh43/Balance.lean) | Lean 4 + Mathlib: the split identities, the two witness theorems, the `N = 3` non-vanishing | `./check.sh --all` → exit 0, no `sorry`, `#print axioms` = `[propext, Classical.choice, Quot.sound]` |

House rules inherited unchanged: exact or rigorously enclosed arithmetic for the
object (never a bare float judgement), every reported number carries its precision,
and every falsified statement is kept in [truths.md](../../../../../geometric-dynamical-phase-transitions/truths.md) §5.

---

## 4. The Lean development

`rh43/lean/` mirrors `rh42/lean/`: `check.sh` (with `--all` = `Rh43/Balance.lean
Rh43.lean`), a root module, and one self-contained module.

| file | contents |
|---|---|
| [`Rh43/Balance.lean`](../lean/Rh43/Balance.lean) | `zetaPartial` (the complex sum), `realPartial`, `posRe`, `negRe`, `balanced`; `zetaPartial_re`; the split identities and the balance equivalences; `posRe_nonneg`, `negRe_nonpos`; `realPartial_continuous`; the `N = 2` exact vanishing and balance; the `N = 3` witness and IVT existence; `zetaPartial_three_ne_zero`; `not_balanced_two_zero` with its corrected docstring |

38 theorems + 4 definitions, no `sorry`/`admit`/`axiom`/`native_decide`.

---

## 5. Corrections banked this round (do not re-propose the old forms)

1. "the split can be balanced iff `N ≥ 3`" — false; `N = 2` balances at `π/log 2`
   (F1 in truths.md §5).
2. "`N = 2` has no root of `Re S_2`" — false; the zeros are the tangential
   `(2k+1)π/log 2` (F2).
3. "the complex partial sum never vanishes for `N ≥ 2`" — false at `N = 2`; and
   "it vanishes for `N = 3`" is also false, provably (F4, T10/T11).
4. "`|S_N(t)|` grows like `N^{1/2}`" — false at `Re(S) = 0`; the growth is linear,
   `1/√(1+t²)` (F5).
5. "`P - |M|` is the imaginary part" — false; it is the real part (F6).
6. "the terms split two-and-two at a balance point" — **false** at the certified
   roots; the term `cos(t log 1) = 1` can never lie in a half while `P < 2`
   (`N = 6`: exact defect `0.16996…`).  The numeric pieces `P/2, M/2` are equal; the
   term-level partition is a different, refuted question (F7, T9′).

---

## 6. Open, and the next round

* **A self-contained proof of T7** (a root of `Re S_N` for every `N ≥ 3`) without
  quoting equidistribution — the numerically verified part is complete through
  `N = 200`.
* **Exact complex vanishing for `N ≥ 4`**: `N = 2` yes, `N = 3` no, `N ≥ 4` unknown.
* **The natural next question**: does any of this touch zeta's own zeros?  Nothing
  in this round relates a root of `Re S_N(t)` to a zero of `ζ(1/2 + it)` or `ζ(it)`;
  an explicit bridge (an approximate-functional-equation or a smoothing identity
  turning `S_N` into `ζ`) is the honest target, and it is *not* claimed here.
* **The imaginary-split convention** (auditor's C7): with the split by
  `-sin(t log n)` the balance condition is `Im S_N(t) = 0`, which also has roots for
  every `N ≥ 2` (`N = 3` at `2π/log 6`).  The convention must be stated whenever the
  question is posed.

---

## 7. Reproduce

```
cd ../../..
python3 rh43/zeta_split.py                    # main numerics  (verify/zeta_split.log)
python3 rh43/verify/independent_check.py      # the auditor's 102 checks
cd rh43/lean && ./check.sh --all              # the Lean development, exit 0
```
