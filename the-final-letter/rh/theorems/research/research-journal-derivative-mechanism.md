# Differentiation converts the frequency k log p into the amplitude log p

**Kind:** Proposition
**Status:** PROVED (paper argument; verified numerically)
**Area:** workspace
**Source:** [`research-journal.md`](../../research-journal.md) — Round 2 ruling, line 259; Round 4(b), line 351; Synthesis §4, line 418; "The ten things that stand" §7, line 620

## Statement

> **(b) The product whose logarithm carries the amplitudes: verified.** log ζ(s) = Σ_{p,k} p^{−ks}/k has amplitude **1/k** at frequency k log p; d/ds gives Σ_n Λ(n)n^{−s} with amplitude **log p** at the same frequency. Verified at s = 2: d/ds log ζ(2) = −0.569960993095 against Σ_{n<2000} Λ(n)n^{−2} = 0.569460116623 (truncation error 5e−4 only); at s = 3: −0.164822682158 against 0.16482255674. **So differentiation provably converts the frequency k log p into the amplitude log p and kills the 1/k.**

The underlying identity, as stated in Round 2:

> d/ds(p^{−ks}/k) = −(log p)p^{−ks}: the frequency k log p becomes the amplitude log p, and the 1/k dies. So the honest statement is that *the explicit formula's prime side is the derivative of the logarithmic side*, and a construction that only ever **adds** produces the amplitude 1/k — i.e. log ζ, not −ζ'/ζ.

## Hypotheses and notation

- log ζ(s) = Σ_{p,k} p^{−ks}/k for Re s > 1; −ζ'/ζ(s) = Σ_n Λ(n)n^{−s}.
- d/ds(p^{−ks}/k) = −(log p)p^{−ks}; the "1/k" coefficient is what dies under differentiation.
- The comparison Σ_{n<2000} Λ(n)n^{−2} is a truncated numerical evaluation of the series.

## Proof / evidence

The derivative computation is elementary and exact; the source verifies it numerically at two points: d/ds log ζ(2) = −0.569960993095 against Σ_{n<2000} Λ(n)n^{−2} = 0.569460116623 (truncation error 5e−4), and at s = 3: −0.164822682158 against 0.16482255674.

## Dependencies and related results

- [The frequency/amplitude dictionary of the explicit formula](research-journal-frequency-amplitude-dictionary.md) — the dictionary this operation produces.
- [The local-factor dichotomy: Euler factors perturb the identity, greedy factors perturb zero](research-journal-local-factor-dichotomy.md) — the product being differentiated.
- [The decay-rate criterion: g must decay faster than e^{−x/2}](research-journal-decay-rate-admissibility.md) — the convergence condition on the resulting prime side.

## Notes

- The source states the operational obstruction attached to this result in Round 4's ruling: A conceded that the residual logarithm log(r_{n+1}/r_n) = −δ_nα_n/r_n **is** a genuine logarithmic derivative, measured for target 1 as −0.693147, −1.09861, 0, 0, −140.303 (= log(1/6)), "**but it costs a division by r_n, and the greedy construction's primitives are add-and-compare.** … *the missing operation is available in the arithmetic and unavailable in the machine.*"
- The journal calls this "the cleanest statement of the failure produced in five rounds" and lists it among the things the dialogue established, not among its open questions.
