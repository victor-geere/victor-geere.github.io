"""Unit tests for the exact twisted-Parseval machinery.

Run:  python3 -m unittest discover -s tests -v
"""

import cmath
import os
import sys
import unittest

import numpy as np
import sympy as sp

sys.path.insert(0, os.path.join(os.path.dirname(__file__), "..", "lib"))

import twisted_parseval as tp  # noqa: E402


PRIMES_1_4 = [13, 17, 29, 37, 41, 53, 61, 73, 89, 97, 101, 109, 113]


def legendre_sympy(q, a):
    a %= q
    return 0 if a == 0 else int(sp.functions.combinatorial.numbers.legendre_symbol(a, q))


def numeric_k(q, A, c):
    """Direct (slow, floating point) evaluation of K(A,c)."""
    zeta = cmath.exp(2j * cmath.pi / q)
    inv4 = pow(4, -1, q)
    return sum(legendre_sympy(q, A * A - w * w) * zeta ** ((-c * w * inv4) % q)
               for w in range(q))


def numeric_signed_sum(q, c):
    return sum(legendre_sympy(q, A) * numeric_k(q, A, c) ** 2 for A in range(q))


def cyclic_square(v, q):
    conv = np.convolve(v, v)
    out = np.zeros(q, dtype=np.int64)
    for k, val in enumerate(conv):
        out[k % q] += int(val)
    return out


class TestReduceModCyclotomic(unittest.TestCase):
    """The reduction is the decision procedure, so it must agree with sympy."""

    def test_matches_sympy_rem(self):
        x = sp.Symbol("x")
        rng = np.random.default_rng(20240518)
        for q in (5, 7, 11, 13, 17, 19):
            phi = sp.Poly(sp.cyclotomic_poly(q, x), x, domain=sp.ZZ)
            for _ in range(25):
                vec = [int(v) for v in rng.integers(-20, 21, size=q)]
                mine = sp.Poly(tp.reduce_mod_cyclotomic(vec, q)[::-1], x, domain=sp.ZZ)
                theirs = sp.Poly(vec[::-1], x, domain=sp.ZZ).rem(phi)
                self.assertEqual(mine.as_expr(), theirs.as_expr(), msg=f"q={q} vec={vec}")

    def test_cyclotomic_vector_is_zero(self):
        for q in (5, 7, 11, 13, 17):
            self.assertEqual(tp.reduce_mod_cyclotomic([1] * q, q), [0] * (q - 1))

    def test_reduction_is_additive(self):
        rng = np.random.default_rng(7)
        for q in (7, 11, 13):
            for _ in range(10):
                a = rng.integers(-9, 10, size=q)
                b = rng.integers(-9, 10, size=q)
                ra = np.array(tp.reduce_mod_cyclotomic(a, q))
                rb = np.array(tp.reduce_mod_cyclotomic(b, q))
                rab = np.array(tp.reduce_mod_cyclotomic(a + b, q))
                self.assertTrue((ra + rb == rab).all())

    def test_distinct_zeta_polys_are_distinguished(self):
        """Reduction really decides equality: 1 - zeta != 0."""
        for q in (5, 7, 11):
            self.assertNotEqual(tp.reduce_mod_cyclotomic([1, -1] + [0] * (q - 2), q),
                                [0] * (q - 1))


