# Audit and change log

This is the durable log for changes to the O6 exactness audit and for the
O7 continuation work it covers. It records what changed, which audit rows were
affected, and the verification performed. It is not a theorem ledger.

## 2026-11-03 — O6 audit created

- Added [`EXACTNESS-AUDIT.md`](EXACTNESS-AUDIT.md) with the decision rule,
  classification legend and matrix.
- Added [`python/audit.py`](python/audit.py) as the machine-readable matrix.
- Added [`tests/test_audit.py`](tests/test_audit.py) to validate identifiers,
  classes, summaries and the presence of every row in the markdown table.
- Initial audit: **18 objects** (A1–A18).
- Classification summary at that point: E1 = 6, E2 = 7, E3 = 2, X = 1,
  F = 1, O = 1.
- Marked O6 closed in README and index.html.

## 2026-11-03 — O7 continuation integrated

- `lean/Continuation.lean` (added by the O7 session) extends the annular/Mellin
  method beyond the critical strip:
  - T53–T55: sharp first-order bound, convergence/holomorphy on `−1 < Re s`,
    and the extended identity on `−1 < Re s` away from `0,1`;
  - T56–T57: the completed annular part equals `Λ₀`, and the completed
    functional equation is an integral identity;
  - T58–T63: the second Bernoulli subtraction reaches `−3 < Re s`, with the
    `−1/(12(s+1))` pole term explicit and the `s = −1` pole cancelled.
- Audit extended with four rows:
  - **A19** once-subtracted annular continuation — **E3**;
  - **A20** completed annular part / functional equation — **E3**;
  - **A21** second Bernoulli subtraction on `−3 < Re s` — **E3**;
  - **A22** general `k`-th Bernoulli subtraction / full-plane finite part —
    **O**.
- Updated audit summary: **22 objects**; E1 = 6, E2 = 7, E3 = 5, X = 1,
  F = 1, O = 2.
- Updated README/index:
  - O6 row now says 22 objects (A1–A22);
  - O7 marked **Closed** for the doubled/tripled-strip continuation and the
    FE integral identity;
  - new **O8** records the still-open general `k`-th Bernoulli subtraction and
    full-plane finite part;
  - A22 points to O8.
- Updated tests to expect 22 audit rows and the new class counts.

## Verification

```bash
python3 -m pytest tests -q
# 20 passed

./lean/check.sh
# all eight Lean files green
```

No `sorry`, `admit` or `axiom` is present in the Lean files.

**No RH proof yet.** O7 is a continuation of the finite-part annular identity,
not a proof of the Riemann hypothesis.

## 2026-11-03 — Lean code aligned with audit evidence

The audit identified four rows whose evidence was text-only or incomplete.
All four were formalised in `lean/Topic.lean`:

- **A4** normalized halving-sector total:
  `half_turn_sector_hasSum`, `half_turn_sector_tsum` (T64);
- **A6** exact divergence of reciprocal weights:
  `not_summable_inv_nat_succ` (T65);
- **A16** infinite complex geometric series:
  `geometric_hasSum_complex`, `geometric_tsum_complex` (T66);
- **A18** layer-cake representation:
  `layer_cake` (T67).

No audit classification changed, so the summary remains 22 objects:
E1 = 6, E2 = 7, E3 = 5, X = 1, F = 1, O = 2.

The theorem ledger now runs to T67. The Lean build and pytest suite were
re-run after the change.

## 2026-11-03 — O5 Bost–Connes closure

Added `lean/BostConnes.lean` and extended the audit:

- **A23** single-prime Bost–Connes angular series — **E1**;
- **A24** all-prime Bost–Connes Euler product — **E2**;
- **A25** prime-log commensurability obstruction — **X**.

New theorems T68–T72:

- `bostConnes_single_prime_angular`, `bostConnes_single_prime_tsum`;
- `bostConnes_all_primes_product`, `bostConnes_all_primes_tprod`;
- `log_primes_not_commensurable`.

O5 is marked **closed** for the exact convergence-domain angular sums and the
commensurability obstruction. The audit summary is now **25 objects**:
E1 = 7, E2 = 8, E3 = 5, X = 2, F = 1, O = 2. O8 remains open.

## 2026-11-03 — finite Gram positivity formalised

Added `lean/Gram.lean` with T73–T76:

- `gramQuad_eq_norm_sq` — the Gram quadratic form is a squared norm;
- `gramQuad_nonneg` — finite Gram positivity;
- `gramMatrix_posSemidef` — every finite Gram matrix is PSD;
- `gramMatrix_quadForm_nonneg` — matrix quadratic form nonnegativity.

This is the finite algebraic shadow suggested by the Gram matrix in
`absolute-polarized-hodge-index-realization`. It applies to annular/sector
indicator vectors but does **not** prove the analytic Weil positivity
statement. O4 therefore remains open; its row now points to the finite shadow
T73–T76 while retaining the analytic gap.

## 2026-11-03 — continuous Hurwitz-zeta coil formalised

Added `lean/ContinuousCoil.lean` with T77–T80:

- `hasSum_shiftedZetaKernel` — the shifted geometric kernel;
- `hasSum_mellin_shiftedZetaKernel` — the shifted Mellin series;
- `mellin_shiftedZetaKernel_eq` — the Hurwitz-zeta integral representation;
- `continuousCoil_eq_integral` — the continuous coil as a normalized integral.

This formalises the section-2 integral representation and the replacement of
the discrete annular coil by a continuous spiral for `x > 0`, `Re s > 1`.
Analytic continuation beyond `Re s > 1` remains outside the statement.
