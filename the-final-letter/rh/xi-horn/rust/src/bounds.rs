//! **TODO G1** — γ(n) *bounded*, not measured.
//!
//! [`crate::mellin`] computes Γ_Φ(w) by a trapezoid rule whose error is
//! established by step-halving: convincing, and not a proof. This module
//! replaces every estimate in that pipeline with an inequality, so what comes
//! out is an interval that provably contains Γ_Φ(w) — and therefore a Jensen
//! or Hermite–Jensen certificate that stands on its own rather than on
//! "the quadrature has converged".
//!
//! # The decomposition
//!
//! With f(v) = e^{(w+1)v}Φ(e^v), a := w + 1 > 0, U₁ := e^{V₁},
//!
//! ```text
//! Γ_Φ(w)/4  =  ∫_{−∞}^{V₀} f  +  ∫_{V₀}^{V₁} f  +  ∫_{V₁}^{∞} f
//!           =      T_lo       +        Q       +      T_hi
//! ```
//!
//! and the three pieces are the three error sources TODO G1 names — (c), (b)
//! and the reach of (a) respectively. Each is enclosed:
//!
//! **T_lo — G1(c), the neglected Taylor term.** TODO G1 proposes bounding
//! Φ(e^v) = Φ(0)(1 + O(e^{2v})) by sup|Φ′|. That needs a derivative bound;
//! interval arithmetic does not. Since e^{av} > 0 and Φ(e^v) ∈ Φ([0, e^{V₀}])
//! for every v ≤ V₀, one *interval* evaluation of Φ over the whole range gives
//!
//! ```text
//! T_lo  ∈  Φ([0, e^{V₀}]) · e^{aV₀}/a                                  (G1c)
//! ```
//!
//! exactly, with no Taylor expansion at all. At V₀ = −14 the enclosure of Φ is
//! relatively 10^{−5} wide and the tail is 3e−6 of Γ_Φ(0), so it costs 10^{−11}
//! relative — and less at every larger w, since the tail decays like e^{aV₀}.
//!
//! **T_hi — the upper tail.** (G1a) at N = 0 majorises Φ(u) ≤ 4π²e^{9u/2}e^{−πe^{2u}}
//! (see [`crate::jet`]), so with ρ(u) := w·log u + 9u/2 − πe^{2u},
//!
//! ```text
//! ρ′(u) = w/u + 9/2 − 2πe^{2u}  ≤  −κ,   κ := 2πe^{2U₁} − 9/2 − w/U₁
//! ```
//!
//! and ρ′ is decreasing on u ≥ U₁, so ρ(u) ≤ ρ(U₁) − κ(u − U₁) and
//!
//! ```text
//! 0  ≤  T_hi  ≤  4π²·e^{ρ(U₁)}/κ                                       (G1d)
//! ```
//!
//! At V₁ = 1.4 that is κ ≈ 2.09e4 and ρ(U₁) ≈ −10339 even at w = 72, so the
//! upper tail is e^{−10339} — the one term in the whole budget that is
//! negligible by an enormous margin rather than a comfortable one.
//!
//! **Q — G1(b), the trapezoid error.** TODO G1 calls this "the real work" and
//! proposes Poisson summation, Σ_{k≠0} F̂(2πk/h). **H2 removed the need.**
//! Certifying P^{d,n} instead of J^{d,n} needs a relative enclosure of 5.4e−6
//! rather than 3.6e−18, and *flat in n* — so the classical composite-trapezoid
//! remainder, which is nowhere near sharp enough for J, clears P with room:
//!
//! ```text
//! |Q − T_h|  ≤  (h²/12)·Σ_j h·max_{[v_j,v_{j+1}]}|f″|                  (G1b)
//! ```
//!
//! and f″ = e^{av}·(a²g + 2a·g′ + g″) with g(v) = Φ(e^v), whose three
//! components come from one interval jet evaluation per block
//! ([`crate::jet::phi_at_exp_jet`]). Nothing here is spectral and nothing here
//! needs the integrand's analyticity — which is exactly why it is provable in
//! an afternoon.
//!
//! Note what this costs: the *measured* rule converges spectrally (H1 — each
//! halving of h roughly triples the correct digits), and this bound sees only
//! h². The certified enclosure at h = 2^{−13} is 10^{−7} wide where the same
//! rule is in fact correct to far more. The gap between the two is the price
//! of a proof, and it is the honest reason G1 targets P.

