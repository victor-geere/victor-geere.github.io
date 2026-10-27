# Open and conditional items

**Sources:** [`todo.md`](../../geometric-dynamical-phase-transitions/todo.md); [`gaps.html`](../../geometric-dynamical-phase-transitions/gaps.html), “Tractable items” and “Not tractable here”; [`publication.html`](../../geometric-dynamical-phase-transitions/publication.html) Addendum F and Remark F.13.

This is the working list, not a wish list. Each item is marked with what it would move and whether the paper’s toolbox can reach it.

## The main open item

### F.4 — A Lee–Yang property for the polygon

**Question.** Is there a ferromagnetic spin system whose finite-volume partition functions are $\eta_N^{(N^2)}$, or any reweighting confining every finite zero to a line?

**Why it matters.** The Lee–Yang circle theorem is the one known mechanism in this setting that forces the zeros of every finite system onto a line, and it has a precise hypothesis: ferromagnetic positivity of the couplings. It fails for antiferromagnets and says nothing about a linear combination of two partition functions. That is exactly the shape of the missing input (M). A Lee–Yang theorem therefore passes the Davenport–Heilbronn litmus.

**Boundary.** Plain partial sums have zeros in $\sigma>1$ (Montgomery) and cluster to the line without lying on it (Gonek–Ledoan). Bombieri–Hejhal show density statements are blind to a density-zero off-line set, so the property would have to be **pointwise**: confinement of every finite zero, not almost every.

**Status.** Open. The computable part is item (b).

## Tractable with the paper’s toolbox

| Item | Statement | What it would give | Status |
|---|---|---|---|
| (a) Gonek–Ledoan for $\eta_N$ | $N_\eta(\sigma,T)\ll TN^{2(1-2\sigma)}\log^6T$ for $\sigma\ge\tfrac12+1/\log T$ | Quantifies the clustering of §F.7; additive, transfers to the twist | Tractable, not done |
| (b) Transfer-operator form | Write $\eta_N^{(N^2)}$ as a trace over the $N$-spin chain of nested fibres; compute the sign of the induced couplings for small $N$ | A negative coupling settles F.4 in the negative for that representation; positive couplings for all $N$ would be the first Lee–Yang-shaped input that passes the litmus | Tractable, not done; highest expected return |
| (c) Heat-flowed polygon | Tabulate the zeros of $\sum_{m\le N^2}c_me^{\tau(\log m)^2}m^{-s}$ against $\tau$ on the window | Register form of the de Bruijn–Newman flow; clock zeros and near-line zeros should respond differently | Tractable, not done |
| (d) Twist form of F.8 | Lemma F.8 at clock points whose Rouché circle avoids the zeros of $f$, using Lemma 9.4 instead of the zero-free region | Transfers the clock-zero count to the DH twist; finite computation at each $N$ | Tractable, not done |

## Conditional / conjectural

| Item | Hypothesis | Status |
|---|---|---|
| Uniform slow passage on the window | $\lvert\zeta'(\rho)\rvert\le N^{\varepsilon}$ for $\lvert\gamma\rvert\le N^{1/2-\varepsilon}$; random-matrix prediction (Hughes–Keating–O’Connell) says yes | Conjectural; not used by any theorem |
| Uniform isolation | Count of zeros with a neighbour within $N^{-\kappa}$ up to $N^{1/2-\varepsilon}$; pair correlation (Montgomery/GUE) | Conditional; the isolation clause (ii) of Definition 5.1 stays per zero |
| Corollary F.9 for $\varepsilon\le13/194$ | Needs Lindelöf, or the random-matrix moments of HKO | Conditional |
| Extending Weil positivity past the first prime | Importing (M); the archimedean window is $[2^{-1/2},2^{1/2}]$, first prime at $\lambda=2$ | Not a polygon problem |
| $\Lambda=0$ | de Bruijn–Newman; known $0\le\Lambda\le0.22$ | Open; equivalent to RH |
| (M) itself | No zeros in $\sigma>1$ | Open as an input; true for $\zeta$, false for DH |
| A contour reaching the critical line | Remark E.11: no admissible contour is known | Open; the barrier is unmoved |

## Not a route

- **Jensen tower at fixed degree.** Griffin–Ono–Rolen–Zagier occupy the large-shift, fixed-degree regime; Farmer argues the route is not plausible. Uniformity in the degree is the full tower, which is RH.
- **Density statements.** Any “almost all” statement about Fisher zeros or a free-energy density is blind to a density-zero off-line set (Bombieri–Hejhal). The measures $\mu,\nu$ escape this only because the tempering weight charges individual atoms.
- **A sharper estimate of an existing quantity.** Addendum C shows the missing input cannot be an estimate of anything already in the paper: the DH twist has every such estimate and still has an off-line zero. The input must fail for a sum of two Euler products.

## The status of the list

Items (a)–(d) sharpen what the polygon is known to do or settle a question about the polygon itself. None moves an atom of $\nu$. F.4 is the only item that could, and it is open.

[Back to folder README](README.md) · [Back to the summary index](../README.md)
