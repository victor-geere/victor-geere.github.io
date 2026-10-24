//! Jets over intervals, and Φ(e^v) with its shell truncation **bounded**.
//!
//! This is the first half of **TODO G1**: everywhere else in the crate Φ is
//! *computed* — summed until the terms stop moving the answer — and the
//! residue is argued from how fast they fell. Here the residue is majorised in
//! closed form, so what comes out is an enclosure and not an estimate.
//!
//! # G1(a) — the shell tail
//!
//! Write X = e^{2u} and, for u ≥ 0 and k ≥ 1,
//!
//! ```text
//! φ_k(u) = (2π²k⁴e^{9u/2} − 3πk²e^{5u/2})·e^{−πk²X}
//! ```
//!
//! **(i) The head is between 0 and 2π²k⁴e^{9u/2}.** It is non-negative because
//! 2π²k⁴e^{9u/2} ≥ 3πk²e^{5u/2} ⟺ 2πk²e^{2u} ≥ 3, and 2π > 3 already at
//! k = 1, u = 0. So |φ_k(u)| ≤ 2π²k⁴e^{9u/2}e^{−πk²X}, and Φ > 0 on u ≥ 0.
//!
//! **(ii) Each derivative costs a factor 5πk²X.** With ψ = −πk²X we have
//! ψ′ = 2ψ, ψ″ = 4ψ, and the head's derivatives are bounded by (9/2) and
//! (81/4) times the head. Expanding φ = h·e^ψ,
//!
//! ```text
//! |φ′|  ≤ H·(9/2 + 2πk²X)e^ψ                    ≤ H·(5πk²X)·e^ψ
//! |φ″|  ≤ H·(81/4 + 22πk²X + 4π²k⁴X²)e^ψ        ≤ H·(5πk²X)²·e^ψ
//! ```
//!
//! with H = 2π²k⁴e^{9u/2}, both valid for k ≥ 1 and X ≥ 1 (at the corner
//! k = X = 1 the bracket is 128.8 against (5π)² = 246.7).
//!
//! **(iii) The majorants halve.** The ratio of consecutive terms of
//! (5πk²X)^j·k⁴·e^{−πk²X} is ((k+1)/k)^{2j+4}·e^{−π(2k+1)X} ≤ 2⁸e^{−3π} =
//! 0.0207 for j ≤ 2, so the geometric sum is under 2. Hence, for every u ≥ 0
//! and every N ≥ 0,
//!
//! ```text
//! Σ_{k>N} |φ_k^{(j)}(u)|  ≤  (5π(N+1)²e^{2u})^j · T_N(u),
//! T_N(u) := 4π²·e^{9u/2}·(N+1)⁴·e^{−π(N+1)²e^{2u}}                    (G1a)
//! ```
//!
//! T_N is the quantity [`phi_at_exp_jet`] adds to the enclosure after N
//! shells, and the loop stops on it rather than on the terms. At N = 10 and
//! the worst argument u = 0 it is 5.8e5·e^{−380} ≈ 10^{−160}. Taking N = 0
//! gives a bound on Φ itself, which is what the upper tail of the quadrature
//! needs — see [`crate::bounds`].
//!
//! # The jet
//!
//! The quadrature's error bound needs the *second* derivative of the whole
//! integrand, so Φ(e^v) is evaluated as a triple (value, d/dv, d²/dv²) rather
//! than a number, with every component an outward-rounded interval and the
//! argument itself an interval — so one evaluation bounds the function and its
//! two derivatives over a whole subinterval at once.
//!
//! The same code serves both jobs. [`Jet`] is implemented for `Iv` (order 0 —
//! the node amplitudes, where derivatives would be wasted) and for [`Jet2`]
//! (order 2 — the error bound), so the shell sum is written once.

use crate::interval::Iv;
use crate::real::R;

/// A truncated Taylor triple: the value and the first two derivatives of a
/// function of one real variable, each enclosed.
#[derive(Clone, Debug)]
pub struct Jet2 {
    pub f: Iv,
    pub d1: Iv,
    pub d2: Iv,
}

/// What the shell sum needs of its arithmetic. Implemented at order 0 by `Iv`
/// itself and at order 2 by [`Jet2`], so [`phi_at_exp_jet`] is written once.
pub trait Jet: Clone {
    /// A constant — derivatives zero.
    fn cst(c: &Iv) -> Self;
    /// The variable itself — first derivative one.
    fn var(x: &Iv) -> Self;
    fn add(&self, o: &Self) -> Self;
    fn sub(&self, o: &Self) -> Self;
    fn mul(&self, o: &Self) -> Self;
    /// Multiply by a constant.
    fn scale(&self, c: &Iv) -> Self;
    fn exp(&self) -> Self;
    /// The value component.
    fn value(&self) -> &Iv;
    /// Widen component *j* by ±`tail[j]`, for whatever orders this jet carries.
    fn widen(&self, tail: &[R]) -> Self;

