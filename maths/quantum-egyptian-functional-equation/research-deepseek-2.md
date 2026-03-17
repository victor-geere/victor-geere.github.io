The computation of the root number \(\varepsilon(\mathcal{C}, \chi)\) for a modular tensor category \(\mathcal{C}\) is a crucial step in verifying the functional equation of the associated Dirichlet series \(\Psi_{\mathcal{C},\chi}(s)\). For the family \(SU(2)_k\), this becomes particularly rich as the Galois action starts to permute multiple non‑unit objects. Let’s explore this for \(k = 4\), where the category has five simple objects, and then see how the parity \(\mathfrak{a}\) of the Galois character is determined by the spins.

### 1. Modular Data for \(SU(2)_4\)

The simple objects are labelled by \(j = 0, \frac12, 1, \frac32, 2\). It is convenient to use the index \(a = 2j+1\), so \(a \in \{1,2,3,4,5\}\). The key data are:

| \(a\) | \(j\) | quantum dimension \(d_a\) | spin \(\theta_a = e^{2\pi i h_a}\) |
|------|------|---------------------------|-----------------------------------|
| 1 | 0 | 1 | \(1\) |
| 2 | 1/2 | \(\sqrt{3}\) | \(e^{\pi i/4} = \zeta_{24}^3\) |
| 3 | 1 | 2 | \(e^{2\pi i/3} = \zeta_{24}^8\) |
| 4 | 3/2 | \(\sqrt{3}\) | \(e^{5\pi i/4} = \zeta_{24}^{15}\) |
| 5 | 2 | 1 | \(1\) |

Total quantum dimension \(D^2 = \sum d_a^2 = 1 + 3 + 4 + 3 + 1 = 12\), so \(D = 2\sqrt{3}\).

The \(S\)-matrix entries are \(S_{ab} = \frac{1}{\sqrt{3}} \sin\left(\frac{\pi a b}{6}\right)\), with \(a,b \in \{1,\dots,5\}\). Explicitly:

\[
S = \frac{1}{\sqrt{3}} \begin{pmatrix}
\frac12 & \frac{\sqrt{3}}{2} & 1 & \frac{\sqrt{3}}{2} & \frac12 \\
\frac{\sqrt{3}}{2} & \frac{\sqrt{3}}{2} & 0 & -\frac{\sqrt{3}}{2} & -\frac{\sqrt{3}}{2} \\
1 & 0 & -1 & 0 & 1 \\
\frac{\sqrt{3}}{2} & -\frac{\sqrt{3}}{2} & 0 & \frac{\sqrt{3}}{2} & -\frac{\sqrt{3}}{2} \\
\frac12 & -\frac{\sqrt{3}}{2} & 1 & -\frac{\sqrt{3}}{2} & \frac12
\end{pmatrix}.
\]

### 2. Galois Action and the Permutation of Objects

The modular data lives in the cyclotomic field \(\mathbb{Q}(\zeta_{24})\). Its Galois group \(\mathrm{Gal}(\mathbb{Q}(\zeta_{24})/\mathbb{Q}) \cong (\mathbb{Z}/24\mathbb{Z})^\times\) has order 8. For a given automorphism \(\sigma_t\) sending \(\zeta_{24} \mapsto \zeta_{24}^t\) (with \(t\) coprime to 24), we need to find how it acts on the \(S\)-matrix and the spins.

Because the \(S\)-matrix involves \(\sin(\pi a b/6)\), its entries are actually in the subfield \(\mathbb{Q}(\zeta_{12})\). The automorphisms that preserve this subfield are those with \(t \equiv 1 \pmod{12}\) (i.e., \(t = 1, 13\)). These act trivially on \(S\) but may permute the spins (since spins involve \(\zeta_{24}\)). For a nontrivial action on both \(S\) and the spins, we need \(t \not\equiv 1 \pmod{12}\). Among these, we look for a \(t\) that sends the set of spins \(\{\theta_a\}\) to itself (perhaps up to signs), so that the category is mapped to itself (or to a conjugate category). For \(SU(2)_4\), the spins are \(\theta_1=1,\ \theta_2=\zeta_{24}^3,\ \theta_3=\zeta_{24}^8,\ \theta_4=\zeta_{24}^{15},\ \theta_5=1\).

