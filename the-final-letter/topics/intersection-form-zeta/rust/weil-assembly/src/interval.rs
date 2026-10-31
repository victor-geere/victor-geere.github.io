//! Two interval arithmetic layers.
//!
//! * [`Iv`] — exact rational intervals.  Used for the pole, the finite prime
//!   sum, the `Ω(0)` constants, and every final assembly step.
//! * [`Fv`] — MPFR intervals at [`PREC`] bits with directed rounding.  Used
//!   for the heavy density quadrature (the per-panel `Ω` enclosure and the
//!   oscillatory weight integral).  MPFR is correctly rounded, so the
//!   directed-rounding operations enclose the exact result; converting the
//!   final endpoints to [`rug::Rational`] is exact because every MPFR value is
//!   a dyadic rational.
//!
//! No `f64` appears anywhere in the certificate path.

use rug::float::Round;
use rug::ops::{AddAssignRound, DivAssignRound, MulAssignRound, SubAssignRound};
use rug::{Float, Rational};

/// MPFR working precision for the density quadrature.
pub const PREC: u32 = 256;

fn f_from_rat(r: &Rational, round: Round) -> Float {
    Float::with_val_round(PREC, r, round).0
}

fn f_add(a: &Float, b: &Float, round: Round) -> Float {
    let mut r = Float::with_val(PREC, a);
    r.add_assign_round(b, round);
    r
}

fn f_sub(a: &Float, b: &Float, round: Round) -> Float {
    let mut r = Float::with_val(PREC, a);
    r.sub_assign_round(b, round);
    r
}

fn f_mul(a: &Float, b: &Float, round: Round) -> Float {
    let mut r = Float::with_val(PREC, a);
    r.mul_assign_round(b, round);
    r
}

fn f_div(a: &Float, b: &Float, round: Round) -> Float {
    let mut r = Float::with_val(PREC, a);
    r.div_assign_round(b, round);
    r
}

fn f_min(a: Float, b: Float) -> Float {
    if a < b {
        a
    } else {
        b
    }
}

fn f_max(a: Float, b: Float) -> Float {
    if a > b {
        a
    } else {
        b
    }
}

fn f_abs(a: &Float) -> Float {
    let mut r = Float::with_val(PREC, a);
    r.abs_mut();
    r
}

// ---------------------------------------------------------------------------
// Exact rational pi bounds (the same decimal bounds as lean/Enclosure.lean).
// ---------------------------------------------------------------------------

pub fn pi_lo() -> Rational {
    "314159265358979323846/100000000000000000000"
        .parse()
        .unwrap()
}

pub fn pi_hi() -> Rational {
    "314159265358979323847/100000000000000000000"
        .parse()
        .unwrap()
}

// ---------------------------------------------------------------------------
// Iv: exact rational intervals
// ---------------------------------------------------------------------------

#[derive(Clone, Debug, PartialEq, Eq)]
pub struct Iv {
    pub lo: Rational,
    pub hi: Rational,
}

impl Iv {
    pub fn new(lo: Rational, hi: Rational) -> Self {
        assert!(lo <= hi, "interval with lo > hi: {lo} > {hi}");
        Iv { lo, hi }
    }

    pub fn point(q: Rational) -> Self {
        Iv {
            lo: q.clone(),
            hi: q,
        }
    }

    pub fn from_i64(n: i64) -> Self {
        Iv::point(Rational::from(n))
    }

    pub fn pi() -> Self {
        Iv::new(pi_lo(), pi_hi())
    }

    pub fn width(&self) -> Rational {
        Rational::from(&self.hi - &self.lo)
    }

    pub fn centre(&self) -> Rational {
        let sum = Rational::from(&self.lo + &self.hi);
        sum / 2
    }

    pub fn contains(&self, q: &Rational) -> bool {
        self.lo <= *q && *q <= self.hi
    }

    pub fn add(&self, other: &Iv) -> Iv {
        Iv::new(
            Rational::from(&self.lo + &other.lo),
            Rational::from(&self.hi + &other.hi),
        )
    }

    pub fn sub(&self, other: &Iv) -> Iv {
        Iv::new(
            Rational::from(&self.lo - &other.hi),
            Rational::from(&self.hi - &other.lo),
        )
    }

    pub fn neg(&self) -> Iv {
        Iv::new(
            Rational::from(-&self.hi),
            Rational::from(-&self.lo),
        )
    }

