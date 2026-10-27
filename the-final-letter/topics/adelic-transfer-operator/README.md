# Adelic transfer operator — research programme

**Status:** archived thesis outline, reconstructed as a small local formal core and an exact computation layer. The global Riemann-hypothesis proof claim is **not** reconstructed and is recorded as an archived claim.  
**Source:** [`archive/maths/rh/research/adelic-transfer-operator/thesis-complete-outline.md`](../../archive/maths/rh/research/adelic-transfer-operator/thesis-complete-outline.md)  
**Companion outline:** [`thesis-local-outline.md`](../../archive/maths/rh/research/adelic-transfer-operator/thesis-local-outline.md) (a more explicit statement of the local RT-weight claim)  
**Inventory:** [Scraps](../../scraps.html) item 7 · [Topic index](../README.md)

## Provenance and status

The folder `archive/maths/rh/research/adelic-transfer-operator/` contains a thesis outline, a local-paper outline, a prompt tree, and several variant directories. It does **not** contain a completed proof. The outline is programmatic: it names the objects, states the main theorems, and allocates page counts. Its abstract claims a "complete and unconditional proof of the Riemann Hypothesis"; that claim is archived here and is not treated as established.

The source overlaps inventory item 21 (`rh-mtc`), which uses the same prime-indexed modular tensor category construction. This folder reconstructs only what the outlines actually define on the local side:

- the finite data of the modular tensor category `C_p = SU(2)_{p-2}`, in the `1 … p − 1` labelling;
- the local RT weight `p^{−n}`;
- the geometric-series bookkeeping behind the local Fredholm factor `(1 − p^{−s})^{−1}`.

The adelic operator itself, the restricted tensor product, the global determinant identity, the functional equation, the Ruelle-pressure argument, the winding-number count, and the RH conclusion are left as source claims or open items. No analytic operator theory is formalised.

## What the source claims

The complete outline asserts, among other things:

1. a self-adjoint adelic transfer operator `L_s` whose spectrum encodes the nontrivial zeros of the Riemann zeta function;
2. local building blocks from `C_p = SU(2)_{p-2}`;
3. `RT_{C_p}(β) = p^{−n}` for the framed braid of a length-`n` periodic orbit on the Bruhat–Tits tree `T_p`;
4. local Fredholm determinants `det(1 − L_{p,s}) = (1 − p^{−s})^{−1}`;
5. a restricted tensor product over all places whose determinant is `ζ̂(s) e^{P(s)}`;
6. a functional equation derived from modular invariance of local theta functions;
7. a Ruelle-pressure argument excluding zeros off the critical line;
8. unitarity on `Re(s) = 1/2` and a winding-number computation reproducing Riemann–von Mangoldt.

The local outline states the same RT-weight claim as a standalone theorem and describes a proof via Seifert-fibred manifolds, the Verlinde formula, a Gauss sum, and Landsberg–Schaar reciprocity. It also promises numerical verification for `p ≤ 17`, `n ≤ 8`. None of these proofs is present in the archive, and none is formalised here.

## Reconstructed objects and notation

| Object | Reconstruction |
|---|---|
| Prime / level | `p` odd, `p ≥ 3`; source uses primes. Level `k = p − 2`. |
| Labels | The source writes spins `j = 0, 1/2, …, (p−2)/2`. We use `a = 2j + 1`, so `a = 1, …, p − 1`. The identity object is `a = 1`. |
| Quantum dimension | `d_a = sin(π a / p) / sin(π / p)`; `d_1 = 1`. |
| S-matrix | `S_{ab} = sqrt(2/p) sin(π a b / p)`, with `a, b = 1, …, p − 1`. |
| Total quantum dimension | `D_p = sqrt(p / (2 sin²(π/p)))`. |
| Local RT weight | `w_n = p^{−n}`. |
| Local Fredholm/Euler factor | `F(x) = (1 − x)^{−1}`; at `x = p^{−s}` this is the source's `(1 − p^{−s})^{−1}`. |
| Truncated Euler sum | `sum_{k=0}^{N−1} p^{−k} = (p^{−N} − 1)/(p^{−1} − 1)` for `p ≠ 1`. |

