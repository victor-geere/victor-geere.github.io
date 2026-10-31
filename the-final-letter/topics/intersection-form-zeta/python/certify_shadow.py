"""Regenerate the certified 4x4 Gaussian Weil Gram shadow.

This is the script behind ``python/weil_certificate.json``.  It wires the
certified ``Omega``/density layer of ``prime-spectrum-tensor`` into this
dossier, records the interval Gram matrix and the centre/error PSD
certificate, and writes the JSON that the pytest suite verifies.

Run from the topic directory::

    python3 python/certify_shadow.py

The first run is long (2000 Taylor panels, each carrying an interval ``Omega``
jet).  The density enclosures are cached in ``python/density_cache.json``;
later runs reuse the cache and only do the fast pole/prime/certificate
bookkeeping.  Pass ``--recompute`` to force the heavy run.

Provenance: the ``Omega``/jet/density machinery is
``../prime-spectrum-tensor/python/programme.py`` (C9-C21 in that dossier).
The construction is the one recorded in
``../prime-spectrum-tensor/WEIL-GRAM.md`` section 3.5.
"""

from __future__ import annotations

import json
import sys
from fractions import Fraction
from pathlib import Path

import mpmath as mp
import sympy as sp

HERE = Path(__file__).resolve().parent
TOPIC = HERE.parent
SIBLING = TOPIC.parent / "prime-spectrum-tensor" / "python"
sys.path.insert(0, str(SIBLING))

import programme as pst  # noqa: E402

mp.mp.dps = 30

SIGMA = mp.mpf("0.05")
CENTRES = [mp.mpf("-0.3"), mp.mpf("-0.1"), mp.mpf("0.1"), mp.mpf("0.3")]
CS = [mp.mpf("0"), mp.mpf("0.2"), mp.mpf("0.4"), mp.mpf("0.6")]
X_PRIME = 20000
H = mp.mpf("0.1")
T = mp.mpf("100")
U = 4
ORDER = 4
STEP = mp.mpf("0.05")
MARGIN = mp.mpf("1e-4")
CONVERSION_SLACK = Fraction(1, 10**9)
CACHE = HERE / "density_cache.json"


def key(c) -> str:
    """Normalised one-decimal key for a separation value."""
    return f"{float(c):.1f}"


def num(x, digits: int = 20) -> str:
    """Decimal string for an ``mpf``, ``Fraction`` or sympy rational."""
    if isinstance(x, Fraction):
        return mp.nstr(mp.mpf(x.numerator) / x.denominator, digits)
    if isinstance(x, sp.Basic):
        return mp.nstr(mp.mpf(float(x)), min(digits, 16))
    return mp.nstr(mp.mpf(x), digits)


def endpoint(x, digits: int = 20) -> str:
    """Shortest round-tripping decimal for an interval endpoint.

    The verifier reconstructs the exact rational from this string; using the
    shortest float representation makes the recorded matrix and the verified
    matrix identical rationals.
    """
    return str(float(x))


def pole_interval(c):
    c = mp.mpf(c)
    half_c = mp.iv.mpf([c, c]) / 2
    cosh_c = (mp.iv.exp(half_c) + mp.iv.exp(-half_c)) / 2
    pref = 4 * mp.pi * SIGMA**2 * mp.exp(SIGMA**2 / 4)
    return mp.iv.mpf([pref, pref]) * cosh_c


def prime_interval(c):
    c = mp.mpf(c)
    c_iv = mp.iv.mpf([c, c])
    total = mp.iv.mpf([0, 0])
    pref = mp.iv.mpf([mp.sqrt(mp.pi) * SIGMA, mp.sqrt(mp.pi) * SIGMA])
    four_s2 = mp.iv.mpf([4 * SIGMA * SIGMA, 4 * SIGMA * SIGMA])
    for weight, v in pst._prime_power_data(X_PRIME):
        w_iv = mp.iv.mpf([weight, weight])
        v_iv = mp.iv.mpf([v, v])
        total += w_iv * pref * mp.iv.exp(-((v_iv - c_iv) ** 2) / four_s2)
    return -2 * total


def rat(x) -> Fraction:
    return Fraction(str(float(x)))


def leading_minors(M):
    return [sp.Matrix(M[:k, :k]).det() for k in range(1, M.rows + 1)]


def ldl_factorization(M):
    """Exact rational ``M = L * diag(d) * L^T`` with unit lower ``L``."""
    n = M.rows
    A = [[sp.Rational(M[i, j]) for j in range(n)] for i in range(n)]
    L = [[sp.Integer(0)] * n for _ in range(n)]
    for i in range(n):
        L[i][i] = sp.Integer(1)
    d = []
    for k in range(n):
        pivot = A[k][k]
        d.append(pivot)
        if pivot == 0:
            continue
        for i in range(k + 1, n):
            lik = A[i][k] / pivot
            L[i][k] = lik
            for j in range(k + 1, n):
                A[i][j] -= lik * A[k][j]
    return sp.Matrix(n, n, lambda i, j: L[i][j]), d


def certificate(G):
    """Centre/error PSD certificate for a symmetric interval matrix."""
    n = len(G)
    centres = [[(rat(G[i][j].a) + rat(G[i][j].b)) / 2 for j in range(n)]
               for i in range(n)]
    half = [[(rat(G[i][j].b) - rat(G[i][j].a)) / 2 for j in range(n)]
            for i in range(n)]
    t = max(sum(half[i][j] for j in range(n)) for i in range(n))
    t += CONVERSION_SLACK
    M = sp.Matrix(n, n, lambda i, j: sp.Rational(centres[i][j].numerator,
                                                 centres[i][j].denominator))
    P = M - sp.Rational(t.numerator, t.denominator) * sp.eye(n)
    L, d = ldl_factorization(P)
    minors = leading_minors(P)
    ok = all(m > 0 for m in minors) and all(p > 0 for p in d)
    return ok, centres, t, minors, d, L, d, P


