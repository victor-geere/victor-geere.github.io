"""Computation layer for the absolute polarized Hodge-index reconstruction.

The dossier's exact and high-precision computations live in small focused
modules in this directory (``local_polarization``, ``rescue_probe``,
``ccm_fast``, …).  This module gathers the entry points quoted in the
programme's computation ledger under one importable API, so that callers and
``tests/test_programme.py`` can use a single, documented surface.

Importing the module performs no computation: every dependency is imported
lazily inside the function that needs it.
"""

from __future__ import annotations

__all__ = [
    "local_hodge_index",
    "finite_hodge_riemann_half_weight",
    "finite_crossed_product_hodge_index",
    "kms_kernel_form",
    "krein_hodge_realization",
    "ccm_probe_accuracy",
    "archimedean_symbol_identity",
    "symbol_identity_check",
    "gaussian_gram_4x4",
    "recorded_gram6_certificate",
    "spectral_gap",
    "smooth_window_gap",
    "prime_arch_split",
    "uv_localisation",
    "generic_resonance",
]


# ---------------------------------------------------------------------------
# local rank-three model
# ---------------------------------------------------------------------------

def local_hodge_index(grid: int = 4) -> dict:
    """Local rank-three Hodge index of the fibre ``E_p x E_p``.

    The Néron–Severi space has basis ``H, V, Δ`` with Gram matrix ``B`` and
    ample class ``A = H + V + Δ``.  The function checks, over the integer cube
    ``[-grid, grid]^3``, that

    * ``6 d² ≤ (A·d)²`` (the Hodge index), and
    * the defect identity ``(A·d)² − 6 d² = 2((a−b)² + (b−c)² + (c−a)²)``,

    and that ``B`` restricted to ``A^⊥`` is negative definite.  The same
    statements are Lean-proved in ``lean/Shadow.lean``
    (``hodge_defect_identity``, ``hodge_index_explicit``).

    Raises ``ValueError`` for ``grid < 1``.
    """
    if grid < 1:
        raise ValueError("grid must be a positive integer")
    import numpy as np

    import local_polarization as L

    hodge_ok = True
    defect_ok = True
    for a in range(-grid, grid + 1):
        for b in range(-grid, grid + 1):
            for c in range(-grid, grid + 1):
                d = (a, b, c)
                if not L.hodge_holds(d):
                    hodge_ok = False
                if (6 * L.intersection(d, d) - L.intersection(L.A, d) ** 2
                        != L.defect(d)):
                    defect_ok = False
    on_orthogonal = L.restricted_gram([[1, -1, 0], [1, 1, -2]])
    return {
        "grid": grid,
        "signature": L.signature(),
        "ample_square": L.intersection(L.A, L.A),
        "hodge_index_ok": hodge_ok,
        "defect_identity_ok": defect_ok,
        "restricted_gram": on_orthogonal.tolist(),
        "negative_definite_on_ample_orthogonal": bool(
            np.all(np.linalg.eigvalsh(on_orthogonal.astype(float)) < 0)
        ),
    }


# ---------------------------------------------------------------------------
# finite positivity layers
# ---------------------------------------------------------------------------

def finite_hodge_riemann_half_weight(n: int = 3, seed: int = 5) -> dict:
    """Finite Hodge–Riemann half-weight form on a random state.

    Checks the explicit formula for ``C_s`` against its definition and that the
    half-weight polarization ``C_{1/2}`` is positive on a random density matrix
    of size ``n``.  Dossier note 04; the finite algebra is the same as the
    half-weight positivity used by the Lean layer.
    """
    import kms_transverse as K

    import finite_hodge_riemann as H

    rho = K.random_density(n, seed=seed)
    a = K.hermitian_basis(n)[-1]
    return {
        "n": n,
        "seed": seed,
        "half_weight_positive": bool(H.half_weight_positive(rho)),
        "C_half": float(H.C_s(rho, a, 0.5)),
        "transverse": float(K.transverse_form(rho, a)),
    }


