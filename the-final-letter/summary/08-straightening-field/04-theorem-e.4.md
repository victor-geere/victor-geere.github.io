# Theorem E.4 (Holonomy of the straightening field is the zero count)

| Field | Value |
|---|---|
| Type | Theorem |
| Status | Proved |
| Source | [publication.html Addendum E](../../geometric-dynamical-phase-transitions/publication.html#adde) · Addendum E. The straightening field: rays, holonomy, and finite-data zero detection |
| Proof in source | yes |

## Statement

Let \(\Gamma\subset D\) be a rectifiable closed curve avoiding the singular set of \(\mathsf{R}_f\), null-homotopic in \(D\). Define the *holonomy* \[
\operatorname{hol}(f,\Gamma)=\frac{1}{2\pi}\,\Delta_\Gamma\arg\mathsf{r}_f
=\frac{1}{2\pi i}\oint_\Gamma\Bigl(\frac{f'}{f}-\frac1s\Bigr)\,ds ,
\] the total turning of the straightening angle, in units of a full revolution. Then \[
\operatorname{hol}(f,\Gamma)=Z_f(\Gamma)-P_f(\Gamma)-n(\Gamma,0),
\] where \(Z_f,P_f\) count zeros and poles of \(f\) inside \(\Gamma\) with multiplicity and \(n(\Gamma,0)\) is the winding number of \(\Gamma\) about the origin. In particular the holonomy is an integer, and it vanishes for every \(\Gamma\) in a simply connected region if and only if the straightening field admits a global continuous ray family there.

## Proof

The argument principle applied to \(f\) and to \(\mathrm{id}\) separately, using Lemma E.3; \(\mathrm{id}\) contributes its single zero at the origin, counted by \(n(\Gamma,0)\). The final sentence is Lemma E.3 together with the monodromy theorem.
