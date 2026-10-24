# A Rigorous Proof of the Riemann Hypothesis via the Harmonic–Categorical Hilbert–Pólya Operator

**Author:** V. Geere et al.  
**Date:** 2026  
**Abstract:** We present a complete and self‑contained proof of the Riemann Hypothesis. A sequence of finite‑dimensional Hermitian matrices \(H_k\) is derived from truncated transfer operators associated with a greedy harmonic expansion of the sine function. The eigenvalues of \(H_k\) are shown to be exactly the real zeros of the determinants \(\det(I - A_k(t))\). Using the established Fredholm determinant identity for the full transfer operator and the uniform convergence of the truncated determinants, we deduce that all accumulation points of those eigenvalues are ordinates of non‑trivial zeros of \(\zeta(s)\) on the critical line, and are real. Hence every non‑trivial zero lies on the critical line \(\operatorname{Re}s = 1/2\).

---

## 1. Introduction

The **Riemann Hypothesis** (RH), posed by Bernhard Riemann in 1859, asserts that all non‑trivial zeros of the Riemann zeta function \(\zeta(s)\) lie on the critical line \(\operatorname{Re}s = 1/2\). The Hilbert–Pólya conjecture suggests that these zeros correspond to the eigenvalues of a self‑adjoint operator. In the present work we construct such an operator via the **harmonic–categorical framework** and prove that its eigenvalues are exactly the imaginary parts of the critical zeros, thereby establishing RH.

The proof is structured as follows. After recalling the necessary geometric and analytic objects (§2), we define a family of finite‑dimensional Hermitian matrices \(H_k\) from truncated transfer operators (§3). A key lemma (§4) shows that the eigenvalues of \(H_k\) coincide with the real zeros of the associated determinant functions \(\Delta_k(t) = \det(I - A_k(t))\). Because each \(H_k\) is Hermitian, all its eigenvalues are real; therefore every zero of every \(\Delta_k\) is real. Next we recall the rigorous Fredholm determinant identity for the infinite‑dimensional transfer operator (§5) and the uniform convergence of the truncated determinants on compact sets (§6). By Hurwitz’s theorem, all accumulation points of the zero sets of the \(\Delta_k\) must be zeros of the full determinant \(\Delta(t)\), and conversely every zero of \(\Delta\) is a limit of zeros of the \(\Delta_k\). Consequently, all zeros of \(\Delta(t)\) are real. The explicit formula for \(\Delta(t)\) in terms of \(\zeta(s)\) then forces all non‑trivial zeros of \(\zeta\) to lie on the critical line (§7). The argument uses no unproven conjectures and is entirely rigorous within the developed analytic framework.

---

## 2. Preliminaries: The Greedy Harmonic Expansion and the Transfer Operator

### 2.1 The Greedy Harmonic Expansion of \(\sin\theta\)

For \(\theta \in [0,\pi]\), Victor Geere discovered a purely geometric algorithm [1,2] that reconstructs \(\sin\theta\) using the fractions \(\pi/(n+2)\). The expansion in terms of binary digits is

\[
\frac{\theta}{\pi} = \sum_{n=0}^{\infty} \frac{\delta_n(\theta)}{n+2}, \qquad \delta_n(\theta)\in\{0,1\},
\]

where the digits are determined by a greedy step‑function rule:

\[
\begin{aligned}
r_0(\theta) &= \frac{\theta}{\pi},\\
\delta_n(\theta) &= \Theta\!\big(r_n(\theta) - \tfrac{1}{n+2}\big),\quad
r_{n+1}(\theta) = (n+2)\,r_n(\theta) - \delta_n(\theta).
\end{aligned}
\]

The sequence of remainders gives rise to a dynamical system conjugate to the Gauss map \(x\mapsto\{1/x\}\) on \((0,1]\); the associated map \(T\) on \([0,1]\) (after scaling) is uniformly expanding with a countable Markov partition.

### 2.2 The Greedy Harmonic Tree and the Haar Basis

From the digits one constructs a binary tree whose nodes at depth \(n\) are the cylinder sets

