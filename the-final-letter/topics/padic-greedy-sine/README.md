# p-adic greedy sine — research programme

**Status:** finite formal core and exact computation layer. The proposed step sequence `p^{-n}` is
**not** p-adically null; the corrected construction uses base-`p` digits (equivalently, steps
`p^n`). No relation to the Kubota–Leopoldt p-adic zeta function is asserted or found.
**Provenance:** proposed in the discussion of [`../sin-x-over-x`](../sin-x-over-x/README.md) as a
p-adic analogue of the greedy harmonic sine, with the Euler product over primes as the intended
target. Standard p-adic analysis; sibling topic
[`../padic-stochastic-zeta`](../padic-stochastic-zeta/README.md).
**Inventory:** a derived exploratory topic, not a separate [Scraps](../../scraps.html) entry.

## The question

Can a p-adic analogue of the greedy harmonic sine be used in place of the Euler product over
primes? The proposal was to work on `Z_p` with steps `p^{-n}`. The first finding is that this
step sequence does not converge p-adically at all. The corrected object is the base-`p` digit
expansion, and the p-adic sine is the standard power series. The experiment below defines that
object, computes its first zeros, and asks whether it has any relation to `ζ_p`.

## The step correction

The p-adic norm is

\[
|q|_p=p^{-v_p(q)}.
\]

Consequently,

\[
|p^{-n}|_p=p^n\longrightarrow\infty,
\qquad
|p^n|_p=p^{-n}\longrightarrow0.
\]

So `p^{-n}` are the **large** p-adic numbers, not small ones. An infinite greedy sum of `p^{-n}`
terms has no reason to converge. The p-adic analogue of “small steps” is `p^n`, or more
generally the digits `a_n p^n` with `a_n ∈ {0, …, p−1}`.

This is the central correction. The archimedean intuition that `1/p^n` is small is exactly wrong
in the p-adic metric.

## Reconstructed objects

| Object | Definition |
|---|---|
| p-adic step | `p^n` (not `p^{-n}`) |
| Base-`p` digit truncation | `T_N(x) = Σ_{n<N} a_n p^n`, where `a_n` are the base-`p` digits of `x` |
| Truncation identity | `T_N(x) = x mod p^N` |
| p-adic sine | `sin_p(z) = Σ_{k≥0} (−1)^k z^(2k+1)/(2k+1)!` |
| Newton polygon | the lower hull of the points `(2k+1, v_p(1/(2k+1)!))` |
| First root valuation | minus the first slope of the Newton polygon |

The Python layer uses `trunc`, `base_digits`, `p_adic_sine_partial`, `newton_points`,
`lower_hull`, `first_slope`, `first_root_valuation`, `p_adic_sine_mod`, and
`approximate_zeros`.

## Findings

### 1. The base-`p` greedy expansion is exact

For `x ∈ Z_p`, the base-`p` digit truncation satisfies

\[
T_N(x)=x\bmod p^N,
\qquad
x-T_N(x)\in p^N Z_p,
\qquad
|x-T_N(x)|_p\le p^{-N}.
\]

This is the p-adic analogue of the greedy expansion: at each step the digit is forced, and the
expansion is exact in the limit. Unlike the archimedean greedy harmonic sine, there is no
approximation theorem to prove; the digit expansion is exact after `N` digits modulo `p^N`.

### 2. The p-adic sine is local, not global

The series

\[
\sin_p(z)=\sum_{k\ge0}(-1)^k\frac{z^{2k+1}}{(2k+1)!}
\]

converges for

\[
|z|_p<p^{-1/(p-1)}.
\]

For odd `p` this disk contains `p Z_p`; for `p=2` the radius is `1/2`. There is no element
`π ∈ Q_p`, so the classical Euler sine product does not have a direct p-adic analogue: the zeros
`nπ` do not exist in `Q_p` in the same way.

### 3. The first zeros are at the boundary, not in `Q_p`

The Newton polygon of `sin_p` is computed from the coefficient valuations
`v_p(1/(2k+1)!) = −v_p((2k+1)!)`. For the tested odd primes `p = 3, 5, 7, 11`, the first slope is

\[
-\frac{1}{p-1},
\]

and **every nonzero slope is fractional**. A nonzero root of the p-adic sine would have
valuation equal to minus one of those slopes, hence fractional; no nonzero root lies in `Q_p`.
The roots are in a ramified extension on the boundary of the convergence disk. A finite search in
`p Z_p` modulo `p^4` finds only `0` for `p = 3, 5, 7`, consistent with this.

For `p = 2`, the first slope of the truncated polygon approaches `−1` as more terms are added.
A root of valuation `1` is therefore not excluded, and the `p=2` case is recorded as open.

### 4. No relation to `ζ_p` is found

The Kubota–Leopoldt function `ζ_p` is built by p-adic interpolation,

\[
\zeta_p(1-k)=(1-p^{k-1})\zeta(1-k),
\]

not by a product over primes. The zeros of `sin_p` are boundary/ramified objects of p-adic
analysis; they are not the zeros of `ζ_p`. The established local analogue of the archimedean
sine factor in the functional equation is the p-adic Gamma function, not a greedy p-adic sine.

No identity relating the greedy p-adic sine to `ζ_p` is proposed here. The experiment is
negative on that point.

