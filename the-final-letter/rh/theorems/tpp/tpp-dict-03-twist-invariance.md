# THEOREM 5.5 (the twist-invariance identity, `F7`; why index parity is irrelevant)

**Kind:** Theorem
**Status:** PROVED (paper argument, elementary; VERIFIED numerical, 0 mismatches in `10⁶` terms)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/dictionary/03-parity-problem.md`](../../research/twin-prime-parity/dictionary/03-parity-problem.md) — §5.4

## Statement

> **THEOREM 5.5 (the twist-invariance identity, `F7`; why index parity is irrelevant).** For every `x`,

```
Σ_{n≤x} λ(n)(−1)^n · λ(n+2)(−1)^{n+2} = Σ_{n≤x} λ(n) λ(n+2) ,
```

> because `(−1)^n (−1)^{n+2} = 1`. Hence multiplying `λ` by the index-parity character leaves the two-point correlation **identically** unchanged: knowledge of index parity would say nothing about `S(x)`.

The file's status line: *Status:* THEOREM (elementary); VERIFIED numerically (0 mismatches in `10⁶` terms), `rh47/truths.md` §2 (B2).

## Hypotheses and notation

- `λ` is the Liouville function (Definition 1.2); `(−1)^n` is the **index-parity** character; `S(x) := Σ_{n≤x} λ(n) λ(n+2)`.
- The identity holds for **every** `x` (identically in `x`, not merely asymptotically), because `(−1)^n (−1)^{n+2} = (−1)^{2n+2} = 1`.

## Proof / evidence

- The source gives the one-line proof: `(−1)^n (−1)^{n+2} = 1`.
- Numerically verified: "0 mismatches in `10⁶` terms", `rh47/truths.md` §2 (B2).

## Dependencies and related results

- This is the theorem-level content of barrier row **F7** and bridge **B2**: see [F7](tpp-dict-03-f7-index-parity-invisible.md) and §5.4 (B2).
- It is the reason the `ζ`-budget/index-parity bridge B2 fails as a route to `Ω`-parity: see the §5.4 bridge table and §6 row F7.
- Restated in the §7 ledger row "5.5".

## Notes

- The identity is **exact for every `x`**, so it cannot be weakened to an asymptotic statement; the parenthetical "for every `x`" in the source is preserved.
- The numerical verification is recorded exactly as the source gives it (0 mismatches in `10⁶` terms); it is corroboration of an elementary identity, not the proof.