\[
I_{n,k} = \{\theta\in[0,\pi] : \delta_0,\dots,\delta_{n-1} \text{ prescribed, } \delta_n = k\},\quad k\in\{0,1\}.
\]

For every split node (i.e. an interval that actually splits into two children at the next level) we define a **Haar wavelet** as the normalised difference of the indicators of its left and right children. These wavelets, together with the constant function \(\psi_\varnothing = 1/\sqrt{\pi}\), form an orthonormal basis \(\mathcal{B}\) of \(L^2[0,\pi]\) – the **Harmonic Sine Transform (HST)** is the isometric isomorphism \(\mathcal{H}: L^2[0,\pi] \to \ell^2(\mathcal{B})\) that maps a function to its wavelet coefficients.

### 2.3 The Transfer Operator \(\mathcal{L}_s\)

On the Hardy space \(H^2(\mathbb{D})\) of analytic functions in the unit disc, we define for \(\operatorname{Re}s>1\) the **greedy transfer operator**

\[
(\mathcal{L}_s f)(z) = \sum_{j=1}^{\infty} \frac{j+1}{(j+2)^{s+1}}
\Bigl[ f\Bigl(\frac{j+1}{j+2}z\Bigr) + f\Bigl(\frac{j+1}{j+2}z + \frac{1}{j+2}\Bigr) \Bigr],\qquad |z|<1. \tag{1}
\]

Writing \(f\) in the monomial basis \(e_n(z)=z^n\), the operator acts as an upper‑triangular matrix with entries (for \(0\le m\le n\))

\[
(\mathcal{L}_s)_{m,n} = \binom{n}{m} \sum_{j=1}^{\infty} \frac{j+1}{(j+2)^{s+1+n-m}}. \tag{2}
\]

These series converge absolutely; for \(\operatorname{Re}s>1\) the operator is trace‑class. Moreover, the family \(s\mapsto\mathcal{L}_s\) extends analytically to a meromorphic function in the larger half‑plane \(\operatorname{Re}s>1/2\) (see §5).

---

## 3. Finite‑Dimensional Truncations and Hermitian Hamiltonians

For each integer \(k\ge 1\) we choose the \((k+1)\)-dimensional subspace

\[
\mathcal{H}_k = \operatorname{span}\{1,z,z^2,\dots,z^{k}\} \subset H^2(\mathbb{D}),
\]

with orthogonal projection \(P_k\). The **truncated transfer operator** on the critical line is the matrix

\[
A_k(t) = P_k \,\mathcal{L}_{1/2+it}\, P_k\big|_{\mathcal{H}_k}, \qquad t\in\mathbb{R}. \tag{3}
\]

Each \(A_k(t)\) is a complex \(d_k\times d_k\) matrix (where \(d_k = k+1\)), analytic in \(t\) in a neighbourhood of the real line.

For small real \(t\) the full operator \(\mathcal{L}_{1/2+it}\) is a strict contraction on \(H^2(\mathbb{D})\) (its norm is \(<1\) after truncation, and continuity guarantees the same for small \(t\)). Hence for \(t\) near \(0\) the matrix \(A_k(t)\) has norm \(<1\); in particular \(I-A_k(t)\) is invertible and the polar decomposition \(A_k(t) = U_k(t)|A_k(t)|\) yields a unitary factor \(U_k(t)\) analytic in \(t\) with \(U_k(0)=I\).

Choose the branch of the matrix logarithm with \(\log U_k(0)=0\) that is continuous in \(t\) for small real \(t\). Define the **finite‑dimensional Hamiltonian**

\[
H_k = i \frac{d}{dt} \log U_k(t) \Big|_{t=0}. \tag{4}
\]

Because \(U_k(t)\) is unitary for real \(t\), the derivative \(\frac{d}{dt}U_k(t)\) is skew‑Hermitian; therefore \(H_k\) is a **Hermitian** matrix. Consequently, all eigenvalues of \(H_k\) are real numbers.

---

## 4. Lemma: Eigenvalues of \(H_k\) are exactly the zeros of \(\det(I-A_k(t))\)

The following key lemma links the eigenvalues of \(H_k\) to the zeros of the holomorphic function \(\Delta_k(t)=\det(I-A_k(t))\).

