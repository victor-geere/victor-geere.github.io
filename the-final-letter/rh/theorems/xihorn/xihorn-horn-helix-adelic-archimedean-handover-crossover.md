# The archimedean handover — the finite places overtake W_∞ at v* = 0.6701618091

**Kind:** Claim
**Status:** VERIFIED (numerical, σ = 0.15 Gaussian window; crossover v* = 0.6701618091; evidence absent; the source is prose only, no committed evaluator)
**Area:** xi-horn
**Source:** [`xi-horn/horn-helix-adelic.md`](../../xi-horn/horn-helix-adelic.md) — §4.3 "Where the weight sits"; §9 dictionary, term "the archimedean handover"

## Statement

> ```
>     v      volume term      W_∞              Σ_p W_p          E(v)                    |Σ_p W_p| / |W_∞|
>     0      0.284338251591   −0.279916164061  −0.00125244542   0.003169642105395524     0.00447
>     1      0.320627195395   −0.102837171783  −0.217789790492  2.331205694651819e−07    2.12
>     2      0.438756849767   −0.053425856423  −0.388491462706  −0.003160469361761614    7.27
>     3      0.668880037024   −0.031812523401  −0.637077213888  −9.700265983602851e−06   20.0
>     5      1.743644468900   −0.011670558926  −1.731937005890   3.690407645630660e−05   148
>     8      7.764775178630   −0.002603918705  −7.759014529590   0.003156730331609184     2980
>     10     21.100727014180   −0.000957928037  −21.10293701520  −0.003167929015991991    22030
>     12     57.355471293600   −0.000352402030  −57.35195633930   0.003162552253771376   162746
> ```
>
> **The archimedean place hands the ledger over to the finite ones almost immediately.** At v = 0 the finite places contribute 0.45 % of what ∞ does; the crossover is at **v\* = 0.6701618091**, where both sides read −0.1518012429; and by v = 12 the finite places outweigh the archimedean one by 1.6×10⁵. The ratio grows like e^{v/2} — the volume term's own cosh(v/2), which the finite places must cancel and ∞ cannot.

## Hypotheses and notation

- Same window as §4.2: the Weil pairing of two translates of one Gaussian window φ(u) = e^{−u²/2σ²} at σ = 0.15, with separation v.
- The columns are the volume term, W_∞, the sum over finite places Σ_p W_p, and E(v) = volume + W_∞ + Σ_p W_p (source (16)).
- Every E(v) column entry "reproduces positivity-generator.md §2.1's table to the digits printed there."

## Proof / evidence

Numerical: the per-place decomposition of §4.2 evaluated across v (mpmath, 30–40 digits); the crossover v* = 0.6701618091 and the ratio at v = 0, 5, 12 (0.00447, 148, 1.63e+05) are in §8's verified numbers, as is the crossover row: "archimedean/finite crossover |Σ_p W_p| = |W_∞| | v\* = 0.6701618091, both sides −0.1518012429".

## Dependencies and related results

- [The per-place ledger](xihorn-horn-helix-adelic-per-place-ledger-to-21-digits.md) (§4.2) for the decomposition and totals.
- §6 draws the consequence: "the adelic split does **not** localise the difficulty at ∞ in any naive sense — at large separation ∞ contributes almost nothing."

## Notes


- The measured crossover is specific to the σ = 0.15 Gaussian window; the ratio's growth "like e^{v/2}" is described as "the volume term's own cosh(v/2)", which the finite places must cancel.
- The statement is a numerical finding of §4, not a theorem; §7.3 classifies §4 as a decomposition/attribution.

- **Evidence absent (session-003 audit repair 3, 2025-10-06).** No script, log or other evaluator is named in the document or in the source it was harvested from. The number(s) above therefore rest on the source's prose alone: nothing committed in this repository computes them. The label carries `evidence absent` for that reason and for no other — it is **not** a claim that the result is wrong, and it is **not** a demotion of the mathematics. It is the qualifier the archive already uses well elsewhere: `research/twin-prime-parity/checks/06-numerical-checks.md:378` discloses in the same spirit that `explicit_formula.log` "DOES NOT EXIST".
