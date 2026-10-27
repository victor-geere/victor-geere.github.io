# Theorem 2 (initial segment)

**Kind:** Theorem
**Status:** PROVED (paper argument, from the cited [O'S] Jensen criterion and closure of LP under differentiation)
**Area:** xi-horn
**Source:** [`xi-horn/gorz-gap.md`](../../xi-horn/gorz-gap.md) — §3 "The three theorems", Theorem 2 (equation (8))

## Statement

> **Theorem 2 (initial segment).** Define
>
> ```
> ν := min{ n ≥ 0 : F^{(n)} ∈ LP }   ∈  {0, 1, 2, …} ∪ {∞}                    (8)
> ```
>
> Then `E_∞ = { n : 0 ≤ n < ν }`.

## Hypotheses and notation

- F(z) = Σ_{n≥0} a(n)·z^n/n! = Ξ(√−z), real entire of order ½ and of genus 0, hence of Pólya's class "genus 1\*" (§1.1); LP is the Laguerre–Pólya class, the real entire functions of genus 1\* with only real zeros, equivalently the locally uniform limits of real-rooted real polynomials (§1.2).
- E_∞ := ∪_{d≥1} E(d), the exceptional shifts (§1.3).
- The Jensen criterion used is the cited **[O'S] Corollary 3.2** ([harvested here](xihorn-gorz-gap-osullivan-cor32-jensen-criterion.md)): F^{(n)}(z) is hyperbolic if and only if J_{d,n}(z) is hyperbolic for all d ≥ 1.

## Proof / evidence

The source's proof, verbatim: "By the Jensen criterion ([O'S] Cor 3.2, legitimate since every F^{(n)} is real entire of order ½), n ∉ E_∞ ⟺ J_{d,n} hyperbolic for all d ⟺ F^{(n)} ∈ LP. LP is closed under differentiation, so F^{(n)} ∈ LP implies F^{(n+1)} ∈ LP: the set {n : F^{(n)} ∈ LP} is upward closed, its complement E_∞ is downward closed, and ν is by definition its first non-element. ∎"

The source adds: "(The differentiation step, read through L1, is [O'S] Corollary 3.3: 'If ξ^{(n)}(z) is hyperbolic then ξ^{(m)}(z) is also hyperbolic for all m ≥ n.')"

## Dependencies and related results

- Cited [O'S] Corollary 3.2 (Jensen criterion); [Lemma L1](xihorn-gorz-gap-l1-derivative-ladder.md) for the differentiation step.
- Feeds [Theorem 3 (the uniformity constant)](xihorn-gorz-gap-t3-uniformity-constant.md) and [Corollary 4 (the wedge is flat)](xihorn-gorz-gap-c4-wedge-is-flat.md).
- The Pólya–Wiman theorem (harvested as [CITED literature](xihorn-gorz-gap-polya-wiman-theorem.md)) is what would give ν < ∞ from finitely many non-real zeros of ξ.

## Notes

- The source is explicit that this theorem does **not** say each E(d) is an initial segment: "Theorem 2 says the *union* E_∞ is an initial segment. It does **not** say each E(d) is. For a general positive sequence it need not be — with a = (1, 2, 1, 100, …), J_{2,0}(X) = 1 + 4X + X² is hyperbolic while J_{2,1}(X) = 2 + 2X + 100X² is not, so 1 ∈ E(2) and 0 ∉ E(2). Whether ξ's own E(d) are initial segments is open and is not needed for anything above."
- ν itself is not computed: "ν < ∞ is not proved here, and could not be: it is a statement about ζ" (§ opening). The source's table lists "ν < ∞ | open — implied by 'finitely many off-line zeros'" and "ν = 0 | open — this is RH".
