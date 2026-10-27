# Termination criterion for a greedy alphabet (and the ζ(p) threshold)

**Kind:** Theorem
**Status:** PROVED (paper argument; verified in exact rationals)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/K_remaining.md`](../../research/twin-prime-parity/rounds/rh40/K_remaining.md) — §5.1 "Termination criterion (PROVED, verified)"

## Statement

> For a non-increasing positive alphabet `α_n` and target `x`, the greedy rule halts
> finitely iff `Σ_n α_n ≥ x`; the taken set is the initial segment
> `{0, …, N−2}` with `N = min{n : Σ_{k<n} α_k ≥ x}`. For `α_n = (n+2)^{−p}` and
> `x = 1`, since `Σ_{n≥0}(n+2)^{−p} = ζ(p) − 1`,
>
> ```
> the family halts  ⟺  ζ(p) ≥ 2  ⟺  p ≤ p* = 1.728647238998183618135.
> ```
>
> The threshold is **target-dependent**: for general `x` it is the root of
> `ζ(p) − 1 = x`, e.g. `x = 1/2 → p = 2.18528545178748223`, `x = 0.9 → 1.7883`,
> `x = 0.1 → 3.7706`. Recorded facts confirmed; the handoff's phrasing as a property
> of `p` alone must be read with `x = 1`.

## Hypotheses and notation

- `α_n` is a non-increasing positive alphabet; `x` is the target.
- The greedy rule takes `α_n` in increasing `n` while the residual remains covered; "halts finitely" means the residual reaches 0 after finitely many selections, so the taken set is an initial segment `{0, …, N−2}`.
- `N = min{n : Σ_{k<n} α_k ≥ x}` is the index at which the initial segment ends.
- For the power family `α_n = (n+2)^{−p}`: `Σ_{n≥0}(n+2)^{−p} = ζ(p) − 1`, so halting is `ζ(p) ≥ 2`, and `p* = 1.728647238998183618135` is the root.
- The threshold root is `ζ(p) − 1 = x`; the source's examples are `x = 1/2 → p = 2.18528545178748223`, `x = 0.9 → 1.7883`, `x = 0.1 → 3.7706`.

## Proof / evidence

The source states this as "PROVED, verified" and gives no separate proof text for the criterion; the threshold is derived from the identity `Σ_{n≥0}(n+2)^{−p} = ζ(p) − 1`. Evidence file named by the source: [`verify/k7_alphabet.py`](../../research/twin-prime-parity/rounds/rh40/verify/k7_alphabet.py) (delegated) plus the mediator's independent recomputation.

The later round `research/twin-prime-parity/rounds/rh41/TRUTHS.md` states the same criterion as "Theorem 9 (halting criterion)", harvested as [Theorem 9 (halting criterion)](tpp-rh41-truths-theorem-9-halting-criterion.md); see Notes.

## Dependencies and related results

- [The corrected structure theorem (power family)](tpp-rh40-k-remaining-structure-theorem.md) — the case analysis `S < 1`, `S = 1`, `S > 1` for `S = ζ(p) − 1`.
- [The exponential alphabet gives bounded gaps and termination](tpp-rh40-k-remaining-exponential-alphabet-dichotomy.md) — the counterexample to the dichotomy, which uses this criterion's initial-segment reading.
- [The inverse problem has no halting alphabet with linear complexity](tpp-rh40-k-remaining-inverse-problem-negative.md) — §5.5, which invokes "any alphabet with `Σ α_n ≥ x` halts (§5.1) and so has finitely many ones".
- [Theorem 9 (halting criterion)](tpp-rh41-truths-theorem-9-halting-criterion.md) — the later round's restatement.
- [Every rational x terminates](tpp-rh41-truths-theorem-8-rational-termination.md) and [R5 — rational termination, general p](tpp-rh42-truths-r5-rational-termination-general-p.md) — the rational-termination results in the same programme.

## Notes

- **Restatement round, and a later correction.** The criterion is "Theorem 9 (halting criterion)" in the later round `research/twin-prime-parity/rounds/rh41/TRUTHS.md`, harvested as [Theorem 9 (halting criterion)](tpp-rh41-truths-theorem-9-halting-criterion.md) — where it carries Status **REFUTED** ("Lean; the printed `iff` is false — only 'halting ⟹ some partial sum ≥ x' holds"), and where the threshold is printed as `p* = 1.7286472389981836181` with `ζ(p*) = 2 exactly`. The Status line here records what the `rh40` source itself asserts ("PROVED, verified"); the contradiction with the later Lean-refuted `iff` is recorded, not resolved, since this harvest copies each source faithfully.
- The source's own caveat is preserved: "the handoff's phrasing as a property of `p` alone must be read with `x = 1`."
- A delegated report's structural claim about this family is separately refuted in §5.2 (recorded there, not harvested as a theorem); §5.2 is the source of the "the error is reading `N(p)` as a stopping point" correction.
- Quantities quoted exactly as printed: `p* = 1.728647238998183618135`, `2.18528545178748223`, `1.7883`, `3.7706`.