### 5. The “greedy” part is not the interesting content

The base-`p` digit expansion is exact and forced; there is no nontrivial greedy selection to
study. The interesting object is the p-adic sine power series and its zeros, which is standard
p-adic analysis. The p-adic experiment therefore does not supply a new route to the Euler
product; it supplies a precise reason why the naive `p^{-n}` proposal fails.

## Theorem ledger

Every row marked **Theorem** is proved in [`lean/Topic.lean`](lean/Topic.lean) with no `sorry`,
`axiom`, or `admit`. Every row marked **Computation** is tested in
[`tests/test_programme.py`](tests/test_programme.py).

| # | Kind | Statement | Lean / test name |
|---|---|---|---|
| T1 | Theorem | `T_N(x) = x mod p^N`. | `PadicGreedy.trunc_eq_mod` |
| T2 | Theorem | `T_N(x) < p^N`. | `PadicGreedy.trunc_lt` |
| T3 | Theorem | `T_N(x) + p^N (x / p^N) = x`. | `PadicGreedy.trunc_add` |
| T4 | Theorem | `|p^n|_p = p^{-n}`. | `PadicGreedy.pNorm_p_pow` |
| T5 | Theorem | `|p^{-n}|_p = p^n`: the proposed steps grow. | `PadicGreedy.pNorm_p_neg_pow` |
| T6 | Theorem | `n ↦ |p^n|_p` is strictly decreasing. | `PadicGreedy.pNorm_p_pow_strictAnti` |
| C1 | Computation | Base-`p` digits and truncations satisfy `T_N(x)=x mod p^N` and `T_N + p^N (x/p^N)=x` on a grid. | `test_base_digits_and_truncation` |
| C2 | Computation | `|p^n|_p=p^{-n}` shrinks and `|p^{-n}|_p=p^n` grows; the proposed steps are not null. | `test_padic_norm_correction` |
| C3 | Computation | For `p=3,5,7,11` the first Newton-polygon slope is `−1/(p−1)` and every nonzero slope is fractional, so no nonzero `Q_p` zero exists in the disk. | `test_newton_polygon_first_slope_odd_primes` |
| C4 | Computation | The truncated p-adic sine at `x=p` reduces to `39, 505, 350` modulo `p^4` for `p=3,5,7`. | `test_p_adic_sine_values_and_reduction` |
| C5 | Computation | The finite search in `p Z_p` modulo `p^4` finds only `0` for `p=3,5,7`. | `test_approximate_zero_search` |

## Source claims and open items

| Item | Status |
|---|---|
| The p-adic greedy steps are `p^{-n}`. | **False p-adically:** `|p^{-n}|_p=p^n` grows. The corrected steps are `p^n` / base-`p` digits. |
| The p-adic sine is related to `ζ_p`. | **Not established.** No identity is proposed or found; the zeros are boundary/ramified, not `ζ_p` zeros. |
| The first slope is `−1/(p−1)` and all nonzero slopes are fractional, for all odd `p`. | Computed for `p=3,5,7,11`; the general statement is recorded as a computation/conjecture, not proved. |
| The `p=2` first root valuation. | **Open:** the truncated first slope approaches `−1`; a root of valuation `1` is not excluded. |
| A global adelic assembly replacing the Euler product. | **Open and unaddressed.** The local p-adic sine has no known relation to the local Euler factor. |

## Python layer

[`python/programme.py`](python/programme.py) implements the exact arithmetic and the finite
p-adic computations. It uses `Fraction` for the sine partial sums and exact residue arithmetic
modulo `p^m`.

Run from the repository root:

```bash
python3 -m pytest the-final-letter/topics/padic-greedy-sine/tests -q
```

Recorded result: **6 passed** in under a second.

## Lean layer

[`lean/Topic.lean`](lean/Topic.lean) proves T1–T6 in `namespace PadicGreedy`. The p-adic sine,
Newton polygon and zero search are in Python, not Lean.

```bash
the-final-letter/topics/padic-greedy-sine/lean/check.sh
```

Recorded build: [`lean/BUILD.log`](lean/BUILD.log) — `[check] OK Topic.lean`. See
[`lean/README.md`](lean/README.md) for what is and is not formalised.

## Open items

1. **`p=2` root.** Decide whether `sin_2` has a nonzero root of valuation `1` in `Q_2`.
2. **General first slope.** Prove the Newton-polygon first slope `−1/(p−1)` for all odd `p`.
3. **Zeros in `C_p`.** Locate the ramified zeros and compare them with p-adic period lattices.
4. **Relation to `ζ_p`.** No identity is known; the p-adic Gamma function, not `sin_p`, is the
   established local factor in the functional equation.
5. **Euler product replacement.** The local p-adic sine has no known relation to
   `(1−p^{-s})^{-1}`; a global assembly is unaddressed.

## Provenance and links

- [Proposal context: `sin(x)/x` with the greedy harmonic sine](../sin-x-over-x/README.md)
- [Sibling p-adic topic](../padic-stochastic-zeta/README.md)
- [Scraps inventory](../../scraps.html)
- [Topic index](../README.md) · [The Final Letter](../../index.html)

[Back to the topic index](../README.md) · [Scraps](../../scraps.html) · [The Final Letter](../../index.html)
