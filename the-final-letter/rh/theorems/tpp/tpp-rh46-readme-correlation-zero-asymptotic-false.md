# §1.1 — the correlation of `λ ≡ 1` is exactly `x`, so `o(x)` is not formal

**Kind:** Theorem
**Status:** PROVED (Lean, `Rh46/Chowla.lean`: `corrAsymptotic_zero_false`)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh46/README.md`](../../research/twin-prime-parity/rounds/rh46/README.md) — §1.1 and §5 claim table

## Statement

> The second line is the sharpness witness: for the (completely multiplicative,
> bounded) function `λ ≡ 1` the correlation is exactly `x`, so `o(x)` is **not** a
> formal consequence of multiplicativity plus boundedness.  It is a genuine
> arithmetic statement about `λ`.

The §5 claim table states it as: "the correlation of `λ ≡ 1` is `x`, so `o(x)` is not formal | **PROVED** (Lean: `corrAsymptotic_zero_false`)".

## Hypotheses and notation

- `λ ≡ 1` is the completely multiplicative, bounded `{−1,+1}`-valued function identically `1`; its two-point correlation is `Σ_{n≤x} 1·1 = x`.
- `o(x)` here is the vanishing claimed in (★): `Σ_{n≤x} λ(n) λ(n+2) = o(x)`.
- The statement is a logical non-implication: multiplicativity plus boundedness do not formally force the correlation to be `o(x)`.

## Proof / evidence

The source gives the example as the evidence. Lean evidence: `corrAsymptotic_zero_false` is named in §4 among the contents of `lean/Rh46/Chowla.lean` ("`liouville_sq`, `liouville_abs_le_one`, `liouville_mul` (nonzero; with `liouville_mul_zero_false` refuting the zero case), `corr_abs_le`, `corr_zero`, `corrAsymptotic_zero_false`, the non-multiplicativity witness, and the slice layer (`slice_agree`, `corrSlice_eq_corr_of_lt`, `corrSliceSqSub`)") and in the §5 claim table.

## Dependencies and related results

- The `x`-correlation is the same instance as `corr_zero` (`S(x,0) = x`) of the trivial-bound entry.
- The round's §2 repeats the consistency check: "the deterministic `λ ≡ 1` has correlation `x`, so no soft/multiplicative argument alone can give `o(x)` — the input must be genuinely arithmetic."

## Notes

- The declaration name `corrAsymptotic_zero_false` says what is refuted: the asymptotic `o(x)` as a *formal* consequence. The claim is not that `λ ≡ 1` refutes (★) itself, but that it refutes any proof relying only on multiplicativity and boundedness.
- The source's own word is "sharpness witness".
