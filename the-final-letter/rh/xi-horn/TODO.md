# TODO — honest

State of the `docs/xi-horn/` work as of 2026-08-05. Ordered by whether it is
actually worth doing, not by how interesting it sounds.

**Framing, so nothing below is misread:** none of this is a route to the Riemann
Hypothesis, and none of it improves the arc's position, which remains
[rh28 §7](../html/rh28.html#s7) and [rh29](../html/rh29.html). What exists here is
exposition, a working figure, one clean reformulation, and twenty-two correction entries —
plus, since 2026-08-05, an arbitrary-precision implementation in
**[rust/](rust/)** which has closed the computational half of this list,
opened section G, and — as of **G1** — turned B1 from a conditional
certificate into an unconditional one. The mathematical content is classical
throughout.

**Six papers now sit in this directory.** Four of them pay down **A1** —
`turan-inequalities.pdf` and the three Connes PDFs. The other two are the ones
section **H** is built on:

- **[GOR⁺]** Griffin, Ono, Rolen, Thorner, Tripp, Wagner, *Jensen polynomials
  for the Riemann xi-function*, Adv. Math. **397** (2022) 108186 —
  [`jensens-polynomials.pdf`](jensens-polynomials.pdf)
- **[O'S]** O'Sullivan, *Zeros of Jensen polynomials and asymptotics for the
  Riemann xi function*, arXiv:2007.13582v2 —
  [`zeros-jensens-polynomials.pdf`](zeros-jensens-polynomials.pdf)

Both use **exactly this directory's γ(n)** — their γ(m) = m!/(2m)!·ξ^(2m)(½) is
what [POSITIVITY.md](POSITIVITY.md) (12) calls a(n), with no rescaling. (GORZ19's
is 8× larger; these two agree with us.) That makes every table in them a direct
check, and it makes two claims here retractable on sight: see **E8** and **E9**.

**The boxes.**

- `[x]` — **done.** Reproducible; the number is in [rust/RESULTS.md](rust/RESULTS.md)
  or the correction is applied in the file named.
- `[ ]` — **tractable.** Either debt worth paying or work worth doing, with a
  route and a cost estimate attached. Everything in this class is a decision
  about time, not about whether it can be done at all.
- `[-]` — **not tractable, or should not be done.** Dead ends, the genuine
  mathematical obstruction, and things whose cost/benefit is settled against
  them. Recorded so the ground is not re-covered.

## Status at a glance

| | | item | state |
|---|---|---|---|
| `[x]` | **A1** | verify the four "from memory" citations | **done 2026-10-11** — all four verified; Representation Formula (26) confirmed against Gentili–Struppa 2007 (restated in [arXiv:0905.1861](https://arxiv.org/abs/0905.1861) Thm 3.1), Connes 1999 Selecta bibliographic data confirmed via Connes–Consani [2006.13771](https://arxiv.org/abs/2006.13771) |
| `[x]` | **A2** | fold dictionary entries into `dictionary.html` | **done** — rh3 was already in; the real gap was rh29; xi-horn dictionary written and folded |
| `[x]` | **A3** | Γ_Φ near w = 0 | **done** — and there were *two* errors, not one |
| `[x]` | **A4** | CONTINUATION §8.3's z₂ row is wrong at w = 0, 8, 12 | **done** — table repasted, five columns, and the truncation claims retracted |
| `[x]` | **A5** | §4 overstates the "~4/\|w\|" and "no zeros" claims | **done** — both downgraded to what B3 and C3 actually measured |
| `[x]` | **B1** | certified discriminant signs | **done** — 35/35; but the *statement* is Chasse 2013, see **E8** |
| `[x]` | **B2** | resolve more of the Jensen flow | **done** — ten resolved at w = 0, and K_req is no longer open (**G6**) |
| `[x]` | **B3** | the "no zeros of R − 1" scan | **done as a scan** — and it argues for downgrading, not upgrading |
| `[-]` | **C1** | uniformity in the Jensen degree d | the real obstruction; nothing *here* moves it — but [O'S] moved it, e^d → d^(3/4) |
| `[ ]` | **C2** | is F(w, ·) ∈ LP *equivalent* to RH? | **half answered** — G4 says the continuum adds nothing; the equivalence itself is still open |
| `[x]` | **C3** | the constant in \|w\|(R − 1) → 4 | **measured, then derived** — see **G5**; the arrow is right after all |
| `[x]` | **G1** | γ(n) **bounded**, not measured — B1 without its conditional | **done** — 35/35 P certified from a proved enclosure; J only 15/35 |
| `[x]` | **G3** | CONTINUATION (22)'s pole string | **done** — every claim holds; the *derivation* does not, see **E14** |
| `[x]` | **G2** | push B1 until it breaks | **done** — the frontier is a staircase: P to d = 6 at n ≤ 120 |
| `[x]` | **G4** | does non-integer w add content? | **done** — no. 25 of 25 points, two truncations, every zero real |
| `[x]` | **G5** | the C3 constant, analytically | **done** — w(R−1) = 4 − 4/(1+W(w/π)) + O(1/w). The limit **is** 4 |
| `[x]` | **G6** | K_req(w, k), the truncation law | **done** — one law, K_req ≈ c·√\|z\| with c = 1.42 → 1.89 |
| `[x]` | **H1** | a(1000) against [O'S] Table 1 | **done** — all 20 published digits; the rule has ~113 to spare |
| `[x]` | **H2** | P^(d,n) and what it costs to certify | **done** — 175× to 6.0e9× looser than J, and **flat in n** |
| `[x]` | **H3** | where Turán's criterion actually starts to hold | **done** — P at n = 0 to **d ≤ 400**; J only to **d ≤ 7** |
| `[x]` | **H4** | γ(n) from two representations that are not the horn | **done** — 66–73 digits three ways; and [GOR⁺] (3.1) as printed returns **8γ(M)** |
| `[x]` | **H5** | the Lambert-W asymptotic | **done** — [O'S] Table 1's four rows reproduced from the Bell chain; not a cheaper route |
| `[x]` | **H6** | search Ω ∈ LP for the earliest onset | **done** — Ω = e^{−z²} is a razor-sharp optimum, but a **translation** takes d³ → d⁴ |

Every `[x]` below is reproducible with `cargo run --release --bin <name>` from
[rust/](rust/); the numbers are recorded in [rust/RESULTS.md](rust/RESULTS.md)
and asserted by the library's tests.

---

## A. Debts — things that are wrong or missing right now

### `[x]` A1. Verify every citation flagged "from memory." — DONE, 2026-10-11.

Four sat in the text unverified. **The two PDFs settle two of them**, with full
bibliographic detail and — better — with the statements restated in this
directory's own normalisation.

- `[x]` **Csordas–Norfolk–Varga 1986** — *The Riemann hypothesis and the Turán
  inequalities*, Trans. Amer. Math. Soc. **296** (1986) 521–541. Confirmed by
  both papers. [GOR⁺] Theorem 2.1 restates it in our γ: **γ(n−2)γ(n) ≤ γ(n−1)²
  for n ≥ 3**, i.e. log-concavity — which `rust` already tests
  (`the_laguerre_polya_sequence_is_log_concave`). [O'S] (1.5) gives the same
  thing as "J₂,ₙ hyperbolic ⟺ γ(n+1)² ≥ γ(n)γ(n+2)", first proved for all
  n ≥ 0 in [CNV86]. ([POSITIVITY.md](POSITIVITY.md) §3).
  [turan-inequalities.pdf](turan-inequalities.pdf) [AMS](https://www.ams.org/journals/tran/1986-296-02/) 
- `[x]` **Griffin–Ono–Rolen–Zagier 2019** — *Jensen polynomials for Riemann's
  zeta function and suitable arithmetic sequences*, PNAS **116**(23) (2019)
  11103–11110, arXiv:1902.07321. Confirmed. The Hermite limit is real and is
  now available in a sharper form than the one quoted here: [GOR⁺] Lemma 2.3
  gives it **exactly** — J̃₁,ₙ = H₁(X/2), J̃₂,ₙ = H₂(X/2), and
  deg(J̃_{d,n} − H_d(X/2)) ≤ d − 3 for d ≥ 3, under the renormalisation (2.6).
  ([POSITIVITY.md](POSITIVITY.md) §5, [INTEGERS.md](INTEGERS.md) §5) ·
  [jensens-polynomials.pdf](jensens-polynomials.pdf) is the *effective*
  successor [GOR⁺]; [zeros-jensens-polynomials.pdf](zeros-jensens-polynomials.pdf)
  (arXiv:2007.13582) is [O'S], and both are now cited throughout section **H**
- `[x]` Gentili–Struppa — slice regularity and the Representation Formula ([CONTINUATION.md](CONTINUATION.md) §8.1). *G. Gentili, D. C. Struppa, "A new theory of regular functions of a quaternionic variable," Adv. Math. 216(1) (2007), 279–301, doi:* [10.1016/j.aim.2007.05.010](https://doi.org/10.1016/j.aim.2007.05.010) *— paywalled at Elsevier, but the DOI resolves and the paper is cited as [1] by* [Colombo–Gentili–Sabadini–Struppa, arXiv:0905.1861](https://arxiv.org/abs/0905.1861), *whose Theorem 3.1 states the Representation Formula and attributes it to Gentili–Struppa 2007. **The formula (26) is verified correct**: Thm 3.1 reads `f(x+yI) = ½[f(x+yJ)+f(x−yJ)] + I·½[J[f(x−yJ)−f(x+yJ)]]`, which expands to exactly `½[(1−IJ)f(x+yJ)+(1+IJ)f(x−yJ)]`. Verified 2026-10-11.*
- `[x]` Connes 1999 *Selecta*, Connes–Moscovici prolate operator, Connes–Consani archimedean Weil positivity — asserted in conversation, not yet written into any file. *A. Connes, "Trace formula in noncommutative geometry and the zeros of the Riemann zeta function," Selecta Math. 5 (1999), no. 1, 29–106 —* [Springer](https://link.springer.com/article/10.1007/s000290050042) *(paywalled); free early version pulled (1997 EDP talk, same material):* [connes-1997-edp-trace-formula.pdf](connes-1997-edp-trace-formula.pdf) *· A. Connes, H. Moscovici, "Prolate spheroidal operator and Zeta,"* [arXiv:2112.05500](https://arxiv.org/abs/2112.05500) *(confirmed, 10 Dec 2021, 17 pp.) — pulled:* [connes-moscovici-prolate-zeta.pdf](connes-moscovici-prolate-zeta.pdf) *· A. Connes, C. Consani, "Weil positivity and Trace formula, the archimedean place,"* [arXiv:2006.13771](https://arxiv.org/abs/2006.13771) *(confirmed, 24 Jun 2020, 57 pp.; its abstract cites the 1999 Selecta paper with the exact journal/volume/pages, verifying that citation too) — pulled:* [connes-consani-weil-positivity-archimedean.pdf](connes-consani-weil-positivity-archimedean.pdf). *All confirmed 2026-10-11.*

The §8.1 argument *depends* on the Representation Formula being what I claim.
**It is** — the formula (26) matches Gentili–Struppa 2007 as restated in
[arXiv:0905.1861](https://arxiv.org/abs/0905.1861) Thm 3.1. **A1 is closed: no
citation in this directory is any longer unverified.** Nothing in the Rust work touched
it — arithmetic cannot verify a citation.

### `[x]` A2. Fold dictionary entries into `dictionary.html`. — DONE, 2026-08-05.

[docs/CLAUDE.md](../CLAUDE.md) makes this a standing, non-optional rule, and it
had been outstanding since the start of this work. Paid in full:

- `[x]` rh3's entries were already folded in — all **eighteen** of them (the
  "fifteen" this item carried was from memory), verbatim, as the `#rh3`
  section of [dictionary.html](../dictionary.html)
- `[x]` **the actual gap was rh29** — its §9 "Dictionary additions and
  references" (six entries) had never been folded; the aggregate stopped at
  rh28. rh30–rh39 were checked too: they reuse the `dl.dict` styling for
  "what this document leaves" lists and contain no dictionary sections, so
  rh29 was the only unfolded document in the series
- `[x]` xi-horn now has a dictionary — [README.md](README.md) §10, nineteen
  entries covering the whole directory (README, POSITIVITY, INTEGERS,
  CONTINUATION, the rust layer) — folded as the `xi-horn` section
- `[x]` the aggregate now reads 317 entries across 30 documents; the header
  count equals the `tr[data-k]` row count and every TOC link resolves

### `[x]` A3. Fix Γ_Φ near w = 0. — DONE, and the diagnosis was exactly right.

The dropped piece has a closed form. Below V₀ the amplitude has already settled
to Φ(0), so the tail of (25) is

```
4 ∫_{−∞}^{V₀} e^{(w+1)v} Φ(e^v) dv  →  4·Φ(0)·e^{(w+1)V₀}/(w + 1)
```

which at w = 0, V₀ = −16 is **2.010764550e−07** — precisely the −2.010e−07 this
item reported F(0, −γ_k²) returning instead of 0, identically at every k.
Restoring it analytically gives Γ_Φ(0) = 0.4971207781883141 against
ξ(½) = 0.4971207782, removing **4.045e−07** of relative error. Two things
beyond the diagnosis above, both found by testing rather than by reading:

- `[x]` **there was a second V₀ error.** The trapezoid rule is spectrally
  accurate only once the integrand has decayed at *both* ends, and at V₀ = −16
  it is still 5e−8 there — so Euler–Maclaurin leaves a boundary term
  −h²/12·f′(V₀). Measured: 1.3e−13 relative at w = 0, scaling as h² rather than
  vanishing (h = 0.004 and h = 0.002 disagree by 3.4e−19 at V₀ = −30). **No tail
  correction repairs it.** V₀ = −50 does, and that is now the default.
- `[x]` **the fix is free continuation.** That 1/(w + 1) is the very pole
  [CONTINUATION.md](CONTINUATION.md) (22) predicts, so the corrected evaluator
  continues Γ_Φ meromorphically to Re w ≤ −1 at no extra cost — but the
  residues it predicts are still unchecked, which is **G3**.

Implementation: `rust/src/mellin.rs`, driver `bin/a3_gamma_phi`.

### `[x]` A4. CONTINUATION §8.3's z₂ row was wrong in three places. — DONE.

Found while doing B2, and repaid once **G6** made the truncation control real
rather than anecdotal. At w = 0 the zeros of F(0, ·) are *exactly* −γ_k², so
the row is checkable against a known answer, and §8.3 printed **−442.41** where
the answer is **−441.9262**; w = 8 and w = 12 were off by more than rounding
too (−639.18 for −638.9887, and −739.87 for **−746.1074**).

- `[x]` **the table is repasted** from `bin/b2_flow`, now five columns wide
  (z₁ … z₅ at w = 0, 1, 2, 4, 8, 12), every entry stable between K = 128 and
  K = 140, found by bisection inside a one-root bracket rather than by a global
  solve. The z₁ column reproduced everywhere and still does; dz₁/dw comes out
  −21.47, −21.76, −23.01 against §8.3's −21.43, −21.76, −23.01.
- `[x]` **§8.2's "the first two computed zeros land at −199.786 and −442.407"
  is replaced** by the first nine, at 170 terms, agreeing with −γ_k² to
  6.5e−20 … 7.4e−17 — which is the twenty-digit γ_k table's own rounding.
- `[x]` **"z₂ stabilises from K = 28" is retracted.** G6 measures K_req(2) = 32
  at w = 0 and 42 by w = 12; the claim was a small-w statement read as a
  general one.
- `[x]` **"z₄ is a pure truncation artifact" is retracted** — see **E5**. At
  K = 34 the fourth zero is not present in its bracket at all, so what §8.3 saw
  was an artifact of the cut; the fourth zero is real, is −925.6731 = −γ₄², and
  needs K = 50.

**Cost: ten minutes, as estimated — but only after G6, which is why it waited.**

### `[x]` A5. §4 overstated two claims; both are now what the measurements say. — DONE.

Not a new discovery so much as a bill that B3 and C3 jointly made due. Both
paragraphs in [CONTINUATION.md](CONTINUATION.md) §4 are rewritten:

- `[x]` **"R has no zeros"** → no zero was found in the widest scan run, 425
  points at 50 digits over Re w ∈ [0, 40] × Im w ∈ [0, 150]; the smallest
  |R − 1| was 1.9526e−2 **at the far corner of the box**, where
  |w|·|R − 1| = 3.031 is exactly the real-axis creep at |w| ≈ 155. So the
  minimum is the ~3/|w| decay at the farthest point tried, not an anomaly, and
  **a bounded scan of a quantity decaying to zero cannot establish absence at
  any precision** (**B3**, **D**).
- `[x]` **"R(w) − 1 ~ 4/|w|"** → |w|(R − 1) reaches **3.445 at w = 9600**, a
  factor of 960 in w having bought 1.32; on the best-fitting model
  a = 4 − 5.09/ln w the next factor of 960 buys 0.24. The data are consistent
  with 4 **and** with a slow logarithmic divergence and establish neither
  (**C3**), which is why **G5** wants the constant derived rather than read off.
- `[x]` **and a caveat the section needed anyway**: its complex table stops at
  5 + 150i because |Γ_Φ| has fallen to ~1e−30 there and the ratio is formed
  from noise above |Im w| ≈ 200 — where it reads 426.07.

**Cost: twenty minutes, as estimated.**

---

## B. Worth building

### `[x]` B1. Certified discriminant signs in interval arithmetic. — DONE.

All **35** Jensen polynomials J^{d,n}, d = 2…6 and n = 0…30, are certified
hyperbolic from *enclosures* rather than from floating-point signs. The route is
Hermite rather than a resultant: disc = lc^{2d−2}·det H for the Hankel matrix H
of Newton power sums, and H is positive definite ⟺ all d roots are real and
simple — decided by an interval LDLᵀ, which needs no square roots and no
division by a sign-unknown quantity. One factorisation yields both the verdict
and det H, since the pivots multiply to it.

- `[x]` discriminants reproduce [INTEGERS.md](INTEGERS.md) §5 exactly (3.6746e−5,
  9.8744e−41, 5.3285e−118, 2.0170e−13, 7.6910e−123, 2.4317e−240, 1.5931e−25,
  8.4217e−191, 1.2401e−367), and so do its normalised margins
- `[x]` **`max width`** — the largest *relative* enclosure width on the
  coefficients at which the sign is still decided, found by bisection. It runs
  5.035e−3 at (d, n) = (2, 0) down to 3.621e−18 at (6, 30), falling twelve
  decades in d at n = 0 and fourteen at n = 30. A far sharper statement of the
  cost of degree than any discriminant column, because it is scale-free *and*
  actionable: it says exactly how good a bound on γ(n) a certificate needs
- `[ ]` **the certificate is still conditional** — see **G1**
- `[-]` **the certified range is not a contribution** — Chasse 2013 has
  d ≤ 2 × 10¹⁷ for all n ≥ 0, and [GOR⁺] Corollary 1.3 has d ≤ 9 × 10²⁴. See
  **E8**

**What this is not.** Two things, and the second is the larger. The propagation
from an enclosure of a(n) to a certified sign is rigorous — outward rounding
throughout, `Undecided` rather than a guess whenever a pivot straddles zero —
but the *enclosure of γ(n) itself is measured, not proved*: the quadrature's
error is established by step-halving, which is evidence, not a bound. And the
*statement* being certified has been known since 2013 across a range twenty-four
orders of magnitude wider. What is here is a route, not a result.

Implementation: `rust/src/interval.rs`, `rust/src/poly.rs`, `rust/src/jensen.rs`,
driver `bin/b1_certify [dmax] [nmax] [nstep] [digits]`.

### `[x]` B2. Resolve more of the Jensen flow. — DONE. Ten, and K_req is closed.

`bin/b2_flow`, `rust/src/flow.rs`. CONTINUATION §8.3 resolved two roots of
F(w, ·) at K = 34 and its own header here said the two limits — truncation and
precision — bind together. Both halves have moved.

- `[x]` **ten roots at w = 0**, against −γ_k² for k = 1 … 10, agreeing to
  6.5e−20 … 3.0e−16 relative at K = 170 — which is the twenty-digit γ_k table's
  own rounding, not a limit of the computation
- `[x]` **five columns across the flow**, w = 0 … 12, every entry stable
  between K = 128 and K = 140 — the table **A4** pastes into §8.3
- `[x]` **the root-finding changed**, and that is what made it work: bisection
  inside a one-root bracket instead of a global solve on a degree-K polynomial.
  It needs only the sign of F, cannot converge to a neighbour, and cannot
  report a root outside the bracket — three failure modes **E4** already caught
  once. Aberth is kept, and agrees, but it is no longer what is trusted
- `[x]` **K_req is no longer open** — see **G6**, which measures it and finds
  one law
- `[x]` **and the "two limits bind together" premise was wrong** — see **E21**.
  Only truncation binds

### `[x]` B3. Re-do the "no zeros of R − 1" claim at high precision. — DONE AS A SCAN.

425 points at 50 digits over Re w ∈ [0, 40] × Im w ∈ [0, 150], against §4's
float64 scan valid only to |Im w| ≤ 50. No zero. The smallest |R − 1| found is
**1.9526e−2 at w = 40 + 150i**, and it does not move when the quadrature step is
halved — which is the §5 diagnostic, applied.

Note that R needs **no Γ at all**: the two gamma functions in
C(w) = Γ_Φ(w)/Γ(w+1) cancel out of (24) into an explicit rational factor, so
neither this scan nor C3 depends on anything whose own accuracy is in question.

- `[x]` the scan itself, wider and better conditioned than §4's
- `[x]` the §5 diagnostic applied to the smallest value found
- `[-]` **extending it further is not the answer.** The infimum sat on the
  *boundary* of the box in both runs (40 + 120i in the first, 40 + 150i in the
  second), and at that corner |w|·|R − 1| = **3.031** — exactly C3's real-axis
  value at |w| ≈ 155. The box contains no zero *and no anomaly*; the minimum is
  just the ~3/|w| decay evaluated at the farthest point tried. A bounded scan of
  a quantity that decays to zero can never establish absence, at any precision
- `[ ]` downgrade §4's wording accordingly — **A5**

Implementation: `rust/src/ratio.rs`, driver `bin/b3_scan [nx] [ny] [ymax]`.

---

## C. Open, and honestly hard

### `[-]` C1. Uniformity in the Jensen degree d.

Untouched, and untouchable by arithmetic. §8 of CONTINUATION.md relocates it
into a statement about a domain in ℂ² and explicitly does not make it tractable.
This is the actual mathematical obstruction and nothing in this directory —
including the Rust work — moves it. Marked `[-]` not because it is unimportant
but because it is the opposite: it is the whole difficulty, and no item on this
list is a route to it.

**But "nothing moves it" would now be wrong, and the wording here should say
so.** The two papers moved it twice. [GOR⁺] Theorem 1.1 makes the d-uniformity
*effective* — J_{d,n} is hyperbolic once n ≥ c·e^d, with 0.9634 the exponent
their proof yields. [O'S] Theorem 1.3 then replaces the exponential with a
**polynomial**: P_{d,n} is hyperbolic once n/log²n ≥ d^(3/4)/2, for d large.
That is not RH — both still leave n small relative to d — but it is a real
change in the state of the art, and it happened by changing the criterion
(**H6**), not by improving the estimates.

The full map — both theorems quoted verbatim, where each exponent is
manufactured, and what "past the frontier" would and would not mean — is
written out in
[uniformity-in-the-jensen-degree-d.md](uniformity-in-the-jensen-degree-d.md).

### `[ ]` C2. Is F(w, ·) ∈ LP for all real w actually equivalent to RH, or merely implied by it? — HALF ANSWERED.

Two things have happened to this question and neither is the hour of thought it
still wants.

- `[x]` **G4 answers the computable half, and the answer is "no content".**
  §8.2 asks for the LP condition at *every* w where the classical criterion
  needs it at the even integers only. Over w ∈ [0, 12] in 24 steps, at two
  truncations, inside the disc G6's law says a truncation can speak for, the
  contour zero-count equals the sign-change count on the axis at **all 25
  sample points**. Every zero is real and negative, at the integers and between
  them. So the continuum is not stronger, and §8 is a repackaging — which
  §8.4 now says.
- `[x]` **[O'S] Theorem 3.5 changes what the question is worth asking for.**
  For *any* Ω in the Laguerre–Pólya class the corresponding criterion is
  equivalent to hyperbolicity; the interpolating parameter is Ω, every value of
  it is equivalent to RH, and what differs is not content but **cost of
  verification**. **H6** measured that cost across Ω and found the optimum is
  where [O'S] put it, with a translation left on the table worth a change of
  exponent.
- `[ ]` **what is still open** is the equivalence itself — whether the LP
  condition on F(w, ·) for all real w *implies* RH, not merely follows from it.
  G4 says the extra w carry no information the integers do not; that is
  evidence for "equivalent, and that is not the interesting part", and it is
  not a proof of it. **Cost: an hour of thought, with [O'S] §3 in hand.**

### `[x]` C3. The asymptotic constant in |w|·(R(w) − 1) → 4. — MEASURED.

§4 infers "~4/|w|" from a creep through 2.13 … 3.19. Extended sixteen-fold, to
w = 9600:

```
    w        10      40      80     150     300     600    1200    2400    4800    9600
 |w|(R−1)  2.126   2.652   2.834   2.967   3.088   3.187   3.269   3.337   3.395   3.445
```

Still **14% short of 4** after a factor of 960 in w. And the discriminating
quantity is worse for the inference than the creep is: `(4 − a)·ln w` is **not
flat** — it rises to 5.204 near w = 300–600 and then *falls* to 5.091 by 9600.
Flat would mean a = 4 − c/ln w; falling means a → 4 faster; the observed
rise-then-fall means the data are consistent with 4 and consistent with a slow
logarithmic divergence, and **establish neither**.

- `[x]` the suspicion recorded in this item is upheld, and now by a measured
  amount
- `[ ]` downgrade §4's phrasing — **A5**
- `[ ]` get the constant the only way it will actually come — analytically,
  **G5**
- `[-]` another decade of w. See **D**

Implementation: driver `bin/c3_asymptote`.

---

## G. Now possible — what the arbitrary-precision layer opens

Everything here was out of reach before [rust/](rust/) existed and is in reach
now. Ordered by value/effort, like the rest of the file. All tractable — that is
what makes them a section rather than a wish list. **Section H is the same idea
for the two papers, and H2 had to be done before G1** — it was, and it changed
G1's target by twelve orders of magnitude before a line of G1 was written.

**G1, G2 and G3 are done.** G4, G5, G6 remain.

### `[x]` G1. Turn B1 into a theorem: bound γ(n) instead of measuring it. — DONE.

`bin/g1_theorem`. Every certificate in this directory used to carry a silent
conditional — *"the discriminant is positive, given that the quadrature has
converged."* It no longer does. The coefficients now arrive as intervals
**proved** to contain a(n), and the same interval LDLᵀ that B1 and H2 run
decides the sign from them.

Four bounds replace the four estimates, and all four are in
[`rust/src/jet.rs`](rust/src/jet.rs) and
[`rust/src/bounds.rs`](rust/src/bounds.rs) with their derivations:

- `[x]` **(a) the shell truncation.** For u ≥ 0 the head of φ_k lies in
  [0, 2π²k⁴e^{9u/2}], each u-derivative costs at most a factor 5πk²e^{2u}, and
  consecutive majorants fall by 2⁸e^{−3π} = 0.021 — so the geometric sum is
  under 2 and, for every N ≥ 0 and j ≤ 2,

  ```
  Σ_{k>N} |φ_k^(j)(u)|  ≤  (5π(N+1)²e^{2u})^j · T_N(u),
  T_N(u) := 4π²·e^{9u/2}·(N+1)⁴·e^{−π(N+1)²e^{2u}}                      (G1a)
  ```

  The loop stops on T_N rather than on the terms. TODO's "easy" was right.
- `[x]` **(b) the trapezoid error.** The composite-trapezoid remainder,
  |Q − T_h| ≤ (h²/12)·Σ_j h·max|f″| over each subinterval, with
  f″ = e^{av}(a²g + 2a·g′ + g″) enclosed by one interval **jet** per block.
  No Poisson summation, no analyticity — see **E12** for why that matters.
- `[x]` **(c) the piece below V₀.** Not a Taylor bound at all: since e^{av} > 0
  and Φ(e^v) ∈ Φ([0, e^{V₀}]) for *every* v ≤ V₀, one interval evaluation of Φ
  over that range gives the whole tail exactly, `Φ([0,e^{V₀}])·e^{aV₀}/a`.
  The recipe this item printed does not work as written — **E13**.
- `[x]` **(d) the piece above V₁**, which the item did not list and which needs
  a bound of its own. (G1a) at N = 0 majorises Φ, and ρ(u) = w·log u + 9u/2 −
  πe^{2u} has ρ′ ≤ −κ = −(2πe^{2U₁} − 9/2 − w/U₁) < 0 on u ≥ U₁, so
  `T_hi ≤ 4π²e^{ρ(U₁)}/κ`.

**What it delivers.** At V₀ = −14, h = 2⁻¹⁴, V₁ ≈ 1.4 — 252,317 nodes, 63,079
jet blocks, 60 digits, four minutes:

| | required by P | achieved, certified |
|---|---|---|
| d = 6, n = 30 | 5.427e−6 | **3.283e−7** |
| worst case over the grid | — | **33.1× slack** (**E16**) |

**35 of 35** P^{d,n} certified for d = 2…6, n = 0…30. **15 of 35** for J^{d,n}
— it holds to d = 3 and dies at (4, 5). That is H2's table, re-derived from the
opposite direction: the same enclosure that certifies every P certifies fewer
than half the J.

**What binds, which was not obvious.** (G1b) dominates at every single n, by
between one and four hundred decades:

```
    n     rel width     G1b quad      G1c low     G1d high
    0     1.3028e-9     6.30e-10     4.28e-11   6.65e-4542
   36     3.2834e-7      1.64e-7    3.31e-445   1.34e-4492
```

So the two tails are not merely small, they are irrelevant — and **V₀ = −50 is
the wrong limit for a certified rule.** `mellin.rs` needs it because the
Euler–Maclaurin *boundary* term survives at −16; the certified rule has no
separate boundary term to kill, because (G1b) bounds the remainder over the
whole range at once, and (G1c) is exact. V₀ = −14 is enough, which is 3.6×
fewer nodes.

**One implementation fact worth keeping.** a²g + 2a·g′ + g″ nearly *cancels* at
the saddle — that is what "the integrand is flat at its peak" means, |f″| there
being f/σ² and not a²f. Bounding the three terms separately throws the
cancellation away and inflates (G1b) by ~40× at n = 36. Keeping them as
intervals, so the cancellation happens inside the arithmetic, is worth more than
a factor of four in h. Block width matters for the same reason: the enclosure of
g over a block of width ω is relatively e^{Lω} − 1 too wide with L ≈ 350 near
the peak, so ω past ~10⁻³ costs more than the jets it saves. Both were measured.

**And be clear about what it buys.** The result is not new mathematics: Chasse
2013 covers d ≤ 2 × 10¹⁷ for all n ≥ 0 (**E8**). What G1 delivers is a
*self-contained* certification running from the horn's own integral to a
certified sign, with no step taken on trust — and that is the whole claim.

### `[x]` G2. Push B1 until it breaks. — DONE. It is a staircase, not a number.

`bin/g2_frontier`. G1 made both sides of this question numbers, so the answer
is arithmetic: **demand** is how tight an enclosure of a(n) each criterion
needs, **supply** is how tight one the certified quadrature delivers, and the
frontier is where they cross.

**Demand**, extended from H2's d ≤ 6, n ≤ 30 to **d ≤ 10, n ≤ 140** — and the
extension changes the reading of H2's headline finding:

| | at n = 0 | at n = 140 | cost of degree |
|---|---|---|---|
| **P** at d = 10 | 2.042e−12 | **2.085e−12** | 1.45 decades/d |
| **J** at d = 6 | 1.709e−15 | 1.115e−20 | 3.45 decades/d |

**P's demand is flat in n over the whole range, and rising slightly.** H2 saw
that to n = 30 and called it the property that decides G1; it holds to n = 140
at every degree to 10. J's falls five decades over the same span at d = 6.

Four cells are marked `prec` rather than given a number: at d = 10, n ≥ 80, J's
discriminant is undecidable at 60 digits **even from a zero-width enclosure**.
That is the arithmetic's floor and not the criterion's demand, and it is
labelled as such — `max_tolerable_width_in` returning 0 does not mean "needs
nothing", it means "cannot be decided at all here".

**Supply** at V₀ = −14, h = 2⁻¹⁴, 252,317 nodes: 1.3028e−9 at n = 0 rising to
**8.7396e−6 at n = 140**, i.e. like **n^2.23**. Pure h²/σ² would give n¹; the
excess is the block term, which carries an extra a² = (2n+1)². And the h² half
is *measured*, not assumed — against a rule with h four times coarser at the
same block width, the ratio is 15.51, 16.00, 16.00, 16.00 at n = 0, 40, 80,
120. Mean 15.88, **99% of the 16 that h² predicts**.

**The crossing.** Every failure is diagnosed rather than counted: a cell can
fail because the enclosure is too wide (the frontier) or because the precision
cannot resolve the discriminant (an artifact), and the driver separates them by
re-certifying each failure from the tightest enclosure the scalar allows. Every
failure below is the bound.

```
    d  P to n  J to n   P needs @top      supplied
    2     120     140       1.906e0      5.992e-6
    3     120      40      1.013e-1      6.127e-6
    4     120       0      6.190e-3      6.263e-6
    5     120       —      2.810e-4      6.402e-6
    6     120       —      1.087e-5      6.542e-6
    7      20       —      3.269e-7      1.918e-7
    8       0       —      8.775e-9      3.268e-8
    9       —       —     1.979e-10      3.782e-8
```

So at one h the pipeline certifies **P to d = 6 across n ≤ 120**, d = 7 to
n = 20, d = 8 at n = 0 alone, and nothing at d ≥ 9. B1 published d ≤ 6, n ≤ 30
— and conditionally. **J** reaches d = 2 across the whole range, d = 3 to
n = 40, and d = 4 at n = 0 only.

**The trade law.** Demand is flat in n for P and falls 1.45 decades per unit of
d; supply costs h² and rises like n^2.23. So

```
d_max(n, h)  =  const  −  (2/1.45)·log₁₀h  −  (2.23/1.45)·log₁₀n
```

— **0.41 degrees per halving of h**, and **1.54 degrees lost per decade of n**.
Which is why the frontier is a staircase: n is as expensive as d.

**And what the next degrees cost.** h must shrink by 10^(1.45/2) = 5.3× per
degree and the node count rises by the same factor, so from four minutes at
d = 6:

| d | h | nodes | build |
|---|---|---|---|
| 7 | 2^−16.4 | 1.35e6 | 23 min |
| 8 | 2^−18.8 | 7.19e6 | 2.0 h |
| 9 | 2^−21.2 | 3.84e7 | 10.8 h |
| 10 | 2^−23.7 | 2.05e8 | 2.4 days |
| 11 | 2^−26.1 | 1.09e9 | 12.9 days |

That is the practical frontier of an integral-to-certified-sign route, and it
is **not** the frontier of hyperbolicity, which Chasse settled to d ≤ 2 × 10¹⁷
in 2013 (**E8**). The gap between d ≈ 8 and 2 × 10¹⁷ is the honest measure of
what this pipeline is for: it is a *route*, demonstrated end to end, not an
extension of what is known.

G2 also turned up **E16**, a half-width compared against a full one, which had
been halving every slack figure the directory printed.

### `[x]` G3. Check CONTINUATION (22)'s pole string. — DONE, and (22) is broken.

`bin/g3_poles`. (22) claims Γ_Φ is meromorphic on ℂ with simple poles at
w = −1, −3, −5, … **only** and residue 4c_{2k} at w = −(2k+1), where
Φ(u) = Σ c_{2k}u^{2k}; (23) that C(w) = Γ_Φ(w)/Γ(w+1) is entire. **No c_{2k}
had ever been computed**, so none of it had ever been checked.

[`rust/src/series.rs`](rust/src/series.rs) computes them exactly — truncated
power series over intervals, two recurrences (e^{αu} → α^m/m!, and
F = e^G ⟹ m·f_m = Σ i·g_i·f_{m−i}), no quadrature anywhere — with the shell
truncation majorised by a Cauchy estimate on |u| = 3/10 (G3a). So:

```
c_0 =  0.4466969004671234440870      c_4 =  16.92005903032133932308
c_2 = -4.182625193675814216698       c_6 = -35.23314299039473379539
```

and every odd coefficient comes out enclosing zero — Φ's evenness, which is
the theta functional equation, arriving through arithmetic rather than being
imposed.

- `[x]` **the residues.** Res_{w=−(2k+1)} Γ_Φ = 4c_{2k} = 1.786787601868…,
  −16.7305…, 67.6802…, −140.9326…. The first agrees with the **1.7867876**
  that (22) prints, to the nine digits it prints.
- `[x]` **(23), which is the sharp test.** C(−(2k+1)) = 4·(2k)!·c_{2k}, because
  Γ_Φ's pole meets 1/Γ(w+1)'s zero. Measured against predicted at
  w = −1, −3, −5: **1.79e0, −3.35e1, 1.62e3**, agreeing to 1e−25. And C(−2),
  C(−4), C(−6) = 3e−77, 4e−75, 8e−73 — the simple zeros. Every structural
  claim (22) and (23) make is true.
- `[x]` **the derivation is not.** See **E14**: (22) splits at u = 1 and
  integrates Φ's Taylor series over [0, 1]. The radius of convergence is π/4.
- `[x]` **a working evaluator, which the directory did not have.** Split at
  V₀ = −2 instead (U₀ = e^{−2} = 0.135, inside the disc), take the whole
  series below it and Romberg the quadrature above. It agrees with
  `mellin::eval` to **8.8e−43** at w = 2, 4, 10 — two independent routes to
  the same number — and is finite and correct at every w below −1, where
  `mellin::eval` is not. See **E15**.

Three things had to be got right that the item did not anticipate, all found by
measurement:

* **Romberg, not trapezoid.** At U₀ = 0.135 the integrand has not decayed at
  the lower limit, so Euler–Maclaurin leaves −h²/12·f′(V₀) — a relative 1.3e−7.
  Six Romberg levels remove it.
* **the split point must be exactly representable.** Specifying U₀ = 1/8 and
  letting the quadrature take log(1/8) through f64 puts the two halves 2e−16
  apart in v; across an integrand of size 0.4 that is 7e−17 on Γ_Φ(0), and it
  does not move under *any* number of Romberg levels. Specify V₀, not U₀.
* **the residual at w = 0 belongs to `Mellin::standard`, not to this route** —
  it is that rule's own boundary term at V₀ = −50, and halving h quarters it
  (measured ratio 4.00).

### `[x]` G4. Does non-integer w add content? — DONE. It does not.

`bin/g4_content`. The computable half of **C2**, and it needed **G6** first —
without a truncation law every "complex root" is an artifact and **E4** records
two of them surviving a refinement round.

**The method is a count, not a root-find**, which is what makes it decisive.
The argument principle gives the number of zeros of the K-term truncation
inside |y| ≤ Y as an *integer* — the winding of F_K around that circle, no
poles to worry about — and bisection gives the number of sign changes on
[−Y, 0). **If the two agree, every zero in the disc is real and negative**, and
no artifact can hide inside. Aberth was tried first and is the wrong tool here:
the coefficients span three hundred decades, so it starts every root on a
Cauchy circle far outside the region of interest and converges slowly.

- `[x]` the trusted disc is |y| ≤ (K/1.9)² = **3352** at K = 110, from G6's
  law with its largest measured constant — the safe direction, since a larger c
  makes the disc smaller
- `[x]` **25 of 25 sample points across w ∈ [0, 12], at K = 110 and K = 130,
  the two counts agree — every time.** Twelve real zeros in the disc at w = 0,
  falling to ten by w = 12 as the flow carries them outward past the boundary
- `[x]` the regression: at w = 0 the disc holds exactly the −γ_k² it should,
  and the scan finds them to 6.5e−20 … 3.0e−16
- `[x]` **so §8.2's "for every w" is the same condition as "for every even
  integer"**, within reach, and §8.4 now says so instead of leaving it open
- `[x]` what it does **not** establish: anything outside the disc, and anything
  at complex w. A zero beyond the boundary is unseen, not absent — the same
  distinction **D** insists on for B3

**Cost: a day after G6, as estimated. Three minutes to run.**

### `[x]` G5. Get the C3 constant analytically, then check it. — DONE. It is 4.

`bin/g5_watson`, `rust/src/watson.rs`. The numerical route was finished and had
settled nothing: a factor of 960 in w bought 1.32, reaching 3.445 at w = 9600,
consistent with a limit of 4 **and** with a slow logarithmic divergence. So
derive it.

**Every step but one is an identity.** With L := log Γ_Φ, (24) is
R = exp(−Δ²L)·R_f, Δ²L := L(w+4) − 2L(w+2) + L(w). Since
Γ_Φ(w) = 4∫e^{(w+1)v}Φ(e^v)dv, differentiating under the integral makes both
derivatives of L **moments of the tilted density** ρ_w(v) ∝ e^{(w+1)v}Φ(e^v):

```text
L′(w) = ⟨v⟩_w,   L″(w) = Var_w(v),   Δ²L = ∫_{−2}^{2}(2−|s|)L″(w+2+s)ds
R_f   = (w+3)(w+4)/((w+1)(w+2)) = 1 + 4/w − 2/w² + …
```

L″ > 0 *is* the Cauchy–Schwarz defect, which is why R_γ < 1. The one
approximation is Laplace on Var_w(v): the saddle of (w+1)v + log Φ(e^v) gives
−P″ = (w+1)(1 + 2U) + 9U² with 2πU·e^{2U} = w + 1 + (9/2)U, U = e^{v\*}. And
**that saddle equation is solved exactly by U = ½·W(w/π)** — Lambert's
function, which the crate already owns from **H5**. So

```text
w·(R(w) − 1)  =  4  −  4/(1 + W(w/π))  +  O(1/w)
```

- `[x]` **the limit is 4**, because W(x) → ∞; the approach is 4/W(w/π) ~
  4/log w, which is why sixteen-fold in w bought 0.26
- `[x]` **the identities are checked, not assumed.** L′ = ⟨v⟩ agrees with a
  difference quotient to 5.3e−19 … 2.3e−26; L″ = Var to **1.4e−15 at w = 1000
  and 1.3e−19 at w = 10⁴** under Richardson extrapolation
- `[x]` **Laplace's residual falls like 1/w over five decades** — 5.49e−2,
  8.61e−3, 1.19e−3, 1.52e−4, 1.87e−5, 2.22e−6 at w = 30 … 3×10⁶ — and the
  closed form for −P″ against the full Φ falls like 1/w²: 6.07e−3 down to
  3.94e−11
- `[x]` **the prediction against the measurement, three and a half decades
  past where C3 stopped**: at w = 1.024×10⁷ the derivation gives 3.7031210446
  against 3.7031208350 measured, a relative **5.66e−8**, with the residual
  falling by 4× for every 4× in w — Watson's next term, seen rather than
  asserted
- `[x]` **what C3's fit was reading.** a = 4 − 5.09/ln w was a local snapshot
  of 4·ln w/(1 + W(w/π)), which falls from 5.23 to 5.09 across C3's own range
  and keeps falling — so extrapolating it was extrapolating a moving quantity
- `[x]` **how far the limit is**: 3.9 needs w ≈ 10¹⁹, 3.99 needs w ≈ 10¹⁷⁶,
  3.999 needs 10¹⁷⁴¹. Nothing computational was ever going to settle this
- `[x]` **a by-product worth more than the item** — see **E22**. The same
  saddle gives σ = 1/√(−P″), and Poisson summation puts the trapezoid's
  relative error at exp(−2π²(σ/h)²). So `Mellin::standard` has a *formula* for
  its own reach, and it says the fixed grid stops measuring R at about
  w = 4×10⁴. `watson::adapted_rule` replaces it above that, which is what let
  the check run to 10⁷ at all

**§4's claim now rests on a derivation instead of on a creep**, and A5's
downgrade of it is superseded by (24a).

**Cost: half a day of Watson's-lemma bookkeeping, as estimated. 64 s to run.**

### `[x]` G6. Measure K_req(w, k) — the truncation law of the flow. — DONE.

`bin/g6_kreq`, `rust/src/flow.rs`. The blocker under both **B2** and **G4**.
K_req(w, k) is the fewest terms at which the k-th root of F(w, ·) reaches its
converged place to a stated relative tolerance **and stays there** for every
larger K — the second half being what separates a law from a coincidence.

**The law was predicted before it was measured**, from the coefficient decay
alone. A(w+2j) is a(j + w/2), which falls like (C/j)^j with C growing only
logarithmically ([O'S] Theorem 1.4, which **H5** implements). So
|A(w+2j)y^j/j!| ~ (Ce/j²)^j|y|^j, whose largest term sits at j\* = √(C|y|/e) —
**K_req should be a function of √|z| alone**, and not of w and k separately.

It is:

```
   k          1     2     3     4     5     6     7     8     9    10
   K_req     20    32    40    50    56    66    74    78    90    94    (w = 0, 1e−6)
   k = 1 across w = 0, 1, 2, 4, 6, 8, 12, 16, 24:  20 22 22 24 26 28 30 34 40
```

**Forty-one measurements from nine values of w and ten root indices collapse
onto one curve**: K_req/√|z| rises smoothly from **1.415 to 1.889** as √|z|
runs 14.1 → 49.8, fitted exponent 1.229 in √|z| — the predicted 1 plus the
logarithmic drift C carries.

- `[x]` **the anchor is external.** At w = 0 the roots are −γ_k² and the γ_k
  come from outside the crate, so the whole measurement is against a known
  answer rather than against itself. Agreement 6.5e−20 … 3.0e−16 at K = 170 —
  the twenty-digit table's own rounding
- `[x]` **the tolerance dependence is reported, not hidden**: K_req at 1e−3,
  1e−6 and 1e−12 differ by about six terms across the whole range
- `[x]` **precision does not bind** — see **E21**. Identical K_req at 30, 45,
  60 and 90 working digits
- `[x]` **and it audits §8.3 retroactively.** At K = 34: z₁ resolved (K_req 20),
  z₂ resolved (32), z₃ **not** (40, and it sits 1.95e−3 off), z₄ and z₅ not
  present in their brackets at all. So "only z₁ and z₂ are trustworthy" was
  right for the right reason, and "z₄ is a pure truncation artifact" was not —
  see **A4** and **E5**
- `[x]` **one bracket bug, found twice and recorded** — see **E20**

**Cost: an afternoon of machine time, as estimated. 140 seconds to run.**

---

## H. From the two papers

Everything here became tractable when [GOR⁺] and [O'S] arrived in the directory,
and everything here uses the crate that already exists. They agree with our γ(n)
exactly, so every table in them is an answer key.

**All six are done, and [H_track.md](H_track.md) is the self-contained
account** — read that rather than this section if you want the arc rather than
the register. H1 confirmed the crate against an external twenty-digit value and
retracted a feasibility claim of its own (**E10**, **E11**); H2 measured what
O'Sullivan's P^{d,n} is worth to a certificate and **moved G1's target by
twelve orders of magnitude**; H3 found where both papers' criteria actually
switch on; H4 checked γ(n) by two more representations and found that [GOR⁺]
(3.1) as printed returns **8γ(M)** (**E17**, **E18**); H5 rebuilt [O'S]'s
asymptotic from its Bell-polynomial chain and reproduced Table 1 entire; H6
searched Ω and found that **[O'S] picked the optimal Gaussian and left a
translation on the table worth a change of exponent** (**E19**).

### `[x]` H1. Check a(n) at n = 1000 against [O'S] Table 1. — DONE, exactly.

[O'S] Theorem 1.4's table prints γ(1000) = **4.8450426112725879772 × 10⁻²⁵⁶⁸**.
`bin/h1_moment` returns

```
a(1000) = 4.8450426112725879772e-2568
```

— **every digit [O'S] prints**, and unchanged under h doubled, h halved, V₁
raised, V₀ raised, and a 90-digit run. The first external high-precision check
this directory has ever had of its own a(n), and it passes.

- `[x]` the value itself, agreeing to 20.36 digits — the residual is the
  rounding of [O'S]'s own last printed digit, so the comparison is saturated
  by *their* precision, not ours
- `[x]` **the rule's actual accuracy, which is far higher.** Comparing rules
  against each other at 150 digits (V₀ = −2 there, which costs nothing at
  n = 1000 and is 30× cheaper):

  | h | nodes | digits vs the next halving |
  |---|---|---|
  | 0.008 | 426 | 10.72 |
  | 0.004 | 851 | 40.58 |
  | 0.002 | 1701 | **133.51** |
  | 0.001 | 3401 | 169.80 (at the 173-digit floor) |

  Each halving roughly **triples** the correct digits. At the standard
  h = 0.002 the quadrature error at n = 1000 is ~10⁻¹³³.
- `[x]` a(0) = 0.49712077818831410991 = ξ(½) — A3 again, from the other end
- `[-]` **the feasibility worry above was wrong, and is retracted** — see
  **E10**. The saddle diagnostic is right (v\* = 0.891 at n = 1000, V₁ = 1.4
  holds the peak to n ≈ 42 000) but "the binding constraint is node density"
  and "right at the edge" were not: at h = 0.004, i.e. 2.3 nodes across the
  Gaussian width, the rule still delivers 40 correct digits. Counting nodes
  across a peak measures *algebraic* accuracy; the trapezoid rule on an
  analytic, doubly-exponentially decaying integrand is **geometric**.

Implementation: `rust/src/mellin.rs` (`eval_real`, `saddle`),
`rust/src/jensen.rs` (`a_at`, `fact_ratio`), driver `bin/h1_moment`.

### `[x]` H2. Implement P_{d,n} and measure its `max width` against J's. — DONE.

[O'S] (1.4)'s second family, Hermite from the start:

```
P_{d,n}(X) := Σ_{j=0}^{d} C(d,j)·γ(n+j)·H_{d−j}(X)
```

carries the same equivalence to RH (**Theorem 1.2**) under a strictly weaker
condition (**Corollary 3.8**: J hyperbolic ⟹ P hyperbolic). Certified through
exactly the same interval LDLᵀ on the same Hermite–Hankel form, so the
tolerances are directly comparable:

| d | J `max width`, n = 0 → 30 | P `max width`, n = 0 → 30 | P/J at n = 30 |
|---|---|---|---|
| 2 | 5.035e−3 → 9.443e−4 | 8.790e−1 → 9.281e−1 | 9.8e2 |
| 3 | 7.909e−6 → 3.729e−7 | 5.042e−2 → 5.060e−2 | 1.4e5 |
| 4 | 7.569e−9 → 1.105e−10 | 3.078e−3 → 3.093e−3 | 2.8e7 |
| 5 | 4.421e−12 → 2.323e−14 | 1.395e−4 → 1.403e−4 | 6.0e9 |
| 6 | 1.709e−15 | 5.383e−6 | — |

- `[x]` every P certifies wherever J does — Corollary 3.8, confirmed on all 35
- `[x]` **the smallest advantage anywhere is 175×**, at (2, 0). At d = 2 the
  sign survives every coefficient being wrong by a factor of two: `max width`
  0.93 against the scale's end at 1.0, where the leading coefficient reaches
  zero and the polynomial loses its degree
- `[x]` **P's cost of degree is ~1.3 decades per unit of d, against J's ~3.5**
- `[x]` **P's tolerance is flat in n — it even rises slightly — where J's
  falls by one to three decades over the same range.** This is the property
  that matters, and it was not predicted above: a bound on γ(n) good enough
  for P at n = 0 is good enough for P at *every* n, whereas J's requirement
  keeps tightening as n grows
- `[x]` the d = 2 identities check out exactly against [O'S] (1.5)/(1.6): at
  n = 30 the J margin is 1.33e−118 and the P margin 1.95e−112 — the 2a(n)²
  term is six decades of free slack

**G1 is now much cheaper, and the target has moved.** Instead of 3.6e−18 at
(6, 30) it is **5.4e−6 at d = 6** and 1.4e−4 at d ≤ 5, flat in n. See G1.

Implementation: `rust/src/hermite.rs`, `rust/src/jensen.rs` (`p_jensen`,
`Family`, `certify_in`, `max_tolerable_width_in`), driver
`bin/h2_pjensen [dmax] [nmax] [nstep] [digits]`.

### `[x]` H3. Find where the Turán criteria actually start to hold. — DONE.

`bin/h3_onset`, `rust/src/turan.rs`. Both papers certify through Turán's
Theorem III and **both bound the onset only asymptotically** — n ≥ c·e^d for J
([GOR⁺] Theorem 1.1, with **c never given**) and n/log²n ≥ d^{3/4}/2 for P
([O'S] Theorem 1.3, "d large"). Where it *actually* starts is a finite
computation, and here it is.

**The headline, and it is H2 again from the other side:**

> **[O'S]'s criterion for P holds at n = 0 for every d ≤ 400.
> [GOR⁺]'s for J holds at n = 0 only for d ≤ 7.**

A factor of **57 in the degree reachable at no cost in n at all**. H2 measured
the same asymmetry as 175× to 6.0e9× in tolerable enclosure width at fixed
(d, n); this is the same fact in the currency of the criteria themselves.

The crossing for P is sharp: (8.2) = **0.993195 at d = 400** and **1.000691 at
d = 401**.

| d | 2 | 8 | 90 | 303 | 400 | 401 | 454 | 681 | 1021 |
|---|---|---|---|---|---|---|---|---|---|
| **P**: n₀ | 0 | 0 | 0 | 0 | 0 | — | 2 | 10 | 24 |
| **P**: (8.2) at n = 0 | 6.2e−8 | 6.9e−6 | 1.1e−2 | 0.430 | 0.993 | 1.001 | — | — | — |

| d | 3–7 | 8 | 9 | 10 | 11 | 12 | 13 | 14 | 15 | 16 |
|---|---|---|---|---|---|---|---|---|---|---|
| **J**: n₀ | 0 | 51 | 129 | 251 | 434 | 693 | 1048 | 1518 | 2126 | 2897 |

Every J row is a genuine first crossing — (2.9) sits at 0.9983…0.9999 at n₀ and
above 1 at n₀ − 1.

- `[x]` **against the published bounds.** Where both are defined, [O'S] Theorem
  1.3's sufficient bound overshoots the true onset by **296× to 1602×**.
  [GOR⁺]'s cannot be compared at all: **no c is given**. What can be said is
  that the measured J onset grows *more slowly* than e^d over 8 ≤ d ≤ 16 — the
  implied c falls from 0.0171 to 0.0003 — so the exponential regime their proof
  needs has not begun at these degrees.
- `[x]` **the implementation is checked against the papers' own lemma.**
  [GOR⁺] Lemma 2.3 says A_{d,0} = 1, A_{d,1} = 0, A_{d,2} = −d(d−1), and that
  J̃^{2,n} = H₂(X/2) identically. `A_{d,0}`, `A_{d,1}`, `A_{d,2}` hold to 40 digits at `d = 2…12` for
`n ∈ {0, 1, 5, 20, 40}` and `J̃^{2,n} = H₂(X/2)` at `d = 2` for `n ∈ {0, 3, 11, 30}`
(corrected 2025-10-06 to the coverage the committed tests exercise) — and they are what settles that the Δ^d of (2.6) belongs in the
  **denominator**, which the paper's typography leaves ambiguous and which the
  wrong choice gets wrong by a factor of Δ^{2d}.
- `[x]` **and the criterion is checked to be sufficient**: wherever either
  criterion holds, the discriminant route certifies the same polynomial. If it
  ever held where B1 says the polynomial is not hyperbolic, one of the two
  would be wrong.
- `[x]` **precision is not the obstacle, measured rather than assumed.** The J
  renormalisation is an alternating sum whose max-term-over-sum reaches 1e77,
  which looks fatal. It is not: recomputing a(0) … a(2914) at **120** digits
  moves (2.9) at every n₀ by at most **3.0e−54**. The huge ratios are
  coefficients that are genuinely near zero and contribute nothing. The naive
  cancellation metric overstates by seventy decades, and only the precision
  cross-check settles it.

**What it does not say.** These are onsets of a *sufficient* criterion, not of
hyperbolicity. The discriminant route decides every cell in the small-d table
at n = 0 — including the d = 8 where J's criterion needs 51 moments — and
Chasse settled d ≤ 2 × 10¹⁷ for all n in 2013 (**E8**). What H3 measures is the
price of a criterion that is *uniform in n and provable* against one that is a
finite check with no uniformity at all.

**Cost: an afternoon, as estimated. 70 seconds to run.**

### `[x]` H4. Cross-check γ(n) against two representations that are not the horn. — DONE.

`bin/h4_crosscheck`, `rust/src/crossref.rs`, `rust/src/quad.rs`. H1 compared
one number against one number; a shared error would have survived. So compute
γ(n) three more ways, with a quadrature the crate did not previously own —
**composite Gauss–Legendre**, whose error is ρ^{−2m} on a Bernstein ellipse and
to which the finite endpoint t = 1 is nothing:

```text
ξ^{(2n)}(½) = 2^{1−2n}∫₁^∞ (log t)^{2n}·ω(t)·t^{−3/4} dt              [O'S] (7.1)
γ(M)        = M!/(2M)!·[32·C(2M,2)F(2M−2) − F(2M)]/2^{2M−1}          [GOR⁺] (3.1)
F(z)        = ∫₁^∞ (log t)^z·t^{−3/4}·Σ_{k≥1}e^{−πk²t} dt
ω(t)        = Σ_{k≥1}(2π²k⁴t² − 3πk²t)e^{−πk²t}                      [O'S] (6.1)
```

plus a control — the horn's own integrand 4∫₀^∞u^{2n}Φ(u)du on a *uniform* grid
in u, where the horn's is geometric — so a disagreement can be attributed to
the rule or to the representation rather than to both at once.

- `[x]` **they agree to the arithmetic floor.** At 60 digits requested (77
  resolvable, **E11**): uniform-u 69–73 digits against the horn, (7.1) 66–69,
  (3.1)/8 61–69, and (7.1) against uniform-u 66–72 — i.e. the two new routes
  agree with *each other* as well as the arithmetic allows. At **n = 1000** all
  three agree to **72.9 digits** and reproduce [O'S] Table 1's twenty printed
  digits, in 1.8 s.
- `[x]` **[GOR⁺] (3.1) as printed returns 8γ(M)** — see **E18**. Measured
  exactly 8.00000000000000000000000000000 at every M from 1 to 12.
- `[x]` **the one place the horn is the one that is off.** At n = 0 the three
  routes split by 2.31e−28, and it is the horn: `Mellin::standard`'s V₀ = −50
  leaves an Euler–Maclaurin boundary term 4(h²/12)f′(V₀), which the new routes
  do not have. Predicted against measured over **thirty-three decades** of V₀
  (−16 to −90), the ratio is 1.00000 at every one — so the mechanism is
  identified, not observed. Only n = 0 is affected (for n ≥ 1 the weight is
  e^{(2n+1)V₀}), and the tightest tolerance ever asked of γ(0) is H2's
  1.709e−15, thirteen decades above it. Nothing published changes.
- `[x]` **the cancellation the item assumed is not there** — see **E17**. Both
  ω and ψ are positive on [1, ∞).
- `[x]` **two structural identities checked as arithmetic**: Φ(u) =
  e^{u/2}ω(e^{2u}) to sixty digits (which is **E9**'s identification, in one
  line) and ω = 2t²ψ″ + 3tψ′, which is what the by-parts derivation behind
  (3.1) rests on.

**Cost: half a day, as estimated. 58 seconds to run.**

### `[x]` H5. Check the Lambert-W asymptotic for γ(n). — DONE.

`bin/h5_asymptotic`, `rust/src/lambert.rs`. [O'S] Theorem 1.4, with
w := W(2n/π):

```text
γ(n) = 4π²e^{7w/4}·√(w/(w+1))·( e·w²/(16·n·e^{2/w}) )^n·(1 + Σ_{k<K} c_k(w)/n^k + …)
```

The paper describes **every** c_k, through a chain of five formulas — (2.6)
ℓ_i, (7.4) a_r, (7.7) μ_r, (7.11) κ_m, (7.13) κ*_k and c_k, all built on the
partial ordinary Bell polynomials B̂_{i,j} of (2.1). The whole chain is
implemented, and Lambert W by Newton on w + log w = log x.

- `[x]` **everything the paper prints is reproduced**: μ₁(w) under (7.6),
  c₁(w) = (1.8) to 5.0e−76 relative, c₂(w)'s eight-degree rational function,
  κ_m = 1, 1/12, 1/288, −139/51840, −571/2488320 from (7.11) alone, (7.14)
  against the crate's exact n!/(2n)!, and W(1) = the omega constant.
- `[x]` **[O'S] Table 1, all four rows** (K = 1, 3, 5, 7 at n = 1000), every
  one to all twenty digits printed — a single check on the Bell chain *and* on
  H1's quadrature, from a direction sharing no arithmetic with it.
- `[x]` **where the asymptotic series turns around**, which the table does not
  say: it saturates at **7 digits at n = 3** and **11 at n = 10**, and has not
  turned by K = 24 for n ≥ 200 (44.7 digits at n = 200, 58.5 at n = 1000).
- `[x]` **it is not a cheaper route to γ(n).** At K = 24 the Bell chain costs
  **four times more** than 25 700 trapezoid nodes and delivers fewer digits; at
  K = 7 it is five times cheaper but stops at 21 digits, which is not enough
  for anything here. The quadrature stays.
- `[x]` **[GOR⁺]'s L_M parametrisation**, the root of M = L_M(πe^{L_M} + ¾),
  checked against W through a derived relation: w − L ≈ (3L/8+1)/((π/2)e^L(1+L))
  holds to three or four figures at n = 10 … 5000.
- `[x]` **(3.2), whose extracted text does not fix how its factors nest.** Both
  readings were evaluated rather than chosen: `… / √(2πK)` tends to 4/π, which
  nobody would write; `… · √(2π/K)` tends to **8**, which is [GORZ19]'s
  normalisation again and is also the factor a Laplace saddle produces. So the
  second is the reading, and **E18** covers both formulas.

**Cost: half a day, as estimated. 3 seconds to run.**

### `[x]` H6. Search over Ω ∈ LP for the criterion with the earliest onset. — DONE.

`bin/h6_omega`, `rust/src/omega.rs`. The most interesting thing in either
paper, and it reframes **C2**. [O'S] Theorem 3.5: for Φ(z) = Σ c_j z^j/j! real
entire of genus 1\* and **any** Ω in the Laguerre–Pólya class,

```text
Φ hyperbolic  ⟺  Σ_{j=0}^{d} C(d,j)·c_j·g*_{d−j}(Ω; x)  hyperbolic for all d ≥ 1
```

Ω = 1 gives J^{d,n}; Ω = e^{−z²} gives P^{d,n}(x/2). **That single substitution
took the effective bound from e^{0.96d} to d^{3/4}log²n**, so the free
parameter is not the degree and not w — it is Ω, and H3 supplies the cost
function.

The whole search is one formula. Writing M := Ω(σz)·e^{z²} — a second
application of Lemma 3.4, which avoids converting bases and so keeps [O'S]'s
own criterion exactly as cancellation-free as he wrote it —

```text
χ_j = Σ_i C(j,i)·γ(n+i)σ^i·M_{j−i},   c_k = C(d,d−k)·χ_{d−k}
T   = Σ_{k≤d−2} 2^k·k!·c_k² / (2^d·(d−1)!·c_d²)   <  1
```

- `[x]` **both papers' criteria are points of this search**, which is the
  validation: ν = 0, μ = 0, σ = 1, g\* form reproduces [O'S] (8.2) to 6.05e−77,
  and Ω = 1, σ = Δ/ρ, τ = −1/Δ, g form reproduces [GOR⁺] (2.9) to 8.39e−69 —
  50 cells each, against a `turan.rs` that never touches Lemma 3.4.
- `[x]` **σ is not a third dial.** LP already contains the affine group:
  translation is Ω = e^{−τz}, scaling is Ω → Ω(σ·). Only the σ acting on
  Θ^{(n)} is carried separately.
- `[x]` **dial ν: [O'S]'s Ω is a razor-sharp optimum.** T depends on the whole
  Gaussian family only through ν = 1 − βσ², and a **1% move in ν costs four
  decades**, in either direction, nearly symmetrically in |ν|. The reason is
  structural: Turán III is a statement in the Hermite basis, and ν = 0 is the
  one Ω for which the criterion polynomial is *already* in it.
- `[x]` **dial μ: [O'S]'s choice is not optimal, and [GOR⁺]'s Δ says where to
  move.** χ₂(μ) = γ(n+2) − 2μγ(n+1) + μ²γ(n) is a parabola with roots
  **μ± = γ(n+1)/γ(n)·(1 ± √2·Δ(n+2))**, and at μ± the dominant term of Turán's
  sum is annihilated outright: at (8,20), T falls from 5.412e−7 to **2.662e−16**,
  a factor of 4.9e−10.
- `[x]` **the shift changes the power of d, not the constant.** [O'S]'s P
  carries d^3.015 (the j = 2 term, d·C(d,2)/8); the shifted criterion carries
  d^4.011 (j = 3 takes over). d_max at n = 0 goes from **400 to > 1400**
  (search cap) with the d⁴ law extrapolating to ~10⁴, and n₀(d) = 0 for every
  d ≤ 1000 where P needs up to 23. Whether the *exponent* of n₀(d) improves is
  **not settled** — it needs d beyond 10⁴, a bigger computation than this item.
- `[x]` **every other Ω is worse, most of them far worse.** The Bessel family
  J_α of [O'S] Theorem 3.9 — the one extended criterion the paper itself
  proposes — fails at d = 2 where [O'S]'s reaches 400; so do cos z, Ω = 1 in
  either form, and every non-unit Gaussian.
- `[x]` **d_max is not scale-invariant** — see **E19**. Measured d_max ∝
  σ^{−4/3} to three figures at four scales.
- `[x]` **precision is not the obstacle**, measured: the shift is an exact
  cancellation by construction, and T is nevertheless identical at 60, 120 and
  240 digits at every d from 100 to 1400.

**Cost: a day, as estimated. 64 seconds to run.**

---

## D. Closed — do not redo

Recorded so the same ground is not re-covered. Everything here is `[-]`.

| | Dead end | Why it is dead |
|---|---|---|
| `[-]` | Quaternionic axis for the degree | Fueter regularity excludes power series; slice regularity's Representation Formula makes extra axes carry no independent information ([CONTINUATION.md](CONTINUATION.md) §8.1) |
| `[-]` | Naive quadrature zero-hunting for R(w) | Produced convincing fictitious zeros twice. Any candidate must survive both a rule change and a precision change ([CONTINUATION.md](CONTINUATION.md) §5) |
| `[-]` | **Bounded scanning as evidence that R − 1 has no zeros** | The infimum sits on the *boundary* of every box tried, and \|R − 1\| decays like ~3/\|w\|. A bigger box moves the infimum down, never to zero — so no scan, at any precision, is evidence of absence (**B3**) |
| `[-]` | **Reading any R or Γ_Φ table above \|Im w\| ≈ 200** | \|Γ_Φ\| has fallen to ~1e−80 by 400i and ~1e−200 by 1000i; at 50 digits the ratio (24) is formed from noise. On Re w = 5, \|w\|(R−1) reads 2.33, 2.84, 3.05 at 10i, 50i, 150i — and then **426.07 at 400i** ([rust/RESULTS.md](rust/RESULTS.md)) |
| `[-]` | **Numerical creep on \|w\|(R − 1)** | Sixteen-fold in w bought 0.26 and the trend indicator reversed direction. See **G5** |
| `[-]` | The ⟨a, b⟩ = cos(π/6)\|η\|² pairing | Free positivity of a norm-square; true of every Dirichlet series ([rh3 §10](../html/rh3.html#s10)) |
| `[-]` | Log-concavity of the raw moments γ(n) | Forced log-*convex* by Cauchy–Schwarz for any positive weight; carries no information ([POSITIVITY.md](POSITIVITY.md) §2) |
| `[-]` | Smearing the level sum into the cone | Γ-factors and exponentials, zero-free ([rh3 §11](../html/rh3.html#s11)) |
| `[-]` | Reading raw discriminants as a difficulty trend | Measures the discriminant's dimensionality in d, not conditioning ([INTEGERS.md](INTEGERS.md) §5). `max width` (**B1**) is the reading that does work |
| `[-]` | **Certifying more (d, n) by discriminant sign, as an end in itself** | Chasse 2013 has d ≤ 2 × 10¹⁷ for all n ≥ 0 and [GOR⁺] Cor. 1.3 has d ≤ 9 × 10²⁴ (**E8**). Extending B1's range proves nothing new; only **G1** (making *this* route rigorous) and **H3** (where the Turán criteria actually switch on) have anything left to find |
| `[-]` | **The discriminant as the certification route at all, if H2 says otherwise** | It needs a 3.6e−18 enclosure at (6, 30) to separate a number of size 10⁻⁶³⁷ from zero. Turán's criterion ([O'S] (8.2), [GOR⁺] (2.9)) compares a sum of squares against **1**. If the margin can be O(1), taking it at 10⁻⁶³⁷ is a choice, not a necessity |

---

## E. Corrections already applied — keep them applied

Twenty-two entries. Listed so they are not quietly reintroduced by a later
edit. 1–4 predate the Rust implementation, 5–7 were found by it, 8–9 by reading
the two papers, 10–11 by carrying out H1, 12–16 by G1–G3, 17–19 by H4–H6, 20–21
by G6, and **22 is not an error but a sharpening** of one — kept here because
anyone who acts on E10 alone will get the reach of the quadrature wrong. **E18 is not this directory's error** — it
is a normalisation carried across two published formulas, recorded here because
anyone using them numerically has to know.

- `[x]` **E1. "Φ needs ≥ 50 decimal digits."** Wrong diagnosis. The cancellation
  is entirely on u < 0 and Φ is even, so `Φ(|u|)` with 6 terms in float64 holds
  1e−15 relative down to Φ ~ 1e−30. Corrected in README §7, POSITIVITY §7,
  INTEGERS §3.
- `[x]` **E2. "Certificates get harder with d."** Artifact of the discriminant
  being a product over d(d−1)/2 squared root gaps. Scale-free margins are flat
  at 90–100% of Hermite. Corrected in INTEGERS §5.
- `[x]` **E3. Conflating the Jensen-degree axis with rh28/rh29's decaying
  floor.** Two different uniformities; neither bears on the other. Retracted in
  INTEGERS §5.
- `[x]` **E4. Two spurious complex zeros of R − 1**, one Newton-converged to
  1e−09 and surviving one refinement round. Method and diagnostic recorded in
  CONTINUATION §5.
- `[x]` **E5. "z₄ is a pure truncation artifact" (§8.3).** Wrong. At K = 48 it
  lands 1.0e−05 from −γ₄² — the fourth zero, under-resolved, not spurious. The
  general lesson is the opposite of the one §5 teaches and has to sit beside it:
  an unstable root is *evidence of nothing either way* until K_req is known
  (**G6**). Retraction in the file itself is still owed — **A4**.
- `[x]` **E6. The V₀ = −16 truncation had two errors, not one.** The missing
  tail (A3) and, underneath it, an Euler–Maclaurin boundary term of 1.3e−13
  relative that scales as h² and that **no tail correction repairs**. Only moving
  V₀ fixes the second. Any future "just add the tail back" patch at V₀ = −16 is
  reintroducing it.
- `[x]` **E7. INTEGERS §3's Φ(1.6).** Published as 8.752056431082448e−30.
  Sixty-digit arithmetic gives 8.752056431082564e−30 and independent float64
  gives 8.7520564310825e−30, so the published value's last three digits are the
  outlier. Everything else in that table reproduces to the digits it prints.
- `[x]` **E8. B1's statement is not new — it is Chasse 2013.** Chasse proved
  J_{d,n} hyperbolic for **all n ≥ 0 and d ≤ 2 × 10¹⁷** ([Cha13], via
  Borcea–Brändén and Obreschkoff); [GOR⁺] Corollary 1.3 extends that to
  **d ≤ 9 × 10²⁴** using Platt–Trudgian's verification of RH₀ to 3 × 10¹².
  B1's 35 polynomials sit at d ≤ 6, n ≤ 30 — inside the known range by
  twenty-four orders of magnitude. What B1 actually contributes is a
  **pipeline** (enclosures of γ(n) from the horn's own integral, propagated
  through an interval LDLᵀ to a certified sign), not a theorem, and **G1 and G2
  must be read that way**: G1 would make *this directory's* route rigorous, and
  G2 measures where *this pipeline* breaks — neither extends what is known
  about hyperbolicity. Corrected in B1 and G1 above.
- `[x]` **E9. The horn is not new either, and it has a name.** [O'S] (6.1)
  defines θ(t) = Σ_{k∈ℤ} e^{−πk²t}, ω(t) = ½(3tθ′(t) + 2t²θ″(t)) and
  **Φ(x) := 2e^{x/2}ω(e^{2x})** — which expands to exactly **twice** this
  directory's Φ. And (7.2), **ξ^(n)(½) = ∫_{−∞}^{∞} Φ(y)·y^n dy**, is
  attributed to Romik and called "implicit in Jensen's formula from [Jen13,
  p. 189]" — 1913. The README's framing ("the mathematical content is classical
  throughout") was right; this is the specific citation it was missing, and any
  wording suggesting the construction originates here should go.

- `[x]` **E10. "The binding constraint is node density" (H1, as first
  written).** Wrong, and wrong by a hundred digits. It reasoned from the
  Laplace width — 4.6 nodes across the peak at n = 1000, 1.3 at n = 10⁴ — and
  concluded the rule was at its limit. Measured: at h = 0.004, i.e. **2.3**
  nodes across the width, a(1000) is still correct to 40 digits, and at the
  standard h = 0.002 to ~133. Counting nodes across a peak estimates
  *algebraic* convergence; the trapezoid rule on an integrand that is analytic
  in a strip and decays doubly-exponentially at both ends converges
  **geometrically**, so each halving of h roughly triples the digits rather
  than adding two. Any future capacity estimate for this quadrature that
  counts nodes is repeating the error.
- `[x]` **E11. `prec_digits()` is not what the scalar resolves.** astro-float
  rounds the requested precision up to whole 64-bit words, so
  `set_prec_digits(60)` asks for 216 bits and gets a 256-bit mantissa: two
  values can differ by 10⁻⁷⁷ where the request implies 10⁻⁶⁵. Found while H1
  reported rules agreeing "to 73 digits" at a nominal 65 — which was the
  arithmetic floor, not a measurement. `real::resolvable_digits()` now reports
  the true figure and `bin/h1_moment` caps its agreement column at it. Nothing
  else is affected in an unsafe direction: `ulp()` is computed from the
  *request*, so interval enclosures are wider than needed, never narrower.
- `[x]` **E12. "Poisson summation … which is explicitly boundable" (G1(b), as
  first written).** Overconfident, and in a way that matters if anyone tries
  it. The bound Σ_{k≠0} F̂(2πk/h) is only useful with a lower bound on the
  width of a *strip* on which F is analytic, and **F has no such strip.**
  F(v) = e^{(w+1)v}Φ(e^v), and the shell sum converges only where
  Re e^{2z} > 0, i.e. |Im z| < π/4; with z = e^v that is
  |e^{Re v}·sin(Im v)| < π/4, a region whose half-width **shrinks like
  e^{−Re v}** as v → +∞. So Trefethen–Weideman's strip theorem does not apply
  verbatim, and the standard estimate 2M/(e^{2πα/h} − 1) has no uniform α to
  quote. It is presumably repairable — the integrand is doubly-exponentially
  small exactly where the strip narrows — but "explicitly boundable" was
  written without checking, and the repair is a real piece of work rather than
  a substitution. **G1 did not need it**: at P's tolerance the elementary h²
  remainder clears the target with 33.1× to spare, so the Poisson route was
  never entered. The claim stands corrected, not discharged.
- `[x]` **E13. "bounded by sup|Φ′| on (−∞, V₀]" (G1(c), as first written).**
  Inconsistent with the order stated one clause earlier. Φ(u) − Φ(0) = ∫₀^u Φ′
  gives |Φ(u) − Φ(0)| ≤ u·sup|Φ′| = **O(e^v)** — one power short of the
  O(e^{2v}) the same sentence claims. Getting O(e^{2v}) needs Φ′(0) = 0, which
  is true (Φ is even — that *is* the theta functional equation) and then a
  bound on Φ″, not Φ′. The route actually taken needs neither: Φ(e^v) lies in
  Φ([0, e^{V₀}]) for every v ≤ V₀, so one interval evaluation of Φ over that
  range encloses the entire tail with no expansion at all, and no derivative of
  Φ appears anywhere in (G1c).
- `[x]` **E14. CONTINUATION (22) is derived by a step that is not available.**
  (22) reads

  ```
  Γ_Φ(w) = 4·Σ_{k≥0} c_{2k}/(w + 2k + 1)  +  4∫_1^∞ u^w Φ(u) du
  ```

  and gets there by "splitting at u = 1 and using Φ's Taylor series at the
  origin". **The Taylor series does not converge on [0, 1].** Φ(u) =
  2e^{u/2}ω(e^{2u}) with ω built from θ, and θ has Re t = 0 as a natural
  boundary, so Φ is analytic exactly on |Im u| < π/4 and no further — at
  u = iπ/4 the shell sum's own terms are (2π²k⁴e^{9iπ/8} − 3πk²e^{5iπ/8})(−1)^k
  and do not decay at all. The radius is **π/4 = 0.7854 < 1**, and G3 measures
  it: |c_m|^{1/m} runs 1.25–1.45 over 30 ≤ m ≤ 158, settling toward
  4/π = 1.27324 from above, with the coefficients enclosed to 1e−118 relative
  so the structure is Φ's and not roundoff. So the series in (22) **diverges**
  and the displayed identity is false as written.
  **The conclusion survives; only the derivation fails.** Split anywhere inside
  the disc instead — G3 uses U₀ = e^{−2} = 0.135 — and the same argument gives
  the same pole set, the same residues 4c_{2k}, and (23) entire. All three are
  checked. What must go is the formula as printed and the phrase "splitting at
  u = 1"; §7's "For Re w ≤ −1 use the split (22)" must go with it.
- `[x]` **E15. `mellin.rs`: "for Re w < −1 it is the meromorphic
  continuation."** False, and by margins that make it dangerous rather than
  approximate — at w = −1.5 it returns **2.14e4** where the answer is −7.74.
  Two independent causes, either fatal:
  * for Re w < −1 the integrand e^{(w+1)v}Φ(e^v) **grows** as v → −∞. V₀ = −50
    is chosen to make it negligible at the lower limit for Re w > −1; below −1
    it makes it enormous, and the Euler–Maclaurin boundary term is amplified by
    e^{(w+1)V₀}. Measured against (h²/12)·|w+1|·e^{(w+1)V₀}·Φ(0) the agreement
    is three significant figures at every w tried, from 2.27e−18 at w = −0.5 to
    1.33e33 at w = −2.9 — **fifty-one decades**, so the mechanism is identified
    and not merely observed;
  * the A3 tail approximates Φ(e^v) by Φ(0), so it carries the pole at w = −1
    and **no other**. Even with an exact quadrature the poles at −3, −5, …
    would be missing.
  Both are repaired by the same move, and `bin/g3_poles` makes it: split inside
  the disc of convergence and use the whole Taylor series below the split. The
  doc comment on `Mellin::tail` now says all of this.
- `[x]` **E16. Half-widths compared against full ones.** `certify_in` widens
  each coefficient to x ± |x|·w, so the enclosure it builds has *full* relative
  width **2w** — and `max_tolerable_width_in`, which bisects on that w, returns
  a **half**-width. But `Iv::rel_width()` is the full width, and `certify_iv`
  stored *that* in the same `Certificate::input_width` field. Every figure
  comparing the two therefore read **half its true value**. Found in G2, where
  the "needs" and "supplied" columns disagreed with the certifications printed
  beside them — d = 6 at n = 120 certified while the columns said it should
  not. **Nothing certified or failed to certify because of it**: the verdicts
  come from `certify_iv`, which never consults `max_tolerable_width_in`. What
  changes is a reported number: **G1's slack at the tightest demand is 33×, not
  the 16.5× first published.** `certify_iv` now stores a half-width like
  `certify_in`, `max_tolerable_width_in`'s doc says which it returns, and G2's
  two columns are both full widths so they compare directly.
- `[x]` **E17. "Both have cancellation in them — which is what 60 digits is
  for" (H4's own specification, as first written).** The second half is wrong.
  ω(t) = Σ_k πk²t(2πk²t − 3)e^{−πk²t} and ψ(t) = Σ_k e^{−πk²t} are both
  **positive for every t ≥ 1** — 2πt > 3 already at t = 1 — so [O'S] (7.1) and
  [GOR⁺]'s F(z) integrate positive integrands, and (3.1)'s difference does not
  cancel either: its first term beats its second by ~64M²/(log M)². Φ's famous
  cancellation lives entirely on u < 0, i.e. t < 1, which neither
  representation ever visits. What 60 digits is actually for on this route is
  the *dynamic range* — (log t)^{2n}e^{−πt} spans six hundred decades at
  n = 1000 — not cancellation.
- `[x]` **E18. [GOR⁺] (3.1) and (3.2) as printed return 8γ(M), not γ(M).**
  Both are quoted from [GOR⁺]'s reference [11] = [GORZ19], whose γ is eight
  times larger — a fact [O'S] states under Table 1 and [GOR⁺] do not repeat.
  Measured: **(3.1)/γ(M) = 8.00000000000000000000000000000** at every M from 1
  to 12, and (3.2)/γ(M) → 8 with the O_ε(M^{−1+ε}) residual the paper claims
  (7.869 at M = 10, 7.9975 at M = 1000, 7.99942 at M = 5000). The independent
  derivation — integrating ω = 2t²ψ″ + 3tψ′ by parts twice — puts (3.1)'s
  denominator at 2^{2M+2} rather than the printed 2^{2M−1}. Nothing in [GOR⁺]'s
  Theorem 2.2 depends on the constant, since (3.1) is used only through the
  asymptotic, so this is a normalisation carried across without conversion and
  not a defect in the proof. **Anyone evaluating (3.1) or (3.2) numerically
  must divide by 8.** (H5 also settles a second ambiguity in (3.2)'s extracted
  text: the radical is √(2π/K_{2M−2}), not 1/√(2π·K_{2M−2}) — the first tends
  to 8, the second to 4/π.)
- `[x]` **E19. "d ≤ 400 at n = 0" is a property of a normalisation, not of the
  criterion's Ω** *(qualifying H3)*. H6 measures **d_max ∝ σ^{−4/3}** under the
  scale σ — 0.398, 0.583, 1.000, 1.470, 2.525 against 0.397, 0.582, 1.000,
  1.468, 2.520 at σ = 2, 1.5, 1, 0.75, 0.5 — and a further factor of ~25 under
  a *translation* that is still a legal Ω. H3's comparison, 400 for [O'S] (8.2)
  against 7 for [GOR⁺] (2.9), remains correct as a statement about **those two
  published criteria**; it is not a statement about Ω = e^{−z²} against Ω = 1,
  and it should not be quoted as one. The scale-invariant reading is the growth
  of n₀(d), which no dial moves.

- `[x]` **E20. A bracket wide enough to hold two roots has no sign change at
  all** — so the bisection reports "no root" exactly where the root is best
  resolved. Hit twice while building **G6**, in two different disguises. First
  with a fixed window (target × 1.6 to target × 0.55), which is fine for z₁ and
  swallows the neighbour for every k ≥ 2, because the ξ zeros −γ_k² sit at
  ratios as close as 1.17; the symptom was a table of dashes in which only z₁
  and z₆ ever appeared. Fixed by tying the window to the **geometric midpoints
  between neighbours**. Then again at the *end* of the list, where the last
  target has no neighbour below it and the fallback window ran down to −3097 —
  swallowing z₁₁ at −2805.8 and producing a false **"K_req(10) > 170"**, which
  survived a whole run and was caught only because G4's regression found z₁₀
  perfectly well at K = 110. Fixed by carrying two extra γ_k that exist *only*
  to be neighbours; nothing measures K_req against them. The general form: a
  root-locating method whose failure mode is silent needs a regression that
  reaches past it.
- `[x]` **E21. "The two limits bind together — truncation and precision"**
  (`bin/b2_flow`'s own header, as first written). Measured, and they do not.
  **K_req is identical at 30, 45, 60 and 90 requested digits** — every entry of
  the k = 1 … 6 table, unchanged. Only truncation binds, and by a wide margin:
  at 30 digits requested (38 resolvable, **E11**) the answer is already the one
  90 digits gives. The premise mattered because it justified raising both at
  once and reporting neither separately; the measurement is one line of the G6
  driver and should have been made first.

- `[x]` **E22. E10 is right and incomplete: the node count *is* the diagnostic,
  squared in the exponent.** E10 retracted "the binding constraint is node
  density" and said, correctly, that counting nodes across the peak estimates
  *algebraic* convergence while the trapezoid on this integrand is
  **geometric**. True — but it left the node count looking irrelevant, and it
  is not. **G5**'s saddle gives the peak's half-width in closed form,
  σ = 1/√(−P″(v\*)), and the integrand is Gaussian to leading order, so Poisson
  summation puts the rule's relative error at

  ```text
  error  ≈  exp( −2π²·(σ/h)² )
  ```

  — the nodes across the width, entering *squared in the exponent* rather than
  as a power. Two consequences, both measured. The law says halving h
  **quadruples** the correct digits, against E10's "roughly triples" read off
  H1's ladder; H1 measured ×3.79 and ×3.29, which is ×4 seen through a slowly
  moving σ and a precision floor. And it says exactly where the fixed grid
  gives out: σ/h is 4.60 at w = 2000, 1.90 at 9600, **0.86 at 4×10⁴** and 0.24
  at 4×10⁵, for predicted errors 4e−182, 1e−31, 4.6e−7 and 0.31. Measured, the
  standard grid agrees with a halved one to ten digits at w = 9600, to seven at
  4×10⁴, and returns **−19.7** at w = 6.4×10⁶ where the truth is 3.693. So
  `Mellin::standard` is not a universal rule and never was; `watson::adapted_rule`
  is what to use above w ≈ 4×10⁴, and **any table of Γ_Φ or R at large w
  computed on the fixed grid should be re-checked against it**.

---

## F. Not worth doing

- `[-]` More sliders on [figure.html](figure.html). It shows what it needs to.
- `[-]` Continuing in d by Nörlund–Rice contour integral. §8.2's generating
  function already subsumes every degree; the contour route is strictly more
  machinery for the same object.
- `[-]` Another decade of w on |w|(R − 1). See D and **G5** — the answer is not
  down that road.
- `[-]` More precision for its own sake. Nothing in this directory is
  precision-bound any more; A1, A2, C1 and C2 are the binding constraints and
  none of them is arithmetic.
- `[-]` **Treating any of this as a route to RH.** The framing paragraph has said
  so from the start; there is now a citation. Farmer, *Jensen polynomials are
  not a viable route to proving the Riemann hypothesis* (arXiv:2008.07206,
  2020) — cited by [GOR⁺] themselves as reference [10]. And [GOR⁺]'s own
  Remark (3) says it from the inside: Jensen polynomials "are ultimately quite
  inefficient at detecting zeros that violate RH_n", and a converse to their
  Theorem 1.2 is "highly unlikely … unless one has hyperbolicity for all n ≥ m
  and all d ≥ 1". Read both before writing another sentence about what this
  directory could become.
- `[-]` Claiming a series slot. The series now runs to [rh39](../html/rh39.html), so
  it would be rh40 — and B1 is still conditional (**G1**) *and* subsumed
  (**E8**), and A1 is two-thirds paid; A2 is finally paid, and it was the easy
  one. The bar went up, not down.

---

*Files: [README.md](README.md) · [H_track.md](H_track.md) · [POSITIVITY.md](POSITIVITY.md) ·
[INTEGERS.md](INTEGERS.md) · [CONTINUATION.md](CONTINUATION.md) ·
[uniformity-in-the-jensen-degree-d.md](uniformity-in-the-jensen-degree-d.md) ·
[figure.html](figure.html) · [prime-horn.html](prime-horn.html) ·
[rust/](rust/) · [rust/RESULTS.md](rust/RESULTS.md)*

*Papers: [GOR⁺] [jensens-polynomials.pdf](jensens-polynomials.pdf) — Griffin,
Ono, Rolen, Thorner, Tripp, Wagner, Adv. Math. 397 (2022) 108186 ·
[O'S] [zeros-jensens-polynomials.pdf](zeros-jensens-polynomials.pdf) —
O'Sullivan, arXiv:2007.13582v2*