    pub fn mul(&self, other: &Iv) -> Iv {
        let p = [
            Rational::from(&self.lo * &other.lo),
            Rational::from(&self.lo * &other.hi),
            Rational::from(&self.hi * &other.lo),
            Rational::from(&self.hi * &other.hi),
        ];
        let mut lo = p[0].clone();
        let mut hi = p[0].clone();
        for q in p.iter().skip(1) {
            if *q < lo {
                lo = q.clone();
            }
            if *q > hi {
                hi = q.clone();
            }
        }
        Iv::new(lo, hi)
    }

    pub fn scale(&self, c: &Rational) -> Iv {
        self.mul(&Iv::point(c.clone()))
    }

    pub fn inv(&self) -> Iv {
        assert!(
            self.lo > 0 || self.hi < 0,
            "interval inversion through zero: [{}, {}]",
            self.lo,
            self.hi
        );
        Iv::new(
            Rational::from(Rational::from(1) / &self.hi),
            Rational::from(Rational::from(1) / &self.lo),
        )
    }

    pub fn div(&self, other: &Iv) -> Iv {
        self.mul(&other.inv())
    }

    pub fn pow_nat(&self, n: u32) -> Iv {
        let mut acc = Iv::from_i64(1);
        for _ in 0..n {
            acc = acc.mul(self);
        }
        acc
    }

    pub fn hull(&self, other: &Iv) -> Iv {
        Iv::new(
            if self.lo < other.lo {
                self.lo.clone()
            } else {
                other.lo.clone()
            },
            if self.hi > other.hi {
                self.hi.clone()
            } else {
                other.hi.clone()
            },
        )
    }

    /// Monotone increasing: `exp([lo, hi]) = [exp(lo) ↓, exp(hi) ↑]`.
    pub fn exp(&self) -> Iv {
        let mut a = f_from_rat(&self.lo, Round::Down);
        a.exp_round(Round::Down);
        let mut b = f_from_rat(&self.hi, Round::Up);
        b.exp_round(Round::Up);
        Iv::new(a.to_rational().unwrap(), b.to_rational().unwrap())
    }

    /// Monotone increasing on `(0, ∞)`.
    pub fn log(&self) -> Iv {
        assert!(self.lo > 0, "log of a non-positive interval");
        let mut a = f_from_rat(&self.lo, Round::Down);
        a.ln_round(Round::Down);
        let mut b = f_from_rat(&self.hi, Round::Up);
        b.ln_round(Round::Up);
        Iv::new(a.to_rational().unwrap(), b.to_rational().unwrap())
    }

    /// Monotone increasing on `[0, ∞)`.
    pub fn sqrt(&self) -> Iv {
        assert!(self.lo >= 0, "sqrt of a negative interval");
        let mut a = f_from_rat(&self.lo, Round::Down);
        a.sqrt_round(Round::Down);
        let mut b = f_from_rat(&self.hi, Round::Up);
        b.sqrt_round(Round::Up);
        Iv::new(a.to_rational().unwrap(), b.to_rational().unwrap())
    }

    pub fn abs(&self) -> Iv {
        if self.lo >= 0 {
            self.clone()
        } else if self.hi <= 0 {
            self.neg()
        } else {
            let a = Rational::from(-&self.lo);
            let b = self.hi.clone();
            let m = if a > b { a } else { b };
            Iv::new(Rational::from(0), m)
        }
    }

    pub fn cosh(&self) -> Iv {
        let a = self.abs();
        let e1 = a.exp();
        let e2 = a.neg().exp();
        let half = Rational::from(1) / Rational::from(2);
        e1.add(&e2).scale(&half)
    }

    /// `cos` on a short interval.  `cos` is 1-Lipschitz, so
    /// `cos(x) ∈ [cos(lo) - w, cos(lo) + w]` where `w = hi - lo`.
    pub fn cos(&self) -> Iv {
        let w = self.width();
        let mut a = f_from_rat(&self.lo, Round::Down);
        a.cos_round(Round::Down);
        let mut b = f_from_rat(&self.lo, Round::Up);
        b.cos_round(Round::Up);
        let lo = Rational::from(a.to_rational().unwrap() - &w);
        let hi = Rational::from(b.to_rational().unwrap() + &w);
        let minus_one = Rational::from(-1);
        let one = Rational::from(1);
        Iv::new(
            if lo < minus_one { minus_one.clone() } else { lo },
            if hi > one { one } else { hi },
        )
    }

    /// Outward round both endpoints onto the decimal grid `1/scale`.
    pub fn round_to_grid(&self, scale: &rug::Integer) -> Iv {
        let (lo, _) = crate::rational::round_outward(&self.lo, scale);
        let (_, hi) = crate::rational::round_outward(&self.hi, scale);
        Iv::new(lo, hi)
    }
}

// ---------------------------------------------------------------------------
// Fv: MPFR intervals with directed rounding
// ---------------------------------------------------------------------------

