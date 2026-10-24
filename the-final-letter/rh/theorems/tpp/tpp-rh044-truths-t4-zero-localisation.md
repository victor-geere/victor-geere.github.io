# T4 — zero localisation

**Kind:** Claim
**Status:** VERIFIED (numerical; both routes agree to the `1e-44` bisection floor)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh044/truths.md`](../../research/twin-prime-parity/rounds/rh044/truths.md) — §4 "Zero localisation (T4)", line 128

## Statement

> **VERIFIED.**  With a reliable `ζ` evaluator (mpmath's `mp.zeta`, cross-checked by
> the auditor's theta route), bracketed bisection gives the first five zeros:
> `14.1347251417346937904572519836`, `21.0220396387715549926284795939`,
> `25.0108575801456887632137909926`, `30.4248761258595132103118975306`,
> `32.9350615877391896906623689641` (both routes agree to the `1e-44` bisection floor).
>
> In contrast, the **sharp partial sum cannot do this**: for `N = 10^3, 10^4` the first
> positive roots of `Re S_N(1/2+it)` are `0.30398963, 0.21372367`, with `60` and `102`
> roots in `(0,35)` (stable under scan refinement `0.05` vs `0.02`) — generic
> oscillations, `t_1·log N = 2.0999, 1.9685` (an effective `t_1 ~ (log N)^{−1.22}` from
> the two-point fit, drifting to the model `π/2`), and `|ζ(1/2+it_1)| = 1.26, 1.35`,
> i.e. no root within `10^{−3}` of a true zero.

The source adds: "Two independent calculations (`Re S_N` and `Z(t)`) confirm: the sharp partial sum's roots are not zeta zeros." and, parenthetically, "(Re ζ alone also has spurious roots — at `0.8195`, `20.654`, `29.739`, `33.624` there are sign changes of `Re ζ` but no zero of `ζ`; only `Z(t)`-based bracketing is reliable.)"

## Hypotheses and notation

- `S_N(s) = Σ_{n≤N} n^{−s}` is the sharp partial sum; `Z(t)` is the Riemann–Siegel `Z`-function.
- `t_1` denotes the first positive root of `Re S_N(1/2+it)`.
- `1e-44` is the bisection floor at which the two independent routes agree.

## Proof / evidence

Numerical: bracketed bisection with `mpmath`'s `mp.zeta`, cross-checked by the auditor's own theta route ([Theorem 3](tpp-rh044-truths-theorem-3-riemann-theta-identity.md)); the routes agree to the bisection floor. The sharp-partial-sum contrast rests on scans at refinement `0.05` and `0.02`.

## Dependencies and related results

- [Theorem 3 (Riemann's theta identity)](tpp-rh044-truths-theorem-3-riemann-theta-identity.md) — the route used as the independent evaluator.
- [T5 — the zero count](tpp-rh044-truths-t5-zero-count.md) — the count at `T = 30, 35`.
- [README fact 4 — zero localisation](tpp-rh044-readme-fact-4-zero-localisation.md) — restates this result and additionally quotes `N = 10^5` values.
- The source cites the earlier round `../rh43/truths.md` T16″ for "the finite-N balance sees generic roots, not zeta zeros".

## Notes


- The source explicitly does **not** claim the `N = 10^5` count `≈128`: "The `N = 10^5` count `≈128` from earlier partial runs is **not** claimed here: it was omitted for runtime and is unverified — recorded as OPEN."
- The README contradicts this by reporting `0.163744` and `128` roots for `N = 10^5` as part of the settled facts (see [README fact 4](tpp-rh044-readme-fact-4-zero-localisation.md)); this harvest records both without resolving them.
- Status VERIFIED (numerical) is the source's own bolded verdict; the first-five-zeros list is a computation, not a theorem with proof.
- **Correction to a correction (session-003 audit, 2025-10-06).** The `evidence absent` qualifier that briefly stood here was **false** and has been reversed: a committed artefact does compute the numbers above — `research/twin-prime-parity/rounds/rh044/verify/independent_check.log`. The qualifier was assigned by a mechanical rule that looked only at this document and at the source it was harvested from, and only for artefact names, so it missed evaluators kept elsewhere in the tree. The original label is restored, unqualified. See `AUDIT-verification-labels-002.md` §6.
