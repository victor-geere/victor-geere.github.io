# Generalisations and attempts in the twin-prime-parity programme: character weights, the shift-2 core, and angle signs

**First edition, packaged from `research/truths.md` §10 (ledger rows `007`, `008`, `009`) and the round material of `research/twin-prime-parity/007`, `008`, `009`. Local-only source: this folder's `README.md`, `TRUTHS.md`, `notes/`, `verify/`, and the Lean developments `Op57`, `Op58`, `Op59`.**

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

## 1. Introduction and goal

The programme studies the two-point Liouville (Chowla) correlation at shift $2$,
$S(x) = \sum_{n\le x}\lambda(n)\lambda(n+2)$, where $\lambda$ is the Liouville function
$\lambda(n) = (-1)^{\Omega(n)}$ and $\Omega(n)$ is the number of prime factors of $n$ counted with
multiplicity. The target $\sum_{n\le x}\lambda(n)\lambda(n+2) = o(x)$ is the two-point Chowla
conjecture at shift $2$, and it is **open**; the twin prime conjecture is open too, and the programme's
parity barrier says the standard sieve-theoretic inputs cannot decide it. Earlier rounds
(`006`, "OP-5"/"OP-6") reduced the corresponding *internal* problem at a boundary functional to a
forced leading equation and a second-order asymptotic expansion. This item asks whether that machinery
survives when its alphabet is replaced in three different ways, and records the verdict on each
replacement. Two of the three replacements fail; both failures are results, and they are reported here
as such.

The three attempts are:

* `007` — replace the parity sieve by a **character sum** (a Dirichlet character, or more generally a
  periodic coefficient): does the OP-5 second-order expansion survive for non-principal $\chi$?
* `008` — supply an **automorphic/spectral input** for the shift-2 correlation: does it break parity
  over $\mathbb{Q}$ the way the analogous geometric input does over $\mathbb{F}_q[T]$?
* `009` — test an **angle sign** $w(n) = \operatorname{sign}(\sin(t\log n))$ and an
  **$\Omega$-dependent sign**: can either separate $\Omega$-parity and force the conclusion?

Nothing in this manuscript proves $S(x)=o(x)$, the twin prime conjecture, or anything about the
Riemann Hypothesis. The material is a set of closures of routes, with the machine-checked fragments
that survive inside each attempt.

## 2. Setup and definitions

**Liouville function.** $\lambda(n) = (-1)^{\Omega(n)}$ for $n\ge1$, with $\lambda$ extended as an
arithmetic function; $\lambda$ is **completely** multiplicative: $\lambda(mn)=\lambda(m)\lambda(n)$
for all $m,n$, with no coprimality hypothesis.

**Correlations.**
$$S_h(x) = \sum_{n\le x}\lambda(n)\lambda(n+h),\qquad S_1(x)=\sum_{n\le x}\lambda(n)\lambda(n+1),$$
$$C(K) = \sum_{k\le K}\lambda(4k^2-1).$$
Here $S_1$ denotes the **shift-one correlation**, *not* the one-point sum $\sum_{n\le x}\lambda(n)$;
this convention is the one used in the shift-2 audit and in `Op58`, and it is the point on which a
first draft of `verify/008/01_reduction.py` went wrong (see §5).

**Periodic coefficient and the twisted objects (`007`).** Let $c:\mathbb{N}\to\mathbb{R}$ be
$q$-periodic with $q>0$, i.e. $c(m+q)=c(m)$ for all $m$. Define the **twisted boundary functional**
$$\Phi_c(p,n) = \sum_{j\ge1} c(n+j)\left(1+\frac{j}{n}\right)^{-p},$$
the **twisted generating function** (the object $\Phi_c$ tends to)
$$F_r(x) = \sum_{j\ge1} c(r+j)\,x^j,$$
and the **block polynomial**
$$f_r(x) = \sum_{s=1}^{q} c(r+s)\,x^s .$$
The un-twisted case $c\equiv1$ ($q=1$) is the programme's OP-5. The parity sieve is the $q=2$
coefficient $c(m) = \mathbf{1}_{2\mid m}$.

**Characters.** $\chi_3$ is the real non-principal character mod $3$ ($\chi_3(1)=1$,
$\chi_3(2)=-1$, $\chi_3(0)=0$) and $\chi_4$ the real non-principal character mod $4$
($\chi_4(1)=1$, $\chi_4(3)=-1$, $\chi_4$ vanishes on even arguments). A **real** Dirichlet character
mod $q$ is a homomorphism $(\mathbb{Z}/q)^\times\to\{\pm1\}$ extended by $0$; the scan of §3 restricts
to real characters, which is the setting in which a real threshold equation $F_r(x)=1$ is meaningful
(complex characters are not treated; see §5).

