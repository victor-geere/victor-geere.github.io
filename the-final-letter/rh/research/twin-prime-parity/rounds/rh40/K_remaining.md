# rh40 — the remaining K problems: K2, K3, K4, K5, K6, K7

**Companion to** [`K1_plateau_theorem.md`](K1_plateau_theorem.md) (K1, CLOSED) and
[`rounds/truths.md`](rounds/truths.md) (the register).
**Status legend:** `PROVED` / `VERIFIED` / `REFUTED` / `PARTIAL` / `OPEN`.

---

## 0. Summary

| problem | before | after |
|---|---|---|
| **K1** plateau value `a_m + 2` | OPEN | **PROVED** (previous round) |
| **K2** plateau onset | OPEN | **PARTIAL** — determinacy settled (a shift-invariance theorem); no closed form |
| **K3** C1 boundary | OPEN | **PARTIAL** — regime `L ≤ min gap` proved; boundary open; one of my candidate equivalences refuted |
| **K4** general-`L` law | OPEN | **PARTIAL** — exact route found, closed form not |
| **K5** `A(N) = log₂ log N + O(1)` | `INHERITED` | **PROVED (lower)** and sharpened; upper OPEN |
| **K6** residual-orbit limit | protocol impossible | **REFUTED** as posed — the limit depends on `x`; replaced by `L¹` result + conjecture |
| **K7** inverse problem | unopened | see [`k7_alphabet.py`](verify/k7_alphabet.py) |

---

## 1. K3 — the C1 boundary. PARTIAL.

**Theorem D (PROVED).** If `L ≤ min( min_j d_j , a_0 , N − a_0 − 1 )` — with the convention that `min_j d_j = ∞` when `m = 0` — then

```
p(L) = L + 1,
```

which is the C1 law `p(L) = L + 1 + #{j : d_j < L}` in the regime where
`#{j : d_j < L} = 0`, together with the all-zero factor.

*Proof.* `L ≤ min_j d_j` means the ones are at least `L` apart, so every window of
length `L` contains **at most one** 1. Hence each non-zero factor is a singleton
`{x}` with `0 ≤ x ≤ L−1`, and different windows give different `x` (the window is
`[a_j − x, a_j − x + L − 1]`). The singleton factors are realised for exactly the
offsets `x` with `a_0 − L + 1 ≤ a_0 − x ≤ min(a_0, N − L)`, i.e. the `L` values
`x = 0 … L−1` when `L ≤ min(a_0, N−L)`; that is the `min_j d_j`, `a_0` and
`N−a_0−1` conjunction in the statement. `L ≤ N−a_0−1` additionally makes the
all-zero window available, which is the `+1`. ∎

**Verified exhaustively and unconditionally.** The implication was checked on
**399 486** (support, L) cases over all supports with `m+1 ≤ 4`, `N ≤ 31`, with
**zero counterexamples**. The three constraints are each necessary:

* `L ≤ min_j d_j` — without it two ones can share a window and the singletons merge;
* `L ≤ a_0` — for `ones = (1,)`, `N = 3`, `L = 2` the offsets needed are
  `{0, 1}` but offset `1` would need a window starting at `0`, and `L ≤ a_0` fails
  (`2 > 1`); the window set is `[max(0,a_0−L+1), min(a_0, N−L)] = [1, 1]`, giving
  only offset `0`;
* `L ≤ N − a_0 − 1` — this is what makes the all-zero window exist, and hence what
  supplies the `+1`.

**Refuted in-session (mine).** Two candidate generalisations were false and are
recorded so they are not re-proposed:

1. `C1 holds at L ⟺ L ≤ 1 + min_j d_j or L > max_j d_j` — **false on 65.6 %** of
   1 772 281 cases (all supports, `m+1 ≤ 4`, `N ≤ 25`, all `L`); still false on
   26 % when restricted to `L ≤ a_0+1`.
2. `p(L) = min(L, a_0, N−L+1) + [N−L > a_0]` for the single-one case — false at
   `a = 0, N = 1, L = 1`; the correct single-one law is
   `p(L) = min(L, a) + [N−L > a]` away from that degenerate case, checked over all
   `0 ≤ a < 40`, `N < 40`.

