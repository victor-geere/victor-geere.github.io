# Yakaboylu notes — literature dossier and formal core

**Status:** literature notes on a speculative synthesis. The elementary eta/prime geometry is reconstructed and formally checked; the Riemann-hypothesis claims are preserved as source claims, not promoted to theorems.  
**Source:** [`archive/maths/yakaboylu/intro.html`](../../archive/maths/yakaboylu/intro.html), with the companion pages `expanded.html`, `review.html`, `04-lemmas-01.html`, `05-lemmas-02.html`, the archived PDF `2408.15135v15.pdf`, and `check-topological-rigidity.py`.  
**Inventory:** [Scraps](../../scraps.html) item 31 · [Topic index](../README.md).

## What this topic is — and what it is not

This folder is **not a proof programme**. It is a set of literature notes built around Enderalp Yakaboylu's operator-theoretic approach to the Riemann zeros, wrapped in a proposed "prime-infused geometry" of the Dirichlet eta function. The archived `intro.html` presents a unified "geometric foliation proof of the Riemann Hypothesis"; `expanded.html` decomposes that strategy into eight conditions (C1)–(C8) and records C4 and C7 as the central obstacles; `05-lemmas-02.html` then **explicitly retracts** the naive argument-principle route to C4, concluding that "a complete proof of (C4) is still an open problem."

Accordingly the reconstruction here is deliberately small and honest:

- the **elementary** finite-`N` eta geometry is defined and proved (amplitude bound, monotonicity, threshold identity, weight symmetry);
- the **analytic** continuation, the functional equation, the operator construction, and every Riemann-hypothesis statement are recorded with their archived status;
- no row marked **Theorem** depends on an unproved source claim.

The archived source is a synthesis, not a refereed proof. Nothing below proves RH, GRH, twin primes, Chowla, Sarnak, or Elliott.

## Provenance and bibliographic caution

The folder mixes three layers of provenance:

| Layer | File(s) | What it is |
|---|---|---|
| Source paper | `2408.15135v15.pdf` | E. Yakaboylu, *Nontrivial Riemann Zeros as Spectrum*, arXiv:2408.15135v15 (math-ph / quant-ph). |
| Notes / synthesis | `intro.html`, `expanded.html`, `review.html` | An unauthored geometric gloss on the paper, claiming a proof strategy for RH. |
| Lemma drafts | `04-lemmas-01.html`, `05-lemmas-02.html` | Attempted lemmas for condition (C4); the second file retracts the first's argument-principle route. |
| Numerical script | `check-topological-rigidity.py` | A contour scan (`numpy`/`scipy`/`matplotlib`) that prints "numerically supports the rigidity"; it is not a proof and is not reproduced here. |

Two provenance defects are worth recording rather than silently repairing:

1. **Mismatched arXiv identifier.** `intro.html` §9 cites `arXiv:2309.00405` for the operator construction, while the PDF actually archived in the folder is `arXiv:2408.15135v15`, titled *Nontrivial Riemann Zeros as Spectrum*. The notes appear to conflate an earlier preprint with the archived version.
2. **The notes claim more than the paper.** The paper constructs an operator whose spectrum encodes the nontrivial zeros. The notes upgrade this to a "geometric proof" of RH whose only remaining step is an unproved positivity statement. That upgrade is not present in the paper and is not accepted here.

## Objects and notation

