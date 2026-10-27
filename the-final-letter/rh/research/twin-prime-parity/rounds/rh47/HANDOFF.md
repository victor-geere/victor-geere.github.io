# rh47 — HARVEST: the greedy harmonic sine against the TPC parity problem

**Created:** end of the rh46 round (the round that established that
`Σ_{n≤x} λ(n)λ(n+2) = o(x)`, the two-point Chowla statement, is **open** and cannot be
settled by finite computation).
**Working directory:** `/Users/victor/workspace/rh`.
**Stated goal of this round:** *use the greedy harmonic sine to solve the parity
problem for the twin prime conjecture.*

**Status of that goal, stated before anything else: it is not achieved here, and this
document records why the programme's own results make it a hard target rather than an
oversight.**  The round's job is to (i) harvest the conversation into one place,
(ii) state the goal precisely enough to be falsifiable, (iii) carry out the *first*
reconnaissance against it, and (iv) fix the barrier that any greedy-sine attack must
cross.  Everything below is either PROVED, VERIFIED, REFUTED, or OPEN in the house
style of rh40–rh46.

---

## 0. The harvest — the chain of rounds

| round | object | outcome relevant here |
|---|---|---|
| rh40 | factor-complexity law `p(L)` of the *unsigned* greedy word | K1 plateau + C1 regime (computed) |
| rh41 | the same law, closed | Theorems 1–12; Lean development, no `sorry` |
| rh42 | the *signed* Tau alphabet `(−1)^n/(n+2)^p`, helix, zeta budgets | budgets `P(p),N(p)`; **Brown's criterion** for the exact reachable set; parity lock of the signed support; the helix factors through `sin(2πθ)` |
| rh43 | partial sums of ζ at `Re(S)=0`; the equal split | balance ⟺ `Re S_N(t)=0`; attainable for every `N≥2`; the term-level split fails at balance points; divergence is linear |
| rh44 | the smoothing detour | **smoothing does not remove the `√N`**: `\|S_N^φ−ζ\|/√N → \|M_φ(s)\|`; exponential accuracy needs the functional equation |
| rh45 | the explicit formula, used explicitly | the correct Weil form (with the **archimedean term**, which my first draft omitted); `N(T)=θ(T)/π+1+S(T)`; zeros located to 32–33 digits |
| rh46 | `Σ_{n≤x}λ(n)λ(n+2)` | **OPEN**; trivial bound `\|S\|≤x`; the **finite-prefix indeterminacy** proof; the RH/Euler-product route fails (the correlation is not multiplicative) |

**The arc, in one line.**  rh43–rh45 chased the finite-`N` balance from the critical
line to the explicit formula and found that the transcendental obstruction is
irreducible (smoothing cannot beat `√N`; only the functional equation reaches
`o(1)`).  rh46 then tested the *other* side of the twin-prime question — the
correlation `Σλ(n)λ(n+2)` — and found it **open**, with a proof that no finite
computation can decide it.

---

## 1. The two objects that the goal proposes to fuse

**(A) The greedy harmonic sine (rh41/rh42).**  Alphabet `α_n = (−1)^n/(n+2)^p`
(`p = 1` on the helix pages), target a signed height `sin(2πθ)`; a term is taken iff it
has the residual's sign and does not overshoot, and is never reused.  Proved facts:

* the word factors through the height: `θ`, `θ+1`, `1/2−θ` give the same word; `1−θ`
  flips the sign (rh42 §8);
* the signed support is **parity-locked** (all gaps even, `≥ 2`) — `Rh42/Tau.lean`;
* the budgets are zeta values: `P(p) = 2^{−p}ζ(p)`, `N(p) = (1−2^{−p})ζ(p)−1`;
* the exact reachable set is governed by **Brown's criterion**: subset sums fill
  `[0,A]` iff `a_k ≤ T_{k+1}` for **every** `k`.  The positive half is complete
  **iff** `ζ(p) ≥ 2`, i.e. `p ≤ p* = 1.7286472…`.

