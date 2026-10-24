# lean — T14 (the three thresholds `pN < pP < p*`)

Lean 4 formalisation of `theorems/tpp-rh42-handoff-three-thresholds.md`,
the ledger row T14 of `research/twin-prime-parity/rounds/rh42/HANDOFF.md` §5.3.

**Status: complete.**  `./check.sh --all` is green and there is **no `sorry`** anywhere.

## The theorem

```lean
theorem tpp_rh42_three_thresholds (pP pN pstar : ℝ)
    (hP : BPos pP = 1) (hN : BNeg pN = 2) (hstar : ZetaR pstar = 2) :
    pN < pP ∧ pP < pstar
```

with the concrete rh42 budgets

    ZetaR p = Σ_{k≥1} k^{-p} ,   BPos p = P p = 2^{-p} ZetaR p ,   BNeg p = N p = Σ_{k≥0} (2k+3)^{-p}

so `pP` is the crossing `P pP = 1`, `pN` the crossing `N pN = 2` and `p*` the crossing
`ZetaR p* = 2`.  (The source's negative *budget* is `N p - 1`, so `N pN = 2` is the ledger's
`(1−2^{−p}) ζ(p) = 3`; the source states `pN = 1.3778…` for the neighbouring normalisation
`(1−2^{−p}) ζ(p) = 2`, i.e. budget `= 1`.  Both are the same series crossing `N`, and the
ordering asserted by T14 is what is proved here.)

## How the ordering is obtained

Everything is monotonicity plus five certified brackets; no continuity and no numeric ζ is used.

1. **Gap (1) — `N p < P p` on `(1, ∞)`** (`BNeg_lt_BPos`).  The two budgets are the same sum
   split by parity: `N p = Σ_k (2k+3)^{-p}` (odd denominators from 3) and
   `P p = 2^{-p} ζ(p) = Σ_k (2k+2)^{-p}` (even denominators).  Termwise `2k+3 > 2k+2`, so every
   odd term is strictly smaller (`odd_lt_even`), and `Summable.tsum_lt_tsum` upgrades this to the
   strict series inequality.  `BNeg_strictAnti` and `BPos_strictAnti` are the corresponding
   termwise/factorwise antitonicities.
2. **Gap (2) — certified ζ brackets from exact integer arithmetic** (`ZetaR_7_5_lt`,
   `ZetaR_4_3_gt`, `ZetaR_3_2_gt`, `ZetaR_3_2_lt`).  `fpow num den k` is a fuel-recursive binary
   search for `⌊10^9 / k^{num/den}⌋`, verified once and for all by `go_spec`
   (`fpow_valid` / `fpow_max`); `sumF num den N` is the corresponding integer partial sum.  The
   bridges `sumF_le_zetaR_partial` / `zetaR_partial_le` move between an integer sum and
   `10^9 · Σ_{k≤N} k^{-num/den}`, and `tail_finite` / `tsum_tail_le` (Mathlib's integral test,
   `AntitoneOn.sum_le_integral_Ico`) bounds the tail.  The numeric side conditions are discharged
   by `native_decide` on the `ℕ` certificates and `norm_num`.
3. **Assembly.**  `pP > 4/3`, `1 < pP` (`one_lt_of_BPos_eq`), hence gap (1) at `pP` gives
   `N pP < 1`; since `N pN = 2` and `N` is strictly antitone, `pN < pP`.  Separately
   `P (3/2) < 1 = P pP` gives `pP < 3/2`, and `ZetaR (3/2) > 2 = ZetaR p*` gives `3/2 < p*`;
   hence `pP < p*`.

## Layout

| file | contents |
|---|---|
| `TppLean/Core.lean` | `IsThreshold`, `CrossesOnce`, `BudgetHyp`, abstract `threshold_ordering` |
| `TppLean/Budget.lean` | `ZetaR`, `BPos`, `BNeg`, summability, `ZetaR_strictAnti` |
| `TppLean/ThreeThresholds.lean` | the oracle, the integral tail, the bridges, the four ζ brackets, gap (1), and `tpp_rh42_three_thresholds` |

## Build

```
cd lean
./check.sh --all
```

Elaborates against the Mathlib checkout at `$LEAN_PREFIX` (default `$HOME/lean`); `check.sh`
rebuilds `LEAN_PATH` from `lake env`, so no `lake` project file is needed in this directory.
Toolchain: Lean `v4.35.0-rc2`.  Note that `mathlib`'s `riemannZeta : ℂ → ℂ` has neither
monotonicity nor numeric bounds, which is why the real Dirichlet series `ZetaR` is used instead.
