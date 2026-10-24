"""Exact computation layer for the iota-helix programme.

The package exposes :mod:`programme`, a sympy-only module implementing the
finite iota walk and the real-axis Dirichlet-eta identities.
"""

from .programme import (  # noqa: F401
    PI,
    eta_partial,
    eta_term,
    eta_x,
    eta_y,
    greedy_dot,
    helix_x,
    helix_y,
    paired_partial,
    phase,
    radius,
    source_greedy_dot,
)

__all__ = [
    "PI",
    "eta_partial",
    "eta_term",
    "eta_x",
    "eta_y",
    "greedy_dot",
    "helix_x",
    "helix_y",
    "paired_partial",
    "phase",
    "radius",
    "source_greedy_dot",
]
