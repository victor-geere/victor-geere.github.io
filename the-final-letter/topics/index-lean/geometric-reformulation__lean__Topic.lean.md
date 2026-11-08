# `geometric-reformulation/lean/Topic.lean`

[Back to the split index](index.md) · Topic: [`geometric-reformulation`](../geometric-reformulation/README.md)

### [`geometric-reformulation/lean/Topic.lean`](../geometric-reformulation/lean/Topic.lean) — 7 proofs

| Line | Kind | Proof | Statement (LaTeX) |
|---:|---|---|---|
| [42](../geometric-reformulation/lean/Topic.lean#L42) | theorem | `helixTorsion_pos` | $\forall\,\omega : \mathbb{R},\ \forall\,h : 0<\omega,\ 0<\mathrm{helixTorsion}\ \omega$ |
| [48](../geometric-reformulation/lean/Topic.lean#L48) | theorem | `helixTorsion_lt_half` | $\forall\,\omega : \mathbb{R},\ \forall\,h : \omega\ne\ 1,\ \mathrm{helixTorsion}\ \omega<1/2$ |
| [60](../geometric-reformulation/lean/Topic.lean#L60) | theorem | `helixTorsion_symm` | $\forall\,\omega : \mathbb{R},\ \forall\,h : \omega\ne\ 0,\ \mathrm{helixTorsion}\ \omega=\mathrm{helixTorsion}\ \omega^{-1}$ |
| [68](../geometric-reformulation/lean/Topic.lean#L68) | theorem | `scaledTorsion_half_one` | $:\mathrm{scaledTorsion}(1/2)\ 1=4/5$ |
| [75](../geometric-reformulation/lean/Topic.lean#L75) | theorem | `scaling_not_torsion_invariant` | $:\mathrm{scaledTorsion}(1/2)\ 1\ne\ \mathrm{helixTorsion}\ 1$ |
| [82](../geometric-reformulation/lean/Topic.lean#L82) | theorem | `coneRadius_pos_and_strictAnti` | $\forall\,\sigma\,t : \mathbb{R},\ \forall\,h\sigma : 0<\sigma,\ \forall\,ht : 0<t,\ (\forall\ k:\mathbb{N},\ 0<\mathrm{coneRadius}\ \sigma\ t\ k)\ \land\ \mathrm{StrictAnti}(\mathrm{coneRadius}\ \sigma\ t)$ |
| [97](../geometric-reformulation/lean/Topic.lean#L97) | theorem | `primeWeight_pos` | $\forall\,p : \mathbb{R},\ \forall\,hp : 1<p,\ \forall\,m : \mathbb{N},\ 0<\mathrm{primeWeight}\ p\ m$ |
