# Ten questions for *Partial sum plus tail*

Ten questions about [the programme page](index.html), ordered from its logical
foundations towards its stated open items. They are questions, not objections:
each names a place where the page's own vocabulary — *certified*, *sound*,
*enclosed*, *proved* — is doing more work than the neighbouring sentence makes
explicit.

---

## 1. Is a sound box the same as an informative one?

`Expr.wf_sound` guarantees that an accepted certificate's final box contains
the value it denotes. But `inflate` is sound for *every* `r ≥ 0` (T6, T13, C14),
so any accepted box can be widened arbitrarily and remain accepted. The page's
headline claim "`0 ∈ [ζ(1/2 + 14.1347…i)]`, width ≤ `5e-17`" therefore welds two
different kinds of assertion together: containment, which is certified, and
tightness, which is a number reported by the Python side and never itself
kernel-checked.

*Is there any part of the architecture in which the width of an enclosure is a
theorem rather than a measurement — or is "usefully tight" permanently outside
the certificate?*

## 2. Where does the mathematics actually reside?

The checkable cell is `add`, `sub`, `neg`, `scale`, `mul`, `inflate` over `ℚ` —
elementary ordered-field algebra. Everything specifically number-theoretic sits
in the atoms: the input `s`, the transcendental enclosures, and above all the
Euler–Maclaurin decomposition (S1) and its tail bound (S2), which the page
leaves as source claims. Twenty-five of the thirty-five ledger rows (T1–T25) are
about the container; the contents are trusted by hypothesis. The elementary
S3–S5 are now T33–T35; S1–S2 have a written proof but are not Lean-formalised.

*If the kernel-checked spine would remain true for an arbitrary series and an
arbitrary tail bound, what exactly has been certified about ζ — and why was the
transcendental library worth formalising to the last decimal while the one
inequality that encodes the arithmetic is not?*

## 3. Does "0 ∈ box" certify a zero?

C9 reports that the enclosure of `η(1/2 + iγ₁)` contains `0`. Containment of
zero is compatible with the true value being anything inside the box, and in
particular with it not being zero at all; it also gives no information about
nearby `t`. A certified zero normally needs two boxes — one isolating the value,
and a sign change or argument-principle count exhibiting that a zero must lie
there — plus an exclusion of zeros elsewhere.

*What would it take, in this architecture, to move from "the value is small" to
"there is a zero here", and how far is the page's phrasing from that
distinction?*

## 4. What is the object when the input is a decimal?

`η` is evaluated at `"14.134725…"`, a rational literal chosen because it
approximates the first ordinate. The certified statement is about that rational,
not about `γ₁`, and its cost grows with height: `sin(t log n)` needs a rigorous
`2π` reduction whose denominator grows with `t`, and the 64-bit certificates are
described as reaching ~115 kB at small heights.

*Is there a stability statement — an explicit Lipschitz or derivative bound —
that carries a box at `t₀` to a neighbourhood of `t₀`, and what is the asymptotic
cost of certification at height `T`? Until both exist, is the evaluator a
*verifier of arithmetic* rather than a tool for zero-free regions?*

## 5. Where is the remainder bound actually valid?

The bound `|R_K| ≤ |(s)_{2K+1}| · 2ζ(2K+1)/(2π)^{2K+1} · b^{−σ−2K}/(σ+2K)` has
`σ + 2K` in the denominator, and degenerates at `σ = −2K` as well as for
`σ < −2K`. The critical strip `0 < σ < 1` is safe for every `K`, but the
functional equation — and hence any use of this evaluator to reach the region
where RH's symmetry actually lives — needs values at negative real part.

*What is the exact range of `(s, K, b)` for which S2 is claimed, is that range
stated anywhere, and is the failure at `σ ≤ −2K` a removable artefact of this
particular bound or a structural limit of the partial-sum-plus-tail scheme?*

## 6. How does an `η` enclosure become a `ζ` enclosure without a division lemma?

