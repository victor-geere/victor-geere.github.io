# Definition E.1 (Straightening ratio and straightening matrix)

| Field | Value |
|---|---|
| Type | Definition |
| Status | Definition |
| Source | [publication.html Addendum E](publication.html#adde) · Addendum E. The straightening field: rays, holonomy, and finite-data zero detection |
| Proof in source | no separate proof block |

## Statement

Let \(f\) be meromorphic on a domain \(D\subseteq\mathbb{C}\) and let \(s\in D\setminus\{0\}\) with \(f(s)\notin\{0,\infty\}\). The *straightening ratio* is \[
\mathsf{r}_f(s)=\frac{f(s)}{s}\in\mathbb{C}^\times ,
\] and the *straightening matrix* \(\mathsf{R}_f(s)\in GL_2(\mathbb{R})\) is the real matrix of multiplication by \(\mathsf{r}_f(s)\) in the basis \(\{1,i\}\): \[
\mathsf{R}_f(s)=\begin{pmatrix}a&-b\\ b&a\end{pmatrix},
\qquad a=\operatorname{Re}\mathsf{r}_f(s),\quad b=\operatorname{Im}\mathsf{r}_f(s).
\] Writing \(s=\lvert s\rvert e^{i\theta}\) and \(f(s)=\lvert f(s)\rvert e^{i\varphi}\), \[
\mathsf{R}_f(s)=\varrho\,\mathrm{Rot}(\varphi-\theta),\qquad
\varrho=\frac{\lvert f(s)\rvert}{\lvert s\rvert},\qquad
\mathrm{Rot}(\psi)=\begin{pmatrix}\cos\psi&-\sin\psi\\ \sin\psi&\cos\psi\end{pmatrix}.
\] By construction \(\mathsf{R}_f(s)\,s=f(s)\) and \(\mathsf{R}_f(s)^{-1}f(s)=s\). The scalar \(\varrho\) is the *gain* and \(\psi_f(s)=\varphi-\theta\) the *straightening angle*.

## Proof

_No separate proof is given in the source. The statement is either a definition, a remark, a cited result, or is argued inline in the surrounding section._
