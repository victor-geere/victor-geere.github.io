# The twin-prime parity programme — research directory

A single, self-contained reference for the research programme conducted in
`/Users/victor/workspace/rh` across rounds **rh40–rh47**: *can the greedy harmonic
sine solve the parity problem for the twin prime conjecture?*

**The programme's verdict, stated first.**  **No — not by this programme as it
stands.**  The directory documents the precise reasons, the barriers, the numerical
evidence, and the one clean new theorem the programme produced (the finite-prefix
theorem of rh46).  Nothing here solves, or claims to solve, the twin prime conjecture
or the parity problem.

---

## This folder is self-contained

Everything referenced from here lives **inside** this folder, and every link is
relative:

```
research/twin-prime-parity/
├── README.md                    this file
├── dictionary/00..05-*.md       the reference documents (the dictionary)
├── checks/06-numerical-checks.md
├── open/07-open-problems.md
├── archive/INDEX.md             pointer index into rounds/
└── rounds/                      the harvested round artefacts, moved here
    ├── rh40/ rh41/ rh42/ rh43/ rh044/ rh45/ rh46/ rh47/
    ├── rh42/rh41 -> ../rh41      compatibility symlinks, so the rounds'
    └── rh43/rh41 -> ../rh41      own cross-references keep resolving
```

The only external paths that remain are (i) the **Mathlib toolchain** (`$HOME/lean`,
required to elaborate the Lean files — it is a build dependency, not archive content)
and (ii) the **`xi-horn`** material, which is mentioned in `rounds/rh42/HANDOFF.md`
and is explicitly marked as living outside this archive.

**Validation:** a sweep of all **796 relative links in this folder** (re-counted after
the 2026 out-of-reach reassessment) finds **0 broken**; `rounds/rh43` runs from an
arbitrary working directory, and the moved `rounds/rh46/lean` and `rounds/rh47/lean`
layers re-elaborate clean (`[check] OK`, `--all` exit 0).

## Folder map (the round directories are not uniformly named)

| round label used in this directory | actual workspace folder | object |
|---|---|---|
| rh40, rh41 | `rounds/rh40/`, `rounds/rh41/` | the unsigned greedy word and its complexity law |
| rh42 | `rounds/rh42/` | the signed Tau alphabet, budgets, reachability, helix |
| rh43 | `rounds/rh43/` | partial sums at `Re(S) = 0`; the equal split |
| **rh044** | `rounds/rh044/` | smoothing (the "rh44" label in prose) |
| **rh45** | `rounds/rh45/` | the explicit formula |
| rh46 | `rounds/rh46/` | two-point Chowla |
| rh47 | `rounds/rh47/` | greedy sine vs parity (this harvest) |

Prose uses the short labels (rh44 = `rh044/`); every path in this directory is
relative and internal.

## The one-paragraph summary

The *greedy harmonic sine* (rh41/rh42) is a rich object: a proved factor-complexity
law, a parity-locked signed support, zeta-valued budgets with sharp completeness
thresholds, and an exact reachability theory.  The *parity obstruction* (rh46) is a
statement about a multiplicative function: `λ(n) = (−1)^{Ω(n)}`, with
`Σ_{n≤x}λ(n)λ(n+2) = o(x)` **open**.  The programme's own results show the two do not
meet: the greedy support carries no `λ`-parity signal above a size-matched control;
the ζ budgets separate *index* parity, which is invisible to the correlation; the
correlation has no Euler product; and the greedy support is **Sylvester-sparse**
(`m_{i+1} ≥ m_i(m_i−1)+1`), so it cannot be the positive-density witness that `o(x)`
would require.  What a successful attack needs is a *sign-blind rule with a
positive-density multiplicative coupling to `Ω`* — which is exactly what is missing.

## Reading order

