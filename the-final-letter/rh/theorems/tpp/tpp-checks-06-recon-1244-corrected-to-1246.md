# The recon value `S(10^7) = 1244` is wrong; the correct value is `1246`

**Kind:** Claim
**Status:** CHECKED (exhaustive finite — three independent `λ` algorithms give `1246`; the `1244` differs by a final-block boundary slip)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/checks/06-numerical-checks.md`](../../research/twin-prime-parity/checks/06-numerical-checks.md) — *Corrections and discrepancies*, item 1 (lines 748–757)

## Statement

> **`S(10^7) = 1244` → `1246`.** The main agent's reconnaissance printed `1244`; the auditor's **three independent `λ` algorithms** give `1246` (`rh46/verify/independent_check.log` check `S2.crosscheck`, the run's only FAIL; `rh46/README.md` §1.2). The difference is a **final-block boundary slip** in the reconnaissance streaming: `1244 = Σ_{n≤x−2}` (it drops `n=10^7−1, 10^7`, whose products are both `+1`). No single convention reproduces the recon row (`Σ_{n≤x}` matches 4/5 rows, `Σ_{n≤x−2}` only 2/5). **`1246` is correct.** The reconnaissance script itself is not preserved in `rh46/verify/`; the `1244` survives only as `RECON_S` in `independent_check.py` and as the README's correction note.

## Hypotheses and notation

- `S(x) = Σ_{n≤x} λ(n)λ(n+2)` with `λ(n) = (−1)^{Ω(n)}`, exact on every `n`.
- `Σ_{n≤x}` vs `Σ_{n≤x−2}` are the two possible conventions for the final block in the streaming implementation.
- The value `1246` is also the `10^7` entry of the register's `S(x)` table (`§ rh46`, "Headline numbers").

## Proof / evidence

- `rh46/verify/independent_check.py` → `rh46/verify/independent_check.log` (**`FINAL: 25/26 checks pass`**; the single FAIL is this reconnaissance cross-check). The auditor implements "three unrelated `λ` algorithms — a segmented trial-division sieve, an additive prime-power sieve (`Ω = Σ_{p^k|n} 1`), and pure-Python factorization — and cross-checks them exactly (`0` mismatches on `[1,10^8+2]` for the first two, spot checks at `10^7`, `10^8` for the third)".
- The declared difference is a boundary slip: dropping `n=10^7−1, 10^7` (both products `+1`) gives exactly `1244 = Σ_{n≤x−2}`.
- The repro run `rh46/verify/chowla_two_point.repro1.log` ("**`30 checks pass, 0 fail`**, wall 264.1 s") agrees "on every `S` value across the whole `10^9` ladder" with the main log.

## Dependencies and related results

- The `S(x)` table of § rh46 of the same register (`10^7 → 1246`) and the argmaxima there (`max|S| = 3059` at `x = 8572105`).
- `OP-1` of [`07-open-problems.md`](../../research/twin-prime-parity/open/07-open-problems.md).

## Notes

- The register's *Cross-checking* table records the related row "rh46 `S(10^9)`" as reproduced by "two bit-identical reruns of the full ladder".
- The reconnaissance script is not preserved, so the wrong value cannot be re-run; the register says the `1244` "survives only as `RECON_S` in `independent_check.py` and as the README's correction note".
