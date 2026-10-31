//! Exact rational helpers and outward decimal-grid rounding.
//!
//! Every number that leaves the crate is a `rug::Rational`.  Internal
//! high-precision work uses [`crate::interval::Fv`] (MPFR floats with directed
//! rounding); the conversion back to `Rational` is exact because every MPFR
//! value is a dyadic rational.

use rug::ops::Pow;
use rug::{Integer, Rational};

/// Parse a rational written either as `"p/q"` or as a decimal string.
pub fn parse_rational(s: &str) -> Result<Rational, String> {
    let t = s.trim();
    if t.is_empty() {
        return Err("empty rational".to_string());
    }
    // `p/q` and plain integers.
    if let Ok(q) = t.parse::<Rational>() {
        return Ok(q);
    }
    // Decimal, optionally with an exponent: `1.25`, `-0.5`, `1e-3`.
    let (mantissa, exp) = match t.find(['e', 'E']) {
        Some(i) => (
            &t[..i],
            t[i + 1..]
                .parse::<i32>()
                .map_err(|e| format!("bad exponent in `{s}`: {e}"))?,
        ),
        None => (t, 0),
    };
    let (sign, mantissa) = if let Some(r) = mantissa.strip_prefix('-') {
        (-1i32, r)
    } else if let Some(r) = mantissa.strip_prefix('+') {
        (1, r)
    } else {
        (1, mantissa)
    };
    let (int_part, frac_part) = match mantissa.split_once('.') {
        Some((a, b)) => (a, b),
        None => (mantissa, ""),
    };
    if int_part.is_empty() && frac_part.is_empty() {
        return Err(format!("cannot parse rational `{s}`"));
    }
    let digits = format!(
        "{}{}",
        if int_part.is_empty() { "0" } else { int_part },
        frac_part
    );
    if !digits.chars().all(|c| c.is_ascii_digit()) {
        return Err(format!("cannot parse rational `{s}`"));
    }
    let mut num = digits
        .parse::<Integer>()
        .map_err(|e| format!("cannot parse rational `{s}`: {e}"))?;
    let mut den = Integer::from(10).pow(frac_part.len() as u32);
    if exp >= 0 {
        num *= Integer::from(10).pow(exp as u32);
    } else {
        den *= Integer::from(10).pow((-exp) as u32);
    }
    if sign < 0 {
        num = -num;
    }
    Ok(Rational::from((num, den)))
}

/// `"p/q"` for a rational; integers are written without a denominator.
pub fn rat_json(q: &Rational) -> String {
    if *q.denom() == 1 {
        q.numer().to_string()
    } else {
        format!("{}/{}", q.numer(), q.denom())
    }
}

/// A Lean rational literal.  `0` and `1` are emitted as plain numerals so that
/// `decide` can see the triangular structure of `certL`.
pub fn lean_rat(q: &Rational) -> String {
    if *q == 0 {
        "0".to_string()
    } else if *q == 1 {
        "1".to_string()
    } else if *q.denom() == 1 {
        format!("({} : ℚ)", q.numer())
    } else {
        format!("(({} : ℚ) / {})", q.numer(), q.denom())
    }
}

/// Round `q` outward (down for `lo`, up for `hi`) to the grid `1/scale`.
///
/// The returned pair `(lo, hi)` satisfies `lo ≤ q ≤ hi` and both endpoints are
/// integer multiples of `1/scale`.  Keeping the grid coarse keeps the emitted
/// Lean literals small; the extra width is far below the certificate margin.
pub fn round_outward(q: &Rational, scale: &Integer) -> (Rational, Rational) {
    let n = Integer::from(q.numer() * scale);
    let d = q.denom().clone();
    let (floor, rem) = n.div_rem_floor(d);
    let lo = Rational::from((floor.clone(), scale.clone()));
    let floor_plus_one = if rem == 0 { floor } else { floor + 1 };
    let hi = Rational::from((floor_plus_one, scale.clone()));
    (lo, hi)
}

/// Round `q` to the nearest grid point `k/scale`.
pub fn round_nearest(q: &Rational, scale: &Integer) -> Rational {
    let n = Integer::from(q.numer() * scale);
    let d = q.denom().clone();
    let (floor, rem) = n.div_rem_floor(d.clone());
    let twice = Integer::from(&rem * 2);
    let k = if twice >= d { floor + 1 } else { floor };
    Rational::from((k, scale.clone()))
}

/// The decimal grid `10^digits` used for all emitted endpoints.
pub fn decimal_scale(digits: u32) -> Integer {
    Integer::from(10).pow(digits)
}

/// Upward-rounded value of `10^digits`.
pub fn decimal_scale_rational(digits: u32) -> Rational {
    Rational::from(decimal_scale(digits))
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn grid_rounding_is_outward() {
        let scale = decimal_scale(6);
        let q = parse_rational("0.123456789").unwrap();
        let (lo, hi) = round_outward(&q, &scale);
        assert!(lo <= q && q <= hi);
        assert_eq!(lo, parse_rational("0.123456").unwrap());
        assert_eq!(hi, parse_rational("0.123457").unwrap());
    }

    #[test]
    fn negative_grid_rounding_is_outward() {
        let scale = decimal_scale(4);
        let q = parse_rational("-1.234567").unwrap();
        let (lo, hi) = round_outward(&q, &scale);
        assert!(lo <= q && q <= hi);
        assert_eq!(lo, parse_rational("-1.2346").unwrap());
        assert_eq!(hi, parse_rational("-1.2345").unwrap());
    }
}
