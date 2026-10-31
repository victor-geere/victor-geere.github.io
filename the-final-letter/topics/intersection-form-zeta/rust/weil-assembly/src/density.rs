//! Certified density integral
//!
//! `density(c) = 2 σ² ∫_0^∞ exp(−σ² t²) cos(c t) Ω(t) dt`.
//!
//! Per panel `[a,b]`:
//!
//! 1. [`crate::omega::omega_panel_iv`] encloses `Ω` on the whole panel.
//! 2. The oscillatory weight integral `∫_a^b exp(−σ² t²) cos(c t) dt` is
//!    enclosed by a degree-`K` Taylor expansion about the midpoint with a
//!    rigorous `K`-th-derivative remainder (the complex exponential is
//!    integrated exactly term by term).
//! 3. Writing `Ω = m ± r`, the panel contribution is
//!    `m · ∫w ± r · h · σ²`, because `|w| ≤ σ²`.
//!
//! The single panel adjacent to `0` uses the T79 point enclosure at its right
//! endpoint and the Lipschitz bound of T87 (`|Ω'| ≤ psiSeriesBound 1`), whose
//! elementary upper bound is [`crate::omega::psi_bound_one_upper`].
//!
//! ## The tail bound `|Ω(t)| ≤ 10 + 5t`
//!
//! For `z = 1/4 + it/2` the standard digamma series
//! `ψ(z) = −γ + Σ_{n≥0} (1/(n+1) − 1/(n+z))` gives
//! `|1/(n+1) − 1/(n+z)| = |z−1| / ((n+1)|n+z|)`
//! with `|z−1| ≤ 1 + t` and `|n+z| ≥ n + 1/4`, hence
//! `|ψ(z)| ≤ γ + (1+t) S` where
//! `S = Σ_{n≥0} 1/((n+1)(n+1/4)) = (4/3)(π/2 + 3 log 2) < 5`
//! (using `π < 3.2` and `log 2 < 0.7`).  With `γ < 1` and `log π < 2`,
//! `|Ω(t)| ≤ |ψ(z)| + log π < 6 + 5t + 2 = 8 + 5t < 10 + 5t`.
//!
//! Integrating this against the Gaussian gives
//! `∫_T^∞ σ² e^{−σ²t²}(10+5t) dt ≤ e^{−σ²T²}(5/T + 5/2)`, and the density
//! tail is twice that; at `T = 150` it is below `10⁻²³`.

use crate::interval::{Fv, Iv, PREC};
use rug::Float;
use crate::omega::{omega_panel_iv, psi_bound_one_upper};
use rug::Rational;

#[derive(Clone, Debug)]
pub struct DensityParams {
    pub sigma: Rational,
    pub t_start: Rational,
    pub t_max: Rational,
    pub h: Rational,
    pub n_shift: u32,
    pub taylor_order: u32,
}

#[derive(Clone, Debug)]
struct Cv {
    re: Fv,
    im: Fv,
}

impl Cv {
    fn zero() -> Self {
        Cv {
            re: Fv::from_i64(0),
            im: Fv::from_i64(0),
        }
    }

    fn one() -> Self {
        Cv {
            re: Fv::from_i64(1),
            im: Fv::from_i64(0),
        }
    }

    fn real(x: Fv) -> Self {
        Cv {
            re: x,
            im: Fv::from_i64(0),
        }
    }

    fn add(&self, o: &Cv) -> Cv {
        Cv {
            re: self.re.add(&o.re),
            im: self.im.add(&o.im),
        }
    }

    fn mul(&self, o: &Cv) -> Cv {
        Cv {
            re: self.re.mul(&o.re).sub(&self.im.mul(&o.im)),
            im: self.re.mul(&o.im).add(&self.im.mul(&o.re)),
        }
    }
}

fn poly_mul(a: &[Cv], b: &[Cv]) -> Vec<Cv> {
    let mut out = vec![Cv::zero(); a.len() + b.len() - 1];
    for (i, ai) in a.iter().enumerate() {
        for (j, bj) in b.iter().enumerate() {
            out[i + j] = out[i + j].add(&ai.mul(bj));
        }
    }
    out
}

fn poly_derivative(a: &[Cv]) -> Vec<Cv> {
    if a.len() <= 1 {
        return vec![Cv::zero()];
    }
    let mut out = Vec::with_capacity(a.len() - 1);
    for k in 1..a.len() {
        out.push(Cv::real(Fv::from_i64(k as i64)).mul(&a[k]));
    }
    out
}