**Honest status.** The *regime* in which the C1 law holds is now characterised by
Theorem D (proved). The **boundary** — the largest `L` at which the C1 law still
holds, i.e. `span`-adjacent behaviour — remains **OPEN**, and register J13/F4/E4
now carries **six** refuted candidates (Agent A's, and five of mine). The lesson
recorded in the ledger: I generalised from four examples twice in this session,
which is exactly the failure mode the programme's protocol exists to catch.

## 2. K2 and K4 — the plateau onset and the general-`L` law. PARTIAL.

### 2.1 A determinacy theorem for the onset (new)

**Theorem E.** Let `onset(w) = min{ L : p(L) = max_L p(L) }`. Then `onset` is
**not** a function of `(gaps, N)` alone, but **is** a function of
`(gaps, N, a_0)` — equivalently of the full support and `N`.

*Proof of the negative half.* Exhaustive counterexample:
`gaps = (2,)`, `N = 6` gives `onset = 2` for the support `(0,2)` and `onset = 3`
for `(1,3)`, `(2,4)`, `(3,5)`. Over all supports with `m+1 ≤ 4`, `6 ≤ N ≤ 24`
there are **2 299** distinct `(gaps, N)` keys and **1 486** of them carry more
than one onset value.

*The positive half is a tautology, and should be said so.* The map
`(a_0, d_1, …, d_m, N) ↦ onset` is a function because `a_0` and the gaps determine
the support completely (`a_j = a_0 + d_1 + … + d_j`) and the onset is a function of
the support and `N`. The corpus check reflects that: on the same corpus the number of distinct
`(gaps, N, a_0)` keys equals the number of words, so the "0 failures" is a
restatement of completeness, not evidence. **The content of Theorem E is entirely
in the negative half.**

**This is why every candidate formula failed.** Register J11/J12 and E8 list four
refuted candidates; all four were functions of the gap sequence (and `N`) and so
were *provably* incapable of working before they were even tested. Theorem E
retro-explains the failures and tells the next attempt where to look: any correct
formula must use `a_0` (equivalently the absolute positions), not just the gaps.

### 2.2 The general-`L` law: exact route, no closed form

For `L ≥ span` the K1 proof gives the law. Below `span`, the natural coarse
encodings are **refuted** and the count must be taken over the factors themselves.
The refuted encodings, with their smallest counterexample (`ones = (0,1)`, `N = 3`,
`L = 1`, where windows `t=0` and `t=1` give the same factor `(0,)`):

```
p(L) = #{ F(t) : 0 ≤ t ≤ N−L },     F(t) = { a_j − t : t ≤ a_j ≤ t+L−1 },
```

with two exact structural facts attached: the **all-zero factor** occurs iff some
gap between consecutive support positions — or before the first / after the last —
is `≥ L+1` (verified on 634 004 cases, 0 mismatches); and the set of window starts
whose **last** 1 is `a_j` is exactly the interval
`[max(0, a_{j−1}+1, a_j−L+1), min(a_j, N−L)]` (verified on 297 910 cases,
0 mismatches).

* `(first index, offset)` — overcounts in **136 954 of 297 910** cases;
* `(first index, last index, offset)` — also not injective;
* `(support subset S, offset of the last 1)` — also not injective: `S = (0,)` and
  `S = (1,)` are different subsets realising the *same* factor.

So the subset is determined by the factor only when consecutive ones are more
than `L` apart — exactly the C1 regime of Theorem D. That is the concrete reason
no closed form in the first-1 data exists.

**Refuted this session:** `p(L) = Σ_j |X_j|` (the sum of the per-index offset
intervals) — the intervals overlap and the sum overcounts by up to 14 for 1/π and
41 for `(10,20,40,80)`. The correct count is the **union/offset-tuple set**, not
the sum.

**Corrected this session:** the all-zero condition is **not** any statement about
a single endpoint. In general a length-`L` window avoids the support iff it fits
inside one of the gaps, so writing the extended positions
`(−1, a_0, …, a_m, N)`, the all-zero factor occurs **iff some consecutive
difference is `≥ L+1`** (verified on 634 004 cases, 0 mismatches).

Three wrong forms were tried and are recorded: `a_0 + 1 ≤ N−L` (29 247 failures
on the 95 826-case corpus), `a_m + 1 ≤ N−L` (24 337 failures), and the
symbolic `a_0 + 1 ≤ N − L` I had carried over from the K1 regime. None is valid
outside the specific regime where the relevant gap is the trailing one. **The K1
proof is unaffected**, because there `L ≥ span` makes the trailing gap the only
one that can be large enough, and there the condition does reduce to
`a_m + 1 ≤ N − L`.

**Measured:** the plateau onset values 605, 6065, 250, 60, 53 have no formula in
the gap sequence (Theorem E makes that a theorem, not an observation).

---

## 3. K5 — `A(N) = log₂ log N + O(1)`. Lower bound PROVED, upper OPEN.

### 3.1 Status clarification (the requested item)

The handoff records `A(N) = log₂ log N + O(1)` as verified by a census to
`N = 128 541 453`. That census is consistent with it, but the *proof* direction
was never stated. Here is the correct split.

**Theorem F (rigorous, one-sided).** Let `x ∈ (0,1)` irrational, `r_0 = x`, and
`n_{k+1} = ⌈1/r_k⌉ − 2`. Then

```
A(N) ≥ log₂ log N − log₂ log(1/x) − 1 ,
```

i.e. `A(N) = Ω(log log N)` with the implied constant and additive term explicit.

*Proof.* `r_{k+1} = r_k − 1/n_{k+1}` and `1/n_{k+1} ≥ r_k`, so
`r_{k+1} ≤ r_k − r_k = 0` is the termination case and otherwise
`r_{k+1} ≤ r_k²`. Hence `r_k ≤ x^{2^k}`. Also `n_{k+1} = ⌈1/r_k⌉ − 2 ≤ 1/r_k + 1`,
so `n_k ≤ (1/x)^{2^{k−1}} + 1`. Therefore every `k` with
`(1/x)^{2^{k−1}} + 1 ≤ N` satisfies `n_k ≤ N`, i.e. contributes to `A(N)`, which
gives the stated bound. ∎

**Theorem G (the upper bound is open).** `A(N) ≤ log₂ log N + O(1)` would follow
from a **two-sided** squaring law `r_{k+1} ≥ c·r_k²` with `c > 0` fixed. But

```
r_{k+1}/r_k² = (1−f)/(1+(1−f)r_k),     f = {1/r_k},
```

which is `≤ 1` and has **no positive lower bound at all** — this is not merely
unproven, it is *impossible*: as `f → 1⁻` the ratio `→ 0`, and `f` can be
arbitrarily close to 1 (it equals `1 − ε` exactly when `1/r_k` is just below an
integer, i.e. when `r_k` is just above `1/(n−1)`). Over 3 000 random **exact
rational** starting points the measured minimum of the ratio is **1.95·10⁻⁴**,
and it is driven toward 0 by Diophantine approximation of `x`, not bounded away
from it.

**Consequence: no two-sided squaring law of the form `c·r_k² ≤ r_{k+1} ≤ r_k²`
with `c > 0` can hold.** So Theorem G's upper bound cannot be obtained that way,
and K5's upper half is genuinely open rather than merely unfinished. This also
strengthens the negative content of K5: the reason `A(N) = log₂ log N + O(1)` is
hard is that the residual map has *unbounded relative loss*, i.e. the index growth
can occasionally be much slower than the generic double-exponential rate.

### 3.2 What *is* rigorously established

| statement | status |
|---|---|
| `A(N) ≥ log₂ log N − log₂ log(1/x) − 1` | **PROVED** (Theorem F) |
| `log n_k / 2^k` converges to a finite positive constant | **VERIFIED** (1/π, log 2, √2−1, e−2, √3−1, log₁₀2; 14 indices each) |
| `⌊log₂ log₂ n_k⌋ = k + O(1)` | **VERIFIED** (same six targets, first 10 indices) — this is the empirical tightness of `A(N) = log₂ log N` |
| `A(N) ≤ log₂ log N + O(1)` | **OPEN** — needs `r_{k+1} ≥ c r_k²`, not proven |

**So the handoff's formula is correct in form and empirically tight, but only the
lower half is proved.** Two independent earlier claims were also wrong and are
noted for the record: the journal's "`A(N) = O(log log N)`" (an *upper* bound,
which is the unproved direction) and the handoff §2's census (consistent, but not
a proof).

