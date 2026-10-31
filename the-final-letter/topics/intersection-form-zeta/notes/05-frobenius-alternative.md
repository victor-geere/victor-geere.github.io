# An alternative to the Frobenius correspondence

**Status:** proposal and finite demonstration. The scaling correspondence is a
source claim (Connes); the Hecke shadow is standard (Eichler–Shimura,
Deligne); the trichotomy in §2 and the finite-shadow route in §6 are this
dossier's interpretation. Nothing here proves the Riemann hypothesis.

## 1. What has to be replaced

[`02-arithmetic-obstruction.md`](02-arithmetic-obstruction.md) isolates the
missing object. The function-field proof uses three ingredients:

1. a correspondence `Γ ⊂ C × C`, the graph of Frobenius;
2. a Lefschetz trace formula, which turns `Γ` into the zeta function;
3. a positivity, the Hodge index on `NS(C × C)`, which forces the
   Frobenius eigenvalues onto the circle `|α| = √q`.

Over `Q` there is no single Frobenius endomorphism. The question of this note
is whether the *role* of `Γ` can be played by something else. The answer
developed below is: **yes, but the replacement is not an algebraic cycle, and
the positivity — not the correspondence — becomes the open problem.**

Two replacements are available, and they sit at different levels:

- the **algebraic shadow**: Hecke correspondences on a Shimura curve. These
  are genuine algebraic cycles over `Q`. The Eichler–Shimura relation
  identifies them with Frobenius on the reduction, and the
  Ramanujan–Petersson bound is the Riemann hypothesis for the associated
  `L`-function. This is the only known algebraic supply of Frobenius-like
  correspondences over `Q`.
- the **scaling correspondence**: the measured relation `(x, λx)` on the
  adele class space. It is not an algebraic cycle, but it is global,
  infinite-dimensional, and its trace formula is the explicit formula. Its
  absorption spectrum is the multiset of non-trivial zeros of `ζ`.

The algebraic shadow is exact but reaches only automorphic `L`-functions; for
`ζ` it degenerates to the identity. The scaling correspondence reaches `ζ` but
leaves the polarization open. The two failures are different faces of the same
wall.


> **Proposal.** Replace the graph of Frobenius by the scaling correspondence
> `S = {(λx, x)}` on the adele class space `X = A_Q^×/Q^×`. Its Lefschetz
> trace is the explicit formula, its periodic orbits are the prime powers, and
> its absorption spectrum is the multiset of non-trivial zeros of `ζ`. The
> algebraic shadow of the construction is the Hecke correspondence; the
> remaining open problem is the polarization.

## 2. Why one algebraic Frobenius cannot exist

### 2.1 A fixed correspondence has a fixed trace

Let `X` be a variety over `Q` and let `C ⊂ X × X` be an algebraic
correspondence defined over `Q`. Its class in a Weil cohomology is fixed, so
its action on `H^i(X)` has eigenvalues in a fixed number field, independent of
any prime. In particular the trace is constant across primes of good
reduction.

Frobenius traces are not constant. For an elliptic curve
`E : y² = x³ + x + 1` over `Q`, the traces

\[
a_p = p + 1 - \#E(\mathbb{F}_p)
\]

computed by [`../python/frobenius_alternative.py`](../python/frobenius_alternative.py)
begin

```
p    5   7  11  13  17  19  23  29  31  37  41  43  47  53  59  61  67  71  73
a_p -3   3  -2  -4   0  -1  -4  -6  -1 -10   7  10 -12  -4  -3  12  12  13   2
```

No single integer is the trace at all these primes, so no single algebraic
correspondence over `Q` specialises to the graph of Frobenius at all of them.
The general statement is stronger: for a non-CM elliptic curve the traces
`a_p` are unbounded (Sato–Tate; Serre's open-image theorem is the
Galois-theoretic input), while a fixed endomorphism has bounded, indeed
constant, trace.
For a CM curve the CM correspondence is fixed, but it is the *endomorphism*,
not Frobenius; the traces `a_p` still vary with `p`.

### 2.2 A finite determinant has too few zeros

A finite-dimensional correspondence produces a determinant of the form

\[
D(s)=\prod_{i=1}^{d}\bigl(1-\alpha_i e^{-s}\bigr).
\]

Its zeros satisfy `e^{-s} = 1/α_i`, so they lie on the finitely many vertical
lines `Re s = log|α_i|`; up to height `T` there are `O(T)` of them, one
arithmetic progression per line. The completed `ξ`-function has, by von
Mangoldt's formula,

\[
N_\xi(T) \sim \frac{T}{2\pi}\log\frac{T}{2\pi e},
\]

