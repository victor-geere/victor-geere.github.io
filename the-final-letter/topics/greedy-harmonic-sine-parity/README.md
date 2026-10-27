# Greedy harmonic sine / twin-prime parity — research programme

**Status:** reconstructed finite-prefix formal core + exact integer computation layer. The archived programme's headline claims about RH, twin primes, Chowla, Sarnak and Elliott remain **open** and are not asserted here.  
**Source:** [`summary-rh/README.md`](../../summary-rh/README.md), with the parity core in [`01-ledger/07`](../../summary-rh/01-ledger/07-two-point-chowla-and-the-finite-prefix-theorem-rh46.md), [`01-ledger/08`](../../summary-rh/01-ledger/08-greedy-sine-vs-the-parity-barrier-rh47.md) and [`04-programme/04-barrier-ledger.md`](../../summary-rh/04-programme/04-barrier-ledger.md). The harvested corpus lives outside this site at `/Users/victor/workspace/rh`; the relevant Lean source is `research/twin-prime-parity/rounds/rh46/lean/Rh46/Chowla.lean`.  
**Inventory:** [Scraps](../../scraps.html) item 2 · [Topic index](../README.md).

## What the programme is

The `~/workspace/rh` corpus asks whether the **greedy harmonic sine** can solve the parity problem for the twin prime conjecture. Its own verdict, stated first in the source, is **no — not by this programme as it stands**. The programme produced a proved factor-complexity law for the greedy digit word, budget algebra, a parity-locked support, the Sylvester-sparsity theorem, and — the one clean parity-side theorem — the **finite-prefix indeterminacy theorem** for the two-point Liouville correlation.

This folder does not re-derive the whole corpus. It reconstructs the *finite-prefix / parity core* that the source actually isolates:

- the Liouville sign `λ(n) = (−1)^{Ω(n)}`;
- the two-point correlation `S(N,h) = Σ_{1≤n≤N} λ(n)λ(n+h)`;
- the trivial bound `|S(N,h)| ≤ N` and its sharpness at `h = 0`;
- the one-point slice `λ_a` obtained by negating `λ(a)`, and the exact statement that prefixes below `a` cannot see the flip;
- the exact `ℓ²` mass `4` of that slice;
- the non-complete-multiplicativity witness for `n ↦ λ(n)λ(n+2)`.

The finite greedy word (rh41/rh42) is the programme's *other* object. It is recorded below as source claims, not reconstructed as Lean theorems, because the selected source footprint for this topic is the rh46 finite-prefix/parity core. No asymptotic statement about `S(N,2)` is proved here.

## Provenance and source status

| Layer | Where | Status of the layer |
|---|---|---|
| Harvest index | [`summary-rh/README.md`](../../summary-rh/README.md) | Structured harvest of an external repository; it explicitly says that nothing there solves RH, twin primes, Chowla, Sarnak or Elliott. |
| Proved-results ledger | [`summary-rh/01-ledger/`](../../summary-rh/01-ledger/README.md) | 13 sections, 140 named rows; the canonical audit of what the corpus established. |
| Finite-prefix section | [`01-ledger/07`](../../summary-rh/01-ledger/07-two-point-chowla-and-the-finite-prefix-theorem-rh46.md) | rh46: 42 Lean theorems; two-point Chowla itself **OPEN**. |
| Parity-barrier section | [`01-ledger/08`](../../summary-rh/01-ledger/08-greedy-sine-vs-the-parity-barrier-rh47.md) | rh47: Sylvester-sparsity proved; bridges B1–B3 **REFUTED**. |
| Programme verdict | [`04-programme/04-barrier-ledger.md`](../../summary-rh/04-programme/04-barrier-ledger.md) | P1–P19, B1–B5, N1–N3; the goal is not reachable by this programme as it stands. |
| Lean source | `/Users/victor/workspace/rh/research/twin-prime-parity/rounds/rh46/lean/Rh46/Chowla.lean` | Source of the definitions adapted here; outside this repository. |

**Honesty note.** The source corpus is fragmentary as a *research programme* and conclusive as a *barrier map*. The material reconstructed here is the part that is elementary, finite, and checkable. The grand claims are kept in the ledger as source claims or open problems. In particular, the source's own documents say the parity attack failed.

## Reconstructed objects and notation

