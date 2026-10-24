# Proposition 1

**Kind:** Proposition
**Status:** PROVED (paper argument)
**Area:** xi-horn
**Source:** [`xi-horn/initial-segments.md`](../../xi-horn/initial-segments.md) — §2 "Three ways to say 'initial segment'"

## Statement

> **Proposition 1.** For f as above, the following are equivalent:
>
> 1. every E(d), d ≥ 1, is an initial segment;
> 2. D is non-decreasing on E_∞ = [0, ν);
> 3. E_{f′}(d) ⊆ E_f(d) for every d — *differentiation shrinks every exception
>    set*.

## Hypotheses and notation

- f is a real entire function of genus 1\* with Taylor data
  `a(n) = f^(n)(0) > 0`; the definitions are [gorz-gap.md](../../xi-horn/gorz-gap.md) §1, restated in
  [initial-segments.md](../../xi-horn/initial-segments.md) §1:
  ```
  J_{d,n}(X) = Σ_{j=0}^{d} C(d,j)·a(n+j)·X^j
  E(d)  = { n ≥ 0 : J_{d,n} not hyperbolic }
  D(n)  = min { d : n ∈ E(d) }          (∞ if none)      the witness degree
  ν     = min { n : f^(n) ∈ LP }
  ```
- `E_∞ = ∪_d E(d) = [0, ν)` is [gorz-gap Theorem 2](xihorn-gorz-gap-t2-initial-segment.md) (an initial segment);
  `E(d) ⊆ E(d+1)` is [gorz-gap Theorem 1](xihorn-gorz-gap-t1-nesting.md).
- A set S ⊆ ℕ is an **initial segment** if n ∈ S and m < n imply m ∈ S. A
  **gap** in E(d) is a witness against this: m < n with n ∈ E(d), m ∉ E(d).
- LP is the Laguerre–Pólya class.
- `N(d) = 1 + max E(d)`.

## Proof / evidence

The source's proof, verbatim: "(1) ⟺ (2): E(d) = {n : D(n) ≤ d} is the
sublevel set of D, and every sublevel set of a function on an initial segment is
an initial segment iff the function is non-decreasing. (1) ⟺ (3): the Taylor
data of f′ is the shifted sequence a(n+1), so J^{f′}_{d,n} = J^f_{d,n+1}
termwise and E_{f′}(d) = {n : n+1 ∈ E_f(d)}. The inclusion E_{f′}(d) ⊆ E_f(d)
says exactly that n+1 ∈ E_f(d) implies n ∈ E_f(d), which is downward closure. ∎"

## Dependencies and related results

- [gorz-gap Theorem 1 (nesting)](xihorn-gorz-gap-t1-nesting.md) and
  [gorz-gap Theorem 2 (initial segment)](xihorn-gorz-gap-t2-initial-segment.md).
- Used throughout [initial-segments.md](../../xi-horn/initial-segments.md): §8 reads the whole question
  through (3); [Proposition 2](xihorn-initial-segments-p2-staircase.md) bounds how bad a gap can be.
- The source's reading: "gorz-gap Theorem 1 says raising the *degree* only
  reveals exceptions; the initial-segment property would say raising the *shift*
  — differentiating — only heals them. The first is a theorem (Rolle); the
  second, this file shows, is false in the class."

## Notes

- A per-d signature worth naming, in the source's words: "since N(d) = 1 + max
  E(d), a gap in E(d) is the same thing as **#E(d) < N(d)** — gorz-gap
  Theorem 3's two suprema still agree at ν, but the witnesses below have
  #E(2) < N(2) at finite d."
- The equivalence is bookkeeping on one shift identity; the source says so in
  its §0 disclaimer ("The equivalences of §2 are bookkeeping on one shift
  identity").
