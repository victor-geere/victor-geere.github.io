# Termination for rational θ/π: the greedy Egyptian expansion terminates

**Kind:** Theorem
**Status:** CITED (literature — Fibonacci–Sylvester, Curtiss 1922; verified exhaustively for q ≤ 30)
**Area:** workspace
**Source:** [`research-journal.md`](../../research-journal.md) — "Status of the starting claims", line 19; Round 1 (b), line 131; Round 1 status table, lines 152–153; Round 1 Agent B audit, line 167; Round 10 table, line 679

## Statement

> Rational θ/π ⇒ greedy Egyptian fraction, terminates; θ=π selects {0,1,4} since ½+⅓+⅙=1.

The source's exact-rational audit:

> Exhaustive exact-rational rerun over all reduced p/q with q ≤ 30: **268 of 277 terminate**, and the nine that had not terminated within 200 000 terms (4/17, 14/19, 17/19, 7/23, 21/23, 4/25, 9/29, 12/29, 27/29) are slow, not divergent — this is Curtiss's 1922 theorem (greedy/Sylvester expansion of a rational terminates). Hardest concrete case measured: 19/23 terminates in 5 terms, last index **138458**. Unit fractions 1/k terminate in exactly one term at index k−2.

and the Round 10 certification row:

> |sin θ − s_N| ≤ π/(N+1) on [0,π]; termination for rational θ/π; support {0,1,4} at θ = π.

## Hypotheses and notation

- Target x = θ/π ∈ (0,1) rational; greedy alphabet α_n = 1/(n+2), n ≥ 0 (equivalently the Egyptian unit fractions 1/2, 1/3, 1/4, …).
- δ_n ∈ {0,1} is the greedy digit; the termination claim is that only finitely many δ_n equal 1.
- "Index" is n with denominator n+2; the index set is the support {n : δ_n = 1}.

## Proof / evidence

The source gives the result as literature, not as a new proof: "this is Curtiss's 1922 theorem (greedy/Sylvester expansion of a rational terminates)", with Agent B citing the Fibonacci–Sylvester theorem (Sylvester 1880) and term-count bounds [Curtiss 1922, Proc. LMS]. The mediator verified it by exhaustive exact-rational computation: 268 of 277 reduced p/q with q ≤ 30 terminate; the nine non-terminating-within-200 000-terms cases are slow, not divergent. Termination table for rational θ/π (greedy Egyptian, 200 terms) includes θ/π = 1/2 → {0}, 1/3 → {1}, 1/4 → {2}, 1/5 → {3}, 1/7 → {5}, 1/6 → {4}, 5/6 → {0,1}, 7/8 → {0,1,22}, 2/5 → {1,13}, while 3/7 → {1,9} and 2/3 → {0,5,41} were still not terminated at 200 terms. θ = π gives exactly {0,1,4} by exact rational arithmetic (a binary-float run had spuriously produced [0,1,5,41,1805] with residual 3.06e−7; the float digit δ₄ = 1 is rejected because 1/6 > 1e−16).

## Dependencies and related results

- [A(N) = Θ(1) for rational θ/π (density 0)](research-journal-rational-digit-count-theta-one.md) — the counting corollary of termination.
- [1/2 + 1/3 + 1/6 = 1 is the unique 3-term distinct-unit-fraction decomposition of 1](research-journal-unique-three-term-unit-fraction.md) — the exact θ = π support.
- [A's certification theorem for the greedy residual](research-journal-certification-theorem.md) — clause (c), r_N → 0, "terminating for every rational target".

## Notes

- The result is classical (CITED). The journal's contribution is the exhaustive exact-rational check and the diagnosis of a float trap, not a proof of termination.
- The source distinguishes the **unsigned** greedy rule (the one under which the claims are coherent) from a **signed** rule (take ±1/(n+2) by the sign of the residual), which "does not terminate and gives empty support at θ = π"; Agent B records the signed rule's ∅ as his own error.
- Related dead claims in the same table: δ_n monotone in θ (retracted; counterexample δ₂(π/4)=1, δ₂(π/3)=0) and the selection density D(N,θ) ~ (θ/π)·log N (retracted).