| Object | Definition |
|---|---|
| `Ω n` | Number of prime factors of `n`, counted with multiplicity (`ArithmeticFunction.cardFactors`). |
| `λ n` | Liouville function `(−1)^(Ω n)`; the convention is `λ 0 = 1`. |
| `S(N,h)` | `corr h N = Σ_{1≤n≤N} λ n · λ(n+h)`, an integer. |
| `f_h(n)` | `shiftProd h n = λ n · λ(n+h)`, the Chowla summand. |
| `λ_a` | `liouvilleSlice a n = if n = a then −λ a else λ n`. |
| `S_a(N,h)` | `corrSlice h a N`, the same correlation built from `λ_a`. |
| Slice mass | `Σ_{1≤n≤N} (λ_a(n) − λ(n))²`. |

The shift is written `h`; the twin-prime case is `h = 2`. The sum always starts at `n = 1`, which is why the index `0` is an edge case below.

## Theorem ledger

Every row marked **Theorem** is proved in [`lean/Topic.lean`](lean/Topic.lean) with no `sorry`, no `axiom`, and no `admit`. Every row marked **Computation** is executed exactly by [`tests/test_programme.py`](tests/test_programme.py). Source claims and open items are **not** theorems of this reconstruction.

| # | Kind | Statement | Status / source | Lean or test |
|---|---|---|---|---|
| T1 | **Theorem** | `λ n ^ 2 = 1` for every `n`; `λ` is a sign. | Proved here; parity core. | `GSP.liouville_sq` |
| T2 | **Theorem** | `|S(N,h)| ≤ N` for every shift `h` and length `N`. | Proved here; source P15 trivial bound. | `GSP.corr_abs_le` |
| T3 | **Theorem** | `S(N,0) = N`; the trivial bound is attained. | Proved here; source P15 sharpness. | `GSP.corr_zero` |
| T4 | **Theorem** | If `n < a` then `λ_a(n) = λ(n)`: a one-point flip is invisible below `a`. | Proved here; source slice layer. | `GSP.slice_agree` |
| T5 | **Theorem** | If `N + h < a` then `S_a(N,h) = S(N,h)`. | Proved here; source `corrSlice_eq_corr_of_lt`. | `GSP.corrSlice_eq_corr_of_lt` |
| T6 | **Theorem** | For `1 ≤ a ≤ N`, `Σ_{1≤n≤N} (λ_a(n) − λ(n))² = 4`. | Proved here; source `corrSliceSqSub`. | `GSP.corrSliceSqSub` |
| T7 | **Theorem** | `f_2(25) ≠ f_2(5)·f_2(5)`: the Chowla summand is not completely multiplicative. | Proved here; the source's P17 witness. | `GSP.shiftProd_two_five` |
| C1 | **Computation** | `λ(n) ∈ {±1}`, `λ(n)² = 1` on `0 ≤ n < 200`, and `λ(mn) = λ(m)λ(n)` on `1 ≤ m,n ≤ 20`. | Exact integer check. | `test_liouville_is_a_sign_and_multiplicative` |
| C2 | **Computation** | `|S(N,h)| ≤ N` for `0 ≤ h ≤ 5`, `0 ≤ N ≤ 60`, and `S(N,0) = N`. | Exact integer check. | `test_trivial_bound_and_sharpness` |
| C3 | **Computation** | Prefix agreement holds on the stated grid, while `S_5(2,2) = S(2,2)` and `S_5(2,5) ≠ S(2,5)`. | Exact integer check. | `test_prefix_agreement_of_the_slice` |
| C4 | **Computation** | For `0 < h < a`, tested with `h ∈ 1..4` and `a ∈ h+1..15`, `S_a(a,h) − S(a,h) = −2λ(a)λ(a+h) − 2λ(a−h)λ(a)`; at `h=2, a=5` the value is `−4`. | Exact integer check. | `test_slice_perturbation_closed_form` |
| C5 | **Computation** | The slice `ℓ²` mass is `4` for `1 ≤ a ≤ N ≤ a+10`; at `a = 0` it is `0` because the sum starts at `1`. | Exact integer check with edge case. | `test_slice_l2_mass_is_exactly_four` |
| C6 | **Computation** | `f_2(25) = −1` while `f_2(5)² = 1`. | Exact integer check. | `test_shifted_product_is_not_completely_multiplicative` |
| C7 | **Computation** | Boundary behaviour: `λ 0 = 1`, `λ_0(0) = −1`, empty correlation at `N = 0`, and rejection of negative indices and of `h = 0` or `h ≥ a` in the closed form. | Exact integer check with failure cases. | `test_edge_and_invalid_inputs` |
| S1 | **Source claim** | Factor-complexity law `p(L) = min(a_m+1, N−L+1) + [L ≤ N−a_m−1]` for the greedy digit word. | Source: **PROVED (Lean, rh41)**; not reconstructed here — it belongs to the greedy-word layer, not the parity core. | — |
| S2 | **Source claim** | Budgets `P = 2^{−p}ζ`, `N = (1−2^{−p})ζ−1`, `P+N = ζ−1`, `P−N = 1−η`, `P > N`. | Source: **PROVED (Lean at p=2,4, rh42)**; not reconstructed here. | — |
| S3 | **Source claim** | The signed Tau support is parity-locked (even gaps for `x>0`, odd for `x<0`). | Source: **PROVED (Lean, rh42)**; not reconstructed here. | — |
| S4 | **Source claim** | **Finite-prefix indeterminacy theorem:** there is a modified `λ''` agreeing with `λ` on an arbitrary finite prefix (the source uses `[1,10⁸]`) with `S''(x)/x → 1`, while the true `S(x)/x` is believed to vanish — so no finite computation decides `o(x)`. | Source: **PROVED (Lean, rh46)** for the slice layer. This reconstruction proves only its elementary slice lemmas T4–T6, not the asymptotic reading. | — |
| S5 | **Source claim** | `|S(N,h)| ≤ N` and `S(N,0) = N`; therefore any argument using only `|λ| = 1` cannot give `o(N)`. | Source: **PROVED (Lean, rh46)**. The two finite inequalities are reconstructed as T2–T3; the negative "cannot give `o(N)`" reading is the source's interpretation and is not formalised. | — |
| S6 | **Source claim** | `n ↦ λ(n)λ(n+2)` is not multiplicative, so its Dirichlet series has no Euler product. | Source: **PROVED (Lean, rh46)**, but the Lean witness is non-*complete*-multiplicativity at `m = n = 5`. T7 and C6 reproduce exactly that witness; the step from it to "no Euler product" is not formalised. | — |
| S7 | **Source claim** | **Sylvester-sparsity:** for the greedy support `m₁ < m₂ < …`, `m_{i+1} ≥ m_i(m_i−1)+1`. | Source: **PROVED (paper) + VERIFIED** on 53,159 pairs; not formalised here. | — |
| S8 | **Source claim** | Bridges B1–B5 from the greedy sine to `λ`-parity are refuted: support signal is a positional artefact; budgets split index parity; the correlation has no Euler product; the support density `≈ 3.9·10⁻⁵` is `o(x)`; an arithmetic alphabet imports the target. | Source: **REFUTED / disposed of (rh47)**; these are negative findings, not formalised in this folder. | — |
| S9 | **Source claim** | One-point Chowla `Σ_{n≤x} λ(n) = o(x)` is equivalent to PNT. | Source: **THEOREM (classical; correction X1)**; not reconstructed here. | — |
| S10 | **Source claim** | Balance identity, sharp `√N` partial-sum error at a zero, smoothing cannot remove `√N`, corrected explicit formula with the archimedean term, closed Turing windows. | Source: **PROVED (Lean/paper, rh43–rh45)**; outside this topic's finite-prefix footprint, not reconstructed. | — |
| O1 | **Open / conjecture** | Two-point Chowla: `Σ_{n≤x} λ(n)λ(n+2) = o(x)`. | **OPEN** in the source and here. Not asserted, not approximated, not claimed. | — |
| O2 | **Open / conjecture** | Twin prime conjecture. | **OPEN**. The programme proves nothing about prime pairs. | — |
| O3 | **Open / conjecture** | Riemann hypothesis. | **OPEN**. Not addressed by this topic. | — |
| O4 | **Open / conjecture** | Chowla for `k ≥ 2`, Sarnak's conjecture, Elliott's conjecture. | **OPEN**. Not addressed. | — |
| O5 | **Open / conjecture** | OP-3 / R2: no sign-blind `log n`-rule can force a multiplicative correlation. | **OPEN — not well-posed as inherited**; the later phrasing was repaired into OP-19. | — |
| O6 | **Open / conjecture** | OP-19 log-indicator barrier; whether `Σ_{n≤x} 1_{cos(t log n)>0} λ(n) = o(x)` for any `t`. | **OPEN**. | — |
| O7 | **Open / conjecture** | A positive-density witness coupled to `Ω` is necessary for any `o(x)` proof through this route. | **OPEN requirement**, not a theorem; the sparsity result only says the greedy support is not such a witness. | — |
| O8 | **Open / conjecture** | Formalise the full finite-prefix *limit* statement (not just the prefix lemmas) in Lean. | **OPEN in this reconstruction**; see [`lean/README.md`](lean/README.md). | — |

