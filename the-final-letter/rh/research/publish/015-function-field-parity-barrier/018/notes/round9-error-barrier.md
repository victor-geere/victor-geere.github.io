# Round 9 — the error barrier, and a correction to round 8

This round does two things: it **corrects an overclaim** from round 8, and it
isolates the obstruction that the numerical data actually faces — the
Chebotarev error, not the arithmetic of a motive.

---

## 1. Established direction — the `d = 2` formula, re-derived

For shift 2, write `f = x² + bx + c`, `d = b² − 4c`. Then `f` is irreducible iff
`χ(d) = −1`, and `f + 2` is irreducible iff `χ(d − 8) = −1`. For each `b`, `c ↦ d`
is a bijection, so

```
T(2;q) = q · #{d : χ(d) = χ(d−8) = −1} .
```

The indicator `[χ = −1] = (1−χ)/2` holds off `d = 0, 8`; a short character-sum
computation (using `Σ_u χ(u²−16) = −1`) gives

```
4·T(2;q)/q² = 1 − (3 − χ(2)(1+χ(−1)))/q .
```

Verified exactly for every prime in the grid (`checks/round9_error_barrier.py`
§[A]), with `A_2 ∈ {−1, −3, −5}` by `q mod 8`. This is a clean, proved exact
formula.

## 2. The error barrier

The general theorem (Bary-Soroker–Stix eq. (1.3)) gives

```
T(d;q) = q^d S(q)/d² + O_d(q^{d−1/2}) .
```

The power of `q` is what matters:

* the **main term** is `q^d`;
* the **correction** (the `1/q` term in `T(d;q)/q^d`, where the traces live) is
  `q^{d−1}`;
* the **error** is `q^{d−1/2}`.

So the error is larger than the correction by a factor `√q`. For `d = 2, 3` this
is harmless because the correction was *proved* by computing the cohomology
(the error is simply not used). For `d ≥ 4` there is no exact formula, and the
correction is buried under the error.

Numerically (`checks/round9_error_barrier.py` §[B]), at the largest available
`q` per `d`:

| `d` | `q` | `Δ_d = T − q^d S/d²` | `|Δ|/q^{d−1/2}` |
|---|---|---|---|
| 2 | 97 | `+5.03e−1` | `5.3e−4` |
| 3 | 97 | `−1.89e+3` | `2.0e−2` |
| 4 | 61 | `−5.37e+3` | `3.0e−3` |
| 5 | 31 | `−1.80e+3` | `3.5e−4` |
| 6 | 19 | `+1.08e+3` | `1.0e−4` |
| 7 | 13 | `+3.25e+3` | `1.9e−4` |

All are consistent with the `O(q^{d−1/2})` bound. Fitting `16T(4) − q^4` by a
cubic in `q` leaves an RMS residual of `~0.1·q³` — the same order as the
correction. No stable `q³` coefficient can be read off.

## 3. Correction to round 8

Round 8 read `A_4(q) = q(16T(4)/q^4 − 1)` as a "new motive" because it varies on
the class `q ≡ 2 (mod 3)`, where the elliptic-curve trace `c_q` vanishes. The
variation is real, but `A_4` is **not** a clean `1/q` coefficient: the
`O(q^{3.5})` error contributes to it, and the `d = 4` data does not admit a
stable trace decomposition. The honest statement is:

> **large arithmetic fluctuation at the `q³` level, not identifiable as a trace
> with the available data.**

The `M_4` identification is therefore **open**, not established. Round 8's
`A_2`, `A_3` results are unaffected (they are proved exact formulas).

## 4. Wild guess 9 — the computability barrier

> **Wild guess 9.** The barrier is **computational**, not analytic. The twin
> count in degree `d` is a trace on `V_d`, but `H^*(V_d)` is computable only for
> `d ≤ 3` (an elliptic curve / an `𝔸¹`-bundle over a hyperelliptic surface). For
> `d ≥ 4` the cohomology — and with it the exact formula — is out of reach. The
> solution would be a **stable or recursive computation of `H^*(V_d)`**: a "twin
> cohomology" algorithm that produces the trace for all `d` at once.

**Why a guess.** There is no known algorithm for `H^*(V_d)` for `d ≥ 4`, no
stable-cohomology theorem for these varieties, and no evidence that `V_d` has a
uniform description as `d` grows. The guess is a statement about *where* the
difficulty lies (computability of a cohomology), not a construction.

**What would falsify it.** An explicit `d = 4` formula obtained by other means
(e.g. a Lefschetz trace computation on a surface) would show the cohomology is
accessible; a proof that no such formula can be computed would support the
guess. The numerical data neither confirms nor refutes it: the observed error
is well below the worst-case bound, so we cannot even estimate the Betti-number
growth from it.

---

## 5. Lean — completing the `q mod 8` table

`lean/Quad.lean` now has, for shift 2:

| field | `q mod 8` | count |
|---|---|---|
| `𝔽₅` | 5 | 0 |
| `𝔽₇` | 7 | 7 |
| `𝔽₁₁` | 3 | 22 |
| `𝔽₁₃` | 5 | 26 |
| `𝔽₁₇` | 1 | 68 |
| `𝔽₁₉` | 3 | 76 |

This is a complete Lean-checked table of the `χ`-dependence behind
`A_2 ∈ {−1, −3, −5}`: `q ≡ 1 (mod 8)` gives `−1`, `q ≡ 3, 7` give `−3`, and
`q ≡ 5` gives `−5`. Footprints clean.

---

## 6. Honest verdict

* **Established this round:** the `d = 2` exact formula (re-derived and
  verified); the error-vs-correction scale `q^{d−1/2}` vs `q^{d−1}`; the fact
  that `d = 4` data cannot support a stable trace decomposition.
* **Corrected:** round 8's "new motive at `d = 4`" is downgraded to "large
  arithmetic fluctuation, not identifiable". `A_2`, `A_3` stand.
* **The wild guess:** the barrier is computability of `H^*(V_d)`. Coherent but
  not testable with the available data.
* **Not claimed:** that `V_4` has no accessible cohomology; that the barrier is
  purely computational; any `d = 4` formula.

## 7. Next round

1. **Improve the `d = 4` extraction.** Average over shifts `h` (the B-S–Stix
   "on average" formula removes the trace terms); the average over `h` may
   expose the clean polynomial part and separate it from the error.
2. **`d = 5`.** Same averaging test.
3. **Wild guess 10 (preview).** *The averaged twin count over shifts `h ∈ 𝔽_q^*`
   is exactly a polynomial in `q` plus `O(q^{-2})`; the "arithmetic" is entirely
   in the `h`-dependence. Over `ℚ`, the analogue is that averaging over the
   shift (`∫ Λ(n)Λ(n+h) dh`) is accessible while the individual `h = 2` is
   not.* Investigate: compute `(1/(q−1))Σ_h T(d;q,h)` and fit a polynomial.

---

## 8. Reproduction

```
python3 checks/round9_error_barrier.py   # exit 0
python3 -m pytest -q tests/              # 200 passed
cd lean && ./check.sh Quad.lean Axioms.lean   # OK
```

New files this round: `checks/round9_error_barrier.py`, `tests/test_round9.py`,
and the `𝔽₁₇`, `𝔽₁₉` sections of `lean/Quad.lean`.
