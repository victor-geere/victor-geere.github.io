# §1.4 — prefix agreement does not determine the correlation asymptotic

**Kind:** Theorem
**Status:** PROVED (Lean, `slice_agree`, `corrSlice_eq_corr_of_lt`) + VERIFIED (numerically to the strongest form, auditor A1, `10⁸` prefixes)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh46/README.md`](../../research/twin-prime-parity/rounds/rh46/README.md) — §1.4 "A finite prefix does **not** determine the asymptotic (PROVED in Lean)" and §5 claim table

## Statement

> This is the round's logical core.  Let `λ^{(a)}` be `λ` with the sign flipped at the
> single index `a`:
>
> ```
> λ^{(a)}(n) = −λ(n)  if n = a,     λ^{(a)}(n) = λ(n)  otherwise.
> ```
>
> Then, for every `N + h < a`,
>
> ```
> Σ_{n≤N} λ^{(a)}(n) λ^{(a)}(n+h)  =  Σ_{n≤N} λ(n) λ(n+h)
> ```
>
> — the two functions **agree on every prefix shorter than `a`**, so no computation
> whatever, at any finite `x < a`, can distinguish them — while their correlation sums
> differ from index `a` onward (each sum acquires a different sign-flip contribution).
> The prefix data therefore cannot decide the asymptotic.

The §5 claim table states it as: "prefix agreement does not determine the correlation asymptotic | **PROVED** (Lean: `slice_agree`, `corrSlice_eq_corr_of_lt`) + **VERIFIED** numerically to the strongest form (auditor A1, `10⁸` prefixes)".

## Hypotheses and notation

- `λ^{(a)}`: `λ` with the sign flipped at the single index `a`.
- The prefix identity holds for every `N + h < a`.
- `S(x) = Σ_{n≤x}λ(n)λ(n+2)` is the `h = 2` case; `h` is a fixed shift.
- Auditor A1's witness: `λ''` agrees with `λ` on *all* of `[1, 10⁸]` and equals `1` beyond.

## Proof / evidence

The strongest form, quoted from §1.4: "**The strongest form of the gap** (auditor, check A1): define `λ''` to agree with `λ` on *all* of `[1, 10⁸]` and to equal `1` beyond; then `S''(x) = S(x)` **exactly for every `x ≤ 10⁸ − 2`** (0 of 99 999 998 prefixes differ) yet `S''(x)/x → 1`. So the entire computed dataset is equally consistent with `S(x) = o(x)` and with `S(x) = Θ(x)`: a finite check can **refute** but never **prove** the statement."

The Lean slice layer named in §4: `slice_agree`, `corrSlice_eq_corr_of_lt`, `corrSliceSqSub`.

## Dependencies and related results

- Uses the two-point correlation definitions and the `λ^{(a)}` construction above.
- The dictionary records the same theorem as "F4 finite-prefix indeterminacy" and as the programme's "one clean new theorem" (identical statement, different source file).
- The companion sparse-modification claim (auditor's refinement, §1.4) is recorded separately; the harvest reads it against the correction table of the top-level programme README (see that entry's Notes).

## Notes

- This entry restates the "finite-prefix indeterminacy" theorem also recorded in the dictionary and in the top-level programme README ("**The one clean theorem** the programme produced for the parity side is the **finite-prefix indeterminacy**: two functions agreeing on `[1,10⁸]` can have `S''(x)/x → 1` while the true `S(x)/x` is believed to vanish — so no computation can decide `o(x)`.").
- Status is the source's own combination: `PROVED` for the Lean layer plus `VERIFIED` for the `10⁸` numerical strongest form (the A1 check is finite, so it verifies the agreement count only).
- Exact figures: `0 of 99 999 998 prefixes differ`, `x ≤ 10⁸ − 2`.
