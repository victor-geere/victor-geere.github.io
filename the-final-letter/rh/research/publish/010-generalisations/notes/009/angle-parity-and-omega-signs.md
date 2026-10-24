# Angle parity and Ω-dependent signs: two decisive tests

**Package** `research/twin-prime-parity/009/`
**Question** Two concrete obligations from the previous round:
1. machine-check the **sparse-pair lemma** — `|C − S| ≤ 2·#{crossings}` and the
   `O(t log x)` crossing bound, for the eta/angle sign `w(n) = sign(sin(t log n))`;
2. test whether an **Ω-dependent sign** changes the shift-2 correlation by
   positive density, i.e. whether it can break the parity barrier where the
   angle sign cannot.

**Status** both done. Result: a sign either **preserves** the pair cancellation
(and is uninformative) or **destroys** it (and is useless); none both preserves it
and separates Ω. The barrier stands, now with a proved lemma and a measured
dichotomy. Nothing here proves `S(x) = o(x)` or the twin prime conjecture.

---

## 0. Context: why the angle sign was even in play

For `s = σ + it`, the eta term is `n^{−s} = n^{−σ} e^{−i t log n}`, so
`Im(n^{−s}) = −n^{−σ} sin(t log n)` (terms "above the Re line" iff `sin < 0`) and
`Re(n^{−s}) = n^{−σ} cos(t log n)`. The angle sign `w(n) = sign(sin(t log n))` is
**not periodic**, so Selberg's parity principle (which governs weight classes
determined by small-prime residues) does not by itself exclude it. It had to be
tested directly. It fails — not because it is "parity-blind" in the residue
sense, but because it is **slowly varying across the pair**.

---

## 1. Move 1 — the sparse-pair lemma, machine-checked

### 1.1 The two lemmas

Both are proved in `lean/Op59` (`0 sorry`, `0 axiom`, footprint
`propext, Classical.choice, Quot.sound`).

> **Lemma A (`Op59.sparse_pair_bound`).** For `a, w : ℕ → ℤ` with `|a n| ≤ 1` and
> `w n ∈ {+1,−1}`,
> ```
> | Σ_{n<N} a n (w n · w (n+2) − 1) |  ≤  2 · #{ n < N : w n · w (n+2) ≠ 1 } .
> ```
> The left side is exactly `|C_w(N) − Σ_{n<N} a n|` for `C_w(N) = Σ a n w n w (n+2)`.

> **Lemma B (`Op59.phaseCrossing_card_le`).** Let `θ : ℕ → ℝ` be strictly
> increasing, `c > 0`, and call `n < N` a *phase crossing* if `(θ n, θ (n+2))`
> contains a positive multiple of `c`. Then
> ```
> #phaseCrossing  ≤  2 · ( ⌊θ(N+2)/c⌋ + 1 ) .
> ```

> **Corollary (`Op59.angle_twist_invisible`).** If every pair crossing of `w` is a
> phase crossing, then
> ```
> | C_w(N) − Σ_{n<N} a n |  ≤  4 · ( ⌊θ(N+2)/c⌋ + 1 )  =  O( θ(N+2)/c ) .
> ```
> For the angle sign, `θ n = t log n` and `c = π`, giving `O(t log N)`.

The mechanism, in one sentence: the two angles in the correlation differ by
`t log(1 + 2/n) = O(t/n)`, so `w(n+2) = w(n)` except where the phase crosses a
multiple of `π`; the intervals `(θ n, θ(n+2))` overlap at most twice (strict
monotonicity), so the crossing count is twice the number of multiples of `π`
below `θ(N+2)`.

### 1.2 The proof of Lemma B, in words

For a fixed multiple index `k`, the fibre
`X_k = { n < N : θ n < kc < θ(n+2) }` has at most two elements: if `m ≤ m′ − 2`
both lay in `X_k`, then `kc < θ(m+2) ≤ θ m′ < kc`, a contradiction. Hence any two
members of a fibre differ by at most `1`, and the case split on whether
`n₀+1 ∈ X_k` (where `n₀ = min X_k`) bounds `#X_k ≤ 2`. Summing over the fibres
`k ≤ ⌊θ(N+2)/c⌋` gives `#phaseCrossing ≤ 2(⌊θ(N+2)/c⌋+1)`.

### 1.3 Numerical confirmation (`verify/01_angle_parity.py`, `X = 10⁷`)

`crossed = #{n < X : w(n) ≠ w(n+2)}`, bound `= 2·(t log(X+2)/π + 1)`:

| `t` | `crossed` | `2(t logX/π + 1)` | bound ok | `\|C−S\|` | `2·crossed` |
|---|---|---|---|---|---|
| 1 | 10 | 12.3 | ✓ | 8 | 20 |
| 5 | 49 | 53.3 | ✓ | 14 | 98 |
| 14.134725 | 131 | 147.0 | ✓ | 42 | 262 |
| 50 | 421 | 515.1 | ✓ | 34 | 842 |
| 100 | 800 | 1028.1 | ✓ | 76 | 1600 |

