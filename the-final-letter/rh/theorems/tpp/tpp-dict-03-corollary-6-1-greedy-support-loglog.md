# Corollary 6.1 (why the greedy support is quantitatively useless here)

**Kind:** Corollary
**Status:** PROVED (paper argument, combining row T18 and row F5)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/dictionary/03-parity-problem.md`](../../research/twin-prime-parity/dictionary/03-parity-problem.md) — §6

## Statement

> **Corollary 6.1 (why the greedy support is quantitatively useless here).** By T18 the greedy support satisfies `m_{i+1} ≥ m_i(m_i−1)+1`, hence `#{m ≤ x+2 : m ∈ A} = O(log log x)`. By F5 the support therefore moves `S(x)` by at most `4·O(log log x) = O(log log x) = o(x)`. The greedy support **cannot** be the positive-density witness that F5 shows is necessary.

The file's status line: *Status:* THEOREM (combining T18 and F5); *source:* `rh47/HANDOFF.md` §3 (H4), `rh47/truths.md` §4.

## Hypotheses and notation

- `A` is the greedy support (the support of the signed greedy support of [`02-greedy-harmonic-sine.md`](../../research/twin-prime-parity/dictionary/02-greedy-harmonic-sine.md) Theorem 2.3).
- `m_i` are the elements of the greedy support, Sylvester-sparse: `m_{i+1} ≥ m_i(m_i−1)+1`, so `A(N) = O(log log N)` (row **T18**, [row T18](tpp-dict-03-t18-greedy-sylvester-sparse.md)).
- `S(x) := Σ_{n≤x} λ(n) λ(n+2)`; **F5** is the corrected sparse-modification bound `|S_A(x) − S(x)| ≤ 2·#{n ≤ x : n ∈ A or n+2 ∈ A} ≤ 4·#{m ≤ x+2 : m ∈ A}` ([F5](tpp-dict-03-f5-corrected-sparse-bound.md)).
- "Positive-density witness" is the object F5 shows is necessary to move `S(x)` by a non-`o(x)` amount.

## Proof / evidence

- The source's proof is the two-step computation: T18 gives `#{m ≤ x+2 : m ∈ A} = O(log log x)`; F5 gives `|S_A(x) − S(x)| ≤ 4·O(log log x) = O(log log x) = o(x)`. Hence the greedy support cannot be a positive-density witness.
- Sources: `rh47/HANDOFF.md` §3 (H4); `rh47/truths.md` §4. F5 is prose-only ("**not** yet machine-checked — registered as OP-12"), so this corollary inherits that hedge.

## Dependencies and related results

- [Row T18](tpp-dict-03-t18-greedy-sylvester-sparse.md); [F5](tpp-dict-03-f5-corrected-sparse-bound.md); [F6](tpp-dict-03-f6-no-signal-greedy-support.md) (the numerical no-signal companion).
- The `02-greedy-harmonic-sine.md` Theorem 2.3 (the signed greedy support and the parity lock).
- Restated in the §7 ledger row "6.1".

## Notes

- The source calls it a Corollary but records its status as "THEOREM (combining T18 and F5)"; the Kind is Corollary, matching the source's own label "Corollary 6.1".
- Because F5 is not yet machine-checked, this corollary is not machine-checked either; the source's OP-12 hedge consequently applies to it.
