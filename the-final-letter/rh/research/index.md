# `research/` — index

A map of everything under `research/`. Paths are relative to this file's
directory (`research/`). Three companion documents live beside this one:

* [`TODO.md`](TODO.md) — open work, ranked by tractability (010 + `open/HANDOFF.md`).
* [`truths.md`](truths.md) — the harvested ledger of proved results, with Lean links.
* [`open.md`](open.md) — current status of `twin-prime-parity/open/`.
* [`../research-journal.md`](../research-journal.md) — the **project-wide harvest of
  tractable work** (2026-10-11): candidate list, the chosen goal (OP-8/OP-9/OP-19
  compute extensions, `theorems/` harvest reconciliation, xi-horn citation debt), and
  the work log.

> **Read first:** [`twin-prime-parity/README.md`](twin-prime-parity/README.md) —
> the programme's own orientation, folder map, per-round status table and the six
> corrections `X1–X6` the harvest forced on the round records.

---

## 0. The whole tree at a glance

```
research/
├── index.md  TODO.md  truths.md  open.md     ← this document set
├── zero_count.py, u1.npy, u2.npy, z1000_1100.npy    loose numerics (unattached)
├── publish/001-von-mangoldt-sieves/   published paper + reference impl + Lean companion
├── publish/002-…-012-…                the truths.md ledger §2–§12, packaged one folder per item
├── publish/014-two-point-chowla/      published paper + reference impl + Lean companion
├── shift2-audit/                      "what would it take" audit of the shift-2 odd core
├── various/                           legacy reconnaissance, A/B dialogues, source papers
└── twin-prime-parity/                 the main programme archive (rh40–rh47 + 001–010)
    ├── README.md                    master orientation
    ├── HANDOFF.md                   duplicate of open/HANDOFF.md (see §8)
    ├── dictionary/00–05             the reference dictionary
    ├── checks/06                    register of numerical checks
    ├── open/                        open-problems register + OP-05/OP-06 + Lean
    ├── cone/                        cone residue / shift-2 deconstruction
    ├── archive/INDEX.md             pointer index into rounds/
    ├── theorems/                    rh42 three-thresholds paper (HTML)
    ├── lab/                         geometric & harmonic decomposition lab
    ├── rounds/rh40 … rh47           the harvested round artefacts
    └── 001 … 010                    numbered session / round folders
```

| area | one line | status |
|---|---|---|
| [`publish/001-von-mangoldt-sieves/`](publish/001-von-mangoldt-sieves) | *Sieves for the von Mangoldt Function* — paper, code, Lean companion | **published / closed** |
| [`publish/014-two-point-chowla/`](publish/014-two-point-chowla) | *The Finite-Prefix Indeterminacy Theorem for the Two-Point Liouville Correlation* — paper, code, Lean companion | **published / closed** |
| [`002-greedy-digit-word/`](publish/002-greedy-digit-word) | *greedy digit word and the complexity law* — truths.md §2, packaged | **published** |
| [`003-budgets-reachability-tau/`](publish/003-budgets-reachability-tau) | *budgets, reachability and the Tau alphabet* — truths.md §3, packaged | **published** |
| [`004-balance-equal-split/`](publish/004-balance-equal-split) | *partial sums at Re S = 0 and the equal split* — truths.md §4, packaged | **published** |
| [`005-smoothing-bridge/`](publish/005-smoothing-bridge) | *the smoothing bridge* — truths.md §5, packaged | **published** |
| [`006-explicit-formula-routes-abc/`](publish/006-explicit-formula-routes-abc) | *the explicit formula and Routes A/B/C* — truths.md §6, packaged | **published** |
| [`007-two-point-chowla/`](publish/007-two-point-chowla) | *two-point Chowla and the finite-prefix theorem* — truths.md §7, packaged | **published** |
| [`008-parity-barrier/`](publish/008-parity-barrier) | *greedy sine vs the parity barrier* — truths.md §8, packaged | **published** |
| [`009-op5-op6-asymptotics/`](publish/009-op5-op6-asymptotics) | *OP-5 and OP-6, resolved* — truths.md §9, packaged | **published** |
| [`010-generalisations/`](publish/010-generalisations) | *generalisations: character weights, shift-2, angle parity* — truths.md §10, packaged | **published** |
| [`011-von-mangoldt-sieves/`](publish/011-von-mangoldt-sieves) | *sieves for the von Mangoldt function* — truths.md §11, packaged | **published** |
| [`012-cone-shift2-thresholds/`](publish/012-cone-shift2-thresholds) | *cone, shift-2 core and the three thresholds* — truths.md §12, packaged | **published** |
| [`shift2-audit/`](shift2-audit) | audit of the shift-2 odd core; corrects an MRT misattribution | **closed audit** |
| [`various/`](various) | pre-programme reconnaissance and the greedy-sine A/B dialogue | **legacy / closed** |
| [`twin-prime-parity/`](twin-prime-parity) | the programme rh40–rh47: greedy harmonic sine vs twin-prime parity | **goal not achieved; one clean theorem** |

---

## 1. Loose top-level files (unattached numerics)