*Correction to the record:* the journal's Round-5 line "A(N) = O(log log N)"
is the unproved half; what the super-exponential index growth actually gives is
the **lower** bound `A(N) = Ω(log log N)`. The two are not the same claim and the
register previously carried the handoff's version without flagging the direction.

---

## 4. K6 — the residual-orbit average. The handoff's claim is REFUTED.

K6 is **closed** as a question, and the answer is not the one the handoff posed.
Evidence: [`verify/k6_residual.py`](verify/k6_residual.py) (Agent B) and the
mediator's independent recomputation in
[`verify/verify_agentK6.py`](verify/verify_agentK6.py).

### 4.1 The correct coordinate system

With `u = 1/r_k`, `q_k = ⌈u_k⌉` and `s_k := q_k − u_k = 1 − f_k`, the squaring law
is exactly

```
u_{k+1} = q_k²/s_k − q_k = u_k q_k / (q_k − u_k),
```

and the induced map on the fractional part is

```
s_{k+1} = 1 − { q_k²/s_k }.
```

Verified in exact `Fraction` arithmetic on rational seeds and to working accuracy
on irrational ones. **The map is not the Gauss map** (`s ↦ 1 − {1/s}`); the
maximum deviation is 0.91. It is a *skew product over the escaping integer* `q_k`,
i.e. the Fibonacci–Sylvester greedy Egyptian-fraction digit map.

