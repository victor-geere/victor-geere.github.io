# Theorem 7 (unimodality)

**Kind:** Theorem
**Status:** PROVED (paper argument; VERIFIED over nine exponents)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh42/truths.md`](../../research/twin-prime-parity/rounds/rh42/truths.md) — §3 "The exact reachable set: Brown's criterion"

## Statement

> For the positive half put
> `h(n) = Σ_{k>n} k^{−p} − n^{−p}`. Then
>
> ```
> h(n+1) − h(n) = n^{−p} − 2(n+1)^{−p},
> ```
>
> which is `> 0` iff `(1 + 1/n)^p < 2`, i.e. iff `n` is below the single value
> `1/(2^{1/p} − 1)`; and `h(n) → 0⁺` with `h(n) ~ n^{−p}(n/(p−1) − 1) > 0` for
> `n > p − 1`. So `h` rises then falls to `0`, and
>
> ```
> {n : h(n) < 0} = {1, 2, …, n_min(p) − 1}
> ```
>
> is an **initial segment**, with `n_min(p)` the first complete tail.

## Hypotheses and notation

- `p` is the exponent of the alphabet/`p`-series (the positive half of the budgets).
- `h(n) = Σ_{k>n} k^{−p} − n^{−p}` — the "positive half" defect function (tail sum minus the term `n^{−p}`).
- `n_min(p)` — the first index at which the positive tail is complete (see Theorem 8).
- `h(n) → 0⁺` means `h(n)` decreases to `0` from positive values; `n > p − 1` is the range in which the stated asymptotic has the displayed sign.

## Proof / evidence

> **PROVED** (the difference formula and the `n → ∞` asymptotics are elementary;
> the sign change count is one), **VERIFIED** over nine exponents in
> [`reachable.py`](../../research/twin-prime-parity/rounds/rh42/reachable.py) §1.

## Dependencies and related results

- Feeds Theorem 8 (the condition at `n = 1` is the binding one) and Theorem 11 (greedy optimality, the case `h(n) > 0`).
- Source comments (§4, Theorem 11): "It is Theorem 7 that rescues the `p`-series", in contrast with the general failure of greedy optimality (R4).

## Notes

- The source gives the sign-change count as the only non-elementary ingredient ("the sign change count is one").
- The set `{n : h(n) < 0}` being an initial segment is the stated consequence; `n_min(p)` is "the first complete tail".
