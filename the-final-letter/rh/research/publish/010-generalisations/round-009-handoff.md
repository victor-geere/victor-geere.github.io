# HANDOFF — Angle parity and Ω-dependent signs: two decisive tests

**Directory** `research/twin-prime-parity/009/`
**Lean** `research/twin-prime-parity/009/lean/`
**Toolchain** Lean 4 `v4.35.0-rc2` + Mathlib at `$LEAN_PREFIX/mathlib4`
**Status** **COMPLETE** — sparse-pair lemma and crossing bound machine-checked;
Ω-sign test measured. **The parity barrier stands.**

> Read `notes/angle-parity-and-omega-signs.md` first; `index.html` is the paper.

---

## 1. The objective

Two obligations from the previous round:

1. machine-check the **sparse-pair lemma** for the eta/angle sign
   `w(n) = sign(sin(t log n))`: `|C − S| ≤ 2·#{crossings}` **and** the
   `O(t log x)` crossing bound;
2. test whether an **Ω-dependent sign** changes the shift-2 correlation by
   positive density (the backward criterion
   `M_w(x) = Σ λ(n)λ(n+2)(w(n)w(n+2)−1) ≢ o(x)`).

---

## 2. TL;DR

| item | status |
|---|---|
| **Lemma A** `\|Σ a n (w n w (n+2) − 1)\| ≤ 2·#crossings` | **PROVED** — `Op59.sparse_pair_bound` |
| **Lemma B** `#phaseCrossing ≤ 2·(⌊θ(N+2)/c⌋+1)` | **PROVED** — `Op59.phaseCrossing_card_le` |
| **Corollary** angle twist `= Σ a n + O(t log N)` | **PROVED** — `Op59.angle_twist_invisible` |
| cross-bound vs numerics (`t ≤ 100`, `X = 10⁷`) | **VERIFIED** — `01_angle_parity.py` |
| `w = (−1)^{ω(n)}` couples to Ω at positive density | **NUMERICAL** `U/x → 0.4717`, `M/x → 0.1589` |
| `(−1)^{ω}` **destroys** the pair cancellation (pole at `s=1`) | **NUMERICAL** + structural |
| squarefree / `χ₄` / angle preserve cancellation, change nothing | **NUMERICAL** `M/x ≈ 0` |
| any sign both preserving cancellation and separating Ω | **NONE FOUND** |
| `S(x) = o(x)` / twin primes | **OPEN** |

**Verdict.** A sign either **preserves** the pair cancellation (uninformative) or
**destroys** it (useless); none both preserves it and separates Ω. The reason is
structural: `Σ a(n)a(n+2)` has no Euler product for any `a` (the shift breaks
multiplicativity), so no twist restores it; and a sign that separates the pair
necessarily changes the sum it was meant to control.

---

## 3. Build and verify

```bash
cd research/twin-prime-parity/009/lean
./check.sh --all                      # Sparse, Phase, root -> 3/3 OK

cd ../verify
python3 01_angle_parity.py            # crossing counts + Lean-bound check
python3 02_omega_sign_test.py         # Ω-dependent sign table
```

Axiom footprint (`import Op59; #print axioms Op59.angle_twist_invisible`):
`[propext, Classical.choice, Quot.sound]` — **0 `sorry`, 0 `axiom`, no
`native_decide`**.

---

## 4. File map

```
research/twin-prime-parity/009/
  index.html                          the paper
  handoff.md                          this file
  notes/
    angle-parity-and-omega-signs.md   the note (read first)
  lean/
    check.sh  Op59.lean  README.md
    Op59/Sparse.lean    crossingSet, pair_prod_eq, sparse_pair_bound  (Lemma A)
    Op59/Phase.lean     phaseCrossing, phaseCrossing_card_le_of_le,
                        phaseCrossing_card_le, angle_twist_invisible (Lemma B + corollary)
  verify/
    01_angle_parity.py     crossing counts + Lean bound + C−S vs 2·crossed
    02_omega_sign_test.py  W/x, U/x, M/x for six signs
```

### Key Lean objects