fn poly_eval(a: &[Cv], z: &Fv) -> Cv {
    let mut acc = Cv::zero();
    for coeff in a.iter().rev() {
        acc = acc.mul(&Cv::real(z.clone())).add(coeff);
    }
    acc
}

fn factorial(n: u32) -> i64 {
    (1..=n).product::<u32>() as i64
}

/// Enclosure of `I_c = ∫_a^b exp(−σ² t²) cos(c t) dt` on a panel `a ≤ b`,
/// `0 < a`.
pub fn weight_integral(c: &Rational, a: &Rational, b: &Rational, sigma: &Rational, order: u32) -> Fv {
    let m = Rational::from(a + b) / 2;
    let r = Rational::from(b - a) / 2;
    let s2 = Rational::from(sigma * sigma);

    let a_coef = Fv::point(&Rational::from(-&s2));
    let s2m = Rational::from(&s2 * &m);
    let b_re = Fv::point(&(Rational::from(-2) * &s2m));
    let b_im = Fv::point(c);
    let mm = Rational::from(&m * &m);
    let c_re = Fv::point(&Rational::from(-Rational::from(&s2 * &mm)));
    let c_im = Fv::point(&Rational::from(c * &m));

    // e^C
    let e_re = c_re.exp();
    let e_c = Cv {
        re: e_re.mul(&c_im.cos()),
        im: e_re.mul(&c_im.sin()),
    };

    // B + 2 A z as a degree-one polynomial.
    let linear = vec![
        Cv {
            re: b_re,
            im: b_im,
        },
        Cv {
            re: a_coef.mul(&Fv::from_i64(2)),
            im: Fv::from_i64(0),
        },
    ];

    // P_k with g^{(k)}(z) = P_k(z) g(z).
    let mut poly = vec![Cv::one()];
    let mut main = Cv::zero();
    let r_fv = Fv::point(&r);
    let mut rpow = r_fv.clone();

    for k in 0..order {
        if k % 2 == 0 {
            let fact = Fv::from_i64(factorial(k + 1));
            let coeff = poly[0]
                .mul(&e_c)
                .mul(&Cv::real(rpow.clone()));
            let coeff = coeff.mul(&Cv::real(Fv::from_i64(1).div(&fact)));
            main = main.add(&coeff.mul(&Cv::real(Fv::from_i64(2))));
        }
        rpow = rpow.mul(&r_fv);
        let deriv = poly_derivative(&poly);
        poly = poly_mul(&poly, &linear);
        // add derivative, padding lengths
        if deriv.len() > poly.len() {
            poly.resize(deriv.len(), Cv::zero());
        }
        for (i, d) in deriv.iter().enumerate() {
            poly[i] = poly[i].add(d);
        }
    }

    // K-th derivative remainder.
    let z_iv = Fv::new(r_fv.lo.clone(), r_fv.hi.clone()).neg();
    let z_iv = Fv::new(z_iv.lo, r_fv.hi.clone());
    let p_at = poly_eval(&poly, &z_iv);
    let bound = p_at.re.max_abs() + p_at.im.max_abs();
    let bound_fv = Fv::new(bound.clone(), bound);
    let rp = r_fv.pow_nat(order + 1);
    let fact = Fv::from_i64(factorial(order + 1));
    let rem = bound_fv
        .mul(&Fv::from_i64(2))
        .mul(&rp)
        .div(&fact);
    let pad = Fv::new(rem.hi.clone(), rem.hi.clone());

    let lower = Fv::new(main.re.lo.clone(), main.re.lo.clone()).sub(&pad);
    let upper = Fv::new(main.re.hi.clone(), main.re.hi.clone()).add(&pad);
    Fv::new(lower.lo, upper.hi)
}

/// Weight interval `σ² exp(−σ² t²) cos(c t)` over a `t` interval.
fn weight_interval(c: &Rational, t: &Fv, sigma: &Rational) -> Fv {
    let s2 = Fv::point(&Rational::from(sigma * sigma));
    let t2 = t.pow_nat(2);
    let gauss = s2.mul(&t2).neg().exp();
    let cos_arg = Fv::point(c).mul(t);
    s2.mul(&gauss).mul(&cos_arg.cos())
}

