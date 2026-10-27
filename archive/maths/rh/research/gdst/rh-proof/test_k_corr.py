#!/usr/bin/env python3
"""
Exact symbolic computation of the GDST correlation kernel.
Includes a verification test for the structural formula.
"""

import sys
from fractions import Fraction

# ------------------------------------------------------------
# Integral helper
# ------------------------------------------------------------
def integrate_quadratic(a: int, b: int, L: Fraction, U: Fraction) -> Fraction:
    A = Fraction(a * b, 1)
    B = Fraction(a + b, 1)
    U2 = U * U
    L2 = L * L
    U3 = U2 * U
    L3 = L2 * L
    return A * (U - L) - B * (U2 - L2) / 2 + (U3 - L3) / 3

# ------------------------------------------------------------
# Full DFS over all histories
# ------------------------------------------------------------
def compute_matrix(max_n: int):
    M = max_n + 1
    thr = [Fraction(1, i + 2) for i in range(M)]
    c = [[Fraction(0, 1) for _ in range(M)] for _ in range(M)]
    stack = [(0, (), Fraction(0, 1), Fraction(1, 1), Fraction(0, 1))]
    while stack:
        k, bits, L, U, sum_sel = stack.pop()
        if k == M:
            if L < U:
                for n in range(M):
                    a = bits[n]
                    for m in range(n, M):
                        b = bits[m]
                        c[n][m] += integrate_quadratic(a, b, L, U)
            continue
        U0 = min(U, sum_sel + thr[k])
        L0 = max(L, sum_sel)
        if L0 < U0:
            stack.append((k + 1, bits + (0,), L0, U0, sum_sel))
        L1 = max(L, sum_sel + thr[k])
        if L1 < U:
            stack.append((k + 1, bits + (1,), L1, U, sum_sel + thr[k]))
    for n in range(M):
        for m in range(n + 1, M):
            c[m][n] = c[n][m]
    return c

# ------------------------------------------------------------
# Restricted DFS: only count if m is the FIRST 1 after n
# ------------------------------------------------------------
def compute_via_next(max_n: int):
    """Returns a matrix c_next[n][m] = integral over histories where
        δ_n=1, δ_m=1, and δ_k=0 for all n<k<m."""
    M = max_n + 1
    thr = [Fraction(1, i + 2) for i in range(M)]
    c_next = [[Fraction(0, 1) for _ in range(M)] for _ in range(M)]
    stack = [(0, (), Fraction(0, 1), Fraction(1, 1), Fraction(0, 1))]
    while stack:
        k, bits, L, U, sum_sel = stack.pop()
        if k == M:
            if L < U:
                # For each n where bits[n]=1, find the FIRST m>n with bits[m]=1
                for n in range(M):
                    if bits[n] == 0:
                        continue
                    # find next 1 after n
                    m = n + 1
                    while m < M and bits[m] == 0:
                        m += 1
                    if m < M and bits[m] == 1:
                        # This pair (n,m) qualifies as "next" pair
                        a = bits[n]
                        b = bits[m]
                        c_next[n][m] += integrate_quadratic(a, b, L, U)
            continue
        U0 = min(U, sum_sel + thr[k])
        L0 = max(L, sum_sel)
        if L0 < U0:
            stack.append((k + 1, bits + (0,), L0, U0, sum_sel))
        L1 = max(L, sum_sel + thr[k])
        if L1 < U:
            stack.append((k + 1, bits + (1,), L1, U, sum_sel + thr[k]))
    for n in range(M):
        for m in range(n + 1, M):
            c_next[m][n] = c_next[n][m]
    return c_next

# ------------------------------------------------------------
# Diagonal formula test
# ------------------------------------------------------------
def diagonal_formula(n: int) -> Fraction:
    """Expected c_nn according to the new closed form."""
    num = 13 * n * n + 17 * n + 6
    den = 18 * (n + 2) * (n + 2)
    return Fraction(num, den)

# ------------------------------------------------------------
# Main test
# ------------------------------------------------------------
if __name__ == "__main__":
    MAX_N = 100   # increase for deeper verification
    print(f"Computing exact correlation matrix up to n,m ≤ {MAX_N} …")
    C = compute_matrix(MAX_N)
    print("Computing restricted (next‑selected) matrix …")
    C_next = compute_via_next(MAX_N)

    all_ok = True

    # Test diagonal formula
    print("\nDiagonal test:")
    for n in range(MAX_N + 1):
        exact = C[n][n]
        formula = diagonal_formula(n)
        if exact != formula:
            all_ok = False
            print(f"  FAIL n={n}: exact={exact}, formula={formula}")
    if all_ok:
        print("  PASS: diagonal matches c_nn = (13n²+17n+6)/(18(n+2)²)")

    # Test off‑diagonal structure
    print("\nOff‑diagonal test (should be zero unless m is first 1 after n):")
    for n in range(MAX_N + 1):
        for m in range(n + 1, MAX_N + 1):
            exact = C[n][m]
            next_val = C_next[n][m]
            if exact != next_val:
                all_ok = False
                print(f"  FAIL n={n}, m={m}: exact={exact}, via_next={next_val}")
    if all_ok:
        print("  PASS: all off‑diagonal entries are captured by the ‘first next 1’ condition.")

    if all_ok:
        print("\n" + "="*50)
        print("OVERALL RESULT: PASS")
        print("The correlation kernel is fully determined by the diagonal formula and the")
        print("next‑selected principle.  These can now be proved formally in Isabelle.")
    else:
        print("\n" + "="*50)
        print("OVERALL RESULT: FAIL – some entries do not match the expected structure.")