/-
  Rh47 — root module of the rh47 Lean development.

  The module `Rh47.Sparse` formalises the corrected sparse-modification bound of
  rh47 (register item OP-12):

  * `sparseLiouville` / `corrSparse` — the sign modification of `λ` on a finite
    index set `A` and its two-point correlation;
  * `corrSparse_sub_corr_abs_le` — the sharp bound
    `|S_A(x) − S(x)| ≤ 2·#{n ≤ x : n ∈ A ∨ n + h ∈ A}`;
  * `corrSparse_sub_corr_abs_le_four` — the registered corollary
    `≤ 4·#{m ≤ x + h : m ∈ A}`;
  * `rh46_sparse_bound_false` — the rh46 form `2·#{n ≤ x + h : n ∈ A}` is
    **false**, witnessed by `A = {5}`, `h = 2`, `N = 5`;
  * `corrSparse_bound_sharp` — the sharp bound is attained at that witness.

  It imports the certified `Rh46.Chowla` slice layer (including the OP-11 lemma
  `Rh46.corrSlice_sub_corr_self_eq`).  There is no `sorry`, no `axiom` and no
  `native_decide`.

  The module `Rh47.Parity` formalises register item O12, *sign-blindness as a
  theorem*, in the restricted setting of small-prime residue conditions:

  * `sieveWeight` — the sign-blind linear-sieve weight family
    `n ↦ ∑_{d ∈ D} c d · 1_{d ∣ n}`, fixed by divisibility conditions alone;
  * `sieveLam_collapse` — the exact parity collapse
    `∑_{n ≤ N} w(n) λ(n) = ∑_{d ∈ D} c d · λ(d) · (∑_{m ≤ N/d} λ(m))`:
    every such weight sees `λ` only through the one-point sums;
  * `sieveLam_abs_le` — the quantitative bound: a sign-blind weight cannot beat
    the one-point decay by more than the factor `∑_d |c d|`;
  * `sieveLam_vanishes` — the parity principle: if the one-point sums vanish
    (PNT, the `k = 1` Chowla case, carried as `LiouvilleVanishes`), then *every*
    sign-blind weight has `o(N)` `λ`-correlation;
  * `corr_twist_two` — the index-parity twist is invisible to the `h = 2`
    correlation, proved (rh47's `0/10^6`-mismatch identity).
-/
import Rh47.Sparse
import Rh47.Parity
