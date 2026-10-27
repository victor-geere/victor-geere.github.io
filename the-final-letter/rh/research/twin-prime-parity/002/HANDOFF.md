# HANDOFF — session 002: the cone residue, the shift-2 deconstruction, and an audit of the archive's labels

**Created:** end of the session that produced the cone/parity work indexed as `002`.
**Working directory:** `/Users/victor/workspace/rh`.
**Status:** One theorem proved (the cone residue, conditional on a published result), one
**published error found and corrected**, one deconstruction that **undercut itself on inspection**,
and one audit that found the archive's `PROVED (Lean)` labels sound but roughly a third of its
`PROVED (paper argument)` and numerical labels unsupported by anything in the repository. The
target `Σ λ(n)λ(n+2) = o(x)` is **open and untouched**.

---

## 0. READ THIS FIRST — a correction, and a rule

**The rule:** *no load-bearing external citation goes into a document until someone has fetched the
source and read it.* In this session I published, in several artifacts, the claim that
`Σ_{n≤x} λ(n)λ(n+1) = o(x)` is a **theorem** of Matomäki–Radziwiłł–Tao. **It is false.** MRT prove the
shift-**averaged** form; the un-averaged statement is open for every shift. The claim was labelled
`EXTERNAL` with a citation, which is the correct protocol, and it passed **every machine check in the
repository** — a misattributed theorem is invisible to formal verification. It was caught by a
subagent instructed to audit mechanisms against primary sources, and I then verified it myself.

**Consequences a reader must know:**

1. Any document in this archive, or written in this session, that says *"the shift-1 correlation is
   solved"*, *"h=1 is a theorem"*, or *"given MRT, shift 2 is equivalent to the odd core"* is
   **wrong**. Corrected statements are in §3.
2. The full correction, with the verified quotations and a per-source table, is
   [`research/twin-prime-parity/cone/ERRATUM-mrt-misattribution.md`](../cone/ERRATUM-mrt-misattribution.md).
3. The archive's own protocol — label every claim `MACHINE-CHECKED` / `EXTERNAL (cited)` /
   `ARGUMENT` / `HEURISTIC` / `OPEN` — worked; what failed was my adherence to the citation half of
   it.

---

## 1. What this document is for

Session 001 (`../001/qa.md`) and the earlier rounds (`../rounds/`, top-level `HANDOFF.md`,
`theorems/`) built a large archive around the twin-prime/parity problem. Session 002 did four
things, in this order:

1. Finished the **Abelian-mean reductions** for the cone residue (goals 1–2 of the session).
2. Ran an **honest attack** on `o(x)`, which produced a **ledger and a verdict**, not a proof.
3. Attempted a **deconstruction of shift 2** — which produced a machine-checked identity, a false
   premise, and a correction.
4. **Audited the archive's verification labels** at the user's request.

§2 is the state of the mathematics. §3 is what is machine-checked. §4 is the error and its
consequences. §5 is the audit. §6 is what is open. §7 is a do-not-trust list. §8 is process.
§9 is how to re-verify everything.

---

## 2. State of the mathematics

