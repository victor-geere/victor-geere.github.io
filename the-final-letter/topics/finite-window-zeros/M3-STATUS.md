# M3-finite — status

**Goal.** A non-vacuous finite-window explicit formula for the scaled tent,
using the repaired pole-corrected product `Fext`.

## What is proved

| Layer | Result |
|---|---|
| Upstream repair | `Fext = s(s−1)Λ₀+1`, entire, `Fext 0 = Fext 1 = 1`, agrees with `s(s−1)Z` away from poles |
| Corrected remainder | `differentiableOn_globalRemainder_repair`, `exists_analyticOnNhd_globalRemainder_repair` |
| Corrected contour | `test_function_explicit_formula_repair`, `contour_shift_paleyWiener_repair` |
| Finite-window consumers | T543, T544, T546 |
| General finite-zero tent formula | T547 `p4_tent_finite` |
| Concrete zero set | T551–T559 `FextZeroFinset R` (ζ-zeros minus `0,1`, containment, completeness, monotonicity) |
| Zero equivalence | T548–T550 `Fext s = 0 ↔ ζ s = 0` away from `0,1` |
| Instantiated formula | T557 `p4_tent_from_zeros` |

T557 is the current M3-finite endpoint. Its remaining explicit hypotheses are:

- `hF_simple : ∀ ρ ∈ FextZeroFinset R, deriv Fext ρ ≠ 0`;
- `hZeroIn : every Fext-zero in U lies in R`;
- `hΓ`, `hZ`, `hint`.

## What remains

1. **Simplicity — done.** T560 `deriv_completedZeta_of_zeta_zero` and T561
   `deriv_Fext_ne_zero_of_simple` prove the transfer.
2. **Zero location.** Choose a concrete compact rectangle `R` and open `U`, and
   prove every `Fext`-zero in `U` lies in `R`. A zero-free strip would make this
   vacuous.
3. **Numerical archimedean/prime data.** Enclose `tentArch T` and
   `tentPrime T` at a concrete rational `T`.
4. **Final assembly.** Substitute the intervals into T557/T546.

## Honesty notes

- No RH or GRH claim.
- T534/T536/T539 are vacuous old consumers and are marked superseded.
- `Fext` is the correct pole-corrected object; the old raw product is not used in
  T543/T544/T546/T547/T557.

## Blocking boundary (2026-11-18)

The explicit-formula repair is complete. The remaining M3-finite work is not a
repair task:

- **Zero-location.** No rigorous zero-free strip for the contour rectangle is
  available. T557 can consume one, but constructing it needs a new interval /
  argument-principle certificate over the critical strip.
- **Numeric enclosure.** No rigorous interval enclosures of `tentArch T` and
  `tentPrime T` exist. These require new quadrature and L-series enclosure work.

Both are new numerical-analysis infrastructure, not missing pole bookkeeping.
T557 is the exact formal endpoint they must feed.
