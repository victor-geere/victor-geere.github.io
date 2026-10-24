# The squaring law: r' = (1−f)r²/(1 + (1−f)r)

**Kind:** Theorem
**Status:** PROVED (paper argument; verified to every digit at 120 dps)
**Area:** workspace
**Source:** [`research-journal.md`](../../research-journal.md) — Round 7, lines 554–564; "The ten things that stand" §3, line 616; Round 10 table, line 683

## Statement

> **The squaring law — both agents derived it independently, in different algebraic forms, and both are right.** With u = 1/r, m = ⌈u⌉, f = {u}:
>
>   **r' = r − 1/m = (1−f)r²/(1 + (1−f)r)**,  hence  **c_k := r'/r² = (1−f)/(1 + (1−f)r) → 1−f as r → 0.**
>
> I verified this to every digit at every step for 1/π, log 2, √2−1 at 120 dps: r'_formula = r'_actual exactly in all cases. B's closed form for c matches the measured c to 8 digits; A's alternative form (1−{u})/(2−{u}) is algebraically the same in the limit but differs numerically at finite r (for log 2, k=2: measured c = 0.23491198, B's form 0.23491198, A's form 0.19118876) because the correct denominator carries r as well.

Final synthesis:

> **The squaring law, derived independently by both agents and verified to every digit:** r' = r − 1/⌈1/r⌉ = (1−f)r²/(1+(1−f)r) with f = {1/r}, so c_k := r_{k+1}/r_k² = (1−f)/(1+(1−f)r). There is **no universal constant** — c_k is a function of the fractional parts alone, measured in [0.03, 0.83].

## Hypotheses and notation

- r = r_k is the greedy residual; u = 1/r; m = ⌈u⌉ is the next selected index + 2; f = {u} = u − ⌊u⌋ is the fractional part.
- r' = r_{k+1} = r − 1/m; c_k = r_{k+1}/r_k².
- f ∈ [0,1); as r → 0, c_k → 1 − f.

## Proof / evidence

Both agents derived the closed form independently; the mediator verified r'_formula = r'_actual exactly at every step for 1/π, log 2, √2−1 at 120 dps, and B's closed form for c matches the measured c to 8 digits. Round 10 Correction 1 refutes Agent A's later "corrected" ratio identity r_{k+1}/r_k² = (u − f − uf + f²)/(u + 1 − f): it agrees with B's exact form only asymptotically and fails at finite r — at 1/π, k = 2 it gives 0.4378614839 against measured 0.4382657988; at √2−1, k = 0 it gives 0.3905242918 against measured 0.4714045208. B's identity matches the measurement to 10 digits at every step.

## Dependencies and related results

- [The census law: n_{k+1} = ⌈1/r_k⌉ − 2](research-journal-census-law.md) — the index-level form of the same recurrence.
- [A(N) = log₂ log N + O(1) for irrational θ/π](research-journal-digit-count-log-log-law.md) — the consequence via log u_{k+1} = 2 log u_k + log((1+A_k)/A_k).
- [The orbit average of log c_k is bounded, negative and target-dependent](research-journal-orbit-average-log-c.md) — the orbit statistics of c_k.

## Notes

- The journal calls the consequence "the sharpest result of the second sitting": there is **no universal constant**, because c_k depends only on the fractional part of 1/r_k.
- The mechanism is stated to be "the **squaring of the residual**, not the divergence of the harmonic series."
- A's scaling-limit statement E[log c_k] = ∫₀¹ log(1−f) df = −1 is "a scaling-limit statement, correctly labelled as such by him."