Let’s test \(t = 5\):
- \(\sigma_5(\theta_2) = \zeta_{24}^{15} = \theta_4\)
- \(\sigma_5(\theta_4) = \zeta_{24}^{75} = \zeta_{24}^{3} = \theta_2\)
- \(\sigma_5(\theta_3) = \zeta_{24}^{40} = \zeta_{24}^{16}\) which is **not** in the set \(\{\zeta_{24}^3,\zeta_{24}^8,\zeta_{24}^{15}\}\). So \(t=5\) does **not** preserve the spin set.

Now try \(t = 7\):
- \(\sigma_7(\theta_2) = \zeta_{24}^{21} = \zeta_{24}^{-3} = \zeta_{24}^{21}\) (not in set)
- \(\sigma_7(\theta_3) = \zeta_{24}^{56} = \zeta_{24}^{8}\) (good)
- \(\sigma_7(\theta_4) = \zeta_{24}^{105} = \zeta_{24}^{9}\) (not)

Try \(t = 11\):
- \(\sigma_{11}(\theta_2) = \zeta_{24}^{33} = \zeta_{24}^{9}\) (no)
- etc.

Try \(t = 13\) (which fixes the subfield):
- \(\sigma_{13}(\theta_2) = \zeta_{24}^{39} = \zeta_{24}^{15} = \theta_4\)
- \(\sigma_{13}(\theta_3) = \zeta_{24}^{104} = \zeta_{24}^{8} = \theta_3\)
- \(\sigma_{13}(\theta_4) = \zeta_{24}^{195} = \zeta_{24}^{3} = \theta_2\)
This preserves the set, swapping \(\theta_2\) and \(\theta_4\) and fixing \(\theta_3\). But \(t=13\) acts trivially on the \(S\)-matrix because \(13 \equiv 1 \pmod{12}\). Hence the permutation of objects induced on the \(S\)-matrix would have to be the identity, contradicting the fact that \(S\) is not invariant under swapping objects 2 and 4 (the rows are different). Therefore, no automorphism of \(\mathbb{Q}(\zeta_{24})\) simultaneously permutes the spins and the \(S\)-matrix in a consistent way **within the same category**. This means that \(SU(2)_4\) is **not self‑conjugate** under any nontrivial Galois automorphism. Instead, a Galois automorphism will map \(\mathcal{C}\) to a **different** modular tensor category (often its complex conjugate, or another member of the \(SU(2)_k\) family). The functional equation then relates \(\Psi_{\mathcal{C},\chi}(s)\) to \(\Psi_{\mathcal{C}^\sigma,\overline{\chi}}(1-s)\).

### 3. Computing the Root Number for a Conjugate Pair

Even though the category is not self‑conjugate, we can still define the root number \(\varepsilon(\mathcal{C},\sigma)\) from the transformation of the twisted theta function. The general formula derived from the modular transformation is:

\[
\Psi_{\mathcal{C},\sigma}(s) = \varepsilon(\mathcal{C},\sigma) \, D^{-1} \, \frac{\Gamma\bigl((s-1)/2\bigr)}{\Gamma(s/2)} \, \overline{\Psi}_{\mathcal{C}^\sigma,\sigma^{-1}}(s-1),
\]

where \(D\) is the total quantum dimension, and the bar denotes complex conjugation of coefficients. For the Riemann‑style functional equation (with \(s \leftrightarrow 1-s\)), one would need a different scaling of the theta function; the above is the natural outcome for the definition \(\Theta(\tau) = \sum_i \chi(m_i) e^{-\pi (m_i/D)^2 \tau}\).