### 4.2 The density is Lebesgue, not Gauss–Kuzmin

Given the digit `q`, the conditional density of `s` is

```
μ_q(s) = q(q−1)/(q−s)² = 1 + (2s−1)/q + O(1/q²)  →  1,
```

verified: `μ_q` integrates to 1 to 25 digits, and its `L¹` distance from the
Gauss–Kuzmin density `1/((1+s) log 2)` is **0.172** at `q = 10⁶`. Hence

```
E[log s_k | q_k] = −1 + 1/(2q_k) + O(1/q_k²),
```

checked to 12 digits for `q ≤ 10⁶`. **So A's integral `−1` was right, but for the
opposite reason to the one proposed in the dialogue:** the density is Lebesgue,
not an exotic Gauss-like measure.

### 4.3 The correction term is absolutely convergent

`log c_k = log s_k − log(1 + s_k r_k)` with `0 ≤ log(1+s_k r_k) ≤ r_k` and
`Σ r_k ≤ Σ 1/(q_k−1) < ∞` by the Sylvester bound. Verified to 100 digits. So the
whole problem reduces to `Σ log s_k`.

### 4.4 The refutation

**Theorem (PROVED).** Let `q_0 = 4` and `q_{k+1} = 2q_k²`. This sequence is
Sylvester-admissible (`q_{k+1} ≥ q_k(q_k−1)+1`), so it *is* the digit sequence of
the greedy expansion of `x = Σ_k 1/q_k ≈ 0.2817384005`. The exact backward
relation `s_k = q_k²/(q_k + q_{k+1} − s_{k+1})` then gives

```
s_k → 1/2,   hence   (1/K) Σ_{k<K} log c_k → log(1/2) = −0.693147… ≠ −1.
```

The mediator reproduced this **both** backward (exact relation) and by running the
**forward** greedy map on `x` rebuilt from the sequence (the `s_k` values
0.45060809, 0.49242604, 0.49987799, 0.49999997 agree digit for digit). Therefore:

