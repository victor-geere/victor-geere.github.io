# UNVERIFIED 2.3 (the truncated case — the slogan cannot be taken literally)

**Kind:** Claim
**Status:** OPEN (source label: **UNVERIFIED**; the literal identity is not a theorem of the standard theory here)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/dictionary/03-parity-problem.md`](../../research/twin-prime-parity/dictionary/03-parity-problem.md) — §2.2

## Statement

> **UNVERIFIED 2.3 (the truncated case — the slogan cannot be taken literally).** The extension of 2.2 to Selberg weights *truncated at a level* `D = x^θ` with `θ < 1` is **not** derived by the argument of 2.2, because the truncation destroys periodicity. Concretely, for `w(n) = (Σ_{d | (n,P(z)), d ≤ D} λ_d)²` one has the exact expansion

```
Σ_{n≤x} w(n) λ(n) = Σ_{d,e ≤ D} λ_d λ_e λ([d,e]) Σ_{m ≤ x/[d,e]} λ(m) ,
```

> using complete multiplicativity of `λ` and `Σ_{n≤x, q|n} λ(n) = λ(q) Σ_{m≤x/q} λ(m)`. Since `Σ_{m≤y} λ(m) = o(y)` is a *theorem* (PNT), one is tempted to conclude that the right side is `o(x · Σ_{d,e ≤ D} |λ_d λ_e|/[d,e])`. But the object that must be compared against is the *sieve's own* main term, whose size is `x · Σ_{d,e≤D} λ_d λ_e/[d,e] ≈ x Π_{p≤z}(1 − 1/p) ≈ x e^{−γ}/log z` (the Selberg weights are chosen to make this small), whereas the absolute-value sum `Σ_{d,e≤D} |λ_d λ_e|/[d,e]` can be of size `≈ (log D)²` for admissible `λ_d`. So the PNT input alone loses a factor `(log D)² log z`; genuine cancellation in `Σ_{n≤x}w(n)λ(n)` is required, and that cancellation is **precisely of parity difficulty**.

The file's status line: *Status:* **UNVERIFIED.** The literal identity is *not* a theorem of the standard theory for truncated weights with `z → ∞`; the present file could not confirm it in the literature, and it does not follow from PNT + Siegel–Walfisz alone. **Any use of the slogan as a literal identity should be replaced by 2.1 (the no-go theorem) or by 2.2 (the small-prime theorem).**

## Hypotheses and notation

- A **Selberg weight** is `w(n) = (Σ_{d | (n, P(z)), d ≤ D} λ_d)² ≥ 0` for real `λ_d` with `λ_1 = 1`, truncated at the **level of distribution** `D = x^θ` (Definition 1.10).
- `[d, e]` is the least common multiple of `d` and `e`; `(n, P(z))` is the gcd of `n` with `P(z) = Π_{p ≤ z, p ∈ 𝒫} p`.
- `θ < 1`; the truncation `d ≤ D` is what makes the weight non-periodic (Definition 1.10).
- `γ` is the Euler–Mascheroni constant; `e^{−γ}/log z` is the size of the sieve's main term.

## Proof / evidence

- The source gives the exact algebraic expansion above but states explicitly that the required cancellation is not available: PNT alone loses a factor `(log D)² log z`, and the missing cancellation "is **precisely of parity difficulty**".
- The file marks the status **UNVERIFIED** and says it could not confirm the literal identity in the literature.
- The source also records a programme note: `rh43/truths.md` §8.5 states the slogan in the methodological reading; this file records the distinction so that the slogan is not re-proposed as a literal identity.

## Dependencies and related results

- Definition 1.10 (Brun / Selberg weights, level of distribution); [`THEOREM 2.2`](tpp-dict-03-periodic-weight-liouville.md) is the periodic case it fails to extend; [`THEOREM 2.1`](tpp-dict-03-selberg-parity-principle.md) is the correct replacement no-go statement.
- §4.2 OPEN 4.3 (no `O(x/(log x)^A)` bound known) is the open shadow of this difficulty.
- Restated in the §7 ledger row "2.3".

## Notes

- **Status mapping:** the source's own label is **UNVERIFIED**, which is not one of the SPEC status terms; the closest term is OPEN (no proof known), and the qualifier records the source's label exactly. The statement must not be read as a proved impossibility: the source's first clause is a fact about why the proof of 2.2 does not transfer, and its second clause is that the literal identity was not confirmed.
- The source's instruction is reproduced: **"Any use of the slogan as a literal identity should be replaced by 2.1 (the no-go theorem) or by 2.2 (the small-prime theorem)."**