use crate::interval::Iv;
use crate::jet::{phi_at_exp_jet, phi_on_u, Jet2};
use crate::real::R;

/// The three tails and the quadrature, kept separate so a driver can say which
/// of TODO G1's error sources actually binds.
#[derive(Debug, Clone)]
pub struct Parts {
    pub w: usize,
    /// h·Σ, the trapezoid sum itself (already ×4).
    pub quad: Iv,
    /// The (G1b) remainder (already ×4).
    pub e_quad: R,
    /// (G1c), the piece below V₀ (already ×4).
    pub t_lo: Iv,
    /// (G1d), the bound on the piece above V₁ (already ×4).
    pub t_hi: R,
    /// The three assembled: a certified enclosure of Γ_Φ(w).
    pub gamma: Iv,
}

impl Parts {
    /// Which source dominates the enclosure's width — the answer TODO G1 wants
    /// and could not have guessed.
    pub fn dominant(&self) -> &'static str {
        let q = self.quad.width();
        let l = self.t_lo.width();
        let mut best = ("rounding", q);
        if self.e_quad > best.1 {
            best = ("G1b quadrature", self.e_quad.clone());
        }
        if l > best.1 {
            best = ("G1c low tail", l);
        }
        if self.t_hi > best.1 {
            best = ("G1d high tail", self.t_hi.clone());
        }
        best.0
    }
}

/// A quadrature rule for Γ_Φ carrying everything (G1a)–(G1d) need.
///
/// The grid is dyadic on purpose: V₀ is an integer and h = 2^{−`h_exp`}, so
/// every node v_j = V₀ + jh is exactly representable and the enclosure of a
/// node carries no error beyond the one ulp [`Iv::point`] adds.
pub struct Certified {
    v0: R,
    v1: R,
    h: R,
    /// Subintervals. A multiple of `blk`.
    m: usize,
    /// Subintervals per jet block.
    blk: usize,
    /// Φ(e^{v_j}) enclosed, j = 0..=m.
    amp: Vec<Iv>,
    /// Per block: enclosures of g, g′, g″ over the block.
    ///
    /// Enclosures and not sups, deliberately. f″ = e^{av}(a²g + 2a·g′ + g″)
    /// and near the saddle those three very nearly cancel — that is precisely
    /// what "the integrand is flat at its peak" means, |f″| there being f/σ²
    /// with σ the Gaussian width, not a²f. Bounding the three terms separately
    /// throws the cancellation away and inflates (G1b) by a factor of ~40 at
    /// n = 36. Keeping them as intervals lets the cancellation happen inside
    /// the arithmetic, where it is still rigorous.
    gb: Vec<(Iv, Iv, Iv)>,
    /// Φ over u ∈ [0, e^{V₀}] — (G1c).
    phi_low: Iv,
}

impl Certified {
    /// `v0` an integer, step 2^{−`h_exp`}, upper limit the first grid point at
    /// or past `v1_target`, jets evaluated over blocks of `blk` subintervals.
    pub fn new(v0: i64, h_exp: u32, v1_target: f64, blk: usize) -> Certified {
        assert!(v0 < 0 && blk >= 1);
        let h = R::from_i64(2).powi(-(h_exp as i64));
        let raw = ((v1_target - v0 as f64) * (1u64 << h_exp) as f64).ceil() as usize;
        let m = raw.div_ceil(blk) * blk;
        let v0r = R::from_i64(v0);
        let v1 = &v0r + &(&R::from_usize(m) * &h);

        let node = |j: usize| -> R { &v0r + &(&R::from_usize(j) * &h) };

        let amp: Vec<Iv> = (0..=m)
            .map(|j| phi_at_exp_jet::<Iv>(&Iv::point(&node(j))))
            .collect();

        let gb: Vec<(Iv, Iv, Iv)> = (0..(m / blk))
            .map(|b| {
                let lo = node(b * blk);
                let hi = node((b + 1) * blk);
                let j: Jet2 = phi_at_exp_jet(&Iv::new(lo, hi));
                (j.f, j.d1, j.d2)
            })
            .collect();

        // Φ over u ∈ [0, e^{V₀}] — every v ≤ V₀ lands in here
        let u0 = v0r.exp();
        let phi_low = phi_on_u(&Iv::new(R::zero(), u0));

        Certified {
            v0: v0r,
            v1,
            h,
            m,
            blk,
            amp,
            gb,
            phi_low,
        }
    }

