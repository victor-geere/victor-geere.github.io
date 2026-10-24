# The per-place ledger — the Weil pairing split by place reproduces E(0) and E(10) to 21 digits

**Kind:** Claim
**Status:** VERIFIED (numerical, 21 digits against the published E(v); independently checked against 30 zeros to 21–29 digits; evidence absent; the source is prose only, no committed evaluator)
**Area:** xi-horn
**Source:** [`xi-horn/horn-helix-adelic.md`](../../xi-horn/horn-helix-adelic.md) — §0 "Headline", §4.2 "The per-place table", §4.4 "The check that makes the split independent"; §9 dictionary, term "the ledger, place by place"

## Statement

> §4 breaks the Weil pairing of [positivity-generator.md](../../xi-horn/positivity-generator.md) §2 into its per-place terms and reproduces that file's `E(0)` and `E(10)` to **21 digits**, place by place. That table is the file's main empirical content.
>
> Take [positivity-generator.md](../../xi-horn/positivity-generator.md) §2's kernel — the Weil pairing of two translates of one Gaussian window, `φ(u) = e^{−u²/2σ²}` at σ = 0.15, as a function of the separation *v*. That file computes E(v) two ways (22,986 prime powers on one side, 30 ordinates on the other) and they agree to 2e−30. Here is the same number **split by place**, at v = 0:
>
> ```
>    place            contribution                       running total
>    volume       +0.28433825159078621253            0.28433825159078621253
>    ∞            −0.27991616406062974035            0.0044220875301564721776
>    2            −0.0012519397691183105678          0.0031701477610381616098
>    3            −5.0565552145051910258e−07         0.0031696421055167110906
>    5            −1.2118644107533763414e−13         0.0031696421053955246496
>    7            −2.0903356717543403182e−19         0.0031696421053955244405
>    11           −6.8978273038693064e−29            0.0031696421053955244405
>    13           −6.7771106927742606e−33            0.0031696421053955244405
>    …            (all remaining places)             0.0031696421053955244405
>    TOTAL                                           0.003169642105395524440539
> ```
>
> against `E(0) = 0.00316964210539552444` as published — **21 digits, and three places carry all of it.**

At v = 10 the table's total is −0.003167929015991991309161 against E(10) = −0.00316792901599199131, "21 digits again" (volume +21.100727014180420256; ∞ −0.00095792803677548885; largest finite terms at p = 22027 and p = 22031, each ≈ −0.0179). §4.4's independent check: `E(v) = 2Σ_k Φ̂(γ_k)²cos(γ_k v)` from 30 ordinates agrees with the place-side totals with relative differences 2.0e−29 (v = 0), 3.4e−25 (v = 1), 1.8e−29 (v = 2), 1.8e−27 (v = 5), 2.5e−21 (v = 10).

## Hypotheses and notation

- E(v) is positivity-generator.md §2's Weil pairing of two translates of one Gaussian window φ(u) = e^{−u²/2σ²} at σ = 0.15, as a function of separation v.
- The rows are the local terms of (11): the volume term, W_∞, and W_p for each finite place p; the running total is over all places in order up to that row.
- The place rows shown are a selection; between p = 1009 and p = 22027 the running total falls by 9.6 across the places not shown.

## Proof / evidence

Numerical: the per-place split (22,837 primes below 260,000, mpmath at 30–40 digits per §8) reproduces the published E(0) and E(10) to 21 digits, and the same totals against the zeros from 30 ordinates agree to between 21 and 29 digits. The source's own qualification: "§4's table is a decomposition, not a new computation. The totals were already in positivity-generator.md §2.1, verified there against the zeros. What §4 adds is the attribution — which place pays what — and that attribution is a regrouping of a convergent sum, not an independent result."

## Dependencies and related results

- [positivity-generator.md](../../xi-horn/positivity-generator.md) §2, §2.1 (the kernel and its published E(v)).
- [The local Weil term at a finite place](xihorn-horn-helix-adelic-local-weil-term-finite-place.md) (13) and [the archimedean local kernel](xihorn-horn-helix-adelic-archimedean-local-kernel.md) (14) are the terms being summed.
- [Every finite place's term is negative](xihorn-horn-helix-adelic-finite-place-terms-negative.md), [the archimedean handover](xihorn-horn-helix-adelic-archimedean-handover-crossover.md), [the place count](xihorn-horn-helix-adelic-place-count-at-e-v-plus-2.md) are §4's readings of this table.

## Notes


- The source is explicit that this is a regrouping of a convergent sum, not an independent result; the value it claims is the attribution (§4.3–§4.6).
- At v = 0 "three places carry all of it" — the volume, ∞ and p = 2; at v = 10 the volume term is 21.1 and the places cancel it to four parts in 10⁴.

- **Evidence absent (session-003 audit repair 3, 2025-10-06).** No script, log or other evaluator is named in the document or in the source it was harvested from. The number(s) above therefore rest on the source's prose alone: nothing committed in this repository computes them. The label carries `evidence absent` for that reason and for no other — it is **not** a claim that the result is wrong, and it is **not** a demotion of the mathematics. It is the qualifier the archive already uses well elsewhere: `research/twin-prime-parity/checks/06-numerical-checks.md:378` discloses in the same spirit that `explicit_formula.log` "DOES NOT EXIST".
