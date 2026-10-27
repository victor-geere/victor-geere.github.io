# An honest failure — the noise floor above |Im w| ≈ 200

**Kind:** Claim
**Status:** VERIFIED (numerical, 50 digits; a negative result identifying a noise floor)
**Area:** xi-horn
**Source:** [`xi-horn/rust/RESULTS.md`](../../xi-horn/rust/RESULTS.md) — Summary, "An honest failure, reproducing CONTINUATION §5"

## Statement

> **An honest failure, reproducing CONTINUATION §5.** On the ray Re w = 5 the
> same quantity reads 2.33, 2.84, 3.05 at Im w = 10, 50, 150 — and then
> **426.07 at 400i and 100.32 at 1000i**. That is not structure. |Γ_Φ| has
> fallen to ~1e−80 and ~1e−200 there, below what 50 digits can form a ratio
> from: it is precisely the failure mode §5 records, met again. Anything above
> |Im w| ≈ 200 in these tables is noise, and B3's scan is bounded accordingly.

## Hypotheses and notation

- The quantity is |w|(R − 1) along the ray Re w = 5, R the ratio (24).
- |Γ_Φ| falls to ~1e−80 at 400i and ~1e−200 at 1000i, below what 50 digits can form a ratio from.
- The bound drawn: anything above |Im w| ≈ 200 in these tables is noise.

## Proof / evidence

Numerical: the values 2.33, 2.84, 3.05 at Im w = 10, 50, 150 against 426.07 at 400i and 100.32 at 1000i, with |Γ_Φ| at ~1e−80 and ~1e−200 respectively, identify the 50-digit ratio as noise above |Im w| ≈ 200. The source calls it "precisely the failure mode §5 records, met again" and bounds B3's scan accordingly.

## Dependencies and related results

- [B3 — the widest scan](xihorn-rust-results-b3-widest-scan.md) — scans Re w ∈ [0,40] × Im w ∈ [0,150] "bounded accordingly".
- [C3 — the asymptotic constant](xihorn-rust-results-c3-asymptotic-constant.md) — the same quantity on the real axis.
- The source's §D dead-end list records the same rule: "**Reading any R or Γ_Φ table above |Im w| ≈ 200**".

## Notes

- The source records this as an *honest failure* of the measurement, not of the mathematics: the ratio is formed from noise, so the numbers 426.07 and 100.32 carry no information.
- It is a diagnostic bound on the tables, not a statement about R.