| file | what it is |
|---|---|
| [`zero_count.py`](zero_count.py) | mpmath (25 dps) probe: Riemann–von Mangoldt zero count at `T = 300`, plus a Weil-type explicit-formula test (`Z = Σ ĝ(γ)` vs prime side and archimedean integral). Standalone; exploratory. |
| [`u1.npy`](u1.npy) | `float64`, shape `(78498,)` — one value per prime ≤ 10⁶. |
| [`u2.npy`](u2.npy) | `float64`, shape `(78498,)` — paired with `u1.npy`, same index space. |
| [`z1000_1100.npy`](z1000_1100.npy) | `float64`, shape `(81,)` — 81 consecutive ζ-zero ordinates in `(1000, 1100)`. |

No script in the tree references the `.npy` arrays; they are loose artefacts.

---

## 2. `publish/001-von-mangoldt-sieves/` — published first edition

*"Sieves for the von Mangoldt Function"* — self-contained; the only external
dependency is Mathlib.

| file | what it is |
|---|---|
| [`README.md`](publish/001-von-mangoldt-sieves/README.md) | folder guide, how to run the self-check, how to build the Lean file, list of formalised propositions |
| [`von-mangoldt-sieves.html`](publish/001-von-mangoldt-sieves/von-mangoldt-sieves.html) | the paper: Propositions 2.1–2.8 (support of `Λ`, divisor identity, Möbius inversion, non-additivity/multiplicativity, `Λ ≤ log`, `log rad`, Chebyshev `ψ`/`θ`, lcm identity, Dirichlet series) |
| [`von_mangoldt_sieves.py`](publish/001-von-mangoldt-sieves/von_mangoldt_sieves.py) | reference implementation + self-check of Algorithms A, B, B′, C; exits 0 iff all checks pass; stdlib only |
| [`VonMangoldtSieves.lean`](publish/001-von-mangoldt-sieves/VonMangoldtSieves.lean) | Lean companion: `support_ne_zero_iff`, `apply_prime_pow` (2.1), `divisor_identity` (2.2), `moebius_convolution` (2.3), `not_additive` / `not_multiplicative` / `le_log` (2.4) |

**Status: complete first edition.** 7 theorems, no `sorry`, no `axiom`.

---

## 3. `publish/014-two-point-chowla/` — published second edition

*"The Finite-Prefix Indeterminacy Theorem for the Two-Point Liouville Correlation"*
— self-contained; the only external dependencies are Mathlib (for the Lean
companion) and NumPy/mpmath (for the two Python programs).  It packages the
programme's one clean new theorem: no finite computation can decide whether
`Σ_{n≤x} λ(n)λ(n+2) = o(x)`.

| file | what it is |
|---|---|
| [`README.md`](publish/014-two-point-chowla/README.md) | folder guide: contents, what is proved / verified / open, how to run every check, references |
| [`finite-prefix-indeterminacy.html`](publish/014-two-point-chowla/finite-prefix-indeterminacy.html) | the paper (§1 the question; §2 the Liouville function and the trivial bound; §3 why the Dirichlet-series route fails; §4 the finite-prefix indeterminacy theorem; §5 the numerical record; §6 what is open; §7 supporting files) |
| [`chowla_two_point.py`](publish/014-two-point-chowla/chowla_two_point.py) | reference implementation + self-check: 30/30, exit 0, sieve to `10⁹` |
| [`independent_check.py`](publish/014-two-point-chowla/independent_check.py) | independent recomputation: 25/26 — the one non-pass is the recorded data correction (`S(10⁷) = 1246`, not the reconnaissance's `1244`) |
| [`Rh46/Chowla.lean`](publish/014-two-point-chowla/Rh46/Chowla.lean) | Lean companion: 462 lines, 37 theorems/lemmas, 7 definitions, no `sorry`/`axiom`/`native_decide`; imports `Mathlib` only |
| [`Rh46.lean`](publish/014-two-point-chowla/Rh46.lean), [`check.sh`](publish/014-two-point-chowla/check.sh) | root module and build script |
| [`logs/`](publish/014-two-point-chowla/logs) | the recorded runs |
| [`ROUND-NOTES.md`](publish/014-two-point-chowla/ROUND-NOTES.md) | the original round notes, kept for provenance |

## 4. `publish/002` … `publish/012` — the `truths.md` ledger, packaged

One folder per item of [`truths.md`](truths.md) §§2–12, numbered by item. Each folder is
self-contained: the item's ledger (`TRUTHS.md`, the §N section with its links re-pointed
inward), the Lean sources it cites, its Python scripts and recorded logs, and a
`check.sh` that builds the Lean development against Lean 4 + Mathlib alone. The only
external dependencies are Mathlib (Lean) and, where the numerics need it, NumPy/mpmath
or Pillow. Every folder carries a comprehensive `README.md`.