> **the handoff's "a limit independent of `x`" is FALSE.** There is no universal
> constant, and the handoff's equivalent question — "is `Σ log c_k` bounded?" —
> also has no uniform answer: it is bounded for some `x` and unbounded for others.

The mediator could **not** reproduce the stronger claim that the achievable limits
are *exactly* `(−∞, 0]` via `q_{k+1} = ⌊q_k²/s*⌋`: the cases `s* = 1/2` and
`s* = 0.1` work, but `s* = 0.9` and `s* = 0.99` do not (they give ≈ 0.794 and
≈ 0.839). That stronger claim is recorded as `PARTIAL`; the refutation itself needs
only the single explicit `x` above and is unaffected.

### 4.5 What remains true

* **PROVED:** for `x` uniform on `(0,1)`, `E[(1/K)Σ log c_k] = −1 + O(1/K)` —
  convergence in `L¹`, hence in probability.
* **`[CONJECTURE]`:** the same limit `−1` for Lebesgue-a.e. `x`. The reduction is
  written out but its key correlation lemma is stated, not proved.
* **`[CONJECTURE]`:** a family of `x` for which the limit does not exist at all
  (prescribed digit blocks); not reproduced by the mediator.

---

## 5. K7 — the inverse problem. The family is rigid; the dichotomy is false.

Evidence: [`verify/k7_alphabet.py`](verify/k7_alphabet.py) (delegated) and the
mediator's independent recomputation. **The delegated report's central structural
claim is refuted below**, so the corrected statement is given here.

### 5.1 Termination criterion (PROVED, verified)

For a non-increasing positive alphabet `α_n` and target `x`, the greedy rule halts
finitely iff `Σ_n α_n ≥ x`; the taken set is the initial segment
`{0, …, N−2}` with `N = min{n : Σ_{k<n} α_k ≥ x}`. For `α_n = (n+2)^{−p}` and
`x = 1`, since `Σ_{n≥0}(n+2)^{−p} = ζ(p) − 1`,

```
the family halts  ⟺  ζ(p) ≥ 2  ⟺  p ≤ p* = 1.728647238998183618135.
```

The threshold is **target-dependent**: for general `x` it is the root of
`ζ(p) − 1 = x`, e.g. `x = 1/2 → p = 2.18528545178748223`, `x = 0.9 → 1.7883`,
`x = 0.1 → 3.7706`. Recorded facts confirmed; the handoff's phrasing as a property
of `p` alone must be read with `x = 1`.

### 5.2 The delegated report's structural claim is REFUTED

The report states: *"the word is `1^{N(p)}0^∞`, so every gap is exactly 1 for every
`p`"*, and offers `p = 3/2` as a witness with **max gap 1**.

**Refutation.** For `p = 3/2`, `x = 1`: `N = 10`, so the initial segment is
`{0, …, 8}` with residual `r = 1 − Σ_{k=2}^{11} k^{−3/2} = 0.004663506…`. Because
`α_k → 0`, the residual *continues to select* every later `k` with `α_k ≤ r`
(that is `k ≥ 955` at that residual), then every later one again. The mediator's
full run gives

```
taken = {0,1,2,3,4,5,6,7,8, 34, 954, 77716, …}     max gap 76 762  (so far)
```

— **not** `1^{10}0^∞`. The error is reading `N(p)` as a stopping point: `N(p)` is
where the *initial segment* ends, not where the orbit ends.

### 5.3 The corrected structure theorem (PROVED)

For `α_n = (n+2)^{−p}`, `x = 1`, `p > 1`, with `S = ζ(p) − 1`:

| case | structure | halts? | gaps |
|---|---|---|---|
| `S < 1` (`p > p*`) | `1^∞` | never | all 1 |
| `S = 1` (`p = p*`) | `1^∞` | at the limit | all 1 |
| `S > 1` (`1 < p ≤ p*`) | `1^{N−1} 0^{…} 1 0^{…} 1 …` | **never** — infinitely many later selections | **unbounded** |

