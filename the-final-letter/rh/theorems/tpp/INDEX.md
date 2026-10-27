# `theorems/tpp/` — index of the twin-prime-parity harvest

Every theorem, claim and proposition harvested from the **twin-prime-parity**
programme, one Markdown file per item. The folder is flat: **582 `.md` files** plus
one HTML paper, no subdirectories. Each file carries the source's own `Kind`, `Status`
and `Source` line and links back to the document it was taken from.

See [`../SPEC.md`](../SPEC.md) for what counts as a theorem and how statuses are
assigned, and [`../INDEX.md`](../INDEX.md) for the harvest-wide index across all
folders. Files are named `tpp-<source>-<slug>.md`; the sections below are grouped by
that `<source>` prefix, so each group is one source document.

## Groups at a glance

| prefix | files | source document |
|---|---|---|
| [`tpp-dict-00`](#tpp-dict-00) | 42 | `dictionary/00-dictionary.md` |
| [`tpp-dict-01`](#tpp-dict-01) | 10 | `dictionary/01-preliminaries.md` |
| [`tpp-dict-02`](#tpp-dict-02) | 7 | `dictionary/02-greedy-harmonic-sine.md` |
| [`tpp-dict-03`](#tpp-dict-03) | 54 | `dictionary/03-parity-problem.md` |
| [`tpp-dict-04`](#tpp-dict-04) | 17 | `dictionary/04-zeta-relations.md` |
| [`tpp-dict-05`](#tpp-dict-05) | 24 | `dictionary/05-programme-barriers-and-harvest.md` |
| [`tpp-checks-06`](#tpp-checks-06) | 17 | `checks/06-numerical-checks.md` |
| [`tpp-open-07`](#tpp-open-07) | 2 | `open/07-open-problems.md` |
| [`tpp-readme-x1`](#tpp-readme-x1) | 1 | `README.md` |
| [`tpp-readme-x2`](#tpp-readme-x2) | 1 | `README.md` |
| [`tpp-readme-x6`](#tpp-readme-x6) | 1 | `README.md` |
| [`tpp-rh40-ledger`](#tpp-rh40-ledger) | 6 | `rounds/rh40/rounds/ledger.md` |
| [`tpp-rh40-k1`](#tpp-rh40-k1) | 4 | `rounds/rh40/K1_plateau_theorem.md` |
| [`tpp-rh40-k`](#tpp-rh40-k) | 12 | `rounds/rh40/K_remaining.md` |
| [`tpp-rh40-readme`](#tpp-rh40-readme) | 11 | `rounds/rh40/README.md` |
| [`tpp-rh40-round01`](#tpp-rh40-round01) | 48 | `rounds/rh40/rounds/round01.md` |
| [`tpp-rh40-rounds`](#tpp-rh40-rounds) | 94 | `rounds/rh40/rounds/truths.md` |
| [`tpp-rh41-lean`](#tpp-rh41-lean) | 7 | `rounds/rh41/lean/README.md` |
| [`tpp-rh41-truths`](#tpp-rh41-truths) | 31 | `rounds/rh41/TRUTHS.md` |
| [`tpp-rh42-handoff`](#tpp-rh42-handoff) | 20 | `rounds/rh42/HANDOFF.md` |
| [`tpp-rh42-lean`](#tpp-rh42-lean) | 10 | `rounds/rh42/lean/README.md` |
| [`tpp-rh42-truths`](#tpp-rh42-truths) | 31 | `rounds/rh42/truths.md` |
| [`tpp-rh43-handoff`](#tpp-rh43-handoff) | 13 | `rounds/rh43/HANDOFF.md` |
| [`tpp-rh43-lean`](#tpp-rh43-lean) | 10 | `rounds/rh43/lean/README.md` |
| [`tpp-rh43-readme`](#tpp-rh43-readme) | 4 | `rounds/rh43/README.md` |
| [`tpp-rh43-truths`](#tpp-rh43-truths) | 39 | `rounds/rh43/truths.md` |
| [`tpp-rh044-handoff`](#tpp-rh044-handoff) | 2 | `rounds/rh044/HANDOFF.md` |
| [`tpp-rh044-readme`](#tpp-rh044-readme) | 5 | `rounds/rh044/README.md` |
| [`tpp-rh044-truths`](#tpp-rh044-truths) | 13 | `rounds/rh044/truths.md` |
| [`tpp-rh45-handoff`](#tpp-rh45-handoff) | 3 | `rounds/rh45/HANDOFF.md` |
| [`tpp-rh45-readme`](#tpp-rh45-readme) | 5 | `rounds/rh45/README.md` |
| [`tpp-rh45-truths`](#tpp-rh45-truths) | 8 | `rounds/rh45/truths.md` |
| [`tpp-rh46-readme`](#tpp-rh46-readme) | 6 | `rounds/rh46/README.md` |
| [`tpp-rh47-handoff`](#tpp-rh47-handoff) | 9 | `rounds/rh47/HANDOFF.md` |
| [`tpp-rh47-readme`](#tpp-rh47-readme) | 6 | `rounds/rh47/README.md` |
| [`tpp-rh47-truths`](#tpp-rh47-truths) | 9 | `rounds/rh47/truths.md` |
| **total** | **582** | |

## `tpp-dict-00`

<a id="tpp-dict-00"></a>

The programme's master dictionary — the index of every ledger row. Balance splits, the ζ-budget relations, the censused reachable set, the correlation facts (trivial bound, non-multiplicativity, the false asymptotic), the four thresholds, and the corrected barrier.

Source: [`dictionary/00-dictionary.md`](../../research/twin-prime-parity/dictionary/00-dictionary.md) &nbsp;·&nbsp; **42** files.

| file | kind | status |
|---|---|---|
| [``P_N + M_N = Re S_N`; balance ⟺ `P_N = \|M_N\|` ⟺ `Re S_N(t) = 0``](tpp-dict-00-balance-split-identity.md) | Theorem | PROVED (Lean) |
| [`bridge B1: the greedy support carries no `λ`-parity signal`](tpp-dict-00-bridge-b1-no-parity-signal.md) | Theorem | VERIFIED (numerical, with controls) |
| [`bridge B2: the ζ budgets split index parity, not `Ω`-parity`](tpp-dict-00-bridge-b2-index-parity.md) | Theorem | VERIFIED (numerical, `χ²=2.94`; source calls it "THEOREM-adjacent") |
| [`bridge B3: the `ζ`-machinery does not apply to the correlation`](tpp-dict-00-bridge-b3-zeta-machinery.md) | Theorem | PROVED (paper argument; source records THEOREM + NUMERICAL) |
| [`Brown's criterion: sub-sums fill `[0,A]` iff `a_k ≤ T_{k+1}` ∀k`](tpp-dict-00-brown-criterion.md) | Theorem | PROVED (paper argument) |
| [``P+N = ζ−1`, `P−N = 1−η`, `P > N` for all `p>0``](tpp-dict-00-budget-relations.md) | Theorem | PROVED (paper argument) |
| [`censused reachable set: `2^{n_min−1}` intervals, measure `2^{n_min−1}T_{n_min}``](tpp-dict-00-censused-reachable-set.md) | Theorem | PROVED (paper argument) |
| [`the corrected barrier: sign-blind alphabet, no arithmetic input`](tpp-dict-00-corrected-barrier-open.md) | Claim | OPEN (heuristic) |
| [``o(x)` fails for `λ ≡ 1` — `o(x)` is not a formal consequence`](tpp-dict-00-correlation-asymptotic-false.md) | Theorem | PROVED (Lean, `corrAsymptotic_zero_false`) |
| [``f(n) = λ(n)λ(n+2)` is not multiplicative; no Euler product`](tpp-dict-00-correlation-not-multiplicative.md) | Theorem | PROVED (Lean; source records THEOREM (Lean) + NUMERICAL) |
| [``S(x) = Σ_{n≤x}λ(n)λ(n+2)`; trivial bound `\|S\| ≤ x`; `S(x,0) = x``](tpp-dict-00-correlation-trivial-bound.md) | Theorem | PROVED (Lean) |
| [``η(s) = (1−2^{1−s})ζ(s)`, `η(1) = ln 2``](tpp-dict-00-eta-functional-identity.md) | Theorem | PROVED (paper argument) |
| [`for every `N ≥ 2` there is a height with `Re S_N(t) = 0``](tpp-dict-00-existence-of-balance-heights.md) | Theorem | PROVED (paper argument; `N=3,4` explicit, `N≥3` sketch) |
| [`exponential accuracy requires the functional equation`](tpp-dict-00-exponential-accuracy-needs-functional-equation.md) | Theorem | PROVED (paper argument) |
| [`the factor-complexity law `p(L)` (plateau, C1 regime)`](tpp-dict-00-factor-complexity-law.md) | Theorem | PROVED (Lean) |
| [`finite-prefix indeterminacy: `λ'' = λ` on `[1,10⁸]`, `1` beyond, has `S''/x → 1``](tpp-dict-00-finite-prefix-indeterminacy.md) | Theorem | PROVED (Lean slice layer; source records THEOREM (Lean slice layer) + NUMERICAL) |
| [`the four thresholds `pN < pP < p* < q``](tpp-dict-00-four-thresholds.md) | Theorem | VERIFIED (numerical, rigorous enclosures) |
| [`at `σ = 1/2` the parts are `~ (2/π)√N`; the sharp error is `√N/\|s−1\|``](tpp-dict-00-half-abscissa-parts-asymptotic.md) | Theorem | PROVED (paper argument; source records THEOREM + NUMERICAL) |
| [`the helix `(cos 2πθ, sin 2πθ, θ)`; the word cannot see turns`](tpp-dict-00-helix-word-cannot-see-turns.md) | Theorem | PROVED (paper argument) |
| [``\|S_N(t)\|` grows linearly: `\|S_N\|/N → 1/√(1+t²)``](tpp-dict-00-linear-growth-of-sn.md) | Theorem | PROVED (paper argument; source records THEOREM + NUMERICAL) |
| [`logarithmic Chowla (two-point)`](tpp-dict-00-logarithmic-chowla-two-point.md) | Theorem | CITED (literature, Tao 2016) |
| [``N = 2` balances exactly at `t = π/log 2` (tangential zero)`](tpp-dict-00-n2-balance-at-pi-over-log2.md) | Theorem | PROVED (Lean) |
| [``N = 3` balances via `Re S_3(5/2) < 0 < 3 = Re S_3(0)``](tpp-dict-00-n3-balance-by-sign-change.md) | Theorem | PROVED (Lean) |
| [`negative budget `N(p) = Σ_{k≥1}(2k+1)^{−p} = (1−2^{−p})ζ(p)−1``](tpp-dict-00-negative-budget.md) | Theorem | PROVED (paper argument) |
| [`negative half complete iff `p ≤ q = 2.0767752…``](tpp-dict-00-negative-half-complete-threshold.md) | Theorem | PROVED (paper argument) |
| [`parity lock: the signed support has all gaps even `≥ 2``](tpp-dict-00-parity-lock-signed-support-gaps.md) | Theorem | PROVED (Lean) |
| [`the parity phenomenon of sieve weights`](tpp-dict-00-parity-phenomenon-of-sieve-weights.md) | Theorem | CITED (literature; ledger records status "THEOREM / HEURISTIC") |
| [`the pole is split: `P(p) ~ N(p) ~ 1/(2(p−1))` as `p↓1``](tpp-dict-00-pole-split-budgets.md) | Theorem | PROVED (paper argument; source records THEOREM + NUMERICAL) |
| [`positive budget `P(p) = Σ_{k≥1}(2k)^{−p} = 2^{−p}ζ(p)``](tpp-dict-00-positive-budget.md) | Theorem | PROVED (Lean at `p=2,4`) |
| [`positive half complete iff `ζ(p) ≥ 2`, i.e. `p ≤ p* = 1.7286472…``](tpp-dict-00-positive-half-complete-threshold.md) | Theorem | PROVED (Lean) |
| [``S_3(t) ≠ 0` for every real `t`; `S_2(π/log 2) = 0` exactly`](tpp-dict-00-s3-nonvanishing.md) | Theorem | PROVED (Lean) |
| [`the sharp constant is `1/\|s−1\| = 1/√(1/4+t²)`, not `1/√(2t)``](tpp-dict-00-sharp-constant-refuted.md) | Claim | REFUTED (first draft; the corrected constant `1/\|s−1\|` is asserted instead) |
| [`the residual obeys `S_N^φ−ζ = N^{1−s}J_φ + φ(0)ζ(s) + R_N``](tpp-dict-00-smoothed-residual-decomposition.md) | Theorem | PROVED (paper argument; source records THEOREM + NUMERICAL) |
| [`smoothing does not remove `√N`: `\|S_N^φ−ζ\|/√N → \|M_φ(s)\|``](tpp-dict-00-smoothing-does-not-remove-sqrt-n.md) | Theorem | PROVED (paper argument, asymptotic; source records THEOREM (asymptotic) + NUMERICAL) |
| [`a sparse modification cannot move `S`: `≤ 4·#{m ≤ x+2 : m ∈ A}``](tpp-dict-00-sparse-modification-bound.md) | Theorem | PROVED (paper argument; corrected in rh47) |
| [`the support is Sylvester-sparse: `m_{i+1} ≥ m_i(m_i−1)+1``](tpp-dict-00-sylvester-sparse-support.md) | Theorem | PROVED (paper argument; source records THEOREM + NUMERICAL) |
| [`the term-level two-and-two split fails at balance points`](tpp-dict-00-term-level-split-fails.md) | Theorem | VERIFIED (numerical, exact subset-sum) |
| [`un-averaged two-point Chowla `Σλ(n)λ(n+2) = o(x)``](tpp-dict-00-un-averaged-two-point-chowla-open.md) | Claim | OPEN |
| [`the Weil explicit formula needs the archimedean term and poles `2φ(i/2)``](tpp-dict-00-weil-explicit-formula-archimedean-term.md) | Theorem | PROVED (paper argument; the first draft omitting them is REFUTED) |
| [`the word factors through the height `sin(2πθ)``](tpp-dict-00-word-factors-through-height.md) | Theorem | PROVED (paper argument) |
| [`counting: `N(T) = θ(T)/π + 1 + S(T) = (T/2π)log(T/2πe)+7/8+S(T)+O(1/T)``](tpp-dict-00-zero-counting-asymptotic.md) | Theorem | PROVED (paper argument; source records THEOREM + NUMERICAL) |
| [`zeros located from `ζ` evaluations alone to 32–33 digits`](tpp-dict-00-zeros-from-zeta-evaluations.md) | Theorem | VERIFIED (numerical, 32–33 digits) |

## `tpp-dict-01`

<a id="tpp-dict-01"></a>

Classical prerequisites used throughout: the Euler product and analytic continuation of ζ, the Dirichlet series on the critical line, Abel/partial summation, the explicit formula, and zero counts.

Source: [`dictionary/01-preliminaries.md`](../../research/twin-prime-parity/dictionary/01-preliminaries.md) &nbsp;·&nbsp; **10** files.

| file | kind | status |
|---|---|---|
| [`(P4) Abel/partial summation`](tpp-dict-01-abel-partial-summation.md) | Theorem | CITED (literature; one-directional only) |
| [`(P3) The Dirichlet series on the critical line`](tpp-dict-01-critical-line-truncation-error.md) | Theorem | CITED (literature; local verification cited) |
| [`(P1) Euler product and analytic continuation of `ζ``](tpp-dict-01-euler-product-and-continuation.md) | Theorem | CITED (literature, classical) |
| [`(P5) The explicit formula (Riemann–von Mangoldt)`](tpp-dict-01-explicit-formula-rvm.md) | Theorem | CITED (literature, classical; archimedean term mandatory) |
| [`Lemma 2.1 (multiplicativity)`](tpp-dict-01-liouville-completely-multiplicative.md) | Lemma | PROVED (Lean, `liouville_mul`, for nonzero arguments) |
| [`Lemma 2.3 (the divisor identity)`](tpp-dict-01-liouville-divisor-identity.md) | Lemma | PROVED (paper argument; classical identity, numerically checked in the source) |
| [`Lemma 2.2 (the square)`](tpp-dict-01-liouville-square-and-abs-bound.md) | Lemma | PROVED (Lean, `liouville_sq`, `liouville_abs_le_one`) |
| [`Lemma 2.4 (the one-point average — a THEOREM)`](tpp-dict-01-one-point-liouville-average.md) | Lemma | PROVED (paper argument; unconditional) |
| [`(P2) The partial-sum asymptotic at `σ = 0` (Euler–Maclaurin)`](tpp-dict-01-partial-sum-asymptotic-sigma-0.md) | Theorem | CITED (literature; re-measured numerically in the source) |
| [`(P6) Counting formula`](tpp-dict-01-zero-counting-formula.md) | Theorem | CITED (literature; verified in rh45 §4) |

## `tpp-dict-02`

<a id="tpp-dict-02"></a>

The greedy harmonic sine construction itself: the factor-complexity law, factorisation through the height, the parity lock, the Egyptian transfer, and the large-`L` law for `p(L)`.

Source: [`dictionary/02-greedy-harmonic-sine.md`](../../research/twin-prime-parity/dictionary/02-greedy-harmonic-sine.md) &nbsp;·&nbsp; **7** files.

| file | kind | status |
|---|---|---|
| [`Corollary 2.4 (Egyptian transfer)`](tpp-dict-02-egyptian-transfer.md) | Corollary | PROVED (paper argument; source labels it THEOREM + NUMERICAL) |
| [`Theorem 1.3 (the factor-complexity law — rh41, closed and formalised)`](tpp-dict-02-factor-complexity-law.md) | Theorem | PROVED (Lean, no `sorry`; `rh41/lean`, 7 modules, 144 declarations) |
| [`Theorem 3.1 (factorisation through the height — THEOREM)`](tpp-dict-02-factorisation-through-the-height.md) | Theorem | PROVED (paper argument; source also NUMERICAL, 200 dps) |
| [`Theorem 2.3 (parity lock — THEOREM, Lean)`](tpp-dict-02-parity-lock.md) | Theorem | PROVED (Lean: `tauStep_nonneg`, `take_parity`, `support_subset_even`, `support_gap_even_and_two_le` in `rh42/lean/Rh42/Tau.lean`) |
| [`Corollary 3.2`](tpp-dict-02-periodic-rules-cannot-see-turns.md) | Corollary | PROVED (paper argument; stated as a corollary of Theorem 3.1) |
| [`Theorem 1.4 (rational termination)`](tpp-dict-02-rational-termination.md) | Theorem | PROVED (paper argument; source labels it THEOREM) |
| [`Theorem 4.1 (Sylvester-sparsity of the support — THEOREM)`](tpp-dict-02-sylvester-sparsity-of-support.md) | Theorem | PROVED (paper argument; source also NUMERICAL, 0 violations in 53 159 consecutive pairs) |

## `tpp-dict-03`

<a id="tpp-dict-03"></a>

The parity problem. Brun's upper bound, Chen's lower bound stopping at `P₂`, the Chowla and Sarnak conjectures and their almost-all and almost-every-scale weakenings, and why the averaged statements are insufficient.

Source: [`dictionary/03-parity-problem.md`](../../research/twin-prime-parity/dictionary/03-parity-problem.md) &nbsp;·&nbsp; **54** files.

| file | kind | status |
|---|---|---|
| [`THEOREM 4.6 (the almost-all statements are also insufficient)`](tpp-dict-03-almost-all-insufficient.md) | Theorem | PROVED (paper argument, meta-level: immediate from the quantifier structure of T4 and T7) |
| [`THEOREM 3.12 (Chowla for almost all scales / exceptional shifts — Tao–Teräväinen)`](tpp-dict-03-almost-all-scales.md) | Theorem | CITED (literature) |
| [`THEOREM 2.5 (Brun; the upper bound)`](tpp-dict-03-brun-upper-bound.md) | Theorem | CITED (literature; bibliographic details marked **unverified citation** in the source, Appendix A row Br1) |
| [`THEOREM 2.6 (the lower bound stops at `P₂`: Chen)`](tpp-dict-03-chen-p2.md) | Theorem | CITED (literature) |
| [`HEURISTIC 2.8 (the "switching" reading)`](tpp-dict-03-chen-switch-heuristic.md) | Claim | CONJECTURED (explicitly an interpretation, not a theorem) |
| [`Conjecture 3.1 (Chowla, 1965; `k`-point form)`](tpp-dict-03-chowla-conjecture.md) | Claim | OPEN (for every `k ≥ 2`; the case `k = 1` is PNT, a theorem) |
| [`Corollary 6.1 (why the greedy support is quantitatively useless here)`](tpp-dict-03-corollary-6-1-greedy-support-loglog.md) | Corollary | PROVED (paper argument, combining row T18 and row F5) |
| [`THEOREM 5.1 (the exact relation; no implication in either direction is known)`](tpp-dict-03-exact-relation-twin-primes.md) | Theorem | OPEN (for parts (b), (c); part (a) is PROVED (paper argument, via THEOREM 3.5)) |
| [`F1 — the trivial bound`](tpp-dict-03-f1-trivial-bound.md) | Theorem | PROVED (Lean: `corr_abs_le`, `corr_zero`) |
| [`F2 — the "`λ ≡ 1`" triviality: `o(x)` is not formal`](tpp-dict-03-f2-lambda-identically-one.md) | Theorem | PROVED (Lean: `corrAsymptotic_zero_false`) |
| [`F3 — no Euler product`](tpp-dict-03-f3-no-euler-product.md) | Theorem | PROVED (Lean; NUMERICAL discrepancy `2.0144` vs tail `1.84·10⁻⁵`) |
| [`F4 — finite-prefix indeterminacy`](tpp-dict-03-f4-finite-prefix-indeterminacy.md) | Theorem | PROVED (Lean slice layer: `slice_agree`, `corrSlice_eq_corr_of_lt`; NUMERICAL, auditor A1, all `10⁸` prefixes) |
| [`F5 — the corrected sparse-modification bound`](tpp-dict-03-f5-corrected-sparse-bound.md) | Theorem | PROVED (paper argument; **not** yet machine-checked — registered as OP-12) |
| [`F6 — no signal in the greedy support (bridge B1)`](tpp-dict-03-f6-no-signal-greedy-support.md) | Claim | REFUTED (numerically, with controls) |
| [`F7 — index parity ≠ `Ω` parity; index parity invisible to the correlation (bridge B2)`](tpp-dict-03-f7-index-parity-invisible.md) | Claim | REFUTED (the bridge claim; the companion twist-invariance is THEOREM 5.5) |
| [`F9 — the corrected barrier`](tpp-dict-03-f9-corrected-barrier.md) | Claim | OPEN (source label: HEURISTIC / **OPEN**; the source states the impossibility claim is **not** a theorem) |
| [`UNVERIFIED 4.7 (a recent frontier development; preprint, single author, not peer-reviewed)`](tpp-dict-03-guo-preprint-unverified.md) | Claim | OPEN (source label: **UNVERIFIED** citation; preprint, not peer-reviewed) |
| [`Conjecture 1.8 (Hardy–Littlewood / Dickson prime `k`-tuples)`](tpp-dict-03-hardy-littlewood-dickson-k-tuples.md) | Claim | OPEN (for every `k ≥ 2`; HEURISTIC as a prediction) |
| [`THEOREM (Landau; the parity classes have equal density 1/2)`](tpp-dict-03-landau-parity-classes-density.md) | Theorem | CITED (literature; classical, equivalent to PNT) |
| [`THEOREM (basic) — complete multiplicativity of `λ``](tpp-dict-03-liouville-completely-multiplicative.md) | Theorem | PROVED (Lean for the multiplicativity facts; Dirichlet-series identity cited from `01` §2) |
| [`THEOREM 4.4 (no such implication is available)`](tpp-dict-03-log-averaged-no-implication.md) | Theorem | PROVED (paper argument, meta-level: immediate consequence of T2 + OPEN 4.1) |
| [`HEURISTIC 4.5 (why log-averaging is genuinely weaker)`](tpp-dict-03-log-averaging-weaker-heuristic.md) | Claim | CONJECTURED (structural explanation; the rigorous content is THEOREM 4.4) |
| [`THEOREM 3.10 (log-Chowla ⟺ log-Sarnak)`](tpp-dict-03-log-chowla-iff-log-sarnak.md) | Theorem | CITED (literature) |
| [`THEOREM 3.6 (a non-trivial unconditional bound; the best elementary shape known to the programme)`](tpp-dict-03-matomaki-radziwill-bound.md) | Theorem | CITED (literature) |
| [`HEURISTIC 5.4 (the shape of the missing input)`](tpp-dict-03-missing-input-heuristic.md) | Claim | CONJECTURED (the three routes are theorems in their own problems; the necessity claim is a heuristic) |
| [`THEOREM (basic) — multiplicativity of `μ` and `μ * 1 = ε``](tpp-dict-03-mobius-multiplicative.md) | Theorem | CITED (literature; classical, no source line given in the file) |
| [`THEOREM 3.11 (Chowla for almost all shifts — Matomäki–Radziwiłł–Tao "MRTT")`](tpp-dict-03-mrtt-almost-all-shifts.md) | Theorem | CITED (literature) |
| [`THEOREM 5.2 (what is excluded)`](tpp-dict-03-no-bounded-depth-sieve-lower-bound.md) | Theorem | PROVED (paper argument, immediate from THEOREM 2.1 / §2.1) |
| [`THEOREM 5.3 (what is *not* excluded)`](tpp-dict-03-no-impossibility-theorem.md) | Theorem | PROVED (paper argument, meta-level: no such impossibility theorem is known) |
| [`THEOREM 3.3 — one-point Chowla is equivalent to PNT`](tpp-dict-03-one-point-chowla-iff-pnt.md) | Theorem | PROVED (paper argument; classical equivalence, proof route given in the source) |
| [`OPEN 4.2 — the register of open statements`](tpp-dict-03-open-chowla-twin-sarnak-elliott.md) | Claim | OPEN |
| [`OPEN 4.3 (a genuinely open "intermediate" statement, for calibration)`](tpp-dict-03-open-intermediate-decay.md) | Claim | OPEN |
| [`THEOREM 2.2 (the periodic case — the honest small-prime statement)`](tpp-dict-03-periodic-weight-liouville.md) | Theorem | PROVED (paper argument; classical ingredients, proof written out in the source) |
| [`HEURISTIC 3.2 (the random-sign model)`](tpp-dict-03-random-sign-heuristic.md) | Claim | CONJECTURED (heuristic model; not a proof) |
| [`THEOREM 2.1 (Selberg's parity principle, as sharpened by Polymath8b)`](tpp-dict-03-selberg-parity-principle.md) | Theorem | CITED (literature) |
| [`HEURISTIC 2.4 (why the slogan is nevertheless the right picture)`](tpp-dict-03-slogan-heuristic.md) | Claim | CONJECTURED (heuristic expectation; not a proof) |
| [`THEOREM 3.13 (the structure theorem for correlations; the modern "why")`](tpp-dict-03-structure-theorem-correlations.md) | Theorem | CITED (literature) |
| [`T10 — Goldston–Pintz–Yıldırım: small gaps relative to the average`](tpp-dict-03-t10-gpy.md) | Theorem | CITED (literature) |
| [`T11 — Zhang: bounded gaps between primes`](tpp-dict-03-t11-zhang.md) | Theorem | CITED (literature) |
| [`T14 — Friedlander–Iwaniec: `X² + Y⁴` captures its primes`](tpp-dict-03-t14-x2-y4-captures-primes.md) | Theorem | CITED (literature) |
| [`T15 — the asymptotic sieve (Friedlander–Iwaniec)`](tpp-dict-03-t15-asymptotic-sieve.md) | Theorem | CITED (literature) |
| [`T16 — equidistribution of primes in arithmetic progressions to large moduli (BFI)`](tpp-dict-03-t16-bfi-large-moduli.md) | Theorem | CITED (literature; **partially verified** citation — volume/pages not independently confirmed) |
| [`T18 — the greedy support is Sylvester-sparse`](tpp-dict-03-t18-greedy-sylvester-sparse.md) | Theorem | PROVED (paper argument; NUMERICAL, verified internally: 0 violations in 53 159 consecutive pairs) |
| [`T5 — Matomäki–Radziwiłł: the non-trivial bound and `μ` in short intervals`](tpp-dict-03-t5-matomaki-radziwill.md) | Theorem | CITED (literature) |
| [`T8 — Polymath8b: bounded gaps and the parity ceiling`](tpp-dict-03-t8-polymath8b-bounded-gaps.md) | Theorem | CITED (literature) |
| [`T9 — Maynard: bounded gaps in every order and the `k`-tuples proportion`](tpp-dict-03-t9-maynard.md) | Theorem | CITED (literature) |
| [`THEOREM 3.8 (log-averaged two-point Chowla; Tao 2015/2016)`](tpp-dict-03-tao-log-two-point-chowla.md) | Theorem | CITED (literature) |
| [`THEOREM 3.9 (log-averaged Chowla for odd orders and for k = 2 — Tao–Teräväinen, Tao)`](tpp-dict-03-tao-teravainen-log-all-orders.md) | Theorem | CITED (literature) |
| [`UNVERIFIED 2.3 (the truncated case — the slogan cannot be taken literally)`](tpp-dict-03-truncated-weights-unverified.md) | Claim | OPEN (source label: **UNVERIFIED**; the literal identity is not a theorem of the standard theory here) |
| [`OPEN 2.7 — the twin prime lower bound`](tpp-dict-03-twin-prime-open.md) | Claim | OPEN |
| [`THEOREM 5.5 (the twist-invariance identity, `F7`; why index parity is irrelevant)`](tpp-dict-03-twist-invariance.md) | Theorem | PROVED (paper argument, elementary; VERIFIED numerical, 0 mismatches in `10⁶` terms) |
| [`OPEN 3.4 (the target)`](tpp-dict-03-two-point-chowla-open.md) | Claim | OPEN |
| [`THEOREM 3.5 (the exact equivalent form; a sharpening of the rounds' phrasing)`](tpp-dict-03-two-point-equidistribution.md) | Theorem | PROVED (paper argument, elementary given THEOREM 3.3) |
| [`THEOREM (basic) — `Λ = μ * log` and PNT`](tpp-dict-03-von-mangoldt-convolution-pnt.md) | Theorem | CITED (literature; classical, no source line given in the file) |

## `tpp-dict-04`

<a id="tpp-dict-04"></a>

The ζ-relations: Brown's criterion for sub-sums filling `[0,A]`, the census of the reachable set, the attainable limits, and the completeness thresholds.

Source: [`dictionary/04-zeta-relations.md`](../../research/twin-prime-parity/dictionary/04-zeta-relations.md) &nbsp;·&nbsp; **17** files.

| file | kind | status |
|---|---|---|
| [`Theorem 3.2 (attainability)`](tpp-dict-04-attainability-of-balance.md) | Theorem | PROVED (Lean for `N = 3`; `N = 4` by certified numerical enclosure; PROOF-SKETCH + VERIFIED numerically to `N = 200` for all `N`) |
| [`Theorem 3.1 (the identity)`](tpp-dict-04-balance-split-identity.md) | Theorem | PROVED (Lean: `realPartial_eq_posRe_add_negRe`, `balanced_iff_realPartial_eq_zero`, `balanced_equal_split`, `equal_split_balanced`) |
| [`Theorem 2.1 (Brown's criterion)`](tpp-dict-04-brown-criterion.md) | Theorem | PROVED (paper argument; one-step lemmas machine-checked in `Rh42/Reachable.lean`) |
| [`Theorem 2.3 (census)`](tpp-dict-04-census-of-reachable-set.md) | Theorem | PROVED (paper argument; source also NUMERICAL, 70/70 checks in `rh42/verify/reachable.log`) |
| [`Theorem 2.2 (completeness thresholds)`](tpp-dict-04-completeness-thresholds.md) | Theorem | PROVED (paper argument; source also NUMERICAL, 70/70 checks in `rh42/verify/reachable.log`) |
| [`Theorem 3.3 (the complex split is a different question)`](tpp-dict-04-complex-split-different-question.md) | Theorem | PROVED (Lean: `zetaPartial_two_pi_div_log_two`, `zetaPartial_three_ne_zero`) |
| [`Theorem 1.1 (the even/odd split of ζ)`](tpp-dict-04-even-odd-split-of-zeta.md) | Theorem | PROVED (Lean: closed forms at `p = 2` and `p = 4` in `Rh42/Budget.lean`; source also NUMERICAL) |
| [`Theorem 4.3 (exponential accuracy needs the functional equation)`](tpp-dict-04-exponential-accuracy-functional-equation.md) | Theorem | CITED (literature, Riemann's theta identity; source also NUMERICAL) |
| [`Theorem 3.4 (the linear divergence)`](tpp-dict-04-linear-divergence.md) | Theorem | PROVED (paper argument, Euler–Maclaurin; source also NUMERICAL) |
| [`Theorem 1.3 (the pole, halved)`](tpp-dict-04-pole-halved.md) | Theorem | PROVED (paper argument; source also NUMERICAL) |
| [`Theorem 4.1 (sharp error at a zero)`](tpp-dict-04-sharp-error-at-a-zero.md) | Theorem | PROVED (paper argument, Euler–Maclaurin; source also NUMERICAL) |
| [`Theorem 1.2 (the algebra)`](tpp-dict-04-sign-budget-algebra.md) | Theorem | PROVED (Lean: §1 closed forms in `Rh42/Budget.lean` at `p = 2, 4`; source also NUMERICAL) |
| [`Theorem 4.2 (the smoothing law — the round's main result)`](tpp-dict-04-smoothing-law.md) | Theorem | PROVED (asymptotic; source also NUMERICAL, 5–7 digits) |
| [`Theorem 3.5 (the term-level split fails)`](tpp-dict-04-term-level-split-fails.md) | Theorem | VERIFIED (numerical, exhaustive exact subset-sum) |
| [`Theorem 5.1 (Weil form — with the archimedean term)`](tpp-dict-04-weil-form-archimedean-term.md) | Theorem | CITED (literature, classical explicit formula; source also NUMERICAL, ≥20 digits) |
| [`Theorem 5.2 (counting)`](tpp-dict-04-zero-counting.md) | Theorem | CITED (literature; source labels it THEOREM + NUMERICAL) |
| [`Theorem 5.3 (zeros from the formula, not from the partial sum)`](tpp-dict-04-zeros-from-the-formula.md) | Theorem | VERIFIED (numerical; "auditor, independent route") |

## `tpp-dict-05`

<a id="tpp-dict-05"></a>

The programme's barriers and harvest: the bridges B1–B4 and their refutations, the corrected sign-blindness reading, and the summary of what the programme did and did not achieve.

Source: [`dictionary/05-programme-barriers-and-harvest.md`](../../research/twin-prime-parity/dictionary/05-programme-barriers-and-harvest.md) &nbsp;·&nbsp; **24** files.

| file | kind | status |
|---|---|---|
| [`B1 — the greedy support carries λ-parity signal (refuted)`](tpp-dict-05-b1-greedy-support-lambda-parity-refuted.md) | Claim | REFUTED (rh47; with witness) |
| [`B2 — the ζ budgets carry Ω-parity information (refuted)`](tpp-dict-05-b2-zeta-budgets-omega-parity-refuted.md) | Claim | REFUTED |
| [`B3 — the ζ-machinery applies to the correlation (refuted)`](tpp-dict-05-b3-zeta-machinery-correlation-refuted.md) | Claim | REFUTED |
| [`B4 — the support could be the positive-density witness (refuted)`](tpp-dict-05-b4-support-positive-density-witness-refuted.md) | Claim | REFUTED |
| [`B5 — an arithmetic alphabet escapes the barrier (refuted as a route)`](tpp-dict-05-b5-arithmetic-alphabet-route-refuted.md) | Claim | REFUTED (as a route; circular) |
| [`P8 — balance is attained for every N ≥ 2`](tpp-dict-05-balance-attained-every-n.md) | Theorem | PROVED (Lean) |
| [`P7 — the balance identity`](tpp-dict-05-balance-identity.md) | Theorem | PROVED (Lean) |
| [`P3 — Brown's criterion`](tpp-dict-05-brown-criterion.md) | Theorem | PROVED (one-step lemmas in Lean) |
| [`P2 — the budgets`](tpp-dict-05-budget-algebra.md) | Theorem | PROVED (Lean at `p=2,4`) |
| [`P4 — completeness thresholds`](tpp-dict-05-completeness-thresholds.md) | Theorem | PROVED (paper argument) |
| [`P17 — the correlation is not multiplicative (no Euler product)`](tpp-dict-05-correlation-not-multiplicative.md) | Theorem | PROVED (Lean; plus numerical component) |
| [`P14 — the counting function, exact and asymptotic`](tpp-dict-05-counting-function-exact-and-asymptotic.md) | Theorem | PROVED (paper argument; plus numerical component) |
| [`P13 — the explicit formula with the archimedean term`](tpp-dict-05-explicit-formula-archimedean-term.md) | Theorem | PROVED (paper argument; plus numerical verification ≥ 20 digits on four kernels) |
| [`P12 — exponential accuracy requires the functional equation`](tpp-dict-05-exponential-accuracy-functional-equation.md) | Theorem | PROVED (paper argument) |
| [`P1 — the factor-complexity law`](tpp-dict-05-factor-complexity-law.md) | Theorem | PROVED (Lean, 144 declarations) |
| [`P16 — finite-prefix indeterminacy`](tpp-dict-05-finite-prefix-indeterminacy.md) | Theorem | PROVED (Lean slice layer) |
| [`P19 — the one-point case Σ_{n≤x}λ(n) = o(x) is equivalent to PNT`](tpp-dict-05-one-point-case-equivalent-pnt.md) | Theorem | CITED (literature, classical; correction X1) |
| [`P5 — the signed support is parity-locked`](tpp-dict-05-parity-locked-signed-support.md) | Theorem | PROVED (Lean) |
| [`P9 — S₃ has no zero, S₂ vanishes at π/log 2`](tpp-dict-05-s3-nonvanishing-s2-zero.md) | Theorem | PROVED (Lean) |
| [`P10 — the sharp error at a zero`](tpp-dict-05-sharp-error-at-a-zero.md) | Theorem | PROVED (paper argument; plus numerical component) |
| [`P11 — smoothing does not remove √N`](tpp-dict-05-smoothing-cannot-remove-sqrt-n.md) | Theorem | PROVED (asymptotic; plus numerical component) |
| [`P18 — the greedy support is Sylvester-sparse`](tpp-dict-05-sylvester-sparse-support.md) | Theorem | PROVED (paper argument; plus numerical component) |
| [`P15 — the trivial two-point bounds, and o(x) fails for λ ≡ 1`](tpp-dict-05-trivial-two-point-bounds.md) | Theorem | PROVED (Lean) |
| [`P6 — the word factors through the height`](tpp-dict-05-word-factors-through-height.md) | Theorem | PROVED (paper argument) |

## `tpp-checks-06`

<a id="tpp-checks-06"></a>

The numerical-check register: each checked claim with its method, precision and explicit tail bound, together with the corrections the audits forced — including the `1244 → 1246` reconnaissance repair and the corrected sparse-modification bound.

Source: [`checks/06-numerical-checks.md`](../../research/twin-prime-parity/checks/06-numerical-checks.md) &nbsp;·&nbsp; **17** files.

| file | kind | status |
|---|---|---|
| [`B2 — the ζ-budgets are index-parity objects; the twist-invariance identity`](tpp-checks-06-b2-index-parity-invisibility.md) | Claim | VERIFIED (numerical — twist invariance exact: 0 mismatches on `10^6`; the supporting census is a finite table at `N=10^7`) |
| [`rh42 — the budget identities and the four threshold certificates`](tpp-checks-06-budget-identities-and-thresholds.md) | Claim | VERIFIED (numerical — budget identities to `1e-81`; each threshold certified by a sign change on an explicit rational bracket) |
| [`The budget sign-blindness package`](tpp-checks-06-budget-sign-blindness.md) | Claim | VERIFIED (numerical — identity residuals `≤ 1.32e-81`; twist invariance exact, 0 mismatches on `10^6`; separation of *index* parity only) |
| [`C3 / C5 — `S_2` vanishes exactly at `t = (2k+1)π/log 2` (two round claims refuted)`](tpp-checks-06-c3-c5-s2-exact-zeros.md) | Claim | REFUTED (the round's claims "`N=2` has no root" and "no exact complex vanishing for `N ≤ 6`", by the exact witness `S_2(π/log2) = 1 + e^{−iπ} = 0`) |
| [`C6 — the growth of `S_N` is linear, not `N^{1/2}``](tpp-checks-06-c6-linear-growth-lower-bound.md) | Claim | REFUTED (the round's claim "`N^{1/2}`-ish growth"), with a rigorous Euler-summation lower bound and certified exponents |
| [`The census identity — `#intervals = 2^{n_min−1}`, `measure = 2^{n_min−1} T_{n_min}``](tpp-checks-06-census-formula-intervals-and-measure.md) | Claim | PROVED (Lean, global form — `Rh42/Reachable.lean`, per the register; the register's own evidence for the recorded numbers is VERIFIED numerical, two independent routes to `3.89e-62`) |
| [`The corrected sparse-modification bound`](tpp-checks-06-corrected-sparse-bound.md) | Claim | PROVED (paper argument — the source gives the two-step inequality and the witness; not yet machine-checked) |
| [`rh42 — the exact reachable sets at `p=2` and `p=3``](tpp-checks-06-exact-reachable-sets-p-2-and-3.md) | Claim | CHECKED (exhaustive finite — exact enumeration of all `2^16` sub-sums at `p=2`; exact `Fraction` arithmetic) |
| [`SS4/SS5 — `n ↦ λ(n)λ(n+2)` is not multiplicative; no Euler product`](tpp-checks-06-not-multiplicative-no-euler-product.md) | Claim | PROVED (paper argument / finite algebraic fact; VERIFIED (numerical) with a rigorous tail bound — discrepancy exceeds the tail by a factor `109 178`) |
| [`The recon value `S(10^7) = 1244` is wrong; the correct value is `1246``](tpp-checks-06-recon-1244-corrected-to-1246.md) | Claim | CHECKED (exhaustive finite — three independent `λ` algorithms give `1246`; the `1244` differs by a final-block boundary slip) |
| [`rh45 — the corrected Weil explicit formula and the naive-normalisation refutation`](tpp-checks-06-rh45-explicit-formula-corrected-convention.md) | Claim | CITED (literature for the explicit formula itself: "The explicit formula is a known theorem"; VERIFIED (numerical) for the corrected convention, on four kernels to 44–63 digits; the naive normalisation is REFUTED) |
| [`SS4 — finite-prefix indeterminacy (the round's real logical result)`](tpp-checks-06-ss4-finite-prefix-indeterminacy.md) | Theorem *(so classified by the source: "the round's real logical result"; the register's companion ledger calls it the certified finite-prefix theorem)* | VERIFIED (numerical — exact construction, verified on 99 999 998 prefixes; the register states it is the round's real logical result, and the Lean slice layer is named elsewhere in the programme) |
| [`The Sylvester-sparsity theorem`](tpp-checks-06-sylvester-sparsity-theorem.md) | Theorem *(so labelled by the source: "The Sylvester-sparsity theorem (the round's one new exhaustive statement)")* | PROVED (paper argument — the source calls it "the rigidity lemma"; VERIFIED numerically, 0 violations in 53 159 consecutive pairs over 20 320 supports) |
| [`T1 — sharp cutoff: `\|S_N(1/2+it) − ζ(1/2+it)\|/√N → 1/√(1/4+t²) = 1/\|s−1\|``](tpp-checks-06-t1-sharp-cutoff-constant.md) | Claim | VERIFIED (numerical — finite-range, observed at `N=102400` with relative deviation ≈ `2.44e-6`; the exact leading law comes from the Abel/Euler–Maclaurin derivation, not from the fit) |
| [`T2 — the smoothing law: `S_N^φ − ζ = N^{1−s} J(φ) + φ(0)ζ(s) + R_N``](tpp-checks-06-t2-smoothing-law-master-formula.md) | Claim | VERIFIED (numerical — finite-range fit on `N = 1e2…1.024e5` for six weights; the round's claim (b) "the residual is `O(N^{−σ})` with a weight-dependent constant" is the one marked VERIFIED in the log) |
| [`T3 — corrected θ / functional-equation identity for `ζ``](tpp-checks-06-t3-corrected-theta-identity.md) | Claim | VERIFIED (numerical — reproduces `ζ` at the tested points to `3.4e-48`…`5.68e-69`; the corrected identity replaces the brief's algebraically wrong formula) |
| [`The withdrawn `x^{1/2+ε}` reading and the `N ≳ T²` cost claim`](tpp-checks-06-withdrawn-x-half-reading-and-nt2-refuted.md) | Claim | REFUTED (the `N ≳ T² = 200` resolution cost, by four-point non-detection with growing values; the `x^{1/2+ε}` reading is **WITHDRAWN** as unverified) |

## `tpp-open-07`

<a id="tpp-open-07"></a>

The open-problems register. OP-2 (one-point Chowla is equivalent to PNT, hence settled) and OP-3 (the barrier downgraded to a sign-blind alphabet with no arithmetic input).

Source: [`open/07-open-problems.md`](../../research/twin-prime-parity/open/07-open-problems.md) &nbsp;·&nbsp; **2** files.

| file | kind | status |
|---|---|---|
| [`OP-3 — the barrier downgraded: "sign-blind alphabet, no arithmetic input", and the two do not mix`](tpp-open-07-barrier-downgraded-to-heuristic.md) | Claim | CONJECTURED (heuristic — the source states it as a HEURISTIC and as **OPEN**; the register's earlier, over-wide form is withdrawn) |
| [`OP-2 — one-point Chowla is equivalent to the prime number theorem (SETTLED, not open)`](tpp-open-07-op2-one-point-chowla-iff-pnt.md) | Theorem | CITED (literature — Tao, arXiv:1605.04628 §1; the transfer identity `λ = 1_□ * μ` is classical, Landau) |

## `tpp-readme-x1`

<a id="tpp-readme-x1"></a>

Correction X1 from the programme's top-level README: one-point Chowla `Σ_{n≤x}λ(n) = o(x)` is equivalent to the prime number theorem, hence a theorem and not open.

Source: [`README.md`](../../research/twin-prime-parity/README.md) &nbsp;·&nbsp; **1** files.

| file | kind | status |
|---|---|---|
| [`X1 — one-point Chowla `Σ_{n≤x}λ(n) = o(x)` is equivalent to PNT`](tpp-readme-x1-one-point-chowla-iff-pnt.md) | Theorem | CITED (literature; `λ = 1_squares ∗ μ`, cited Tao [arXiv:1605.04628](https://arxiv.org/abs/1605.04628)) |

## `tpp-readme-x2`

<a id="tpp-readme-x2"></a>

Correction X2: the sparse-modification bound, corrected from the false `2·#{n ≤ x+2 : n ∈ A}` to `2·#{n ≤ x : n ∈ A or n+2 ∈ A} ≤ 4·#{m ≤ x+2 : m ∈ A}`, with the witness `A = {5}`.

Source: [`README.md`](../../research/twin-prime-parity/README.md) &nbsp;·&nbsp; **1** files.

| file | kind | status |
|---|---|---|
| [`X2 — the sparse-modification bound corrected to `2·#{n ≤ x : n ∈ A or n+2 ∈ A} ≤ 4·#{m ≤ x+2 : m ∈ A}``](tpp-readme-x2-sparse-bound-corrected.md) | Claim | REFUTED (witness `A = {5}`, `x = 5`: `\\|ΔS\\| = 4 > 2`); corrected bound stated |

## `tpp-readme-x6`

<a id="tpp-readme-x6"></a>

Correction X6: the claimed `k`-point Chowla consequence for twin primes is withdrawn and replaced by an explicit statement of what is actually implied.

Source: [`README.md`](../../research/twin-prime-parity/README.md) &nbsp;·&nbsp; **1** files.

| file | kind | status |
|---|---|---|
| [`X6 — the `k`-point Chowla consequence for twin primes: withdrawn, replaced by `k=1 ⟺ PNT` and `Chowla ⇒ Sarnak``](tpp-readme-x6-chowla-implication-withdrawn.md) | Claim | CITED (literature: `Chowla ⇒ Sarnak`); the round's stronger form is withdrawn as UNVERIFIED |

## `tpp-rh40-ledger`

<a id="tpp-rh40-ledger"></a>

The rh40 ledger of proved laws for the greedy word: the finite-word Cassaigne repair `p(L+1) − p(L) = RS(L) − Z(L)`, the large-`L` law, the decay law, and the plateau theorem `max p = a_m + 2`.

Source: [`rounds/rh40/rounds/ledger.md`](../../research/twin-prime-parity/rounds/rh40/rounds/ledger.md) &nbsp;·&nbsp; **6** files.

| file | kind | status |
|---|---|---|
| [`p(L+1) − p(L) = RS(L) − Z(L), the finite-word Cassaigne repair`](tpp-rh40-ledger-attributed-cassaigne-repair.md) | Claim | VERIFIED (numerical; mediator-reproduced by an independent bit-string route — **all** `L` on the `N = 500` word and ≈405 sampled `L` on each of the other four, 0 failures) |
| [`The decay law as a corollary (C2b)`](tpp-rh40-ledger-attributed-decay-law-corollary.md) | Corollary | PROVED (paper argument; corollary of the large-`L` law) |
| [`The large-L law p(L) = min(a_m+1, N−L+1) + [L ≤ N−a_m−1]`](tpp-rh40-ledger-attributed-large-l-law.md) | Theorem | PROVED (paper argument) |
| [`max p = a_m + 2 on the plateau, proved`](tpp-rh40-ledger-attributed-plateau-value-proved.md) | Theorem | PROVED (paper argument) |
| [`The residual-orbit precision law steps ≈ 2 + log₂(dps)`](tpp-rh40-ledger-attributed-residual-orbit-precision-law.md) | Claim | VERIFIED (numerical; refutes the handoff's protocol) |
| [`Z(L) = 1 ⟺ L ∈ [N−a_m−1, N−1]`](tpp-rh40-ledger-attributed-z-one-range.md) | Claim | VERIFIED (numerical; Agent B for the value, mediator for the exact range) |

## `tpp-rh40-k1`

<a id="tpp-rh40-k1"></a>

The rh40 plateau theorem in full: the multiplicity-one window lemma, the count of windows containing `a_m`, and Theorems A and B that establish the plateau value.

Source: [`rounds/rh40/K1_plateau_theorem.md`](../../research/twin-prime-parity/rounds/rh40/K1_plateau_theorem.md) &nbsp;·&nbsp; **4** files.

| file | kind | status |
|---|---|---|
| [`Lemma 1 (a window has multiplicity one, and is recognised by its last offset)`](tpp-rh40-k1-lemma-1-window-multiplicity-one.md) | Lemma | PROVED (paper argument; not formalised in Lean) |
| [`Lemma 2 (how many windows contain `a_m`, and whether they are non-zero)`](tpp-rh40-k1-lemma-2-windows-containing-a-m.md) | Lemma | PROVED (paper argument; not formalised in Lean) |
| [`Theorem A (the large-`L` regime)`](tpp-rh40-k1-theorem-a-large-l-regime.md) | Theorem | PROVED (paper argument; exhaustively machine-corroborated, 242 295 cases, 0 counterexamples; not formalised in Lean) |
| [`Theorem B (the plateau, = C2a)`](tpp-rh40-k1-theorem-b-plateau.md) | Theorem | PROVED (paper argument; exhaustively machine-corroborated; not formalised in Lean) |

## `tpp-rh40-k`

<a id="tpp-rh40-k"></a>

The remaining rh40 questions on the greedy map: the `u`-map and its invariant density, the achieved limit set, termination thresholds for power alphabets, and the bounded-gaps/termination dichotomy.

Source: [`rounds/rh40/K_remaining.md`](../../research/twin-prime-parity/rounds/rh40/K_remaining.md) &nbsp;·&nbsp; **12** files.

| file | kind | status |
|---|---|---|
| [`Conjecture: a family of x for which the limit does not exist`](tpp-rh40-k-remaining-conjecture-family-without-limit.md) | Claim | **PROVED (2026-10-11 attack; constructive, OP-28).** There exist `x ∈ (0,1)` and a greedy orbit with `limsup_K (1/K)Σ_{k<K} log c_k ≥ −0.76` and `liminf_K ≤ −1.21`; the running mean has **no limit**. Construction: prescribe `α_k` alternating `1/2,1/4` in blocks `M_j = 3^j` (`α_k = (q_k²+2q_k)/q_{k+1}`), build `q_k` backwards via `u_k = n_k u_{k+1}/(n_k+u_{k+1})`, take `x = Σ_k 1/(q_k+2)`. Exact-rational witness `x = 300129656263973531720568953662090234/48845289055200132283765298144075427525`; error budget `Ση_k ≤ 1.6·10⁻³` versus block-mean gap `0.35–0.52`. `lib/tpp_no_limit_orbit.py` (self-test 5/5) and `research/attacks/OP-28-30-33.md`. |
| [`L¹ convergence of the orbit average to −1 for uniform `x``](tpp-rh40-k-remaining-conjecture-l1-convergence-uniform-x.md) | Theorem | PROVED (source's label; no proof text given — reduction stated) |
| [`Conjecture: the limit −1 for Lebesgue-a.e. x`](tpp-rh40-k-remaining-conjecture-lebesgue-a-e-limit.md) | Claim | CONJECTURED |
| [`The exponential alphabet gives bounded gaps and termination (the dichotomy is false)`](tpp-rh40-k-remaining-exponential-alphabet-dichotomy.md) | Theorem | VERIFIED (exact rational arithmetic) |
| [`The inverse problem has no halting alphabet with linear complexity`](tpp-rh40-k-remaining-inverse-problem-negative.md) | Theorem | PROVED (paper argument, as a consequence of K1's Theorem A) |
| [`The corrected structure theorem (power family)`](tpp-rh40-k-remaining-structure-theorem.md) | Theorem | PROVED (paper argument) |
| [`Termination criterion for a greedy alphabet (and the ζ(p) threshold)`](tpp-rh40-k-remaining-termination-criterion.md) | Theorem | PROVED (paper argument; verified in exact rationals) |
| [`Theorem D — the C1 regime boundary (PROVED)`](tpp-rh40-k-remaining-theorem-d-c1-regime.md) | Theorem | PROVED (paper argument; exhaustively verified, 399 486 cases, 0 counterexamples) |
| [`Theorem E — determinacy of the plateau onset`](tpp-rh40-k-remaining-theorem-e-onset-determinacy.md) | Theorem | PROVED (negative half by exhaustive counterexample, positive half by construction/tautology) |
| [`Theorem F — the lower bound on `A(N)``](tpp-rh40-k-remaining-theorem-f-an-lower-bound.md) | Theorem | PROVED (paper argument, one-sided; the upper bound is open) |
| [`Theorem G — the upper bound is open`](tpp-rh40-k-remaining-theorem-g-upper-bound-open.md) | Theorem | PROVED (paper; components Lean) — corrected 2026-10-11 (OP-13): the no-two-sided-law obstruction kills the *lower* bound |
| [`The residual-orbit limit depends on x (the handoff's universal limit is refuted)`](tpp-rh40-k-remaining-theorem-limit-depends-on-x.md) | Theorem | REFUTED (the handoff's claim "a limit independent of `x`" — by an explicit `x`) |

## `tpp-rh40-readme`

<a id="tpp-rh40-readme"></a>

The rh40 round summary: the corrections M1–M5 to the inherited closed forms, the five-piece structure with non-monotone slope, and the saturation plateau.

Source: [`rounds/rh40/README.md`](../../research/twin-prime-parity/rounds/rh40/README.md) &nbsp;·&nbsp; **11** files.

| file | kind | status |
|---|---|---|
| [`M1 — HANDOFF.md §3.1's closed forms are false`](tpp-rh40-readme-m1-piecewise-closed-forms-refuted.md) | Claim | REFUTED (exact enumeration; the §3.1 piecewise law is false from L = 15 onward) |
| [`M2/M3 — the true structure is five-piece with a non-monotone slope`](tpp-rh40-readme-m2-m3-five-piece-slope-structure.md) | Claim | VERIFIED (numerical; exact enumeration at N = 1400) |
| [`M3 — the saturation plateau and the decay boundary`](tpp-rh40-readme-m3-plateau-and-decay-boundary.md) | Claim | VERIFIED (numerical; all four dialogue words, exact enumeration) |
| [`M5 — Cassaigne's identity fails exactly in the decay regime`](tpp-rh40-readme-m5-cassaigne-identity-fails-decay.md) | Claim | REFUTED (numerical; the identity holds for every L ≤ 604 and fails for all 608 values L ∈ [792, 1399] at N = 1400; the mediator's naive finite-word fix fails too, 0 of 608) |
| [`M5 — the corrected finite-word first-difference identity p(L+1) − p(L) = RS(L) − Z(L)`](tpp-rh40-readme-m5-corrected-first-difference-identity.md) | Claim | VERIFIED (numerical; all four dialogue words for every L, 5 666 values, 0 failures; independently recomputed against a bit-string implementation) |
| [`M6 — C1 as stated in §4 is false, and the real boundary is not the min gap`](tpp-rh40-readme-m6-c1-regime-boundary-refuted.md) | Claim | REFUTED (numerical; C1 fails on the first L greater than the smallest gap, for all four dialogue words; the correct boundary is left OPEN) |
| [`M8 — two counterexamples printed in HANDOFF.md §5 do not reproduce`](tpp-rh40-readme-m8-handoff-witnesses-fail-to-reproduce.md) | Claim | REFUTED (numerical; the two recorded witnesses are wrong, though the laws they were meant to refute are genuinely false) |
| [`M9 — the single-one word is completely solved`](tpp-rh40-readme-m9-single-one-word-solved.md) | Claim | VERIFIED (numerical; first half exact on all a < 60, N < 120; combined law has zero counterexamples for 1 ≤ a < 40, N ≥ 2a + 4) |
| [`Plateau value = a_m + 2`](tpp-rh40-readme-plateau-value-am-plus-2.md) | Claim | VERIFIED (numerical; 255/255 N = 20 words and 744/744 random supports, zero counterexamples; the proof is recorded separately in K1_plateau_theorem.md) |
| [`Refuted: Agent A's round-1 boundary rule L_max = 1 + min(min_j d_j, min_j(d_j + d_{j+1}))`](tpp-rh40-readme-refuted-agent-a-boundary-rule.md) | Claim | REFUTED (numerical; on 17 375 random words satisfying N ≥ 2a_m + 3 it fails inside its own claimed range in 4 903 cases and is too early in 449; the correct boundary is OPEN) |
| [`Refuted: the unified candidate p(L) = min(L + 1 + #{d_i < L}, N − L + 1)`](tpp-rh40-readme-refuted-unified-min-candidate.md) | Claim | REFUTED (numerical; fails in the saturation-onset regime, 16 vs 18 at L = 14 for 1/π) |

## `tpp-rh40-round01`

<a id="tpp-rh40-round01"></a>

The first rh40 dialogue between two agents — `round01.md` plus the two agent logs `round01_agentA.md` and `round01_agentB.md` — harvested claim by claim: the C1 boundary, the slope switch, the decay laws, and each agent's counterexamples and retractions.

Source: [`rounds/rh40/rounds/round01.md`](../../research/twin-prime-parity/rounds/rh40/rounds/round01.md) &nbsp;·&nbsp; **48** files.

| file | kind | status |
|---|---|---|
| [`A1 — C1 boundary L_max = 1 + min(min_j d_j, min_j(d_j+d_{j+1}))`](tpp-rh40-round01-a1-agent-a-c1-boundary-disproven.md) | Claim | REFUTED (on 6 000–17 375 sampled eligible words the rule fails *inside* its own claimed range and is too early elsewhere) |
| [`A2 — A's own counterexample {13,244}, N=253`](tpp-rh40-round01-a2-counterexample-13-244-retracted.md) | Claim | REFUTED (witness retracted; the conclusion is right but the example is degenerate and its numbers are internally inconsistent) |
| [`A3 — slope 1→2 switch at L = d_1 + 2 = 13 for 1/π`](tpp-rh40-round01-a3-slope-switch-at-d1-plus-2.md) | Claim | VERIFIED (numerical, confirmed; `slopes` gives the transition at L = 13) |
| [`A4 — decay p(L) = N − L + 1 for L ≥ N − a_m`](tpp-rh40-round01-a4-decay-not-tight-at-bottom.md) | Claim | VERIFIED (numerical; true but not tight at the bottom) |
| [`A5 — plateau = a_m + 2`](tpp-rh40-round01-a5-plateau-value-standing.md) | Claim | VERIFIED (numerical, standing; independently predicted by B and confirmed by the mediator) |
| [`A6 — three new-word predictions {0,3,17}→19, {2,9,44}→46, {1,6,31,200}→202 at L = span+1`](tpp-rh40-round01-a6-three-new-word-predictions.md) | Claim | VERIFIED (numerical; all three exact) |
| [`A7 — window-class decomposition T(i,j) with union cardinality`](tpp-rh40-round01-a7-window-class-decomposition-unsubstantiated.md) | Claim | **REFUTED as stated / repaired (2026-10-11 attack; OP-34).** The class sum over-counts `p(L)` on **604/1399** `L` for `x = 1/π` (the classes are not disjoint); the corrected collision criterion `factor(t)=factor(t') ⟺ x(t)=x(t') ∧ shape(t)=shape(t')` and the exact shape-union formula `p(L) = [∃all-zero] + Σ_shapes |⋃_{C: shape} X(C)|` are **PROVED** (6 378 064 exhaustive cases, 0 mismatches). See `research/attacks/OP-34-36-37-35.md`. |
| [`A8 — deficit form D(L) = max_j (L − d_j − 1 − S_{1,j−2})_+ explains the 2→1`](tpp-rh40-round01-a8-deficit-form-unsubstantiated.md) | Claim | **REFUTED / ill-posed (2026-10-11 attack; OP-35).** `S_{1,k}` is undefined corpus-wide; under the natural reading `S_{1,k} = Σ_{i≤k} d_i`, `D(L) = (L−12)_+` switches on at `L = 13` while the measured `2→1` slope drop is at `L = 14` (`p(13)=16, p(14)=18, p(15)=19`); no partial-sum convention repairs it, and the natural `D` is unbounded whereas a cancelled-pair deficit must be bounded. See `research/attacks/OP-34-36-37-35.md`. |
| [`(a) Boundary: p(L) = L+1+#{d_i<L} holds for L ≤ L_max with L_max = min(1+min_j d_j, 1+min_j(d_j+d_{j+1}))`](tpp-rh40-round01-agenta-boundary-rule-l-max.md) | Claim | REFUTED (in general; the source's own tag is `[DREAM]`, exact only "on all four dialogue words plus 5 new ones") |
| [`Cassaigne's first-difference theorem`](tpp-rh40-round01-agenta-cassaigne-first-difference-theorem.md) | Theorem | CITED (literature) |
| [`(c) Decay law p(L) = N−L+1 for L ≥ N−a_m, and the plateau value a_m+2`](tpp-rh40-round01-agenta-decay-law-and-plateau-value.md) | Claim | VERIFIED (numerical; 607 values L = 792..1399, 0 violations, for {2,13,607}, N = 1400) |
| [`Morse–Hedlund: a non-eventually-periodic word has p(L) ≥ L+1`](tpp-rh40-round01-agenta-morse-hedlund-bound.md) | Theorem | CITED (literature) |
| [`Predictions (new words) for the plateau value at L = span+1`](tpp-rh40-round01-agenta-plateau-predictions-new-words.md) | Claim | VERIFIED (numerical; confirmed exactly in the source's session) |
| [`(b) Slope structure for 1/π, N = 1400`](tpp-rh40-round01-agenta-slope-structure-1-over-pi.md) | Claim | VERIFIED (numerical; exact slopes output at N = 1400) |
| [`[DREAM] the window-class sum for p(L)`](tpp-rh40-round01-agenta-window-class-sum-conjecture.md) | Claim | **REFUTED as stated (2026-10-11 attack; OP-36).** The `[DREAM]` sum `p(L) = 1 + #{}(L>span) + Σ_{i≤j}|T(i,j)|` over-counts on **all 1399** `L` for `x = 1/π` (`T(i,j)` counts last-index `≤ j`, so each window is counted `m−J+1` times; the `(i,j)`-class-sizes variant over-counts on 604/1399); replaced by the corrected shape-union formula in the OP-34 entry. See `research/attacks/OP-34-36-37-35.md`. |
| [`Cassaigne's first-difference method for an extendable language`](tpp-rh40-round01-agentb-cassaigne-extendable-language.md) | Theorem | CITED (literature; Cassaigne, *Complexity and special factors*, Bull. SMF 125 (1997) 1–26, Zbl 0921.68065) |
| [`digitword.py is computationally clean (audit of the ground-truth layer)`](tpp-rh40-round01-agentb-digitword-audit-clean.md) | Claim | CHECKED (exhaustive finite; p_offset == p_bruteforce on 43 342 cases, right_special_factors == an independent bit-string enumeration on 22 088 cases; two documentation defects) |
| [`Misattribution flag: the "e−2" word (10,20,40,80), N=500 is not e−2`](tpp-rh40-round01-agentb-e-minus-2-mislabel.md) | Claim | VERIFIED (numerical; the true greedy word for e−2 at N = 2000 is (0,3,53)) |
| [`The exact finite first-difference identity p(L+1) − p(L) = RS(L) − Z(L)`](tpp-rh40-round01-agentb-exact-first-difference-identity.md) | Claim | VERIFIED (numerical; 18895/18895 over five words, 0 failures; the naive forms hold 0/18895 and 5/18895) |
| [`The (i,x) repair: exactly which window starts realise (i, x) as the first 1 of the factor`](tpp-rh40-round01-agentb-i-x-repair-realisable-window-starts.md) | Proposition | **SETTLED with corrections (2026-10-11 attack; components Lean; OP-37).** (a) realisability **PROVED**: realised `(i,x)` = `max(0,a_i−(N−L)) ≤ x ≤ min(d_{i−1}−1,a_i,L−1)`; (b) the source's all-zero criterion `L ≤ N−a_m−1` is **REFUTED** by `((0,4),N=6,L=3)`, corrected form `L ≤ max(a_0, max_j(d_j−1), N−1−a_m)` **PROVED** (source wrong on 24 337/95 826 cases); (c) the source's injectivity claim is **REFUTED** by `((12,20),N=26,L=12)`, corrected form `p(L) ≥ a_m+2 ⟹ injective` **PROVED with no `N`-hypothesis**, machine-checked as `Rh40.injOn_of_card_ge` (`rounds/rh40/lean/Rh40/Plateau.lean`, 2/2 green). The plateau *value* `max p = a_m+2` stays unproved. See `research/attacks/OP-34-36-37-35.md`. |
| [`The plateau/decay boundary is L = N−a_m−1, not N/2 (and the two off-by-one corrections)`](tpp-rh40-round01-agentb-plateau-decay-boundary.md) | Claim | VERIFIED (numerical; exact ranges for 1/pi, N = 1400) |
| [`The plateau value is not determined by (m, span, N), nor by gaps or (gaps, N)`](tpp-rh40-round01-agentb-plateau-not-determined-by-m-span-n.md) | Claim | VERIFIED (numerical; 45/55 keys multi-valued, with explicit counterexamples) |
| [`On the plateau p(L) = a_m+2, and max p = a_m+2 for every support with N ≥ 2a_m+3`](tpp-rh40-round01-agentb-plateau-value-am-plus-2.md) | Claim | VERIFIED (numerical; 255/255 N = 20 words and 744/744 random supports, zero counterexamples; the source records that the a_m+2 form still lacks a proof) |
| [`B1 — p(L+1) − p(L) = RS(L) − Z(L) exactly, all L`](tpp-rh40-round01-b1-corrected-first-difference-identity.md) | Claim | VERIFIED (numerical, mediator-reproduced for all L on 5 words by an independent bit-string route) |
| [`B10 — the word (10,20,40,80), N=500 is not e−2`](tpp-rh40-round01-b10-geometric-word-not-e-minus-2.md) | Claim | VERIFIED (numerical, confirmed; true e−2 support `(0, 3, 53)` at N=2000, stable over dps 60/120/200) |
| [`B11 — Cassaigne gives p(L+1)−p(L) = Σ(d⁺(f)−1) only for an extendable language`](tpp-rh40-round01-b11-cassaigne-extendable-language.md) | Theorem | CITED (literature; the mediator's `[KNOWN]` check agrees) |
| [`B13 — "the naive RS(L) − LS(L+1) holds 0/18895 cases"`](tpp-rh40-round01-b13-naive-formula-count-unsubstantiated.md) | Claim | OPEN (UNSUBSTANTIATED / imprecise — B's count is not reproducible; the substance of B4 survives, the count does not) |
| [`B2 — Z(L) ∈ {0,1} always`](tpp-rh40-round01-b2-z-in-0-1.md) | Claim | VERIFIED (numerical; no violation on any word tested) |
| [`B3 — #{L : Z(L) = 1} = a_m + 1, i.e. Z = 1 on exactly L ∈ [N−a_m−1, N−1]`](tpp-rh40-round01-b3-z-one-range-and-count.md) | Claim | VERIFIED (numerical; holds on every word tested) |
| [`B4 — the naive RS(L) − LS(L+1) is not the identity`](tpp-rh40-round01-b4-naive-left-special-not-identity.md) | Claim | VERIFIED (numerical, mediator-reproduced; false only in the decay regime) |
| [`B5 — plateau value = a_m + 2`](tpp-rh40-round01-b5-plateau-value-a-m-plus-2.md) | Claim | VERIFIED (numerical, value standing; proof OPEN in this round) |
| [`B6 — the plateau for 1/π, N = 1400 is exactly L ∈ [605, 792] (188 values)`](tpp-rh40-round01-b6-plateau-range-one-over-pi.md) | Claim | VERIFIED (numerical, confirmed) |
| [`B7 — p(L) = N − L + 1 on exactly L ∈ [792, 1399] for 1/π`](tpp-rh40-round01-b7-decay-range-one-over-pi.md) | Claim | VERIFIED (numerical, confirmed) |
| [`B8 — plateau value not a function of (m, span, N)`](tpp-rh40-round01-b8-plateau-not-function-of-m-span-n.md) | Claim | VERIFIED (numerical, confirmed; witness `(0,)→2` vs `(11,)→10` at m=1, span=0, N=20) |
| [`M1 — HANDOFF.md §3.1's closed forms are false`](tpp-rh40-round01-brief-m1-piecewise-closed-forms-false.md) | Claim | REFUTED (numerical; `p(L) = 2L − 10` is false from L = 15 onward) |
| [`M2 — the true slope structure for x = 1/π, N = 1400 is five-piece`](tpp-rh40-round01-brief-m2-five-piece-slope-structure.md) | Claim | VERIFIED (numerical; exact enumeration, with two later-corrected boundary details) |
| [`M3 — the saturation plateau boundary is exactly L = N − a_m`](tpp-rh40-round01-brief-m3-plateau-boundary-n-minus-a-m.md) | Claim | REFUTED (numerical; off by one — the boundary is L = N − a_m − 1, as Agent B's round-1 audit records) |
| [`M4 — the offset-tuple count and the bit-string factor count agree everywhere compared`](tpp-rh40-round01-brief-m4-offset-tuple-equals-bit-string-count.md) | Claim | CHECKED (exhaustive finite; agreement on the listed L, including deep in the decay regime) |
| [`M5 — Cassaigne's identity fails in the decay regime, and only there`](tpp-rh40-round01-brief-m5-cassaigne-fails-decay-regime.md) | Claim | REFUTED (numerical; the identity fails for all 608 values L ∈ [792, 1399] and the naive left-special correction fails there too, 0 of 608; the mediator's loss hypothesis is stated as NOT verified) |
| [`M6 — C1 as stated in HANDOFF.md §4 is false`](tpp-rh40-round01-brief-m6-c1-regime-false.md) | Claim | REFUTED (numerical; fails on the first L strictly greater than the smallest gap, for all four dialogue words; the correct boundary rule is stated as OPEN) |
| [`The exact formulation of the C1 boundary`](tpp-rh40-round01-exact-c1-formulation.md) | Claim | VERIFIED (derivation + spot checks; stated as the round's exact formulation) |
| [`M1 — HANDOFF.md §3.1's closed forms are false`](tpp-rh40-round01-m1-handoff-closed-forms-false.md) | Claim | VERIFIED (numerical; confirmed by both agents and by probe 6) |
| [`M2 — slope sequence 1→2→1→0→−1, no slope-3 range`](tpp-rh40-round01-m2-slope-sequence.md) | Claim | VERIFIED (numerical; `slopes()` and B's hand computation agree) |
| [`M3 (mediator error) — plateau is L ∈ [605, 791]; decay begins at N − a_m`](tpp-rh40-round01-m3-plateau-range-mediator-error.md) | Claim | REFUTED (truth: plateau `[605, 792]`; the decay law holds from `L = N − a_m − 1 = 792`; caught by Agent B) |
| [`M4 — offset-tuple count = bit-string count everywhere`](tpp-rh40-round01-m4-offset-tuple-equals-bit-string.md) | Claim | VERIFIED (numerical; confirmed to L = 1399 by both routes) |
| [`M5 (mediator error) — the finite-word fix is RS(L) − LS(L+1)`](tpp-rh40-round01-m5-left-special-fix-mediator-error.md) | Claim | REFUTED (fails in the decay regime; the correct correction is `Z(L)`, which is not a left-special count) |
| [`M5h — the loss is "the windows dropping off the right edge" (standing in substance)`](tpp-rh40-round01-m5h-terminal-window-substance.md) | Claim | VERIFIED (numerical, standing in substance) |
| [`M6 — C1 as stated in §4 is false; regime ends below the next gap`](tpp-rh40-round01-m6-c1-statement-false.md) | Claim | VERIFIED (numerical; probe 3 and both agents) |

## `tpp-rh40-rounds`

<a id="tpp-rh40-rounds"></a>

The consolidated rh40 truth table — the largest single source here: the `A`-series bounds, the Cassaigne identity and the regime where it fails, the `K`-series structure theorems, and the refuted candidates.

Source: [`rounds/rh40/rounds/truths.md`](../../research/twin-prime-parity/rounds/rh40/rounds/truths.md) &nbsp;·&nbsp; **94** files.

| file | kind | status |
|---|---|---|
| [`A2 — p(L) is finite for every L`](tpp-rh40-rounds-truths-a2-p-l-finite-every-length.md) | Claim | VERIFIED (elementary) |
| [`A3 — for irrational x the process never terminates and n_{k+1} = ⌈1/r_k⌉ − 2`](tpp-rh40-rounds-truths-a3-irrational-index-law.md) | Claim | CITED (INHERITED — HANDOFF §2, verified there to index 128 541 453; not recomputed this session) |
| [`A4 — the lower bound A(N) ≥ log₂ log N − log₂ log(1/x) − 1`](tpp-rh40-rounds-truths-a4-lower-bound-log-log-n.md) | Claim | PROVED (paper argument; Theorem F: `r_{k+1} ≤ r_k²`) |
| [`A4b — the matching upper bound A(N) ≤ log₂ log N + O(1)`](tpp-rh40-rounds-truths-a4b-upper-bound-open.md) | Claim | PROVED (paper; components Lean) — corrected 2026-10-11 (OP-13) |
| [`A4c — ⌊log₂ log₂ n_k⌋ = k + O(1), i.e. A(N) = log₂ log N + O(1) empirically tight`](tpp-rh40-rounds-truths-a4c-a-n-empirically-tight.md) | Claim | VERIFIED (numerical) |
| [`A5 — for rational x the process always terminates`](tpp-rh40-rounds-truths-a5-rational-termination.md) | Claim | VERIFIED (numerical) |
| [`B2 — p_offset == p_bruteforce for every word of length 12 with 0–4 ones and every L`](tpp-rh40-rounds-truths-b2-offset-tuple-equals-bit-string.md) | Claim | CHECKED (exhaustive finite: 9 528 exhaustive cases, 0 divergences) |
| [`B3 — the offset-tuple equivalence holds deep in the right-edge decay regime`](tpp-rh40-rounds-truths-b3-offset-tuple-deep-decay-regime.md) | Claim | CHECKED (exhaustive finite: 608 cases, 0 divergences) |
| [`B4 — factor_set and p_offset raise on L > N instead of silently returning an empty set`](tpp-rh40-rounds-truths-b4-factor-set-raises-beyond-n.md) | Claim | VERIFIED (code behaviour; defect found by Agent B, fixed) |
| [`C1 — p(L) = L + 1 for 1 ≤ L ≤ min gap`](tpp-rh40-rounds-truths-c1-p-l-l-plus-1-min-gap.md) | Claim | VERIFIED (numerical, `probes.py` probe 3: 2 000/2 000 random trials) |
| [`C2 — p(L+1) − p(L) = RS(L) holds for every L ≤ N − a_m − 2`](tpp-rh40-rounds-truths-c2-first-difference-right-special.md) | Claim | VERIFIED (numerical; `verify_agentB.py` B-a, `probes.py` probe 4) |
| [`C3 — Z(L) counts the length-L factors with no right extension inside w`](tpp-rh40-rounds-truths-c3-z-l-no-right-extension.md) | Claim | VERIFIED (numerical; `verify_agentB.py` B-a) |
| [`C4 — the corrected finite-word identity p(L+1) − p(L) = RS(L) − Z(L)`](tpp-rh40-rounds-truths-c4-corrected-finite-word-identity.md) | Claim | VERIFIED (numerical; 0 failures across all L on `(10,20,40,80)` N=500 (499/499) and 400+ sampled L on each of four other words) |
| [`C5 — Z(L) ∈ {0,1} always`](tpp-rh40-rounds-truths-c5-z-l-in-0-1.md) | Claim | VERIFIED (numerical; same run as C4, 0 violations) |
| [`C6 — Z(L) = 1 iff L ∈ [N − a_m − 1, N − 1], equivalently #{L : Z(L)=1} = a_m + 1`](tpp-rh40-rounds-truths-c6-z-l-one-exact-range.md) | Claim | VERIFIED (numerical; exact profile on 1/π, exact count on `(10,20,40,80)`) |
| [`C7 — LS(L) = 0 for all L: the standard left-special count is identically zero`](tpp-rh40-rounds-truths-c7-left-special-count-zero.md) | Claim | VERIFIED (numerical; `verify_agentB.py` B-a, independent bit-string `bLS`) |
| [`C8 — the word is finitely supported, hence non-recurrent, hence not Sturmian`](tpp-rh40-rounds-truths-c8-non-recurrent-not-sturmian.md) | Claim | VERIFIED (elementary) |
| [`C9 — the offset-tuple encoding is lossy in principle but never diverges on any case tested`](tpp-rh40-rounds-truths-c9-offset-encoding-lossy-in-principle.md) | Claim | VERIFIED (numerical; via register row B3) |
| [`D1 — window count: p(L) ≤ N − L + 1, and p(N) = 1, p(N−1) = 2`](tpp-rh40-rounds-truths-d1-window-count-bound.md) | Claim | VERIFIED (elementary; `probes.py` probe 1) |
| [`D2 — the D1 bound is never binding until L ≥ N − a_m − 1`](tpp-rh40-rounds-truths-d2-bound-not-binding-before-decay.md) | Claim | VERIFIED (numerical; from E5 and E6) |
| [`D3 — the ceiling regime: for L ≥ N − a_m − 1 every window meets the support and exactly one factor is lost per unit increase of L`](tpp-rh40-rounds-truths-d3-ceiling-regime.md) | Claim | PROVED (paper argument; K1 Theorem A (Corollary)) |
| [`D4 — terminal-window lemma`](tpp-rh40-rounds-truths-d4-terminal-window-lemma.md) | Claim | VERIFIED (numerical; `verify_agentB.py` B-a) |
| [`D5 — crossover: (a_m + 2) − (N − L + 1) &gt; 0 iff L &gt; N − a_m − 1`](tpp-rh40-rounds-truths-d5-crossover.md) | Claim | PROVED (paper argument; K1 Theorem A) |
| [`D6 — squaring law: r_{k+1} = (1−f)r_k²/(1+(1−f)r_k) with f = {1/r_k}`](tpp-rh40-rounds-truths-d6-squaring-law.md) | Claim | VERIFIED (numerical, to `\|dev\| < 1e-45` at dps 60 over 60 steps, six irrational targets) |
| [`D7 — rational termination: every rational x terminates; θ = π gives the support {0,1,4}`](tpp-rh40-rounds-truths-d7-rational-termination-theta-pi.md) | Claim | VERIFIED (exact `Fraction` arithmetic; H-section census) |
| [`E1 — plateau value max_L p(L) = a_m + 2`](tpp-rh40-rounds-truths-e1-plateau-value-a-m-plus-2.md) | Claim | PROVED (paper argument; `K1_plateau_theorem.md`, Theorem B) |
| [`E2 — the plateau is non-empty when a_m + 1 ≤ N − a_m − 1, i.e. N ≥ 2a_m + 2`](tpp-rh40-rounds-truths-e2-plateau-nonempty-condition.md) | Claim | PROVED (paper argument; and E1 is proved) |
| [`E3 — the plateau value is not a function of (m, span, N)`](tpp-rh40-rounds-truths-e3-plateau-not-function-of-m-span-n.md) | Claim | VERIFIED (numerical; 45/55 keys multi-valued at N=20) |
| [`E4 — max_L p(L) &gt; a_m + 2 is possible outside the eligibility condition`](tpp-rh40-rounds-truths-e4-max-p-outside-eligibility.md) | Claim | VERIFIED (numerical; witness `(30,)`, `N = 34`) |
| [`E5 — decay law: p(L) = N − L + 1 for exactly L ∈ [N − a_m − 1, N − 1]`](tpp-rh40-rounds-truths-e5-decay-law-exact-range.md) | Claim | PROVED (paper argument; Corollary of Theorem A) |
| [`E6 — the p(L) = a_m + 2 plateau ends at exactly L = N − a_m − 1`](tpp-rh40-rounds-truths-e6-plateau-ends-at-crossover.md) | Claim | PROVED (paper argument; the indicator in Theorem A flips there) |
| [`E7 — the large-L law (Theorem A)`](tpp-rh40-rounds-truths-e7-large-l-law-theorem-a.md) | Theorem | PROVED (paper argument; `K1_plateau_theorem.md`, Theorem A) |
| [`E8 — the plateau onset has no formula found so far`](tpp-rh40-rounds-truths-e8-plateau-onset-no-formula.md) | Claim | OPEN (all four tested candidates fail on ≥3 of 5 words; on 375 random eligible supports `a_{m−1}+1` fails in 284) |
| [`E8a — Theorem E (determinacy): the plateau onset is not a function of (gaps, N) but is a function of (gaps, N, a_0)`](tpp-rh40-rounds-truths-e8a-theorem-e-onset-determinacy.md) | Theorem | PROVED (paper argument; the negative half by counterexample, the positive half by construction) |
| [`F1 — Theorem D: p(L) = L + 1 for L ≤ min(min_j d_j, a_0, N − a_0 − 1)`](tpp-rh40-rounds-truths-f1-theorem-d-c1-regime.md) | Theorem | PROVED (paper argument; verified unconditionally on 399 486 cases, 0 counterexamples) |
| [`F2 — the C1 regime extends strictly below the next gap`](tpp-rh40-rounds-truths-f2-c1-regime-below-next-gap.md) | Claim | VERIFIED (numerical; measured first failures) |
| [`F3 — exact formulation of the C1 boundary`](tpp-rh40-rounds-truths-f3-exact-c1-formulation.md) | Claim | VERIFIED (derivation + spot checks) |
| [`F4 — no closed form for the C1 boundary in the gaps alone has been found`](tpp-rh40-rounds-truths-f4-no-closed-form-in-gaps.md) | Claim | REFUTED (all four candidates) |
| [`F5 — which gap governs the first failure of C1 is not determined by the gaps alone`](tpp-rh40-rounds-truths-f5-which-gap-governs-open.md) | Claim | VERIFIED (numerical measurement; the rule is OPEN) |
| [`G1 — the HANDOFF §3.1 table for 1/π`](tpp-rh40-rounds-truths-g1-one-over-pi-handoff-table.md) | Claim | VERIFIED (numerical; `code/digitword.py` self-check and `probes.py` probe 6) |
| [`G10 — single-one word law`](tpp-rh40-rounds-truths-g10-single-one-word-law.md) | Claim | VERIFIED (numerical; first half exact on all 239 599 cases, combined law 0 counterexamples on its stated range) |
| [`G11 — in the degenerate sliver N &lt; 2a + 4 the halves do not simply patch together`](tpp-rh40-rounds-truths-g11-single-one-degenerate-sliver.md) | Claim | VERIFIED (numerical; recorded, not chased) |
| [`G2 — slope runs for 1/π`](tpp-rh40-rounds-truths-g2-one-over-pi-slope-runs.md) | Claim | VERIFIED (numerical; `slopes()` and `probes.py` probe 6) |
| [`G3 — RS(L) runs for 1/π up to L = 699`](tpp-rh40-rounds-truths-g3-one-over-pi-right-special-counts.md) | Claim | VERIFIED (numerical; `probes.py` probe 4) |
| [`G4 — the plateau for 1/π is exactly L ∈ [605, 792], p = 609 = a_m + 2`](tpp-rh40-rounds-truths-g4-one-over-pi-plateau-range.md) | Claim | VERIFIED (numerical; `verify_agentB.py` B-b) |
| [`G5 — p(L) = N − L + 1 on exactly L ∈ [792, 1399] for 1/π`](tpp-rh40-rounds-truths-g5-one-over-pi-decay-range.md) | Claim | VERIFIED (numerical; `verify_agentB.py` B-b) |
| [`G6 — log 2: word (0, 4, 36, 6069), N = 13000, max p = 6071`](tpp-rh40-rounds-truths-g6-log-2-parameters.md) | Claim | VERIFIED (numerical; `probes.py` probe 1 and `verify_agentB.py` B-b/B-e) |
| [`G7 — √2−1: word (1, 11, 251), N = 2000, max p = 253`](tpp-rh40-rounds-truths-g7-sqrt2-minus-1-parameters.md) | Claim | VERIFIED (numerical; `probes.py` probe 1 and `verify_agentB.py` B-b/B-e) |
| [`G8 — the word (10, 20, 40, 80), N = 500, max p = 82`](tpp-rh40-rounds-truths-g8-geometric-word-parameters.md) | Claim | VERIFIED (numerical; `probes.py` probe 1 and `verify_agentB.py` B-b/B-e) |
| [`G9 — true e−2 is (0, 3, 53) at N = 2000; (10, 20, 40, 80) is not e−2`](tpp-rh40-rounds-truths-g9-true-e-minus-2-support.md) | Claim | VERIFIED (numerical; `probes.py` probe 1 and `verify_agentB.py` B-b/B-e; support stable at dps 60/120/200) |
| [`H1 — all 277 reduced p/q with q ≤ 30 terminate`](tpp-rh40-rounds-truths-h1-all-277-rationals-terminate.md) | Claim | VERIFIED (exact rational census at cap 5·10⁶ plus targeted runs) |
| [`H2 — deepest termination indices for q ≤ 30`](tpp-rh40-rounds-truths-h2-deepest-termination-indices.md) | Claim | VERIFIED (exact rational censuses and targeted runs) |
| [`H3 — the count is a cap artefact, not a fact about the rationals`](tpp-rh40-rounds-truths-h3-count-is-cap-artefact.md) | Claim | VERIFIED (exact rational censuses at four caps) |
| [`H4 — θ = π terminates with exactly the support {0, 1, 4}`](tpp-rh40-rounds-truths-h4-theta-pi-support.md) | Claim | VERIFIED (exact `Fraction` loop) |
| [`H5 — a float run gives the spurious support [0,1,5,41,1805] for θ = π`](tpp-rh40-rounds-truths-h5-float-run-spurious-support.md) | Claim | CITED (INHERITED — HANDOFF §8.1; not reproduced this session) |
| [`I1 — ζ(3)/ζ(6) = 1.18156494901…`](tpp-rh40-rounds-truths-i1-zeta-3-over-zeta-6.md) | Claim | VERIFIED (numerical, mpmath at dps 25) |
| [`I2 — p* = 1.728647239… where ζ(p*) = 2`](tpp-rh40-rounds-truths-i2-p-star-threshold.md) | Claim | VERIFIED (numerical, `mp.findroot` at dps 25) |
| [`I3 — Mertens = γ + Σ_{p ≤ 10⁶}[log(1−1/p) + 1/p] = 0.261497246736…`](tpp-rh40-rounds-truths-i3-mertens-constant.md) | Claim | VERIFIED (numerical, sympy `primerange` + mpmath at dps 25; 78 498 primes) |
| [`I4 — ∫₀¹ log(1−f) df = −1 exactly`](tpp-rh40-rounds-truths-i4-integral-log-one-minus-f.md) | Claim | VERIFIED (numerical/exact; `probes.py` probe 5) |
| [`I5 — the number of usable residual-orbit steps is logarithmic in the working precision`](tpp-rh40-rounds-truths-i5-residual-orbit-steps-precision.md) | Claim | VERIFIED (numerical; seven precisions) |
| [`I6 — HANDOFF §6.5's residual-orbit protocol is unachievable`](tpp-rh40-rounds-truths-i6-handoff-protocol-unachievable.md) | Claim | VERIFIED (from register row I5 plus arithmetic) |
| [`I7 — the residual-orbit limit question cannot be settled by iterating a fixed-precision x`](tpp-rh40-rounds-truths-i7-residual-orbit-symbolic-necessity.md) | Claim | VERIFIED (obstruction; follows from I5/I6) |
| [`I8 — the finite-r means are not −1 (no convergence claim either way)`](tpp-rh40-rounds-truths-i8-finite-r-means-open.md) | Claim | **SETTLED (2026-10-11 attack; OP-33).** (a) **PROVED** (Lean, `Rh42.step_bound`, `rounds/rh42/lean/Rh42/PrecisionFloor.lean`, axiom-clean): if `r_0 ≤ 1/10`, `r_{k+1} ≤ r_k²` and `10^{−D} < r_{K−1}` then `2^{K−1} ≤ D`, so `D` digits reach only `K ≤ log₂ D + 1` steps — the source's `7–13 steps before underflow` is a theorem, not a bug. (b) Means of `log c_k` over `10⁴` prescribed steps converge to the mean of `log α_k` (`1/2→−0.6931`, `1/4→−1.3863`, `1/10→−2.3026`); **none is `−1`** — the source's claim is confirmed but re-attributed (no universal limit exists; the finite-`K` mean is strictly below the `s`-mean by the un-decayed gap `Γ_K/K`). See `research/attacks/OP-28-30-33.md`. |
| [`J1 (refuted) — p(L) = L + 1 + #{pairs of 1s at distance ≤ L}`](tpp-rh40-rounds-truths-j1-pair-count-law-refuted.md) | Claim | REFUTED (1/π `L = 11` (law 13, truth 12); log 2 **`L = 4`** (6 vs 5) — ★HANDOFF §5 wrongly records log 2 at `L = 6` (both sides give 8)) |
| [`J10 (refuted) — p(L) = min(a_m + 2, N − L + 1) for all L`](tpp-rh40-rounds-truths-j10-min-a-m-plus-2-law-refuted.md) | Claim | REFUTED (fails exactly on `L = 1 … onset − 1` (604 values for 1/π), per E7) |
| [`J11 (refuted) — plateau onset = a_{m−1} + 1`](tpp-rh40-rounds-truths-j11-onset-a-m-minus-1-plus-1-refuted.md) | Claim | REFUTED (`(9,25)`, `N = 70`: onset 26 vs 10; 284/375 random eligible supports fail) |
| [`J12 (refuted) — plateau onset = a_m + 2 − #distinct gaps`](tpp-rh40-rounds-truths-j12-onset-minus-distinct-gaps-refuted.md) | Claim | REFUTED (1/π 605 vs 607; (10,20,40,80) 60 vs 79) |
| [`J13 (refuted) — C1 boundary = 1 + min(min_j d_j, min_j(d_j + d_{j+1})) (Agent A, round 1)`](tpp-rh40-rounds-truths-j13-c1-boundary-agent-a-refuted.md) | Claim | REFUTED (4 903 violations inside its own claimed range, 449 too early, over 17 375 sampled eligible words; exact on the four dialogue words only) |
| [`J14 (refuted) — "p(L) saturates on [span, N]"`](tpp-rh40-rounds-truths-j14-saturation-on-span-n-refuted.md) | Claim | REFUTED (only true on the plateau `[onset, N − a_m − 1]`; outside it `p` is not constant, and past it `p` strictly decreases) |
| [`J2 (refuted) — p(L) = L + 1 + #{distinct distances ≤ L}`](tpp-rh40-rounds-truths-j2-distinct-distance-law-refuted.md) | Claim | REFUTED (1/π **`L = 11`** (13 vs 12) — ★HANDOFF §5 wrongly records `L = 12` (both sides give 14)) |
| [`J3 (refuted) — p(L) = L + 1 + Σ_i (L − d_i)_+`](tpp-rh40-rounds-truths-j3-sum-of-gaps-law-refuted.md) | Claim | REFUTED (1/π `L = 20` (30 vs 24)) |
| [`J4 (refuted) — the HANDOFF §3.1 piecewise law p(L) = 2L − 10 / 3L − 603`](tpp-rh40-rounds-truths-j4-piecewise-law-refuted.md) | Claim | REFUTED (1/π `L = 15` (20 vs 19); `L = 100` (190 vs 104); `L = 593` (1176 vs 597)) |
| [`J5 (refuted) — B's triple (index of first 1, its offset, number of further 1s) classifies factors`](tpp-rh40-rounds-truths-j5-triple-classification-refuted.md) | Claim | REFUTED (`{19,50,83}`, `L = 1`: triple gives 4, truth 2) |
| [`J6 (refuted) — model D: p(L) = min(L + span, N − L + 1)`](tpp-rh40-rounds-truths-j6-model-d-min-law-refuted.md) | Claim | REFUTED (`{139,151}`, `N = 172`, `L = 13`: 25 vs 15) |
| [`J7 (refuted) — p(L) = L + 1 for all L (Sturmian-like)`](tpp-rh40-rounds-truths-j7-sturmian-law-refuted.md) | Claim | REFUTED (impossible — the word is finitely supported, so non-recurrent; Morse–Hedlund forbids it) |
| [`J8 (refuted) — the finite-word fix p(L+1) − p(L) = RS(L) − LS(L+1)`](tpp-rh40-rounds-truths-j8-naive-left-special-fix-refuted.md) | Claim | REFUTED (fails for every `L` with `Z(L) = 1`, i.e. all of `[N − a_m − 1, N − 1]`; `LS ≡ 0` (C7) so the term does nothing) |
| [`J9 (refuted) — p(L) = min(L + 1 + #{d_i &lt; L}, N − L + 1)`](tpp-rh40-rounds-truths-j9-min-l-plus-1-law-refuted.md) | Claim | REFUTED (1/π `L = 13` (15 vs 16) — fails across the whole saturation-onset range `L = 13 … 604`) |
| [`K6 (refuted) — the limit is independent of x`](tpp-rh40-rounds-truths-k6-limit-independent-of-x-refuted.md) | Claim | REFUTED (by K6f) |
| [`K6a — the u-map: u_{k+1} = q²/s − q exactly`](tpp-rh40-rounds-truths-k6a-u-map-exact.md) | Claim | PROVED (paper argument, algebra; VERIFIED numerically on 8 rational seeds × 25 steps, 0 mismatches) |
| [`K6b — the induced map on s: s_{k+1} = 1 − {q²/s}, not the Gauss map`](tpp-rh40-rounds-truths-k6b-induced-map-on-s.md) | Claim | VERIFIED (exact on rationals; not the Gauss map, max deviation 0.91) |
| [`K6c — the density μ_q(s) = q(q−1)/(q−s)² → 1 (Lebesgue), not Gauss–Kuzmin`](tpp-rh40-rounds-truths-k6c-density-mu-q.md) | Claim | VERIFIED (normalisation exact; `L¹` distance computed) |
| [`K6d — E[log s_k \| q_k] = −1 + 1/(2q_k) + O(1/q_k²)`](tpp-rh40-rounds-truths-k6d-expectation-log-s.md) | Claim | VERIFIED (numerical, to 12+ digits for `q ≤ 10⁶`) |
| [`K6e — correction term: Σ[log c_k − log s_k] converges absolutely`](tpp-rh40-rounds-truths-k6e-correction-term-converges.md) | Claim | PROVED (paper argument) + VERIFIED (numerical) |
| [`K6f — refutation of x-independence: the Sylvester-admissible family converges to log(1/2)`](tpp-rh40-rounds-truths-k6f-x-independence-refuted.md) | Claim | PROVED (paper argument) — reproduced by the mediator both backward (exact relation) and by the forward greedy map from `x = Σ1/q_k` |
| [`K6g — the achieved limits are exactly (−∞, 0] (partial)`](tpp-rh40-rounds-truths-k6g-achieved-limits-partial.md) | Claim | VERIFIED (numerical, partial: `s* = 1/2` and `s* = 0.1` reproduced; `s* = 0.9, 0.99` did **not** reproduce under `q_{k+1} = ⌊q_k²/s*⌋`; the weaker conclusion is proved by K6f) |
| [`K6h — conjecture: a family with no limit at all (prescribed blocks)`](tpp-rh40-rounds-truths-k6h-no-limit-family-conjectured.md) | Claim | **PROVED (2026-10-11 attack; constructive, OP-30 ≡ OP-28).** Same construction as OP-28; the block-end running means of `log α_k` form an exact 2-cycle (`{−0.8664, −1.2130}` for `3^j` blocks, gap `0.347`), far exceeding the `O(10⁻³)` correction. See `research/attacks/OP-28-30-33.md`. |
| [`K6i — for x uniform on (0,1): E[(1/K)Σ log c_k] = −1 + O(1/K) (L¹)`](tpp-rh40-rounds-truths-k6i-uniform-x-mean.md) | Claim | PROVED (paper argument, Agent B; mediator verified the density input K6c/K6d) |
| [`K6j — conjecture: a.e. convergence to −1`](tpp-rh40-rounds-truths-k6j-a-e-convergence-conjectured.md) | Claim | CONJECTURED (modulo the stated expanding-map correlation lemma, which is not written out) |
| [`K7a — termination threshold for α_n = (n+2)^{−p} at unit target: ζ(p) ≥ 2, p* = 1.72864723899818362`](tpp-rh40-rounds-truths-k7a-power-family-threshold.md) | Claim | VERIFIED (mediator) — and **target-dependent**: for `x = 1/2` the threshold is the root of `ζ(p) = 3/2`, `p = 2.18528545178748223` |
| [`K7b (refuted) — the family's word is 1^{N(p)}0^∞ with every gap 1`](tpp-rh40-rounds-truths-k7b-bounded-gap-witness-refuted.md) | Claim | REFUTED — for `p = 3/2` the orbit is `{0..8, 34, 954, 77716, …}` with gaps 25, 919, 76 761, … **unbounded**; `N(p)` ends the *initial segment*, not the orbit |
| [`K7c (refuted) — "bounded gaps OR exact termination, never both"`](tpp-rh40-rounds-truths-k7c-bounded-gaps-or-termination-refuted.md) | Claim | REFUTED (`α_n = 2^{−(n+1)}`, `x = 1`, verified in exact `Fraction`s: taken `{0,1,2,…}` with max gap 1, residual `2^{−(n+1)} → 0` exactly) |
| [`K7d — the three cases of the power family`](tpp-rh40-rounds-truths-k7d-power-family-cases.md) | Claim | VERIFIED (numerical: max gaps 76 762 at `p=1.5`; 795 962 at `p=1.7`) |
| [`K7e — any terminating alphabet has finite support, hence max_L p(L) = a_m + 2`](tpp-rh40-rounds-truths-k7e-terminating-alphabet-finite-support.md) | Claim | PROVED (paper argument; direct from K1's Theorem A, and alphabet-independent) |
| [`K7f — the corrected structure theorem for α_n = (n+2)^{−p}, x = 1, p &gt; 1`](tpp-rh40-rounds-truths-k7f-corrected-structure-theorem.md) | Claim | PROVED (paper argument: the third case because `r>0` is fixed while `α_k → 0`, so `{k : α_k ≤ r}` is an infinite tail and the residual never reaches 0) |

## `tpp-rh41-lean`

<a id="tpp-rh41-lean"></a>

The rh41 Lean layer's own report: the general bound `p(L) ≤ a_m + 2` and the three corrections to the printed theorems — an interchanged example, a false Theorem 9, and a missing hypothesis in Theorem 10.

Source: [`rounds/rh41/lean/README.md`](../../research/twin-prime-parity/rounds/rh41/lean/README.md) &nbsp;·&nbsp; **7** files.

| file | kind | status |
|---|---|---|
| [`The auxiliary general bound p(L) ≤ a_m + 2`](tpp-rh41-lean-readme-auxiliary-general-bound.md) | Lemma | PROVED (Lean, no sorry) |
| [`Correction 1 — the printed onset example is interchanged`](tpp-rh41-lean-readme-correction-1-onset-example.md) | Claim | PROVED (Lean; gap-sequence part by `native_decide`) |
| [`Correction 2 — Theorem 9 as printed is false`](tpp-rh41-lean-readme-correction-2-halting-criterion.md) | Claim | REFUTED (Lean counterexamples; the surviving direction and its converse form are PROVED (Lean)) |
| [`Correction 3 — Theorem 10 row 3 needs an extra hypothesis`](tpp-rh41-lean-readme-correction-3-theorem-10-row-3.md) | Claim | PROVED (Lean, with the added hypothesis) |
| [`Correction 4 — Theorem 1 is stated with a redundant hypothesis`](tpp-rh41-lean-readme-correction-4-theorem-1-redundant-hypothesis.md) | Claim | PROVED (Lean) |
| [`Correction 5 — Theorem 7 needs strict hypotheses`](tpp-rh41-lean-readme-correction-5-theorem-7-strict-hypotheses.md) | Claim | PROVED (Lean) |
| [`Correction 6 — the literal phrasing of Theorem 12`](tpp-rh41-lean-readme-correction-6-theorem-12-literal-phrasing.md) | Claim | PROVED (Lean) |

## `tpp-rh41-truths`

<a id="tpp-rh41-truths"></a>

The rh41 truth table: factor and offset-tuple counts, the all-zero-factor criterion, the ratio `r_{k+1}/r_k²` having no positive lower bound, termination of all reduced `p/q` with `q ≤ 30`, and fourteen refuted statements.

Source: [`rounds/rh41/TRUTHS.md`](../../research/twin-prime-parity/rounds/rh41/TRUTHS.md) &nbsp;·&nbsp; **31** files.

| file | kind | status |
|---|---|---|
| [`The all-zero factor occurs iff an extended gap is ≥ L+1`](tpp-rh41-truths-claim-all-zero-factor-gap-criterion.md) | Claim | CHECKED (exhaustive finite, 95 835 cases; Lean-proved for all supports) |
| [`The ratio r_{k+1}/r_k² has no positive lower bound`](tpp-rh41-truths-claim-no-positive-lower-bound-ratio.md) | Claim | CHECKED (exhaustive finite, 4 000 exact rational orbits; Lean-proved) |
| [`The offset-tuple count equals the bit-string factor count`](tpp-rh41-truths-claim-offset-tuple-equals-bit-factor.md) | Claim | CHECKED (exhaustive finite, 59 267 cases; Lean-proved for all supports) |
| [`All 277 reduced p/q with q ≤ 30 terminate`](tpp-rh41-truths-claim-rational-census-q-le-30.md) | Claim | CHECKED (exhaustive finite: all 277 reduced `p/q` with `q ≤ 30`) |
| [`The squaring law r_{k+1} ≤ r_k² and the lower bound A(N) = Ω_x(log log N)`](tpp-rh41-truths-claim-squaring-law-omega-lower-bound.md) | Claim | PROVED, direction corrected (OP-13) — the squaring law yields `O`, not `Ω` |
| [`The exact number of windows containing a_m`](tpp-rh41-truths-claim-window-count-containing-a-m.md) | Claim | CHECKED (exhaustive finite, 25 044 603 cases; Lean-proved for all `1 ≤ L ≤ N`) |
| [`Corollary 2 (plateau)`](tpp-rh41-truths-corollary-2-plateau.md) | Corollary | PROVED (paper argument; Lean, no sorry) |
| [`Corollary 3 (decay)`](tpp-rh41-truths-corollary-3-decay.md) | Corollary | PROVED (paper argument; Lean, no sorry) |
| [`Corollary 4`](tpp-rh41-truths-corollary-4-max-complexity.md) | Corollary | PROVED (paper argument; Lean, no sorry) |
| [`Refuted — "bounded gaps OR termination, never both"`](tpp-rh41-truths-refuted-bounded-gaps-or-termination.md) | Claim | REFUTED (counterexample: `α_n = 2^{−(n+1)}` has both) |
| [`Refuted — the distinct-distance formula`](tpp-rh41-truths-refuted-distinct-distance-formula.md) | Claim | REFUTED (counterexample: `x = 1/π`, `L = 11`: 13 vs 12) |
| [`Refuted — A(N) = log₂ log N + O(1) with an explicit constant`](tpp-rh41-truths-refuted-explicit-loglog-constant.md) | Claim | REFUTED (the per-step factor `r'/r²` has no positive lower bound, minimum 1.58·10⁻⁴) |
| [`Refuted — the first-difference identity with a left-special correction`](tpp-rh41-truths-refuted-first-difference-left-special.md) | Claim | REFUTED (left-special count is 0 throughout; the correct correction is the count of factors with no right extension) |
| [`Refuted — the gap-deficit formula`](tpp-rh41-truths-refuted-gap-deficit-formula.md) | Claim | REFUTED (counterexample: `x = 1/π`, `L = 20`: 30 vs 24) |
| [`Refuted — Σ_j \|intervals\| counts the factors`](tpp-rh41-truths-refuted-interval-count-equals-factors.md) | Claim | REFUTED (counterexample: the intervals overlap) |
| [`Refuted — the main formula for all L`](tpp-rh41-truths-refuted-main-formula-all-l.md) | Claim | REFUTED (counterexample: support `{0,1}`, `N=2`, `L=1`) |
| [`Refuted — the onset is a function of the gaps`](tpp-rh41-truths-refuted-onset-function-of-gaps.md) | Claim | REFUTED (counterexample: `gaps=(2,)`, `N=6`: onset 2 for `(0,2)`, 3 for `(1,3)`; the onsets are in fact 3 and 2) |
| [`Refuted — the pair-count formula`](tpp-rh41-truths-refuted-pair-count-formula.md) | Claim | REFUTED (counterexample: `x = 1/π`, `L = 11`: 13 vs 12) |
| [`Refuted — α_n = (n+2)^{−3/2} has bounded gaps`](tpp-rh41-truths-refuted-power-alpha-bounded-gaps.md) | Claim | REFUTED (counterexample: max gap 76 762) |
| [`Refuted — the residual-orbit average has a limit independent of x`](tpp-rh41-truths-refuted-residual-orbit-average-limit.md) | Claim | REFUTED (counterexample: `q_0=4`, `q_{k+1}=2q_k²` gives limit `log(1/2) = −0.6931…`, not `−1`) |
| [`Refuted — the slope formula p(L) = 2L − 10`](tpp-rh41-truths-refuted-slope-formula-2l-minus-10.md) | Claim | REFUTED (counterexample: `x = 1/π`, `L = 100`: 190 vs 104) |
| [`Refuted — the span formula`](tpp-rh41-truths-refuted-span-formula.md) | Claim | REFUTED (counterexample: `{139,151}`, `N=172`, `L=13`: 25 vs 15) |
| [`Theorem 1 (main)`](tpp-rh41-truths-theorem-1-complexity-main.md) | Theorem | PROVED (paper argument; Lean, no sorry) |
| [`Theorem 10 (structure, corrected)`](tpp-rh41-truths-theorem-10-alphabet-structure.md) | Theorem | PROVED (paper argument; Lean with an added hypothesis) |
| [`Theorem 11 (dichotomy false)`](tpp-rh41-truths-theorem-11-dichotomy-false.md) | Theorem | PROVED (Lean, no sorry) |
| [`Theorem 12 (inverse problem, impossibility half)`](tpp-rh41-truths-theorem-12-inverse-impossibility.md) | Theorem | PROVED (paper argument; Lean) |
| [`Theorem 5 (C1 regime)`](tpp-rh41-truths-theorem-5-c1-regime.md) | Theorem | PROVED (paper argument; Lean, no sorry) |
| [`Theorem 6 (onset determinacy)`](tpp-rh41-truths-theorem-6-onset-determinacy.md) | Theorem | PROVED (Lean; gap-sequence part by `native_decide`; printed example corrected) |
| [`Theorem 7 (maps)`](tpp-rh41-truths-theorem-7-induced-maps.md) | Theorem | PROVED (Lean; exact rational identities) |
| [`Theorem 8 (rational termination)`](tpp-rh41-truths-theorem-8-rational-termination.md) | Theorem | PROVED (Lean, no sorry) |
| [`Theorem 9 (halting criterion)`](tpp-rh41-truths-theorem-9-halting-criterion.md) | Theorem | REFUTED (Lean; the printed `iff` is false — only "halting ⟹ some partial sum ≥ x" holds) |

## `tpp-rh42-handoff`

<a id="tpp-rh42-handoff"></a>

The rh42 handoff: the budget closed forms `P(p) = 2^{−p}ζ(p)` and `N(p) = (1−2^{−p})ζ(p) − 1`, the corrected alphabet total `1 − ln 2`, Brown's criterion as used, and the threshold certificates.

Source: [`rounds/rh42/HANDOFF.md`](../../research/twin-prime-parity/rounds/rh42/HANDOFF.md) &nbsp;·&nbsp; **20** files.

| file | kind | status |
|---|---|---|
| [`T17 — the alphabet's total is `1 − ln 2`, not `ln 2 − 1``](tpp-rh42-handoff-alphabet-total-sign.md) | Claim | VERIFIED (numerical, `nsum` to 25 digits both ways) |
| [`Brown's criterion (as used for the positive half-series)`](tpp-rh42-handoff-brown-criterion.md) | Theorem | CITED (literature; Brown's criterion, used as a rung of the §5.5 argument) |
| [`T2 — the budgets `P(p) = 2^{−p}ζ(p)`, `N(p) = (1−2^{−p})ζ(p) − 1``](tpp-rh42-handoff-budget-closed-forms.md) | Claim | PROVED (paper argument; even/odd split of ζ) + VERIFIED (numerical, direct partial sums to 200k terms) |
| [`T15 — at `p*` the budget interval is `[−0.39653, +0.60347]`, length `1``](tpp-rh42-handoff-budget-interval-at-p-star.md) | Claim | VERIFIED (numerical; `P(p*) = 2^{1−p*}`) |
| [`T7 — reachable ⊆ `[−N(p), P(p)]`; above the budget the residual tends to `x − P(p)``](tpp-rh42-handoff-budget-necessary-and-stall.md) | Claim | PROVED (paper argument, necessity) + VERIFIED (numerical, exact stall values at `p = 2`) |
| [`T3 — `P+N = ζ−1`, `P−N = 1−η`, `P = (ζ−η)/2`, `N = (ζ+η−2)/2``](tpp-rh42-handoff-budget-sum-difference-identities.md) | Claim | PROVED (paper argument; algebra) + VERIFIED (numerical, to 1e−81) |
| [`T6 — at `p = 1` every target passes the budget test and the residual falls to `0``](tpp-rh42-handoff-budget-test-at-p-1.md) | Claim | VERIFIED (numerical, max residual `2.29e−6` over six sines, 200k terms, 80 dps) |
| [`T8 — the positive half is the classical Egyptian greedy at `2^p x``](tpp-rh42-handoff-egyptian-greedy-correspondence.md) | Claim | PROVED (paper argument, index substitution) + VERIFIED (numerical, support correspondence at `p = 1, 2`) |
| [`T13 — the negative half is complete iff `p ≤ q = 2.07677517921069``](tpp-rh42-handoff-negative-half-completeness-threshold.md) | Claim | PROOF-SKETCH (root of `N(p) = 2·3^{−p}`, sign change at `q ± 10^{−6}`) + VERIFIED (numerical) |
| [`R1 — the source pages' ledger has the corrected onsets (`{0,2}→3`, `{1,3}→2`)`](tpp-rh42-handoff-onset-values-cross-check.md) | Claim | VERIFIED (numerical, `rigorous_check.py::onset` and agreement with the Lean theorem) |
| [`T9 — the signed support has only even/odd indices (all gaps even, `≥ 2`)`](tpp-rh42-handoff-parity-locked-support.md) | Claim | VERIFIED (numerical, parity of every take for four `θ`) |
| [`T5 — `P(p) ~ N(p) ~ 1/(2(p−1))` as `p ↓ 1` (the pole, halved)`](tpp-rh42-handoff-pole-halved-asymptotics.md) | Claim | PROVED (paper argument) + VERIFIED (numerical, `P(p)(p−1) = 0.49999994` at `p = 1+10^{−6}`) |
| [`The positive half is complete iff `2 ≤ ζ(p)` iff `p ≤ p*``](tpp-rh42-handoff-positive-half-completeness-chain.md) | Proposition | PROOF-SKETCH (the equivalence is stated with its algebra) + VERIFIED (numerical, both directions at `p* ± 10^{−6}`) |
| [`T10 — the positive half is complete (reachable = `[0, P]`) iff `p ≤ p*`, `ζ(p*) = 2``](tpp-rh42-handoff-positive-half-completeness-threshold.md) | Claim | PROOF-SKETCH (Brown's criterion; both directions at `p* ± 10^{−6}`) + VERIFIED (numerical, 11/11 targets at `p = 1.5`) |
| [`T4 — `P(p) > N(p)` for all `p > 0`; the asymmetry is `1−η(p)``](tpp-rh42-handoff-positive-side-cheaper.md) | Claim | PROVED (paper argument; from `η(p) < 1`) |
| [`T11 — at `p = 2` the reachable set is `[0, P−1/4] ∪ [1/4, P]` (one gap)`](tpp-rh42-handoff-reachable-set-p-equals-2.md) | Claim | PROOF-SKETCH (exactly predicted) + VERIFIED (numerical, exact stall residuals) |
| [`T12 — at `p = 3` the reachable set is the four intervals listed in §5.5`](tpp-rh42-handoff-reachable-set-p-equals-3.md) | Claim | VERIFIED (numerical, exact stall residuals) |
| [`The subset-sum recursion `S = S(tail) ∪ (a_1 + S(tail))` and the gap `(total − a_1, a_1)``](tpp-rh42-handoff-subset-sum-recursion-and-gap.md) | Proposition | PROVED (paper argument, stated in §5.5) |
| [`T14 — the three thresholds `pN < pP < p*` with the values in §5.3`](tpp-rh42-handoff-three-thresholds.md) | Claim | VERIFIED (numerical, `findroot` at 80 dps; each residual `< 1e−30`) |
| [`T16 — `w` factors through `sin(2πθ)`; `θ, θ+1, 1/2−θ` share a word, `1−θ` flips it`](tpp-rh42-handoff-word-factors-through-height.md) | Claim | PROVED (factorisation) + VERIFIED (numerical, 200-dps prefixes above the `1e−100` floor) |

## `tpp-rh42-lean`

<a id="tpp-rh42-lean"></a>

The rh42 Lean development: the budget closed forms, the C1 regime for signed words, the finite gap lemma, and Theorem 14 on even gaps.

Source: [`rounds/rh42/lean/README.md`](../../research/twin-prime-parity/rounds/rh42/lean/README.md) &nbsp;·&nbsp; **10** files.

| file | kind | status |
|---|---|---|
| [``Rh42/Budget.lean` — the budget closed forms (`hasSum_even_zeta_two`, `positiveBudget_two`, …)`](tpp-rh42-lean-readme-budget-closed-forms.md) | Theorem | PROVED (Lean, machine-checked; no `sorry`, no `admit`, no project-specific `axiom`, no `native_decide`) |
| [`The C1 regime — an even positive gap is `≥ 2`, and a support with a gap equal to `2` has C1 range `L ≤ 2``](tpp-rh42-lean-readme-c1-regime-signed.md) | Theorem | PROVED (Lean, machine-checked; no `sorry`) + VERIFIED (the example `{2,4}`, `N = 10`) |
| [`Theorem 14, even gaps — consecutive taken indices differ by an even number `≥ 2``](tpp-rh42-lean-readme-even-gaps.md) | Theorem | PROVED (Lean, machine-checked; no `sorry`) |
| [``gap_lemma` — the finite gap lemma`](tpp-rh42-lean-readme-gap-lemma.md) | Lemma | PROVED (Lean, machine-checked; no `sorry`) |
| [``greedySum` — the greedy's total is a sub-sum that never overshoots`](tpp-rh42-lean-readme-greedy-sum-sub-sum-bound.md) | Lemma | PROVED (Lean, machine-checked; no `sorry`) |
| [`Theorem 14, parity lock — a positive target only ever takes even indices; a negative target odd ones`](tpp-rh42-lean-readme-parity-lock.md) | Theorem | PROVED (Lean, machine-checked; no `sorry`) |
| [`Theorem 14, sign invariance — a positive residual stays `≥ 0` (and `> 0` when the term is strictly smaller)`](tpp-rh42-lean-readme-sign-invariance.md) | Theorem | PROVED (Lean, machine-checked; no `sorry`) |
| [`Refutation R3 — `(1/2, 2/5, 1/20, 1/20)` has `a_1 = A − a_1` and misses `1/5``](tpp-rh42-lean-readme-single-condition-not-sufficient.md) | Claim | PROVED (Lean, machine-checked counterexample; `no sorry`) |
| [``subSums` — `0` and the total are sub-sums, and sub-sums lie in `[0, sum]``](tpp-rh42-lean-readme-subsets-sums-and-greedy.md) | Lemma | PROVED (Lean, machine-checked; no `sorry`) |
| [``subSums_cons_disjoint` — Theorem 10's doubling step`](tpp-rh42-lean-readme-subsums-cons-disjoint.md) | Lemma | PROVED (Lean, machine-checked; no `sorry`) |

## `tpp-rh42-truths`

<a id="tpp-rh42-truths"></a>

The rh42 truth table: the C1 regime of a signed word, the corollaries of the budget theorems, and the eight statements refuted in that round.

Source: [`rounds/rh42/truths.md`](../../research/twin-prime-parity/rounds/rh42/truths.md) &nbsp;·&nbsp; **31** files.

| file | kind | status |
|---|---|---|
| [`The C1 regime of a signed word (new, corrected)`](tpp-rh42-truths-c1-regime-signed-word.md) | Claim | VERIFIED (numerical, on the listed examples) |
| [`Corollary 15 (T8)`](tpp-rh42-truths-corollary-15-egyptian-greedy.md) | Corollary | PROVED (paper argument; VERIFIED at p = 1 on four targets) |
| [`Corollary 4`](tpp-rh42-truths-corollary-4-max-plateau.md) | Corollary | VERIFIED (numerical, on the signed supports {0,2,4} and {2,6,38}) |
| [`Corollary 9`](tpp-rh42-truths-corollary-9-writable-intervals.md) | Corollary | PROVED (paper argument, immediate from Theorem 8) |
| [`The four thresholds, rigorously enclosed`](tpp-rh42-truths-four-thresholds-enclosed.md) | Claim | PROVED (paper argument; VERIFIED by rigorous bisection, brackets of width ≤ 2.2·10⁻¹²) |
| [`The onset is still not determined by (gaps, N)`](tpp-rh42-truths-onset-not-determined-by-gaps.md) | Claim | CHECKED (exhaustive finite: 210 of 402 keys multi-valued) |
| [`Plateau and decay (rh41's Theorem 1)`](tpp-rh42-truths-plateau-and-decay-signed.md) | Theorem | PROVED (Lean, inherited from rh41; VERIFIED here on signed supports) |
| [`R1 (refuted) — the alphabet (−1)^n/(n+2) totals ln 2 − 1`](tpp-rh42-truths-r1-alphabet-total-sign.md) | Claim | REFUTED (smallest witness below) |
| [`R2 (refuted) — "inside the budget ⟹ writable"`](tpp-rh42-truths-r2-inside-budget-not-writable.md) | Claim | REFUTED (smallest witness below) |
| [`R3 (refuted) — "a_1 ≤ A − a_1 ⟹ the sub-sums fill [0,A]"`](tpp-rh42-truths-r3-single-condition-not-sufficient.md) | Claim | REFUTED (smallest witness; machine-checked) |
| [`R4 (refuted) — "the greedy is optimal for a decreasing sequence"`](tpp-rh42-truths-r4-greedy-not-optimal.md) | Claim | REFUTED (smallest witness; verified exactly) |
| [`R5 (refuted) — "every rational target terminates" at general p`](tpp-rh42-truths-r5-rational-termination-general-p.md) | Claim | REFUTED (smallest witness below) |
| [`R6 (refuted) — "the word sees the turns"`](tpp-rh42-truths-r6-word-sees-turns.md) | Claim | REFUTED (smallest witness below) |
| [`R7 (refuted) — the reachable set has measure P(p) for every p`](tpp-rh42-truths-r7-measure-equals-budget.md) | Claim | REFUTED (false for every p > p*) |
| [`R8 (refuted) — the interval count grows like 2^{#{gaps}} in any p-free way`](tpp-rh42-truths-r8-interval-count-growth.md) | Claim | REFUTED (witness list below) |
| [`T6 — at p = 1 every target passes the budget test`](tpp-rh42-truths-t6-budget-test-at-p-1.md) | Claim | VERIFIED (numerical, `helix_zeta.py` §3) |
| [`T7 — reachable ⊆ budget; above it, residual → x − P(p)`](tpp-rh42-truths-t7-reachable-subset-of-budget.md) | Claim | PROVED (from Theorem 6 + Theorem 11) |
| [`Theorem 1 (sign)`](tpp-rh42-truths-theorem-1-sign.md) | Theorem | PROVED (paper argument; VERIFIED with exact rational enclosures) |
| [`Theorem 10 (census, new)`](tpp-rh42-truths-theorem-10-census.md) | Theorem | PROVED (paper argument; machine-checked finite form; VERIFIED to 3.9·10⁻⁶² on every endpoint) |
| [`Theorem 11 (greedy optimality, new)`](tpp-rh42-truths-theorem-11-greedy-optimality.md) | Theorem | PROVED (paper argument; case analysis over Theorem 7 and Theorem 8) |
| [`Theorem 12 (p = 2)`](tpp-rh42-truths-theorem-12-p-equals-2.md) | Theorem | VERIFIED (exact rational arithmetic; structure from Theorem 10) |
| [`Theorem 13 (p = 3)`](tpp-rh42-truths-theorem-13-p-equals-3.md) | Theorem | VERIFIED (exact rational arithmetic; structure from Theorem 10) |
| [`Theorem 14 (parity lock, T9)`](tpp-rh42-truths-theorem-14-parity-lock.md) | Theorem | PROVED (paper argument; machine-checked in Lean) |
| [`Theorem 16 (T16)`](tpp-rh42-truths-theorem-16-helix-height.md) | Theorem | PROVED (paper argument; VERIFIED at 200 dps) |
| [`Theorem 2 (T2, T3)`](tpp-rh42-truths-theorem-2-budget-algebra.md) | Theorem | PROVED (paper argument; VERIFIED to 1e−50 at p = 1.5, 2, 3, 4) |
| [`Theorem 3 (T4)`](tpp-rh42-truths-theorem-3-p-gt-n.md) | Theorem | PROVED (paper argument; VERIFIED at p = 1.01, 1.5, 2, 3, 5) |
| [`Theorem 4 (T5, H4)`](tpp-rh42-truths-theorem-4-pole-asymptotics.md) | Theorem | PROVED (paper argument; VERIFIED numerically at p = 1.001) |
| [`Theorem 5 (closed forms)`](tpp-rh42-truths-theorem-5-budget-closed-forms.md) | Theorem | PROVED (Lean, no sorry) |
| [`Theorem 6 (Brown's criterion, T10/T13 core)`](tpp-rh42-truths-theorem-6-brown-criterion.md) | Theorem | PROVED (paper argument; two one-step lemmas machine-checked in Lean) |
| [`Theorem 7 (unimodality)`](tpp-rh42-truths-theorem-7-unimodality.md) | Theorem | PROVED (paper argument; VERIFIED over nine exponents) |
| [`Theorem 8 (completeness thresholds, T10, T13)`](tpp-rh42-truths-theorem-8-completeness-thresholds.md) | Theorem | PROVED (paper argument; VERIFIED in both directions at the bracketing points) |

## `tpp-rh43-handoff`

<a id="tpp-rh43-handoff"></a>

The rh43 handoff: whether the balance condition is solvable for every `N`, the certified root brackets, the imaginary-split convention, and `S₂(π/log 2) = 0` exactly.

Source: [`rounds/rh43/HANDOFF.md`](../../research/twin-prime-parity/rounds/rh43/HANDOFF.md) &nbsp;·&nbsp; **13** files.

| file | kind | status |
|---|---|---|
| [`The answer: yes, for every N ≥ 2`](tpp-rh43-handoff-answer-yes-every-n.md) | Theorem | PROVED (paper argument) + VERIFIED (numerical); the case of every `N ≥ 3` is PROOF-SKETCH (equidistribution quoted) + VERIFIED to `N = 200` |
| [`The complex sum is a different question: S_2(π/log 2) = 0 exactly, S_3(t) ≠ 0 for every t`](tpp-rh43-handoff-complex-sum-different-question.md) | Proposition | PROVED (Lean, `zetaPartial_two_pi_div_log_two`, `zetaPartial_three_ne_zero`) |
| [`Existence for every N ≥ 3 (equidistribution), and certified brackets for N = 3..50`](tpp-rh43-handoff-existence-every-n.md) | Proposition | PROOF-SKETCH + VERIFIED (numerical, complete through N = 200); a self-contained proof is the main open item |
| [`The imaginary-split convention: the answer depends on the split convention`](tpp-rh43-handoff-imaginary-split-convention.md) | Proposition | VERIFIED (numerical; auditor check C7) |
| [`The divergence is linear: \|S_N(t)\|/N → 1/√(1+t²)`](tpp-rh43-handoff-linear-divergence.md) | Proposition | PROVED (paper argument, Euler summation) + VERIFIED (numerical, certified values) |
| [`N = 1: Re S_1 ≡ 1, the only degenerate case`](tpp-rh43-handoff-n1-only-degenerate-case.md) | Proposition | PROVED (paper argument; from the definition of the object) |
| [`N = 2 is balanced exactly at `t = π/log 2` (the tangential zero)`](tpp-rh43-handoff-n2-tangential-zero.md) | Proposition | PROVED (Lean, `balanced_two`) |
| [`N = 3 is balanced with the explicit IVT witness `t = 5/2``](tpp-rh43-handoff-n3-ivt-witness.md) | Proposition | PROVED (Lean, 38 theorems, no `sorry`, no new axiom) |
| [`N = 4 is balanced by the same route`](tpp-rh43-handoff-n4-same-route.md) | Proposition | VERIFIED (numerical, certified enclosure) |
| [`The round's object and question`](tpp-rh43-handoff-object-and-question.md) | Proposition | PROVED (paper argument; the readings R1, R2 are equivalent, R2′ and R3 are different questions) |
| [`The reduction: `P_N + M_N = Re S_N`, and balance as one real equation`](tpp-rh43-handoff-reduction-to-real-equation.md) | Theorem | PROVED (paper argument; the identities are Lean-checked in the round) |
| [`Term-level reading: strictly stronger than P = \|M\| and false at the balance points`](tpp-rh43-handoff-term-level-reading-fails.md) | Proposition | REFUTED (strict reading) — the exact subset-sum defect is `0.16996…` at `N = 6` |
| [`The three traps of the round`](tpp-rh43-handoff-three-traps.md) | Claim | PROVED (all three components: the `N = 2` tangential zero and the `S_3` non-vanishing in Lean; the linear divergence by Euler summation) |

## `tpp-rh43-lean`

<a id="tpp-rh43-lean"></a>

The rh43 Lean development: the balance/equal-split equivalences, the reduction of the round's question to a real partial sum, the certified `N = 2` case, and the trigonometric bounds at `t = 5/2`.

Source: [`rounds/rh43/lean/README.md`](../../research/twin-prime-parity/rounds/rh43/lean/README.md) &nbsp;·&nbsp; **10** files.

| file | kind | status |
|---|---|---|
| [`The balance-to-equal-split equivalences (`balanced_equal_split`, `equal_split_balanced`, `balanced_iff_equal_split`)`](tpp-rh43-lean-readme-balanced-iff-equal-split.md) | Theorem | PROVED (Lean, no `sorry`); the `iff` needs the conjunct `p1 + n1 = 0` |
| [``balanced_iff_realPartial_eq_zero` — the reduction of the round's question to one real equation`](tpp-rh43-lean-readme-balanced-iff-realpartial-eq-zero.md) | Theorem | PROVED (Lean, no `sorry`) |
| [``balanced_two` / `exists_balanced_two` — N = 2 is balanced at `π/log 2``](tpp-rh43-lean-readme-balanced-two.md) | Theorem | PROVED (Lean, no `sorry`) |
| [`The two trigonometric bounds at `t = 5/2`: `cos((5/2) log 2) < -0.16`, `cos((5/2) log 3) < -0.92``](tpp-rh43-lean-readme-cos-bounds-at-five-halves.md) | Lemma | PROVED (Lean, from Mathlib's log/π bounds and Taylor inequalities; no numerical axiom) |
| [`Reference sheet: the Lean development of rh43`](tpp-rh43-lean-readme-development-reference.md) | Proposition | PROVED (Lean, no `sorry`, no `admit`, no project-specific `axiom`, no `native_decide`) |
| [`Existence of a balanced partial sum (`exists_balanced_partial_sum`)`](tpp-rh43-lean-readme-exists-balanced-partial-sum.md) | Theorem | PROVED (Lean, no `sorry`, no numerical axiom) — "the answer of the round" |
| [``realPartial_continuous` — continuity of the real partial sum`](tpp-rh43-lean-readme-realpartial-continuous.md) | Lemma | PROVED (Lean, no `sorry`) |
| [``realPartial_eq_posRe_add_negRe` — the real part is the sum of the positive and negative parts`](tpp-rh43-lean-readme-realpartial-split-identity.md) | Theorem | PROVED (Lean, no `sorry`) |
| [``zetaPartial_three_ne_zero` — S_3(t) ≠ 0 for every real t`](tpp-rh43-lean-readme-zetapartial-three-ne-zero.md) | Theorem | PROVED (Lean, no `sorry`; axiom audit `[propext, Classical.choice, Quot.sound]`) |
| [``zetaPartial_two_pi_div_log_two` — `S_2(π/log 2) = 0` exactly`](tpp-rh43-lean-readme-zetapartial-two-exact-vanishing.md) | Theorem | PROVED (Lean, no `sorry`) |

## `tpp-rh43-readme`

<a id="tpp-rh43-readme"></a>

The rh43 round summary: the answer for every `N ≥ 2`, its dependence on the split convention, and the three traps that are part of the answer.

Source: [`rounds/rh43/README.md`](../../research/twin-prime-parity/rounds/rh43/README.md) &nbsp;·&nbsp; **4** files.

| file | kind | status |
|---|---|---|
| [`Answer: yes — for every N ≥ 2`](tpp-rh43-readme-answer-yes-every-n.md) | Theorem | SETTLED for all `N ≥ 3` (OP-7) |
| [`The answer depends on the split convention`](tpp-rh43-readme-split-convention.md) | Proposition | VERIFIED (numerical; the imaginary-split roots differ) |
| [`Read at the level of the terms, the answer flips`](tpp-rh43-readme-term-level-answer-flips.md) | Proposition | REFUTED (strict term-level reading) — exact subset-sum defect `0.16996…` at `N = 6` |
| [`Three traps are part of the answer`](tpp-rh43-readme-three-traps.md) | Claim | PROVED (all three components: the `N = 2` tangential zero and the `S_3` non-vanishing in Lean; the divergence by Euler summation) |

## `tpp-rh43-truths`

<a id="tpp-rh43-truths"></a>

The rh43 truth table: balance needs only the real equation, the certified root brackets for `N = 3..50`, why the complex picture is not the question, and the round's refutations.

Source: [`rounds/rh43/truths.md`](../../research/twin-prime-parity/rounds/rh43/truths.md) &nbsp;·&nbsp; **39** files.

| file | kind | status |
|---|---|---|
| [`Theorem 10 (balance needs only the real equation)`](tpp-rh43-truths-balance-needs-only-real-equation.md) | Theorem | PROVED (paper argument; assembled from the Lean-proved components) |
| [`T7 — certified root brackets for N = 3..50`](tpp-rh43-truths-certified-root-ledger.md) | Theorem | VERIFIED (numerical, 47 certified digits per bracket) |
| [`Theorem 6 (certified root table)`](tpp-rh43-truths-certified-root-table.md) | Theorem | VERIFIED (numerical, 47 certified digits per bracket) |
| [`Theorem 9 (why the complex picture is *not* the question)`](tpp-rh43-truths-complex-picture-not-the-question.md) | Theorem | PROVED (paper argument); the exact complex vanishing for `N >= 4` is OPEN |
| [`T16 — the critical-line case σ = 1/2`](tpp-rh43-truths-critical-line-sigma-half.md) | Theorem | PROVED (identities, radial law) + VERIFIED (numerics, including the `1/√(2t)` coefficient) |
| [`T8 — existence of a root for every N >= 3`](tpp-rh43-truths-existence-every-n-ledger.md) | Theorem | PROOF-SKETCH (density step quoted) + VERIFIED (numerical, `N <= 200`); self-contained proof OPEN |
| [`Theorem 7 (existence for every N >= 3)`](tpp-rh43-truths-existence-every-n.md) | Theorem | SETTLED (OP-7) — uniform `t_N = π/log N`, no equidistribution |
| [`F1 — "the split can be balanced iff N >= 3"`](tpp-rh43-truths-f1-balance-iff-n-ge-3-refuted.md) | Claim | REFUTED (smallest witness `N = 2`, `t = pi/log 2`) |
| [`F2 — "N = 2 has no root of Re S_2"`](tpp-rh43-truths-f2-n2-no-root-refuted.md) | Claim | REFUTED (smallest witness: the roots themselves, `t = (2k+1) pi/log 2`) |
| [`F3 — "N = 1 is the same as N = 2"`](tpp-rh43-truths-f3-n1-equals-n2-refuted.md) | Claim | REFUTED (witness: `N = 1` is the only case with no negative part) |
| [`F4 — "the complex partial sum never vanishes for N >= 2"`](tpp-rh43-truths-f4-complex-never-vanishes-refuted.md) | Claim | REFUTED (smallest witness `N = 2`, `t = pi/log 2`) |
| [`F5 — "\|S_N(t)\| grows like N^{1/2}"`](tpp-rh43-truths-f5-sqrt-n-growth-refuted.md) | Claim | REFUTED (certified value `\|S_{10^4}(1)\| = 7071.771405`; the growth is linear) |
| [`F6 — "the sum of positive parts minus the absolute sum of negative parts is the imaginary part"`](tpp-rh43-truths-f6-real-not-imaginary-part-refuted.md) | Claim | REFUTED (it is the **real** part: `P + M = Re S_N`) |
| [`F7 — "a balance point implies the *terms* can be split two-and-two"`](tpp-rh43-truths-f7-balance-implies-term-split-refuted.md) | Claim | REFUTED (witness `N = 6`, `t = 1.3625080873…`, exact subset-sum defect `0.169962576…`) |
| [`T16″ — the finite-N balance sees generic roots, not zeta zeros`](tpp-rh43-truths-generic-roots-not-zeta-zeros.md) | Theorem | PROVED + VERIFIED (numerical) |
| [`T12 — `\|S_N(t)\|/N -> 1/sqrt(1+t^2)`; no ordinary summability`](tpp-rh43-truths-linear-divergence-ledger.md) | Theorem | PROVED (paper argument, first-order Euler summation) + VERIFIED (numerical, certified values) |
| [`Theorem 12 (linear divergence)`](tpp-rh43-truths-linear-divergence.md) | Theorem | PROVED (paper argument, first-order Euler summation) + VERIFIED (numerical, certified values) |
| [`T15 — the N -> infinity asymptotic of the split`](tpp-rh43-truths-n-to-infinity-asymptotic-split.md) | Theorem | PROVED (identities) + VERIFIED (numerical); at `σ = 0` the ratio does not settle |
| [`T3 — N = 1 is degenerate (`Re S_1 ≡ 1`)`](tpp-rh43-truths-n1-degenerate-ledger.md) | Theorem | PROVED (paper argument, from the definition) + VERIFIED (numerical) |
| [`Theorem 2 (N = 1 is degenerate)`](tpp-rh43-truths-n1-degenerate.md) | Theorem | PROVED (paper argument, from the definition); VERIFIED (numerical) |
| [`T4 — N = 2 is balanced exactly at `t = pi/log 2` (the zero is tangential)`](tpp-rh43-truths-n2-balanced-ledger.md) | Theorem | PROVED (Lean, no `sorry`) + VERIFIED (numerical, 74-digit certified enclosures) |
| [`Theorem 3 (N = 2 is balanced, exactly, at `t = pi/log 2`)`](tpp-rh43-truths-n2-balanced-tangential.md) | Theorem | PROVED (Lean, no `sorry`); VERIFIED (numerical, 74-digit certified enclosures) |
| [`T5 — N = 3 is balanced via IVT, `Re S_3(5/2) < 0``](tpp-rh43-truths-n3-balanced-ledger.md) | Theorem | PROVED (Lean, no `sorry`, no numerical axiom) |
| [`Theorem 4 (existence of a balanced partial sum)`](tpp-rh43-truths-n3-existence-ivt.md) | Theorem | PROVED (Lean, no `sorry`, no numerical axiom); VERIFIED (numerical, certified sign change) |
| [`T6 — N = 4 is balanced via IVT, `Re S_4(12/5) < 0``](tpp-rh43-truths-n4-balanced-ledger.md) | Theorem | PROVED (numerically certified, paper argument); Lean formalises the `N = 3` witness only |
| [`Theorem 5 (the same route at N = 4)`](tpp-rh43-truths-n4-ivt-witness.md) | Theorem | PROVED (paper argument, numerically certified; Lean formalises the `N = 3` witness only) |
| [`T9 — the numeric four-part split is exact at a balance point`](tpp-rh43-truths-numeric-four-part-split.md) | Theorem | PROVED (paper argument, trivial algebra once T2 holds; Lean declarations named) |
| [`Theorem 11 (the numeric split is exact)`](tpp-rh43-truths-numeric-split-exact.md) | Theorem | PROVED (paper argument, trivial algebra once T2 holds; Lean declarations named) |
| [`T14 — the positive-values-only two-subset problem (ledger row)`](tpp-rh43-truths-positive-only-ledger.md) | Theorem | PROOF-SKETCH + VERIFIED (numerical, 15/15 checks); exact equality REFUTED at tested points, OPEN in general |
| [`T14 — the positive-values-only two-subset problem`](tpp-rh43-truths-positive-only-two-subset-problem.md) | Theorem | PROOF-SKETCH + VERIFIED (numerical, defect measured at 7 points, 15/15 checks); exact equality REFUTED at every tested point, OPEN in general |
| [`T16′ — the radial law at σ = 1/2: `P_N, \|M_N\| ~ (2/π)√N``](tpp-rh43-truths-radial-law-critical-line.md) | Theorem | PROVED (identities, radial law) + VERIFIED (numerical, measured constants) |
| [`T11 — S_2(pi/log 2) = 0 exactly`](tpp-rh43-truths-s2-exact-vanishing.md) | Theorem | PROVED (Lean, no `sorry`) + VERIFIED (numerical, 74-digit certified) |
| [`T10 — `S_3(t) != 0` for all `t``](tpp-rh43-truths-s3-nonvanishing-ledger.md) | Theorem | PROVED (Lean, no `sorry`; axiom audit `[propext, Classical.choice, Quot.sound]`) |
| [`Theorem 8 (algebraic independence at work)`](tpp-rh43-truths-s3-nonvanishing.md) | Theorem | PROVED (Lean, no `sorry`; `#print axioms` = `[propext, Classical.choice, Quot.sound]`) |
| [`T13 — the split convention changes the answer (imaginary split roots differ)`](tpp-rh43-truths-split-convention-changes-answer.md) | Theorem | VERIFIED (numerical; auditor check C7) |
| [`T2 — P + M = Re S_N; P = -M ⟺ Re S_N = 0; the four-piece reading`](tpp-rh43-truths-split-identity-and-balance-equation.md) | Theorem | PROVED (Lean, no `sorry`) |
| [`Theorem 1 (the split is an identity, and balance is a single equation)`](tpp-rh43-truths-split-is-an-identity.md) | Theorem | PROVED (Lean, no `sorry`; also VERIFIED numerically) |
| [`Theorem 11′ — the term-level two-and-two split fails at the certified roots`](tpp-rh43-truths-term-level-split-defects-n6.md) | Theorem | REFUTED (strict reading) + VERIFIED (exhaustive subset-sum) |
| [`Theorem 11′ (the term-level split fails, and this is a *different* question)`](tpp-rh43-truths-term-level-split-fails.md) | Theorem | REFUTED (strict reading) + VERIFIED (exhaustive subset-sum at the certified roots); the general question is OPEN |

## `tpp-rh044-handoff`

<a id="tpp-rh044-handoff"></a>

The rh044 handoff, recording the two claims the audit refuted: that the sharp cutoff converges at a zero in the practical sense, and that smoothing removes the fluctuations.

Source: [`rounds/rh044/HANDOFF.md`](../../research/twin-prime-parity/rounds/rh044/HANDOFF.md) &nbsp;·&nbsp; **2** files.

| file | kind | status |
|---|---|---|
| [`The sharp cutoff does not converge *at a zero* in the practical sense (constant `1/√(2t)`)`](tpp-rh044-handoff-fact-1-sharp-cutoff-constant.md) | Claim | REFUTED (the constant `1/√(2t)` is corrected to `1/\|s−1\| = 1/√(1/4+t²)` in §0.5 of the same file) |
| [`Smoothing removes the fluctuations`](tpp-rh044-handoff-fact-2-smoothing-removes-fluctuations.md) | Claim | REFUTED (the smoothed error keeps the `√N` growth; only the constant is rescaled) |

## `tpp-rh044-readme`

<a id="tpp-rh044-readme"></a>

The rh044 round on smoothing the explicit formula: the sharp cutoff as the Euler–Maclaurin main term, the smoothing law, why exponential accuracy needs the functional equation, and zero localisation.

Source: [`rounds/rh044/README.md`](../../research/twin-prime-parity/rounds/rh044/README.md) &nbsp;·&nbsp; **5** files.

| file | kind | status |
|---|---|---|
| [`The sharp cutoff is the Euler–Maclaurin main term`](tpp-rh044-readme-fact-1-sharp-cutoff-euler-maclaurin.md) | Theorem | PROVED (paper argument, Euler–Maclaurin; checked to 5 digits at `N = 10^5`) |
| [`The smoothing law — the round's main result`](tpp-rh044-readme-fact-2-smoothing-law.md) | Theorem | VERIFIED (numerical, 5–7 digits at `N = 10^5`) |
| [`Exponential accuracy needs the functional equation`](tpp-rh044-readme-fact-3-exponential-accuracy.md) | Theorem | CITED (literature, classical theta identity — Riemann 1859; independently verified to `5.7·10^{−69}`) |
| [`Zero localisation`](tpp-rh044-readme-fact-4-zero-localisation.md) | Claim | VERIFIED (numerical; both routes agree to the `1e-44` bisection floor) |
| [`The zero count`](tpp-rh044-readme-fact-5-zero-count.md) | Claim | VERIFIED (numerical, with caveat) |

## `tpp-rh044-truths`

<a id="tpp-rh044-truths"></a>

The rh044 truth table: the four consequences of the smoothing analysis — universal `√N` growth, smoothing buying only a constant, the residual's closed form, and the condition for bounded error.

Source: [`rounds/rh044/truths.md`](../../research/twin-prime-parity/rounds/rh044/truths.md) &nbsp;·&nbsp; **13** files.

| file | kind | status |
|---|---|---|
| [`Consequence 1 — the `√N` growth is universal`](tpp-rh044-truths-consequence-1-sqrt-n-growth-universal.md) | Corollary | VERIFIED (numerical, last-decade exponent `0.5000` for every weight tested) |
| [`Consequence 2 — smoothing buys only a constant`](tpp-rh044-truths-consequence-2-smoothing-buys-only-constant.md) | Corollary | VERIFIED (numerical) |
| [`Consequence 3 — the residual's closed form`](tpp-rh044-truths-consequence-3-residual-closed-form.md) | Corollary | VERIFIED (numerical; constants and slopes fitted) |
| [`Consequence 4 — bounded error would need `M_φ(s) = 0``](tpp-rh044-truths-consequence-4-bounded-error-vanishing-mellin.md) | Corollary | PROVED (paper argument) |
| [`R1 — the sharp fluctuation constant is `1/√(2t)``](tpp-rh044-truths-r1-sharp-fluctuation-constant.md) | Claim | REFUTED (false by a factor 2.66 at `t = 14.1347`) |
| [`R2 — "smoothing removes the `√N` fluctuation; the smoothed error is `O(N^{−1/2})`"`](tpp-rh044-truths-r2-smoothing-removes-sqrt-n.md) | Claim | REFUTED (measured last-decade exponents `0.5000` for all six weights) |
| [`R3 — the scaled ratio `\|S_N\|·√(2t)/√N → 1``](tpp-rh044-truths-r3-sharp-scaled-ratio-limit.md) | Claim | REFUTED (measured `0.37592469` and `0.30835845` against the claimed limit `1`) |
| [`R4 — the theta identity `ζ(s) = 1/(s−1) + 1/s + …``](tpp-rh044-truths-r4-theta-identity-correction.md) | Claim | REFUTED (off by exactly `1/s`: at `s = 2` it returns `1.547197551`) |
| [`T4 — zero localisation`](tpp-rh044-truths-t4-zero-localisation.md) | Claim | VERIFIED (numerical; both routes agree to the `1e-44` bisection floor) |
| [`T5 — the zero count`](tpp-rh044-truths-t5-zero-count.md) | Claim | VERIFIED (numerical, with caveat) |
| [`Theorem 1 (Euler–Maclaurin, full first terms)`](tpp-rh044-truths-theorem-1-euler-maclaurin-first-terms.md) | Theorem | PROVED (paper argument, Euler–Maclaurin; each coefficient checked exactly and the limit VERIFIED numerically) |
| [`Theorem 2 (weight law)`](tpp-rh044-truths-theorem-2-weight-law.md) | Theorem | VERIFIED (numerical, 5–7 digits at `N = 10^5`) |
| [`Theorem 3 (Riemann's theta identity)`](tpp-rh044-truths-theorem-3-riemann-theta-identity.md) | Theorem | CITED (literature, classical — Riemann 1859; independently re-verified numerically) |

## `tpp-rh45-handoff`

<a id="tpp-rh45-handoff"></a>

The rh45 handoff, citing the three forms of the explicit formula: the exact form, the per-zero Riemann–von Mangoldt count, and the smoothed zero count.

Source: [`rounds/rh45/HANDOFF.md`](../../research/twin-prime-parity/rounds/rh45/HANDOFF.md) &nbsp;·&nbsp; **3** files.

| file | kind | status |
|---|---|---|
| [`The explicit formula (exact form)`](tpp-rh45-handoff-explicit-formula-exact-form.md) | Theorem | CITED (literature) |
| [`The per-zero count (Riemann–von Mangoldt)`](tpp-rh45-handoff-riemann-von-mangoldt-count.md) | Theorem | CITED (literature) |
| [`The smoothed zero count`](tpp-rh45-handoff-smoothed-zero-count.md) | Theorem | CITED (literature) |

## `tpp-rh45-readme`

<a id="tpp-rh45-readme"></a>

The rh45 round that repaired the explicit formula: the instrument and the correct form of the formula, the clean unconditional counting core, what the first draft got wrong, and the explicit statement that there is no parity-problem advance.

Source: [`rounds/rh45/README.md`](../../research/twin-prime-parity/rounds/rh45/README.md) &nbsp;·&nbsp; **5** files.

| file | kind | status |
|---|---|---|
| [`The instrument — and the correct form of the formula`](tpp-rh45-readme-correct-explicit-formula.md) | Theorem | VERIFIED (numerical, ≥ 20 digits on four kernels) |
| [`The counting formula (the clean unconditional core)`](tpp-rh45-readme-counting-formula.md) | Theorem | VERIFIED (numerical, twice; exact form to `1e−20`) |
| [`What my first draft got wrong`](tpp-rh45-readme-draft-errors-refuted.md) | Claim | REFUTED (numerical; isolated by the round's auditor) |
| [`No parity-problem advance`](tpp-rh45-readme-no-parity-advance.md) | Claim | PROVED (paper argument, structural) |
| [`Three structural advantages over the partial-sum route`](tpp-rh45-readme-three-structural-advantages.md) | Claim | PROVED (paper argument; cost figures numerical, auditor C4.1) |

## `tpp-rh45-truths`

<a id="tpp-rh45-truths"></a>

The rh45 truth table: the correct explicit formula with its archimedean term, the counting formula as the robust core, the refutation of check C1e as stated, and how the formula bypasses the rh43/rh044 obstruction.

Source: [`rounds/rh45/truths.md`](../../research/twin-prime-parity/rounds/rh45/truths.md) &nbsp;·&nbsp; **8** files.

| file | kind | status |
|---|---|---|
| [`How the explicit formula bypasses the rh43/rh044 obstruction (T4)`](tpp-rh45-truths-bypasses-sqrt-n-obstruction.md) | Claim | PROVED (paper argument, structural; numerical cost witness from auditor C4.1) |
| [`C1e (Cauchy `a = 1/2` to 20 digits) is refuted as stated`](tpp-rh45-truths-cauchy-boundary-case-refuted.md) | Claim | REFUTED (as stated; the kernel is on the boundary) |
| [`The correct explicit formula`](tpp-rh45-truths-correct-explicit-formula.md) | Theorem | VERIFIED (numerical, ≥ 20 digits on four kernels; auditor's independent route, 20–63 digits) |
| [`The counting formula (T2/T3, the robust core)`](tpp-rh45-truths-counting-formula.md) | Theorem | VERIFIED (numerical, twice; exact form to `1e−20`) |
| [`The first draft's explicit formula is wrong twice`](tpp-rh45-truths-draft-formula-refuted.md) | Claim | REFUTED (numerical witnesses; auditor's decomposition C1d) |
| [`The zeros (T2)`](tpp-rh45-truths-first-zeros-32-digits.md) | Theorem | VERIFIED (numerical, 32–33 digits; independent route, no `mp.zetazero`) |
| [`Parity problem (T4, negative)`](tpp-rh45-truths-no-parity-advance.md) | Claim | PROVED (paper argument, structural; numerical measurements included) |
| [`C4.1 (`N ≳ T²` suffices) is refuted`](tpp-rh45-truths-sqrt-n-cost-criterion-refuted.md) | Claim | REFUTED (numerical: no sign change within `10^{−3}` of `γ₁` for `N` up to `10^6`) |

## `tpp-rh46-readme`

<a id="tpp-rh46-readme"></a>

The rh46 round on two-point Chowla: the trivial bound and its sharpness witness, the finite-prefix indeterminacy, the logarithmic Chowla theorem checked finitely, and the failure of the Euler product.

Source: [`rounds/rh46/README.md`](../../research/twin-prime-parity/rounds/rh46/README.md) &nbsp;·&nbsp; **6** files.

| file | kind | status |
|---|---|---|
| [`§1.1 — the correlation of `λ ≡ 1` is exactly `x`, so `o(x)` is not formal`](tpp-rh46-readme-correlation-zero-asymptotic-false.md) | Theorem | PROVED (Lean, `Rh46/Chowla.lean`: `corrAsymptotic_zero_false`) |
| [`§1.3 — logarithmic Chowla `(1/log x) Σ_{n≤x} λ(n)λ(n+h)/n = o(1)` (known theorem)`](tpp-rh46-readme-logarithmic-chowla.md) | Theorem | CITED (literature: Tao 2015/2016; Matomäki–Radziwiłł–Tao) + VERIFIED (numerical, checks to `3·10⁷`) |
| [`§1.4 — prefix agreement does not determine the correlation asymptotic`](tpp-rh46-readme-prefix-agreement-indeterminacy.md) | Theorem | PROVED (Lean, `slice_agree`, `corrSlice_eq_corr_of_lt`) + VERIFIED (numerically to the strongest form, auditor A1, `10⁸` prefixes) |
| [`§1.5 — `n ↦ λ(n)λ(n+2)` is not multiplicative (no Euler product)`](tpp-rh46-readme-shift-product-not-multiplicative.md) | Theorem | PROVED (Lean, `Rh46/Chowla.lean`: `shiftProd_not_completely_multiplicative`) |
| [`§1.4 refinement — the sparse-modification bound `\|S_A(x) − S(x)\| ≤ 2·#{n ≤ x+2 : n ∈ A}``](tpp-rh46-readme-sparse-modification-bound.md) | Claim | REFUTED (corrected by the top-level programme README, §"Corrections this harvest forced": witness `A = {5}`, `x = 5`, `\|ΔS\| = 4 > 2`) |
| [`§1.1 — the trivial two-point bounds `\|S(x,h)\| ≤ x`, `S(x,0) = x``](tpp-rh46-readme-trivial-two-point-bounds.md) | Theorem | PROVED (Lean, `Rh46/Chowla.lean`: `corr_abs_le`, `corr_zero`) |

## `tpp-rh47-handoff`

<a id="tpp-rh47-handoff"></a>

The rh47 handoff's barrier claims B1–B3 in their original wording, including the 'additive character in `log n`' sentence later withdrawn, and the open questions that remain.

Source: [`rounds/rh47/HANDOFF.md`](../../research/twin-prime-parity/rounds/rh47/HANDOFF.md) &nbsp;·&nbsp; **9** files.

| file | kind | status |
|---|---|---|
| [`the barrier in one sentence (HANDOFF): every greedy-sine object is an "additive character in `log n`"`](tpp-rh47-handoff-barrier-additive-character-open.md) | Claim | OPEN (heuristic; the source's own record correction declares the phrasing too wide and keeps the impossibility OPEN) |
| [`B1 — the greedy support correlates with `λ`'s parity class: no mechanism known (HANDOFF)`](tpp-rh47-handoff-bridge-b1-no-mechanism-known.md) | Claim | OPEN (no mechanism known; the signed support's parity lock is a rigidity, not a bridge) |
| [`B2 — the zeta budgets separate index parity, not `Ω`-parity (HANDOFF)`](tpp-rh47-handoff-bridge-b2-index-parity-refuted.md) | Claim | REFUTED (direction: the budgets are sign-blind combinations of `ζ(p)`) |
| [`B3 — the greedy balance condition cannot force a correlation (HANDOFF)`](tpp-rh47-handoff-bridge-b3-balance-route-refuted.md) | Claim | REFUTED (as a route: the balance error is `√N·\|M_φ(s)\|` for every one-sided weight, and the correlation is not multiplicative) |
| [`H1 — the greedy support is Sylvester-sparse (the round's own new theorem)`](tpp-rh47-handoff-h1-sylvester-sparse-support.md) | Theorem | PROVED (paper argument; the numerical legs — `max A ≥ s₂₀`, the density, the controls — are VERIFIED) |
| [`H2 — the parity classes on twin-prime candidates stay balanced`](tpp-rh47-handoff-h2-parity-classes-balanced.md) | Claim | VERIFIED (numerical, rh46: ratio `0.9942` at `10⁵`, `0.9989` at `10⁶`) |
| [`H3 — the three bridges B1, B2, B3 all fail`](tpp-rh47-handoff-h3-bridges-fail.md) | Claim | REFUTED (numerical; no signal, index parity invisible to the correlation, no Euler product) |
| [`H4 — the goal cannot be reached by the greedy-sine programme as it stands (honest conclusion)`](tpp-rh47-handoff-h4-goal-unreachable-open.md) | Claim | OPEN (honest conclusion; the source's own audit keeps the impossibility heuristic and OPEN) |
| [`record correction: one-point Chowla is equivalent to PNT (HANDOFF)`](tpp-rh47-handoff-one-point-chowla-pnt.md) | Claim | CITED (literature; the source asserts the equivalence without proof or named attribution) |

## `tpp-rh47-readme`

<a id="tpp-rh47-readme"></a>

The rh47 round summary: the corrected barrier (sign-blind alphabet, no arithmetic input), the bridges B1–B3 and their refutations, and the Sylvester-sparsity of the greedy support.

Source: [`rounds/rh47/README.md`](../../research/twin-prime-parity/rounds/rh47/README.md) &nbsp;·&nbsp; **6** files.

| file | kind | status |
|---|---|---|
| [`the barrier in one sentence (README): every greedy-sine object is an "additive character in `log n`"`](tpp-rh47-readme-barrier-additive-character-open.md) | Claim | OPEN (heuristic; the README's own record correction declares the phrasing too wide and keeps the impossibility OPEN) |
| [`B1 — the greedy support carries no `λ`-parity signal (README)`](tpp-rh47-readme-bridge-b1-no-signal.md) | Claim | REFUTED (no signal above a size-matched control) |
| [`B2 — the zeta budgets do not carry parity information (README)`](tpp-rh47-readme-bridge-b2-index-parity-independent.md) | Claim | REFUTED (index parity and `Ω`-parity are independent; max relative deviation `<1%`) |
| [`B3 — the `ζ`-machinery does not apply to the correlation (README): no Euler product`](tpp-rh47-readme-bridge-b3-no-euler-product.md) | Claim | REFUTED (no Euler product; `D(2)` differs from the naive product by `≈2.01`, beyond the tail bound) |
| [`record correction: one-point Chowla is equivalent to PNT`](tpp-rh47-readme-one-point-chowla-pnt.md) | Claim | CITED (literature; the source asserts the equivalence without proof or named attribution) |
| [`the greedy support is Sylvester-sparse (README §1.5)`](tpp-rh47-readme-sylvester-sparse-support.md) | Theorem | PROVED (paper argument; restatement of rh47 `truths.md` §1) |

## `tpp-rh47-truths`

<a id="tpp-rh47-truths"></a>

The rh47 truth table: the corrected barrier, the refutations of B1 and B2, the Euler-product failure for the correlation, and the round's remaining open question R2.

Source: [`rounds/rh47/truths.md`](../../research/twin-prime-parity/rounds/rh47/truths.md) &nbsp;·&nbsp; **9** files.

| file | kind | status |
|---|---|---|
| [`B1 — the greedy support carries no `λ`-parity signal`](tpp-rh47-truths-bridge-b1-no-lambda-parity-signal.md) | Claim | REFUTED (no signal; the nominal `z = −47.9` is killed by the size-matched controls) |
| [`B2 — the zeta budgets carry no `Ω`-parity information: index parity is independent of `Ω`-parity`](tpp-rh47-truths-bridge-b2-index-parity-independent.md) | Claim | REFUTED (index parity and `Ω`-parity independent; index parity is invisible to the correlation itself) |
| [`B3 — the `ζ`-machinery does not apply to the correlation: no Euler product`](tpp-rh47-truths-bridge-b3-no-euler-product.md) | Claim | REFUTED (the correlation is not multiplicative; the naive Euler product misses by `2.01438655` against a rigorous tail `1.84·10⁻⁵`) |
| [`the corrected barrier: a sign-blind alphabet with no arithmetic input`](tpp-rh47-truths-corrected-barrier-open.md) | Claim | OPEN (heuristic; the impossibility must stay OPEN, per the source's own correction 2) |
| [`the corrected sparse-modification bound `≤ 4·#{m ≤ x+2 : m ∈ A}``](tpp-rh47-truths-corrected-sparse-bound.md) | Theorem | PROVED (paper argument; the source states the corrected bound and its consequence directly) |
| [``\|A\| ≥ 20` forces `max A ≥ s₂₀` (the Sylvester sequence), a 106 721-digit number`](tpp-rh47-truths-max-support-sylvester-bound.md) | Corollary | VERIFIED (numerical, 0 violations in 53 159 consecutive pairs) |
| [`the rh46 sparse-modification bound `\|S_A(x) − S(x)\| ≤ 2·#{n ≤ x+2 : n ∈ A}` is false`](tpp-rh47-truths-rh46-sparse-bound-refuted.md) | Claim | REFUTED (witness `A = {5}`, `x = 5`: `\|ΔS\| = 4 > 2`) |
| [`the greedy support density is `≈ 3.9·10⁻⁵``](tpp-rh47-truths-support-density-3-9e-5.md) | Corollary | VERIFIED (numerical, 0 violations in 53 159 consecutive pairs) |
| [`the greedy support is Sylvester-sparse: `m_{i+1} ≥ m_i (m_i − 1) + 1``](tpp-rh47-truths-sylvester-sparse-support.md) | Theorem | PROVED (paper argument; the section heading tags it "PROVED/VERIFIED", the numerical leg being the two consequences) |
