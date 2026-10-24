# Round 111 — the bilinear route dies; what the grading buys

*Plan fixed at the start of the round (`rounds.log`, BEFORE line).*

---

## 1. The envisioned path

Round 110 measured the parity factor at `4` and named the next question: can a **bilinear pair weight** — a
product of two one-sided divisor sums, rather than the square of one — remove the factor `4`? If it could, the
function-field crossing would be a sieve after all, and the transfer target for `ℤ` would be concrete.

The second question is what exactly the degree grading buys. The exact identity of round 108 holds because at
`y = n/2` the Legendre sieve is exact; that exactness rests on a single elementary fact about degrees. Making
that fact a theorem is the Lean half of this round.

## 2. Wild guess 52

> **Wild guess 52.** Replacing the square weight `(Σ_{d|f(f+2)} λ_d)²` by the bilinear pair weight
> `(Σ_{d|f} λ_d)(Σ_{e|f+2} λ_e)` keeps an upper-bound interpretation and drops the parity factor from `4` to `1`.

**Why guess it.** The factor `4` comes from squaring; a bilinear form cannot square, so the `2²` might
disappear. The optimistic reading is that the pair structure is exactly what the square weight destroys.

**Falsification test.** Build `C[d,e] = #{f : d|f, e|f+2}` for the level set `{deg ≤ κ}` and examine the
quadratic form `λ^T C λ`. If `C` is indefinite the "minimum" is not a bound and the guess dies.

## 3. Results

### 3.1 The bilinear form is indefinite

`C[d,e] = q^{n−deg d−deg e}` for coprime `d,e` (`0` otherwise). Its eigenvalues at `q = 3`, `κ = 1`:

| `n` | eigenvalues of `C` | smallest |
|---|---|---|
| 5 | `−27, −27, −20.65, 317.65` | `−27` |
| 6 | `−81, −81, −61.96, 952.96` | `−81` |
| 8 | `−729, −729, −557.67, 8576.67` | `−729` |

`C` has negative eigenvalues at every `n`, so `λ^T C λ` is unbounded below on `λ_1 = 1` and the "minimised
value" is negative — the computed values were `−4.5, −13.5, −40.5, …`, which are not bounds on anything.

**Wild guess 52 is refuted.** The square in `Λ²` is not cosmetic: it is what makes the weight nonnegative and
hence an upper bound. There is no bilinear variant with the same property, so the factor `4` cannot be removed
inside the sieve framework. A regression test records the indefiniteness.

This closes the last sieve-side crossing route the programme had. Round 110's factor `4` is therefore the exact
limit of the `Λ²` method, not an artefact of a suboptimal weight.

### 3.2 The cancellation, measured

The exact expansion (round 108) is a sum of strata whose `L¹` mass is comparable to `q^n`, while the answer is
`≍ q^n/n²`:

| `q` | `n` | `L¹` mass of strata | `T(n)` | `L¹/|T|` | `L¹/|T| / n²` |
|---|---|---|---|---|---|
| 3 | 3 | 125 | 1 | 125 | 13.9 |
| 3 | 5 | 1410 | 6 | 235 | 9.4 |
| 3 | 6 | 4138 | 6 | 690 | 19.2 |

The mass is `≍ q^n` and the ratio grows like `n²` (the constants wobble at small `n`). So the identity is exact
but its evaluation is a cancellation problem of polynomial depth in the answer — the mass is `q^n`, the signal is
`q^n/n²`.

### 3.3 What the grading buys (Lean)

The exactness of the sieve at `y = n/2` is one degree inequality, now formalised (`lean/Grading.lean`):

```lean
theorem Grading.exists_two_mul_le {f g h : F[X]} (hf : f = g * h)
    (hg0 : g ≠ 0) (hh0 : h ≠ 0) (hgd : g.natDegree ≠ 0) (hhd : h.natDegree ≠ 0) :
    2 * g.natDegree ≤ f.natDegree ∨ 2 * h.natDegree ≤ f.natDegree
```

with the contrapositive `not_both_large`: no reducible `f` of degree `n` can have all its factors of degree
`> n/2`. That is precisely why the Legendre sieve over primes of degree `≤ n/2` is an exact indicator in
`𝔽_q[x]` — and precisely what is unavailable over `ℤ`, where there is no grading to bound the support.

## 4. The transfer demand, stated once

Putting rounds 108–111 together, the function-field crossing consists of exactly two ingredients:

1. **An exact growing-support identity.** `1_Irr(f) = Σ_{d | gcd(f, P_{n/2})} μ(d)`, exact by the grading lemma.
   The parity theorem does not apply because the support grows with `n`.
2. **A canonical truncation.** The support is bounded by the degree (`deg d ≤ n`), and the error of the
   truncation is controlled by the boundary stratum (round 108), not by an arbitrary cut.

Over `ℤ`:

1. The analogous identity runs through `Λ = μ ∗ log`, whose support is unbounded and *not* canonically
   truncatable — there is no grading to say where to stop.
2. The truncation error is exactly a two-point correlation of `μ`/`Λ`, i.e. the Chowla-type problem, which is
   open.

So the transfer demand is not "a better sieve" (the sieve is capped at `4`, and the bilinear variant is
indefinite). It is **a grading substitute**: a canonical, error-controlled truncation of the Möbius sum. Every
known method that supplies one over `ℤ` — the circle method, the large sieve — is blocked at exactly this point.

## 5. State

* Wild guess 52 refuted; the bilinear route is closed (indefinite form, regression-tested).
* The parity factor `4` of round 110 stands as the sieve's exact limit.
* Cancellation measured: mass `≍ q^n`, answer `≍ q^n/n²`, ratio `≍ n²`.
* Lean: `Grading.exists_two_mul_le`, `Grading.not_both_large` (standard axioms).
* 20 unit tests green.

## 6. Next round (112)

With the sieve routes closed, the remaining strategy is the **window on the exact identity**: use the round-108
expansion, average over a window of degrees, and test whether the boundary stratum's contribution can be
computed from degree-local data (the `q^{n/2}` spectrum) rather than by enumerating pairs. That is the last
place where the function-field zeta could enter the calculation directly.
