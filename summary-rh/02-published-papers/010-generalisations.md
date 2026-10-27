# 010 — Generalisations: Character Weights, Shift-2, Angle Parity

| Field | Value |
|---|---|
| Source | [`research/publish/010-generalisations/manuscript.md`](../rh/research/publish/010-generalisations/manuscript.md) |
| Status | Published; truths ledger §10. |
| Harvested statements | 8 |

## Abstract

This manuscript reports three generalisation attempts made after OP-5/OP-6 in a programme on the
parity problem for the twin-prime correlation. **It does not prove the twin prime conjecture, and
nothing here bears on the Riemann Hypothesis.** Each attempt takes machinery that worked for the
programme's internal problem, replaces the alphabet, and asks what survives; each carries a verdict,
and two of the three verdicts are negative. (i) *Character weights.* Replacing the parity sieve by a
$q$-periodic coefficient $c$ turns the boundary functional into a character-weighted geometric sum
$\Phi_c(p,n) \to F_{r}(e^{-p/n})$ with $F_r(x) = f_r(x)/(1-x^q)$; the regrouping
(**PROVED**, Lean `Op57.F_eq_fblock`), the forced leading equation $x^s = 1-x^q$ (**PROVED**,
`Op57.leading_forced_of_hasSum_geom`), its parity specialisations $x = 1/\sqrt2$ and
$x = (\sqrt5-1)/2$ (**PROVED**), and the non-existence of a threshold for $\chi_3$ and $\chi_4$
(**PROVED**) are machine-checked; the OP-5 second-order expansion **survives** wherever the leading
equation has a root, but the leading equation **fails** for $\chi_3,\chi_4$ — only $1349$ of $4537$
$(\chi,r)$ pairs over real characters mod $q\le60$ have a root (**MEASURED**). (ii) *Shift 2.* The
exact split $S_2(x) = S_1(\lfloor x/2\rfloor) + C(\lfloor(x+1)/2\rfloor)$ with
$C(K)=\sum_{k\le K}\lambda(4k^2-1)$ is **PROVED** and reduces the open core to a sum of $\lambda$ over
a quadratic polynomial; the automorphic/spectral input **does not** break parity over $\mathbb{Q}$
(no automorphic object: $L(s,\lambda)=\zeta(2s)/\zeta(s)$), although parity *is* broken over
$\mathbb{F}_q[T]$ by Sawin–Shusterman — an **unconditional theorem there, open here**, whose engine
(Deligne square-root cancellation) is **VERIFIED** numerically. (iii) *Angle signs.* The sparse-pair
bound and the phase-crossing bound are **PROVED**, making an angle twist pair-invisible up to
$O(t\log N)$; a measured dichotomy shows any $\pm1$ sign either preserves the pair cancellation
(uninformative) or destroys it (useless), and **the parity barrier stands**.

## Harvested theorem-like statements

### Proposition 1 (regrouping; PROVED, Lean `Op57.F_eq_fblock`; also `Op57.hasSum_F_of_periodic`).

For $q>0$, $c(m+q)=c(m)$, $0\le x<1$ and every $r$,
$$F_r(x) = \sum_{j\ge1} c(r+j)\,x^j = \frac{f_r(x)}{1-x^{q}} .$$
*Proof.* Group $j$ by residue mod $q$, $j = kq+s$, and sum the resulting geometric series in $x^q$.
The Lean proof reindexes $\mathbb{N}\simeq\mathbb{N}\times\mathrm{Fin}(q)$ (`Nat.divModEquiv`), uses
`HasSum.mul` for the finite$\times$infinite product and `Summable.of_norm_bounded` for the product
summability, and invokes periodicity through `periodic_mod`. $\blacksquare$

**Limit law (NUMERICAL).** With $a=p/n$ fixed and $r = n\bmod q$,
$$\Phi_c(p,n) = F_r(e^{-a}) + O(1/n)\qquad (n\to\infty). \qquad\text{(LIMIT)}$$
The source states that the proof of (LIMIT) is classical (Abel summation / Euler–Maclaurin; the
$j$-sum is geometrically cut off by $e^{-aj}$, so the remainder is $O(1/n)$) but that it is **not
formalised**. `verify/007/05_limit_rate.py` exhibits the stable product $n\,(\Phi_c - F_r)$ for
$c\equiv1$, the parity sieve, $\chi_3$ and $\chi_{11}$, so that the error is exactly $O(1/n)$ and not
merely $o(1)$. The Lean development therefore contains the algebraic core, not the analytic limit.

