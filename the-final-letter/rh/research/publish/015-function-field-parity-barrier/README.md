# publish/015 — The function-field parity barrier, measured

Fifteenth published edition. This folder packages the **twin-prime-parity programme's three phases** — 018 (the
barrier), 019 (the residual character-sum identity) and 020 (the mechanisms) — together with every Lean proof,
every numeric check, and a self-contained manuscript.

**The headline is a negative result with a number on it.** No standard mechanism crosses the parity barrier in
this model; the best square-weight sieve is exactly `2^dim` times the truth (`4×` for twins), and the deficiency
is dimensional rather than a matter of local densities. The four mechanisms are closed by measurement:

| mechanism | failure | factor |
|---|---|---|
| `Λ²` square weight at level `n/2` | capped | `2^dim` (`4` for twins) |
| bilinear pair weight | indefinite form | no bound exists |
| degree windows | no `L^{−1/2}` cancellation | position-dependent |
| large sieve | slack in the second moment | `≍ n` |

Nothing here proves the twin prime conjecture, the parity problem, or the fixed-`q` asymptotic.

## What the item is

The programme transposes twin primes to `𝔽_q[x]`, where "primes" are monic irreducibles (**qrimes**) and the
twin count `T(n)` counts `f` with both `f` and `f+2` irreducible. Three phases:

* **018** — the barrier: the separation theorem (the zeta sees only linear statistics), the `d=4` cap, the
  closed forms, and the parity theorem (bounded-support divisor sums are periodic; the twin indicator is not).
* **019** — the residual character-sum identity, tested exactly in `ℤ[ζ_q]` at 80 primes: false as stated at
  `q ≡ 5 (mod 8)`, true in the corrected `χ₂(2c)` form, with hypothesis exactly `q ≡ 1 (mod 8)`.
* **020** — the mechanisms: the `2^dim` measurement, the four failure modes, the exact coprime-pair expansion,
  the degree grading, polynomial shifts, and the numeric support to `n = 14`.

The quantitative side: `T(n) = S(q)q^n/n² + E(n)` with `|E|/q^{n/2} ≤ 0.30` for every `n ≤ 14` at `q = 3`
(`T(13) = 3747`, `T(14) = 9510`), and `T(9) = 17265` at `q = 5`.

## Contents

| Path | What it is |
|---|---|
| [`manuscript.md`](manuscript.md) | **The paper**: abstract, model, the three barrier theorems, the four measurements, the exact side, the 019 identity, polynomial shifts, the main term, the ledger, the transfer demand, limitations, references. |
| [`LEAN-README.md`](LEAN-README.md) | The Lean layer: 61 modules across the three phases, what each proves, how to build. |
| [`check.sh`](check.sh) | The Lean harness: `./check.sh` (all), `./check.sh 020` (one phase), `./check.sh --list`. |
| [`018/`](018) | Phase 018: 110 check scripts, 45 Lean modules, 106 round notes, the library and tests. |
| [`019/`](019) | Phase 019: the exact `χ₂(2c)` test (80 primes), sympy cross-check, 14 unit tests, 2 Lean modules, and the HTML harvest. |
| [`020/`](020) | Phase 020: 9 check scripts, 14 Lean modules, 20 unit tests, 22 notes including the phase synthesis, and the recorded data. |
| [`figures/harvest.pdf`](figures/harvest.pdf) | The rendered 019 harvest (HTML → PDF); the HTML source is `019/harvest.html`. |
| [`submission/`](submission) | Submission sheet for solveathome.org (project 001, Twin Prime Conjecture): title, abstract, per-claim calibration, and the 6-page typeset PDF. |
| [`provenance/`](provenance) | The programme's own record: `rounds.log` (one line before and after every round), `objectives.json`, and the three synthesis documents. |
| [`logs/`](logs) | Recorded verification runs. |

## Verification

Everything runs from this folder. The only external dependency is a Lean 4 toolchain with Mathlib at
`$LEAN_PREFIX` (default `$HOME/lean`).

```sh
./check.sh                          # 61 Lean modules, multi-pass; expect all OK
python3 020/checks/audit.py         # 35 numeric claims; expect "0 failures"
python3 -m unittest discover -s 020/tests
python3 -m unittest discover -s 019/tests
python3 020/checks/linkcheck.py     # every relative link in the folder
python3 -m pytest 018/tests -q      # 552 pytest cases (~1 min)
```

The 018 **check** suite is 110 scripts and takes longer; run them individually, e.g.
`python3 018/checks/round3.py`. Each prints its result report to stdout and exits non-zero on failure.
`018/logs/` is included because the 018 pytest suite reads its degree log from there.

### Python output convention

**Results go to stdout; everything else goes to stderr.** Every script in this folder obeys it: banners,
section headers and progress lines are written to stderr, numeric tables and JSON summaries to stdout. No script
writes an output file — recorded inputs live in `020/data/` and are read, never rewritten. That is why

```sh
python3 020/checks/round107.py > results.txt
```

captures the numbers and nothing else.

## Provoked corrections

The package carries the record's own corrections, kept beside the claims they correct:

| claim | correction | where |
|---|---|---|
| the coprime-pair expansion truncated at `deg d + deg e ≤ n` | **invalid** — the boundary terms exist and are `0/1` | `020/notes/round108.md` |
| `ω` (distinct-factor) counter in round 109's constants | **over-counted repeated factors** | `020/notes/round109.md` erratum |
| "complete for the entire Selberg class" | **over-stated** — bounded-support weights only | `020/notes/round118.md`, `provenance/PROGRAMME-SYNTHESIS.md` |
| the 019 identity as stated | **false at `q ≡ 5 (mod 8)`**; corrected by `χ₂(2c)` | `019/README.md` |
| a closed form for the boundary stratum | **no constant exists** — `y²P(y)` has no limit | `020/notes/round119.md` |

## Provenance

Assembled at round 127 of phase 020. The source tree is the twin-prime-parity programme; this folder reproduces
its artefacts with relative links re-pointed inward and absolute paths removed. `provenance/rounds.log` records
every round of phase 020 with a line before and after; `provenance/objectives.json` carries the objective ledger
including the explicit `achieved` / `not_achieved` record.

The manuscript's claim set is the same as the programme's synthesis: **the barrier is a missing object, not a
missing estimate.** Four mechanisms are closed; the crossing requires two-dimensional equidistribution over
`𝔽_q[x]`, and a grading substitute over `ℤ`.
