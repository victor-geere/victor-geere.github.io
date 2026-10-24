# Sieves for the von Mangoldt Function

**First edition.** This is the first edition of the paper *Sieves for the von Mangoldt
Function*, packaged from the folder `research/publish/001-von-mangoldt-sieves`. The
authoritative text is the folder's own paper [`von-mangoldt-sieves.html`](von-mangoldt-sieves.html),
which is headed "First edition"; the companion files are [`README.md`](README.md),
[`von_mangoldt_sieves.py`](von_mangoldt_sieves.py) (reference implementation and self-check)
and [`VonMangoldtSieves.lean`](VonMangoldtSieves.lean) (Lean 4 / Mathlib companion). The same
item is recorded as §11 of the programme ledger `../../truths.md`; the item-number packaging
of that ledger is the second edition in `../011-von-mangoldt-sieves`. Every statement, value
and code listing below is carried by the files named in **Sources**; the mathematics is
restated here in TeX from the HTML paper.

**Keywords:** von Mangoldt function; von Mangoldt sieve; Chebyshev $\psi$ and $\theta$;
Euler product; logarithmic derivative of $\zeta$; Möbius inversion; linear sieve; additive
functions; least common multiple.

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

## 1. Introduction and goal

Let $\Lambda:\mathbb{N}\to\mathbb{R}$ be the function introduced by von Mangoldt [1] in his
proof that Chebyshev's function has the asymptotic behaviour predicted by the prime number
theorem:

$$\Lambda(1)=0,\qquad \Lambda(n)=\log p \ \text{ if } n=p^{k}\ (p \text{ prime},\ k\ge 1),\qquad \Lambda(n)=0\ \text{ otherwise.}$$

Three properties make it ubiquitous. First, its summatory function is Chebyshev's $\psi$,
and $\psi(x)\sim x$ is equivalent to the prime number theorem [4, 5]. Second, it is the
coefficient function of $-\zeta'/\zeta$:
$-\zeta'(\sigma)/\zeta(\sigma)=\sum_{n\ge 1}\Lambda(n)n^{-\sigma}$ for $\sigma>1$. Third,
it weights the prime side of the explicit formula and of Chebyshev-type bounds [6, 7].

The practical problem addressed in this folder is entirely elementary and, as the paper puts
it, completely solvable: *produce the whole table $\Lambda(1),\dots,\Lambda(N)$ exactly, and
cheaply*. Because $\Lambda(n)$ is $0$ or the logarithm of a prime, the table carries only
integer information; only the final presentation as a real number involves a logarithm. The
paper gives three sieves and proves them correct:

* the **prime-power marking sieve** (§3.1 of the paper; Algorithm A), simplest and fastest;
* the **divisor-sum sieve** (paper §3.2; Algorithm B), which needs no factoring and has an
  exact integer form (Algorithm B′);
* the **Möbius-convolution sieve** (paper §3.3; Algorithm C), a direct realisation of
  $\Lambda=\mu\ast\log$.

Paper §3.4 recalls the linear sieve for multiplicative functions and explains why it does not
by itself cover $\Lambda$ — a point that matters when choosing an implementation. Paper §4
collects the exact identities that make each output checkable, and paper §5 lists the standard
uses.

The goal of the folder is therefore twofold, and both parts are in scope here: to record the
elementary identities that make $\Lambda$ computable, and to record the exact sieves together
with the checks that certify their output. The folder also contains the two artefacts needed
to reproduce those claims: a Python 3 reference implementation with a self-check, and a Lean 4
companion that formalises the identities of paper §2 in Mathlib.

This manuscript is an exposition of material that already exists in the folder. No claim below
is stronger than the file it is attributed to.

## 2. Setup and definitions

**Numbers and functions.**

* $\mathbb{N}$ denotes the positive integers $\{1,2,3,\dots\}$ as used by the paper text; the
  Lean companion works in Lean's `ℕ`, which contains $0$, where `Λ 0 = 0`. All statements about
  $\Lambda$ below are for $n\ge 1$.
* $\mathbb{R}$ is the field of real numbers, $\mathbb{C}$ the complex numbers, and $\log$ is
  the natural logarithm. $\exp$ is its inverse, so $\exp(\Lambda(n))$ is a positive real; by
  Proposition 2.1 below it is $1$ or a prime.
* $p,q,r$ denote primes. $n$ is a **prime power** if $n=p^{k}$ for a prime $p$ and an exponent
  $k\ge 1$. $\operatorname{IsPrimePow} n$ is the corresponding Mathlib predicate.
* $p\mid n$ means $p$ divides $n$, and $p\nmid n$ means it does not. $v_{p}(n)$ is the exponent
  of $p$ in $n$. $\lfloor x\rfloor$ is the integer part of the real number $x$.