S4 records `η(s) = (1 − 2^{1−s}) ζ(s)`, and open item 2 notes that derivatives
would cost a `div` soundness lemma — implying no such lemma exists yet. But
even the value-level passage from `η` to `ζ` requires multiplying by the
reciprocal of `1 − 2^{1−s}`, a factor that vanishes at `s = 1 + 2πik/log 2`.

*Is the `η` route currently a certified route to `ζ` at all, or only a certified
route to `η`? And near the zeros of `1 − 2^{1−s}`, where the reciprocal is
unbounded, does interval multiplication destroy whatever the alternating series
bought?*

## 7. Is the `s = 1` problem a symptom of the dependency problem?

Open item 3 says the Hurwitz pole "cancels only in the `Σ χ(a)` sum", and that
`L(1, χ₃)` is therefore checked at `3/2` instead. Exact rational interval
arithmetic does not automatically see such cancellations: if each `ζ(s, a/N)` is
enclosed separately and then summed, the widening from independent enclosure can
swallow the cancellation entirely — the classic dependency problem, here with a
pole behind it.

*Does the architecture ever compute in exact rational *algebra* before taking
enclosures, so that `Σ χ(a)` is formed symbolically? If not, is the retreat to
`3/2` a local convenience or evidence that the evaluator cannot be trusted near
any cancellation it was not hand-tuned for?*

## 8. Which characters does the `L`-reduction actually cover?

S5 states `L(s,χ) = N^{−s} Σ_{a=1..N−1} χ(a) ζ(s, a/N)`. The missing `a = N`
term vanishes only when `χ(N) = 0`, i.e. for characters primitive at `N` (or at
least with `N ∤ N` in the relevant sense); for imprimitive `χ` the reduction
needs `a = 1..N` and a twist. The tests C8 and C9 use `χ₄` and `χ₃`, both
primitive, so the gap is invisible in the ledger.

*Is the evaluator defined only for primitive characters, and is that restriction
stated as a domain condition — or is it an unremarked hypothesis that would
silently produce a wrong enclosure for the first imprimitive character handed
to it?*

## 9. Do T15–T18 connect to Euler–Maclaurin, or run parallel to it?

`tsum_eq_finite_add_tail`, `truncation_residual_le_tail_norm`,
`truncation_residual_le_finset_tail_norm` and
`truncation_residual_le_three_tails` are statements about abstract `tsum`s and
norms. They are true of any summable family, and nothing in their names or the
page's description ties them to `R_K`, to Bernoulli numbers, or to `b = a + M`.

*Is there a stated bridge lemma from the transport layer to the analytic
remainder, or is the "partial sum plus tail" of the title formalised as a
generic skeleton whose instantiation is the part still missing? If the latter,
would the skeleton survive a change of tail bound unchanged — and if so, what
does it certify?*

## 10. What does "no axiom" cover, and who keeps the ledger honest?

The dossier's former S7 named `native_decide` as the checker of each replay's rational cell. That
tactic trusts compiled evaluation (`Lean.ofReduceBool`), so the blanket "no
`sorry`, no `axiom`, no `admit`" holds for `wf_sound` and the interval lemmas but
not, without qualification, for each accepted certificate. Meanwhile the page's
Lean-layer paragraph and `lean/BUILD.log` must stay in sync as the development
grows; they now list seven files, including `SourceClaims.lean`.

*What is the trust budget when `native_decide` is in the loop, and what
maintenance discipline keeps a ledger of 35 theorems, 14 tests, 2 unresolved
source claims and 6 open items in sync with the artefacts it indexes — given that this page has
already drifted from its own build log?*

---

### A closing question the ten share

The page's strongest asset is that it separates what is proved from what is
claimed, at a granularity most of the programme's topics do not attempt. Its
weakest point is that the separation follows the *shape of the code* — rational
cell, atoms, source claims — rather than the shape of the *mathematics*, where
the load-bearing step is one inequality (S2) that no test can reach.

*If a reader wanted to know which single unproved line, if false, would
invalidate every enclosure in the "Recorded source results" table, would the
page's structure make that line findable — or would it look like one atom among
many?*
