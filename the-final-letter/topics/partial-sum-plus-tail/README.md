# Partial sum plus tail — certified evaluation of ζ, ζ(s,a) and L(s,χ)

**Status:** Objective III of the Final Letter, integrated as the programme's
positive computation layer. The rational interval algebra, the certificate
replay, the truncation transport, the eta cos/sin split, and the
transcendental enclosures (`π`, `log`, `exp`, `sin`, `cos`) are proved in
Lean. The Euler–Maclaurin formula and the explicit tail bound have a written
proof in [`notes/euler-maclaurin-proof.md`](notes/euler-maclaurin-proof.md) but
remain unformalised in Lean: they are the only parts outside Lean. The
elementary source claims S3–S5 (the zeta bound, the eta identity and the
`L`-reduction) are proved in `SourceClaims.lean`. The layer is an instrument, not a hypothesis: no theorem
about either wall yet uses a certified enclosure as a premise.

**Objective:** the third objective of the Final Letter. The first two
objectives are the two walls (RH and parity). This one is the positive
computation layer those walls need: a certified evaluator that returns a
rational rectangle containing `ζ(s)`, `ζ(s,a)` or `L(s,χ)`, with a
kernel-checked replay of every rational operation.

**Source bundle:** `~/workspace/rh/research/twin-prime-parity/012/`
(“a partial-sum-plus-tail evaluator with checked certificates”), also
snapshotted in `~/workspace/rh/research/publish/013-twin-prime-parity-explicit-function/`.
The eta/cos/sin analysis is in the published bundle's
`notes/004-eta-cos-sin.md`.

## Role in the programme

The Final Letter has three objectives. The first two are the walls (RH and
parity); this is the positive computation layer they need. Its integration
is as an instrument, not as a bridge:

- [05 — Proofs, section C](../../categories/05-proofs/proofs.md#c-the-certified-evaluation-layer) records the theorem groups C1–C7 (interval algebra, certificate soundness, truncation transport, eta split, ζ(2) replay, transcendental enclosures, S3–S5) and the two analytic inputs S1–S2.
- [06 — Findings, F11](../../categories/06-findings/findings.md#f11-certified-evaluation-is-an-instrument-not-a-key) states what the layer does and does not do.
- [07 — Significance, section 8](../../categories/07-significance/significance.md#8-a-reusable-certified-computation-layer) records it as a reusable positive residue.
- [08 — Novelty, N7](../../categories/08-novelty/novelty.md#n7-a-certified-evaluator-inside-the-letters-argument) is explicit that the method is inherited and the integration is the contribution.
- [09 — Further research, R13–R15](../../categories/09-further-research/further-research.md#r13-formalise-eulermaclaurin-and-the-explicit-tail-bound) lists the remaining formalisation, use-as-hypothesis, and width-certification tasks.
- [STATUS.md](../../STATUS.md) keeps the layer in the status ledger.

## What the programme is

For `a > 0`, `b = a + M`, rising factorial `(s)_n = s(s+1)…(s+n−1)` and
Bernoulli numbers `B_{2j}`, Euler–Maclaurin gives

\[
\zeta(s,a)=\sum_{k<M}(a+k)^{-s}
+\frac{b^{1-s}}{s-1}+\frac{b^{-s}}{2}
+\sum_{j=1}^{K}\frac{B_{2j}}{(2j)!}(s)_{2j-1}b^{-s-2j+1}
+R_K(s),
\]

with the explicit tail bound

\[
|R_K(s)|\le |(s)_{2K+1}|\,
\frac{2\zeta(2K+1)}{(2\pi)^{2K+1}}\,
\frac{b^{-\sigma-2K}}{\sigma+2K}.
\]

The Dirichlet `L`-function is reduced to Hurwitz zeta by

\[
L(s,\chi)=N^{-s}\sum_{a=1}^{N-1}\chi(a)\,\zeta(s,a/N).
\]

Every factor is enclosed by exact rationals: `π` by Machin's formula, `log` by
the `atanh` series after a power-of-two reduction, `exp` by a reduced Taylor
series, and `sin`/`cos` by Taylor after a rigorous `2π` reduction. There is no
floating point in the computation layer.

The evaluator records every rational operation into a straight-line
certificate:

- **atoms** — the input `s`, rational constants, and the transcendental
  enclosures (the latter are proved in `Transcend.lean`);
- **ops** — the checkable cell: `add`, `sub`, `neg`, `scale`, `mul`, `inflate`,
  each with its declared output box.

The `ops` cell is replayed by an independent Python checker and kernel-checked
in Lean: `Expr.wf` recomputes every box and `Expr.wf_sound` proves that an
accepted certificate encloses the value it denotes.

## The eta cos/sin split

The same alternating handle used by the published `013` bundle is

\[
\eta(s)=\sum_{n\ge 1}(-1)^{n-1}n^{-s}=(1-2^{1-s})\zeta(s).
\]

Writing `s = σ + it` and `φ_n = t log n`,

\[
\Re\eta(\sigma+it)=\sum_{n\ge1}(-1)^{n-1}n^{-\sigma}\cos(t\log n),
\qquad
\Im\eta(\sigma+it)=-\sum_{n\ge1}(-1)^{n-1}n^{-\sigma}\sin(t\log n).
\]

The finite partial sums are formalised in `lean/Topic.lean`:
`etaPartial_re` and `etaPartial_im` prove the split exactly. At the first
zero the series does not vanish termwise — the cancellation is in the tail —
so the evaluator's tail bound, not the first hundred terms, is what certifies
the enclosure.

## Reconstructed objects and notation

| Object | Definition | Status in this folder |
|---|---|---|
| Rational interval | `Iv lo hi`, `lo ≤ x ≤ hi` over `ℚ` | Lean `IBox.Iv`, Python `rativ.Iv` |
| Complex rectangle | `Cx re im` | Lean `IBox.Cx`, Python `rativ.Cx` |
| Interval sum/product | endpoint arithmetic | Lean `Iv.mem_add`, `Iv.mem_mul`; Python `Iv.add`, `Iv.mul` |
| Certificate node | atom / add / sub / neg / scale / mul / inflate | Lean `Expr`, Python `partial_tail.Recorder` |
| Checker | recompute every box | Lean `Expr.wf`, Python `verify_certificate` |
| Euler–Maclaurin tail | `R_K` bound above | Source claims S1–S2; Python `tail_radius` |
| Eta cos/sin series | `etaCos`, `etaSin` | Lean `PST.etaCos`, `PST.etaSin` |
| Eta partial sum | `etaPartial` | Lean `PST.etaPartial` |
| Eta identity | `η(s) = (1−2^{1−s})ζ(s)` | Lean `PartialTail.eta_eq_one_sub_two_cpow_mul_zeta` (for `Re s > 1`) |
| `L(s,χ)` reduction | `N^{-s} Σ χ(a) ζ(s,a/N)` | Lean `PartialTail.LFunction_eq_hurwitz_sum`; Python `dirichlet_L` |

## Theorem ledger

Every row is proved in Lean with no `sorry`, `axiom` or `admit`.

| # | Statement | Lean name |
|---|---|---|
| T1 | Rational interval addition is sound. | `PartialTail.Iv.mem_add` |
| T2 | Rational interval negation is sound. | `PartialTail.Iv.mem_neg` |
| T3 | Rational interval subtraction is sound. | `PartialTail.Iv.mem_sub` |
| T4 | Rational scaling is sound. | `PartialTail.Iv.mem_scale` |
| T5 | Rational interval multiplication is sound. | `PartialTail.Iv.mem_mul` |
| T6 | Rational inflation is sound for `r ≥ 0`. | `PartialTail.Iv.mem_inflate` |
| T7 | The same six laws over `ℝ`. | `Iv.memR_add`, `memR_neg`, `memR_sub`, `memR_scale`, `memR_mul`, `memR_inflate` |
| T8 | Complex-box addition is sound. | `PartialTail.Cx.mem_add` |
| T9 | Complex-box negation is sound. | `PartialTail.Cx.mem_neg` |
| T10 | Complex-box subtraction is sound. | `PartialTail.Cx.mem_sub` |
| T11 | Complex scaling is sound. | `PartialTail.Cx.mem_scale` |
| T12 | Complex multiplication is sound. | `PartialTail.Cx.mem_mul` |
| T13 | Complex inflation is sound for `r ≥ 0`. | `PartialTail.Cx.mem_inflate` |
| T14 | Certificate checker soundness: an accepted certificate encloses its value. | `PartialTail.Expr.wf_sound` |
| T15 | A finite partial sum plus the shifted tail is the total. | `PST.tsum_eq_finite_add_tail` |
| T16 | The truncation residual is bounded by the tail norm. | `PST.truncation_residual_le_tail_norm` |
| T17 | The arbitrary finite-family tail bound. | `PST.truncation_residual_le_finset_tail_norm` |
| T18 | The three-tail residual bound. | `PST.truncation_residual_le_three_tails` |
| T19 | The imaginary part of a real sign power is `0`. | `PST.negOne_pow_im` |
| T20 | The real part of a sign power is the real sign power. | `PST.negOne_pow_re` |
| T21 | The real part of an eta term is `n^{-σ} cos(t log n)`. | `PST.etaTerm_re` |
| T22 | The imaginary part of an eta term is `-n^{-σ} sin(t log n)`. | `PST.etaTerm_im` |
| T23 | The real part of the eta partial sum is the cos series. | `PST.etaPartial_re` |
| T24 | The imaginary part is minus the sin series. | `PST.etaPartial_im` |
| T25 | The concrete `ζ(2)` replay is accepted and its final box encloses the value under the atom hypotheses. | `PartialTail.Replay.cert_mem` |
| T26 | `π` lies in its 20-digit rational interval. | `piIv_memR` |
| T27 | `exp` is enclosed on any interval `A ⊆ [-1,1]` by reduced Taylor plus `Real.exp_bound`. | `expIv_memR`, `expBox_memR` |
| T28 | `exp` is enclosed on an arbitrary interval by splitting into `k` parts. | `expIvGeneral_memR` |
| T29 | `log` is enclosed on every interval `A ⊆ [1,∞)` by the positive `log(1+a)` series and a geometric tail. | `logPartialQ_le_log`, `log_le_logPartialQ_add_rem`, `logIv_memR` |
| T30 | `sin` and `cos` are enclosed on `A ⊆ [-1,1]`, and on arbitrary intervals after a rigorous `2π` reduction. | `cosBox_memR`, `sinBox_memR`, `cosReduce_memR`, `sinReduce_memR` |
| T31 | Concrete checks: `log 2`, `exp 1`, `sin 1`, `cos 1` and `π` lie in their computed boxes. | `log_two_check`, `exp_one_check`, `sin_one_check`, `cos_one_check`, `piIv_check` |
| T32 | Every atom of the concrete ζ(2) replay is discharged; `cert_mem_closed` encloses `cert.eval σ` in `cert.box` with no atom hypothesis. | `Replay.cert_mem_closed` |
| T33 | `ζ(m) ≤ 1 + 1/(m−1)` for `m ≥ 2` (as a bound on the real part). | `PartialTail.riemannZeta_nat_re_le` |
| T34 | `η(s) = (1−2^{1−s})ζ(s)` for `Re s > 1`. | `PartialTail.eta_eq_one_sub_two_cpow_mul_zeta` |
| T35 | `L(s,χ) = N^{−s} Σ_{j≠0} χ(j) ζ(s,j/N)` for modulus `N ≠ 1`, as an erase-zero Hurwitz sum. | `PartialTail.LFunction_eq_hurwitz_sum` |

## Computation ledger

Every row is checked by the Python suite.

| # | Statement | Test / function |
|---|---|---|
| C1 | Rational interval arithmetic is exact. | `test_interval_arithmetic_is_exact` |
| C2 | `π` is enclosed to 64 bits. | `test_pi_bounds` |
| C3 | `log 2` and `exp 1` are enclosed. | `test_log_and_exp_bounds` |
| C4 | `sin(0.3)` and `cos(0.3)` are enclosed. | `test_sin_cos_bounds` |
| C5 | Bernoulli numbers are exact. | `test_bernoulli_numbers` |
| C6 | The tail radius decreases with `K`. | `test_tail_radius_positive_and_decreasing` |
| C7 | `ζ(2)` enclosure contains `π²/6`. | `test_zeta2_enclosure_contains_pi_squared_over_six` |
| C8 | `L(2,χ₄)` enclosure contains Catalan's constant. | `test_L2_chi4_enclosure_contains_catalan` |
| C9 | `η(1/2+iγ₁)` enclosure contains `0`. | `test_eta_enclosure_at_first_zero_contains_zero` |
| C10 | The eta cos/sin enclosures have finite rational width. | `test_eta_cos_sin_enclosure_widths_are_finite` |
| C11 | A certificate round-trips through the independent checker. | `test_certificate_roundtrip` |
| C12 | Invalid domains are rejected. | `test_invalid_domain_is_rejected` |
| C13 | Complex-box arithmetic is exact. | `test_complex_box_arithmetic` |
| C14 | Inflation widens by exactly `r`. | `test_inflate_is_sound` |

## Recorded source results

The source bundle reports these enclosures (its `verify/check_values.log`); they are quoted, not re-run by this folder.

| Enclosure | Source width |
|---|---|
| `ζ(2) = π²/6` | ≤ `2e-19` |
| `ζ(3)` | ≤ `4e-20` |
| `ζ(4) = π⁴/90` | ≤ `2e-20` |
| `L(2,χ₄)` (Catalan) | ≤ `3e-19` |
| `L(3/2,χ₃)` | ≤ `3e-19` |
| `L(2,χ₃)` | ≤ `4e-19` |
| `0 ∈ [ζ(1/2 + 14.1347…i)]` | ≤ `5e-17` |
| `L(1/2 + 10i, χ₃)` | ≤ `4e-17` |

## Transcendental library

`lean/Transcend.lean` closes the analytic gap. It proves, with no trusted
leaves:

| Function | Method | Coverage |
|---|---|---|
| `π` | Mathlib 20-digit `Real.pi_gt_d20` / `pi_lt_d20` | all |
| `exp` | reduced Taylor polynomial + `Real.exp_bound`, then `k`-fold scaling | all rational intervals |
| `log` | `Real.hasSum_log_one_add` (positive series in `a/(a+2)`) + geometric tail | intervals with `lo ≥ 1` |
| `sin`, `cos` | `Complex.exp_bound` on the `2π`-reduced argument; real and imaginary parts give `cos`/`sin` | all rational intervals |

The concrete theorems are `piIv_memR`, `expIvGeneral_memR`, `logIv_memR`,
`cosBox_memR`, `sinBox_memR`, `cosReduce_memR` and `sinReduce_memR`. The
checks `log_two_check`, `exp_one_check`, `sin_one_check`, `cos_one_check` and
`piIv_check` are kernel-checked instances. The concrete ζ(2) replay already has
every atom discharged (`ReplayAtoms.lean`, `cert_mem_closed`). What remains is
to wire the general transcendental theorems into a `Replay` for arbitrary `s`,
and to use a certified enclosure as a hypothesis in a theorem about a wall.
The Euler–Maclaurin formula and its tail bound have a written proof but remain
unformalised in Lean, so the final Lean enclosure of `ζ(s)` is still
conditional on S1–S2, not on the transcendentals.

## Source claims (not Lean-formalised)

| # | Claim | Status |
|---|---|---|
| S1 | Euler–Maclaurin decomposition of `ζ(s,a)` above. | Lean-proved for `K ≥ 1` (`hurwitzZetaNP_eq_eulerMaclaurin`) |
| S2 | Explicit tail bound `\|R_K\| ≤ …`. | Lean-proved for `K ≥ 1` (`hurwitzZetaNP_eulerMaclaurin_with_bound`) |

The former claims S3–S7 are now Lean theorems rather than source claims:
S3 is T33 (`riemannZeta_nat_re_le`), S4 is T34
(`eta_eq_one_sub_two_cpow_mul_zeta`), S5 is T35
(`LFunction_eq_hurwitz_sum`), the transcendental enclosures S6 are T26–T31
(`Transcend.lean`), and the rational cell S7 is T14 and T32.

## Open items

1. **Euler–Maclaurin formula.** The `exp`/`log`/`sin`/`cos` enclosures are
   proved in `Transcend.lean`, and the atom hypotheses of the concrete ζ(2)
   replay are discharged in `ReplayAtoms.lean` (`cert_mem_closed`). What
   remains is S1–S2: the identity that the replay value is `ζ(s)` and the
   explicit tail bound. Both now have a written proof in
   [`notes/euler-maclaurin-proof.md`](notes/euler-maclaurin-proof.md), but they
   are still not Lean theorems. S3–S5 are Lean theorems in `SourceClaims.lean`
   (T33–T35).
2. **Use as a hypothesis.** No theorem about either wall yet consumes a
   certified enclosure. Wiring the general transcendentals into a `Replay`
   for arbitrary `s` and using that replay in a finite-scale theorem is the
   integration task recorded as R14 in the letter.
3. **Width, not just soundness.** `inflate` accepts any `r ≥ 0`, so the
   narrow widths are Python measurements, not Lean theorems. R15 records the
   target: a checked width bound.
4. **Derivatives.** `partial_tail.py` encloses values, not `L'/L`; adding
   derivatives costs a `div` soundness lemma and differentiated tail atoms.
5. **`s = 1`.** The individual Hurwitz terms have a pole that cancels only in
   the `Σ χ(a)` sum; `L(1,χ₃)` is checked at `3/2` instead.
6. **Larger certificates.** The 64-bit certificates are exact rationals; the
   largest in the source bundle is about 115 kB.

## Python layer

```
cd the-final-letter/topics/partial-sum-plus-tail
python3 -m pytest -q tests
```

`python/programme.py` is the clean API; `python/rativ.py` is the exact
interval engine; `python/partial_tail.py` is the Euler–Maclaurin evaluator;
`python/verify_certificate.py` is the independent checker; `python/to_lean.py`
emits a Lean replay.

Example:

```python
import programme as P
P.zeta_enclosure(2, 2, 0, 0, M=20, K=8)   # contains pi^2/6
P.L_enclosure([0, 1, 0, -1], 2, 2, 0, 0)  # contains Catalan
P.eta_enclosure("1/2", "1/2", "14.134725…", "14.134725…")
```

## Lean layer

```
cd the-final-letter/topics/partial-sum-plus-tail
./lean/check.sh
```

`lean/IBox.lean` is the rational/complex interval layer; `lean/Expr.lean` is
the certificate language and `wf_sound`; `lean/Replay.lean` is a concrete
ζ(2) replay; `lean/ReplayAtoms.lean` discharges its atom boxes; `lean/Topic.lean` adds the transport lemmas and the eta cos/sin
split; `lean/SourceClaims.lean` proves the zeta bound, the eta identity and
the `L`-reduction. `lean/EulerMaclaurin.lean` starts the Euler–Maclaurin
formalisation: it defines the periodic Bernoulli functions and a non-periodic
Hurwitz zeta, proves that the latter is the ordinary Hurwitz series for
`Re s > 1`, and proves the `K = 0` finite Euler–Maclaurin identity and the interior derivative of the periodic Bernoulli functions, the polynomial integration-by-parts identity for the unit intervals, the raw unit-interval recursion, the global recursion obtained by summing over adjacent intervals, and its odd specialisation. The finite Euler–Maclaurin induction, Fourier inversion and the
analytic continuation are still open. The recorded build is
`[check] OK IBox.lean`, `[check] OK Expr.lean`, `[check] OK Transcend.lean`,
`[check] OK Replay.lean`, `[check] OK ReplayAtoms.lean`, `[check] OK Topic.lean`,
`[check] OK SourceClaims.lean`, `[check] OK EulerMaclaurin.lean` in
[`lean/BUILD.log`](lean/BUILD.log).

No `sorry`, no `axiom`, no `admit`.

## Provenance and links

- Source bundle: `~/workspace/rh/research/twin-prime-parity/012/`; harvest map: [`SOURCE.md`](SOURCE.md).
- Published snapshot: `~/workspace/rh/research/publish/013-twin-prime-parity-explicit-function/`
  (`notes/004-eta-cos-sin.md`, `python/eta_interval.py`, `python/ivmath.py`).
- The rational replay layer (`IBox.lean`, `Expr.lean`) is vendored from the
  012 bundle; the Python engine is vendored from `012/rigorous/`.
- Programme standard: [`../PROGRAMME-STANDARD.md`](../PROGRAMME-STANDARD.md).
- Topic index: [`../README.md`](../README.md).
- The Final Letter: [`../../index.html`](../../index.html).

[Back to the topic index](../README.md) · [The Final Letter](../../index.html)
