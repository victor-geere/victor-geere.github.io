# Lemma E.2 (Domain, conformal group, and the twisted product)

| Field | Value |
|---|---|
| Type | Lemma |
| Status | Proved |
| Source | [publication.html Addendum E](publication.html#adde) · Addendum E. The straightening field: rays, holonomy, and finite-data zero detection |
| Proof in source | yes |

## Statement

\(i\) \(\mathsf{R}_f(s)\) is defined and invertible exactly on \(D\setminus\bigl(\{0\}\cup f^{-1}\{0\}\cup f^{-1}\{\infty\}\bigr)\). Its singular set is therefore the zero set of \(f\), together with the poles of \(f\) and the single point \(s=0\).

\(ii\) \(\mathsf{R}_f(s)\) lies in the conformal group \(CO_2^{+}(\mathbb{R})=\mathbb{R}_{>0}\times SO(2)\); every straightening matrix is angle-preserving and orientation-preserving, and the decomposition into gain and straightening angle in Definition E.1 is the isomorphism.

\(iii\) The assignment \(f\mapsto \mathsf{R}_f\) is multiplicative for the *twisted product* \[
\mathsf{A}\star\mathsf{B}=s\,\mathsf{A}\mathsf{B},
\qquad\text{that is}\qquad
\mathsf{R}_{fg}(s)=\mathsf{R}_f(s)\star\mathsf{R}_g(s),
\] whose two-sided unit is the identity matrix, attained by the identity function \(\mathrm{id}(s)=s\): \(\mathsf{R}_{\mathrm{id}}\equiv I\). Moreover \(\mathsf{R}_{cf}=c\,\mathsf{R}_f\) for constants \(c\), and \(\mathsf{R}_{1/f}=(s^2\mathsf{R}_f)^{-1}\).

## Proof

\(i\) and (ii) are the standard description of \(\mathbb{C}^\times\) inside \(GL_2(\mathbb{R})\); a nonzero complex number is a positive scalar times a rotation, and the map is an isomorphism of \(\mathbb{C}^\times\) onto \(CO^{+}_2(\mathbb{R})\). For (iii), \(\mathsf{r}_{fg}=fg/s=s\,(f/s)(g/s)=s\,\mathsf{r}_f\mathsf{r}_g\), and \(\mathsf{r}_{\mathrm{id}}=s/s=1\); associativity of \(\star\) is associativity of multiplication in \(\mathbb{C}\). That \(I\) is the unit follows by taking \(g=\mathrm{id}\): the product \(f\cdot\mathrm{id}\) has straightening ratio \(f\cdot s/s=f=s\,\mathsf{r}_f\cdot 1\), which is \(\mathsf{r}_f\star 1\). The last two identities are immediate from the definition.
