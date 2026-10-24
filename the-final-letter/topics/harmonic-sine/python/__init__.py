"""Harmonic sine computation package."""
from .programme import (
    PI,
    greedy_residuals,
    greedy_word,
    half_angle_sine,
    harmonic_angle,
    reconstruct_sine,
    residual_bound_holds,
    rotation_step,
    step_sine,
)

__all__ = [
    "PI",
    "harmonic_angle",
    "half_angle_sine",
    "step_sine",
    "rotation_step",
    "greedy_word",
    "greedy_residuals",
    "residual_bound_holds",
    "reconstruct_sine",
]
