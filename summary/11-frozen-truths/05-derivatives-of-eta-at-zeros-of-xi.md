# 5. Derivatives of \(\eta\) at zeros of \(\Xi\)

> Source: [`truths.md`](truths.md), §5. Frozen by the canonical paper; corrections from `tensor.md` are noted in the folder README.

## Truth 5.1 — Lemma 4.5.1

If \(\zeta(\tfrac12+i\gamma)=0\), then
\[
\bigl\lvert\partial_t\eta_N^{(N^2)}(\tfrac12+i\gamma)\bigr\rvert
\le N^{1/2}\lvert\zeta'(\tfrac12+i\gamma)\rvert+O\bigl((1+\lvert\gamma\rvert)\log N\bigr).
\]
For each **fixed** such \(\gamma\) and each \(\varepsilon>0\), this is \(\le N^{1/2+\varepsilon}\) for all large \(N\).

## Truth 5.2 — Lemma 4.5.2

If \(\rho\) is a **simple** zero in the interior of \(S_\delta\), there is \(N_1(\rho)\) such that for \(N\ge N_1(\rho)\) and all \(s\) with \(\lvert s-\rho\rvert\le N^{-\varepsilon}\),
\[
\bigl\lvert\partial_t\eta_N^{(N^2)}(s)\bigr\rvert\ge\tfrac12 N^{1-\sigma}\lvert\zeta'(\rho)\rvert.
\]
If also \(\sigma\le\tfrac12-\delta\) with \(\delta>\varepsilon\), the right-hand side exceeds \(N^{1/2+\varepsilon}\) for all large \(N\).

## Truth 5.3 — Lemma 4.5.3

If \(\rho\) has multiplicity \(m\ge 1\), the same disk and the same \(N\)-threshold (now depending on \(\rho\) and \(m\)) give
\[
\bigl\lvert\partial_t^{\,m}\eta_N^{(N^2)}(s)\bigr\rvert\ge\tfrac12 N^{1-\sigma}\lvert\zeta^{(m)}(\rho)\rvert.
\]
If \(\sigma\le\tfrac12-\delta\) with \(\delta>\varepsilon\), this exceeds \(N^{1/2+\varepsilon}(2\log N)^m\) for all large \(N\).

## Truth 5.4

Therefore: no point of the isolation disk of a simple zero with \(\sigma\le\tfrac12-\varepsilon\) can satisfy \(\lvert\partial_t\eta\rvert\le N^{1/2+\varepsilon}\) for all large \(N\). No point of the isolation disk of a zero of multiplicity \(m\) with \(\sigma\le\tfrac12-\varepsilon\) can satisfy \(\lvert\partial_t^m\eta\rvert\le N^{1/2+\varepsilon}(2\log N)^m\) for all large \(N\).

These are statements about the Dirichlet polynomial \(\eta\), not about the Riemann hypothesis.

---
