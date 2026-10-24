//! Truncated power series over intervals, and **Φ's Taylor coefficients**.
//!
//! [`crate::jet`] carries two derivatives because that is all the quadrature
//! bound needs. **TODO G3** needs the whole germ: CONTINUATION (22) claims
//! Γ_Φ is meromorphic with simple poles at w = −1, −3, −5, … and residue
//! 4c_{2k} at w = −(2k+1), where Φ(u) = Σ_k c_{2k}u^{2k}, and nothing has ever
//! computed a c_{2k}.
//!
//! Nothing here is a quadrature. Every coefficient comes out of two exact
//! recurrences applied to the shell series:
//!
//! ```text
//! e^{αu}          → α^m/m!
//! F = e^G         → f₀ = e^{g₀},   m·f_m = Σ_{i=1}^{m} i·g_i·f_{m−i}
//! (FG)_m          = Σ_i f_i g_{m−i}
//! ```
//!
//! so φ_k = (2π²k⁴e^{9u/2} − 3πk²e^{5u/2})·exp(−πk²·e^{2u}) is assembled from
//! series that are right to the last bit, and the only approximation is the
//! truncation over **k**, which is bounded below.
//!
//! # The shell tail, for coefficients
//!
//! (G1a) bounds Φ and two derivatives on the real axis; a Taylor coefficient
//! needs a bound on a circle. For |u| = r < π/4, writing t = e^{2u}:
//! Re t = e^{2Re u}cos(2 Im u) ≥ e^{−2r}cos(2r) =: ρ(r) > 0, so
//!
//! ```text
//! |φ_k(u)|  ≤  (2π²k⁴e^{9r/2} + 3πk²e^{5r/2})·e^{−πk²ρ(r)}
//! ```
//!
//! and Cauchy's estimate divides by r^m. Consecutive bounds fall by
//! ((k+1)/k)⁴e^{−π(2k+1)ρ} ≤ 16e^{−3πρ}, which at **r = 3/10** is 0.224 ≤ ½,
//! so the geometric sum is under 2 and
//!
//! ```text
//! Σ_{k>N} |c_m(φ_k)|  ≤  2·(2π²(N+1)⁴e^{9r/2} + 3π(N+1)²e^{5r/2})
//!                          · e^{−π(N+1)²ρ(r)} / r^m                    (G3a)
//! ```
//!
//! # The radius, which decides whether (22) is a formula or a mistake
//!
//! Each φ_k is entire, but the sum converges only where Re e^{2u} > 0, i.e.
//! |Im u| < π/4. At u = iπ/4 exactly, e^{2u} = i and e^{−πk²i} = (−1)^k, so
//! the terms grow like 2π²k⁴ and the series diverges. That is not a defect of
//! the representation: Φ(u) = 2e^{u/2}ω(e^{2u}) with ω built from θ, and θ has
//! Re t = 0 as a **natural boundary**, so Φ does not continue past it at all.
//!
//! **The radius of convergence of Σ c_m u^m is therefore exactly π/4 =
//! 0.7854 — less than 1.** `bin/g3_poles` measures it. See TODO **E14**.

use crate::interval::Iv;
use crate::real::R;

/// A power series truncated at degree `n`, coefficients low-to-high, each an
/// outward-rounded interval.
#[derive(Clone, Debug)]
pub struct Series(pub Vec<Iv>);

impl Series {
    /// The zero series of the given length (degree `n` = len − 1).
    pub fn zero(len: usize) -> Series {
        Series(vec![Iv::zero(); len])
    }
    /// A constant.
    pub fn cst(c: &Iv, len: usize) -> Series {
        let mut v = vec![Iv::zero(); len];
        v[0] = c.clone();
        Series(v)
    }
    /// α·u — the argument of every exponential in the shell series.
    pub fn linear(alpha: &Iv, len: usize) -> Series {
        let mut v = vec![Iv::zero(); len];
        if len > 1 {
            v[1] = alpha.clone();
        }
        Series(v)
    }
    pub fn len(&self) -> usize {
        self.0.len()
    }
    pub fn is_empty(&self) -> bool {
        self.0.is_empty()
    }