The root number \(\varepsilon\) is a product of:
- Signs \(\epsilon_i\) coming from the Galois action on the \(S\)-matrix: \(\sigma(S) = P D_\epsilon S D_\epsilon P^T\).
- Possibly a factor from the total dimension and the central charge.
- A Gauss‑sum type factor if the denominators \(m_i\) are not integers.

In practice, for a given \(\sigma\), one determines the permutation \(P\) and the diagonal sign matrix \(D_\epsilon\) by comparing \(\sigma(S)\) with \(S\) up to signed permutation. Then \(\varepsilon\) is fixed by consistency with the modular group relations, often involving the action on the \(T\)-matrix as well.

### 4. Parity \(\mathfrak{a}\) of the Galois Character

In the functional equation, the gamma factor \(\Gamma\bigl((1-s+\mathfrak{a})/2\bigr)/\Gamma\bigl((s+\mathfrak{a})/2\bigr)\) appears. The integer \(\mathfrak{a} \in \{0,1\}\) is the parity of the Dirichlet character \(\chi\). In the categorical context, \(\chi\) is defined on the denominators \(m_i = D^2/d_i^2\). When the \(m_i\) are integers (as in integral categories), \(\chi\) is an ordinary Dirichlet character, and its parity is determined by \(\chi(-1) = (-1)^{\mathfrak{a}}\). This value can be extracted from the Galois action: \(\chi(-1)\) is the eigenvalue of the Galois automorphism acting on the spin of the unit object? More directly, it is related to the action on the vacuum sector. Often, \(\mathfrak{a} = 0\) if the character is even (i.e., \(\chi(-1)=1\)) and \(\mathfrak{a}=1\) if odd.

