# Gap inventory and strengthening list — programme dossier

**Inventory:** [Scraps](../../scraps.html) item 6 · [Topic index](../README.md).  
**Source:** [`gaps.html`](../../geometric-dynamical-phase-transitions/gaps.html), the sidecar gap inventory to [`publication.html`](../../geometric-dynamical-phase-transitions/publication.html). The scraps entry also points at [`todo.md`](../../geometric-dynamical-phase-transitions/todo.md) and [`publication-addendum-A.html`](../../geometric-dynamical-phase-transitions/publication-addendum-A.html).  
**Status:** reconstructed elementary formal core; the source is a **checklist, not a proof programme**, and no archived claim is promoted here.

## What the source is

`gaps.html` is a sidecar to the merged paper. It is a status file, not a paper:

- a table of 21 closed-item rows (some rows group several labels) (A, B, C, D, G, …, P8, L₀, T) with the lemma or theorem said to close each;
- a table of "closed identities" (L, L<sub>m</sub>, L<sub>band</sub>, T, DH, D, E, F) recording what the source says was proved;
- a table of "tractable items" from Addendum F, with statuses `proved`, `conditional`, `tractable, not done`, and `open`;
- a prose section, "The remaining gap, collapsed", which isolates the final missing statement.

The body of `gaps.html` contains **no complete proofs**. Every status word in it ("proved", "unconditional", "sharp") is an *archived source claim* in the sense of the [programme standard](../PROGRAMME-STANDARD.md). This reconstruction does not re-verify the paper. What it does instead is take the one place where the source writes an exact, self-contained identity — the last-chord product — and build a small Lean/Python core around it. Everything else is recorded below as a source claim or an open item.

The scraps description also mentions "the refined quadratic asymptotic of Addendum A". That asymptotic is a separate archived claim in [`publication-addendum-A.html`](../../geometric-dynamical-phase-transitions/publication-addendum-A.html) (a stationary-phase expansion with exponent `δ = 29/168 − η`); it is not developed in `gaps.html`, has no complete proof in the source, and is recorded here only as a source claim.

## The precise identity that anchors the formal core

In "The remaining gap, collapsed", the source writes the **last chord** and its product across `s` and `1 − s`:

\[
H_N(s)=\frac{1-N}{2}\,N^{-2s},
\qquad
H_N(s)\,H_N(1-s)=\frac{(N-1)^2}{4N^2}\longrightarrow\frac14 .
\]

The product is an identity of monomials and is independent of `s`. At a displacement `s = 1/2 + δ` the two factors separate as

\[
H_N\!\left(\tfrac12+\delta\right)=C_N\,N^{-2\delta},
\qquad
H_N\!\left(\tfrac12-\delta\right)=C_N\,N^{2\delta},
\qquad
C_N=\frac{1-N}{2N},
\]

so one factor tends to `0` and the other to `∞` as `N → ∞`, while their product stays at `(N−1)^2/(4N^2)`. That is the entire algebraic content of the source's off-line dichotomy. It is **not** a statement about zeros of `ζ`: the source itself says "Both factors remain of order one if and only if `σ = 1/2`", and that conditional reading depends on the unproved tracking estimate. The formal core stops at the monomial identity.

## Reconstructed objects and notation

| Object | Definition | Role |
|---|---|---|
| Last chord | `H_N(s) = ((1 − N)/2) · N^(−2s)` | Exact monomial in `s` |
| Scale | `N ∈ ℕ`, `N ≥ 2` for the non-degenerate case | Integer truncation scale |
| Chord product | `c_N = H_N(s) H_N(1−s)` | Independent of `s` |
| Closed form | `c_N = (N−1)²/(4N²)` | Exact rational |
| Limit | `c_N → 1/4` | Elementary limit |
| Displacement | `δ = s − 1/2` | Off-line parameter |
| North factor | `N^(−2δ)` | Shrinks for `N > 1`, `δ > 0` |
| South factor | `N^(2δ)` | Grows for `N > 1`, `δ > 0` |
| Pole ratio | `H_N(1/2+δ)/H_N(1/2−δ) = N^(−4δ)` | Exact exponential separation |

## Theorem ledger

Every row marked **Theorem** is a declaration in [`lean/Topic.lean`](lean/Topic.lean), compiled with no `sorry`, `axiom`, or `admit`. Every row marked **Computation** has a test in [`tests/test_programme.py`](tests/test_programme.py).

