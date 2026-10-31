//! The finite prime-power sum.
//!
//! `prime(c) = −2 Σ_{p^k ≤ X} (log p / p^{k/2}) √π σ
//!              exp(−(log(p^k) − c)²/(4σ²))`.
//!
//! Every term is an exact rational interval; `log`, `sqrt` and `exp` are
//! evaluated by MPFR with directed rounding.

use crate::interval::Iv;
use rug::Rational;

#[derive(Clone, Debug)]
pub struct PrimePower {
    pub p: u32,
    pub k: u32,
    pub power: u32,
    /// `log p / sqrt(p^k)`.
    pub weight: Iv,
    /// `log(p^k) = k log p`.
    pub v: Iv,
}

/// Sieve to `x` and collect `(weight, v)` for every prime power `p^k ≤ x`.
pub fn prime_power_data(x: u32) -> Vec<PrimePower> {
    let mut sieve = vec![true; (x + 1) as usize];
    sieve[0] = false;
    if x >= 1 {
        sieve[1] = false;
    }
    let mut p = 2u32;
    while (p as u64) * (p as u64) <= x as u64 {
        if sieve[p as usize] {
            let mut m = p * p;
            while m <= x {
                sieve[m as usize] = false;
                m += p;
            }
        }
        p += 1;
    }
    let mut data = Vec::new();
    for p in 2..=x {
        if !sieve[p as usize] {
            continue;
        }
        let log_p = Iv::point(Rational::from(p)).log();
        let mut power: u64 = p as u64;
        let mut k = 1u32;
        while power <= x as u64 {
            let pw = power as u32;
            let weight = log_p.div(&Iv::point(Rational::from(pw)).sqrt());
            let v = log_p.scale(&Rational::from(k));
            data.push(PrimePower {
                p,
                k,
                power: pw,
                weight,
                v,
            });
            power *= p as u64;
            k += 1;
        }
    }
    data
}

pub fn prime_iv(c: &Rational, sigma: &Rational, data: &[PrimePower]) -> Iv {
    let pref = Iv::pi().sqrt().scale(sigma);
    let four_s2 = Rational::from(4) * Rational::from(sigma * sigma);
    let mut total = Iv::from_i64(0);
    for term in data {
        let diff = term.v.sub(&Iv::point(c.clone()));
        let exponent = Iv::point(Rational::from(-1))
            .mul(&diff.pow_nat(2))
            .div(&Iv::point(four_s2.clone()));
        let conv = pref.mul(&exponent.exp());
        total = total.add(&term.weight.mul(&conv));
    }
    total.scale(&Rational::from(-2))
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::rational::parse_rational;

    #[test]
    fn prime_power_count() {
        assert_eq!(prime_power_data(20000).len(), 2328);
    }

    #[test]
    fn prime_term_is_narrow() {
        let sigma = parse_rational("1/20").unwrap();
        let data = prime_power_data(20000);
        let iv = prime_iv(&parse_rational("3/5").unwrap(), &sigma, &data);
        assert!(iv.width() < parse_rational("1/1000000000000").unwrap());
    }
}
