# T6 — an admissible kernel with an `O(1)` left side

**Outcome: (A).** There *is* a compactly supported even kernel meeting the operative
admissibility conditions with an `O(1)` left side and a zero-tail far below `10⁻²⁰` at
`K = 100 ≤ 10³`. The literal negative claim (B) is **false** as stated; the correct
structural constraint is Paley–Wiener (no exponential decay for compact support), not a
`c/log G` lower bound.

Reproduce with

```
cd research/twin-prime-parity/010/rigorous
/opt/homebrew/Caskroom/miniforge/base/bin/python3 kernel_probe.py | tee kernel_probe.log
```

`kernel_probe.py` exits `0` iff all 9 self-checks pass; the archived run
`kernel_probe.log` is `9/9` (96 s, `mp.dps = 60`).

---

## 1. Conventions (the audited Weil form)

As in [`../truths.md`](../truths.md) §1, [`../notes/routes-a-b-c-status.md`](../../006-explicit-formula-routes-abc/notes/routes-a-b-c-status.md) §4:

```
g real, even;   φ(t) = ∫_ℝ g(u) e^{i t u} du;   Φ(s) = ∫_ℝ g(u) e^{(s−1/2)u} du,
Σ_ρ Φ(ρ) = Φ(1) + Φ(0) + (1/2π)∫_ℝ φ(t) Ψ(t) dt − Σ_{n≥2} (Λ(n)/√n)[g(log n) + g(−log n)],
Ψ(t) = −log π + Re ψ(1/4 + i t/2).
```

For even `g`: `LHS = 2 Σ_{γ>0} φ(γ)`, `Φ(1)+Φ(0) = 2φ(i/2) = 2∫g(u)e^{−u/2}du`, and the
prime side is `2 Σ Λ(n) n^{−1/2} g(log n)`.

`LHS` below is this `Σ_ρ Φ(ρ)`; `RHS` is the right-hand side; the residual is `RHS − LHS`.

**The `Λ` guard.** The probe checks its von Mangoldt sieve against an independent
trial-division `Λ` (0 mismatches for `n ≤ 3000`) and against `log rad(n)` (2533
mismatches). This matters: using `log rad` — the exact bug of
[`../von-mangoldt-sieve.html`](../../../twin-prime-parity/010/von-mangoldt-sieve.html) — turns the Gaussian residual
into a fake `−0.0858`; with correct `Λ` it is `1.56·10⁻⁴⁴`.

---

## 2. The kernel

Main candidate (`a = γ₁ = 14.1347251417346937904572519836`):

```
g(u) = C (1 − u²/144)^40 cos(a u),          |u| ≤ 12,     C = 0.60026318172387376824
φ(t) = C/2 [ M(t−a) + M(t+a) ],
M(x) = A √π m! (2/(A|x|))^{m+1/2} J_{m+1/2}(A|x|),   M(0) = A √π m!/Γ(m+3/2) = 3.3318718537,
```

with `A = 12`, `m = 40`. `M` is even (the probe's transform is even in its argument — an
initial hand computation missed this and gave a spurious `0.30` residual).

* `g` is real, even, compactly supported in `[−12,12]`, and `C^{39}`.
* The modulation `cos(a u)` shifts the flat-top of `M` to `t = a = γ₁`, so `φ(γ₁) ≈ 1`;
  because zeros come in conjugate pairs, `LHS = 2Σφ(γ) ≈ 2·1 = 2`.
* `M(0)/A = √π m!/Γ(m+3/2) = 0.277656` (≈`√(π/(m+3/4))`), so `φ(γ₁) = 1` and
  `LHS = 2 + 2Σ_{γ≠γ₁}φ(γ) = 2` to 14 digits.

---

## 3. The table

`K = 100` zero terms (`γ₁₀₀ = 236.5242297`). "Zero tail" and "arch tail" are truncation
bounds (below). The residual for the main bump is limited by the archimedean quadrature,
not by the identity.

| kernel | `\|LHS\|` | `\|RHS−LHS\|` | zero-tail bound at `γ_K` | arch-tail bound | prime cut `N` | compact? |
|---|---|---|---|---|---|---|
| Gaussian `e^{−u²/2}/√(2π)` | `8.26·10⁻⁴⁴` | `1.56·10⁻⁴⁴` | — | 0 | `2·10⁶` | no |
| modulated Gaussian `cos(a u)e^{−u²/2}` | `2.5066` | `2.41·10⁻⁴⁵` | — | 0 | `2·10⁶` | no |
| **bump `A=12, m=40`** | **`2.0000`** | **`−7.24·10⁻⁵⁴`** | `4.95·10⁻⁷⁷` | `3.69·10⁻⁵⁰` | `162754` | **yes** |
| bump `A=8, m=40` | `2.000000000064` | `3.68·10⁻⁴⁷` | `6.7·10⁻⁷⁰` | `5.0·10⁻⁴³` | `2980` | yes |
| bump `A=12, m=24` | `2.0000` | `4.78·10⁻³⁹` | `5.0·10⁻⁵¹` | `4.0·10⁻³⁵` | `162754` | yes |