## Python layer

[`python/programme.py`](python/programme.py) is an exact integer implementation, using `sympy.factorint` only to compute `Ω`. It exports:

| Function | Meaning |
|---|---|
| `omega(n)` | `Ω(n)`, raising on negative input. |
| `liouville(n)` | `λ(n) = (−1)^Ω(n)`, with `λ(0) = 1`. |
| `shift_prod(h,n)` | `λ(n)λ(n+h)`. |
| `corr(h,N)` | `Σ_{1≤n≤N} λ(n)λ(n+h)`; `corr(h,0) = 0`. |
| `liouville_slice(a,n)` | `λ` with the value at `a` negated. |
| `corr_slice(h,a,N)` | The correlation built from the slice. |
| `slice_l2_mass(a,N)` | `Σ_{1≤n≤N} (λ_a(n)−λ(n))²`. |
| `slice_perturbation(h,a)` | The closed form `−2λ(a)λ(a+h) − 2λ(a−h)λ(a)` for `0 < h < a`. |
| `prefix_agreement(h,a,N)` | Exact check of `S_a = S` when `N+h < a`. |

The module is importable as a package (`python/__init__.py` re-exports the public functions) and has no side effects.

```bash
cd the-final-letter/topics/greedy-harmonic-sine-parity
python3 -m pytest -q tests
```