* $\operatorname{rad}(n)=\prod_{p\mid n}p$ is the radical of $n$ (the product of its distinct
  prime divisors), and $\operatorname{lcm}(1,\dots,m)$ is the least common multiple.
* $\zeta$ is the Riemann zeta function, $\zeta'$ its derivative, and $\operatorname{Re}s$ the
  real part of $s\in\mathbb{C}$.
* $O(\cdot)$ is the usual asymptotic notation; $\pi(N)$ is the number of primes $\le N$.

**The von Mangoldt function.** $\Lambda:\mathbb{N}\to\mathbb{R}$ is defined by
$$\Lambda(n)=\begin{cases}\log p,& n=p^{k},\ p\text{ prime},\ k\ge 1,\\ 0,&\text{otherwise,}\end{cases}\qquad \Lambda(1)=0 .$$
Equivalently, $\Lambda(n)=\log p$ if $n$ is a power of the prime $p$, and $\Lambda(n)=0$
otherwise.

**Arithmetic functions.** An arithmetic function $f$ is *additive* if $f(mn)=f(m)+f(n)$
whenever $\gcd(m,n)=1$, and *multiplicative* if $f(mn)=f(m)f(n)$ whenever $\gcd(m,n)=1$.
$\mu$ is the Möbius function, and $\epsilon$ is the identity of the Dirichlet convolution
algebra: $\epsilon(1)=1$ and $\epsilon(n)=0$ for $n>1$. The **Dirichlet convolution** is
$(f\ast g)(n)=\sum_{d\mid n}f(d)g(n/d)$; it is associative and commutative, and $\mu\ast 1=\epsilon$,
where $1$ is the constant function $1$. Write also $\log$ for the arithmetic function $n\mapsto\log n$.

**The additive sibling.** $L$ is the function
$$L(n)=\log\operatorname{rad}(n)=\sum_{p\mid n}\log p\qquad (n\ge 1),\qquad L(1)=0 .$$

**Chebyshev's functions.**
$$\psi(x)=\sum_{n\le x}\Lambda(n),\qquad \theta(x)=\sum_{p\le x}\log p .$$

**Sieve inputs and outputs.** $N\ge 2$ is the table bound. Each algorithm fills an array
`lam[1..N]` whose entry `lam[n]` is the value $\Lambda(n)$; the Python reference
implementation instead stores, for each $n$, the integer *decision plus prime*:
`tab[n] = 0` if $\Lambda(n)=0$, and `tab[n] = p` if $n=p^{k}$. Reporting $\Lambda(n)$ from
`tab` is then a matter of taking $\log$ of the stored prime. This is the paper's point that
the table carries integer information only.

**The integer-detection quotient.** For $n\ge 1$ put
$$P(n):=\prod_{d\mid n,\ d<n}\exp\Lambda(d),\qquad N(n):=\frac{n}{P(n)} .$$
**Warning on notation.** The paper (and this manuscript, keeping its symbols) uses $N$ for the
table bound and $N(n)$ for this quotient. They are different objects; where the two could be
confused we write $N_{\text{bound}}$ for the table bound.

**Statuses used below.** **PROVED** means a proof is written out in the paper text, or a Lean
theorem is stated and elaborated (Mathlib theorems invoked by the companion are named where
used). **VERIFIED** marks a numerical check run by the folder's script with the observed
outcome reported in §4. **MEASURED** marks numbers produced by a computation and reported with
their scale.

## 3. Results

The paper numbers its results; the numbering is kept. Statuses are as in the sources. Paper
§2 is "The function $\Lambda$ and its identities"; paper §3 is "Three exact sieves".

### 3.1 Support, values and the two identities (paper §2.1–2.3)

**Proposition 2.1 (support). — PROVED (paper) and PROVED (Lean).**
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
[`VonMangoldtSieves.lean`](VonMangoldtSieves.lean), lines 28 and 33–35; the ledger §11 records
the same two rows (the ledger's prime-power row is the abbreviation `Λ(pᵏ) = log p`, the Lean
statement carries the side condition $k\ne 0$).

**Proposition 2.2 (divisor identity). — PROVED (paper) and PROVED (Lean).**
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

**Corollary 2.3. — PROVED (paper) and PROVED (Lean).** For every $n\ge 1$,
$$\Lambda(n)=\sum_{d\mid n}\mu(d)\log(n/d)=-\sum_{d\mid n}\mu(d)\log d,$$
that is, $\Lambda=\mu\ast\log$.

