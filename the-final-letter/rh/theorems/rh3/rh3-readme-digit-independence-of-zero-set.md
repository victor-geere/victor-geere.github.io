# The zero set is digit-independent

**Kind:** Theorem
**Status:** PROVED (paper argument)
**Area:** workspace
**Source:** [`rh3/README.md`](../../rh3/README.md) — §8 "The b-thread, and why it is off by default", eq. (18) and the zero-set remark, lines 249–265

## Statement

> Every *b*-vertex is its *a*-vertex rotated by the same fixed π/6, at every σ, at every *t*, at every depth. Hence
>
> val(bbbb…) = e^{iπ/6}·η(s),    val(k-th digit string) = e^{ikπ/6}·η(s)   (18)
>
> The zero set is **digit-independent**: a closure is the simultaneous collapse of the whole clock frame, all twelve helices returning to the origin together.

## Hypotheses and notation

- The twelve primary digits *a*…*l* sit at angular offsets kπ/6, k = 0…11, in the circle's frame; digit *k* of level *n* sits at angle ϑ<sub>n</sub> + kπ/6.
- The *b*-vertex is "the same point rotated rigidly by π/6 about the depth axis"; the b-thread is the thread carried by the *b*-vertices.
- val(·) is the chained value of §7: val(aaaa…) = η(s) (eq. (15)).
- The phase-opposite rule of §2, a + A = 0, b + B = 0, …, g ≡ A, h ≡ B (1), identifies the antipode with the additive inverse; it is what fixes the twelve digit names.

## Proof / evidence

The source states this without proof beyond the observation that the π/6 offset is the same fixed rotation at every σ, every *t* and every depth, so it factors out of the chained sum of §7: each term picks up e^{ikπ/6}. The document notes that "nothing below depends on the choice: all twelve digit strings evaluate to e^{ikπ/6}·η(s)."

## Dependencies and related results

- [rh3-readme-evaluation-is-projection](rh3-readme-evaluation-is-projection.md) — the k = 0 case val(aaaa…) = η(s), from which (18) follows by the fixed rotation.
- The source pairs this with the remark that ⟨a,b⟩ = cos(π/6)|η(s)|² ≥ 0 with equality exactly at closures "looks like a missing axiom and is not: its positivity is the free positivity of a norm-square, true of every Dirichlet series whatsoever."

## Notes

- The practical consequence the source draws: "The amber thread makes that point once and then carries no further information", which is why the b-thread is hidden behind a checkbox in the figure.
- This is a statement about the construction's clock frame, not about zeros of ζ: a closure here is a closure of the numeral (a gauge closure may be one — see §9).
