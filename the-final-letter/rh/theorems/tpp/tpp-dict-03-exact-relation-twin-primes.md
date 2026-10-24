# THEOREM 5.1 (the exact relation; no implication in either direction is known)

**Kind:** Theorem
**Status:** OPEN (for parts (b), (c); part (a) is PROVED (paper argument, via THEOREM 3.5))
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/dictionary/03-parity-problem.md`](../../research/twin-prime-parity/dictionary/03-parity-problem.md) — §5.1

## Statement

> **THEOREM 5.1 (the exact relation; no implication in either direction is known.)**
> **(a)** By 3.5, `S(x) = o(x)` is *equivalent* to the equal-class density of `{n : λ(n) = λ(n+2)}` being `1/2`, and (given PNT) to each of the four pairs `(λ(n), λ(n+2))` having density `1/4`. It is therefore **incompatible** with the equal-class density being any other fixed positive number; equivalently it is *necessary and sufficient* for equidistribution of the pair.
> **(b)** `S(x) = o(x)` does **not** imply the twin prime conjecture: `λ` says nothing about primality, and under the Hardy–Littlewood heuristic the twin primes have density `~ 2C₂/log²x = o(1)` inside the class `{λ(n) = λ(n+2) = −1}`, which itself has density `1/4`.
> **(c)** The twin prime conjecture does **not** imply `S(x) = o(x)`: it constrains only the primes, and the parity of `Ω(n)` on the composites — which dominates `S(x)` — is untouched.
> **(d)** The two-point Chowla statement `S(x) = o(x)` is a **special case of the programme's target** and is itself OPEN (4.1); it is a *prerequisite-shaped* statement, not a route to twin primes.

The file's status lines: *Status of (a):* THEOREM. *Status of (b), (c):* the *non-implications* are **not** theorems in the literature — they are statements about absence of a known proof, labelled **OPEN** as formal questions, with the heuristic reading marked **HEURISTIC**.

## Hypotheses and notation

- `S(x) := Σ_{n≤x} λ(n) λ(n+2)` (OPEN 3.4); `λ` is the Liouville function (Definition 1.2); `Ω(n)` counts prime factors with multiplicity (Definition 1.1).
- `2C₂ = 𝔖(0,2) = 1.3203236316…` is the twin-prime constant (Definition 1.7).
- "Equal-class density" is the density of `{n : λ(n) = λ(n+2)}`.

## Proof / evidence

- Part (a) is [`THEOREM 3.5`](tpp-dict-03-two-point-equidistribution.md) applied to the twin-prime reading; the source marks it THEOREM.
- Parts (b) and (c) are **not** proved anywhere: the source states the non-implications "are **not** theorems in the literature — they are statements about absence of a known proof, labelled **OPEN** as formal questions, with the heuristic reading marked **HEURISTIC**".
- The source's part (b) uses the Hardy–Littlewood heuristic ([Conjecture 1.8](tpp-dict-03-hardy-littlewood-dickson-k-tuples.md)); part (d) restates OPEN 3.4 / OPEN 4.1.

## Dependencies and related results

- [`THEOREM 3.5`](tpp-dict-03-two-point-equidistribution.md) (part (a)); [`OPEN 3.4`](tpp-dict-03-two-point-chowla-open.md) / OPEN 4.1 (part (d)); [Conjecture 1.8](tpp-dict-03-hardy-littlewood-dickson-k-tuples.md) (the heuristic in (b)); [THEOREM 3.10](tpp-dict-03-log-chowla-iff-log-sarnak.md) (the "Sarnak half" of the programme correction below).
- Restated in the §7 ledger rows "5.1(a)" (THEOREM) and "5.1(b),(c)" (OPEN).

## Notes

- **Status mapping:** the source's heading labels the item THEOREM 5.1, but the source's own per-part statuses are THEOREM for (a) and OPEN/HEURISTIC for the non-implications (b), (c); the heading itself says "no implication in either direction is known". This harvest records the conservative primary term **OPEN** with the part (a) theorem stated in the qualifier, so that the status never overstates.
- **Programme correction (preserved).** `rh46/README.md` §2 asserts that "Chowla for `k`-point correlations … contradicts the twin prime conjecture's failure mode and implies the Sarnak conjecture". The Sarnak half is a THEOREM (T3). The "contradicts the twin prime conjecture's failure mode" half is **withdrawn as unverified** — it is already so marked in [`07-open-problems.md`](../../research/twin-prime-parity/open/07-open-problems.md) OP-4, and the source confirms the withdrawal.
