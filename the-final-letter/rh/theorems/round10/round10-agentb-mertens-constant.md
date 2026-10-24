# (A)8 M = γ + Σ_p [log(1−1/p) + 1/p]: the Mertens constant and M − γ = −0.3157184521

**Kind:** Theorem
**Status:** CITED (literature, Mertens; verified numerically)
**Area:** workspace
**Source:** [`round10_agentB.md`](../../research/various/round10_agentB.md) — §(A) "CLOSING VERDICT", standing item 8, lines 23–24, and §(3) "CONSTANTS", lines 57–60

## Statement

> 8. M - gamma = -0.3157184521 is exact via M = gamma + sum_p[log(1-1/p)+1/p]; it is a
>    prime-indexed object and has no counterpart in a construction with no primes.
>
> M = 0.2614972128 = gamma + sum_p[log(1-1/p)+1/p]: exact (Mertens), verified.
> M - gamma = -0.3157184521. It is meaningful for the primes and has NO counterpart here: the
> greedy construction contains no primes, and the cancellation in log(1-1/p)+1/p is a prime-specific
> fact. It is a coincidence of two unrelated rearrangements.

## Hypotheses and notation

- M is the Meissel–Mertens constant, quoted as M = 0.2614972128; γ = 0.5772156649015329 is the Euler–Mascheroni constant.
- The sum runs over primes p: Σ_p [log(1 − 1/p) + 1/p].
- M − γ = −0.3157184521 is the quoted difference.

## Proof / evidence

The source states the Mertens identity M = γ + Σ_p [log(1 − 1/p) + 1/p] as exact and marks it
"verified" numerically, with the quoted value M = 0.2614972128 and difference M − γ = −0.3157184521.
It adds that the object is prime-indexed and has no counterpart in the prime-free greedy construction.

## Dependencies and related results

- [round10-agentb-harmonic-asymptotic](round10-agentb-harmonic-asymptotic.md) — the companion constant statement H_{N+2} − 1 = log N + γ − 1 + o(1).

## Notes

- Status CITED (literature): the identity is Mertens's; the workspace verified it numerically.
- The values 0.2614972128, 0.5772156649015329 and −0.3157184521 are quoted exactly as in the source.
