# Lean layer — hst-transfer-operator

`Topic.lean` is the proved finite core. It contains no `sorry`, `axiom` or
`admit`, and defines:

- `greedyT`, `branch0`, `branch1`: the normalised greedy map and its inverse
  branches.
- `weight`, `greedyL`, `greedyLInf`: the archived two-branch transfer operator,
  its finite truncation and its infinite sum.
- `greedyL_add`, `greedyL_smul`, `greedyL_const`, `greedyL_abs_le`,
  `greedyL_uniform_bound`, `greedyL_tendsto`, `greedyLInf_abs_le`: the finite
  and infinite operator estimates.

**Not formalised:** trace-classness on a Hardy/Banach space, the Fredholm
determinant, the identity
`det(I − L_s) = ζ(s)/ζ(2s)e^{P(s)}`, analytic continuation, the explicit
formula, and any spectral or Hilbert–Pólya statement. Those remain source claims
or open items.

The source's displayed `T` map uses an off-by-one branch index (R18); the map
proved here is the one derived from the residual rule.

Run:

```bash
./check.sh
```
