"""Tests for the missing-bridge computations (C1–C17)."""

import math
import sys
from pathlib import Path

import pytest

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "python"))
from programme import (  # noqa: E402
    admissible_epsilon,
    arch_kernel,
    arithmetic_gram_entry,
    archimedean_omega,
    convex_combination,
    convex_combination_psd,
    diag_block_eigenvalues,
    diag_block_psd,
    gaussian_mode,
    gaussian_test,
    offline_quad,
    on_line_quad,
    on_line_quad_sos,
    diag_block_linear,
    geometric_tail_radius,
    gram_entry_from_weights,
    lambda_min_diag_block,
    kernel_gram,
    lambda_min_derivative,
    linear_path_criterion,
    linear_path_psd_by_sampling,
    max_abs_offline_quad,
    min_eigenpair,
    on_line_weights,
    pole_main_identity_error,
    pole_minus_prime_main,
    prime_kernel,
    prime_main_ratio,
    prime_error_kernel,
    prime_main_term,
    prime_side,
    pole_term,
    pseries_tail_radius,
    rank_one_factor,
    sandwich_2x2,
    symmetric_eigenvalues,
    toeplitz_kernel_gram,
    toeplitz_lambda_min,
    von_mangoldt,
    weil_entry,
    weil_gram,
    weil_kernel,
)

A = [-0.3, -0.1, 0.1, 0.3]
C = [1.0, -2.0, 0.5, 3.0]


# C1 -----------------------------------------------------------------------

def test_on_line_form_equals_its_sum_of_squares():
    for sigma in (0.02, 0.05, 0.1):
        for gamma in (0.0, 1.7, 14.1347):
            lhs = on_line_quad(A, sigma, gamma, C)
            rhs = on_line_quad_sos(A, sigma, gamma, C)
            assert math.isclose(lhs, rhs, rel_tol=0, abs_tol=1e-12)
            assert rhs >= 0.0


def test_on_line_form_is_nonnegative_for_signed_coefficients():
    for coefs in ([1, 1, 1, 1], [1, -1, 1, -1], [-3, 2, -1, 0.5]):
        value = on_line_quad(A, 0.05, 7.0, coefs)
        assert value >= -1e-15
        assert math.isclose(value, on_line_quad_sos(A, 0.05, 7.0, coefs),
                            rel_tol=0, abs_tol=1e-12)


# C2 -----------------------------------------------------------------------

def test_rank_one_factorization_holds_on_the_critical_line():
    a, b, sigma, t = 0.3, -0.1, 0.05, 14.1347
    lhs = gaussian_test(a - b, sigma, complex(0.5, t))
    rhs = rank_one_factor(a, b, sigma, t)
    assert abs(complex(lhs) - rhs) < 1e-12
    # the modes are nonzero
    assert abs(gaussian_mode(a, sigma, t)) > 0.0


def test_rank_one_factorization_fails_off_the_critical_line():
    a, b, sigma, t = 0.3, -0.1, 0.05, 14.1347
    rho = complex(0.5 + 0.1, t)
    value = gaussian_test(a - b, sigma, rho)
    # an on-line value is a product of modes and hence has the phase of
    # φ_a conj φ_b; off the line it acquires a real exponential factor
    on_line = rank_one_factor(a, b, sigma, t)
    assert abs(complex(value) - on_line) > 1e-6
    assert abs(complex(value).imag) > 0.0


# C3 -----------------------------------------------------------------------

def test_von_mangoldt_values_and_errors():
    assert von_mangoldt(1) == 0.0
    assert math.isclose(von_mangoldt(2), math.log(2))
    assert math.isclose(von_mangoldt(4), math.log(2))
    assert math.isclose(von_mangoldt(8), math.log(2))
    assert math.isclose(von_mangoldt(9), math.log(3))
    assert von_mangoldt(6) == 0.0
    assert von_mangoldt(12) == 0.0
    with pytest.raises(ValueError):
        von_mangoldt(0)


def test_prime_side_is_a_manifest_sum_of_nonnegative_terms():
    values = [prime_side(0.5, 0.05, n) for n in (10, 100, 1000)]
    assert all(v >= 0.0 for v in values)
    assert values[0] <= values[1] <= values[2]
    # and every coefficient is nonnegative
    assert all(von_mangoldt(n) >= 0.0 for n in range(1, 100))


def test_archimedean_density_is_signed():
    assert archimedean_omega(0.0) < 0.0
    assert archimedean_omega(20.0) > 0.0
    # the assembled off-diagonal entry takes both signs
    assert weil_entry(0.0, 0.05) > 0.0
    assert weil_entry(1.0, 0.05) < 0.0


