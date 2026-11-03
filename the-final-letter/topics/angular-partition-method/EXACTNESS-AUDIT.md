# O6 — exactness audit

**Status:** completed audit of the infinite series and transforms in the
angular-partition-method dossier.

**Scope and honesty rule.** This audit decides, for each object, whether an
exact transform exists **before** any finite evaluator is assigned. It does not
prove the Riemann hypothesis, does not claim that every representation has a
closed value, and does not upgrade a representation into an evaluation. The
machine-readable matrix is [`python/audit.py`](python/audit.py); the pytest
layer checks its classes, identifiers and the presence of every row below.

## 1. Decision rule

For each infinite object, ask in this order:

1. **Is there an exact transform?** A proved identity, measure partition,
   product-to-sum, Mellin/Laplace, finite part or contour identity.
2. **If yes, is it also an exact evaluation?** Does the transform produce a
   closed value or named constant, rather than another unevaluated object?
3. **If the raw series diverges, is there an exact finite part?** If so, the
   correct object is the finite part, not a truncated raw sum.
4. **If no exact transform exists, is a certified finite evaluator available?**
   Only then use partial sums plus a tail bound; label it as a fallback.
5. **Otherwise record the object as open.** A finite estimate is not an exact
   transform and does not settle an open question.

## 2. Classification legend

| Class | Meaning |
|---|---|
| **E1** | Exact closed evaluation: exact transform and a closed value. |
| **E2** | Exact representation/transform; the total may not have a closed value. |
| **E3** | Exact finite part / analytic continuation of a divergent raw series. |
| **X** | Exact obstruction or divergence diagnosis; no finite exact total. |
| **F** | Certified finite evaluator only; no exact transform claimed. |
| **O** | Open; neither an exact transform nor a certified evaluator is assigned. |

## 3. Audit matrix

| ID | Object | Domain | Convergence | Exact transform? | Class | Evidence | Evaluator policy |
|---|---|---|---|---|---|---|---|
| A1 | Geometric series `sum a r^n` | `abs(r) < 1`; finite partial identities for `r != 1` | absolute for `abs(r) < 1` | yes | **E1** | `geom_sector_sum`, `self_similar_total`; `test_geometric_partial_sum`, `test_self_similar_total` | closed form `a/(1-r)` or finite `a(1-r^n)/(1-r)`; no truncation |
| A2 | Self-similar cake `S = a + rS` | `r != 1` | fixed-point identity | yes | **E1** | `self_similar_total`; `test_self_similar_total`, `test_rational_cake_value` | closed form `a/(1-r)` |
| A3 | Halving-sector radian series `sum pi/2^n` | all `n` | absolute | yes | **E1** | `sector_angle_hasSum`, `sector_angle_tsum`; `test_sector_angle_sum` | closed value `2*pi` |
| A4 | Normalized halving series `sum 1/2^n` | all `n` | absolute | yes | **E1** | `half_turn_sector_hasSum`, `half_turn_sector_tsum`; `test_normalized_half_turn_sum` | closed value `1` |
| A5 | General nonnegative summable series `sum a_n` | `a_n >= 0`, summable | absolute by nonnegativity | yes | **E2** | `annular_representation`; `test_squared_radii_encode_weights`, `test_annular_telescope`, `test_annular_weights_sum` | exact annular representation; closed evaluation only when `R_0` is known |
| A6 | Reciprocal weights `sum 1/(n+1)` | divergent | divergent | no | **X** | `not_summable_inv_nat_succ` (divergence), `inv_nat_not_geometric` (non-geometric obstruction) | none; a finite estimate is not an exact total |
| A7 | `p`-series `sum n^(-sigma)`, generalized to `n^(-s)` | `sigma > 1`; `Re(s) > 1` | absolute for `Re(s) > 1` | yes | **E2** | `annular_representation`; Basel value for `n = 2` is classical and not reproved here | exact annular/Mellin representation; closed evaluation only at special parameters |
| A8 | Complex absolutely summable series `sum c_n` | summable complex `c_n` | absolute | yes | **E2** | `phase_carrying_coil`, `vectorArea_apply`, `vectorArea_eq_phase_sum`; `test_complex_tail_telescope`, `test_unit_coil`, `test_phase_carrying_tuple` | exact phase coil/vector area; the total is the original sum |
| A9 | Dirichlet series `sum n^(-s)` and `zeta(s)` | `Re(s) > 1` | absolute | yes | **E2** | `mellin_zetaKernel_eq_Gamma_mul_zeta`, `riemannZeta_eulerProduct_exp_log` | exact Mellin/Euler representation; numerical evaluation remains separate |
| A10 | Dirichlet series in the critical strip | `0 < Re(s) < 1` | raw series not absolutely convergent; conditionally grouped | yes | **E3** | `mellin_regularizedKernel_eq_of_re_pos_of_lt_one`, `regularizedMellin` | exact finite part/analytic continuation; no raw truncation |
| A11 | Mellin/Laplace integral of `1/(e^t-1)` | `Re(s) > 1`; finite part in `0 < Re(s) < 1` | absolutely convergent for `Re(s) > 1` | yes | **E2** | `hasSum_mellin_zetaKernel`, `mellin_zetaKernel_eq_Gamma_mul_zeta` | exact integral representation; `Gamma*zeta` evaluation separate |
| A12 | Completed zeta and finite part `Lambda_0` | completed zeta; finite part in the strip | analytic continuation via the completed FE | yes | **E3** | `completedRiemannZeta_functional_equation`, `completedRiemannZeta_finite_part`, `completedRiemannZeta0_functional_equation` | exact finite part plus functional equation |
| A13 | Euler product over primes and its log-series | `Re(s) > 1` | absolute local factors; summable log-series | yes | **E2** | `riemannZeta_eulerProduct_exp_log`, `eulerLogSeries_coil`, `finite_eulerProduct_exp_log` | exact product-to-sum/coil; zeta evaluation remains separate |
| A14 | Pole-term contour integral `h(z)/(z(z-1))` | `h` holomorphic on a disk containing `0,1` | finite contour integral | yes | **E1** | `explicitFormula_poleContour`, `explicitFormula_poleContour_residue_form` | closed contour value `2*pi*I*(h(1)-h(0))` |
| A15 | Explicit-formula zero sum `sum_rho h(rho)` and Weil positivity | zeta zeros; test functions | conditional/zero-dependent | open | **O** | no Lean theorem; open item O4 | not assigned; finite truncation would not prove positivity |
| A16 | Rational series `1/(1-z) = sum z^n` | `abs(z) < 1` | absolute | yes | **E1** | `geometric_hasSum_complex`, `geometric_tsum_complex`; `test_geometric_partial_sum` | closed form `1/(1-z)` |
| A17 | Partial-sum-plus-tail certified evaluator | arbitrary series with a tail bound or closed tail | depends on input | no | **F** | depth-axis companion `partial-sum-plus-tail`; no exact transform claimed here | certified finite evaluator; fallback only |
| A18 | Layer-cake representation `a_n = integral 1_{t < a_n} dt` | `a_n >= 0` | Tonelli | yes | **E2** | `layer_cake` | exact representation; no closed evaluation |
| A19 | Once-subtracted annular continuation `-1 < Re(s)` | `-1 < Re(s)`, `s not in {0,1}` | conditionally/regularized; first-order kernel bound | yes | **E3** | `regularizedReal_nonneg`, `regularizedReal_le_div_twelve`; `mellinConvergent_regularizedKernel_of_neg_one_lt`, `differentiableAt_mellin_regularizedKernel_of_neg_one_lt`; `mellin_regularizedKernel_eq_of_neg_one_lt_re` (T53–T55) | exact finite part on the doubled strip; no raw truncation |
| A20 | Completed annular part and functional equation | `-1 < Re(s)`; completed part, with the critical-strip FE | completed finite part; entire comparison target | yes | **E3** | `completedMellinPart_eq_completedRiemannZeta₀`, `completedMellinPart_one_sub` (T56–T57) | exact completed finite part plus the FE as an integral identity |
| A21 | Second Bernoulli subtraction on `-3 < Re(s)` | `-3 < Re(s)` away from `{-2,-1,0,1}` | conditionally/regularized; second-order kernel bound | yes | **E3** | `hasMellin_linCutoff`, `norm_regularizedKernel₂_le`, `mellinConvergent_regularizedKernel₂`, `differentiableAt_mellin_regularizedKernel₂`, `mellin_regularizedKernel₂_eq_of_neg_three_lt_re`, `mellin_regularizedKernel₂_sub`, `regularizedMellin₂_residue_neg_one` (T58–T63) | exact twice-subtracted finite part; pole at `-1` explicitly cancelled |
| A22 | General `k`-th Bernoulli subtraction and full-plane finite part | all `k`; full complex plane | not yet proved | open | **O** | not formalised; open item O8 | not assigned |


