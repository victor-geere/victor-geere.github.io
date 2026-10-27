# Theorem (the altitude of RH)

**Kind:** Theorem
**Status:** CITED (literature)
**Area:** rh-html
**Source:** [`rh5.html`](../../html/rh5.html) — §4 "ZFC on the circles, and the altitude of RH", theorem box at lines 582–585

## Statement

> RH is a Π⁰₁ statement of arithmetic: a single universal quantifier over a decidable matrix. Two certificates. **Analytic:** RH ⟺ |ψ(<i>x</i>) − <i>x</i>| ≤ √<i>x</i> log²<i>x</i> / 8π for all <i>x</i> ≥ 73.2 (Schoenfeld's effective von Koch) — each instance a finite computation over the gears. **Purely gear-side:** RH ⟺ σ(<i>n</i>) &lt; <i>e</i><sup>γ</sup> <i>n</i> log log <i>n</i> for every <i>n</i> &gt; 5040 (Robin), with Lagarias's unconditional dressing σ(<i>n</i>) ≤ <i>H</i><sub><i>n</i></sub> + <i>e</i><sup><i>H</i><sub><i>n</i></sub></sup> log <i>H</i><sub><i>n</i></sub> for all <i>n</i> ≥ 1.

## Hypotheses and notation

- Π⁰₁: a single universal quantifier over a decidable matrix; arithmetic statements are absolute between a universe of sets and its forcing extensions (Shoenfield).
- ψ(<i>x</i>) is Chebyshev's function (the prime staircase); the threshold 73.2 is Schoenfeld's.
- σ(<i>n</i>) = Σ<sub><i>d</i>|<i>n</i></sub> <i>d</i> is the sum of divisors; γ is the Euler–Mascheroni constant; <i>e</i><sup>γ</sup> is the Mertens density ceiling of rh5 §1; <i>H</i><sub><i>n</i></sub> is the <i>n</i>-th harmonic number.
- Gronwall's theorem bridges the two sides: lim sup σ(<i>n</i>)/(<i>n</i> log log <i>n</i>) = <i>e</i><sup>γ</sup>.

## Proof / evidence

CITED: the analytic certificate is attributed to Schoenfeld's effective von Koch, the purely gear-side one to Robin, with Lagarias's unconditional inequality. No proof is given here.

The source adds a computation from its own divisor sieve to one million:

| <i>n</i> | σ(<i>n</i>) / <i>e</i><sup>γ</sup><i>n</i> log log <i>n</i> |
|---|---|
| 5040 | 1.00556 — the last violator |
| 10080 | 0.98582 — the maximum beyond 5040 |
| 55440 | 0.98325 |
| 27720 | 0.97836 |
| 7560 | 0.97689 |

> (the champions are the colossally abundant clicks, as they must be), with Lagarias's inequality verified for all <i>n</i> ≤ 10⁴.

## Dependencies and related results

- Mertens' third theorem and Gronwall's lim sup = <i>e</i><sup>γ</sup> (§4).
- Shoenfield absoluteness, for the forcing remark.
- The source draws two consequences: "If RH is false, it is provably false" (one overloaded click, checked by finite computation); and forcing cannot change the truth of RH.

## Notes

- CITED: all three certificates are attributed to the literature (Schoenfeld; Robin; Lagarias); no proof is given.
- The source is explicit that the finite computations are not evidence: "None of this is evidence in the asymptotic sense rh4 §18 warned about; it is the <i>shape</i> of the statement that matters."
- The thresholds 73.2 and 5040, and the table entries, are quoted exactly as the source writes them.