**The leading equation.** Setting $x = e^{-a}$, $p = an$, the leading order of the limit law is
$$F_r(x) = 1. \qquad\text{(LEAD)}$$
For a coefficient of positive period mean ($c\equiv1$, residue-class indicators, principal characters),
$F_r(x)\to+\infty$ as $x\to1^-$ and a root always exists. For a coefficient of zero period mean
(non-principal characters), $f_r(1)=0$ and
$$F_r(1^-) = -\frac{f_r'(1)}{q} = -\frac1q\sum_{s=1}^{q} s\,c(r+s),$$
so $F_r$ is bounded on $[0,1)$ and the existence of a root is an arithmetic condition on $(\chi,r)$.

**Shift-2 splitting data (`008`).** For the abstract constants of the deformation we write $\gamma$
for the $1/n$ coefficient of the threshold expansion below; the sources write $c$ for it, and this
manuscript reserves $c$ for the coefficient sequence.

**Angle sign and crossing data (`009`).** For a $\pm1$-valued weight $w:\mathbb{N}\to\mathbb{Z}$ and
$a(n) = \lambda(n)\lambda(n+2)$,
$$C_w(N) = \sum_{n<N} a(n)\,w(n)\,w(n+2),\qquad
\text{crossingSet}_w(N) = \{\,n<N : w(n)w(n+2)\ne1\,\}.$$
For a phase $\theta:\mathbb{N}\to\mathbb{R}$ that is strictly increasing and a modulus $c>0$,
$n<N$ is a **phase crossing** if $(\theta(n),\theta(n+2))$ contains a positive multiple of $c$; for the
angle sign one takes $\theta(n) = t\log n$ and $c=\pi$.

**Status vocabulary.** PROVED (machine-checked in Lean), VERIFIED (a script checks an identity or a
bound and exits $0$), MEASURED (finite-range numbers, which prove nothing about asymptotics),
CONDITIONAL, and OPEN. Finite ranges are diagnostics: the programme records finite-prefix
indeterminacy as dictionary F4.

## 3. Results

### 3.1 `007` — character-weighted limit law, and where its leading equation dies

**Proposition 1 (regrouping; PROVED, Lean `Op57.F_eq_fblock`; also `Op57.hasSum_F_of_periodic`).**
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

**Theorem 2 (forced leading equation; PROVED, Lean `Op57.leading_forced_of_hasSum_geom`).**
For $q>0$, $s\ge1$, $0\le x<1$: if $\sum_{k\ge0} x^{qk+s} = 1$ then
$$x^{s} = 1 - x^{q}. \qquad\text{(LEAD}')$$
*Proof.* $\sum_{k\ge0}x^{qk+s} = x^s/(1-x^q)$ for $|x^q|<1$; uniqueness of the sum forces
$1 = x^s(1-x^q)^{-1}$, and $1-x^q>0$ clears the denominator. This is the character-sum analogue of
`006`'s anchor `Op56.leadingCoeff_forced` ($\sum_{j\ge1}x^j=1 \vdash x=1/2$). $\blacksquare$

**Theorem 3 (parity specialisations; PROVED, Lean `Op57.leading_forced_parity_even`, `…_odd`,
`…_even_eq`, `…_odd_eq`).** For the parity sieve $c=\mathbf{1}_{2\mid m}$ ($q=2$), (LEAD$'$) reads
$x^2 = 1-x^2$ for even $r$ ($s=2$) and $x = 1-x^2$ for odd $r$ ($s=1$). Hence
$$r \text{ even}:\quad x = \frac{1}{\sqrt2},\quad a = \tfrac12\log 2 = 0.3465735903\ldots;\qquad
r \text{ odd}:\quad x = \frac{\sqrt5-1}{2},\quad a = 0.4812118251\ldots$$
Both are quadratic irrationals: the rate is *forced* by the character equation exactly as $x=1/2$ is
forced in OP-5. $\blacksquare$

**Theorem 4 (no threshold for $\chi_3$, $\chi_4$; PROVED, Lean `Op57.chi3_F_lt_one`,
`Op57.chi4_F_lt_one`, and the corollaries `Op57.chi3_no_leading_threshold`,
`Op57.chi4_no_leading_threshold`).** For $c\in\{\chi_3,\chi_4\}$, every $r$ and every $x\in[0,1)$,
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

### 3.2 `008` — the shift-2 split, and why the spectral input does not transfer

**Theorem 5 (shift-2 split and the polynomial core; PROVED, Lean `Op58.Sh2_split`,
`Op58.Ccore_eq_poly`, with `Op58.Sparse.lean`-independent arithmetic in `Op58/Defs.lean`).** For
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

### 3.3 `009` — angle signs and $\Omega$-dependent signs: the barrier stands

**Lemma A (sparse-pair bound; PROVED, Lean `Op59.sparse_pair_bound`).** For $a,w:\mathbb{N}\to\mathbb{Z}$
with $|a(n)|\le1$ and $w(n)\in\{+1,-1\}$ for all $n$, and every $N$,
$$\Bigl|\sum_{n<N} a(n)\bigl(w(n)w(n+2)-1\bigr)\Bigr| \le 2\,\#\text{crossingSet}_w(N).$$
The left side is exactly $|C_w(N) - \sum_{n<N}a(n)|$. *Proof.* $w(n)w(n+2)=1$ off the crossing set;
each exceptional term contributes at most $2$ because $|a(n)|\le1$ and
$w(n)w(n+2)=-1$ there (`Op59.pair_prod_eq`). $\blacksquare$

**Lemma B (crossing count; PROVED, Lean `Op59.phaseCrossing_card_le`, with the parametrised form
`Op59.phaseCrossing_card_le_of_le`).** Let $\theta:\mathbb{N}\to\mathbb{R}$ be strictly increasing and
$c>0$. Then
$$\#\text{phaseCrossing}(N) \le 2\left(\left\lfloor \frac{\theta(N+2)}{c}\right\rfloor + 1\right).$$
*Proof.* For a fixed multiple index $k$, the fibre
$X_k = \{n<N : \theta(n) < kc < \theta(n+2)\}$ has at most two elements: if $m\le m'-2$ both lay in
$X_k$ then $kc < \theta(m+2)\le\theta(m') < kc$, a contradiction; so any two members of a fibre differ
by at most $1$, and the case split on whether $n_0+1\in X_k$ (for $n_0=\min X_k$) gives $\#X_k\le2$.
Summing over the fibres $k\le\lfloor\theta(N+2)/c\rfloor$ gives the bound. $\blacksquare$

**Corollary (angle-twist invisibility; PROVED, Lean `Op59.angle_twist_invisible`).** If every pair
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

## 4. Verification and evidence

All paths are relative to this folder. The commands below were run in this folder during packaging;
the observed outputs are quoted. `LEAN_PREFIX` defaults to `$HOME/lean` (elan at
`$LEAN_PREFIX/elan`, Mathlib4 at `$LEAN_PREFIX/mathlib4`); `check.sh` reconstructs `LEAN_PATH` from
`lake env` inside Mathlib and invokes the toolchain binary directly.

### 4.1 Lean developments (run here; observed output quoted)

```sh
./check.sh --all
```

elaborates the $11$ files in dependency order —
`Op57/Defs`, `Op57/Leading`, `Op57/Blocks`, `Op57/Obstruction`, `Op57`, `Op58/Defs`, `Op58/Split`,
`Op58`, `Op59/Sparse`, `Op59/Phase`, `Op59` — and prints one `[check] OK <file> (<s>s)` line per file.
Observed in this packaging session on this machine (Lean `v4.35.0-rc2`):

```
[check] OK   Op57/Defs.lean (170s)
[check] OK   Op57/Leading.lean (143s)
[check] OK   Op57/Blocks.lean (117s)
[check] OK   Op57/Obstruction.lean (74s)
[check] OK   Op57.lean (77s)
[check] OK   Op58/Defs.lean (69s)
[check] OK   Op58/Split.lean (22s)
[check] OK   Op58.lean (37s)
[check] OK   Op59/Sparse.lean (85s)
[check] OK   Op59/Phase.lean (23s)
[check] OK   Op59.lean (44s)
EXIT=0
```

**$11/11$ `[check] OK`, exit status $0$** — 5/5 for `Op57`, 3/3 for `Op58`, 3/3 for `Op59`, exactly as
`lean-Op57-README.md`, `lean-Op58-README.md`, `lean-Op59-README.md`, `round-007-handoff.md` §3,
`round-008-handoff.md` §3 and `round-009-handoff.md` §3 record. The only diagnostics printed are three
`push_neg` deprecation warnings in `Op59/Phase.lean` (lines $50$, $63$, $75$); there is no error, and
no `sorry`/`admit` declaration is reported. Axiom queries (also run here; the footprint output is
quoted in §4.2):

```lean
import Op57
#print axioms Op57.F_eq_fblock
#print axioms Op57.chi3_F_lt_one
#print axioms Op57.leading_forced_parity_odd_eq
import Op58
#print axioms Op58.Sh2_split
#print axioms Op58.Ccore_eq_poly
import Op59
#print axioms Op59.sparse_pair_bound
#print axioms Op59.angle_twist_invisible
```

### 4.2 Axiom footprints (run here; observed output quoted)

The queries above were run against the `.olean` files produced by the build, with `LEAN_PATH`
reconstructed the same way `check.sh` does. **Every one of the $19$ queried declarations reports exactly**

```
depends on axioms: [propext, Classical.choice, Quot.sound]
```

— for `Op57`: `F_eq_fblock`, `hasSum_F_of_periodic`, `leading_forced_of_hasSum_geom`,
`leading_forced_parity_even`, `leading_forced_parity_odd`, `leading_forced_parity_even_eq`,
`leading_forced_parity_odd_eq`, `chi3_F_lt_one`, `chi4_F_lt_one`, `chi3_no_leading_threshold`,
`chi4_no_leading_threshold`; for `Op58`: `Sh2_split`, `Ccore_eq_poly`, `liouville_pair`,
`poly_identity`, `even_shift`; for `Op59`: `sparse_pair_bound`, `phaseCrossing_card_le`,
`angle_twist_invisible`. Exit status $0$. No `sorryAx`, no `native_decide` assumption, and no axiom
beyond the three — which confirms the folder's record (each `lean-OpNN-README.md` §Status: "0 `sorry`,
0 `axiom`", footprint `[propext, Classical.choice, Quot.sound]`, and "no `native_decide`" for `Op57`).
The build prints only `push_neg` deprecation warnings (`Op59/Phase.lean` lines $50$, $63$, $75$).

### 4.3 Python checks (all run here; each exits 0)

```sh
python3 verify/007/01_twisted_threshold.py   # exploratory first probe (superseded by 02–05)
python3 verify/007/02_leading_law.py         # limit law, forced constants, criterion
python3 verify/007/03_character_scan.py      # exhaustive real characters mod q <= 60
python3 verify/007/04_second_order.py        # OP-5' and the c5 calibration
python3 verify/007/05_limit_rate.py          # the O(1/n) rate of the limit law
python3 verify/008/01_reduction.py           # (R1),(R2),(R3), discrepancy 0
python3 verify/008/02_level_and_growth.py    # C(K) growth; level of distribution of lambda
python3 verify/008/03_function_field.py      # Weil/Deligne; F_q[T] Chowla and twin counts
python3 verify/009/01_angle_parity.py        # crossing counts against the Lean bound
python3 verify/009/02_omega_sign_test.py     # the Omega-sign table
```

Observed, on this machine (numpy 2.5.0, mpmath 1.3.0; all ten exited $0$):

* `verify/007/05_limit_rate.py` — $n(\Phi_c-F_r)$ stabilises, e.g. for $c\equiv1$
  $n(\Phi-F)\to2.03885351\ldots$; for the parity sieve $r=0$: $-0.03405277$ (residue $0$),
  $-0.04134778$ (residue $1$), $+0.07540055$ (residue $2$) at $n=2\cdot10^6$; for $\chi_{11}$,
  $r=2$: $0.186576633$. The observed limit for $r=0$ is $2.03885351$, matching the source's
  `c = 1: n(Φ−F) → 2.03885351…`.
* `verify/007/02_leading_law.py` — at $a=0.7$, $n\approx2\cdot10^5$, the observed
  $|\Phi_c-F_r(e^{-a})|$ is $1.02\cdot10^{-5}$ for $c\equiv1$, $5.03\cdot10^{-6}$ / $5.16\cdot10^{-6}$
  for the parity sieve ($r=0,1$), $1.70\cdot10^{-7}$, $2.07\cdot10^{-7}$, $3.77\cdot10^{-7}$ for
  $\chi_3$, $1.88\cdot10^{-7}$ … $6.71\cdot10^{-7}$ for $\chi_4$, and $6.99\cdot10^{-6}$ … for the
  principal character mod $3$. The script's root-finding reproduces $x=1/\sqrt2=0.707106781186548$
  and $x=(\sqrt5-1)/2=0.618033988749895$ to all printed digits, and prints
  $\max_x F_r = 0.333333333$ for $\chi_3$ and $0.500000000$ for $\chi_4$.
* `verify/007/03_character_scan.py` — the observed count line is
  `real characters scanned : 187`, `non-principal among them : 128`,
  `(chi, r) pairs scanned : 4537`, `... pairs with a threshold (max>=1): 1349 (29.7%)`, and the global
  maximum over non-principal real characters is `q = 47, chi = [0,1,1,1,1,-1,...], r = 0, x* = 1.0`,
  `max F_r = 5.000000000000000`. Principal-character crossing constants observed:
  $q=2$: $x^*=0.61803398875$, $a=0.48121182506$; $q=3$: $0.543689012692$, $0.609377863436$;
  $q=5$: $0.508660391642$, $0.675974692103$; $q=7$: $0.502017055178$, $0.689121185409$;
  $q=12$: $0.704407524388$, $0.350398220436$.
* `verify/007/04_second_order.py` — calibration at $c\equiv1$: the printed $n\,(p(n)-(an+g))$ column
  is $-0.00269920017004$ ($n=2000$), $-0.00269823084551$ ($5000$), $-0.00269774603663$ ($20000$),
  $-0.00269764906312$ ($50000$), converging to
  $3(\log2)^2-(25/12)\log2 = -0.0026975844\ldots$. Parity sieve, even $r$: $\gamma_1=-0.0053951688239$
  with $n\,(p-(an+\gamma)) = -0.00540162968397,\ -0.00539775421061,\ -0.00539581530089,\
  -0.00539542742512$. Parity sieve, odd $r$: $\gamma_1 = 0.0203439629608$ with
  $0.020345885304,\ 0.0203447338792,\ 0.0203441559383,\ 0.0203440401717$. $\chi_{11}$, $r=2$:
  $x^*=0.643733393665$, $\gamma=-0.446756900116$, $\gamma_1=-0.245434754879$ with
  $-0.244676972154,\ -0.245130598369,\ -0.24535850083,\ -0.245404249429$. The script also prints the
  no-threshold cases: `chi3 r=0`, `chi3 r=2`, `chi4 r=0` and `chi11 r=0` all report *no root in (0,1)*.
* `verify/007/01_twisted_threshold.py` — the exploratory first probe exits $0$; its own header states
  it is superseded by `02`–`05`, and its two helper stubs (`build_char`, `chi_mod`) still
  `raise NotImplementedError` but are never called.
* `verify/008/01_reduction.py` — sieve to $N=2\cdot10^6$. (R3): `mismatches = 0` over
  $k=1..707$ and `diff=0` at $k=10^3,10^4,10^5,10^6$ by explicit factorisation. (R2): `diff=0` at
  $K=100,1000,10000,20000$; `core form only` gives $C(10^5)=366$ and $C(10^6)=168$ (the second line is
  the script's own duplicate print). (R1): the observed table is
  $$\begin{array}{r|rrrr}
  x & S_2(x) & S_1(\lfloor x/2\rfloor) & C(\lfloor(x+1)/2\rfloor) & \text{diff}\\\hline
  10^3 & -30 & 12 & -42 & 0\\
  10^4 & 12 & 72 & -60 & 0\\
  10^5 & 258 & 146 & 112 & 0\\
  10^6 & 68 & 36 & 32 & 0\\
  1999998 & -940 & -1109 & 169 & 0
  \end{array}$$
  with the one-point sum $\sum_{n\le x}\lambda(n)$ printed separately
  ($-14,-94,-288,-530,-1232$ at those scales). The discrepancy is exactly $0$ at every scale, as the
  source reports. (The round note's §1 table for (R1) quotes the same five rows.)
* `verify/008/02_level_and_growth.py` — part (A), the $C(K)$ table quoted in §3.2
  ($-42,-6,366,32$ with $\max|C|=61,98,369,488$ and $\max|C|/\sqrt K = 1.929,0.980,1.167,0.488$) at
  $x=10^6$; part (B), level of distribution with $x^{1/2}=1000$:
  $M(x;2)=916$ ($M/(x/q)=0.0018$), $M(x;100)=274$ ($0.0274$), $M(x;1000)=106$ ($0.1060$),
  $M(x;5000)=56$ ($0.2800$), $M(x;50000)=18$ ($0.9000$) — cancellation excellent for $q\ll\sqrt x$,
  gone for $q\gg\sqrt x$. The script also prints the large-sieve form $V(q)$.
* `verify/008/03_function_field.py` — part (A): the Weil bound `max|K(a,b)| <= 2 sqrt(p)` and the exact
  Gauss values hold at every prime tested, with `ok = True`: $p=101$: $18.660160 \le 20.099751$,
  Gauss $10.049876 = \sqrt{101}$; $p=211$: $28.306569 \le 29.051678$, $14.525839$; $p=1009$:
  $62.114892 \le 63.529521$, $31.764760$. Part (B): over $\mathbb{F}_3[T]$ at $n=8$ ($q^n=6561$,
  $810$ irreducibles) the Chowla correlation is $-30$ ($|Ch|/q^n = 0.0046$) and the twin count is
  $36$ (against $q^n/n^2 = 102.5$); over $\mathbb{F}_5[T]$ at $n=5$ ($3125$, $624$ irreducible) $24$
  ($0.0077$) and $98$ (against $125.0$); over $\mathbb{F}_2[T]$ the twin count is $0$ for every $n$,
  the char-2 degeneracy the source records (every irreducible of degree $\ge2$ has nonzero constant
  term, so $f+1$ is divisible by $T$). The script's closing line records that the analogous over
  $\mathbb{Q}$ statement is **OPEN**.
* `verify/009/01_angle_parity.py` — $X=10^7$; the Lean-bound check `bindok` is `True` at every $t$
  tested ($t=1,2,5,10,14.134725,21.022040,50,100$): e.g. crossed $=10$ vs bound $12.3$ at $t=1$,
  crossed $=800$ vs bound $1028.1$ at $t=100$; and $|C-S| \le 2\cdot\text{crossed}$ holds at every
  $t$ ($8\le20$, $14\le98$, $42\le262$, $34\le842$, $76\le1600$). The untwisted correlation is
  $S=1244$ and the one-point sum is $-842$ at $X=10^7$.
* `verify/009/02_omega_sign_test.py` — the table quoted in §3.3 ($S=1244$ at $x=10^7$; the circular
  row gives $T/x=1.0000$, $M/x=0.9999$; $(-1)^\omega$ gives $U/x=0.4717$, $T/x=0.1591$, $M/x=0.1589$;
  squarefree, $\chi_4$ and the angle sign give $M/x\approx0$).

### 4.4 What the numerics do not show

Finite ranges ($10^6$–$10^7$) prove nothing about asymptotics: the programme's dictionary F4 records
finite-prefix indeterminacy. The Lean lemmas are asymptotics-free and exact; they are the rigorous
content of the rounds.

## 5. What is not claimed

* **The twin prime conjecture is not proved here, and neither is $S(x)=o(x)$ nor $S_2(x)=o(x)$.** The
  two-point Chowla conjecture at shift $2$ remains **OPEN**. The `008` reduction is a *sufficiency*,
  not an equivalence: `Op58.Sh2_split` is an identity, but its correct consequence
  `shift_two_of_shift_one_and_core` is one-directional (if both halves vanish then shift 2 vanishes);
  the converse fails in general because the two halves can cancel. Both halves are open, and the
  round's own erratum (in `ConeLean/ShiftTwoCore.lean` of the sibling item) records that the
  un-averaged Chowla conjecture is open for **every** $k\ge2$, i.e. for every shift: what
  Matomäki–Radziwiłł–Tao prove is the **average over shifts**, not a prescribed shift.
* **The limit law (LIMIT) and the second-order expansion (OP-5$'$) are NUMERICAL**, not formalised. The
  proof of (LIMIT) is classical (Abel/Euler–Maclaurin) and needs real-exponent manipulation and a
  uniform $O(1/n)$ estimate of the same order as `006`'s `PhiAsymptotic`; out of scope for one round.
* **The threshold criterion is proved only negatively** (for $\chi_3$ and $\chi_4$, wholly in Lean).
  The positive direction ($\max_{[0,1)}F_r\ge1$ implies a threshold with (OP-5$'$)) is **not**
  formalised. The general inequality $F_r<1$ for all non-principal $\chi$ is **FALSE** (scan: $q=47$
  attains $5.0$); there is no uniform character barrier, and solvability of (LEAD) is genuinely
  character-dependent.
* **Complex characters are not treated.** For complex $\chi$, $\Phi_\chi$ is complex and
  $\Phi_\chi=1$ is a complex equation; the natural objects would be $\operatorname{Re}\Phi_\chi$ or
  $|\Phi_\chi|$. All characters in the numerics are real.
* **The $\mathbb{F}_q[T]$ theorems are cited, not reproved.** The Sawin–Shusterman results are
  external; their two abstracts were read in the round and are quoted verbatim by the source. The
  numerics in `verify/008/03_function_field.py` exhibit the engine and the consequences; they do not
  prove the cited theorems.
* **The number-field spectral realisation is not constructed** (obstruction O1), and this is a finding,
  not a gap: no automorphic object with Hecke eigenvalues $\lambda$ is known, and
  $L(s,\lambda)=\zeta(2s)/\zeta(s)$ has no monodromy. The claim "no automorphic form has these
  coefficients" is **not** proved here.
* **The level-of-distribution data is finite** ($x=10^6$) and proves nothing; it locates, not decides,
  the $\theta=1/2$ wall. The transfer $(H_\theta)\Rightarrow S_2=o(x)$ is the standard linear-sieve
  implication: **stated, not formalised**.
* **$C(K)=o(K)$ is OPEN.** The empirical $O(\sqrt K)$ shape is a target, not a result.
* **In `009`, the analytic instantiation is not formalised.** The Lean lemmas are abstract in
  $\theta$; the case $\theta(n)=t\log n$, $c=\pi$ is a one-line substitution not carried out. The
  dichotomy ("preserves $\Rightarrow$ uninformative; destroys $\Rightarrow$ useless") is a
  numerical/structural finding; only the angle side of it is a theorem. The finite ranges
  ($10^6$–$10^7$) prove nothing about asymptotics. The coupling constant $0.4717$ for
  $(-1)^{\omega(n)}$ is the density associated with "all exponents odd", a main-term constant of a
  Dirichlet series with a pole, not a parity-breaking cancellation.
* **Corrections of earlier claims, kept visible.** (a) The first framing of `007` was "non-principal
  characters destroy the threshold", together with the conjecture $F_r<1$ for **all** non-principal
  characters; the exhaustive scan **refuted** the uniform bound, and the corrected statement is the
  criterion $\max_{[0,1)}F_r\ge1$. (b) A first draft of the `008` reduction used the wrong meaning of
  $S_1$ (the one-point sum instead of the shift-one correlation) and produced a nonzero discrepancy;
  the misreading is recorded in the round's technique notes, and §2 fixes the convention.
* **A citation marked unverified in the source.** Duke–Friedlander–Iwaniec, *Equidistribution of roots
  of a quadratic congruence to prime moduli*, Ann. of Math. (2) **141** (1995) 423–441, is recorded by
  the source as an **unverified citation** (the number-field prototype of the spectral method for
  quadratic-polynomial sums). It is reproduced here only as such.
* **Nothing here bears on the Riemann Hypothesis**, and the source says so explicitly in each round.
* **Provenance of this edition.** The three rounds' `index.html` pages are **not** included in this
  folder: they are rendered views of the corresponding `round-NNN-README.md`, which are here. Sources
  are otherwise reproduced unmodified except that markdown links have been re-pointed into this
  folder. This edition makes no priority claim.

## 6. Value and significance

The three attempts close routes rather than open problems, and the source says exactly that: none of
the three produced a new open problem, and their function is to **close off** routes. Their value is
fourfold.

**They convert slogans into machine-checked statements.** The parity barrier, in the `008`/`009`
reading, is usually a heuristic about bounded-depth sieves. Here it acquires proved local forms: the
regrouping identity and the two non-existence theorems for $\chi_3,\chi_4$ (`007`); the exact split of
the shift-2 correlation into a solved-shape dilate and a quadratic-polynomial core, with the
non-multiplicativity of both the correlation and the core witnessed explicitly (`008`); and the
sparse-pair plus crossing-count lemmas, which pin down *why* an angle sign cannot see the pair (`009`).

**They localise the missing input precisely.** The `008` verdict does not say "spectral methods fail";
it names the three components (S1)–(S3) such an input must supply, exhibits the setting where all three
exist ($\mathbb{F}_q[T]$, Sawin–Shusterman), and identifies over $\mathbb{Q}$ the two that are absent:
no sheaf/monodromy object for $\lambda$, and no non-periodic parity-breaking sign. The route therefore
*reduces* to Type-II/bilinear inputs over $\mathbb{Q}$ — a negative result that is more useful than a
vague barrier, because it tells a future attempt which of the three components to attack.

**They produce positive intermediate structure.** The regrouping $F_r = f_r/(1-x^q)$
(`Op57.F_eq_fblock`) is proved once for an arbitrary periodic coefficient and reused for every
character; the forced leading equation $x^s = 1-x^q$ generalises `006`'s anchor; the twisted
second-order expansion at $c\equiv1$ reproduces `006`'s constant $3(\log2)^2-(25/12)\log2$ exactly, so
the deformation is a strict extension of the earlier theorem rather than a parallel theory; and the
shift-2 reduction turns "the correlation is not multiplicative" from a blocker into a pointer at
$\sum\lambda(k^2-1)$, the canonical spectral-method target. The threshold criterion itself is a
genuinely character-dependent arithmetic condition, with the sharp fact that for $\chi_3$ and $\chi_4$
the threshold is *destroyed* while for $29.7\%$ of $(\chi,r)$ pairs over real characters mod $q\le60$
it exists.

**They record their own corrections.** The refuted uniform bound, the corrected criterion, the
misread $S_1$, and the explicitly labelled unverified citation are all part of the record. The value of
publishing them is that the next attempt cannot re-make these errors, and that the negative results are
stated with the strength they actually have: PROVED where machine-checked, MEASURED where finite-range,
CONDITIONAL where cited, OPEN where open.

## Sources

Local sources are **local-only**: none of these files is published elsewhere except as this edition.
Line locators are as of this packaging.

| Source | What it supplied | Locator |
|---|---|---|
| `README.md`, this folder | the item's identity, the three attempts and their verdicts, the contents table, the provenance note, the `check.sh`/`verify` commands | whole file; §"What the item is", §"What is proved, what is refuted, what is open", §"Provenance" |
| `TRUTHS.md`, this folder | the §10 ledger: the seven PROVED rows with their Lean names, and the three verdicts verbatim | whole file (19 lines) |
| `Op57/Defs.lean` | `IsPeriodic`, `PhiChi`, `F`, `fblock`, `endpointValue`, `geom_term`, `geom_norm_lt_one` | whole file |
| `Op57/Leading.lean` | `leading_forced_of_hasSum_geom` (L35), `leading_forced_parity_even` (L66), `…_odd` (L74), `…_even_eq` (L82), `…_odd_eq` (L87) | quoted |
| `Op57/Blocks.lean` | `periodic_mod` (L30), `periodic_eq_of_mod_eq` (L45), `hasSum_F_of_periodic` (L50), `fblock_mod` (L112), `F_eq_fblock` (L128), `F_mod` (L134) | quoted |
| `Op57/Obstruction.lean` | `chi3` (L31), `chi4` (L34), the block-polynomial lemmas (L55–L82), `chi3_F_lt_one` (L135), `chi4_F_lt_one` (L141), `chi3_no_leading_threshold` (L147), `chi4_no_leading_threshold` (L153) | quoted |
| `Op58/Defs.lean` | `liouville_mul` (L39), `liouville_two` (L49), `liouville_sq` (L54), `liouville_pair` (L60), `poly_identity` (L65), `even_shift` (L75) | quoted |
| `Op58/Split.lean` | `Sh` (L26), `Ccore` (L29), `sum_range_even_odd` (L33), `Ccore_eq_poly` (L56), `Sh2_split` (L65) | quoted |
| `Op59/Sparse.lean` | `crossingSet` (L29), `pair_prod_eq` (L33), `sparse_pair_bound` (L42) | quoted |
| `Op59/Phase.lean` | `phaseCrossing` (L32), `phaseCrossing_card_le_of_le` (L39), `phaseCrossing_card_le` (L109), `angle_twist_invisible` (L123) | quoted |
| `Op57.lean`, `Op58.lean`, `Op59.lean` | the three umbrella imports | whole files |
| `check.sh` | the build command, the `LEAN_PREFIX` convention, the 11-file `--all` list | L38–L40 |
| `lean-Op57-README.md` | "5/5 `[check] OK`", 0 `sorry`, 0 `axiom`, footprint, no `native_decide`, and "not formalised here" | §Status, §Not formalised here |
| `lean-Op58-README.md` | "3/3 `[check] OK`", footprint, and the reduction in words | §Status, §In words |
| `lean-Op59-README.md` | "3/3 `[check] OK`", footprint, and the two lemmas in words | §Status, §In words |
| `round-007-README.md`, `round-007-handoff.md` | the objective verbatim; the TL;DR status table; the mid-course correction (the uniform bound is FALSE, $q=47$ attains $5.0$); the `c_5` calibration to 40 dps; what is not proved | handoff §1–§3, §6 |
| `round-008-README.md`, `round-008-handoff.md` | the verdict; the reduction; the evidence list; the misread of $S_1$; the unverified Duke–Friedlander–Iwaniec citation | handoff §2, §5, §6 |
| `round-009-README.md`, `round-009-handoff.md` | the two obligations; the TL;DR table; the Verdict; what is not proved | handoff §1–§3, §5 |
| `notes/007/generalisation-06.md` | the mathematical note: (LIMIT), the threshold criterion, the block polynomials, the proof sketches, (OP-5$'$) and the moments, the scan numbers, the status table | §0–§7 |
| `notes/008/automorphic-spectral-attempt.md` | the verdict paragraph; (R1)–(R3); (S1)–(S3); (O1)–(O5); the conditional transfer and $(H_\theta)$; the citations | §0–§7 |
| `notes/008/research.md` | the sharpest numerical target ($C(K)=O(\sqrt K)$, $C=o(K)$ unproved) | whole file |
| `notes/009/angle-parity-and-omega-signs.md` | Lemma A, Lemma B, the corollary, the criterion, the sign table, the reading, the honest scope | §1–§4 |
| `verify/007/01_twisted_threshold.py` … `verify/009/02_omega_sign_test.py` | the ten scripts, each run during packaging; observed output quoted in §4 | script headers and printed output |

SHA-256 of every file whose words are quoted above, computed on the files as packaged in this folder
(`shasum -a 256`):

| File | SHA-256 |
|---|---|
| `TRUTHS.md` | `04b98e188a9cc8e5035bfb2bc22cc4eb1ba89796cc24d31aa3ba60bc792f9bfc` |
| `README.md` | `c2cef4993f08773de41772f7e2b1605b4809eb814d5de384002de0c4f0f1ee4c` |
| `Op57/Defs.lean` | `f6d8d0f01b4b70706e6762f7fb6d50e77e1f3b82fc8c7dedebfff10c8988db22` |
| `Op57/Leading.lean` | `de2e594d285633c5d6246d620839f2f1f281e98db5eb5ef022496e51b9986839` |
| `Op57/Blocks.lean` | `5f24a0169e9f443cda3273ae41f551c9e63bb70376f5dfb36ce04938f233e553` |
| `Op57/Obstruction.lean` | `d097300882235c1c8d50f2d04a6d19a2e5209e9e490f7edcbe72c4aec5d1a114` |
| `Op58/Defs.lean` | `83efb3a9bb2ad2422c263fac906d33d2853af295b08bbb7a1bbce1e98b0abdf4` |
| `Op58/Split.lean` | `37bf89a87fd56ee4e6e30a7d13b2a8bbb7f51ae7172db0f12f9a94ebe20a7999` |
| `Op59/Sparse.lean` | `e13d42c994b2dbca386e95d76a2816d9b87c0be25f11980369732950fc01da23` |
| `Op59/Phase.lean` | `4ef7263eab48a46dbf3282dd9b2461298796af106dd6d5babb083ecb8110c95f` |
| `check.sh` | `b0eb7ed8ffd7fea2722893b96ed87c61aabc6a40da063bb68610ad1b89d9a375` |
| `notes/007/generalisation-06.md` | `9b63908c085d2fb92aff9917a259ddea3aa41c97bead4fe5d1c04a0939365b64` |
| `notes/008/automorphic-spectral-attempt.md` | `5cbf2a34fe3d0d43d84ea4f5437e95cd88fd124f10b26d27c558796d044d6c0a` |
| `notes/009/angle-parity-and-omega-signs.md` | `6633f5bc7d380bdf02a74e98b797669112ae81e88fc13d60ff6aa231c1255f1f` |

The remaining files read (the three `lean-OpNN-README.md`, the three `round-NNN-README.md`, the three
`round-NNN-handoff.md`, `notes/008/research.md`, the three root modules `Op57.lean`/`Op58.lean`/
`Op59.lean`, and the ten `verify/` scripts) are quoted in §4 or paraphrased above; their observed
script output is the transcript quoted in §4.3 rather than a file hash.

**External citations (from the sources, not read here).** W. Sawin, M. Shusterman, *On the Chowla and
twin primes conjectures over $\mathbb{F}_q[T]$*, arXiv:1808.04001, and *Möbius cancellation on
polynomial sequences and the quadratic Bateman–Horn conjecture over function fields*,
arXiv:2008.09905 — both abstracts read in round `008` and quoted verbatim by the source. From the
programme's verified ledger: Friedlander–Iwaniec $X^2+Y^4$; the asymptotic sieve; Polymath8b's parity
ceiling; Matomäki–Radziwiłł; Tao–Teräväinen. Duke–Friedlander–Iwaniec (1995) is recorded by the source
as an **unverified citation**.