| folder | truths.md item | Lean |
|---|---|---|
| [`002-greedy-digit-word/`](publish/002-greedy-digit-word) | §2 — greedy digit word and the complexity law | `Rh41` (7 files) |
| [`003-budgets-reachability-tau/`](publish/003-budgets-reachability-tau) | §3 — budgets, reachability and the Tau alphabet | `Rh42` + `Rh41/DigitWord` |
| [`004-balance-equal-split/`](publish/004-balance-equal-split) | §4 — partial sums at Re S = 0 and the equal split | `Rh43` |
| [`005-smoothing-bridge/`](publish/005-smoothing-bridge) | §5 — the smoothing bridge | `Rh044` |
| [`006-explicit-formula-routes-abc/`](publish/006-explicit-formula-routes-abc) | §6 — the explicit formula and Routes A/B/C | `Rh45` (6 files) |
| [`007-two-point-chowla/`](publish/007-two-point-chowla) | §7 — two-point Chowla and the finite-prefix theorem | `Rh46` |
| [`008-parity-barrier/`](publish/008-parity-barrier) | §8 — greedy sine vs the parity barrier | — (no Lean layer: the item is paper + numerics) |
| [`009-op5-op6-asymptotics/`](publish/009-op5-op6-asymptotics) | §9 — OP-5 and OP-6, resolved | `Op56` (9 files) |
| [`010-generalisations/`](publish/010-generalisations) | §10 — generalisations: character weights, shift-2, angle parity | `Op57`, `Op58`, `Op59` |
| [`011-von-mangoldt-sieves/`](publish/011-von-mangoldt-sieves) | §11 — sieves for the von Mangoldt function | `VonMangoldtSieves` |
| [`012-cone-shift2-thresholds/`](publish/012-cone-shift2-thresholds) | §12 — cone, shift-2 core and the three thresholds | `ConeLean`, `TppLean` |

**Two of them restate earlier editions.** `007` is the same theorem as [`publish/014-two-point-chowla`](publish/014-two-point-chowla) and `011` is the same paper as [`publish/001-von-mangoldt-sieves`](publish/001-von-mangoldt-sieves); both exist because the packaging was done by item number. The earlier folders are the fuller editions and are cross-referenced from the new ones.

**`012` is the one item whose sources live outside `research/`** — at the workspace root `lean/`. They are copied here so the item packages like the others; the workspace originals are untouched.

---
## 5. `shift2-audit/` — closed audit of the shift-2 odd core

Audits the core `C(K) = Σ_{k≤K} λ(2k−1)λ(2k+1)`. Claims are labelled
CONFIDENT / PLAUSIBLE / UNVERIFIED.

| file | what it is |
|---|---|
| [`REPORT.md`](shift2-audit/REPORT.md) | the audit: §1 corrected logical geography; §2 mechanism audit (MR short intervals, entropy decrement, Selberg/Friedlander–Iwaniec, Perron, spectral/positivity); §3 gap statement; §4 what the `h = 1` proof has that the core lacks; §5 numerics; §6 confidence ledger; §7 sources |
| [`core_probe.py`](shift2-audit/core_probe.py) | Liouville sieve to `N` (default 10⁸); exact `S₂ = S₁ + C` decomposition, partial sums, running maxima, dyadic cancellation, local AP bias |
| [`core_probe2.py`](shift2-audit/core_probe2.py) | second-round probes: algebraic identities, constancy/run-length statistics, core bias |
| [`core_probe2.log`](shift2-audit/core_probe2.log) | output of the above (`EXIT=0`) |
| [`core_probe_N1e8.log`](shift2-audit/core_probe_N1e8.log) | `N = 10⁸` run; local bias `max z ≈ 4.02` at `q = 94`; `EXIT=0` |

**Headline finding (REPORT §0):** the brief's premise is false —
`Σ_{n≤x} λ(n)λ(n+1) = o(x)` is **not** a theorem of Matomäki–Radziwiłł (2015);
unweighted Chowla is open for all `k ≥ 2`. The exact split gives
**shift-2 ⟺ [h = 1] AND [odd core]**, a sufficiency, with **both halves open**.
This correction is carried into the programme as `ERRATUM-mrt-misattribution`
(see §7, `cone/`).

---

## 6. `various/` — legacy reconnaissance (pre-programme)

Earlier (Oct 2025 and before) material: explicit-formula numerics, the
greedy-harmonic-sine A/B dialogue, and captured literature.

| file | what it is |
|---|---|
| [`HANDOFF.md`](various/HANDOFF.md) | "The factor-complexity law of the greedy digit word" — defines the open law `p(L)`, records the dialogue's proved/disproved items. Dialogue closed; law developed in `rh40`/`rh41`. |
| [`qa.md`](various/qa.md) | "Original Questions on the Riemann Hypothesis" — 12 deliberately non-standard Q&As. |
| [`research-journal.md`](various/research-journal.md) | the mediated A/B dialogue journal: ground rules, Rounds 0–10, claim-status table, error ledger, the ten things that stand, the one unanimously identified open problem. |
| [`round1_verdict_agentB.md`](various/round1_verdict_agentB.md), [`round2_agentB.md`](various/round2_agentB.md), [`round5_agentB.md`](various/round5_agentB.md), [`round7_agentB.md`](various/round7_agentB.md), [`round10_agentB.md`](various/round10_agentB.md) | per-round adjudications of the dialogue (convention repair; retraction of the Legendre-polynomial error; the `1/(N+2)` telescoping and `p* = 1.7286…`; the squaring law; the closing verdict). |
| [`conrad.txt`](various/conrad.txt), [`conrad_clean.txt`](various/conrad_clean.txt), [`conrad_eulerprod.pdf`](various/conrad_eulerprod.pdf) | Keith Conrad, *Partial Euler products on the critical line* (Goldfeld √2 phenomenon, Chowla/Erdős equivalence). |
| [`mayer_zagier.txt`](various/mayer_zagier.txt), [`mayer_zagier.pdf`](various/mayer_zagier.pdf), [`mz_fixed.txt`](various/mz_fixed.txt) | Mayer–Zagier, *New points of view on the Selberg zeta function*. |
| [`mz_clean.txt`](various/mz_clean.txt) | **placeholder** — 3 bytes (`Y `); failed text extraction. |
| [`explicit_check.py`](various/explicit_check.py), [`explicit_fit.py`](various/explicit_fit.py), [`explicit_fit2.py`](various/explicit_fit2.py), [`explicit_gauss.py`](various/explicit_gauss.py), [`explicit_gauss2.py`](various/explicit_gauss2.py) | explicit-formula numerics with various kernels. |
| [`gue_small.py`](various/gue_small.py) | scans Riemann–Siegel `Z` on `[1500,1800]` for sign changes. |
| [`r10.py`](various/r10.py) | exact rational enumeration of `1/a + 1/b + 1/c = 1`. |

