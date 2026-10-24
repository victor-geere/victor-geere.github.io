# `010/verify/` — criteria dispositions

This file records the formal disposition of the auditor's checks that were found to be
**over-strong or unsatisfiable criteria of the original task prompt** rather than defects
of the round. A disposition is a verdict on the *criterion*; the refutation itself is the
correct outcome and stays on the record.

The auditor's scoring in [`independent_check.py`](independent_check.py) /
[`independent_check.log`](independent_check.log) is **not** rewritten: it remains the
historical artifact of the audit as run. The dispositions below are what closes the
criteria in the programme's ledgers ([`../truths.md`](../truths.md),
[`../handoff.md`](../handoff.md), [`../README.md`](../README.md),
[`../../checks/06-numerical-checks.md`](../../checks/06-numerical-checks.md)).

---

## C4.1 — RETIRED (over-strong criterion)

**The criterion.** *"The sharp Dirichlet partial sum resolves the zero at `t₁` to within
`10⁻³` with `N ≤ 10⁶` — the claim `N ≳ T² = 200` suffices."*

**Disposition.** **RETIRED.** This is a criterion of the task prompt, not a claim of the
round, and it is unsatisfiable by the instrument it names:

* `Re S_N(t₁) = 0.644, 6.986, 12.539, 36.052` at `N = 10³, 10⁴, 10⁵, 10⁶`; no sign change
  within `10⁻³` of `γ₁`, and the magnitude **grows** like `≈ 0.04√N` — the Dirichlet
  series does not converge on `Re s = 1/2`, so a sharp cutoff cannot be pushed to the
  claimed accuracy at any `N`.
* The correct instrument is the `Z`-function / explicit-formula route, which the same
  audit confirms in **C4.2** (the zero is located with `O(T)` `ζ`-evaluations,
  independent of `N`). That route is what `010/` uses: see
  [`../rigorous/certify_zeros.py`](../../../publish/013-twin-prime-parity-explicit-function/python/certify_zeros.py) and
  [`../rigorous/certify_unique.py`](../../../publish/013-twin-prime-parity-explicit-function/python/certify_unique.py).

**Witness (reproducible).** `verify/independent_check.py`, the C4.1 block:
`|Re S_N(t₁)|/√N = 0.0204, 0.0699, 0.0396, 0.0361` at `N = 10³…10⁶`, none resolving the
root; `T² = 199.8` is far too optimistic.

**Closure.** Recorded as retired in [`../truths.md`](../truths.md) and
[`../handoff.md`](../handoff.md) §6 item 4. No further work is required.

---

## C1e — RETIRED (unsatisfiable as stated); RESTATED as C1f

**The criterion.** *"C1(ii): the Cauchy kernel `F(t) = 1/(1/4+t²)` with
`g(u) = (π/2)e^{−|u|/2}` is verified to ≥ 20 digits."*

**Disposition.** **RETIRED**, for three independent reasons (all recorded in
[`independent_check.log`](independent_check.log)):

1. the stated pair `(F, g)` is **not a Fourier pair** — `∫ g(u)e^{itu}du = (π/2)F(t)`, so
   the stated `F` is `2/π` times the transform of the stated `g`;
2. at `a = 1/2` the pole term `π(U+1)` and the prime sum `π Σ_{n≤N} Λ(n)/n` each
   **diverge** like `π log N` (`U = log N`); the two divergent pieces cancel to a finite
   limit `π(1+γ)`, so the literal right-hand side is not even defined as a limit of
   finite truncations;
3. the zero side converges only like `log G/G`, so 20-digit agreement would need
   `G ∼ 10²¹` zeros.

**Restatement (the standing requirement).** The corrected, convergent companion is
[`C1f`](independent_check.py): `a = 1 > 1/2`, `g(u) = (π/2)e^{−|u|}`, `φ(t) = π/(1+t²)`.
It satisfies the corrected Weil identity within its stated zero-side truncation bound
(`|residual| < 2 ×` density estimate), i.e. at the **~2-digit level** — the Cauchy family
is verifiable only that far because its zero-side tail is `log G/G`. That ~2-digit
attainment *is* the correct outcome for this kernel; the 20-digit demand of C1(ii) cannot
be met by it.

**Closure.** Recorded as retired+restated in [`../truths.md`](../truths.md) and
[`../handoff.md`](../handoff.md) §6 item 4. No further work is required.

---

*Generated as part of the tractability passes over [`../../../TODO.md`](../../../TODO.md)
(items T5, T4 and their successors).*