    /// The default this crate certifies with: V₀ = −14, h = 2^{−14}, V₁ ≈ 1.4,
    /// blocks of 4.
    ///
    /// The two parameters trade against each other and both were measured, not
    /// guessed: h sets (G1b) through h², and the *block width* blk·h sets how
    /// much of f″'s cancellation at the saddle survives interval evaluation.
    /// Holding blk·h ≈ 2.4e−4 and halving h is what buys the h²; widening the
    /// block to save jet evaluations costs more than it saves once blk·h
    /// passes about 10^{−3}.
    ///
    /// V₀ = −14 rather than [`crate::mellin::Mellin::standard`]'s −50 because
    /// (G1c) is exact: pushing V₀ down buys nothing once the tail is enclosed
    /// rather than dropped, and every node saved is a node not evaluated. V₁
    /// is where the majorant (G1d) has already reached e^{−10³⁴} at every w
    /// used here.
    pub fn standard() -> Certified {
        Certified::new(-14, 14, 1.4, 4)
    }

    pub fn nodes(&self) -> usize {
        self.m + 1
    }
    pub fn v0(&self) -> &R {
        &self.v0
    }
    pub fn v1(&self) -> &R {
        &self.v1
    }
    pub fn h(&self) -> &R {
        &self.h
    }
    /// The enclosure of Φ over [0, e^{V₀}] that (G1c) rests on.
    pub fn phi_low(&self) -> &Iv {
        &self.phi_low
    }

    /// A certified enclosure of Γ_Φ(w) for a non-negative integer w, with the
    /// pieces kept apart.
    pub fn gamma_parts(&self, w: usize) -> Parts {
        let a = R::from_usize(w + 1); // exact
        let aiv = Iv::exact(&a);
        let four = Iv::from_i64(4);

        // ---- the trapezoid sum, in interval arithmetic --------------------
        // e^{a·v_j} = e^{a·V₀}·q^j, and both exponents are exact products.
        let start = Iv::point(&(&a * &self.v0).exp());
        let q = Iv::point(&(&a * &self.h).exp());
        let half = &Iv::one() / &Iv::from_i64(2);
        let mut term = start.clone();
        let mut acc = Iv::zero();
        for (j, amp) in self.amp.iter().enumerate() {
            let wgt = if j == 0 || j == self.m {
                amp * &half
            } else {
                amp.clone()
            };
            acc = &acc + &(&term * &wgt);
            term = &term * &q;
        }
        let quad = &(&(&acc * &Iv::point(&self.h)) * &four);

        // ---- (G1b): (h²/12)·Σ_j h·max|f″| ---------------------------------
        // f″ = e^{av}(a²g + 2a·g′ + g″); over a block, e^{av} is largest at the
        // block's right end, and the three g-bounds are the block's own.
        let qb = Iv::point(&(&(&a * &self.h) * &R::from_usize(self.blk)).exp());
        let mut eterm = &start * &qb; // e^{a·(right end of block 0)}
        let mut esum = Iv::zero();
        let a2 = &aiv * &aiv;
        let two_a = &Iv::from_i64(2) * &aiv;
        for (g0, g1, g2) in &self.gb {
            let bracket = &(&(&a2 * g0) + &(&two_a * g1)) + g2;
            esum = &esum + &(&eterm * &bracket.abs());
            eterm = &eterm * &qb;
        }
        let hh = Iv::point(&self.h);
        let e_quad = &(&(&(&(&hh * &hh) * &hh) / &Iv::from_i64(12))
            * &(&esum * &Iv::from_i64(self.blk as i64)))
            * &four;
        let e_quad = e_quad.sup_abs();

        // ---- (G1c): the piece below V₀ ------------------------------------
        let t_lo = &(&(&self.phi_low * &start) / &aiv) * &four;

        // ---- (G1d): the piece above V₁ ------------------------------------
        let t_hi = self.upper_tail(w);

        let gamma = &(&(quad + &t_lo) + &Iv::new(R::zero(), t_hi.clone()))
            + &Iv::pm(&e_quad);
        Parts {
            w,
            quad: quad.clone(),
            e_quad,
            t_lo,
            t_hi,
            gamma,
        }
    }

