> **ERRATUM (see [`ERRATUM-mrt-misattribution.md`](ERRATUM-mrt-misattribution.md)).**  This
> document, as originally written, described `Σ λ(n)λ(n+1)` as *solved* and concluded that shift 2
> is *equivalent* to the odd core.  **That premise is false**: the un-averaged Chowla conjecture is
> open for every `k ≥ 2` ([MRT](https://arxiv.org/abs/1503.05121): "remains unproven for any
> h_1,…,h_k with k ≥ 2").  The correct consequence of the split below is a **sufficiency** — both
> halves open — not an equivalence.  The identities are unaffected.

# Lateral-thinking appendix: the odd core

*Goal 5, deliverable (4).  Labels: **MACHINE-CHECKED** / **IDENTITY** (exact, definitional or
elementary) / **ARGUMENT** (reasoning, not a proof) / **HEURISTIC** / **FAILED**.  Nothing in this
appendix is promoted to a claim, and there is no proof of anything here.*

## 0a. Subagent material (deliverable 4) — and one caveat

Two of the three subagents returned after this appendix was drafted. Their reports are on disk and
are **their** material, not checked by me line by line:

* reframer — [`chowla2/REPORT.md`](../../../chowla2/REPORT.md), `DATA.md`, and re-runnable checks
  (`checks1.py` … `checks5.py`, `fqt.py`, `growth.py`).  26 items, labelled IDENTITY / HEURISTIC / FAILED.
  **Caveat: two of its items (5 and 6) inherit the false premise corrected in
  [`ERRATUM-mrt-misattribution.md`](ERRATUM-mrt-misattribution.md)** — they call the shift-1 case a
  theorem.  The identities they state are checkable; the "=> MRT (THEOREM)" labels are wrong and
  must be re-read as "=> the open shift-1 statement".  Its item 17 (log-averaged case **is** a
  theorem: Tao 2016) is correct and is the sharpest single statement in the report.
* mechanism hunter — [`research/shift2-audit/REPORT.md`](../../shift2-audit/REPORT.md) (523 lines,
  every claim labelled CONFIDENT / PLAUSIBLE / UNVERIFIED) with `core_probe.py`,
  `core_probe2.py` and logs.  This is the report that caught the misattribution.
* adversary — **returned.**  [`odd-core-adversary/REPORT.md`](../../../odd-core-adversary/REPORT.md),
  scripts 01–21, repro via `16_final_consolidated.py` / `21_final_verify.py`.  Result: **FAILED-ATTEMPT
  to prove structural separation**, with one verified construction and three partial findings.
  Summarised in §5 below.  Its material is the subagent's; I have not re-run its scripts.

I have independently verified the two load-bearing citations myself (MRT's and Tao–Teräväinen's
abstracts, quoted in the erratum).  Everything else from the subagents is **UNVERIFIED by me** and
should be treated as lead material, not as established fact.

## 0. Status of the subagent pass

Three subagents were spawned under this brief (reframer / mechanism hunter / adversary), each with
explicit rules against fabricating proofs and with instructions to label every item and to run
numerics rather than assert.  **At the time of writing all three were still running and had returned
nothing.**  So this appendix records *my own* disciplined lateral pass, run under the same rules;
subagent material will be appended if and when it lands, with its labels preserved, and nothing from
it will be promoted without a check.

## 1. Reformulations of the core

**A1.** Core = difference of squares: `λ(2k+1)λ(2k+3) = λ((2k+2)² − 1)`.  **MACHINE-CHECKED**
(`core_diff_squares`).

**A2.** Core = the shift-2 correlation restricted to a parity class:
`C(K) = Σ_{n odd ≤ 2K} λ(n)λ(n+2)`.  **IDENTITY**.

**A3 (the substantive item).** Put `g(k) = λ(2k+1)`.  Then `λ(2k+1)λ(2k+3) = g(k)·g(k+1)`, so

```
C(K) = Σ_{k<K} g(k) g(k+1)        -- a SHIFT-1 two-point correlation
```

i.e. the core has exactly the *shape* that Matomäki–Radziwiłł–Tao solved — but for the sequence `g`
rather than for `λ`.  **IDENTITY** (definitional).  And `g` is **not multiplicative**:
`g(15) = λ(31) = −1` while `g(3)·g(5) = λ(7)λ(11) = +1`, with `3, 5` coprime —
**MACHINE-CHECKED** (`oddLam_not_multiplicative`).

Consequence, labelled **ARGUMENT** (a reason, not a proof that the method cannot be adapted): the
MRT mechanism consumes multiplicativity; `g` has none; so the method has nothing to consume in the
core.  This is my candidate answer to the question left open in the deconstruction note — *what is
the differentiator between h=1 and the core?* — and it is a candidate only.

**A4.** Norm form: `λ((2k+2)² − 1)`, and `m² − 1 = N(m + √1)` in the **split** algebra `ℤ[√1] ≅ ℤ×ℤ`.
So the core is a correlation over values of a split norm form.  **IDENTITY** (restatement).  The
question this raises — whether split norm forms are structurally different from elliptic ones (e.g.
`n² + 1 = N(n + i)` in `ℤ[i]`) for these correlations — is **OPEN**, and I have no evidence either
way.  Do not read the framing as a lead.

**A5.** Dirichlet series `D(s) = Σ_k g(k)g(k+1)k^{−s}` exists by construction; it has **no Euler
product**, by A3's machine-checked non-multiplicativity.  **IDENTITY** + **MACHINE-CHECKED** input.

**A6.** Spectral form: by goal 3's (b1) (MACHINE-CHECKED, `dft_autocorr`), the core is one Fourier
coefficient of the correlogram of `g`; "all shifts of `g` vanish" is equivalent to "the spectrum of
`g` is flat".  So the core is a single coefficient of a flat-spectrum statement about `g`.

**A7.** Numerical non-proportionality: at `M = 10⁶`, the shift-2 sum is `−941`, its h=1 part is
`−1109`, the core is `+168` (from `shift_two_split_check.py`, exact integers).  The two halves are
not proportionate, so there is no "half of the total" heuristic available.  **HEURISTIC**.

## 2. Mechanisms, and what each would need

**B1.** An MRT-type short-interval argument applied to `g`.  Blocked by A3's non-multiplicativity —
**ARGUMENT**.  A precise missing lemma would be: *for the specific sequence* `g(k) = λ(2k+1)`,
`Σ_{k≤K} g(k)g(k+1) = o(K)`.  That is the core restated, so it is not progress; its value is as a
statement of what a proof must consume.

**B2.** Entropy decrement / logarithmic averaging.  Produces log-averaged statements only, and goal
3's (b3) is **MACHINE-CHECKED** that a logarithmic average is blind to a prescribed scale — so this
route cannot deliver the core.

**B3.** Positivity / spectral realisation.  No candidate exists (goal 3, (c2) ledger).  **OPEN**.

**B4.** What would suffice, stated plainly: a prescribed-scale statement about a *non-multiplicative*
±1 sequence of a specific algebraic shape (`g`).  No toolkit in the current literature does this, and
I do not have one.

## 3. Failed attempts (recorded because failure is the honest output)

**C1 — model separation: FAILED.**  I looked for a model in which the shift-1 statement holds but the
core fails (which would prove the two are inequivalent in general, and hence that no argument using
only shift-1-type information can reach h=2).  I did not find one.  The natural candidates — a random
completely multiplicative ±1 function, or `λ` with the value at one prime flipped — are
non-pretentious and are expected to satisfy *both* statements, so they do not separate them.  No
verification of that expectation was attempted.

**C2 — dilation: FAILED, with a machine-checked reason.**  Seeking a substitution that moves the core
into a solved regime: blocked by `prime_dvd_shift_two` (MACHINE-CHECKED) — 2 is the only prime
dividing both `n` and `n+2`, so the 2-adic substitution is the only one of its kind, and it is
already used up.  This direction is genuinely closed, not merely unattempted.

**C3 — exhibiting the core as a norm or square of something solved: FAILED.**  Nothing found.

## 4. What is not here

No proof, no partial proof, no candidate proof, no numerical evidence about the limit.  The single
substantive new item is A3+B1: the core is a shift-1 correlation whose underlying sequence is
provably non-multiplicative, which is a *candidate* explanation of why the solved case's machinery
does not transfer.  It is an ARGUMENT with machine-checked support, and if it is wrong, the machine-
checked part (non-multiplicativity of `g`) still stands while the explanation falls.


---

## 5. Adversary report (subagent material, unverified by me)

**Headline: no separator found, and the one construction it did verify is a finite-window artefact.**
The adversary is explicit that it did not disprove Chowla, did not solve the core, and did not show
shift 2 inequivalent.

**The methodological warning — worth more than the mathematics.**  Its first "separator" returned
`|S₁(T)|/T = 0` exactly while `|C(T)|/T = 0.267`.  It was **its own sieve bug**: `G[p::p] *= g(p)`
applies `g(p)` once per *multiple* rather than once per *prime power*, so `G(p²) = g(p)` instead of
`g(p)²`, and the object was not completely multiplicative (16 violations in 200 000 pairs).  Fixed,
re-verified with 0 violations.  **Every numerical result in this session has had at least one silent
bug — mine included** (`np.add.reduceat` off-by-one; the one-sided-FFT factor of 2; short-interval
windows limited by grid spacing) — and every one was caught by a check, never by inspection.

**The construction (verified, but not a separator).**  An explicit completely multiplicative ±1
function `g` with `max_{n≤8·10⁸} |S₁(n)| = 29 431`, i.e. `S₁(X)/X = −2.6·10⁻⁵`, while
`|C(T)|/T = 0.1887` at `T = 8·10⁶` — about 530× the random-multiplicative size.  So for *arbitrary*
completely multiplicative ±1 functions, cancellation of shift 1 does **not** force the core to
vanish, and the two statements are not equivalent in that generality.  **But** `C(K)` grows linearly
inside the fitting window and then saturates (`1.61·10⁶` at `K = 10⁸`, `1.71·10⁶` at `4·10⁸` — a 4 %
move over a factor 4 in `K`), so `C(K)/K ~ 1/K` and is *not bounded away from zero*.  Not an
asymptotic separator, and the adversary says so plainly.

**Partial findings.**  (i) In the random completely-multiplicative model, both sums are `~√K`
(exact enumeration at `K = 2000`: variances 2070 and 2014; MC sds track `√K`) — **no random-model
separation**.  (ii) The one exact asymmetry is **quantitative**: `p = 2` supplies 0.1752 of the
shift-1 variance and *exactly* 0 of the core variance, since `2k±1` are odd — a ~18 % weakening of
the "entropy reserve", not a structural block.  (iii) Where the mechanism has no grip:
`T_k = λ(2k−1)` is **not multiplicative in the summation variable** `k` (`T_{ab} = T_aT_b` fails
50.18 % of the time — a coin flip), so any technique that treats the core as a multiplicative
function of its index has nothing to hold on to — *a statement about that mechanism class, and the
adversary labels it as such*.

**One error in its report, flagged so it is not propagated.**  It states that
`n(n+1) = ((2n+1)²−1)/4` maps the shift-1 sum to the **even** part of shift 2.  Under the convention
used throughout this repository it is the **odd**-`m` part (shift 1 ↔ odd `m`; the core ↔ even `m`) —
which is the same convention its own reduction check confirms (residual = the single unmatched tail
term).  Conclusion unaffected.

**The live question it leaves.**  Whether *any* construction can hold `C(K)/K` bounded away from 0
while the log-averaged Chowla statement `(1/log x)Σ g(n)g(n+1)/n → 0` holds — required of any
genuine separator, since that statement is a theorem for every bounded multiplicative `g`.  It found
none and cannot rule one out.  It also advises against further finite-window optimisation, which
cannot see the asymptotics.  I agree with both.

**What this does not do.**  It does not revive the retracted round-2 claim.  There is still no
un-averaged shift-1 theorem to differentiate from, and these findings concern mechanism classes and
*arbitrary* multiplicative functions, not `λ`.
