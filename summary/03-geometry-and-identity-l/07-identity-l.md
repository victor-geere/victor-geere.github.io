# Identity L (slow passage; proved)

| Field | Value |
|---|---|
| Type | Identity |
| Status | Proved (Lemma 4.5.2) |
| Source | [publication.html §4](publication.html#sec4) · 4. Quadratic scaling and the explicit remainder |
| Proof in source | no separate proof block |

> **Editorial note.** Identity L is not a separate proof: its content is exactly the lower bound of Lemma 4.5.2, with the geometric reading added. The proof of Lemma 4.5.2 is the proof.

## Statement

Let \(\rho=\sigma+i\gamma\) be a simple zero of \(\Xi\) with \(\sigma\le\tfrac12-\delta\) and \(\delta>0\). Then for every \(\varepsilon\in(0,\min(\delta,1/6))\) and every integer \(N\) large enough that \(\lvert\gamma\rvert\le N^{1/2-\varepsilon}\), \[
\bigl\lvert\partial_t\eta_N^{(N^2)}(s)\bigr\rvert\ge\tfrac12 N^{1-\sigma}\lvert\zeta'(\rho)\rvert> N^{1/2+\varepsilon}
\] throughout the isolation disk \(\lvert s-\rho\rvert\le N^{-\varepsilon}\). Geometrically: the last chord of Lemma 4.3.3 has size \(\tfrac12 N^{1-2\sigma}\) and is cancelled, in that disk, by the main-term slope \(P_N\zeta'\asymp N^{1-\sigma}\lvert\zeta'\rvert\). The cancellation is a high-speed transit through a small neighbourhood of the origin, not a slow Hilbert-cell visit. Envelope non-degeneracy \(\lvert\eta(\rho)\rvert\ge c\,D_N\) is false throughout the band \(\sigma>\tfrac14+\varepsilon/2\) (Corollary 4.3.1) — and true below it, where the floor of Corollary 4.3.2 exceeds \(D_N\) — so it is not the identity. The remaining simple abscissae for a fixed construction with parameter \(\varepsilon\) are \(\tfrac12-\varepsilon<\sigma\le\tfrac12+\varepsilon/2\). For multiplicity \(m\ge 2\), Lemma 4.5.3 is the same comparison on \(\partial_t^{\,m}\eta\). See [gaps.html](gaps.html).

## Proof

Identity L is the geometric reading of [Lemma 4.5.2](summary/03-geometry-and-identity-l/05-lemma-4.5.2.md); the proof is the proof of that lemma. In outline: write $s=\rho+h$ with $\lvert h\rvert\le N^{-\varepsilon}$ and expand $\zeta(s)=\zeta'(\rho)h+O_\rho(h^2)$, $\zeta'(s)=\zeta'(\rho)+O_\rho(h)$. Substitution into the differentiated remainder of Lemma 4.5 gives the leading term $i(1-N^{1-s})\zeta'(s)$, of size $(N^{1-\sigma}+O(1))\lvert\zeta'(\rho)\rvert+O_\rho(N^{-\varepsilon})$, against a half-term derivative of size $O(N^{1-2\sigma}\log N)$. For $\sigma\le\tfrac12-\delta$ with $\delta>\varepsilon$, the main term exceeds $N^{1/2+\varepsilon}$ on the isolation disk, while the half-term does not. The full computation is in the lemma file.

The geometric reading is explanatory: the last chord has size $\tfrac12N^{1-2\sigma}$ and is cancelled by the main-term slope $P_N\zeta'\asymp N^{1-\sigma}\lvert\zeta'\rvert$. The cancellation is a high-speed transit, not a slow passage, so a balanced closure (which requires $\lvert\partial_t\eta\rvert\le N^{1/2+\varepsilon}$) cannot occur there.
