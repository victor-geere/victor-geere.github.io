# Corollary 12.3 (Conversion of the Riemann hypothesis)

| Field | Value |
|---|---|
| Type | Corollary |
| Status | Proved equivalence; does not prove RH |
| Source | [publication.html §12](../../geometric-dynamical-phase-transitions/publication.html#sec12) · 12. Realisation of the limiting measure |
| Proof in source | yes |

> **Editorial note.** The paper is explicit that this is a conversion of RH into an equality of supports, not a proof of RH. The inequality of supports is the open statement.

## Statement

The following are equivalent.

1.  Every non-trivial zero of \(\Xi\) lies on the critical line (the Riemann hypothesis).
2.  Every unrestricted path-closure is balanced, for all sufficiently large \(N\): \(\mathcal{U}_N=\mathcal{C}_N\).
3.  Every weak-star limit of \(\{\nu_N\}\) is supported on the critical line.
4.  The balanced and unrestricted limiting measures coincide, and their common support is exactly the set of non-trivial zeros of \(\Xi\).

## Proof

Theorem 12.1 places every critical-line zero in \(\operatorname{supp}\mu\subset\operatorname{supp}\nu\). Theorem 12.2, via the Marty bound of Lemma 4.8, excludes the left half-strip from \(\operatorname{supp}\nu\) and keeps the right half-strip: a simple zero with \(\sigma\ge\tfrac12+\varepsilon/2\) is unrestricted and not balanced, which separates \(\nu\) from \(\mu\). Pairing \(\Xi(s)=\Xi(1-s)\) converts a left-half zero into a right-half zero already visible to \(\nu_N\). Conversely, if every zero lies on the line, then fibre-closures off the line can accumulate only at zeros, of which there are none, so Theorem 10.1 puts \(\operatorname{supp}\nu\) on the critical line and \(\mathcal{U}_N=\mathcal{C}_N\) in the limit. The vanishing-aperture jet of Theorem 12.6 removes multiple left-half atoms from \(\mu\); the same Marty comparison at the minimiser removes them from \(\nu\) once \(K_N\ge m\).
