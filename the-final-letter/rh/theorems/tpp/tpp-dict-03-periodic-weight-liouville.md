# THEOREM 2.2 (the periodic case — the honest small-prime statement)

**Kind:** Theorem
**Status:** PROVED (paper argument; classical ingredients, proof written out in the source)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/dictionary/03-parity-problem.md`](../../research/twin-prime-parity/dictionary/03-parity-problem.md) — §2.2

## Statement

> **THEOREM 2.2 (the periodic case — the honest small-prime statement).** Let `w ≥ 0` be periodic modulo `q` (so `w` depends only on `n mod q`), with `q ≤ (log x)^A` for a fixed `A`, and suppose `Σ_{n≤x} w(n) ≫ x` (positive density). Then

```
Σ_{n≤x} w(n) λ(n) = o( Σ_{n≤x} w(n) )        as x → ∞ .
```

## Hypotheses and notation

- `w ≥ 0` is periodic modulo `q`, i.e. `w` depends only on `n mod q`.
- `q ≤ (log x)^A` for a fixed `A` (the range in which Siegel–Walfisz applies).
- Positive density: `Σ_{n≤x} w(n) ≫ x`.
- `λ` is the Liouville function (Definition 1.2); `Σ_{n≤x, n≡a (q)}` denotes the sum over `n ≤ x` in the residue class `a mod q`.

## Proof / evidence

The source gives the proof in full:

> *Proof.* Write `Σ_{n≤x}w(n)λ(n) = Σ_{a mod q} w(a) Σ_{n≤x, n≡a (q)} λ(n)`, and expand the inner sum over Dirichlet characters `χ mod q` using `Σ_n λ(n)χ(n)n^{−s} = L(2s, χ²)/L(s, χ)` (a consequence of `λ = 1_□ * μ`, §1.1). For `q ≤ (log x)^A` the Siegel–Walfisz theorem gives a zero-free region for `L(s, χ)`, and the quotient is analytic and non-vanishing at `s = 1` (for `χ` principal the quotient has a *zero* at `s = 1`; for `χ²` principal it is finite and non-zero). Wiener–Ikehara / Perron then gives `Σ_{n≤x, n≡a(q)} λ(n) = o(x/q)` uniformly. ∎

The file's status line: *Status:* THEOREM (classical; the programme uses the special cases `q = 2, 210` in rh43 §8.5 and rh47 §2). This is the precise sense in which "small-prime residue conditions cannot see the parity of `Ω`".

## Dependencies and related results

- [`THEOREM (basic)` — complete multiplicativity of `λ`](tpp-dict-03-liouville-completely-multiplicative.md) supplies `Σ_n λ(n)χ(n)n^{−s} = L(2s, χ²)/L(s, χ)` and `λ = 1_□ * μ`.
- Definition 1.11 / THEOREM 2.1: the bounded-depth class to which the parity phenomenon applies.
- Contrasted with UNVERIFIED 2.3 (the truncated case, where periodicity is destroyed) and HEURISTIC 2.4.
- Restated in the §7 ledger row "2.2".

## Notes

- The source words the status as "THEOREM (classical; …)"; the proof is written out in the file, so this harvest records PROVED (paper argument) and notes the classical ingredients (Dirichlet characters, Siegel–Walfisz, Wiener–Ikehara / Perron).
- The quantifier restriction `q ≤ (log x)^A` is essential and must not be dropped: it is exactly what fails for the truncated weights of UNVERIFIED 2.3.