    /// (G1d), already multiplied by the 4 of (25).
    fn upper_tail(&self, w: usize) -> R {
        let pi = Iv::pi();
        let u1 = Iv::point(&self.v1.exp()); // U₁ = e^{V₁}
        let e2u1 = (&Iv::from_i64(2) * &u1).exp();
        // κ = 2πe^{2U₁} − 9/2 − w/U₁, and ρ(U₁) = w·V₁ + 9U₁/2 − πe^{2U₁}
        let kappa = &(&(&(&Iv::from_i64(2) * &pi) * &e2u1)
            - &(&Iv::from_i64(9) / &Iv::from_i64(2)))
            - &(&Iv::from_i64(w as i64) / &u1);
        assert!(
            kappa.is_positive(),
            "the (G1d) majorant is not decreasing at w = {w}: raise V₁"
        );
        let rho = &(&(&Iv::from_i64(w as i64) * &Iv::point(&self.v1))
            + &(&(&Iv::from_i64(9) * &u1) / &Iv::from_i64(2)))
            - &(&pi * &e2u1);
        let b = &(&(&Iv::from_i64(4) * &(&pi * &pi)) * &rho.exp()) / &kappa;
        (&b * &Iv::from_i64(4)).sup_abs()
    }

    /// A certified enclosure of γ(n) = Γ_Φ(2n).
    pub fn gamma(&self, n: usize) -> Iv {
        self.gamma_parts(2 * n).gamma
    }

    /// A certified enclosure of a(n) = γ(n)·n!/(2n)! — POSITIVITY (12), and
    /// the γ(n) of both papers.
    pub fn a(&self, n: usize) -> Iv {
        &self.gamma(n) / &fact_ratio_iv(n)
    }

    /// a(0) … a(upto), certified.
    pub fn a_seq(&self, upto: usize) -> Vec<Iv> {
        (0..=upto).map(|n| self.a(n)).collect()
    }
}

