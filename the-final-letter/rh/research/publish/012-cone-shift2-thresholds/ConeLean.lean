/-
ConeLean.lean — root module of the cone development
(`research/twin-prime-parity/cone/cone-critical-pair-greedy.md`).

  * `ConeLean/Cone.lean`           the cone, the index readout, the critical weight,
                                   the one-power dichotomy
  * `ConeLean/PairThreshold.lean`  the radial-pair threshold and the ordering
  * `ConeLean/PairCensus.lean`     the pair alphabet, the pairing identity
                                   `Σ_k a_k = BPos p`, Brown's first condition
                                   `↔ Ψ(p) ≥ 0`, and the tail integral bound
  * `ConeLean/ChowlaEquiv.lean`    the exact equivalent form of the target
                                   `Σ λ(n)λ(n+2) = o(x)`: the pair-count identity,
                                   the four-pattern decomposition, and the
                                   equivalence with density `1/4` (conditional on
                                   the one-point input)
  * `ConeLean/ResidueReduction.lean`  the Abelian mean `ε Σ f(n)n^{−1−ε}`: discrete
                                   Abel summation, the weight-difference bound, and the
                                   reduction from `o(x)` and from the log-averaged
                                   input to the vanishing residue
  * `ConeLean/ShiftBarrier.lean`   barrier (b2): averaging the correlation over shifts does
                                   not bound a prescribed shift
  * `ConeLean/SpectralStructure.lean`  (b1) finite Wiener–Khinchin: the Fourier transform of
                                   the autocorrelation is the power spectrum, and vanishing
                                   correlations are equivalent to a flat spectrum
  * `ConeLean/LogAverageBarrier.lean`  (b3) a logarithmic average is blind to sets of zero
                                   harmonic density: the squares have bounded harmonic weight
  * `ConeLean/ParityObstruction.lean`  (c1) the correlation sequence is not multiplicative and
                                   not a convolution of multiplicative functions
  * `ConeLean/ShiftTwoCore.lean`   (goal 5) the parity split of shift 2: the even part is the
                                   solved shift-1 correlation, so the open content is the odd core
-/
import ConeLean.Cone
import ConeLean.PairThreshold
import ConeLean.PairCensus
import ConeLean.ChowlaEquiv
import ConeLean.ResidueReduction
import ConeLean.ShiftBarrier
import ConeLean.SpectralStructure
import ConeLean.LogAverageBarrier
import ConeLean.ParityObstruction
import ConeLean.ShiftTwoCore
