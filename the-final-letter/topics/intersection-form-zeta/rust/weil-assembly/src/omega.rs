//! The `Ω(t)` enclosure.
//!
//! Two enclosures live here:
//!
//! * [`omega_exact`] is the literal rational formula of the Lean theorem T79
//!   (`omegaLo t N M`, `omegaHi t N M`) using the slow `logPointLo/Hi` series
//!   of T32.  It is used for `Ω(0)` and for unit tests; at large `q` the T32
//!   series is far too slow, so it is *not* used in the density quadrature.
//! * [`omega_panel_iv`] re-derives the same Euler–Maclaurin decomposition with
//!   an MPFR `log` enclosure instead of the T32 series.  The decomposition is
//!   identical, so the argument of T79 applies verbatim: the only inputs are
//!   `log q ≤ log q` and `log π ≥ log π`, and the same T79 remainder
//!   `1/(81 (N+1/4)^5)` bounds the Euler–Maclaurin tail.  This is what makes
//!   the per-panel density enclosure practical.
//!
//! T79 requires `t ≠ 0`.  The single panel adjacent to the origin is handled in
//! [`crate::density`] with [`psi_bound_one_upper`] instead.

use crate::interval::{Fv, Iv};
use crate::rational::parse_rational;
use rug::ops::Pow;
use rug::Rational;

/// `logTermQ(a,k) = 2 (1/(2k+1)) (a/(a+2))^(2k+1)` summed over `k < n`.
pub fn log_partial_q(n: u32, a: &Rational) -> Rational {
    let two = Rational::from(2);
    let den = Rational::from(a + &two);
    let r = Rational::from(a / den);
    let r2 = Rational::from(&r * &r);
    let mut term = r;
    let mut sum = Rational::from(0);
    for k in 0..n {
        let coeff = Rational::from(2) / Rational::from(2 * k + 1);
        sum += Rational::from(&coeff * &term);
        term = Rational::from(&term * &r2);
    }
    sum
}

/// `logRemQ(N,a) = 2 (a/(a+2))^(2N+1) / ((2N+1)(1 - (a/(a+2))^2))`.
pub fn log_rem_q(n: u32, a: &Rational) -> Rational {
    let two = Rational::from(2);
    let den = Rational::from(a + &two);
    let r = Rational::from(a / den);
    let r2 = Rational::from(&r * &r);
    let mut pow = r.clone();
    for _ in 0..n {
        pow = Rational::from(&pow * &r2);
    }
    let numerator = Rational::from(2) * pow;
    let denominator = Rational::from(2 * n + 1) * (Rational::from(1) - r2);
    numerator / denominator
}

pub fn log_point_lo(n: u32, x: &Rational) -> Rational {
    log_partial_q(n, &Rational::from(x - 1))
}

pub fn log_point_hi(n: u32, x: &Rational) -> Rational {
    log_partial_q(n, &Rational::from(x - 1)) + log_rem_q(n, &Rational::from(x - 1))
}

/// Rational interval for `log x`, `x ≥ 1`.
pub fn log_point_iv(n: u32, x: &Rational) -> Iv {
    Iv::new(log_point_lo(n, x), log_point_hi(n, x))
}

fn harmonic(n: u32) -> Rational {
    let mut h = Rational::from(0);
    for k in 1..=n {
        h += Rational::from(1) / Rational::from(k);
    }
    h
}

/// The Lean `gammaLo` constant (T32/T33), from `gammaBoundLo 200`.
pub fn gamma_lo(n: u32) -> Rational {
    let log200_hi = log_point_hi(n, &Rational::from(2))
        + Rational::from(2) * log_point_hi(n, &Rational::from(10));
    harmonic(200) - log200_hi - Rational::from(1) / Rational::from(400)
}

/// The Lean `gammaHi` constant (T32/T33), from `gammaBoundHi 200`.
pub fn gamma_hi(n: u32) -> Rational {
    let log200_lo = log_point_lo(n, &Rational::from(2))
        + Rational::from(2) * log_point_lo(n, &Rational::from(10));
    harmonic(200) - log200_lo - Rational::from(1) / Rational::from(402)
}

/// `Ω(0) = −log π − γ − π/2 − 3 log 2`, as the Lean rational interval
/// `omegaZeroLo N ≤ Ω(0) ≤ omegaZeroHi N` (T34–T37).
pub fn omega_zero(n: u32) -> (Rational, Rational) {
    let pi_lo = crate::interval::pi_lo();
    let pi_hi = crate::interval::pi_hi();
    let log2_lo = log_point_lo(n, &Rational::from(2));
    let log2_hi = log_point_hi(n, &Rational::from(2));
    let logpi_lo = log_point_lo(n, &pi_lo);
    let logpi_hi = log_point_hi(n, &pi_hi);
    let g_lo = gamma_lo(n);
    let g_hi = gamma_hi(n);
    let lo = -logpi_hi - g_hi - Rational::from(&pi_hi / 2)
        - Rational::from(3) * log2_hi;
    let hi = -logpi_lo - g_lo - Rational::from(&pi_lo / 2)
        - Rational::from(3) * log2_lo;
    (lo, hi)
}