These are finite objects. The source's operators `L_{p,s}` and `L_s` are **not** among the reconstructed objects: the archive gives no domain, no kernel, no boundedness proof, and no nuclearity proof for them. The scalar `(1 − x)^{−1}` below is a model for the local factor, not the Fredholm determinant of a constructed operator.

## Theorem ledger

Every row marked **Theorem** is proved in [`lean/Topic.lean`](lean/Topic.lean) with no `sorry`, `axiom`, or `admit`. Every row marked **Computation** is tested in [`tests/test_programme.py`](tests/test_programme.py). Source claims and open items are not theorems of this reconstruction.

| # | Kind | Statement | Lean / test name |
|---|---|---|---|
| T1 | Theorem | For `sin(π/p) ≠ 0`, the identity quantum dimension is `1`: `qdim p 1 = 1`. | `Adelic.qdim_one` |
| T2 | Theorem | Quantum dimensions are positive for `1 ≤ a < p`. | `Adelic.qdim_pos` |
| T3 | Theorem | The S-matrix is symmetric: `S_{ab} = S_{ba}`. | `Adelic.sEntry_symm` |
| T4 | Theorem | For `sin(π/p) ≠ 0`, the identity row is `S_{1b} = S_{11} d_b`. | `Adelic.sEntry_one_eq_mul_qdim` |
| T5 | Theorem | For `p ≠ 1`, `∑_{k<N} p^{−k} = (p^{−N} − 1)/(p^{−1} − 1)`. | `Adelic.rtWeight_geom` |
| T6 | Theorem | The local Fredholm factor satisfies `1 < (1 − x)^{−1}` for `0 < x < 1`. | `Adelic.localDet_gt_one` |
| T7 | Theorem | `(1 − x)^{−1} = ∑_{n≥0} x^n` for `‖x‖ < 1`. | `Adelic.localDet_eq_tsum` |
| C1 | Computation | `d_1 = d_{p−1} = 1`, all `d_a > 0`, invalid labels rejected. | `test_quantum_dimension_normalisation` |
| C2 | Computation | `S` is symmetric and `S² = I` exactly for `p = 3, 5, 7, 11, 13`. | `test_s_matrix_squared_identity` |
| C3 | Computation | `S_{1b} = S_{11} d_b` exactly for `p = 3, 5, 7, 11`. | `test_identity_row_quantum_dimensions` |
| C4 | Computation | `∑_a d_a² = p / (2 sin²(π/p))` exactly for `p = 3, 5, 7, 11, 13`. | `test_total_quantum_dimension` |
| C5 | Computation | `(1 − x) ∑_{k<N} x^k = 1 − x^N` exactly, including the empty sum. | `test_euler_truncation_identity` |
| C6 | Computation | The geometric tail is `∑_{k≥N} p^{−k} = p^{−N}/(1 − p^{−1})`; the local factor exceeds `1`. | `test_local_det_tail_bound` |
| C7 | Computation | `w_{n+1} p = w_n`, `w_{n+m} = w_n w_m`, positivity and strict decrease. | `test_local_weight_scaling` |
| C8 | Computation | Small Verlinde coefficients are nonnegative integers (`p = 3, 5`). | `test_verlinde_coefficients_small` |

The Lean theorems are genuine local facts: normalisation, positivity, symmetry, the identity-row/quantum-dimension relation, a finite geometric identity, and the scalar geometric series. They are not a formalisation of the global programme.

### Source claims

The following rows are recorded with their archived status. They are **not** theorems of this reconstruction.

