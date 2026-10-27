# Theorem 5 (the same route at N = 4)

**Kind:** Theorem
**Status:** PROVED (paper argument, numerically certified; Lean formalises the `N = 3` witness only)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh43/truths.md`](../../research/twin-prime-parity/rounds/rh43/truths.md) — §1.2 "The explicit IVT witness at `N = 3` (and `N = 4`)" (ledger row T6)

## Statement

> **Theorem 5 (the same route at N = 4).** `Re S_4(0) = 4 > 0` and `Re S_4(12/5) = -0.950677206742… < 0`, so `N = 4` is balanced in `(0, 12/5)` too;

## Hypotheses and notation

- `t` real; `S_4(t) = 1 + 2^{-it} + 3^{-it} + 4^{-it}`; `Re S_4(0) = 4` and `Re S_4(12/5) = -0.950677206742…`.
- "Balanced in `(0, 12/5)`" means there is a root of `Re S_4` in that interval, by continuity and the intermediate value theorem (the same route as Theorem 4).

## Proof / evidence

- **VERIFIED** in [`zeta_split.py`](../../research/twin-prime-parity/rounds/rh43/zeta_split.py) §3 with the rigorous enclosure. The ledger row T6 states the status as "**PROVED** (numerically certified)", evidence "§1.2, script §3".
- The source is explicit that the Lean development currently formalises the `N = 3` witness; the `N = 4` enclosure is the numerical route's.

## Dependencies and related results

- Same route as [Theorem 4 (existence of a balanced partial sum)](tpp-rh43-truths-n3-existence-ivt.md) (T5).
- Related: [The certified root table](tpp-rh43-truths-certified-root-table.md) (T7); [Existence for every N >= 3](tpp-rh43-truths-existence-every-n.md) (T8).

## Notes

- The source hedges the status: it is "PROVED (numerically certified)" in the ledger and "VERIFIED in the script §3 with the rigorous enclosure" in the prose. It is **not** claimed as a Lean-formalised result.
- The source quotes the certified value with a trailing ellipsis, `-0.950677206742…`; the shorter form `-0.9506772…` appears in HANDOFF.md §2.3.
