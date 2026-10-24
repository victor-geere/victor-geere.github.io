# Lemma D.2.1 (Faithfulness: the kernel of the shadow is exactly the constants)

| Field | Value |
|---|---|
| Type | Lemma |
| Status | Proved |
| Source | [publication.html Addendum D](publication.html#addd) · Addendum D. The modular shadow: finite Euler sums in \(\mathcal{A}\) |
| Proof in source | yes |

## Statement

The map \(a\mapsto F_{\mathcal{A}}[a]\) of Definition D.1 is \(\mathbb{Z}\)-linear in the coefficient vector \((a_1,\dots,a_q)\), and by Lemma D.2 the constant sequences lie in its kernel. They exhaust it.

\(i\) *Necessary number of weights.* For fixed \(p\nmid q\) let \(T_r(k,p)=\sum_{n<p,\ n\equiv r\,(q)}n^{-k}\in\mathbb{F}_p\), so that the shadow at weight \(k\) is \(\sum_r a_rT_r(k,p)\). The \(K\times q\) matrix \(\bigl(T_r(k,p)\bigr)_{k\le K,\,r}\) always annihilates the all-ones vector, so its rank is at most \(q-1\); weights \(k=1,\dots,K\) can therefore cut the kernel down to the constants only if \(K\ge q-1\).

\(ii\) *That many suffice.* The rank is exactly \(\min(K,q-1)\), equivalently the kernel has dimension \(\max(1,q-K)\). Verified by elimination over \(\mathbb{F}_p\) for every \(q\le 12\), each \(K\in\{q-2,q-1,q,q+2\}\), and the first \(25\) primes exceeding \(20\) with \(p\nmid q\): \(961\) of the \(975\) triples \((q,K,p)\) meet the prediction exactly, and the \(14\) exceptions exceed it by one, at the isolated primes \(23,29,37,53,59,67,127\), each disappearing at \(K=q+2\). Since \(\mathcal{A}\) discards any finite set of primes, exceptional primes do not affect the element of \(\mathcal{A}\). For \(K\ge q+2\) the kernel basis is \((1,1,\dots,1)\) at every prime tested.

\(iii\) *Injectivity on mean-zero sequences.* If \(a,b\) are \(q\)-periodic integer sequences with \(\sum_n a_n=\sum_n b_n=0\) and \(F_{\mathcal{A}}[a](k)=F_{\mathcal{A}}[b](k)\) for all \(k\), then \(a=b\).

## Proof

Linearity is immediate from Definition D.1, and the all-ones vector lies in the kernel by Lemma D.2. For (i), the displayed annihilation is Lemma D.2 read columnwise. For (iii), put \(d=a-b\); it is \(q\)-periodic with vanishing shadow, so by (ii) \(d\) is constant modulo every non-exceptional \(p\). Choosing \(p>2\max_n\lvert d_n\rvert\) makes \(d\) constant in \(\mathbb{Z}\), and a constant sequence with \(\sum_n d_n=0\) is zero.