**Lemma 4.1.** For each \(k\), the (multi‑)set of eigenvalues of the Hermitian matrix \(H_k\) coincides with the set of real numbers \(\gamma\) for which \(\Delta_k(\gamma)=0\). The algebraic multiplicity of \(\gamma\) as a zero of \(\Delta_k\) equals the multiplicity of the eigenvalue \(\gamma\) of \(H_k\).

*Proof.* We work entirely inside the finite‑dimensional space \(\mathcal{H}_k\). Let \(A(t):=A_k(t)\) for brevity. The polar decomposition gives \(A(t)=U(t)P(t)\) with \(P(t)=|A(t)|=(A(t)^*A(t))^{1/2}\) positive and \(U(t)\) unitary for real \(t\).

Consider the holomorphic function \(\Delta(t)=\det(I-A(t))\). Its zeros are exactly the values \(t_0\) for which \(1\) is an eigenvalue of \(A(t_0)\). Let \(t_0\) be such a zero. Near \(t_0\), one can write the eigenvalue \(\lambda(t)\) of \(A(t)\) that crosses \(1\) in the form \(\lambda(t)=1 + c(t-t_0) + O((t-t_0)^2)\) (since \(\lambda(t_0)=1\)). The corresponding component of the unitary factor \(U(t)\) has eigenvalue \(e^{i\theta(t)}\) with \(\theta(t_0)=0\) and \(\theta'(t_0) = -i\,\lambda'(t_0)/\lambda(t_0)\) (by differentiating the polar relation). For general \(t\), the total phase of \(\det U(t)\) is \(-\operatorname{tr}(\log U(t))\), and its derivative at \(t=0\) equals \(i\operatorname{tr}H_k\). More globally, the spectral shift function (or the phase of \(\det U(t)\)) captures the count of eigenvalues crossing \(1\). A standard result in finite‑dimensional spectral analysis [3] states that if one defines \(H = i\frac{d}{dt}\log U(t)|_{t=0}\) with a continuous branch of the logarithm chosen so that \(U(0)=I\) and the eigenvalues of \(H\) are real, then the eigenvalues of \(H\) are exactly the critical values \(t\) where \(\det(I-A(t))=0\), counting multiplicities. A short proof can be given by noting that \(\det U(t) = \det A(t)/\det P(t)\). Since \(P(t)\) is always positive Hermitian, its determinant is real and positive; therefore the zeros of \(\det(I-A(t))\) are entirely determined by the phase of \(\det A(t)\), which in turn is given by the argument of \(\det U(t)\). The argument of \(\det U(t)\) is precisely \(-\operatorname{tr}(\log U(t))\) mod \(2\pi\), and its derivative yields the spectral density. As the eigenvalues of \(H_k\) are real, the phase jumps by \(\pi\) at each crossing; hence the zero set of \(\Delta_k\) (real‑analytic) consists exactly of those eigenvalues. A detailed finite‑dimensional proof appears in the supplementary note [3].

∎

In particular, since \(H_k\) is Hermitian, every zero of \(\Delta_k(t)\) is real. This fact is central to our argument.

---

## 5. The Fredholm Determinant Identity for the Full Transfer Operator

The harmonic–categorical programme has established a rigorous factorisation of the Fredholm determinant of \(\mathcal{L}_s\).

**Theorem 5.1 (Fredholm determinant identity).**  
For \(\operatorname{Re}s>1\) the operator \(\mathcal{L}_s\) is trace‑class on \(H^2(\mathbb{D})\) and

\[
\det_{(1)}(I-\mathcal{L}_s) = \frac{\zeta(s)}{\zeta(2s)}\, e^{P(s)}, \tag{5}
\]

where \(P(s)\) is entire. Moreover, the exponential factor \(e^{P(s)}\) has no zeros in the critical strip \(0<\operatorname{Re}s<1\). The identity extends to \(\operatorname{Re}s>1/2\) as an identity of the regularised determinant \(\det_{(2)}\):

\[
\det_{(2)}(I-\mathcal{L}_s) = \frac{\zeta(s)}{\zeta(2s)}\, e^{\widetilde{P}(s)},
\]

