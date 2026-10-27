# Dyadic sheaf cohomology — research programme

**Status:** speculative source, reconstructed finite formal core; the cohomological and RH bridges remain open.  
**Source:** [`archive/essays/rh/dyadic-sheaf.html`](../../archive/essays/rh/dyadic-sheaf.html), with the companion sketches [`dyadic-sheaf-cohomology.html`](../../archive/essays/rh/dyadic-sheaf-cohomology.html) and [`dyadic-sheaf-cohomology-2.html`](../../archive/essays/rh/dyadic-sheaf-cohomology-2.html).  
**Inventory:** [Scraps](../../scraps.html) item 40 · [Topic index](../README.md).

## What the programme is

The archived source proposes a dyadic sheaf on the critical strip, or on the idele class group, whose first cohomology is conjectured to vanish off the critical line and to be one-dimensional at each non-trivial zero. The construction is explicitly labelled **speculative**: the essays say there is "no paper, no preprint, no calculation, no evidence", that the differential `d` is "currently ill-defined", and that "the first dyadic sheaf cohomology remains undefined and uncomputed".

Nothing in the source is a theorem. What the source *does* define concretely is finite and checkable:

- the dyadic filtration with radii `2^{-k}` and boxes `{2^{-k} ≤ |x| < 2^{-k+1}}`;
- the alignment energy `E(x;t) = (1 − cos(2πt/x))² + (1 − cos(2πx))²`;
- the divisor-detection identity `cos(2πp/x) + cos(2πx) − 2 = 0 ⇔ x | p`;
- a two-term complex `0 → F₀ → F₁ → 0` whose `H⁰` and `H¹` are conjectural.

This folder reconstructs the finite dyadic/energy algebra exactly, in Lean and in sympy, and records every cohomological and RH-facing statement as a **Source claim** or an **Open / conjecture**. It does not claim that the dyadic sheaf exists, that `H¹` has been computed, or that RH follows.

## Provenance and archived status

| Essay | Role | Status |
|---|---|---|
| [`dyadic-sheaf.html`](../../archive/essays/rh/dyadic-sheaf.html) | Inventory item 40; the "pathway" essay that introduces the dyadic sheaf on the critical line | speculative, January 2026 |
| [`dyadic-sheaf-cohomology.html`](../../archive/essays/rh/dyadic-sheaf-cohomology.html) | companion sketch computing `H⁰`/`H¹` on the adeles | speculative, self-described "thought experiment" |
| [`dyadic-sheaf-cohomology-2.html`](../../archive/essays/rh/dyadic-sheaf-cohomology-2.html) | expanded "formal definition" of the same construction | speculative, "not an existing mathematical theory" |

The two companions duplicate and expand the first essay; they are not independent evidence. No calculation of `H¹` appears in any of them. The source's own disclaimer is the authority for the status recorded here.

## Objects and notation

| Object | Definition |
|---|---|
| Dyadic radius | `r k = 2^{-k}` |
| Dyadic box | `U k = [2^{-k}, 2^{-k+1})`, the shell of index `k` |
| Shell index | `shell(x) = k` when `2^{-k} ≤ x < 2^{-k+1}` (`x > 0`) |
| Alignment energy | `E t x = (1 − cos(2πt/x))² + (1 − cos(2πx))²` |
| Perfect alignment | `E t x = 0`, equivalent to both cosine terms being `1` |
| Divisor detection | for `x ≥ 1`, `cos(2πp/x) + cos(2πx) − 2 = 0 ⇔ x ∣ p` |
| Conjectural complex | `0 → F₀ →(d) F₁ → 0` on the adelic site, `H⁰ = ker d`, `H¹ = coker d` |
| Conjectural anti-involution | `τ` induced by `s ↦ 1 − s`, with `τ² = id` only on `Re(s) = 1/2` |

The finite two-term complex `C⁰ → C¹` used in the Python layer is a **toy model** for the rank bookkeeping of `H⁰` and `H¹`; it is not the source's sheaf complex.

## Theorem ledger

Every row marked **Theorem** is proved in [`lean/Topic.lean`](lean/Topic.lean) with no `sorry`, `axiom`, or `admit`. Every row marked **Computation** has a test in [`tests/test_programme.py`](tests/test_programme.py).

