//! Assembly of the `4 × 4` Weil Gram box and its exact rational certificate.

use crate::density::{densities_iv, DensityParams};
use crate::interval::Iv;
use crate::pole::pole_iv;
use crate::primes::{prime_iv, PrimePower};
use crate::rational::{rat_json, round_nearest};
use rug::ops::Pow;
use rug::{Integer, Rational};

pub const N: usize = 4;

fn zero_rat_mat() -> [[Rational; N]; N] {
    std::array::from_fn(|_| std::array::from_fn(|_| Rational::from(0)))
}

fn zero_iv_mat() -> [[Iv; N]; N] {
    std::array::from_fn(|_| std::array::from_fn(|_| Iv::from_i64(0)))
}

#[derive(Clone, Debug)]
pub struct Assembly {
    pub sigma: Rational,
    pub centres: [Rational; N],
    pub cs: Vec<Rational>,
    pub gram_raw: [[Iv; N]; N],
    pub gram: [[Iv; N]; N],
    pub centre: [[Rational; N]; N],
    pub err: [[Rational; N]; N],
    pub t: Rational,
    pub p: [[Rational; N]; N],
    pub ldl_l: [[Rational; N]; N],
    pub ldl_d: [Rational; N],
    pub leading_minors: [Rational; N],
    pub ldl_pivots: [Rational; N],
    pub numerical: [[Rational; N]; N],
    pub density: Vec<(Rational, Iv)>,
    pub prime: Vec<(Rational, Iv)>,
    pub pole: Vec<(Rational, Iv)>,
    pub margin: Rational,
    pub conversion_slack: Rational,
    pub grid_digits: u32,
}

fn find(map: &[(Rational, Iv)], c: &Rational) -> Iv {
    map.iter()
        .find(|(k, _)| k == c)
        .map(|(_, v)| v.clone())
        .unwrap_or_else(|| panic!("no interval recorded for c = {}", rat_json(c)))
}

fn sym_abs(c: &Rational) -> Rational {
    if *c < 0 {
        Rational::from(-c)
    } else {
        c.clone()
    }
}

fn det_leading(m: &[[Rational; N]; N], k: usize) -> Rational {
    // Laplace expansion; k ≤ 4.
    if k == 1 {
        return m[0][0].clone();
    }
    let mut total = Rational::from(0);
    for col in 0..k {
        let mut minor = vec![vec![Rational::from(0); k - 1]; k - 1];
        for i in 1..k {
            let mut jj = 0;
            for j in 0..k {
                if j == col {
                    continue;
                }
                minor[i - 1][jj] = m[i][j].clone();
                jj += 1;
            }
        }
        let mut sub = zero_rat_mat();
        for i in 0..(k - 1) {
            for j in 0..(k - 1) {
                sub[i][j] = minor[i][j].clone();
            }
        }
        let d = det_leading(&sub, k - 1);
        let term = Rational::from(&m[0][col] * &d);
        if col % 2 == 0 {
            total += term;
        } else {
            total -= term;
        }
    }
    total
}

/// Exact rational `L D Lᵀ` of a symmetric matrix, with unit lower `L`.
pub fn ldl(
    p: &[[Rational; N]; N],
) -> Result<([[Rational; N]; N], [Rational; N], [Rational; N]), String> {
    let mut a = p.clone();
    let mut l = zero_rat_mat();
    let mut d: [Rational; N] = std::array::from_fn(|_| Rational::from(0));
    for i in 0..N {
        l[i][i] = Rational::from(1);
    }
    for k in 0..N {
        let pivot = a[k][k].clone();
        d[k] = pivot.clone();
        if pivot == 0 {
            return Err(format!("zero LDL pivot at index {k}"));
        }
        for i in (k + 1)..N {
            let lik = Rational::from(&a[i][k] / &pivot);
            l[i][k] = lik.clone();
            for j in (k + 1)..N {
                let delta = Rational::from(&lik * &a[k][j]);
                a[i][j] = Rational::from(&a[i][j] - &delta);
            }
        }
    }
    Ok((l, d.clone(), d))
}

