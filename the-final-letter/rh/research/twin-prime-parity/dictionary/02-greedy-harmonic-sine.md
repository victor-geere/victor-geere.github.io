# 02 — The greedy harmonic sine: the word, the Tau alphabet, the helix

Part of the **twin-prime parity programme** dictionary.
See also: [`00-dictionary.md`](00-dictionary.md), [`01-preliminaries.md`](01-preliminaries.md),
[`04-zeta-relations.md`](04-zeta-relations.md).

Sources: `rh40/rounds/truths.md`, `rh41/TRUTHS.md` + `rh41/lean/`, `rh42/truths.md` +
`rh42/lean/`, `rh43` (which uses the split), `rh47/truths.md` (the sparsity theorem).

---

## 1. The unsigned greedy word

**Definition 1.1 (the rule).**  Fix `x ∈ (0,1)`.  Put `r_0 = x`.  At step `n ≥ 0`
(with alphabet element `1/(n+2)`):
```
if r_n ≥ 1/(n+2):  take it,  r_{n+1} = r_n − 1/(n+2) ;
else:              skip it (permanently),  r_{n+1} = r_n .
```
The **word** is `w(x) = δ_0δ_1δ_2…` with `δ_n ∈ {0,1}`; the **support** is
`A(x) = {n : δ_n = 1} ⊂ ℕ`, and by the alphabet shift `m = n+2` we also write
`A(x) ⊂ {2,3,4,…}`.
*Status:* DEFINITION.  *Source:* rh41 §2.

**Definition 1.2 (factor complexity).**  `p(L)` = the number of distinct length-`L`
factors occurring in a length-`N` truncation of `w(x)`.
*Status:* DEFINITION.  *Source:* rh40/r41.

**Theorem 1.3 (the factor-complexity law — rh41, closed and formalised).**  For a
finite support `0 ≤ a_0 < … < a_m < N` and `L ≥ a_m + 1`,
```
p(L) = min(a_m+1, N−L+1) + [L ≤ N−a_m−1] .
```
*Corollaries:* plateau `a_m+2` on `max(span, a_m+1) ≤ L ≤ N−a_m−1`; decay `N−L+1`
afterwards; `p(N) = 1`, `p(N−1) = 2`; `max_L p(L) = a_m+2` once `N ≥ 2a_m+2`; and
always `p(L) ≤ a_m+2`.  The C1 regime `p(L) = L+1` holds for
`L ≤ min(min gap, a_0, N−a_0−1)`, each bound sharp.
*Status:* THEOREM (proved; formalised in `rh41/lean`, 7 modules, 144 declarations, no
`sorry`).  *Source:* rh41 `TRUTHS.md` Theorems 1–5, 12.

**Theorem 1.4 (rational termination).**  Every rational `x ∈ (0,1)` has a finite greedy
expansion; for `x = 1` the support is `{0,1,4}`.
*Status:* THEOREM.  *Source:* rh41 Theorems 7–8.

## 2. The signed (Tau) reading — the "harmonic sine"

**Definition 2.1 (the Tau alphabet).**  `α_n = (−1)^n/(n+2)^p`, `n = 0,1,2,…`, i.e.
`+1/2, −1/3, +1/4, −1/5, …` at `p = 1`.
*Status:* DEFINITION.  *Source:* rh42 §2.

**Definition 2.2 (the signed rule).**  At step `n`, take `α_n` iff
`sign(α_n) = sign(r_n)` **and** `|α_n| ≤ |r_n|`; then `r_{n+1} = r_n − α_n`; otherwise
skip it forever.  A term is used at most once.  The target is a signed height
`x = sin(2πθ)` (`θ` in turns).
*Status:* DEFINITION.  *Source:* rh42 §2.

**Theorem 2.3 (parity lock — THEOREM, Lean).**  For a positive target every take occurs
at an **even** index; for a negative target every take occurs at an **odd** index.
Hence every gap of a signed support is **even and ≥ 2**.
*Proof.*  The residual stays non-negative at a positive target (it can reach `0`
exactly), and odd-index terms are negative, so the sign test rejects them.  ∎
*Status:* THEOREM, machine-checked in `rh42/lean/Rh42/Tau.lean`
(`tauStep_nonneg`, `take_parity`, `support_subset_even`, `support_gap_even_and_two_le`).
*Note:* the strict form "the residual stays `> 0`" is false (`x = 1/2`, `p = 1`:
equality at the first take), which is why the checked statements are the non-strict
ones.

**Corollary 2.4 (Egyptian transfer).**  For `x > 0` the signed rule **is** the classical
Egyptian greedy on `{k^{−p}}` at target `2^p x` (term `n = 2(k−1)` has value
`2^{−p}k^{−p}`).
*Status:* THEOREM + NUMERICAL.  *Source:* rh42 §7 (`{0}↔{1}`, `{2,10}↔{2,6,38}`,
`{2,6,38}↔{2,4,20}`, `{0,2,34}↔{1,2,18}`).

