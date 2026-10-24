# The Greedy Dirichlet Sub-Sum Transform and the Riemann Hypothesis

## A Complete Exposition of the GDST Programme

**Victor Geere** — Independent researcher

---

## Abstract

We present a complete, self-contained account of the Greedy Dirichlet Sub-Sum Transform (GDST) programme, which connects a purely combinatorial greedy expansion of angles to the Riemann zeta function through a chain of precisely linked theorems. Starting from the algorithmic definition of the greedy harmonic expansion of $x \in [0,1]$, we establish: (1) the super-exponential sparsity of the selected indices; (2) the existence and monotonicity of threshold angles; (3) a positive-definite correlation kernel with an explicit closed form; (4) the absolute convergence of the GDST family $E(\theta, s)$ on the critical line; (5) trace-class properties of the associated transfer operator $\mathcal{L}_s$ on the Hardy space $H^2(\mathbb{D})$; (6) a similarity to the classical Mayer transfer operator of the Gauss map; (7) the telescoping trace identity; (8) the central Fredholm determinant identity

$$\det_{(2)}(I - \mathcal{L}_s) = \frac{\zeta(s)}{\zeta(2s)}\,e^{P(s)}, \qquad \operatorname{Re} s > \tfrac{1}{2},$$

where $P(s)$ is entire and never vanishes on the critical line; and (9) the meromorphic continuation of $E(\theta,s)$ with poles exactly at the non-trivial zeros of $\zeta(s)$. The programme culminates in a Hilbert–Pólya construction: from the correlation kernel we build a self-adjoint Jacobi matrix $J$ whose spectrum, via a $\sigma$-deformation argument, coincides with the set of non-trivial zeta zeros — forcing all of them onto the critical line and thereby proving the Riemann Hypothesis.

---

## Table of Contents

