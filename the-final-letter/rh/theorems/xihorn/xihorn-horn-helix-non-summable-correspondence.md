# The non-summable correspondence — the shell transforms sum like √N/|1−s| while ξ(½ + iγ₁) = 1.09e−18

**Kind:** Claim
**Status:** VERIFIED (numerical, five-digit agreement with the predicted law at N = 10⁴; evidence absent; the source is prose only, no committed evaluator)
**Area:** xi-horn
**Source:** [`xi-horn/horn-helix.md`](../../xi-horn/horn-helix.md) — §2 consequence (b); §12 "Verified numbers"; §13 dictionary, term "non-summable correspondence"

## Statement

> **(b) The correspondence is exact term by term and useless summed.** Sum (5) over *n* at σ = ½ and you recover the divergent ζ series. The partial sums grow like `√N/|1−s|`, exactly rh3 §9's un-alternated train:
>
> ```
>    N        |Σ_{n≤N} shell transforms|    |completion|·√N/|1−s|
>    1        0.0017433032                  0.00012325768
>    4        0.00040479596                 0.00024651537
>    100      0.0012366747                  0.0012325768
>    10⁴      0.012326077                   0.012325768
>    10⁵      0.038977599                   0.038977502
>                                           ξ(½ + iγ₁) = 1.09e−18
> ```
>
> Five-digit agreement with the predicted law by N = 10⁴, heading to infinity, while the object it is supposed to compute is zero. **The horn's convergence does not come from the shells.** It comes from doing the *u*-integral of the whole sum, where Poisson summation folds the divergent tail into the mirror.

Dictionary entry, verbatim: "**non-summable correspondence** | the shell transforms sum like √N/\|1−s\| (0.012326 at N = 10⁴) while ξ(½+iγ₁) = 1.09e−18: the horn's convergence comes from Poisson summation on the whole weight, never from the shells".

## Hypotheses and notation

- The shell transforms are those of (5): 2∫φ_n(u)e^{(s−½)u}du = ½s(s−1)π^{−s/2}Γ(s/2)·n^{−s}.
- The sums are at s = ½ + iγ₁, where γ₁ is the first non-trivial zero ordinate and ξ(½ + iγ₁) = 1.09e−18.
- The prediction law √N/|1−s| is the source's citation of rh3 §9's un-alternated train; "|completion|" is |½s(s−1)π^{−s/2}Γ(s/2)| at that s.

## Proof / evidence

The source supplies the table quoted above and reads it ("Five-digit agreement with the predicted law by N = 10⁴, heading to infinity, while the object it is supposed to compute is zero"); the mechanism it names for the horn's actual convergence is Poisson summation on the whole weight, not the shells — "the 23 digits that collapse at u = −1.5 are the 10⁵ gears that never converge" (INTEGERS.md §2's cancellation table). §12 lists the same numbers (Σ_{n≤10⁴} = 0.012326077 against predicted 0.012325768; Σ_{n≤10⁵} = 0.038977599 against 0.038977502). No proof of the asymptotic law is given in the source beyond the identification with rh3 §9.

## Dependencies and related results

- [Shell *n* is gear *n*](xihorn-horn-helix-shell-n-is-gear-n.md) (equation (5)) is the identity being summed.
- rh3 §9's un-alternated train is the cited law.
- INTEGERS.md §2's condition-number/cancellation table is the same phenomenon from the other side.

## Notes


- The source does not present the √N/|1−s| law as its own theorem; it is identified with rh3 §9's train and checked numerically to five digits. The status is therefore numerical verification, not a proof.
- The divergence is the reason the horn's convergence cannot be attributed to the shells; §11.4 makes the same point ("What the horn contains is the helix's *terms*").

- **Evidence absent (session-003 audit repair 3, 2025-10-06).** No script, log or other evaluator is named in the document or in the source it was harvested from. The number(s) above therefore rest on the source's prose alone: nothing committed in this repository computes them. The label carries `evidence absent` for that reason and for no other — it is **not** a claim that the result is wrong, and it is **not** a demotion of the mathematics. It is the qualifier the archive already uses well elsewhere: `research/twin-prime-parity/checks/06-numerical-checks.md:378` discloses in the same spirit that `explicit_formula.log` "DOES NOT EXIST".
