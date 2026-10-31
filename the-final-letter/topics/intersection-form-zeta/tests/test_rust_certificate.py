"""Verification of the Rust-generated certificate.

This mirrors ``test_weil_shadow.py`` but reads
``python/rust_certificate.json`` (whose numeric leaves are exact ``"p/q"``
strings) and cross-checks it against independent high-precision values
computed here with mpmath, not against the Rust program's own numbers.
"""

import json
import sys
from fractions import Fraction
from pathlib import Path

import mpmath as mp
import pytest

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "python"))

import weil_shadow as W  # noqa: E402

RUST = ROOT / "python" / "rust_certificate.json"
PY_CERT = ROOT / "python" / "weil_certificate.json"
LEAN = ROOT / "lean" / "Certificate.lean"
mp.mp.dps = 50


def Q(s):
    """Exact rational from ``"p/q"`` or a decimal string."""
    return Fraction(s)


def M(q):
    """mpmath value of an exact Fraction."""
    return mp.mpf(q.numerator) / q.denominator


@pytest.fixture(scope="module")
def cert():
    if not RUST.exists():
        pytest.fail("run `cargo run --release -- --out-json python/rust_certificate.json`")
    return json.loads(RUST.read_text(encoding="utf-8"))


@pytest.fixture(scope="module")
def py_cert():
    return json.loads(PY_CERT.read_text(encoding="utf-8"))


@pytest.fixture(scope="module")
def gram(cert):
    return [[(Q(lo), Q(hi)) for lo, hi in row] for row in cert["gram"]]


def test_schema_and_status(cert):
    required = {
        "gram", "gram_raw", "sigma", "centres", "prime_cutoff",
        "density_panels", "margin", "density", "centre_matrix",
        "conversion_slack", "operator_slack", "leading_minors",
        "ldl_pivots", "ldl", "omega_samples", "numerical", "provenance",
    }
    assert required <= set(cert)
    assert cert["status"] == "certified"
    assert cert["prime_cutoff"] == 20000
    assert Q(cert["sigma"]) == Fraction(1, 20)
    assert Q(cert["margin"]) == Fraction(1, 10000)
    assert Q(cert["conversion_slack"]) == Fraction(1, 10**9)
    assert len(cert["gram"]) == 4
    assert all(len(row) == 4 for row in cert["gram"])


def test_interval_matrix_is_symmetric(gram):
    for i in range(4):
        for j in range(4):
            assert gram[i][j][0] <= gram[i][j][1]
            assert gram[i][j] == gram[j][i]


def test_certificate_is_positive_definite(cert, gram):
    ok, t, minors, pivots = W.certificate_ok(gram)
    assert ok
    assert all(m > 0 for m in minors)
    assert all(p > 0 for p in pivots)
    # The true fourth minor is ~1.8e-6, so this is a genuine (not vacuous) check.
    assert min(float(m) for m in minors) < 1e-5
    assert t == Q(cert["operator_slack"])


def test_ldl_factorisation_is_exact(cert, gram):
    L = [[Q(x) for x in row] for row in cert["ldl"]["L"]]
    d = [Q(x) for x in cert["ldl"]["d"]]
    P = [[Q(x) for x in row] for row in cert["ldl"]["P"]]
    assert W.rational_factorization_ok(gram, L, d)
    G0, E, t = W.box_data(cert)
    for i in range(4):
        for j in range(4):
            assert Q(cert["centre_matrix"][i][j]) == G0[i][j]
            assert Q(cert["ldl"]["P"][i][j]) == P[i][j]
            assert P[i][j] == G0[i][j] - (t if i == j else 0)
    assert all(L[i][i] == 1 for i in range(4))
    assert all(L[i][j] == 0 for i in range(4) for j in range(i + 1, 4))


def test_box_contains_numerical_matrix(cert, gram):
    A = [[Q(x) for x in row] for row in cert["numerical"]["gram"]]
    G0, E, t = W.box_data(cert)
    assert W.box_contains(G0, E, A)
    assert all(A[i][j] == A[j][i] for i in range(4) for j in range(4))
    assert max(sum(row) for row in E) <= t