---

## 7. `twin-prime-parity/` — the main programme archive

**Question:** *can the greedy harmonic sine solve the parity problem for the
twin prime conjecture?* **Verdict: no — not by this programme as it stands**, and
the directory documents the precise reasons.

### 6.1 Top-level files

| file | what it is |
|---|---|
| [`README.md`](twin-prime-parity/README.md) | master orientation, folder map, reading order, per-round status table, the three take-away claims, corrections `X1–X6` |
| [`HANDOFF.md`](twin-prime-parity/HANDOFF.md) | **duplicate** of `open/HANDOFF.md` and `006/notes/HANDOFF.md` (see §8) |
| [`eta-euler-acceleration.html`](twin-prime-parity/eta-euler-acceleration.html) | "The η/Euler Route to ζ on the Critical Line" — the specification whose §6 defines the Routes A/B/C obligations used by `010/` |
| [`decomposition-lab-notes.md`](twin-prime-parity/decomposition-lab-notes.md), [`decomposition_lab.html`](twin-prime-parity/decomposition_lab.html), [`decomposition_lab_zeta_probe.py`](twin-prime-parity/decomposition_lab_zeta_probe.py) | the geometric/harmonic decomposition lab: what the Egyptian/harmonic tier can and cannot do |
| [`linarith-agent-prompt.md`](twin-prime-parity/linarith-agent-prompt.md) | the `linarith` discipline prompt used by the Lean rounds |

### 6.2 `dictionary/` — the reference dictionary

| file | what it is |
|---|---|
| [`00-dictionary.md`](twin-prime-parity/dictionary/00-dictionary.md) | **master index** — every term/theorem/barrier/witness with status and source |
| [`01-preliminaries.md`](twin-prime-parity/dictionary/01-preliminaries.md) | notation (`λ, μ, Λ, Ω`), elementary facts, analytic prerequisites `P1–P6` |
| [`02-greedy-harmonic-sine.md`](twin-prime-parity/dictionary/02-greedy-harmonic-sine.md) | the unsigned greedy word, the signed Tau reading, the helix, the sparsity theorem |
| [`03-parity-problem.md`](twin-prime-parity/dictionary/03-parity-problem.md) | the parity problem, Chowla/Elliott, the no-go theorem, literature status with citations (largest chapter) |
| [`04-zeta-relations.md`](twin-prime-parity/dictionary/04-zeta-relations.md) | budgets, Brown's criterion, the balance split, the failure of smoothing, the explicit formula |
| [`05-programme-barriers-and-harvest.md`](twin-prime-parity/dictionary/05-programme-barriers-and-harvest.md) | **capstone**: positive ledger `P1–P19`, the five bridges disposed of, the precise missing ingredient |

### 6.3 `checks/` — numerical-check register

[`06-numerical-checks.md`](twin-prime-parity/checks/06-numerical-checks.md):
every numerical check for rh42/rh43/rh044/rh45/rh46/rh47, its method, precision,
outcome, and **what it does not establish**. Reading rule: a finite computation
never establishes an asymptotic statement.

### 6.4 `open/` — see [`open.md`](open.md)

`open/` holds the 18-item open-problems register, the two resolved
problem notes (OP-05, OP-06), the OP-5/OP-6 Lean development and its (18 685-line)
development log. Full status: [`open.md`](open.md).

### 6.5 `cone/` — cone residue and shift-2 deconstruction