| # | Kind | Statement | Lean / test name |
|---|---|---|---|
| T1 | Theorem | `H_N(s) H_N(1−s) = (N−1)²/(4N²)` for every `N > 0` and every real `s`. | `GapInventory.chord_product` |
| T2 | Theorem | The degenerate scale `N = 1` gives `H_1(s) = 0` for every `s`. | `GapInventory.chord_one` |
| T3 | Theorem | At the centre, `H_N(1/2) = (1−N)/(2N)` for `N > 0`. | `GapInventory.chord_half` |
| T4 | Theorem | The chord product is positive for every `N > 1`. | `GapInventory.chord_product_pos` |
| T5 | Theorem | `(N−1)²/(4N²) = 1/4 − 1/(2N) + 1/(4N²)` for `N > 0`. | `GapInventory.chord_product_quarter` |
| T6 | Theorem | `c_N → 1/4` as `N → ∞`. | `GapInventory.chord_product_tendsto` |
| T7 | Theorem | For `N > 1`, `δ > 0`: `N^(−2δ)·N^(2δ) = 1`, `N^(−2δ) < 1`, `1 < N^(2δ)`. | `GapInventory.pole_dichotomy` |
| C1 | Computation | The symbolic product `H_N(s)H_N(1−s)` simplifies to the closed form for `N = 2..8`. | `test_chord_product_identity_exact` |
| C2 | Computation | The symbolic closed form's limit is `1/4`, verified from the quarter decomposition. | `test_chord_product_limit_is_quarter` |
| C3 | Computation | `c_N` is strictly increasing on `N ≥ 2`, with `c_2 = 1/16` and `c_N < 1/4`. | `test_product_sequence_increasing_below_quarter` |
| C4 | Computation | `N^(−2δ)·N^(2δ) = 1`; at `δ = 1` the north factor is `< 1` and the south factor `> 1`. | `test_pole_dichotomy_exact` |
| C5 | Computation | `H_N(1/2+δ)/H_N(1/2−δ) = N^(−4δ)`. | `test_ratio_is_pure_negative_power` |
| C6 | Computation | `H_N(1/2)² = c_N` and `H_N(1/2) = (1−N)/(2N)` for `N = 2..11`. | `test_half_chord_square` |
| C7 | Computation | Edge case: `N = 1` gives zero; `N = 0`, negative `N`, and `product_sequence(1)` are rejected. | `test_degenerate_scale_and_bad_input` |

“All theorems are proved” means exactly T1–T7. The source claims below are not theorems of this reconstruction.

## Source claims (recorded, not promoted)

| Claim in the source | Archived status | Reconstruction note |
|---|---|---|
| The closed-item rows A–P8, L₀, T closed by named lemmas/theorems | archived claim, "closed" in the source | Not re-verified. The status words are assertions in `gaps.html`, not proofs reproduced here. |
| Identity L: `|∂_t η_N^{(N²)}(s)| ≥ ½ N^{1−σ}|ζ′(ρ)| > N^{1/2+ε}` near a simple off-line zero | archived claim, source says "proved, speed" | Not formalised; depends on the paper's `η_N`, `ζ`, and zero isolation. |
| L<sub>m</sub>, L<sub>band</sub> | archived claim | Not formalised; multiplicity and vanishing-aperture machinery absent. |
| T (tails): tempered atomic tail `O((log A)²/A) + O(1/log N)` | archived claim, "proved" | Not formalised; measure-theoretic and unconditional only for the paper's `η`. |
| DH (Addendum C), including Corollary C.10 that no theorem from the toolbox can be RH | archived claim | Not verified. This is a limitative metatheorem about the toolbox, not a theorem of this dossier. |
| Addendum D mod-`p` Fermat-quotient collapse | archived claim | Not verified; requires the Kaneko–Zagier ring. |
| Addendum E straightening/holonomy zero count | archived claim | Not verified; requires the argument principle and Rouché estimates. |
| Addendum F: Lemma F.1, Proposition F.2, Lemma F.5 exact identifications | archived claim of exact identifications | Not formalised; each depends on external objects (averaged phase, free energies, Connes–Consani window). |
| Lemma F.8 clock zeros; Corollary F.9 uniform window `ε > 13/194`; Lemma F.10 Landau–Gonek | archived claim, "proved" | Not formalised. |
| Refined quadratic asymptotic of Addendum A, exponent `δ = 29/168 − η` | archived claim | Not developed in `gaps.html`; stationary-phase proof not reproduced. |
| "Both factors remain of order one iff `σ = 1/2`" | conditional reading | Only the monomial product T1 and the scale split T7 are formalised; the implication needs the unproved tracking estimate. |
| `η_N^{(N²)}(ρ) η_N^{(N²)}(1−ρ) → 1/4` on the tightness window | conditional on the paper's tracking theorem | Not formalised; `η_N` is not defined here. |
| RH ⇔ `supp ν = supp μ` (Corollary 12.3 route) | archived equivalence | Not a theorem here; the source itself says it is not a proof of RH. |

