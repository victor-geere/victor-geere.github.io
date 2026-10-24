# Every local figure is zero-free — no finite place has a closure

**Kind:** Proposition
**Status:** PROVED (paper argument; geometric series of ratio p^{−1/2} < 1 on the line, Γ zero-free; verified numerically for p = 2, 3, 5, 7, 11, 101, 10007)
**Area:** xi-horn
**Source:** [`xi-horn/horn-helix-adelic.md`](../../xi-horn/horn-helix-adelic.md) — §1.2 "The finite places: the local horn *is* a helix", §1.3 "The archimedean place: the horn"; §9 dictionary, term "no local closure"

## Statement

> **No finite place has a closure.** |Z_p| is bounded away from zero on the whole critical line — it is a geometric series whose ratio has modulus p^{−1/2} < 1:
>
> ```
>    p        min |Z_p(½+it)|    max |Z_p(½+it)|    ratio
>    2        0.585786437627     3.41421356237      5.828
>    3        0.633974596216     2.36602540378      3.732
>    5        0.690983005625     1.80901699437      2.618
>    7        0.725708114823     1.60762521851      2.215
>    11       0.768337520964     1.43166247904      1.863
>    101      0.909501243789     1.11049875621      1.221
>    10007    0.990102439149     1.01009744092      1.020
> ```
>
> The other row of (1) is [horn-helix.md](../../xi-horn/horn-helix.md) §9's result restated: `Z_∞(s) = π^{−s/2}Γ(s/2)` is the horn's completion factor, i.e. shell 1's transform, i.e. the archimedean Euler factor. It is **also** zero-free — Γ has no zeros anywhere.
>
> So, exactly:
>
> > **Every local figure is zero-free.** No finite place's ladder closes and the archimedean place's bump does not either. The closures of Ξ exist only in the product over all places, equivalently only in the sum over the whole ℚ^× orbit (§2).

Dictionary entry, verbatim: "**no local closure** | \|Z_p(½+it)\| ∈ [(1+p^{−1/2})^{−1}, (1−p^{−1/2})^{−1}] — 0.5858 to 3.4142 at p = 2 — and Γ is zero-free, so **every** local figure is zero-free: the closures exist only in the product over all places".

## Hypotheses and notation

- Z_v(s) is the local zeta integral Z_v(s) = ∫_{ℚ_v^×} f_v(x)·|x|_v^s d^×x (source (1)); the weights are f_∞ = e^{−πx²} and f_p = 1_{ℤ_p}.
- Z_p(s) = Σ_{k≥0} p^{−ks} = (1 − p^{−s})^{−1} (source (2)); Z_∞(s) = π^{−s/2}Γ(s/2).
- The finite-place bound is [(1+p^{−1/2})^{−1}, (1−p^{−1/2})^{−1}] on the critical line; the table's "ratio" column is max/min.

## Proof / evidence

The finite-place statement is the source's one-line reason: |Z_p(½+it)| is a geometric series whose ratio has modulus p^{−1/2} < 1, so it is bounded away from zero; the table gives the measured min/max for p = 2 through 10007. The archimedean statement is that Γ has no zeros anywhere, so Z_∞ = π^{−s/2}Γ(s/2) is zero-free (with the factor ½s(s−1) supplying only s = 0 and s = 1). The source restates horn-helix.md §9's identification of Z_∞ with shell 1's transform.

## Dependencies and related results

- [Shell 1 is the place at infinity](xihorn-horn-helix-shell-1-is-the-place-at-infinity.md) (horn-helix.md §4, §9) for the archimedean factor.
- §1.4's four-difference table: local closure "none: |Z_p| ≥ (1+p^{−1/2})^{−1}" at v = p, "none: Γ is zero-free" at v = ∞.
- The interference reading: the closures of Ξ exist only in the product over all places, the sharp form of horn-helix.md §4's "the zero at γ₁ is 0.0017 of destructive interference between dilates" — "the interference is between *places* as well as between shells".

## Notes

- The statement block merges two adjacent labelled passages of the source: the finite-place table from §1.2 (with its intervening truncation table omitted) and the archimedean paragraph and the "Every local figure is zero-free" blockquote from §1.3.
- The bound is stated for the critical line (σ = ½); |Z_p| is bounded away from zero there, which is where the closure question lives.
- The source's framing: the two self-duality rows of §1.4 are why the theta functional equation works (§2.4), and these two extent/closure rows are why §5 is a negative result.