## 4. Summary

| Class | Count | Objects |
|---|---|---|
| **E1** exact closed evaluation | 6 | A1, A2, A3, A4, A14, A16 |
| **E2** exact representation | 7 | A5, A7, A8, A9, A11, A13, A18 |
| **E3** exact finite part | 5 | A10, A12, A19, A20, A21 |
| **X** exact obstruction | 1 | A6 |
| **F** finite evaluator only | 1 | A17 |
| **O** open | 2 | A15, A22 |

**Total: 22 audited objects.**

## 5. Conclusions

- Every defined infinite series or transform in the dossier has a row and a
  classification.
- No row with an exact transform is assigned a finite truncation as its
  representation of infinity.
- There are three genuinely different exact outcomes:
  **E1** closed values, **E2** exact representations with evaluation left
  separate, and **E3** exact finite parts of divergent raw series.
- The only certified finite evaluator is A17, the explicit fallback layer. It
  is not used as a proof of any exact identity.
- The explicit-formula zero sum `sum_rho h(rho)` / Weil positivity (A15)
  remains open; its pole-term contour part is separately exact (A14).
- The general `k`-th Bernoulli subtraction and the full-plane finite part
  (A22 / O8) remain open; the doubled and tripled strips are exact
  finite-part statements A19–A21.
- The audit does not claim an RH proof. In particular, A10 is an exact
  finite-part statement, not a proof of the Riemann hypothesis.

## 6. Exclusions

- **Bost–Connes periodic-orbit sums.** They are an open application, not a
  defined numerical series in this dossier; see the open item O5. They are
  therefore outside this audit rather than assigned a spurious classification.
- **`w = e^{-s}` compactification.** It is an obstruction discussion, not an
  infinite series; it is recorded in section 7.5 of the README.
- **Finite computations.** The exact rational computations C1–C13 are not
  infinite objects; they are evidence for the finite identities used above.

## 7. Reproducing the audit

```bash
python3 -m pytest tests -q          # validates python/audit.py and this table
python3 -m pytest tests -q -k audit # audit checks only
```

The audit itself is data-first. The exactness claims point to the Lean
declarations listed in the matrix and in the theorem ledger; the audit fixes
for A4, A6, A16 and A18 are T64–T67 in `lean/Topic.lean`.

**No RH proof yet.**
