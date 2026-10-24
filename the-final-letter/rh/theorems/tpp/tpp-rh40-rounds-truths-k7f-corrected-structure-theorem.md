# K7f — the corrected structure theorem for α_n = (n+2)^{−p}, x = 1, p &gt; 1

**Kind:** Claim
**Status:** PROVED (paper argument: the third case because `r>0` is fixed while `α_k → 0`, so `{k : α_k ≤ r}` is an infinite tail and the residual never reaches 0)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/rounds/truths.md`](../../research/twin-prime-parity/rounds/rh40/rounds/truths.md) — §K "Open problems, ranked", register row K7f

## Statement

> **Corrected structure theorem** for `α_n=(n+2)^{−p}`, `x=1`, `p>1`, `S=ζ(p)−1`: `S<1` → `1^∞`, all gaps 1, never halts; `S=1` → `1^∞`; `S>1` (`1<p≤p*`) → **never halts**, unbounded gaps

## Hypotheses and notation

- Alphabet `α_n = (n+2)^{−p}`, unit target `x = 1`, exponent `p > 1`; `S = ζ(p) − 1 = Σ_{n≥0} α_n`.
- `1^∞` denotes the word taking every index (all gaps 1); `p*` is the root of `ζ(p) = 2` (register row K7a).

## Proof / evidence

Register row K7f's state cell reads: "**`PROVED`** — the third case because `r>0` is fixed while `α_k → 0`, so `{k : α_k ≤ r}` is an infinite tail and the residual never reaches 0"; its evidence cell reads: "§5.3" (`K_remaining.md`).

## Dependencies and related results

- [The corrected structure theorem (power family)](tpp-rh40-k-remaining-structure-theorem.md).
- Register rows K7a (the threshold), K7b (the refuted witness it corrects), K7d (the verified case split), K7e.

## Notes

- The theorem corrects the claim of row K7b: `N(p)` ends the initial segment, and the residual keeps selecting a tail, so the orbit never halts for `1 < p ≤ p*`.
