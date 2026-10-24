# The three claims to take away

> Source: [`research/twin-prime-parity/README.md`](../rh/research/twin-prime-parity/README.md).

## The three claims to take away

1. **The goal is not reachable by this programme as it stands**, and the reason is
   structural rather than a lack of effort: every greedy-sine object is *sign-blind*
   and carries no arithmetic input ([`00`](../rh/research/twin-prime-parity/dictionary/00-dictionary.md) F9).
2. **The one clean theorem** the programme produced for the parity side is the
   **finite-prefix indeterminacy**: two functions agreeing on `[1,10⁸]` can have
   `S''(x)/x → 1` while the true `S(x)/x` is believed to vanish — so no computation
   can decide `o(x)`.  Certified in Lean (`rh46/lean/Rh46/Chowla.lean`).
3. **What would count as progress** is a *new obstruction* (a proof that no sign-blind
   `log n`-rule can force a multiplicative correlation) — that is R2 in
   [`open/07-open-problems.md`](../rh/research/twin-prime-parity/open/07-open-problems.md), and it is **open**.