    /// x^k, by binary powering.
    fn powu(&self, k: usize) -> Self
    where
        Self: Sized,
    {
        let mut acc: Option<Self> = None;
        let mut b = self.clone();
        let mut e = k;
        while e > 0 {
            if e & 1 == 1 {
                acc = Some(match acc {
                    None => b.clone(),
                    Some(a) => a.mul(&b),
                });
            }
            e >>= 1;
            if e > 0 {
                b = b.mul(&b);
            }
        }
        acc.unwrap_or_else(|| Self::cst(&Iv::one()))
    }
}

impl Jet for Iv {
    fn cst(c: &Iv) -> Iv {
        c.clone()
    }
    fn var(x: &Iv) -> Iv {
        x.clone()
    }
    fn add(&self, o: &Iv) -> Iv {
        self + o
    }
    fn sub(&self, o: &Iv) -> Iv {
        self - o
    }
    fn mul(&self, o: &Iv) -> Iv {
        self * o
    }
    fn scale(&self, c: &Iv) -> Iv {
        self * c
    }
    fn exp(&self) -> Iv {
        Iv::exp(self)
    }
    fn value(&self) -> &Iv {
        self
    }
    fn widen(&self, tail: &[R]) -> Iv {
        self + &Iv::pm(&tail[0])
    }
}

impl Jet for Jet2 {
    fn cst(c: &Iv) -> Jet2 {
        Jet2 {
            f: c.clone(),
            d1: Iv::zero(),
            d2: Iv::zero(),
        }
    }
    fn var(x: &Iv) -> Jet2 {
        Jet2 {
            f: x.clone(),
            d1: Iv::one(),
            d2: Iv::zero(),
        }
    }
    fn add(&self, o: &Jet2) -> Jet2 {
        Jet2 {
            f: &self.f + &o.f,
            d1: &self.d1 + &o.d1,
            d2: &self.d2 + &o.d2,
        }
    }
    fn sub(&self, o: &Jet2) -> Jet2 {
        Jet2 {
            f: &self.f - &o.f,
            d1: &self.d1 - &o.d1,
            d2: &self.d2 - &o.d2,
        }
    }
    /// (fg)′ = f′g + fg′, (fg)″ = f″g + 2f′g′ + fg″.
    fn mul(&self, o: &Jet2) -> Jet2 {
        let cross = &(&self.d1 * &o.d1) * &Iv::from_i64(2);
        Jet2 {
            f: &self.f * &o.f,
            d1: &(&self.d1 * &o.f) + &(&self.f * &o.d1),
            d2: &(&(&self.d2 * &o.f) + &cross) + &(&self.f * &o.d2),
        }
    }
    fn scale(&self, c: &Iv) -> Jet2 {
        Jet2 {
            f: &self.f * c,
            d1: &self.d1 * c,
            d2: &self.d2 * c,
        }
    }
    /// (e^f)′ = e^f·f′, (e^f)″ = e^f·(f″ + f′²).
    fn exp(&self) -> Jet2 {
        let e = self.f.exp();
        Jet2 {
            d1: &e * &self.d1,
            d2: &e * &(&self.d2 + &(&self.d1 * &self.d1)),
            f: e,
        }
    }
    fn value(&self) -> &Iv {
        &self.f
    }
    fn widen(&self, tail: &[R]) -> Jet2 {
        Jet2 {
            f: &self.f + &Iv::pm(&tail[0]),
            d1: &self.d1 + &Iv::pm(&tail[1]),
            d2: &self.d2 + &Iv::pm(&tail[2]),
        }
    }
}

/// A hard ceiling on the shell count. The loop stops on (G1a), not on this;
/// exceeding it is a bug and panics rather than returning a wrong enclosure.
pub const MAX_SHELLS: usize = 64;

/// Φ(e^v) over the interval `v`, as a jet, with the truncation bounded by
/// (G1a) rather than assumed negligible.
///
/// `v` may be a point (a node) or a whole subinterval (a block, for the
/// quadrature's error bound); in the second case the result encloses Φ(e^·)
/// and its two derivatives over the entire subinterval simultaneously.
///
/// **Only correct for u = e^v ≥ 0**, which is automatic, and the bound (G1a)
/// additionally wants e^{2u} ≥ 1, which is also automatic since u > 0.
pub fn phi_at_exp_jet<J: Jet>(v: &Iv) -> J {
    phi_of_u_jet(J::var(v).exp())
}

