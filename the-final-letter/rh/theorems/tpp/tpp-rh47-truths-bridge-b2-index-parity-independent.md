# B2 — the zeta budgets carry no `Ω`-parity information: index parity is independent of `Ω`-parity

**Kind:** Claim
**Status:** REFUTED (index parity and `Ω`-parity independent; index parity is invisible to the correlation itself)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh47/truths.md`](../../research/twin-prime-parity/rounds/rh47/truths.md) — §2, "B2 — do the zeta budgets carry `Ω`-parity information?  **REFUTED**", line 64

## Statement

> ### B2 — do the zeta budgets carry `Ω`-parity information?  **REFUTED**
>
> Index parity and `Ω`-parity are independent: at `N = 10⁷` the four cells give `χ²(1) = 2.944` (`z = 0.99`), and the residual coupling after conditioning on the margins has permutation `z = 1.47, 1.30`.  **The strengthening the auditor found is the decisive one: index parity is invisible to the correlation itself** — `Σ λ(n)·(−1)ⁿ · λ(n+2)·(−1)^{n+2} = Σ λ(n)λ(n+2)` exactly (`0/10⁶` mismatches), so even perfect knowledge of index parity would say nothing about `(★)`.

## Hypotheses and notation

- `λ(n) = (−1)^{Ω(n)}` is the Liouville function; `Ω`-parity means the parity of `Ω(n)`.
- "Index parity" is the parity of the index `n` itself (even/odd), the parity class the budget identities separate.
- At `N = 10⁷` the four cells of the `2×2` table (index parity × `Ω`-parity) give `χ²(1) = 2.944` (`z = 0.99`); the residual coupling after conditioning on the margins has permutation `z = 1.47, 1.30`.
- `(★)` is the two-point Chowla statement `Σ_{n≤x} λ(n)λ(n+2) = o(x)`, which the source marks **OPEN**.

## Proof / evidence

Numerical, from [`greedy_parity_probe.py`](../../research/twin-prime-parity/rounds/rh47/greedy_parity_probe.py) → `verify/greedy_parity_probe.log` (**23/23 checks**, exit 0), audited by `verify/independent_check.py` (**31/31 checks**, exit 0). The decisive leg is the twist-invariance identity `Σ λ(n)·(−1)ⁿ · λ(n+2)·(−1)^{n+2} = Σ λ(n)λ(n+2)`, verified exactly with `0/10⁶` mismatches — the factor `(−1)ⁿ(−1)^{n+2} = 1` makes the twist invisible to the correlation.

## Dependencies and related results

- [B1 — no `λ`-parity signal in the greedy support](tpp-rh47-truths-bridge-b1-no-lambda-parity-signal.md) and [B3 — no Euler product](tpp-rh47-truths-bridge-b3-no-euler-product.md) — the other two bridges.
- [The corrected barrier](tpp-rh47-truths-corrected-barrier-open.md) — the source's correction 2 records that "the budget sign-blindness (strengthened by twist invariance)" is what is *proved*, while "the two do not mix" stays OPEN.
- Restated in this round: [README B2](tpp-rh47-readme-bridge-b2-index-parity-independent.md) (measured max relative deviation `<1%`), [HANDOFF B2](tpp-rh47-handoff-bridge-b2-index-parity-refuted.md) (`P+N = ζ−1`, `P−N = 1−η`).
- Earlier ledger row: [bridge B2](tpp-dict-00-bridge-b2-index-parity.md).

## Notes

- The source's status is **REFUTED**: the budgets separate *index parity*, not the parity of `Ω(n)`.
- The identity `Σ λ(n)·(−1)ⁿ · λ(n+2)·(−1)^{n+2} = Σ λ(n)λ(n+2)` is stated as "exactly" true with `0/10⁶` mismatches; the source's claim is that even perfect knowledge of index parity would say nothing about `(★)`.
- The source states no analytic proof; the evidence is the finite computation and its audit.