| Object | Definition | Status in this reconstruction |
|---|---|---|
| `η(s)` | `Σ_{n≥1} (−1)^{n−1} n^{−s}`, `s = σ + it`, `σ > 0` | Defining series; analytic continuation is a source claim. |
| `U(σ,t), V(σ,t)` | Real and imaginary parts of `η(σ+it)` | Defined by the real/imaginary series. |
| `η_N, U_N, V_N` | Truncation to `n ≤ N` | Finite objects used below. |
| `R_N(σ,t)` | `Σ_{n=2..N} (−1)^n n^{−σ} cos(t log n)` | The cosine sum in the real-zero equation. |
| `S_N(σ)` | `Σ_{n=2..N} n^{−σ}` | The amplitude bound. |
| `σ_N` | Unique root of `S_N(σ_N) = 1` | Computed exactly/high precision; limit is a source claim. |
| `σ_0` | Root of `ζ(σ_0) = 2`, `σ_0 ≈ 1.728647238998` | Numerical computation. |
| `ω(t)` | `t e^t / (1 + e^t)^2 = t / (4 cosh²(t/2))` | Formalised (oddness, positivity). |
| `M(s)` | `(1 − 2^{1−s})/(1 − 2^s) · 2^s π^{s−1} sin(πs/2) Γ(1−s)` | Corrected factor (the source displays an incomplete one). |
| `Λ(s)` | `Γ(s+1)(1 − 2^{1−s}) ζ(s)` | Source claim. |
| `ℛ` | Yakaboylu's operator on `L²[0,∞)` | Source claim; not constructed here. |
| `Ŵ` | The proposed positive-semidefinite intertwiner | Open (condition C7). |
| `C_Re, C_Im` | Zero curves `U = 0` and `V = 0` | Geometric language; no global theorem. |

### The exact sign chain

The source rewrites `U_N = 0` as

```
1 = Σ_{n=2..N} (−1)^n n^{−σ} cos(t log n) = R_N(σ,t).
```

Indeed `U_N = 1 − R_N`, because the `n = 1` term is `1`. Therefore

```
|R_N(σ,t)| ≤ Σ_{n=2..N} n^{−σ} = S_N(σ).
```

This is the only estimate the notes actually need for the "birth cascade". It is proved in Lean as `abs_R_le_S`, and its contrapositive is `R_ne_one_of_S_lt_one`: when `S_N(σ) < 1` the truncated equation has no solution.

## Theorem ledger

Every row marked **Theorem** is proved in [`lean/Topic.lean`](lean/Topic.lean) with no `sorry`, `axiom`, or `admit`. Every row marked **Computation** is tested in [`tests/test_programme.py`](tests/test_programme.py).

| # | Kind | Statement | Lean / test name |
|---|---|---|---|
| T1 | Theorem | `|R_N(σ,t)| ≤ S_N(σ)` for all real `σ,t` and all `N`. | `Yakaboylu.abs_R_le_S` |
| T2 | Theorem | If `S_N(σ) < 1` then `R_N(σ,t) ≠ 1` (no truncated real zero). | `Yakaboylu.R_ne_one_of_S_lt_one` |
| T3 | Theorem | For `N ≥ 2`, `σ ↦ S_N(σ)` is strictly decreasing. | `Yakaboylu.S_lt_S` |
| T4 | Theorem | For `N ≥ 2`, `S_N(σ) > 0` for every `σ`. | `Yakaboylu.S_pos` |
| T5 | Theorem | `S_N(0) = N − 1` for `N ≥ 1`; in particular `S_N(0) ≥ 1` for `N ≥ 2`. | `Yakaboylu.S_zero` |
| T6 | Theorem | `ω(−t) = −ω(t)` (the weight is odd). | `Yakaboylu.weight_odd` |
| T7 | Theorem | `0 < t ⇒ 0 < ω(t)` (positivity on the positive axis). | `Yakaboylu.weight_pos` |
| C1 | Computation | `S_N(0) = N − 1` and `S_5(2)` is the exact rational tail; `S_N` decreases in `σ`. | `test_amplitude_sum_exact_identity` |
| C2 | Computation | `max_t |R_N(σ,t)| ≤ S_N(σ)` on a grid, for `N ∈ {2,5,20}`. | `test_amplitude_bound_numeric` |
| C3 | Computation | For `N = 40`, `σ = 3` (where `S_N < 1`), `U_N > 0` on a grid. | `test_no_real_zero_below_threshold` |
| C4 | Computation | `σ_N` is increasing for the sampled `N ∈ {2, 3, 4, 5, 10, 20, 50, 100, 200}`, bounded above by `σ_0`, with `σ_0 − σ_200 < 0.02`. | `test_thresholds_increase_to_sigma_zero` |
| C5 | Computation | `σ_0 ≈ 1.7286472389981835` and `ζ(σ_0) = 2` to `10^{−25}`. | `test_sigma_zero_is_zeta_two_root` |
| C6 | Computation | The partial Euler product at `σ_0` approaches `2`, and at `σ = 2` approaches `π²/6`. | `test_euler_product_approaches_zeta_at_sigma_zero` |
| C7 | Computation | `ω(t) = t/(4 cosh²(t/2))` and `ω(−t) = −ω(t)` symbolically. | `test_weight_identity_and_symmetry_exact` |
| C8 | Computation | Edge cases `N = 1, 2`: invalid truncations raise, `σ_2 = 0`, and `η_N(1)` is the alternating harmonic number. | `test_edge_cases` |