#[derive(Clone, Debug)]
pub struct Fv {
    pub lo: Float,
    pub hi: Float,
}

impl Fv {
    pub fn new(lo: Float, hi: Float) -> Self {
        assert!(lo <= hi, "Fv interval with lo > hi");
        Fv { lo, hi }
    }

    pub fn point(q: &Rational) -> Self {
        // The two conversions may differ by one ulp; both are kept so that the
        // point is enclosed.
        Fv::new(f_from_rat(q, Round::Down), f_from_rat(q, Round::Up))
    }

    pub fn from_i64(n: i64) -> Self {
        Fv::point(&Rational::from(n))
    }

    pub fn from_f64(x: f64) -> Self {
        let lo = Float::with_val_round(PREC, x, Round::Down).0;
        let hi = Float::with_val_round(PREC, x, Round::Up).0;
        Fv::new(lo, hi)
    }

    pub fn pi() -> Self {
        Fv::new(f_from_rat(&pi_lo(), Round::Down), f_from_rat(&pi_hi(), Round::Up))
    }

    pub fn width(&self) -> Float {
        f_sub(&self.hi, &self.lo, Round::Up)
    }

    /// Outward midpoint `(lo + hi)/2`.
    pub fn midpoint(&self) -> Fv {
        let two = Float::with_val(PREC, 2);
        Fv::new(
            f_div(&f_add(&self.lo, &self.hi, Round::Down), &two, Round::Down),
            f_div(&f_add(&self.lo, &self.hi, Round::Up), &two, Round::Up),
        )
    }

    /// Upward-rounded half-width `(hi - lo)/2`.
    pub fn radius(&self) -> Float {
        let two = Float::with_val(PREC, 2);
        f_div(&f_sub(&self.hi, &self.lo, Round::Up), &two, Round::Up)
    }

    pub fn add(&self, other: &Fv) -> Fv {
        Fv::new(
            f_add(&self.lo, &other.lo, Round::Down),
            f_add(&self.hi, &other.hi, Round::Up),
        )
    }

    pub fn sub(&self, other: &Fv) -> Fv {
        Fv::new(
            f_sub(&self.lo, &other.hi, Round::Down),
            f_sub(&self.hi, &other.lo, Round::Up),
        )
    }

    pub fn neg(&self) -> Fv {
        Fv::new(
            Float::with_val(PREC, -&self.hi),
            Float::with_val(PREC, -&self.lo),
        )
    }

    pub fn mul(&self, other: &Fv) -> Fv {
        let lo = f_min(
            f_min(
                f_mul(&self.lo, &other.lo, Round::Down),
                f_mul(&self.lo, &other.hi, Round::Down),
            ),
            f_min(
                f_mul(&self.hi, &other.lo, Round::Down),
                f_mul(&self.hi, &other.hi, Round::Down),
            ),
        );
        let hi = f_max(
            f_max(
                f_mul(&self.lo, &other.lo, Round::Up),
                f_mul(&self.lo, &other.hi, Round::Up),
            ),
            f_max(
                f_mul(&self.hi, &other.lo, Round::Up),
                f_mul(&self.hi, &other.hi, Round::Up),
            ),
        );
        Fv::new(lo, hi)
    }

    pub fn scale(&self, c: &Fv) -> Fv {
        self.mul(c)
    }

    pub fn inv(&self) -> Fv {
        assert!(
            self.lo > 0 || self.hi < 0,
            "Fv inversion through zero"
        );
        let one = Float::with_val(PREC, 1);
        Fv::new(
            f_div(&one, &self.hi, Round::Down),
            f_div(&one, &self.lo, Round::Up),
        )
    }

    pub fn div(&self, other: &Fv) -> Fv {
        self.mul(&other.inv())
    }

    pub fn pow_nat(&self, n: u32) -> Fv {
        // Exponentiation by squaring, every multiplication outward-rounded.
        let mut result = Fv::from_i64(1);
        let mut base = self.clone();
        let mut e = n;
        while e > 0 {
            if e & 1 == 1 {
                result = result.mul(&base);
            }
            e >>= 1;
            if e > 0 {
                base = base.mul(&base);
            }
        }
        result
    }

    pub fn exp(&self) -> Fv {
        let mut a = Float::with_val(PREC, &self.lo);
        a.exp_round(Round::Down);
        let mut b = Float::with_val(PREC, &self.hi);
        b.exp_round(Round::Up);
        Fv::new(a, b)
    }