| # | document | what it gives you |
|---|---|---|
| 1 | [`dictionary/00-dictionary.md`](dictionary/00-dictionary.md) | **the master index** — every term, theorem, barrier and witness, with statuses |
| 2 | [`dictionary/01-preliminaries.md`](dictionary/01-preliminaries.md) | the objects (λ, μ, Λ, Ω), notation, and the analytic prerequisites (P1–P6) |
| 3 | [`dictionary/02-greedy-harmonic-sine.md`](dictionary/02-greedy-harmonic-sine.md) | the greedy word, the Tau alphabet, the helix, the complexity law, the sparsity theorem |
| 4 | [`dictionary/03-parity-problem.md`](dictionary/03-parity-problem.md) | the parity problem, Chowla/Elliott, the literature status with citations |
| 5 | [`dictionary/04-zeta-relations.md`](dictionary/04-zeta-relations.md) | budgets, Brown's criterion, the balance split, smoothing, the explicit formula |
| 5b | [`dictionary/05-programme-barriers-and-harvest.md`](dictionary/05-programme-barriers-and-harvest.md) | **the capstone**: the positive ledger (P1–P19), the five bridges disposed of, and the precise missing ingredient |
| 6 | [`checks/06-numerical-checks.md`](checks/06-numerical-checks.md) | the register of numerical checks — and what each does **not** establish |
| 7 | [`open/07-open-problems.md`](open/07-open-problems.md) | the open-problems register and the research plan |
| 8 | [`archive/`](../../../archive) | harvested handoffs and ledgers of the individual rounds |

## Status of the programme, by round

| round | object | outcome | Lean |
|---|---|---|---|
| rh40 | the factor-complexity law `p(L)` of the greedy word | K1 plateau + C1 regime (computed) | — |
| rh41 | the same law, closed | Theorems 1–12 | **certified** (7 modules, 144 declarations) |
| rh42 | the signed Tau alphabet, budgets, reachability, helix | budgets, Brown's criterion, thresholds `p*, q`, parity lock | **certified** |
| rh43 | partial sums at `Re(S) = 0`; the equal split | balance ⟺ `Re S_N(t)=0`; attainable `N≥2`; linear divergence | **certified** (38 theorems) |
| rh044 | smoothing | **smoothing does not remove `√N`**; functional equation needed | **certified** |
| rh45 | the explicit formula, used explicitly | correct Weil form (with the archimedean term); zeros via the formula | **certified** |
| rh46 | two-point Chowla `Σλ(n)λ(n+2)` | **OPEN**; finite-prefix indeterminacy proved; no Euler product | **certified** (42 theorems; no unproved statement — OP-11 closed) |
| rh47 | greedy sine vs parity | the Sylvester-sparsity theorem; bridges B1–B3 refuted; barrier stated | **certified** — `lean/Rh47/Sparse.lean` proves the corrected sparse bound (OP-12) |

## The three claims to take away

1. **The goal is not reachable by this programme as it stands**, and the reason is
   structural rather than a lack of effort: every greedy-sine object is *sign-blind*
   and carries no arithmetic input ([`00`](dictionary/00-dictionary.md) F9).
2. **The one clean theorem** the programme produced for the parity side is the
   **finite-prefix indeterminacy**: two functions agreeing on `[1,10⁸]` can have
   `S''(x)/x → 1` while the true `S(x)/x` is believed to vanish — so no computation
   can decide `o(x)`.  Certified in Lean (`rh46/lean/Rh46/Chowla.lean`).
3. **What would count as progress** is a *new obstruction* (a proof that no sign-blind
   `log n`-rule can force a multiplicative correlation) — that is R2 in
   [`open/07-open-problems.md`](open/07-open-problems.md), and it is **open**.

## Corrections this harvest forced on the rounds' own records

Compiling this directory exposed errors in the source rounds; they are corrected here
(and pointer notes are left in the round files):