Both Lean inequalities hold with room to spare at every `t`.

---

## 2. Move 2 — do Ω-dependent signs change the pair sum?

### 2.1 The criterion

To force `S(x) = o(x)`, a `±1` weight `w` must **change the pair sum at positive
density**, i.e.

```
M_w(x) = Σ_{n≤x} λ(n)λ(n+2) ( w(n)w(n+2) − 1 )   must NOT be o(x).
```

(Equivalently: `w` must not be invisible to the pair. This is necessary, not
sufficient — see §2.3.) We also measure the one-point coupling
`U_w(x) = Σ_{n≤x} λ(n) w(n)` and the mean `W(x) = Σ_{n≤x} w(n)`.

### 2.2 Results (`verify/02_omega_sign_test.py`, `x = 10⁷`)

| `w` | `W/x` | `U/x` | `M/x` |
|---|---|---|---|
| `λ` (circular) | −0.0001 | **1.0000** | **0.9999** |
| `(−1)^{ω(n)}` | −0.0002 | **0.4717** | **0.1589** |
| `2·1_{squarefree} − 1` | 0.2159 | 0.0003 | −0.0004 |
| `(−1)^{Ω(n)+ω(n)}` | 0.4717 | −0.0002 | −0.0005 |
| `χ₄` (Hecke character of ℚ(i)) | 0.0000 | 0.0003 | −0.0003 |
| angle sign, `t = 10` | 0.0500 | −0.0005 | 0.0000 |

### 2.3 Reading the table

* **`w = (−1)^{ω(n)}` genuinely couples to Ω-parity at positive density.** It has
  mean `≈ 0` yet `U/x → 0.4717 ≠ 0`, and `M/x → 0.1589 ≠ 0`. This vindicates the
  intuition that Ω-dependent signs *can* see parity. But the coupling is carried
  by the **density of its support**: the Dirichlet series of `λ·(−1)^{ω}` has a
  *pole* at `s = 1` (its local factor is `(1+2p^{−s})/(1+p^{−s})`), i.e. it is a
  main-term/bias effect — and it **destroys** the pair cancellation
  (`T/x → 0.159`, whereas `S/x ≈ 1.2·10⁻⁴`). It cannot be used to prove
  `S = o(x)`.
* **Signs that preserve the cancellation give nothing.** Squarefree parity, the
  automorphic sign `χ₄`, and the angle sign all have `M/x ≈ 0`: they leave the
  correlation (and hence its difficulty) untouched. Verified independently in the
  008 route: the Hecke character of ℚ(i) is periodic, hence inside the class the
  parity principle governs.
* **Only `w = λ` moves the pair sum by density — and it is circular** (`w` *is*
  the function under study).

The dichotomy is sharp: a sign either preserves the pair cancellation
(uninformative) or destroys it (useless). None both preserves it and separates Ω.
The reason is structural, not accidental: the pair correlation
`Σ a(n)a(n+2)` has **no Euler product** for any `a` (the shift breaks
multiplicativity), so no twist can restore multiplicativity; and a sign that
"separates" the pair necessarily changes the sum it was meant to control.

---

## 3. Status table

| item | status |
|---|---|
| Lemma A: `\|C−S\| ≤ 2·#crossings` | **PROVED** (Lean `Op59.sparse_pair_bound`) |
| Lemma B: `#crossings ≤ 2(⌊θ(N+2)/c⌋+1)` | **PROVED** (Lean `Op59.phaseCrossing_card_le`) |
| Corollary: angle twist `= S + O(t log N)` | **PROVED** (Lean `Op59.angle_twist_invisible`) |
| Lean/numerics agree on the crossing bound | **VERIFIED** (`01_angle_parity.py`) |
| `(−1)^{ω}` couples to Ω at positive density | **NUMERICAL** (`U/x → 0.472`) + structural (pole at `s=1`) |
| `(−1)^{ω}` destroys the pair cancellation | **NUMERICAL** (`M/x → 0.159`) |
| squarefree / `χ₄` / angle preserve cancellation, change nothing | **NUMERICAL** (`M/x ≈ 0`) |
| no tested sign both preserves cancellation and separates Ω | **NUMERICAL** + structural |
| `S(x) = o(x)` / twin primes | **OPEN** (untouched) |

---

## 4. Honest scope

* Finite ranges (`10⁶`–`10⁷`) prove nothing about asymptotics (006 dictionary F4,
  finite-prefix indeterminacy). They are diagnostics.
* The Lean lemmas are exact and asymptotic-free; they are the rigorous content of
  this round.
* The coupling constant `0.4717` for `(−1)^{ω}` is the density associated with
  "all exponents odd"; it is a *main-term* constant of a Dirichlet series with a
  pole, not a parity-breaking cancellation.
* Nothing here touches the Riemann Hypothesis or the twin prime conjecture.
