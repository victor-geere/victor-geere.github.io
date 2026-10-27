# THEOREM 3.3 — one-point Chowla is equivalent to PNT

**Kind:** Theorem
**Status:** PROVED (paper argument; classical equivalence, proof route given in the source)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/dictionary/03-parity-problem.md`](../../research/twin-prime-parity/dictionary/03-parity-problem.md) — §3.2

## Statement

> **THEOREM 3.3.** `Σ_{n≤x} λ(n) = o(x)` **if and only if** PNT holds; since PNT is proved, the one-point Chowla statement is a **theorem**.

*Source (as given):* verified verbatim in [Matomäki–Radziwiłł–Tao, arXiv:1509.01545](https://arxiv.org/abs/1509.01545) §1: *"For `k = 1`, this claim is equivalent to the prime number theorem, but for `k > 1` Chowla's conjecture remains open."* Also [Tao, arXiv:1605.04628](https://arxiv.org/abs/1605.04628) §1.

*Proof route (as given):* `Σ_{n≤x}λ(n) = Σ_{d≤√x} M(x/d²)` with `M(y) = Σ_{n≤y}μ(n)` (from `λ = 1_□ * μ`), and conversely `M(x) = Σ_{d≤√x} μ(d) L(x/d²)`; splitting the `d`-sum at a large fixed `D` shows `Σ λ(n) = o(x) ⟺ M(x) = o(x)`, and `M(x) = o(x) ⟺` PNT (classical, Landau).

## Hypotheses and notation

- `λ(n) = (−1)^{Ω(n)}` (Definition 1.2); `μ` is the Möbius function (Definition 1.3).
- `M(y) = Σ_{n≤y} μ(n)` is the Mertens function; `L(y) = Σ_{n≤y} λ(n)` is the Liouville summatory function (the source writes `L(x/d²)`).
- `λ = 1_□ * μ`: `Σ_{d|n} λ(d) = 1` if `n` is a square and `0` otherwise.
- PNT is `ψ(x) := Σ_{n≤x} Λ(n) = x + o(x)`.

## Proof / evidence

- The source gives the **proof route** above (not a full proof): it reduces the one-point statement to `M(x) = o(x)`, and quotes the classical equivalence `M(x) = o(x) ⟺ PNT` (Landau).
- The equivalence with PNT is verified verbatim in the cited abstracts/sections (MRTT arXiv:1509.01545 §1, Tao arXiv:1605.04628 §1).

## Dependencies and related results

- [`THEOREM (basic)` — complete multiplicativity of `λ`](tpp-dict-03-liouville-completely-multiplicative.md) supplies `λ = 1_□ * μ`.
- Same statement as the Landau theorem of §1.1 ([parity classes density](tpp-dict-03-landau-parity-classes-density.md)) and as §4.1 row **T1**.
- Used by [`THEOREM 3.5`](tpp-dict-03-two-point-equidistribution.md) ("given the one-point theorem 3.3") and contrasted with [`OPEN 3.4`](tpp-dict-03-two-point-chowla-open.md).
- Restated in the §7 ledger row "3.3".

## Notes

- **Record correction (preserved verbatim in substance).** `rh46/README.md` §1.3 states that one-point Chowla *"is itself OPEN"*. **That is an error**, repeated in `rh47/HANDOFF.md` §5.1 and `rh47/README.md`. The register [`07-open-problems.md`](../../research/twin-prime-parity/open/07-open-problems.md) §0.1 and OP-2 already corrects it; the source repeats the correction because it is the dictionary entry for the statement. The *obstruction* to the one-point case is methodological (Selberg's parity principle, §2.1), not a lack of truth.
- `k = 1` Chowla being a theorem does **not** extend to `k ≥ 2`; see OPEN 3.4.