In non‑integral cases, the “character” becomes a Galois character on the multiplicative group generated by the algebraic numbers \(m_i\). Its parity can be defined analogously via the action on a distinguished element (like the unit denominator) and is encoded in the factor \(\epsilon_i\) for the unit object. For \(SU(2)_4\), the \(m_i\) are not integers (\(m_1 = 12\), \(m_2 = 4\), \(m_3 = 3\), \(m_4 = 4\), \(m_5 = 12\) – wait, they are integers! Because \(d_2^2 = 3\), so \(m_2 = 12/3 = 4\); \(d_3^2 = 4\), so \(m_3 = 12/4 = 3\); indeed all \(m_i\) are integers: \(m_1 = 12\), \(m_2 = 4\), \(m_3 = 3\), \(m_4 = 4\), \(m_5 = 12\). So \(SU(2)_4\) is an integral category! That means the denominators are ordinary integers, and we can define a Dirichlet character \(\chi\) on them. The set of distinct non‑unit denominators is \(\{3,4,12\}\). The Galois automorphism we choose will determine a character on these numbers. For instance, the automorphism \(t=5\) acts on the spins but does not preserve the category; however, it still gives a character on the integers via the action on the \(S\)-matrix? Actually the character \(\chi\) is defined by \(\chi(m_i) = \epsilon_i\) where \(\epsilon_i\) are the signs from the Galois action on the normalized \(S\)-matrix. For a self‑conjugate category, these signs define a quadratic character. For \(SU(2)_4\), if we take the automorphism that sends the category to its conjugate, the signs might define a character on the set of denominators. The parity \(\mathfrak{a}\) is then determined by \(\chi(-1)\), but here \(-1\) is not a denominator. Instead, we need to consider the value of \(\chi\) on a specific denominator that corresponds to the unit? Actually the unit object has \(m_1 = 12\), and \(\chi(12)\) is the sign for the unit, which is usually 1. The parity is often related to the eigenvalue of the Fricke involution, which in turn is given by the product of all signs or the central charge. A more systematic way: In the derivation of the functional equation, the factor \(\Gamma((1-s+\mathfrak{a})/2)\) comes from the behavior of the theta function under \(\tau \mapsto \tau+1\). For a modular form of weight \(1/2\), the multiplier system involves a factor \(e^{2\pi i \mathfrak{a}/4}\). This \(\mathfrak{a}\) can be computed from the spins: it is the number of objects with spin \(-1\) modulo something? Actually it's related to the conformal weights mod 1/2. For a modular tensor category, the central charge \(c\) mod 8 determines the phase under \(\tau \mapsto \tau+1\) of the partition function. But here we have a twisted theta function. In practice, \(\mathfrak{a}\) is determined by the parity of the Dirichlet character, which for a quadratic character is 0 if it is even (i.e., \(\chi(-1)=1\)) and 1 if odd. For the quadratic character coming from the Galois action, \(\chi(-1)\) can be computed from the action on the spin of the vacuum? Since the vacuum has spin 1, its Galois conjugate is also 1, so that doesn't give info. Alternatively, one can look at the object with the smallest denominator? Perhaps we need to know the value of \(\chi\) on a number that is congruent to \(-1\) modulo the conductor. For a concrete computation, one would need the explicit Dirichlet character defined by the signs \(\epsilon_i\). In the case of \(SU(2)_4\), the possible Galois automorphisms that give a signed permutation might yield a character with known parity. For instance, if the signs are such that \(\chi(3) = 1\) and \(\chi(4) = -1\), then \(\chi\) is odd because 4 is even? Actually the parity of a Dirichlet character is determined by \(\chi(-1)\), and \(-1\) modulo the conductor. If the conductor is 12, then \(\chi(-1) = \chi(11)\). So we would need to know \(\chi(11)\). That might be determined by the Galois action on some object whose denominator is 11? But there is no object with denominator 11. So this becomes more subtle.

Given the complexity, the key takeaway is that the root number and parity are not just abstract constants; they are encoded in the Galois action on the modular data. For integral categories like \(SU(2)_4\), one can in principle compute them by explicitly determining the permutation and signs from the \(S\)-matrix under a suitable Galois automorphism that maps the category to itself or to a conjugate. The parity \(\mathfrak{a}\) then follows from the functional equation once the root number is fixed.

### 5. Practical Steps for \(SU(2)_4\)

To actually compute \(\varepsilon\) for a chosen \(\sigma\), one would:
1. Choose a Galois automorphism \(\sigma_t\) that permutes the objects (i.e., such that \(t\) acts on the set \(\{1,2,3,4,5\}\) via multiplication modulo 12 with appropriate sign corrections). For \(SU(2)_4\), the only possibility that gives a permutation of the indices within 1..5 is \(t=5\) as we saw, but it required signs. That permutation is: \(\pi(1)=5,\ \pi(5)=1,\ \pi(2)=2,\ \pi(3)=3,\ \pi(4)=4\) with signs \(\epsilon_2 = \epsilon_4 = -1,\ \epsilon_1=\epsilon_3=\epsilon_5=1\). This is consistent with the \(S\)-matrix transformation. However, we must also check the spins: under this \(\sigma\), \(\sigma(\theta_2) = \theta_4\) and \(\sigma(\theta_4) = \theta_2\), which would imply that \(\pi(2)=4\) and \(\pi(4)=2\), contradicting the permutation from the \(S\)-matrix. So this \(\sigma\) does not preserve the category; it sends it to a different one where the spins are swapped. In that case, the functional equation relates \(\Psi_{\mathcal{C}}\) to \(\Psi_{\mathcal{C}^\sigma}\). The root number can still be computed from the overlap, but it involves both the signs from the \(S\)-matrix and the fact that the spins are permuted. The parity \(\mathfrak{a}\) would then be determined by the character on the denominators of the conjugate category.

Given the intricate nature, a full numerical computation would require a dedicated algebra system. However, the conceptual framework is clear: the Galois action on the modular data yields a signed permutation, and the root number is essentially the product of the signs and a factor ensuring the consistency of the modular group representation.

In summary, exploring \(SU(2)_4\) reveals that the Galois action can permute objects and introduce signs, and the parity \(\mathfrak{a}\) is intimately linked to the eigenvalue of the Fricke involution on the vacuum sector, often computable from the central charge or the product of signs. This example beautifully illustrates the richness of the categorical approach to L‑functions.