Component values of the main row (`A=12, m=40`): poles `Φ(1)+Φ(0) = −1.73·10⁻³⁰`,
archimedean `(1/2π)∫φΨ = 0.485703508744`, prime side `2ΣΛ(n)n^{−1/2}g(log n) = −1.51429649126`,
so `RHS = 1.999…` and `RHS − LHS = −7.24·10⁻⁵⁴`. The Gaussian row reproduces the archived
value `1.56·10⁻⁴⁴` of [`../truths.md`](../truths.md) §1 exactly.

**Truncation bounds.**

*Zero tail.* With `dN(t) ≤ (log(t/2π)/(2π) + 1)dt`,
`Σ_{γ>G}|φ(γ)| ≤ ∫_G^∞ env(t)(log(t/2π)/(2π)+1)dt`, where
`env(t) = C A√π m! (2/(A(t−a)))^{m+1/2}` is the Bessel envelope (`|J_ν| ≤ 1`). For the main
row at `G = γ₁₀₀` this is `2.48·10⁻⁷⁷`, i.e. `2·(2.48·10⁻⁷⁷) = 4.95·10⁻⁷⁷`.

*Archimedean tail.* `(1/π)∫_T^∞ env(t)(log t + 2)dt` at `T = 60` is `3.69·10⁻⁵⁰` (using
`|Ψ(t)| ≤ log t + 2` for `t ≥ 2`).

*Prime side.* Because `supp g = [−12,12]`, only `n ≤ e¹² = 162754` contribute; the sum is
**finite and exact**, with zero tail.

---

## 4. The three admissibility conditions

* **(i) Decay of `Φ` at the nontrivial zeros.** `Φ(ρ) = φ(γ)`. Verified numerically:
  `|φ(t)| ≲ t^{−41}` — e.g. `|φ(γ₂)| = 1.70·10⁻¹⁸`, `|φ(50)| = 6.32·10⁻⁴⁸`,
  `|φ(500)| = 7.87·10⁻⁹⁵` — and the probe checks `|φ(γ)| ≤ env(γ)` for every zero
  `γ ≥ γ₂`. Hence the zero sum converges absolutely and rapidly in the practical sense:
  each decade of `G` gains ≈41 digits.

* **(ii) `g` compactly supported.** `supp g = [−12,12]`; this is also what makes the prime
  sum finite and exact.

* **(iii) "Decay at the trivial zeros `s = −2,−4,…`".** This condition is **not
  satisfiable literally by any non-zero even kernel**, and the probe exhibits it:
  `Φ(−2n) = ∫g(u)e^{−(2n+1/2)u}du` is dominated by the endpoint `u = −A`, so it *grows*.
  For the Gaussian, `Φ(−2n) = (2π)^{−1/2}e^{(2n+1/2)²/2}` (`9.08, 9.96·10³, 5.96·10⁸,
  3.48·10²³, 7.20·10⁹⁰` at `n = 1,2,3,5,10`); for the bump (`A=12, m=40`) the values are
  `−4.1·10⁻¹⁹, −2.3·10⁻⁹, 1.98, −1.35·10¹⁹, −4.99·10⁶⁴`, also growing. So the
  Gaussian family does **not** satisfy the literal reading either, and the condition must
  be a convention artefact: for even `g`, `Φ(s) = Φ(1−s)`, so the trivial zeros `s = −2n`
  are the mirror images of `s = 2n+1`, and the archimedean integral `(1/2π)∫φΨ` is exactly
  the term that regularises them. The **operative** content is that this integral
  converge absolutely, i.e. `φ(t) = o(1/log t)`; for the bump this holds with a huge
  margin (archimedean tail `3.69·10⁻⁵⁰`), and the probe checks it.

  Note the same `Φ` also tells us where the condition *can* be met: with the sign
  convention `Φ̃(s) = Φ(1−s)` the trivial-point values are the ones above, and their
  growth `e^{(2n+1/2)A}` is intrinsic to even, compactly supported `g`.

---

## 5. What is proved vs. what is numerical

