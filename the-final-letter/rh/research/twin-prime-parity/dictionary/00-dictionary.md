# The programme dictionary — master index

A cross-referenced dictionary of the **twin-prime parity programme** as it stands after
rounds rh40–rh47 of the `/Users/victor/workspace/rh` workspace.  Every entry carries:

* a **status** — `THEOREM` (proved, with Lean where noted), `NUMERICAL` (verified by
  computation only), `HEURISTIC`, `OPEN`, `REFUTED`, `DEFINITION`;
* a **source** — the round and file that establish it;
* a **one-line statement**;

and, where useful, the **witness** (for refutations) or the **barrier** (for open
items).

> **The programme's goal** is to use the *greedy harmonic sine* (rh41/rh42) to solve
> the *parity problem* for the twin prime conjecture.
> **Its current verdict** is that this is **not achievable by the programme as it
> stands**, and the documents below record the precise reasons, the barriers, and the
> one clean new theorem (rh46's finite-prefix theorem) it has produced.

## How to read this directory

| file | contents |
|---|---|
| [`README.md`](../README.md) | the programme: one page, status, and the reading order |
| [`dictionary/00-dictionary.md`](00-dictionary.md) | **this file** — the master index, grouped by topic |
| [`dictionary/01-preliminaries.md`](01-preliminaries.md) | the objects and the analytic prerequisites |
| [`dictionary/02-greedy-harmonic-sine.md`](02-greedy-harmonic-sine.md) | the greedy word, the Tau alphabet, the helix, its proved laws |
| [`dictionary/03-parity-problem.md`](03-parity-problem.md) | the parity problem and the Chowla/Elliott landscape, with citations |
| [`dictionary/04-zeta-relations.md`](04-zeta-relations.md) | the ζ/η budgets, the balance split, the smoothing laws, the explicit formula |
| [`dictionary/05-programme-barriers-and-harvest.md`](05-programme-barriers-and-harvest.md) | **the capstone**: the positive ledger, the five bridges, the verdict, and the missing ingredient |
| [`checks/06-numerical-checks.md`](../checks/06-numerical-checks.md) | the register of numerical checks and what each does *not* establish |
| [`open/07-open-problems.md`](../open/07-open-problems.md) | the open-problems register and the research plan |
| `archive/` | harvested handoffs and ledgers of the individual rounds |

## Index. A — the analytic objects

| id | term | status | source |
|---|---|---|---|
| A1 | `ζ(s)`, Euler product, functional equation | DEFINITION | [`01`](01-preliminaries.md) |
| A2 | `η(s) = (1−2^{1−s})ζ(s)`, `η(1) = ln 2` | THEOREM | rh42 §5.1 |
| A3 | `λ(n) = (−1)^{Ω(n)}`, `μ`, `Λ` | DEFINITION | [`01`](01-preliminaries.md) |
| A4 | logarithmic Chowla (two-point) | THEOREM (Tao 2016) | [`03`](03-parity-problem.md) |
| A5 | un-averaged two-point Chowla `Σλ(n)λ(n+2) = o(x)` | **OPEN** | rh46, [`03`](03-parity-problem.md) |
| A6 | the parity phenomenon of sieve weights | THEOREM / HEURISTIC | [`03`](03-parity-problem.md) |

## Index. B — the greedy harmonic sine

| id | term | status | source |
|---|---|---|---|
| B1 | the greedy word `w(x)`: take `1/(n+2)` iff `r_n ≥ 1/(n+2)` | DEFINITION | rh41 |
| B2 | the factor-complexity law `p(L)` (plateau, C1 regime) | THEOREM (Lean) | rh41 `TRUTHS.md`, `lean/` |
| B3 | the signed *Tau* alphabet `α_n = (−1)^n/(n+2)^p` | DEFINITION | rh42 §2 |
| B4 | the sign-matched, no-overshoot, never-reuse rule | DEFINITION | rh42 `Tau.lean` |
| B5 | the word factors through the height `sin(2πθ)` | THEOREM | rh42 §8 |
| B6 | parity lock: the signed support has all gaps even `≥ 2` | THEOREM (Lean) | rh42 `Tau.lean` |
| B7 | the support is **Sylvester-sparse**: `m_{i+1} ≥ m_i(m_i−1)+1` | THEOREM + NUMERICAL | rh47 `truths.md` §1 |
| B8 | the helix `(cos 2πθ, sin 2πθ, θ)`; the word cannot see turns | THEOREM | rh42 §5.7 |

## Index. C — the ζ budgets and the reachable set

| id | term | status | source |
|---|---|---|---|
| C1 | positive budget `P(p) = Σ_{k≥1}(2k)^{−p} = 2^{−p}ζ(p)` | THEOREM (Lean at `p=2,4`) | rh42 §2 |
| C2 | negative budget `N(p) = Σ_{k≥1}(2k+1)^{−p} = (1−2^{−p})ζ(p)−1` | THEOREM | rh42 §2 |
| C3 | `P+N = ζ−1`, `P−N = 1−η`, `P > N` for all `p>0` | THEOREM | rh42 §2 |
| C4 | the pole is split: `P(p) ~ N(p) ~ 1/(2(p−1))` as `p↓1` | THEOREM + NUMERICAL | rh42 §5.2 |
| C5 | **Brown's criterion**: sub-sums fill `[0,A]` iff `a_k ≤ T_{k+1}` ∀k | THEOREM | rh42 §3 |
| C6 | positive half complete **iff** `ζ(p) ≥ 2`, i.e. `p ≤ p* = 1.7286472…` | THEOREM | rh42 `Reachable.lean` |
| C7 | negative half complete **iff** `p ≤ q = 2.0767752…` | THEOREM | rh42 §3 |
| C8 | censused reachable set: `2^{n_min−1}` intervals, measure `2^{n_min−1}T_{n_min}` | THEOREM | rh42 §3 |
| C9 | the four thresholds `pN < pP < p* < q` | NUMERICAL (rigorous enclosures) | rh42 §6 |

## Index. D — the balance split at `Re(S) = 0` (rh43)

| id | term | status | source |
|---|---|---|---|
| D1 | `S_N(t) = Σ_{n≤N} n^{−it}`, the split `P_N, M_N` by sign of `cos(t log n)` | DEFINITION | rh43 §0 |
| D2 | `P_N + M_N = Re S_N`; balance ⟺ `P_N = \|M_N\|` ⟺ `Re S_N(t) = 0` | THEOREM (Lean) | rh43 `Balance.lean` |
| D3 | for every `N ≥ 2` there is a height with `Re S_N(t) = 0` | THEOREM (`N=3,4` explicit; `N≥3` sketch) | rh43 §1 |
| D4 | `N = 2` balances **exactly** at `t = π/log 2` (tangential zero) | THEOREM (Lean) | rh43 |
| D5 | `N = 3` balances via `Re S_3(5/2) < 0 < 3 = Re S_3(0)` | THEOREM (Lean) | rh43 |
| D6 | `S_3(t) ≠ 0` for every real `t`; `S_2(π/log 2) = 0` exactly | THEOREM (Lean) | rh43 §2 |
| D7 | the term-level two-and-two split **fails** at balance points | NUMERICAL (exact subset-sum) | rh43 §3 |
| D8 | `\|S_N(t)\|` grows **linearly**: `\|S_N\|/N → 1/√(1+t²)` | THEOREM + NUMERICAL | rh43 §4 |
| D9 | at `σ = 1/2` the parts are `~ (2/π)√N`; the sharp error is `√N/\|s−1\|` | THEOREM + NUMERICAL | rh43 §7.6, [`../../../rh044/truths.md`](../rounds/rh044/truths.md) |

## Index. E — smoothing (`rh044/`) and the explicit formula (`rh45/`)

| id | term | status | source |
|---|---|---|---|
| E1 | **smoothing does not remove `√N`**: `\|S_N^φ−ζ\|/√N → \|M_φ(s)\|` | THEOREM (asymptotic) + NUMERICAL | [`../../../rh044/truths.md`](../rounds/rh044/truths.md) |
| E2 | the sharp constant is `1/\|s−1\| = 1/√(1/4+t²)`, **not** `1/√(2t)` | REFUTED (first draft) | [`../../../rh044/truths.md`](../rounds/rh044/truths.md) §0 R1 |
| E3 | the residual obeys `S_N^φ−ζ = N^{1−s}J_φ + φ(0)ζ(s) + R_N` | THEOREM + NUMERICAL | rh044 §2 |
| E4 | exponential accuracy requires the **functional equation** | THEOREM | rh044 §3 |
| E5 | the Weil explicit formula **needs the archimedean term** and poles `2φ(i/2)` | REFUTED (first draft) + THEOREM | rh45 `truths.md` §1 |
| E6 | counting: `N(T) = θ(T)/π + 1 + S(T) = (T/2π)log(T/2πe)+7/8+S(T)+O(1/T)` | THEOREM + NUMERICAL | rh45 §4 |
| E7 | zeros located from `ζ` evaluations alone to 32–33 digits | NUMERICAL | rh45 audit C2 |

## Index. F — the parity obstruction and the programme's barriers (rh46, rh47)

| id | term | status | source |
|---|---|---|---|
| F1 | `S(x) = Σ_{n≤x}λ(n)λ(n+2)`; trivial bound `\|S\| ≤ x`; `S(x,0) = x` | THEOREM (Lean) | rh46 `Chowla.lean` |
| F2 | `o(x)` fails for `λ ≡ 1` — `o(x)` is not a formal consequence | THEOREM (Lean `corrAsymptotic_zero_false`) | rh46 |
| F3 | `f(n) = λ(n)λ(n+2)` is **not multiplicative**; no Euler product | THEOREM (Lean) + NUMERICAL (`D(2)` discrepancy `2.0144`) | rh46 |
| F4 | **finite-prefix indeterminacy**: `λ'' = λ` on `[1,10⁸]`, `1` beyond, has `S''/x → 1` | THEOREM (Lean slice layer) + NUMERICAL | rh46 |
| F5 | a **sparse** modification cannot move `S`: `≤ 4·#{m ≤ x+2 : m ∈ A}` | THEOREM (corrected in rh47) | [`../../rh47/truths.md`](../rounds/rh47/truths.md) §3 |
| F6 | **bridge B1**: the greedy support carries no `λ`-parity signal | NUMERICAL (with controls) | rh47 §2 |
| F7 | **bridge B2**: the ζ budgets split *index* parity, not `Ω`-parity | THEOREM-adjacent + NUMERICAL (`χ²=2.94`) | rh47 §2 |
| F8 | **bridge B3**: the `ζ`-machinery does not apply to the correlation | THEOREM + NUMERICAL | rh47 §2 |
| F9 | the corrected barrier: *sign-blind alphabet, no arithmetic input* | **OPEN** (heuristic) | rh47 `truths.md` §3 |

## The three-line summary of the whole programme

1. **The greedy harmonic sine is rich but arithmetic-free.**  Everything it produces is
   a function of the target alone (B5, B7); its structure — budgets, completeness,
   parity lock — is a structure of *indices*, not of factorisations (C1–C8, F7).
2. **The parity obstruction is a statement about a multiplicative function** (A5, F3),
   and the programme's own rounds show the two do not meet: smoothing fails (E1), the
   explicit formula needs the functional equation (E5), and the correlation has no
   Euler product (F3).
3. **What would be needed is a sign-blind rule with a positive-density multiplicative
   coupling to `Ω`** — precisely what `o(x)` requires and what is open (F9, R2 in
   [`../open/07-open-problems.md`](../open/07-open-problems.md)).

*Status legend — THEOREM: proved (Lean in the round's `lean/` where noted);
NUMERICAL: finite computation only, never a proof of an asymptotic; HEURISTIC:
plausible but unproved; OPEN: no proof known; REFUTED: with a witness.*
