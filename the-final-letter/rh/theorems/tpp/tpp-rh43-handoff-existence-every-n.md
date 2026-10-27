# Existence for every N ≥ 3 (equidistribution), and certified brackets for N = 3..50

**Kind:** Proposition
**Status:** PROOF-SKETCH + VERIFIED (numerical, complete through N = 200); a self-contained proof is the main open item
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh43/HANDOFF.md`](../../research/twin-prime-parity/rounds/rh43/HANDOFF.md) — §2.3 "The reduction, and the answer", §6 "Open, and the next round"

## Statement

> * `N = 3, …, 50`: certified root brackets, 47 digits each (the auditor's independent engine), reproduced by the round's own `ivmath` engine.
> * every `N ≥ 3`: existence is **PROOF-SKETCH + VERIFIED** (equidistribution), and a self-contained proof is the main open item (§6).

§6 states the open item:

> * **A self-contained proof of T7** (a root of `Re S_N` for every `N ≥ 3`) without quoting equidistribution — the numerically verified part is complete through `N = 200`.

## Hypotheses and notation

- `N ≥ 3`; a root is a real `t` with `Re S_N(t) = 0`.
- The certified brackets for `N = 3, …, 50` carry 47 digits each and come from the auditor's independent engine, reproduced by the round's own `ivmath` engine.
- The quoted input is the equidistribution of `(t log 2, …, t log N)`.

## Proof / evidence

- **PROOF-SKETCH + VERIFIED** for every `N ≥ 3`: the density step is quoted (equidistribution), the numerical part is complete through `N = 200`.
- **VERIFIED** for the 47-digit brackets over `N = 3, …, 50`.
- The round's ledger records these as **T7** and **T8**; the source labels the self-contained proof the main open item.

## Dependencies and related results

- Harvested truths counterparts: [Theorem 6 (certified root table)](tpp-rh43-truths-certified-root-table.md), [Theorem 7 (existence for every N ≥ 3)](tpp-rh43-truths-existence-every-n.md), ledgers [T7](tpp-rh43-truths-certified-root-ledger.md) and [T8](tpp-rh43-truths-existence-every-n-ledger.md).
- Related: [N = 3 is balanced with the explicit IVT witness t = 5/2](tpp-rh43-handoff-n3-ivt-witness.md).

## Notes

- HANDOFF.md §6 also lists "Exact complex vanishing for `N ≥ 4`" and the next-round question about zeta's own zeros as open; those are targets, not results, and are not harvested.
- The next-round target is stated as the honest open item: "an explicit bridge (an approximate-functional-equation or a smoothing identity turning `S_N` into `ζ`) … is *not* claimed here."