**The cone residue is a theorem, conditional on a published result — it is not open.**
`C_f(p) = Σ_n λ(n)λ(n+2)(n(n+2))^{−p}`; its residue at `p = 1/2` is the Abelian mean
`lim_{ε↓0} ε Σ f(n)n^{−1−ε}`, and the machine-checked chain is: Cesàro mean `o(x)` ⟹ residue `0`
(deliverable 1a), and the **log-averaged** input `Σ_{n≤x} f(n)/n = o(log x)` ⟹ residue `0`
(1b). The second hypothesis is exactly Tao's logarithmically averaged two-point Chowla theorem,
which **is** a theorem ([Tao, Forum of Math Pi 2016](https://arxiv.org/abs/1509.05422)). So the
residue follows from published work; an earlier claim in the archive that "the residue is open" was
wrong and is corrected in the cone note §6.6.

**The residue is strictly weaker than `o(x)`.** `o(x)` ⟹ residue `0`, but not conversely: the
classical `cos(θ log n)` has vanishing Abelian mean and Cesàro mean `≍ x`. Therefore settling the
residue cannot give the target — a door that is now closed by a machine-checked implication plus a
cited counterexample, rather than left ambiguously open.

**The target `Σ_{n≤x} λ(n)λ(n+2) = o(x)` is open, and so is every other shift.** Verified from the
primary sources this session:

| result | status | source |
|---|---|---|
| two-point Chowla, **shift-averaged** | THEOREM | [MRT, ANT 9 (2015)](https://arxiv.org/abs/1503.05121) — *"remains unproven for any h₁,…,h_k with k ≥ 2"* |
| two-point Chowla, **shift 1**, un-averaged | only `1−δ`, called *"progress towards Chowla"* | [Matomäki–Radziwiłł, Ann. Math. 183 (2016)](https://arxiv.org/abs/1501.04585) |
| two-point Chowla, **log-averaged, all affine pairs** | THEOREM | [Tao, Forum Math Pi (2016)](https://arxiv.org/abs/1509.05422) |
| k=2, un-averaged, **all scales outside a zero-log-density set** | THEOREM | [Tao–Teräväinen, ANT 13 (2019)](https://arxiv.org/abs/1809.02518) |

Because Tao's log-averaged theorem covers *all* affine pairs `a₁b₂ − a₂b₁ ≠ 0`, shift 1, shift 2 and
the "odd core" are the **same statement at different parameters**, and the only gap —
logarithmic average → natural average — is **uniform across the family**. Nothing in the literature
distinguishes them.

**What the session's own probes found (all HEURISTIC, finite range).** At `N = 2²⁶`, the shift-2
correlation is statistically indistinguishable from white noise on every statistic tried
(`C(2)/(rms·√M) = +0.27`; periodogram max `13.76` vs `log M = 15.25`; Mellin max `2.32` vs random
control `2.40`; short intervals identical to controls), and the numerically verified Wiener–Khinchin
identity holds to `3.5×10⁻¹⁰`. No scale-localised conspiracy is visible up to `6.7×10⁷`. This is a
null result and says nothing about the asymptotics.

**Route ledger** (in `../cone/residue-verdict.md` §6–§8): closed by proof or by machine-checked
barrier — bounded-depth sieve (parity principle), positivity/majorant, Euler product and Type-II
convolution (no multiplicativity), averaging over shifts or scales (cannot reach a prescribed point);
the one route not contradicted is a **new positivity mechanism**, for which no candidate exists.

---

## 3. What is machine-checked (11 modules, all green, no `sorry`, no axioms)

Run: `cd lean && ./check.sh ConeLean/Cone.lean ConeLean/PairThreshold.lean ConeLean/PairCensus.lean ConeLean/ChowlaEquiv.lean ConeLean/ResidueReduction.lean ConeLean/ShiftBarrier.lean ConeLean/SpectralStructure.lean ConeLean/LogAverageBarrier.lean ConeLean/ParityObstruction.lean ConeLean/ShiftTwoCore.lean ConeLean.lean`
Log: [`../cone/verify/lean_check.log`](../cone/verify/lean_check.log) — 11/11 `[check] OK`, 0 warnings.

| module | key declarations | what they say |
|---|---|---|
| `ResidueReduction.lean` | `abelMean_tendsto_zero`, **`abelMean_tendsto_zero_of_logAverage`**, `coneTransform_sub_dirichlet_le` | Cesàro ⟹ Abel; log-average ⟹ Abel (the residue theorem); the pair weight differs from `n^{−2p}` by `O(1)` |
| `ChowlaEquiv.lean` | `chowlaSum_tendsto_iff_patCount_tendsto`, `chowla_not_multiplicative` | `o(x)` ⟺ four densities `1/4`; the correlation is not multiplicative |
| `SpectralStructure.lean` | `dft_autocorr`, `dft_mul_star_dft_eq_of_corr_eq_zero`, `corr_eq_zero_of_dft_mul_star_dft_eq` | finite Wiener–Khinchin; vanishing correlations ⟺ flat spectrum |
| `ShiftBarrier.lean` | `shift_average_does_not_control_single`, `scale_average_does_not_control_prescribed` | averaging over shifts, or over scales, cannot bound a prescribed point |
| `LogAverageBarrier.lean` | `sum_inv_sq_le_zeta_two`, `tendsto_sum_inv_sq_div_log`, `zero_log_density_meets_every_dyadic_block` | a log-average is blind to zero-harmonic-density sets |
| `ParityObstruction.lean` | `chowlaAF_one`, `chowlaAF_not_multiplicative`, `chowlaAF_not_conv` | no Euler product, no multiplicative Type-II summand |
| `ShiftTwoCore.lean` | `chowlaSum_shift_two_split`, **`shift_two_of_shift_one_and_core`**, `core_not_multiplicative`, `oddLam_not_multiplicative` | the exact parity identity, and the **sufficiency** (not equivalence) that follows from it |

`dft_autocorr` etc. rest on Mathlib's `ZMod.dft` API plus one new lemma, `star_stdAddChar`
(conjugation inverts the additive character, via `Circle.coe_inv_eq_conj`).
`ResidueReduction.lean` uses **zero** `native_decide`; the only computational-trust steps are the
`native_decide` witnesses in `ChowlaEquiv.lean`, `ParityObstruction.lean` and `ShiftTwoCore.lean`.

---

## 4. The error, in full, and what it changes

**Claimed:** `Σ λ(n)λ(n+1) = o(x)` is a theorem (MRT 2015); hence, given MRT, `h=2` is *equivalent*
to the odd core `C(K) = Σ_{k<K} λ(2k+1)λ(2k+3) = o(K)`.

**True:** un-averaged two-point Chowla is open for every shift (MRT abstract: *"remains unproven for
any h₁,…,h_k with k ≥ 2"*). MRT prove the shift average; MR give `1−δ` for `h=1`; Tao–Teräväinen
give k=2 outside a zero-log-density set of scales; Tao gives the log-averaged form for all affine
pairs.

**What survives (machine-checked, unaffected):** the exact identity
`Σ_{n<2M} λ(n)λ(n+2) = Σ_{j<M} λ(j)λ(j+1) + Σ_{k<M} λ(2k+1)λ(2k+3)` (cross-checked in exact integer
arithmetic at seven scales), the structural facts about the core (its arguments are coprime, `2` is
the only prime dividing both `n` and `n+2`, it is a difference of squares), and the
non-multiplicativity witnesses.

**What changes:** the identity gives a **sufficiency** — *if* both halves vanish *then* shift 2
vanishes — and the converse fails in general (the halves can cancel). **Both halves are open**, so
the split does **not** reduce shift 2 to a solved case, and the core is **not** the difficulty
isolated. My round-2 narrative ("the core is the differentiator") collapsed; the correct statement
is the one in §2: one open problem `Σ_m λ(m²−1) = o(x)`, split by the parity of `m`.

**Derived and recorded:** applying Tao–Teräväinen to the pairs `(0,1)` and `(0,2)` and feeding the
result into the identity gives `C(K) = o(K)` outside a set of zero logarithmic density — the core is
in exactly the same position as every other member of the family. (DERIVED by me from a verified
abstract; arithmetic mine.)

---

## 5. The audit of the archive's verification labels

Full report: [`AUDIT-verification-labels.md`](../../../theorems/AUDIT-verification-labels.md). Method:
two exhaustive mechanical sweeps plus a 40-document stratified sample (five parallel agents, each
required to quote `file:line`), with the three most serious findings re-verified by hand.

**Positive results.** Every Lean identifier cited anywhere in the prose resolves to a real
declaration (≈660 identifiers vs 661 archive + 165 893 Mathlib declarations; 0 genuine dangling).
`PROVED (Lean …)` labels held up **10/10** in the sample, several character-for-character. Of 752
named evidence artifacts, all exist except one.

**Defects, in order of severity.**

1. `theorems/tpp-rh40-round01-agentb-i-x-repair-realisable-window-starts.md` carries
   `Status: PROVED (paper argument)` while its source (`rounds/rh40/rounds/round01_agentB.md`) marks
   the passage `[CHARITABLE]` and its own `[VERDICT]` reads *"the a_m+2 form still lacks a proof"*,
   with an `[OPEN]` request for exactly that proof. **Verified by me.** This is the one finding that
   can mislead a reader about mathematics.
2. **`compute_rh17.py` is cited by three documents as producing "54 named checks" and exists
   nowhere.** `rh17-l2-aliasing-bound.md`, `rh17-t1-certified-sections.md`, `rh17-t2-exact-sections.md`.
   **Verified by me.**
3. `VERIFIED (numerical)` held up only **4/10**. The weak stratum is the `rh*.html` prose series
   (rh15, rh27b, rh36, xihorn horn-helix): the numbers exist only as prose in the HTML page, and the
   claimed "N named checks plus the inline assertion suite" is not in the repository.
4. Two outright mismatches, both **verified by me**: `theorems/tpp-rh40-readme-m9-single-one-word-solved.md`
   credits `verify/probes.py` with a law the script does not implement (the string `min(L` does not
   occur in it) and its labelled exhaustive sweep (239 599 cases) has **no enumerator**; and
   `handoff-greedy-squaring-law.md` attributes the census figure 128 541 453 to `x = (π−3)/π` while
   the archive's own enumerator (`verify/round7_AN_census.py:38`) and census journal attribute it to
   `x = π−3`.
5. `PROVED (paper argument)` held up **7/10**; two further documents (`rh17-l2`, `rh33-modulated-crystal-loss-exact.md`)
   advertise numerical support that is absent.
6. Small: `tpp-checks-06-not-multiplicative-no-euler-product.md` says `f(1) = +1` for
   `f(n) = λ(n)λ(n+2)`; it is `−1` — already machine-checked here as `ConeLean.chowlaAF_one`.
   `lean-rh41-digitword-c1-bound-a0-necessary.md`'s Source line is off by one (619–621 vs 620–622,
   verified by me).

**Repairs, in order:** demote the rh40 document to `OPEN`; resolve `compute_rh17.py` (commit it or
demote the three clauses); add a grade `VERIFIED (numerical, evidence absent)` and re-label the
`rh*.html`-derived documents — the archive already does this well once, disclosing in
`checks/06-numerical-checks.md:378` that `explicit_formula.log` "DOES NOT EXIST", and that
disclosure is the model to copy; fix the two small errors; then **re-run the sample at scale**,
because 6/10 numerical and 3/10 paper-argument labels were affected in 40 documents, which suggests
a population in the low hundreds.

---

## 6. What is open, ranked by tractability

1. **Repeat the label audit on a proper stratified sample** (cheap, mechanical, and the only item
   here with a certain payoff — see §5).
2. **Repair the five audit findings** (mechanical).
3. **The positivity route** — the single ledger entry not contradicted by a machine-checked fact
   (goal 3, `residue-verdict.md` §8). No candidate mechanism exists; refuting it looks more
   tractable than establishing it.
4. **`o(x)` itself** — open, uniform across shifts, and not reachable by any method in the ledger.
   Do not start here.
5. **Goal 5 is `blocked`, not complete.** Its objective text asserts the false equivalence from §4.
   Editing a goal's objective needs a direct instruction from the user; the corrected deliverable
   (identity + sufficiency + erratum) exists. Either edit the objective or close the goal.

---

## 7. Do-not-trust list

| claim | where | status |
|---|---|---|
| "shift-1 un-averaged Chowla is a theorem (MRT)" | `exceptional_set.py` comments (fixed), `exceptional-set-probe.md`, `shift-two-deconstruction.md`, `shift-two-lateral-appendix.md` (all bannered), goal-4/5 objectives | **FALSE** — see the erratum |
| "given MRT, h=2 ⟺ the odd core" | `shift-two-deconstruction.md` | **FALSE** — sufficiency only |
| "the core is where the difficulty sits" | same | **FALSE** — the gap is uniform across the affine family |
| "the residue is open" | earlier cone note text (fixed in §6.6) | **FALSE** — it follows from Tao's theorem |
| `PROVED (paper argument)` | `tpp-rh40-round01-agentb-i-x-repair-…` | **UNSUPPORTED** — source says the proof is missing |
| "54 named checks by `compute_rh17.py`" | three `rh17-*` documents | **UNSUPPORTED** — the script does not exist |
| `VERIFIED (numerical)` on `rh15`, `rh27b`, `rh36`, xihorn horn-helix | `theorems/rh*.md` | **UNSUPPORTED** — no script or log |
| "`probes.py` verifies the single-one law; 239 599/239 599" | `tpp-rh40-readme-m9-…` | **MISMATCH** — script lacks the check; no enumerator |
| "census 128 541 453 at `x = (π−3)/π`" | `handoff-greedy-squaring-law.md` (source: top-level `HANDOFF.md:40`) | **MISMATCH** — the enumerator runs `x = π−3` |
| subagent material in `chowla2/`, `research/shift2-audit/`, `odd-core-adversary/` | those directories | **NOT VERIFIED BY ME** except where quoted — and the reframer's items 5–6 inherit the §4 false premise |

---

## 8. Process lessons (the durable part of this session)

1. **Machine checks cannot catch a wrong citation.** Four separate rounds of this session rested on
   a misattributed theorem while every Lean build was green. The only defence is fetching the source
   and reading it. One subagent doing that was worth more than every formal check combined.
2. **Every numerical result in this session had at least one silent bug, and every one was caught by
   a check, never by inspection.** Mine: a `np.add.reduceat` prefix-offset error, a one-sided-FFT
   factor-of-2, short-interval windows limited by grid spacing. The subagents': applying `g(p)` once
   per multiple rather than once per prime power, producing an object that was not multiplicative at
   all and a spectacular false "separator". Write the self-check first.
3. **Subagents are useful as adversaries and auditors, and unreliable as authorities.** The
   mechanism audit found the error; its material still needed spot-checking (three findings
   re-verified by hand here) and it inherited my false premise in two items.
4. **Honest labels are load-bearing even when the mathematics is untouched.** The erratum, the
   barriers, and the audit all changed no theorem; they changed what a reader is entitled to believe.
5. **A null result is a result.** The probes found no conspiracy, the adversary found no separator,
   and both are worth more written down than forgotten — provided they are labelled as what they
   are.

---

## 9. How to re-verify everything

```bash
cd /Users/victor/workspace/rh/lean
./check.sh ConeLean/Cone.lean ConeLean/PairThreshold.lean ConeLean/PairCensus.lean \
          ConeLean/ChowlaEquiv.lean ConeLean/ResidueReduction.lean ConeLean/ShiftBarrier.lean \
          ConeLean/SpectralStructure.lean ConeLean/LogAverageBarrier.lean \
          ConeLean/ParityObstruction.lean ConeLean/ShiftTwoCore.lean ConeLean.lean
# expect: 11 × "[check] OK", 0 errors, 0 warnings, no sorry

cd ../research/twin-prime-parity/cone
python3 exceptional_set.py            # goal-4 probe  (sieve to 2^26, ~4 min)
python3 parity_diagnostic.py          # goal-3 (c3) diagnostic
python3 shift_two_split_check.py      # exact cross-check of chowlaSum_shift_two_split
python3 make_html.py <note>.md        # renders any note to self-contained HTML
```

Logs: `../cone/verify/{lean_check,exceptional_set,parity_diagnostic,shift_two_split_check}.log`.
Subagent reports: `../../../chowla2/REPORT.md`, `../../../research/shift2-audit/REPORT.md`,
`../../../odd-core-adversary/REPORT.md`.

**Goal states at handoff:** session goals 1–4 complete; **goal 5 blocked** (objective asserts the
false equivalence in §4; needs an instruction to edit or close it); no goal claimed `o(x)`.
