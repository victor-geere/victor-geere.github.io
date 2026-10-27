## 10. Generalisations and attempts — `007`, `008`, `009`

| result | statement | status | Lean proof |
|---|---|---|---|
| character-weighted limit law | `Φ_c(p,n) → F_r(e^{−p/n})`, `F_r(x) = f_r(x)/(1−x^q)` | PROVED (Lean) | [`hasSum_F_of_periodic`](Op57/Blocks.lean#L50), [`F_eq_fblock`](Op57/Blocks.lean#L128) |
| parity leading equation | `x = 1/√2` (even `r`), `x = (√5−1)/2` (odd `r`) | PROVED (Lean) | [`leading_forced_parity_even`](Op57/Leading.lean#L66), [`leading_forced_parity_odd`](Op57/Leading.lean#L74) |
| `χ₃`, `χ₄` have no threshold | `F_r < 1` on `[0,1)` for all residues | PROVED (Lean) | [`chi3_no_leading_threshold`](Op57/Obstruction.lean#L147), [`chi4_no_leading_threshold`](Op57/Obstruction.lean#L153) |
| shift-2 split | `S(x,2) = S(⌊x/2⌋,1) + C(⌊(x+1)/2⌋)`, `C(K)=Σ_{k≤K} λ(4k²−1)` | PROVED (Lean) | [`Sh2_split`](Op58/Split.lean#L65), [`Ccore_eq_poly`](Op58/Split.lean#L56) |
| λ on the polynomial core | `liouville_pair`, `poly_identity`, `even_shift` | PROVED (Lean) | [`Op58/Defs.lean`](Op58/Defs.lean#L60) |
| sparse-pair bound | `\|Σ aₙ(wₙw_{n+2}−1)\| ≤ 2·#{crossings}` | PROVED (Lean) | [`sparse_pair_bound`](Op59/Sparse.lean#L42) |
| angle twist invisible | twist changes the correlation by `O(θ(N+2)/c)` | PROVED (Lean) | [`angle_twist_invisible`](Op59/Phase.lean#L123), [`phaseCrossing_card_le`](Op59/Phase.lean#L109) |

**Verdicts (paper, not Lean):** `007` — the OP-5 second-order expansion survives for
character sums, but the leading equation fails for `χ₃`, `χ₄` (29.7 % of 4537
`(χ,r)` pairs have a root). `008` — the automorphic/spectral input **does not** break
parity over ℚ (`L(s,λ)=ζ(2s)/ζ(s)` has no automorphic object; parity is broken over
`𝔽_q[T]` by Sawin–Shusterman but does not transfer). `009` — a sign either preserves
the pair cancellation (uninformative) or destroys it (useless); the parity barrier
stands.
