# `rh47` — harvest: the greedy harmonic sine vs the TPC parity problem

## The goal of this round, and its status

**Goal:** *use the greedy harmonic sine to solve the parity problem for the twin prime
conjecture.*

**Status: not achieved, and this folder records why the programme's own results make
it a hard target rather than an oversight.**  The round harvests the conversation
(rh40–rh46) into one place, states the goal falsifiably, runs the first
reconnaissance against it, and fixes the barrier any greedy-sine attack must cross.

Nothing here solves, or claims to solve, the twin prime conjecture or the parity
problem.  `Σ_{n≤x}λ(n)λ(n+2) = o(x)` is **open** (rh46).

---

## 1. The two objects the goal fuses

**(A) The greedy harmonic sine** (rh41/rh42).  Alphabet `α_n = (−1)^n/(n+2)^p`; take a
term iff its sign matches the residual and it does not overshoot, never reuse.  Proved:
the word factors through the height `sin(2πθ)`; the signed support is **parity-locked**
(all gaps even); the budgets are `P(p) = 2^{−p}ζ(p)`, `N(p) = (1−2^{−p})ζ(p)−1`; the
exact reachable set is governed by **Brown's criterion**, and the positive half is
complete **iff** `p ≤ p*` with `ζ(p*) = 2`.

**(B) The parity problem / two-point Chowla** (rh46).  `λ(n) = (−1)^{Ω(n)}`;
`Σ_{n≤x}λ(n)λ(n+2) = o(x)` is **open**; `λ`-data on every finite prefix cannot decide
it (a `λ''` agreeing on all of `[1,10⁸]` has `S''(x)/x → 1`); a witness needs
**positive density** (`|S_A(x)−S(x)| ≤ 2·#{n≤x : n∈A or n+2∈A} ≤ 4·#{m≤x+2 : m∈A}`,
the corrected bound — see §3 and the Lean layer `lean/Rh47/Sparse.lean`).

## 1.5 The round's own new result: the greedy support is Sylvester-sparse

**Theorem.**  If `A = {m₁ < m₂ < …}` is the greedy support, then
`m_{i+1} ≥ m_i(m_i − 1) + 1`.  (After taking `1/m_i` the residual is
`< 1/(m_i(m_i−1))`.)  Consequently `|A| ≥ 20 ⟹ max A ≥ s₂₀`, a **106 721-digit**
integer: any target with a support large enough for a parity statistic has its largest
index beyond any computable `λ`.  The support density is `≈ 3.9·10⁻⁵`.

This is why the round's *specified* test has an **empty domain**: of 19 900 rational
targets with denominators `≤ 200` plus 400 with denominators up to `10¹²`, **none** has
`|A| ≥ 20`.  The relaxed diagnostic (8 820 targets with `|A| ≥ 4`) produced a nominal
`z = −47.9`, which the controls killed — positional sign-permutation `z = +0.43`,
rank-matched slots `z = +1.55`: the statistic was an artefact of repeated positions
(`m = 2` occurs in 70.5 % of supports).

## 2. The bridge the goal needs — and the barrier

Any such attack needs a map from the greedy word to the arithmetic of `Ω(n)`.  The
three candidates, with their status (all tested in
[`greedy_parity_probe.py`](../python/greedy_parity_probe.py)):

| bridge | statement | status |
|---|---|---|
| **B1** | the greedy *support* carries `λ`-parity signal | **no signal above a size-matched control** — the word is a function of the target `x` alone (deterministic, additive in `log n`), while `λ` is multiplicative |
| **B2** | the zeta budgets carry parity information | **index parity and `Ω`-parity are independent** (measured max relative deviation `<1%`); the budgets are sign-blind combinations of `ζ` |
| **B3** | the `ζ`-machinery applies to the correlation | **no Euler product**: `f(n) = λ(n)λ(n+2)` is not multiplicative (`f(1) ≠ 1`, coprime counterexamples); `D(2)` differs from the naive product by `≈2.01`, beyond the tail bound |

**The barrier in one sentence.**  Every greedy-sine object in rh41–rh45 is an
**additive character in `log n`** — the word depends on `sin(2πθ)`, the budgets on
`Σn^{−p}`, the balance on `Σn^{−it}` — whereas the parity obstruction is a statement
about a **multiplicative** function, and rh46 verified concretely that the two do not
mix.

## 3. What a successor round should do

* **R2 (the real target).**  Prove that a deterministic rule seeing `n` only through
  `log n` cannot force a multiplicative correlation — that would close the greedy-sine
  route *in principle*.  This is the honest ambition; solving twin primes is not.
* **R3.**  If an *arithmetic* enrichment is wanted, note immediately that indexing the
  alphabet by `(−1)^{Ω(p+2)}` imports the parity by construction — circular for the
  twin-prime purpose, useful only as a consistency check.
* **R4.**  Formalise the barriers already proved in prose (Brown, the parity lock, the
  worst-case smoothing bound, rh46's finite-prefix theorem).  **Partially done:** the
  rh46 finite-prefix layer is now fully certified (its last commented statement,
  `corrSlice_sub_corr_self_eq`, is proved — item OP-11), and
  [`lean/Rh47/Sparse.lean`](../../../twin-prime-parity/rounds/rh47/lean/Rh47/Sparse.lean) machine-checks the corrected sparse
  bound and refutes the inherited `2·#{n ≤ x+2 : n ∈ A}` form (item OP-12).  The
  Brown/parity-lock port as a *rh47* module and the negative statement R2 remain open.
* **R5.**  Keep the harvested "do not re-propose" list.

## 4. Files

| file | what it is |
|---|---|
| [`HANDOFF.md`](../../../twin-prime-parity/006/notes/HANDOFF.md) | the harvest: the chain of rounds, the proven facts with statuses, the three bridges and the barrier, the targets and the do-not-re-propose list |
| [`greedy_parity_probe.py`](../python/greedy_parity_probe.py) | the reconnaissance: support statistics vs `λ` with size-matched controls, the budget/parity independence, the Euler-product failure |
| [`verify/independent_check.py`](../../../twin-prime-parity/010/verify/independent_check.py) | the auditor's attack on the *barrier claim* itself |
| [`lean/`](lean) | R4: the barrier statements, to be formalised — [`Rh47/Sparse.lean`](../../../twin-prime-parity/rounds/rh47/lean/Rh47/Sparse.lean) and [`Rh47.lean`](../lean/Rh47.lean) now machine-check the corrected sparse bound, its sharpness witness and the falsity of the inherited form (item OP-12) |
| `truths.md` | the ledger (written once the audit lands) |

## 5. Reproduce

```
cd ../../..
python3 rh47/greedy_parity_probe.py
python3 rh47/verify/independent_check.py
cd rh47/lean && ./check.sh --all          # Rh47/Sparse.lean + Rh47.lean, exit 0
```


---

> **Record correction (from the research harvest at
> [`../../twin-prime-parity/`](../../README.md)).**  The
> harvested files correct two items in this round's documentation: the inherited claim
> that one-point Chowla is open (it is **equivalent to PNT**), and this round's own
> barrier phrasing ("additive character in `log n`"), which the audit showed is too
> wide — read it as *sign-blind alphabet, no arithmetic input*, with the impossibility
> kept **OPEN**.