    pub fn add(&self, o: &Series) -> Series {
        Series(self.0.iter().zip(&o.0).map(|(a, b)| a + b).collect())
    }
    pub fn sub(&self, o: &Series) -> Series {
        Series(self.0.iter().zip(&o.0).map(|(a, b)| a - b).collect())
    }
    pub fn scale(&self, c: &Iv) -> Series {
        Series(self.0.iter().map(|a| a * c).collect())
    }
    /// Cauchy product, truncated to the shorter length.
    pub fn mul(&self, o: &Series) -> Series {
        let n = self.len().min(o.len());
        let mut out = vec![Iv::zero(); n];
        for (i, a) in self.0.iter().take(n).enumerate() {
            for (j, b) in o.0.iter().take(n - i).enumerate() {
                out[i + j] = &out[i + j] + &(a * b);
            }
        }
        Series(out)
    }

    /// e^G, by F′ = G′F: f₀ = e^{g₀} and m·f_m = Σ_{i=1}^{m} i·g_i·f_{m−i}.
    ///
    /// Exact as a recurrence — no series inversion, no factorials formed.
    pub fn exp(&self) -> Series {
        let n = self.len();
        let mut f = vec![Iv::zero(); n];
        f[0] = self.0[0].exp();
        for m in 1..n {
            let mut s = Iv::zero();
            for i in 1..=m {
                s = &s + &(&(&Iv::from_i64(i as i64) * &self.0[i]) * &f[m - i]);
            }
            f[m] = &s / &Iv::from_i64(m as i64);
        }
        Series(f)
    }

    /// Σ a_m u^m, by Horner.
    pub fn eval(&self, u: &Iv) -> Iv {
        let mut acc = Iv::zero();
        for a in self.0.iter().rev() {
            acc = &(&acc * u) + a;
        }
        acc
    }
}

/// The circle (G3a) is stated on. Any r < π/4 works; 3/10 is the one at which
/// the ratio test gives a clean ½.
pub fn cauchy_radius() -> Iv {
    &Iv::from_i64(3) / &Iv::from_i64(10)
}

/// A hard ceiling on the shell count. The loop stops on (G3a), not on this.
pub const MAX_SHELLS: usize = 96;

/// M(r) — an upper bound on |Φ| over the whole circle |u| = r, from (G3a) at
/// N = 0. The constant every Cauchy estimate here divides by r^m.
pub fn phi_circle_bound() -> Iv {
    let pi = Iv::pi();
    let r = cauchy_radius();
    let two_r = &Iv::from_i64(2) * &r;
    let cos2r = Iv::new(
        crate::real::pred(&two_r.hi.cos()),
        crate::real::succ(&two_r.lo.cos()),
    );
    let rho = &(-&two_r).exp() * &cos2r;
    let e9r = (&r * &(&Iv::from_i64(9) / &Iv::from_i64(2))).exp();
    let e5r = (&r * &(&Iv::from_i64(5) / &Iv::from_i64(2))).exp();
    let head = &(&(&Iv::from_i64(2) * &(&pi * &pi)) * &e9r) + &(&(&Iv::from_i64(3) * &pi) * &e5r);
    &(&Iv::from_i64(2) * &head) * &(&(-&pi) * &rho).exp()
}

/// Φ(u) from its Taylor series, with **both** truncations bounded: the shell
/// tail is already inside the coefficients (G3a), and the degree tail is
/// Cauchy again —
///
/// ```text
/// |Σ_{m≥M} c_m u^m|  ≤  M(r)·(|u|/r)^M / (1 − |u|/r),      |u| < r      (G3b)
/// ```
///
/// so this is an enclosure of Φ and not of a polynomial. Requires |u| < r.
pub fn phi_from_series(c: &Series, u: &Iv) -> Iv {
    let r = cauchy_radius();
    let q = &Iv::new(u.sup_abs(), u.sup_abs()) / &r;
    assert!(q.hi < R::one(), "phi_from_series needs |u| < r = 0.3");
    let m = c.len();
    let tail = &(&phi_circle_bound() * &q.powu(m)) / &(&Iv::one() - &q);
    &c.eval(u) + &Iv::pm(&tail.sup_abs())
}

