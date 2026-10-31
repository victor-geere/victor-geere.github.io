"""Tests for the finite uniform bound and its KMS growth."""

import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "python"))

import kms_transverse as K  # noqa: E402
import uniform_bound as U  # noqa: E402


def test_finite_bound_holds():
    for n in (2, 3, 4):
        rho = K.random_density(n, seed=2)
        for a in K.hermitian_basis(n):
            assert U.bound_holds(rho, a)


def test_kms_norm_grows_with_level():
    norms = [U.kms_norm(1.0, k, 2.0) for k in (1, 2, 4, 8)]
    assert norms == sorted(norms)
    assert norms[-1] > 4 * norms[0]
