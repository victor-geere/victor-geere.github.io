# The admissibility constraint (Gaussian inadmissible) — REFUTED

**Kind:** Claim
**Status:** REFUTED (withdrawn by Agent A, refuted by Agent B, accepted by the mediator)
**Area:** workspace
**Source:** [`research-journal.md`](../../research-journal.md) — Round 5, line 391; Synthesis §7, line 424; Round 5, line 470; error ledger, line 656; Round 6, line 535

## Statement

The claim as first stated and endorsed (Round 5):

> **A's Q2 answer — the admissibility constraint — is the deepest result of the dialogue and I accept it.** Two statements: (i) the Gaussian is inadmissible because it is self-dual and grows in the strip — F(2in) = e^{2σ²n²}, measured 1.4948 (n=1), 2.72e21 (n=10), **1.35e195** (n=30) at σ = ½; (ii) by Paley–Wiener, a compactly supported spatial test function h has an entire transform H of exponential type, hence bounded in every strip |Im r| ≤ ½, and then the prime side **truncates to finitely many primes**. The resulting dichotomy … **This is the one theorem-shaped statement in the whole dialogue.** I flag one part as unverified…

The refutation (Synthesis §7, Round 5):

> **~~The admissibility constraint (A, Round 5) — the one theorem-shaped discovery.~~ RETRACTED.** I had written that the explicit formula requires test functions bounded in |Im r| ≤ ½, that a Gaussian is therefore inadmissible, and that this explained every failed truncation. **Both halves are wrong, and B refuted them.** A Gaussian g(u) = e^{−u²/2R²} has ĝ(r) = R√(2π)e^{−R²r²/2}, entire and rapidly decaying in every strip — admissible by every standard criterion. My "F̂(2in) = 1.35e195" computed a transform in a *different pairing* (a Mellin-type object), not the Fourier pair of the explicit formula. A's own numbers in support of his version were the reciprocal of the same artefact.

> **B's refutation of the admissibility theorem — accepted, and this is the most important single judgement in the dialogue, because it destroyed the mediator's last positive result.**

## Hypotheses and notation

- The claimed inadmissibility: for the explicit formula in r (the spectral variable), an admissible test function would need ĝ bounded in every strip |Im r| ≤ ½.
- The Gaussian pair used by the source: g(u) = e^{−u²/2R²}, ĝ(r) = R√(2π)e^{−R²r²/2}.
- The artefactual number: "F̂(2in) = 1.35e195" at σ = ½, n = 30, computed in a different (Mellin-type) pairing.

## Proof / evidence

The refutation is a computation: the Gaussian's Fourier transform ĝ(r) = R√(2π)e^{−R²r²/2} is entire and rapidly decaying in every strip, so the Gaussian is admissible. The mediator's supporting divergence figure was computed in a different pairing and so did not apply; Agent A's supporting numbers were "the reciprocal of the same artefact". Round 6 records that Agent A "withdrew his own admissibility theorem unprompted — 'the correct statement is the smoothness/support trade-off, not a blanket boundedness class'."

## Dependencies and related results

- [The decay-rate criterion: g must decay faster than e^{−x/2}](research-journal-decay-rate-admissibility.md) — what replaces this claim.
- [The two sides of the explicit formula are dual but exponentially non-equi-truncatable](research-journal-non-equi-truncatability.md) — the replacement result the mediator then quantified.
- [The frequency/amplitude dictionary of the explicit formula](research-journal-frequency-amplitude-dictionary.md) — unaffected by the refutation, since it needs no archimedean convention.

## Notes

- The error ledger records this entry twice, once for Agent A and once for the mediator: "A | Gaussian inadmissible ('F(2in) blows up') | admissible; real obstruction is globality" and "mediator | 'admissibility theorem' | truism about globality".
- The status is REFUTED. The journal's own words: this was "the mediator's last positive result" and it "should not have been dressed as a theorem about test functions."
