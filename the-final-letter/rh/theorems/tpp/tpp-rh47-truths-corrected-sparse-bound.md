# the corrected sparse-modification bound `≤ 4·#{m ≤ x+2 : m ∈ A}`

**Kind:** Theorem
**Status:** **PROVED (paper argument; machine-checked in Lean 2026-10-11 — OP-12 closed).** `Rh47/Sparse.lean` (`corrSparse_sub_corr_abs_le`, `corrSparse_sub_corr_abs_le_four`, `rh46_sparse_bound_false`, `corrSparse_bound_sharp`).
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh47/truths.md`](../../research/twin-prime-parity/rounds/rh47/truths.md) — §3, "A defect in rh46 that this round found", line 107

## Statement

> The correct bound is `2·#{n ≤ x : n ∈ A or n+2 ∈ A} ≤ 4·#{m ≤ x+2 : m ∈ A}`.  The `o(x)` conclusion is unaffected, and rh46's stated product tail (`1.808988`) is also mis-derived (it bounds the *retained* primes, not the omitted ones); the conclusion survives on the correct tail `1.84·10⁻⁵`.

The consequence the source draws in §4:

> By the corrected sparse
> bound, the greedy support moves `S(x)` by `O(log log x) = o(x)`: it cannot be the
> positive-density witness that `(★)` requires.

## Hypotheses and notation

- `S(x) = Σ_{n≤x} λ(n)λ(n+2)`; `S_A(x)` is its modification on the set `A`.
- The intermediate count is `#{n ≤ x : n ∈ A or n+2 ∈ A}`; the usable form counts `#{m ≤ x+2 : m ∈ A}`.
- `(★)` is `Σ_{n≤x} λ(n)λ(n+2) = o(x)`, marked **OPEN** by the source.
- The rigorous tail quoted for the accompanying Dirichlet series is `1.84·10⁻⁵`; rh46's stated product tail was `1.808988`.

## Proof / evidence

The source states the corrected bound without giving the derivation, only the witness that refutes the rh46 version ([`A = {5}`, `x = 5`, `|ΔS| = 4 > 2`](tpp-rh47-truths-rh46-sparse-bound-refuted.md)). The count-bounding step `2·#{n ≤ x : n ∈ A or n+2 ∈ A} ≤ 4·#{m ≤ x+2 : m ∈ A}` is asserted, not proved in detail, and the `o(x)` conclusion and the corrected tail `1.84·10⁻⁵` are stated as surviving.

## Dependencies and related results

- [The rh46 sparse-modification bound is false](tpp-rh47-truths-rh46-sparse-bound-refuted.md) — the witness that forces the correction.
- [The corrected barrier](tpp-rh47-truths-corrected-barrier-open.md) — uses the positive-density requirement.
- [B3 — no Euler product](tpp-rh47-truths-bridge-b3-no-euler-product.md) — shares the rigorous tail `1.84·10⁻⁵`.
- Earlier ledger row: [a sparse modification cannot move `S`](tpp-dict-00-sparse-modification-bound.md) (dictionary row F5, tagged "PROVED (paper argument; corrected in rh47)").
- The `|S_A(x) − S(x)| ≤ 2·#{n ≤ x+2 : n ∈ A}` form quoted in [HANDOFF §1(B)](../../research/twin-prime-parity/rounds/rh47/HANDOFF.md) is the superseded false one.

## Notes

- The source presents this as a **repair of rh46**: the `o(x)` conclusion is unaffected and survives on the correct tail `1.84·10⁻⁵`.
- rh46's stated product tail `1.808988` is flagged as mis-derived (it bounds the *retained* primes, not the omitted ones).
- The `O(log log x) = o(x)` reading in §4 is stated as a consequence of this bound applied to the (Sylvester-sparse) greedy support; it is not labelled as a separate theorem by the source.
