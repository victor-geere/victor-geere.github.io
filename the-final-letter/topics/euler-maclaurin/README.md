# Euler–Maclaurin layer

**Status:** structural pass. This is the focused annex to Objective III. It
documents and mirrors the Euler–Maclaurin development that turns the two
former source claims S1–S2 into Lean theorems for `K ≥ 1`. The authoritative
full dossier remains [`../partial-sum-plus-tail`](../partial-sum-plus-tail/README.md);
this folder exists so that the analytic layer can be read, tested and audited
on its own.

**Provenance.** The canonical Lean file is
[`../partial-sum-plus-tail/lean/EulerMaclaurin.lean`](../partial-sum-plus-tail/lean/EulerMaclaurin.lean),
built in the same directory and recorded in
[`../partial-sum-plus-tail/lean/BUILD.log`](../partial-sum-plus-tail/lean/BUILD.log)
(`[check] OK EulerMaclaurin.lean (41s)`). The written proof it follows is
[`../partial-sum-plus-tail/notes/euler-maclaurin-proof.md`](../partial-sum-plus-tail/notes/euler-maclaurin-proof.md).
The source bundle is `~/workspace/rh/research/twin-prime-parity/012/`.

## What this layer is

For `a > 0`, `s = σ + it` with `σ > 1`, `M ≥ 1`, `b = a + M`, rising factorial
`(s)_n = s(s+1)…(s+n−1)` and Bernoulli numbers `B_{2j}`, the non-periodic
Hurwitz zeta satisfies

\[
\zeta(s,a)=\sum_{k<M}(a+k)^{-s}
+\int_M^\infty (a+x)^{-s}\,dx
+\frac{b^{-s}}{2}
+\sum_{j=1}^{K}\frac{B_{2j}}{(2j)!}\,(s)_{2j-1}\,b^{-s-2j+1}
+R_K(s),
\]

and the explicit tail bound

\[
|R_K(s)|\le |(s)_{2K+1}|\,
\frac{2\zeta(2K+1)}{(2\pi)^{2K+1}}\,
\frac{b^{-\sigma-2K}}{\sigma+2K}.
\]

The Lean development proves the finite Euler–Maclaurin identity, the Fourier
inversion and Bernoulli supremum bound that control the periodic Bernoulli
functions, the differentiability and iterated derivatives of the Hurwitz
term, the integral form of the tail bound, and the two displayed statements
above for `K ≥ 1`.

## Theorem ledger

Every row is proved in [`lean/Topic.lean`](lean/Topic.lean) with no `sorry`,
no `axiom` and no `admit`. `Topic.lean` is a byte-for-byte mirror of the
canonical file; the mirror is enforced by a Python test.

| # | Kind | Statement | Lean name |
|---|---|---|---|
| T36 | Theorem | Finite Euler–Maclaurin identity for a smooth `f` on an integer interval `[M,N]`, all `K`. | `PartialTail.finite_eulerMaclaurin` |
| T37 | Theorem | The same finite identity for the Hurwitz term `(a+x)^{-s}`. | `PartialTail.finite_eulerMaclaurin_hurwitz` |
| T38 | Theorem | Fourier inversion for the periodic Bernoulli functions, `n ≥ 2`. | `PartialTail.hasSum_periodicBernoulli_fourier` |
| T39 | Theorem | Odd Bernoulli supremum bound `‖B̃_{2K+1}‖∞ ≤ 2(2K+1)! ζ(2K+1)/(2π)^(2K+1)`, `K ≥ 1`. | `PartialTail.iSup_norm_periodicBernoulli_odd_le_zeta` |
| T40 | Theorem | The non-periodic Hurwitz zeta is differentiable away from `s = 0, 1`. | `PartialTail.differentiableAt_hurwitzZetaNP` |
| T41 | Theorem | Iterated derivative formula `d^n (a+x)^{-s} = (−1)^n (s)_n (a+x)^{-s-n}`, and integrability of every derivative on the tail. | `PartialTail.iteratedDeriv_hurwitzTerm_eqOn`, `PartialTail.integrableOn_iteratedDeriv_hurwitzTerm` |
| T42 | Theorem | Integral form of the S2 tail bound: `‖∫ B̃_{2K+1}(x) f^{(2K+1)}(x) dx‖ ≤ …`. | `PartialTail.norm_integral_periodicBernoulli_mul_odd_le` |
| T43 | Theorem | S1 decomposition of `ζ(s,a)` and the explicit S2 tail bound, together, for `K ≥ 1`. | `PartialTail.hurwitzZetaNP_eq_eulerMaclaurin`, `PartialTail.hurwitzZetaNP_eulerMaclaurin_with_bound` |

