# The GORZ gap, closed — the exception set is nested, its supremum is one integer, and that integer is not RH

Self-contained. Every definition, every quoted theorem, every number, and every
proof used below is in this file; the companions at the end are optional.

**What is being closed.** Griffin–Ono–Rolen–Zagier proved that for each fixed
Jensen degree *d*, the polynomial J_{d,n} is hyperbolic for all sufficiently
large shifts *n*. The residue — call it the **GORZ gap** — is that nobody
controls the exceptions *uniformly in d*: for each *d* finitely many *n* may
fail, and no bound on how many, or on where they sit, survives as *d* → ∞.

**What this file proves.** The exception sets are **nested**, E(d) ⊆ E(d+1),
and their union is an **initial segment** [0, ν). Consequently the exception
count and GORZ's own threshold N(d) are both non-decreasing in *d*, both
bounded by ν, and both converge up to ν. The two-parameter gap collapses onto
a single integer, and every exception at every degree lies below it.

**What this file does not prove.** ν < ∞ is not proved here, and could not be:
it is a statement about ζ. And — this is the correction the file exists to
make — ν < ∞ is **not** RH. RH is ν = 0. §6 gives an explicit real entire
function of order ½, the same order as ξ's, that satisfies the uniformity with
constant 1 and is not hyperbolic. The uniformity is therefore not a sufficient
statement for RH, and any list that files it as one is wrong.

All numbers reproduce; §8 collects them, §9 is the code.

---

## 0. Standing disclaimer

