# 041 — the greedy digit word: proven results

Every statement below is either **PROVED** (a written argument) or **CHECKED**
(exhaustively verified over all objects in a stated finite class). Nothing else is
listed. Evidence: `rigorous_check.py` in this folder — run it, 31/31 pass.

**Object.** For `x ∈ (0,1)`, the greedy rule at step `n` compares the residual `r`
with `1/(n+2)`: take the digit 1 iff `r ≥ 1/(n+2)`, and subtract. The word is
`w(x) = δ_0δ_1…`. Its support is `0 ≤ a_0 < … < a_m`, and

```
p(L) = #{ distinct length-L factors of w } = #{ {a − t : t ≤ a ≤ t+L−1} : 0 ≤ t ≤ N−L }
```

for a truncation of length `N`. Write `span = a_m − a_0` and `d_j = a_j − a_{j−1}`.

---

## 1. The complexity function

**Theorem 1 (main).** For `L ≥ max(span, a_m + 1)`,

```
p(L) = min(a_m + 1, N − L + 1) + [ L ≤ N − a_m − 1 ].
```

*Proof.* Let `t ∈ [0, N−L]`. If the window `[t, t+L−1]` contains `a_m`, then
`a_m − t ∈ F(t)` and it is the **maximum** of `F(t)` (every offset is `a−t ≤ a_m−t`
and non-negative). Hence `F(t) = F(t')` forces `a_m − t = a_m − t'`, i.e. `t = t'`:
the map is injective on the windows containing `a_m`, which number
`max(0, min(a_m, N−L) − max(0, a_m−L+1) + 1) = min(a_m+1, N−L+1)`.
A window that does not contain `a_m` lies entirely to the right of `a_m`
(`L ≥ span`), so it meets no support point and gives the single all-zero factor;
one exists iff `a_m + 1 ≤ N − L`. ∎

**Corollary 2 (plateau).** For `max(span, a_m+1) ≤ L ≤ N − a_m − 1`, `p(L) = a_m + 2`.

**Corollary 3 (decay).** For `L ≥ max(span, a_m+1, N − a_m − 1)`, `p(L) = N − L + 1`;
in particular `p(N−1) = 2` and `p(N) = 1`.

**Corollary 4.** If `N ≥ 2a_m + 2` then `max_L p(L) = a_m + 2`.
(If `N < 2a_m + 2` the plateau is empty and the maximum is smaller: e.g. support
`{0,…,199}`, `N = 259` has `max p = 60`.)

The bound `L ≥ max(span, a_m+1)` is **necessary**: for support `{0,1}`, `N = 2`,
`L = 1` the formula gives 2 but `p = 1`.

**Theorem 5 (C1 regime).** For `L ≤ min( min_j d_j , a_0 , N − a_0 − 1 )`,

```
p(L) = L + 1.
```

Each of the three bounds is necessary. This is the C1 law
`p(L) = L + 1 + #{j : d_j < L}` in the range where `#{j : d_j < L} = 0`.

## 2. Auxiliary structure

**Checked.** The all-zero factor occurs **iff** some gap between consecutive
support points — or before the first / after the last — is `≥ L+1`
(95 835 cases).

**Checked.** `#{ t : window contains a_m } = max(0, min(a_m,N−L) − max(0,a_m−L+1) + 1)`
(exactly, all `L`, 25 044 603 cases).

**Checked.** The offset-tuple count equals the bit-string factor count
(59 267 cases, all words of length ≤ 14).

**Theorem 6 (onset determinacy).** Write `onset(w) = min{ L : p(L) = max p }`.
Then `onset` is **not** determined by `(gap sequence, N)` (3 896 of 7 521 keys are
multi-valued), while it is trivially determined by `(gap sequence, N, a_0)` since
those determine the support. So any formula for the onset must use absolute
positions, not just the gaps.

## 3. The support: greedy orbits

**Checked, and PROVED in Lean (`Rh41/GreedyResidual.lean`).** `r_{k+1} ≤ r_k²` at every
active step (max observed ratio `0.993905`); the Lean theorem `squaring_law` proves it,
and `residual_invariant` gives `r_k < 1/(n_k+1)`.

**CORRECTED DIRECTION (B.2-ranking pass).** At the `k`-th support point `n_k`, with
`r_k` the residual *before* the take, the take rule and `residual_invariant` give
`1/(n_k+2) ≤ r_k < 1/(n_k+1)`, while `squaring_law` iterates to `r_k ≤ x^{2^k}`.  Hence

```
n_k + 2 ≥ 1/r_k ≥ x^{−2^k},      i.e.      n_k ≥ x^{−2^k} − 2,
```

so the support indices grow at least doubly-exponentially, and

```
A(N) := #{k : n_k ≤ N} ≤ log₂( log(N+2) / log(1/x) ) = O_x(log log N).      (*)
```

So `(*)` is the **upper** bound, and it is an *elementary consequence of the
programme's own proved squaring law*.  *(An earlier revision of this section read
`n_k ≤ (1/x)^{2^{k−1}} + 1` and `A(N) = Ω_x(log log N)` — the inequality stated in the
wrong direction, which would require a **lower** bound on the residual.  It is corrected
here; the register's OP-13 inherited the slip and is corrected the same way.)*

