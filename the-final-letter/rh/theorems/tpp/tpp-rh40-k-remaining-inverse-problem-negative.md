# The inverse problem has no halting alphabet with linear complexity

**Kind:** Theorem
**Status:** PROVED (paper argument, as a consequence of K1's Theorem A)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/K_remaining.md`](../../research/twin-prime-parity/rounds/rh40/K_remaining.md) — §5.5 "The inverse problem proper — the negative answer (PROVED)"

## Statement

> K1's Theorem A is **combinatorial and alphabet-independent**: for *any* finitely
> supported 0/1 word, `p(L) = min(a_m+1, N−L+1) + [L ≤ N−a_m−1]` for
> `L ≥ max(span, a_m+1)`, hence `max_L p(L) = a_m + 2`, a **number**. Any alphabet
> with `Σ α_n ≥ x` halts (§5.1) and so has finitely many ones. Therefore:
>
> > **no halting alphabet realises `p(L) = cL`** for any `c > 0`, and in particular
> > not the Sturmian profile `p(L) = L + 1`. "Exact termination **and** linear
> > complexity growth" is impossible — as a consequence of finite support, not of a
> > threshold coincidence.

## Hypotheses and notation

- `α_n` is a greedy alphabet with target `x`; "halting" means `Σ α_n ≥ x` (the criterion of §5.1), so the taken set is finite.
- `p(L)` is the number of distinct length-`L` factors of the resulting 0/1 word; `a_m` is the last support position, `span = a_m − a_0`, `N` the truncation length.
- `p(L) = cL` for `c > 0` is the linear complexity growth being ruled out; the Sturmian profile is the particular case `p(L) = L + 1`.
- The word "realises" ties the alphabet to the complexity profile of the word it produces.

## Proof / evidence

The source's argument, in full: Theorem A holds for any finitely supported 0/1 word, so `max_L p(L) = a_m + 2`, a number; any halting alphabet has finitely many ones (§5.1); hence no halting alphabet can realise `p(L) = cL` for any `c > 0`, and in particular not `p(L) = L + 1`. The source stresses that this is "as a consequence of finite support, not of a threshold coincidence".

The later round `research/twin-prime-parity/rounds/rh41/TRUTHS.md` states the same as "Theorem 12 (inverse problem, impossibility half)", harvested as [Theorem 12 (inverse problem, impossibility half)](tpp-rh41-truths-theorem-12-inverse-impossibility.md); see Notes.

## Dependencies and related results

- [Theorem A (the large-`L` regime)](tpp-rh40-k1-theorem-a-large-l-regime.md) — K1's Theorem A, the combinatorial input ("`p(L) = min(a_m+1, N−L+1) + [L ≤ N−a_m−1]` for `L ≥ max(span, a_m+1)`").
- [Theorem B (the plateau, = C2a)](tpp-rh40-k1-theorem-b-plateau.md) — supplies `max_L p(L) = a_m + 2`.
- [Termination criterion for a greedy alphabet (and the ζ(p) threshold)](tpp-rh40-k-remaining-termination-criterion.md) — §5.1, cited by the source for "any alphabet with `Σ α_n ≥ x` halts".
- [Theorem 12 (inverse problem, impossibility half)](tpp-rh41-truths-theorem-12-inverse-impossibility.md) — the later round's restatement.
- [P1 — the factor-complexity law](tpp-dict-05-factor-complexity-law.md) — the dictionary form of the combinatorial input.

## Notes

- **Restatement round.** The same impossibility is "Theorem 12 (inverse problem, impossibility half)" in the later round `research/twin-prime-parity/rounds/rh41/TRUTHS.md`, harvested as [Theorem 12 (inverse problem, impossibility half)](tpp-rh41-truths-theorem-12-inverse-impossibility.md).
- The source's own §5.2 refutation of the delegated report's "bounded gaps" claim is recorded in [the structure theorem's notes](tpp-rh40-k-remaining-structure-theorem.md); §5.4's exponential-alphabet counterexample ([file](tpp-rh40-k-remaining-exponential-alphabet-dichotomy.md)) shows the dichotomy version of that claim is false.
- **What remains open (source's own words):** "non-monotone alphabets, where the taken set need not be an initial segment (`α = [29/40, 1/2, 1/4, 3/20]`, `x = 7/8` gives taken `{0,3}`), so richer complexity profiles may be realisable there. That is the only route the programme has found to a non-rigid inverse answer." This is recorded as open, not harvested as a theorem.
- K7's evidence files named by the source: [`verify/k7_alphabet.py`](../../research/twin-prime-parity/rounds/rh40/verify/k7_alphabet.py) (delegated) and the mediator's independent recomputation.
