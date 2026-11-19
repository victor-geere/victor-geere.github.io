# F2/O4 status: recurrence and closed description

## Proved

- The first component is exactly `[α_n, α_{n-1})` (T62).
- The second-band component is exactly
  `[π/2 + π/(n+2), π/2 + π/(n+1))` (T68–T69).
- The general single-previous-selection component is exactly
  `[α_j + α_n, α_j + α_{n-1})` under the band hypotheses (T70–T72).
- A single-previous-selection component with first index `j ≥ 1` exists when
  `j(j+3) < n` (T116).
- The accumulated angle is the sum of selected angles: `A_n(θ) = ∑_{k<n, δ_k=1} α_k`
  (T117), and digit `n` is selected exactly when that sum plus `α_n` is at most
  `θ` (T118). If exactly `j` and `k` are selected before `n`, the criterion is
  `α_j + α_k + α_n ≤ θ` (T119). For an arbitrary finite selected set `s`, the
  criterion is `∑_{k∈s} α_k + α_n ≤ θ` (T120).

## O3 density consequence

For `n ≥ 1`, at most one selection lies in `[n, 2n+1]` (T121), hence at most
one selection lies in each dyadic block `[2^m, 2^(m+1)-1]` (T122). Mapping each
selection to its dyadic block index is injective, giving the global bound
`D(N) ≤ log₂ N + 1` (T123). O3 is closed.

## Closed description

A component may contain several earlier selected indices. The general component
is the interval
\[
\Big[\sum_{r} \alpha_{j_r} + \alpha_n,\
      \sum_{r} \alpha_{j_r} + \alpha_{n-1}\Big),
\]
where `j_1 < ... < j_m < n` are the selected indices before `n` and no other
digit is selected. The accumulator identity and the general component criterion are now proved
(T117–T120). The component count is not the simple quadratic `2k` formula: the
exact jump table through `n=155` is recorded as C12. A proved count formula for
all `n` remains a separate extension.

The single-selection case T70–T72 and the existence criterion T116 are the
first two layers of this induction.
