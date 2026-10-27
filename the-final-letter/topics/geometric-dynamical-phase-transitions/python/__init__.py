"""Exact finite arithmetic for geometric dynamical phase transitions.

The package is a thin, side-effect-free layer over
:mod:`python.programme`.
"""

from .programme import (
    atomic_mass,
    atomic_mass_bound_holds,
    atomic_weight,
    complete_block_sum,
    filter_coefficient,
    filter_coefficients,
    filter_coefficients_dict,
    quadratic_link,
    tempered_weight,
    two_sum_coefficients,
    two_sum_identity_holds,
)

__all__ = [
    "filter_coefficient",
    "filter_coefficients",
    "complete_block_sum",
    "quadratic_link",
    "two_sum_coefficients",
    "filter_coefficients_dict",
    "two_sum_identity_holds",
    "tempered_weight",
    "atomic_weight",
    "atomic_mass",
    "atomic_mass_bound_holds",
]

from .bridges import (
    clock_zero,
    clock_zero_is_zero,
    clock_zero_residual,
    last_chord_abs,
    last_chord_product,
    last_chord_twin_difference,
    local_diagonal_integral,
    local_diagonal_normalized,
    prefactor,
    prefactor_lower_bound_holds,
    self_dual_abscissa,
)

__all__ += [
    "clock_zero",
    "clock_zero_is_zero",
    "clock_zero_residual",
    "last_chord_abs",
    "last_chord_product",
    "last_chord_twin_difference",
    "local_diagonal_integral",
    "local_diagonal_normalized",
    "prefactor",
    "prefactor_lower_bound_holds",
    "self_dual_abscissa",
]

from .bridges import (
    eta_coefficients,
    heat_flow_reduces_to_polygon,
    heat_flowed_polygon,
    register_coefficient_at_multiple,
)

__all__ += [
    "eta_coefficients",
    "heat_flow_reduces_to_polygon",
    "heat_flowed_polygon",
    "register_coefficient_at_multiple",
]

from .bridges import dh_coeffs, dh_is_odd, dh_mean_zero, dh_xi

__all__ += ["dh_coeffs", "dh_is_odd", "dh_mean_zero", "dh_xi"]

from .bridges import last_chord_complex, last_chord_complex_product

__all__ += ["last_chord_complex", "last_chord_complex_product"]

from .bridges import last_chord_ratio

__all__ += ["last_chord_ratio"]

from .transfer_nogo import (
    reg_coeff,
    reg_coupling,
    reg_matrix,
    reg_product,
    reg_product_matches_polygon,
    reg_topright_sum,
    register_couplings_nonnegative,
)

__all__ += [
    "reg_coeff",
    "reg_coupling",
    "reg_matrix",
    "reg_product",
    "reg_product_matches_polygon",
    "reg_topright_sum",
    "register_couplings_nonnegative",
]

from .bridges import heat_flow_derivative

__all__ += ["heat_flow_derivative"]

from .matrix_nogo import (
    all_entries_nonneg,
    contraction,
    eta_two_neg_one,
    mat_prod,
    nonnegative_contraction,
)

__all__ += [
    "all_entries_nonneg",
    "contraction",
    "eta_two_neg_one",
    "mat_prod",
    "nonnegative_contraction",
]

from .signed_f4 import (
    SINV,
    S,
    contraction,
    gauge,
    gauge_contraction_preserved,
    gauge_product,
    signed_reg_mat,
    signed_represents_polygon,
)

__all__ += [
    "S", "SINV", "contraction", "gauge", "gauge_contraction_preserved",
    "gauge_product", "signed_reg_mat", "signed_represents_polygon",
]

from .lee_yang import ising2_partition, ising2_roots, ising2_roots_on_unit_circle

__all__ += ["ising2_partition", "ising2_roots", "ising2_roots_on_unit_circle"]

from .partial_sum_tail import (
    geometric_partial,
    geometric_tail,
    geometric_total,
    partial_plus_tail,
    residual_bound_holds,
    three_tail_bound_holds,
)

__all__ += [
    "geometric_partial", "geometric_tail", "geometric_total",
    "partial_plus_tail", "residual_bound_holds", "three_tail_bound_holds",
]

from .polygon_zero import (
    box, certified, contains, f, fp, krawczyk_image, off_critical_certificate, real_part_interval,
)

__all__ += [
    "box", "certified", "contains", "f", "fp", "krawczyk_image",
    "off_critical_certificate", "real_part_interval",
]

from .polygon_zero import CENTRES, all_certified, two_distinct_real_parts

__all__ += ["CENTRES", "all_certified", "two_distinct_real_parts"]
