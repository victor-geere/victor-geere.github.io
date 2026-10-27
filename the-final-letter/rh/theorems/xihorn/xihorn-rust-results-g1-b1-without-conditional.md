# G1 — done. B1 without its conditional

**Kind:** Theorem
**Status:** PROVED (paper argument; four proved bounds propagated through interval arithmetic at 60 digits — 35/35 P^{d,n} certified, 15/35 J^{d,n})
**Area:** xi-horn
**Source:** [`xi-horn/rust/RESULTS.md`](../../xi-horn/rust/RESULTS.md) — Summary, "G1 — done. B1 without its conditional"

## Statement

> **G1 — done. B1 without its conditional.** `bounds.rs` bounds γ(n) instead of
> measuring it, so the certificate no longer rests on "the quadrature has
> converged". Four inequalities replace four estimates: (G1a) the shell
> truncation, (G1b) the composite-trapezoid remainder, (G1c) the piece below V₀,
> (G1d) the piece above V₁. At V₀ = −14, h = 2⁻¹⁴, V₁ ≈ 1.4 — 252,317 nodes,
> 63,079 interval jet blocks, 60 digits, four minutes:

| | required | achieved, certified |
|---|---|---|
| P at d = 6, n = 30 | 5.427e−6 (half-width) | **3.283e−7** full — 33.1× slack |
| J at d = 6, n = 30 | 3.621e−18 | short by eleven decades |

> **35 of 35 P^{d,n} certified; 15 of 35 J^{d,n}.** J holds to d = 3 and dies at
> (4, 5). H2's table, re-derived from the opposite direction: the same proved
> enclosure certifies every P and fewer than half the J.
>
> What binds is not what the item expected. (G1b) dominates at every n, by
> between one and four hundred decades — the two tails are not merely small,
> they are irrelevant:
>
> ```text
>     n     rel width     G1b quad      G1c low     G1d high
>     0     1.3028e-9     6.30e-10     4.28e-11   6.65e-4542
>    36     3.2834e-7      1.64e-7    3.31e-445   1.34e-4492
> ```
>
> Three findings from building it:
>
> * **V₀ = −50 is the wrong limit for a certified rule.** `mellin.rs` needs it
>   because the Euler–Maclaurin *boundary* term survives at −16. The certified
>   rule has no separate boundary term — (G1b) bounds the remainder over the
>   whole range at once and (G1c) is exact — so V₀ = −14 suffices, 3.6× fewer
>   nodes;
> * **f″'s cancellation must be kept inside the interval arithmetic.**
>   f″ = e^{av}(a²g + 2a·g′ + g″) and those three nearly cancel at the saddle,
>   where |f″| is f/σ² and not a²f. Bounding them separately inflates (G1b) by
>   ~40× at n = 36 — worth more than a factor of four in h;
> * **the block width has its own scale.** The enclosure of g over a block of
>   width ω is relatively e^{Lω} − 1 too wide, L ≈ 350 near the peak, so blocks
>   past ~10⁻³ cost more than the jet evaluations they save. Both h and ω were
>   tuned by measurement, and the h² law checks out across the scan: 8× in h and
>   4× in ω moved (G1b) at n = 36 by 169×, against 64 × 2.6 predicted.
>
> And the price of a proof, stated plainly: the *measured* rule converges
> spectrally (H1 — each halving of h roughly triples the correct digits), and
> this bound sees only h². The certified enclosure is 3.3e−7 wide where the same
> quadrature is in fact correct to far more. That gap is the whole reason G1
> targets P rather than J.

## Hypotheses and notation

- The four bounds (G1a)–(G1d) are quoted verbatim in their own files: [G1a](xihorn-todo-g1a-shell-truncation-bound.md), [G1b](xihorn-todo-g1b-trapezoid-remainder-bound.md), [G1c](xihorn-todo-g1c-piece-below-v0.md), [G1d](xihorn-todo-g1d-piece-above-v1.md).
- Run parameters: V₀ = −14, h = 2⁻¹⁴, V₁ ≈ 1.4, 252,317 nodes, 63,079 interval jet blocks, 60 digits, four minutes.
- `max width` (H2) is a **half**-width; the achieved figure is a full width — see **E16**.
- Driver `bin/g1_theorem`; modules `jet.rs`, `bounds.rs`.

## Proof / evidence

The coefficients arrive as intervals proved to contain a(n) — four proved inequalities replace the four measured estimates — and the same interval LDLᵀ that B1 and H2 run decides the sign from them. Results: 35 of 35 P^{d,n} certified for d = 2…6, n = 0…30, and 15 of 35 for J^{d,n}, which "holds to d = 3 and dies at (4, 5)". The binding term is identified by measurement ((G1b) at every n) rather than assumed.

## Dependencies and related results

- [G1a](xihorn-todo-g1a-shell-truncation-bound.md), [G1b](xihorn-todo-g1b-trapezoid-remainder-bound.md), [G1c](xihorn-todo-g1c-piece-below-v0.md), [G1d](xihorn-todo-g1d-piece-above-v1.md) — the four bounds.
- [B1 — certified discriminant signs](xihorn-rust-results-b1-certified-discriminant-signs.md) — the conditional version this removes; [H2](xihorn-rust-results-h2-p-jensen-max-width.md) — the demand side.
- [G2 — the frontier is a staircase](xihorn-rust-results-g2-frontier-staircase.md) — pushes the same pipeline until it breaks.
- [Chasse 2013 and GOR⁺ Corollary 1.3](xihorn-todo-e8-chasse-and-corollary-1-3.md) — **E8**: the result is not new mathematics; what G1 delivers is "a *self-contained* certification running from the horn's own integral to a certified sign, with no step taken on trust".

## Notes

- Two claims in G1's own recipe did not survive execution: **E12** (the Poisson route has no strip to work in) and **E13** (sup|Φ′| gives one power less than the sentence it appears in claimed).
- **E16**: `certify_iv` stored a full relative width where `certify_in` stores a half, so slack figures read half their true value; G1's slack at the tightest demand is **33.1×**, not the 16.5× first published.