## 3. The helix, and what the word cannot see

**Theorem 3.1 (factorisation through the height — THEOREM).**  The rule reads exactly
one real number, the height `x = sin(2πθ)`.  Therefore
```
θ, θ+1, θ+2, 1/2 − θ   give the SAME word;
1 − θ                  gives the sign-flipped height, hence the other word;
the lift (cos 2πθ, sin 2πθ, θ) is not periodic — the word cannot see it.
```
*Proof.*  The rule's only input is the target, and
`sin(2π(θ+1)) = sin(2πθ)`, `sin(2π(1/2−θ)) = sin(2πθ)`, `sin(2π(1−θ)) = −sin(2πθ)`.  ∎
*Status:* THEOREM + NUMERICAL (200 dps, prefixes above the `10⁻¹⁰⁰` precision floor).
*Source:* rh42 §8, `T16`.

**Corollary 3.2.**  No rule reading a **periodic** function of `θ` — in particular not
`θ mod 1` — can see the turn count; to see it the input must be non-periodic.  This is
the honest statement of the "the circle forgets the turns" claim.

## 4. The new sparsity theorem (rh47) — the programme's cleanest structural fact

**Theorem 4.1 (Sylvester-sparsity of the support — THEOREM).**  Let `A(x) = {m_1 < m_2
< …}` be the greedy support.  Then
```
m_{i+1} ≥ m_i (m_i − 1) + 1 .
```
*Proof.*  After taking `1/m_i` the residual satisfies `r < 1/(m_i(m_i−1))` (the
standard greedy remainder bound), so no index below `m_i(m_i−1)+1` can be taken.  ∎

*Consequences.*
* `|A| ≥ 20 ⟹ max A ≥ s_20` (the Sylvester sequence), an integer with **106 721
  digits**; so a target whose support is large enough for a parity statistic has its
  largest index beyond any computable `λ`.
* The support **density** is `≈ 3.9·10⁻⁵` (mean support size `2.95 → 3.90` for
  `N = 10² → 10⁵`).
* The size class is non-empty: the ladder `x_k = (s_{k+1}−2)/(s_{k+1}−1)` has support
  exactly `{s_1,…,s_k}`.

*Status:* THEOREM (proof above) + NUMERICAL (0 violations in 53 159 consecutive pairs).
*Source:* rh47 `truths.md` §1.

## 5. The budgets and the reachable set (summary; details in [`04`](04-zeta-relations.md))

```
P(p) = Σ_{k≥1} (2k)^{−p}    = 2^{−p} ζ(p)                 "positive budget"
N(p) = Σ_{k≥1} (2k+1)^{−p}  = (1−2^{−p}) ζ(p) − 1          "negative budget"
P + N = ζ(p) − 1 ,   P − N = 1 − η(p) ,   P > N for all p > 0 .
```
The **exact reachable set** (sub-sums of the two half-series, arbitrary subsets) is
governed by **Brown's criterion**: the sub-sums of `a_1 ≥ a_2 ≥ … > 0` fill `[0, A]`
iff `a_k ≤ T_{k+1}` for every `k`.  For the positive half this holds **iff**
`ζ(p) ≥ 2`, i.e. `p ≤ p* = 1.7286472389981836…`; for the negative half **iff**
`p ≤ q = 2.0767751792…`.  Beyond `p*` the reachable set is a union of exactly
`2^{n_min(p)−1}` disjoint intervals.
*Status:* THEOREM (`rh42/lean/Rh42/Reachable.lean`, `Budget.lean`) + NUMERICAL
(`rh42/verify/reachable.log`, `helix_zeta.log`).

## 6. Why this chapter matters for the goal — and its limit

The greedy harmonic sine is a genuinely rich object: a proved complexity law, a
parity-locked support, zeta-valued budgets, a complete reachability theory with
sharp thresholds.  But every one of these is a statement about **indices and
transcendental weights** — the rule reads only the target `x`, and nothing in it
refers to factorisation.  In particular (rh47 §2):

* the support carries **no** `λ`-parity signal above a size-matched control;
* the budgets split **index** parity, not `Ω`-parity, and index parity is *invisible*
  to the two-point correlation (`S(λ·(−1)^n) = S(λ)` exactly);
* the sparsity theorem above shows the support is too thin to be the positive-density
  witness that `o(x)` would need.

*Status legend — THEOREM: proved (Lean where noted); NUMERICAL: finite computation
only; HEURISTIC: unproved; OPEN: no proof known; REFUTED: with a witness.*
