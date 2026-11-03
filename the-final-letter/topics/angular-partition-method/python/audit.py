"""O6 exactness audit for the angular partition method.

This module is deliberately data-first: the audit matrix in
``EXACTNESS-AUDIT.md`` is represented here so that the claim "every infinite
series/transform in the programme is classified" can be checked by pytest.

The classifications are:

``E1`` exact closed evaluation
``E2`` exact representation/transform, evaluation not necessarily closed
``E3`` exact finite-part/analytic continuation of a divergent raw series
``X``  exact obstruction/divergence diagnosis
``F``  certified finite evaluator only (no exact transform)
``O``  open
"""

from __future__ import annotations

from collections import Counter
from typing import Dict, List

CLASSES: Dict[str, str] = {
    "E1": "exact closed evaluation",
    "E2": "exact representation/transform, evaluation not necessarily closed",
    "E3": "exact finite-part/analytic continuation of a divergent raw series",
    "X": "exact obstruction/divergence diagnosis",
    "F": "certified finite evaluator only",
    "O": "open",
}

REQUIRED_FIELDS = (
    "id",
    "kind",
    "object",
    "domain",
    "convergence",
    "exact_transform",
    "classification",
    "evidence",
    "evaluator",
)

# ``exact_transform`` is one of "yes", "no", "open" so that the audit can be
# checked mechanically rather than by prose alone.
AUDIT_ROWS: List[Dict[str, str]] = [
    {
        "id": "A1",
        "kind": "series",
        "object": "Geometric series sum a r^n",
        "domain": "|r| < 1 for the infinite total; finite partial sums for r != 1",
        "convergence": "absolute for |r| < 1; finite identity otherwise",
        "exact_transform": "yes",
        "classification": "E1",
        "evidence": "geom_sector_sum, self_similar_total; test_geometric_partial_sum, test_self_similar_total",
        "evaluator": "closed form a/(1-r) or a(1-r^n)/(1-r); no truncation",
    },
    {
        "id": "A2",
        "kind": "series",
        "object": "Self-similar cake S = a + r S",
        "domain": "r != 1",
        "convergence": "fixed-point identity; no tail",
        "exact_transform": "yes",
        "classification": "E1",
        "evidence": "self_similar_total; test_self_similar_total, test_rational_cake_value",
        "evaluator": "closed form a/(1-r)",
    },
    {
        "id": "A3",
        "kind": "series",
        "object": "Halving-sector radian series sum pi/2^n",
        "domain": "all n",
        "convergence": "absolute",
        "exact_transform": "yes",
        "classification": "E1",
        "evidence": "sector_angle_hasSum, sector_angle_tsum; test_sector_angle_sum",
        "evaluator": "closed value 2*pi",
    },
    {
        "id": "A4",
        "kind": "series",
        "object": "Normalized halving series sum 1/2^n",
        "domain": "all n",
        "convergence": "absolute",
        "exact_transform": "yes",
        "classification": "E1",
        "evidence": "half_turn_sector_hasSum, half_turn_sector_tsum; test_normalized_half_turn_sum",
        "evaluator": "closed value 1",
    },
    {
        "id": "A5",
        "kind": "series",
        "object": "General nonnegative summable series sum a_n",
        "domain": "a_n >= 0, summable",
        "convergence": "absolute by nonnegativity",
        "exact_transform": "yes",
        "classification": "E2",
        "evidence": "annular_representation; test_squared_radii_encode_weights, test_annular_telescope, test_annular_weights_sum",
        "evaluator": "exact annular representation; closed evaluation only when R_0 is known",
    },
    {
        "id": "A6",
        "kind": "series",
        "object": "Reciprocal weights sum 1/(n+1)",
        "domain": "divergent",
        "convergence": "divergent",
        "exact_transform": "no",
        "classification": "X",
        "evidence": "not_summable_inv_nat_succ (divergence); inv_nat_not_geometric (non-geometric obstruction)",
        "evaluator": "none; a finite estimate is not an exact total",
    },
    {
        "id": "A7",
        "kind": "series",
        "object": "p-series sum n^(-sigma), generalized to n^(-s)",
        "domain": "sigma > 1 for convergence; s complex in Re(s) > 1",
        "convergence": "absolute for Re(s) > 1",
        "exact_transform": "yes",
        "classification": "E2",
        "evidence": "annular_representation; Basel value for n=2 is classical and not reproved here",
        "evaluator": "exact annular/Mellin representation; closed evaluation only at special parameters",
    },
    {
        "id": "A8",
        "kind": "series",
        "object": "Complex absolutely summable series sum c_n",
        "domain": "summable complex c_n",
        "convergence": "absolute",
        "exact_transform": "yes",
        "classification": "E2",
        "evidence": "phase_carrying_coil, vectorArea_apply, vectorArea_eq_phase_sum; test_complex_tail_telescope, test_unit_coil, test_phase_carrying_tuple",
        "evaluator": "exact phase coil/vector area; the total is the original sum",
    },
    {
        "id": "A9",
        "kind": "series",
        "object": "Dirichlet series sum n^(-s) and zeta(s)",
        "domain": "Re(s) > 1",
        "convergence": "absolute",
        "exact_transform": "yes",
        "classification": "E2",
        "evidence": "mellin_zetaKernel_eq_Gamma_mul_zeta, riemannZeta_eulerProduct_exp_log",
        "evaluator": "exact Mellin/Euler representation; numerical evaluation remains separate",
    },
    {
        "id": "A10",
        "kind": "series",
        "object": "Dirichlet series in the critical strip",
        "domain": "0 < Re(s) < 1",
        "convergence": "not absolutely convergent; raw series is conditionally grouped",
        "exact_transform": "yes",
        "classification": "E3",
        "evidence": "mellin_regularizedKernel_eq_of_re_pos_of_lt_one, regularizedMellin",
        "evaluator": "exact finite part/analytic continuation; no raw truncation",
    },
    {
        "id": "A11",
        "kind": "integral",
        "object": "Mellin/Laplace integral of 1/(e^t-1)",
        "domain": "Re(s) > 1 for the raw integral; finite part in 0 < Re(s) < 1",
        "convergence": "absolutely convergent in Re(s) > 1",
        "exact_transform": "yes",
        "classification": "E2",
        "evidence": "hasSum_mellin_zetaKernel, mellin_zetaKernel_eq_Gamma_mul_zeta",
        "evaluator": "exact integral representation; Γζ evaluation separate",
    },
    {
        "id": "A12",
        "kind": "transform",
        "object": "Completed zeta and finite part Lambda_0",
        "domain": "completed zeta; finite part in the critical strip",
        "convergence": "analytic continuation via the completed functional equation",
        "exact_transform": "yes",
        "classification": "E3",
        "evidence": "completedRiemannZeta_functional_equation, completedRiemannZeta_finite_part, completedRiemannZeta0_functional_equation",
        "evaluator": "exact finite part plus functional equation",
    },
    {
        "id": "A13",
        "kind": "product",
        "object": "Euler product over primes and its log-series",
        "domain": "Re(s) > 1",
        "convergence": "absolute local factors; summable log-series",
        "exact_transform": "yes",
        "classification": "E2",
        "evidence": "riemannZeta_eulerProduct_exp_log, eulerLogSeries_coil, finite_eulerProduct_exp_log",
        "evaluator": "exact product-to-sum/coil; zeta evaluation remains separate",
    },
    {
        "id": "A14",
        "kind": "contour",
        "object": "Pole-term contour integral of h(z)/(z(z-1))",
        "domain": "h holomorphic on a disk containing 0 and 1",
        "convergence": "finite contour integral",
        "exact_transform": "yes",
        "classification": "E1",
        "evidence": "explicitFormula_poleContour, explicitFormula_poleContour_residue_form",
        "evaluator": "closed contour value 2*pi*I*(h(1)-h(0))",
    },
    {
        "id": "A15",
        "kind": "sum-over-zeros",
        "object": "Explicit-formula zero sum sum_rho h(rho) and Weil positivity",
        "domain": "zeta zeros; test functions",
        "convergence": "conditional/zero-dependent",
        "exact_transform": "open",
        "classification": "O",
        "evidence": "no Lean theorem; see README/index O4",
        "evaluator": "not assigned; finite truncation would not prove positivity",
    },
    {
        "id": "A16",
        "kind": "series",
        "object": "Rational series 1/(1-z) = sum z^n",
        "domain": "|z| < 1",
        "convergence": "absolute",
        "exact_transform": "yes",
        "classification": "E1",
        "evidence": "geometric_hasSum_complex, geometric_tsum_complex; finite geometric computation in test_geometric_partial_sum",
        "evaluator": "closed form 1/(1-z)",
    },
    {
        "id": "A17",
        "kind": "evaluator",
        "object": "Partial-sum-plus-tail certified evaluator",
        "domain": "arbitrary series with a tail bound or closed tail",
        "convergence": "depends on the input",
        "exact_transform": "no",
        "classification": "F",
        "evidence": "depth-axis companion topic partial-sum-plus-tail; no exact transform claimed here",
        "evaluator": "certified finite evaluator; fallback only",
    },
    {
        "id": "A18",
        "kind": "transform",
        "object": "Layer-cake representation a_n = integral 1_{t < a_n} dt",
        "domain": "a_n >= 0",
        "convergence": "Tonelli, no convergence issue",
        "exact_transform": "yes",
        "classification": "E2",
        "evidence": "layer_cake",
        "evaluator": "exact representation; no closed evaluation",
    },
    {
        "id": "A19",
        "kind": "series",
        "object": "Once-subtracted annular continuation on -1 < Re(s)",
        "domain": "-1 < Re(s), s not in {0, 1}",
        "convergence": "conditionally/regularized; first-order kernel bound",
        "exact_transform": "yes",
        "classification": "E3",
        "evidence": "regularizedReal_nonneg, regularizedReal_le_div_twelve; mellinConvergent_regularizedKernel_of_neg_one_lt, differentiableAt_mellin_regularizedKernel_of_neg_one_lt; mellin_regularizedKernel_eq_of_neg_one_lt_re (T53-T55)",
        "evaluator": "exact finite part on the doubled strip; no raw truncation",
    },
    {
        "id": "A20",
        "kind": "transform",
        "object": "Completed annular part and functional equation",
        "domain": "-1 < Re(s); completed part, with the critical-strip FE",
        "convergence": "completed finite part; entire comparison target",
        "exact_transform": "yes",
        "classification": "E3",
        "evidence": "completedMellinPart_eq_completedRiemannZeta₀, completedMellinPart_one_sub (T56-T57)",
        "evaluator": "exact completed finite part plus functional equation as an integral identity",
    },
    {
        "id": "A21",
        "kind": "series",
        "object": "Second Bernoulli subtraction on -3 < Re(s)",
        "domain": "-3 < Re(s) away from {-2, -1, 0, 1}",
        "convergence": "conditionally/regularized; second-order kernel bound",
        "exact_transform": "yes",
        "classification": "E3",
        "evidence": "hasMellin_linCutoff, norm_regularizedKernel₂_le, mellinConvergent_regularizedKernel₂, differentiableAt_mellin_regularizedKernel₂, mellin_regularizedKernel₂_eq_of_neg_three_lt_re, mellin_regularizedKernel₂_sub, regularizedMellin₂_residue_neg_one (T58-T63)",
        "evaluator": "exact twice-subtracted finite part; pole at -1 explicitly cancelled",
    },
    {
        "id": "A22",
        "kind": "transform",
        "object": "General k-th Bernoulli subtraction and full-plane finite part",
        "domain": "all k; full complex plane",
        "convergence": "not yet proved",
        "exact_transform": "open",
        "classification": "O",
        "evidence": "not formalised; open item O8",
        "evaluator": "not assigned",
    },
    {
        "id": "A23",
        "kind": "series",
        "object": "Single-prime Bost-Connes angular series",
        "domain": "prime p; Re(s) > 0",
        "convergence": "absolute geometric series with ratio p^(-s)",
        "exact_transform": "yes",
        "classification": "E1",
        "evidence": "bostConnes_single_prime_angular, bostConnes_single_prime_tsum (T68-T69)",
        "evaluator": "closed form 1/(1 - p^(-s))",
    },
    {
        "id": "A24",
        "kind": "product",
        "object": "All-prime Bost-Connes angular product",
        "domain": "Re(s) > 1",
        "convergence": "absolute Euler product",
        "exact_transform": "yes",
        "classification": "E2",
        "evidence": "bostConnes_all_primes_product, bostConnes_all_primes_tprod (T70-T71)",
        "evaluator": "exact Euler product; zeta evaluation separate",
    },
    {
        "id": "A25",
        "kind": "obstruction",
        "object": "Commensurability of prime logs",
        "domain": "distinct primes p, q; positive m, n",
        "convergence": "not a series; exact arithmetic obstruction",
        "exact_transform": "no",
        "classification": "X",
        "evidence": "log_primes_not_commensurable (T72)",
        "evaluator": "no common positive period; finite monodromy obstructed",
    },
]


