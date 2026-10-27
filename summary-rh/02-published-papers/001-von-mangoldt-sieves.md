# 001 — Sieves for the von Mangoldt Function

| Field | Value |
|---|---|
| Source | [`research/publish/001-von-mangoldt-sieves/manuscript.md`](../rh/research/publish/001-von-mangoldt-sieves/manuscript.md) |
| Status | Published first edition; 7 theorems, Lean companion. |
| Harvested statements | 14 |

## Abstract

The von Mangoldt function $\Lambda$ is $\log p$ on the powers of a prime $p$ and $0$
elsewhere. It is the coefficient function of the logarithmic derivative of the Riemann zeta
function, the increment of Chebyshev's function $\psi$, and the weight on the prime side of
the explicit formula. This paper gives three elementary sieves that produce the entire table
$(\Lambda(1),\dots,\Lambda(N))$ — a prime-power marking sieve, a divisor-sum sieve, and a
Möbius-convolution sieve — with complete correctness proofs and complexity bounds, and it
gives the divisor-sum sieve in an *integer form* in which the vanishing of $\Lambda(n)$ is
decided by integer arithmetic alone, logarithms being needed only to report a value. The
support of $\Lambda$, its values on prime powers, the divisor identity
$\sum_{d\mid n}\Lambda(d)=\log n$, its Möbius inversion $\Lambda=\mu\ast\log$, the fact that
$\Lambda$ is neither additive nor multiplicative (witnesses $6=2\cdot 3$ and $4=2\cdot 2$),
and the bound $\Lambda(n)\le\log n$ are **PROVED** in Lean 4 / Mathlib by
`VonMangoldtSieves.lean`; the divisor identity and the lcm identity
$\exp\psi(n)=\operatorname{lcm}(1,\dots,n)$ are also **VERIFIED** numerically by
`von_mangoldt_sieves.py`, whose tables of $\psi(10^k)$ are **MEASURED**. The paper's own
identities are **PROVED** in its text. Nothing here proves the twin prime conjecture: as the
programme ledger records, this work leaves the twin-prime and parity questions untouched.

## Harvested theorem-like statements

### Proposition 2.1 (support). — PROVED (paper) and PROVED (Lean).

$\Lambda(n)\ne 0$ if and only if $n$ is a power of a prime. Moreover
$\Lambda(p^{k})=\log p$ for every $k\ge 1$: $\Lambda$ is constant along the powers of each
prime.

*Proof (paper).* Immediate from the definition: the prime powers $p^{k}$ with $p$ fixed have
the same logarithm $\log p$, and every $n$ with at least two distinct prime divisors is
assigned $0$. $\blacksquare$

