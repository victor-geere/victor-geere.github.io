# Greedy harmonic sine: |sin θ − s_N| ≤ π/(N+1) on [0,π]

**Kind:** Theorem
**Status:** PROVED (paper argument, proof sketch; verified numerically)
**Area:** workspace
**Source:** [`research-journal.md`](../../research-journal.md) — "Status of the starting claims", lines 17–18; Round 0b, lines 51–52; Synthesis §1, line 412; "The ten things that stand" §1, line 614; Round 10 table, line 679

## Statement

> Greedy harmonic sine reconstructs sin on [0,π], error ≤ π/(N+1).

Operationally, as the journal states it in the Synthesis:

> Angles α_n = π/(n+2), greedy bits δ_n ∈ {0,1}, invariant s_n = sin θ_n exact, residual bound |sin θ − s_N| ≤ π/(N+1), all real angles reached by oddness and 2π-periodicity.

and in the Round 10 certification table:

> |sin θ − s_N| ≤ π/(N+1) on [0,π]; termination for rational θ/π; support {0,1,4} at θ = π — max error 0.0392598 at N=60 vs bound 0.0515015; exact rationals.

Related stated form (Agent B's unsigned Egyptian repair, Round 1): with x = θ/π, d₀ = x, δ_n = 1 iff d_n ≥ 1/(n+2), d_{n+1} = d_n − 1/(n+2) if so and d_n otherwise; s_N = Σ_{n≤N} δ_n/(n+2), |x − s_N| ≤ 1/(N+2).

## Hypotheses and notation

- θ ∈ [0,π]; grid used for the measurement: 160 points, working N = 60.
- α_n = π/(n+2) are the greedy angles; δ_n ∈ {0,1} are the greedy bits; s_N is the N-term greedy harmonic sine.
- The journal also states the same construction as "the greedy expansion of θ/π in the alphabet α_n = 1/(n+2)" (Round 5, line 389), i.e. with target x = θ/π and alphabet 1/(n+2).
- "All real angles" are reached by oddness and 2π-periodicity.

## Proof / evidence

The entry in the starting-claims table gives the basis as "proof sketch + numerical check in the handoff". The mediator's independent bootstrap verification (`verify/bootstrap_verification.py`, numpy 2.5.0 / mpmath 1.3.0 / python 3.13.13) measured on a 160-point grid of [0,π] with N = 60: max |sin θ − s_N| = **0.0392598**, mean = **0.00656409**, against the guaranteed bound π/61 = **0.0515015**. The journal notes that the handoff's stated 0.043 and ~0.008 were a coarser sampling and that "the bound holds, comfortably". At θ = π the digits are exactly {0,1,4} with residual 2.5e−32 and ½+⅓+⅙ = 1 exactly.

Agent A's signed Round 5 list of the construction's theorems is: "(i) termination for every rational θ/π, (ii) A(N) = O(log log N) for algebraic irrationals ... and (iii) residual ≤ π/(N+1)."

## Dependencies and related results

- [Termination of the greedy Egyptian expansion for rational θ/π](research-journal-rational-termination.md) — the exact-termination property.
- [All real angles by oddness and 2π-periodicity](research-journal-all-real-angles-by-oddness-periodicity.md) — the reduction that extends the bound to all real angles.
- [A's certification theorem for the greedy residual](research-journal-certification-theorem.md) — the general residual bound r_N ≤ Σ_{k>N} α_k.

## Notes

- The source contains two numerically different forms of the tail bound: the angle-space bound **π/(N+1)** (claims table, Synthesis §1, Round 10 table, certification line π/(N+1) = 3.138×10⁻³ at N = 1000) and Agent B's target-space bound **|x − s_N| ≤ 1/(N+2)** (Round 1). Both are recorded here; the journal never reconciles the off-by-one between them.
- The journal stresses that for irrational θ/π the bound "is real but the late digits of the greedy harmonic sine are a numerical mirage": the residual after a few terms falls below any fixed working precision, so late digits are "unrecoverable". The construction is "an excellent low-order approximant and a catastrophic digit generator".
- The journal also records the retracted (disproven) companion claim that the smallest eigenvalue of M(s) drops 7–11 orders at the zeros; that claim is not this theorem and is refuted (see the diagonal-similarity file).
