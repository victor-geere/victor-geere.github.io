//! The Gaussian pole term.
//!
//! `pole(c) = 4 π σ² exp(σ²/4) cosh(c/2)`, entirely in exact rational
//! intervals.

use crate::interval::Iv;
use rug::Rational;

pub fn pole_iv(c: &Rational, sigma: &Rational) -> Iv {
    let four_s2 = Iv::point(Rational::from(4) * Rational::from(sigma * sigma));
    let s2 = Rational::from(sigma * sigma);
    let growth = Iv::point(Rational::from(&s2 / 4)).exp();
    let half_c = Rational::from(c) / 2;
    let cosh = Iv::point(half_c).cosh();
    four_s2.mul(&Iv::pi()).mul(&growth).mul(&cosh)
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::rational::parse_rational;

    #[test]
    fn pole_width_is_tiny() {
        let sigma = parse_rational("1/20").unwrap();
        for c in ["0", "1/5", "2/5", "3/5"] {
            let iv = pole_iv(&parse_rational(c).unwrap(), &sigma);
            assert!(iv.width() < parse_rational("1/1000000000000").unwrap());
        }
    }

    #[test]
    fn pole_is_even() {
        let sigma = parse_rational("1/20").unwrap();
        let c = parse_rational("3/5").unwrap();
        let plus = pole_iv(&c, &sigma);
        let minus = pole_iv(&-c, &sigma);
        assert_eq!(plus.lo, minus.lo);
        assert_eq!(plus.hi, minus.hi);
    }
}