| file | what it is |
|---|---|
| [`ERRATUM-mrt-misattribution.md`](twin-prime-parity/cone/ERRATUM-mrt-misattribution.md) (+ `.html`) | corrects the misattributed MRT theorem: shift-2 is a sufficiency, not an equivalence |
| [`cone-critical-pair-greedy.md`](twin-prime-parity/cone/cone-critical-pair-greedy.md) (+ `.html`) | cone note 001: real lift of the signed greedy expansion, radial-pair greedy rule, the two-point residue at `p = 1/2` |
| [`residue-verdict.md`](twin-prime-parity/cone/residue-verdict.md) (+ `.html`) | ledger/verdict for the cone-residue goal; machine-checked labels via Lean |
| [`exceptional-set-probe.md`](twin-prime-parity/cone/exceptional-set-probe.md) (+ `.html`) | exceptional-set probe (carries the erratum banner) |
| [`shift-two-deconstruction.md`](twin-prime-parity/cone/shift-two-deconstruction.md) (+ `.html`) | shift-2 deconstruction (erratum banner) |
| [`shift-two-lateral-appendix.md`](twin-prime-parity/cone/shift-two-lateral-appendix.md) (+ `.html`) | lateral appendix to the deconstruction |
| `cone_critical_probe.py`, `exceptional_set.py`, `pair_census.py`, `parity_diagnostic.py`, `shift_two_split_check.py`, `make_html.py` | numerics and the HTML renderer |
| [`verify/`](twin-prime-parity/cone/verify) | 7 run logs, including the ConeLean build log |

### 6.6 `archive/`, `theorems/`, `lab/`

| path | what it is |
|---|---|
| [`archive/INDEX.md`](twin-prime-parity/archive/INDEX.md) | pointer index into `rounds/` (round → handoff/ledger/numerics/Lean), plus 9 corrections kept on record |
| [`theorems/tpp-rh42-three-thresholds-paper.html`](twin-prime-parity/theorems/tpp-rh42-three-thresholds-paper.html) | the internal theorem `pN < pP < p*` of the rh42 budget (ledger row T14) — **not** a twin-prime/parity result |
| [`lab/geometric-harmonic-lab.html`](twin-prime-parity/lab/geometric-harmonic-lab.html) + [`preview-s1.png`](twin-prime-parity/lab/preview-s1.png), [`preview-s2.png`](twin-prime-parity/lab/preview-s2.png), [`preview-s3.png`](twin-prime-parity/lab/preview-s3.png) | interactive decomposition lab and its three preview sheets |

### 6.7 `rounds/` — the harvested rounds

| round | subject | outcome | Lean |
|---|---|---|---|
| [`rh40/`](twin-prime-parity/rounds/rh40) | the factor-complexity law `p(L)` of the greedy digit word | K1 plateau + C1 regime (computed) | — |
| [`rh41/`](twin-prime-parity/rounds/rh41) | the law closed; Theorems 1–12 | the complexity law, the inverse-problem impossibility | **certified** (6 modules, ~120 thms) |
| [`rh42/`](twin-prime-parity/rounds/rh42) | the signed Tau alphabet, budgets, reachability, helix | budgets, Brown's criterion, thresholds `p*, q`, parity lock | **certified** (`Budget`, `Reachable`, `Tau`) |
| [`rh43/`](twin-prime-parity/rounds/rh43) | partial sums at `Re S = 0`; the equal split | balance ⟺ `Re S_N(t) = 0`; attainable `N ≥ 2`; linear divergence | **certified** (37 thms, `Balance.lean`) |
| [`rh044/`](twin-prime-parity/rounds/rh044) | smoothing (prose "rh44") | **smoothing does not remove `√N`**; the functional equation is needed | **certified** (`Smoothing.lean`, 32 thms) |
| [`rh45/`](twin-prime-parity/rounds/rh45) | the explicit formula, used explicitly | the correct Weil form (with the archimedean term); zeros from the formula | **certified** (`Rh45/*`) |
| [`rh46/`](twin-prime-parity/rounds/rh46) | two-point Chowla `Σ λ(n)λ(n+2)` | **OPEN**; finite-prefix indeterminacy proved; no Euler product | **certified** (`Rh46/Chowla.lean`, 37 thms) |
| [`rh47/`](twin-prime-parity/rounds/rh47) | greedy sine vs parity (the harvest) | Sylvester-sparsity theorem; bridges B1–B3 refuted; barrier stated | **empty** (`lean/Rh47/` has no module) |

Compatibility symlinks: `rounds/rh42/rh41 → ../rh41` and
`rounds/rh43/rh41 → ../rh41` (both resolve). The `README.md` also mentions
`rounds/xi-horn`; **that symlink does not exist** in the tree.

### 6.8 Numbered folders `001`–`010`

