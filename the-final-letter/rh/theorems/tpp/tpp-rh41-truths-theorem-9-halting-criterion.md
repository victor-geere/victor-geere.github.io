# Theorem 9 (halting criterion)

**Kind:** Theorem
**Status:** REFUTED (Lean; the printed `iff` is false — only "halting ⟹ some partial sum ≥ x" holds)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh41/TRUTHS.md`](../../research/twin-prime-parity/rounds/rh41/TRUTHS.md) — §4 "Alphabets `α_n = (n+2)^{−p}` and the inverse problem"

## Statement

> **Theorem 9 (halting criterion).** For a non-increasing positive alphabet and target `x`, the process halts finitely **iff** `Σ_n α_n ≥ x`. For `α_n = (n+2)^{−p}` and `x = 1` this is `ζ(p) ≥ 2`, i.e. `p ≤ p*` with
>
> ```
> p* = 1.7286472389981836181  (ζ(p*) = 2 exactly).
> ```
>
> The threshold is **target-dependent**: for `x = 1/2` it is the root of `ζ(p) = 3/2`, namely `p = 2.18528545179`.

## Hypotheses and notation

- `α_n` is a non-increasing sequence of positive alphabet weights; `x` is the target; the process takes the digit 1 at step `n` iff the residual `r ≥ α_n`, and subtracts.
- "Halts finitely" means the residual reaches `0` at some finite step.
- `ζ` is the Riemann zeta function; `p*` is the root of `ζ(p*) = 2` given to the printed precision.
- The `x = 1/2` threshold is the root of `ζ(p) = 3/2`, printed as `p = 2.18528545179`.

## Proof / evidence

`TRUTHS.md` prints the criterion as a theorem of the round (the round's preamble says every statement is PROVED or CHECKED), but gives no proof text for Theorem 9.

The round's Lean README ("Corrections found while formalising", item 2) proves the printed `iff` **false**:
- Theorem 10 row 3 has `Σ α_n = ∞ ≥ x = 1` and never halts;
- for `α_n = 2^{-(n+1)}` we have `Σ α_n = 1 = x` while the residual is `2^{-n} > 0` at every finite step.

The sound statements, both formalised in `Rh41/Alphabet.lean`, are:
- if every finite partial sum is `< x` then every index is taken and the residual is never `0` (the process never halts) — `taken_all_of_bounded_partial_sums`, `never_halts_of_partial_sums_lt`, `residual_ge_sub_sum`;
- if the residual reaches `0` at step `N` then `x ≤ Σ_{k<N} α_k` — `le_sum_of_residual_eq_zero`, "the only true direction of the printed `iff`".

## Dependencies and related results

- [Theorem 10 (structure, corrected)](tpp-rh41-truths-theorem-10-alphabet-structure.md) — its row 3 is one of the counterexamples.
- [Theorem 11 (dichotomy false)](tpp-rh41-truths-theorem-11-dichotomy-false.md) — the `α_n = 2^{−(n+1)}` counterexample.
- [Theorem 12 (inverse problem, impossibility half)](tpp-rh41-truths-theorem-12-inverse-impossibility.md) — cites Theorem 9 for the halting step.
- [Correction 2 — Theorem 9 as printed is false](tpp-rh41-lean-readme-correction-2-halting-criterion.md).

## Notes

- The source prints this as PROVED; the round's **own** Lean README refutes the printed `iff`. The status line above therefore does not repeat the source's claim of proof.
- The round's Lean README notes that "termination" is used in `TRUTHS.md` in two different senses (the residual hits `0`; the residual tends to `0`), "which is the source of the inconsistency". Concretely, Theorem 11's "terminates exactly" is formalised as `residual = (1/2)^n → 0`, not as finite termination.
- The numerical constants `p* = 1.7286472389981836181` and `p = 2.18528545179` are listed by the Lean README under "Not formalised"; the statements that the quantities exist with the claimed qualitative properties are formalised, the decimal values are not.