The Lean names are all in the `Yakaboylu` namespace. `S_lt_S` is stated pointwise (`σ₁ < σ₂ ⇒ S σ₂ N < S σ₁ N`) rather than as `StrictAnti`, because the theorem needs the hypothesis `2 ≤ N`.

## Source claims (not theorems of this reconstruction)

These are recorded with their archived status. None is used as a hypothesis in the Lean file.

| # | Claim | Archived status | Reconstruction note |
|---|---|---|---|
| S1 | `η(s) = Σ (−1)^{n−1} n^{−s}` continues meromorphically, and `U, V` are conjugate harmonic functions. | Standard background, asserted | The finite truncations are used; the continuation is not formalised. |
| S2 | `C_Re` exists only in the strip `0 < σ < σ_0`, where `ζ(σ_0) = 2`; `C_Im` exists for all `σ > 0`. | Source claim | The threshold computation C4/C5 supports the numerical value; the "only in the strip" assertion is not proved. |
| S3 | `σ_N` is defined by `S_N(σ_N) = 1` and `σ_N ↗ σ_0`. | Source claim | Monotonicity and boundedness are computed (C4); the limit is not formalised. |
| S4 | Functional equation `η(s) = M(s) η(1−s)` and `|M(1/2+it)| = 1`, giving the "line-bundle constraint". | Source claim (standard) | Not formalised; `M` is not defined in Lean. |
| S5 | An off-line zero produces a symmetric quadruplet `σ_0 ± it_0`, `1−σ_0 ± it_0`. | Source claim | Standard consequence of S4 and conjugation, but not formalised here. |
| S6 | The argument foliation has index `+1` at zeros and index `−1` at the pole `s = 1`, with residue `ln 2`. | **Incorrect as stated** | `η` has no pole at `s = 1`: `η(1) = ln 2`. The simple pole with residue `1` belongs to `ζ`. The claimed `−1` singularity of `arg η` therefore needs correction or deletion. |
| S7 | A geometric/harmonic-measure contradiction (C4) with an off-line zero. | Source claim; **open** | The companion `05-lemmas-02.html` concludes the naive argument-principle route gives no contradiction. Recorded as open. |
| S8 | Conditions C1–C8, with C4 and C7 the hard steps. | Source claim | C1–C3 are elementary/standard; C4–C8 are not proved. |
| S9 | Yakaboylu's operator `ℛ` has eigenvalues `i(1/2 − ρ)` and eigenfunctions with `Ψ_s(0) = 0 ⇔ Λ(s) = 0`. | Source claim (from the PDF) | The operator is not constructed or formalised here. |
| S10 | A positive-semidefinite intertwiner `Ŵ ≥ 0` forces `Re(ρ) = 1/2`, proving RH. | Source claim; **open** | This is the central unproved positivity (C7). It is **not** a theorem of this reconstruction and is not claimed as one. |
| S11 | The construction generalises to a "Riemann operator" for every automorphic `L`-function, giving GRH. | Speculative | Open; no construction or proof is supplied. |
| S12 | On the critical line the zero spacing follows GUE statistics; Gram-point crossings follow `S(T)`. | Source claim | Numerical/empirical; not formalised. |
| S13 | "Topological rigidity" — no closed loops, all intersections converge to `σ = 1/2`. | Numerically suggested | The archived script scans finite-`N` contours and prints a rigidity verdict. A numerical contour scan cannot prove the global statement; recorded as open/empirical. |

