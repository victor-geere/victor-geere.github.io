# HANDOFF — Attempt at an automorphic/spectral input (twin-prime parity)

**Directory** `research/twin-prime-parity/008/`
**Lean** `research/twin-prime-parity/008/lean/`
**Toolchain** Lean 4 `v4.35.0-rc2` + Mathlib at `$LEAN_PREFIX/mathlib4`
**Status** **ATTEMPT COMPLETE (first round)** — reduction proved, function-field
realisation exhibited, non-transfer localised. **The parity barrier over ℚ is NOT
broken.**

> Read `notes/automorphic-spectral-attempt.md` first; it is the result.
> `index.html` is the rendered paper.

---

## 1. The objective

Attempt an **automorphic/spectral input** for the twin-prime parity problem
(dictionary `03` §5.4, route 3): the input that lets Friedlander–Iwaniec's
`X²+y⁴` capture its primes and that is missing for the pair `{n, n+2}`.

---

## 2. TL;DR

| item | status |
|---|---|
| the open core is a quadratic-polynomial sum `C(K)=Σ_{k≤K}λ(4k²−1)` | **PROVED** (Lean `Op58.Sh2_split`, `Ccore_eq_poly`) |
| `λ` completely multiplicative; (R1),(R2),(R3) numerical diff 0 | **PROVED / VERIFIED** |
| Weil–Deligne square-root cancellation (`Kloosterman ≤ 2√p`, `Gauss = √p`) | **VERIFIED** numerically, exact |
| `𝔽_q[T]`: Chowla cancellation + twin irreducibles (Sawin–Shusterman) | **THEOREM** (cited) + **VERIFIED** numerically |
| the automorphic/spectral input is realised over `𝔽_q[T]` | **YES** (cited, with numerics) |
| level of distribution of `λ` over ℚ ≈ `1/2` | **NUMERICAL** (crossover at `q ≈ √x`) |
| `C(K) = O(√K)` empirically | **NUMERICAL**; `C(K)=o(K)` **OPEN** |
| transfer of a level of distribution `θ>1/2` to `S(x)=o(x)` | **CONDITIONAL** (standard linear sieve) |
| break the parity barrier over ℚ | **NOT ACHIEVED** |

**Verdict.** Route 3 *reduces to routes 1–2* over ℚ. The automorphic/spectral
input is not hypothetical (it works over `𝔽_q[T]`), but over ℚ it requires
(a) a trace/automorphic object attached to `λ` — absent, since
`L(s,λ)=ζ(2s)/ζ(s)` is a ratio of `ζ` — and (b) a parity-breaking sign that is
*not* periodic mod `q` — and the only signs any `L`-function detects over ℚ are
Dirichlet characters, which are periodic and parity-blind (dictionary Thm 2.2).

---

## 3. Build and verify

```bash
cd research/twin-prime-parity/008/lean
./check.sh --all                      # Defs, Split, root — 3/3 OK
./check.sh Op58/Split.lean

cd ../verify
python3 01_reduction.py               # exact (R1),(R2),(R3); discrepancy 0
python3 02_level_and_growth.py        # C(K) growth; level of distribution of λ
python3 03_function_field.py          # Weil/Deligne; F_q[T] Chowla + twin primes
```

Axiom footprint (`import Op58; #print axioms Op58.Sh2_split`):
`[propext, Classical.choice, Quot.sound]` — **0 `sorry`, 0 `axiom`, no
`native_decide`**.

---

## 4. File map

```
research/twin-prime-parity/008/
  index.html                          the paper
  handoff.md                          this file
  notes/
    automorphic-spectral-attempt.md   the note (read first)
  lean/
    check.sh  Op58.lean  README.md
    Op58/Defs.lean     liouville_mul, liouville_two, liouville_sq,
                       liouville_pair, poly_identity, even_shift
    Op58/Split.lean    Sh, Ccore, sum_range_even_odd, Ccore_eq_poly, Sh2_split
  verify/
    01_reduction.py         (R1),(R2),(R3) with discrepancy 0
    02_level_and_growth.py  C(K) growth + level of distribution of λ
    03_function_field.py    Weil/Deligne bounds + F_q[T] Chowla/twin counts
```

### Key Lean objects

