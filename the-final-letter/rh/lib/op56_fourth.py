"""OP-5 threshold asymptotic, fourth order — exact coefficient derivation.

The threshold `IsThreshold n (u*n)` is `Phi(un, n) = 1`, and (Phi_fourth_order)

    Phi(un,n) = 1/(e^u-1) + u*PhiS(u)/(2n) + D(u)/n^2 + E(u)/n^3 + O(n^-4),

with PhiS(u) = sum k^2 e^{-uk}, D(u) = -(u/3)PhiK3u(u) + (u^2/8)PhiK4u(u),
E(u) = EFourth(u) = (u/4)PhiK4u - (u^2/6)PhiK5u + (u^3/48)PhiK6u.

Writing F(u) = 1 - 1/(e^u-1) and delta = u - log 2, the threshold equation is

    F(L+delta) = u*PhiS(u)/(2n) + D(u)/n^2 + E(u)/n^3 + O(n^-4).

Substituting delta = a1/n + a2/n^2 + a3/n^3 and matching powers of 1/n gives
a1, a2, a3 exactly.  All Taylor coefficients are rational in L = log 2 because
e^L = 2 and the moments are PhiK_p(L) = Li_{-p}(1/2) in Q.

Self-test: python3 lib/op56_fourth.py
"""
from __future__ import annotations

import sympy as sp


def moment(p: int) -> sp.Rational:
    """Li_{-p}(1/2) = sum_{k>=0} k^p / 2^k, exact rational."""
    x = sp.symbols("x")
    # sum_{k>=0} k^p x^k = (x d/dx)^p 1/(1-x); evaluate the Eulerian closed form at 1/2.
    expr = 1 / (1 - x)
    for _ in range(p):
        expr = sp.simplify(x * sp.diff(expr, x))
    return sp.nsimplify(sp.simplify(expr.subs(x, sp.Rational(1, 2))))


def taylor_of_moment(u: sp.Symbol, p: int, order: int) -> sp.Expr:
    """Taylor poly in (u - L) of PhiK_p(u) = sum k^p e^{-uk}, through `order`."""
    L = sp.log(2)
    # PhiK_p(u) = sum_k k^p e^{-kL} e^{-k(u-L)} -> coefficients (-1)^m M_{p+m}/m!
    d = sp.symbols("d")
    return sum((-1) ** m * moment(p + m) / sp.factorial(m) * d**m for m in range(order + 1))


def expand_in_u(expr_in_d: sp.Expr, u0: sp.Symbol) -> sp.Expr:
    """Substitute d = u0 - L into a polynomial in d."""
    return sp.expand(expr_in_d.subs(sp.symbols("d"), u0 - sp.log(2)))


def derive(order_delta: int = 4, order_n: int = 4):
    n = sp.symbols("n", positive=True)
    L = sp.log(2)
    d = sp.symbols("d")

    # Taylor polynomials in delta = u - L, through order_delta.
    PhiS_d = sum((-1) ** m * moment(2 + m) / sp.factorial(m) * d**m for m in range(order_delta + 1))
    PhiK = {p: taylor_of_moment(None, p, order_delta) for p in (3, 4, 5, 6)}
    u = L + d
    uPhiS_d = sp.expand(u * PhiS_d)
    D_d = sp.expand(-(u / 3) * PhiK[3] + (u**2 / 8) * PhiK[4])
    E_d = sp.expand((u / 4) * PhiK[4] - (u**2 / 6) * PhiK[5] + (u**3 / 48) * PhiK[6])
    F_d = sp.series(1 - 1 / (sp.exp(L + d) - 1), d, 0, order_delta + 1).removeO()
    F_d = sp.expand(F_d)

    # delta = a1/n + a2/n^2 + a3/n^3 (+ a4/n^4)
    a = sp.symbols("a1:5")
    delta = sum(a[i] / n ** (i + 1) for i in range(order_n))

    t = sp.symbols("t", positive=True)

    def sub(e):
        e2 = sp.expand(e.subs(d, delta).subs(n, 1 / t))
        s = sp.series(e2, t, 0, order_n + 1).removeO()
        return sp.expand(s.subs(t, 1 / n))

    lhs = sub(F_d)
    rhs = sub(uPhiS_d / (2 * n)) + sub(D_d / n**2) + sub(E_d / n**3)

    diff = sp.simplify(sp.expand(lhs - rhs))
    eqs = []
    for k in range(1, order_n + 1):
        eqs.append(sp.expand(diff * n**k).coeff(n, 0))
    sol = {}
    for k, eq in enumerate(eqs, start=1):
        expr = sp.simplify(eq.subs(sol))
        s = sp.solve(sp.Eq(expr, 0), a[k - 1])
        if not s:
            print(f"  (no solution at order n^-{k}: {expr})")
            break
        sol[a[k - 1]] = sp.simplify(s[0])
    out = {}
    for name, val in sol.items():
        out[str(name)] = sp.simplify(sp.expand(val))
    return out, F_d, uPhiS_d, D_d, E_d