/// All four (or any list of) density enclosures, sharing the `Ω` work.
pub fn densities_iv(cs: &[Rational], p: &DensityParams) -> Vec<Iv> {
    let two = Fv::from_i64(2);
    let s2 = Fv::point(&Rational::from(&p.sigma * &p.sigma));
    let mut totals: Vec<Fv> = vec![Fv::from_i64(0); cs.len()];

    // Panel adjacent to the origin.
    let t0 = &p.t_start;
    let om0 = omega_panel_iv(&Fv::point(t0), p.n_shift);
    let lip = Fv::point(&psi_bound_one_upper());
    let delta = Fv::point(t0).mul(&lip);
    let omega_lo = Fv::new(om0.lo.clone(), om0.lo.clone()).sub(&delta);
    let omega_hi = Fv::new(om0.hi.clone(), om0.hi.clone()).add(&delta);
    let omega_first = Fv::new(omega_lo.lo, omega_hi.hi);
    let t_first = Fv::new(
        Fv::from_i64(0).lo,
        Fv::point(t0).hi,
    );
    for (k, c) in cs.iter().enumerate() {
        let w = weight_interval(c, &t_first, &p.sigma);
        let panel = w.mul(&omega_first).mul(&Fv::point(t0));
        totals[k] = totals[k].add(&panel.mul(&two));
    }

    // Regular panels.
    let mut a = t0.clone();
    let mut panels: u64 = 0;
    while a < p.t_max {
        let mut b = Rational::from(&a + &p.h);
        if b > p.t_max {
            b = p.t_max.clone();
        }
        let t_iv = Fv::new(Fv::point(&a).lo, Fv::point(&b).hi);
        let om = omega_panel_iv(&t_iv, p.n_shift);
        let m_om = om.midpoint();
        let r_om = Fv::new(om.radius(), om.radius());
        let h = Rational::from(&b - &a);
        let err = r_om
            .mul(&Fv::point(&h))
            .mul(&s2);
        let err_sym = Fv::new(
            Float::with_val(PREC, -&err.hi),
            err.hi.clone(),
        );
        for (k, c) in cs.iter().enumerate() {
            let ic = weight_integral(c, &a, &b, &p.sigma, p.taylor_order);
            let panel = s2.mul(&ic).mul(&m_om);
            let panel = panel.add(&err_sym);
            totals[k] = totals[k].add(&panel.mul(&two));
        }
        panels += 1;
        a = b;
    }

    // Gaussian tail, |Ω(t)| ≤ 10 + 5t for t ≥ 0.
    let tmax = Fv::point(&p.t_max);
    let expo = s2.mul(&tmax.pow_nat(2)).neg().exp();
    let factor = Fv::point(&(
        Rational::from(5) / &p.t_max + Rational::from(5) / Rational::from(2)
    ));
    let tail = expo.mul(&factor).mul(&two);
    let tail_sym = Fv::new(
        Float::with_val(PREC, -&tail.hi),
        tail.hi.clone(),
    );
    for total in totals.iter_mut() {
        *total = total.add(&tail_sym);
    }

    let _ = panels;
    totals.iter().map(|t| t.to_iv()).collect()
}

/// Single density enclosure.
pub fn density_iv(c: &Rational, p: &DensityParams) -> Iv {
    densities_iv(std::slice::from_ref(c), p).remove(0)
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::rational::parse_rational;

    fn params() -> DensityParams {
        DensityParams {
            sigma: parse_rational("1/20").unwrap(),
            t_start: parse_rational("1/100000").unwrap(),
            t_max: parse_rational("60").unwrap(),
            h: parse_rational("1/100").unwrap(),
            n_shift: 20,
            taylor_order: 8,
        }
    }

    #[test]
    fn weight_integral_is_small_and_consistent() {
        let sigma = parse_rational("1/20").unwrap();
        let a = parse_rational("1").unwrap();
        let b = parse_rational("1.001").unwrap();
        let c = parse_rational("1/5").unwrap();
        let iv = weight_integral(&c, &a, &b, &sigma, 8);
        assert!(iv.lo > 0);
        assert!(iv.width().abs() < rug::Float::with_val(80, 1e-20));
    }

    #[test]
    fn density_at_zero_is_positive() {
        let p = params();
        let d = density_iv(&parse_rational("0").unwrap(), &p);
        assert!(d.lo > 0);
        assert!(d.width().abs() < rug::Float::with_val(80, 1e-2));
        let true_value = parse_rational("0.0117003907676535193623574").unwrap();
        assert!(d.contains(&true_value));
    }
}