def test_gram_contains_independent_numerical_gram(cert, gram):
    sigma = mp.mpf(cert["sigma"])
    centres = [mp.mpf(c) for c in cert["centres"]]
    A = W.numerical_gram(centres, sigma, 20000)
    for i in range(4):
        for j in range(4):
            value = Q(mp.nstr(A[i][j], 45))
            assert gram[i][j][0] <= value <= gram[i][j][1]


def test_gram_overlaps_python_certificate(cert, py_cert, gram):
    """The two independent enclosures of the same matrix must overlap."""
    other = W.interval_matrix(py_cert)
    for i in range(4):
        for j in range(4):
            lo, hi = gram[i][j]
            lo2, hi2 = other[i][j]
            assert max(lo, lo2) <= min(hi, hi2)


def test_density_intervals(cert):
    sigma = mp.mpf(cert["sigma"])
    for rec in cert["density"]:
        lo, hi = Q(rec["lo"]), Q(rec["hi"])
        c = M(Q(rec["c"]))
        value = Q(mp.nstr(W.weil_gaussian_density(c, sigma), 45))
        assert lo <= value <= hi
        assert hi - lo < Fraction(1, 1000)


def test_density_overlaps_python_certificate(cert, py_cert):
    py = {rec["c"]: (Q(rec["lo"]), Q(rec["hi"])) for rec in py_cert["density"]}
    for rec in cert["density"]:
        c = rec["c"]
        lo, hi = Q(rec["lo"]), Q(rec["hi"])
        lo2, hi2 = py[str(float(Fraction(c)))]
        assert max(lo, lo2) <= min(hi, hi2)


def test_pole_intervals(cert):
    sigma = mp.mpf(cert["sigma"])
    for rec in cert["pole_intervals"]:
        lo, hi = Q(rec["lo"]), Q(rec["hi"])
        c = M(Q(rec["c"]))
        value = Q(mp.nstr(W.weil_gaussian_pole(c, sigma), 45))
        assert lo <= value <= hi
        assert hi - lo < Fraction(1, 10**12)


def test_prime_intervals(cert):
    sigma = mp.mpf(cert["sigma"])
    for rec in cert["prime_intervals"]:
        lo, hi = Q(rec["lo"]), Q(rec["hi"])
        c = M(Q(rec["c"]))
        value = Q(mp.nstr(W.weil_gaussian_prime(c, sigma, 20000), 45))
        assert lo <= value <= hi
        assert hi - lo < Fraction(1, 10**8)
        assert abs(float(lo + hi) / 2 - float(value)) < 1e-8


def test_prime_term_is_active(cert):
    """The prime sum is not a token: at c = 3/5 it moves the entry by 3.6e-2."""
    rec = next(r for r in cert["prime_intervals"] if Q(r["c"]) == Fraction(3, 5))
    assert abs(float(Q(rec["lo"]))) > 1e-3


def test_omega_samples_contain_digamma(cert):
    for rec in cert["omega_samples"]:
        lo, hi = Q(rec["lo"]), Q(rec["hi"])
        t = M(Q(rec["t"]))
        ref = Q(mp.nstr(W.omega_density(t), 45))
        assert lo <= ref <= hi
        assert hi - lo < Fraction(1, 10000)


def test_diagonal_contains_W_sigma(cert, gram):
    sigma = mp.mpf(cert["sigma"])
    value = W.weil_gaussian_W(0, sigma)
    lo, hi = gram[0][0]
    assert lo <= Q(mp.nstr(value, 45)) <= hi


def test_lean_file_is_sorry_free():
    text = LEAN.read_text(encoding="utf-8")
    for bad in ("sorry", "axiom ", "native_decide"):
        assert bad not in text
    assert "theorem certA_posDef" in text
    assert "theorem certP_posDef" in text
