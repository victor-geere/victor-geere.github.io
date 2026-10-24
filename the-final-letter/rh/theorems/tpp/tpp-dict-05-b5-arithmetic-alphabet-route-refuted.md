# B5 — an arithmetic alphabet escapes the barrier (refuted as a route)

**Kind:** Claim
**Status:** REFUTED (as a route; circular)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/dictionary/05-programme-barriers-and-harvest.md`](../../research/twin-prime-parity/dictionary/05-programme-barriers-and-harvest.md) — §2 "The bridges, each disposed of", row B5

## Statement

> | bridge | claim | disposal |
> |---|---|---|
> | **B5** | an *arithmetic* alphabet (`α_p = (−1)^{Ω(p+2)}/(p+2)`) escapes the barrier | **REFUTED as a route** (circular): the signal lives in the **alphabet**, not the greedy selection, and importing `Ω(p+2)` is importing the very correlation under study |

## Hypotheses and notation

- The proposed arithmetic alphabet is `α_p = (−1)^{Ω(p+2)}/(p+2)`, where `Ω` is the prime-factor counting function with multiplicity and `p` indexes the alphabet terms.
- "The barrier" is the programme's parity barrier; the proposed route is to escape it by importing arithmetic data (`Ω(p+2)`) into the alphabet.
- The ledger's disposal is "REFUTED as a route" — not that the construction is impossible, but that it is circular as an attack.

## Proof / evidence

- The ledger records the disposal as **REFUTED as a route** (circular), with the reason that the signal lives in the alphabet, not the greedy selection, and that importing `Ω(p+2)` imports the very correlation under study. No further derivation is given in the dictionary.

## Dependencies and related results

- P17 / B3 (the correlation is not multiplicative; the ζ-machinery does not apply to it).
- The dictionary's §4: a successful attack needs a rule `R` and a statistic `T` that is sign-blind "otherwise the programme's objects are not sign-blind — fine, but then say which arithmetic input was imported, and check it is not circular".

## Notes

- This entry harvests a *refutation*: the bridge claim is the refuted proposition, and its honest status is REFUTED as a route. It is not a positive theorem of the programme.
- The qualifier "as a route" is the source's own wording ("**REFUTED as a route** (circular)") and is preserved here; it is not a claim that no arithmetic alphabet can exist.
