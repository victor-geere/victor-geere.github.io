import sys
from decimal import Decimal
from fractions import Fraction
from pathlib import Path

import mpmath as mp
import pytest

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "python"))

import weil_shadow as W  # noqa: E402

CERT = ROOT / "python" / "weil_certificate.json"
mp.mp.dps = 30


def Q(s):
    """Exact rational from a decimal string, including scientific notation."""
    return Fraction(Decimal(str(s)))


@pytest.fixture(scope="module")
def cert():
    if not CERT.exists():
        pytest.fail("run `python3 python/certify_shadow.py` to record the certificate")
    return W.load_certificate(CERT)


def test_certificate_is_recorded_and_certified(cert):
    assert cert["status"] == "certified"
    G = W.interval_matrix(cert)
    assert len(G) == 4 and all(len(row) == 4 for row in G)
    for i in range(4):
        for j in range(4):
            assert G[i][j][0] <= G[i][j][1]
            assert G[i][j] == G[j][i]
    ok, t, minors, pivots = W.certificate_ok(G)
    assert ok
    assert all(m > 0 for m in minors)
    assert all(p > 0 for p in pivots)


def test_certificate_is_near_the_boundary(cert):
    """The fourth minor is positive but small: this is a real check."""
    G = W.interval_matrix(cert)
    ok, t, minors, pivots = W.certificate_ok(G)
    assert ok
    assert min(float(m) for m in minors) < 1e-5


def test_operator_slack_matches_recorded(cert):
    G = W.interval_matrix(cert)
    ok, t, minors, pivots = W.certificate_ok(G)
    assert ok
    assert abs(float(t) - float(mp.mpf(cert["operator_slack"]))) < 1e-12


def test_margin_is_recorded(cert):
    assert Q(cert["margin"]) == Fraction(1, 10000)


def test_gram_intervals_contain_recorded_numerical_gram(cert):
    G = W.interval_matrix(cert)
    for i in range(4):
        for j in range(4):
            value = Q(cert["numerical"]["gram"][i][j])
            assert G[i][j][0] <= value <= G[i][j][1]


def test_density_intervals_contain_recorded_numerical_density(cert):
    for rec in cert["density"]:
        lo, hi = Q(rec["lo"]), Q(rec["hi"])
        value = Q(cert["numerical"]["density"][rec["c"]])
        assert lo <= value <= hi


def test_diagonal_encloses_W_sigma(cert):
    sigma = mp.mpf(cert["sigma"])
    value = W.weil_gaussian_W(0, sigma)
    assert abs(value - mp.mpf(cert["numerical"]["W_sigma"])) < 1e-15
    lo, hi = W.interval_matrix(cert)[0][0]
    assert lo <= Q(mp.nstr(value, 25)) <= hi


def test_prime_term_is_active(cert):
    sigma = mp.mpf(cert["sigma"])
    value = W.weil_gaussian_prime(mp.mpf("0.6"), sigma)
    assert abs(float(value)) > 1e-3
    assert abs(float(value) - float(mp.mpf(cert["numerical"]["prime_at_06"]))) < 1e-15


def test_omega_enclosure_contains_digamma():
    for t in ["0", "0.5", "1", "10"]:
        iv = W.omega_enclosure(mp.mpf(t))
        width = float(iv.b - iv.a)
        assert 0 < width < 0.1
        ref = W.omega_density(mp.mpf(t))
        assert float(iv.a) - 1e-12 <= ref <= float(iv.b) + 1e-12


def test_omega_enclosure_matches_recorded_samples(cert):
    for rec in cert["omega_samples"]:
        iv = W.omega_enclosure(mp.mpf(rec["t"]))
        assert abs(float(iv.a) - float(mp.mpf(rec["lo"]))) < 1e-12
        assert abs(float(iv.b) - float(mp.mpf(rec["hi"]))) < 1e-12


def test_perturbed_certificate_is_rejected(cert):
    G = W.interval_matrix(cert)
    bad = [[(lo - Fraction(3, 100), hi - Fraction(3, 100)) if i == j else (lo, hi)
            for j, (lo, hi) in enumerate(row)] for i, row in enumerate(G)]
    ok, t, minors, pivots = W.certificate_ok(bad)
    assert not ok


def test_ldl_factorization_is_exact(cert):
    """The recorded rational L, d satisfy L diag(d) L^T = G0 - tI exactly."""
    import sympy as sp

    G = W.interval_matrix(cert)
    L = [[sp.Rational(x) for x in row] for row in cert["ldl"]["L"]]
    d = [sp.Rational(x) for x in cert["ldl"]["d"]]
    P = sp.Matrix([[sp.Rational(x) for x in row] for row in cert["ldl"]["P"]])
    assert W.rational_factorization_ok(G, L, d)
    M, t = W.centre_and_slack(G)
    assert P == M - sp.Rational(t.numerator, t.denominator) * sp.eye(4)
    assert all(x > 0 for x in d)
    assert all(L[i][i] == 1 for i in range(4))
    assert all(L[i][j] == 0 for i in range(4) for j in range(i + 1, 4))


def test_tampered_ldl_is_rejected(cert):
    """A zero pivot or a corrupted L fails the factorisation check."""
    import sympy as sp

    G = W.interval_matrix(cert)
    L = [[sp.Rational(x) for x in row] for row in cert["ldl"]["L"]]
    d = [sp.Rational(x) for x in cert["ldl"]["d"]]
    assert W.rational_factorization_ok(G, L, d)
    bad_d = list(d)
    bad_d[3] = sp.Integer(0)
    assert not W.rational_factorization_ok(G, L, bad_d)
    bad_L = [row[:] for row in L]
    bad_L[1][0] = sp.Integer(0)
    assert not W.rational_factorization_ok(G, bad_L, d)


def test_lean_embedding_matches_certificate(cert):
    """The rational constants in lean/Topic.lean are the certificate's L, d, P."""
    text = (ROOT / "lean" / "Topic.lean").read_text(encoding="utf-8")
    for row in cert["ldl"]["L"]:
        for v in row:
            if v not in {"0", "1"}:
                assert v in text, v
    for v in cert["ldl"]["d"]:
        assert v in text, v
    for row in cert["ldl"]["P"]:
        for v in row:
            assert v in text, v


def test_box_hypotheses(cert):
    """The numerical matrix lies in the box and the row-sum bound holds."""
    res = W.box_hypotheses_ok(cert)
    assert res["box_contains"]
    assert res["row_sums"]
    assert res["symmetric"]
    assert res["centre_is_P_plus_tI"]
    _, E, t = W.box_data(cert)
    assert max(sum(row) for row in E) < t
