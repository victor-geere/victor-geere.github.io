# Round 1 notes — qrimes, twin qrimes, linear vs bilinear

## Definitions

- **qrime** = closed point / place of the function field; in `𝔽_q[x]`, a monic
  irreducible.
- **twin qrime** = pair `(f, f+2)` of monic irreducibles of the same degree.

## Verified

- `q^n = Σ_{d|n} d·I(d)` and `I(n) = (1/n)Σ_{d|n}μ(d)q^{n/d}` (enumeration ==
  Möbius, q=3,5,7, n≤6).
- Twin counts `T(n)`; `T(n)n²/qⁿ → C(q)`; `T/(I²/qⁿ) → C(q) ≠ 1`.
- Equal-size qrime sets with different twin counts (q=5, n=3: a twin pair has
  twin count 1, a non-twin pair has 0).
- Pure-Python irreducibility cross-checked against sympy.

## Lean (green, clean footprints)

- `Qrime.card_monic`: coefficient vectors of monic degree-`n` polys number `q^n`.
- `Qrime.shift_bijective`: `f ↦ f+2` is a bijection (measure-preserving).
- `Qrime.linear_not_determine_twin`: the finite witness.

## The honest barrier statement

The zeta (and its zeros) encodes **linear** statistics: `I(n)`, point counts.
The twin count is **bilinear**. In `𝔽_q[x]` it is provable by 2D equidistribution
(Chebotarev / large sieve), not by the zeros. Over ℚ the same 2D equidistribution
is the open twin prime conjecture, and the parity theorem blocks the 1D methods.
So the function-field case does not "solve" the barrier; it isolates precisely
which extra structure (Frobenius/Chebotarev) does the work.

## Round-2 options

1. Derive/verify the singular series `C(q)` explicitly (product over qrimes) and
   match it to the measured `T(n)n²/qⁿ`.
2. Compute the zeta/point-count side of a curve (e.g. an elliptic curve over
   `𝔽_q`) and exhibit explicitly that its Frobenius zeros determine all *linear*
   statistics but not the twin-qrime count.
3. Formalize more of the finite dictionary in Lean (the Möbius inversion
   `q^n = Σ d I(d)` ⇒ `I(n)`).
