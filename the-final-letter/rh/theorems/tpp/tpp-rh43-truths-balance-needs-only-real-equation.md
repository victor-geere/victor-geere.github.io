# Theorem 10 (balance needs only the real equation)

**Kind:** Theorem
**Status:** PROVED (paper argument; assembled from the Lean-proved components)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh43/truths.md`](../../research/twin-prime-parity/rounds/rh43/truths.md) — §2 "The complex picture: `S_N(t) = 0` is a different question"

## Statement

> **Theorem 10 (balance needs only the real equation).** The split of the *real* parts — the question actually asked — is settled by `Re S_N(t) = 0` and is attained for every `N >= 2` (Theorems 3, 4, 6, 7). The complex equation is not needed for it and is *false* in general (`N = 1` has no negative part; `N = 2` does have an exact complex zero; `N = 3` provably has none).

## Hypotheses and notation

- The round's question is about the real-part split `P_N >= 0`, `M_N <= 0`; the balance condition is `P_N = |M_N|`, equivalent to `Re S_N(t) = 0` (Theorem 1).
- The complex equation is `S_N(t) = 0`.
- The three cited cases: `N = 1` (no negative part, `Re S_1 ≡ 1`), `N = 2` (exact complex zero at `t = pi/log 2`), `N = 3` (`S_3(t) != 0` for every real `t`).

## Proof / evidence

- Ledger T10 records `S_3(t) != 0` for all `t` as **PROVED**; the balance-attainment part is assembled from [Theorem 3](tpp-rh43-truths-n2-balanced-tangential.md), [Theorem 4](tpp-rh43-truths-n3-existence-ivt.md), [Theorem 6](tpp-rh43-truths-certified-root-table.md) and [Theorem 7](tpp-rh43-truths-existence-every-n.md) (the latter a proof-sketch plus numerical verification).
- The source states this without a separate proof; it is a summary theorem relating the two equations.

## Dependencies and related results

- Related: [The split is an identity](tpp-rh43-truths-split-is-an-identity.md) (Theorem 1); [S_3(t) != 0](tpp-rh43-truths-s3-nonvanishing.md) (Theorem 8); [S_2(pi/log 2) = 0 exactly](tpp-rh43-truths-s2-exact-vanishing.md) (T11); [Why the complex picture is not the question](tpp-rh43-truths-complex-picture-not-the-question.md) (Theorem 9).

## Notes

- The source states this without proof: "the source states this without proof" — it is a bookkeeping theorem recording which equation the round's question depends on.
- truths.md §9 adds: "It does **not** relate the balanced split to the zeros of `zeta`: no identity is claimed between a root of `Re S_N(t)` and a zero of `zeta(1/2 + it)` or `zeta(i t)`."
