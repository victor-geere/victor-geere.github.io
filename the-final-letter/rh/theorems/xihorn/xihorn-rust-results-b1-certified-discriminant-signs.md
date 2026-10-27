# B1 — all 35 Jensen polynomials certified from enclosures

**Kind:** Claim
**Status:** VERIFIED (numerical; interval LDLᵀ certificates from enclosures at 60 digits — but the enclosure of γ(n) itself is measured, not proved)
**Area:** xi-horn
**Source:** [`xi-horn/rust/RESULTS.md`](../../xi-horn/rust/RESULTS.md) — Summary, "B1 — done. All 35 Jensen polynomials certified"

## Statement

> **B1 — done. All 35 Jensen polynomials certified**, d = 2…6 and n = 0…30,
> from enclosures rather than floating-point signs, by positive-definiteness of
> the Hermite–Hankel form under interval LDLᵀ. The discriminants reproduce
> INTEGERS §5 exactly (3.6746e−5, 9.8744e−41, 5.3285e−118, 2.0170e−13,
> 7.6910e−123, 2.4317e−240, 1.5931e−25, 8.4217e−191, 1.2401e−367) and so do its
> normalised margins. The new column is `max width`: the largest **relative**
> enclosure width on the coefficients at which the sign is still decided. It is
> the honest bridge, because the propagation is rigorous but the enclosure of
> γ(n) itself is measured, not proved — so a fully rigorous certificate needs a
> bound on γ(n) tighter than 9.4e−4 at (d,n) = (2,30), and than 3.6e−18 at
> (6,30). That number falls twelve decades from d = 2 to d = 6 at n = 0 and
> fourteen at n = 30 — three per unit of d, widening to nearly four — which is a
> sharper statement of the cost of degree than any discriminant column.

## Hypotheses and notation

- J^{d,n} is the Jensen polynomial of ξ; the discriminant is written lc^{2d−2}·det H for the Hankel matrix H of Newton power sums, and H positive definite ⟺ all d roots are real and simple.
- The decision procedure is an interval LDLᵀ, needing no square roots and no division by a sign-unknown quantity; one factorisation yields the verdict and det H.
- `max width` is a **relative** enclosure width on the coefficients (see **E16** for the half/full-width bookkeeping correction).
- Modules `rust/src/interval.rs`, `poly.rs`, `jensen.rs`; driver `bin/b1_certify [dmax] [nmax] [nstep] [digits]`.

## Proof / evidence

Numerical, by interval arithmetic: 35 polynomials certified from enclosures rather than floating-point signs; discriminants reproduce INTEGERS §5 exactly, as do the normalised margins. The source states its own limit plainly: "the propagation from an enclosure of a(n) to a certified sign is rigorous … but the *enclosure of γ(n) itself is measured, not proved*: the quadrature's error is established by step-halving, which is evidence, not a bound."

## Dependencies and related results

- [G1 — B1 without its conditional](xihorn-rust-results-g1-b1-without-conditional.md) — removes exactly that conditionality.
- [H2 — P^{d,n} and what it is worth to a certificate](xihorn-h-track-h2-p-jensen-max-width.md) — uses the same interval LDLᵀ on the same Hermite–Hankel form.
- [Chasse 2013 and GOR⁺ Corollary 1.3](xihorn-todo-e8-chasse-and-corollary-1-3.md) — **E8**: "B1's statement is not new"; the certified range is not a contribution.

## Notes

- The source's own verdict on what B1 is: "the *statement* being certified has been known since 2013 across a range twenty-four orders of magnitude wider. What is here is a route, not a result." (The fuller form of this is **E8** in TODO.md.)