```lean
def Sh (h x : ℕ) : ℤ := ∑ n ∈ Finset.range (x + 1), liouville n * liouville (n + h)
def Ccore (K : ℕ) : ℤ :=
  ∑ k ∈ Finset.range (K + 1), liouville (2 * k - 1) * liouville (2 * k + 1)
theorem Sh2_split (x : ℕ) : Sh 2 x = Sh 1 (x / 2) + Ccore ((x + 1) / 2)
theorem Ccore_eq_poly (K : ℕ) :
  Ccore K = ∑ k ∈ Finset.range (K + 1), liouville (4 * k * k - 1)
```

---

## 5. What is NOT proved, and what would be needed

1. **Nothing here breaks parity over ℚ.** `S_2(x)=o(x)` and twin primes remain
   open; the note states this prominently.
2. **The number-field spectral realisation is not constructed** (O1). This is not
   a gap in the argument but the finding: there is no known automorphic object
   whose Hecke eigenvalues are `λ`, and `L(s,λ)=ζ(2s)/ζ(s)` has no monodromy.
3. **The level-of-distribution data is finite** (`x=10⁶`) and proves nothing
   (dictionary F4). It locates, not decides, the `θ=1/2` wall.
4. **`C(K)=o(K)` is open**; the empirical `O(√K)` shape is a target, not a result.
5. **The conditional transfer `(H_θ) ⟹ S_2=o(x)`** is the standard linear-sieve
   implication; it is stated, not formalised.
6. Citation `Duke–Friedlander–Iwaniec (1995)` is marked **unverified** in the
   note; the two Sawin–Shusterman abstracts were read and are quoted verbatim.

---

## 6. Technique notes

**What worked.**
1. **Grounding the route in the literature where it succeeds.** The decisive move
   was finding Sawin–Shusterman: parity *is* broken over `𝔽_q[T]` by geometric
   methods, so route 3 is not vacuous, and the comparison localises the ℚ-gap
   precisely (no sheaf/monodromy for `μ` over ℚ; character-mimicking unavailable).
2. **Reducing to a quadratic polynomial before invoking spectral theory.** The
   reduction `(R1)/(R2)` turns "the correlation is not multiplicative" from a
   blocker into a pointer: the object is `Σ λ(k²−1)`, the canonical
   spectral-method target.
3. **A "does the input work elsewhere?" test.** Instead of arguing abstractly
   about the barrier, exhibit the positively-working analogue (`𝔽_q[T]`) and its
   engine (Deligne bound) numerically. This is the strongest evidence structure in
   the note.
4. **Reading the audit's notation carefully.** `S_1` in the shift-2 audit is the
   *shift-one correlation*, not the one-point sum; the first draft of
   `01_reduction.py` used the wrong quantity and produced a nonzero discrepancy,
   which exposed the misreading immediately.

**Tactic traps hit (008 Lean).**
- `rw [← pow_mul]` does not fire on `(-1)^(2*c)`; use `Even.neg_one_pow` with an
  explicit `Even` witness.
- `omega` cannot prove `1 ≤ 2*k` because it is false at `k=0`; case on `k` first.
- `zify` needs *all* the Nat-subtraction side conditions as explicit hypotheses.
- `Finset.sum_range_succ'` introduces a `g 0` term; `liouville 0 = 0` must be
  supplied (`by simp`) and `zero_mul`/`add_zero` applied.
- `Finset.sum_congr` summand goals need explicit `omega` index equalities
  (`2*(k+1)-1 = 2*k+1`), not a goal-level `rw`.

---

## 7. Concrete next steps

1. **Average the polynomial.** `Σ_{D≤X} Σ_{k≤K} λ(k²+D)`-type sums are
   attackable by Kuznetsov/class-group methods (Duke–Friedlander–Iwaniec and
   successors); compute the averaged spectral quantity and see whether an
   unconditional power saving exists — the fixed `D=−1` is the barrier.
2. **Formalise `(H_θ) ⟹ S_2=o(x)`** (linear sieve) as a conditional theorem.
3. **Quantify (O3)**: state a precise "no trace-function analogue over ℚ" claim
   (e.g. the absence of a Frobenius/monodromy action on the µ-support) and test it
   for well-posedness — the honest analogue of dictionary OP-3.
4. **Push the `C(K)` growth** to `K=10⁸` with a linear sieve + segmented
   polynomial sieving, to sharpen the empirical `√K` exponent.