*Proof of the third row.* After the initial segment, `r = 1 − Σ_{k<N} α_k > 0`
is fixed and positive; `α_k → 0`, so the set `{k : α_k ≤ r}` is infinite (it is a
tail), and the residual is reduced by each such `α_k` but never reaches 0 because
`Σ_{k≥K} α_k < r` once `K` is large enough. ∎

So within the power family the report's "bounded gaps" reading is wrong for the
very case it cites; the gaps there are 25, 919, 76 761, … and unbounded.

### 5.4 The dichotomy is nevertheless FALSE

Not via the power family, but via the **exponential alphabet**, verified in exact
rationals by the mediator:

```
α_n = 2^{−(n+1)},   x = 1   ⟹   taken = {0,1,2,3,…},   max gap = 1,
```

and the process halts when the residual reaches 0 (it is `2^{−(n+1)}` after `n`
steps, so it never overshoots; the target is met exactly in the limit).

> **"You get bounded gaps OR termination, never both" is FALSE.** One alphabet can
> have both. (The handoff's `α_n = c·2^{−n}` counterexample was therefore right all
> along.)

### 5.5 The inverse problem proper — the negative answer (PROVED)

K1's Theorem A is **combinatorial and alphabet-independent**: for *any* finitely
supported 0/1 word, `p(L) = min(a_m+1, N−L+1) + [L ≤ N−a_m−1]` for
`L ≥ max(span, a_m+1)`, hence `max_L p(L) = a_m + 2`, a **number**. Any alphabet
with `Σ α_n ≥ x` halts (§5.1) and so has finitely many ones. Therefore:

> **no halting alphabet realises `p(L) = cL`** for any `c > 0`, and in particular
> not the Sturmian profile `p(L) = L + 1`. "Exact termination **and** linear
> complexity growth" is impossible — as a consequence of finite support, not of a
> threshold coincidence.

**What remains open:** non-monotone alphabets, where the taken set need not be an
initial segment (`α = [29/40, 1/2, 1/4, 3/20]`, `x = 7/8` gives taken `{0,3}`),
so richer complexity profiles may be realisable there. That is the only route the
programme has found to a non-rigid inverse answer.

---

## 5. Upgrades from `VERIFIED` to `PROVED`

| register id | statement | was | now |
|---|---|---|---|
| E1 | `max p = a_m + 2` | verified | **PROVED** (K1) |
| E5 | decay `p(L) = N−L+1` on `[N−a_m−1, N−1]` | verified | **PROVED** (K1 Corollary) |
| E6 | plateau ends at `N−a_m−1` | verified | **PROVED** (K1) |
| E7 | large-`L` law | verified | **PROVED** (K1 Theorem A) |
| D3 | ceiling regime | verified | **PROVED** (K1) |
| D5 | crossover identity | verified | **PROVED** (K1) |
| C1 | `p(L) = L+1` for `L ≤ min gap` | verified | **PROVED** (K3 special case) |
| F1 | C1 law for `L ≤ min gap` | verified | **PROVED** (K3 Theorem D) |
| F3 | ~~exact C1 condition~~ | verified | **REFUTED** — my two-branch equivalence is false on 65.6 % of cases |
| A5 / D7 | every rational terminates | verified | **PROVED** (elementary; the greedy map is the Sylvester/Engel greedy map on rationals, which terminates) |
| C8 | the word is non-recurrent, so `p(L) = L+1` for all `L` is impossible | verified | **PROVED** (elementary) |
| D1 | `p(L) ≤ N−L+1` | verified | **PROVED** (elementary) |
| D6 | squaring law | verified to 45 digits | **PROVED** symbolically: `r_{k+1} = r_k − 1/n` with `n = ⌈1/r_k⌉` gives `f = 1 − (n−1)r_k` and the stated form follows by one algebraic step |

**Still not upgradable:** E8/K2 (onset), F4/E4 (C1 boundary formula), I5–I7 (which
are computations, not propositions), G/H numbers (computations), and the E1
*proof* becomes K1's proof — the value is proven, the **onset** stays open.
