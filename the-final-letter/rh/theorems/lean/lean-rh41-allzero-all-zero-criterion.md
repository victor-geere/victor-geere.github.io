# Claim A2 — the all-zero factor criterion

**Kind:** Theorem
**Status:** PROVED (Lean, no sorry)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh41/lean/Rh41/AllZero.lean`](../../research/twin-prime-parity/rounds/rh41/lean/Rh41/AllZero.lean) — lines 39–42, declaration `Rh41.allZero_iff_hasLargeGap`

## Statement

> **Claim A2.** A window of length `L` avoiding the support exists exactly when the shifted extended support has a consecutive gap `≥ L + 1`.

`TRUTHS.md` §2 lists as *checked* (95 835 cases):

> The all-zero factor occurs **iff** some gap between consecutive support points — or before the first / after the last — is `≥ L+1`.

Formally (Lean 4 / Mathlib):

```lean
theorem allZero_iff_hasLargeGap (S : Finset ℕ) (N L : ℕ) (hS : S ⊆ range N)
    (hL1 : 1 ≤ L) (hLN : L ≤ N) : AllZero S N L ↔ HasLargeGap S N L
```

where

```lean
def AllZero (S : Finset ℕ) (N L : ℕ) : Prop :=
  ∃ t, t ≤ N - L ∧ ∀ a ∈ S, ¬ (t ≤ a ∧ a ≤ t + L - 1)

def HasLargeGap (S : Finset ℕ) (N L : ℕ) : Prop :=
  ∃ a ∈ extSupport S N, ∃ b ∈ extSupport S N,
    a < b ∧ (∀ c ∈ extSupport S N, a < c → c < b → False) ∧ L + 1 ≤ b - a
```

## Hypotheses and notation

- `S : Finset ℕ` with `S ⊆ range N` — support contained in the truncation.
- `1 ≤ L` and `L ≤ N` — window length inside the truncation.
- `extSupport S N = {0} ∪ {s + 1 : s ∈ S} ∪ {N + 1}` — the Python list `[-1] + ones + [N]` shifted up by one ("a bijection on gaps", per the header). Its consecutive gaps are exactly `a_0 + 1`, the consecutive differences `a_{j+1} - a_j`, and `N - a_m`.
- `AllZero S N L` — a length-`L` window inside the truncation meets no support point.

## Proof / evidence

Complete Lean proof, no `sorry`/`admit`, no new axioms — declaration `Rh41.allZero_iff_hasLargeGap` in `Rh41/AllZero.lean` (lines 41–115).

- (⇒) A window avoiding `S` is bracketed by the largest extended-support point `≤ t` and the smallest `> t` (via `max'`/`min'` on filtered finsets); those are consecutive and their distance is `≥ L + 1`.
- (⇐) A consecutive gap `≥ L + 1` contains a window start `a` with `a + L ≤ N` that avoids the support.

The auxiliary `mem_extSupport` (line 35) characterises membership in `extSupport` and is used only by this proof.

## Dependencies and related results

- [`Rh41.DigitWord`](lean-rh41-digitword-main-complexity-law.md) — the shared `factor`/`complexity` layer; the criterion itself is proved independently of it.

## Notes

- The header records the upgrade: the criterion is listed in `TRUTHS.md` §2 as *checked* over 95 835 cases, and "this file proves it for all supports, truncations and window lengths".
- `extSupport` and `AllZero`/`HasLargeGap` are definitions in the same file; only the equivalence is a harvested result.
