# The local root numbers do not multiply — ∏_v γ_v(s) = 1 is not obtained from the local ones

**Kind:** Claim
**Status:** VERIFIED (numerical; seven partial products to 3×10⁶, no approach to 1 and no trend at either height; evidence absent; the source is prose only, no committed evaluator)
**Area:** xi-horn
**Source:** [`xi-horn/horn-helix-adelic.md`](../../xi-horn/horn-helix-adelic.md) — §5.3 "Every local root number is unimodular, and their product does not converge"; §9 dictionary, term "the local root numbers do not multiply"

## Statement

> But the *global* statement ∏_v γ_v(s) = 1 — which is ξ̃(1−s) = ξ̃(s), the functional equation itself — is not obtained by multiplying the local ones. Partial products on the line, all factors unimodular so only the phase moves:
>
> ```
>     P          |∏_{v ≤ P} γ_v(½+5i) − 1|      |∏_{v ≤ P} γ_v(½+20i) − 1|
>     10         0.660                          0.307
>     10²        0.233                          0.257
>     10³        1.543                          0.689
>     10⁴        1.871                          0.627
>     10⁵        1.248                          1.347
>     10⁶        1.930                          0.855
>     3×10⁶      1.952                          0.920
> ```
>
> (the maximum possible value is 2). No approach to 1, no trend, at either height. The control at σ = 1.5 shows the two halves of the local data behaving completely differently: the local *factors* converge there —
> |∏_{p≤P} Z_p − ζ| = 3.5e−02, 7.7e−03, 1.7e−03, 4.2e−04 at P = 10, 10², 10³, 10⁴ — while the local *root numbers* run away, |∏_{p≤P} γ_p| = 8.7e−03, 4.3e−20, 4.1e−209, 2.5e−2152.

(§8 prints the same control rows as |∏_{p≤P} Z_p(1.5+2i) − ζ| = 0.034733, 0.00766384, 0.00174994, 0.000423521 and |∏_{p≤P} γ_p(1.5+2i)| = 8.7e−03, 4.3e−20, 4.1e−209, 2.5e−2152.)

## Hypotheses and notation

- γ_v(s) = Z_v(1−s)/Z_v(s) is the local root number; the partial products on the line are over places v ≤ P in order.
- All factors are unimodular on the line (source (18)), so only the phase moves; the maximum possible value of |∏ − 1| is 2.
- The heights are ½+5i and ½+20i; the control is at σ = 1.5.

## Proof / evidence

Numerical: seven partial products to 3×10⁶ show no approach to 1 and no trend at either height; the σ = 1.5 control shows the local factors converging while the local root numbers run to 2.5e−2152. §8 lists the partial products "|∏_v γ_v(½+5i) − 1|, P = 10³ … 3×10⁶ | 1.543, 1.871, 1.248, 1.930, 1.952 (max possible 2)".

## Dependencies and related results

- [The functional equation is local](xihorn-horn-helix-adelic-functional-equation-is-local.md) (17)–(18) is the positive half of §5.3.
- [The strip is the gap](xihorn-horn-helix-adelic-strip-is-the-gap.md) (§5.4) gives the structural reason: the product and its reflection have disjoint half-planes of absolute convergence.
- [Place truncation does not converge](xihorn-horn-helix-adelic-place-truncation-does-not-converge.md) is the parallel negative statement for the local factors on the line.

## Notes


- The global identity ∏_v γ_v(s) = 1 is the functional equation itself and is not in question; the claim is only that it is *not obtained by multiplying the local factors*, whose partial products do not converge on the line.
- The source's §5.4 explains why: no s has both ∏_p Z_p(s) and ∏_p Z_p(1−s) absolutely convergent.

- **Evidence absent (session-003 audit repair 3, 2025-10-06).** No script, log or other evaluator is named in the document or in the source it was harvested from. The number(s) above therefore rest on the source's prose alone: nothing committed in this repository computes them. The label carries `evidence absent` for that reason and for no other — it is **not** a claim that the result is wrong, and it is **not** a demotion of the mathematics. It is the qualifier the archive already uses well elsewhere: `research/twin-prime-parity/checks/06-numerical-checks.md:378` discloses in the same spirit that `explicit_formula.log` "DOES NOT EXIST".
