# M3-finite — numerical roadmap

**Chosen window:** `T = 1`, contour rectangle `[-1,2] × [-1,1]`.

**Why.** The first nontrivial ζ-zero is numerically at height `≈14.13`. A direct
winding-number census (C15) gives `−1` for `ζ` around the `T=1` rectangle, which
is exactly the pole at `s=1`; hence the strip is numerically zero-free.

**C15 is numerical evidence, not a certificate.** It uses `mpmath` boundary
sampling and rounding, not interval arithmetic.

## Milestones

### N1 — Rigorous winding certificate for `T=1`

Replace the sampled winding by an interval enclosure of `ζ` on the four
boundary sides, then apply the argument principle to prove
`FextZeroFinset (closed rectangle) = ∅` or that the only zeros are the pole
terms.

**Probe result (2026-11-18).** A single `etaGrouped` box over the whole strip is
too wide:
- `Re ∈ [0,1]`, `Im ∈ [-1,1]`, `params 100`, ball 1: fails;
- `Re ∈ [0.1,1]`, `params 200`, ball 1: fails;
- `Re ∈ [0.5,1]`, `params 200`, ball 1/2: fails.

The failure is interval width, not a zero. A rigorous certificate needs tiling
in `Im` (and possibly `Re`), using the functional equation to reduce the left
half-strip to the right half-strip.

**Acceptance:** a Lean theorem giving `FextNonzeroOn U` for an open
neighbourhood `U` of `[-1,2]×[-1,1]`.

### N2 — Tent archimedean enclosure

Produce rational `archLo ≤ Re tentArch 1 ≤ archHi` and the imaginary analogue.

### N3 — Tent prime enclosure

Produce rational `primeLo ≤ Re tentPrime 1 ≤ primeHi` and the imaginary analogue,
using the finite prime sum (support `[-1,1]` means only `n ≤ e`).

### N4 — Substitution into T557

Feed N1–N3 into `p4_tent_from_zeros` / T546 and state the finite-window formula
with explicit rational bounds.

## Status

| Step | State |
|---|---|
| Window choice | `T=1`, numerically zero-free (C15); Lean window `T1U` and formula T562 |
| N1 rigorous winding | open |
| N2 archimedean | numerical value C16 (`≈0.77609955`); rigorous enclosure open |
| N3 prime | numerical value C17 (`≈0.33738795`); rigorous enclosure open |
| N4 substitution | open |

### Box-probe diagnosis (2026-11-18)

Smaller tiles still fail, but the failure is now localised:

- `Re ∈ [1/2,1]`, `Im ∈ [0,1/10]`, 200 pairs, square tail radius `1/4` fails;
- `Re ∈ [1/2,3/5]`, same height, same radius fails.

The square tail box `[-R,R]²` makes the imaginary interval cross `0` for any
height tile adjacent to `t=0`, so `containsZero` is true even if the ζ value is
nowhere near zero. The fix is either:

1. an **asymmetric tail box** with a smaller imaginary radius, or
2. a much larger pair count so the tail radius is below the tile offset, and
   tiles that do not touch `t=0`.

This is an interval-representation issue, not evidence of a zero.

An asymmetric box interface (T563) and a componentwise-tail certificate (T564)
are now available. The next step is the actual componentwise tail bound that
fills it.

## Blocking boundary

The numerical layer cannot proceed with the current interval toolkit:

- the only tail enclosure is the square `ball R`, so any height tile adjacent to
  `t=0` has an imaginary interval containing `0`; `containsZero` then fires
  regardless of the ζ enclosure;
- a componentwise/asymmetric tail enclosure, or an independent zero-free proof
  on the real axis, does not exist in the corpus;
- `tentArch` and `tentPrime` have numerical values (C16/C17) but no interval
  quadrature enclosure for the digamma and L-series factors.

Closing N1–N3 therefore requires new interval-analysis infrastructure, not more
instantiation of the existing boxes.

## Central-tile obstruction