| folder | subject | status |
|---|---|---|
| [`001/`](twin-prime-parity/001) | `qa.md` — how the rh42 three-thresholds paper relates to twin-prime parity; the two different things called "parity" | closed reference |
| [`002/`](twin-prime-parity/002) | `HANDOFF.md` — cone residue, shift-2 deconstruction, label audit | closed |
| [`003/`](twin-prime-parity/003) | `HANDOFF.md` + repair scripts and a 200-document stratified adversarial re-audit of verification labels | closed |
| [`004/`](twin-prime-parity/004) | "The Riemann zeta function in greedy-harmonic coordinates" (`research.md`, `research-v2.md`, `_referee/`) — reconstructs the ordinary Dirichlet partial sum with explicit bounds; **not** a new representation | closed / exploratory |
| [`005/`](twin-prime-parity/005) | the digit-map programme's later phases: `debate.md`, `salvage.md` (net deliverable a **no-go**), `prime-cocycle.md`, `closed-form.md`, phase notes | closed (net negative) |
| [`006/`](twin-prime-parity/006) | OP-5/OP-6 Lean formalisation, **COMPLETE** — all three asymptotic theorems proved, `./check.sh --all` **8/8**, no `axiom`, no `sorry`, no `native_decide`; adds `Op56/FloorAsymptotic.lean` (O11); `notes/HANDOFF.md` is now a pointer to the canonical log | **complete** |
| [`007/`](twin-prime-parity/007) | generalisation #6: Dirichlet L-functions (`a_k = χ(k)k^{−p}`); limit law, threshold criterion, non-existence for `χ₃`, `χ₄` | attack complete; Lean 5/5 OK |
| [`008/`](twin-prime-parity/008) | automorphic/spectral attempt; verdict: does not break parity over ℚ (parity is broken over `𝔽_q[T]`, Sawin–Shusterman, but does not transfer) | attempt complete; barrier stands |
| [`009/`](twin-prime-parity/009) | angle parity and Ω-dependent signs; sparse-pair lemma machine-checked | complete; parity barrier stands |
| [`010/`](twin-prime-parity/010) | rh45 Routes A/B/C: certified zeros and the validated explicit formula | Route A complete · Route B windows `(½,15)` **and** `(½,33)` closed **unconditionally** (items T1, T2) · Route C validated |

**New in `010/` (this and the preceding pass).** Artifacts added to the round:

* [`010/verify/DISPOSITIONS.md`](twin-prime-parity/010/verify/DISPOSITIONS.md) — the formal
  disposition of over-strong/unsatisfiable audit criteria; **`C4.1`** (over-strong) and
  **`C1e`** (unsatisfiable as stated, restated as the convergent companion `C1f`) are both
  **RETIRED**; the audit's own scoring is left as the historical record (it now adjudicates
  *19/21 checks pass; 2 retired; failures: none*).
* [`010/rigorous/check_fast_mode.py`](publish/006-explicit-formula-routes-abc/rigorous/check_fast_mode.py) —
  validates the **certified fast engine mode** (`eta_interval.fast_mode()`,
  `work = 60` / `EPS = 1e-40`) against its enclosure contract; log:
  [`010/rigorous/check_fast_mode.log`](publish/006-explicit-formula-routes-abc/rigorous/check_fast_mode.log)
  (`0 fail(s)`). The engine validation logs `verify_engine.log` / `recheck_engine.log` were
  re-run and re-archived, both `0 fail(s)`.
* [`010/rigorous/T1_BLOCKER.md`](publish/006-explicit-formula-routes-abc/rigorous/T1_BLOCKER.md) — how the
  `T = 15` count was **made unconditional** (item T1, certified 2026-10-11): the engine's
  `1 − 2^{1−s}` representation is singular at `t = 2πk/ln 2` on the path's `Re s = 1` edge,
  fixed by routing near-`t_k` boxes to the rigorous local Taylor/Cauchy enclosure
  `zeta_local_box`; the note also records the earlier UNDECIDED run and the tightened
  curvature budget (`Σ Lf` `74776 → 2282.1`).
* [`010/rigorous/KERNEL_FINDINGS.md`](publish/006-explicit-formula-routes-abc/rigorous/KERNEL_FINDINGS.md) +
  [`kernel_probe.py`](publish/006-explicit-formula-routes-abc/rigorous/kernel_probe.py) — the **admissible-kernel
  question settled positively**: a compactly supported bump has `|LHS| = 2.0` and residual
  `−7.24·10⁻⁵⁴` at `K = 100`, refuting the literal negative claim.
* [`010/lean/Rh45/Archimedean.lean`](twin-prime-parity/010/lean/Rh45/Archimedean.lean) — the
  archimedean term formalised (digamma line, chain rule, Leibniz bound, Simpson assembly).
* [`twin-prime-parity/006/verify/op05_nmin_ceiling_false.py`](twin-prime-parity/006/verify/op05_nmin_ceiling_false.py)
  — the **451-digit counterexample** falsifying the exact ceiling law `nmin p = ⌈p/log 2 − 5/2⌉`.
* [`twin-prime-parity/open/lean/Op56/FloorAsymptotic.lean`](twin-prime-parity/open/lean/Op56/FloorAsymptotic.lean)
  — the floor-asymptotic meta-theorem (`O11`).
* [`twin-prime-parity/open/op06_ceiling_coefficient.py`](twin-prime-parity/open/op06_ceiling_coefficient.py)
  — the exact OP-6 `1/p` coefficient `c(e(p))` (`O4`).
* [`twin-prime-parity/open/lean/Op56/PhiFourth.lean`](twin-prime-parity/open/lean/Op56/PhiFourth.lean)
  — the fourth-order expansion (`O10`): **`Phi_fourth_order` is proved** (1528 lines, 0
  `sorry`/`axiom`/`native_decide`, 9/9 green), together with `phi_term_sharp4` (the former sole
  blocker), the `k⁸`/`m ≤ 8` tail machinery, and the model split `PhiMainS4_eq`.
* [`twin-prime-parity/open/op09_moduli.py`](twin-prime-parity/open/op09_moduli.py) +
  [`open/OP-09-other-moduli.md`](twin-prime-parity/open/OP-09-other-moduli.md) — `O9`:
  the `q`-independence at `r = 0` and the falsification of the "`1/log q`" claim.