*Proof (paper).* Convolve $\Lambda=\log\ast\mu$ with $1$; this is the Möbius inversion of
Proposition 2.2. The second form uses $\sum_{d\mid n}\mu(d)=0$ for $n>1$. $\blacksquare$

*Lean.* `moebius_convolution : (↑moebius : ArithmeticFunction ℝ) * log = Λ`, proved by
Mathlib's `moebius_mul_log_eq_vonMangoldt` (companion lines 44–46).

**Proposition 2.4. — PROVED (paper) and PROVED (Lean).** $\Lambda$ is neither additive nor
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

**Proposition 2.5 (the additive sibling). — PROVED (paper).** Let
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

**Proposition 2.4+ (elementary bound, Lean only). — PROVED (Lean).**
$\Lambda(n)\le\log n$. Lean: `le_log (n : ℕ) : Λ n ≤ Real.log (n : ℝ)`, proved by Mathlib's
`vonMangoldt_le_log` (companion lines 76–79). This bound is not numbered as a proposition in
the paper; it appears only in the companion, whose docstring labels it "Proposition 2.4".

### 3.2 Chebyshev's functions and the Dirichlet series (paper §2.4–2.5)

Define $\psi(x)=\sum_{n\le x}\Lambda(n)$ and $\theta(x)=\sum_{p\le x}\log p$.

**Proposition 2.6. — PROVED (paper); its lcm consequence also VERIFIED numerically.** For
every real $x\ge 1$,
$$\psi(x)=\sum_{p^{k}\le x}\log p=\log\operatorname{lcm}(1,2,\dots,\lfloor x\rfloor).$$

*Proof (paper).* Every prime power $p^{k}\le x$ satisfies $p\le\lfloor x\rfloor$, and
$p^{k}\le\lfloor x\rfloor$ conversely. Hence
$$\psi(x)=\sum_{p\le\lfloor x\rfloor}\Bigl(\max\{k: p^{k}\le\lfloor x\rfloor\}\Bigr)\log p=\log\prod_{p\le\lfloor x\rfloor}p^{\lfloor\log_{p}\lfloor x\rfloor\rfloor},$$
and the last product is the least common multiple of $1,\dots,\lfloor x\rfloor$.
$\blacksquare$

**Proposition 2.7. — PROVED (paper).** For every $x\ge 1$,
$\psi(x)=\sum_{k\ge 1}\theta(x^{1/k})$, the sum being finite (all terms with $k>\log_{2}x$
vanish).

*Proof (paper).* Group the prime powers in Proposition 2.6 by the exponent $k$: the $k$-th
group is $\sum_{p\le x^{1/k}}\log p=\theta(x^{1/k})$. $\blacksquare$