pub fn assemble(
    cs: &[Rational],
    sigma: &Rational,
    centres: &[Rational; N],
    prime_data: &[PrimePower],
    params: &DensityParams,
    margin: &Rational,
    grid_digits: u32,
) -> Result<Assembly, String> {
    let scale = Integer::from(10).pow(grid_digits);

    let densities = densities_iv(cs, params);
    let density: Vec<(Rational, Iv)> = cs
        .iter()
        .cloned()
        .zip(densities.into_iter())
        .map(|(c, iv)| (c, iv.round_to_grid(&scale)))
        .collect();

    // The seven separations c = a − b.
    let separations: Vec<Rational> = vec![
        Rational::from(-3) / 5,
        Rational::from(-2) / 5,
        Rational::from(-1) / 5,
        Rational::from(0),
        Rational::from(1) / 5,
        Rational::from(2) / 5,
        Rational::from(3) / 5,
    ];
    let pole: Vec<(Rational, Iv)> = separations
        .iter()
        .map(|c| (c.clone(), pole_iv(c, sigma).round_to_grid(&scale)))
        .collect();
    let prime: Vec<(Rational, Iv)> = separations
        .iter()
        .map(|c| {
            (
                c.clone(),
                prime_iv(c, sigma, prime_data).round_to_grid(&scale),
            )
        })
        .collect();

    let mut gram_raw = zero_iv_mat();
    let mut gram = zero_iv_mat();

    let width = Rational::from(margin);
    for i in 0..N {
        for j in i..N {
            let c = Rational::from(&centres[i] - &centres[j]);
            let dens = find(&density, &sym_abs(&c));
            let wp = find(&pole, &c).add(&dens).add(&find(&prime, &c));
            let wm = find(&pole, &Rational::from(-&c))
                .add(&dens)
                .add(&find(&prime, &Rational::from(-&c)));
            let g = wp
                .add(&wm)
                .scale(&(Rational::from(1) / Rational::from(2)));
            let raw = g.round_to_grid(&scale);
            let widened = Iv::new(
                Rational::from(&raw.lo - &width),
                Rational::from(&raw.hi + &width),
            )
            .round_to_grid(&scale);
            gram_raw[i][j] = raw.clone();
            gram_raw[j][i] = raw;
            gram[i][j] = widened.clone();
            gram[j][i] = widened;
        }
    }

    let mut centre = zero_rat_mat();
    let mut err = centre.clone();
    for i in 0..N {
        for j in 0..N {
            centre[i][j] = gram[i][j].centre();
            err[i][j] = Rational::from(&gram[i][j].hi - &gram[i][j].lo) / 2;
        }
    }
    // Exact symmetry of the recorded half-widths.
    for i in 0..N {
        for j in (i + 1)..N {
            if err[i][j] < err[j][i] {
                err[i][j] = err[j][i].clone();
            } else {
                err[j][i] = err[i][j].clone();
            }
        }
    }

    let conversion_slack = Rational::from(1) / Rational::from(1_000_000_000);
    let mut t = Rational::from(0);
    for i in 0..N {
        let row: Rational = (0..N).map(|j| err[i][j].clone()).sum();
        if row > t {
            t = row;
        }
    }
    t += &conversion_slack;

    let mut p = centre.clone();
    for i in 0..N {
        p[i][i] = Rational::from(&centre[i][i] - &t);
    }

    let (ldl_l, ldl_d, _) = ldl(&p)?;

    let mut leading_minors: [Rational; N] = std::array::from_fn(|_| Rational::from(0));
    for k in 1..=N {
        leading_minors[k - 1] = det_leading(&p, k);
    }
    for (k, pivot) in ldl_d.iter().enumerate() {
        if *pivot <= 0 {
            return Err(format!(
                "P = G0 − tI is not positive definite: pivot {} = {}",
                k + 1,
                rat_json(pivot)
            ));
        }
    }

    // A distinct 12-digit numerical matrix inside the box, used by the Lean
    // instance check (the centre itself is the mid-point of the box).
    let nscale = Integer::from(10).pow(12);
    let mut numerical = zero_rat_mat();
    for i in 0..N {
        for j in 0..N {
            numerical[i][j] = round_nearest(&centre[i][j], &nscale);
        }
    }

    Ok(Assembly {
        sigma: sigma.clone(),
        centres: centres.clone(),
        cs: cs.to_vec(),
        gram_raw,
        gram,
        centre,
        err,
        t,
        p,
        ldl_l,
        ldl_d: ldl_d.clone(),
        leading_minors,
        ldl_pivots: ldl_d,
        numerical,
        density,
        prime,
        pole,
        margin: margin.clone(),
        conversion_slack,
        grid_digits,
    })
}

impl Assembly {
    pub fn gram_contains(&self, a: &[[Rational; N]; N]) -> bool {
        (0..N).all(|i| (0..N).all(|j| self.gram[i][j].contains(&a[i][j])))
    }

    pub fn row_sums(&self) -> [Rational; N] {
        let mut out: [Rational; N] = std::array::from_fn(|_| Rational::from(0));
        for i in 0..N {
            out[i] = (0..N).map(|j| self.err[i][j].clone()).sum();
        }
        out
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::rational::parse_rational;

    #[test]
    fn determinant_and_ldl_agree_on_a_small_example() {
        let mut m = zero_rat_mat();
        m[0][0] = Rational::from(4);
        m[0][1] = Rational::from(1);
        m[1][0] = Rational::from(1);
        m[1][1] = Rational::from(3);
        m[2][2] = Rational::from(2);
        m[3][3] = Rational::from(5);
        let (l, d, _) = ldl(&m).unwrap();
        // reconstruct
        let mut rebuilt = zero_rat_mat();
        for i in 0..N {
            for j in 0..N {
                let mut s = Rational::from(0);
                for k in 0..N {
                    let prod = Rational::from(&l[i][k] * &d[k]);
                    s += Rational::from(&prod * &l[j][k]);
                }
                rebuilt[i][j] = s;
            }
        }
        assert_eq!(rebuilt, m);
        assert_eq!(det_leading(&m, 2), parse_rational("11").unwrap());
    }
}