def load_density_cache() -> tuple[dict, list[dict]]:
    data = json.loads(CACHE.read_text(encoding="utf-8"))
    records = [{"c": key(rec["c"]), "lo": rec["lo"], "hi": rec["hi"]}
               for rec in data["density"]]
    return data, records


def compute_density() -> tuple[dict, list[dict]]:
    print("starting certified density run (H=0.1, T=100, 2000 panels)", flush=True)
    results, panels = pst.gaussian_density_certified_multi(
        CS, SIGMA, H=H, T=T, order=ORDER, h=STEP, U=U)
    print(f"panels={panels}", flush=True)
    records = []
    for k, c in enumerate(CS):
        d, de = results[k]
        enclosure = mp.iv.mpf([d.a - de, d.b + de])
        records.append({"c": key(c), "lo": endpoint(enclosure.a),
                        "hi": endpoint(enclosure.b)})
        print(f"density({key(c)}) = {enclosure}", flush=True)
    data = {
        "sigma": num(SIGMA), "H": num(H), "T": num(T), "U": U,
        "order": ORDER, "h": num(STEP), "panels": panels,
        "source": "computed by certify_shadow.py",
        "density": records,
    }
    CACHE.write_text(json.dumps(data, indent=2) + "\n", encoding="utf-8")
    return data, records


def main() -> int:
    recompute = "--recompute" in sys.argv
    if CACHE.exists() and not recompute:
        meta, density_records = load_density_cache()
        print(f"using density cache: {CACHE}", flush=True)
    else:
        meta, density_records = compute_density()

    density_by_key = {rec["c"]: rec for rec in density_records}

    def density_interval(c):
        rec = density_by_key[key(c)]
        return mp.iv.mpf([mp.mpf(rec["lo"]), mp.mpf(rec["hi"])])

    def W_of(c):
        c = mp.mpf(c)
        return pole_interval(c) + density_interval(abs(c)) + prime_interval(c)

    def entry(c):
        c = mp.mpf(c)
        return (W_of(c) + W_of(-c)) / 2

    n = len(CENTRES)
    gram = [[None] * n for _ in range(n)]
    gram_raw = [[None] * n for _ in range(n)]
    for i in range(n):
        for j in range(i, n):
            c = CENTRES[i] - CENTRES[j]
            raw = entry(c)
            widened = mp.iv.mpf([raw.a - MARGIN, raw.b + MARGIN])
            gram_raw[i][j] = gram_raw[j][i] = raw
            gram[i][j] = gram[j][i] = widened

    ok, centres, t, minors, pivots, L, d, P = certificate(gram)

    omega_samples = []
    for tv in ["0", "0.5", "1", "10"]:
        iv = pst.omega_interval(mp.mpf(tv))
        omega_samples.append({"t": tv, "lo": endpoint(iv.a), "hi": endpoint(iv.b)})

    numerical = {
        "W_sigma": num(pst.weil_gaussian_W(mp.mpf(0), SIGMA), 25),
        "prime_at_06": num(pst.weil_gaussian_prime(mp.mpf("0.6"), SIGMA), 25),
        "density": {key(c): num(pst.weil_gaussian_density(c, SIGMA), 25)
                    for c in CS},
        "gram": [[num(pst.weil_gaussian_cross(a, b, SIGMA), 25)
                  for b in CENTRES] for a in CENTRES],
    }

    payload = {
        "kind": "finite-weil-gram-shadow",
        "status": "certified" if ok else "not-certified",
        "sigma": num(SIGMA),
        "centres": [num(c) for c in CENTRES],
        "prime_cutoff": X_PRIME,
        "density_panels": {
            "H": meta.get("H", num(H)), "T": meta.get("T", num(T)),
            "U": meta.get("U", U), "order": meta.get("order", ORDER),
            "h": meta.get("h", num(STEP)), "panels": meta.get("panels", None),
        },
        "margin": num(MARGIN),
        "density": density_records,
        "gram_raw": [[[endpoint(gram_raw[i][j].a), endpoint(gram_raw[i][j].b)]
                      for j in range(n)] for i in range(n)],
        "gram": [[[endpoint(gram[i][j].a), endpoint(gram[i][j].b)]
                  for j in range(n)] for i in range(n)],
        "centre_matrix": [[num(x, 25) for x in row] for row in centres],
        "conversion_slack": "1e-9",
        "operator_slack": num(t, 25),
        "leading_minors": [num(m, 25) for m in minors],
        "ldl_pivots": [num(p, 25) for p in pivots],
        "ldl": {
            "L": [[str(L[i, j]) for j in range(n)] for i in range(n)],
            "d": [str(x) for x in d],
            "P": [[str(P[i, j]) for j in range(n)] for i in range(n)],
            "unit_lower": True,
        },
        "omega_samples": omega_samples,
        "numerical": numerical,
        "provenance": (
            "Omega/density jet from topics/prime-spectrum-tensor/python/"
            "programme.py; construction as WEIL-GRAM.md section 3.5 "
            "(H=0.1, T=100, U=4, margin 1e-4)."
        ),
    }

    out = HERE / "weil_certificate.json"
    out.write_text(json.dumps(payload, indent=2) + "\n", encoding="utf-8")
    print(f"wrote {out}", flush=True)
    print("CERTIFIED" if ok else "NOT CERTIFIED", flush=True)
    print(f"operator slack t = {num(t, 25)}", flush=True)
    for k, m in enumerate(minors, 1):
        print(f"  minor {k}: {num(m, 20)}", flush=True)
    return 0 if ok else 1


if __name__ == "__main__":
    raise SystemExit(main())