* [`twin-prime-parity/006/verify/op05_nmin_ceiling_false.py`](twin-prime-parity/006/verify/op05_nmin_ceiling_false.py)
  — the 451-digit counterexample to the exact ceiling law (`O3`).
* [`010/lean/Rh45/RouteBAnalytic.lean`](twin-prime-parity/010/lean/Rh45/RouteBAnalytic.lean)
  — the analytic (symmetric) layer of Route B (`T8`): `ξ(1−s) = ξ(s)`, the logDeriv
  symmetries, the contour reduction `∮_{∂R} g = I₃ − conj I₃`, and `Im(I₃) = πZ` from the
  argument-principle count (the argument principle itself is a Mathlib gap, taken as a
  hypothesis); 010/lean is now **6/6** green.

### 7.9 The B.2-ranking pass (every ranked row of `open/07-open-problems.md` §B.2)

The ranking table in [`twin-prime-parity/open/07-open-problems.md`](twin-prime-parity/open/07-open-problems.md)
§B.2 was worked row by row; each row now carries an explicit disposition. New
artefacts produced by the pass:

* [`twin-prime-parity/rounds/rh47/lean/Rh47/Sparse.lean`](twin-prime-parity/rounds/rh47/lean/Rh47/Sparse.lean)
  (+ [`Rh47.lean`](twin-prime-parity/rounds/rh47/lean/Rh47.lean), and `check.sh` updated)
  — **rank 1 / OP-12**: `corrSparse_sub_corr_abs_le` (sharp bound
  `≤ 2·#{n ≤ x : n ∈ A ∨ n+h ∈ A}`), `corrSparse_sub_corr_abs_le_four`
  (`≤ 4·#{m ≤ x+h : m ∈ A}`), `rh46_sparse_bound_false` (the inherited form is false)
  and `corrSparse_bound_sharp`.  Axiom-clean, no `sorry`.
* [`twin-prime-parity/rounds/rh46/lean/Rh46/Chowla.lean`](twin-prime-parity/rounds/rh46/lean/Rh46/Chowla.lean)
  — **rank 2 / OP-11**: `corrSlice_sub_corr_self_eq` is now **proved** (with the
  pointwise helper `slice_term_sub`), so the file's last commented statement is gone;
  `exists_corrSlice_ne_corr` supplies the nonvanishing witness, and the root module
  [`Rh46.lean`](twin-prime-parity/rounds/rh46/lean/Rh46.lean) no longer records any
  unproved statement.  530 lines, 42 theorems.
