# RH is equivalent to M(x) = O(x^{1/2+ε}) for every ε > 0

**Kind:** Theorem
**Status:** CITED (literature)
**Area:** workspace
**Source:** [`research-journal.md`](../../research-journal.md) — Round 2 ruling, line 242; error ledger, line 478; Round 10 error ledger, line 636

## Statement

> Verified false as stated: by Abel summation, convergence at s = ½ requires M(x)x^{−1/2} → 0 where M(x) = Σ_{n≤x} μ(n), and **RH is equivalent to M(x) = O(x^{1/2+ε}) for every ε > 0**. Even the weaker Mertens bound M(x) = O(x^{1/2}) is *false* (Odlyzko–te Riele 1985). Measured partial sums of μ(n)n^{−1/2}: |·| = 0.5517 (N=10³), 0.8942 (10⁴), 0.8347 (10⁵), 0.6780 (2·10⁵), with M(N)/√N = +0.0632, −0.2300, −0.1518, −0.0022 — oscillating at order 1, not converging. (The correct unconditional statement nearby is that Σ μ(n)n^{−s} converges for Re s = ½+δ for any δ > 0; whether Σ μ(n)n^{−1/2} converges is RH-equivalent.)

## Hypotheses and notation

- M(x) = Σ_{n≤x} μ(n) is the Mertens function; μ is the Möbius function.
- The equivalence is RH ⟺ M(x) = O(x^{1/2+ε}) for every ε > 0; the stronger Mertens conjecture M(x) = O(x^{1/2}) is false.
- Abel summation converts convergence of Σ μ(n)n^{−s} at s = ½ into the condition M(x)x^{−1/2} → 0.

## Proof / evidence

Stated as a classical equivalence (CITED) and used as the rung that refutes Agent A's claim that Σ μ(n)n^{−s} converges at σ = ½ unconditionally. Numerical context: partial sums |Σ_{n≤N} μ(n)n^{−1/2}| = 0.5517, 0.8942, 0.8347, 0.6780 at N = 10³, 10⁴, 10⁵, 2·10⁵, with M(N)/√N = +0.0632, −0.2300, −0.1518, −0.0022. The source cites Odlyzko–te Riele 1985 for the falsity of M(x) = O(x^{1/2}).

## Dependencies and related results

- [The product theorem: ∏(1 + a_n) converges to a finite non-zero limit iff Σ a_n converges](research-journal-product-convergence-theorem.md) — uses the surviving Euler product 1/ζ(s) = Σ μ(n)n^{−s}.
- [The local-factor dichotomy: Euler factors perturb the identity, greedy factors perturb zero](research-journal-local-factor-dichotomy.md) — the local factors of the Möbius product.

## Notes

- The status is CITED (literature): the equivalence and the counterexample are classical, not results of this workspace. It is harvested because the source sets the equivalence out as a labelled rung (**"RH is equivalent to …"**) in its refutation of Agent A's claim.
- The journal's judgement: "**This matters because it is exactly the kind of error the persona is built to make — perfect recall, delusional inference — and here the delusion is arithmetic rather than geometric.**" The error ledger records "A | Σμ(n)n^{−s} converges at σ=½ | RH-equivalent; false as stated".