**Proposition 2.8. — PROVED (paper).** For $\operatorname{Re}s>1$,
$$-\frac{\zeta'(s)}{\zeta(s)}=\sum_{n\ge 1}\Lambda(n)n^{-s}.$$

*Proof (paper).* Absolute convergence for $\operatorname{Re}s>1$ allows termwise
differentiation of the Euler product. Taking logarithms,
$\log\zeta(s)=\sum_{p}-\log(1-p^{-s})=\sum_{p}\sum_{k\ge 1}p^{-ks}/k$, and differentiating
gives
$-\zeta'(s)/\zeta(s)=\sum_{p}\sum_{k\ge 1}(\log p)p^{-ks}=\sum_{n\ge 1}\Lambda(n)n^{-s}$.
$\blacksquare$

### 3.3 The prime-power marking sieve (paper §3.1, Algorithm A)

The definition of $\Lambda$ is a recipe: enumerate the primes, and for each prime mark its
powers. Primality is obtained from the ordinary sieve of Eratosthenes.

```python
def von_mangoldt(N):
    lam  = [0.0] * (N + 1)          # lam[n] will hold Lambda(n)
    is_p = [True] * (N + 1)         # Eratosthenes table
    for p in range(2, N + 1):
        if is_p[p]:
            pk = p
            while pk <= N:          # mark p, p^2, p^3, ...
                lam[pk] = log(p)    # Lambda(p^k) = log p
                pk *= p
            for m in range(p * p, N + 1, p):
                is_p[m] = False
    return lam
```

**Theorem 3.1 (correctness of Algorithm A). — PROVED (paper).** The array returned by
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

### 3.4 The divisor-sum sieve (paper §3.2, Algorithms B and B′)

A factoring-free alternative follows from Proposition 2.2. Process $n=1,2,3,\dots$ in
increasing order, keeping a running array
`acc[n] = ∑_{d|n, d<n} Λ(d)`. At step $n$ the value $\Lambda(n)$ is $\log n-\texttt{acc[n]}$,
after which it is distributed to the multiples of $n$.

```python
def von_mangoldt_divisor(N):
    lam = [0.0] * (N + 1)
    acc = [0.0] * (N + 1)           # acc[n] = sum_{d|n, d<n} Lambda(d)
    for n in range(1, N + 1):
        lam[n] = log(n) - acc[n]    # Lambda(n), by Prop. 2.2
        for m in range(2 * n, N + 1, n):
            acc[m] += lam[n]
    return lam
```

**Theorem 3.2 (correctness of Algorithm B). — PROVED (paper).** For all $1\le n\le N$,
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

#### The integer form of the divisor-sum sieve (Algorithm B′)

Algorithm B can be carried out in exact integer arithmetic. Exponentiate Proposition 2.2:
$$\prod_{d\mid n}\exp\Lambda(d)=n,\qquad\text{hence}\qquad \exp\Lambda(n)=\frac{n}{P(n)},\qquad P(n):=\prod_{d\mid n,\ d<n}\exp\Lambda(d).$$
Since $\exp\Lambda(d)$ is $1$ or a prime, $P(n)$ is a positive integer and the quotient
$N(n):=n/P(n)$ is an integer by Proposition 2.2. The next statement identifies it; as the
paper says, its content is that *no logarithm and no primality test are needed to detect
whether $\Lambda(n)$ vanishes*.

**Theorem 3.3 (integer detection of prime powers). — PROVED (paper).** For every $n\ge 1$,
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

### 3.5 The Möbius-convolution sieve (paper §3.3, Algorithm C)

Corollary 2.3 offers a third route: sieve the Möbius function $\mu$ (which is multiplicative)
and sum.

```python
def von_mangoldt_moebius(N):
    mu    = [0] * (N + 1); mu[1] = 1
    primes, comp = [], [False] * (N + 1)
    for i in range(2, N + 1):                    # linear sieve for mu
        if not comp[i]:
            primes.append(i); mu[i] = -1
        for p in primes:
            if i * p > N: break
            comp[i * p] = True
            if i % p == 0:
                mu[i * p] = 0                    # p^2 | i*p
                break
            mu[i * p] = -mu[i]
    lam = [0.0] * (N + 1)
    for d in range(1, N + 1):                    # Lambda = mu * log
        if mu[d] != 0:
            for m in range(d, N + 1, d):
                lam[m] += mu[d] * log(m // d)
    return lam
```

**Proposition 3.4. — PROVED (paper).** The returned array satisfies `lam[n] = Λ(n)` for all
$n\le N$.

*Proof (paper).* The linear sieve returns the Möbius function [8]; the double loop accumulates
$\sum_{d\mid n}\mu(d)\log(n/d)$, which is $\Lambda(n)$ by Corollary 2.3. $\blacksquare$

**Complexity (paper).** The sieve is $O(N)$; the convolution is
$\sum_{d\le N}N/d=O(N\log N)$ operations. This route uses real logarithms of integers inside
the convolution; for exact output it should be run in a symbolic or sufficiently precise
arithmetic, or replaced by Algorithm B′ above, whose decisions are integral.

### 3.6 Why the linear sieve for multiplicative functions does not cover $\Lambda$ (paper §3.4)

For comparison, the standard linear sieve computes any *multiplicative* function $f$ from its
values on prime powers: with $p$ the smallest prime factor of $i\cdot p$, one uses
$f(ip)=f(i)f(p)$ when $p\nmid i$, and a separate rule involving $f(p^{k})$ when $p\mid i$ [8].
Multiplicativity is exactly what makes the recurrence close, and it is exactly what $\Lambda$
lacks (Proposition 2.4). The same applies to additive functions: their linear-sieve recurrence
closes because additivity ties the value at $ip$ to the values at $i$ and $p$. $\Lambda$ is
therefore outside both families, which is why one either marks prime powers (Algorithm A) or
uses the divisor identity (Algorithms B and C). The additive function that *is* inside the
additive family is $L=\log\operatorname{rad}$ of Proposition 2.5; it is computed by the
additive recurrence with $f(p^{k})=\log p$, and it agrees with $\Lambda$ exactly on the prime
powers.

### 3.7 Exactness, the two certifying checks, and the tables (paper §4–§6)

**What is exact (paper §4.1).** Algorithms A and B′ test primality and divisibility by integer
arithmetic. Their *decisions* — whether $\Lambda(n)$ vanishes — are therefore exact; only the
reporting of the nonzero value uses $\log$. Algorithm B in its real form computes
$\log n-\texttt{acc[n]}$; the subtraction is a difference of logarithms of integers, so it is
exact whenever the arithmetic used for logs is symbolic, and is accurate to the working
precision otherwise.

**Two identities that certify the table (paper §4.2).** The table can be checked without
external data.

1. **Per-index check (divisor identity).** For every $n\le N$, verify
   $\sum_{d\mid n}\Lambda(d)=\log n$. Since each nonzero term is $\log p$, the check is
   equivalent to the exact integer statement
   $\prod_{d\mid n,\ \Lambda(d)\ne 0}\exp\Lambda(d)=n$, which can be tested with integer
   arithmetic alone using the integer form of §3.4.
2. **Sieve-against-sieve check.** Run Algorithm A and the integer form of Algorithm B and
   compare the *decisions* (zero or nonzero) and the primes reported. Agreement over
   $1\le n\le N$ is a complete check of the table.

**Chebyshev's function and Table 1 (paper §4.3). — MEASURED.** Summing the table gives
$\psi(x)$. Proposition 2.6 predicts the exact value
$\psi(x)=\log\operatorname{lcm}(1,\dots,\lfloor x\rfloor)$. Table 1 of the paper lists
$\psi(10^{k})$, computed by Algorithm A; the paper notes that the last two entries illustrate
the sieve scale.

| $x$ | $\psi(x)$ | $\psi(x)/x$ |
|---|---|---|
| 10 | 7.83201418050546899 | 0.78320142 |
| 100 | 94.0453112293573922 | 0.94045311 |
| 1 000 | 996.68091224717524 | 0.99668091 |
| 10 000 | 10 013.3966932631148 | 1.0013397 |
| 100 000 | 100 051.564025657954 | 1.0005156 |
| 1 000 000 | 999 586.597495632922 | 0.9995866 |

**Exact checks (paper §4.3).** Proposition 2.6 gives $\exp\psi(10)=2520=\operatorname{lcm}(1,\dots,10)$
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

## 4. Verification and evidence

### 4.1 What the folder contains for verification

| Claim | Checked by | Kind |
|---|---|---|
| Propositions 2.1, 2.2, 2.4, Corollary 2.3, the bound $\Lambda n\le\log n$ | [`VonMangoldtSieves.lean`](VonMangoldtSieves.lean) | Lean 4 / Mathlib elaboration |
| Algorithm A $=$ Algorithm B′ (integer) on $1\le n\le N$ | [`von_mangoldt_sieves.py`](von_mangoldt_sieves.py), check [1] | exact integer comparison |
| $\prod_{d\mid n}\exp\Lambda(d)=n$ for all $n\le N$ | same script, check [2] | exact integer arithmetic |
| Algorithm B (real) against the table | same script, check [3] | floating point, tolerance $10^{-9}$ |
| Algorithm C (Möbius) against the table | same script, check [4] | floating point, tolerance $10^{-9}$ |
| $\exp\psi(10)=\operatorname{lcm}(1,\dots,10)$, $\exp\psi(20)=\operatorname{lcm}(1,\dots,20)$ | same script, check [5] | relative error $<10^{-12}$ |
| Table 1 | same script, per-prime $\log$ sums | measured |

The script's internal table stores the prime, `tab[n] = p` when $n=p^{k}$ and `tab[n] = 0`
otherwise, so check [2] multiplies the stored primes over the divisors of $n$ and compares the
integer product with $n$: this is exactly the integer form of the divisor identity, no
floating point in the decision.

### 4.2 Observed run — the reference implementation

Command, run in this folder (the folder's `README.md` gives the same command):

```sh
python3 von_mangoldt_sieves.py        # default N = 2000
python3 von_mangoldt_sieves.py 50000  # any table bound
```

Observed stdout of `python3 von_mangoldt_sieves.py` (default $N=2000$), verbatim:

```text
von Mangoldt sieves — self-check, N = 2000
  [1] Algorithm A  vs  Algorithm B' (integer detection): 0 mismatches
  [2] exact divisor identity  prod_{d|n} exp(Lambda(d)) = n : 0 failures
  [3] Algorithm B (real) vs table: 0 mismatches
  [4] Algorithm C (Mobius) vs table: 0 mismatches
  Chebyshev psi(x), computed by Algorithm A:
            x                   psi(x)
           10        7.832014180505469
          100       94.045311229357395
         1000      996.680912247175229
        10000    10013.396693263115594
       100000   100051.564025657949969
      1000000   999586.597495632944629
  [5] exp psi(10) = 2520.000000, lcm(1..10) = 2520, rel. err 3.61e-16
  [5] exp psi(20) = 232792560.000000, lcm(1..20) = 232792560, rel. err 8.96e-16
RESULT: ALL CHECKS PASS
```

* **Exit status:** `0` (the script returns `0` if and only if every check passes).
* **stderr:** empty, 0 bytes. **stdout carried only results:** the run header, the four check
  lines `[1]`–`[4]`, the Chebyshev table, the two `[5]` lcm lines, and the final `RESULT`
  line. No progress or timing text was written to stdout, and nothing at all was written to
  stderr; the script uses only the Python 3 standard library (`math`, `sys`, `typing`).
* Python used for the observed run: `python3` reporting `Python 3.13.13`.
* **$N=50000$ run:** identical output except the header (`N = 50000`); the same four
  `0 mismatches` / `0 failures` lines, the same Chebyshev table to all printed digits, the
  same relative errors `3.61e-16` and `8.96e-16`, and `RESULT: ALL CHECKS PASS`, exit status
  `0`, stderr empty (0 bytes). Wall time reported by the shell's `time`: 3.06 s real.

**Table 1 is reproduced exactly.** The six printed values of $\psi(10^{k})$, read as IEEE-754
doubles, are identical to the six values printed in Table 1 of the paper
(`7.83201418050546899`, `94.0453112293573922`, `996.68091224717524`, `10 013.3966932631148`,
`100 051.564025657954`, `999 586.597495632922`); the script prints them at 15 decimal places
and the paper at more, but the underlying doubles agree bit for bit. Both the $N=2000$ and the
$N=50000$ runs produce the same table, because the script always sums the table produced with
bound $\max(N,10^{6})$ for this output.

### 4.3 Observed run — the Lean companion

The companion is elaborated against Lean 4 + Mathlib. From the 001 folder, inside any Lean 4
project that provides Mathlib (the recipe in this folder's `README.md`):

```sh
lake env lean VonMangoldtSieves.lean
```

The second edition folder `../011-von-mangoldt-sieves` ships [`check.sh`](../011-von-mangoldt-sieves/check.sh),
which locates the toolchain under `$LEAN_PREFIX` (default `$HOME/lean`) and runs

```sh
./check.sh --all
```

expecting `[check] OK   VonMangoldtSieves.lean (...s)` and exit status `0`. The file imports
only `Mathlib`, opens `ArithmeticFunction Finset`, and defines under namespace
`VonMangoldtSieves` the seven theorems listed in §3.1: `support_ne_zero_iff`,
`apply_prime_pow`, `divisor_identity`, `moebius_convolution`, `not_additive`,
`not_multiplicative`, `le_log`. Its docstrings record which Mathlib results supply the
content (`vonMangoldt_ne_zero_iff`, `vonMangoldt_apply_pow`, `vonMangoldt_apply_prime`,
`vonMangoldt_sum`, `moebius_mul_log_eq_vonMangoldt`, `vonMangoldt_le_log`).

I ran this check in the equivalent second-edition folder, which carries a byte-identical copy
of `VonMangoldtSieves.lean` (SHA-256 in **Sources**) plus `check.sh`. Observed output, verbatim:

```text
EXIT=0
[check] OK   VonMangoldtSieves.lean (110s)
```

Exit status `0`; wall time reported by the shell's `time`: 1 m 54.6 s real. The run elaborates
the file in place and writes `VonMangoldtSieves.olean` next to the source; that `.olean` was
removed after the run, leaving the folder as found. With the elaboration reporting `OK` and
status `0`, the seven theorems above are accepted by the toolchain without `sorry`; the file
contains no `sorry` and no `axiom`. The claims this does **not** cover are the paper's
Propositions 2.5–2.8 and Theorems 3.1–3.3 and Proposition 3.4, which are proved in the paper
text only.

## 5. What is not claimed

* **No twin-prime or parity result.** The folder contains nothing about twin primes or the
  parity obstruction; the summary in the programme ledger `../../truths.md` records that "the
  one thing it did not do" was "prove anything about twin primes or the parity obstruction",
  and that $\sum_{n\le x}\lambda(n)\lambda(n+2)=o(x)$ remains **OPEN**. Nothing in this
  manuscript bears on the twin prime conjecture.
* **The complexity bounds are stated, not machine-checked.** The time and memory claims
  $O(N\log\log N)$ (A), $O(N\log N)$ (B, B′, C), $O(N)$ memory, and the prime-power count
  $\pi(N)+\pi(N^{1/2})+\cdots=O(N/\log N)$ are the paper's, with the paper's proofs by
  counting; the folder contains no formal verification of them.
* **Propositions 2.5–2.8 are not in Lean.** They are proved in the paper text only. The Lean
  companion covers Propositions 2.1, 2.2, 2.4, Corollary 2.3 and the bound
  $\Lambda(n)\le\log n$; nothing more.
* **The bound is not an equality statement.** The Lean docstring of `le_log` adds "with
  equality exactly on the prime powers", but the Lean statement is the inequality
  $\Lambda n\le\log n$ alone. Read against Proposition 2.1 ($\Lambda(p^{k})=\log p$) the
  docstring gloss appears to be an overstatement: for $k\ge 2$, $\Lambda(p^{k})=\log p$ while
  $\log(p^{k})=k\log p$. This manuscript asserts the inequality only; it makes no claim about
  the exact equality set.
* **The real-form algorithms are exact only in symbolic arithmetic.** The paper says so for
  Algorithm B in its real form and for Algorithm C; the script's comparisons [3] and [4] are
  floating-point comparisons at tolerance $10^{-9}$, not exact checks. The exact checks are
  [1] and [2].
* **The integer quotient $N(n)$ may overflow.** The paper's statement that all updates are
  exact "in machine integers for $N$ below the word-size limit" is a statement about the
  paper's Algorithm B′, not a claim about any particular implementation; the Python reference
  uses arbitrary-precision integers.
* **Paper §5 is context, not result.** The Chebyshev bounds, the prime number theorem, the
  explicit formula with its test function $g$, the estimates of $\operatorname{lcm}(1,\dots,n)$
  and of binomial denominators, and the Erdős–Kac circle are cited by the paper to [3]–[10];
  none of them is proved in this folder. In particular the bound
  $\psi(x)\le(\log 4+4)x$ is quoted from [7], and the observation that $\psi(x)/x\to 1$ in
  Table 1 is the prime number theorem, cited, not proved here.
* **Table 1 is a measurement.** Its $\psi(x)/x$ column is printed to the paper's precision and
  is not itself an exact identity; the exact identities of the paper are the divisor identity
  and the two lcm checks.
* **The paper's Example values were not separately checked here.** The example
  $P(2)=P(3)=1$, $P(6)=6$, $P(4)=2$ is carried from the paper; the script checks the
  corresponding decisions for every $n\le N$ (checks [1] and [2]) rather than printing this
  example.
* **Unverified cross-folder claim.** The second edition folder records a link between this
  material and the "sieve bug" of `../006-explicit-formula-routes-abc`; see that edition's
  note. This first edition's own files do not carry that claim, and I did not re-derive it
  here.

## 6. Value and significance

The folder records an elementary and complete solution to a concrete computational problem —
producing the whole table of $\Lambda$ — together with the identities that make each output
certifiable without external data. Its value is fourfold.

1. **Three independent sieves, each with a correctness proof.** Algorithm A is the definition
   read as a recipe; Algorithm B avoids factoring entirely and, in its integer form B′, decides
   whether $\Lambda(n)$ vanishes with integer arithmetic alone; Algorithm C realises the
   Möbius inversion $\Lambda=\mu\ast\log$ directly. Each is certified by the same divisor
   identity of Proposition 2.2, which the Lean companion states as `divisor_identity`.
2. **A formalised core.** Seven statements — support, values on prime powers, the divisor
   identity, Möbius inversion, non-additivity, non-multiplicativity, and the bound
   $\Lambda n\le\log n$ — are elaborated in Lean 4 / Mathlib, so the mathematical content of
   the computation's justification is machine-checked, not merely asserted.
3. **An exact, reproducible check.** The Python reference implementation re-derives the whole
   table by four routes, checks the divisor identity in exact integer arithmetic for every
   $n\le N$, and checks the exact lcm identities; it exited `0` with only results on stdout
   and nothing on stderr in the runs recorded in §4.
4. **A recorded implementation trap.** Paper §3.4 explains why the standard linear sieve for
   multiplicative (and additive) functions does not by itself compute $\Lambda$: the
   recurrence closes exactly when the function is multiplicative or additive, and $\Lambda$ is
   neither (Proposition 2.4). The second edition records the concrete instance of this trap
   that motivated the work. Proposition 2.5 isolates the additive function $L=\log\operatorname{rad}$
   that *is* in the additive family and agrees with $\Lambda$ exactly on the prime powers —
   the precise boundary between what such a recurrence can compute and what it cannot.

## Sources

All paths are relative. Line locators are to the files as they exist in this folder. SHA-256
digests are of the files as read for this packaging.

### Folder files read

| File | SHA-256 | Role |
|---|---|---|
| [`von-mangoldt-sieves.html`](von-mangoldt-sieves.html) | `8175fd8dcc88f9273d1596bbecdc5287acd8ff785c853933ea333795154b0c6c` | The authoritative paper text (**first edition**), self-contained HTML; all propositions, proofs, algorithms, Table 1 and references are quoted from here (§§1–7, References). |
| [`README.md`](README.md) | `93c1160af214a527c8d3048e52d3917f275b8c3a885201e59a26a3f3c1ade701` | Folder guide: contents, run commands, Lean build command, list of the seven Lean theorems. |
| [`von_mangoldt_sieves.py`](von_mangoldt_sieves.py) | `52f64848ffb42f25c250854beea427889d3b0c08368373411e00de5635e00929` | Reference implementation of Algorithms A, B, B′, C and the checks [1]–[5]; run in §4.2. |
| [`VonMangoldtSieves.lean`](VonMangoldtSieves.lean) | `e67059c1b3c2517edefc832874402e0bae0bdf1f78d546ab883ba6d5ba8bc9e2` | Lean 4 / Mathlib companion; lines 28, 33–35, 40–41, 44–46, 50–59, 64–74, 78–79 quoted in §3.1. |
| `manuscript.md` | this file | Manuscript (excluded from attachments). |

### Programme records read

| File | SHA-256 | Role |
|---|---|---|
| `../../truths.md` | `afc7329bcbf8f79cfbd6f05228ff5d31563c43cf60a001a07ae51626d8c49cc7` | Programme ledger; §11 (`## 11. von Mangoldt sieves`) is the item this folder publishes, and the programme summary records that "the one thing it did not do" was "prove anything about twin primes or the parity obstruction" and that $\sum_{n\le x}\lambda(n)\lambda(n+2)=o(x)$ remains OPEN. |
| `../011-von-mangoldt-sieves/README.md` | `66801edc713369a55a01359ccbf725ef1fc5ebf4f3fec5c33ca8194d8c6a1f9c` | Second-edition folder guide; source of the "sieve bug" cross-reference noted as unverified in §5. |
| `../011-von-mangoldt-sieves/check.sh` | `a258988c617e6a06f16f7ab3ec57994002028ea6f8449ba25f98efcde74e7c28` | Lean elaboration script used for the observed run in §4.3. |
| `../../../.solveathome/work/html2md/001-von-mangoldt-sieves__von-mangoldt-sieves.md` | `3622ede1afce02fe185cd8d9f66ce50c918a71889cf55c0f1bf226bedbfb786e` | Mechanical HTML→Markdown scaffold supplied as a content source (**local-only**, tool output, not part of the folder); its mathematics was rewritten into TeX here against `von-mangoldt-sieves.html`. |
| `../../../.solveathome/work/MANUSCRIPT_BRIEF.md` | `4c8b1906a1ea3067668b359d286a8c8ea914533129db8df2afcf1671d07878b7` | The packaging brief (**local-only**). |

All other files quoted above are local-only to this workspace; the HTML paper and the folder's
code are the record.

### Bibliography carried by the paper

The paper's reference list is reproduced here as it stands in `von-mangoldt-sieves.html`. These
items are cited by the paper; they were not independently consulted for this packaging, and no
bibliographic detail beyond what the paper prints is claimed.

1. H. von Mangoldt, *Zu Riemanns Abhandlung "Ueber die Anzahl der Primzahlen unter einer
   gegebenen Grösse"*, Journal für die reine und angewandte Mathematik **114** (1895), 255–305.
2. E. C. Titchmarsh, *The Theory of the Riemann Zeta-Function*, 2nd edition, revised by
   D. R. Heath-Brown, Oxford University Press, 1986; Chapter III.
3. G. H. Hardy and E. M. Wright, *An Introduction to the Theory of Numbers*, 6th edition,
   Oxford University Press, 2008; Chapters XVI–XXII.
4. A. E. Ingham, *The Distribution of Prime Numbers*, Cambridge Tracts in Mathematics 30,
   Cambridge University Press, 1932.
5. T. M. Apostol, *Introduction to Analytic Number Theory*, Undergraduate Texts in Mathematics,
   Springer, 1976; Chapters 2 and 3.
6. H. L. Montgomery and R. C. Vaughan, *Multiplicative Number Theory I: Classical Theory*,
   Cambridge Studies in Advanced Mathematics 97, Cambridge University Press, 2007.
7. J. B. Rosser and L. Schoenfeld, *Approximate formulas for some functions of prime numbers*,
   Illinois Journal of Mathematics **6** (1962), 64–94; and L. Schoenfeld, *Sharper bounds for
   the Chebyshev functions $\theta(x)$ and $\psi(x)$, II*, Mathematics of Computation **30**
   (1976), 337–360.
8. P. Pritchard, *Linear prime-number sieves: a family tree*, Science of Computer Programming
   **9** (1987), 17–35.
9. P. Erdős and M. Kac, *The Gaussian law of errors in the theory of additive number theoretic
   functions*, American Journal of Mathematics **62** (1940), 738–742.
10. D. Zagier, *Newman's short proof of the prime number theorem*, American Mathematical Monthly
    **104** (1997), 705–708.
