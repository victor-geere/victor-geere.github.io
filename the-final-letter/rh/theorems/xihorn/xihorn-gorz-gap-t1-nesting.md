# Theorem 1 (nesting)

**Kind:** Theorem
**Status:** PROVED (paper argument, contrapositive of L3(ii); elementary)
**Area:** xi-horn
**Source:** [`xi-horn/gorz-gap.md`](../../xi-horn/gorz-gap.md) — §3 "The three theorems", Theorem 1

## Statement

> **Theorem 1 (nesting).** For every d ≥ 1, `E(d) ⊆ E(d+1)`.

## Hypotheses and notation

- E(d) := { n ≥ 0 : J_{d,n} is NOT hyperbolic }, the exception set (§1.3).
- N(d) := 1 + max E(d) (:= 0 if E(d) = ∅), GORZ's threshold; E_∞ := ∪_{d≥1} E(d); D(n) := min{ d : n ∈ E(d) } (:= ∞ if none); D\* := min{ d : E(d) ≠ ∅ } = min_n D(n) (§1.3).
- J_{d,n} hyperbolic means all its zeros are real; J_{d,n}(X) = Σ_{j=0}^{d} C(d,j)·a(n+j)·X^j (equation (4)).

## Proof / evidence

The source's proof, verbatim: "Contrapositive of L3(ii): if n ∉ E(d+1), i.e. J_{d+1,n} is hyperbolic, then J_{d,n} is hyperbolic, i.e. n ∉ E(d). ∎"

Consequence stated by the source: "So the exception sets form an increasing chain, #E(d) and N(d) are non-decreasing in d, and — this is the whole point — **no exception ever disappears as the degree grows.** Raising d can only reveal."

## Dependencies and related results

- [Lemma L3 (propagation)](xihorn-gorz-gap-l3-propagation.md), clause (ii).
- Used in [Theorem 3](xihorn-gorz-gap-t3-uniformity-constant.md) ("at d = max_{n<ν} D(n) Theorem 1 gives E(d) ⊇ {D(n) ≤ d} = [0, ν)").
- The source notes the witnesses of §7 make the nesting visible: at b = 1, c = 3 in the toy family, E(1) = ∅, E(2) = {0}, E(3–9) = {0,1}, E(≥10) = {0,1,2}, "nesting at every step".

## Notes

- The source's §10 lists this among results that are "set inclusions": "The content is that neither local paper puts them together".
- The source's §7.5 boundary remark: Theorem 2 says the *union* E_∞ is an initial segment; Theorem 1 makes E(d) an increasing chain, and the individual E(d) need not be initial segments (see [the ξ-scan claim](xihorn-gorz-gap-xi-scan-217-polynomials.md) and the source's reference to `initial-segments.md`).
