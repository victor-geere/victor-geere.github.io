# Round 126 — closing verification and the honest ledger

*Plan fixed at the start of the round (`rounds.log`, BEFORE line).*

---

## 1. The envisioned path

One round remains after this one. The last substantive act is to verify the whole record mechanically and to
state — without decoration — what the programme achieved and what it did not.

## 2. Wild guess 67

> **Wild guess 67.** The complete verification suite is green across both phases: phase 019's exact test and
> sympy cross-check, phase 020's 35-claim audit, its 20 unit tests, its link graph, and its fourteen Lean
> modules.

**Why guess it.** Each piece was verified when written; the risk is cross-phase drift, not local failure.

**Falsification test.** Run everything.

## 3. Results — the full suite

| check | result |
|---|---|
| 019 unit tests | 14 / 14 OK |
| 019 falsification test | 80 primes, 0 failures, `EXIT=0` |
| 019 sympy/mpmath cross-check | `EXIT=0` |
| 020 audit | 35 claims, 0 failures |
| 020 unit tests | 20 / 20 OK |
| 020 link check | 26 documents, 36 links, 0 broken |
| 020 Lean layer | 14 modules, `[check] OK`, standard axioms |

**Wild guess 67 is confirmed.** The record is mechanically consistent end to end.

## 4. The honest ledger

**What the programme achieved.**

1. A precise, measured statement of the parity barrier in one model: the best square-weight sieve is `2^dim`
   times the truth (`2` for qrimes, `4` for twins), and the deficiency is dimensional, not local-density.
2. Four standard mechanisms measured and closed: `Λ²` (`4`), bilinear (indefinite), windows (no cancellation),
   large sieve (slack `n`).
3. An exact counting framework — coprime-pair expansion with a `0/1` boundary, exactness of the Legendre sieve
   at `y = n/2` — both Lean-certified.
4. Numerical support for the fixed-`q` asymptotic to `n = 14` (`T(13) = 3747`, `T(14) = 9510`), with the error
   always inside `0.30 q^{n/2}`.
5. A sharpened 019 identity: exact at `q ≡ 1 (mod 8)`, corrected `χ₂(2c)` form verified at 80 primes.
6. The transfer demand, stated constructively: a grading substitute for the Möbius truncation.

**What it did not achieve.**

1. **The barrier was not crossed.** No mechanism in the phase does it, and the one that could — 2D
   equidistribution — was not formalised.
2. **The fixed-`q` asymptotic remains unproved** (conjectural in the literature). The programme supplies
   evidence and constraints, not a proof.
3. **The 019 identity remains open.**
4. **The `d=4` cap's generic case** still rests on three cited theorems and one unformalised decomposition
   (018, unchanged by this phase).

**What changed in understanding.** The barrier is not a missing estimate to be sharpened. It is a missing
*object*: a way to resolve the two conditions jointly, which in `𝔽_q[x]` is the Frobenius and in `ℤ` would be a
grading substitute. Every negative result of the phase is an instance of that single absence.

## 5. Lean

No new lemma this round: the capstone (`Capstone.local_factor_dichotomy`, `parity_constants`) from round 124
already states the phase's local content, and the full fourteen-module layer was re-elaborated above.

## 6. State

* Full suite green; ledger written.
* The goal's remaining round will be the handover: a document that tells a successor exactly where to start,
  with the four concrete directions and the constraints any proof must satisfy.

## 7. Next round (127 — final)

Write the handover and close the log.
