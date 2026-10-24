# Theorem 5.2 (counting)

**Kind:** Theorem
**Status:** CITED (literature; source labels it THEOREM + NUMERICAL)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/dictionary/04-zeta-relations.md`](../../research/twin-prime-parity/dictionary/04-zeta-relations.md) — §5 "The explicit formula (rh45)", "Theorem 5.2 (counting)", line 165

## Statement

> **Theorem 5.2 (counting).**  `N(T) = θ(T)/π + 1 + S(T)` exactly, and
> `N(T) = (T/2π)log(T/2πe) + 7/8 + S(T) + O(1/T)`, `S(T) = (1/π)arg ζ(1/2+iT)`.

## Hypotheses and notation

- `N(T)` is the source's zero count; `S(T) = (1/π)arg ζ(1/2+iT)` as defined in the statement.
- `θ(T)` appears in the exact form; the chapter does not define it.
- The asymptotic is `T → ∞` with error `O(1/T)`.

## Proof / evidence

The source's status line, verbatim:

> *Status:* THEOREM + NUMERICAL (residuals `3.32·10⁻⁴, 1.33·10⁻⁴, 6.63·10⁻⁵,
> 3.32·10⁻⁵, 2.21·10⁻⁵` at `T = 20, 50, 100, 200, 300`; exact form to `10⁻²⁰`;
> independent `ζ'/ζ` count).

No proof is given in the chapter. The evidence is numerical: the five residuals at `T = 20, 50, 100, 200, 300`, the exact form verified to `10⁻²⁰`, and an independent count via `ζ'/ζ`.

## Dependencies and related results

- [Theorem 5.1 (Weil form — with the archimedean term)](tpp-dict-04-weil-form-archimedean-term.md) and [Theorem 5.3 (zeros from the formula)](tpp-dict-04-zeros-from-the-formula.md) — the rest of §5.

## Notes

- Ledger entry for the **rh45** round (section headed "(rh45)").
- The source labels this result "THEOREM + NUMERICAL" without naming an attribution or proof, and it is the standard explicit-formula count of zeros; per this harvest's convention for classical results it is recorded as CITED (literature), with the source's own label quoted in the Status qualifier.
- The source does not define `θ(T)` or spell out `N(T)` in this chapter; both are reproduced as printed.