def main():
    sol, F_d, uPhiS_d, D_d, E_d = derive()
    L = sp.log(2)
    print("moments:", {p: moment(p) for p in range(2, 8)})
    print("F Taylor      :", [sp.nsimplify(sp.expand(F_d).coeff(sp.symbols('d'), k)) for k in range(5)])
    print("u*PhiS coeffs :", [sp.nsimplify(sp.expand(uPhiS_d).coeff(sp.symbols('d'), k)) for k in range(5)])
    print("D(L), D'(L)   :", sp.nsimplify(D_d.subs(sp.symbols('d'), 0)),
          sp.nsimplify(sp.diff(D_d, sp.symbols('d')).subs(sp.symbols('d'), 0)))
    print("E(L)          :", sp.nsimplify(E_d.subs(sp.symbols('d'), 0)))
    for k, v in sol.items():
        print(f"{k} =", sp.simplify(v))
        print(f"   numeric = {sp.N(v, 25)}")
    a2 = sol.get('a2')
    c2_known = 3 * L**2 - sp.Rational(25, 12) * L
    print("a2 - known c2 :", sp.simplify(a2 - c2_known))
    return sol


def numeric_check(ns=(200, 1000, 5000, 25000)):
    """Solve Phi(un,n)=1 to high precision and estimate a3, a4 by Richardson."""
    import mpmath as mp
    mp.mp.dps = 60
    L = mp.log(2)
    a1 = 3 * L / 2
    a2 = 3 * L**2 - mp.mpf(25) / 12 * L
    c3 = (73 * L - 244 * L**2 + 200 * L**3) / 8
    c4 = (-595632 * L - 1232865 * L**3 + 58568 + 1581168 * L**2) * L / 1152

    def terms(un, n):
        kmax = int(200 * n / un) + 20
        for k in range(1, kmax + 1):
            lg = mp.log(1 + mp.mpf(k) / n)
            e = mp.e ** (-un * lg)
            yield e, -n * lg * e

    def Phi(un, n):
        return mp.fsum(t[0] for t in terms(un, n))

    def dPhi(un, n):
        return mp.fsum(t[1] for t in terms(un, n))

    def solve_u(n):
        u = mp.mpf(0.7)
        for _ in range(200):
            f = Phi(u * n, n) - 1
            df = dPhi(u * n, n)
            if df == 0:
                break
            du = f / df
            u -= du
            if abs(du) < mp.mpf(10) ** (-(mp.mp.dps - 10)):
                break
        return u

    rows = []
    for n in ns:
        u = solve_u(n)
        r3 = (u - L - a1 / n - a2 / n**2) * n**3
        r4 = (u - L - a1 / n - a2 / n**2 - c3 / n**3) * n**4
        rows.append((n, u, r3, r4))
    print(f"{'n':>7} {'n^3(u-...-a2/n^2)':>24} {'n^4(u-...-c3/n^3)':>24}")
    for n, u, r3, r4 in rows:
        print(f"{n:>7} {mp.nstr(r3, 18):>24} {mp.nstr(r4, 18):>24}")
    print(f"derived c3 = {mp.nstr(c3, 18)}   c4 = {mp.nstr(c4, 18)}")
    return rows


if __name__ == "__main__":
    main()
    numeric_check()

