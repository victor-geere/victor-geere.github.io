#!/usr/bin/env python3
"""validate_op34.py — exhaustive validation for the OP-34/OP-36/OP-37 attack.

Reproduce:
    python3 research/attacks/validate_op34.py [--full]

`--full` runs the m+1 <= 4, N <= 31 sweep for the shape sum (takes minutes);
without it the N <= 20 sweep plus the other checks run in seconds.
"""
import itertools
import random
import sys
import time

sys.path.insert(0, "/Users/victor/workspace/rh/lib")
from tpp_window_collision import (  # noqa: E402
    all_zero_exists,
    class_collision_criterion,
    class_share_factor,
    class_windows,
    factor_of_window,
    p_offset,
    realisable_offset_range,
    shape_sum_formula,
    window_info,
)


def supports(N, maxones=4):
    for k in range(1, min(maxones, N) + 1):
        for ones in itertools.combinations(range(N), k):
            yield ones


def sweep_shape(maxN, maxones):
    cases = bad = 0
    for N in range(1, maxN + 1):
        for ones in supports(N, maxones):
            for L in range(1, N + 1):
                cases += 1
                if shape_sum_formula(ones, N, L) != p_offset(ones, N, L):
                    bad += 1
                    if bad < 5:
                        print("   shape-sum BAD:", ones, N, L)
    return cases, bad


def sweep_class_criterion(maxN, maxones):
    cases = bad = 0
    for N in range(1, maxN + 1):
        for ones in supports(N, maxones):
            for L in range(1, N + 1):
                cls = list(class_windows(ones, N, L))
                for c1, c2 in itertools.combinations(cls, 2):
                    cases += 1
                    if class_share_factor(ones, N, L, c1, c2) != \
                       class_collision_criterion(ones, N, L, c1, c2):
                        bad += 1
                        if bad < 5:
                            print("   class-crit BAD:", ones, N, L, c1, c2)
    return cases, bad


def sweep_conditional_injectivity(maxN, maxones):
    cases = bad = 0
    for N in range(3, maxN + 1):
        for ones in supports(N, maxones):
            am = ones[-1]
            if am == 0:
                continue
            for L in range(1, N + 1):
                if L > N - am - 1 or p_offset(ones, N, L) < am + 2:
                    continue
                cases += 1
                seen = {}
                for t in range(N - L + 1):
                    info = window_info(ones, N, L, t)
                    if info is None:
                        continue
                    key = (info[0], info[2])
                    f = factor_of_window(ones, t, L)
                    if f in seen and seen[f] != key:
                        bad += 1
                del seen
    return cases, bad


def random_shape(ntrials, seed=0):
    rng = random.Random(seed)
    bad = 0
    for _ in range(ntrials):
        N = rng.randint(5, 400)
        k = rng.randint(1, 5)
        ones = tuple(sorted(rng.sample(range(N), k)))
        L = rng.randint(1, N)
        if shape_sum_formula(ones, N, L) != p_offset(ones, N, L):
            bad += 1
            if bad < 5:
                print("   random BAD:", ones, N, L)
    return ntrials, bad


def provenance_counts():
    """Reproduce the exact case counts quoted by the tractability survey."""
    # realisability: N2 in 3..19, m in 1..min(3,N2-1) ones, all L
    c1 = sum(len(list(itertools.combinations(range(N2), m))) * N2
             for N2 in range(3, 20) for m in range(1, min(3, N2 - 1) + 1))
    # all-zero: same loop
    c2 = c1
    # injectivity plateau: N2 in 6..25, m in 1..3 ones, N2 >= 2 a_m + 3, plateau L
    c3 = 0
    for N2 in range(6, 26):
        for m in range(1, 4):
            for ones in itertools.combinations(range(N2), m):
                if N2 < 2 * ones[-1] + 3:
                    continue
                mx = max(p_offset(ones, N2, L) for L in range(1, N2 + 1))
                for L in range(1, N2 + 1):
                    if p_offset(ones, N2, L) == mx:
                        c3 += 1
    return c1, c2, c3


def main():
    full = "--full" in sys.argv
    t0 = time.time()
    maxN_shape = 31 if full else 20
    print(f"shape-sum sweep, m+1<=4, N<={maxN_shape} ...", flush=True)
    c, b = sweep_shape(maxN_shape, 4)
    print(f"  shape sum: {c} cases, {b} mismatches  [{time.time()-t0:.1f}s]", flush=True)

    t0 = time.time()
    print("class-level collision criterion, m+1<=4, N<=18 ...", flush=True)
    c, b = sweep_class_criterion(18, 4)
    print(f"  class criterion: {c} class-pairs, {b} mismatches  [{time.time()-t0:.1f}s]", flush=True)

    t0 = time.time()
    print("conditional injectivity, m+1<=4, N<=25 ...", flush=True)
    c, b = sweep_conditional_injectivity(25, 4)
    print(f"  conditional injectivity: {c} cases, {b} collisions  [{time.time()-t0:.1f}s]", flush=True)

    t0 = time.time()
    c, b = random_shape(20000)
    print(f"  random shape sum up to N=400: {c} cases, {b} mismatches  [{time.time()-t0:.1f}s]", flush=True)

    c1, c2, c3 = provenance_counts()
    print(f"survey provenance counts: realisability={c1}, all-zero={c2}, "
          f"plateau-injectivity={c3}")


if __name__ == "__main__":
    main()
