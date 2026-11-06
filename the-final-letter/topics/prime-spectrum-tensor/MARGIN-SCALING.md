# Margin scaling of the finite Gaussian Weil–Gram ladder

**Status:** numerical audit (2026-11-05).  No theorem is claimed.  This note
records how the smallest eigenvalue of the spacing-`0.2` Gaussian Gram matrix
behaves as the basis grows, and what that implies for the interval-certificate
budget.  It is the evidence behind the recommendation to stop climbing rungs
one at a time.

The numerical object is the one of [`WEIL-GRAM.md`](WEIL-GRAM.md) §2–3:
`σ = 1/20`, centres `−((n−1)/2)·0.2, …, ((n−1)/2)·0.2`, and
`G_{ab} = (W(a−b) + W(b−a))/2`.  The values were computed with
[`python/programme.py`](python/programme.py) (`weil_gaussian_gram`,
`gram_eigenvalues`) at 30–40 decimal digits, prime truncation `X = 20000` and
`X = 40000` (the two agree to the printed digits), and `mpmath` quadrature for
the density.  They are not interval-certified; they are a route diagnostic.

## 1. The measured wall

| `n` | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 12 | 16 | 20 |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| `λ_min` | 2.271e−2 | 2.142e−2 | 1.671e−2 | 1.244e−2 | 9.743e−3 | **8.968e−4** | 6.600e−4 | 2.878e−4 | 1.251e−4 | 3.406e−5 |

The drop at `n = 9` is a factor `10.9` from `n = 8`; at higher `n` the margin
keeps decaying (roughly by a factor `2–5` for each added pair of centres).  This
is a property of the fixed Gaussian basis at spacing `0.2`, not of the
enclosure: every tested matrix is still positive definite, so there is no
negative witness.

## 2. The budget inequality

The transfer of [`lean/Transfer.lean`](lean/Transfer.lean) and
[`lean/GaussianGram5.lean`](lean/GaussianGram5.lean) needs

```
n · ε  <  t  <  λ_min(n),
```

where `ε` is the uniform entrywise half-width and `t` the rational margin of
the exact `L D Lᵀ` certificate.  The 5×5 certificate uses `ε = 0.0036`,
`t = 0.02`, and `5ε = 0.018 < 0.02`.

The density half-width scales approximately linearly with the panel width `h`
(the dominant term is the `Ω`-variation across a panel).  Calibrating on the
generated chains, `K ≈ 1.586·10⁻³` at `h = 1/20` for `c = 4/5`, and
`densityTerm` contributes `2K`.  Allowing `5·10⁻⁴` for the prime and pole
half-widths gives the following indicative requirements (choose
`t = 0.999·λ_min`):

| `n` | `λ_min` | required `ε <` | required `h` | panels per `c` | chunks per `c` | total chunks |
|---:|---:|---:|---:|---:|---:|---:|
| 4 | 2.271e−2 | 5.67e−3 | current `1/20` | 1305 | 9 | 36 |
| 5 | 2.142e−2 | 4.28e−3 | current `1/20` | 1305 | 9 | 45 |
| 6 | 1.671e−2 | 2.78e−3 | ≈ `1/28` | ≈ 1780 | 12 | 72 |
| 7 | 1.244e−2 | 1.78e−3 | ≈ `1/50` | ≈ 3080 | 21 | 147 |
| 8 | 9.743e−3 | 1.22e−3 | ≈ `1/88` | ≈ 5320 | 36 | 288 |
| 9 | 8.968e−4 | 9.96e−5 | ≈ `1/640` | ≈ 37 800 | 252 | 2268 |

The chunk counts are extrapolations at 150 panels per chunk and `n` distinct
separations `0, 1/5, …, (n−1)/5`; the existing chains would have to be
re-emitted, not merely extended.  The `n = 9` row is already impossible at the
level of the prime/pole half-width, before the density is considered.

## 3. What this changes

* **5×5 is the last cheap rung.**  It closes with `ε = 0.0036` and the existing
  `h = 1/20` chains.
* **6×6 is possible but is no longer an increment.**  It needs a finer
  partition of *all* six chains (`h ≈ 1/28`; about 72 chunks, 7–8 h of Lean
  build here), a new prime enclosure at `c = 1` (where `n = 2, 3, 4, 5, 6` are
  all active), and a 6×6 exact `L D Lᵀ` with `t ≈ 0.0167`.
* **`n ≥ 9` is out of reach for this transfer.**  The uniform entrywise budget
  cannot resolve a `10⁻⁴` eigenvalue without a panel width near `1/600`.
  More rungs therefore measure the same method, not the cone.

## 4. The alternatives, priced

1. **Change the lattice spacing.**  At `σ = 1/20`, spacing `0.15` improves the
   conditioning substantially (numerically `λ_min(12) ≈ 4.5·10⁻³` versus
   `2.9·10⁻⁴` at spacing `0.2`), but every separation `0.15, 0.3, 0.45, …` is a
   new `c` and none of the existing density chains is reusable.
2. **Change `σ`.**  `σ = 0.03` with spacing `0.15` has `λ_min(16) ≈ 7.0·10⁻³`,
   but the shared analysis library's density is hard-wired to `σ = 1/20`;
   changing `σ` re-derives the whole archimedean layer.
3. **Keep the basis, sharpen the enclosure.**  A higher-order panel rule
   (Simpson with a third/fourth-derivative bound) could reduce `K` at fixed
   `h`, but that is new analysis, not a re-partition.
4. **Leave the ladder.**  The remaining honest step is the zero-side bridge:
   connect the finite Gram entries to `Σ_ρ ĝ(γ_ρ)` via the explicit formula.
   That is the subject of [`ZERO-SIDE-BRIDGE.md`](ZERO-SIDE-BRIDGE.md).

## 5. Reproduce

```bash
cd the-final-letter/topics/prime-spectrum-tensor/python
python3 - <<'EOF'
import sys; sys.path.insert(0, '.')
import mpmath as mp; mp.mp.dps = 30
import programme as P
for n in range(4, 21):
    cs = [mp.mpf(2*(i-(n-1)/2))/10 for i in range(n)]
    ev = P.gram_eigenvalues(P.weil_gaussian_gram(cs, mp.mpf(1)/20))
    print(n, mp.nstr(ev[0], 12))
EOF
```

The `n = 6` and `n = 9` values are also checked by
`test_gaussian_margin_scaling_wall` in
[`tests/test_programme.py`](tests/test_programme.py) (C24).

---

[Back to the programme](README.md) · [Weil–Gram rungs](WEIL-GRAM.md) ·
[Zero-side bridge](ZERO-SIDE-BRIDGE.md) ·
[5×5 handoff](HANDOFF-M0P-5X5.md)
