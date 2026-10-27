# The smoothed zero count

**Kind:** Theorem
**Status:** CITED (literature)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh45/HANDOFF.md`](../../research/twin-prime-parity/rounds/rh45/HANDOFF.md) — §1 "The instrument"

## Statement

> The classical quantitative consequence that this round uses is the **smoothed zero count**:
>
> ```
> Σ_γ  h(γ − T)  ≈  (1/2π) ∫ h(u) [ log(T/2π) + ψ(1/4 + i(T+u)/2) + ψ(1/4 − i(T+u)/2) ] du ,
> ```
>
> whose right-hand side is smooth and whose left-hand side is a smoothed `N`.  In
> particular the count on any window is computable **without knowing the zeros in
> advance**, which is exactly what rh43/rh044 lacked.

## Hypotheses and notation

- `h` is a smoothing window; `Σ_γ` runs over the imaginary parts `γ` of the nontrivial zeros; `N` is the zero count.
- `ψ` is the digamma function; the relation is stated with `≈`, as printed.
- The right-hand side is smooth and depends only on `T` and the window `h`, not on the zeros; the left-hand side is a smoothed count.

## Proof / evidence

- The source states this as "the classical quantitative consequence" of the explicit formula, without proof or citation; harvested as CITED (literature).
- The property that the window count is computable without knowing the zeros in advance is stated by the source as what rh43/rh044 lacked.

## Dependencies and related results

- [The explicit formula (exact form)](tpp-rh45-handoff-explicit-formula-exact-form.md) — the identity from which the source says this follows.
- [The per-zero count (Riemann–von Mangoldt)](tpp-rh45-handoff-riemann-von-mangoldt-count.md).
- [The zeros (T2)](tpp-rh45-truths-first-zeros-32-digits.md) — the round's use of the window count to locate zeros without prior knowledge.
- [The counting formula (T2/T3, the robust core)](tpp-rh45-truths-counting-formula.md).

## Notes

- The relation is stated with `≈`, not `=`, and the source gives no error term or admissibility conditions on `h`; nothing stronger is claimed here.
- The source contrasts this with the partial-sum route of rh43/rh044, where no smoothing removes the `√N` error; the same contrast is stated in [`README.md`](../../research/twin-prime-parity/rounds/rh45/README.md) (harvested as [Three structural advantages over the partial-sum route](tpp-rh45-readme-three-structural-advantages.md)).
