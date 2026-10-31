# Term-by-term tail proof for the `Ω` Taylor jet

**Status:** rigorous analytic bound. This note proves that the `u`-tail omitted
from the `Ω` jet beyond `U = 6` contributes less than `10^{−5}` to every jet
component of order `0 ≤ k ≤ 4`, for `|t| ≤ 100`. It removes the blanket
`10^{−6}` tail allowance used in the earlier `U=4` run.

The tail is

```
T(t) = ∫_U^∞ K(u,t) du,
K(u,t) = u · J(t/2,u) · s(u),
J(x,u) = (y−x²) / ((y−x²)² + x²/4),
y = u² + 1/16,  s(u) = 1/(e^{2πu}−1).
```

We take `U = 6`, `|t| ≤ 100` (so `|x| ≤ 50`), and prove
`|T^{(k)}(t)| ≤ 10^{−5}` for `k = 0,1,2,3,4`.

## 1. Root location and a denominator bound

Let

```
P_±(x) = y − x² ∓ i x/2,   D = P_+ P_- = (y−x²)² + x²/4.
```

**Lemma 1.** For `y > 1/16`, the zeros of `P_+` have imaginary part `−1/4`
and real part `±√(y−1/16)`; the zeros of `P_-` have imaginary part `+1/4`.

*Proof.* Write `x = α + iβ`. For `P_+`, the imaginary part is
`−α(2β+1/2)`. If `α = 0`, then `x = iβ` and
`P_+ = y + β² + β/2`, whose discriminant in `β` is `1/4 − 4y < 0`; so
`α ≠ 0` and `β = −1/4`. The real part is then `y − α² + 1/16`, giving
`α² = y − 1/16`. The proof for `P_-` is the same with the sign flipped. ∎

**Lemma 2.** For `u ≥ 6`, `y ≥ 36`, let `x₀ ∈ [−50,50]` and let `E` be the
closed disk `|x−x₀| ≤ 1/5`. Then `|D(x)| ≥ 1/400` on `E`.

*Proof.* The vertical distance from the real axis to every zero in Lemma 1 is
`1/4`. The disk has radius `1/5`, so every point of `E` is at distance at least
`1/4 − 1/5 = 1/20` from each zero. Hence `|P_±| ≥ 1/20` and
`|D| = |P_+| |P_-| ≥ 1/400`. ∎

## 2. Bounds for `J` and its derivatives

On `E`, `|x| ≤ 50 + 1/5 = 251/5`, so `|x|² ≤ 63001/25 < 2521`.

Since `|D| ≥ 1/400`,

```
|J| = |y−x²|/|D| ≤ 400 (y + |x|²) ≤ 400 (u² + 2521).     (2.1)
```

`J` is analytic on `E`, and the Cauchy estimate for the `k`-th derivative is

```
|J^{(k)}(x₀)| ≤ k! · max_E |J| / (1/5)^k.
```

Using (2.1), for `0 ≤ k ≤ 4`,

```
|J^{(k)}(x₀)| ≤ k! 5^k · 400 (u² + 2521)
              ≤ 6·10^6 (u² + 2521),                       (2.2)
```

because `max_{k≤4} k! 5^k = 4!·5^4 = 15000` and `15000·400 = 6·10^6`.

## 3. The `s` factor

For `u ≥ 6`, `e^{2πu} − 1 ≥ e^{2πu}/2`, hence

```
0 < s(u) ≤ 2 e^{−2πu}.                                     (3.1)
```

## 4. Tail derivative bound

`K(u,t) = u · J(t/2,u) · s(u)` and `s` does not depend on `t`. Therefore

```
∂_t^k K(u,t) = u s(u) 2^{−k} J^{(k)}(t/2,u).
```

Using (2.2) and (3.1),

```
|∂_t^k K(u,t)|
  ≤ u · 2e^{−2πu} · 6·10^6 (u² + 2521)
  ≤ 8.64·10^8 u³ e^{−2πu},                                 (4.1)
```

where we used `u² + 2521 ≤ 72u²` for `u ≥ 6` (since `72·36 = 2592 > 2521`).

Finally,

```
∫_6^∞ u³ e^{−2πu} du
 = e^{−12π} ( 6³/(2π) + 3·6²/(2π)² + 6·6/(2π)³ + 6/(2π)^4 ).
```

The bracket is less than `40`, and `e^{−12π} < 4.31·10^{−17}`. Hence

```
∫_6^∞ |∂_t^k K(u,t)| du
  < 8.64·10^8 · 40 · 4.31·10^{−17}
  < 1.49·10^{−6}.                                          (4.2)
```

The `Ω` jet uses `−2∫K`; the factor `2` gives `< 2.98·10^{−6}`, and the
implemented allowance is `10^{−5}`, a factor greater than `3` of safety.

Therefore, for every `k = 0,1,2,3,4` and every `|t| ≤ 100`,

```
|∂_t^k T(t)| < 10^{−5}.
```

## 5. Consequence for the certificate

The `Ω` t-jet now adds `10^{−5}` to every component beyond `U=6`. The
Gram-entry margin `10^{−4}` dominates this bound. The `U=6` rerun with the
audited jet and the `10^{−5}` allowance is recorded as C22; it is the
term-by-term-tail-backed certificate.

[Back to the programme](README.md) · [Weil Gram note](WEIL-GRAM.md)