**(B) The parity problem / two-point Chowla (rh46).**  `λ(n) = (−1)^{Ω(n)}`.  The
statement
```
Σ_{n≤x} λ(n) λ(n+2) = o(x)                                  (★)
```
is **open**.  What rh46 proved about the *logic*: `λ` and a modified `λ''` can agree on
**all** of `[1,10⁸]` while `S''(x)/x → 1`, so (★) is a tail property that no finite
computation can decide.  And any *sparse* modification is useless:
`|S_A(x) − S(x)| ≤ 2·#{n ≤ x : n ∈ A or n+2 ∈ A} ≤ 4·#{m ≤ x+2 : m ∈ A}` (the
corrected bound; the `2·#{n ≤ x+2 : n ∈ A}` form quoted in an earlier revision is
**false**, witness `A = {5}`, `x = 5`), so a witness needs **positive density**.
The corrected bound is machine-checked at [`lean/Rh47/Sparse.lean`](lean/Rh47/Sparse.lean)
(item OP-12).

---

## 2. The bridge that the goal needs — and the barrier

Any "greedy harmonic sine solves parity" argument needs a map from the greedy word to
the arithmetic of `Ω(n)`.  There are exactly three candidate bridges in this
programme, and this document fixes the status of each:

| # | candidate bridge | status |
|---|---|---|
| **B1** | the greedy *support* correlates with `λ`'s parity class | no mechanism known; the unsigned greedy word is a deterministic function of the target `x` alone, with **no arithmetic input**, while `λ` is multiplicative.  The signed support is parity-locked (rh42), which forces all its gaps even — a *rigidity* that constrains the word but says nothing about `Ω` |
| **B2** | the zeta budgets `P(p), N(p)` (rh42) carry parity information | **REFUTED direction**: the budgets are sign-blind combinations of `ζ(p)` — `P+N = ζ−1`, `P−N = 1−η` — so they separate *parity of index* (even/odd denominators), not the parity of `Ω(n)` |
| **B3** | use the greedy **balance** condition (rh43) to force a correlation | **REFUTED as a route**: rh44 showed the balance error is `√N·\|M_φ(s)\|` for every one-sided weight, so no balance condition can see `o(x)`; and rh46 showed the correlation is *not multiplicative*, so the `ζ`-based machinery does not apply to it at all |

**The barrier, in one sentence.**  Every greedy-sine object in rh41–rh45 is an
*additive character in `log n`* (the word depends on `sin(2πθ)`, the budgets on
`Σn^{−p}`, the balance on `Σn^{−it}`), whereas the parity obstruction is a statement
about a *multiplicative* function — and rh46 verified concretely that the two do not
mix: the naive Euler product of the correlation Dirichlet series differs from the
true value by `2.0144` at `s=2`, i.e. the correlation has no Euler product.

---

## 3. What this round verifies (done — 23/23 probe, 31/31 audit)

* **H1 (new theorem, the round's own result).**  The greedy support is
  **Sylvester-sparse**: `m_{i+1} ≥ m_i(m_i−1)+1`, so `|A| ≥ 20 ⟹ max A ≥ s₂₀`
  (106 721 digits) and the density is `3.9·10⁻⁵`.  The specified parity test has an
  **empty domain**; the relaxed version's nominal `z = −47.9` is killed by positional
  (`z = +0.43`) and rank-matched (`z = +1.55`) controls.
* **H2** the parity classes on twin-prime *candidates* stay balanced (rh46: ratio
  `0.9942` at `10⁵`, `0.9989` at `10⁶`).
* **H3** bridges B1, B2, B3 all fail: no signal (B1), index parity independent of
  `Ω`-parity and *invisible to the correlation itself* (`S(λ·(−1)ⁿ) = S(λ)` exactly,
  B2), no Euler product with discrepancy `2.0144` against tail `1.84·10⁻⁵` (B3).
* **H4 (honest conclusion).**  The goal **cannot be reached by the greedy-sine
  programme as it stands**.  The missing ingredient is a **sign-blind alphabet with a
  positive-density multiplicative coupling to `Ω`** — and the greedy support, being
  Sylvester-sparse, cannot supply it (by the corrected sparse bound it moves `S(x)` by
  `O(log log x)`).

**Two corrections the audit forced on this document's §2 barrier** (recorded in
[`truths.md`](truths.md) §3): the phrase "additive character in `log n`" is too wide
(`n^{−it}` is multiplicative on `(ℝ₊,×)`; the budgets are constants), and the barrier
must read **sign-blind, no arithmetic input** — the audit's C3a exhibits a greedy
object with an *arithmetic* alphabet (`α_p = (−1)^{Ω(p+2)}/(p+2)`, `z = +10.1`) whose
signal lives in the alphabet and is circular.  And "the two do not mix" is a heuristic
that must stay **OPEN**, unlike the two verified legs.

---

## 4. The round's plan (targets for a successor)

