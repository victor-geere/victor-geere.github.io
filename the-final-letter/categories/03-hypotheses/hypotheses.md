# Hypotheses

The programme is organised around eight hypotheses. They are stated so they can be attacked, weakened, or refuted. None is an axiom of the Lean development.

## H1 — The RH wall is an arithmetic-positivity wall

The remaining gap in the Riemann programme is not a missing estimate. It is the absence of an arithmetic positivity/multiplicativity input that would exclude a right-half atom of the unrestricted measure, equivalently the joint non-vanishing of `K = ¼ Re ξ` and `S = ¼ Im ξ`, equivalently Weil positivity for the repaired current.

**Status:** supported by the Davenport–Heilbronn sharpness theorem and the failure of the tensor positivity `(★)`.

## H2 — The parity wall is a missing positive-density coupling

The remaining gap in the parity programme is not a missing estimate of the greedy word. It is the absence of a sign-blind rule with a positive-density multiplicative coupling to `Ω`. The five proposed bridges fail for structural reasons, not for want of numerical precision.

**Status:** supported by the barrier ledger P1–P19, B1–B5.

## H3 — Finite prefixes cannot decide either wall

No finite prefix of values can decide the asymptotic statements. For two-point Chowla this is the finite-prefix indeterminacy theorem, Lean-certified. For RH, the analogous statement is that finite numerical certificates at bounded height (e.g. `T=15`, `T=33`) do not prove the asymptotic.

**Status:** H3 is proved for the Chowla slice; for RH it is a methodological observation, not a formal theorem.

## H4 — Any bridge must fail for the Davenport–Heilbronn twist

A result can close the RH gap only if it consumes an Euler product, a positivity, or a self-adjointness that the Davenport–Heilbronn function does not have. This is the litmus of Corollary C.10.

**Status:** proved as a limitative consequence for the additive toolbox of the paper.

## H5 — Any bridge must be pointwise, not density-only

Density statements are blind to a density-zero set of off-line zeros (Bombieri–Hejhal). The measures `μ,ν` escape this only because the tempering weight charges individual atoms. A Lee–Yang theorem for the polygon would have to be pointwise in the same sense.

**Status:** supported by the barrier ledger; F.4 remains open.

## H6 — The two walls share a common missing object

The missing inputs are not identical, but they are the same kind: a global arithmetic positivity that the local machinery cannot manufacture. The RH side calls it Weil positivity/(M); the parity side calls it a positive-density coupling to `Ω`.

**Status:** structural hypothesis; the programme’s central interpretive claim.

## H7 — Formalisation clarifies but does not close the walls

Lean can formalise the finite-prefix core, the definitions, and the elementary implications. It cannot formalise the missing global input without assuming it. The formalisation is a map of the provable layer, not a proof of the wall.

**Status:** demonstrated by the `FinalLetter` Lean development.

## H8 — The futility is structural

The failure is not a lack of effort, compute, or cleverness. It is the structure of the available data: finite prefixes, additive characters, sign-blind rules, and density statements cannot produce the missing global object. More of the same cannot close the wall.

**Status:** the programme’s final assessment; argued in the final note.

[Back to README](README.md) · [Back to index](../../index.html)