### Theorem 2 (forced leading equation; PROVED, Lean `Op57.leading_forced_of_hasSum_geom`).

For $q>0$, $s\ge1$, $0\le x<1$: if $\sum_{k\ge0} x^{qk+s} = 1$ then
$$x^{s} = 1 - x^{q}. \qquad\text{(LEAD}')$$
*Proof.* $\sum_{k\ge0}x^{qk+s} = x^s/(1-x^q)$ for $|x^q|<1$; uniqueness of the sum forces
$1 = x^s(1-x^q)^{-1}$, and $1-x^q>0$ clears the denominator. This is the character-sum analogue of
`006`'s anchor `Op56.leadingCoeff_forced` ($\sum_{j\ge1}x^j=1 \vdash x=1/2$). $\blacksquare$

### Theorem 3 (parity specialisations; PROVED, Lean `Op57.leading_forced_parity_even`, `…_odd`, `…_even_eq`, `…_odd_eq`).

For the parity sieve $c=\mathbf{1}_{2\mid m}$ ($q=2$), (LEAD$'$) reads
$x^2 = 1-x^2$ for even $r$ ($s=2$) and $x = 1-x^2$ for odd $r$ ($s=1$). Hence
$$r \text{ even}:\quad x = \frac{1}{\sqrt2},\quad a = \tfrac12\log 2 = 0.3465735903\ldots;\qquad
r \text{ odd}:\quad x = \frac{\sqrt5-1}{2},\quad a = 0.4812118251\ldots$$
Both are quadratic irrationals: the rate is *forced* by the character equation exactly as $x=1/2$ is
forced in OP-5. $\blacksquare$

### Theorem 4 (no threshold for $\chi_3$, $\chi_4$; PROVED, Lean `Op57.chi3_F_lt_one`, `Op57.chi4_F_lt_one`, and the corollaries `Op57.chi3_no_leading_threshold`, `Op57.chi4_no_leading_threshold`).

For $c\in\{\chi_3,\chi_4\}$, every $r$ and every $x\in[0,1)$,
$$F_r(x) < 1 .$$
Consequently the leading equation $F_r(x)=1$ has **no solution** in $[0,1)$, and there is no OP-5
threshold for that twist to expand. The block polynomials are explicit,
$$f_0^{\chi_3} = x-x^2,\quad f_1^{\chi_3} = x^3-x,\quad f_2^{\chi_3} = x^2-x^3,$$
$$f_0^{\chi_4} = x-x^3,\quad f_1^{\chi_4} = x^4-x^2,\quad f_2^{\chi_4} = x^3-x,\quad
f_3^{\chi_4} = x^2-x^4,$$
and the strict inequality in each case reduces to a positivity statement, e.g.
$1-x^3-(x-x^2) = (1-x)(1+x^2)>0$ for $(\chi_3,r=0)$, and
$1-x^4-(x^4-x^2) = (1-x)(1+x)(2x^2+1)>0$ for $(\chi_4,r=1)$. This is the sharp structural difference
from OP-5: there positivity of the alphabet makes $F_r\to+\infty$ and threshold existence automatic,
whereas for a zero-mean character existence is a genuine condition that can fail. $\blacksquare$

**Deformation (OP-5$'$; NUMERICAL).** With the twisted moments
$$S_m(r) = \sum_{j\ge1} c(r+j)\,j^m x^j,\qquad a = -\log x,\qquad
\gamma = a S_2(r)\big/\bigl(2 S_1(r)\bigr),$$
$$\gamma_2 = \frac12\left(\gamma^2 S_2 - a\gamma S_3 + \frac{a^2}{4}S_4\right)
+ \frac{\gamma}{2}S_2 - \frac{a}{3}S_3,\qquad \gamma_1 = \frac{\gamma_2}{S_1(r)},$$
the threshold $p(n)$ of $\Phi_c(p,n)=1$ satisfies
$$p(n) = a n + \gamma + \frac{\gamma_1}{n} + O(1/n^2). \qquad\text{(OP-5}')$$
*Calibration.* $c\equiv1$ gives $x=1/2$, $a=\log2$,
$\gamma = \tfrac32\log2$ and
$\gamma_1 = 3(\log2)^2 - \tfrac{25}{12}\log2 = -0.00269758441194845\ldots$, which is **exactly** the
constant proved in `006`; the agreement is reported to $2\cdot10^{-41}$ at $40$ decimal places. The
deformation therefore reproduces the known theorem rather than replacing it. For the parity sieve the
predicted constants are
$$r\text{ even}:\ x^*=\tfrac{1}{\sqrt2},\ a = 0.3465735903,\ \gamma = \tfrac32\log2 = 1.0397207708,\
\gamma_1 = -0.0053951688,$$
$$r\text{ odd}:\ x^*=\tfrac{\sqrt5-1}{2},\ a = 0.4812118251,\ \gamma = 0.9684201172,\
\gamma_1 = +0.0203439630,$$
and for $\chi_{11}$ (Legendre symbol mod $11$), $r=2$:
$x^* = 0.6437333937$, $a = 0.4404706236$, $\gamma = -0.4467569001$,
$\gamma_1 = -0.2454347549$. **This last case is the one the round's objective asked about: the
second-order expansion survives in full**, with constants produced by the character sum. What fails
for *other* characters is not the expansion but its leading equation.

**Threshold criterion (MEASURED, `verify/007/03_character_scan.py`).** Enumerating **every** real
Dirichlet character mod $q$ for all $q\le60$, and for every residue $r$ maximising $F_r$ on $[0,1)$
exactly (by root-finding on the numerator of $F_r'$, a polynomial of degree $\le 2q-1$, together with
the endpoint value $-f_r'(1)/q$):
$$\text{real characters } 187,\quad \text{non-principal } 128,\quad (\chi,r)\ \text{pairs } 4537,$$
$$\text{pairs with a threshold } (\max_{[0,1)}F_r\ge1):\ 1349\ (29.7\%).$$
The global maximum over non-principal real characters is $5.000$ at $q=47$, $r=0$, attained at
$x\to1^-$ (a slow, $a\to0$ threshold); at the other extreme $\chi_3$ peaks at $1/3$ and $\chi_4$ at
$1/2$. Principal characters always have a threshold; their density-scaled leading constants include
$q=3$: $x^*=0.5436890127$, $q=5$: $x^*=0.5086603916$, $q=7$: $x^*=0.5020170552$,
$q=12$: $x^*=0.7044075244$.

**Correction to an earlier claim (kept visible).** The round's *first* framing was "non-principal
characters destroy the threshold", and the first conjecture was the uniform bound $F_r<1$ for **all**
non-principal characters. The exhaustive scan **refuted** the uniform bound (e.g. $q=47$ attains
$5.0$). The corrected statement is the criterion $\max_{[0,1)}F_r\ge1$ — an arithmetic condition on
$(\chi,r)$, not a barrier. This was, in the source's words, the single largest mid-course correction of
the round.

### Theorem 5 (shift-2 split and the polynomial core; PROVED, Lean `Op58.Sh2_split`, `Op58.Ccore_eq_poly`, with `Op58.Sparse.lean`-independent arithmetic in `Op58/Defs.lean`).

For
every $x\ge0$,
$$S_2(x) = S_1(\lfloor x/2\rfloor) + C(\lfloor (x+1)/2\rfloor), \qquad\text{(R1)}$$
$$C(K) = \sum_{k\le K}\lambda(4k^2-1). \qquad\text{(R2)}$$
The supporting identities are complete multiplicativity $\lambda((2k-1)(2k+1)) = \lambda(2k-1)\lambda(2k+1)$
(`Op58.liouville_pair`; Lean theorem `(R3)`), the polynomial identity
$(2k-1)(2k+1) = 4k^2-1$ (`Op58.poly_identity`), the even shift
$\lambda(2m)\lambda(2m+2) = \lambda(m)\lambda(m+1)$ (`Op58.even_shift`; this uses
$\lambda(2)^2=1$ via `Op58.liouville_two`, `Op58.liouville_sq`), and the auxiliary
`Op58.sum_range_even_odd`. $\blacksquare$

The point of (R2) is that it **removes the "no Euler product" obstruction as an excuse**: although
$m\mapsto\lambda(m)\lambda(m+2)$ is not multiplicative, the open core is a sum of the multiplicative
$\lambda$ over the quadratic polynomial $k^2-1$, which is precisely the shape attacked by spectral
methods over both $\mathbb{Q}$ and $\mathbb{F}_q[T]$. `verify/008/01_reduction.py` checks (R1), (R2),
(R3) with discrepancy exactly $0$; (R1) on the exact value of $S_1$ as the shift-one correlation,
which is the convention fixed in §2.

**The three components a parity-breaking spectral input must supply (structural, labelled by the
source as ARGUMENT).**
**(S1)** A spectral/geometric object attached to the sequence: over $\mathbb{Q}$ an automorphic form
whose Hecke eigenvalues are the sequence (the toy $x^2+y^4 = N(x+iy^2)$ in $\mathbb{Q}(i)$ gives a
weight-1 Eisenstein series and its Grössencharacter); over $\mathbb{F}_q[T]$ a trace function, i.e.
the trace of Frobenius on an $\ell$-adic sheaf attached to the Möbius function.
**(S2)** Square-root cancellation for that object: over $\mathbb{Q}$ spectral equidistribution /
Kuznetsov–Petersson; over $\mathbb{F}_q[T]$ Deligne's Weil II bound, i.e. the function-field Riemann
hypothesis.
**(S3)** A parity-breaking sign invisible to the sieve: over $\mathbb{F}_q[T]$, Sawin–Shusterman prove
that, restricted to certain special subspaces, the Möbius function over $\mathbb{F}_q[T]$ can be
mimicked by Dirichlet characters (their abstract, quoted verbatim by the source); over $\mathbb{Q}$ the
only completely multiplicative signs an $L$-function detects are Dirichlet characters, which are
periodic mod $q$ and therefore parity-blind.

**Verdict (`008`).** The automorphic/spectral input **does not** break parity over $\mathbb{Q}$. The
source gives four obstructions:
**(O1) No spectral object**: $L(s,\lambda) = \zeta(2s)/\zeta(s)$ is a ratio of $\zeta$ functions;
$\lambda$ is not the sequence of Hecke eigenvalues of any cusp form or Eisenstein series in a way that
supports a Kuznetsov/Petersson bilinear input, and the polynomial $k^2-1$ factors only over
$\mathbb{Z}$, giving no new field, no Hecke character and no sheaf. This is a **STRUCTURAL** finding,
with no proof attempted.
**(O2) The number-field spectral toolkit is parity-blind here**: every $\zeta$-based structure in the
programme is either sign-blind (index parity) or additive in $\log n$; the explicit formula sees
$\Lambda(n)$, an additive object, and a Dirichlet character twist is periodic. **(O3) The
function-field engine has no number-field counterpart**: the Sawin–Shusterman proof uses
finite-dimensional cohomology over a finite field, so Frobenius eigenvalues are algebraic integers of
bounded modulus (Weil II) and the $\ell$-adic monodromy group is a geometric object; over
$\mathbb{Q}$ there is no Frobenius, no monodromy group for $\mu$, and no finite-dimensionality.
**(O4) The missing quantitative input, measured**: the linear (twin-prime) sieve needs a level of
distribution $\theta>1/2$, and `verify/008/02_level_and_growth.py` at $x=10^6$ shows the crossover
exactly at $q\approx x^{1/2}$ (see §4), i.e. the empirical level of distribution is $1/2$, the barrier
itself. A finite range proves nothing, but it locates the wall.

**The function-field realisation (THEOREM, cited, plus VERIFIED numerics).** Sawin–Shusterman,
*On the Chowla and twin primes conjectures over $\mathbb{F}_q[T]$* (arXiv:1808.04001), using geometric
methods (trace functions, a function-field Burgess bound, and the character-mimicking of $\mu$), obtain
a level of distribution close to $1$ for $\mu$ in arithmetic progressions, resolve Chowla's
$k$-point correlation conjecture with large uniformity in the shifts, and establish the twin prime
conjecture in quantitative form over $\mathbb{F}_q[T]$. The companion paper (arXiv:2008.09905)
resolves the $\mathbb{F}_q[u]$-analog of Chowla's conjecture on Möbius sums over polynomial sequences,
and Bateman–Horn in degree $2$, via cancellation in short sums of trace functions. The source records
the abstracts as read in the round. `verify/008/03_function_field.py` exhibits the Weil/Deligne engine
and the function-field consequences numerically; see §4.

**Conditional transfer.** Let
$$(H_\theta)\qquad \sum_{q\le x^\theta}\ \max_{a \bmod q}\Bigl|\sum_{n\le x,\,n\equiv a\,(q)}\lambda(n)\Bigr|
\ll_A x(\log x)^{-A} \quad\text{for some } \theta>1/2 .$$
Then the standard linear-sieve argument gives $S_2(x)=o(x)$ and a positive lower bound for twin
primes (**CONDITIONAL**; the source notes that an equivalent-in-conclusion hypothesis is the pair
$C(K)=o(K)$ and $S_1(y)=o(y)$, that the equivalence of the *conclusions* is a theorem, and that the
equivalence of the two *hypotheses* is not claimed). $(H_\theta)$ for any $\theta>1/2$ is **OPEN** over
$\mathbb{Q}$ and is *attainable* over $\mathbb{F}_q[T]$; over $\mathbb{Q}$ the only mechanisms that
supply it are Type-II/bilinear (Friedlander–Iwaniec) or equidistribution to large moduli
(Bombieri–Friedlander–Iwaniec), so the spectral route **reduces to** those over $\mathbb{Q}$.

**Numerical shape of the core (MEASURED).** `verify/008/02_level_and_growth.py` records the
quadratic-polynomial Mertens function $C(K)$: from the script's run,
$$\begin{array}{c|rrrr}
K & 10^3 & 10^4 & 10^5 & 10^6\\\hline
C(K) & -42 & -6 & 366 & 32\\
\max_{K'\le K}|C(K')| & 61 & 98 & 369 & 488\\
\max|C|/\sqrt K & 1.929 & 0.980 & 1.167 & 0.488
\end{array}$$
The numerical shape is $O(\sqrt K)$ or better, i.e. square-root cancellation — the same phenomenon the
function-field proof *theorems*. Over $\mathbb{Q}$, $C(K)=o(K)$ is **OPEN**, and it would give
$C=o(K)$ and hence $S_2=o(x)$. The source calls this the sharpest available numerical target for the
spectral route.

### Lemma A (sparse-pair bound; PROVED, Lean `Op59.sparse_pair_bound`).

For $a,w:\mathbb{N}\to\mathbb{Z}$
with $|a(n)|\le1$ and $w(n)\in\{+1,-1\}$ for all $n$, and every $N$,
$$\Bigl|\sum_{n<N} a(n)\bigl(w(n)w(n+2)-1\bigr)\Bigr| \le 2\,\#\text{crossingSet}_w(N).$$
The left side is exactly $|C_w(N) - \sum_{n<N}a(n)|$. *Proof.* $w(n)w(n+2)=1$ off the crossing set;
each exceptional term contributes at most $2$ because $|a(n)|\le1$ and
$w(n)w(n+2)=-1$ there (`Op59.pair_prod_eq`). $\blacksquare$

### Lemma B (crossing count; PROVED, Lean `Op59.phaseCrossing_card_le`, with the parametrised form `Op59.phaseCrossing_card_le_of_le`).

Let $\theta:\mathbb{N}\to\mathbb{R}$ be strictly increasing and
$c>0$. Then
$$\#\text{phaseCrossing}(N) \le 2\left(\left\lfloor \frac{\theta(N+2)}{c}\right\rfloor + 1\right).$$
*Proof.* For a fixed multiple index $k$, the fibre
$X_k = \{n<N : \theta(n) < kc < \theta(n+2)\}$ has at most two elements: if $m\le m'-2$ both lay in
$X_k$ then $kc < \theta(m+2)\le\theta(m') < kc$, a contradiction; so any two members of a fibre differ
by at most $1$, and the case split on whether $n_0+1\in X_k$ (for $n_0=\min X_k$) gives $\#X_k\le2$.
Summing over the fibres $k\le\lfloor\theta(N+2)/c\rfloor$ gives the bound. $\blacksquare$

### Corollary (angle-twist invisibility; PROVED, Lean `Op59.angle_twist_invisible`).

If every pair
crossing of a $\pm1$-valued weight $w$ is a phase crossing, then
$$\Bigl|C_w(N) - \sum_{n<N}a(n)\Bigr| \le 4\left(\left\lfloor\frac{\theta(N+2)}{c}\right\rfloor+1\right)
= O\!\left(\frac{\theta(N+2)}{c}\right).$$
For the angle sign, $\theta(n)=t\log n$ and $c=\pi$, giving $O(t\log N)$. The mechanism in one
sentence: the two angles in the correlation differ by $t\log(1+2/n)=O(t/n)$, so $w(n+2)=w(n)$ except
where the phase crosses a multiple of $\pi$. The Lean statement is abstract in $\theta$; the
substitution $\theta(n)=t\log n$, $c=\pi$ (a `StrictMono`/monotonicity instance) is **not**
formalised, and the source calls it a one-line substitution. $\blacksquare$

**Measured dichotomy (MEASURED, `verify/009/02_omega_sign_test.py`, $x=10^7$).** The backward
criterion is that a $\pm1$ weight $w$ can force $S(x)=o(x)$ only if it changes the pair sum at
positive density,
$$M_w(x) = \sum_{n\le x}\lambda(n)\lambda(n+2)\bigl(w(n)w(n+2)-1\bigr) \ \not\equiv\ o(x).$$
Writing $W(x)=\sum_{n\le x}w(n)$, $U_w(x)=\sum_{n\le x}\lambda(n)w(n)$ and $T_w$ for the twisted pair
sum, the observed values at $x=10^7$ are
$$\begin{array}{l|rrrr}
w & W/x & U/x & T/x & M/x\\\hline
\lambda\ \text{(circular)} & -0.0001 & \mathbf{1.0000} & 1.0000 & \mathbf{0.9999}\\
(-1)^{\omega(n)} & -0.0002 & \mathbf{0.4717} & 0.1591 & \mathbf{0.1589}\\
2\cdot\mathbf{1}_{\text{squarefree}}-1 & 0.2159 & 0.0003 & -0.0002 & -0.0004\\
(-1)^{\Omega(n)+\omega(n)} & 0.4717 & -0.0002 & -0.0004 & -0.0005\\
\chi_4\ \text{(Hecke character of }\mathbb{Q}(i)) & 0.0000 & 0.0003 & -0.0002 & -0.0003\\
\text{angle sign, } t=10 & 0.0500 & -0.0005 & 0.0001 & 0.0000
\end{array}$$
where $\omega(n)$ is the number of **distinct** prime factors. Reading the table:
$w=(-1)^{\omega(n)}$ genuinely couples to $\Omega$-parity at positive density ($U/x\to0.4717\ne0$,
$M/x\to0.1589\ne0$), but the coupling is carried by the **density of its support** — the Dirichlet
series of $\lambda\cdot(-1)^\omega$ has a **pole** at $s=1$, its local factor being
$(1+2p^{-s})/(1+p^{-s})$, i.e. it is a main-term/bias effect — and it **destroys** the pair
cancellation ($T/x\to0.159$, whereas $S/x\approx1.2\cdot10^{-4}$). It therefore cannot be used to prove
$S=o(x)$. Signs that preserve the cancellation give nothing: squarefree parity, the automorphic sign
$\chi_4$, and the angle sign all have $M/x\approx0$. Only $w=\lambda$ moves the pair sum by density, and
it is circular ($w$ *is* the function under study).

**Verdict (`009`).** The dichotomy is sharp: a sign either **preserves** the pair cancellation (and is
uninformative) or **destroys** it (and is useless); none both preserves it and separates $\Omega$. The
source's stated reason is structural, not accidental: the pair correlation $\sum a(n)a(n+2)$ has **no
Euler product** for any $a$ (the shift breaks multiplicativity), so no twist can restore it, and a sign
that "separates" the pair necessarily changes the sum it was meant to control. **The parity barrier
stands.** Only the angle side of the dichotomy is a theorem; the rest is numerical plus structural.

## Source

[`manuscript.md`](../rh/research/publish/010-generalisations/manuscript.md) · [`README.md`](../rh/research/publish/010-generalisations/README.md)
