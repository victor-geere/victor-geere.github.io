# Status ledger

## The third objective

| Objective | Statement | Status |
|---|---|---|
| Certified evaluation | Rational enclosures of `ζ(s)`, `ζ(s,a)`, `L(s,χ)` via Euler–Maclaurin partial sum + tail | Interval algebra, certificate replay, transport, eta cos/sin split PROVED in Lean; Euler–Maclaurin formula and transcendental leaves source claims |

The two walls are the programme's negative results; the third objective is the positive computation layer. See [`topics/partial-sum-plus-tail`](topics/partial-sum-plus-tail/README.md).

## The two walls

| Wall | Statement | Status |
|---|---|---|
| Riemann | Every non-trivial zero of `ζ` has real part `1/2` | OPEN |
| Parity | The twin-prime conjecture / two-point Chowla | OPEN |

The programme converts both and proves the limits of the local toolboxes. It does not close either wall.

## Proved

| Result | Where |
|---|---|
| RH conversion: support equality iff RH | [Summary Cor 12.3](summary/05-spectral-measures-and-tightness/13-corollary-12.3.md) |
| Davenport–Heilbronn sharpness | [Summary Theorem C.9](summary/06-davenport-heilbronn/09-theorem-c.9.md) |
| No additive theorem from the toolbox can be RH | [Summary Cor C.10](summary/06-davenport-heilbronn/10-corollary-c.10.md) |
| Tensor inequality `(★)` false; Weil-current repair | [Summary tensor](summary/10-prime-spectrum-tensor/README.md) |
| Finite-prefix indeterminacy | [Summary-rh ledger §7](summary-rh/01-ledger/07-two-point-chowla-and-the-finite-prefix-theorem-rh46.md) |
| Greedy complexity law, budgets, balance | [Summary-rh ledger §§2–4](summary-rh/01-ledger/README.md) |
| Smoothing does not remove `√N` | [Summary-rh ledger §5](summary-rh/01-ledger/05-the-smoothing-bridge-rh044.md) |
| Corrected explicit formula; `T=15/33` finite certificates | [Summary-rh ledger §6](summary-rh/01-ledger/06-the-explicit-formula-and-routes-a-b-c-rh45-010.md) |
| Sylvester sparsity; no Euler product | [Summary-rh ledger §8](summary-rh/01-ledger/08-greedy-sine-vs-the-parity-barrier-rh47.md) |
| One-point Chowla = PNT | [Summary-rh errata X1](summary-rh/04-programme/03-corrections-x1-x6.md) |
| Lean finite-prefix core | [`lean/`](lean) |

## Proved limits

- **DH litmus.** No additive theorem from the RH toolbox can prove RH.
- **Finite-prefix no-go.** No finite prefix can decide two-point Chowla.
- **Five-bridge refutation.** Support parity, budget parity, ζ-machinery, positive-density support, and arithmetic alphabet all fail.
- **Density blindness.** Density statements cannot see a density-zero off-line set.
- **Well-posedness.** OP-3 as inherited is not a proposition; OP-19 replaces it.

## Open

- RH; twin primes; Chowla `k≥2`; Sarnak; Elliott.
- OP-19; OP-1; OP-4; OP-9; OP-16; OP-17; OP-18.
- `(M)`; Weil positivity; F.4; `Λ=0`; Jensen/Li; uniform slow passage.
- Formalising the conversion theorem and the greedy/budget layers in Lean.

## Refuted / withdrawn

- `(★) ≥ 0`; `Φ` positive type; the K-sign law.
- OP-3 as stated; OP-18 as stated.
- The OP-5 `O(1/p)` error; the exact ceiling law.
- X1–X6 (one-point Chowla, sparse bound, product tail, 17/21 count, barrier sentence, k-point contradiction).
- 015 dimension law; 015 character-sum identity.
- The two `maths/` working notes’ RH claims.

Full ledgers: [Summary withdrawn](summary/12-open-problems/withdrawn-and-refuted.md), [Summary-rh errata](summary-rh/05-lean-verification/03-errata.md).

## Lean

`FinalLetter/Chowla.lean` (vendored finite-prefix development), `FinalLetter/Synthesis.lean` (two walls + finite-prefix theorem), `FinalLetter.lean` (root). Build `[check] OK`; no `sorry`; no `axiom`. The open statements are `def`s.

## The one-sentence status

**The map is complete; the walls are not crossed.**

[Back to README](README.md) · [Back to index](index.html) · [Glossary](GLOSSARY.md)
