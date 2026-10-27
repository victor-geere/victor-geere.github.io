# the rh46 sparse-modification bound `|S_A(x) − S(x)| ≤ 2·#{n ≤ x+2 : n ∈ A}` is false

**Kind:** Claim
**Status:** REFUTED (witness `A = {5}`, `x = 5`: `|ΔS| = 4 > 2`)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh47/truths.md`](../../research/twin-prime-parity/rounds/rh47/truths.md) — §3, "A defect in rh46 that this round found", line 104

## Statement

> **A defect in rh46 that this round found:** the quoted sparse-modification bound `|S_A(x) − S(x)| ≤ 2·#{n ≤ x+2 : n ∈ A}` is **false** (witness `A = {5}`, `x = 5`: the two affected terms `n = 3` and `n = 5` each change `+1 → −1`, so `|ΔS| = 4 > 2`).

## Hypotheses and notation

- `S(x) = Σ_{n≤x} λ(n)λ(n+2)` is the two-point correlation; `S_A(x)` is its modification supported on `A`.
- `A = {5}` is the witness modification set, `x = 5` the witness cut-off.
- The bound quoted from rh46 is `|S_A(x) − S(x)| ≤ 2·#{n ≤ x+2 : n ∈ A}`; the source's counterexample gives the two affected terms `n = 3` and `n = 5`, each changing `+1 → −1`, hence `|ΔS| = 4 > 2`.

## Proof / evidence

The source gives the explicit witness `A = {5}`, `x = 5` with the two affected terms `n = 3` and `n = 5`, each changing `+1 → −1`, so that `|ΔS| = 4 > 2`. It also states the effect on the conclusion:

> The correct bound is `2·#{n ≤ x : n ∈ A or n+2 ∈ A} ≤ 4·#{m ≤ x+2 : m ∈ A}`.  The
> `o(x)` conclusion is unaffected, and rh46's stated product tail (`1.808988`) is also
> mis-derived (it bounds the *retained* primes, not the omitted ones); the conclusion
> survives on the correct tail `1.84·10⁻⁵`.

## Dependencies and related results

- [The corrected sparse bound `≤ 4·#{m ≤ x+2 : m ∈ A}`](tpp-rh47-truths-corrected-sparse-bound.md) — the repair.
- [B3 — no Euler product](tpp-rh47-truths-bridge-b3-no-euler-product.md) — shares the rigorous tail `1.84·10⁻⁵`.
- Earlier ledger row: [a sparse modification cannot move `S`](tpp-dict-00-sparse-modification-bound.md) (dictionary row F5, itself tagged "corrected in rh47").
- [HANDOFF §1(B)](../../research/twin-prime-parity/rounds/rh47/HANDOFF.md) still quotes the false bound `≤ 2·#{n ≤ x+2 : n ∈ A}`; this file records the correction.

## Notes

- This is a **correction of an earlier round (rh46)**, not a new positive result: the quoted budget is false as stated.
- The source says the `o(x)` conclusion is unaffected, and that rh46's stated product tail `1.808988` is mis-derived (it bounds the *retained* primes, not the omitted ones).
- The `2·#{n ≤ x : n ∈ A or n+2 ∈ A}` form is the corrected intermediate; the usable bound is `≤ 4·#{m ≤ x+2 : m ∈ A}`.