| # | Kind | Statement | Lean / test name |
|---|---|---|---|
| T1 | Theorem | Every dyadic radius is positive: `0 < 2^{-k}`. | `DyadicSheaf.dyadicRadius_pos` |
| T2 | Theorem | Refining the grid halves the radius: `r (k+1) = r k / 2`. | `DyadicSheaf.dyadicRadius_succ` |
| T3 | Theorem | The dyadic radii are strictly antitone: `k < l ⇒ r l < r k`. | `DyadicSheaf.dyadicRadius_strictAnti` |
| T4 | Theorem | The dyadic radii tend to `0` as `k → ∞`. | `DyadicSheaf.dyadicRadius_tendsto_zero` |
| T5 | Theorem | The alignment energy is non-negative: `0 ≤ E t x`. | `DyadicSheaf.energy_nonneg` |
| T6 | Theorem | The energy vanishes iff both cosine alignments are perfect. | `DyadicSheaf.energy_eq_zero_iff` |
| T7 | Theorem | For `x ≥ 1`, `x ∣ p` forces `E p x = 0` (forward divisor detection). | `DyadicSheaf.energy_vanishes_of_dvd` |
| T8 | Theorem | For `t ≠ 0` and `x ≠ 0`, the energy is symmetric: `E t (t/x) = E t x`. | `DyadicSheaf.energy_symm` |
| C1 | Computation | `r k = 2^{-k}`, `r k > 0`, and `r (k+1) = r k / 2` for `k ≤ 14`. | `test_dyadic_radius_halving_and_positivity` |
| C2 | Computation | The shell index returns the unique `k` with `2^{-k} ≤ x < 2^{-k+1}` on a rational grid; the shell length is `2^{-k}`. | `test_dyadic_shell_index_selects_the_unique_shell` |
| C3 | Computation | The shell is closed below and open above at exact boundaries; non-positive inputs raise. | `test_shell_index_boundary_is_closed_below_open_above` |
| C4 | Computation | Doubling shifts the shell index by `−1`; halving shifts it by `+1`. | `test_shell_index_scales_by_one_under_doubling` |
| C5 | Computation | `E t x ≥ 0` at 50-digit precision on a rational grid (tolerance `10⁻⁴⁰`). | `test_energy_is_nonnegative` |
| C6 | Computation | Exact divisor detection `E(p;x) = 0 ⇔ x ∣ p` for `1 ≤ p ≤ 16`, `1 ≤ x ≤ 8`. | `test_energy_vanishes_exactly_on_divisors` |
| C7 | Computation | `E = 0` requires both cosines to equal `1`; `E(1;2) ≠ 0` although one alignment is perfect. | `test_energy_zero_criterion_is_both_cosines_aligned` |
| C8 | Computation | The energy is symmetric under `x ↦ t/x`; `x = 0` gives `nan`, not zero. | `test_energy_symmetry_under_x_maps_to_t_over_x` |
| C9 | Computation | For the toy dyadic difference complex, `dim H⁰ = 1`, `dim H¹ = 0`, and `dim H⁰ − dim H¹ = dim C⁰ − dim C¹` for `n ≤ 7`. | `test_toy_dyadic_complex_rank_bookkeeping` |

The theorem ledger is deliberately small. The Lean core contains only what the source actually defines; every cohomological statement below is explicitly excluded from it.

## Source claims (not promoted to theorems)

| Claim | Source status | Reconstruction note |
|---|---|---|
| `H¹(strip, F) ≠ 0` only when `Re(s) = 1/2` | archived speculative claim | The sheaf, `d`, and `H¹` are undefined; no computation exists. Not formalised. |
| `dim H¹ = 0` off the critical line and `dim H¹ = r` at a zero of multiplicity `r` | archived conjecture | Stated as the "central conjecture"; no evidence in the source. Not formalised. |
| `τ² = id ⇔ Re(s) = 1/2` | archived conjecture | `τ` is proposed, not constructed; the equivalence is asserted. The finite symmetry `E t x = E t (t/x)` is the only proved shadow. |
| The differential `d` is well-defined after regularisation | archived conjecture | The source calls both proposed definitions "ill-defined". Not formalised. |
| The Euler characteristic of the complex equals `ξ(s)` | archived conjecture | No definition of the regularised Euler characteristic is given. Not formalised. |
| `inf_x E(x;t,σ) = 0 ⇔ σ = 1/2` and `t` is a zero ordinate | archived conjecture | Depends on an unformalised `σ`-dependence; the displayed energy contains only `t` and `x`. Not formalised. |
| Divisor detection `E(p;x) = 0 ⇔ x ∣ p` | source claim (displayed identity) | Only the forward direction `x ∣ p ⇒ E = 0` is proved (T7); the converse is verified computationally (C6), not in Lean. |

