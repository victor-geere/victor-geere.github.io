# The per-zero count (Riemann–von Mangoldt)

**Kind:** Theorem
**Status:** CITED (literature)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh45/HANDOFF.md`](../../research/twin-prime-parity/rounds/rh45/HANDOFF.md) — §1 "The instrument"

## Statement

> Riemann–von Mangoldt.  For a suitable test function, the zeros of `ζ` are detected
> through the elementary per-zero identity
>
> ```
> N(T) = #{ρ = 1/2 + iγ : 0 < γ ≤ T}  =  (T/2π) log(T/2πe) + 7/8 + S(T) + O(1/T),
> S(T) = (1/π) arg ζ(1/2 + iT)     (continuous branch),
> ```

## Hypotheses and notation

- `N(T)` is the count of zeros `ρ = 1/2 + iγ` with `0 < γ ≤ T`; the identity counts zeros on the critical line as stated.
- `S(T) = (1/π) arg ζ(1/2 + iT)` with the **continuous** branch of the argument.
- `θ(T)` is not named here; the main term is written `(T/2π) log(T/2πe) + 7/8`.

## Proof / evidence

- The source states this in its "instrument" section without proof, as the classical Riemann–von Mangoldt count the round uses; no derivation or citation is given in the source.
- The round's ledger restates it in exact form and verifies it numerically: [The counting formula (T2/T3, the robust core)](tpp-rh45-truths-counting-formula.md).

## Dependencies and related results

- [The explicit formula (exact form)](tpp-rh45-handoff-explicit-formula-exact-form.md) — the companion statement in the same section.
- [The smoothed zero count](tpp-rh45-handoff-smoothed-zero-count.md) — the quantitative consequence the round uses.
- [The counting formula (the clean unconditional core)](tpp-rh45-readme-counting-formula.md).

## Notes

- The source calls the identity "elementary"; it gives no proof. It is harvested as a rung of the round's argument with status CITED (literature).
- HANDOFF.md is the round's specification: apart from this instrument section, its §2 lists targets T1–T5 (planned work, not harvested), its §3 lists what the round does not claim, and its §4 lists expected evidence. Only the stated mathematical results of §1 are harvested from this source.