T564 checks `containsZero B = false`, a conservative sufficient condition. For
any tile adjacent to `t=0`, the tail box `rectOfRadii a b` contains `0` whenever
`a,b` exceed the tile offset, so the check cannot fire even if ζ is nowhere near
zero on that tile.

Resolving the central tile needs an independent lower bound or real-axis
zero-free theorem (for example, positivity of `etaGrouped` on the real axis for
`0<σ<1`, then continuity/Rouché for a neighbourhood). That proof is the current
missing piece.

## Uniform neighbourhood target

The central-tile cover needs a single positive height `δ` such that ζ is nonzero
on the `δ`-neighbourhood of the real segment `[1/2,1]`. T573 gives pointwise
nonvanishing on the segment; compactness should turn it into a uniform `δ`.
That theorem is the current delegated task.

## Outer-height wall

The central band `|Im z| ≤ uniformDelta` is now zero-free (T576/T577), including
the left half-strip. The remaining heights `uniformDelta ≤ |Im z| ≤ 1` need the
eta-box tiling with an **explicit rational** tile radius.

`uniformDelta` is noncomputable (chosen from a finite subcover), so no explicit
integer `N` with `1/N ≤ uniformDelta` can be extracted for `native_decide`.
Producing one requires a quantitative finite-subcover proof or a separate
explicit lower bound on `|ζ|` over the real segment.

This is the current outer-height obstruction.

## Quantitative lower bound — done

`zeta_real_abs_ge_one` (T581) proves

```lean
1 ≤ ‖ζ(σ)‖   for real 1/2 ≤ σ < 1.
```

This used a telescoping AM–GM bound for `η(σ) ≥ 1/2` (T578–T579), the prefactor
bound (T580), and the eta identity.

## Derivative-to-delta reduction — corrected hypothesis

A finite bound `‖ζ′(σ)‖ ≤ C` on the **real** segment `[1/2,1)` is impossible:
`ζ′(σ) ~ 1/(σ−1)²` as `σ → 1⁻`. The attempted theorem with that hypothesis was
therefore vacuous and has been removed.

The corrected split is:

1. on `[1/2, 1−ε]`, bound `‖ζ′‖ ≤ C` on a **complex neighbourhood** and apply
   the mean-value inequality with T581;
2. on `[1−ε, 1]`, use the pole/lower-bound behaviour near `s=1` (T581 already
   gives `‖ζ(σ)‖ ≥ 1` on the real segment) or a separate explicit estimate.

The explicit rational `δ` must come from this split, not from a global real-axis
derivative bound.

## Quantitative blocking boundary

The explicit-`δ` route is blocked at the pole:

- a finite real-axis bound on `‖ζ′‖` over `[1/2,1)` is impossible;
- the corrected split `[1/2,1−ε]` needs an explicit complex-neighbourhood bound
  on `‖ζ′‖`, which is absent;
- the near-pole piece `[1−ε,1]` needs an explicit upper/lower bound on `ζ` in a
  punctured neighbourhood of `1`, also absent;
- the only zero-free uniform `δ` available (T574) is noncomputable and cannot be
  turned into a rational tile radius for `native_decide`.

No explicit rational `δ` can be extracted from the current corpus.

## Existing explicit strip bound

`absolute-polarized.../ZetaStrip.lean` proves
`exists_bound_norm_zeta_strip_polefree`:

```lean
∃ A ≥ 0, ∀ s, 1/2 ≤ Re s → Re s ≤ 1 → 2 ≤ ‖s‖ → ‖ζ s‖ ≤ A (‖s‖+2)^2.
```

The proof constructs `A = 5`, but the statement is existential. More importantly
it requires `2 ≤ ‖s‖` and `s.im ≠ 0`, so it does not directly cover a small disk
around a real `σ ∈ [1/2,1)` where `‖σ‖ < 2`. Extending this bound to the bounded
norm region, and making the constant `5` available, is the next construction
task.

## Eta majorant uniform bound

For `Re s ∈ [1/2,3/4]` and `|Im s| ≤ 1`:

- `‖s‖ ≤ 5/4`;
- `‖η(s)‖ ≤ ‖s‖ (1 + 1/(2 Re s)) ≤ 5/2`, using
  `norm_pairTerm_le` and `tsum_pairMajorant_add_le` with `M=0`;
- `‖1 − 2^(1−s)‖ ≥ 2^(1/4) − 1 ≥ 1/6`.

Hence `‖ζ(s)‖ ≤ 15`, in particular `≤ 16`. This bound has no `‖s‖ ≥ 2` restriction and is proved as
`norm_zeta_le_sixteen` (T582).

## Cauchy derivative bound

With T582 and a local rectangle bound `‖ζ‖ ≤ M` on `re ∈ [1/2,7/8]`,
`|im| ≤ 1/8`, Mathlib's
`norm_deriv_le_of_forall_mem_sphere_norm_le` gives

```lean
‖ζ′(σ)‖ ≤ M / (1/8) = 8M   for real σ ∈ [1/2,3/4].
```

`norm_deriv_zeta_le` (T583) now proves `‖ζ′(σ)‖ ≤ 512` on the real segment
`[1/2,3/4]`. The extension to complex `z` with `|Im z| ≤ 1/8` is `norm_deriv_zeta_le_complex`
(T584).

## Explicit central band

With T581 (`‖ζ(σ)‖ ≥ 1`) and T584 (`‖ζ′‖ ≤ 512`), the vertical mean-value bound gives

```lean
‖ζ(z) − ζ(σ)‖ ≤ 512 |Im z| ≤ 1/4   for |Im z| ≤ 1/2048,
```

hence `‖ζ z‖ ≥ 3/4 > 0` on

```lean
1/2 ≤ Re z ≤ 3/4,  |Im z| ≤ 1/2048.
```

This is the explicit central zero-free band, proved as
`zeta_ne_zero_central_band` (T585). T586 mirrors it to `1/4 ≤ Re ≤ 1/2` by the
functional equation.

## Extending the explicit band rightward

The next explicit band is `3/4 ≤ Re z ≤ 7/8`, `|Im z| ≤ 1/2048`. With a Cauchy
radius `1/16`, the local rectangle `11/16 ≤ Re ≤ 15/16`, `|Im| ≤ 1/8` gives
`‖ζ‖ ≤ 64`, hence `‖ζ′‖ ≤ 1024`; the vertical mean-value bound then gives
`‖ζ z‖ ≥ 1/2` from T581. This is proved as T587–T589: `norm_zeta_le_sixtyfour_band`,
`norm_deriv_zeta_le_band`, and `zeta_ne_zero_band_34_78`.

## Near-pole quantitative wall

T591 proves `Fext` is eventually nonzero near `1` from `Fext 1 = 1` and
continuity, but gives no quantitative radius. Producing an explicit rational
near-`1` band requires one of:

- a quantitative residue/Taylor bound for `Fext` (or `(z−1)ζ(z)`) near `1`;
- a derivative bound for `Fext` on a disk around `1`, hence a bound on `Fext`;
- an explicit zero-free annulus for `ζ` near `1`.

None exists in the corpus. The explicit band T593 covers `1/4 ≤ Re ≤ 7/8`,
`|Im| ≤ 1/2048`; the gap `7/8 < Re < 1` and the outer heights remain.

## Consolidation decision

A corpus search found no quantitative near-`1` residue/Taylor bound, no `Fext`
derivative bound, and no explicit zero-free annulus. The tractable path is to
consolidate what is proved:

- T593 explicit `Fext` band on `1/4 ≤ Re ≤ 7/8`, `|Im| ≤ 1/2048`;
- T594/T595 package it as the open set `ExplicitBand` and the predicate
  `FextNonzeroOn ExplicitBand`, which is exactly what T562 consumes.

The unresolved height problem is separate: covering `|Im|` up to `1` still needs
an eta-box tiling with a tail radius below the tile offset, and near `t=0` the
current square/asymmetric boxes cannot exclude zero without the explicit band.

## Rigorous quadrature probe (2026-11-19)

