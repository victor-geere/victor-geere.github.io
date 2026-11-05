"""Tests for the curated computation layer (``python/programme.py``).

Each test corresponds to a **Computation** row of the programme ledger.  The
suite is the fast canonical subset: the heavier probes (the 4×4 Gaussian
eigenvalue computation) are included here as the one high-precision check,
while the topic's focused module tests carry the detailed coverage.
"""

import sys
from pathlib import Path

import pytest

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "python"))

import programme as P  # noqa: E402


# ---------------------------------------------------------------------------
# local rank-three model
# ---------------------------------------------------------------------------

def test_local_hodge_index():
    d = P.local_hodge_index(grid=3)
    assert d["signature"] == (1, 2)
    assert d["ample_square"] == 6
    assert d["hodge_index_ok"] and d["defect_identity_ok"]
    assert d["negative_definite_on_ample_orthogonal"]
    assert d["restricted_gram"] == [[-2, 0], [0, -6]]


def test_local_hodge_index_rejects_bad_grid():
    with pytest.raises(ValueError):
        P.local_hodge_index(grid=0)


# ---------------------------------------------------------------------------
# finite positivity layers
# ---------------------------------------------------------------------------

def test_finite_hodge_riemann_half_weight():
    d = P.finite_hodge_riemann_half_weight(n=3, seed=5)
    assert d["half_weight_positive"]
    assert d["C_half"] > 0.0


def test_finite_crossed_product_hodge_index():
    d = P.finite_crossed_product_hodge_index(n=3)
    assert d["dimension"] == 6
    assert d["tracial_ok"] and d["nontracial_ok"]


def test_kms_kernel_form_is_negative_semidefinite():
    for n, seed in ((2, 0), (3, 1), (4, 2)):
        d = P.kms_kernel_form(n=n, seed=seed)
        assert d["negative_semidefinite"], (n, seed, d["eigenvalues"])


def test_krein_hodge_realization():
    d = P.krein_hodge_realization()
    assert d["S_squared_error"] < 1e-12
    assert d["preserves_Q_error"] < 1e-12
    assert d["fixes_ample_error"] < 1e-12
    assert d["signature_S"] == [1, 2]
    assert d["signature_h"] == [3, 0]


# ---------------------------------------------------------------------------
# CCM probe and the symbol
# ---------------------------------------------------------------------------

def test_ccm_probe_accuracy():
    d = P.ccm_probe_accuracy()
    assert d["max_deviation"] < d["tolerance"]


def test_archimedean_symbol_identity():
    for xi in (2.0, 10.0):
        d = P.archimedean_symbol_identity(xi)
        assert d["difference"] < 1e-12


def test_symbol_identity_check():
    d = P.symbol_identity_check(10.0)
    assert d["abs_difference"] < 1e-12


# ---------------------------------------------------------------------------
# Gaussian Gram: eigenvalues and the recorded interval certificate
# ---------------------------------------------------------------------------

def test_gaussian_gram_4x4():
    d = P.gaussian_gram_4x4()
    assert d["W_psd"]
    assert min(d["W_eigenvalues"]) > 0.02
    # the recorded normalization is indefinite on the same basis
    assert min(d["N_eigenvalues"]) < 0.0


def test_recorded_gram6_certificate():
    d = P.recorded_gram6_certificate()
    assert d["n"] == 6
    assert d["ok"]
    assert abs(d["t"] - d["recorded_t"]) < 1e-12
    assert min(d["minors"]) > 0.0


# ---------------------------------------------------------------------------
# truncation diagnostics
# ---------------------------------------------------------------------------

def test_spectral_gap_even_and_odd():
    even = P.spectral_gap(6)
    assert not even["degenerate"]
    assert even["min_gap"] is not None and even["min_gap"] > 0.0
    odd = P.spectral_gap(7)
    assert odd["degenerate"]
    assert odd["min_gap"] is None


def test_spectral_gap_rejects_small_k():
    with pytest.raises(ValueError):
        P.spectral_gap(2)


def test_smooth_window_gap():
    d = P.smooth_window_gap(12, "sin2")
    assert d["gap"] > 0.0
    assert d["condition_number"] > 0.0
    with pytest.raises(ValueError):
        P.smooth_window_gap(12, "no-such-window")


def test_prime_arch_split():
    d = P.prime_arch_split(12)
    # the K=16 near-degeneracy is prime-driven (note 16)
    assert d["prime_min"] < d["arch_min"]
    assert d["prime_min"] > 0.0


def test_uv_localisation():
    d = P.uv_localisation(16)
    assert set(d) == {"prime", "arch", "total"}
    assert d["total"]["participation_ratio"] < d["arch"]["participation_ratio"]
    assert 0.0 < d["total"]["top_mass"] <= 1.0