/// Φ over a range of u directly, with no v-substitution — the form the
/// quadrature's *lower* tail needs, where u runs over [0, e^{V₀}] and there is
/// no v small enough to reach it. Order 0 only in practice: as a jet this
/// differentiates with respect to u, not v.
pub fn phi_on_u(u: &Iv) -> Iv {
    phi_of_u_jet::<Iv>(u.clone())
}

/// The shell sum itself, given u as a jet.
pub fn phi_of_u_jet<J: Jet>(u: J) -> J {
    let two = Iv::from_i64(2);
    let half = &Iv::one() / &two;
    let pi = Iv::pi();

    let u_sup = u.value().sup_abs();
    let (u_lo, u_hi) = (u.value().lo.clone(), u.value().hi.clone());
    let eh = u.scale(&half).exp(); // e^{u/2}
    let e4 = eh.powu(4); // e^{2u}
    let e5 = eh.powu(5);
    let e9 = eh.powu(9);
    let g1 = e4.scale(&-&pi).exp(); // e^{−π e^{2u}}
    let g2 = g1.mul(&g1);

    let two_pi2 = &(&two * &pi) * &pi;
    let three_pi = &Iv::from_i64(3) * &pi;

    // sup e^{9u/2} and inf e^{2u}, for the tail majorant (G1a)
    let e9_sup = e9.value().hi.clone();
    let e4_iv = e4.value().clone();

    let eps = R::from_i64(2).powi(-(crate::real::prec() as i64) - 8);
    let mut acc: Option<J> = None;
    let mut gauss = g1.clone(); // e^{−πk²e^{2u}} at k = 1
    let mut bump = g2.mul(&g1); // ×e^{−π(2k+1)e^{2u}} at k = 1

    let four_pi2_e9 = &(&(&Iv::from_i64(4) * &(&pi * &pi))
        * &Iv::new(e9_sup.clone(), e9_sup.clone()))
        * &Iv::one();
    let five_pi_e4 = &(&(&Iv::from_i64(5) * &pi) * &e4_iv)
        * &Iv::new(u_sup.clone(), u_sup.clone());

    for k in 1..=MAX_SHELLS {
        let k2 = Iv::from_i64((k * k) as i64);
        let k4 = &k2 * &k2;
        let head = e9.scale(&(&two_pi2 * &k4)).sub(&e5.scale(&(&three_pi * &k2)));
        let term = head.mul(&gauss);
        acc = Some(match acc {
            None => term,
            Some(a) => a.add(&term),
        });

        // (G1a) at N = k. The exponential it needs, e^{−π(k+1)²e^{2u}}, is the
        // *next* shell's Gaussian factor — already on the way — so the bound
        // costs a few multiplications rather than the transcendental it looks
        // like it costs. That is the difference between a build in minutes and
        // one in hours, at a hundred thousand nodes.
        let next_gauss = gauss.mul(&bump);
        let n1sq = Iv::from_i64(((k + 1) * (k + 1)) as i64);
        let t0 = &(&four_pi2_e9 * &n1sq.powu(2)) * next_gauss.value();
        // each v-derivative costs one factor of u (chain rule) and one of
        // 5π(N+1)²e^{2u} (the u-derivative bound)
        let us = &five_pi_e4 * &n1sq;
        let t1 = &t0 * &us;
        let t2 = &t1 + &(&t0 * &(&us * &us));
        let tail = [t0.sup_abs(), t1.sup_abs(), t2.sup_abs()];

        let val = acc.as_ref().unwrap().value().sup_abs();
        if k >= 3 && tail[0] <= &val * &eps {
            return acc.unwrap().widen(&tail);
        }
        gauss = next_gauss;
        bump = bump.mul(&g2);
    }
    panic!(
        "the shell tail (G1a) never fell in {} shells at u ⊆ [{}, {}]",
        MAX_SHELLS,
        u_lo.sci(6),
        u_hi.sci(6)
    );
}

