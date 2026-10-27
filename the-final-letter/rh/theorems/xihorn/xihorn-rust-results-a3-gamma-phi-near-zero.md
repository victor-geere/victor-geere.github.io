# A3 — done, and the diagnosis was exactly right

**Kind:** Claim
**Status:** VERIFIED (numerical, 60 digits; the dropped tail has the closed form 4·Φ(0)·e^(V₀))
**Area:** xi-horn
**Source:** [`xi-horn/rust/RESULTS.md`](../../xi-horn/rust/RESULTS.md) — Summary, "A3 — done, and the diagnosis was exactly right"

## Statement

> **A3 — done, and the diagnosis was exactly right.** The dropped tail is
> `4·Φ(0)·e^(V₀)` in closed form. At V₀ = −16 that is **2.0108e−07**, which is
> the −2.010e−07 TODO A3 reports F(0, −γ_k²) returning instead of 0. Restoring
> it analytically removes **4.045e−07** of relative error and gives
> Γ_Φ(0) = 0.49712077818831 against ξ(½) = 0.4971207782.
>
> Two things beyond the TODO's diagnosis, both found by testing:
>
> * the tail is not the only V₀ error — the trapezoid also leaves an
>   Euler–Maclaurin **boundary** term, because at V₀ = −16 the integrand is
>   still 5e−8 rather than negligible. It scales as h² (1.3e−13 relative at
>   w = 0) and no tail correction repairs it; V₀ = −50 does.
> * the same closed form *is* CONTINUATION (22)'s pole string, so the corrected
>   evaluator continues Γ_Φ meromorphically to Re w ≤ −1 for free.

## Hypotheses and notation

- Φ is the horn's weight; Γ_Φ(w) = 4∫₀^∞ u^w Φ(u)du; F(w, ·) is the flow function of CONTINUATION §8, whose zeros at w = 0 are exactly −γ_k².
- V₀ is the lower truncation limit of the trapezoid rule; h the step.
- The closed form is stated at V₀ (dropping the (w+1) denominator, which is 1 at w = 0); the same file's driver output lists "the tail CONTINUATION §7 drops below V₀ = −16: 4·Φ(0)·e^(V₀) = 2.010764550e-7".
- Driver `bin/a3_gamma_phi`; implementation `rust/src/mellin.rs`.

## Proof / evidence

Numerical with an analytic tail: restoring the closed form makes Γ_Φ(0) = 4.971207781883141e-1 in the driver output, against the published ξ(½) = 0.4971207782 (relative error removed 4.045e-7). The boundary term is measured, not inferred: it scales as h² (1.3e−13 relative at w = 0; h = 0.004 and h = 0.002 disagree by 3.4e−19 at V₀ = −30), and "**No tail correction repairs it.** V₀ = −50 does, and that is now the default."

## Dependencies and related results

- [G3 — the pole string](xihorn-rust-results-g3-pole-string.md) — the same 1/(w + 1) pole as (22) predicts.
- [(22) — the pole string of Γ_Φ](xihorn-todo-22-pole-string-identity-refuted.md) — the identity whose displayed derivation fails while its pole data hold.
- [H1 — a(n) at n = 1000](xihorn-rust-results-h1-a1000-against-os-table-1.md) — "a(0) = 0.49712077818831410991 is ξ(½), which is A3 again from the other end".

## Notes

- **Fidelity note:** the closed form is printed in this file as `4·Φ(0)·e^(V₀)`; TODO.md's item A3 states the general form `4·Φ(0)·e^{(w+1)V₀}/(w + 1)`, which reduces to the printed one at w = 0.
- The source claims one thing only beyond the fix: the corrected evaluator "continues Γ_Φ meromorphically to Re w ≤ −1 for free" — "**but the residues it predicts are still unchecked, which is G3**".