```lean
def crossingSet (w : ℕ → ℤ) (N : ℕ) : Finset ℕ :=
  (Finset.range N).filter (fun n => w n * w (n + 2) ≠ 1)

theorem sparse_pair_bound (a w : ℕ → ℤ) (N : ℕ)
    (ha : ∀ n, |a n| ≤ 1) (hw : ∀ n, w n = 1 ∨ w n = -1) :
    |∑ n ∈ Finset.range N, a n * (w n * w (n + 2) - 1)|
      ≤ 2 * ((crossingSet w N).card : ℤ)

def phaseCrossing (θ : ℕ → ℝ) (c : ℝ) (N : ℕ) : Finset ℕ

theorem phaseCrossing_card_le (θ : ℕ → ℝ) (c : ℝ) (N : ℕ)
    (hθ : StrictMono θ) (hc : 0 < c) (_h0 : 0 ≤ θ 0) :
    (phaseCrossing θ c N).card ≤ 2 * (Nat.floor (θ (N + 2) / c) + 1)

theorem angle_twist_invisible ... :
    |∑ n ∈ Finset.range N, a n * w n * w (n + 2) - ∑ n ∈ Finset.range N, a n|
      ≤ 4 * ((Nat.floor (θ (N + 2) / c) + 1 : ℕ) : ℤ)
```

---

## 5. What is NOT proved

1. **`S(x) = o(x)` and twin primes remain open.** Nothing here advances them.
2. The Ω-sign table is **numerical** (`x = 10⁷`); finite data proves nothing about
   asymptotics (dictionary F4). The structural reading (the pole of
   `λ·(−1)^{ω}` at `s = 1`) explains the coupling.
3. The Lean lemmas are asymptotic-free and exact; they formalise *why* the angle
   sign is pair-invisible, not the analytic `θ n = t log n` instantiation (this is
   a one-line substitution: `StrictMono` of `t log n` for `t > 0`, `c = π`).
4. The dichotomy "preserves ⇒ uninformative, destroys ⇒ useless" is stated as a
   numerical/structural finding; only the angle side of it is a theorem.

---

## 6. Technique notes

**What worked.**
1. **Formalising the *mechanism*, not the analytic instance.** Lemma B is stated
   for an abstract strictly increasing phase `θ`, so no `Real.log`/`Real.pi`
   machinery is needed; the angle case is a substitution.
2. **The right fibre argument.** The first attempt bounded `#X_k` by
   `#{multiples}` via a *minimal* multiple index, which has unbounded fibres; the
   correct statement is "any two members of `X_k` differ by at most one", proved
   by a one-step monotonicity contradiction.
3. **Making the criterion measurable.** `M_w/x` distinguishes a sign that is
   invisible to the pair (`M/x ≈ 0`) from one that changes it at positive density,
   and `W/x` vs `U/x` separates a *density* effect from a *coupling*.

**Tactic traps (009 Lean).**
- `Finset.filter` with a predicate `∃ k : ℕ, …` over `ℝ` needs `classical`
  (`DecidablePred` is not synthesizable constructively).
- `Nat.le_floor` is not an `Iff` here (`Nat.le_floor.mpr` is unknown); use the
  floor-free parametrised form `phaseCrossing_card_le_of_le` with a hypothesis
  `θ(N+2) ≤ (K+1)c`, and derive the floor version from `Nat.lt_floor_add_one`.
- `mul_lt_mul_right hc` pulls a `MulLeftStrictMono` instance error; use
  `mul_lt_mul_iff_of_pos_right hc`.
- Do not `simp only [Finset.mem_range]` when you still need membership; keep
  `n ∈ Finset.range N` and use `Finset.mem_range.mp` later.
- `simp` cannot prove `({a, b} : Finset ℕ).card ≤ 2` when `a = b` is possible;
  use `Finset.card_insert_le`.
- `rwa [...] at h` closes the *current* goal; when the current goal is not the
  intended one, restructure with an explicit `have` (the `le_of_lt ?_` pitfall).
- `push_neg` is deprecated; still works, leave the warnings.

---

## 7. Next steps

1. **Instantiate the corollary** at `θ n = t log n`, `c = π` (prove `StrictMono`
   and `t log(N+2)/π` monotone), giving a closed-form `O(t log N)` theorem.
2. **Generalise the dichotomy.** Find a provable statement of the form: if `w` is
   `λ`-correlated at positive density then `Σ λ(n)λ(n+2)w(n)w(n+2) ≫ x` — i.e. the
   numeric dichotomy as a theorem.
3. **Test the automorphic sign of 008** (`χ_D` for real quadratic characters) with
   the same `M_w/x` criterion at larger `x`; all such signs are periodic, so the
   prediction is `M/x ≈ 0`.
4. **Test genuinely non-periodic arithmetic signs** (e.g. `w(n) = sign(sin(π Ω(n)))`
   is degenerate; `w(n) = (−1)^{ω(n)}` is the sharp one) and classify which
   `Ω`-functionals have a pole vs a zero at `s = 1`.
