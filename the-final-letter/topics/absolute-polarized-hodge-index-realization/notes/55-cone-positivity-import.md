# Cone positivity: the box-positivity import

**Status:** finite cone positivity formalised. **No RH proof yet.**

## 1. What was imported

The sibling topic [`intersection-form-zeta`](../../intersection-form-zeta/README.md)
formalises the finite Hodge-index core and a **box-positivity certificate** for
a Weil Gram matrix (T18–T20, T91–T100). The relevant lemmas are:

- **row-sum bound**: if `D` is symmetric and `Σ_j |D_ij| ≤ t`, then
  `|xᵀDx| ≤ t‖x‖²`;
- **box inequality**: if `A` is Hermitian and lies in the box
  `(P + tI) ± E` with row sums of `E` at most `t`, then `A ⪰ P`, i.e.
  `xᵀPx ≤ xᵀAx` for every `x`;
- **positive definiteness**: if in addition `P` is positive definite, then so
  is `A`;
- **LDLᵀ certificate**: an exact rational factorisation `L d Lᵀ` with `d > 0`
  and `L` invertible proves `L d Lᵀ` positive definite.

These were ported into [`lean/Shadow.lean`](../lean/Shadow.lean), in real and
rational forms, and **generalised to an arbitrary finite index type** `ι`
(not just `Fin 4`), so the same certificate applies to any `n × n` Gram
matrix. The proofs are unchanged (the rational proofs are the same arguments
over `ℚ`).

## 2. What was proved

The dossier's 4×4 Gaussian Gram shadow is the rational matrix `W4`, close to
the rational Cholesky shadow `G4 = L4 L4ᵀ`:

```
|G4 i j - W4 i j| ≤ 1/50000     (G4_close)
```

The new Lean results are:

| theorem | content |
|---|---|
| `abs_quad_le_row_sum` / `_rat` | the row-sum bound |
| `box_ge` / `box_ge_rat` | the box inequality `A ⪰ P` |
| `posDef_of_box` / `posDef_of_box_rat` | positive definiteness from a box |
| `ldl_posDef_rat` | an exact rational `L d Lᵀ`, `d > 0`, is positive definite |
| `Pq_factor` | `Ld · diag(dd) · Ldᵀ = G4 - (1/12500)·1` exactly over `ℚ` |
| `Pqm_posDef` | `G4 - (1/12500)·1` is positive definite |
| `W4m_herm`, `W4m_mem_box`, `E4m_row` | the box hypotheses |
| **`W4m_posDef`** | **`W4` is positive definite** |

A second, 2×2 rung (`W2m_posDef`) exercises the same machinery: the rational
centre `G2q = [[355/10000, 802/100000], [802/100000, 355/10000]]`, slack
`t = 2/10000`, entrywise bound `E2m`, and the numerical shadow `W2m` with
`354/10000` on the diagonal and `801/100000` off it, positive definite by the
box theorem.

For the 4×4 certificate the slack is `t = 1/12500 = 4·(1/50000)`, the fourth
of the entrywise `1/50000` bound. The LDLᵀ pivots are positive with margin: the smallest is
`4305929/100000000 ≈ 0.0431` after scaling by the first pivot; the computed
minimal pivot is about `0.0366`. The Python test
`test_cone_positivity_ldl_constants` rechecks the embedded rationals exactly.

## 3. Finite Gram positivity

A complementary pair of theorems formalises the finite structure of any
inner-product positivity:

- `gram_quadFormR_nonneg`: every finite Gram matrix
  `G_ij = ⟪v_i, v_j⟫` is positive semidefinite, since
  `∑ c_i c_j G_ij = ‖∑ c_i • v_i‖² ≥ 0`;
- `gram_quadFormR_pos_iff`: it is positive definite exactly when the vectors
  `v_i` are linearly independent.

For the Weil programme this is the abstract shape of the finite rung: a
positive form yields PSD Gram matrices, and a positive-definite certificate
is exactly a linear-independence statement. It does not supply the positivity
of the Weil form itself.

## 4. What this does and does not establish

This is a **finite** positive-definiteness certificate: the 4×4 Gaussian Weil
Gram shadow is positive definite, Lean-checked from a rational centre and an
interval box. It is the finite rung of the cone positivity.

It does **not** prove the infinite cone positivity, hence not Weil's criterion,
hence not RH. The infinite statement requires the distributional explicit
formula and the passage from finite subspaces to the full test-function cone.
The finite certificate is consistent with that programme; it does not close it.

## 5. The explicit rank-three model

The pairing itself is ported: `Bint a b c a' b' c'` on the classes
`aH + bV + cΔ`, with `Bint_comm`, `Bint_self` (`D² = 2(ab+ac+bc)`),
`Bint_ample_sq` (`A² = 6`) and `Bint_ample_dot` (`A·D = 2(a+b+c)`).

## 6. The Hodge defect

The rank-three Hodge-index defect is also formalised: for
`D = aH + bV + cΔ` and `A = H + V + Δ`,
`(A·D)² - 6D² = 2((a-b)² + (b-c)² + (c-a)²)` (`hodge_defect_identity`), and
hence `6D² ≤ (A·D)²` (`hodge_index_explicit`). The positivity gap is a sum of
squares, the quantitative form of the cone positivity in the finite model.
The equality case is also formalised: the defect vanishes if and only if
`a = b = c` (`hodge_defect_eq_zero_iff`), i.e. exactly on the ample line.

## 7. Provenance

The box and LDLᵀ lemmas are ported from
[`intersection-form-zeta/lean/Topic.lean`](../../intersection-form-zeta/lean/Topic.lean)
(T14–T20), which in turn follows the interval centre/error method of the
`prime-spectrum-tensor` dossier. The rational constants `Ld`, `dd` were
computed with exact rational arithmetic from `G4 - (1/12500)·1`.

**No RH proof yet.**

[Back to the dossier](../README.md) · [Priorities](53-priorities.md) ·
[Final assessment](54-final-assessment.md) · [Journal](../research-journal.md)
