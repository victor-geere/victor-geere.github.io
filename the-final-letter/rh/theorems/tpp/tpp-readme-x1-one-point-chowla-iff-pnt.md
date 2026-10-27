# X1 — one-point Chowla `Σ_{n≤x}λ(n) = o(x)` is equivalent to PNT

**Kind:** Theorem
**Status:** CITED (literature; `λ = 1_squares ∗ μ`, cited Tao [arXiv:1605.04628](https://arxiv.org/abs/1605.04628))
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/README.md`](../../research/twin-prime-parity/README.md) — "Corrections this harvest forced on the rounds' own records", row X1

## Statement

> | # | the round's claim | correction | witness |
> |---|---|---|---|
> | X1 | "one-point Chowla `Σ_{n≤x}λ(n) = o(x)` is itself **OPEN**" (rh46 §1.3, rh47 §5.1) | **false** — it is **equivalent to PNT**, i.e. a **theorem**.  `λ = 1_squares ∗ μ`, so `Σ_{n≤x}λ(n) = Σ_{d≤√x} M(x/d²) = o(x)` follows from `M(y) = o(y)` | identity verified exactly (`x = 100, 1000`), and `L(x)/x → 0` measured; citation: Tao, [arXiv:1605.04628](https://arxiv.org/abs/1605.04628) |

## Hypotheses and notation

- `λ(n) = (−1)^{Ω(n)}` the Liouville function; `μ` the Möbius function.
- `M(y) = Σ_{n≤y} μ(n)` is the Mertens function; `L(x)` is the Liouville summatory function, `L(x)/x` the ratio measured in the witness.
- `1_squares` is the indicator of the squares and `∗` is Dirichlet convolution, so the displayed identity is `λ = 1_squares ∗ μ`.
- PNT is the prime number theorem, in the Mertens form `M(y) = o(y)`.

## Proof / evidence

- The source gives the proof route in the correction cell: `λ = 1_squares ∗ μ` gives `Σ_{n≤x}λ(n) = Σ_{d≤√x} M(x/d²)`, which is `o(x)` once `M(y) = o(y)`; the converse direction (PNT from one-point Chowla) is the classical equivalence.
- Verified evidence quoted: "identity verified exactly (`x = 100, 1000`), and `L(x)/x → 0` measured".
- Citation: Tao, [arXiv:1605.04628](https://arxiv.org/abs/1605.04628).
- The same theorem is harvested from the dictionary as "THEOREM 3.3 — one-point Chowla is equivalent to PNT" (a Lean-free paper argument there), with the additional reference Matomäki–Radziwiłł–Tao arXiv:1509.01545 §1.

## Dependencies and related results

- Corrects `rh46/README.md` §1.3 ("one-point Chowla `Σ_{n≤x} λ(n) = o(x)` is itself OPEN") and `rh47/HANDOFF.md` §5.1.
- Relates to the round's own trailing record note in `rh46/README.md`, which repeats the correction.
- The statement is the `k = 1` case of the Chowla conjecture, in contrast to the open `k = 2` case `Σ λ(n)λ(n+2) = o(x)`.

## Notes

- Harvested because the programme README labels and states it as a correction of a named round claim, with a witness and a citation; the status is **CITED (literature)**, matching the source's own attribution.
- The README's wording "it is **equivalent to PNT**, i.e. a **theorem**" is preserved; the equivalence is claimed in both directions, not only the easy one.
- The witness figures `x = 100, 1000` and the measured limit `L(x)/x → 0` are quoted exactly.