# C4 -----------------------------------------------------------------------

def test_offline_block_fails_for_large_separation():
    sigma, delta, gamma = 0.05, 0.1, 14.1347
    s0 = offline_quad(0.0, sigma, delta, gamma)
    assert s0 > 0.0
    failures = []
    for c in (0.0, 2.0, 4.0, 8.0, 16.0):
        sc = offline_quad(c, sigma, delta, gamma)
        lo, _hi = diag_block_eigenvalues(s0, sc)
        if lo < 0:
            failures.append(c)
    assert failures, "no separation broke the off-line block"
    assert not diag_block_psd(s0, abs(offline_quad(16.0, sigma, delta, gamma)))


def test_offline_quad_is_even_in_c():
    sigma, delta, gamma = 0.05, 0.1, 14.1347
    for c in (0.5, 1.0, 3.0):
        assert math.isclose(offline_quad(c, sigma, delta, gamma),
                            offline_quad(-c, sigma, delta, gamma),
                            rel_tol=0, abs_tol=1e-12)
    with pytest.raises(ValueError):
        offline_quad(1.0, 0.0, 0.1, 14.1347)


# C5 -----------------------------------------------------------------------

def test_admissible_margin_shrinks_with_dimension():
    margin = 227 / 10000
    eps4 = admissible_epsilon(margin, 4)
    eps100 = admissible_epsilon(margin, 100)
    assert eps4 > eps100 > 0
    assert math.isclose(eps4, margin / 4)
    assert math.isclose(eps4 * 4, margin)
    # the certificate's stated margin
    assert math.isclose(eps4, 0.005675)
    with pytest.raises(ValueError):
        admissible_epsilon(0.0, 4)
    with pytest.raises(ValueError):
        admissible_epsilon(margin, 0)


# C6 -----------------------------------------------------------------------
def test_convex_combinations_of_psd_blocks_stay_psd():
    # A and B are PSD symmetric diagonal blocks
    a1, b1 = 1.0, 0.5
    a2, b2 = 2.0, 0.1
    assert diag_block_psd(a1, b1) and diag_block_psd(a2, b2)
    for t in (0.0, 0.25, 0.5, 0.75, 1.0):
        lo, hi = convex_combination(a1, b1, a2, b2, t)
        assert lo >= -1e-15 and hi >= 0.0
        assert convex_combination_psd(a1, b1, a2, b2, t)
    with pytest.raises(ValueError):
        convex_combination(a1, b1, a2, b2, 1.5)


# C7 -----------------------------------------------------------------------
def test_prime_kernel_is_indefinite_despite_nonnegative_coefficients():
    """Every scalar term is nonnegative, but the kernel is not PSD.

    This is the numerical form of the objective-1 obstruction: the prime
    side is not a manifest sum of squares term by term.
    """
    for sigma in (0.05, 0.1, 0.2):
        kernel = prime_kernel(A, sigma, n_max=4000)
        eigs = symmetric_eigenvalues(kernel)
        assert min(eigs) < -1e-6
        assert max(eigs) > 1e-6
        # the diagonal is nonnegative, so the indefiniteness is off-diagonal
        assert all(kernel[i][i] >= 0.0 for i in range(len(A)))
    with pytest.raises(ValueError):
        prime_kernel(A, 0.0)


# C8 -----------------------------------------------------------------------
def test_positivity_preserving_sandwich_can_lower_lambda_min():
    """Congruence preserves PSD but need not be λ_min-monotone."""
    base = [[2.0, 1.0], [1.0, 2.0]]
    eigs_base = symmetric_eigenvalues(base)
    assert min(eigs_base) > 0.0

    squeezed = sandwich_2x2(2.0, 1.0, 2.0, 1.0, 0.5)
    eigs_squeezed = symmetric_eigenvalues(squeezed)
    assert all(e >= -1e-12 for e in eigs_squeezed)
    assert min(eigs_squeezed) < min(eigs_base) - 0.1

    degenerate = sandwich_2x2(2.0, 1.0, 2.0, 1.0, 0.0)
    eigs_degenerate = symmetric_eigenvalues(degenerate)
    assert all(e >= -1e-12 for e in eigs_degenerate)
    assert math.isclose(min(eigs_degenerate), 0.0, abs_tol=1e-12)