The ladder identities of §2 are elementary: L1 is written out verbatim inside
[O'S] Corollary 3.3's proof, and L2's reciprocal step is used inside Corollary
3.8's proof (though identity (7) itself is not stated there). The Jensen
criterion is Pólya–Schur 1914; the Pólya–Wiman theorem invoked in §5 is
classical. What is new here is the *consequence for the exception sets* —
Theorems 1–3 and Corollaries 4–6 — which is stated in neither local paper,
together with the two computed witnesses of §7 and the correction of §6. Nothing below moves any wall. The gap that closes is a
bookkeeping gap; the gap that does not close is ζ's.

---

## 1. The problem, stated exactly

### 1.1 The objects

Riemann's kernel and the completed zeta function:

```
Φ(u) = Σ_{n≥1} ( 2π²n⁴e^{9u/2} − 3πn²e^{5u/2} ) · e^{−πn²e^{2u}}            (1)

ξ(½ + z) = Σ_{n≥0} γ(n)·z^{2n}/(2n)! ,      γ(n) = 4∫₀^∞ u^{2n}·Φ(u) du      (2)
```

Φ > 0 on ℝ, so **γ(n) > 0 for every n** — unconditionally; this positivity is
what Lemma L3 and the reduction (5) below need, and it is used nowhere else.
Numerically γ(0) = ξ(½) = 0.49712077819, and (2) reproduces an independent ξ
to 1.6e−61 at z = 0.1 (§8).

Write Ξ(t) = ξ(½ + it). Putting z = it in (2) and collecting in the variable
−t²:

```
Ξ(t) = F(−t²),     F(z) = Σ_{n≥0} γ(n)·z^n/(2n)! = Σ_{n≥0} a(n)·z^n/n! ,
a(n) = γ(n)·n!/(2n)!                                                        (3)
```

F is real entire of **order ½** ([O'S] Corollary 3.2's proof: "We know that
ξ(z) is real and entire of order 1/2", his ξ(z) being this F), hence of genus
0, hence of Pólya's class "genus 1\*" — the class in which the Jensen
criterion below is stated. a(n) > 0 for every n.

*Notation reconciliation, once.* Both papers write γ(m) for
m!/(2m)!·ξ^{(2m)}(½), which is this file's **a(m)**, not this file's γ(m). No
rescaling is involved (the 2019 PNAS normalisation was 8× larger; the two
papers cited here agree with (3) exactly). Everything below uses a(n), and the
first values are

```
  n      γ(n)                a(n)
  0      0.49712077819       0.49712077819
  1      0.022971944315      0.011485972158
  2      0.0029628484337     0.00024690403614
  3      0.0005992959466     4.9941328883e−06
  5      5.3038634278e−05    1.7539230912e−09
 10      1.3679861516e−06    2.0404225613e−18
 20      1.2135730923e−07    3.6186408981e−37
 30      3.0936393387e−07    9.8617708535e−57
```

### 1.2 Jensen polynomials and the criterion

For d ≥ 1 and n ≥ 0 the **Jensen polynomial of degree d and shift n** is

```
J_{d,n}(X) = Σ_{j=0}^{d} C(d,j)·a(n+j)·X^j                                   (4)
```

A real polynomial is **hyperbolic** if all its zeros are real. The
**Laguerre–Pólya class** LP consists of the real entire functions of genus 1\*
with only real zeros; equivalently, the locally uniform limits of real-rooted
real polynomials. Pólya–Schur's criterion, in the form used by both papers:

> **[O'S] Corollary 3.2.** *The function F^{(n)}(z) is hyperbolic if and only
> if J_{d,n}(z) is hyperbolic for all d ≥ 1.*

(Verbatim except that [O'S]'s symbol for the order-½ function is written F
here, per §1.1. His proof is one line from the fact that the Taylor
coefficients of F^{(n)} are those of F shifted by n, plus his Theorem 3.1 =
Pólya–Schur [PS14, p. 111]; it applies because F, and therefore every F^{(n)},
is real entire of order ½.) Every a(n) > 0, so F(z) > 0 for z ≥ 0 and any real
zero of F is negative; since Ξ(t) = F(−t²), F is hyperbolic exactly when every
zero of Ξ is real. Hence

```
RH  ⟺  F ∈ LP  ⟺  J_{d,n} hyperbolic for all d ≥ 1, n ≥ 0                   (5)
```

which is [O'S] Theorem 1.1, and is the criterion GORZ set out to attack.

### 1.3 The exception sets, and the gap

Define, for d ≥ 1,

```
E(d)  := { n ≥ 0 : J_{d,n} is NOT hyperbolic }        the exception set
N(d)  := 1 + max E(d)   (:= 0 if E(d) = ∅)           GORZ's threshold
E_∞   := ∪_{d≥1} E(d)                                 the exceptional shifts
D(n)  := min{ d : n ∈ E(d) }   (:= ∞ if none)        the witness degree
D*    := min{ d : E(d) ≠ ∅ }  = min_n D(n)           the first witness degree
```

N(d) — the least N for which J_{d,n} is hyperbolic at every n ≥ N — is the
quantity [GOR⁺] name when they write that their main result "provides an
effective upper bound for N(d)". The theorem being sharpened:

> **[GORZ19] Theorem 1** (as quoted by [O'S] p. 1). *For every fixed d,
> J_{d,n}(X) is hyperbolic for all sufficiently large n.*

i.e. N(d) < ∞ and #E(d) < ∞ for each d. Its effective form, and the finite-d
band:

> **[GOR⁺] Theorem 1.1.** *There is a constant c > 0 such that if n ≥ ce^d,
> then J_{d,n}(X) is hyperbolic.*
>
> **[GOR⁺] Theorem 1.2.** *If RH_m(T) is true and d ≤ ⌊T⌋², then J_{d,n}(X) is
> hyperbolic for all n ≥ m.*
>
> **[GOR⁺] Corollary 1.3.** *If d ≤ 9 × 10²⁴ and n ≥ 0, then J_{d,n}(X) is
> hyperbolic.*

(Corollary 1.3 is Theorem 1.2 fed with Platt–Trudgian's verification of
RH₀(3 000 175 332 800); 3 000 175 332 800² = 9.001 × 10²⁴. The proof of
Theorem 1.1 closes with the requirement n ≥ C̃·d^{13/3}(2 + 16C²)^{d/3}, whose
exponent tends to ⅓·log 18 = 0.9634… as C → 1.)

**The gap, stated as a proposition to be closed.**

```
(U)   sup_{d≥1} N(d) < ∞           — the uniformity
```

GORZ give N(d) < ∞ for each d; [GOR⁺] give N(d) ≤ ce^d; neither gives (U), and
[GOR⁺] Remark (3) says a converse to Theorem 1.2 is "highly unlikely … unless
one has hyperbolicity for all n ≥ m and all d ≥ 1", with Jensen polynomials
"ultimately quite inefficient at detecting zeros that violate RH_n". So the
exceptional corner is not shrinking toward empty by anything in either paper.

---

## 2. The two ladders

Everything follows from two identities and Rolle's theorem.

**Lemma L1 (the derivative ladder).** For every d ≥ 1, n ≥ 0,

```
(d/dX) J_{d,n}(X) = d · J_{d−1,n+1}(X)                                      (6)
```

*Proof.* Differentiate (4) termwise: Σ_{j≥1} j·C(d,j)a(n+j)X^{j−1}, reindex
k = j−1, and use (k+1)C(d,k+1) = d·C(d−1,k). ∎

**Lemma L2 (the reciprocal ladder).** Write J\*\_{d,n}(X) := X^d·J_{d,n}(1/X) =
Σ_k C(d,k)·a(n+d−k)·X^k. Then for every d ≥ 1, n ≥ 0,

```
(d/dX) J*_{d,n}(X) = d · J*_{d−1,n}(X)                                      (7)
```

*Proof.* Identical bookkeeping on the reversed coefficient list. ∎

Both were verified symbolically with generic coefficients for d = 1 … 8:
residual identically 0 in every case (§8).

**Lemma L3 (propagation).** If J_{d,n} is hyperbolic then so are J_{d−1,n+1}
and J_{d−1,n}.

*Proof.* J_{d,n} has strictly positive coefficients, so it has degree exactly
d and J_{d,n}(0) = a(n) ≠ 0; its zeros, being real, are all negative.
(i) Rolle applied to a hyperbolic polynomial gives a hyperbolic derivative;
by (6) that derivative is d·J_{d−1,n+1}.
(ii) J\*\_{d,n} has as its zeros the reciprocals of those of J_{d,n} — d real
numbers, since none is 0 — so J\*\_{d,n} is hyperbolic of degree d. Rolle
again, with (7), makes J\*\_{d−1,n} hyperbolic; a(n) ≠ 0 and a(n+d−1) ≠ 0, so
reversing once more gives J_{d−1,n}. ∎

Clause (i) is exactly the step inside [O'S] Corollary 3.3; the reciprocal of
clause (ii) is the step inside [O'S] Corollary 3.8. What follows from putting
them together is not in either paper.

**Both implications are strictly one-way**, so L3 has content. Over 300 random
positive rational sequences, in exact arithmetic, the scan produced 6 973
hyperbolic and 18 227 non-hyperbolic instances — the test is not vacuous — and
checked 4 946 instances of L3 with **0 violations**. A separate run of 300
sequences found the converse, "J_{d−1,n} hyperbolic ⟹ J_{d,n} hyperbolic",
failing in 3 975 of 20 700 trials.

---

## 3. The three theorems

**Theorem 1 (nesting).** For every d ≥ 1, `E(d) ⊆ E(d+1)`.

*Proof.* Contrapositive of L3(ii): if n ∉ E(d+1), i.e. J_{d+1,n} is
hyperbolic, then J_{d,n} is hyperbolic, i.e. n ∉ E(d). ∎

So the exception sets form an increasing chain, #E(d) and N(d) are
non-decreasing in d, and — this is the whole point — **no exception ever
disappears as the degree grows.** Raising d can only reveal.

**Theorem 2 (initial segment).** Define

```
ν := min{ n ≥ 0 : F^{(n)} ∈ LP }   ∈  {0, 1, 2, …} ∪ {∞}                    (8)
```

Then `E_∞ = { n : 0 ≤ n < ν }`.

*Proof.* By the Jensen criterion ([O'S] Cor 3.2, legitimate since every
F^{(n)} is real entire of order ½), n ∉ E_∞ ⟺ J_{d,n} hyperbolic for all d ⟺
F^{(n)} ∈ LP. LP is closed under differentiation, so F^{(n)} ∈ LP implies
F^{(n+1)} ∈ LP: the set {n : F^{(n)} ∈ LP} is upward closed, its complement
E_∞ is downward closed, and ν is by definition its first non-element. ∎

(The differentiation step, read through L1, is [O'S] Corollary 3.3: "If
ξ^{(n)}(z) is hyperbolic then ξ^{(m)}(z) is also hyperbolic for all m ≥ n.")

**Theorem 3 (the uniformity constant).** With ν as in (8):

```
sup_{d≥1} N(d)  =  sup_{d≥1} #E(d)  =  ν ,                                  (9)
```

both suprema attained when ν < ∞. Hence

```
(U) holds   ⟺   ν < ∞   ⟺   some derivative of F is hyperbolic.            (10)
```

*Proof.* E(d) ⊆ E_∞ = [0, ν) by Theorem 2, so #E(d) ≤ N(d) ≤ ν for every d.
For the reverse: if ν < ∞, every n < ν has a finite witness degree D(n), and
at d = max_{n<ν} D(n) Theorem 1 gives E(d) ⊇ {D(n) ≤ d} = [0, ν), so
E(d) = [0, ν) exactly, #E(d) = N(d) = ν. If ν = ∞, the same argument at
d = max_{n<K} D(n) gives #E(d) ≥ K for every K. ∎

**Read (9) against [GOR⁺] Theorem 1.1.** Their bound is N(d) ≤ ce^d. The truth
is that N(d) is *monotone and bounded*, increasing to ν. The exponential is
therefore never tight for large d — it is an artifact of the certificate, not a
feature of the family. (An aside for readers of the companion file: this is the
same conclusion its §3 reached from the certification side, where the interval
LDLᵀ widths of the Hermite family come out flat in n. Nothing below depends on
that remark.)

---

## 4. Four corollaries

**Corollary 4 (the wedge is flat).** For every d ≥ 1 and every n ≥ ν, J_{d,n}
is hyperbolic. The boundary of the hyperbolic region in the (d, n) quarter
plane is the horizontal line n = ν.

Immediate from Theorem 2, but worth stating in these terms: the two published
onset thresholds — [GOR⁺]'s n ≥ ce^d and [O'S]'s n/log²n ≥ d^{3/4}/2 for the
Hermite family — are curves rising in d above a truth that does not rise at
all. Any measured onset table will therefore fit a constant, not an exponent,
once d is large enough; the exponents being fitted belong to the certificates.

**Corollary 5 (column reduction).** If J_{d,0} is hyperbolic for every d ≤ D,
then J_{d,n} is hyperbolic for every (d, n) with d + n ≤ D.

*Proof.* Suppose J_{d,n} is not hyperbolic with d + n ≤ D. Apply the
contrapositive of L3(i) n times: J_{d+1,n−1}, J_{d+2,n−2}, …, J_{d+n,0} are
each non-hyperbolic. But d + n ≤ D. ∎

The whole two-parameter family is decided by its **n = 0 column**: D checks
certify a triangle of ≈ D²/2 pairs. This is the cheap direction of GORZ
verification, and it needs no zero data at all.

**Corollary 6 (the hardest shift is nearly the easiest).** D(0) ≤ D(n) + n for
every n; hence `D* ≤ D(0)` always, and `D(0) < D* + ν` whenever ν < ∞.

*Proof.* The same n-fold application of L3(i); the second bound applies it at
the n₀ < ν achieving D\* = D(n₀). ∎

So the shift that carries RH itself, n = 0, fails at a degree exceeding the
earliest failure anywhere by less than ν. Unconditionally [GOR⁺] Corollary 1.3
gives D\* > 9 × 10²⁴, so under ¬RH with ν < ∞ the n = 0 column's first failure
lies in (9 × 10²⁴, D\* + ν) — a window of width ν above a threshold nobody can
compute past.

**Corollary 7 (the column decides ν = 0 — classical, recovered).** ν = 0 ⟺
J_{d,0} is hyperbolic for every d ≥ 1.

*Proof.* ν = 0 means F ∈ LP, and [O'S] Corollary 3.2 at n = 0 says exactly
F ∈ LP ⟺ J_{d,0} hyperbolic for all d ≥ 1. The ladders give the same thing
without re-invoking Pólya–Schur: if some J_{d,n} is not hyperbolic, n
applications of L3(i)'s contrapositive make J_{d+n,0} not hyperbolic — this
is Corollary 5 read at D = ∞ — and conversely ν = 0 makes every J_{d,n}
hyperbolic by (5). ∎

Unlike Corollaries 4–6 this statement is not new: it is the Jensen–Pólya
criterion at shift 0, a century old. It is stated because of what it makes
explicit next to Theorem 3: RH — ν = 0, by (5) — is a statement about the
**single column n = 0**, of which Corollary 5 is the finite-degree shadow
(D checks on the column certify the triangle d + n ≤ D) and [GOR⁺]
Corollary 1.3 is the column verified through d ≤ 9 × 10²⁴. The column reads
the alternative "ν = 0 versus ν ≥ 1" and nothing finer: no finite prefix of
it computes the value of ν.

---

## 5. What ν is

```
ν = 0                    ⟺   F ∈ LP   ⟺   RH.
ν < ∞                    ⟸   ξ has only finitely many non-real zeros.
ν = ∞                    ⟹   ξ has infinitely many non-real zeros.
```

The middle line is the **Pólya–Wiman theorem**: *if f is a real entire function
of order < 2 with only finitely many non-real zeros, then f^{(n)} has only real
zeros for all sufficiently large n.* F has order ½, so it applies verbatim.
(Conjectured by Pólya; proved for order < 2 by Craven–Csordas–Smith, *Ann. of
Math.* **125** (1987) 405–431 — **this attribution is from memory; verify it
before publishing.** The related and definitely-local reference is Ki–Kim, *On
the number of nonreal zeros of real entire functions and the Fourier–Pólya
conjecture*, Duke Math. J. **104** (2000) 45–73, which is [KK00] in [O'S]'s
bibliography.)

Both remaining implications are one-way, and the second is *provably* one-way
in the ambient class: f(z) = (1 + c) − cos z with c > 0 is real entire of order
1 with f′ = sin z ∈ LP, so ν = 1, while cos z = 1 + c has the infinite family
of non-real solutions z = ±i·arccosh(1+c) + 2πk. Finiteness of the non-real
zero count is sufficient for ν < ∞ and not necessary. (This f has vanishing odd
Taylor coefficients, so it is not a witness about E(d) — L2 needs positivity —
only about the implication.)

So the state of knowledge, unconditionally, is:

| statement | status |
|---|---|
| N(d) < ∞ for each d | [GORZ19] Theorem 1 |
| N(d) ≤ ce^d | [GOR⁺] Theorem 1.1 |
| N(d) non-decreasing, sup N(d) = ν | **Theorems 1–3 above** |
| E(d) = ∅ for d ≤ 9 × 10²⁴ | [GOR⁺] Corollary 1.3 |
| ν < ∞ | open — implied by "finitely many off-line zeros" |
| ν = 0 | open — this is RH |

The GORZ gap, as posed ("finitely many small-n exceptions at each d, with no
uniform-in-d control of how many"), is closed: the count is uniform, its exact
value is ν, the exceptions all lie in [0, ν), and the whole family reduces to
one column. What is not closed is the value of ν — and that is not a gap in the
Jensen machinery, it is ζ.

---

## 6. The correction: the uniformity is *not* a sufficient statement for RH

[horn-helix-revisited.md](horn-helix-revisited.md) §4.3 lists, under "the
minimal new theorems that would finish it":

> **2. A uniformity**: the number of Jensen exceptions at degree d is bounded
> uniformly in d (closes the GORZ gap; INTEGERS.md §5).

It closes the GORZ gap; it does **not** finish RH. By (10) the uniformity is
ν < ∞, and RH is ν = 0. Proving sup_d N(d) ≤ 17 would leave RH exactly where
it is. The item is correctly filed as a *gap closure* and incorrectly filed as
a *sufficient statement*, and the difference is the whole set {1, 2, 3, …}.

That this is a real distinction and not a formal quibble needs a witness in the
right class. Here is one, computed in §7.2: **G(z) = (z² + 1)·cosh(√z)**. It
is real entire of order ½ — the same order as ξ's F, in the same genus-1\*
class the Jensen criterion quantifies over — with strictly positive Taylor
data, and with exactly two non-real zeros, ±i. Its exception sets are

```
E(1) = ∅ ,      E(d) = {0}  for every d ≥ 2,        so   sup_d N(d) = ν = 1.
```

Uniformity with constant 1, and no hyperbolicity. Nothing in the uniformity
statement can see the difference between this G and a hyperbolic one.

What a witness like this does **not** do is say anything about ζ. There is no
construction here of an ξ with off-line zeros, and none is possible by these
means. The witness settles a question of logic — whether (U) implies (5) — and
the answer is no.

---

## 7. The witnesses, computed

### 7.1 An exactly solvable model: G(z) = (z² + b z + c)·e^z

Real entire of genus 1 (hence genus 1\*), with exactly one conjugate pair of
non-real zeros when Δ₀ := b² − 4c < 0. Differentiating, G^{(m)} = q_m(z)e^z
with q_m = z² + b_m z + c_m and

```
b_m = b + 2m ,   c_m = c + mb + m² − m ,   Δ_m = b_m² − 4c_m = Δ₀ + 4m       (11)
```

so G^{(m)} ∈ LP ⟺ Δ_m ≥ 0, giving `ν = ⌈−Δ₀/4⌉`. The Jensen sequence is
a_m = G^{(m)}(0) = c_m, a quadratic in m, and the whole family factors: for
d ≥ 2,

```
J_{d,n}(X) = (1 + X)^{d−2} · Q_{d,n}(X) ,   disc Q_{d,n} = d·( d·Δ_n + 4c_n ) (12)
```

— an exact identity, verified symbolically for d = 2 … 6, and checked against
brute-force real-root counting on 6 072 (d, n) pairs across 120 random
parameter choices with **0 mismatches**. So

```
n ∈ E(d)   ⟺   Δ_n < 0  and  d > 4c_n/|Δ_n| ,       D(n) = ⌊4c_n/|Δ_n|⌋ + 1  (13)
```

— a threshold in d, which is Theorem 1 made visible. At b = 1, c = 3
(Δ₀ = −11, a_m = m² + 3, ν = 3), exact rational arithmetic gives

```
   d      E(d)          #E(d)   N(d)
   1      ∅               0      0
   2      {0}             1      1
   3–9    {0,1}           2      2
  ≥10     {0,1,2}         3      3      = ν
```

with D(0) = 2, D(1) = 3, D(2) = 10 as (13) predicts, nesting at every step,
every exception below ν, and nothing new appearing through d = 10⁶.

### 7.2 The order-½ witness: G(z) = (z² + 1)·cosh(√z)

cosh(√z) = Σ_k z^k/(2k)! lies in LP with zeros at −((2k+1)π/2)², and has order
½; multiplying by z² + 1 keeps the order and inserts one non-real pair. The
Jensen sequence a_m = m!·(1/(2m−4)! + 1/(2m)!) is positive throughout:

```
a = 1, 1/2, 25/12, 361/120, 1681/1680, 5041/30240, …
```

Exact real-root counting, d = 1 … 11 and n = 0 … 11:

```
  d = 1   E(d) = ∅
  d ≥ 2   E(d) = {0}          nested at every step, #E(d) = N(d) = 1 = ν
```

Two further instances behave the same way: (z² + ¼)cosh√z gives E(d) = {0} for
d ≥ 2, and (z² + 2z + 2)cosh√z gives E(d) = ∅ for d ≤ 2 and {0} for d ≥ 3 —
the same picture with the witness degree shifted by one. This is the §6 object.

### 7.3 The detection law — [GOR⁺] Remark (3), as a formula

Take b = 2 − 1/K, c = 1 in §7.1: q₀ has a conjugate pair approaching the double
root −1 as K grows, with |Δ₀| < 4 so ν = 1 for every K. Writing β for the
imaginary part of that pair, (13) collapses to

```
D(0) = ⌊ β^{−2} ⌋ + 1                                                       (14)
```

exactly. Brute force against the closed form:

```
   K       β = Im(root)     D(0) measured   D(0) from (14)
    1      0.866025               2               2
    2      0.661438               3               3
    4      0.484123               5               5
    8      0.347985               9               9
   16      0.248039              17              17
   32      0.176085              33              33
   64      0.124756              65              65
   10²     9.987e−02            n/a            101      (β^{−2} = 100.2506)
   10³     3.162e−02            n/a           1001      (β^{−2} = 1000.2501)
   10⁶     1.000e−03            n/a        1000001      (β^{−2} = 1000000.25)
```

**The count stays 1; the degree needed to see it is unbounded.** That is the
exact shape of the GORZ gap: uniformity in the number of exceptions coexists
with unboundedness in the degree that exhibits them, and it is why Theorem 3
costs nothing and ν costs everything. It is also [GOR⁺] Remark (3) —
"ultimately quite inefficient at detecting zeros" — with an exponent: detection
degree ≍ (distance off the line)^{−2}.

Run the inequality the other way and it prices the verified band. In this model
"hyperbolic through degree D" forces β ≤ D^{−1/2}; at [GOR⁺]'s D = 9 × 10²⁴
that is β ≤ 3.3 × 10⁻¹³. **For ξ no such converse is available** — that is
precisely what [GOR⁺] Remark (3) says is unlikely — so this is the model's
lesson about the shape of the obstruction, not a statement about ζ.

### 7.4 Non-trivial column reduction

At b = 100, c = 2525 (Δ₀ = −100, ν = 25, a_m = m² + 99m + 2525) the witness
degrees are D(0) = 102, D(1) = 110, D(2) = 119, D(3) = 129, D(4) = 140,
D(5) = 153, …, D(24) = 5478, and D(n) = ∞ for n ≥ 25. So D\* = D(0) = 102: the
n = 0 column is the earliest, J_{d,0} is hyperbolic for every d ≤ 101, and
Corollary 5 certifies the whole triangle d + n ≤ 101 — ≈ 5 000 pairs from 101
one-dimensional checks. Confirmed: no exception inside that triangle, by the
closed form for n < 40 and by brute force for d ≤ 11, n ≤ 7. Corollary 6's
D(0) ≤ D(n) + n holds at every n < ν.

### 7.5 ξ itself, and one thing Theorem 2 does not say

For ξ's own sequence a(n), all 217 polynomials with 2 ≤ d ≤ 8 and 0 ≤ n ≤ 30
are hyperbolic — **max |Im root| = 0 exactly at 60 decimal digits** — so
E(d) ∩ [0, 30] = ∅ across the scanned band and the nesting of Theorem 1 is
vacuously satisfied there. This is consistent with [GOR⁺] Corollary 1.3 and
proves nothing beyond it.

Finally, a boundary on what has been shown: Theorem 2 says the *union* E_∞ is
an initial segment. It does **not** say each E(d) is. For a general positive
sequence it need not be — with a = (1, 2, 1, 100, …), J_{2,0}(X) = 1 + 4X + X²
is hyperbolic while J_{2,1}(X) = 2 + 2X + 100X² is not, so 1 ∈ E(2) and
0 ∉ E(2). Whether ξ's own E(d) are initial segments is open and is not needed
for anything above. [initial-segments.md](initial-segments.md) takes the
question up and answers it **for the ambient class**: the property fails even
there — (z² − 6z + 13)e^z has E(2) = {2, 3} and E(3) = {1, 2, 3}, the
order-½ instance (z² − 8z + 73)cosh√z has E(2) = {1}, and the witness degree
D(n) can be strictly decreasing — while for ξ itself the question stays open,
sharpened by an unconditional confinement: every zero of every F^(n) has real
part ≤ ¼ − γ₁² < −199.5, so the witnesses' mechanism is not available to ξ.

---

## 8. Verified numbers

mpmath at 50–60 decimal digits for the ξ moments; exact rational arithmetic
(Sturm real-root counting, roots with multiplicity) everywhere else. Code in §9.

| quantity | value |
|---|---|
| γ(0) = ξ(½) | 0.49712077819 |
| Σ γ(n)z^{2n}/(2n)! vs independent ξ(½+z), z = 0.1 / 0.9 / 2.0 / 4.0 | rel. 1.6e−61 / 1.5e−61 / 0 / 5.4e−61 |
| a(0), a(1), a(2), a(3) | 0.49712077819, 0.011485972158, 2.4690403614e−4, 4.9941328883e−6 |
| a(10), a(20), a(30) | 2.0404225613e−18, 3.6186408981e−37, 9.8617708535e−57 |
| ξ scan: 2 ≤ d ≤ 8, 0 ≤ n ≤ 30 (217 polynomials) | max \|Im root\| = 0 exactly at 60 dps; E(d) ∩ [0,30] = ∅ |
| L1 and L2, generic coefficients, d = 1…8 | residual identically 0 |
| L3 stress: hyperbolic / non-hyperbolic instances | 6 973 / 18 227 (non-vacuous) |
| L3 implications checked / violations | 4 946 / **0** |
| converse of L3(ii) checked / failures | 20 700 / 3 975 (strictly one-way) |
| toy (12)–(13) closed form vs brute force | 6 072 (d,n) pairs, **0** mismatches |
| toy b=1, c=3: ν / N(d) sequence | 3 / 0, 1, 2, 2, 2, 2, 2, 2, 2, 3, 3, … |
| toy b=1, c=3: D(0), D(1), D(2) | 2, 3, 10 |
| order-½ witness (z²+1)cosh√z: E(d), d ≥ 2 | {0}; sup N(d) = ν = 1, G ∉ LP |
| detection law (14), K = 1…64 measured vs closed form | 2, 3, 5, 9, 17, 33, 65 — exact agreement |
| detection law at K = 10⁶ | β = 1.000e−03, D(0) = 1 000 001, β^{−2} = 1 000 000.25 |
| column reduction b=100, c=2525: ν, D\*, triangle | 25, 102, d+n ≤ 101 exception-free |
| ⅓·log 18 ([GOR⁺] proof exponent) | 0.96345 |
| Platt–Trudgian T², = [GOR⁺] Cor. 1.3's bound | 3 000 175 332 800² = 9.001 × 10²⁴ |

---

## 9. Reproduction

```python
# ---- xi's sequence (mpmath, 50 dps) ---------------------------------------
Phi(u)  = sum_{n=1..24} (2 pi^2 n^4 e^{9u/2} - 3 pi n^2 e^{5u/2}) e^{-pi n^2 e^{2u}}
gamma(n)= 4*quad(u -> u^{2n} Phi(u), [0, .5, 1, 1.5, 2, 3, 5])
a(n)    = gamma(n)*factorial(n)/factorial(2n)          # = the papers' gamma(n)

# ---- hyperbolicity, exactly (roots WITH multiplicity) ---------------------
# sympy's count_roots() counts DISTINCT real roots; the toy families carry a
# (1+X)^{d-2} factor, so use real_roots() and compare its length to the degree.
J(d,n)  = Poly(sum(binomial(d,j)*a[n+j]*X**j for j in range(d+1)), X, domain='QQ')
hyp(p)  = (len(p.real_roots()) == p.degree())

# ---- the ladders (symbolic, generic coefficients g0..gd) ------------------
rev(p,d) = expand(X**d * p.subs(X, 1/X))
diff(J(d,n))          == d * J(d-1,n+1)                 # L1
diff(rev(J(d,n),d))   == d * rev(J(d-1,n), d-1)         # L2

# ---- toy 1: (z^2+bz+c)e^z -------------------------------------------------
a[m]    = c + m*b + m*m - m          # = c_m ;  Delta_m = b^2-4c+4m
nu      = min{ m : Delta_m >= 0 }
D(n)    = floor(4*a[n]/|Delta_n|) + 1  if Delta_n < 0 else infinity
E(d)    = { n : D(n) <= d }

# ---- toy 2: (z^2+bz+c)cosh(sqrt z), order 1/2 -----------------------------
a[m]    = m! * ( 1/(2m-4)! + b/(2m-2)! + c/(2m)! )     # 1/(neg)! := 0
```

---

## 10. What this does not do

**1. It does not prove ν < ∞.** Theorems 1–3 are structural; they identify the
uniformity constant and prove it is one integer, not that the integer is
finite. Finiteness would follow from ξ having finitely many non-real zeros,
which is open.

**2. It does not prove RH, and the uniformity would not either.** §6 is the
point of the file. Any statement of the form "sup_d N(d) ≤ B" is compatible
with ν = B ≥ 1, and §7.2 exhibits a function in the right class where exactly
that happens.

**3. The witnesses are models, not zeta.** §7.1–7.3 construct entire functions
with prescribed off-line pairs. They calibrate the *criterion* — what a Jensen
scan can and cannot see, and at what degree. They say nothing about where ζ's
zeros are, and the converse-to-Theorem-1.2 that §7.3 enjoys in the model is
exactly what [GOR⁺] Remark (3) says is unavailable for ξ.

**4. Nothing here is deep.** L1 and L2 are one-line reindexings; L3 is Rolle
twice; Theorems 1–3 are set inclusions. The content is that neither local paper
puts them together, and that doing so replaces a two-parameter unknown with a
one-parameter one — after which the remaining unknown is visibly RH-shaped
rather than technical. That is a clarification, not progress on ζ. It is also
possible the nesting is folklore somewhere outside these two papers; nothing
above depends on its being new.

**5. Corollary 5 does not beat Corollary 1.3.** [GOR⁺] cover the infinite strip
d ≤ 9 × 10²⁴ at every shift; Corollary 5 covers a triangle. Its content is the
reduction of dimension — one column decides the family — not extra coverage.

---

## 11. Dictionary

| term | meaning |
|---|---|
| the exception set E(d) | {n : J_{d,n} not hyperbolic}; GORZ prove each is finite, [GOR⁺] that it lies in [0, ce^d), and Theorem 1 that it only grows: E(d) ⊆ E(d+1) |
| the two ladders | J′_{d,n} = d·J_{d−1,n+1} (L1) and (X^dJ_{d,n}(1/X))′ = d·(X^{d−1}J_{d−1,n}(1/X)) (L2); with Rolle and a(n) > 0 they make hyperbolicity descend in d along both diagonals |
| the hyperbolicity index ν | least n with F^{(n)} ∈ LP, F(z) = Σ a(n)z^n/n! = Ξ(√−z); ν = 0 is RH, ν < ∞ is the uniformity, ν = ∞ forces infinitely many off-line zeros |
| the uniformity, formalised | sup_d N(d) = sup_d #E(d) = ν exactly, both attained — GORZ's per-degree threshold is monotone in d and bounded by one integer |
| the flat wedge | every J_{d,n} with n ≥ ν is hyperbolic, for every d; the true onset boundary is the horizontal line n = ν, so [GOR⁺]'s e^d and [O'S]'s d^{3/4}log²n are certificate artifacts above a flat truth |
| the column reduction | J_{d,0} hyperbolic for all d ≤ D ⟹ J_{d,n} hyperbolic for all d + n ≤ D; the two-parameter family is decided by its n = 0 column, D checks for ≈ D²/2 pairs |
| the detection law | in the model (z²+bz+c)e^z, the least degree that sees a conjugate pair at imaginary part β is ⌊β^{−2}⌋ + 1 exactly — [GOR⁺] Remark (3)'s "inefficient at detecting zeros", with an exponent |
| the GORZ gap, closed | the count of exceptions is uniform in d and equals ν; the exceptions all lie in [0, ν); what remains is the value of ν, which is ζ's problem and not the Jensen machinery's |
| the misfiling | "bounded uniformly in d" is ν < ∞, not ν = 0; it closes the gap and does not imply RH — (z²+1)cosh√z has order ½, positive Jensen data, sup N(d) = 1, and is not hyperbolic |
| the column decides ν = 0 | ν = 0 ⟺ J_{d,0} hyperbolic for every d ≥ 1 — the Jensen–Pólya criterion, recovered as Corollary 5 at D = ∞; RH is a one-column statement, and [GOR⁺] Cor. 1.3 is that column verified through d ≤ 9 × 10²⁴. The column reads "ν = 0 vs ν ≥ 1" and nothing finer |
| the initial-segment failure | the individual E(d) need not be initial segments even in the ambient class: (z²−6z+13)e^z has E(2) = {2,3}, the order-½ instance (z²−8z+73)cosh√z has E(2) = {1}, and D(n) can be strictly decreasing — see initial-segments.md; the union E_∞ stays an initial segment by Theorem 2 |

---

*Sources, both local to this directory:* **[GOR⁺]** Griffin, Ono, Rolen,
Thorner, Tripp, Wagner, *Jensen polynomials for the Riemann xi-function*, Adv.
Math. **397** (2022) 108186 — [jensens-polynomials.pdf](jensens-polynomials.pdf);
**[O'S]** O'Sullivan, *Zeros of Jensen polynomials and asymptotics for the
Riemann xi function*, arXiv:2007.13582v2 —
[zeros-jensens-polynomials.pdf](zeros-jensens-polynomials.pdf); **[GORZ19]**
Griffin, Ono, Rolen, Zagier, PNAS **116** (2019) 11103–11110, quoted through
[O'S] p. 1. Quotes above were re-extracted from the two local PDFs for this
file, not copied from elsewhere in the directory.

*Optional companions, none of them needed to read the above:*
[horn-helix-revisited.md](horn-helix-revisited.md) §4.3 (the item corrected in
§6) · [uniformity-in-the-jensen-degree-d.md](uniformity-in-the-jensen-degree-d.md)
(the frontier map, and the Ω-dial invariance that Corollary 4 sits under) ·
[INTEGERS.md](INTEGERS.md) §5 (where the gap was first written down here) ·
[POSITIVITY.md](POSITIVITY.md) §3, §5 (the d = 2 margin, and the a(n) sequence) ·
[initial-segments.md](initial-segments.md) (§7.5's question answered in the
ambient class: the individual E(d) need not be initial segments, with order-½
witnesses, a Turán dichotomy, and the confinement lemma for ξ).