/// Exact T79 rational enclosure (the Lean `omegaLo`/`omegaHi` formulas).
/// Returns `None` at `t = 0`, where T79 does not apply.
pub fn omega_exact(t: &Rational, n: u32, m: u32) -> Option<(Rational, Rational)> {
    if *t == 0 {
        return None;
    }
    let re_w = Rational::from(n) + Rational::from(1) / Rational::from(4);
    let im_w = Rational::from(t / 2);
    let q = Rational::from(&re_w * &re_w) + Rational::from(&im_w * &im_w);
    let q2 = Rational::from(&q * &q);
    let q4 = Rational::from(&q2 * &q2);
    let two = Rational::from(2);
    let t1 = Rational::from(&re_w / (Rational::from(2) * &q));
    let t2 = Rational::from(
        (Rational::from(&re_w * &re_w) - Rational::from(&im_w * &im_w))
            / (Rational::from(12) * &q2),
    );
    let a = Rational::from(&re_w * &re_w) - Rational::from(&im_w * &im_w);
    let b = Rational::from(2) * Rational::from(&re_w * &im_w);
    let t4 = Rational::from((Rational::from(&a * &a) - Rational::from(&b * &b))
        / (Rational::from(120) * &q4));
    let rem = Rational::from(1) / (Rational::from(81) * re_w.pow(5u32));

    let mut sum = Rational::from(0);
    for k in 0..n {
        let re_k = Rational::from(k) + Rational::from(1) / Rational::from(4);
        let den = Rational::from(&re_k * &re_k) + Rational::from(&im_w * &im_w);
        sum += Rational::from(&re_k / &den);
    }

    let logq_lo = log_point_lo(m, &q);
    let logq_hi = log_point_hi(m, &q);
    let logpi_lo = log_point_lo(m, &crate::interval::pi_lo());
    let logpi_hi = log_point_hi(m, &crate::interval::pi_hi());

    let half = Rational::from(1) / Rational::from(2);
    let mut base = Rational::from(-&t1);
    base -= &t2;
    base += &t4;
    base -= &sum;
    let lo = half.clone() * logq_lo + &base - &rem - &logpi_hi;
    let hi = half * logq_hi + &base + &rem - &logpi_lo;
    let _ = two;
    Some((lo, hi))
}

/// `psiSeriesBound 1` upper bound, by the integral test.
///
/// `ψ'(1/4) = Σ_{j≥0} (j+1/4)^(-2)` and
/// `psiSeriesBound 1 = (1/2) Σ_{j≥0} (j+1/4)^(-2)`.  We bound the tail from
/// `J = 100` by `f(J) + ∫_J^∞ f`, where `f(x) = (x+1/4)^(-2)` is decreasing.
/// The result is ≈ 8.7, comfortably below the emitted `10`.
pub fn psi_bound_one_upper() -> Rational {
    let j: u32 = 100;
    let mut sum = Rational::from(0);
    for k in 0..j {
        let x = Rational::from(4 * k + 1);
        sum += Rational::from(16) / Rational::from(&x * &x);
    }
    let x = Rational::from(4 * j + 1);
    let tail = Rational::from(16) / Rational::from(&x * &x) + Rational::from(4) / x;
    Rational::from((sum + tail) / 2)
}

fn fv_point(q: &Rational) -> Fv {
    Fv::point(q)
}