class TestCharacters(unittest.TestCase):
    def test_legendre_table_matches_sympy(self):
        for q in PRIMES_1_4:
            chi = tp.legendre_table(q)
            for a in range(q):
                self.assertEqual(int(chi[a]), legendre_sympy(q, a), msg=f"q={q} a={a}")

    def test_legendre_is_multiplicative(self):
        for q in PRIMES_1_4:
            chi = tp.legendre_table(q)
            for a in range(1, q):
                for b in range(1, q):
                    self.assertEqual(int(chi[a * b % q]), int(chi[a]) * int(chi[b]))

    def test_two_square_rep(self):
        for q in PRIMES_1_4:
            a, b = tp.two_square_rep(q)
            self.assertEqual(a * a + b * b, q)
            self.assertEqual(a % 2, 1, msg=f"a must be odd: q={q}")

    def test_gauss_vector_squares_to_q(self):
        """(sum_x zeta^{x^2})^2 = q, exactly, for q = 1 (mod 4)."""
        for q in PRIMES_1_4:
            g = tp.gauss_vector(q)
            sq = cyclic_square(g, q)
            self.assertEqual(tp.reduce_mod_cyclotomic(sq, q),
                             tp.reduce_mod_cyclotomic([q] + [0] * (q - 1), q),
                             msg=f"q={q}")


class TestKSum(unittest.TestCase):
    def test_K_is_real(self):
        for q in (13, 17, 29, 41, 73):
            for c in (1, 3):
                for A in range(1, q):
                    K = numeric_k(q, A, c)
                    self.assertLess(abs(K.imag), 1e-9, msg=f"q={q} c={c} A={A} K={K}")

    def test_exact_vector_matches_direct_sum(self):
        """The integer vector evaluates to the direct floating-point sum."""
        for q in (13, 17, 29, 41):
            for c in (1, 2, 3):
                signed, untwisted = tp.k_sum_vectors(q, c)
                self.assertAlmostEqual(tp.evaluate(signed, q).real,
                                       numeric_signed_sum(q, c), places=6,
                                       msg=f"q={q} c={c}")
                direct_untwisted = sum(numeric_k(q, A, c) ** 2 for A in range(q))
                self.assertAlmostEqual(tp.evaluate(untwisted, q).real,
                                       direct_untwisted, places=6,
                                       msg=f"untwisted q={q} c={c}")


class TestIdentity(unittest.TestCase):
    def test_untwisted_identity_all_primes(self):
        for q in PRIMES_1_4:
            for c in (1, 2, 3):
                self.assertTrue(tp.identity_report(q, c)["untwisted_ok"], msg=f"q={q} c={c}")

    def test_general_identity_all_primes_1_mod_4(self):
        for q in PRIMES_1_4:
            for c in (1, 2, 3):
                self.assertTrue(tp.identity_report(q, c)["general_ok"], msg=f"q={q} c={c}")

    def test_strict_form_requires_q_1_mod_8(self):
        for q in PRIMES_1_4:
            r = tp.identity_report(q, 1)
            if q % 8 == 1:
                self.assertTrue(r["strict_ok"], msg=f"q={q}")
            else:
                self.assertFalse(r["strict_ok"], msg=f"q={q}")
                self.assertEqual(r["chi2_2"], -1, msg=f"q={q}")

    def test_jacobi_sum_is_a_plus_bi(self):
        """J(chi4,chi4) = +-(a + b i) with a odd, via an independent computation."""
        for q in PRIMES_1_4:
            a, b = tp.two_square_rep(q)
            J = jacobi_sum(q)
            self.assertAlmostEqual(abs(J.real), a, places=6, msg=f"q={q} J={J}")
            self.assertAlmostEqual(abs(J.imag), b, places=6, msg=f"q={q} J={J}")
            self.assertAlmostEqual((J * J).real, a * a - b * b, places=6)


def jacobi_sum(q):
    """J(chi4, chi4) with chi4(h) = i^{ind(h)} (independent of the numpy code)."""
    g = None
    for t in range(2, q):
        if len({pow(t, k, q) for k in range(q - 1)}) == q - 1:
            g = t
            break
    assert g is not None
    ind = {}
    x = 1
    for k in range(q - 1):
        ind[x] = k
        x = x * g % q

    def chi4(h):
        h %= q
        return 0 if h == 0 else cmath.exp(2j * cmath.pi * ind[h] / 4)

    return sum(chi4(x) * chi4(1 - x) for x in range(1, q))


if __name__ == "__main__":
    unittest.main(verbosity=2)
