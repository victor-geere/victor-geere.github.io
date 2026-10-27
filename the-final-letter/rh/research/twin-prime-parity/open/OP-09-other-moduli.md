# OP-9 (TODO item O9) — other moduli: what really changes when `2k` becomes `qk + r`

**Status: SETTLED — the recorded conjecture is FALSE.** Reproduce:
[`op09_moduli.py`](op09_moduli.py) → [`op09_moduli.log`](op09_moduli.log) (exit 0,
60 dps, 60 cases).

## The recorded conjecture

> "Replace `2k` by `qk + r`; determine `nmin(p; q, r)`. The leading constant becomes
> `1/log q`-type data; the method is unchanged."

## The correct statement

Define the modulus alphabet

```
term(p, q, r, n) = (q(n+1) + r)^{−p} ,     n ≥ 0 ,   q ≥ 2 ,   0 ≤ r < q ,
```

i.e. the arithmetic progression `q + r, 2q + r, 3q + r, …`, and Brown's criterion at
index `N`

```
b_N ≤ T_{N+1} ,     b_N = (q(N+1)+r)^{−p} ,   T_N = Σ_{n≥N} b_n .
```

Dividing by `b_N`:

```
T_{N+1}/b_N = Σ_{j≥1} (1 + q j/m0)^{−p} ,      m0 := q(N+1) + r
            = Σ_{j≥1} (1 + j/(m0/q))^{−p}  =:  F1(m0/q) ,
```

so the criterion depends on the modulus data **only through the real number**

```
m0/q = N + 1 + r/q .
```

Hence with `θ(p)` the (unique) solution of `F1(θ(p), p) = 1`:

```
criterion(N; q, r)   ⟺   N + 1 + r/q ≥ θ(p) .
```

Two consequences, both verified:

1. **`r = 0` is exactly `q`-independent.** Then `m0/q = N + 1` is an integer, so the
   criterion is literally the OP-5 one: `nmin(p; q, 0) = nmin(p; 2, 0)` for **every**
   `q`. Checked for `q ∈ {2,3,4,5,6,7,11}` at `p ∈ {200, 1000, 5000}` — all values
   coincide. So the `q`-generalisation with `r = 0` produces nothing new.

2. **The slope is `1/log 2` for every `q` and `r`.** `θ(p) = p/log 2 + O(1)` uniformly
   in the modulus data, so

   ```
   nmin(p; q, r) = p/log 2 − 1 − r/q + O(1) ,
   ```

   and `q` enters **only** through the `r/q` shift of the constant. The table
   `nmin + 1 + r/q − p/log 2` over all 60 cases lies in `[−1.4951, −0.5132]` — bounded
   and `(q, r)`-uniform, so the slope is `1/log 2`, **not** `1/log q`.

**The recorded `1/log q` claim is therefore FALSE.** This is the fourth over-reach
found in the same family (after the `O(1/p)` index error, the exact ceiling law, and
OP-6's constant `1/p` coefficient — items of the earlier passes, plus `O3`/`O4` here).

## What is *not* claimed

* Only the **leading order and the `r/q` shift** are settled here. The `O(1)` term
  itself is not a constant (it has the same non-converging ceiling structure as in
  OP-5's `O(1)` correction; cf. the exact OP-5 result `nmin p − nminAsym p ∈ [0,1)`
  and the recently falsified ceiling law, item `O3`).
* The statement is verified at 60 dps for `q ≤ 11`, `p ≤ 5000`; the derivation above is
  exact, and the numerics confirm it.
* The Lean generalisation (a `termQR` alphabet with the basic layer and the ratio
  identity) is **not** attempted here; the mathematical determination of
  `nmin(p; q, r)` is what this item asked for.

## Reproduce

```
python3 op09_moduli.py        # exit 0 iff all three checks pass
```