which is not `O(T)`. Hence `ξ` is not the determinant of a
finite-dimensional correspondence. A finite determinant *can* have infinitely
many zeros in the `s`-plane, but only linearly many up to height `T`; `ξ` has
`T log T`. The replacement must be infinite-dimensional (a Fredholm
determinant), or a family whose product is not a finite determinant.

This also explains why the trivial motive does not solve the problem. Its
`L`-function is `ζ(s)`, and its Frobenius eigenvalue is `1`, but the global
`L`-function is an infinite Euler product, not a finite characteristic
polynomial. The eigenvalue `1` produces the pole at `s = 1`; it says nothing
about the zeros.

### 2.3 A symmetry is not a correspondence

The functional equation `s ↦ 1-s` pairs the two halves of the spectrum. It is
the analogue of `α ↦ q/α`, but it does not generate the spectrum: a set
symmetric about the critical line can have its elements anywhere on that line
or off it. The functional equation is a *constraint* on a correspondence, not
a substitute for one.

### 2.4 The trichotomy

The three obstructions give a trichotomy for candidates:

| candidate | algebraic over `Q`? | finite-dimensional? | reaches `ζ`? |
|---|---|---|---|
| one global Frobenius cycle | yes, by hypothesis | yes | no: §2.1–2.2 |
| a family of Hecke correspondences | yes, one per prime | yes, on `H^1` | only automorphic `L`-functions |
| the scaling correspondence | no (measured relation) | no (`L²` of an adelic space) | yes, as a trace formula |

The rest of the note develops the last two rows.

## 3. The algebraic shadow: Hecke correspondences

### 3.1 The correspondence

Let `X = X_0(N)` be a modular curve, or more generally a Shimura curve. For a
prime `p ∤ N`, the Hecke correspondence

\[
T_p \subset X \times X
\]

is the sum of the graphs of the `p`-isogenies. It is an algebraic cycle
defined over `Q`. On `H^1(X, Q_ℓ)` the Eichler–Shimura relation reads

\[
T_p = F_p + p\,F_p^{-1},
\]

where `F_p` is the `p`-power Frobenius on the reduction. Thus a single
algebraic correspondence over `Q` — the Hecke operator — *does* encode
Frobenius, but only after reducing at `p`. It is a family indexed by `p`, not
one global cycle.

### 3.2 The Ramanujan–Petersson bound is the shadow's RH

Let `f` be a normalised Hecke eigenform of weight `k`, with eigenvalues
`a_p`. The associated `L`-function has local factors

\[
(1 - a_p p^{-s} + p^{k-1-2s})^{-1}.
\]

The Riemann hypothesis for this `L`-function is the bound

\[
|a_p| \le 2\,p^{(k-1)/2}.
\]

For weight `2` this is the Ramanujan–Petersson conjecture, proved by Deligne
as a consequence of the Weil conjectures: the Galois representation attached
to `f` has weight `k-1`, so its Frobenius eigenvalues have absolute value
`p^{(k-1)/2}`.

The classical example is the weight-12 form

\[
\Delta(q) = q\prod_{m\ge1}(1-q^m)^{24} = \sum_{n\ge1}\tau(n)q^n.
\]

Its Hecke eigenvalues are `τ(p)`, and the bound is

\[
|\tau(p)| \le 2\,p^{11/2}.
\]

The Python module verifies this for all primes `p ≤ 500`; the worst ratio
`|τ(p)|/(2p^{11/2})` is `0.9594…` at `p = 103`. This is a finite check of a
theorem, not a proof of it, and it is deliberately included because it is the
cleanest computational instance of the algebraic shadow: an algebraic
correspondence over `Q` whose eigenvalues obey the Riemann-hypothesis bound.

### 3.3 Why the shadow stops at `ζ`

`ζ(s)` is the `L`-function of the trivial automorphic representation of
`GL_1`. Its Hecke eigenvalue at every prime is `1`, not `p^{1/2}`. The Hecke
correspondence is the identity; the only spectral datum it sees is the pole at
`s = 1`. The zeros of `ζ` are not eigenvalues of any finite-dimensional Hecke
operator.

This is not a defect of the Hecke construction. It is the statement that `ζ`
has *no weight*: the local factor `(1-p^{-s})^{-1}` is the local factor of a
motive of weight `0`, and a finite-dimensional weight-`0` object contributes a
pole, not the zeros. To see the zeros one needs an infinite-dimensional
object. The scaling correspondence is the minimal such object.

## 4. The scaling correspondence

### 4.1 Definition

Let

\[
X = \mathbb{A}_{\mathbb{Q}}^{\times} / \mathbb{Q}^{\times}
\]

be the adele class space (one may also quotient by the maximal compact of the
archimedean component; the trace formula is insensitive to the convention).
The multiplicative group `R_+^×` acts by scaling:

\[
\lambda \cdot x = \lambda x .
\]

