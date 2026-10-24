# Lemma 2.3 (the divisor identity)

**Kind:** Lemma
**Status:** PROVED (paper argument; classical identity, numerically checked in the source)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/dictionary/01-preliminaries.md`](../../research/twin-prime-parity/dictionary/01-preliminaries.md) — §2 "Arithmetic functions: the elementary facts", "Lemma 2.3 (the divisor identity)", line 43

## Statement

> **Lemma 2.3 (the divisor identity).**  `Σ_{d | n} λ(d)` equals `1` if `n` is a perfect
> square, and `0` otherwise.  Hence the Dirichlet series of `λ` is
> ```
> Σ_{n≥1} λ(n) n^{−s} = ζ(2s)/ζ(s)        (σ > 1) .
> ```

The source adds the numerical verification, verbatim:

> *Verified numerically:* `Σ_{n≤2·10⁵} λ(n)n^{−2} = 0.657973629903` against
> `ζ(4)/ζ(2) = 0.657973626739` (tail-consistent).

## Hypotheses and notation

- `λ` is the Liouville function, `Ω` counts prime factors with multiplicity, `d | n` means `d` divides `n`.
- The Dirichlet series identity holds for `σ > 1` (the source's stated range).
- `ζ` is the Riemann zeta function.

## Proof / evidence

The source's proof, verbatim:

> *Proof.*  Complete multiplicativity gives the local factors
> `Σ_{k≥0} λ(p^k)p^{−ks} = Σ_k (−1)^k p^{−ks} = (1 + p^{−s})^{−1}`; multiplying over `p`
> gives `Π_p(1+p^{−s})^{−1} = Π_p(1−p^{−s})/(1−p^{−2s}) = ζ(2s)/ζ(s)`.  ∎

The source's status and provenance line, verbatim:

> *Status:* THEOREM.  *Source:* classical; used in rh46 §5 and [`03`](../../research/twin-prime-parity/dictionary/03-parity-problem.md).

## Dependencies and related results

- Complete multiplicativity: [Lemma 2.1 (multiplicativity)](tpp-dict-01-liouville-completely-multiplicative.md).
- The same Dirichlet-series identity is quoted in the proof of [Lemma 2.4 (the one-point average)](tpp-dict-01-one-point-liouville-average.md) and restated in the sibling chapter [`03-parity-problem.md`](../../research/twin-prime-parity/dictionary/03-parity-problem.md).

## Notes

- The source marks this as **classical** and identifies itself as a restatement used by round **rh46**.
- The numerical line is a finite check at `n ≤ 2·10⁵` at `s = 2`; the source calls it "tail-consistent", not a proof.