# C9 -----------------------------------------------------------------------
def test_linear_path_crossing_matches_the_criterion():
    """A PSD base with an indefinite velocity crosses zero; PSD velocity does not."""
    assert lambda_min_diag_block(1.0, 0.0) == 1.0
    assert lambda_min_diag_block(1.0, 1.0) == 0.0
    assert lambda_min_diag_block(1.0, 2.0) == -1.0

    # indefinite velocity: crossing at t = 1
    assert not linear_path_criterion(1.0, 0.0, 0.0, 1.0)
    assert not linear_path_psd_by_sampling(1.0, 0.0, 0.0, 1.0, 10.0, 200)

    # PSD velocity: no crossing
    assert linear_path_criterion(1.0, 0.0, 1.0, 0.0)
    assert linear_path_psd_by_sampling(1.0, 0.0, 1.0, 0.0, 10.0, 200)

    # the criterion is exactly the pair of endpoint conditions
    for a, b, p, q in [(1.0, 0.5, 1.0, 0.2), (2.0, 1.0, 0.0, 0.0),
                       (1.0, 1.0, 1.0, 0.5), (0.0, 1.0, 1.0, 1.0)]:
        assert linear_path_criterion(a, b, p, q) == (
            lambda_min_diag_block(a, b) >= 0 and lambda_min_diag_block(p, q) >= 0
        )
    # the path matrix is the sum of the endpoint blocks
    assert diag_block_linear(1.0, 0.0, 0.0, 1.0, 2.0) == ((1.0, 2.0), (2.0, 1.0))
    with pytest.raises(ValueError):
        linear_path_psd_by_sampling(1.0, 0.0, 1.0, 0.0, 0.0, 10)


# C10 ----------------------------------------------------------------------
def test_sigma_derivative_of_lambda_min_changes_sign():
    """The Gaussian-width flow is not monotone: dλ_min/dσ changes sign."""
    d_small = lambda_min_derivative(A, 0.02)
    d_large = lambda_min_derivative(A, 0.03)
    assert d_small > 0.05
    assert d_large < -0.05
    # the eigenvalue itself barely moves, so the sign change is in the derivative
    lam_small = min_eigenpair(weil_gram(A, 0.02))[0]
    lam_large = min_eigenpair(weil_gram(A, 0.03))[0]
    assert abs(lam_small - lam_large) < 1e-2


# C11 ----------------------------------------------------------------------
def test_finite_gap_collapses_on_a_fixed_interval():
    """No uniform spectral gap for the Toeplitz family on [−0.3, 0.3]."""
    lam4 = toeplitz_lambda_min(4, 0.05)
    lam8 = toeplitz_lambda_min(8, 0.05)
    lam16 = toeplitz_lambda_min(16, 0.05)
    assert lam4 > 1e-2
    assert lam8 < 1e-3
    assert lam16 < 1e-5
    assert lam16 < lam4 / 1000


# C12 ----------------------------------------------------------------------
def test_annular_tail_radius_is_closed_form_only_in_special_cases():
    """The APM restates a tail as a radius; it is closed-form only sometimes."""
    # geometric series: R_n^2 = r^n/(1-r)
    r = 0.5
    for n in range(6):
        partial = sum(r ** k for k in range(n, 80))
        assert math.isclose(geometric_tail_radius(r, n), partial, rel_tol=0, abs_tol=1e-12)
    assert math.isclose(geometric_tail_radius(r, 0), 2.0, abs_tol=1e-12)

    # p-series: R_n^2 = Hurwitz zeta, a named special function
    sigma = 2.0
    assert math.isclose(pseries_tail_radius(sigma, 0), math.pi ** 2 / 6, rel_tol=0, abs_tol=1e-12)
    for n in range(5):
        partial = sum((k + 1) ** (-sigma) for k in range(n, 200000))
        assert math.isclose(pseries_tail_radius(sigma, n), partial, rel_tol=0, abs_tol=1e-4)
    with pytest.raises(ValueError):
        pseries_tail_radius(1.0, 0)


def test_positive_weights_do_not_make_the_gram_entry_positive():
    """The APM's nonnegative area represents the weight sum, not the signed entry."""
    gammas = [14.1347, 21.0220, 25.0109, 30.4249]
    weights = on_line_weights(0.05, gammas)
    assert all(w > 0.0 for w in weights)
    assert sum(weights) > 0.0
    assert gram_entry_from_weights(weights, gammas, 0.0) > 0.0
    assert gram_entry_from_weights(weights, gammas, 2.0) < 0.0
    with pytest.raises(ValueError):
        gram_entry_from_weights(weights, gammas[:-1], 0.0)


