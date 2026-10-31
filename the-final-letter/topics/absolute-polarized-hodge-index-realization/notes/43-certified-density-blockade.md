# Certified-density performance blockade

> **Round 13 update.** The recurrence/Binet enclosure in note
> [`44-first-interval-entry.md`](44-first-interval-entry.md) bypasses this
> blockade for the Gaussian diagonal: it gives a certified entry of width
> \(4.9\cdot10^{-4}\). The 4×4 density path remains blocked for the
> compact-support margin.

**Status:** the interval-certified analytic Gram entry is still not achieved.
The obstruction is now performance, not only the margin: the sibling dossier's
certified density routine is too slow at the parameters needed for a usable
enclosure, and its coarse-parameter output is invalid (`+inf` error). No RH
proof yet.

## 1. The runs

| run | parameters | result |
|---|---|---|
| sibling `certify_gram.py`, \(4\times4\) | `H=0.1`, `T=100`, `U=6` | **no output after >40 min**; killed |
| 2-centre density | `H=1`, `T=20`, `U=6`, order 4 | 40.4 s, 40 panels; density error `+inf`, intervals invalid |
| 2-centre density | `H=0.2`, `T=30`, `U=10`, order 4 | **timeout at 300 s**, no output |

The `+inf` error in the coarse run is not a numerical warning that can be
ignored: `interval_psd_certificate` receives `nan` endpoints and refuses.

## 2. Why

`gaussian_density_certified_multi` evaluates an \(\Omega\)-jet on every panel
(`omega_t_jet`) and accumulates a rigorous error. The cost scales as
\(2T/H\) panels times the jet series, and the error bound grows quickly as
\(H\) is made coarse. The two requirements conflict:

- the compact-support cosh \(+\Omega\) Gram has margin \(2.5\cdot10^{-5}\)
  (note 42), so the enclosure must be tight;
- the tight parameters (`H=0.1`, `T=100`) are too slow to complete in a
  session.

## 3. What this rules out

- Running the sibling certificate as-is is not a route to a compact-support
  certificate in this environment.
- Coarsening the panels to get speed produces invalid (`+inf`) enclosures.
- The interval certificate needs a **different \(\Omega\) enclosure**, not
  just a longer wait.

## 4. The replacement algorithm

The point enclosure `omega_interval` already uses a panel integral over
\([0,U]\). A faster and tighter route is the digamma recurrence plus the
asymptotic expansion:

\[
\psi(z)=\psi(z+N)-\sum_{k=0}^{N-1}\frac{1}{z+k},
\qquad
\psi(w)=\log w-\frac{1}{2w}-\sum_{k=1}^{K}\frac{B_{2k}}{2k\,w^{2k}}+R_K(w),
\]

with \(N\) chosen so that \(\operatorname{Re}(z+N)\ge 10\) and a standard
remainder bound for \(R_K(w)\) on \(\operatorname{Re}w>0\). This replaces the
panel integral by \(O(N+K)\) interval operations per point: fast enough to
evaluate at thousands of nodes, and tight because the asymptotic expansion at
\(\operatorname{Re}w\ge10\) has a small remainder after a few terms.

The remaining work is the complex interval arithmetic and the Bernoulli
remainder bound. Neither is implemented.

## 5. Bottom line

- The certified-density path is blocked at the current parameters.
- The replacement (recurrence + asymptotic interval \(\psi\)) is specified,
  not implemented.
- The margin remains \(2.5\cdot10^{-5}\); the perturbation step is
  Lean-checked (`quadForm_perturb`), the interval entries are not.
- No RH proof yet.

[Back to the dossier](../README.md) · [Interval status](42-interval-status.md) ·
[Lean core](../lean/README.md) · [Research journal](../research-journal.md)
