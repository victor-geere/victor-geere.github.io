# M = γ + Σ_p[log(1 − 1/p) + 1/p]

**Kind:** Theorem
**Status:** CITED (literature — Mertens/Euler-constant relation; verified numerically to X = 10⁶)
**Area:** workspace
**Source:** [`research-journal.md`](../../research-journal.md) — Round 8, line 578; "The corrected results about the digit word itself", line 630; Round 10 table, line 686

## Statement

> **The constants, settled against my own Round 8 question.** M and γ are related exactly: **M = γ + Σ_p[log(1 − 1/p) + 1/p]**, verified to X = 10⁶ (γ + correction = 0.2614972467 against M = 0.2614972128). So M − γ = −0.3157184521 is precisely the prime-indexed correction, and the correct answer to my question is that **the difference has no meaning in this construction, because the construction contains no primes.** That is the sharpest statement of the absence.

Round 10 certification:

> M − γ = −0.3157184521 is exactly prime-indexed, with no counterpart here — M = γ + Σ_p[log(1−1/p)+1/p] verified to X = 10⁶.

## Hypotheses and notation

- M is the Meissel–Mertens constant; γ is the Euler–Mascheroni constant; the sum runs over primes p.
- γ + Σ_{p≤X}[log(1 − 1/p) + 1/p] is the X-truncated form; the source evaluated it to X = 10⁶.
- M − γ = −0.3157184521.

## Proof / evidence

The relation is stated as exact and verified numerically: γ + Σ_p[log(1 − 1/p) + 1/p] evaluated to X = 10⁶ gives 0.2614972467 against M = 0.2614972128 (agreement to 8 digits). The source gives no proof; the identity is classical.

## Dependencies and related results

- [The frequency/amplitude dictionary of the explicit formula](research-journal-frequency-amplitude-dictionary.md) — the only place primes enter the dialogue, and the reason the constant has "no counterpart here".
- [The local-factor dichotomy: Euler factors perturb the identity, greedy factors perturb zero](research-journal-local-factor-dichotomy.md) — the prime-indexed local factors behind the correction.

## Notes

- The status is CITED (literature): this is the standard Meissel–Mertens relation, used as a rung for the journal's "sharpest statement of the absence." The journal's own contribution is the numerical verification and the interpretation: "M − γ … **has no counterpart here precisely because there are no primes here.**"
- The *sign* of the difference in the source is M − γ = −0.3157184521, i.e. M < γ, consistent with each prime correction log(1 − 1/p) + 1/p being negative.
