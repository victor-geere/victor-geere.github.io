# Addendum to `010/rigorous/EXP_NUM_ERRATUM.md` — the midpoint-rule constant

**Status: an unproved constant, not a demonstrated numerical error.** This note records a
second, independent weakness in the Route-B quadrature budget that the 2026-10-12 re-run
surfaced. It is *not* the box-enclosure bug of the erratum; it is a separate factor of two in
the *stated* error bound.

## The claim in the code

`010/rigorous/eta_interval.py` (`I3_certificate`, line ~1181) and
`010/rigorous/certify_count_par.py` use

```python
err = (mp.mpf(1) / 8) * dsmod ** 2 * Lf        # |err| <= (1/8)|ds|^2 sup|f'|
```

and the primer (`010/routes-abc-primer.html` §3.2) prints the same bound.

## The elementary bound

For a segment from `c - v/2` to `c + v/2` (midpoint `c`, step vector `v`, `h = |v|`),

```
E = ∫ f ds - v f(c) = v ∫_{-1/2}^{1/2} [f(c + v u) - f(c)] du,
|f(c + v u) - f(c)| <= h |u| sup|f'|,
|E| <= h sup|f'| · h ∫_{-1/2}^{1/2} |u| du = (1/4) h^2 sup|f'|.
```

The constant `1/4` is sharp: the extremal `|f'|`-profile is `g(u) = sign(u)`-like (the
triangular kernel `h/2 - |x|` has `L¹` mass `h²/4`), and by the Weierstrass/Mergelyan
approximation theorem every continuous function on the segment — in particular a
`sign`-shaped profile — is uniformly approximable by polynomials (entire functions), so
entire `f` can approach the `1/4` bound. Hence the general lemma "`|err| <= (1/8)|ds|^2
sup|f'|`" is **false**; the code's `1/8` is half the elementary constant.

## Why the archived numbers are nevertheless very likely safe

The budget uses `Lf`, the engine's **box** enclosure of `|(log ξ)''|`, which is not the true
`sup|f'|` on the segment: it is the maximum of `|center| + radius` over the whole step box,
and the box radius is dominated by the Euler-series phase error (the erratum's own
observation). Measured on the `010` engine, `Lf / sup|f'|` is of order `10^6 – 10^7` on
ordinary steps, i.e. the `1/8` budget is many orders of magnitude above the actual midpoint
error. So the factor of two is absorbed *in practice*, but it is not absorbed by any proof.

The correct statement to quote is therefore:

* the runs are rigorous **if** one re-derives the budget with the sharp constant `1/4`
  (i.e. doubles the quadrature part), **or**
* one proves `Lf >= 2 sup|f'|` for the engine's box enclosure, which is not done anywhere.

`011/rigorous/dirichlet_routeB.py` takes the safe route: its budget is `factor = 1/4`
(`dirichlet_I3(..., factor=Fraction(1,4))`), and `certify_dirichlet_routeB.py` passes `1/4`.
The Dirichlet count itself no longer uses a curvature bound at all — it tracks `arg H`
exactly (see `dirichlet_I3_arg`), so this constant is moot there.

The same is now true of the `ζ` count: after the `2026-10-12` re-run showed that the fixed
primitives inflate the `T = 33` budget by ≈ 5.9× (`N ∈ [3.304, 6.696]`, UNDECIDED),
[`../rigorous/zeta_routeB.py`](../rigorous/zeta_routeB.py) recomputes `N(T)` by tracking
`arg ξ` from a rigorous enclosure of `ξ(s) = ½s(s−1)π^{−s/2}Γ(s/2)ζ(s)`. That needs neither
`Lf` nor any constant:

```
N(15) ∈ [0.999999909, 1.000000091]   -> 1
N(33) ∈ [4.999999675, 5.000000325]   -> 5
```

So the midpoint constant is now historical for both counts; it remains relevant only to the
archived `010` quadrature runs and to any future use of `I3_certificate`.

## Applied fix

The two `(mp.mpf(1) / 8)` occurrences — in `eta_interval.I3_certificate` and in
`certify_count_par._one` — have been changed to `(mp.mpf(1) / 4)`, so the archived primitive no
longer states an unproved bound. The `1/8`-based quadrature *results* are left as historical
records only: with `1/4` the `T = 33`, `steps/unit = 40` run is `2×` the reported half-width,
which tips past `0.5`, and `steps/unit` would have to rise past `100` for the quadrature
certificate to close. The quadrature route is therefore **retired as the primary Route-B count**
in favour of the argument-tracking route above; any future re-archive of the quadrature runs must
use the `1/4` constant and the larger `steps/unit`.
