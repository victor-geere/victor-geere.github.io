"""Exact computation layer for the Harmonic Sine Transform (HST) programme.

The package is deliberately small: ``python.programme`` contains the exact
greedy digit recursion, the threshold scan, and the Haar wavelet integrals.
There are no import-time side effects and no numerical approximations.
"""

from .programme import (  # noqa: F401
    HaarWavelet,
    alpha,
    alpha_scaled,
    greedy_accumulated,
    greedy_digits,
    haar_mean,
    haar_norm_sq,
    inner_product,
    reconstructed_wavelet,
    residual,
    source_wavelet,
    thresholds_exact,
    tree_intervals,
    tree_wavelets,
)

__all__ = [
    "HaarWavelet",
    "alpha",
    "alpha_scaled",
    "greedy_accumulated",
    "greedy_digits",
    "haar_mean",
    "haar_norm_sq",
    "inner_product",
    "reconstructed_wavelet",
    "residual",
    "source_wavelet",
    "thresholds_exact",
    "tree_intervals",
    "tree_wavelets",
]
