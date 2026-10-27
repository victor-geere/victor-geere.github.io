# §1.1 — the trivial two-point bounds `|S(x,h)| ≤ x`, `S(x,0) = x`

**Kind:** Theorem
**Status:** PROVED (Lean, `Rh46/Chowla.lean`: `corr_abs_le`, `corr_zero`)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh46/README.md`](../../research/twin-prime-parity/rounds/rh46/README.md) — §1.1 "The trivial bound (PROVED in Lean, `Rh46/Chowla.lean`)" and §5 claim table

## Statement

> ```
> |S(x,h)| ≤ x        for every h, x    (each of the x summands lies in {−1,+1})
> S(x,0) = x          (λ(n)² = 1)
> ```

The §5 claim table states the same row as: "`|Σ_{n≤x}λ(n)λ(n+2)| ≤ x`; `Σ λ(n)λ(n) = x` | **PROVED** (Lean: `corr_abs_le`, `corr_zero`)".

## Hypotheses and notation

- `λ(n) = (−1)^{Ω(n)}` the Liouville function, `Ω` counted with multiplicity.
- `S(x,h) = Σ_{n≤x} λ(n) λ(n+h)` is the two-point correlation sum (the round writes `S(x) = Σ_{n≤x}λ(n)λ(n+2)` for `h = 2`).
- Each summand `λ(n)λ(n+h)` lies in `{−1,+1}`; `x` is the number of summands.

## Proof / evidence

> The second line is the sharpness witness: for the (completely multiplicative,
> bounded) function `λ ≡ 1` the correlation is exactly `x`, so `o(x)` is **not** a
> formal consequence of multiplicativity plus boundedness.

Lean evidence: the §5 table names `corr_abs_le`, `corr_zero`; §4 names them again among the 38 theorems of `lean/Rh46/Chowla.lean` ("**CERTIFIED** — 456 lines, **38 theorems**, 7 definitions, `./check.sh --all` **exit 0**, no `sorry`/`admit`/`axiom`/`native_decide` (independently rebuilt by the main agent)").

## Dependencies and related results

- Uses `liouville_abs_le_one` (`|λ| ≤ 1`) and `liouville_sq` (`λ(n)² = 1`) from the same Lean file.
- Companion of the sharpness witness `corrAsymptotic_zero_false` (harvested separately): the correlation of `λ ≡ 1` is exactly `x`.
- Restates the dictionary's "F1 trivial bound" row; the same two bounds appear in the round's HANDOFF and in the dictionary's finite-prefix discussion.

## Notes

- `x` in `|S(x,h)| ≤ x` is the count of summands from `1` to `x`; the §5 row writes the `h = 2` instance.
- The source's parenthetical "(each of the x summands lies in {−1,+1})" is the whole proof sketch given for the first line; the second uses `λ(n)² = 1`.
