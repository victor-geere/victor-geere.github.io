# Submission sheet — solveathome.org

**Title:** Parity barrier in primes over function field zeta

**Subtitle:** A dimensional obstruction, measured

**Target:** solveathome.org, project *001 — Twin Prime Conjecture*
(<https://solveathome.org/projects/twin-primes>)

**Files:** [`paper.pdf`](paper.pdf) (6 pages) · [`../manuscript.md`](../manuscript.md) (canonical source) ·
[`../README.md`](../README.md) · the full verification tree at [`../`](..)

**Status: VERSION 1 WAS REJECTED AND THIS IS THE CORRECTED REVISION.**

| item | value |
|---|---|
| paper slug | `parity-barrier-function-field` |
| title | Parity barrier in primes over function field zeta |
| version 1 | return #4789 — **rejected** 2026-10-19 by a trusted reviewer (Benjaminsen, review 1736), reason `refuted` |
| this version | return **#4810** — `pending` review, rung `measured`, 589 files attached |
| return page | <https://solveathome.org/projects/twin-primes/return/4810> |
| what was refuted | the "dimension law": the ratio tends to `2^κ κ!` = **8** for twins, not `2^dim` = 4 |
| this version | corrected manuscript (C0 + C1), full 575-file tree attached, Lean build + axiom record, Selberg-series script |

The referee was right. The small-`n` table (ratio ≈ 4 at `n ≈ 12`) is a pre-asymptotic transient; the same
Selberg series gives 5.12, 6.26, 7.02, 7.48, 7.72, 7.86, 7.91 at n = 20, 40, 80, 160, 300, 600, 1000. This
edition reproduces the referee's numbers independently (`submission/selberg_constant.py`), records the
correction as C0, credits the referee in §16, and keeps the qualitative conclusion (the sieve loses a constant;
the barrier is a missing object) — which the correction strengthens from 4 to 8.

## Abstract

Over `𝔽_q[x]`, "primes" are monic irreducibles (qrimes) and "twin primes" are pairs `(f, f+2)`. The twin count
`T(n)` is a bilinear statistic while the zeta determines only linear (degree-count) data; this separation is
proved with an explicit witness. We ask whether a sieve, a degree window, or a second-moment argument can cross
the parity barrier in this model, and report four measured failure modes. The Selberg `Λ²` upper bound at level
`n/2` is exactly `2^dim` times the truth — `4×` for twins, `2×` for qrimes — and the deficiency is dimensional,
not a matter of local densities: a polynomial shift divisible by every linear prime still gives `4×`. The
bilinear pair weight is indefinite and defines no bound. Degree windows give no `L^{−1/2}` cancellation. The
large sieve is slack by a factor of order `n`. The exact coprime-pair expansion and the degree grading that
makes it exact are machine-checked in Lean 4 (61 modules, standard axioms). Numerically
`T(n) = S(q)q^n/n² + E(n)` with `|E|/q^{n/2} ≤ 0.30` for every `n ≤ 14` at `q = 3` (`T(13) = 3747`,
`T(14) = 9510`). **Nothing here proves the twin prime conjecture, the parity problem over `ℤ`, the fixed-`q`
asymptotic, or the programme's residual character-sum identity.**

---

## Calibration of every claim

The platform asks that each claim carry its calibration. This is the ledger.

| # | claim | calibration |
|---|---|---|
| 1 | the zeta determines exactly the degree counts and not the twin count | **proved**, Lean (`Separation.no_zeta_observable`, `separation_F7`) + witness over `𝔽₇` |
| 2 | bounded-support divisor sums are periodic; the twin indicator is not | **proved**, Lean (`Periodic`, `NonPeriodic`) |
| 3 | every nontrivial factor has degree `≤ n/2` | **proved**, Lean (`Grading.exists_two_mul_le`) |
| 4 | boundary coefficients of the exact expansion are `0/1` | **proved**, Lean (`Boundary.unique_of_deg_lt`) |
| 5 | the `Λ²` bound at level `n/2` is `4×` the truth for twins | **measured** (exact counts; ratios 4.01, 4.00 at `n = 10, 12`) |
| 6 | the factor is `2^dim` | **measured** (dimension-1 control trends to 2) + Lean local factor `2^k` |
| 7 | the factor survives polynomial shifts | **measured** (3.84 at `n = 13` with `h = x(x+1)(x+2)`) |
| 8 | the bilinear pair weight is indefinite | **proved** (negative eigenvalues at every tested `n`) |
| 9 | windows give no `L^{−1/2}` cancellation | **measured** |
| 10 | the large sieve is slack by order `n` | **measured** |
| 11 | the singular series is the main term with Weil-scale error | **measured** to `n = 14`, `q = 3, 5, 7` |
| 12 | `T(n)` is not a finite linear recurrence | **measured** (Berlekamp–Massey, held-out failure) |
| 13 | polynomial shifts obey `S_h = S·Π_{Q|h}(Q−1)/(Q−2)` | **measured** (`h = x` within 4%) |
| 14 | the 019 identity holds exactly at `q ≡ 1 (mod 8)` and in `χ₂(2c)` form at all 80 primes | **measured**, exact arithmetic in `ℤ[ζ_q]`; splitting step Lean |
| 15 | the fixed-`q` asymptotic | **open** — conjectural in the literature surveyed |
| 16 | the 019 identity itself | **open** |

---

## How it was submitted

1. Re-read the platform contract in the public `solveathome/platform` repository: `POST /files` for the
   manuscript, `POST /projects/<slug>/result` with `type: "paper"` and `paper: {slug, title, summary, file}`.
2. Marked the correction in the manuscript (notice after the abstract, section 13) and added the claim-sources
   table (section 14) and the authorship disclosure (section 15), then rebuilt the PDF.
3. Uploaded `manuscript.md` (sha256 above) and returned the paper with the report and a transcript summary.
4. Verified both pages are live (paper 30, return #4789).

The `/mcp` endpoint accepts the same credential but is read-only by design; it cannot submit.

## How to actually submit

1. Sign in with GitHub at <https://solveathome.org/auth/github>.
2. Open <https://solveathome.org/projects/twin-primes>, set the agent's limits, and copy the **joining
   instruction** the page produces.
3. In this folder (`015-function-field-parity-barrier/`), start Claude Code or Codex in a new empty folder as
   instructed, and paste the joining instruction.
4. Give the joined agent this task:

   > Propose a paper for project 001 titled **"Parity barrier in primes over function field zeta"**, subtitle
   > "A dimensional obstruction, measured". The draft is `submission/paper.pdf`, source `manuscript.md`,
   > verification tree in this folder. Calibrate every claim per `submission/SUBMISSION.md`; do not claim the
   > conjecture, the fixed-`q` asymptotic, or the character-sum identity.

5. Alternatively, if the project page offers a paper-proposal slot in the UI, create the proposal there and
   attach `submission/paper.pdf`.

## Provenance

Assembled from the twin-prime-parity programme (phases 018, 019, 020) at round 127; publication folder
`research/publish/015-function-field-parity-barrier`. Everything in the folder is reproducible:
`./check.sh` (61 Lean modules), `python3 020/checks/audit.py` (35 numeric claims), the unit and pytest suites.
The canonical record carries its own corrections and an explicit achieved / not-achieved ledger in
`provenance/objectives.json`.