**The lower bound is the side that fails.** `r_{k+1}/r_k² = (1−f)/(1+(1−f)r_k)` with
`f = {1/r_k}` has **no positive lower bound** (Lean: `no_positive_lower_bound`;
minimum `1.58·10⁻⁴` over 4 000 exact rational orbits; it tends to `0` as `f → 1`), so the
residual may drop *faster* than squaring, no two-sided law `c·r_k² ≤ r_{k+1} ≤ r_k²` with
`c > 0` exists, and a matching lower bound `A(N) = Ω_x(log log N)` is **not available**
and is expected to be **false** away from a null set.  The upper bound `(*)` is what the
squaring law gives; the earlier framing had the two roles exchanged.

**Theorem 7 (maps).** With `u = 1/r`, `q = ⌈u⌉`, `s = q − u`, the orbit satisfies
exactly

```
u' = q²/s − q        and        s' = 1 − { q²/s }.
```

The induced map on `s` is **not** the Gauss map (max deviation 0.85). The relevant
density is Lebesgue, not Gauss–Kuzmin.

**Theorem 8 (rational termination).** Every rational `x` terminates; `x = 1`
(θ = π) has support exactly `{0, 1, 4}` since `1/2 + 1/3 + 1/6 = 1`.

**Checked.** All 277 reduced `p/q` with `q ≤ 30` terminate; 275 are reached within
`n ≤ 5·10⁶` (the two deepest are `4/25` at 53 307 974 and `27/29` at 1 003 066 151).

## 4. Alphabets `α_n = (n+2)^{−p}` and the inverse problem

**Theorem 9 (halting criterion).** For a non-increasing positive alphabet and
target `x`, the process halts finitely **iff** `Σ_n α_n ≥ x`. For
`α_n = (n+2)^{−p}` and `x = 1` this is `ζ(p) ≥ 2`, i.e. `p ≤ p*` with

```
p* = 1.7286472389981836181  (ζ(p*) = 2 exactly).
```

The threshold is **target-dependent**: for `x = 1/2` it is the root of
`ζ(p) = 3/2`, namely `p = 2.18528545179`.

**Theorem 10 (structure, corrected).** For `α_n = (n+2)^{−p}`, `x = 1`, `p > 1`,
with `S = ζ(p) − 1`:

| case | word | halts? | gaps |
|---|---|---|---|
| `S < 1` (`p > p*`) | `1^∞` | never | all 1 |
| `S = 1` (`p = p*`) | `1^∞` | at the limit | all 1 |
| `S > 1` (`1 < p ≤ p*`) | `1^{N−1} 0… 1 0… 1 …` | **never** | **unbounded** |

*Proof of the third row.* After the initial segment ends at
`N = min{n : Σ_{k<n} α_k ≥ 1}`, the residual `r = 1 − Σ_{k<N−1} α_k` is a fixed
positive number, while `α_k → 0`; so `{k : α_k ≤ r}` is an infinite tail, each
member is taken, and the residual never reaches 0. ∎

Concretely for `p = 3/2`: taken `= {0,…,8, 34, 954, 77716, …}` with max gap 76 762.

**Theorem 11 (dichotomy false).** `α_n = 2^{−(n+1)}`, `x = 1` selects **every**
index (max gap 1) and terminates exactly. Hence "bounded gaps OR exact
termination, never both" is false.

**Theorem 12 (inverse problem, impossibility half).** Any alphabet with
`Σ α_n ≥ x` halts (Theorem 9) and therefore has finitely many ones. By Theorem 4
its complexity satisfies `max_L p(L) = a_m + 2`, a number. Hence **no halting
alphabet realises `p(L) = cL`** for any `c > 0`, and in particular not the
Sturmian profile `p(L) = L + 1`. Exact termination and linear complexity growth
are impossible.

*Open:* non-monotone alphabets, where the taken set need not be an initial
segment and richer profiles may occur.

## 5. Refuted — do not re-propose

| statement | counterexample |
|---|---|
| `p(L) = min(a_m+1, N−L+1) + [L ≤ N−a_m−1]` for **all** `L` | `{0,1}`, `N=2`, `L=1`: formula 2, truth 1 |
| `p(L) = L + 1 + #{pairs at distance ≤ L}` | 1/π, `L = 11`: 13 vs 12 |
| `p(L) = L + 1 + #{distinct distances ≤ L}` | 1/π, `L = 11`: 13 vs 12 |
| `p(L) = L + 1 + Σ min(L−d_j, 0)` | 1/π, `L = 20`: 30 vs 24 |
| `p(L) = 2L − 10` on `12 ≤ L ≤ 593` | 1/π, `L = 100`: 190 vs 104 |
| `p(L) = min(L + span, N − L + 1)` | `{139,151}`, `N=172`, `L=13`: 25 vs 15 |
| the first-difference identity with a left-special correction | left-special count is 0 throughout; the correct correction is the count of length-`L` factors with no right extension |
| the residual-orbit average has a limit independent of `x` | `q_0=4, q_{k+1}=2q_k²` gives limit `log(1/2) = −0.6931…`, not `−1` |
| `A(N) = log₂ log N + O(1)` with an explicit constant | the per-step factor `r'/r²` has no positive lower bound (min 1.58·10⁻⁴), so only `Ω_x(log log N)` follows |
| `α_n = (n+2)^{−3/2}` has bounded gaps | max gap 76 762 |
| "bounded gaps OR termination, never both" | `α_n = 2^{−(n+1)}` has both |
| the onset is a function of the gaps | `gaps=(2,)`, `N=6`: onset 2 for `(0,2)`, 3 for `(1,3)` |
| `Σ_j \|intervals\|` counts the factors | the intervals overlap |
