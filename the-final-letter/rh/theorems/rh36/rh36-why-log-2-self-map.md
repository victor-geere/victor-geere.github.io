# Why log 2: the damage is ordered by the self-map fraction of the rate ladder

**Kind:** Claim
**Status:** VERIFIED (numerical, correlation −0.883); REFUTED (smallest-prime / largest-gap / shallowest-level / first-nonzero-rate readings; evidence absent; the source is prose only, no committed evaluator)
**Area:** rh-html
**Source:** [`rh36.html`](../../html/rh36.html) — §6 "Why log 2"

## Statement

> rh35 §7 (b) offered four readings of why the attacking budget goes entirely to log 2: it is the smallest prime, the largest rate gap, the shallowest level, and the first nonzero rate. One experiment kills all four. Take gear 2 out of the ladder. Then log 3 is the smallest prime, the largest gap, the shallowest level and the first nonzero rate, and log 2 is not a rate at all — and log 2 still wins, factor 0.465 against log 3's 0.618. Start the ladder at gear 3, so there is no gear 1 to measure a first nonzero rate from, and log 2 wins by more: 0.317.

> What survives is geometric. Shift the whole rate ladder by v₀ and some of it lands back on itself; on the integers the fraction that does is 1/2 at log 2, 1/3 at log 3, 1/m at log m. That fraction orders the damage at **−0.883**, on the same fifteen frequencies where the moment scores +0.06 and rh35's rate-distance scores −0.03. It is an ordering rather than a formula — 25 of the 105 pairs invert, all of them in the tail where the fraction ties at one or two gears out of twenty-four — but the top four, log 2, log 3, log 4, log 6, come out in self-map order exactly.

> The decisive test removes the arithmetic entirely. Build the ladder geometrically, ratio e<sup>0.12</sup>. Its own step maps twenty-three of twenty-four rates back onto it and takes the floor to a factor **0.010**, where log 2's best against the integers was 0.344. And log 2, which maps nothing back, does *nothing* here: factor 0.880. The integers' winner and the geometric ladder's winner have traded places. The control that fixes it is ratio 2<sup>1/6</sup>, where log 2 is six steps of the ladder and maps eighteen of twenty-four back: log 2 recovers to 0.271 while log 3, still mapping nothing, stays at 0.816.

> And the primes are the opposite extreme. No shift maps them onto themselves at all, since 2p is never prime, which is why they are simultaneously the best-conditioned of the five gear sets — floor 0.790 — and the least attackable, a best single-frequency factor of 0.596 against the geometric ladder's 0.010.

## Hypotheses and notation

- The attacking budget is a single-frequency weight profile; "damage" is the factor by which the floor is driven down.
- The self-map fraction at frequency v₀ is the fraction of the rate ladder that a shift by v₀ maps back onto itself; on the integers it is 1/m at log m.
- The ladders tested: the integers, the integers with gear 2 removed, a ladder starting at gear 3, the geometric ladder of ratio e<sup>0.12</sup>, the control of ratio 2<sup>1/6</sup>, and the primes.

## Proof / evidence

Numerical: log 2 still wins with gear 2 removed (0.465 against log 3's 0.618) and by more when the ladder starts at gear 3 (0.317); the self-map fraction orders the damage at −0.883 over fifteen frequencies (moment +0.06, rate-distance −0.03), with 25 of 105 pairs inverting in the tie tail and the top four in exact self-map order; the geometric ladder's own step takes the floor to 0.010 while log 2 does nothing there (0.880); the control 2<sup>1/6</sup> gives log 2 0.271 and log 3 0.816; the primes' best single-frequency factor is 0.596 against the geometric ladder's 0.010.

## Dependencies and related results

- [rh35-statistics-do-not-predict-the-floor](../rh35/rh35-statistics-do-not-predict-the-floor.md) — rh35 §3's refuted statistics; §6 adds the moment function refuted as well.
- [rh35-quadrature-lemma-refuted-on-g](../rh35/rh35-quadrature-lemma-refuted-on-g.md) — the search whose optimum this explains.
- [rh36-the-vector-is-the-zeta-partial-sum](rh36-the-vector-is-the-zeta-partial-sum.md) — the vector reading of the same phenomenon.

## Notes


- The source calls the surviving rule "an ordering rather than a formula" and states the number of exceptional pairs (25 of 105) rather than claiming a clean law.
- The moment-function reading is explicitly the author's own fifth reading and is refuted here: E(log 7)/mass is −0.1937 against E(log 2)/mass at −0.1294, yet log 7 does barely half the damage (0.2528 against 0.1010).

- **Evidence absent (session-003 audit repair 3, 2025-10-06).** No script, log or other evaluator is named in the document or in the source it was harvested from. The number(s) above therefore rest on the source's prose alone: nothing committed in this repository computes them. The label carries `evidence absent` for that reason and for no other — it is **not** a claim that the result is wrong, and it is **not** a demotion of the mathematics. It is the qualifier the archive already uses well elsewhere: `research/twin-prime-parity/checks/06-numerical-checks.md:378` discloses in the same spirit that `explicit_formula.log` "DOES NOT EXIST".
