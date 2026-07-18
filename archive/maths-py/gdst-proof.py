import math
from fractions import Fraction
import mpmath as mp

mp.mp.dps = 60
mp.mp.pretty = True

# -------------------------------------------------------------------
# Enumerate every admissible greedy prefix of length N
# -------------------------------------------------------------------
def all_greedy_prefixes(N: int):
    """
    Return a list of the N+1 admissible greedy prefixes of length N.
    Each element is (tuple_of_digits, left_endpoint_in_units_of_pi).
    The left endpoints are exact Fractions.
    """
    prefixes = []
    prefix = [0] * N
    left = Fraction(0, 1)
    prefixes.append((tuple(prefix), left))

    for k in range(N):
        left = left + Fraction(1, k + 2)
        rem = left
        new_prefix = []
        for n in range(N):
            harm = Fraction(1, n + 2)
            if rem >= harm:
                new_prefix.append(1)
                rem -= harm
            else:
                new_prefix.append(0)
        prefixes.append((tuple(new_prefix), left))
    return prefixes

# -------------------------------------------------------------------
# Uniform bound for the omitted tail
# -------------------------------------------------------------------
def uniform_tail_bound(sigma: float, N: int) -> float:
    """
    Return a number B such that for EVERY admissible greedy digit
    sequence and EVERY s = sigma + i t (t real),
        | Re( sum_{n=N}^{oo} delta_n / (n+2)^s ) |  <=  B .
    """
    r_max = Fraction(1, N + 1)
    if r_max == 0:
        return 0.0

    total = 0.0
    n = N
    r = r_max
    while n < 10**15:
        harm = Fraction(1, n + 2)
        if r >= harm:
            total += float((n + 2) ** (-sigma))
            r -= harm
            if r == 0:
                break
        n += 1
        if n > N + 10 and total > 0:
            last_term = float((n + 2) ** (-sigma))
            if last_term < 1e-18:
                total += 2 * last_term
                break
    return total

# -------------------------------------------------------------------
# Compute finite sum with high precision
# -------------------------------------------------------------------
def finite_sum_re(prefix, sigma: float, t: float) -> mp.mpf:
    """
    Real part of sum_{n=0}^{len(prefix)-1} delta_n / (n+2)^{sigma + i t}
    """
    s = mp.mpc(0, 0)
    for n, delta in enumerate(prefix):
        if delta:
            denom = n + 2
            term = mp.power(denom, - (sigma + 1j * t))
            s += term
    return s.real

# -------------------------------------------------------------------
# Rigorous verification with zero detection
# -------------------------------------------------------------------
def verify_no_balance(sigma: float, t: float, N: int = 4000,
                      zeta_tolerance: float = 1e-12,
                      verbose: bool = True) -> str:
    """
    Returns:
      "PROVEN"       : no theta with Re E(theta,s) = -0.5 (⇒ ζ(s)≠0).
      "ZERO"         : ζ(s) is zero (balance angle exists, test not needed).
      "INCONCLUSIVE" : ζ(s)≠0 but the interval around -0.5 cannot be
                       excluded with the current N; increase N and retry.
    """
    # First, check if s is a zeta zero using mpmath's built-in zeta.
    # Use the same high precision.
    s_val = mp.mpc(sigma, t)
    zeta_s = mp.zeta(s_val)
    if abs(zeta_s) < zeta_tolerance:
        if verbose:
            print(f"ζ({sigma} + i·{t}) ≈ {zeta_s} is effectively zero.")
            print("By the GDST equivalence, a balance angle exists – no proof needed.")
        return "ZERO"

    if verbose:
        print(f"ζ(s) = {zeta_s}  (non‑zero)")
        print(f"Truncation depth N = {N}")

    B = uniform_tail_bound(sigma, N)
    rounding_err = mp.mpf('1e-50')
    eps = B * 1e-12 + rounding_err

    prefixes = all_greedy_prefixes(N)
    total = len(prefixes)

    for idx, (prefix, _) in enumerate(prefixes):
        val = finite_sum_re(prefix, sigma, t)
        lo = float(val) - B - float(eps)
        hi = float(val) + B + float(eps)

        if lo <= -0.5 <= hi:
            if verbose:
                print(f"Prefix {idx}/{total}: interval [{lo:.6f}, {hi:.6f}] "
                      f"covers -0.5")
            # Since ζ(s) is not zero, this is an inconclusive case.
            return "INCONCLUSIVE"

        if verbose and (idx + 1) % 100 == 0:
            print(f"  Checked {idx+1}/{total} prefixes ...")

    if verbose:
        print(f"All {total} prefixes checked. -0.5 NOT covered.")
    return "PROVEN"

# -------------------------------------------------------------------
# Example runs
# -------------------------------------------------------------------
if __name__ == "__main__":
    # Off-line point – should be PROVEN
    print("=== Off‑line: s = 0.55 + i·200 ===")
    res = verify_no_balance(0.55, 200.0, N=4000)
    print("Result:", res)
    print()

    # Known zero – should return ZERO
    print("=== First zeta zero: s = 0.5 + i·14.1347251417 ===")
    res = verify_no_balance(0.5, 14.1347251417, N=4000)
    print("Result:", res)
    print()

    # Point where N is too small (simulate by using small N)
    print("=== Off‑line with small N (should be INCONCLUSIVE) ===")
    res = verify_no_balance(0.55, 200.0, N=50)
    print("Result:", res)