def finite_crossed_product_hodge_index(n: int = 3) -> dict:
    """Finite crossed-product Hodge index (note 05).

    ``A = C*(Z/3) ⋊ Z/2`` is the group algebra of ``S_3`` in its regular
    representation.  For the tracial and a non-tracial faithful state, the
    transverse form is negative semidefinite on the self-adjoint part of the
    kernel of the state.
    """
    import finite_crossed_product as FC

    return {
        "n": n,
        "dimension": len(FC.group_elements(n)),
        "tracial_ok": bool(FC.hodge_index_holds(FC.tracial_state(n), n)),
        "nontracial_ok": bool(FC.hodge_index_holds(FC.nontracial_state(n), n)),
    }


def kms_kernel_form(n: int = 3, seed: int = 0) -> dict:
    """KMS transverse form restricted to the kernel of a random state.

    The finite theorem of note 03 says the transverse form ``-B`` is negative
    semidefinite on the self-adjoint part of the kernel of the state; this
    returns its eigenvalues.  Lean counterpart: ``Rescue.kmsForm_nonneg``.
    """
    import numpy as np

    import kms_transverse as K

    rho = K.random_density(n, seed=seed)
    m = K.form_matrix_on_kernel(rho)
    eig = np.linalg.eigvalsh((m + m.conj().T) / 2)
    return {
        "n": n,
        "seed": seed,
        "eigenvalues": [float(x) for x in eig],
        "negative_semidefinite": bool(np.all(eig <= 1e-8)),
    }


def krein_hodge_realization() -> dict:
    """Krein-space Hodge-index realization (note 08).

    Builds the Lorentzian form ``Q`` on the rank-three local model, the
    fundamental symmetry ``S`` (``S² = 1``, ``SᵀQS = Q``) and
    ``h = QS ≻ 0``, and reports the signatures.
    """
    import krein_hodge as K

    out = K.check_krein(K.local_B(), K.local_A())
    return {
        "S_squared_error": float(out["S2"]),
        "preserves_Q_error": float(out["preserves"]),
        "fixes_ample_error": float(out["S_A"]),
        "signature_S": list(out["signature_S"]),
        "signature_h": list(out["signature_h"]),
    }


# ---------------------------------------------------------------------------
# CCM probe and the symbol
# ---------------------------------------------------------------------------

def ccm_probe_accuracy() -> dict:
    """Agreement of the fast CCM probe with the mpmath probe (note 09).

    Returns the maximum absolute deviation between the vectorised
    Gauss–Legendre matrix and the stored high-precision matrix, together with
    the tolerance used by the test suite.
    """
    import numpy as np

    import ccm_fast as F

    m = F.fast_matrix()
    return {
        "max_deviation": float(np.max(np.abs(m - F.PROBE_MPMATH))),
        "tolerance": 1e-7,
    }


def archimedean_symbol_identity(xi: float = 10.0) -> dict:
    """``Re A_arch(ξ) = -Ω(ξ + i/2)/2`` (note 23; Lean ``arch_contour_identity``)."""
    import rescue_probe as R

    d = R.arch_identity(xi)
    return {
        "xi": float(xi),
        "ccm": float(d["ccm"]),
        "weil_shifted": float(d["weil_shifted"]),
        "difference": float(abs(d["diff"])),
    }


def symbol_identity_check(xi: float = 10.0) -> dict:
    """``A_arch(ξ) + Q(ξ) = -Z'/Z(-iξ)`` on ``Im ξ > 1`` (note 38 §3)."""
    import rescue_probe as R

    d = R.symbol_identity(xi)
    return {
        "xi": float(xi),
        "ccm": complex(d["ccm"]),
        "completed": complex(d["completed"]),
        "difference": complex(d["diff"]),
        "abs_difference": float(abs(d["diff"])),
    }


# ---------------------------------------------------------------------------
# Gaussian Gram: eigenvalues and interval certificates
# ---------------------------------------------------------------------------

def gaussian_gram_4x4(sigma: float = 0.05,
                      centres=(-0.3, -0.1, 0.1, 0.3)) -> dict:
    """Eigenvalues of the 4×4 Gaussian Weil Gram matrix (notes 38–41).

    ``W`` is the cosh ``+ Ω`` convention that the compact-support tests support;
    ``N`` is the recorded normalized convention, which is indefinite on the
    same basis.  This is a high-precision computation, not a certificate; the
    interval certificate is :func:`recorded_gram6_certificate`.
    """
    import rescue_probe as R

    d = R.gaussian_comparison(sigma=sigma, centres=centres)
    w_eig = [float(x.real) for x in d["W_eigenvalues"]]
    n_eig = [float(x.real) for x in d["N_eigenvalues"]]
    return {
        "sigma": float(sigma),
        "centres": list(centres),
        "W_eigenvalues": w_eig,
        "N_eigenvalues": n_eig,
        "W_psd": bool(min(w_eig) >= 0.0),
    }


