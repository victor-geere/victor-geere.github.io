# B1 — the greedy support carries no `λ`-parity signal (README)

**Kind:** Claim
**Status:** REFUTED (no signal above a size-matched control)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh47/README.md`](../../research/twin-prime-parity/rounds/rh47/README.md) — §2 table "The bridge the goal needs — and the barrier", row **B1**, line 55

## Statement

> | bridge | statement | status |
> |---|---|---|
> | **B1** | the greedy *support* carries `λ`-parity signal | **no signal above a size-matched control** — the word is a function of the target `x` alone (deterministic, additive in `log n`), while `λ` is multiplicative |

## Hypotheses and notation

- `λ(n) = (−1)^{Ω(n)}` is the Liouville function.
- The greedy word's support depends on the target `x` alone; the README calls it "deterministic, additive in `log n`" — a phrasing the round's own record correction later flags as too wide.
- "Size-matched control" refers to the controls of `truths.md` §2 (positional sign-permutation pool, rank-matched slot pools).

## Proof / evidence

The README's table records the tested status only; the numerical detail is in the round's probe [`greedy_parity_probe.py`](../../research/twin-prime-parity/rounds/rh47/greedy_parity_probe.py) and in `truths.md` §2, where the nominal `z = −47.9` is killed by controls (`z = +0.43`, p = 0.66; `z = +1.55`, p = 0.12).

## Dependencies and related results

- [truths.md B1 §2](tpp-rh47-truths-bridge-b1-no-lambda-parity-signal.md) — the full numerical account.
- [README B2](tpp-rh47-readme-bridge-b2-index-parity-independent.md) and [README B3](tpp-rh47-readme-bridge-b3-no-euler-product.md) — the other two bridge rows.
- [README barrier](tpp-rh47-readme-barrier-additive-character-open.md) — the summary the three rows support.
- Restated with a different status wording in HANDOFF: [B1 "no mechanism known"](tpp-rh47-handoff-bridge-b1-no-mechanism-known.md).
- Earlier ledger row: [bridge B1](tpp-dict-00-bridge-b1-no-parity-signal.md).

## Notes

- The status carries the README's own words: **no signal above a size-matched control**.
- The README's explanatory clause "deterministic, additive in `log n`" is part of the phrasing the round's record correction declares too wide; the corrected reading is *sign-blind alphabet, no arithmetic input*.
