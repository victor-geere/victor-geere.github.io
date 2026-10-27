# SS4 — finite-prefix indeterminacy (the round's real logical result)

**Kind:** Theorem *(so classified by the source: "the round's real logical result"; the register's companion ledger calls it the certified finite-prefix theorem)*
**Status:** VERIFIED (numerical — exact construction, verified on 99 999 998 prefixes; the register states it is the round's real logical result, and the Lean slice layer is named elsewhere in the programme)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/checks/06-numerical-checks.md`](../../research/twin-prime-parity/checks/06-numerical-checks.md) — § rh46, "Headline numbers" SS4 (lines 535–547) and "What it establishes" (lines 560–570)

## Statement

> SS4 (the logical core). With `X = 10^4`, `A± = {n > X+2 : 4|n, f(n)=f(n−2)=∓1}` where `f(n)=λ(n)λ(n+2)`, and `λ± = −λ` on `A±`:
>
> * `λ, λ+, λ−` agree on **every** `n ≤ 10^4` (`0` differences; first flip index `10012`), and `S(x)=S+(x)=S−(x)` for every `x ≤ 10^4`;
> * the identity `S±(x) − S(x) = ±4·#{n ∈ A± : n ≤ x} ± 2ε`, `ε ∈ {0,1}`, holds **exactly** at every `x ≤ 10^7`;
> * at `x = 10^7`: `S+(x)/x = 0.25002` (density of `A+` is `0.06248`, `4× = 0.24990`), `S−(x)/x = −0.24969`, while `S(x)/x = 1.246e-4`. The naive control `A0 = {4|n, n>X}` gives `S0(x)/x = 0.000211` — **not** a witness.
> * Auditor's strongest form: `λ'' = λ` on `[1,10^8]`, `≡ 1` beyond ⇒ `S''(x)=S(x)` for all `x ≤ 10^8−2` (**0 of 99 999 998 prefixes differ**), yet `S''(10^8) = 4634` vs `S(10^8)=4632` and `S''(x)/x → 1` (`0.99999900` at `10^{12}`).

The register's own assessment:

> The **finite-prefix indeterminacy** (SS4/A1) is the round's real logical result: it is an exact construction, verified on 99 999 998 prefixes, showing that the entire computed dataset is equally consistent with `S(x)=o(x)` and with `S(x) ~ x`.

## Hypotheses and notation

- `λ` is the Liouville function, `f(n) = λ(n)λ(n+2)`, `S(x) = Σ_{n≤x} λ(n)λ(n+2)`.
- `A± = {n > X+2 : 4|n, f(n)=f(n−2)=∓1}` with `X = 10^4`; `λ±` is `λ` with signs flipped on `A±`.
- `ε ∈ {0,1}` is the boundary indicator in the exact identity `S±(x) − S(x) = ±4·#{n ∈ A± : n ≤ x} ± 2ε`.
- `λ''` agrees with `λ` on `[1,10^8]` and equals `1` beyond; `S''` is the correlation built from `λ''`.
- The method is a segmented `Ω`-sieve with `BLOCK=10^7`, int64 exact sums, `λ(n) = (−1)^{Ω(n)}` exact on every `n`; the auditor implements three unrelated `λ` algorithms and cross-checks them exactly (`0` mismatches on `[1,10^8+2]` for the first two).

## Proof / evidence

- `rh46/chowla_two_point.py` → `rh46/verify/chowla_two_point.log` (final line **`30 checks pass, 0 fail`**, wall `262.5s`), SS4 with `X = 10^4`; auditor `rh46/verify/independent_check.py` → `independent_check.log` (**`FINAL: 25/26 checks pass`**, the single FAIL being the reconnaissance cross-check), auditor A1 with `X = 10^8`.
- The register says the construction is exact: "an exact construction, verified on 99 999 998 prefixes"; the `ε`-identity "holds **exactly** at every `x ≤ 10^7`".
- The Lean slice layer named by this register is: "the finite-prefix indeterminacy Lean-certified" and "The auditor's strongest form: `λ'' = λ` on `[1,10^8]`"; the same programme's ledger records the Lean declarations `slice_agree` and `corrSlice_eq_corr_of_lt` (see the equivalent entry harvested from the dictionary source, `tpp-dict-03-f4-finite-prefix-indeterminacy.md`).

## Dependencies and related results

- The non-multiplicativity / no-Euler-product entry of the same register section (§ rh46 SS5 and rh47 B3): with no Euler product, no standard theorem derives a bound from RH.
- `(★) Σ_{n≤x}λ(n)λ(n+2) = o(x)` is **OPEN**; this construction is a theorem *about* it, not a proof of it.

## Notes

- The register's moral, quoted exactly: the computed dataset is "equally consistent with `S(x)=o(x)` and with `S(x) ~ x`". The register also says: "`(★) Σ_{n≤x}λ(n)λ(n+2) = o(x)` is **OPEN**. The script's own banner says so before any number; the `10^9` table is consistent with `(★)` and is **not evidence for it**, because SS4 constructs sequences with the same prefix and `S(x)/x → 1/4`."
- The `X=10^4` block and the `X=10^8` auditor block are two strengths of the same construction; this file keeps both as the source states them.
- The Lean layer is reported by this register from other artefacts and is not itself re-verified here.
