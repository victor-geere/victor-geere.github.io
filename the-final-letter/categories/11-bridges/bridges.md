# Possible bridges

A bridge is a proposed route from the available data to the far side of a wall. The programme evaluates each bridge by three tests:

1. **Does it pass the Davenport–Heilbronn litmus?** It must fail for the DH twist, or it is not consuming the missing arithmetic input.
2. **Is it pointwise or only density-level?** Density statements are blind to density-zero off-line sets.
3. **Is it proved, conditional, or open?** A bridge that is only a re-description is not a bridge.

## B1 — Weil positivity / the explicit formula

**What it would give.** Positivity of the Weil current `W` on the cone is equivalent to RH; its spectral resolution is exactly the zero measure.

**Status.** The correct form is proved (Theorem C of `tensor.md`), but the positivity is open. The naive current `P` and its inequality `(★)` are refuted, so the bridge must use `W`, not `P`.

**Verdict.** The right bridge on the RH side; the far side is open.

## B2 — Hypothesis (M) and Saias–Weingartner

**What it would give.** Under (M) — no zeros in `σ>1` — the DH obstruction lapses and the conversion becomes GRH for one `L`-function.

**Status.** Conditional. (M) is true for `ζ`, false for DH. It removes the limitative result but does not prove RH; multiplicativity is known only to reach within `o(1)` of `σ=1`.

**Verdict.** A bridge to a conditional conversion, not to RH.

## B3 — Lee–Yang / ferromagnetic confinement

**What it would give.** A ferromagnetic spin system whose finite partition functions are the polygon would confine every finite zero to a line. This is F.4.

**Status.** Open. It passes the DH litmus because it uses a positivity a sum of two partition functions does not have. The computable part is the transfer-operator form.

**Verdict.** The most promising structural bridge; no construction yet.

## B4 — Hilbert–Pólya / CCM

**What it would give.** A self-adjoint operator whose spectrum is the zero ordinates.

**Status.** Open. The CCM programme reduces it to Conjecture 1 (the ground-state eigenvector is a prime sum). The canonical programme’s tensor work reaches Weil positivity instead. No operator is constructed.

**Verdict.** A bridge in principle; the far side is a conjecture. The dossier-side survey, with the finite truncation as the first step, is in [`bridge-to-weil-positivity.md`](../../bridge-to-weil-positivity.md).

## B5 — Heat flow / de Bruijn–Newman

**What it would give.** `Λ=0` is RH. Known `0 ≤ Λ ≤ 0.22`.

**Status.** Open. The flow is a genuine deformation of `Φ`; the endpoint `τ=0` is the wall. The programme’s cosine/Jensen/Li analysis locates the same object.

**Verdict.** A quantitative bridge; the last `0.22` is not a proof.

## B6 — Log-arc rules / OP-19

**What it would give.** A well-posed parity statement: is `C_I(x)=o(x)` for every log-arc rule?

**Status.** Open. It replaces the unstatable OP-3. A proof would be a genuine parity result; a counterexample would kill the sign-blind programme.

**Verdict.** The cleanest parity bridge; no proof yet.

## B7 — The straightening field

**What it would give.** Holonomy equals the zero count; under the Rouché condition (E.1), the count is computable from two finite Euler sums.

**Status.** Proved identities; (E.1) is explicit. No admissible contour is known to reach the critical line (Remark E.11).

**Verdict.** A finite-data bridge to the zero count, not to RH.

## B8 — The tensor / Weil current

**What it would give.** The exact spectral resolution of `W` is the zero measure; positivity is RH.

**Status.** Proved resolution; open positivity. The naive `P` is refuted.

**Verdict.** The correct real-variable form of B1; same wall.

## B9 — Transfer operator

**What it would give.** The computable part of F.4: write the polygon as a trace over the `N`-spin chain and compute the sign of the induced couplings for small `N`.

**Status.** Tractable, not done. A negative coupling settles F.4 in the negative for that representation; positive couplings for all `N` would be the first Lee–Yang-shaped input that passes the litmus.

**Verdict.** The most concrete next computation; not a proof.

## B10 — Finite-prefix data

**What it would give.** Nothing asymptotic. It can refute, not establish.

**Status.** Proved no-go: finite-prefix indeterminacy.

**Verdict.** Not a bridge. It is the proof that a certain class of bridges cannot exist.

## B11 — Certified evaluation (explicitly not a bridge)

**What it would give.** Rational enclosures of `ζ(s)`, `ζ(s,a)` and `L(s,χ)` with a replayable certificate. It gives exact finite-scale values, not an asymptotic statement.

**Status.** The rational cell, certificate replay, eta split, transcendental enclosures, Euler–Maclaurin S1–S2 (`K ≥ 1`) and a closed rectangle enclosure for `Re s > 1` are Lean-proved. No wall theorem uses an enclosure as a hypothesis yet; a target-width certificate format is proved, but a symbolic width bound is not.

**Verdict.** Not a bridge. It is the instrument a future bridge can use, and the letter says so rather than promoting it.

## Bridge ledger

| Bridge | Passes DH litmus? | Pointwise? | Status | Far side |
|---|---|---|---|---|
| B1 Weil positivity | yes | yes | open | RH |
| B2 (M) | yes | yes | conditional | GRH conversion |
| B3 Lee–Yang | yes | yes | open | F.4 |
| B4 Hilbert–Pólya/CCM | yes | yes | open | CCM Conj 1 |
| B5 heat flow | yes | yes | open | Λ=0 |
| B6 OP-19 | yes | yes | open | parity |
| B7 straightening | no Euler product | yes | conditional (E.1) | zero count |
| B8 Weil current | yes | yes | open | RH |
| B9 transfer operator | yes | yes | tractable | F.4 |
| B10 finite prefix | no | — | no-go | none |
| B11 certified evaluation | n/a | n/a | proved finite layer incl. S1–S2; replay wiring open | none (instrument) |

The table is the programme’s answer to “what are the possible bridges?”: there are several, but they all terminate at the same two walls. The bridges are real; the far banks are not. B11 is listed to make the negative claim explicit: a certified evaluator is an instrument, not a route across either wall.

[Back to README](README.md) · [Back to index](../../index.html)
