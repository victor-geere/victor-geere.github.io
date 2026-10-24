# The margins are flat — the scale-free measurement against Hermite

**Kind:** Claim
**Status:** VERIFIED (numerical; correction of an earlier claim in the same file; evidence absent; the source is prose only, no committed evaluator)
**Area:** xi-horn
**Source:** [`xi-horn/INTEGERS.md`](../../xi-horn/INTEGERS.md) — §5 "Beat it in topological space, then bring it back"

## Statement

> **The margins are flat — an earlier claim here was wrong.** A first pass read the raw discriminants above (1.4e−4 down to 1.1e−31) as certificates getting harder with d and n. That was measuring the discriminant's own dimensionality, not any difficulty: disc is a product over d(d−1)/2 squared root gaps, so it scales like (gap)^{d(d−1)} — one factor at d = 2, fifteen at d = 6 — and a perfectly conditioned configuration still plummets.
>
> The scale-free measurement normalises the roots to mean 0, variance 1 and compares the configuration with Hermite:
>
> ```
>  d      disc / disc(Hermite)                min gap /
>         n=0     n=10    n=20    n=30        Hermite gap
>  2      1.000   1.000   1.000   1.000       1.000
>  3      0.999   0.995   0.995   0.996       0.962
>  4      0.992   0.979   0.981   0.983       0.999   (n=30)
>  5      0.971   0.949   0.953    —          0.970
>  6      0.930   0.900   0.909    —          0.973
> ```
>
> Flat in both directions, and the d = 4 row improves with n — consistent with the Hermite limit arriving. Minimum normalised root gap sits at 0.96–1.00 of Hermite throughout. The residual d-drift in the discriminant column compounds 30 pair-factors at d = 6 against 1 at d = 2; per pair it is 0.07 % at d = 3 rising to 0.35 % at d = 6, and five points will not support an extrapolation.

## Hypotheses and notation

- disc is the discriminant of J^{d,n}, a product over d(d−1)/2 squared root gaps, scaling like (gap)^{d(d−1)}.
- The scale-free normalisation puts the roots at mean 0 and variance 1 and compares disc / disc(Hermite) and the minimum normalised root gap against the Hermite roots.
- d = 2 … 6; n = 0, 10, 20, 30 where computed; the d = 4 minimum gap entry is at n = 30.

## Proof / evidence

The source reports the scale-free measurement: disc / disc(Hermite) between 1.000 (d = 2) and 0.900–0.930 (d = 6), and minimum normalised root gap at 0.96–1.00 of Hermite. It analyses the residual d-drift as 0.07 % per pair at d = 3 rising to 0.35 % at d = 6, and declines to extrapolate from five points. This supersedes the earlier reading of the raw discriminants as certificates getting harder.

## Dependencies and related results

- The raw discriminants whose reading is corrected: [xihorn-integers-positive-jensen-discriminants.md](xihorn-integers-positive-jensen-discriminants.md).
- The Hermite limit attributed to Griffin–Ono–Rolen–Zagier (2019), which the source flags from memory: see POSITIVITY.md §5 and the companion [GORZ] hyperbolicity theorem [xihorn-integers-gorz-hyperbolicity-all-large-n.md](xihorn-integers-gorz-hyperbolicity-all-large-n.md).

## Notes


- The source explicitly retracts its own earlier claim ("an earlier claim here was wrong"); the retraction is preserved here.
- The Hermite limit is named as arriving but not stated as a precise theorem in this source; it is not harvested as a separate theorem.

- **Evidence absent (session-003 audit repair 3, 2025-10-06).** No script, log or other evaluator is named in the document or in the source it was harvested from. The number(s) above therefore rest on the source's prose alone: nothing committed in this repository computes them. The label carries `evidence absent` for that reason and for no other — it is **not** a claim that the result is wrong, and it is **not** a demotion of the mathematics. It is the qualifier the archive already uses well elsewhere: `research/twin-prime-parity/checks/06-numerical-checks.md:378` discloses in the same spirit that `explicit_formula.log` "DOES NOT EXIST".