/// ∏_{k=n+1}^{2n} k, enclosed — the reciprocal of [`crate::jensen::fact_ratio`].
///
/// Divided by rather than multiplied by, so the enclosure is of the exact
/// integer and no reciprocal is formed twice.
pub fn fact_ratio_iv(n: usize) -> Iv {
    let mut d = Iv::one();
    for k in (n + 1)..=(2 * n) {
        d = &d * &Iv::from_i64(k as i64);
    }
    d
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::jensen::a_at;
    use crate::mellin::Mellin;
    use crate::real::set_prec_digits;

    /// A cheap rule, for tests that only need the machinery to be consistent.
    fn quick() -> Certified {
        Certified::new(-8, 8, 1.4, 8)
    }

    /// The certified enclosure must contain what the measured pipeline
    /// computes — the two are independent implementations of the same integral
    /// and one of them is proved.
    #[test]
    fn the_enclosure_contains_the_measured_value() {
        set_prec_digits(50);
        let c = quick();
        let m = Mellin::standard();
        for n in [0usize, 1, 5, 12, 20] {
            let iv = c.gamma(n);
            let got = m.gamma(n);
            assert!(
                iv.contains(&got),
                "γ({n}) = {} outside [{}, {}]",
                got.sci(14),
                iv.lo.sci(14),
                iv.hi.sci(14)
            );
        }
    }

    /// Refining the grid must shrink the enclosure, and the two must overlap —
    /// if they did not, one of them would not be an enclosure.
    #[test]
    fn refining_the_grid_tightens_and_agrees() {
        set_prec_digits(50);
        let coarse = Certified::new(-8, 7, 1.4, 8);
        let fine = Certified::new(-8, 9, 1.4, 8);
        for n in [0usize, 4, 16] {
            let a = coarse.gamma(n);
            let b = fine.gamma(n);
            assert!(a.lo <= b.hi && b.lo <= a.hi, "enclosures of γ({n}) are disjoint");
            assert!(b.rel_width() < a.rel_width(), "refining did not tighten γ({n})");
            // h² — two halvings should buy about sixteen
            let r = (a.rel_width() / b.rel_width()).to_f64();
            assert!(r > 8.0, "γ({n}) tightened only {r}× over four times the nodes");
        }
    }

    /// The four pieces must add up to the whole, and the widths must be
    /// attributable — no piece may be silently doing the work of another.
    #[test]
    fn the_error_budget_adds_up() {
        set_prec_digits(50);
        let c = quick();
        let p = c.gamma_parts(0);
        let assembled = &(&(&p.quad + &p.t_lo) + &Iv::new(R::zero(), p.t_hi.clone()))
            + &Iv::pm(&p.e_quad);
        assert!(assembled.lo == p.gamma.lo && assembled.hi == p.gamma.hi);
        // at this coarse a step the quadrature remainder is what binds
        assert_eq!(p.dominant(), "G1b quadrature");
        // and the upper tail is nothing at all
        assert!(p.t_hi < R::from_f64(1e-1000), "upper tail = {}", p.t_hi.sci(6));
    }

    /// a(n) enclosed must contain a(n) computed, factorials and all.
    #[test]
    fn the_certified_moments_contain_the_computed_ones() {
        set_prec_digits(50);
        let c = quick();
        let m = Mellin::standard();
        for n in [0usize, 3, 9, 24, 36] {
            let iv = c.a(n);
            let got = a_at(&m, n);
            assert!(iv.contains(&got), "a({n}) = {} escapes its enclosure", got.sci(12));
        }
        // and the integer denominator is the right integer: 2!/1! = 2,
        // 4!/2! = 12, 72!/36! at n = 36. The inputs are exact; the products
        // still take an ulp each way from `Iv`'s outward rounding, so the
        // enclosure is a few ulps wide rather than a point.
        assert!(fact_ratio_iv(1).contains(&R::from_i64(2)));
        assert!(fact_ratio_iv(2).contains(&R::from_i64(12)));
        assert!(fact_ratio_iv(36).rel_width() < R::from_f64(1e-45));
    }

    /// **G1, end to end.** A certificate whose inputs are bounds and not
    /// values — and, on the same enclosures, the H2 story in miniature: P
    /// certifies where J cannot.
    #[test]
    fn p_certifies_from_the_bound_where_j_cannot() {
        use crate::jensen::{certify_iv, Family};
        set_prec_digits(50);
        let c = quick();
        let a = c.a_seq(34);
        for n in [0usize, 8, 16, 24, 32] {
            let p = certify_iv(Family::P, 2, n, &a);
            assert!(
                p.hyperbolic(),
                "P^{{2,{n}}} not certified from the bound: {:?}",
                p.verdict
            );
            assert_eq!(p.disc.unwrap().sign(), Some(1));
        }
        // this rule is deliberately coarse — coarse enough that J^{2,n} is
        // undecidable from it well before n = 30, which is the whole reason
        // G1 aims at P
        let j = certify_iv(Family::J, 2, 30, &a);
        assert!(
            !j.hyperbolic(),
            "J^{{2,30}} certified from a 5%-wide enclosure; the test proves nothing"
        );
        assert!(a[30].rel_width() > R::from_f64(1e-2));
    }

    /// (G1d) must be an upper bound on a quantity the measured rule can also
    /// see: extending V₁ upward may not move γ(n) by more than the bound says.
    #[test]
    fn the_upper_tail_bound_dominates_what_extending_v1_adds() {
        set_prec_digits(50);
        let short = Certified::new(-8, 8, 1.4, 8);
        let long = Certified::new(-8, 8, 1.9, 8);
        for n in [0usize, 10, 30] {
            let moved = (&short.gamma(n).mid() - &long.gamma(n).mid()).abs();
            let bound = short.gamma_parts(2 * n).t_hi;
            assert!(
                moved <= bound || moved < R::from_f64(1e-60) * short.gamma(n).mid().abs(),
                "extending V₁ moved γ({n}) by {} against a bound of {}",
                moved.sci(6),
                bound.sci(6)
            );
        }
    }
}
