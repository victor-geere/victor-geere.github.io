"""Quaternion–cosine framework computation package."""
from .programme import (
    PI,
    alignment_energy,
    detector,
    detector_on_divisors,
    displacement_quaternion,
    divisors_exact,
    is_aligned,
    is_divisor,
    phase,
    quaternion_mul,
    quaternion_norm_sq,
    warp_factor,
    warped_height,
)

__all__ = [
    "PI",
    "alignment_energy",
    "detector",
    "detector_on_divisors",
    "displacement_quaternion",
    "divisors_exact",
    "is_aligned",
    "is_divisor",
    "phase",
    "quaternion_mul",
    "quaternion_norm_sq",
    "warp_factor",
    "warped_height",
]