def recorded_gram6_certificate(path=None) -> dict:
    """Replay the recorded 6×6 Gaussian Gram interval certificate.

    The JSON file stores the interval centres and half-widths.  The certificate
    is the box theorem: with ``t`` the maximum row sum of the half-widths (plus
    a slack), the exact rational leading minors of ``centre − t·I`` are all
    positive.  Dossier notes 44–45; the general box theorem is Lean-proved in
    ``lean/Shadow.lean`` (``posDef_of_box_rat``).
    """
    import json
    import pathlib

    import mpmath as mp

    import rescue_probe as R

    if path is None:
        path = pathlib.Path(__file__).with_name("gram6_certificate.json")
    with open(path) as fh:
        d = json.load(fh)
    n = len(d["centre"])
    G = [[mp.iv.mpf([d["centre"][i][j] - d["half"][i][j],
                     d["centre"][i][j] + d["half"][i][j]])
          for j in range(n)] for i in range(n)]
    c = R.interval_psd_check(G)
    return {
        "n": n,
        "ok": bool(c["ok"]),
        "t": float(c["t"]),
        "recorded_t": float(d["t"]),
        "minors": [float(m) for m in c["minors"]],
        "h": float(d["h"]),
        "T": float(d["T"]),
    }


# ---------------------------------------------------------------------------
# truncation diagnostics
# ---------------------------------------------------------------------------

def spectral_gap(k: int = 6, a: float = 1.5) -> dict:
    """Hodge-index spectral gap of the truncated CCM matrix (note 14).

    Even ``K`` gives a negative-definite ``R``; the gap is the smallest
    ``|eigenvalue|``.  Odd ``K`` has a zero mode (``degenerate=True``).
    """
    if k < 4:
        raise ValueError("k must be at least 4")
    import truncation_gap as TG

    d = TG.gap_for(k, a)
    return {
        "K": int(d["K"]),
        "dim": int(d["dim"]),
        "degenerate": bool(d["degenerate"]),
        "mu": [float(x) for x in d["mu"]],
        "min_gap": None if d["min_gap"] is None else float(d["min_gap"]),
    }


def smooth_window_gap(k: int = 12, window: str = "sin2", a: float = 1.5) -> dict:
    """Gap for a smooth cutoff window (notes 18–19)."""
    import window_robustness as WR

    if window not in WR.WINDOWS:
        raise ValueError(f"unknown window {window!r}; expected one of "
                         f"{sorted(WR.WINDOWS)}")
    d = WR.gap_window(k, window, a)
    return {
        "K": int(k),
        "window": window,
        "condition_number": float(d["cond"]),
        "gap": float(d["gap"]),
    }


def prime_arch_split(k: int = 12, a: float = 1.5) -> dict:
    """Prime and archimedean contributions to the gap (note 16)."""
    import prime_arch_split as PA

    d = PA.projected_spectra(k, a)
    return {
        "K": int(k),
        "prime": [float(x) for x in d["prime"]],
        "arch": [float(x) for x in d["arch"]],
        "total": [float(x) for x in d["total"]],
        "prime_min": float(min(d["prime"])),
        "arch_min": float(min(d["arch"])),
    }


def uv_localisation(k: int = 16, a: float = 1.5) -> dict:
    """Participation ratio of the small vectors (note 17)."""
    import uv_localization as UV

    d = UV.small_vectors(k, a)
    return {
        name: {
            "mu": float(part["mu"]),
            "participation_ratio": float(part["participation"]),
            "top_mass": float(part["top_mass"]),
            "top_modes": [int(i) for i in part["top"]],
        }
        for name, part in d.items()
    }


def generic_resonance(ks=(28, 32, 36, 40)) -> dict:
    """Gap table across ``K`` for two windows (notes 20–21)."""
    import generic_resonance as GR

    table = GR.resonance_table(ks)
    return {window: {int(k): float(v) for k, v in row.items()}
            for window, row in table.items()}
