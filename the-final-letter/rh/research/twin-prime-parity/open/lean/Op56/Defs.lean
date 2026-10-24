/-
  Op56/Defs.lean — the objects of OP-5 and OP-6.

  Fixes the alphabet convention of the `open/` notes and the Python ground truth
  (`op06_reachable_fraction.py`).  Proofs begin in `Op56/Exact.lean`.

  ## The alphabet

  The *positive half-series* of the twin-prime-parity programme is

      a_k = (2k)^(-p),        k = 1, 2, 3, …        (the notes' 1-based index k)

  with budget `P(p) = ∑_{k ≥ 1} a_k = 2^(-p) ζ(p)` and tail
  `T_n = ∑_{k ≥ n} a_k`, `n ≥ 1`.

  ## Indexing (0-based in Lean)

  We use the equivalent 0-based sequence

      term p n = b_n = a_{n+1} = (2 (n+1))^(-p) ,      n = 0, 1, 2, …

  with the dictionary

      n_min^{1-based} = N + 1 ,      T^{1-based}_{n_min} = tailSum p N ,
      measure(S_1)    = 2^(n_min - 1) · T^{1-based}_{n_min} = 2^(nmin p) · tailSum p (nmin p) .

  With `N = n_min - 1` the last line is exactly rh42 Thm 10.
-/

import Mathlib

namespace Op56

noncomputable section

open scoped BigOperators Topology

/-- The 0-based positive half-series `b_n = (2 (n+1))^(-p)` (the notes' `a_{n+1}`). -/
def term (p n : ℕ) : ℝ := (2 * ((n : ℝ) + 1)) ^ (-(p : ℝ))

/-- The budget `P(p) = ∑_{n ≥ 0} b_n = 2^(-p) ζ(p)`. -/
def budget (p : ℕ) : ℝ := ∑' n : ℕ, term p n

/-- The tail `T_N = ∑_{n ≥ N} b_n` (0-based; equals `T_{N+1}^{1-based}`). -/
def tailSum (p N : ℕ) : ℝ := ∑' n : ℕ, term p (N + n)

/-- Brown's criterion at index `N`: `b_N ≤ ∑_{n > N} b_n = T_{N+1}`. -/
def IsComplete (p N : ℕ) : Prop := term p N ≤ tailSum p (N + 1)

/-- `Φ_p(n) = ∑_{j ≥ 1} (1 + j/n)^(-p)`, the normalised boundary form of OP-5; the
threshold equation is `Φ_p(n) = 1`.  Here `n` is the notes' 1-based index. -/
def Phi (p : ℝ) (n : ℕ) : ℝ := ∑' j : ℕ, (1 + (((j : ℝ) + 1) / (n : ℝ))) ^ (-p)

/-- `p` is the OP-5 threshold of the 1-based index `n`: `Φ_p(n) = 1`. -/
def IsThreshold (n : ℕ) (p : ℝ) : Prop := Phi p n = 1

/-- `x` is writable with the positive half alone (a sub-sum of `(b_n)`). -/
def IsReachable (p : ℕ) (x : ℝ) : Prop :=
  ∃ s : Finset ℕ, x = ∑ n ∈ s, term p n

/-- The reachable set `S_1` of the positive half-series. -/
def reachableSet (p : ℕ) : Set ℝ := {x | IsReachable p x}

/-- The OP-5 threshold asymptotic, 0-based: `nmin p ≈ p/log 2 - 5/2`. -/
def nminAsym (p : ℕ) : ℝ := (p : ℝ) / Real.log 2 - 5 / 2

/-- The OP-5 closed-form threshold sequence, 1-based index `n`:
`(n + 3/2) log 2 + c/n`, `c = 3 (log 2)² - (25/12) log 2`. -/
def thresholdAsym (n : ℕ) : ℝ :=
  ((n : ℝ) + 3 / 2) * Real.log 2
    + (3 * (Real.log 2) ^ 2 - (25 / 12) * Real.log 2) / (n : ℝ)

/-- The OP-6 leading expression `p log p - (1 + log log 2) p`. -/
def LAsym (p : ℕ) : ℝ := (p : ℝ) * Real.log p - (1 + Real.log (Real.log 2)) * (p : ℝ)

end

end Op56
