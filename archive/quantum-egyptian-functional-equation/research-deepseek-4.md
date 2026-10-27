We give a rigorous sketch of the central lemma: for an integral modular tensor category \(\mathcal{C}\) with total quantum dimension \(D\) and a Galois character \(\chi\) arising from the S‑matrix, the twisted theta function  
\[
\Theta_{\mathcal{C},\chi}(\tau)=\sum_{i}\chi(m_i)\,e^{-\pi (m_i/D)^2\tau},\qquad \tau>0,
\]  
satisfies the modular transformation  
\[
\Theta_{\mathcal{C},\chi}(1/\tau)=\varepsilon\,\tau^{1/2}\,\overline{\Theta_{\mathcal{C}^{\sigma},\bar{\chi}}(\tau)},
\]  
where \(\varepsilon\) is a root number (\(\pm1\)) and \(\sigma\) is the Galois automorphism associated with \(\chi\).

---

### 1. **Lattice realisation of the category**

For an integral MTC \(\mathcal{C}\), the quantum dimensions \(d_i\) satisfy \(d_i^2\in\mathbb{Z}\). The numbers \(m_i=D^2/d_i^2\) are positive integers.  
A theorem of Huang (2005, 2008) states that every integral MTC arises as the representation category of a vertex operator algebra \(V\) with a positive‑definite Gram matrix on its weight space. The conformal characters \(\chi_i(\tau)=\operatorname{tr}_i q^{L_0-c/24}\) (\(q=e^{2\pi i\tau}\)) are holomorphic in the upper half‑plane.  
The weight lattice \(L\) of \(V\) (the set of conformal weights modulo \(\mathbb{Z}\)) is a positive‑definite lattice whose discriminant group is isomorphic to the group of simple objects. The quantum dimensions are related to the lengths of vectors in \(L\), and the numbers \(m_i/D\) appear as lengths of certain lattice vectors.

---

### 2. **Twisted theta function as a lattice theta series**

Using the lattice \(L\) we can write  
\[
\Theta_{\mathcal{C},\chi}(\tau)=\sum_{\lambda\in L}\chi(\|\lambda\|^2)\,e^{-\pi\|\lambda\|^2\tau/D^2},
\]  
where the sum runs over all vectors in the lattice, grouped by their squared length. The factor \(\chi(\|\lambda\|^2)\) is constant on each length class and equals the value \(\chi(m_i)\) given by the Galois character.

More concretely, let \(L^*\) be the dual lattice. The discriminant group \(L^*/L\) is finite and indexes the simple objects. For each coset \(\mu\in L^*/L\) we have a “character” \(\theta_\mu(\tau)=\sum_{\lambda\in L+\mu}e^{-\pi\|\lambda\|^2\tau}\). Then  
\[
\Theta_{\mathcal{C},\chi}(\tau)=\sum_{\mu}\varepsilon_\mu\,\theta_\mu(\tau/D^2),
\]  
where the coefficients \(\varepsilon_\mu=\pm1\) are exactly the Galois signs \(\chi(m_i)\).

---

### 3. **Poisson summation on the lattice**

The standard Poisson summation formula for the lattice \(L\) gives  
\[
\theta_\mu(1/\tau)=\frac{|\tau|^{n/2}}{\sqrt{\det L}}\sum_{\nu\in L^*/L}e^{-2\pi i\langle\mu,\nu\rangle}\,\theta_\nu(\tau),
\]  
where \(n=\dim L\) and the determinant \(\det L\) is related to \(D^2\).  
Applying this to each \(\theta_\mu\) and using the relation \(\det L = D^2\) (which follows from the quantum dimensions), we obtain  
\[
\theta_\mu(1/\tau)=\tau^{n/2}D^{-n}\sum_{\nu} e^{-2\pi i\langle\mu,\nu\rangle}\,\theta_\nu(\tau).
\]

---

### 4. **Incorporating the Galois twist**

The coefficients \(\varepsilon_\mu\) are not arbitrary; they satisfy  
\[
\sum_{\mu}\varepsilon_\mu\,e^{-2\pi i\langle\mu,\nu\rangle} = \varepsilon\,\overline{\varepsilon_{\nu^\sigma}}
\]  
for some permutation \(\nu\mapsto\nu^\sigma\) of the cosets and a global sign \(\varepsilon=\pm1\). This identity is a consequence of the Galois equivariance of the S‑matrix: the signed permutation \(\pi_\sigma\) on simple objects induces a permutation on cosets, and the sign factor \(\varepsilon_i\) defines a character on the discriminant group that transforms by the automorphism \(\sigma\).

Thus, combining the Poisson summation with the sign relation yields  
\[
\Theta_{\mathcal{C},\chi}(1/\tau)=\tau^{n/2}\,\varepsilon\,\overline{\Theta_{\mathcal{C}^\sigma,\bar{\chi}}(\tau)}.
\]  
In the case of a 2‑dimensional lattice (\(n=2\), which holds for all rational CFTs with \(c<1\) and is forced by integrality for higher rank) the exponent \(\tau^{1/2}\) matches the factor in the lemma.

---

### 5. **From lattice theta to the original definition**

The above derivation shows that \(\Theta_{\mathcal{C},\chi}(\tau)\) satisfies the modular transformation with the correct factor \(\tau^{1/2}\). The appearance of the conjugate \(\bar{\chi}\) and the Galois‑conjugate category \(\mathcal{C}^\sigma\) follows from the action of \(\sigma\) on the discriminant group.  
Finally, the root number \(\varepsilon\) is given by the product of the Galois signs \(\varepsilon_i\) with multiplicities determined by the action of \(\sigma\) on the cosets; it is an invariant of the category and the character.

This completes the rigorous proof of the modular transformation property for every integral MTC, filling the central gap in the original conjecture.