/// An upper bound on Φ(u) valid for **every** u ≥ `u_lo`, from (G1a) at N = 0:
/// Φ(u) ≤ 4π²e^{9u/2}e^{−πe^{2u}}. Used for the quadrature's upper tail, where
/// there is no grid and the whole half-line has to be majorised at once.
pub fn phi_majorant(u: &Iv) -> Iv {
    let pi = Iv::pi();
    let e9 = (u.scale(&(&Iv::from_i64(9) / &Iv::from_i64(2)))).exp();
    let e2 = (u.scale(&Iv::from_i64(2))).exp();
    &(&(&Iv::from_i64(4) * &(&pi * &pi)) * &e9) * &(&(-&pi) * &e2).exp()
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::phi::phi;
    use crate::real::{set_prec_digits, R};

    /// The order-0 instantiation must enclose the crate's own Φ — the one
    /// checked against the published table in `phi.rs`.
    #[test]
    fn the_enclosure_contains_the_computed_phi() {
        set_prec_digits(50);
        for s in ["-14", "-3", "-0.5", "0", "0.35", "0.8", "1.2"] {
            let v = R::parse(s);
            let got: Iv = phi_at_exp_jet(&Iv::point(&v));
            let want = phi(&v.exp());
            assert!(got.contains(&want), "Φ(e^{s}) = {} not in [{}, {}]", want.sci(12), got.lo.sci(12), got.hi.sci(12));
            assert!(got.rel_width() < R::from_f64(1e-40), "enclosure at {s} is loose: {}", got.rel_width().sci(4));
        }
    }

    /// The jet's derivatives must match finite differences of the value.
    #[test]
    fn the_derivatives_match_finite_differences() {
        set_prec_digits(60);
        let d = R::parse("1e-12");
        for s in ["-2", "-0.4", "0.3", "0.9"] {
            let v = R::parse(s);
            let j: Jet2 = phi_at_exp_jet(&Iv::point(&v));
            let f = |x: R| -> R { phi(&x.exp()) };
            let fp = (f(&v + &d) - f(&v - &d)) / (R::from_i64(2) * &d);
            let fpp = (f(&v + &d) - R::from_i64(2) * f(v.clone()) + f(&v - &d)) / (&d * &d);
            let e1 = ((&j.d1.mid() - &fp).abs() / fp.abs()).to_f64();
            let e2 = ((&j.d2.mid() - &fpp).abs() / fpp.abs()).to_f64();
            assert!(e1 < 1e-18, "d/dv at {s} off by {e1}");
            assert!(e2 < 1e-8, "d²/dv² at {s} off by {e2}"); // 24 digits lost to the stencil
        }
    }

    /// Evaluated over a fat interval, the jet must contain what it contains at
    /// every point inside it — the property the error bound relies on.
    #[test]
    fn a_fat_argument_encloses_every_point_inside_it() {
        set_prec_digits(50);
        let lo = R::parse("0.30");
        let hi = R::parse("0.31");
        let blk: Jet2 = phi_at_exp_jet(&Iv::new(lo.clone(), hi.clone()));
        for t in 0..=10 {
            let v = &lo + &(&(&hi - &lo) * &R::from_usize(t) / R::from_i64(10));
            let pt: Jet2 = phi_at_exp_jet(&Iv::point(&v));
            assert!(blk.f.lo <= pt.f.lo && pt.f.hi <= blk.f.hi, "value escapes the block at t = {t}");
            assert!(blk.d1.lo <= pt.d1.lo && pt.d1.hi <= blk.d1.hi, "d1 escapes the block at t = {t}");
            assert!(blk.d2.lo <= pt.d2.lo && pt.d2.hi <= blk.d2.hi, "d2 escapes the block at t = {t}");
        }
    }

    /// (G1a) at N = 0 must actually majorise Φ, at every argument.
    #[test]
    fn the_majorant_dominates_phi() {
        set_prec_digits(50);
        for s in ["0", "0.5", "1.0", "1.6", "2.5", "4.06"] {
            let u = R::parse(s);
            let m = phi_majorant(&Iv::point(&u));
            let p = phi(&u);
            assert!(m.hi > p, "majorant {} below Φ({s}) = {}", m.hi.sci(8), p.sci(8));
            // and not absurdly above it — within four decades on the range used
            if u <= R::from_f64(1.6) {
                assert!(m.hi < &p * &R::from_f64(1e4), "majorant at {s} is {} vs Φ = {}", m.hi.sci(6), p.sci(6));
            }
        }
    }

    /// The jet arithmetic itself, on a function whose derivatives are known.
    #[test]
    fn jet_arithmetic_differentiates_correctly() {
        set_prec_digits(50);
        // f(x) = e^{x²} at x = 0.7:  f′ = 2x·f,  f″ = (2 + 4x²)·f
        let x = R::parse("0.7");
        let v: Jet2 = Jet2::var(&Iv::point(&x));
        let f = v.mul(&v).exp();
        let val = (&x * &x).exp();
        assert!(f.f.contains(&val));
        assert!(f.d1.contains(&(R::from_i64(2) * &x * &val)));
        assert!(f.d2.contains(&((R::from_i64(2) + R::from_i64(4) * &x * &x) * &val)));
        // and powu agrees with repeated multiplication
        let p = v.powu(5);
        let mut q = v.clone();
        for _ in 0..4 {
            q = q.mul(&v);
        }
        assert!(p.f.contains(&q.f.mid()) && p.d2.contains(&q.d2.mid()));
    }
}
