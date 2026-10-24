> **ERRATUM (see [`ERRATUM-mrt-misattribution.md`](ERRATUM-mrt-misattribution.md)).**  This
> document, as originally written, described `Σ λ(n)λ(n+1)` as *solved* and concluded that shift 2
> is *equivalent* to the odd core.  **That premise is false**: the un-averaged Chowla conjecture is
> open for every `k ≥ 2` ([MRT](https://arxiv.org/abs/1503.05121): "remains unproven for any
> h_1,…,h_k with k ≥ 2").  The correct consequence of the split below is a **sufficiency** — both
> halves open — not an equivalence.  The identities are unaffected.
>
> **Second correction (round 3).**  Tao's log-averaged theorem covers the *whole* affine two-point
> family, so the core is a literal instance of a theorem, and the gap (log-average → natural
> average) is **uniform across the family**.  Shift 2 is not special, and isolating the core does not
> isolate the difficulty.  See the erratum.

# Deconstructing h = 2: where the difficulty actually sits

*Goal 5, deliverables (1)–(3).  Machine-checked module:
[`lean/ConeLean/ShiftTwoCore.lean`](../../../lean/ConeLean/ShiftTwoCore.lean) ·
numerical cross-check: [`shift_two_split_check.py`](shift_two_split_check.py) ·
[log](verify/shift_two_split_check.log).  **This note does not prove `o(x)` and contains no step
toward a proof.**  Labels: **MACHINE-CHECKED** / **EXTERNAL** / **ARGUMENT** / **HEURISTIC**.*

## 1. The split

`λ` is Liouville's function, **completely** multiplicative: `λ(mn) = λ(m)λ(n)` for all `m, n`, with
no coprimality hypothesis.  Machine-checked (`ShiftTwoCore.lean`):

```
lam_mul            : lam (m * n) = lam m * lam n
lam_even_shift_two : lam (2j) * lam (2j+2) = lam j * lam (j+1)

chowlaSum_shift_two_split (M : ℕ) :
  Σ_{n < 2M} lam n * lam (n+2)
    = (Σ_{j < M} lam j * lam (j+1)) + (Σ_{k < M} lam (2k+1) * lam (2k+3))
```

The even terms of shift 2 *are* shift 1, because `λ(2j)λ(2j+2) = (λ2)²·λ(j)λ(j+1)` and `λ(2)² = 1`.
So, **given** the Matomäki–Radziwiłł–Tao theorem (EXTERNAL: `Σ_{n≤x} λ(n)λ(n+1) = o(x)`), the
two-point Chowla statement at shift 2 is *equivalent* to

```
CORE:   C(K) = Σ_{k<K} λ(2k+1) λ(2k+3) = o(K) .
```

Numerical cross-check of the identity on real data, M ∈ {1, 2, 7, 100, 10³, 10⁵, 10⁶}, exact
integer arithmetic: all seven differences are `0`.

*Provenance, stated plainly:* this split is an elementary consequence of complete multiplicativity
and is almost certainly folklore.  Its value here is that it is exact, machine-checked, and that it
localises the open content — see §3, where it kills a natural but wrong explanation.

## 2. The core, and what it needs

MACHINE-CHECKED structural facts about the core (`ShiftTwoCore.lean`):

```
prime_dvd_shift_two            : p prime → p ∣ n → p ∣ n + 2 → p = 2
core_coprime                   : (2k+1).Coprime (2k+3)
core_diff_squares              : (2k+1)(2k+3) = (2k+2)² − 1
core_not_multiplicative        : the core is not multiplicative (witness k=2, m=5)
core_not_multiplicative_lam    : the same witness in the `lam` normalization
```

So: `2` is the only prime that can divide both `n` and `n+2`, hence the 2-adic substitution is the
**only** substitution of its kind that reduces the shift; inside the core the two arguments are
already coprime; and the core is a difference-of-squares correlation, `Σ_k λ((2k+2)² − 1)`.

What the core needs is therefore a *prescribed-scale, un-averaged* statement about a 2-shift
correlation of `λ` on the odd numbers.  Each neighbouring tool is blocked, and by now provably so
for three of them:

| tool | status for the core |
|---|---|
| log-averaged / entropy-decrement (Tao, EXTERNAL) | gives only the Abelian mean (goal 2, (1b), MACHINE-CHECKED) and is provably blind to a prescribed scale (goal 3, (b3), MACHINE-CHECKED); it cannot supply an un-averaged statement |
| Euler product / Perron | CLOSED for the shift-2 sequence (goal 3, (c1), MACHINE-CHECKED: `chowlaAF_not_multiplicative`) and now CLOSED for the core too — MACHINE-CHECKED: `core_not_multiplicative`, witness `k = 2, m = 5` coprime, where the core at `km = 10` is `λ(21)λ(23) = −1` while the product of core values is `+1` |
| averaging over shifts / over scales | provably cannot reach a prescribed point (goal 3, (b2), MACHINE-CHECKED both sides) |
| Selberg parity / bounded-depth sieve | closed by the parity principle (EXTERNAL, archive dictionary T17) |
| spectral / positivity | no candidate exists (goal 3, (c2) ledger) |

## 3. What the split rules out — the useful part

The natural explanation of why `h = 1` yields to MRT and `h = 2` does not is *"`n` and `n+1` are
coprime, so multiplicativity bites"*.  **The core kills that explanation**: `2k+1` and `2k+3` are
coprime too (`core_coprime`, MACHINE-CHECKED) and differ by 2.  So coprimality is not the
differentiator, and any argument that leans on it is wrong — a plausible story retired by a
machine-checked fact rather than by a counterexample hunt.

**A candidate differentiator, labelled as such.**  Put `g(k) = λ(2k+1)`.  Then the core is exactly
`Σ_{k<K} g(k)g(k+1)` — a shift-1 two-point correlation, i.e. the *shape* MRT solved, but for `g`
rather than for `λ`.  And `g` is **not multiplicative** (MACHINE-CHECKED: `oddLam_not_multiplicative`
— `g(15) = λ(31) = −1` while `g(3)g(5) = λ(7)λ(11) = +1` at the coprime pair `3, 5`).  Since the MRT
mechanism consumes multiplicativity, this is a *candidate* explanation of why it does not transfer —
**ARGUMENT**, not a proof that the method cannot be adapted.  I do not claim the core is easier or
harder than the general case; only that it is equivalent to it, given MRT.  See
[`shift-two-lateral-appendix.md`](shift-two-lateral-appendix.md) A3/B1.

## 4. A test protocol

Because `h = 2` ⟺ core (given MRT), the core is the correct and cheaper test case for any candidate
method:

1. Apply the method to `C(K)` first.  It is a single parity class, so any mechanism that works only
   by exploiting common factors of `n` and `n+2` fails *visibly* — there are none.
2. A method that cannot produce `C(K) = o(K)` cannot produce `h = 2`, whatever it does for other
   shifts.  This is a free filter on proof attempts.
3. If a method does produce `C(K) = o(K)`, it has produced the whole theorem, by
   `chowlaSum_shift_two_split` plus MRT — that is exactly what the machine-checked split buys.

## 5. What is not claimed

No proof of `o(x)`, no partial result toward it, no claim that the core is tractable.  The finite
numerics in the log (HEURISTIC) show the core behaving like a random ±1 sequence at `K = 2²⁰`
(`S/√K = −0.078`, `max|d| = 2.13`, mean `−8×10⁻⁵`) — consistent with the conjecture and with many
alternatives, and no finite computation decides the limit (archive F4).