def rows() -> List[Dict[str, str]]:
    """Return a copy of the audit matrix."""
    return [dict(row) for row in AUDIT_ROWS]


def by_id() -> Dict[str, Dict[str, str]]:
    """Index the audit matrix by id."""
    return {row["id"]: row for row in AUDIT_ROWS}


def summary() -> Dict[str, int]:
    """Count rows by classification."""
    return dict(sorted(Counter(row["classification"] for row in AUDIT_ROWS).items()))


def validate() -> None:
    """Raise ``ValueError`` if the audit matrix is malformed."""
    seen = set()
    for row in AUDIT_ROWS:
        missing = [field for field in REQUIRED_FIELDS if not row.get(field)]
        if missing:
            raise ValueError(f"{row.get('id', '?')}: missing {missing}")
        if row["id"] in seen:
            raise ValueError(f"duplicate audit id {row['id']}")
        seen.add(row["id"])
        if row["classification"] not in CLASSES:
            raise ValueError(f"{row['id']}: unknown classification {row['classification']}")
        if row["exact_transform"] not in {"yes", "no", "open"}:
            raise ValueError(f"{row['id']}: bad exact_transform flag")
        if row["classification"] in {"E1", "E2", "E3"} and row["exact_transform"] != "yes":
            raise ValueError(f"{row['id']}: exact class needs exact_transform=yes")
        if row["classification"] == "O" and row["exact_transform"] != "open":
            raise ValueError(f"{row['id']}: open class needs exact_transform=open")


validate()