## Open / conjecture

1. **Define the site and the sheaves.** `F₀` and `F₁` are described informally; no topology, restriction maps, or stalks are specified precisely enough to check the sheaf axioms.
2. **Construct `d`.** Both proposed formulae involve a limit over `2^n`-th roots of unity or a Haar integral over the idele class group. Convergence is unproved and the source concedes ill-definedness.
3. **Compute `H⁰` and `H¹`.** No example, finite model, or calculation of the adelic cohomology exists in the source. C9 only checks rank bookkeeping for a finite difference complex.
4. **Acyclicity off the critical line.** The "maximum principle on adelic height" is a hope, not a theorem.
5. **One dimension per zero.** The correspondence between zeros and cohomology classes is asserted, never constructed.
6. **Euler characteristic `= ξ(s)`.** No definition of the regularised Euler characteristic is supplied.
7. **Converse divisor detection in Lean.** The converse for all positive integers should follow from `Real.cos_eq_one_iff`, but it is not formalised here; C6 checks only a finite grid.
8. **The RH bridge.** Even if all of the above were completed as stated, the implication from the cohomological vanishing statement to the location of the zeros is itself unproved.

## Python layer

[`python/programme.py`](python/programme.py) implements the exact finite objects:

- `dyadic_radius(k)` — the exact rational `2^{-k}`;
- `dyadic_shell(k)` — the exact box `[2^{-k}, 2^{-k+1})`;
- `dyadic_shell_index(x)` — the unique shell index of a positive rational;
- `energy(t, x)` — the sympy expression for `E(x;t)`;
- `energy_zero(t, x)` — exact symbolic decision of `E = 0`;
- `divisor_detection(p, x)` — the source's criterion on integers;
- `dyadic_difference_matrix(n)` and `cohomology_dimensions(n)` — rank bookkeeping for the toy two-term complex.

Run the tests from the topic folder:

```bash
cd the-final-letter/topics/dyadic-sheaf-cohomology
python3 -m pytest -q tests
```

Current result: **9 passed** in under 10 seconds. The suite uses sympy only; no mpmath is needed.

## Lean layer

[`lean/Topic.lean`](lean/Topic.lean) imports Mathlib and works in the namespace `DyadicSheaf`. It defines `dyadicRadius` and `energy` and proves T1–T7 using elementary order, limit, trigonometric, and field facts. The file contains no `sorry`, no `axiom`, and no `admit`.

```bash
cd the-final-letter/topics/dyadic-sheaf-cohomology
./lean/check.sh
```

The last successful check is recorded in [`lean/BUILD.log`](lean/BUILD.log). See [`lean/README.md`](lean/README.md) for what is and is not formalised.

## Open items and known gaps

- The source never defines its sheaves precisely, so there is no object to formalise cohomologically. The Lean core stops at the finite dyadic/energy algebra.
- The energy in the source is written with a `σ` parameter, but the displayed formula contains only `t` and `x`; the `σ`-dependence is unexplained. The reconstruction therefore formalises the two-variable energy.
- The divisor-detection converse and the `σ = 1/2` characterisation remain source claims.
- The "toy complex" of C9 is not evidence for the source's conjecture; it only shows that the finite Euler-characteristic identity holds in the simplest difference complex.

## Provenance

- [`scraps.html`](../../scraps.html) — inventory entry 40.
- [`topics/README.md`](../README.md) — all topic folders.
- [`summary/14-legacy-conjectures/`](../../summary/14-legacy-conjectures/README.md) — the deduplicated conjecture index.

[Back to the topic index](../README.md) · [Scraps](../../scraps.html) · [The Final Letter](../../index.html)