# C13 ----------------------------------------------------------------------
def test_larger_delta_dominates_smaller_delta():
    """A larger |δ| quadruple grows faster and defeats every uniform bound."""
    sigma = 0.05
    small = max_abs_offline_quad(0.0, 40.0, 4000, sigma, 0.1, 14.1347)
    large = max_abs_offline_quad(0.0, 40.0, 4000, sigma, 0.2, 21.022)
    assert large > 10.0 * small

    # the larger-|delta| quadruple exceeds any fixed bound as c grows
    assert max_abs_offline_quad(0.0, 60.0, 6000, sigma, 0.2, 21.022) > 10.0
    assert max_abs_offline_quad(0.0, 60.0, 6000, sigma, 0.3, 21.022) > 100.0

    with pytest.raises(ValueError):
        max_abs_offline_quad(0.0, 40.0, 4000, 0.0, 0.1, 14.1347)
    with pytest.raises(ValueError):
        max_abs_offline_quad(0.0, 0.0, 4000, sigma, 0.1, 14.1347)


# C14 ----------------------------------------------------------------------
def test_prime_main_term_matches_the_pole_and_the_prime_sum():
    """The smooth PNT main term is the growing half of the pole term."""
    for sigma in (0.05, 0.2):
        for c in (4.0, 6.0, 8.0, 10.0):
            residual = pole_minus_prime_main(c, sigma)
            expected = 2 * math.pi * sigma ** 2 * math.exp(sigma ** 2 / 4) * math.exp(-c / 2)
            assert math.isclose(residual, expected, rel_tol=1e-12, abs_tol=1e-14)

    # wide Gaussian window: the smooth PNT is accurate
    assert abs(prime_main_ratio(10.0, 0.2, 109107) - 1.0) < 1e-4
    # narrow window: the PNT error is the hard regime
    assert abs(prime_main_ratio(10.0, 0.05, 32869) - 1.0) > 1e-3
    with pytest.raises(ValueError):
        prime_main_term(1.0, 0.0)


# C15 ----------------------------------------------------------------------
def test_arithmetic_gram_entry_is_two_pnt_errors_plus_arch():
    """The pole cancels exactly: K(c) = [P_main − P](c) + [P_main − P](−c) + arch."""
    for sigma in (0.05, 0.2):
        for c in (0.0, 0.2, 0.6, 1.0):
            lhs = weil_kernel(c, sigma, 4000)
            rhs = arithmetic_gram_entry(c, sigma, 4000)
            assert math.isclose(lhs, rhs, rel_tol=0, abs_tol=1e-12)
            assert math.isclose(
                pole_term(c, sigma),
                prime_main_term(c, sigma) + prime_main_term(-c, sigma),
                rel_tol=0, abs_tol=1e-12,
            )


# C16 ----------------------------------------------------------------------
def test_pnt_error_and_arch_are_individually_indefinite_but_sum_is_psd():
    """The arithmetic positivity is a cancellation, not termwise positivity."""
    centres = [-0.3, -0.1, 0.1, 0.3]
    sigma = 0.05
    err_gram = kernel_gram(prime_error_kernel, centres, sigma)
    arch_gram = kernel_gram(arch_kernel, centres, sigma)
    total_gram = kernel_gram(weil_kernel, centres, sigma)
    assert min_eigenpair(err_gram)[0] < -1e-3
    assert min_eigenpair(arch_gram)[0] < -1e-2
    assert min_eigenpair(total_gram)[0] > 1e-3


# C17 ----------------------------------------------------------------------
def test_cancellation_persists_under_refinement():
    """The PNT-error/arch cancellation holds at n = 4, 8, 16; the total gap shrinks."""
    sigma = 0.05
    gaps = []
    for n in (4, 8, 16):
        err_gram = toeplitz_kernel_gram(n, sigma, prime_error_kernel)
        arch_gram = toeplitz_kernel_gram(n, sigma, arch_kernel)
        total_gram = toeplitz_kernel_gram(n, sigma, weil_kernel)
        assert min_eigenpair(err_gram)[0] < -1e-3
        assert min_eigenpair(arch_gram)[0] < -1e-2
        gap = min_eigenpair(total_gram)[0]
        assert gap > 0.0
        gaps.append(gap)
    # the gap collapses under refinement, as in C11
    assert gaps[2] < gaps[0] / 100


# C18 ----------------------------------------------------------------------
def test_pole_main_identity():
    """The pole term is exactly the sum of the two prime main terms."""
    for sigma in (0.05, 0.2, 0.5):
        for c in (-10.0, -1.0, 0.0, 1.0, 10.0):
            assert abs(pole_main_identity_error(c, sigma)) < 1e-10


def test_prime_side_bounded_by_von_mangoldt_mass():
    from programme import prime_side, prime_side_mass_bound

    for c in (0.0, 0.5, -1.0):
        for n in (10, 100, 400):
            assert prime_side(c, 0.5, n) <= prime_side_mass_bound(c, 0.5, n) + 1e-9
    with pytest.raises(ValueError):
        prime_side_mass_bound(0.0, -0.1, 10)
