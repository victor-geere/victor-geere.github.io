# R1 — the source pages' ledger has the corrected onsets (`{0,2}→3`, `{1,3}→2`)

**Kind:** Claim
**Status:** VERIFIED (numerical, `rigorous_check.py::onset` and agreement with the Lean theorem)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh42/HANDOFF.md`](../../research/twin-prime-parity/rounds/rh42/HANDOFF.md) — §6 "The rh42 ledger", row R1; §4.5 "Cross-check worth recording"

## Statement

> The public bench prints the onset pair as **`{0,2}` at `L = 3`, `{1,3}` at `L = 2`** — the
> corrected values. `TRUTHS.md` §5 prints them interchanged. So the source pages, the Lean
> theorem `onset_not_determined_by_gaps`, and `rigorous_check.py` all agree with each other,
> and the only outlier is the §5 table of `TRUTHS.md`.

The ledger row states it as: "the source pages' ledger has the corrected onsets (`{0,2}→3`, `{1,3}→2`)" — **VERIFIED** | agrees with `rigorous_check.py::onset` and the Lean theorem; only `TRUTHS.md` §5 disagrees.

## Hypotheses and notation

- Onset: the smallest `L` at which the factor complexity `p(L)` departs from its `L+1` (C1) behaviour — the value the source elsewhere calls "the onset".
- `{0,2}`, `{1,3}`: supports (sets of taken indices); `L` is the factor length.
- "the public bench" is the Note 041 page at <https://harmonic-sine.grok.me/>.

## Proof / evidence

> | R1 | the source pages' ledger has the corrected onsets (`{0,2}→3`, `{1,3}→2`) | **VERIFIED** | agrees with `rigorous_check.py::onset` and the Lean theorem; only `TRUTHS.md` §5 disagrees |

The §3.3 correction 1 states the original error: "the onset example of `TRUTHS.md` §5 has its two values interchanged: with `N = 6` the onsets are `3` for `{0,2}` and `2` for `{1,3}` (`rigorous_check.py::onset`, the Lean theorem `onset_not_determined_by_gaps`, and the public bench all agree)".

## Dependencies and related results

- Companion of rh41's Theorem 6 (onset determinacy) and its Lean declaration `onset_not_determined_by_gaps`.
- Recorded as correction 1 in §3.3 ("Corrections already banked (do not re-propose the old forms)").

## Notes

- This is a bookkeeping/consistency result about the round's records rather than a new mathematical theorem; it is harvested because the source states it as a ledger row of its own.
- The two onsets `3` (for `{0,2}`) and `2` (for `{1,3}`) are quoted exactly, with `N = 6` as in §3.3.
