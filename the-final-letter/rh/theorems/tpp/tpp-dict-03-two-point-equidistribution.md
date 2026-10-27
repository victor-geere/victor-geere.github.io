# THEOREM 3.5 (the exact equivalent form; a sharpening of the rounds' phrasing)

**Kind:** Theorem
**Status:** PROVED (paper argument, elementary given THEOREM 3.3)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/dictionary/03-parity-problem.md`](../../research/twin-prime-parity/dictionary/03-parity-problem.md) — §3.3

## Statement

> **THEOREM 3.5 (the exact equivalent form; a sharpening of the rounds' phrasing).** `S(x) = o(x)` holds **iff** the pair `(λ(n), λ(n+2))` is asymptotically **equidistributed** with each of the four sign patterns having density `1/4`. In particular:

```
S(x) = 2·#{n ≤ x : λ(n) = λ(n+2)} − (x − 2)
```

> so `S(x) = o(x)` is **equivalent** to `#{n ≤ x : λ(n) = λ(n+2)} = x/2 + o(x)`, and — given the one-point theorem 3.3 — to each of the four densities being `1/4`.

The file's status line: *Status:* THEOREM (elementary, given 3.3).

## Hypotheses and notation

- `S(x) := Σ_{n≤x} λ(n) λ(n+2)` (OPEN 3.4); `λ` is the Liouville function (Definition 1.2).
- The four sign patterns are the four pairs `(λ(n), λ(n+2)) = (ε_1, ε_2) ∈ {±1}²`.
- "Equal-class density" is the density of `{n : λ(n) = λ(n+2)}`.

## Proof / evidence

The source gives the proof in full:

> *Proof.* For signs `u, v ∈ {±1}`, `1_{u=ε_1, v=ε_2} = (1 + ε_1 u)(1 + ε_2 v)/4`; average over `n ≤ x` and use 3.3 for the two one-point averages. ∎

## Dependencies and related results

- [`THEOREM 3.3`](tpp-dict-03-one-point-chowla-iff-pnt.md) (the one-point averages used in the proof); [`OPEN 3.4`](tpp-dict-03-two-point-chowla-open.md) (the statement being re-expressed).
- [`THEOREM 5.1`](tpp-dict-03-exact-relation-twin-primes.md) part (a) is this equivalence, used for the relation to twin primes.
- Restated in the §7 ledger row "3.5".

## Notes

- **Record correction — important (preserved).** `rh46/README.md` §3 writes that `o(x)` "is *necessary* for a positive proportion of `n` to have `λ(n) = λ(n+2)`". Taken literally that is **too weak to be true as stated**: the identity above shows that `o(x)` is *incompatible* with the equal-class density being any fixed positive number other than `1/2`. The correct assertion is the equivalence of 3.5. The programme's conclusion for twin primes is *not* affected (see §5.1), but the dictionary records the corrected form.
- The source calls 3.5 a "sharpening of the rounds' phrasing"; the equivalence is elementary, but it requires the one-point theorem 3.3.
