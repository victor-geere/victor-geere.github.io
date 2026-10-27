# F4 — finite-prefix indeterminacy

**Kind:** Theorem
**Status:** PROVED (Lean slice layer: `slice_agree`, `corrSlice_eq_corr_of_lt`; NUMERICAL, auditor A1, all `10⁸` prefixes)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/dictionary/03-parity-problem.md`](../../research/twin-prime-parity/dictionary/03-parity-problem.md) — §6, barrier table row F4

## Statement

> **F4** — **finite-prefix indeterminacy**: define `λ''` to agree with `λ` on all of `[1, 10⁸]` and to equal `1` beyond. Then `S''(x) = S(x)` **exactly for every `x ≤ 10⁸ − 2`** (0 of 99 999 998 prefixes differ), yet `S''(x)/x → 1`. So the entire computed dataset is equally consistent with `S(x) = o(x)` and with `S(x) = Θ(x)`. **A finite check can refute, never prove.** More generally, flipping a single index `a` leaves every prefix shorter than `a` untouched (`λ^{(a)}` vs `λ`).

The file's status line: THEOREM (Lean slice layer: `slice_agree`, `corrSlice_eq_corr_of_lt`) + NUMERICAL (auditor A1, all `10⁸` prefixes). Source given as `rh46` §1.4.

## Hypotheses and notation

- `λ` is the Liouville function (Definition 1.2); `S(x) := Σ_{n≤x} λ(n) λ(n+2)`; `S''` is the correlation built from the modified `λ''`.
- `λ''` agrees with `λ` on `[1, 10⁸]` and equals `1` beyond.
- `λ^{(a)}` is the function obtained by flipping the sign of `λ` at a single index `a`.
- "0 of 99 999 998 prefixes differ" refers to the comparison of `S''` and `S` over the prefixes `x ≤ 10⁸ − 2`.

## Proof / evidence

- Lean slice layer: the source names the declarations `slice_agree` and `corrSlice_eq_corr_of_lt` (Appendix B lists both among the declarations of `rh46/lean/Rh46/Chowla.lean`).
- Numerical: the source records "0 of 99 999 998 prefixes differ" in the independent auditor's check (auditor A1, all `10⁸` prefixes; `rh46/verify/independent_check.py`).
- The construction is also attributed to `rh46/chowla_two_point.py` and `rh46/verify/independent_check.py` (Appendix B).

## Dependencies and related results

- [F1](tpp-dict-03-f1-trivial-bound.md) (the trivial bound); [F2](tpp-dict-03-f2-lambda-identically-one.md) (`λ ≡ 1` has correlation `x`, which is the behaviour of `λ''` in the limit).
- [`OPEN 3.4`](tpp-dict-03-two-point-chowla-open.md) / OPEN 4.1 is the statement this row shows can never be decided by a finite check; the source says so explicitly: "it is **not** decided by any finite computation (§6, `F4`)".
- Restated in the §7 ledger row "6 (F1–F5)".

## Notes

- The source's moral is quoted exactly: "**A finite check can refute, never prove.**" The computed dataset is "equally consistent with `S(x) = o(x)` and with `S(x) = Θ(x)`."
- The programme's numerical reconnaissance (`S(10⁸)/10⁸ = 4.4·10⁻⁵`, prefix-max exponent fit `α = 0.5200 ± 0.0249`, logarithmic-average decay tables) is marked NUMERICAL evidence only, and by F4 it can never decide `o(x)`.
