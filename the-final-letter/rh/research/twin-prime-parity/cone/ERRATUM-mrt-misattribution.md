# ERRATUM: a misattributed theorem, and what it invalidates

**Status: this corrects claims I made in this session (goal 4 and goal 5). The error was mine, it
was not caught by any machine check, and it was caught by a subagent's source audit.**

## The false claim

I asserted, and built on, the statement:

> `Σ_{n≤x} λ(n)λ(n+1) = o(x)` **is a theorem** (Matomäki–Radziwiłł–Tao, 2015) — the "solved
> shift-1 case".

**That is false.** It appears in `exceptional_set.py` (comments), `exceptional-set-probe.md` (the
entire h=1-vs-h=2 framing), `shift-two-deconstruction.md` (the claim that, given MRT, shift 2 is
*equivalent* to the odd core), `shift-two-lateral-appendix.md` (item A3/B1), and in the goal-4 and
goal-5 objective texts.

## What the sources actually say (checked this session against the primary sources)

* **MRT, *An averaged form of Chowla's conjecture*, Algebra & Number Theory 9 (2015) 2167–2196,
  [arXiv:1503.05121](https://arxiv.org/abs/1503.05121)**, abstract, verbatim: *"This conjecture
  remains unproven for any `h_1,…,h_k` with `k ≥ 2`."* What they prove is the **average over
  shifts**: `Σ_{h_1,…,h_k ≤ H} |Σ_{n≤X} λ(n+h_1)···λ(n+h_k)| = o(H^k X)`.
* **Matomäki–Radziwiłł, *Multiplicative functions in short intervals*, Ann. of Math. 183 (2016),
  [arXiv:1501.04585](https://arxiv.org/abs/1501.04585)**, Corollary 2 (as reported): for every
  `h ≥ 1` there is `δ(h) > 0` with `(1/X)|Σ_{n≤X} λ(n)λ(n+h)| ≤ 1 − δ(h)` — a `1−δ` bound, for
  every `h` including `h = 1`, *not* `o(x)`.  (I did not fetch this paper's text myself; it is
  reported to me by the subagent audit and is consistent with MRT's abstract.)
* **Tao–Teräväinen, *The structure of correlations of multiplicative functions at almost all
  scales*, Algebra & Number Theory 13 (2019) 2103–2150,
  [arXiv:1809.02518](https://arxiv.org/abs/1809.02518)**, abstract, verbatim: they establish the
  `k`-point Chowla conjecture *"for `k` odd or equal to 2 for all scales `X` outside of a set of
  zero logarithmic density"* — an **almost-all-scales** statement, nothing at a prescribed scale.

So for `k = 2` the known results are exactly three: shift-averaged (MRT), logarithmically averaged
(Tao, *Forum of Math Pi* 2016), and un-averaged outside a zero-log-density set of scales
(Tao–Teräväinen). **No un-averaged case at a prescribed scale is known, for any shift.**

## How the error happened, and why nothing caught it

I labelled the claim EXTERNAL-with-citation, which is the correct protocol — and then cited the
wrong paper. Every machine check in this repository passed, because the *identities* are true and
unaffected; a misattributed external theorem is invisible to formal verification. The protocol that
would have caught it (fetch the source, read the abstract) is the one step I skipped, for a claim
that the whole of two rounds' interpretation rested on. It was caught by a subagent instructed to
audit mechanisms against primary sources.

## What is unaffected (all machine-checked, all still true)

* `lam_mul`, `lam_even_shift_two` — complete multiplicativity and the 2-adic identity.
* `chowlaSum_shift_two_split` — the exact parity split, valid for every `M`.
* `prime_dvd_shift_two`, `core_coprime`, `core_diff_squares` — the core's structural facts.
* `core_not_multiplicative`, `oddLam_not_multiplicative` — non-multiplicativity of the correlation
  sequence and of `oddLam`.
* Everything in goals 1–3: the four-density equivalence, the Abelian-mean results, the barriers,
  Wiener–Khinchin, the log-average blindness.  (Goal 2 used Tao's *logarithmically averaged*
  theorem, which **is** a theorem — that part was cited correctly.)

## Citation status after this round's check (fetched and read by me, not reported)

| source | what I read | verdict |
|---|---|---|
| [MRT, ANT 9 (2015)](https://arxiv.org/abs/1503.05121) | abstract | **VERIFIED**: "remains unproven for any h_1,…,h_k with k ≥ 2"; they prove the shift-average |
| [Matomäki–Radziwiłł, Ann. Math. 183 (2016)](https://arxiv.org/abs/1501.04585) | abstract | **VERIFIED for h=1**: the mean value of `λ(n)λ(n+1)` is "non-trivially bounded in absolute value by 1 − δ", and this "constitutes progress towards Chowla's conjecture". Their Corollary 2 covering *every* h is reported by the subagent audit — **not verified by me** |
| [Tao–Teräväinen, ANT 13 (2019)](https://arxiv.org/abs/1809.02518) | abstract | **VERIFIED**: k-point Chowla for k odd or 2 "for all scales X outside of a set of zero logarithmic density" |
| [Tao, Forum of Math Pi (2016)](https://arxiv.org/abs/1509.05422) | abstract | **VERIFIED, and this is the load-bearing one**: the two-point Chowla conjecture is stated for *all* affine pairs `(a_1 n + b_1)(a_2 n + b_2)` with `a_1b_2 − a_2b_1 ≠ 0`, and the **logarithmically averaged** version is proved for all of them, "thus breaking the parity barrier for this problem" |
| Pilatte's quantitative log-averaged bound (`(log x)^{1-c}`) | reported by the subagent | **NOT verified by me** |

**What the Tao citation settles.**  The core is the affine pair `(2,−1),(2,1)`, determinant `4 ≠ 0`, so
`Σ_{k≤K} λ(2k−1)λ(2k+1)/k = o(log K)` is a **theorem** — a literal instance, not an analogy.  Shift 1
is the pair `(1,0),(1,1)`, shift 2 the pair `(1,0),(1,2)`.  So:

> **The entire two-point affine family is known logarithmically averaged and open un-averaged.**
> The gap — logarithmic average → natural average — is *uniform across the family*, and shift 2 is
> not special in it.

That is the sharpest correct statement of where the difficulty sits, and it implies that any
deconstruction which treats shift 2 specially — including the one in
[`shift-two-deconstruction.md`](shift-two-deconstruction.md) — is addressing the wrong thing.  What
survives from the deconstruction is the exact identity and the structural facts about the core; what
does not survive is the idea that isolating the core isolates the difficulty.

## What the correction changes

1. **The deconstruction is a sufficiency, not an equivalence.**  `S₂ = S₁ + core` (identity) gives:
   *if* the shift-1 correlation and the core both vanish, *then* shift 2 vanishes.  The converse
   fails in general (the halves can cancel), and **both hypotheses are open**.  So the split does
   *not* reduce shift 2 to a solved case.  Machine-checked as
   `shift_two_of_shift_one_and_core` in `lean/ConeLean/ShiftTwoCore.lean`.
2. **There is no "differentiator" to explain.**  My A3/B1 story — "the core is a shift-1 correlation
   of a non-multiplicative sequence, so the MRT mechanism has nothing to consume" — presupposed a
   solved shift-1 case.  There is none.  The *fact* (oddLam is not multiplicative) stands; its
   claimed significance collapses.  The honest statement is the subagent audit's: every mechanism
   that reaches shift 1 reaches the core identically, and stops at an averaged statement in both
   cases — the core and shift 1 are the two parities of *one* open problem, `Σ_m λ(m²−1)`.
3. **Goal 4's probe never had a "solved control".**  It compared two open cases against random
   controls.  The data stand; the label "solved" does not.
4. **Goal 5's stated objective contains the false premise** and its deliverable (1) is therefore
   mis-stated.  Editing a goal requires a direct instruction from the user; flagged, not fixed.

## A derived consequence, checked this round (labelled)

From Tao–Teräväinen as quoted above, applied to the two fixed-shift pairs `(0,1)` and `(0,2)`:
outside a set of scales of zero logarithmic density (the union of their two exceptional sets, which
still has zero logarithmic density) both `S₁(X) = Σ_{n≤X} λ(n)λ(n+1)` and
`S₂(X) = Σ_{n≤X} λ(n)λ(n+2)` are `o(X)`.  Feeding that into the exact identity
`S₂(x) = S₁(⌊x/2⌋) + C(⌊(x+1)/2⌋)` gives

> `C(K) = o(K)` for all `K` outside a set of zero logarithmic density.  **(DERIVED, not a quoted
> theorem — the arithmetic is mine; the input is Tao–Teräväinen's abstract, verified above.)**

So the core sits in *exactly* the same position as every other member of the family: known outside a
zero-log-density set of scales, open at a prescribed scale.  This is further evidence against the
round-2 framing — there is no sense in which the core is the hard part and shift 1 the easy part;
they are the same statement at different affine parameters, with the same uniform gap.

## The corrected picture in one line

`Σ_{n≤x} λ(n)λ(n+2) = o(x)` and `Σ_{n≤x} λ(n)λ(n+1) = o(x)` are both open, and they are the even-`m`
and odd-`m` halves of the single open statement `Σ_{m≤x} λ(m²−1) = o(x)`.