Current result: **7 passed** in under one second. The suite covers every **Computation** row, including the `a = 0` mass edge case and the `h = 0` / `h = a` rejection cases.

## Lean layer

[`lean/Topic.lean`](lean/Topic.lean) imports Mathlib, uses the namespace `GSP`, and proves T1–T7. It defines `Omega`, `liouville`, `corr`, `shiftProd`, `liouvilleSlice` and `corrSlice`, then proves the seven facts above using elementary order, `Finset` and `ring` reasoning. There is no `sorry`, no `axiom`, and no `admit`.

```bash
cd the-final-letter/topics/greedy-harmonic-sine-parity
./lean/check.sh
```

Recorded build: [`lean/BUILD.log`](lean/BUILD.log) — `[check] OK Topic.lean`.

### What is deliberately not formalised

- **The asymptotic reading.** T5 is the prefix statement; the source's finite-prefix *indeterminacy* conclusion is about the limit of `S(N,h)/N` and is not formalised. No asymptotic statement appears in the Lean file.
- **Two-point Chowla itself.** `corrAsymptotic 2` is not stated and not proved.
- **The greedy recursion.** The greedy digit word, its complexity law, Brown reachability, and the parity lock (S1–S3) are different objects and are not reconstructed here.
- **Sylvester-sparsity.** S7 is kept as a source claim with its numerical verification.
- **The explicit-formula and smoothing layers.** S10 is outside the selected finite-prefix/parity footprint.

See [`lean/README.md`](lean/README.md) for the declaration-by-declaration account and the fidelity notes relative to the source's `Rh46/Chowla.lean`.

## Open items and known gaps

1. **Two-point Chowla is open.** `Σ λ(n)λ(n+2) = o(x)` is the headline target and remains unproved; the source's own reassessment places it out of reach. Nothing in this folder is a step toward it.
2. **The finite-prefix theorem's limit form is not in Lean here.** The slice lemmas are machine-checked, but the statement that finite data cannot decide the asymptotic is only prose in this reconstruction. The source claims a Lean proof of the full slice layer; reproducing that limit argument is future work.
3. **The greedy word is not reconstructed.** The factor-complexity law, budgets, Brown criterion and parity lock are recorded as source claims (S1–S3). They are genuine source theorems, but they are not theorems of this folder.
4. **The barrier is a heuristic where it matters.** The source explicitly says the impossibility of a sign-blind `log n`-rule (OP-3/R2) is **open**, and that the earlier phrasing was withdrawn. It is not upgraded here.
5. **"Not multiplicative" is stronger than the witness.** The source's P17 slogan says `f(n)=λ(n)λ(n+2)` is not multiplicative, but the machine-checked witness is at `(5,5)`, which refutes *complete* multiplicativity only. Multiplicativity for coprime arguments is not refuted here, and the "no Euler product" conclusion is therefore recorded as the source's interpretation (S6), not as a theorem of this reconstruction.
6. **Negative findings are not formalised.** Bridges B1–B5 involve statistical controls and numerical discrepancies (`χ²`, `z`-scores, `D(2)` comparisons); they are source claims, not Lean theorems.

## Links

- [Scraps — unharvested programmes](../../scraps.html), inventory item 2.
- [All topic folders](../README.md).
- [The Final Letter](../../index.html).
- Source harvest: [`summary-rh/README.md`](../../summary-rh/README.md).

[Back to the topic index](../README.md) · [Scraps](../../scraps.html) · [The Final Letter](../../index.html)