Define the **scaling correspondence**

\[
\mathcal{S}
= \{(\lambda x, x) : x \in X,\ \lambda \in \mathbb{R}_{+}^{\times}\}
\subset X \times X,
\]

equipped with the Haar measure `d^×λ` on `R_+^×`. It is a measured
correspondence, not an algebraic cycle: its "components" are the graphs of
the scaling maps, one for each `λ`.

The prime `p` enters as the period `log p` of the scaling flow: the local
Frobenius at `p` is the periodic orbit of that length, not a separate map on
the `p`-adic factor. The `p`-adic places are carried by the adele class space
itself, and the archimedean component is the dilation that carries the
`Γ`-factor.

### 4.2 The dictionary

| function field | number field, scaling picture |
|---|---|
| curve `C/F_q` | adele class space `X_Q` |
| Frobenius endomorphism | scaling by `λ` (local: `×p`) |
| graph `Γ ⊂ C × C` | scaling relation `S ⊂ X × X` |
| fixed points of Frobenius = `C(F_q)` | periodic orbits of scaling = prime powers |
| eigenvalues of Frobenius = zeros of `Z` | absorption spectrum = zeros of `ζ` |
| Lefschetz trace formula | Connes' trace formula |
| Hodge index / polarization | Weil positivity |
| `α ↦ q/α` | `s ↦ 1-s`, i.e. `λ ↦ 1/λ` |

The table contains the conceptual shift. In the function field, Frobenius's
*fixed points* are rational points and its *eigenvalues* are zeros. In the
scaling picture the periodic orbits are primes and the spectrum is zeros. The
duality is the same; the two columns are exchanged. This is why a flow can
replace an endomorphism.

### 4.3 The trace formula

The trace of the scaling correspondence against a test function `f` is the
distributional trace of the scaling representation `U(f)` on `L²(X)`. Connes'
trace formula identifies it with the spectral side of the explicit formula:

\[
\operatorname{Tr}\bigl(U(f)\bigr)
=
\sum_{\rho} \hat f(\rho) + \text{pole terms},
\]

while the geometric side is

\[
\hat f(0) + \hat f(1)
- \sum_{p}\sum_{k\ge1}
  \frac{\log p}{p^{k/2}}
  \bigl(f(k\log p) + f(-k\log p)\bigr)
- \text{archimedean}(f).
\]

The equality of the two sides is the explicit formula. The zeros appear on the
spectral side; the primes appear as the periods of the scaling flow on the
geometric side. This is the exact analogue of the Lefschetz formula

\[
\#C(\mathbb{F}_q) = \sum_i (-1)^i \operatorname{Tr}(\mathrm{Frob} \mid H^i(C)),
\]

with the Frobenius endomorphism replaced by the scaling flow.

### 4.4 The functional equation

The inversion `λ ↦ 1/λ` on `R_+^×`, together with the sign involution on the
adele class space, induces `s ↦ 1-s` on the spectral side. The completed
`ξ`-function is invariant. In the dictionary the functional equation is the
`λ ↦ 1/λ` symmetry of the scaling correspondence; it is no longer an extra
axiom, but a symmetry of the same object.

## 5. The remaining wall is the polarization

The scaling correspondence supplies requirements (1) and (2) of §1: it is a
correspondence, and its trace is `ξ` (via the explicit formula). It does not
supply requirement (3): a polarization, i.e. a positive-definite form
compatible with the correspondence and the functional equation.

In the scaling picture the polarization is the **Weil positivity**: the Weil
functional on the Schwartz space is non-negative on the cone of test functions
that are squares. The Weil criterion states that this positivity is equivalent
to the Riemann hypothesis. This is not a new gap; it is the same wall as in
[`02-arithmetic-obstruction.md`](02-arithmetic-obstruction.md), moved one step
to the right:

> note 02: an intersection form without a correspondence cannot see the
> zeros.
>
> this note: the correspondence exists as a measured relation and does see
> the zeros; what is missing is the polarization that would make it an
> intersection form in the Hodge-index sense.

That is the precise sense in which the alternative is an improvement: it
replaces a missing *object* by a missing *positivity*, and the positivity is
a statement about a known object rather than a search for an unknown one.

### 5.1 The polarization conjecture

> **Conjecture (scaling polarization).** There is a positive-definite inner
> product `⟨·,·⟩_S` on a dense subspace of `L²(X)`, invariant under the scaling
> correspondence and compatible with the functional equation, such that the
> infinitesimal generator of the scaling flow is essentially self-adjoint and
> its spectrum is the multiset of non-trivial zeros of `ζ`. Equivalently, the
> Weil functional is non-negative on the cone of squares.