*Lean.* `support_ne_zero_iff : Λ n ≠ 0 ↔ IsPrimePow n` (the companion's docstring records that
this is Mathlib's `vonMangoldt_ne_zero_iff`) and
`apply_prime_pow (p k : ℕ) (hp : p.Prime) (hk : k ≠ 0) : Λ (p ^ k) = Real.log p`, proved from
`vonMangoldt_apply_pow hk` and `vonMangoldt_apply_prime hp`. Both are in
[`VonMangoldtSieves.lean`](../rh/research/publish/001-von-mangoldt-sieves/VonMangoldtSieves.lean), lines 28 and 33–35; the ledger §11 records
the same two rows (the ledger's prime-power row is the abbreviation `Λ(pᵏ) = log p`, the Lean
statement carries the side condition $k\ne 0$).

### Proposition 2.2 (divisor identity). — PROVED (paper) and PROVED (Lean).

For every $n\ge 1$,
$$\sum_{d\mid n}\Lambda(d)=\log n .$$

*Proof (paper).* For $n=1$ both sides are $0$. Let $n=\prod_{i=1}^{r}p_{i}^{a_{i}}$ be the
prime factorization. A divisor $d$ has $\Lambda(d)\ne 0$ exactly when $d=p_{i}^{j}$ for some
$i$ and $1\le j\le a_{i}$ (Proposition 2.1), and then $\Lambda(d)=\log p_{i}$. Hence
$$\sum_{d\mid n}\Lambda(d)=\sum_{i=1}^{r}\sum_{j=1}^{a_{i}}\log p_{i}=\sum_{i=1}^{r}a_{i}\log p_{i}=\log n . \qquad\blacksquare$$

*Lean.* `divisor_identity (n : ℕ) : ∑ d ∈ n.divisors, Λ d = Real.log n`, proved by Mathlib's
`vonMangoldt_sum` (companion lines 40–41). The companion's docstring calls this "the single
identity underlying the divisor-sum sieve of §3.2".

Proposition 2.2 says $\Lambda\ast 1=\log$, where $\ast$ is Dirichlet convolution. Möbius
inversion ($\mu\ast 1=\epsilon$, the identity of the convolution algebra [5, Thm. 2.1]) turns
it into an explicit formula.

### Corollary 2.3. — PROVED (paper) and PROVED (Lean).

For every $n\ge 1$,
$$\Lambda(n)=\sum_{d\mid n}\mu(d)\log(n/d)=-\sum_{d\mid n}\mu(d)\log d,$$
that is, $\Lambda=\mu\ast\log$.

*Proof (paper).* Convolve $\Lambda=\log\ast\mu$ with $1$; this is the Möbius inversion of
Proposition 2.2. The second form uses $\sum_{d\mid n}\mu(d)=0$ for $n>1$. $\blacksquare$

*Lean.* `moebius_convolution : (↑moebius : ArithmeticFunction ℝ) * log = Λ`, proved by
Mathlib's `moebius_mul_log_eq_vonMangoldt` (companion lines 44–46).

### Proposition 2.4. — PROVED (paper) and PROVED (Lean).

$\Lambda$ is neither additive nor
multiplicative.

*Proof (paper).* At $n=6=2\cdot 3$: $\Lambda(6)=0$, whereas
$\Lambda(2)+\Lambda(3)=\log 2+\log 3=\log 6\ne 0$ and
$\Lambda(2)\Lambda(3)=(\log 2)(\log 3)\ne 0$. $\blacksquare$

*Lean.* The companion formalises additivity and multiplicativity as the negations of the
defining equations for the single pair used:
`not_additive : ∃ m n : ℕ, Λ (m * n) ≠ Λ m + Λ n` with witness $(m,n)=(2,3)$, where
$\Lambda 6=0$ is obtained from `vonMangoldt_eq_zero_iff` and the rest from
`vonMangoldt_apply_prime` together with $\log 2+\log 3=\log 6$ and $\log 6>0$; and
`not_multiplicative : ∃ m n : ℕ, Λ (m * n) ≠ Λ m * Λ n` with witness $(m,n)=(2,2)$, where
$\Lambda 4=\log 2$ is obtained from `vonMangoldt_apply_pow` and the two values are separated by
$0<\log 2<1$ (Mathlib's `Real.log_two_gt_d9`, `Real.log_two_lt_d9`). The two witnesses are the
ones the Lean file records; the paper's single displayed witness is $6=2\cdot 3$.

The paper comments that this is the structural reason why the algorithms below either mark
prime powers directly or use the divisor identity: a recurrence that multiplies or adds values
attached to the *primes* of $n$ computes an additive or multiplicative function, and $\Lambda$
is neither. The additive function that carries the same information on prime powers is worth
naming.

### Proposition 2.5 (the additive sibling). — PROVED (paper).

Let
$L(n)=\log\operatorname{rad}(n)=\sum_{p\mid n}\log p$ for $n\ge 1$ ($L(1)=0$). Then:

1. $L$ is additive on coprime arguments: $L(mn)=L(m)+L(n)$ when $\gcd(m,n)=1$; it is the
   unique additive function with $L(p)=\log p$;
2. $L$ and $\Lambda$ agree exactly on the prime powers and on $n=1$, and differ at every $n$
   with at least two distinct prime divisors;
3. $\sum_{n\le x}L(n)=\sum_{p\le x}\log p\cdot\lfloor x/p\rfloor$, whereas
   $\psi(x)=\sum_{p^{k}\le x}\log p$.

*Proof (paper).* (i) $\operatorname{rad}(mn)=\operatorname{rad}(m)\operatorname{rad}(n)$ for
coprime $m,n$; an additive function is determined by its values on prime powers, and
$L(p^{k})=\log p=L(p)$. (ii) If $n=p^{k}$ then $\operatorname{rad}(n)=p$ and
$L(n)=\log p=\Lambda(n)$; if $n$ has $r\ge 2$ distinct prime divisors then $\Lambda(n)=0$
while $L(n)>0$. (iii) Exchange the order of summation:
$\sum_{n\le x}\sum_{p\mid n}\log p=\sum_{p\le x}\log p\cdot\#\{n\le x: p\mid n\}=\sum_{p\le x}\log p\cdot\lfloor x/p\rfloor$. $\blacksquare$

The paper notes that Proposition 2.5 "is a statement about two different functions and their
exact domains of agreement; it is the reason the integer form of §3.2 tests an integer against
$1$ rather than testing an additive recurrence."

### Proposition 2.4+ (elementary bound, Lean only). — PROVED (Lean).

$\Lambda(n)\le\log n$. Lean: `le_log (n : ℕ) : Λ n ≤ Real.log (n : ℝ)`, proved by Mathlib's
`vonMangoldt_le_log` (companion lines 76–79). This bound is not numbered as a proposition in
the paper; it appears only in the companion, whose docstring labels it "Proposition 2.4".

### Proposition 2.6. — PROVED (paper); its lcm consequence also VERIFIED numerically.

For
every real $x\ge 1$,
$$\psi(x)=\sum_{p^{k}\le x}\log p=\log\operatorname{lcm}(1,2,\dots,\lfloor x\rfloor).$$

*Proof (paper).* Every prime power $p^{k}\le x$ satisfies $p\le\lfloor x\rfloor$, and
$p^{k}\le\lfloor x\rfloor$ conversely. Hence
$$\psi(x)=\sum_{p\le\lfloor x\rfloor}\Bigl(\max\{k: p^{k}\le\lfloor x\rfloor\}\Bigr)\log p=\log\prod_{p\le\lfloor x\rfloor}p^{\lfloor\log_{p}\lfloor x\rfloor\rfloor},$$
and the last product is the least common multiple of $1,\dots,\lfloor x\rfloor$.
$\blacksquare$

### Proposition 2.7. — PROVED (paper).

For every $x\ge 1$,
$\psi(x)=\sum_{k\ge 1}\theta(x^{1/k})$, the sum being finite (all terms with $k>\log_{2}x$
vanish).

*Proof (paper).* Group the prime powers in Proposition 2.6 by the exponent $k$: the $k$-th
group is $\sum_{p\le x^{1/k}}\log p=\theta(x^{1/k})$. $\blacksquare$

### Proposition 2.8. — PROVED (paper).

For $\operatorname{Re}s>1$,
$$-\frac{\zeta'(s)}{\zeta(s)}=\sum_{n\ge 1}\Lambda(n)n^{-s}.$$

*Proof (paper).* Absolute convergence for $\operatorname{Re}s>1$ allows termwise
differentiation of the Euler product. Taking logarithms,
$\log\zeta(s)=\sum_{p}-\log(1-p^{-s})=\sum_{p}\sum_{k\ge 1}p^{-ks}/k$, and differentiating
gives
$-\zeta'(s)/\zeta(s)=\sum_{p}\sum_{k\ge 1}(\log p)p^{-ks}=\sum_{n\ge 1}\Lambda(n)n^{-s}$.
$\blacksquare$

### Theorem 3.1 (correctness of Algorithm A). — PROVED (paper).

The array returned by
`von_mangoldt(N)` satisfies `lam[n] = Λ(n)` for all $1\le n\le N$.

*Proof (paper).* The inner assignments write only at indices of the form $p^{k}$, so `lam[n]`
is changed only if $n$ is a prime power, and then it is set to $\log p$. It remains to see that
every prime power is written exactly once, and with the correct value. Let $n=q^{k}$. Since
`is_p[q]` is true when the outer loop reaches $q$ (the Eratosthenes table is correct), the
while loop writes `lam[q^k] = log q`. If also $n=r^{j}$ with $r\ne q$ prime, then $n$ would
have the two distinct prime divisors $q,r$, contradicting $n=q^{k}$. Hence each prime power is
written once, with the value required by the definition. $\blacksquare$

**Complexity (paper).** The primality sieve costs $O(N\log\log N)$ operations and $O(N)$ bits.
The marking loop runs once per prime power $\le N$; their number is
$\pi(N)+\pi(N^{1/2})+\cdots=O(N/\log N)$. Total time $O(N\log\log N)$, memory $O(N)$ (or
$O(N/\log N)$ bits for the prime table if `lam` is stored separately).

### Theorem 3.2 (correctness of Algorithm B). — PROVED (paper).

For all $1\le n\le N$,
`lam[n] = Λ(n)`.

*Proof (paper).* By strong induction on $n$. For $n=1$, `acc[1] = 0` and `lam[1] = log 1 = 0`.
For $n\ge 2$, assume the claim for all $d<n$. Every proper divisor $d$ of $n$ is $<n$, and at
its own step it added $\Lambda(d)$ to `acc[n]`; no other contribution is made. Hence
`acc[n] = ∑_{d|n, d<n} Λ(d)`, and Proposition 2.2 gives
$\log n-\texttt{acc[n]}=\sum_{d\mid n}\Lambda(d)-\sum_{d\mid n,\,d<n}\Lambda(d)=\Lambda(n)$.
$\blacksquare$

**Complexity (paper).** The inner loop makes
$\sum_{n\le N}(\lfloor N/n\rfloor-1)=O(N\log N)$ additions, and no multiplications; memory
$O(N)$.

### Theorem 3.3 (integer detection of prime powers). — PROVED (paper).

For every $n\ge 1$,
$$N(n)=\frac{n}{P(n)}=\begin{cases}1,& n\text{ is not a prime power},\\ p,& n=p^{k}\text{ is a prime power}.\end{cases}$$
Consequently $\Lambda(n)=0$ if $N(n)=1$, and $\Lambda(n)=\log N(n)$ otherwise, with $N(n)$
prime in that case.

*Proof (paper).* By Proposition 2.2, $P(n)=n/\exp\Lambda(n)$. If $n=p^{k}$ then
$\exp\Lambda(n)=p$ and $N(n)=p$. If $n$ is not a prime power then $\exp\Lambda(n)=1$ and
$N(n)=n$. (Equivalently, every divisor $d<n$ contributing a nontrivial factor to $P(n)$ is
itself a prime power $p^{j}$, and the total $p$-adic valuation of $P(n)$ is $v_{p}(n)$ when
some other prime divides $n$, and $v_{p}(n)-1$ when $n=p^{k}$.) $\blacksquare$

```python
def von_mangoldt_integer(N):
    # exact: P[n] is an integer, N(n) = n // P[n] is 1 or a prime
    P   = [1] * (N + 1)             # P[n] = prod_{d|n, d<n} exp(Lambda(d))
    lam = [0.0] * (N + 1)
    for n in range(2, N + 1):
        q = n // P[n]               # integer division; divides exactly
        if q != 1:                  # q is prime
            lam[n] = log(q)
        for m in range(2 * n, N + 1, n):
            P[m] *= q               # q = exp(Lambda(n)); q = 1 is a no-op
    return lam
```

**Example (paper).** $P(2)=P(3)=1$, so $N(2)=2$, $N(3)=3$ and $\Lambda(2)=\log 2$,
$\Lambda(3)=\log 3$. Then $P(6)=2\cdot 3=6$, so $N(6)=1$ and $\Lambda(6)=0$; while $P(4)=2$,
so $N(4)=2$ and $\Lambda(4)=\log 2$. The integer $N(n)$ always fits in $[1,n]$, so all updates
are exact in machine integers for $N_{\text{bound}}$ below the word-size limit, and in
arbitrary precision beyond it.

### Proposition 3.4. — PROVED (paper).

The returned array satisfies `lam[n] = Λ(n)` for all
$n\le N$.

*Proof (paper).* The linear sieve returns the Möbius function [8]; the double loop accumulates
$\sum_{d\mid n}\mu(d)\log(n/d)$, which is $\Lambda(n)$ by Corollary 2.3. $\blacksquare$

**Complexity (paper).** The sieve is $O(N)$; the convolution is
$\sum_{d\le N}N/d=O(N\log N)$ operations. This route uses real logarithms of integers inside
the convolution; for exact output it should be run in a symbolic or sufficiently precise
arithmetic, or replaced by Algorithm B′ above, whose decisions are integral.

### Exact checks (paper §4.3).

Proposition 2.6 gives $\exp\psi(10)=2520=\operatorname{lcm}(1,\dots,10)$
and $\exp\psi(20)=232792560=\operatorname{lcm}(1,\dots,20)$; the paper states that both
identities hold for the computed table. The convergence of $\psi(x)/x$ to $1$ visible in the
last column is the prime number theorem [4, 5]; the paper notes that quantitative versions are
in [7].

**Summary and complexity (paper §6).**

| algorithm | output | arithmetic | time | memory |
|---|---|---|---|---|
| A. prime-power marking | $\Lambda(n)$ | integer decisions, $\log$ to report | $O(N\log\log N)$ | $O(N)$ |
| B. divisor sum | $\Lambda(n)$ | real (symbolic for exactness) | $O(N\log N)$ | $O(N)$ |
| B′. divisor sum, integer form | $\Lambda(n)$ | exact integers, $\log$ to report | $O(N\log N)$ | $O(N)$ |
| C. Möbius convolution | $\Lambda(n)$ | real (symbolic for exactness) | $O(N\log N)$ | $O(N)$ |

As the paper puts it: for a single table the prime-power marking sieve (Algorithm A) is the
method of choice — it is shortest, fastest, and its decisions are integral. The divisor-sum
sieve is preferable when the implementation should avoid a factorization table entirely, or
when $\Lambda$ is wanted one value at a time: Algorithm B′ computes $\Lambda(n)$ from $P(n)$,
an integer in $[1,n]$, with the test $P(n)<n\iff n$ is a prime power. All three methods are
certified by the divisor identity of Proposition 2.2, which is the single mathematical fact
underlying the computation.

## Source

[`manuscript.md`](../rh/research/publish/001-von-mangoldt-sieves/manuscript.md) · [`README.md`](../rh/research/publish/001-von-mangoldt-sieves/README.md)
