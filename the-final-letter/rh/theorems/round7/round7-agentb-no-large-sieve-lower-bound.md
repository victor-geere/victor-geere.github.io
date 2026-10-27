# Refuted: a large-sieve lower bound of the shape ~√(N/T)

**Kind:** Claim
**Status:** REFUTED (the recalled claim; the source supplies the correct direction)
**Area:** workspace
**Source:** [`round7_agentB.md`](../../research/various/round7_agentB.md) — §(2) "LARGE-SIEVE CLAIM — INVALID", lines 17–24

## Statement

> There is NO large-sieve lower bound of the shape ~sqrt(N/T); lower bounds for Dirichlet
> polynomials come from second-moment / resonance arguments, and the exponents differ.
> So A's [RECALL] is a misstatement of the inequality direction, and the citation supports
> the opposite direction. The CONCLUSION survives by a different route: the trivial bound on a
> partial sum requires knowing the zero locations (S(T) enters); S(T)=O(log T) is the only
> unconditional bound, and no modulus depending on N alone can control it. Salvage: state it as
> "certification requires zero information", not as "the large sieve gives a lower bound".

## Hypotheses and notation

- The refuted shape is a lower bound ~√(N/T) for Dirichlet polynomials Σ_{n≤N} a_n e(nt_r) over T points.
- S(T) is the argument term of the zero-counting formula; "the only unconditional bound" quoted is S(T) = O(log T).
- "[RECALL]" marks the recalled claim by the other agent ("A").

## Proof / evidence

The source refutes the recalled claim by direction: the large sieve is an upper bound
(see the linked file), so no lower bound of that shape follows from it; genuine lower bounds for
Dirichlet polynomials come from second-moment/resonance arguments with different exponents. The
underlying conclusion is said to survive by a different route: bounding a partial sum requires the
zero locations via S(T), and no modulus depending on N alone can control it.

## Dependencies and related results

- [round7-agentb-large-sieve-upper-bound](round7-agentb-large-sieve-upper-bound.md) — the correct direction of the inequality.

## Notes

- Status REFUTED records the source's verdict on the recalled lower-bound claim ("INVALID",
  "a misstatement of the inequality direction").
- The salvage sentence "certification requires zero information" is the source's reformulation and is
  quoted as such; the source explicitly does not claim a large-sieve lower bound.