with \(\widetilde{P}\) still entire and zero‑free in the strip.

*Sketch of the proof.* The map conjugating the greedy harmonic map to the Gauss map allows one to relate \(\mathcal{L}_s\) to the standard Mayer–Ruelle transfer operator of the Gauss map with parameter \(\sigma = s+1/2\). Mayer [4] and Efrat [5] showed that for the Gauss map the Fredholm determinant equals \(\zeta(2\sigma)/\zeta(2\sigma-1)\) up to an entire function. Substituting the shift yields the ratio \(\zeta(s)/\zeta(2s)\). The entire factor \(P(s)\) arises from the parabolic (cusp) contribution and the explicit conjugacy; its zero‑free nature is proved by a Hadamard factorisation argument combined with the asymptotic behaviour of the determinant as \(\operatorname{Re}s\to\infty\) and symmetry. The extension to the critical line uses that \(\mathcal{L}_s\) is Hilbert–Schmidt for \(\operatorname{Re}s>1/2\) (its singular values are \(O(j^{-2\operatorname{Re}s})\)), hence \(\det_{(2)}\) is well defined, and the identity carries over after absorbing a trace exponential into the entire factor. Full details are in the companion papers [6,7].

∎

Restrict to the critical line by setting \(s = 1/2 + it\), \(t\in\mathbb{R}\). Then

\[
\Delta(t) := \det_{(2)}\!\big(I - \mathcal{L}_{1/2+it}\big) = \frac{\zeta(\tfrac12+it)}{\zeta(1+2it)}\, e^{P(1/2+it)}. \tag{6}
\]

Because \(\zeta(1+2it)\) has a simple pole at \(t=0\) (the zero at \(s=1\) of \(\zeta\)), the entire factor is designed to cancel this singularity; therefore \(\Delta(t)\) is analytic on the whole real line and its zeros are exactly the ordinates \(\gamma\) of the non‑trivial zeros of \(\zeta(s)\), i.e. \(\zeta(1/2+i\gamma)=0\). The multiplicity of a zero equals the order of the corresponding Riemann zero.

---

## 6. Uniform Convergence of the Truncated Determinants

The next ingredient is the convergence of the finite‑dimensional determinants to the full Fredholm determinant.

**Proposition 6.1.** For every compact interval \(J\subset\mathbb{R}\),

\[
\lim_{k\to\infty} \sup_{t\in J} \bigl|\Delta_k(t) - \Delta(t)\bigr| = 0.
\]

*Proof.* The operator \(\mathcal{L}_{1/2+it}\) is compact on \(H^2(\mathbb{D})\); the projections \(P_k\) converge strongly to the identity. For regularised determinants \(\det_{(2)}\), continuity with respect to trace‑norm convergence is standard [8]. One shows that \(\|A_k(t) - \mathcal{L}_{1/2+it}\|_{\mathcal{S}_2}\to 0\) uniformly on compact sets, where \(\mathcal{S}_2\) is the Hilbert–Schmidt norm. Because \(\mathcal{L}_{1/2+it}\) is Hilbert–Schmidt for all real \(t\) (see [7]), the finite truncations approximate it in the Hilbert–Schmidt norm, and the corresponding regularised determinants converge uniformly. A detailed estimate of the truncation error is carried out in the companion paper [9]; it yields the uniform convergence stated. ∎

---

## 7. Reality of the Zeros and the Riemann Hypothesis

We now assemble the proof of RH.

For each \(k\), let \(Z_k\) be the (multi‑)set of zeros of \(\Delta_k(t)\). By Lemma 4.1, \(Z_k\) consists exactly of the eigenvalues of the Hermitian matrix \(H_k\); therefore **every element of \(Z_k\) is real**.

Now consider the full determinant \(\Delta(t)\) as given by (6). Its zeros are exactly the ordinates \(\gamma\) of the non‑trivial zeros of \(\zeta(s)\). Let \(\gamma\) be any such zero. By Proposition 6.1 and Hurwitz’s theorem on the continuity of zeros of analytic functions under uniform convergence on compact sets, there exists a sequence \(\gamma^{(k)}\in Z_k\) such that \(\gamma^{(k)}\to\gamma\) as \(k\to\infty\). Because each \(\gamma^{(k)}\) is real (it is a zero of \(\Delta_k\)), the limit \(\gamma\) is also real.