The Python interval layer cannot certify `tentArch`/`tentPrime`:

- `mpmath.iv` has no `digamma`, no `zeta`, and its `quad` raises `ValueError`
  for the test integrand;
- `arb` and `python-flint` are not installed;
- Lean has no interval-quadrature or parametric-integral API for these
  integrands.

A rigorous enclosure therefore needs a new interval-special-function layer
(digamma and LSeries) plus quadrature error control. C16/C17 remain numerical
reference values only.

**Correction (2026-11-19):** reusable tools do exist in other topics:

- `digamma-contour-shift` proves `‖ψ(w) − log w‖ ≤ 19` for `1/4 ≤ Re w`,
  `Im w ≠ 0` (now bridged as T596 `digamma_one_add_half_bound`);
- `intersection-form-zeta` has generic Simpson-panel quadrature
  (`simpsonPanelEstimate`) and a digamma/Omega enclosure layer;
- `intersection-form-zeta/PolygammaSeries` has `norm_digamma_le` bounds.

So the quadrature path is tractable after all, but needs the LSeries bound and
the actual Simpson assembly.

## LSeries bound at Re = 2

`LSeries_vonMangoldt_eq_deriv_riemannZeta_div` gives
`LSeries Λ s = -ζ′(s)/ζ(s)` for `Re s > 1`.

- Lower bound: `ζ s * L μ s = 1`, `‖L μ s‖ ≤ ∑ 1/n² ≤ 2`, so
  `1/2 ≤ ‖ζ s‖` on `Re s ≥ 2`.
- Upper bound: Cauchy with radius `1/2` around `s` and `‖ζ‖ ≤ 3` on
  `Re ≥ 3/2` gives `‖ζ′(s)‖ ≤ 6`.

Hence `‖LSeries Λ (2+iy)‖ ≤ 12` (target constant 24). This is proved as `norm_LSeries_vonMangoldt_two_le` (T597), constant 24.

## First quadrature-level bound

With T596 (`‖ψ(1+iy/2) − log(1+iy/2)‖ ≤ 19`) and T597
(`‖LSeries Λ (2+iy)‖ ≤ 24`), the first assembly target is a crude bound

```lean
‖tentPrime T‖ ≤ 96 * exp T
```

from `‖tentC‖ ≤ 1`, `‖exp(i3u/2)‖ = 1`, the inner bound
`24 * ∫_{-T}^{T} exp(-uy) dy`, and `exp(-uy) ≤ exp T` on `u ∈ [-1,1]`.
This is proved as `norm_tentPrime_le` (T598). It is a norm bound, not yet an
enclosure.

## Archimedean norm bound

Using T596, on `|y| ≤ T`:

- `‖ψ(1+iy/2) − log(1+iy/2)‖ ≤ 19`;
- `‖log(1+iy/2)‖ ≤ log(T+2) + 2`;
- hence `‖A(y)‖ ≤ log(T+2) + 22` for
  `A(y) = (1/2)log π − (1/2)ψ(1+iy/2)`;
- inner `≤ 2(log(T+2)+22) exp T`, outer `≤ 4(log(T+2)+22) exp T`.

Proved as `norm_tentArch_le` (T599) with constant 100.

## Coarse rational boxes (2026-11-19)

Kernel-checked enclosures:

| Quantity | Box |
|---|---|
| `tentArch 1` | `|Re|, |Im| ≤ 7200` (T600) |
| `tentPrime 1` | `|Re|, |Im| ≤ 288` (T601) |
| `-tentArch 1 - tentPrime 1` | `|Re|, |Im| ≤ 7488` (T602); norm `≤ 14976` (T612) |

These are rigorous but coarse: they use `log 3 ≤ 2`, `exp 1 ≤ 3`, and the norm
bounds T598/T599. A Simpson enclosure would replace them by much tighter
rational intervals; T603 now provides the generic Simpson-panel error interface,
but pointwise node evaluations are still missing.

## Pointwise node plan

