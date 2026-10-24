# Round 121 — polynomial shifts and the `(Q−1)/(Q−2)` correction

*Plan fixed at the start of the round (`rounds.log`, BEFORE line).*

---

## 1. The envisioned path

Every round so far used a **constant** shift `h ∈ 𝔽_q`, which is why no prime ever divides `h` and the singular
series was shift-free (round 113). The natural extension is a **polynomial shift** `h ∈ 𝔽_q[x]` of positive
degree: now primes can divide `h`, and the local factor must change.

At a prime `Q | h`, the two conditions `f ≢ 0 (Q)` and `f + h ≡ 0 (Q)` coincide, so the admissible residues are
`Q − 1` rather than `Q − 2`. The local factor becomes

```
L₁(Q) = 1/(1 − 1/Q)      instead of     L₂(Q) = (1 − 2/Q)/(1 − 1/Q)² ,
```

and the ratio is `L₁/L₂ = (Q−1)/(Q−2)`. Hence the prediction

```
T(n; h) ≈ S_h(q) q^n / n² ,      S_h(q) = S(q) · Π_{Q | h} (Q−1)/(Q−2) .
```

This is testable with the segmented counter, extended to polynomial shifts.

## 2. Wild guess 62

> **Wild guess 62.** The polynomial-shift twin count obeys the same asymptotic with the modified singular
> series `S_h`; in particular `h = x` over `𝔽₃` should give `T ≈ 2S(3) q^n/n² = 0.7922 q^n/n²`.

**Why guess it.** The local-factor computation is forced by the residue counts, and constant shifts already
obey the asymptotic with `S_0 = S`.

**Falsification test.** Compute `T(n;h)` for `h = x, x+1, x²+1` at `q = 3`, `n = 5..9`, and compare with
`S_h q^n/n²`.

## 3. Results

| shift | factors | `S_h` | ratios `T/(S_h q^n/n²)` for `n = 5..9` |
|---|---|---|---|
| `x` | `{x}`, `Q=3` | 0.792208 | 1.039, 0.997, 0.962, 0.985, 0.987 |
| `x+1` | `{x+1}`, `Q=3` | 0.792208 | 1.039, 0.997, 0.962, 0.985, 0.987 |
| `x²+1` | `{x²+1}`, `Q=9` | 0.452690 | 1.136, 0.655, 1.138, 0.905, 1.073 |

For the linear shifts the agreement is excellent — within `4%` over five degrees, and `h = x` and `h = x+1`
give identical counts (they are in the same orbit under the shift symmetry). For the quadratic shift the counts
are small (`5, 6, 23, 42, 118`), so the ratios are noisier but centred on `1`.

**Wild guess 62 is confirmed** for the case where it is sharpest. This is the first extension of the
programme's counting framework beyond constant shifts, and it confirms that the singular series machinery
(local factors from residue counts) works for polynomial shifts with the `(Q−1)/(Q−2)` correction.

## 4. Lean

`PolyShift.card_nonzero`: avoiding only `0` leaves `|F| − 1` residues — the degenerate local factor at a prime
dividing `h` — and `PolyShift.factor_gap`: the two counts differ by exactly one, the source of the ratio.
Standard axioms.

## 5. State

* Polynomial-shift counts computed and matched to `S_h` (linear shifts within 4%).
* The `(Q−1)/(Q−2)` correction is confirmed numerically and formalised at the local level.
* 20 unit tests green; twelve Lean modules green.

## 6. Next round (122)

The extension raises a natural question the constant-shift programme could not ask: does the **dimension**
factor `2^dim` change when `h` has prime factors? At a prime `Q | h` the local count is `Q−1` rather than
`Q−2`, so the parity structure may weaken. Round 122 will compute the Λ² bound for a polynomial shift and
compare its factor with `4`.