| # | the round's claim | correction | witness |
|---|---|---|---|
| X1 | "one-point Chowla `Σ_{n≤x}λ(n) = o(x)` is itself **OPEN**" (rh46 §1.3, rh47 §5.1) | **false** — it is **equivalent to PNT**, i.e. a **theorem**.  `λ = 1_squares ∗ μ`, so `Σ_{n≤x}λ(n) = Σ_{d≤√x} M(x/d²) = o(x)` follows from `M(y) = o(y)` | identity verified exactly (`x = 100, 1000`), and `L(x)/x → 0` measured; citation: Tao, [arXiv:1605.04628](https://arxiv.org/abs/1605.04628) |
| X2 | the sparse-modification bound `≤ 2·#{n ≤ x+2 : n ∈ A}` (rh46 §3) | **false** — correct is `2·#{n ≤ x : n ∈ A or n+2 ∈ A} ≤ 4·#{m ≤ x+2 : m ∈ A}` | witness `A = {5}`, `x = 5`: `\|ΔS\| = 4 > 2` (rh47 §3) |
| X3 | rh46's product-tail `1.80898647` | mis-derived (it bounds the *retained* primes); the correct omitted-prime tail is `≈ 1.84·10⁻⁵` | the conclusion (no Euler product) survives |
| X4 | rh45/truths "17/21, 4 failures" | stale — the log shows **19/21**; both `C1e` and `C4.1` are now **RETIRED** (over-strong / unsatisfiable as stated), so the current run is *19/21 checks pass; 2 retired; failures: none* (exit 0) | `rh45/verify/independent_check.log`, `010/verify/DISPOSITIONS.md` |
| X5 | rh47's "every greedy-sine object is an additive character in `log n`" | **too wide / imprecise** — `n^{−it}` is multiplicative on `(ℝ₊,×)` and the budgets are constants; read the barrier as *sign-blind, no arithmetic input* | rh47 audit C3a exhibits a greedy object with an *arithmetic* alphabet that does mix (circularly) |
| X6 | rh46's "k-point Chowla contradicts the twin-prime failure mode" | **withdrawn as unverified**; replaced by the citable `k=1 ⟺ PNT` and `Chowla ⇒ Sarnak` | [`dictionary/03-parity-problem.md`](dictionary/03-parity-problem.md) §4 |

As of the B.2-ranking pass, **X1 and X2 are now applied in the round body text** as
well as recorded here: `rounds/rh46/README.md` §1.3 no longer calls one-point Chowla
open, its §1.4 carries the corrected sparse bound, and the same correction is in
`rounds/rh47/README.md` and `rounds/rh47/HANDOFF.md`.  The corrected sparse bound is
machine-checked in `rounds/rh47/lean/Rh47/Sparse.lean` (item OP-12).

A **2026 reassessment of the out-of-reach register rows** — `OP-1`, `OP-4`, `OP-16`,
`OP-17`, `OP-18` (OP-3 excluded) — is in
[`open/OP-01-04-16-17-18-tractability.md`](open/OP-01-04-16-17-18-tractability.md):
a 2020–2026 literature survey with citations plus a definitional analysis.  **None is
newly tractable**; `OP-18` is reclassified ⚠️ *not well-posed as phrased* (its
well-posed restriction is the existential dual of `OP-19`), substantiated by the exact
experiment `open/op18_coupling_equivalence.py`.

## Ground rules for contributors

* Never present a finite numerical check as a proof of an asymptotic statement.
* Never claim progress on the twin prime conjecture or the parity problem without a
  proof of `Σ_{n≤x}λ(n)λ(n+2) = o(x)`.
* Every entry carries a status: `THEOREM` (Lean where noted), `NUMERICAL`,
  `HEURISTIC`, `OPEN`, `REFUTED` (with witness).
* Every link in this folder is **relative and internal** — the round sources,
  numerics, logs and Lean developments live under [`rounds/`](rounds) with thin
  compatibility symlinks (`rounds/rh42/rh41 → ../rh41`, `rounds/rh43/rh41 → ../rh41`,
  `rounds/xi-horn → ../../../xi-horn`) so that the rounds' own cross-references keep
  resolving.
* Refuted statements are **kept**, with their witnesses — see the per-round
  `truths.md` files and [`archive/`](../../../archive).

## Reproduction

Each round's artefacts live in its own folder with a `verify/` log:

Everything is inside this folder, so the commands are relative to it:

```
cd research/twin-prime-parity          # from /Users/victor/workspace/rh
python3 rounds/rh43/zeta_split.py          # the balance split      (64/64)
python3 rounds/rh044/smoothed_zeta.py      # smoothing              (59/59)
python3 rounds/rh45/explicit_formula.py    # the explicit formula
python3 rounds/rh46/chowla_two_point.py    # two-point Chowla       (30/30)
python3 rounds/rh47/greedy_parity_probe.py # the parity probes      (23/23)
cd rounds/rh46/lean && ./check.sh --all    # the certified Lean layer (42 theorems)
cd rounds/rh47/lean && ./check.sh --all    # the rh47 sparse-bound layer (OP-12)
```

The B.2-ranking pass (`open/07-open-problems.md` §B.2) adds the finite experiments
`open/op07_root_existence.py`, `op08_subset_defect.py`, `op09_complex_zero.py`,
`op13_almost_everywhere.py`, `op14_complex_weights.py`, `op15_nonmonotone.py` and
`op19_log_indicator.py`, each with a matching `.log`. The 2026 out-of-reach reassessment
adds `open/op18_coupling_equivalence.py` (`.log`) and
`open/OP-01-04-16-17-18-tractability.md`.
