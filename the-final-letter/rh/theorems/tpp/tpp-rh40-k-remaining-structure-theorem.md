# The corrected structure theorem (power family)

**Kind:** Theorem
**Status:** PROVED (paper argument)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/K_remaining.md`](../../research/twin-prime-parity/rounds/rh40/K_remaining.md) — §5.3 "The corrected structure theorem (PROVED)"

## Statement

> For `α_n = (n+2)^{−p}`, `x = 1`, `p > 1`, with `S = ζ(p) − 1`:
>
> | case | structure | halts? | gaps |
> |---|---|---|---|
> | `S < 1` (`p > p*`) | `1^∞` | never | all 1 |
> | `S = 1` (`p = p*`) | `1^∞` | at the limit | all 1 |
> | `S > 1` (`1 < p ≤ p*`) | `1^{N−1} 0^{…} 1 0^{…} 1 …` | **never** — infinitely many later selections | **unbounded** |

## Hypotheses and notation

- `α_n = (n+2)^{−p}` is the power alphabet; `x = 1` is the target; `p > 1`; `S = ζ(p) − 1 = Σ_{n≥0}(n+2)^{−p}`.
- `p* = 1.728647238998183618135` is the halting threshold of [the termination criterion](tpp-rh40-k-remaining-termination-criterion.md), i.e. the root of `ζ(p) = 2`; the three rows correspond to `p > p*`, `p = p*`, `1 < p ≤ p*`.
- `N` is the end of the initial segment; the residual after it is fixed and positive in the third row.
- The third row's structure string is the source's exact rendering: `1^{N−1} 0^{…} 1 0^{…} 1 …`.

## Proof / evidence

The source gives the proof of the third row in full:

> *Proof of the third row.* After the initial segment, `r = 1 − Σ_{k<N} α_k > 0` is fixed and positive; `α_k → 0`, so the set `{k : α_k ≤ r}` is infinite (it is a tail), and the residual is reduced by each such `α_k` but never reaches 0 because `Σ_{k≥K} α_k < r` once `K` is large enough. ∎

The source then applies it to the concrete witness of §5.2: for `p = 3/2`, `x = 1`, `N = 10`, the initial segment is `{0, …, 8}` with residual `r = 1 − Σ_{k=2}^{11} k^{−3/2} = 0.004663506…`, and "the mediator's full run gives `taken = {0,1,2,3,4,5,6,7,8, 34, 954, 77716, …}     max gap 76 762  (so far)`", with the gaps "25, 919, 76 761, … and unbounded".

This is the source's correction of the delegated report's claim (quoted in §5.2): *"the word is `1^{N(p)}0^∞`, so every gap is exactly 1 for every `p`"* — "The error is reading `N(p)` as a stopping point: `N(p)` is where the *initial segment* ends, not where the orbit ends."

## Dependencies and related results

- [Termination criterion for a greedy alphabet (and the ζ(p) threshold)](tpp-rh40-k-remaining-termination-criterion.md) — defines `p*` and the initial segment.
- [The exponential alphabet gives bounded gaps and termination](tpp-rh40-k-remaining-exponential-alphabet-dichotomy.md) — shows the "bounded gaps OR termination" dichotomy fails outside the power family.
- [The inverse problem has no halting alphabet with linear complexity](tpp-rh40-k-remaining-inverse-problem-negative.md) — §5.5.
- [Theorem 10 (structure, corrected)](tpp-rh41-truths-theorem-10-alphabet-structure.md) — the later round's statement of the same case analysis; see Notes.

## Notes

- **Restatement round.** The same case analysis is "Theorem 10 (structure, corrected)" in the later round `research/twin-prime-parity/rounds/rh41/TRUTHS.md`, harvested as [Theorem 10 (structure, corrected)](tpp-rh41-truths-theorem-10-alphabet-structure.md), where the middle and concrete rows read `1^{N−1} 0… 1 0… 1 …` and `taken = {0,…,8, 34, 954, 77716, …}` with max gap `76 762`.
- **Source's own framing.** §5.2 labels the delegated report's structural claim **REFUTED**; §5.4 then shows the report's *dichotomy* is nevertheless false for another reason (the exponential alphabet). Both are recorded here in Notes; the theorem above is the corrected positive structure statement.
- The third-row verdict in the source's §0 summary is part of K7: "the family is rigid; the dichotomy is false."
- Quantities quoted exactly as printed: `N = 10`, `r = 0.004663506…`, `taken = {0,1,2,3,4,5,6,7,8, 34, 954, 77716, …}`, max gap `76 762`, gaps `25, 919, 76 761`.
