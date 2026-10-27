# The product theorem: ∏(1 + a_n) converges to a finite non-zero limit iff Σ a_n converges

**Kind:** Theorem
**Status:** CITED (literature; stated as [KNOWN])
**Area:** workspace
**Source:** [`research-journal.md`](../../research-journal.md) — Round 2 Agent B answer, "[KNOWN] (i) The product theorem, stated properly", line 234; Round 2 status table, line 266; Synthesis §5, line 420; "The ten things that stand" §8, line 621

## Statement

> **[KNOWN] (i) The product theorem, stated properly.** ∏(1 + a_n) converges to a finite non-zero limit **iff Σ a_n converges** (no zero factors). Euler: a_p = (1 − p^{−s})^{−1} − 1 = Σ_{k≥1} p^{−ks} ~ p^{−s}, and Σ_p p^{−s} < ∞ for σ > 1 — summable. Annihilating case: a_n = n^{−1/2} − 1 has Σ_{n≤N} a_n = 2√N − N − c → −∞, so the product is (N!)^{−1/2}, log = −½N log N + O(N). **The failure is a whole power of N, not a borderline divergence.**

Later restatements keep the criterion verbatim:

> ∏(1+a_n) finite non-zero iff Σa_n converges; ∏n^{−1/2} = (N!)^{−1/2} (Round 10 table, line 680)

## Hypotheses and notation

- a_n are the product increments; the criterion is stated for real/complex a_n with 1 + a_n ≠ 0 ("no zero factors").
- Euler local factors: a_p = (1 − p^{−s})^{−1} − 1 = Σ_{k≥1} p^{−ks} ~ p^{−s}, summable over primes for σ > 1.
- Annihilating comparison sequence: a_n = n^{−1/2} − 1.

## Proof / evidence

Agent B states the theorem as known literature ([KNOWN]) and gives the Euler specialisation as the evidence for the convergent case and the explicit partial-sum computation for the annihilating case. The source gives no proof of the general criterion; it is the standard infinite-product convergence criterion used as a rung. The journal's own independent check is the numerical annihilation of ∏ n^{−1/2}: 1.0e−79 at N = 100 and 3.95e−435 at N = 400.

## Dependencies and related results

- [∏_{n≤N} n^{−1/2} annihilates as (N!)^{−1/2}](research-journal-factorial-annihilation-of-product.md) — the annihilating instance.
- [The local-factor dichotomy: Euler factors perturb the identity, greedy factors perturb zero](research-journal-local-factor-dichotomy.md) — the convergence mechanism read locally.
- [Differentiation converts the frequency k log p into the amplitude log p](research-journal-derivative-mechanism.md) — the multiplicative-to-additive transition applied to the surviving product.

## Notes

- The status is CITED (literature): the journal labels it [KNOWN] and attributes the Euler case to Euler, not to this workspace.
- It is harvested because the source sets it out as a labelled result ("The product theorem, stated properly") and uses it as the criterion against which the greedy construction is judged, not as a bare mention.