    pub fn log(&self) -> Fv {
        assert!(self.lo > 0, "Fv log of a non-positive interval");
        let mut a = Float::with_val(PREC, &self.lo);
        a.ln_round(Round::Down);
        let mut b = Float::with_val(PREC, &self.hi);
        b.ln_round(Round::Up);
        Fv::new(a, b)
    }

    pub fn sqrt(&self) -> Fv {
        assert!(self.lo >= 0, "Fv sqrt of a negative interval");
        let mut a = Float::with_val(PREC, &self.lo);
        a.sqrt_round(Round::Down);
        let mut b = Float::with_val(PREC, &self.hi);
        b.sqrt_round(Round::Up);
        Fv::new(a, b)
    }

    pub fn abs(&self) -> Fv {
        if self.lo >= 0 {
            self.clone()
        } else if self.hi <= 0 {
            self.neg()
        } else {
            let a = f_abs(&self.lo);
            let b = f_abs(&self.hi);
            Fv::new(Float::with_val(PREC, 0), f_max(a, b))
        }
    }

    /// `|x|` upper bound as a single float.
    pub fn max_abs(&self) -> Float {
        f_max(f_abs(&self.lo), f_abs(&self.hi))
    }

    pub fn cosh(&self) -> Fv {
        let a = self.abs();
        let e1 = a.exp();
        let e2 = a.neg().exp();
        let two = Fv::from_i64(2);
        e1.add(&e2).div(&two)
    }

    /// `cos` on any interval: 1-Lipschitz padding around the left endpoint.
    pub fn cos(&self) -> Fv {
        let w = self.width();
        let mut a = Float::with_val(PREC, &self.lo);
        a.cos_round(Round::Down);
        let mut b = Float::with_val(PREC, &self.lo);
        b.cos_round(Round::Up);
        let lo = f_sub(&a, &w, Round::Down);
        let hi = f_add(&b, &w, Round::Up);
        let minus_one = Float::with_val(PREC, -1);
        let one = Float::with_val(PREC, 1);
        Fv::new(
            if lo < minus_one { minus_one.clone() } else { lo },
            if hi > one { one } else { hi },
        )
    }

    pub fn sin(&self) -> Fv {
        let w = self.width();
        let mut a = Float::with_val(PREC, &self.lo);
        a.sin_round(Round::Down);
        let mut b = Float::with_val(PREC, &self.lo);
        b.sin_round(Round::Up);
        let lo = f_sub(&a, &w, Round::Down);
        let hi = f_add(&b, &w, Round::Up);
        let minus_one = Float::with_val(PREC, -1);
        let one = Float::with_val(PREC, 1);
        Fv::new(
            if lo < minus_one { minus_one.clone() } else { lo },
            if hi > one { one } else { hi },
        )
    }

    pub fn to_iv(&self) -> Iv {
        Iv::new(
            self.lo.to_rational().unwrap(),
            self.hi.to_rational().unwrap(),
        )
    }

    pub fn round_to_grid(&self, scale: &rug::Integer) -> Iv {
        self.to_iv().round_to_grid(scale)
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    fn r(s: &str) -> Rational {
        crate::rational::parse_rational(s).unwrap()
    }

    #[test]
    fn rational_arithmetic() {
        let a = Iv::new(r("1/3"), r("1/2"));
        let b = Iv::new(r("-2"), r("3"));
        let p = a.mul(&b);
        assert_eq!(p.lo, r("-1"));
        assert_eq!(p.hi, r("3/2"));
        assert!(a.div(&a).contains(&r("1")));
    }

    #[test]
    fn exp_log_roundtrip() {
        let x = Iv::new(r("1/2"), r("3/4"));
        let y = x.log();
        assert!(y.lo <= r("-0.6931471805599453") && r("-0.6931471805599453") <= y.hi);
        let z = y.exp();
        assert!(z.lo <= r("1/2") && r("3/4") <= z.hi);
    }

    #[test]
    fn pi_contains_pi() {
        let p = Iv::pi();
        assert!(p.contains(&r("3.14159265358979323846")));
        assert!(p.width() < r("1/1000000000000000000"));
    }

    #[test]
    fn float_interval_contains_exact() {
        let a = Fv::point(&r("1/3"));
        let b = Fv::point(&r("3"));
        let p = a.mul(&b);
        assert!(p.lo <= Float::with_val(PREC, 1) && Float::with_val(PREC, 1) <= p.hi);
        let q = a.div(&b);
        assert!(q.lo <= Float::with_val(PREC, r("1/9")));
    }

    #[test]
    fn float_exp_log() {
        let x = Fv::point(&r("2"));
        let y = x.log();
        let e = y.exp();
        let target = Float::with_val(PREC, 2);
        assert!(e.lo <= target && target <= e.hi);
    }
}