**No archived claim about RH, GRH, twin primes, Chowla, Sarnak, or Elliott is presented as proved anywhere in this folder.** The only `Theorem` rows are the seven elementary Lean facts in the ledger above.

## Python layer

[`python/programme.py`](python/programme.py) provides:

- `amplitude_sum(N, σ)` — exact `S_N(σ)`;
- `cosine_sum(N, σ, t)` and `eta_real_part(N, σ, t)` — exact truncated `R_N` and `U_N`;
- `eta_truncation_at_one(N)` — exact alternating harmonic number;
- `max_abs_cosine(N, σ, ...)` — grid maximum of `|R_N|`;
- `sigma_threshold(N)` — bisection for `S_N(σ_N) = 1` (safe because `S_N` is strictly decreasing, T3);
- `sigma_zero()` — high-precision root of `ζ(σ) = 2`;
- `euler_product(σ, prime_bound)` — partial Euler product;
- `weight(t)` and `weight_closed(t)` — the two forms of `ω`.

`sympy` is used for exact algebra; `mpmath` is used only for roots, grid maxima, and the Euler product. The module has no import-time side effects.

Run:

```bash
cd the-final-letter/topics/yakaboylu-notes
python3 -m pytest -q tests
```

Current result: **8 passed** (about 1.2 s).

## Lean layer

[`lean/Topic.lean`](lean/Topic.lean) imports `Mathlib`, opens the `Yakaboylu` namespace, defines `S`, `R`, and `weight`, and proves T1–T7. It contains no `sorry`, `axiom`, or `admit`.

```bash
cd the-final-letter/topics/yakaboylu-notes
./lean/check.sh 2>&1 | tee lean/BUILD.log
```

Recorded build: [`lean/BUILD.log`](lean/BUILD.log) — `[check] OK Topic.lean`.

What is **not** formalised, and why:

- the meromorphic continuation of `η`, the functional equation, and the factor `M(s)` — these require a substantial complex-analysis development;
- the definition of `σ_N` as a root and the limit `σ_N → σ_0` — the Lean file proves monotonicity and the boundary value, but not the existence/uniqueness of the root or its limit;
- the operator `ℛ`, its spectrum, and the intertwiner `Ŵ` — these are source claims from the paper, not constructions available in this folder;
- the global foliation, extremal-length estimates, and positivity of `Ŵ` — all open.

## Open items and known gaps

1. **C7 / positivity of `Ŵ`.** This is the one step the notes say would prove RH. It is unproved in the source and entirely outside this reconstruction.
2. **C4 / extremal-length contradiction.** `05-lemmas-02.html` retracts the argument-principle shortcut; no replacement proof is given.
3. **The limit `σ_N → σ_0`.** Computed to high precision, not proved. A Lean proof would need the infinite tail and a convergence argument.
4. **The "pole at `s = 1`" error (S6).** The notes' index count for the foliation is wrong at `s = 1`; this should be corrected before the geometric argument is taken seriously.
5. **Global topological claims.** The `check-topological-rigidity.py` output is a finite-`N` contour scan, not a proof of "no closed loops" or of convergence to the critical line.
6. **GRH generalisation (S11).** Speculative; no construction is supplied.
7. **Bibliographic mismatch.** `intro.html` cites arXiv:2309.00405 while the archived PDF is arXiv:2408.15135v15; the notes should distinguish the two.

## Provenance

- [`scraps.html`](../../scraps.html) — inventory entry 31.
- [`topics/README.md`](../README.md) — all topic folders.
- [`archive/maths/yakaboylu/intro.html`](../../archive/maths/yakaboylu/intro.html) — the archived source start page.
- [`PROGRAMME-STANDARD.md`](../PROGRAMME-STANDARD.md) — the dossier and ledger standard.

[Back to the topic index](../README.md) · [Scraps](../../scraps.html) · [The Final Letter](../../index.html)