| # | Claim | Archived status | Why it is not a theorem here |
|---|---|---|---|
| S1 | "Complete and unconditional proof of the Riemann Hypothesis." | Archived claim; outline only. | No proof is present in the source, and no part of the RH conclusion is formalised. |
| S2 | `RT_{C_p}(β) = p^{−n}` for the framed braid of every length-`n` periodic orbit. | Source Theorem 5.1; archived claim. | The braid encoding, framing, Seifert invariants, RT invariant, and Gauss-sum evaluation are not constructed. Only the scalar weight `p^{−n}` is defined. |
| S3 | `det(1 − L_{p,s}) = (1 − p^{−s})^{−1}`. | Source theorem; archived claim. | The operator `L_{p,s}` is not defined with a domain, kernel, trace class or nuclearity proof. Only the scalar geometric series is formalised. |
| S4 | There are `p^n + 1` periodic orbits of length `n` on `T_p`, including the fixed point at infinity. | Source claim; archived, and **inconsistent with the boundary map as stated**. | For the boundary map `z ↦ pz` on `P¹(Q_p)`, period `n` means `p^n z = z`, giving only `z = 0` and `z = ∞`. The count `p^n + 1` may belong to a different shift convention; it is not used as a theorem. |
| S5 | `det(1 − L_s) = ζ̂(s) e^{P(s)}` for the restricted tensor product. | Archived claim. | The restricted tensor product, strong convergence, and the determinant are not constructed. |
| S6 | The completed zeta function satisfies `ζ̂(s) = ζ̂(1 − s)` via modular invariance of local theta functions. | Archived claim. | The local theta functions and their modular phases are not defined in the archive. |
| S7 | A Ruelle-pressure/variational argument excludes all zeros with `Re(s) ≠ 1/2`. | Archived claim; speculative. | No pressure function, Gibbs state, or variational argument is supplied. |
| S8 | Unitarity on `Re(s) = 1/2` plus a winding-number count yields Riemann–von Mangoldt. | Archived claim. | Neither the unitary conjugation nor the determinant's reality properties are constructed. |
| S9 | The S-matrix normalisation is the "corrected" one. | Source definition. | We use the stated formula and verify `S² = I`; this does not audit the source's historical claim about other normalisations. |

### Open / conjecture

These are precise unresolved statements. They are not claimed to be true.

| # | Open item |
|---|---|
| O1 | Construct the framed braid `β` from a length-`n` periodic orbit on `T_p`, including the framing prescription, and define `RT_{C_p}(β)` as a rigorous invariant. |
| O2 | Prove `RT_{C_p}(β) = p^{−n}` for that construction, or exhibit a counterexample. |
| O3 | Define `L_{p,s}` on a precise Hilbert space (the outline suggests `ℓ²(V(T_p))`), prove boundedness/nuclearity, and prove `det(1 − L_{p,s}) = (1 − p^{−s})^{−1}`. |
| O4 | Define the restricted tensor product `H = ⊗'_p H_p ⊗ H_∞`, prove strong convergence, and construct `L_s`. |
| O5 | Prove the global determinant identity `det(1 − L_s) = ζ̂(s) e^{P(s)}` and determine the holomorphic factor `P(s)`. |
| O6 | Derive the functional equation from the local theta functions, with explicit phases `ε_p`. |
| O7 | Make the Ruelle-pressure exclusion argument rigorous, or identify the gap that prevents it. |
| O8 | Derive Riemann–von Mangoldt from the determinant and close the zero-counting argument. |
| O9 | Reconcile the orbit count `p^n + 1` with the definition of the shift on `T_p` and on `P¹(Q_p)`. |

No row above asserts RH, GRH, twin primes, Chowla, Sarnak, or Elliott.

## Python layer

[`python/programme.py`](python/programme.py) implements the finite local data with `sympy` exact arithmetic. `mpmath` is not needed.

Main entry points:

- `quantum_dimension(p, a)`, `s_matrix(p)` and `s_squared_entry(p, a, c)`;
- `cosine_sum(p, k)`, the exact cosine sum used to verify `S² = I`;
- `total_quantum_dimension_sq_sum(p)` and `total_quantum_dimension(p)`;
- `rt_weight(p, n)`, the local weight `p^{−n}`;
- `local_det(x)`, `geometric_partial_sum(x, N)`, `euler_truncation_residual(x, N)`, `local_det_tail(p, N)`;
- `verlinde_coefficient(p, a, b, c)` for small `p`.