## Open items and gaps

1. **The remaining slice.** For `K(α,γ) = ∫_0^∞ Φ(u) cosh(αu) cos(γu) du`, the source reduces the gap to: for `α ≠ 0` and `γ ≠ 0`, `K(α,·)` vanishes only if it changes sign. This is open in the source; no Lean statement is made about it.
2. **F.4 — Lee–Yang confinement for `η_N^{(N²)}`.** An interacting ferromagnetic representation whose finite partition functions are the polygon. Open in the source.
3. **Item (b), the transfer-operator form of F.4.** Highest expected return according to the source, but a finite computation not carried out.
4. **Items (a), (c), (d).** Gonek–Ledoan for `η_N`, the heat-flowed polygon, and the twisted F.8 are all "tractable, not done" in the source.
5. **Conditional uniformity.** Uniform slow passage for `ε ≤ 13/194` needs Lindelöf or random-matrix moments; uniform isolation needs pair correlation. Both are conditional in the source.
6. **Re-verification of the closed-item table.** The closures are labels, not arguments. A reader who wants a proof must follow each label into `publication.html`; this dossier does not claim to have done so.
7. **Formalising the tracking theorem.** T1/T7 are the algebraic skeleton of the off-line dichotomy. The step from the monomial product to `η_N(ρ)η_N(1−ρ) → 1/4` is an analytic theorem about `η_N` and is left as a source claim.

## Python layer

[`python/programme.py`](python/programme.py) implements the exact computation layer with `sympy`:

- `chord(N, s)`, `chord_closed(N)`, `chord_product(N, s)`;
- `chord_product_limit()`;
- `north(N, δ)`, `south(N, δ)`, `pole_ratio(N, δ)`;
- `product_sequence(n_max)`.

It raises `ValueError` for `N < 1` and for `product_sequence(n_max)` with `n_max < 2`. No side effects on import.

```bash
python3 -m pytest the-final-letter/topics/gap-inventory-strengthening/tests -q
```

Current result: **7 passed** (≈0.6 s).

## Lean layer

[`lean/Topic.lean`](lean/Topic.lean) imports `Mathlib`, opens the namespace `GapInventory`, and proves T1–T7. The proofs use `Real.rpow_add`, `Real.rpow_neg`, `Real.one_lt_rpow`, field simplification, and elementary filter limits. There is no `sorry`, `axiom`, or `admit`. T2, T4, and T7 are not `rfl` padding: T2 is the degenerate-scale evaluation, T4 is a genuine positivity statement, and T7 combines the exponent law with strict one-sided bounds.

[`lean/README.md`](lean/README.md) records what is and is not formalised.

```bash
the-final-letter/topics/gap-inventory-strengthening/lean/check.sh
```

Recorded build: [`lean/BUILD.log`](lean/BUILD.log) — `[check] OK Topic.lean`.

## Provenance and links

- [`gaps.html`](../../geometric-dynamical-phase-transitions/gaps.html) — canonical source, sidecar to the merged paper.
- [`publication.html`](../../geometric-dynamical-phase-transitions/publication.html) — the paper and its changelog; the source says the live list is the changelog.
- [`publication-addendum-A.html`](../../geometric-dynamical-phase-transitions/publication-addendum-A.html) — the refined quadratic asymptotic mentioned by the scraps entry.
- [`todo.md`](../../geometric-dynamical-phase-transitions/todo.md), [`truths.md`](../../geometric-dynamical-phase-transitions/truths.md) — working list and frozen identities referenced by the source.
- [`the-final-letter/scraps.html`](../../scraps.html) — inventory item 6.
- [`topics/README.md`](../README.md) — the topic index.
- [`PROGRAMME-STANDARD.md`](../PROGRAMME-STANDARD.md) — the four-kind ledger and honesty rules.

[Back to the topic index](../README.md) · [Scraps](../../scraps.html) · [The Final Letter](../../index.html)