The two rows that were source claims in the old ledger are now T43: S1 is
`hurwitzZetaNP_eq_eulerMaclaurin`, S2 is the second conjunct of
`hurwitzZetaNP_eulerMaclaurin_with_bound`. No source claim is adopted as a
theorem here; the archived written proof is retained as commentary.

## Computation ledger

The Python layer is an independent exact check over `Q`; it does not import the
Lean proof. Every row has a test in [`tests/test_programme.py`](tests/test_programme.py).

| # | Kind | Statement | Test |
|---|---|---|---|
| E1 | Computation | Bernoulli numbers `B_0, B_1, B_2, B_4, B_6, B_8, B_10` are exact; odd `B_n > 1` vanish. | `test_bernoulli_numbers_are_exact`, `test_bernoulli_edge_cases` |
| E2 | Computation | The finite Euler–Maclaurin identity holds exactly for polynomial `f`, over `K = 0,1,2,3,4` and several intervals. | `test_finite_euler_maclaurin_identity` |
| E3 | Computation | The S2 tail radius is positive and decreases with `K` on a documented test range. | `test_tail_radius_positive_and_decreasing` |
| E4 | Computation | `lean/Topic.lean` is byte-for-byte the canonical `EulerMaclaurin.lean`. | `test_lean_mirror_matches_canonical_file` |

The tail-radius test is a numerical illustration of the shape of the bound, at
the stated precision, not a certified enclosure. The exact identity tests use
`sympy` rationals and require exact zero.

## Python layer

```bash
cd the-final-letter/topics/euler-maclaurin
python3 -m pytest -q tests
```

```python
import sys; sys.path.insert(0, "python")
from programme import em_identity_polynomial, tail_radius
em_identity_polynomial([0, 0, 0, 0, 1], 2, 9, 4)  # 0
tail_radius(2.0, 3.0, 1.0, 10, 4)                  # mpf(...)
```

`python/programme.py` uses `sympy` for exact rational work and `mpmath` for the
tail illustration. It is importable without side effects. `K ≥ 1` is enforced
for `tail_radius` because that is the hypothesis of the Lean S1/S2 theorem;
`K = 0` is allowed for the finite identity, which Lean proves for all `K`.

## Lean layer

```bash
cd the-final-letter/topics/euler-maclaurin
./lean/check.sh
```

`lean/Topic.lean` is the mirrored module. It imports Mathlib only, keeps the
`PartialTail` namespace, and contains no `sorry`, `axiom` or `admit`.
`lean/check.sh` calls [`../../tools/check-lean.sh`](../tools/check-lean.sh)
against the shared Mathlib installation.

### What is not formalised

- The lowering of the general S1/S2 theorem into the evaluator's certificate
  `Replay` for arbitrary `s`, `a` and Dirichlet character. This is the R13
  wiring task; it is engineering, not new analysis.
- A certified enclosure *width*. `inflate` is sound for every non-negative
  radius, so the recorded narrow widths are measurements, not theorems. This
  is R15.
- Use of a certified enclosure as a hypothesis in a theorem about a wall
  (R14). Nothing in this folder changes the wall map.
- The `s = 1` pole and `L'/L` derivatives, which belong to the larger
  evaluator dossier rather than to the Euler–Maclaurin identity itself.

## Relation to the walls

This layer is the analytic core of the third objective, not a bridge. It makes
the evaluator's decomposition unconditional. It does **not** prove RH or the
twin-prime conjecture, and no theorem about either wall consumes the enclosure.
The bridge requirements remain global positivity on the Riemann side and a
positive-density multiplicative coupling on the parity side; see
[`../../status.html`](../../status.html) §§5–6 and
[`../../categories/11-bridges/bridges.md`](../../categories/11-bridges/bridges.md).

## Links

- [Objective III dossier](../partial-sum-plus-tail/README.md)
- [Proof ledger C](../../categories/05-proofs/proofs.md#c-the-certified-evaluation-layer)
- [Further research R13–R15](../../categories/09-further-research/further-research.md)
- [Replay wiring — P1 specification](notes/replay-wiring.md)
- [Status](../../status.html)
- [Topic index](../README.md) · [Programme standard](../PROGRAMME-STANDARD.md)