* **Proved (elementary, in the note and the probe's comments).**
  * Paley–Wiener obstruction (§6).
  * `φ(t) = O(t^{−(m+1)})` for `g ∈ C^m` compactly supported, via `M(x) = A√π m!(2/(Ax))^ν J_ν(Ax)`
    and `|J_ν| ≤ 1`; hence the tail bound `Σ_{γ>G}|φ(γ)| = O((log G)G^{−m})`.
  * `Φ(−2n) → ∞` for every non-zero even `g` (the literal reading of (iii)).

* **Numerical (high precision, but not interval-certified).**
  * The identity residual itself (`7.24·10⁻⁵⁴`), computed at `mp.dps = 60` with
    `mp.quad`, `mp.besselj`, `mp.digamma`, and `mp.zetazero`; the prime sum is an exact
    finite integer-`Λ` sum.
  * The truncation bounds use the standard density estimate `dN(t) ≈ (1/2π)log(t/2π)dt`
    (the same estimate used in [`../truths.md`](../truths.md) §1, §5), not an explicit
    zero-counting certificate.
  * The residual is stable under refinement (`dps = 60/80/100` and `T = 30/40/60`; see the
    probe's `S2`/`S6`); with `T = 60` it is `−7.24·10⁻⁵⁴`, and the discrepancy at
    `T = 30` was entirely the archimedean tail.

  A fully interval-certified version would replace `mp.zetazero` by the round's certified
  brackets and `mp.quad`/`mp.besselj` by the `eta_interval`/`ivmath` enclosures; this was
  out of scope here and is the main residual uncertainty.

---

## 6. Paley–Wiener, and why (B) is false as stated

**Theorem (proved above).** If `g ≠ 0` is compactly supported and `|φ(t)| ≤ C e^{−c|t|}` on
`ℝ` for some `c > 0`, then `g = 0`. Indeed `g(u) = (1/2π)∫φ(t)e^{−itu}dt` is holomorphic in
the strip `|Im u| < c` (the integral converges absolutely there) and vanishes for
`|u| > A` on the real axis; that open set meets the strip, so `g = 0` by analytic
continuation.

So compact support forbids **exponential** decay of `φ`; it does **not** forbid
super-polynomial decay (`g ∈ C^∞` gives `e^{−c√t}`-type) or `t^{−(m+1)}` decay for
`g ∈ C^m`. Hence the literal claim

> `O(1)`-LHS forces a zero-side tail `≥ c/log G` for every compactly supported even `g`

is **false**: the main bump has `|LHS| = 2` and zero-tail bound `4.95·10⁻⁷⁷` at
`G = γ₁₀₀`, while `1/log G = 0.1829` — the tail is ~76 orders of magnitude below any
`c/log G`.

The correct structural statement, and the real content of the "Cauchy boundary case":

* `g ∈ C^m` vanishing to order `m` at the endpoints of its support ⟹
  `φ(t) = O(t^{−(m+1)})` and the zero tail beyond `G` is `O((log G)G^{−m})`.
* Absolute convergence of the zero side needs `m ≥ 1`; the case `m = 0` (a jump, or a
  non-compactly-supported kernel with `g(log n) ∼ n^{−1/2}`, e.g. the Cauchy kernel at
  `a = 1/2`) is exactly the divergent boundary case of [`../truths.md`](../truths.md) §1.
* Exponential convergence of the zero side is impossible for compactly supported `g`, but
  the non-compact modulated Gaussian in the table shows it is attainable once compact
  support is dropped (`|LHS| = 2.5066`, residual `2.41·10⁻⁴⁵`).

---

## 7. Summary

| question | answer |
|---|---|
| admissible compact kernel with `\|LHS\| ≥ 0.1` and residual `≤ 10⁻²⁰` at `K ≤ 10³`? | **yes** — `g(u) = 0.6002632 (1−u²/144)⁴⁰ cos(γ₁u)` on `[−12,12]`, `\|LHS\| = 2`, residual `7.2·10⁻⁵⁴`, `K = 100` |
| prime sum finite and exact? | yes, `N = e¹² = 162754` |
| (i) decay at nontrivial zeros? | yes, `φ(t) = O(t⁻⁴¹)`; zero-tail bound `4.95·10⁻⁷⁷` |
| (ii) compact support? | yes, `supp = [−12,12]`, `C³⁹` |
| (iii) decay at trivial zeros? | unsatisfiable as literally stated by any even kernel; operative convergence of the archimedean term holds |
| is (B)'s `c/log G` lower bound true? | **no**, refuted by the witness; the correct obstruction is Paley–Wiener (no exponential decay) |

**Residual uncertainty.** The identity verification is high-precision numerics, not an
interval certificate; `mp.zetazero` supplies the zeros. The bound on the zero tail uses the
standard Riemann–von Mangoldt density rather than a counted certificate. The literal
condition (iii) is convention-dependent and cannot be satisfied by any even kernel.
