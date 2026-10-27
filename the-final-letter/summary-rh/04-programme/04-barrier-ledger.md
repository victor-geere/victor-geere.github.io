# The barrier ledger

> Source: [`dictionary/05-programme-barriers-and-harvest.md`](../../rh/research/twin-prime-parity/dictionary/05-programme-barriers-and-harvest.md). The capstone: P1–P19, B1–B5, N1–N3, the missing ingredient, and the verdict.

## 1. What the programme proved (the positive ledger)

| id | statement | status | source |
|---|---|---|---|
| P1 | the factor-complexity law `p(L) = min(a_m+1, N−L+1) + [L ≤ N−a_m−1]` for `L ≥ a_m+1` | **THEOREM** (Lean, 144 declarations) | rh41 |
| P2 | the budgets `P = 2^{−p}ζ`, `N = (1−2^{−p})ζ−1`, `P+N = ζ−1`, `P−N = 1−η`, `P > N` | **THEOREM** (Lean at `p=2,4`) | rh42 |
| P3 | **Brown's criterion**: sub-sums fill `[0,A]` ⟺ `a_k ≤ T_{k+1}` ∀`k` | **THEOREM** (one-step lemmas in Lean) | rh42 |
| P4 | completeness thresholds: positive half ⟺ `ζ(p) ≥ 2` (i.e. `p ≤ p*`); negative ⟺ `p ≤ q` | **THEOREM** | rh42 |
| P5 | the signed support is **parity-locked** (gaps even `≥ 2`) | **THEOREM** (Lean) | rh42 |
| P6 | the word factors through the height `sin(2πθ)` | **THEOREM** | rh42 |
| P7 | the balance identity `P_N + M_N = Re S_N`, and balance ⟺ `Re S_N = 0` | **THEOREM** (Lean) | rh43 |
| P8 | balance is attained for every `N ≥ 2` (`N=2` exactly at `π/log 2`; `N=3,4` by IVT) | **THEOREM** (Lean) | rh43 |
| P9 | `S_3(t) ≠ 0` ∀`t`; `S_2(π/log 2) = 0` | **THEOREM** (Lean) | rh43 |
| P10 | the sharp error at a zero is `√N/\|s−1\|`; the constant is `1/√(1/4+t²)` | **THEOREM** + NUMERICAL | rh43, rh044 |
| P11 | **smoothing does not remove `√N`**: `\|S_N^φ−ζ\|/√N → \|M_φ(s)\|` | **THEOREM** (asymptotic) + NUMERICAL | rh044 |
| P12 | exponential accuracy requires the functional equation (theta identity, `e^{−πX}` tail) | **THEOREM** | rh044 |
| P13 | the explicit formula **with the archimedean term**, verified ≥ 20 digits on four kernels | **THEOREM** + NUMERICAL | rh45 |
| P14 | `N(T) = θ(T)/π + 1 + S(T)` exactly; asymptotic with `+7/8` | **THEOREM** + NUMERICAL | rh45 |
| P15 | the trivial two-point bounds `\|S(x)\| ≤ x`, `S(x,0) = x`, and `o(x)` fails for `λ ≡ 1` | **THEOREM** (Lean) | rh46 |
| P16 | **finite-prefix indeterminacy**: `λ'' = λ` on `[1,10⁸]`, `1` beyond, has `S''/x → 1` | **THEOREM** (Lean slice layer) | rh46 |
| P17 | `f(n) = λ(n)λ(n+2)` is **not multiplicative**; no Euler product (`D(2)` off by `2.0144`) | **THEOREM** (Lean) + NUMERICAL | rh46 |
| P18 | the greedy support is **Sylvester-sparse**: `m_{i+1} ≥ m_i(m_i−1)+1` | **THEOREM** + NUMERICAL | rh47 |
| P19 | the one-point case `Σ_{n≤x}λ(n) = o(x)` is **equivalent to PNT** — a theorem | **THEOREM** (classical; correction X1) | [`03`](../../rh/research/twin-prime-parity/dictionary/03-parity-problem.md) |

## 2. The bridges, each disposed of