/// The Taylor coefficients of Φ at u = 0, to degree `len − 1`, enclosed.
///
/// Truncation over k is bounded by (G3a), so the result is an enclosure and
/// not an estimate. The odd coefficients come out containing zero, which is
/// the evenness of Φ — the theta functional equation — arriving through
/// arithmetic rather than being imposed.
pub fn phi_taylor(len: usize) -> Series {
    let pi = Iv::pi();
    let two_pi2 = &(&Iv::from_i64(2) * &pi) * &pi;
    let three_pi = &Iv::from_i64(3) * &pi;

    let e9 = Series::linear(&(&Iv::from_i64(9) / &Iv::from_i64(2)), len).exp();
    let e5 = Series::linear(&(&Iv::from_i64(5) / &Iv::from_i64(2)), len).exp();
    let e2 = Series::linear(&Iv::from_i64(2), len).exp();

    // the circle constants of (G3a). Every one of them is formed outward, and
    // every outward direction is the conservative one here: the bound holds
    // for each fixed r in (0, π/4), so an enclosure that dominates the value
    // at every r in a thin interval dominates it at one of them.
    let r = cauchy_radius();
    let two_r = &Iv::from_i64(2) * &r;
    // cos is decreasing on [0, π/2] and 2r ≈ 0.6 sits well inside it, so the
    // endpoints map to the endpoints, reversed
    assert!(two_r.hi < R::pi() / R::from_i64(2) && two_r.lo.is_positive());
    let cos2r = Iv::new(
        crate::real::pred(&two_r.hi.cos()),
        crate::real::succ(&two_r.lo.cos()),
    );
    let rho = &(-&two_r).exp() * &cos2r;
    let e9r = (&r * &(&Iv::from_i64(9) / &Iv::from_i64(2))).exp();
    let e5r = (&r * &(&Iv::from_i64(5) / &Iv::from_i64(2))).exp();

    let eps = R::from_i64(2).powi(-(crate::real::prec() as i64) - 8);
    let mut acc = Series::zero(len);
    for k in 1..=MAX_SHELLS {
        let k2 = Iv::from_i64((k * k) as i64);
        let k4 = &k2 * &k2;
        let gauss = e2.scale(&(-&(&pi * &k2))).exp(); // exp(−πk²e^{2u})
        let head = e9.scale(&(&two_pi2 * &k4)).sub(&e5.scale(&(&three_pi * &k2)));
        acc = acc.add(&head.mul(&gauss));

        // (G3a) at N = k, per coefficient index m
        let n1 = Iv::from_i64((k + 1) as i64);
        let n1sq = &n1 * &n1;
        let head_bound = &(&(&two_pi2 * &n1sq.powu(2)) * &e9r)
            + &(&(&three_pi * &n1sq) * &e5r);
        let amp = &(&Iv::from_i64(2) * &head_bound)
            * &(&(-&(&pi * &n1sq)) * &rho).exp();
        // |c_m| tail = amp / r^m — largest at the top degree
        let top = &amp / &r.powu(len - 1);
        let smallest = acc
            .0
            .iter()
            .map(|a| a.sup_abs())
            .fold(R::zero(), |a, b| if a > b { a } else { b });
        if k >= 3 && top.sup_abs() <= &smallest * &eps {
            let mut rpow = Iv::one();
            let widened: Vec<Iv> = acc
                .0
                .iter()
                .map(|a| {
                    let t = (&amp / &rpow).sup_abs();
                    rpow = &rpow * &r;
                    a + &Iv::pm(&t)
                })
                .collect();
            return Series(widened);
        }
    }
    panic!("the coefficient tail (G3a) never fell in {MAX_SHELLS} shells");
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::phi::phi;
    use crate::real::set_prec_digits;

    /// The two recurrences, on series whose answers are known in closed form.
    #[test]
    fn the_recurrences_are_exact() {
        set_prec_digits(50);
        // e^{2u}: coefficients 2^m/m!
        let e2 = Series::linear(&Iv::from_i64(2), 12).exp();
        let mut want = R::one();
        for m in 0..12 {
            assert!(e2.0[m].contains(&want), "e^{{2u}} coefficient {m} wrong");
            want = want * R::from_i64(2) / R::from_usize(m + 1);
        }
        // (1+u)² by convolution
        let mut a = Series::zero(6);
        a.0[0] = Iv::one();
        a.0[1] = Iv::one();
        let sq = a.mul(&a);
        for (m, w) in [1i64, 2, 1, 0, 0, 0].iter().enumerate() {
            assert!(sq.0[m].contains(&R::from_i64(*w)));
        }
        // exp of a series with a non-zero constant term
        let g = Series::cst(&Iv::from_i64(3), 8).add(&Series::linear(&Iv::one(), 8));
        let f = g.exp(); // e^{3+u} = e³·e^u
        let e3 = R::from_i64(3).exp();
        assert!(f.0[0].contains(&e3));
        assert!(f.0[1].contains(&e3));
        assert!(f.0[2].contains(&(&e3 / R::from_i64(2))));
    }

    /// **G3.** The series must reproduce Φ itself — checked against the shell
    /// sum `phi.rs` validates against the published table.
    ///
    /// Through [`phi_from_series`], which adds (G3b): a truncated series is
    /// not Φ, and at u = 0.25 with 40 terms the degree tail alone is 1e−16.
    #[test]
    fn the_taylor_series_reproduces_phi() {
        set_prec_digits(50);
        let c = phi_taylor(120);
        for s in ["0", "0.1", "0.2", "0.25", "0.29"] {
            let u = R::parse(s);
            let got = phi_from_series(&c, &Iv::point(&u));
            let want = phi(&u);
            assert!(got.contains(&want), "series ≠ Φ({s}): {} escapes", want.sci(14));
        }
        // (G3b) degrades as |u| climbs toward r, because it is (|u|/r)^M — at
        // 0.1 that is 1e−57 and at 0.29 it is 0.017, so the enclosure is tight
        // well inside the circle and worthless at its edge. Both, asserted.
        let tight = phi_from_series(&c, &Iv::point(&R::parse("0.1")));
        let edge = phi_from_series(&c, &Iv::point(&R::parse("0.29")));
        assert!(tight.rel_width() < R::from_f64(1e-40), "tight: {}", tight.rel_width().sci(4));
        assert!(edge.rel_width() > R::from_f64(1.0), "the edge case is not loose after all");
        // and the bound is not vacuous: the circle is inside the unit disc
        assert!(cauchy_radius().hi < R::from_f64(0.31));
    }

    /// Φ is even, so every odd coefficient is zero — and the arithmetic must
    /// find that rather than have it imposed.
    #[test]
    fn the_odd_coefficients_vanish() {
        set_prec_digits(50);
        let c = phi_taylor(24);
        for m in (1..24).step_by(2) {
            assert!(c.0[m].contains_zero(), "c_{m} = {} does not contain 0", c.0[m].mid().sci(6));
        }
        // and the even ones do not
        for m in (0..12).step_by(2) {
            assert!(!c.0[m].contains_zero(), "c_{m} straddles zero");
        }
    }

    /// **E14.** The radius of convergence is **below 1**, so CONTINUATION
    /// (22)'s split at u = 1 is outside it and the series it integrates there
    /// diverges. Measured by the root test, which settles toward 4/π from
    /// above.
    #[test]
    fn the_radius_of_convergence_is_below_one() {
        set_prec_digits(60);
        let c = phi_taylor(160);
        let root = |m: usize| c.0[m].mid().abs().to_f64().powf(1.0 / m as f64);
        // nowhere near 1 anywhere in the range — R ≥ 1 would force
        // |c_m|^{1/m} → ≤ 1
        for m in (30..158).step_by(2) {
            assert!(root(m) > 1.2, "|c_{m}|^(1/{m}) = {} — too small for R < 1", root(m));
        }
        let target = (R::from_i64(4) / R::pi()).to_f64();
        assert!(target > 1.0, "4/π ≤ 1 would make the split at u = 1 legal");
        // and it is settling toward 4/π from above, not diverging
        assert!(root(158) < root(60) && root(158) > target);
        assert!((root(158) / target - 1.0).abs() < 0.05, "root test at m=158: {}", root(158));
    }
}
