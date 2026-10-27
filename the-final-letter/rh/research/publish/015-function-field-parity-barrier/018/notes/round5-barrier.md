# Round 5 — the twin count as a Frobenius trace, and the "twin motive" guess

**State at the start of this round.** The handoff's two suggested next steps are
already done: (a) the exact normalisation of `S(q)` was pinned against Pollack's
Conjecture 2 (`ω(P)=2`, `∏ deg f_i = 1`) in round 3, and re-derived with the
correct numerical value in round 4; (b) the Möbius inversion and the
"2-D Chebotarev vs 1-D zeros" separation are formalised in Lean
(`ZetaMobius.mobius_inversion`, `Separation.no_zeta_observable`,
`Separation.separation_F7`). The round-2/3 claim that the convergence is
"`O(1/n)` and slow" was a floating-point artefact (round 4, §2): with
`S(3)=0.396104` the ratio already matches `S(q)` to `8.5e-6` at `q=3, n=16`.

This round goes beyond (a)/(b) and attacks the barrier itself.

---

## 1. What the barrier is, in this dictionary

Two facts from earlier rounds are the whole story:

1. **No Euler product** (the dictionary's F3/F8; Lean: `Barrier.twinInd_not_mult`).
   The twin indicator `n ↦ [n, n+2 both prime]` is not multiplicative:
   `twinInd(3)=twinInd(5)=1` but `twinInd(15)=0`, with `gcd(3,5)=1`. A
   multiplicative indicator has a Dirichlet series with an Euler product; the
   twin indicator does not.

2. **Not a zeta coefficient** (round 3). `ζ_S` determines exactly the degree
   counts `Z(S)`; the twin count `B(S)` is not a function of `Z(S)`
   (`Separation.no_zeta_observable`), and on `ℙ¹` the zero multiset is empty
   (round 3, Prop. 4.1).

So the twin count is neither an Euler product nor a zeta coefficient. The sieve
sees only the *local densities* `ω(p)/p` — i.e. the `H⁰`/trivial part of the
arithmetic — and the parity theorem says that this is all a bounded-depth sieve
can see. The question is what the *other* part is.

## 2. What replaces the Euler product: a trace

In `𝔽_q[x]` the twin count is a **Chebotarev / Frobenius-trace** quantity. The
2-D equidistribution of §3 of `round3-formal-statement.md` is, in cohomological
language, the statement that

```
T(n) = Σ_i (-1)^i Tr(Frob_q | H^i_c(M_n)) ,
```

for a motive `M_n` attached to the *generic pair* `(g, g+2)` (the fiber product
of two generic-`S_n` torsors over the degree-`n` coefficient space). The Euler
product of `ζ` is replaced by a sum of eigenvalues. This is why the function-field
barrier is crossed: the trace is computable by Weil's theorem.

## 3. Degree-3 probe: the trace is an elliptic curve

Bary-Soker–Stix (*Cubic twin prime polynomials are counted by a modular form*,
2017) show that the degree-3 geometry involves

```
E : Y² − Y = X³      (j = 0) .
```

Let `c_q = q + 1 − #E(𝔽_q)` be its Frobenius trace. The "clean" candidate is

```
T_clean(3) = q(q−2)(q+1)/9 .
```

**Observation (verified).** For every prime `5 ≤ q ≤ 120`:

```
T(3) = q(q−2)(q+1)/9    ⇔    c_q = 0    ⇔    q ≡ 2 (mod 3) .
```

The equivalence `c_q = 0 ⇔ q ≡ 2 (mod 3)` is the classical supersingularity
criterion for `j = 0`. So:

* in the **supersingular** case the elliptic curve's `H¹` vanishes and only the
  "clean" (`H⁰ ⊕ H²`-type) part survives;
* in the **ordinary** case (`q ≡ 1 mod 3`) the deviation
  `T(3) − q(q−2)(q+1)/9` is a nonzero arithmetic quantity.

The deviation is not a smooth function of `q`: for `q = 7, 13, 19, 31, 37, 43, 61`
it is `+3.89, +24.56, −90.78, −158.44, −324.78, −105.11, +277.89`, and
`dev/c_q` is not constant. Bary-Soker–Stix's exact formula is a sum of traces;
the qualitative point — *the deviation is the ordinary part of a Frobenius
trace* — is what matters here, and it is clean.

Data and sympy cross-checks: [`checks/round5_lfunction.py`](../checks/round5_lfunction.py),
[`tests/test_round5.py`](../tests/test_round5.py).

## 4. Wild guess 5 — the twin motive

> **Wild guess 5.** The twin count is the Frobenius trace on the **twin motive**
> `M_n`. In `𝔽_q[x]` this motive exists and its cohomology is computed by Weil,
> which is why the barrier is crossed there. Over `ℚ`, the missing object is the
> **L-function of the twin motive** — a `GL(2)×GL(2)`-type object with a
> functional equation and a pole at `s = 1`. The parity barrier is not a weakness
> of sieves; it is the non-existence (or non-automorphy) of this L-function.

**Sharper, function-field-testable form.**

> **Guess 5a.** The "clean" part of `T(n)` is the `H⁰ ⊕ H^{2d}` contribution
> and is a polynomial in `q`; the rest is the `H¹` (and higher) contribution and
> is an arithmetic fluctuation of size `O(q^{n−1/2})`. In degree 3,
> `H¹(M_3) = H¹(E)`, the clean polynomial is `q(q−2)(q+1)/9`, and it is exact
> precisely when `E` is supersingular.

Guess 5a's vanishing pattern is verified in degree 3 (§3). The exact ordinary
correction (the full Bary-Soker–Stix formula) is a sum of traces we did not
decode; that is the natural next probe.

**Why this is a guess and not a proof.** Over `ℚ` we cannot even write down
`M_n`: there is no Frobenius, no finite coefficient space, and no cohomology
theory for the "generic pair" over `ℚ`. The guess predicts *what kind* of object
would cross the barrier (a motive with an L-function), not how to build it. It is
consistent with the dictionary's §5.4: the three historical ways to cross a
parity barrier (Type-II, equidistribution, automorphic/spectral) are all,
in this reading, ways of accessing the `H¹` part.

## 5. Honest verdict

* **Established this round:** the degree-3 twin count is controlled by an
  elliptic-curve Frobenius trace; the clean formula is exact exactly in the
  supersingular case (primes `5 ≤ q ≤ 120`, sympy-checked point counts); the
  twin indicator has no Euler product (Lean); the linear bound
  `B(S) ≤ |S|` is trivial (Lean).
* **The wild guess:** coherent, supported in the function field, unfalsifiable
  over `ℚ` with current tools. It reframes the barrier as a cohomological /
  automorphic gap rather than a sieve gap. It does not prove anything about `ℚ`.
* **Not claimed:** that `M_n` exists over `ℚ`; that its L-function has the
  required properties; that this route is *necessary*. The parity theorem is a
  no-go for bounded-depth sieves, not for every method.

## 6. What the next round should probe

1. **Decode the ordinary correction.** Fit `T(3) − q(q−2)(q+1)/9` against the
   elliptic-curve trace and the traces of its symmetric powers; identify the
   exact Bary-Soker–Stix formula and check it symbolically. This would turn
   Guess 5a's "the deviation is the ordinary part" from a vanishing statement
   into an identity.
2. **Go to degree 4.** Identify the motive `M_4` (a surface?) and test whether
   the clean/ordinary splitting persists.
3. **Wild guess 6 (preview).** *The barrier is an **archimedean** phenomenon:
   over `𝔽_q[x]` the trace is exact because there is no archimedean place; over
   `ℚ` the `H¹` contribution is spread over the infinite place, and the fix is to
   use a **completed** L-function whose archimedean factor is not a local density
   but a spectral measure.* Investigate: in the function field, insert an
   archimedean place by working over `𝔽_q((1/t))` and see what changes.

---

## 7. Reproduction

```
python3 checks/round5_lfunction.py     # exit 0
python3 -m pytest -q tests/            # 51 passed
cd lean && ./check.sh Barrier.lean Axioms.lean   # OK
```

New files this round: `checks/round5_lfunction.py`,
`tests/test_round5.py`, `lean/Barrier.lean`.