To evaluate `LSeries Λ (2+iy)` at rational nodes, anchor at `y=0` and use a
vertical Taylor/MVT bound:

- on `Re s ≥ 3/2`, `‖LSeries Λ s‖ ≤ ∑ Λ(n)/n^{3/2} ≤ 100` (crude);
- Cauchy with radius `1/2` gives `‖deriv LSeries Λ‖ ≤ 200`;
- hence `‖LSeries Λ (2+iy) − LSeries Λ 2‖ ≤ 200|y|` for `|y| ≤ 1/2`.

This is proved as `norm_LSeries_vonMangoldt_sub_two_le` (T604), with constant
200 (actual 40). This is proved as `norm_LSeries_two_node_le` (T605): `‖LΛ(2+iy)‖ ≤ 124` for
`|y| ≤ 1/2`, using the coarse anchor `‖LΛ(2)‖ ≤ 24`.

## Rational anchor for LΛ(2)

`LΛ(2) = ∑ Λ(n)/n²`. Split at `N=100`:

- finite partial sum is a rational `anchorPartial`;
- tail: `Λ(n) ≤ log n ≤ 2√n`, so `Λ(n)/n² ≤ 2 n^{-3/2}`;
- `∑_{n>100} n^{-3/2} ≤ 2/√101` by the integral test;
- hence `LΛ(2) ∈ [anchorPartial − 1, anchorPartial + 1]` (or tighter).

This replaces the `[-24,24]` anchor by a rational interval of width about `2`.
Proved as T606–T608: `anchorLo = ⌈1000·S⌉/1000 − 2/5`, `anchorHi = ⌈1000·S⌉/1000 + 2/5`,
so the enclosure is `[0.16, 0.96]`, width `0.8`. `LΛ(2)` is real (T607).

## Digamma node bound

The matching node bound `‖ψ(1+iy/2)‖ ≤ 24` on `y ≠ 0`, `|y| ≤ 1` is being
proved from T596 (`‖ψ−log‖ ≤ 19`) plus `‖log(1+iy/2)‖ ≤ log 3 + 2 ≤ 4`.
Proved as T610/T611: `‖log(1+iy/2)‖ ≤ 4`, `‖ψ(1+iy/2)‖ ≤ 24`.

## Tight Simpson wall

The coarse certificate is complete (T600–T612). Tight Simpson needs:

- `ContDiffOn ℝ 4` of the outer `u`-integrand
  `G(u) = tentC u · exp(i3u/2) · ∫ LSeries Λ (2+iy) exp(-uy) dy`
  (and the archimedean analogue);
- explicit bounds on `iteratedDeriv 4 G` on each panel.

Those require parametric differentiation under the integral four times, with
dominated-convergence hypotheses. No such parametric-integral API or theorem
exists in the corpus. The generic Simpson estimate (T603) and all node bounds are
in place, but the `C⁴` input cannot be supplied with current infrastructure.

## Parametric differentiation goal

Tight Simpson needs `C⁴` of the outer `u`-integrand. The first generic step is

```lean
HasDerivAt (fun u => ∫ y in a..b, f y * exp(-u*y))
  (∫ y in a..b, f y * (-y) * exp(-u*y)) u
```

for continuous `f` on `[a,b]`, using Mathlib's
`hasDerivAt_integral_of_dominated_loc_of_deriv_le`. Iterating four times gives
the required `C⁴` and the fourth-derivative bound `∫ y⁴ f(y) exp(-uy)`.
Proved as T613/T614 in `ParametricExp.lean`: the unordered `uIcc` version and the
ordered `Icc` version (the latter needs `a ≤ b`).

## Iterated parametric derivative

T613/T614 give the first derivative under the integral. Iterating gives

```lean
iteratedDeriv k (fun u => ∫ f(y) exp(-u y)) u
  = ∫ f(y) (-y)^k exp(-u y),
```

and for `k=4` the explicit bound
`‖iteratedDeriv 4 F u‖ ≤ C M^4 |b-a| exp(|u|M)`.
Proved as T615/T616 in `ParametricIter.lean`.
