# OP-5 and OP-6 — resolved

> Source: [`research/open.md`](../../rh/research/open.md) §3; Lean development `Op56` (9/9 green, axiom-clean).

## 3. The resolved problems, in one paragraph each

**OP-5 — the asymptotic of `n_min(p)`.** `n_min(p) = p/ln 2 − 3/2 + O(1)`. (The write-up
originally stated `O(1/p)`; that is **false**, since an integer index cannot beat the
Diophantine gap against an irrational linear threshold — the exact law is
`nmin(p) = ⌈p/ln 2 − 5/2⌉`. The error term is corrected to `O(1)` throughout the
`open/` sources, and the Lean theorem states the `O(1)` index form.) The recorded guess
`n_min ≈ p + O(1)` is **refuted**: the slope is `1/ln 2 = 1.4426950…` (measured
`1.4424` at `p = 5000`) and `n_min − p` grows (21, 88, 442, 2212 at
`p = 50, 200, 1000, 5000`). Thresholds satisfy
`P_n = (n + 3/2)ln 2 + c/n + O(1/n²)` with the closed-form
`c = 3(ln 2)² − (25/12)ln 2 = −0.002697584411948…`, verified to `1·10⁻¹⁰` by
Richardson extrapolation; `P_1 = p* = 1.7286472389981836` (`ζ(p*) = 2`). The `1/n²`
remainder coefficient is `≈ 0.00323`, stable over six decades.

**OP-6 — the order of the reachable fraction.** Composing the census law
(`measure(S_1) = 2^{n_min−1} T_{n_min}`) with OP-5 gives
`L(p) = p log p − (1 + ln ln 2)p − c(e(p))/p + O(1/p²)` with the closed-form ceiling-error coefficient `c(e) = −((ln 2)²/2)(e² − e + 9/4) ∈ [−0.540510, −0.480453]`, i.e.
`measure(S_1)/P(p) = p^{−p} e^{(1+ln ln 2)p}(1+o(1)) → 0`. The recorded leading
constant in `c·p log p` is **`c = 1`** (not `1/ln 2`, not `2/ln 2`); the linear
coefficient `−(1 + ln ln 2) = −0.6334870794…` is exact (verified to ten figures at
`p = 10⁶`). The `1/p` coefficient is **closed form but not a constant** — the constant `−0.540509640658…` quoted in the original write-up is the smooth-index (`e = 0`) value; see the correction in [`OP-06-reachable-fraction.md`](../../rh/research/twin-prime-parity/open/OP-06-reachable-fraction.md) §2.4 and [`op06_ceiling_coefficient.py`](../../rh/research/twin-prime-parity/open/op06_ceiling_coefficient.py).
In the Lean statement, `L` and `LAsym` are the relevant functions and the theorem
bounds the residual `L p − LAsym p = O(1)`.

> **Census caveat (recorded, not stale).** `census_measure_eq` holds *by construction*:
> `reachableMeasure` is *defined* as `2^{nmin p}·tailSum p (nmin p)`. The geometric
> statement that the `2^{nmin}` translates are pairwise disjoint with union the sub-sum
> set is **not** formalised — `Op56/Census.lean` records it as the remaining "census
> counting" gap.

---
