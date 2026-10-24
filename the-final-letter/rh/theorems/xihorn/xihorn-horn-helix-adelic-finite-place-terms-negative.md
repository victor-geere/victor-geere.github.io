# Every finite place's term is negative (for a Gaussian window)

**Kind:** Proposition
**Status:** PROVED (paper argument; G > 0 and (13) with a positive window; checked numerically for the first 2000 places at v = 0, 5, 10)
**Area:** xi-horn
**Source:** [`xi-horn/horn-helix-adelic.md`](../../xi-horn/horn-helix-adelic.md) — §4.5 "The sign structure, and where positivity actually lives"

## Statement

> For a Gaussian window, G — the inverse transform of Φ̂² — is a Gaussian, hence positive, hence by (13) **every finite place's term is negative**. Checked for the first 2000 places at v = 0, 5, 10: all strictly negative, without exception. The volume term is positive by construction. And W_∞ is negative *for this window*: ψ̃(r) < 0 on |r| ≲ 7 and positive beyond, and the σ = 0.15 Gaussian carries most of its mass inside that range. **That last sign is measured, not a theorem** — a much wider window would weight ψ̃'s positive tail more, and nothing here says where it turns. So, at σ = 0.15,
>
> ```
> E(v) = volume(v) + W_∞(v) + Σ_p W_p(v),
>        volume > 0,   W_∞ < 0,   every W_p < 0                              (16)
> ```
>
> and the Weil criterion — RH ⟺ E is positive-definite ([positivity-generator.md](../../xi-horn/positivity-generator.md) §3) — is, adelically, the statement that **one positive term coming from the pole survives the subtraction of every place.**

## Hypotheses and notation

- G is the inverse transform of Φ̂² for the Gaussian window φ(u) = e^{−u²/2σ²} at σ = 0.15; g in (13) is the translated window, so the finite-place term is a sum of positive values of G, with the minus sign in front.
- (13): W_p(g) = −log p·Σ_{k≥1} p^{−k/2}[g(k log p) + g(−k log p)].
- The volume term is the two pole terms h(±i/2) (§4.1: "the residues of the global zeta integral at s = 0 and s = 1 ... a single positive **volume term**").
- §8 lists "sign of W_p, first 2000 places, v = 0, 5, 10 | negative without exception".

## Proof / evidence

The finite-place negativity is derived: G > 0 (a Gaussian) and (13) is minus a sum of non-negative terms, so W_p < 0; the source additionally checked the first 2000 places at v = 0, 5, 10 ("all strictly negative, without exception"). The W_∞ sign is explicitly labelled by the source as measured, not a theorem, for this window.

## Dependencies and related results

- [The local Weil term at a finite place](xihorn-horn-helix-adelic-local-weil-term-finite-place.md) (13) is the identity used.
- [The per-place ledger](xihorn-horn-helix-adelic-per-place-ledger-to-21-digits.md) supplies the running totals.
- positivity-generator.md §3 (RH ⟺ E positive-definite) is the criterion invoked.

## Notes

- Only the finite places' sign is proved; the archimedean sign is measured for σ = 0.15 and "nothing here says where it turns" for wider windows. The source says so in bold.
- The honest reading recorded in §4.5: "the arithmetic is not 'almost' cancelling the pole, it is cancelling it to four parts in 10⁴ and the residue is the entire content. No place is negligible and no finite set of places is sufficient."
- §6 repeats the shape: "RH ⟺ the volume term dominates the sum over every place, for every window and every translate."