| bridge | claim | disposal |
|---|---|---|
| **B1** | the greedy support carries `λ`-parity signal | **REFUTED** (rh47): nominal `z = −47.9` killed by positional (`z = +0.43`) and rank-matched (`z = +1.55`) controls; the statistic is an artefact of repeated positions (`m=2` in 70.5 % of supports) |
| **B2** | the ζ budgets carry `Ω`-parity information | **REFUTED**: budgets are constants split by *index* parity; the four cells `(n even/odd)×(Ω even/odd)` give `χ²(1) = 2.944`; and index parity is *invisible* to the correlation (`S(λ·(−1)^n) = S(λ)` exactly) |
| **B3** | the `ζ`-machinery applies to the correlation | **REFUTED**: `f` is not multiplicative; `D(2) = −1.12681304` vs naive product `0.88757352`, discrepancy `2.0144` against tail `1.84·10⁻⁵` |
| **B4** | the support could be the positive-density witness | **REFUTED**: density `≈3.9·10⁻⁵`, so by the corrected sparse bound it moves `S(x)` by `O(log log x) = o(x)` |
| **B5** | an *arithmetic* alphabet (`α_p = (−1)^{Ω(p+2)}/(p+2)`) escapes the barrier | **REFUTED as a route** (circular): the signal lives in the **alphabet**, not the greedy selection, and importing `Ω(p+2)` is importing the very correlation under study |

## 3. What is *not* claimed, and why

**(N1) The `o(x)` statement is not proved, and cannot be by computation.**  `λ''`
agreeing with `λ` on `[1,10⁸]` has `S''(x)/x → 1` (P16), so prefix data cannot decide
the asymptotic.  A witness needs **positive density** (corrected sparse bound, X2).

**(N2) The impossibility is a heuristic, not a theorem.**  What is *proved* is: the
budgets are sign-blind (P2/rh47 B2); the correlation has no Euler product (P17); the
support is Sylvester-sparse (P18).  The statement *"no sign-blind `log n`-rule can
force a multiplicative correlation"* is **OPEN** — this is R2/OP-3, the programme's
real ambition.  The earlier phrasing "every greedy-sine object is an additive
character in `log n`" was **too wide** and is withdrawn (X5): `n^{−it}` is a
*multiplicative* character on `(ℝ₊,×)`, and the budgets are constants.

**(N3) No progress on twin primes.**  Nothing here gives a lower bound for prime pairs,
a positive proportion, or a zero-free region.

## 4. The precise missing ingredient

A successful attack needs a rule `R` and a statistic `T` such that

* `T` is computable from `R` and is **sign-blind** (otherwise the programme's objects
  are not sign-blind — fine, but then say which arithmetic input was imported, and
  check it is not circular);
* `T` is coupled to `Ω` at **positive density**: `Σ_{n≤x} T(n)λ(n) ≢ o(x)` (or the
  non-correlation `Σλ(n)λ(n+2) = o(x)` derived from it).

The programme supplies no such `R`/`T`, and its own structure theorems (P18, B2, B4)
say why the greedy ones cannot be it.  Deciding whether *any* sign-blind rule can work
is the open problem **OP-3** (R2), and it is not well-posed yet — the honest next step
is to make it well-posed (for instance: for the concrete instance
`Σ_{n≤x} 1_{cos(t log n)>0} λ(n)`, is it `o(x)`? — flagged unverified in
[`03`](../../rh/research/twin-prime-parity/dictionary/03-parity-problem.md), since no harvested technique settles it).

## 5. The verdict, in one paragraph

The programme set out to use the greedy harmonic sine to solve the parity problem for
the twin prime conjecture.  What it actually produced is a **complete map of the
barrier**: a proved complexity law and reachability theory for the greedy word; a
proved parity lock; the sharp constant for the partial-sum error at a zero; the proof
that smoothing cannot beat `√N` and that the functional equation is required; the
correct explicit formula; the **certified finite-prefix theorem** (its one clean new
theorem for the parity side) showing that no computation can decide `o(x)`; the proof
that the correlation has no Euler product; and the **Sylvester-sparsity theorem**,
which shows the greedy support is far too thin to be the positive-density witness any
proof of `o(x)` would need.  The goal is therefore **not reachable by this programme
as it stands** — and the next honest step is not a numerical push but a *well-posed
negative statement* (OP-3): that no sign-blind `log n`-rule can force a multiplicative
correlation.

*Status legend — THEOREM: proved (Lean where noted); NUMERICAL: finite computation
only, never a proof of an asymptotic; HEURISTIC: unproved; OPEN: no proof known;
REFUTED: with a witness.*