The equivalence with the Weil criterion means the conjecture is another form
of RH, not a proof of it. Its value is that it names the missing structure
precisely: a Hilbert-space polarization for a known correspondence, rather
than an unknown correspondence for a known positivity.

### 5.2 A candidate for the polarization

The metaplectic group has a unitary representation — the Weil representation
— on `L²` of the adeles. The theta correspondence relates representations of
dual reductive pairs, and the scaling action is central in the metaplectic
group. If the unitary structure of the Weil representation descends to the
Weil functional on the multiplicative cone, it would supply the polarization.
Whether it does is open; the arithmetic-site programme of Connes–Consani is
one attempt to make this precise. This note records the route, not a
construction.

## 6. A finite programme

The existing certified `4 × 4` Gram matrix is the compression of the Weil form
to four Gaussians. In the scaling picture it is the compression of the
polarization to a four-dimensional subspace of test functions. Its positive
definiteness (T91–T100, C25–C39) is the first finite check of the
polarization, not of the correspondence.

The natural conjecture is:

> **Finite-shadow convergence.** Let `V_N` be an increasing family of
> test-function spaces whose union is dense in the Schwartz space. If the
> Weil form is continuous in the relevant topology, then `W|_{V_N} ≥ 0` for
> every `N` if and only if `W ≥ 0` on the Schwartz space, i.e. iff RH.

The "only if" direction is the Weil criterion. The "if" direction is the
continuity statement, which is exactly where the analytic difficulty sits.
The certified rank-four shadow is evidence at `N = 4`; it is not a proof of
the limit.

Falsifiable consequences:

- a negative finite shadow would refute RH;
- the lowest eigenvalue of the finite shadows should approach `0` at a rate
  dictated by the zero density;
- the eigenfunctions should concentrate on the zeros in the scaling picture.

The first is a genuine test; the second and third are numerical programmes.
The `4 × 4` certificate has smallest numerical eigenvalue `0.0227…`, so the
first test has not failed at rank four.

## 7. What is and is not new

The function-field template is Weil (1948) and Deligne (1974). The Hecke
shadow is Eichler–Shimura, with the Ramanujan–Petersson bound proved by
Deligne. The scaling correspondence and its trace formula are Connes (1999);
the arithmetic-site refinement is Connes–Consani. The contribution of this
note is the bookkeeping against the intersection-form route:

- it states exactly which of the three requirements each known alternative
  meets;
- it proves the elementary no-go for a single algebraic Frobenius and
  illustrates it computationally;
- it identifies the residual polarization as the Hodge-index analogue, and
  therefore as the precise open problem on this route.

It does not construct the polarization, and it does not prove RH.

## Source claims and computations

- **S6.** Connes' trace formula and spectral realization of the zeros
  (Connes 1999). Standard; not formalised.
- **S7.** Eichler–Shimura: `T_p = F_p + p F_p^{-1}` on `H¹` of a modular
  curve. Standard; not formalised.
- **S8.** Deligne's proof of the Ramanujan–Petersson bound via the Weil
  conjectures. Standard; not formalised.
- **S9.** The trichotomy of §2.4 and the polarization reading of §5 are this
  dossier's interpretation, not a theorem.

The finite computations are in
[`../python/frobenius_alternative.py`](../python/frobenius_alternative.py) and
[`../tests/test_frobenius_alternative.py`](../tests/test_frobenius_alternative.py):

```bash
cd the-final-letter/topics/intersection-form-zeta
python3 python/frobenius_alternative.py
python3 -m pytest -q tests/test_frobenius_alternative.py
```

The module computes `τ(p)` exactly from the eta product, checks
multiplicativity and the Hecke recurrence, verifies `|τ(p)| ≤ 2p^{11/2}` for
`p ≤ 500`, and tabulates `a_p` for `y² = x³ + x + 1` to show that no fixed
trace fits the Frobenius data.

## References

- A. Weil, *Numbers of solutions of equations in finite fields* (1948).
- P. Deligne, *La conjecture de Weil I* (1974).
- M. Eichler, *Quaternäre quadratische Formen und die Riemannsche
  Vermutung für die Kongruenzzetafunktionen* (1954); G. Shimura (1959).
- A. Connes, *Trace formula in noncommutative geometry and the zeros of the
  Riemann zeta function* (1999).
- A. Connes and C. Consani, *The arithmetic site* (2014) and subsequent
  papers.
- H. Iwaniec and E. Kowalski, *Analytic Number Theory*, for the explicit
  formula and the Weil criterion.

[The angular Bochner attack](06-angular-bochner-attack.md) tests this alternative against the
finite-level normal form of the accompanying PDF.  See also:
[Back to the dossier](../README.md) · [Function-field template](01-function-field-template.md) ·
[Arithmetic obstruction](02-arithmetic-obstruction.md) ·
[Certified shadow](04-certified-shadow.md)