**R1 (falsifiable, cheap).**  Finish H1 properly: define a *support statistic* on the
greedy word (e.g. the density of the support in dyadic blocks, or the parity of the
greedy residual's denominator) and test it against `λ` on windows of increasing
length; report the discrepancy exponent.  If the statistic is a genuine function of
`x` alone, the test is guaranteed null — which is itself the point.

**R2 (the real target).**  Decide whether **any** deterministic choice rule based on
`sin`/`Σ1/n` can produce an object whose correlation with `λ` is not `o(x)`.  The
known barrier is that such a rule sees `n` only through `log n` (additive), while `λ`
is multiplicative; a proof that additive data cannot force a multiplicative
correlation would close the greedy-sine route *in principle* — and the round should
aim at exactly that statement, not at the twin primes.

**R3 (if R2 fails).**  Look for the minimal *arithmetic* enrichment of the greedy
alphabet that does couple to `Ω`: e.g. an alphabet indexed by primes only,
`α_p = (−1)^{Ω(p+2)}/(p+2)`, which imports the parity by construction.  Record
immediately that this is circular for the twin-prime purpose — importing
`Ω(p+2)` is importing the very correlation under study — and use it only as a
consistency check.

**R4 (Lean).**  Formalise the barriers that are already proved in prose: Brown's
criterion (exists in rh42's development), the parity lock (`Rh42/Tau.lean`), the
worst-case bound `‖S_N^φ − ζ‖ ≤ Σ‖1−φ(n/N)‖·n^{−σ}` (`Rh44/Smoothing.lean`), and the
rh46 finite-prefix theorem.  **Status update:** the rh46 piece is now
**certified** — [`../rh46/lean/Rh46/Chowla.lean`](../rh46/lean/Rh46/Chowla.lean),
530 lines, 42 theorems, `./check.sh --all` exit 0, no `sorry`, and its last
commented statement (`corrSlice_sub_corr_self_eq`) is now **proved** (item OP-11).
The `rh47` layer itself is no longer empty: [`lean/Rh47/Sparse.lean`](lean/Rh47/Sparse.lean)
machine-checks the corrected sparse bound
`|S_A(x) − S(x)| ≤ 2·#{n ≤ x : n ∈ A ∨ n+2 ∈ A} ≤ 4·#{m ≤ x+2 : m ∈ A}`, the sharpness
witness, and the falsity of the inherited `2·#{n ≤ x+2 : n ∈ A}` form (item OP-12).
What remains is the *negative* statement R2 below (the round's real ambition, now
made well-posed as OP-19 and still OPEN).

**R5 (the honest ledger).**  Keep the failure modes of rh43–rh46 in the "do not
re-propose" list of the successor: the `1/√(2t)` constant, the claim that smoothing
removes `√N`, the `N ≳ T²` cost estimate, the Cauchy-kernel normalisation, the
missing archimedean term, and the RH/Euler-product route to (★).

---

## 5. Do not re-propose (harvested from rh43–rh46)

1. `Σ_{n≤x}λ(n)λ(n+2) = o(x)` is **open**; no computation decides it (rh46 §1.4).
2. The correlation `n ↦ λ(n)λ(n+2)` is **not multiplicative**; no Euler product, no
   Perron route (rh46, verified discrepancy `2.0144` at `s=2`).
3. Smoothing cannot beat `√N` on the critical line (rh44).
4. The explicit formula needs the **archimedean term** and pole arguments `2φ(i/2)`
   (rh45).
5. The finite-`N` balance condition sees generic roots, not zeta zeros (rh43 §7.6).
6. The budget identities separate *index parity*, not `Ω`-parity (rh42 §2).
7. The signed support is parity-locked with even gaps — a rigidity, not a bridge
   (rh42 §7).

## 6. Reproduce

```
cd /Users/victor/workspace/rh
python3 rh47/greedy_parity_probe.py          # the H1–H3 reconnaissance
python3 rh47/verify/independent_check.py     # the audit
cd rh47/lean && ./check.sh --all             # the barrier statements (R4)
```


---

> **Record correction (from the research harvest at
> [`../../twin-prime-parity/`](../../README.md)).**  The
> harvested files correct two items in this round's documentation: the inherited claim
> that one-point Chowla is open (it is **equivalent to PNT**), and this round's own
> barrier phrasing ("additive character in `log n`"), which the audit showed is too
> wide — read it as *sign-blind alphabet, no arithmetic input*, with the impossibility
> kept **OPEN**.
