# RH-relevance audit of the Mellin/Lambert inequality programme

**Status:** audit document.  It records what the half-plane inequality can and
cannot say about the zeros of `ζ`, and states the precise obstruction.  It does
not claim RH progress.

## 1. What the inequality is

For real `σ > 1`,

```
ζ(σ)^2  ≥  2^σ E_0(σ),      E_0(σ) = Σ_{k,m≥1} (k² + m²)^{−σ},
```

and more generally

```
ζ(σ)^2  ≥  2^σ Σ_{j=0}^{J} (Γ(σ+j)/(j! Γ(σ))) E_j(σ+j).
```

It is a statement about **one real variable** `σ > 1`.  It has no `t`
dependence and says nothing directly about `ζ(σ + it)` for `σ ≤ 1`.

## 2. The lattice sum and its functional equation

Let

```
E_full(s) = Σ_{(k,m)∈ℤ²∖{(0,0)}} (k² + m²)^{−s}.
```

Splitting into open quadrants and axes gives, for `Re s > 1`,

```
E_full(s) = 4 E_0(s) + 4 ζ(2s).
```

The full square-lattice Epstein zeta satisfies the classical modular functional
equation

```
π^{−s} Γ(s) E_full(s) = π^{−(1−s)} Γ(1−s) E_full(1−s),
```

so

```
E_full(s) = π^{2s−1} (Γ(1−s)/Γ(s)) E_full(1−s).
```

Substituting the quadrant decomposition yields the exact continuation relation

```
E_0(s) = π^{2s−1} (Γ(1−s)/Γ(s)) (E_0(1−s) + ζ(2−2s)) − ζ(2s).        (★)
```

This is an algebraic consequence of the Epstein and zeta functional equations;
it is the natural tool for continuing `E_0` into the critical strip.  The
Epstein functional equation is classical but is not formalised in this
repository.

## 3. The difference `D(s)` and the no-go

Define, on `Re s > 1`,

```
D(s) = ζ(s)^2 − 2^s E_0(s).
```

The inequality says `D(σ) ≥ 0` for real `σ > 1`.  Suppose `D` had an analytic
continuation to the critical line with `D(1/2 + it) ≥ 0` for all real `t` (in
the real-valued sense).  At a nontrivial zero `ρ` of `ζ`,

```
ζ(ρ) = 0  ⟹  D(ρ) = −2^ρ E_0(ρ).
```

So `D(ρ) = 0` iff `E_0(ρ) = 0`; and `D(ρ) ≥ 0` would force a condition on
`E_0(ρ)`.  The half-plane inequality gives **no information** about `E_0(ρ)` on
the critical line: it constrains only the combination `ζ(σ)^2 − 2^σ E_0(σ)` for
real `σ > 1`.  In particular:

- the inequality cannot force `D ≥ 0` on the line;
- it cannot force `D(ρ) = 0` at a zero of `ζ` (that would require `E_0(ρ) = 0`);
- it cannot exclude a zero, because at a zero the value of `D` is governed by
  `E_0(ρ)`, which the inequality does not control.

This is the **no-go**: a sign inequality on `Re s > 1` for the difference
`ζ² − 2^s E_0` does not transfer to a sign or zero statement for `ζ` in the
critical strip without a new sign theorem for the continued `E_0` (or for `D`)
on the line.  The continuation relation (★) is an identity, not a sign
statement; identities are compatible with either sign of the difference.

## 4. The higher-`j` remainder

The truncated expansion has a positive remainder for `σ > 1`, because it is an
integral of non-negative terms.  In the critical strip the individual terms are
not absolutely convergent, and the continuation of the remainder is not known to
be sign-definite.  The same obstruction as in §3 applies: positivity on
`(1, ∞)` does not imply positivity in the strip.

## 5. A precisely stated conjecture (not claimed)

**Conjecture (D-continuation).**  `D(s) = ζ(s)^2 − 2^s E_0(s)` continues
meromorphically to `ℂ` and, with the continuation (★), satisfies a functional
equation relating `D(s)` and `D(1−s)` with explicit gamma/exponential factors
and zeta terms `ζ(2s), ζ(2−2s)`.  Its zeros are not the nontrivial zeros of `ζ`
(equivalently, `E_0(ρ) ≠ 0` at every nontrivial zero `ρ`, or `D(ρ) ≠ 0`).

If this conjecture is true, `D` cannot be an RH criterion: its zeros are a
different set.  If it is false, then `D(ρ) = 0` at some zero `ρ`, and the
vanishing of `D` at that zero is a new arithmetic coincidence rather than the
half-plane inequality doing any work.  Either way, the half-plane inequality is
not a zero-location mechanism.

## 6. What would be needed for a genuine RH bridge

A genuine bridge would have to supply one of:

1. a **sign theorem** for the continued `D` or remainder on the critical line
   (not just on `(1, ∞)`), or
2. a **positivity/Gram** statement of Weil type (the lattice inequality is not
   one), or
3. a **spectral identity** identifying the zeros with a self-adjoint spectrum
   (the Epstein zeta side is a different object), or
4. an **arithmetic estimate** strong enough to force zeros onto the line
   (nothing in the half-plane inequality touches the prime side).

None of these is supplied by the Mellin/Lambert inequality.  The audit therefore
records a **no-go** for this particular route, not a proof of RH and not a claim
that no other route exists.

## 7. Formalisation status

- The pointwise majorant `lambert_majorant`, the Gaussian moment
  `gaussian_moment`, the identification `lambert_eq_double`, and the complex-power
  identity `cpow_sq` are Lean-proved.
- The integrated `J = 0`/`J = 1` bound and the continuation (★) are not
  Lean-proved.  The integrated bound is accepted as a paper/numerical result;
  formalisation is blocked by a Lean coercion issue in the Mellin substitution
  (recorded in `INEQUALITY.md` §5).
- The no-go in §3 is a mathematical argument, not a Lean theorem; it depends on
  the classical Epstein functional equation, which is not in the repository.
