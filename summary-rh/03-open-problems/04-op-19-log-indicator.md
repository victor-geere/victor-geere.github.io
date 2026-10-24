# OP-19 — the log-indicator barrier

**Source:** [`research/TODO.md`](../rh/research/TODO.md) §A.1; [`research/open.md`](../rh/research/open.md) §4.
**Status:** OPEN, and well-posed. This is the explicit replacement for the inherited OP-3.

## Why OP-3 is not a proposition

The inherited R2/OP-3 says: “no sign-blind deterministic rule seeing `n` only through `log n` can force a multiplicative correlation.” It has three defects:

1. **No definitions.** “rule”, “sees” and “force” are undefined; there is no quantifier over `x`, no normalisation and no threshold.
2. **The literal reading is false.** `n ↦ log n` is injective on `ℕ`, so every `A ⊆ ℕ` is `{n : f(log n) > 1/2}` for some `f`. With `A = {n : λ(n)=1}`, `Σ_{n≤x}1_A(n)λ(n) = x/2 + o(x)` because `Σ_{n≤x}λ(n)=o(x)` is equivalent to PNT. So “depends only on `log n`” excludes nothing.
3. **The supporting sentence was withdrawn.** “Every greedy-sine object is an additive character in `log n`” is too wide: `n^{-it}` is multiplicative on `(ℝ₊,×)`, and the sums `Σ λ(n)n^{-it}` do vanish. Additivity alone neither prevents nor forces correlation.

## The repair: restrict the description, not the value

**Definition A.1 (log-arc rule).** Let `𝔽 ⊂ ℝ` be a fixed countable field (canonically `ℚ(π)`). A log-arc rule is

```
A_I = { n ≥ 1 : (log n mod 2π) ∈ I },
```

where `I ⊆ [0,2π)` is a finite union of intervals with endpoints in `𝔽` and Lebesgue measure `0 < |I| < 2π`. Equivalently `A_I = {n : f_I(log n) > 1/2}` with `f_I` the `2π`-periodic indicator of `I`.

**Definition A.2 (λ-correlation).**

```
C_I(x) = Σ_{n≤x} 1_{A_I}(n) λ(n).
```

**Problem P1 (the log-indicator barrier).** Is `C_I(x) = o(x)` for every log-arc rule `I`?

**Problem P2 (single-arc instance).** Take `I = [0,π)`, i.e. `A = {n : cos(log n) ≥ 0}` — the `rh43` positive-part set. Determine the true order of `C(x)`: is it `o(x)`? Is it `O(x^{1/2+ε})`?

## Well-posedness and what is known

`𝔽` is countable, so P1 quantifies over a countable family of definite sets and has a definite truth value. Each instance is falsifiable by one arc and one window.

The same identity **is** a theorem for finite complex exponential sums `w(n) = Σ_{|k|≤K} c_k n^{it_k}`: `Σ_{n≤x} w(n)λ(n) = o(x)`, since `Σ λ(n)n^{it}` is controlled by `ζ(2(s-it))/ζ(s-it)`. The passage to an indicator is discontinuous; the square wave’s Fourier series is not absolutely convergent, so the theorem does not transfer.

## Status

OP-19 is OPEN. The B.2 pass added finite data to `10⁹` (`open/op19_log_indicator.py`), consistent with `o(x)` and proving nothing asymptotically. OP-18, once the sign-blind class is fixed, is the existential dual of OP-19.

[Back to folder README](summary-rh/03-open-problems/README.md) · [Back to the summary index](summary-rh/README.md)