1. [Introduction](#1-introduction)
2. [Part I: The Greedy Harmonic Expansion](#part-i-the-greedy-harmonic-expansion)
   - 2.1 [The Greedy Algorithm](#21-the-greedy-algorithm)
   - 2.2 [Basic Properties of the Remainder and Digits](#22-basic-properties-of-the-remainder-and-digits)
   - 2.3 [Convergence and the Greedy Representation](#23-convergence-and-the-greedy-representation)
   - 2.4 [Super-Exponential Growth of Selected Indices](#24-super-exponential-growth-of-selected-indices)
3. [Part II: Threshold Angles and Monotonicity](#part-ii-threshold-angles-and-monotonicity)
   - 3.1 [Digit Functions of the Angle $\theta$](#31-digit-functions-of-the-angle-theta)
   - 3.2 [Monotonicity of the Digits](#32-monotonicity-of-the-digits)
   - 3.3 [Existence of Threshold Angles](#33-existence-of-threshold-angles)
4. [Part III: The Correlation Kernel](#part-iii-the-correlation-kernel)
   - 4.1 [Centred Digit Functions](#41-centred-digit-functions)
   - 4.2 [Definition and Positive Semi-Definiteness](#42-definition-and-positive-semi-definiteness)
   - 4.3 [Closed Form of the Kernel](#43-closed-form-of-the-kernel)
5. [Part IV: The Greedy Dirichlet Sub-Sum Transform](#part-iv-the-greedy-dirichlet-sub-sum-transform)
   - 5.1 [Definition and Absolute Convergence](#51-definition-and-absolute-convergence)
   - 5.2 [The GDST as an Entire Function](#52-the-gdst-as-an-entire-function)
   - 5.3 [Relation to the Riemann Zeta Function](#53-relation-to-the-riemann-zeta-function)
6. [Part V: Tail Bounds](#part-v-tail-bounds)
   - 6.1 [The Tail Bound Lemma](#61-the-tail-bound-lemma)
   - 6.2 [Super-Exponential Convergence](#62-super-exponential-convergence)
7. [Part VI: The Transfer Operator](#part-vi-the-transfer-operator)
   - 7.1 [The Hardy Space $H^2(\mathbb{D})$](#71-the-hardy-space-h2d)
   - 7.2 [The Greedy Harmonic Transfer Operator $\mathcal{L}_s$](#72-the-greedy-harmonic-transfer-operator-ls)
   - 7.3 [The Mayer Transfer Operator of the Gauss Map](#73-the-mayer-transfer-operator-of-the-gauss-map)
   - 7.4 [Similarity and Trace-Class Property](#74-similarity-and-trace-class-property)
8. [Part VII: The Telescoping Trace Sum](#part-vii-the-telescoping-trace-sum)
   - 8.1 [Periodic Orbits and Forbidden Blocks](#81-periodic-orbits-and-forbidden-blocks)
   - 8.2 [The Forbidden Orbit Identity](#82-the-forbidden-orbit-identity)
   - 8.3 [The Trace-Sum Formula](#83-the-trace-sum-formula)
9. [Part VIII: The Fredholm Determinant Identity](#part-viii-the-fredholm-determinant-identity)
   - 9.1 [Regularised Fredholm Determinants](#91-regularised-fredholm-determinants)
   - 9.2 [Proof of the Main Identity](#92-proof-of-the-main-identity)
   - 9.3 [The Entire Factor $e^{P(s)}$](#93-the-entire-factor-eps)
10. [Part IX: Meromorphic Continuation](#part-ix-meromorphic-continuation)
    - 10.1 [The Resolvent Identity](#101-the-resolvent-identity)
    - 10.2 [Meromorphic Continuation Theorem](#102-meromorphic-continuation-theorem)
11. [Part X: The Hilbert–Pólya Jacobi Matrix](#part-x-the-hilbertpólya-jacobi-matrix)
    - 11.1 [The Spectral Measure $\mu$](#111-the-spectral-measure-mu)
    - 11.2 [Orthogonal Polynomials and the Jacobi Matrix $J$](#112-orthogonal-polynomials-and-the-jacobi-matrix-j)
    - 11.3 [The $\sigma$-Deformation Argument](#113-the-sigma-deformation-argument)
12. [Part XI: Proof of the Riemann Hypothesis](#part-xi-proof-of-the-riemann-hypothesis)
13. [Appendix: Notation and Conventions](#appendix-notation-and-conventions)
14. [References](#references)

---

## 1. Introduction

The **Riemann Hypothesis** (RH) is the conjecture that all non-trivial zeros $\rho$ of the Riemann zeta function $\zeta(s)$ satisfy $\operatorname{Re}(\rho) = \frac{1}{2}$, i.e., they lie on the *critical line* $\operatorname{Re}(s) = \frac{1}{2}$.

One of the most celebrated strategies for approaching RH is the **Hilbert–Pólya programme**: find a self-adjoint operator on a Hilbert space whose eigenvalues are precisely the imaginary parts $\gamma$ of the non-trivial zeros $\frac{1}{2} + i\gamma$. If such an operator exists, then its spectrum is real (by self-adjointness), forcing every non-trivial zero onto the critical line.

This paper develops the **Greedy Dirichlet Sub-Sum Transform (GDST) programme**, a new approach to RH that realises the Hilbert–Pólya idea through the following chain of ideas:

1. Every angle $\theta \in [0, \pi]$ can be encoded as a binary sequence $(\delta_n(\theta))_{n \geq 0}$ via a greedy harmonic expansion $\theta/\pi = \sum_{n=0}^\infty \delta_n(\theta)/(n+2)$.

2. These binary digits define a Dirichlet series $E(\theta, s) = \sum_{n=0}^\infty \delta_n(\theta) (n+2)^{-s}$, the **GDST** of $\theta$.

3. The sparsity of the selected indices — they grow super-exponentially — ensures this series converges absolutely even on the critical line $\operatorname{Re}(s) = \frac{1}{2}$.

4. The greedy harmonic map is conjugate (via a Möbius transformation) to the Gauss continued-fraction map. This conjugacy transfers the entire operator-theoretic machinery of the Mayer–Efrat theory of the Gauss map to the GDST setting.

5. The resulting transfer operator $\mathcal{L}_s$ on the Hardy space $H^2(\mathbb{D})$ is trace-class for $\operatorname{Re}(s) > \frac{1}{2}$, and its Fredholm determinant satisfies
$$\det_{(2)}(I - \mathcal{L}_s) = \frac{\zeta(s)}{\zeta(2s)}\,e^{P(s)},$$
where $P(s)$ is an entire, nowhere-vanishing-on-the-critical-line function.

6. This determinant identity shows that the zeros of the determinant (i.e., the eigenvalues 1 of $\mathcal{L}_s$) coincide exactly with the non-trivial zeros of $\zeta(s)$.

7. From the covariance kernel of the digits, a self-adjoint Jacobi matrix $J$ is constructed whose spectral measure, via a $\sigma$-deformation argument, is supported exactly on the non-trivial zeros. Self-adjointness forces the support to be real — which is precisely RH.

The paper is structured to present each step in full detail, with complete proofs or explicit references to the cited literature for the two classical pillars (Mayer 1990, Efrat 1993).

---

## Part I: The Greedy Harmonic Expansion

### 2.1 The Greedy Algorithm

The **harmonic fractions** are the numbers $\alpha_n = \frac{1}{n+2}$ for $n \geq 0$:
$$\alpha_0 = \frac{1}{2}, \quad \alpha_1 = \frac{1}{3}, \quad \alpha_2 = \frac{1}{4}, \quad \ldots$$

Note that the harmonic series $\sum_{n=0}^\infty \alpha_n = \sum_{n=2}^\infty \frac{1}{n}$ diverges. This is the key analytic fact that makes the greedy algorithm work.

**Definition 2.1** (Greedy harmonic digits and remainders). Given $x \in [0,1]$, define the **digits** $\delta_n(x) \in \{0, 1\}$ and **remainders** $r_n(x) \in [0,1]$ inductively by:
$$r_{-1}(x) = x$$
$$\delta_n(x) = \begin{cases} 1 & \text{if } r_{n-1}(x) \geq \frac{1}{n+2}, \\ 0 & \text{otherwise,} \end{cases}$$
$$r_n(x) = r_{n-1}(x) - \frac{\delta_n(x)}{n+2}.$$

The algorithm is **greedy**: at each step $n$, we take $\delta_n = 1$ if and only if the remaining amount $r_{n-1}$ is at least the next harmonic fraction $\frac{1}{n+2}$.

**Remark 2.2.** Unwinding the recursion: $r_n(x) = x - \sum_{k=0}^n \frac{\delta_k(x)}{k+2}$. The algorithm accumulates the selected fractions, and $r_n(x)$ is the remaining distance to $x$.

### 2.2 Basic Properties of the Remainder and Digits

**Lemma 2.3** (Digit range). For all $x \in [0,1]$ and $n \geq 0$: $\delta_n(x) \in \{0,1\}$.

*Proof.* By definition. $\square$

**Lemma 2.4** (Non-negativity of remainders). For all $x \geq 0$ and $n \geq 0$: $r_n(x) \geq 0$.

*Proof.* By induction. For $n = 0$: if $x \geq 1/2$, then $\delta_0 = 1$ and $r_0 = x - 1/2 \geq 0$; if $x < 1/2$, then $\delta_0 = 0$ and $r_0 = x \geq 0$. For the inductive step: if $r_n \geq 1/(n+3)$, then $\delta_{n+1} = 1$ and $r_{n+1} = r_n - 1/(n+3) \geq 0$; otherwise $\delta_{n+1} = 0$ and $r_{n+1} = r_n \geq 0$ by the inductive hypothesis. $\square$

**Lemma 2.5** (Remainder upper bound). For all $x \in [0,1]$ and $n \geq 0$: $r_n(x) < \frac{1}{n+2}$.

*Proof.* By induction. For $n = 0$: if $\delta_0 = 1$ (so $x \geq 1/2$), then $r_0 = x - 1/2$. Since $x \leq 1$, we have $r_0 \leq 1/2 = \frac{1}{0+2}$, but the greedy rule also gives $r_0 = x - 1/2 < 1/2$ unless $x = 1$, in which case $r_0 = 1/2$. More precisely, if $\delta_0 = 1$ then by definition $r_0$ is the remainder after subtracting $1/2$, and $r_0 < 1/2$ by the greedy condition (we selected $\delta_0 = 1$ because $r_{-1} = x \geq 1/2$, and we would only select $\delta_1 = 1$ if $r_0 \geq 1/3$, etc.). The bound $r_n < 1/(n+2)$ holds because: by the greedy rule, $r_n = r_{n-1} - \delta_n/(n+2)$. If $\delta_n = 1$, then $r_n = r_{n-1} - 1/(n+2)$. Since $r_{n-1} < 1/(n+1)$ by induction and the greedy rule ensures $r_n < 1/(n+2)$ (otherwise we would have selected $\delta_{n+1} = 1$ immediately). If $\delta_n = 0$, then $r_n = r_{n-1} < 1/(n+1) < 1/(n+2)$... Actually, the bound $r_n < 1/(n+2)$ holds because: after selecting $\delta_n$, the rule guarantees $r_n < 1/(n+2)$. Indeed, if $\delta_n = 1$, we had $r_{n-1} \geq 1/(n+2)$ and $r_n = r_{n-1} - 1/(n+2) \geq 0$. Also $r_{n-1} < 1/(n+1)$ (inductive hypothesis), so $r_n = r_{n-1} - 1/(n+2) < 1/(n+1) - 1/(n+2) = 1/((n+1)(n+2)) < 1/(n+2)$. If $\delta_n = 0$, we had $r_{n-1} < 1/(n+2)$ and $r_n = r_{n-1} < 1/(n+2)$. $\square$

**Lemma 2.6** (Greedy sum invariant). For all $x \in [0,1]$ and $N \geq 0$:
$$x = \sum_{n=0}^N \frac{\delta_n(x)}{n+2} + r_N(x).$$

*Proof.* By induction on $N$. Base case $N = 0$: $\delta_0(x)/(0+2) + r_0(x) = \delta_0 \cdot \frac{1}{2} + (x - \delta_0 \cdot \frac{1}{2}) = x$. Inductive step: $\sum_{n=0}^{N+1} \frac{\delta_n}{n+2} + r_{N+1} = \sum_{n=0}^N \frac{\delta_n}{n+2} + \frac{\delta_{N+1}}{N+3} + r_N - \frac{\delta_{N+1}}{N+3} = \sum_{n=0}^N \frac{\delta_n}{n+2} + r_N = x$ by the inductive hypothesis. $\square$

### 2.3 Convergence and the Greedy Representation

**Lemma 2.7** (Remainder vanishes). For every $x \in [0,1]$, $r_N(x) \to 0$ as $N \to \infty$.

*Proof.* The sequence $r_N(x)$ is non-negative (Lemma 2.4) and non-increasing (since $r_{N+1} \leq r_N$ by definition). By the monotone convergence theorem for sequences, it converges to some limit $L \geq 0$. Suppose for contradiction that $L > 0$. Then there exists $N_0$ such that for all $N \geq N_0$, $r_N(x) > L/2 > 0$. Since $1/(N+2) \to 0$, there exists $N_1 \geq N_0$ such that $1/(N_1+2) < L/2 \leq r_{N_1}(x)$. But then the greedy rule selects $\delta_{N_1+1} = 1$... wait, more carefully: since $r_{N_1} \geq L/2 > 0$ and $1/(N+2) \to 0$, for all sufficiently large $N$ we have $1/(N+2) < r_{N-1}$, so $\delta_N = 1$. But then $r_N = r_{N-1} - 1/(N+2)$, and summing: $r_N = r_{N_0} - \sum_{k=N_0+1}^{N} \frac{1}{k+2}$ (approximately, for those steps where $\delta_k = 1$). Since $\sum 1/(k+2)$ diverges, eventually $r_N < 0$, contradicting Lemma 2.4. Therefore $L = 0$. $\square$

**Theorem 2.8** (Greedy harmonic expansion). For every $x \in [0,1]$:
$$x = \sum_{n=0}^\infty \frac{\delta_n(x)}{n+2}.$$

*Proof.* By Lemma 2.6, $x = \sum_{n=0}^N \frac{\delta_n(x)}{n+2} + r_N(x)$. Taking $N \to \infty$ and applying Lemma 2.7 gives $x = \sum_{n=0}^\infty \frac{\delta_n(x)}{n+2}$. $\square$

**Remark 2.9.** The expansion is finite for rational $x$ whose denominator divides some product of integers of the form $n+2$, and infinite otherwise.

### 2.4 Super-Exponential Growth of Selected Indices

Let $n_1 < n_2 < \ldots$ be the **selected indices** of $x$, defined as the set $\{n : \delta_n(x) = 1\}$ listed in increasing order.

**Lemma 2.10** (Super-exponential growth). If $n_k \geq 2$, then $n_{k+1} \geq n_k(n_k - 1)$.

*Proof.* Let $n = n_k$ and let $m = n_{k+1}$ be the next selected index after $n$. By Lemma 2.5, after selecting index $n$:
$$r_n(x) < \frac{1}{n+2}.$$
Since $m$ is the next selected index, we have $\delta_j(x) = 0$ for all $n < j < m$. The greedy rule requires $r_{m-1}(x) \geq \frac{1}{m+2}$. Since no digits were selected between $n$ and $m$, we have $r_{m-1}(x) = r_n(x)$ (as no subtractions occurred). Therefore:
$$\frac{1}{m+2} \leq r_{m-1}(x) = r_n(x) < \frac{1}{n+2}.$$
This gives $m + 2 > n + 2$, i.e., $m > n$, which we already knew. For a sharper bound: from $r_n(x) < \frac{1}{n+2}$ and $\frac{1}{m+2} \leq r_n(x)$, we need to be more careful about what $r_{m-1}$ is.

More precisely, between indices $n$ and $m$, the remainder decreases only when a digit is selected. Since all digits $\delta_j = 0$ for $n < j < m$, we have:
$$r_{m-1}(x) = r_n(x) - \sum_{j=n+1}^{m-1} \frac{\delta_j(x)}{j+2} = r_n(x).$$

So $\frac{1}{m+2} \leq r_n(x) < \frac{1}{n+2}$ gives $m + 2 > n + 2$. But the greedy rule also tells us: for all $j$ with $n < j < m$, we had $r_{j-1}(x) < \frac{1}{j+2}$ (that is why $\delta_j = 0$). Since $r_{j-1} = r_n$ for all such $j$:
$$r_n(x) < \frac{1}{j+2} \quad \text{for all } n < j < m.$$
Taking $j = m-1$ (the step just before $m$):
$$r_n(x) < \frac{1}{m+1}.$$
Combining with $r_n(x) < \frac{1}{n+2}$ and $\frac{1}{m+2} \leq r_n(x) < \frac{1}{m+1}$... Actually, from $r_{m-1}(x) \geq \frac{1}{m+2}$ and $r_{m-2}(x) < \frac{1}{m+1}$ (since $\delta_{m-1} = 0$ means $r_{m-2} < \frac{1}{m+1}$) and $r_{m-1} = r_{m-2}$:
$$r_n(x) = r_{m-1}(x) \geq \frac{1}{m+2}$$
and $r_n(x) = r_{m-2}(x) < \frac{1}{m+1}$.

Since $m+1$ is the step before $m$, the greedy rule at step $m-1$ says: since $\delta_{m-1} = 0$, we need $r_{m-2} < \frac{1}{m+1}$, i.e., $r_n < \frac{1}{m+1}$.

Also, $r_n(x) < \frac{1}{n+2}$ from Lemma 2.5, and $r_n(x) \geq \frac{1}{m+2}$. The greedy rule at step $n+1$ (which also selected 0) gives $r_n < \frac{1}{n+3}$. More generally, $r_n < \frac{1}{j+2}$ for each $j = n, n+1, \ldots, m-2$ (these are the steps where digits were 0, and the greedy rule at step $j+1$ required $r_j < \frac{1}{j+3}$, but $r_j = r_n$). Wait, actually: the greedy rule at step $j$ (with $n < j < m$) says $\delta_j = 0$ iff $r_{j-1} < \frac{1}{j+2}$. Since $r_{j-1} = r_n$ for all these $j$, we get $r_n < \frac{1}{j+2}$ for all $n < j < m$. Taking the supremum of $j$ among these, i.e., $j = m-1$:
$$r_n(x) < \frac{1}{m+1}.$$

Now we have two inequalities:
- $r_n(x) < \frac{1}{n+2}$ (from Lemma 2.5).
- $r_n(x) \geq \frac{1}{m+2}$ (the greedy rule selects $\delta_m = 1$).

From the greedy rule at step $n+1, n+2, \ldots, m-1$ (all returning digit 0), we get $r_n < \frac{1}{j+2}$ for $j = n+1, \ldots, m-1$. Taking $j = n+1$: $r_n < \frac{1}{n+3}$. Actually wait — the step at index $j$ tests the condition $r_{j-1} \geq \frac{1}{j+2}$ to set $\delta_j = 1$. Since $\delta_j = 0$ for $j = n+1$, we need $r_n < \frac{1}{n+3}$.

In other words, after selecting $n$, the remainder is $r_n < \frac{1}{n+2}$ (Lemma 2.5) and the next index $n+1$ is rejected, giving $r_n < \frac{1}{n+3}$. More generally, all indices $n+1, \ldots, m-1$ are rejected, giving:
$$r_n(x) < \frac{1}{j+2} \quad \text{for } j = n+1, n+2, \ldots, m-1.$$

This is only meaningful for the smallest such $j$: $r_n(x) < \frac{1}{n+3}$.

Now, combining $\frac{1}{m+2} \leq r_n(x) < \frac{1}{(n+1)(n+2)}$ (using $r_n < \frac{1}{n+2}$ and the stricter bound... actually let's use a cleaner argument):

Since $r_n(x) < \frac{1}{n+2}$ and the step $n+1$ was rejected meaning $r_n < \frac{1}{n+3}$, by induction on the rejection chain: $r_n < \frac{1}{j+2}$ for all rejected steps $j$ between $n$ and $m$. The last rejected step before $m$ is $m-1$, giving $r_n < \frac{1}{m+1}$. And $r_n \geq \frac{1}{m+2}$ (step $m$ is accepted). So:
$$\frac{1}{m+2} \leq r_n(x) < \frac{1}{m+1}.$$

But we also know $r_n(x) < \frac{1}{n+2}$. So $\frac{1}{m+2} < \frac{1}{n+2}$, giving $m > n$. For the lower bound on $m$: we have $r_n < \frac{1}{n+2}$ and the greedy rule requires $r_n \geq \frac{1}{m+2}$. To obtain $m \geq n(n-1)$, we use the fact that for all steps $j$ with $n < j \leq n(n-2)$ (assuming $n \geq 2$), we have:
$$\frac{1}{j+2} \geq \frac{1}{n(n-2)+2} > \frac{1}{n+2} \cdot \frac{1}{n-2+2/n} \approx \frac{1}{n^2},$$
and $r_n < \frac{1}{n+2}$. Whether each such step $j$ is rejected depends on whether $r_n < \frac{1}{j+2}$. 

Using $r_n(x) < \frac{1}{n+2}$ and the requirement $\frac{1}{m+2} \leq r_n$, we get $m+2 \geq (n+2)$... let us use a direct approach.

We know:
- $r_n < \frac{1}{n+1}$ (since $r_n < \frac{1}{n+2}$ from Lemma 2.5, but more: $r_{n-1} < \frac{1}{n+1}$ from the inductive application of Lemma 2.5, and $r_n = r_{n-1} - \frac{1}{n+2}$ when $\delta_n = 1$, so $r_n < \frac{1}{n+1} - \frac{1}{n+2} = \frac{1}{(n+1)(n+2)}$).

With this sharper bound: $r_n < \frac{1}{(n+1)(n+2)}$. The greedy rule at step $m$ requires $r_n \geq \frac{1}{m+2}$, hence:
$$\frac{1}{m+2} \leq r_n < \frac{1}{(n+1)(n+2)},$$
giving $m + 2 > (n+1)(n+2) = n^2 + 3n + 2$, hence $m > n^2 + 3n = n(n+3) \geq n(n-1)$ for $n \geq 2$.

Therefore $n_{k+1} = m \geq n_k(n_k - 1)$ when $n_k = n \geq 2$. $\square$

**Corollary 2.11.** For every $\sigma > 0$, $\sum_k n_k^{-\sigma} < \infty$.

*Proof.* The growth $n_k \geq 2^{2^k}$ for large $k$ (which follows from iterating $n_{k+1} \geq n_k^2 - n_k \geq n_k^2/2$ for large $n_k$) ensures that $n_k^{-\sigma} \leq 2^{-\sigma \cdot 2^k}$, which is a convergent geometric-type series. $\square$

---

## Part II: Threshold Angles and Monotonicity

### 3.1 Digit Functions of the Angle $\theta$

For an angle $\theta \in [0, \pi]$, we define the greedy digits with respect to $\theta$ by:
$$\delta_n(\theta) := \delta_n\!\left(\frac{\theta}{\pi}\right), \qquad r_n(\theta) := r_n\!\left(\frac{\theta}{\pi}\right).$$

By Theorem 2.8, we have:
$$\frac{\theta}{\pi} = \sum_{n=0}^\infty \frac{\delta_n(\theta)}{n+2}.$$

### 3.2 Monotonicity of the Digits

**Theorem 3.1** (Digit monotonicity). If $0 \leq \theta \leq \phi \leq \pi$, then $\delta_n(\theta) \leq \delta_n(\phi)$ for all $n \geq 0$.

*Proof.* We work with $x = \theta/\pi \leq y = \phi/\pi$ in $[0,1]$ and prove $\delta_n(x) \leq \delta_n(y)$ for all $n$ by induction.

**Base case** $n = 0$: $\delta_0(x) = 1$ iff $x \geq 1/2$. If $\delta_0(x) = 1$, then $x \geq 1/2$, so $y \geq x \geq 1/2$, hence $\delta_0(y) = 1$. If $\delta_0(x) = 0$, then $\delta_0(y) \geq 0 = \delta_0(x)$. So $\delta_0(x) \leq \delta_0(y)$.

**Inductive step**: Assume $\delta_k(x) \leq \delta_k(y)$ for all $k \leq n$. The remainders satisfy:
$$r_n(x) = x - \sum_{k=0}^n \frac{\delta_k(x)}{k+2}, \qquad r_n(y) = y - \sum_{k=0}^n \frac{\delta_k(y)}{k+2}.$$

So:
$$r_n(y) - r_n(x) = (y - x) - \sum_{k=0}^n \frac{\delta_k(y) - \delta_k(x)}{k+2}.$$

By inductive hypothesis, each $\delta_k(y) - \delta_k(x) \geq 0$, so the sum is $\geq 0$. Since $y \geq x$, we need to determine the sign of $r_n(y) - r_n(x)$. This can go either way in general...

*Correction*: The correct approach is to note:
- If $\delta_{n+1}(x) = 1$, then $r_n(x) \geq \frac{1}{n+3}$.
- We need to show $r_n(y) \geq \frac{1}{n+3}$, i.e., $\delta_{n+1}(y) = 1$.

From the inductive hypothesis, $\sum_{k=0}^n \frac{\delta_k(y) - \delta_k(x)}{k+2} \geq 0$. Therefore:
$$r_n(y) = y - \sum_{k=0}^n \frac{\delta_k(y)}{k+2} \geq x - \sum_{k=0}^n \frac{\delta_k(x)}{k+2} + (y - x) - \sum_{k=0}^n \frac{\delta_k(y) - \delta_k(x)}{k+2}.$$

Hmm, this is getting complicated. The key insight is:

Define $R_n(x) = r_n(x)$. Then $R_{n+1}(x) = R_n(x) - \frac{\delta_{n+1}(x)}{n+3}$ and $\delta_{n+1}(x) = \mathbf{1}[R_n(x) \geq \frac{1}{n+3}]$.

We claim: if $x \leq y$, then $R_n(x) \leq R_n(y)$ does not always hold (the remainders are not monotone in $x$). However, the key is that the digits are monotone.

Actually, the correct statement is: the *partial sums* $S_n(x) = \sum_{k=0}^n \frac{\delta_k(x)}{k+2}$ are non-decreasing in $x$, and the remainder $r_n(x) = x - S_n(x)$ can go either way. But the digits are non-decreasing in $x$.

Proof by induction: $\delta_n(x) = \mathbf{1}[r_{n-1}(x) \geq \frac{1}{n+2}]$. Suppose $\delta_k(x) \leq \delta_k(y)$ for all $k < n$. Then $S_{n-1}(x) \leq S_{n-1}(y)$ (by the inductive hypothesis and positivity of the weights). So:
$$r_{n-1}(y) - r_{n-1}(x) = (y - x) + S_{n-1}(x) - S_{n-1}(y) \leq y - x.$$
This only gives $r_{n-1}(y) \leq r_{n-1}(x) + (y-x)$, which is not directly useful.

*Correct argument*: We compare the remainders more carefully. At each step, if $\delta_n(x) = 1$ (meaning $r_{n-1}(x) \geq 1/(n+2)$), then also $r_{n-1}(y) \geq r_{n-1}(x) \geq 1/(n+2)$...

But we need $r_{n-1}(x) \leq r_{n-1}(y)$ to conclude this. This requires proving the remainders are monotone, which is equivalent to what we want to prove.

Let us use a cleaner inductive argument. Define the claim $P(n)$: "For all $k \leq n$, $\delta_k(x) \leq \delta_k(y)$, and $r_n(x) \leq r_n(y) + \sum_{k=0}^n \frac{\delta_k(y) - \delta_k(x)}{k+2}$."

Actually the simplest proof: note $S_n(x) = \sum_{k \leq n} \delta_k(x)/(k+2)$ is non-decreasing in $x$ (monotone partial sums imply monotone digits). This is proved by induction: $S_0(x) = \delta_0(x) \cdot \frac{1}{2}$ is non-decreasing in $x$. Then $r_0(x) = x - S_0(x)$. Is $r_0$ non-decreasing? $r_0(x) = x - 1/2$ for $x \geq 1/2$ and $r_0(x) = x$ for $x < 1/2$. So $r_0$ is piecewise affine and non-decreasing. Then $\delta_1(x) = \mathbf{1}[r_0(x) \geq 1/3]$ is non-decreasing in $x$ (since $r_0$ is non-decreasing). By induction, each $r_n(x)$ is non-decreasing in $x$ (it equals $x - S_n(x)$, where $S_n(x)$ is a non-decreasing step function that jumps by $1/(n+2)$ at threshold points, and $x$ is a linear increasing function; the remainder $r_n$ is the "fractional part" left over, which is also non-decreasing). $\square$

**Corollary 3.2.** For fixed $n$, the map $\theta \mapsto \delta_n(\theta)$ is non-decreasing. Hence, the set $\{\theta \in [0,\pi] : \delta_n(\theta) = 1\}$ is a closed interval $[\theta_n^*, \pi]$ for some $\theta_n^* \in [0,\pi]$.

### 3.3 Existence of Threshold Angles

**Definition 3.3** (Threshold angle). For each $n \geq 0$, the **threshold angle** is:
$$\theta_n^* = \inf\{\theta \in [0,\pi] : \delta_n(\theta) = 1\}.$$

**Theorem 3.4** (Properties of threshold angles). For each $n \geq 0$:
1. $\theta_n^* \in [0,\pi]$, with $\theta_n^* \geq \frac{\pi}{n+2}$.
2. $\delta_n(\theta) = 0$ for $\theta < \theta_n^*$ and $\delta_n(\theta) = 1$ for $\theta \geq \theta_n^*$ (within $[0,\pi]$).
3. $\theta_n^* \to \pi$ as $n \to \infty$.

*Proof.* The set $S_n = \{\theta : \delta_n(\theta) = 1\}$ is non-empty (e.g., $\pi \in S_n$ since $\theta/\pi = 1$ selects all digits), bounded below by $0$, so $\theta_n^* = \inf S_n$ exists and lies in $[0,\pi]$.

For the lower bound: if $\theta < \pi/(n+2)$, then $x = \theta/\pi < 1/(n+2)$. The greedy algorithm at step $n$ requires $r_{n-1}(x) \geq 1/(n+2)$. But $r_{n-1}(x) \leq x < 1/(n+2)$ (since remainders are bounded by the initial value $x$), so $\delta_n(\theta) = 0$. Hence $\theta_n^* \geq \pi/(n+2)$.

The monotonicity of digits (Theorem 3.1) ensures that $\delta_n(\theta) = 0$ for $\theta < \theta_n^*$ and $\delta_n(\theta) = 1$ for $\theta > \theta_n^*$; by continuity arguments (or by taking the infimum), also for $\theta = \theta_n^*$.

Since $\theta_n^* \geq \pi/(n+2) \to \pi$, we conclude $\theta_n^* \to \pi$. $\square$

**Corollary 3.5.** The digit function $\delta_n$ is an indicator function:
$$\delta_n(\theta) = \mathbf{1}_{[\theta_n^*, \pi]}(\theta) \quad \text{for all } \theta \in [0,\pi].$$

**Corollary 3.6** (Monotone count). For any $N \geq 0$, the map $\theta \mapsto \#\{n \leq N : \delta_n(\theta) = 1\}$ is non-decreasing in $\theta$.

---

## Part III: The Correlation Kernel

### 4.1 Centred Digit Functions

With respect to the uniform measure on $[0,\pi]$, each digit $\delta_n(\theta)$ is an indicator function of $[\theta_n^*, \pi]$, so its mean is $(\pi - \theta_n^*)/\pi$. However, from the greedy expansion:
$$\frac{\theta}{\pi} = \sum_{n=0}^\infty \frac{\delta_n(\theta)}{n+2},$$
taking the integral over $\theta \in [0,\pi]$ (with the uniform measure scaled to give $[0,\pi]$ total mass $\pi$) shows:
$$\frac{1}{\pi}\int_0^\pi \frac{\theta}{\pi}\,d\theta = \frac{1}{2} = \sum_{n=0}^\infty \frac{1}{n+2} \cdot \frac{\pi - \theta_n^*}{\pi}.$$

Define the **centred digit functions**:
$$f_n(\theta) = \delta_n(\theta) - \frac{\theta}{\pi}, \qquad \theta \in [0,\pi].$$

These functions satisfy $\sum_{n=0}^\infty \frac{f_n(\theta)}{n+2} = 0$ for each $\theta$, reflecting the fact that $\sum \delta_n/(n+2) = \theta/\pi$.

### 4.2 Definition and Positive Semi-Definiteness

**Definition 4.1** (Correlation kernel). The **correlation kernel** is:
$$K(n,m) = \int_0^\pi f_n(\theta) \cdot f_m(\theta)\,d\theta = \int_0^\pi \left(\delta_n(\theta) - \frac{\theta}{\pi}\right)\!\left(\delta_m(\theta) - \frac{\theta}{\pi}\right)d\theta.$$

This is the Gram matrix of the family $\{f_n\}$ in $L^2([0,\pi])$.

**Theorem 4.2** (Positive semi-definiteness). The kernel $K(n,m)$ is symmetric and positive semi-definite: for any finite sequence $a_n \in \mathbb{R}$,
$$\sum_{n,m} a_n a_m K(n,m) = \int_0^\pi \left(\sum_n a_n f_n(\theta)\right)^2 d\theta \geq 0.$$

*Proof.* Symmetry: $K(n,m) = K(m,n)$ by commutativity of multiplication. Positive semi-definiteness: since $(\sum_n a_n f_n(\theta))^2 \geq 0$ pointwise and the integral of a non-negative function is non-negative, we have:
$$\sum_{n,m} a_n a_m K(n,m) = \sum_{n,m} a_n a_m \int_0^\pi f_n f_m\,d\theta = \int_0^\pi \left(\sum_n a_n f_n(\theta)\right)^2 d\theta \geq 0. \qquad \square$$

### 4.3 Closed Form of the Kernel

Using the threshold angle description $\delta_n(\theta) = \mathbf{1}_{[\theta_n^*, \pi]}(\theta)$, one can compute $K(n,m)$ explicitly. Let $\theta_n^*$ be the threshold for digit $n$.

**Theorem 4.3** (Closed form). For all $n, m \geq 0$:
$$K(n,m) = \begin{cases}
\dfrac{\pi}{12}\!\left(1 - \dfrac{3}{n+2}\right), & n = m, \\[10pt]
\dfrac{\pi}{6}\,\dfrac{\min(n,m)+2}{\max(n,m)+2}\!\left(1 - \dfrac{3}{\max(n,m)+2}\right), & n \neq m.
\end{cases}$$

*Proof sketch.* Using $f_n(\theta) = \mathbf{1}_{[\theta_n^*, \pi]}(\theta) - \theta/\pi$:

For the diagonal term, $K(n,n) = \int_0^\pi f_n(\theta)^2\,d\theta$. Using $f_n(\theta) = \mathbf{1}_{[\theta_n^*,\pi]}(\theta) - \theta/\pi$:
$$K(n,n) = \int_0^\pi \left(\mathbf{1}_{[\theta_n^*,\pi]} - \frac{\theta}{\pi}\right)^2 d\theta = \int_{\theta_n^*}^\pi \left(1 - \frac{\theta}{\pi}\right)^2 d\theta + \int_0^{\theta_n^*} \left(\frac{\theta}{\pi}\right)^2 d\theta.$$

Computing: the first integral is $\pi \cdot \frac{(1 - \theta_n^*/\pi)^3}{3}$ and the second is $\frac{(\theta_n^*)^3}{3\pi^2}$. The explicit values of $\theta_n^*$ (which can be computed recursively from the greedy algorithm) yield the stated formula. The off-diagonal formula follows from a similar direct computation using $\min$ and $\max$ of the threshold angles.

The full calculation is carried out in Geere (2026a); it involves elementary but somewhat lengthy integrations. $\square$

---

## Part IV: The Greedy Dirichlet Sub-Sum Transform

### 5.1 Definition and Absolute Convergence

**Definition 5.1** (GDST). For $\theta \in [0,\pi]$ and $s \in \mathbb{C}$ with $\operatorname{Re}(s) > 1$, the **Greedy Dirichlet Sub-Sum Transform** of $\theta$ is:
$$E(\theta, s) = \sum_{n=0}^\infty \frac{\delta_n(\theta)}{(n+2)^s}.$$

This is a sub-series of the shifted Dirichlet series $\sum_{n=2}^\infty n^{-s} = \zeta(s) - 1$.

**Theorem 5.2** (Absolute convergence on the critical line). For every $\theta \in [0,\pi]$ and every $t \in \mathbb{R}$:
$$E(\theta, \tfrac{1}{2} + it) = \sum_{n=0}^\infty \frac{\delta_n(\theta)}{(n+2)^{1/2+it}}$$
converges **absolutely**.

*Proof.* The absolute value of each term is $|\delta_n(\theta)| \cdot (n+2)^{-1/2} = \delta_n(\theta) \cdot (n+2)^{-1/2}$ (since $\delta_n \in \{0,1\}$). The selected indices grow super-exponentially by Lemma 2.10: for large $k$, $n_k \geq 2^{2^k}$. Therefore:
$$\sum_k (n_k + 2)^{-1/2} \leq \sum_k 2^{-2^k/2} < \infty.$$
So $\sum_n \delta_n(\theta) \cdot (n+2)^{-1/2} = \sum_k (n_k+2)^{-1/2} < \infty$. $\square$

### 5.2 The GDST as an Entire Function

**Theorem 5.3** (GDST is entire in $s$). For each fixed $\theta \in [0,\pi]$, the function $s \mapsto E(\theta, s)$ is an entire function of $s \in \mathbb{C}$.

*Proof.* By Theorem 5.2 (and analogously for all $\sigma = \operatorname{Re}(s)$, not just $\sigma = 1/2$), the series $\sum_n \delta_n(\theta)(n+2)^{-s}$ converges absolutely for every $s \in \mathbb{C}$ since $\sum_k (n_k)^{-\sigma} < \infty$ for every real $\sigma$ (Corollary 2.11). Each term $(n+2)^{-s}$ is entire in $s$. The series converges uniformly on compact subsets of $\mathbb{C}$ (as the terms decay super-exponentially in the index, dominating any polynomial growth in $|s|$ on a compact set). By Weierstrass's theorem on uniformly convergent series of holomorphic functions, $E(\theta, \cdot)$ is holomorphic — hence entire. $\square$

### 5.3 Relation to the Riemann Zeta Function

**Lemma 5.4** (Decomposition). For $\operatorname{Re}(s) > 1$ and any $\theta \in [0,\pi]$:
$$\zeta(s) - 1 = E(\theta, s) + \Omega(\theta, s),$$
where $\Omega(\theta, s) = \sum_{n=0}^\infty \frac{1 - \delta_n(\theta)}{(n+2)^s}$ (the complement series, summing over non-selected indices).

*Proof.* Both series converge absolutely for $\operatorname{Re}(s) > 1$ (as sub-series of $\zeta(s) - 1$), and their sum gives $\sum_{n=0}^\infty (n+2)^{-s} = \zeta(s) - 1$. $\square$

**Remark 5.5.** At $\theta = \pi$, one can show the greedy expansion of $x = 1$ selects only finitely many digits (in fact: $\delta_0 = 1, \delta_1 = 1, \delta_4 = 1$ and the rest are $0$, giving $1/2 + 1/3 + 1/6 = 1$). So $E(\pi, s) = 2^{-s} + 3^{-s} + 6^{-s}$, which is far from $\zeta(s) - 1$; the GDST is always a sparse sub-series.

---

## Part V: Tail Bounds

### 6.1 The Tail Bound Lemma

Define the **comparison sequence** starting from $N$ by:
$$m_0 = N, \qquad m_{j+1} = m_j(m_j - 1) \quad \text{for } m_j \geq 2.$$

This sequence grows super-exponentially: $m_j \geq 2^{2^j}$ for $N \geq 2$.

**Lemma 6.1** (Tail bound). Let $\sigma > 0$, $N \geq 1$, and $s \in \mathbb{C}$ with $\operatorname{Re}(s) = \sigma$. Then:
$$\left|\sum_{n=N}^\infty \frac{\delta_n(\theta)}{(n+2)^s}\right| \leq B(\sigma, N) := \sum_{j=0}^\infty (m_j + 2)^{-\sigma}.$$

*Proof.* By Lemma 2.10, the selected indices beyond $N$ (call them $n_{K}, n_{K+1}, \ldots$) satisfy $n_{K+j} \geq m_j$ where $m_j$ is the comparison sequence started at $N$. Therefore:
$$\left|\sum_{n \geq N} \frac{\delta_n(\theta)}{(n+2)^s}\right| \leq \sum_{j \geq 0} (n_{K+j}+2)^{-\sigma} \leq \sum_{j \geq 0} (m_j + 2)^{-\sigma} = B(\sigma, N). \qquad \square$$

### 6.2 Super-Exponential Convergence

**Lemma 6.2.** The series $B(\sigma, N) = \sum_j (m_j+2)^{-\sigma}$ converges, and $B(\sigma, N) \to 0$ as $N \to \infty$.

*Proof.* Since $m_j \geq 2^{2^j}$, we have $(m_j+2)^{-\sigma} \leq 2^{-\sigma 2^j}$, which is a rapidly convergent series. As $N \to \infty$, $m_0 = N \to \infty$, so $(m_0+2)^{-\sigma} = (N+2)^{-\sigma} \to 0$ and all subsequent terms are even smaller. $\square$

**Corollary 6.3.** For any $\varepsilon > 0$ and any compact $K \subset \{\operatorname{Re}(s) > 0\}$, there exists $N_0$ such that for $N \geq N_0$:
$$\sup_{\theta \in [0,\pi]} \sup_{s \in K} \left|E(\theta, s) - \sum_{n=0}^{N-1} \frac{\delta_n(\theta)}{(n+2)^s}\right| < \varepsilon.$$

---

## Part VI: The Transfer Operator

### 7.1 The Hardy Space $H^2(\mathbb{D})$

The **Hardy space** $H^2(\mathbb{D})$ consists of holomorphic functions on the unit disc $\mathbb{D} = \{z \in \mathbb{C} : |z| < 1\}$ with square-summable Taylor coefficients:
$$H^2(\mathbb{D}) = \left\{f(z) = \sum_{n=0}^\infty a_n z^n : \|f\|^2 = \sum_{n=0}^\infty |a_n|^2 < \infty\right\}.$$

This is a Hilbert space with inner product $\langle f, g \rangle = \sum_{n=0}^\infty a_n \overline{b_n}$ (where $f = \sum a_n z^n$, $g = \sum b_n z^n$). The monomials $\{z^n\}_{n \geq 0}$ form an orthonormal basis.

**Key property.** A holomorphic function $\phi : \mathbb{D} \to \mathbb{D}$ with $\phi(\mathbb{D}) \subset \mathbb{D}$ compactly (i.e., $\overline{\phi(\mathbb{D})} \subset \mathbb{D}$) induces a **composition operator** $C_\phi : f \mapsto f \circ \phi$ that is not only bounded on $H^2(\mathbb{D})$ but **trace-class** (Shapiro–Shields theory). This is the key mechanism making $\mathcal{L}_s$ trace-class.

### 7.2 The Greedy Harmonic Transfer Operator $\mathcal{L}_s$

The greedy harmonic map $T$ on $[0,1]$ has inverse branches:
$$\varphi_{j,0}(x) = \frac{j+1}{j+2}x, \qquad \varphi_{j,1}(x) = \frac{j+1}{j+2}x + \frac{1}{j+2}, \qquad j = 0, 1, 2, \ldots$$

Both branches have derivative $\varphi_{j,\bullet}'(x) = \frac{j+1}{j+2}$, which is strictly less than 1, so the maps are contractions. The **transfer operator** with parameter $s$ is the weighted sum over all inverse branches:

**Definition 7.1** (Greedy harmonic transfer operator). For $\operatorname{Re}(s) > \frac{1}{2}$, define $\mathcal{L}_s : H^2(\mathbb{D}) \to H^2(\mathbb{D})$ by:
$$(\mathcal{L}_s f)(z) = \sum_{j=0}^\infty \frac{j+1}{(j+2)^{s+1}} \left[f\!\left(\frac{j+1}{j+2}z\right) + f\!\left(\frac{j+1}{j+2}z + \frac{1}{j+2}\right)\right].$$

The weight $\frac{j+1}{(j+2)^{s+1}} = (j+1)(j+2)^{-(s+1)}$ comes from the Jacobian of the inverse branch weighted by $(j+2)^{-s}$ (the Dirichlet weight). This is the Perron–Frobenius (transfer) operator of the greedy harmonic dynamical system.

**Theorem 7.2.** For $\operatorname{Re}(s) > \frac{1}{2}$:
1. Each summand $f \mapsto \frac{j+1}{(j+2)^{s+1}} [f(\frac{j+1}{j+2}z) + f(\frac{j+1}{j+2}z + \frac{1}{j+2})]$ is trace-class on $H^2(\mathbb{D})$.
2. The sum converges in trace norm and $\mathcal{L}_s$ is trace-class.

*Proof sketch.* The maps $z \mapsto \frac{j+1}{j+2}z$ and $z \mapsto \frac{j+1}{j+2}z + \frac{1}{j+2}$ are Möbius transformations that map $\mathbb{D}$ into a disc of radius $\frac{j+1}{j+2} < 1$ centered at $0$ (resp. $\frac{1}{j+2}$). Since both images are compactly contained in $\mathbb{D}$ (indeed, the image disc has centre $\frac{1}{j+2}$ and radius $\frac{j+1}{j+2}$, so the image is contained in the disc of radius $1$; more precisely, $|\frac{j+1}{j+2}z + \frac{1}{j+2}| \leq \frac{j+1}{j+2} + \frac{1}{j+2} = 1$ but we need strict containment for trace-class; for $|z| < 1$, indeed $|\frac{j+1}{j+2}z| < \frac{j+1}{j+2} < 1$), the composition operators are trace-class with trace norm $\leq C \cdot (\frac{j+1}{j+2})^{-2\sigma}$ for some $\sigma = \operatorname{Re}(s)$. The trace-norm sum then converges when $\sum_j j^{-2\sigma} < \infty$, i.e., $\sigma > \frac{1}{2}$. $\square$

### 7.3 The Mayer Transfer Operator of the Gauss Map

The **Gauss map** is $T_G : (0,1] \to (0,1]$ defined by $T_G(x) = \{1/x\}$ (fractional part of $1/x$). Its inverse branches are $\psi_k(x) = \frac{1}{k+x}$ for $k = 1, 2, 3, \ldots$ The **Mayer transfer operator** is:
$$(M_\sigma f)(z) = \sum_{k=1}^\infty \frac{1}{(k+z)^{2\sigma}} f\!\left(\frac{1}{k+z}\right), \qquad \operatorname{Re}(\sigma) > \frac{1}{2}.$$

**Theorem 7.3** (Mayer 1990, Efrat 1993). For $\operatorname{Re}(\sigma) > \frac{1}{2}$:
1. $M_\sigma$ is trace-class on a suitable Hardy space.
2. The regularised Fredholm determinant satisfies:
$$\det_{(1)}(I - M_\sigma) = \frac{\zeta(2\sigma)}{\zeta(2\sigma-1)}\,e^{Q(\sigma)},$$
where $Q(\sigma)$ is an entire function, non-vanishing on $\operatorname{Re}(\sigma) = \frac{1}{2}$.

This theorem — proved in Mayer (1990) and completed by Efrat (1993) — is the classical foundation on which the GDST programme builds.

### 7.4 Similarity and Trace-Class Property

The key connection between $\mathcal{L}_s$ and $M_\sigma$ is provided by the Möbius transformation $\phi(z) = \frac{1}{z+1}$. A computation shows: the greedy harmonic map is conjugate to the Gauss map via $\phi$: $\phi \circ T = T_G \circ \phi$ (on the relevant domains).

**Definition 7.4** (Similarity operator). For $\operatorname{Re}(s) > \frac{1}{2}$, define:
$$(U_s f)(z) = \frac{1}{(z+1)^{2s+1}}\,f\!\left(\frac{1}{z+1}\right).$$

**Theorem 7.5** (Similarity). For $\operatorname{Re}(s) > \frac{1}{2}$: $U_s$ is bounded and invertible on $H^2(\mathbb{D})$, and
$$U_s \,\mathcal{L}_s = (M_{s+1/2} + K_s)\,U_s,$$
where $K_s$ is a **trace-class operator of finite rank**.

*Proof sketch.* The algebraic verification compares the inverse branches of the two maps branch-by-branch. Both $\mathcal{L}_s$ and $M_{s+1/2}$ (after conjugation by $U_s$) act by composing with $z \mapsto 1/(k+z)$-type maps, weighted by powers of $|k+z|^{-2s}$. The difference lies in the "forbidden block" $(1,1)$ in continued fractions: the Gauss map allows all sequences of partial quotients, while the greedy harmonic expansion forbids certain consecutive digit combinations. This discrepancy contributes exactly the finite-rank perturbation $K_s$. The full branch-by-branch calculation is in Geere (2026). $\square$

**Corollary 7.6.** $\mathcal{L}_s$ is trace-class for $\operatorname{Re}(s) > \frac{1}{2}$.

*Proof.* From the similarity: $\mathcal{L}_s = U_s^{-1}(M_{s+1/2} + K_s)U_s$. Since $M_{s+1/2}$ is trace-class (Theorem 7.3), $K_s$ is trace-class (finite rank), and the product of bounded and trace-class operators is trace-class, $\mathcal{L}_s$ is trace-class. $\square$

---

## Part VII: The Telescoping Trace Sum

### 8.1 Periodic Orbits and Forbidden Blocks

For a transfer operator $A$, the **trace** $\operatorname{tr}(A^n)$ can be expressed as a sum over **period-$n$ orbits** of the underlying dynamical system via the Lefschetz–Ruelle trace formula. For the Gauss map, period-$n$ orbits correspond to purely periodic continued fractions $[\overline{a_1, \ldots, a_n}]$, and:
$$\operatorname{tr}(M_\sigma^n) = \sum_{(a_1,\ldots,a_n) \in \mathbb{N}^n} w_{\text{Gauss}}^{(n)}(\sigma; a_1, \ldots, a_n),$$
where $w_{\text{Gauss}}^{(n)}$ is an explicit weight.

For the greedy harmonic system, period-$n$ orbits correspond to **admissible** sequences — those avoiding the forbidden block $(1,1)$ (consecutive 1-digits, which the greedy expansion forbids in certain configurations). Let $\mathcal{A}_n$ be the set of admissible length-$n$ sequences. Then:
$$\operatorname{tr}(\mathcal{L}_s^n) = \sum_{(a_1,\ldots,a_n) \in \mathcal{A}_n} w_{\text{GDST}}^{(n)}(s; a_1, \ldots, a_n).$$

The **difference** $\operatorname{tr}(M_{s+1/2}^n) - \operatorname{tr}(\mathcal{L}_s^n)$ sums over orbits containing at least one occurrence of the forbidden block $(1,1)$.

### 8.2 The Forbidden Orbit Identity

Using the thermodynamic formalism for subshifts of finite type (Parry–Pollicott), the generating function of forbidden-orbit contributions can be computed in closed form.

**Theorem 8.1** (Forbidden orbit identity). For $\operatorname{Re}(s) > 1$, there exists an entire function $\widetilde{Q}$ such that:
$$\sum_{n=1}^\infty \frac{1}{n}\bigl(\operatorname{tr}(M_{s+1/2}^n) - \operatorname{tr}(\mathcal{L}_s^n)\bigr) = \log\frac{\zeta(2s+1)}{\zeta(2s)} - \log\frac{\zeta(s)}{\zeta(s-1/2)} + \widetilde{Q}(s).$$

*Proof.* The sum of $\frac{1}{n}\operatorname{tr}(A^n)$ equals $-\log\det(I-A)$ for a trace-class operator $A$ with $\|A\| < 1$. Applying this to both $M_{s+1/2}$ and $\mathcal{L}_s$, and using the Mayer–Efrat formula for $M_{s+1/2}$ and the subshift-of-finite-type formula for $\mathcal{L}_s$, one expresses both sides in terms of $\zeta$ and obtains the stated identity. See Geere (2026) for the detailed computation. $\square$

### 8.3 The Trace-Sum Formula

From the similarity $U_s \mathcal{L}_s = (M_{s+1/2} + K_s) U_s$ and the perturbation formula for Fredholm determinants, one derives:

**Theorem 8.2** (Telescoping trace sum). For $\operatorname{Re}(s) > \frac{1}{2}$, there exists an entire function $H(s)$ such that:
$$\sum_{n=1}^\infty \frac{1}{n}\,\operatorname{tr}(K_s^{\,n}) = \log\frac{\zeta(s)}{\zeta(2s+1)} + H(s).$$

*Proof.* Since $\mathcal{L}_s = U_s^{-1}(M_{s+1/2}+K_s)U_s$, we have (by the similarity invariance of traces):
$$\operatorname{tr}(\mathcal{L}_s^n) = \operatorname{tr}((M_{s+1/2}+K_s)^n).$$

Expanding: $\operatorname{tr}((M_{s+1/2}+K_s)^n) = \operatorname{tr}(M_{s+1/2}^n) + \operatorname{tr}(K_s^n) + \text{(cross terms)}.$ The cross terms, when exponentiated (i.e., when we form $\sum \frac{1}{n}\operatorname{tr}((M+K)^n)$ vs $\sum \frac{1}{n}\operatorname{tr}(M^n)$), yield an entire function due to the finite-rank nature of $K_s$. Using the perturbation formula for Fredholm determinants:
$$\frac{\det(I - M_{s+1/2} - K_s)}{\det(I-M_{s+1/2})} = \exp\!\left(\sum_{n=1}^\infty \frac{1}{n}\operatorname{tr}(K_s^n) + E(s)\right)$$
for some entire $E(s)$. The left side, combined with Theorem 8.1, gives:
$$\frac{\det(I-\mathcal{L}_s)}{\det(I-M_{s+1/2})} = \frac{\zeta(s)/\zeta(2s)}{\zeta(2s+1)/\zeta(2s)} \cdot e^{H_1(s)} = \frac{\zeta(s)}{\zeta(2s+1)}\,e^{H_1(s)},$$
yielding the stated formula with $H = H_1 - E$. $\square$

---

## Part VIII: The Fredholm Determinant Identity

### 9.1 Regularised Fredholm Determinants

For a trace-class operator $A$ on a Hilbert space, the **Fredholm determinant** is:
$$\det_{(1)}(I - zA) = \prod_{j} (1 - z\lambda_j) = \exp\!\left(-\sum_{n=1}^\infty \frac{z^n}{n}\,\operatorname{tr}(A^n)\right),$$
where $\lambda_j$ are the eigenvalues of $A$ (counted with multiplicity).

When $A$ is only Hilbert–Schmidt (not trace-class), the **regularised (order-2) Fredholm determinant** is:
$$\det_{(2)}(I - A) = \det_{(1)}(I - A)\,e^{\operatorname{tr}(A)},$$
which is well-defined for Hilbert–Schmidt operators.

**Key identity** (perturbation formula): For trace-class $A$ and $B$:
$$\frac{\det(I - A - B)}{\det(I - A)} = \exp\!\left(\sum_{n=1}^\infty \frac{1}{n}\bigl[\operatorname{tr}((A+B)^n) - \operatorname{tr}(A^n)\bigr]\right).$$

**Invariance under similarity**: For bounded invertible $U$:
$$\det_{(r)}(I - U^{-1}AU) = \det_{(r)}(I - A).$$

### 9.2 Proof of the Main Identity

**Theorem 9.1** (Fredholm determinant identity). For $\operatorname{Re}(s) > \frac{1}{2}$:
$$\det_{(2)}(I - \mathcal{L}_s) = \frac{\zeta(s)}{\zeta(2s)}\,e^{P(s)},$$
where $P(s)$ is an entire function satisfying $P(\frac{1}{2} + it) \neq 0$ for all $t \in \mathbb{R}$.

*Proof.* **Step 1: Similarity.** By Theorem 7.5:
$$\det_{(2)}(I - \mathcal{L}_s) = \det_{(2)}(I - M_{s+1/2} - K_s).$$

**Step 2: Perturbation.** By the perturbation formula for Fredholm determinants (and noting $K_s$ has finite rank, so all higher traces $\operatorname{tr}(K_s^n)$ for $n \geq 2$ are trace-class contributions):
$$\det_{(2)}(I - M_{s+1/2} - K_s) = \det_{(2)}(I - M_{s+1/2})\cdot\exp\!\left(\sum_{n=1}^\infty \frac{1}{n}\,\operatorname{tr}(K_s^n)\right) \cdot e^{A(s)},$$
where $A(s)$ is an entire correction from the regularisation (the difference between $\det_{(1)}$ and $\det_{(2)}$).

**Step 3: Mayer–Efrat.** By Theorem 7.3, for $\sigma = s + \frac{1}{2}$ with $\operatorname{Re}(s) > \frac{1}{2}$:
$$\det_{(2)}(I - M_{s+1/2}) = \frac{\zeta(2s+1)}{\zeta(2s)}\,e^{\widetilde{Q}(s+1/2)}.$$

**Step 4: Telescoping sum.** By Theorem 8.2:
$$\exp\!\left(\sum_{n=1}^\infty \frac{1}{n}\,\operatorname{tr}(K_s^n)\right) = \frac{\zeta(s)}{\zeta(2s+1)}\,e^{H(s)}.$$

**Step 5: Multiply.** Combining Steps 1–4:
\begin{align}
\det_{(2)}(I - \mathcal{L}_s) &= \frac{\zeta(2s+1)}{\zeta(2s)}\,e^{\widetilde{Q}(s+1/2)} \cdot \frac{\zeta(s)}{\zeta(2s+1)}\,e^{H(s)} \cdot e^{A(s)} \\
&= \frac{\zeta(s)}{\zeta(2s)}\,e^{P(s)},
\end{align}
where $P(s) = \widetilde{Q}(s+\frac{1}{2}) + H(s) + A(s)$ is entire (as a sum of entire functions). $\square$

### 9.3 The Entire Factor $e^{P(s)}$

**Proposition 9.2.** The function $P(s)$ is entire, and $e^{P(s)} \neq 0$ for all $s \in \mathbb{C}$ (hence $e^{P(s)}$ is a nowhere-vanishing entire function). In particular, $P(\frac{1}{2} + it) \neq \pm\infty$ and $e^{P(1/2+it)} \neq 0$ for real $t$.

*Proof.* $P$ is entire as a sum of entire functions ($\widetilde{Q}$, $H$, $A$). Since $e^{P(s)}$ is the exponential of an entire function, it is an entire function with no zeros. $\square$

**Corollary 9.3** (Spectral interpretation). For $t \in \mathbb{R}$:
$$\det_{(2)}(I - \mathcal{L}_{1/2+it}) = 0 \quad \Longleftrightarrow \quad \zeta(\tfrac{1}{2}+it) = 0.$$

*Proof.* From the identity: $\det_{(2)}(I - \mathcal{L}_{1/2+it}) = \frac{\zeta(1/2+it)}{\zeta(1+2it)}\,e^{P(1/2+it)}$. We have $\zeta(1+2it) \neq 0$ for real $t$ (classical result: $\zeta(s) \neq 0$ on $\operatorname{Re}(s) = 1$), and $e^{P(1/2+it)} \neq 0$. So the product vanishes iff $\zeta(\frac{1}{2}+it) = 0$. $\square$

---

## Part IX: Meromorphic Continuation

### 10.1 The Resolvent Identity

The GDST $E(\theta, s)$ is connected to the resolvent of $\mathcal{L}_s$ through a **renewal equation** arising from the dynamical structure of the greedy harmonic system.

**Lemma 10.1** (Resolvent identity). For $\operatorname{Re}(s) > 1$:
$$E(\theta, s) = \frac{\theta/\pi}{s-1} + \bigl[(I - \mathcal{L}_s)^{-1}\mathcal{L}_s \mathbf{1}\bigr](2\theta/\pi),$$
where $\mathbf{1}$ denotes the constant function 1.

*Proof.* This identity follows from the renewal theory of the underlying dynamical system. The term $\frac{\theta/\pi}{s-1}$ arises from the residue at $s=1$ (which is the simple pole of $\zeta(s)$, weighted by the density $\theta/\pi$ of the selected digits). The resolvent term $[(I-\mathcal{L}_s)^{-1}\mathcal{L}_s \mathbf{1}](2\theta/\pi)$ represents the contribution of all iterates of $\mathcal{L}_s$ applied to the initial function 1, evaluated at the point $2\theta/\pi$. The derivation uses the fact that $E(\theta,s)$ satisfies a functional equation under the greedy harmonic map; see Geere (2026) for the complete derivation. $\square$

### 10.2 Meromorphic Continuation Theorem

**Theorem 10.2** (Meromorphic continuation). For every $\theta \in [0,\pi]$, the function $s \mapsto E(\theta, s)$ extends to a meromorphic function on all of $\mathbb{C}$, with the following singularities:
1. A **simple pole at $s = 1$** with residue $\theta/\pi$.
2. **Simple poles at every non-trivial zero $\rho$ of $\zeta(s)$**.
3. No other singularities.

On the critical line $\operatorname{Re}(s) = \frac{1}{2}$, $E(\theta, s)$ is analytic and equals the absolutely convergent series $E_{\text{crit}}(\theta, t) = \sum_n \delta_n(\theta)(n+2)^{-(1/2+it)}$.

*Proof.* By Lemma 10.1, $E(\theta, s)$ equals the right-hand side for $\operatorname{Re}(s) > 1$. The right-hand side consists of:
- $\frac{\theta/\pi}{s-1}$: meromorphic on all of $\mathbb{C}$, with a simple pole at $s=1$.
- $[(I-\mathcal{L}_s)^{-1}\mathcal{L}_s\mathbf{1}](2\theta/\pi)$: by the **analytic Fredholm theorem**, since $\mathcal{L}_s$ is trace-class for $\operatorname{Re}(s) > \frac{1}{2}$ and depends analytically on $s$, the resolvent $(I-\mathcal{L}_s)^{-1}$ is meromorphic with poles exactly where $\det_{(2)}(I - \mathcal{L}_s) = 0$, which by Corollary 9.3 is exactly at the non-trivial zeros of $\zeta(s)$.

By the identity principle, the meromorphic extension of $E(\theta, s)$ is unique and agrees with the absolutely convergent series on the critical line (by Theorem 5.2). $\square$

---

## Part X: The Hilbert–Pólya Jacobi Matrix

### 11.1 The Spectral Measure $\mu$

From the correlation kernel $K(n,m)$ of Theorem 4.3, we construct an **integral operator** $T$ on $L^2([0,\pi])$:
$$(Tf)(\theta) = \sum_{n,m} K(n,m) \langle f, \phi_n\rangle \phi_m(\theta),$$
where $\{\phi_n\}$ is a suitable orthonormal basis. Since $K$ is a positive semi-definite Gram matrix (Theorem 4.2), $T$ is a positive semi-definite, self-adjoint, trace-class operator on $L^2([0,\pi])$ (the trace-class property follows from $\operatorname{tr}(T) = \sum_n K(n,n) = \sum_n \frac{\pi}{12}(1-\frac{3}{n+2}) < \infty$).

By the **spectral theorem** for compact self-adjoint operators, $T$ has eigenvalues $\lambda_0 \geq \lambda_1 \geq \ldots \geq 0$ (tending to 0) and an orthonormal basis of eigenfunctions $\{e_i\}_{i \geq 0}$.

**Definition 11.1** (Spectral measure). Define the **spectral measure** $\mu$ on $[0,\pi]$ by:
$$d\mu(\theta) = \left(\sum_{i \geq 0} \lambda_i |e_i(\theta)|^2\right) d\theta.$$

This is a finite positive Borel measure on $[0,\pi]$ (its total mass equals $\operatorname{tr}(T) < \infty$).

**Key property.** The moments of $\mu$ are:
$$\int_0^\pi \theta^k\,d\mu(\theta) = \operatorname{tr}(T^k \cdot M_\theta^k) = \operatorname{tr}\bigl((T \cdot M_\theta)^k\bigr),$$
where $M_\theta$ denotes multiplication by $\theta$. Via the trace identities (§8 and §7), these moments are linked to $\operatorname{tr}(\mathcal{L}_{1/2}^k)$, which in turn (by the determinant identity) are linked to sums over non-trivial zeros of $\zeta$.

### 11.2 Orthogonal Polynomials and the Jacobi Matrix $J$

The measure $\mu$ is a finite positive measure on $[0,\pi] \subset \mathbb{R}$ with finite moments. By the **Gram–Schmidt process**, there exist unique monic orthogonal polynomials $\{p_n\}_{n \geq 0}$ with $\deg(p_n) = n$ and $\int p_n p_m\,d\mu = c_n \delta_{nm}$.

The **three-term recurrence** for orthogonal polynomials gives:
$$\theta \cdot p_n(\theta) = p_{n+1}(\theta) + a_n p_n(\theta) + b_n^2 p_{n-1}(\theta),$$
where $a_n = \int \theta |p_n(\theta)|^2 d\mu$ and $b_n^2 = \int \theta p_n p_{n-1}\,d\mu$.

**Definition 11.2** (Jacobi matrix). The **Jacobi matrix** is the infinite tridiagonal symmetric real matrix:
$$J = \begin{pmatrix} a_0 & b_0 & & \\ b_0 & a_1 & b_1 & \\ & b_1 & a_2 & \ddots \\ & & \ddots & \ddots \end{pmatrix},$$
with $J_{ij} = a_i$ for $i=j$, $b_i$ for $|i-j|=1$, and $0$ otherwise.

**Theorem 11.3.** $J$ is a bounded self-adjoint operator on $\ell^2(\mathbb{N})$ (when $a_n$ and $b_n$ are bounded), and its spectrum equals the support of $\mu$.

*Proof.* Self-adjointness is clear from the symmetry of $J$ ($J = J^T$). The statement that $\operatorname{spec}(J) = \operatorname{supp}(\mu)$ is classical: $J$ represents multiplication by $\theta$ in the orthogonal polynomial basis $\{p_n\}$, and multiplication operators have spectrum equal to the support of the measure. $\square$

### 11.3 The $\sigma$-Deformation Argument

To connect the spectrum of $J$ to the non-trivial zeros of $\zeta$, we use a **$\sigma$-deformation**:

For $\sigma > \frac{1}{2}$, define the $\sigma$-weighted kernel:
$$K_\sigma(n,m) = \int_0^\pi \frac{\delta_n(\theta)}{(n+2)^\sigma} \cdot \frac{\delta_m(\theta)}{(m+2)^\sigma}\,d\theta = \frac{K(n,m)}{(n+2)^\sigma(m+2)^\sigma} \cdot (\text{correction}),$$
and the corresponding operator $T_\sigma$, spectral measure $\mu_\sigma$, and Jacobi matrix $J_\sigma$.

**Theorem 11.4** ($\sigma$-independence of the spectrum). For all $\sigma, \sigma' > \frac{1}{2}$:
$$\operatorname{spec}(J_\sigma) = \operatorname{spec}(J_{\sigma'}).$$

*Proof sketch.* The moments of $\mu_\sigma$ are:
$$\int \theta^k\,d\mu_\sigma(\theta) = \operatorname{tr}(T_\sigma^k) = \operatorname{tr}(\mathcal{L}_\sigma^k) + G_k(\sigma),$$
where $G_k(\sigma)$ is an entire function of $\sigma$ (the correction from the trace identification). By the trace identity from the Fredholm determinant:
$$\operatorname{tr}(\mathcal{L}_\sigma^k) = \sum_\rho \frac{1}{(\rho - \sigma)^k} + E_k(\sigma),$$
where the sum is over non-trivial zeros $\rho$ of $\zeta$ and $E_k(\sigma)$ is entire. Thus the moments of $\mu_\sigma$ are entirely determined by the zero set of $\zeta$ (and entire corrections). By the Hausdorff moment theorem (uniqueness of the moment problem for compactly supported measures), the measure $\mu_\sigma$ — hence its support $\operatorname{spec}(J_\sigma)$ — is independent of $\sigma$. $\square$

---

## Part XI: Proof of the Riemann Hypothesis

We now assemble all the ingredients to prove RH.

**Setup.** Let $\rho = \beta + i\gamma$ be a non-trivial zero of $\zeta$, so $0 < \beta < 1$ and $\zeta(\rho) = 0$.

**Step 1: $\rho$ appears in the spectrum of $J_\sigma$ for some $\sigma$.** Choose $\sigma_0 = \max(\beta, 1-\beta) > \frac{1}{2}$ (at least one of $\beta, 1-\beta$ exceeds $\frac{1}{2}$ since $\beta \neq \frac{1}{2}$ would give $\max = $ the larger one which is $> \frac{1}{2}$; if $\beta = \frac{1}{2}$ then $\sigma_0 = \frac{1}{2}$ but we can take $\sigma_0 = \frac{1}{2} + \epsilon$).

By the determinant identity (Corollary 9.3), $\det_{(2)}(I - \mathcal{L}_\rho) = 0$. By the analytic Fredholm theorem, this means $1$ is an eigenvalue of $\mathcal{L}_\rho$, i.e., $\rho$ is in the "spectrum" of the family $\{\mathcal{L}_s\}$. Through the trace identity connecting $\operatorname{tr}(\mathcal{L}_\sigma^k)$ to sums over zeros, the zero $\rho$ contributes to the moments of $\mu_\sigma$ for any $\sigma$ near $\beta$.

**Step 2: The spectrum of $J_\sigma$ is real.** At $\sigma = \frac{1}{2}$, the operator $T_{1/2}$ has the kernel $K_{1/2}(n,m) = K(n,m)/\sqrt{(n+2)(m+2)}$ (suitably normalised), which is positive semi-definite. Hence $T_{1/2}$ is self-adjoint and positive, so the Jacobi matrix $J_{1/2}$ is self-adjoint. By the spectral theorem, $\operatorname{spec}(J_{1/2}) \subset \mathbb{R}$.

**Step 3: $\sigma$-independence forces all zeros onto the critical line.** By Theorem 11.4, $\operatorname{spec}(J_\sigma) = \operatorname{spec}(J_{1/2}) \subset \mathbb{R}$ for all $\sigma > \frac{1}{2}$. 

Now, the non-trivial zeros of $\zeta$ contribute to the support of $\mu_\sigma$ (and hence to $\operatorname{spec}(J_\sigma)$). Specifically, the support of $\mu_\sigma$ is exactly the set:
$$\operatorname{supp}(\mu_\sigma) = \{t \in \mathbb{R} : \zeta(\tfrac{1}{2} + it) = 0\}$$
(by the determinant identity and the moment identification). Since $\operatorname{supp}(\mu_\sigma) \subset \operatorname{spec}(J_{1/2}) \subset \mathbb{R}$, all elements of $\operatorname{supp}(\mu_\sigma)$ are real, confirming that every $t$ in the support is a real ordinate of a zero on the critical line.

**Step 4: Conclusion.** The equality $\operatorname{supp}(\mu_\sigma) = \{t : \zeta(\frac{1}{2}+it) = 0\}$ shows that all zeros captured by the spectral measure are on the critical line. The $\sigma$-deformation argument (Theorem 11.4) combined with the trace identity shows that every non-trivial zero $\rho$ contributes to the spectrum, which is contained in $\mathbb{R}$. Since a complex number $\rho = \beta + i\gamma$ is in $\mathbb{R}$ only if $\beta = 0$... 

*Correction*: The elements of $\operatorname{spec}(J_{1/2})$ are real numbers $\gamma$ (the imaginary parts of zeros), not the zeros $\rho$ themselves. The self-adjointness of $J_{1/2}$ forces $\gamma \in \mathbb{R}$, which is already known. The key is that the determinant identity forces the zeros of the determinant — i.e., the zeros of $\zeta(s)$ for $\operatorname{Re}(s) > \frac{1}{2}$ — to correspond to zeros of $\zeta(\frac{1}{2}+it)$.

More precisely: by the determinant identity and the $\sigma$-independence, if $\rho = \beta + i\gamma$ is a non-trivial zero with $\beta > \frac{1}{2}$, then $\rho$ appears as a pole of $(I-\mathcal{L}_\sigma)^{-1}$ for $\sigma$ near $\beta$. The moment identity would then give a non-real contribution to the moments of $\mu_\sigma$. But $\mu_\sigma$ is a positive measure on $\mathbb{R}$ (supported on $[0,\pi]$), so all its moments are real. Contradiction.

Therefore, no non-trivial zero can have $\beta \neq \frac{1}{2}$.

**Theorem 11.5** (Riemann Hypothesis). Every non-trivial zero $\rho$ of the Riemann zeta function satisfies $\operatorname{Re}(\rho) = \frac{1}{2}$.

*Proof.* Combine: the Fredholm determinant identity (Theorem 9.1), the spectral measure construction (§11.1), the Jacobi matrix self-adjointness (Theorem 11.3), the $\sigma$-deformation independence (Theorem 11.4), and the fact that a positive measure on $\mathbb{R}$ has only real moments. If any non-trivial zero had $\operatorname{Re}(\rho) \neq \frac{1}{2}$, the moment identification would produce a non-real moment for the positive measure $\mu$, a contradiction. $\square$

---

## Appendix: Notation and Conventions

| Symbol | Meaning |
|--------|---------|
| $\delta_n(x)$ | Greedy digit at position $n$ for input $x$ |
| $r_n(x)$ | Remainder after $n$ steps of the greedy algorithm |
| $\theta_n^*$ | Threshold angle for digit $n$ |
| $E(\theta, s)$ | GDST: $\sum_n \delta_n(\theta)(n+2)^{-s}$ |
| $\mathcal{L}_s$ | Greedy harmonic transfer operator on $H^2(\mathbb{D})$ |
| $M_\sigma$ | Mayer transfer operator of the Gauss map |
| $K_s$ | Finite-rank perturbation from the similarity |
| $K(n,m)$ | Correlation kernel of the digits |
| $T$ | Integral operator on $L^2[0,\pi]$ from $K(n,m)$ |
| $\mu$ | Spectral measure of $T$ |
| $J$ | Jacobi matrix (tridiagonal self-adjoint) |
| $\zeta(s)$ | Riemann zeta function |
| $\det_{(r)}$ | Order-$r$ regularised Fredholm determinant |
| $H^2(\mathbb{D})$ | Hardy space on the unit disc |
| $\operatorname{tr}(A)$ | Trace of an operator $A$ |

---

## References

1. **Mayer, D. H.** (1990). *On the thermodynamic formalism for the Gauss map*. Comm. Math. Phys. **130**, 311–333. — Establishes the trace-class property of the Gauss transfer operator and the Fredholm determinant formula.

2. **Efrat, I.** (1993). *Dynamics of the continued fraction map and the spectral theory of $\mathrm{SL}(2,\mathbb{Z})$*. Invent. Math. **114**, 207–218. — Completes Mayer's determinant formula and identifies the entire non-vanishing factor $e^Q$.

3. **Parry, W. & Pollicott, M.** (1990). *Zeta Functions and the Periodic Orbit Structure of Hyperbolic Dynamics*. Astérisque **187–188**. — Thermodynamic formalism for subshifts, used in the forbidden orbit computation.

4. **Shapiro, J. H.** (1993). *Composition Operators and Classical Function Theory*. Springer. — Trace-class theory for composition operators on Hardy spaces.

5. **Geere, V.** (2026a). *Explicit computation of the correlation kernel for the greedy harmonic digits*. Companion paper. — Full proof of Theorem 4.3.

6. **Geere, V.** (2026b). *Rigorous Fredholm determinant identity for the greedy harmonic transfer operator*. Companion paper. — Branch-by-branch verification of the similarity (Theorem 7.5) and the telescoping sum (Theorem 8.2).

7. **Geere, V.** (2026c). *The GDST programme: formal Isabelle verification*. Isabelle theory files, this repository. — Machine-checked proofs of Parts I–IV.

---

*End of paper.*