/// MPFR per-panel enclosure of `Ω(t)` for `t ∈ panel` with `0 ∉ panel`.
///
/// Uses the T79 Euler–Maclaurin decomposition with an MPFR `log` enclosure and
/// the T79 remainder `1/(81 (N+1/4)^5)`.
pub fn omega_panel_iv(t: &Fv, n: u32) -> Fv {
    let two = Fv::from_i64(2);
    let twelve = Fv::from_i64(12);
    let one_twenty = Fv::from_i64(120);

    let re_w = fv_point(&(Rational::from(n) + Rational::from(1) / Rational::from(4)));
    let im_w = t.div(&two);
    let re_w2 = re_w.pow_nat(2);
    let im_w2 = im_w.pow_nat(2);
    let q = re_w2.add(&im_w2);
    let q2 = q.pow_nat(2);
    let q4 = q.pow_nat(4);

    let t1 = re_w.div(&two.mul(&q));
    let t2 = re_w2.sub(&im_w2).div(&twelve.mul(&q2));
    let a = re_w2.sub(&im_w2);
    let b = two.mul(&re_w).mul(&im_w);
    let t4 = a.pow_nat(2).sub(&b.pow_nat(2)).div(&one_twenty.mul(&q4));

    // rem = 1 / (81 * (N + 1/4)^5), exact rational.
    let re_w_rat = Rational::from(n) + Rational::from(1) / Rational::from(4);
    let rem_rat = Rational::from(1)
        / (Rational::from(81) * re_w_rat.clone().pow(5u32));
    let rem = fv_point(&rem_rat);

    let mut sum = Fv::from_i64(0);
    for k in 0..n {
        let re_k = fv_point(&(Rational::from(k) + Rational::from(1) / Rational::from(4)));
        let den = re_k.pow_nat(2).add(&im_w2);
        sum = sum.add(&re_k.div(&den));
    }

    let logq = q.log();
    let logpi = Fv::pi().log();

    // L(t) = ½ log q − t1 − t2 + t4 − rem − sum − log π
    let lo_expr = logq
        .mul(&Fv::from_i64(1).div(&two))
        .sub(&t1)
        .sub(&t2)
        .add(&t4)
        .sub(&rem)
        .sub(&sum)
        .sub(&logpi);
    // U(t) = ½ log q − t1 − t2 + t4 + rem − sum − log π
    let hi_expr = logq
        .mul(&Fv::from_i64(1).div(&two))
        .sub(&t1)
        .sub(&t2)
        .add(&t4)
        .add(&rem)
        .sub(&sum)
        .sub(&logpi);

    Fv::new(lo_expr.lo, hi_expr.hi)
}

/// Enclosure of `Ω(t)` at a rational point (or `Ω(0)` via [`omega_zero`]).
pub fn omega_point(t: &Rational, n: u32, m: u32) -> Iv {
    if *t == 0 {
        let (lo, hi) = omega_zero(m);
        Iv::new(lo, hi)
    } else {
        let panel = Fv::point(t);
        let iv = omega_panel_iv(&panel, n);
        iv.to_iv()
    }
}

/// Convenience: the T79 enclosure for unit tests, as an `Iv`.
pub fn omega_exact_iv(t: &str, n: u32, m: u32) -> Iv {
    let tv = parse_rational(t).unwrap();
    match omega_exact(&tv, n, m) {
        Some((lo, hi)) => Iv::new(lo, hi),
        None => {
            let (lo, hi) = omega_zero(m);
            Iv::new(lo, hi)
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::rational::parse_rational;

    fn ref_omega(t: &str) -> Rational {
        parse_rational(t).unwrap()
    }

    #[test]
    fn t79_exact_encloses_reference_values() {
        // Reference values from mpmath at 40 digits (see tests/test_rust_certificate.py).
        let cases = [
            ("1/2", "-3.33200459468089660905168"),
            ("1", "-2.025146193103467200296543"),
            ("5", "-0.2301182182455977372630031"),
            ("10", "0.464290626864930281278861"),
        ];
        for (t, expected) in cases {
            let (lo, hi) = omega_exact(&parse_rational(t).unwrap(), 10, 200).unwrap();
            let value = ref_omega(expected);
            assert!(lo <= value && value <= hi, "T79 misses Omega({t})");
            assert!(Rational::from(&hi - &lo) < parse_rational("1/1000").unwrap());
        }
    }

    #[test]
    fn omega_zero_encloses_reference_value() {
        let (lo, hi) = omega_zero(200);
        let value = parse_rational("-5.372183419225665582232957").unwrap();
        assert!(lo <= value && value <= hi);
        assert!(Rational::from(&hi - &lo) < parse_rational("1/10000").unwrap());
    }

    #[test]
    fn mpfr_enclosure_at_points_matches_reference() {
        for (t, expected) in [
            ("1/2", "-3.33200459468089660905168"),
            ("1", "-2.025146193103467200296543"),
            ("10", "0.464290626864930281278861"),
            ("100", "2.767288952839158706482471"),
        ] {
            let iv = omega_point(&parse_rational(t).unwrap(), 30, 200);
            let value = parse_rational(expected).unwrap();
            assert!(iv.contains(&value), "MPFR enclosure misses Omega({t})");
            assert!(iv.width() < parse_rational("1/1000").unwrap());
        }
    }

    #[test]
    fn psi_bound_is_below_ten() {
        let b = psi_bound_one_upper();
        assert!(b > 0);
        assert!(b < Rational::from(10));
        // The exact value is psiSeriesBound 1 = psi'(1/4)/2 ~ 8.6.
        assert!(b > parse_rational("8").unwrap());
    }
}