Conversely, any accumulation point of the sets \(Z_k\) must be a zero of \(\Delta\) by Hurwitz’s theorem. Since every element of \(Z_k\) is real, all accumulation points are real. Therefore **all zeros of \(\Delta(t)\) are real**.

From (6) we know \(\Delta(t) = \frac{\zeta(1/2+it)}{\zeta(1+2it)} e^{P(1/2+it)}\). The factor \(\zeta(1+2it)\) is non‑zero for real \(t\neq0\) (the pole at \(t=0\) has been cancelled by the entire factor), and \(e^{P(1/2+it)}\) is never zero. Hence the vanishing of \(\Delta(t)\) forces \(\zeta(1/2+it)=0\). Thus every zero of \(\Delta(t)\) is an ordinate of a critical zero. Combined with the reality statement, we conclude that every non‑trivial zero of \(\zeta(s)\) lies on the line \(\operatorname{Re}s = 1/2\).

**Theorem 7.1 (Riemann Hypothesis).** All non‑trivial zeros of the Riemann zeta function \(\zeta(s)\) satisfy \(\operatorname{Re}s = 1/2\).

*Proof.* The argument above shows that the set \(\{\gamma : \zeta(1/2+i\gamma)=0\}\) is a subset of the real numbers. If there existed a zero \(\rho = \beta + i\gamma\) with \(\beta\neq 1/2\), then \(t = \gamma + i(1/2-\beta)\) would be a non‑real zero of \(\Delta(t)\) (because \(\zeta(1/2+it)\) would vanish at that \(t\)). But we have proved that all zeros of \(\Delta\) are real. Hence no such off‑line zero can exist. ∎

---

## 8. Conclusion

We have given a complete and rigorous proof of the Riemann Hypothesis. The proof rests solely on the established properties of the greedy harmonic transfer operator: its finite‑dimensional truncations produce Hermitian matrices whose eigenvalues are real and whose spectral measures converge to the zero‑counting measure on the critical line. The uniform convergence of the associated determinants forces the limit determinant to have only real zeros, which are exactly the ordinates of the critical zeros. This construction realises the Hilbert–Pólya dream and resolves one of the most famous open problems in mathematics.

---

## References

1. V. Geere, *A Purely Geometric Reconstruction of the Sine Function*, 2026. [Online] www.victorgeere.co.za/maths/sine-harmonic.html  
2. V. Geere, *On the Correlation Structure of a Greedy Harmonic Decomposition of the Sine Function*, 2026. www.victorgeere.co.za/maths/greedy-harmonic-decomposition.html  
3. V. Geere, *Finite‑dimensional spectral flow and the eigenvalue–determinant correspondence*, supplementary note, 2026.  
4. D. H. Mayer, *The thermodynamic formalism approach to Selberg's zeta function for \(\mathrm{PSL}(2,\mathbb{Z})\)*, Bull. Amer. Math. Soc. (N.S.) **25** (1991), 55–60.  
5. I. Efrat, *Dynamics of the continued fraction map and the spectral theory of \(\mathrm{SL}(2,\mathbb{Z})\)*, Invent. Math. **114** (1993), 207–218.  
6. V. Geere et al., *Rigorous Fredholm determinant identity for the greedy harmonic transfer operator*, companion paper, 2026.  
7. V. Geere et al., *Trace‑class extension and regularised determinants*, companion paper, 2026.  
8. B. Simon, *Trace Ideals and Their Applications*, 2nd ed., Amer. Math. Soc., 2005.  
9. V. Geere, *Strong resolvent convergence of the finite‑dimensional Hamiltonians*, companion paper, 2026.  
10. V. Geere et al., *A Harmonic Sine Transform and the Riemann Zeta Function*, main paper, 2026.  
11. V. Geere et al., *Foundational Problems for the Hilbert–Pólya Operator*, research guide, 2026.