Run the tests:

```bash
cd the-final-letter/topics/adelic-transfer-operator
python3 -m pytest -q tests
```

Recorded result: **8 passed** (under two seconds).

The S-matrix involution is checked through the exact product-to-sum identity

```text
(S²)_{ac} = (1/p) [ C(a−c) − C(a+c) ],    C(k) = ∑_{b=1}^{p−1} cos(π k b / p),
```

with `C(0) = p − 1`, `C(k) = −1` for nonzero even `k`, and `C(k) = 0` for odd `k`. This avoids relying on `sympy`'s incomplete trigonometric simplification for `p ≥ 7`.

## Lean layer

[`lean/Topic.lean`](lean/Topic.lean) imports Mathlib and works in the namespace `Adelic`. It defines:

- `Adelic.qdim p a = sin(π a / p) / sin(π / p)`;
- `Adelic.sEntry p a b = sqrt(2/p) sin(π a b / p)`;
- `Adelic.rtWeight p n = (p⁻¹)^n`;
- `Adelic.localDet x = (1 − x)⁻¹`.

It proves T1–T7 with no `sorry`, `axiom`, or `admit`:

```bash
cd the-final-letter/topics/adelic-transfer-operator
./lean/check.sh 2>&1 | tee lean/BUILD.log
```

Recorded build: [`lean/BUILD.log`](lean/BUILD.log) — `[check] OK Topic.lean`.

The Lean file deliberately does **not** formalise:

- modular tensor categories, their axioms, or Reshetikhin–Turaev invariants;
- braids, framings, Seifert-fibred 3-manifolds, or the Verlinde formula;
- transfer operators on `ℓ²` spaces, traces, nuclearity, or Fredholm determinants of operators;
- restricted tensor products, strong operator convergence, or adelic Hilbert spaces;
- theta functions, modular forms, Ruelle pressure, or zero-counting;
- any part of the Riemann-hypothesis conclusion.

The scalar `localDet` is the elementary model of the local Euler factor, not the determinant of a constructed operator. See [`lean/README.md`](lean/README.md) for the precise boundary.

## Open items and known gaps

1. **The source is an outline, not a proof.** The abstract's RH claim is unsupported by the archived text. It remains an archived claim.
2. **The local RT theorem is not reconstructed.** The braid, framing, RT invariant, and Gauss-sum evaluation are absent. T1–T4 and C1–C4 only verify the finite MTC data that such a proof would use.
3. **The local Fredholm identity is not reconstructed.** T5–T7 and C5–C6 formalise the scalar geometric series; the operator `L_{p,s}` and its determinant are not defined.
4. **The orbit count needs reconciliation.** `p^n + 1` does not match the periodic points of the boundary map `z ↦ pz` as stated. This should be resolved before the local theorem is cited.
5. **The global argument is entirely open.** Restricted tensor products, determinant factorisation, functional equation, Ruelle exclusion, and zero counting remain source claims or open items O3–O8.
6. **The Verlinde check is small.** C8 verifies the stated formula for `p = 3, 5` only; no general proof of the Verlinde formula is attempted.

## Provenance

- [Scraps inventory](../../scraps.html) — item 7, with the archived-claim and outline tags.
- [Topic index](../README.md) — all reconstructed topics.
- [Complete thesis outline](../../archive/maths/rh/research/adelic-transfer-operator/thesis-complete-outline.md) — the primary source.
- [Local RT outline](../../archive/maths/rh/research/adelic-transfer-operator/thesis-local-outline.md) — the local theorem statement.
- [Prompt tree](../../archive/maths/rh/research/adelic-transfer-operator/thesis-local-prompt.md) — the source's own expansion prompts.
- [The Final Letter](../../index.html).

[Back to the topic index](../README.md) · [Scraps](../../scraps.html) · [The Final Letter](../../index.html)
