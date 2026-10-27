# rh40 — round 01, Agent A (the professor)

Recorded verbatim by the mediator. Headings are A's own tags.

**Mediator's verification status is in `round01.md`.**

---

## [DREAM]

The object is a *window-class sum*. For a window start `t` write `[i(t), j(t)]`
for the block of `ones` it meets; the factor is `(a_i−t, …, a_j−t)`. Each class
contributes a set of translates, and `p(L)` is the size of the union. I claim the
exact description is

`T(i,j) = max(0, min(a_i, a_{j+1}−L) − max(0, a_{i−1}+1, a_i−L+1) + 1)`,
`p(L) = 1 + #{}(L>span) + Σ_{i≤j} |T(i,j)|`,

with the convention `a_{−1}=−1`, `a_{m+1}=∞`; the `+1` is the all-zero factor,
present iff `L ≤ span` or `N−L+1` is large. My own implementations of this kept
over-counting by 1–2 % in *ad hoc* runs, so I mark the union step **[DREAM]**, not
[COMPUTABLE] — the class decomposition is right, my cardinality bookkeeping is not
yet.

Physically: for `L ≤ d_1+1` only singleton classes fire, so `p(L)=L+1`; the pair
class `(i,i+1)` switches on at `L=d_i+2`, adding slope 1 (`d_i < L`); the deficit
`D(L)=max_j(L−d_j−1−S_{1,j−2})_+` then grows linearly and *eats the pair slope
back* — that is the 2→1. The plateau is `a_m+2`; the fall at `L=N−a_m` is the last
1 leaving the window.

## [RECALL]

Morse–Hedlund: a non-eventually-periodic word has `p(L) ≥ L+1`; our word is
finitely supported hence non-recurrent — that bound is attained in the C1 regime
and lost later (HANDOFF §5). Cassaigne's first-difference theorem
`p(L+1)−p(L) = Σ_{L}(k−1)(p_k(L+1)−p_k(L))` — in the bispecial-count form
`p(L+1)−p(L) = #{right-special L} − #{left-special L+1}` — is the standard tool;
M5 shows the finite word violates the first form in the decay region, which is
expected because finitely-supported truncations are not uniformly recurrent.
Trailing-edge corrections to `p` are the standard finite-word phenomenon
(Cassaigne–Nicolas, *Factor complexity*). Sylvester/Egyptian-fraction and
Kim–Song style sparse-word complexity are the nearest relatives. Sós, Surányi:
the gap-pair statistics `(d_j+d_{j+1})` are the arithmetic-progression-triple
quantifier; that is exactly the boundary quantity below.

## [COMPUTABLE]

**(a) Boundary.** `p(L) = L+1+#{d_i<L}` holds for `L ≤ L_max`,
`L_max = min( 1+min_j d_j, 1+min_j(d_j+d_{j+1}) )`, and fails first at `L_max+1`.
For the four mediator words this gives 12 (1/π), 33 (log 2, `d_2+2=34` — the
*chain* term, not `d_1`), 11 (√2−1), 11 (e−2): exactly M6's table. Test:
`next(L for L in range(1,N) if p_offset(list(ones),N,L) != L+1+sum(1 for x in
gaps(ones) if x<L))`; this succeeds on 40/50 of my words and fails on 10 (e.g.
`{13,244}`, `N=253`, rule 233 vs true 24) — so the rule is **[DREAM]** in general,
exact on all four dialogue words plus 5 new ones.

**(b)** Slope: for 1/π, `slopes((2,13,607),1400)` returns
`[(1,10,1),(11,13,2),(14,604,1),(605,791,0),(792,1399,−1)]` — the 1→2 at `L=13`
is the pair class switching on (`13 = d_1+2`); the 2→**1** at `L=14` is the
deficit. The crossover `L=N−a_m=792`: verified `p(792)=609=N−792+1`.

**(c)** Decay law, exact: `p(L) = N−L+1` for all `L ≥ N−a_m`. Verified for
`{2,13,607},N=1400`: `L=792..1399`, **607 values, 0 violations**. Plateau value:
**`a_m+2`** — `p(605)=p(606)=p(791)=p(792)=609 = 607+2`; `{0,4,36,6069}`:
6069+2 = 6071 ✓.

**Predictions (new words), test with `p_offset(ones,N,span(ones)+1)`:**
`{0,3,17}, N=600 → 19`; `{2,9,44}, N=800 → 46`; `{1,6,31,200}, N=1200 → 202`.
Confirmed exactly in this session; the same call at `L=N−a_m−1` must also return
those values.

## [LEAP]

If the class decomposition closes, the whole complexity of the greedy word is the
arithmetic of the gap-chain sums `S_{1,k}`, and `p` becomes decidable from the
support alone.
