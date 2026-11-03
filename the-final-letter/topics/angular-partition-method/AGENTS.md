# Agent notes — angular partition method

## Working rules

- Use the topic standard in [`../PROGRAMME-STANDARD.md`](../PROGRAMME-STANDARD.md).
- Keep the exact core separate from open applications. Label claims
  **Lean-checked**, **numerical**, **text-proof**, **conditional**, or **open**.
- Do not add `sorry`, `axiom`, or `admit`.
- Run `./lean/check.sh` and `python3 -m pytest tests -q` before reporting a
  green state.

## `nlinarith` guidance

The project-wide Lean journal
[`../../rh/research-journal.md`](../../rh/research-journal.md) records repeated
`nlinarith` failures. The useful lessons are:

1. **Normalise before `nlinarith`.** A goal containing unexpanded products,
   divisions, or coercions often stalls with errors such as
   `IsOrderedRing ?m` or deterministic heartbeat timeouts. Try `ring_nf` first,
   then `nlinarith` with explicit nonnegativity facts.
2. **Feed the nonlinear hypotheses explicitly.** For square-root/absolute-value
   goals, include `sq_nonneg`, `sq_abs`, `abs_nonneg`, and
   `Real.sqrt_nonneg`; for a square comparison, add
   `sq_nonneg (√x - |t|)` rather than expecting `nlinarith` to invent it.
3. **Do not ask `nlinarith` to multiply through an inequality.** Use
   `mul_le_mul_of_nonneg_left` / `mul_le_mul_of_nonneg_right` first. The same
   applies to division: use `div_le_iff₀`, `one_div_le_one_div_of_le`, or
   `div_le_div_of_nonneg_left`, not `nlinarith` alone.
4. **Abbreviate heavy terms.** `set` a `tsum`, a complicated norm, or a
   `LSeries` expression to a local constant so `nlinarith` sees atoms. If the
   statement itself unfolds a heavy definition, prove an intermediate lemma
   with the heavy term abstracted first.
5. **Split before solving.** If a goal mixes `abs`, `max`, `min`, casts, or
   several products, prove the component inequalities as separate `have`s and
   close with `linarith`/`nlinarith` on the resulting atoms.
6. **Pin the type.** Coercion ambiguity is a common source of
   `IsOrderedRing ?m`; annotate `(t : ℝ)`, `(n : ℕ)`, or use an explicit
   `have` with the intended type.

Local example from this topic: `nlinarith` failed on
`2 - t - t^2 < 2 - t` even with `0 < t^2` in context. The reliable pattern is
to normalise the polynomial (`ring_nf`), state the needed square bound as a
separate `have`, and then use `linarith`/`nlinarith`. When a sharper analytic
bound is available, prefer it: the regularized-kernel estimate was completed
with `Real.abs_exp_sub_one_sub_id_le` and explicit division lemmas rather than
a long nonlinear search.
