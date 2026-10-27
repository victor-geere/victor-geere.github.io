# The envelope anomaly, resolved

**Kind:** Claim
**Status:** VERIFIED (numerical; the source's answer is "no — different phenomena"; evidence absent; the source is prose only, no committed evaluator)
**Area:** rh-html
**Source:** [`rh32.html`](../../html/rh32.html) — §6 "The envelope anomaly, resolved", lines 1041–1073 and boxed experiments at lines 1050–1064

## Statement

The question, from rh31 §8(b): the envelope window — the window with no polynomial factor, whose heavy atoms are the first hundred *consecutive* zeros — fits the emptiest-arc law at 1.81 where every other family stays under 1.39; and consecutive wrapped ordinates carry the one long-range structure rh31 §6 detected, the 10% excess over the Poisson band at Δ′ = 0.09. Same arithmetic?

The three experiments, all at the envelope's worst point (mesh 0.12, n = 121, x = n/N<sub>eff</sub> = 0.92):

> **Shuffle.** Permute the same weight multiset across the same atoms — six draws: median 1.62, and two of the six *exceed* the original 1.81. The consecutive-ordinate assignment is not required.
> **Poisson.** Same weights on synthetic uniform positions — six draws: median 1.64, one draw at 3.59 — twice the anomaly, from pure noise. 1.81 was never a structural ceiling.
> **The arithmetic mesh.** At Δ′ = 0.09 itself the envelope's ratio *falls* to 1.49 (searched-0.12 control at the same mesh and depth: 1.06). The anomaly does not live where the arithmetic excess lives.

The answer:

> Answer: no — different phenomena. What makes the envelope special is its weight profile: a few heavy atoms over a light sea (N<sub>eff</sub> = 131 across 4,308 ordinates), which is precisely the profile that builds a wide, shallow near-void — the grid's widest and deepest (§5) — at the bulk edge. Analysis, not arithmetic. The one place arithmetic was on offer, the mesh that over-orders the wrapped ordinates, it made the certificate *better*, not worse — as equidistribution-priced certificates should.

## Hypotheses and notation

- The envelope window is the one with no polynomial factor A ≡ const; its heavy atoms are the first hundred consecutive zero ordinates.
- x = n/N<sub>eff</sub> = 0.92 at the worst point; N<sub>eff</sub> = 131 for the envelope across 4,308 ordinates.
- The tested conjecture was that the envelope's worse fit and rh31's Δ′ = 0.09 excess are the same arithmetic phenomenon.

## Proof / evidence

Numerical, three controlled experiments: shuffle (median 1.62, two of six above 1.81), Poisson positions (median 1.64, one at 3.59), and the arithmetic mesh Δ′ = 0.09 (envelope 1.49, searched control 1.06). The source's conclusion is negative for the conjecture and positive for the weight-profile explanation.

## Dependencies and related results

- [rh31-emptiest-arc-law](../rh31/rh31-emptiest-arc-law.md) — the 1.81 outlier this resolves.
- [rh31-wrapped-ordinates-ride-poisson-band](../rh31/rh31-wrapped-ordinates-ride-poisson-band.md) — the 10% Δ′ = 0.09 excess being tested.
- [rh32-safe-zone](rh32-safe-zone.md) — §5's emptiness profile that explains the envelope's wide shallow near-void.
- rh31 §8(b) posed the question.

## Notes


- The source flags one number as noise-driven: "one draw at 3.59 — twice the anomaly, from pure noise."
- Conditional on RH (the ordinates are the zero-side input).

- **Evidence absent (session-003 audit repair 3, 2025-10-06).** No script, log or other evaluator is named in the document or in the source it was harvested from. The number(s) above therefore rest on the source's prose alone: nothing committed in this repository computes them. The label carries `evidence absent` for that reason and for no other — it is **not** a claim that the result is wrong, and it is **not** a demotion of the mathematics. It is the qualifier the archive already uses well elsewhere: `research/twin-prime-parity/checks/06-numerical-checks.md:378` discloses in the same spirit that `explicit_formula.log` "DOES NOT EXIST".