* `twin-prime-parity/open/op07_*.py`, `op08_*.py`, `op09_*.py`, `op13_*.py`,
  `op14_*.py`, `op15_*.py`, `op19_*.py` — the finite experiments for ranks 6–12
  (details and verdicts in the register's §B.2 rows).
* [`twin-prime-parity/open/OP-01-04-16-17-18-tractability.md`](twin-prime-parity/open/OP-01-04-16-17-18-tractability.md)
  — the **2026 reassessment of the out-of-reach rows** (OP-1, OP-4, OP-16, OP-17, OP-18;
  OP-3 excluded): a 2020–2026 literature survey with citations, plus the OP-18
  definitional analysis. Verdict: none newly tractable; OP-18 reclassified ⚠️ as not
  well-posed as phrased.
* [`twin-prime-parity/open/op18_coupling_equivalence.py`](twin-prime-parity/open/op18_coupling_equivalence.py)
  — **OP-18 experiment** (exact sieve to `10⁸`, 6/6 PASS): periodic and
  finite-exponential-sum sign-blind classes have decaying `λ`-correlation; the
  arithmetic witness satisfies `S_A = (Σλ + C)/2` with `C` the open two-point
  correlation, making the circularity algebraic.

### 7.10 The B.2-ranking pass — dispositions by rank

| rank | id | disposition after the pass |
|---|---|---|
| 1 | OP-12 | **CLOSED** — corrected sparse bound + falsity witness machine-checked in `Rh47/Sparse.lean` |
| 2 | OP-11 | **CLOSED** — `corrSlice_sub_corr_self_eq` proved; no unproved statement remains in `Rh46/Chowla.lean` |
| 3 | OP-10 | **SETTLED (T6)** — re-verified by `kernel_probe.py` (9/9) |
| 4 | OP-5 | **SETTLED** (Lean `op5_nmin_asymptotic`; 9/9 green) |
| 5 | OP-6 | **SETTLED** (Lean `op6_reachable_fraction`; 9/9 green) |
| 6 | OP-3 / OP-19 | **discharged definitionally** into the well-posed OP-19; OP-19 **OPEN** with finite-range numerics only |
| 7 | OP-7 | **SETTLED** — the uniform height `t_N = π/log N` is proved elementarily for every `N ≥ 20` (no equidistribution), with certified explicit rational heights for `N = 3..19` |
| 8 | OP-8 | term-level defect **certified strictly positive for every `N = 3…76`** (smallest certificates `3.97·10⁻⁸` positive, `1.06·10⁻¹²` negative at `N=60`); general question OPEN (MITM ceiling `N ≈ 80`) |
| 9 | OP-14 | **resolved**: an identically-zero weight is impossible (analyticity), and an explicit complex weight with `\|M_φ\| ≤ 10⁻⁶` on `[0,50]` is exhibited |
| 10 | OP-13 | **SETTLED, direction corrected** — `A(N) = O_x(log log N)` follows from the take rule plus the proved squaring law (`rh41` §3 and the register had the inequality reversed); the `Ω` lower bound is the side that fails |
| 11 | OP-15 | **SETTLED — impossibility direction**: no halting alphabet of any kind realises `p(L) = cL` (finite support ⟹ rh41 Thm 4; the search re-verifies it on 3 096 cases); the `L < 20` sub-claim is **REFUTED** by `[1/6,1,1/3,1/6]`, `x=1` (`p(3)=8`) |
| 12 | OP-9 | zero-free **certified on `[0,10^4]` for `N = 4..10`** (extended 2026-10-11: lower bounds `1.6·10⁻⁶`–`6.4·10⁻⁵`; controls `N=2` zeros, `N=3` Lean); existence beyond `t=10^4` OPEN |
| 13 | OP-2 | **CLOSED editorially** — body text corrected in `rh46/README.md`, `rh47/README.md`, `rh47/HANDOFF.md`; dictionary entry already carried the transfer |
| 14 | OP-1, OP-4, OP-16, OP-17 / OP-18 | **out of reach** — a 2026 literature reassessment found none newly tractable; OP-18 is **⚠️ not well-posed as phrased** (its well-posed restriction is the existential dual of OP-19). See [`open/OP-01-04-16-17-18-tractability.md`](twin-prime-parity/open/OP-01-04-16-17-18-tractability.md) |

---

## 8. Known anomalies

Worth knowing before citing anything:

1. **`HANDOFF.md` — deduplicated (was a triplicate).** The OP-5/OP-6 development log
   now lives at exactly **one** path, [`twin-prime-parity/open/HANDOFF.md`](twin-prime-parity/open/HANDOFF.md)
   (984 803 B / 18 706 lines, carrying a **status banner** and a correction at `13.681`).
   The former duplicates [`twin-prime-parity/HANDOFF.md`](twin-prime-parity/HANDOFF.md) and
   [`twin-prime-parity/006/notes/HANDOFF.md`](twin-prime-parity/006/notes/HANDOFF.md) are now
   short **pointer files**. The **authoritative current state** remains
   [`006/handoff.md`](twin-prime-parity/006/handoff.md).
2. **`rounds/rh044/truths.md` is a Python script** (starts `#!/usr/bin/env python3`),
   not markdown — a mislabelled extension. Its `README.md` is the prose ledger.
3. **Duplicate ledgers.** `rh41`, `rh42`, `rh43`, `rh45` each carry both
   `TRUTHS.md` and `truths.md`, byte-identical.
4. ~~**Empty Lean layer:** `rounds/rh47/lean/Rh47/` contains no files~~ — **corrected:**
   `rounds/rh47/lean/Rh47/Sparse.lean` now machine-checks the corrected sparse bound
   (item OP-12), and `rounds/rh46/lean/Rh46/Chowla.lean` has no unproved statement left
   (item OP-11). The change was made in the B.2-ranking pass; see §7.9.
5. **`various/mz_clean.txt`** is a 3-byte failed extraction.
6. **`rounds/xi-horn`** is referenced by `twin-prime-parity/README.md` but does not
   exist inside `research/`.

*Previously listed here as stale and now corrected at the source:* the `open/lean`
docstrings that denied the three proved asymptotic theorems; the `open/07-open-problems.md`
placeholder note; the `open/07-open-problems.md` summary tally; the `open/HANDOFF.md`
tail (`13.681`, now also carrying a status banner); `rounds/rh47/truths.md` §5's claim
that `rh46/lean` "does not compile"; the `rh45` `17/21` count in
`checks/06-numerical-checks.md`; the **false `O(1/p)` error term** for `n_min(p)` in
`open/OP-05-nmin-asymptotic.md`, `open/OP-06-reachable-fraction.md`,
`open/07-open-problems.md`, `rounds/rh42/truths.md`, the two `open/*.html` expositions,
the two `open/*.py` scripts and `open/lean/README.md` (all now `O(1)`, with correction
notes); and `open/RESULTS.html`, which still described the three asymptotic theorems as
"stated, not proved" and the third-order layer as "not yet in Lean" — it now reports the
8/8 build and all three theorems proved. See [`open.md`](open.md)
§2.4/§7 and [`TODO.md`](TODO.md) §B.

---

## 9. Suggested reading order

1. [`twin-prime-parity/README.md`](twin-prime-parity/README.md) — the verdict and the map.
2. [`twin-prime-parity/dictionary/00-dictionary.md`](twin-prime-parity/dictionary/00-dictionary.md) — master index of terms/results.
3. [`truths.md`](truths.md) — the harvested proved ledger with Lean links.
4. [`open.md`](open.md) — the open-problems status.
5. [`TODO.md`](TODO.md) — what is left to do or prove, ranked.
6. [`twin-prime-parity/checks/06-numerical-checks.md`](twin-prime-parity/checks/06-numerical-checks.md) — what the numerics do and do not establish.
7. [`twin-prime-parity/010/README.md`](twin-prime-parity/010/README.md) — the newest round (Routes A/B/C).
