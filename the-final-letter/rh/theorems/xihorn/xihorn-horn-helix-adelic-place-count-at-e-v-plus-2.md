# The places needed grow like the prime counting function at e^{v+2}

**Kind:** Claim
**Status:** VERIFIED (numerical; float64 scan bound 3×10⁷ places = 1,857,859 places, complete through v = 14; evidence absent; the source is prose only, no committed evaluator)
**Area:** xi-horn
**Source:** [`xi-horn/horn-helix-adelic.md`](../../xi-horn/horn-helix-adelic.md) — §4.6 "How many places the ledger needs"; §9 dictionary, term "the places are sampled, not summed"

## Statement

> Counting places whose term exceeds 1e−20 in the same window:
>
> ```
>     v      places needed     largest term at      e^v            π(e^{v+2})
>     0      4                 p = 2                1.0            7
>     2      16                p = 7                7.39           54
>     5      179               p = 149              148.4          201
>     10      13,585            p = 21,647           22,026         14,750
>     14      520,050           p = 1,179,637        1,202,604      ≈589,000
> ```
>
> (scan bound 3×10⁷, i.e. 1,857,859 places — enough to make every row complete through v = 14; an earlier run bounded at 2×10⁶ returned 133,360 for the last row and was measuring its own cutoff.)
>
> The count grows like the prime counting function at e^{v+2} — the window's width in the exponent — i.e. **exponentially in the depth**, and the largest single contributor sits at a prime power within a window-width of e^v. Compare the horn: at depth |u| = 1.5 it needs **one** place and the truncation costs 1e−19 (README §6).

Dictionary entry, verbatim: "**the places are sampled, not summed** | at separation v only the places carrying a prime power within a window-width of e^v contribute: p = 101 gives 1.7e−05 at v = 10 while p = 1009 gives 7.7e−48. The count grows like π(e^{v+2}) — 4, 16, 179, 13,585, 520,050 at v = 0, 2, 5, 10, 14".

## Hypotheses and notation

- Same σ = 0.15 Gaussian window and per-place ledger of §4.2; a place is "needed" if its term exceeds 1e−20.
- The comparison of the count with π(e^{v+2}) is the source's identification; e^v is the depth scale and the window's width in the exponent is 2.
- The earlier run bounded at 2×10⁶ "returned 133,360 for the last row and was measuring its own cutoff."

## Proof / evidence

Numerical: a float64 scan over 1,857,859 places below 3×10⁷, complete through v = 14; §8 lists the counts (4, 16, 179, 13,585, 520,050) and the largest single places at v = 10, 14 (p = 21,647 and p = 1,179,637 against e^v = 22,026 and 1.20e+06). The identification with π(e^{v+2}) is a comparison of the measured counts with the prime-counting column, not a proof.

## Dependencies and related results

- [The per-place ledger](xihorn-horn-helix-adelic-per-place-ledger-to-21-digits.md) (§4.2) and [the archimedean handover](xihorn-horn-helix-adelic-archimedean-handover-crossover.md) (§4.3) are the same table read differently.
- [horn-helix-adelic.md](../../xi-horn/horn-helix-adelic.md) §5.2 draws the consequence: depth truncation is cheap at every place (K = 129 at p = 2 for 1e−19) while place truncation is not — the truncation trade is reversed by the completion.

## Notes


- The count includes all places with term exceeding the 1e−20 threshold in the given window; the source notes the earlier 2×10⁶ run was measuring its own cutoff, i.e. scan bounds matter.
- §4.6's closing identification — that the prime horn's amplitude ledger |C(½+iγ_k)| is the archimedean local factor read at the closures — is a separate reading of the same section.

- **Evidence absent (session-003 audit repair 3, 2025-10-06).** No script, log or other evaluator is named in the document or in the source it was harvested from. The number(s) above therefore rest on the source's prose alone: nothing committed in this repository computes them. The label carries `evidence absent` for that reason and for no other — it is **not** a claim that the result is wrong, and it is **not** a demotion of the mathematics. It is the qualifier the archive already uses well elsewhere: `research/twin-prime-parity/checks/06-numerical-checks.md:378` discloses in the same spirit that `explicit_formula.log` "DOES NOT EXIST".
