//! Writer for `python/rust_certificate.json`.
//!
//! Every numeric leaf is an exact rational string `"p/q"`; the Python verifier
//! accepts these through `fractions.Fraction`.

use crate::assemble::Assembly;
use crate::density::DensityParams;
use crate::interval::Iv;
use crate::rational::rat_json;
use rug::Rational;
use serde_json::{json, Value};

fn iv_value(iv: &Iv) -> Value {
    json!([rat_json(&iv.lo), rat_json(&iv.hi)])
}

fn mat_iv(m: &[[Iv; 4]; 4]) -> Value {
    Value::Array(
        (0..4)
            .map(|i| Value::Array((0..4).map(|j| iv_value(&m[i][j])).collect()))
            .collect(),
    )
}

fn mat_rat(m: &[[Rational; 4]; 4]) -> Value {
    Value::Array(
        (0..4)
            .map(|i| {
                Value::Array((0..4).map(|j| Value::String(rat_json(&m[i][j]))).collect())
            })
            .collect(),
    )
}

fn vec_rat(v: &[Rational; 4]) -> Value {
    Value::Array(v.iter().map(|q| Value::String(rat_json(q))).collect())
}

fn omega_pairs(list: &[(Rational, Iv)]) -> Value {
    Value::Array(
        list.iter()
            .map(|(t, iv)| {
                json!({
                    "t": rat_json(t),
                    "lo": rat_json(&iv.lo),
                    "hi": rat_json(&iv.hi),
                })
            })
            .collect(),
    )
}

fn pairs(list: &[(Rational, Iv)]) -> Value {
    Value::Array(
        list.iter()
            .map(|(c, iv)| {
                json!({
                    "c": rat_json(c),
                    "lo": rat_json(&iv.lo),
                    "hi": rat_json(&iv.hi),
                })
            })
            .collect(),
    )
}

pub fn to_json(
    a: &Assembly,
    params: &DensityParams,
    panels: u64,
    cutoff: u32,
    omega_samples: &[(Rational, Iv)],
) -> Value {
    let density_by_c: Value = Value::Object(
        a.density
            .iter()
            .map(|(c, iv)| (rat_json(c), Value::String(rat_json(&iv.centre()))))
            .collect(),
    );

    let prime_at_06 = a
        .prime
        .iter()
        .find(|(c, _)| *c == Rational::from(3) / 5)
        .map(|(_, iv)| rat_json(&iv.centre()))
        .unwrap_or_else(|| "0".to_string());

    let w_sigma = rat_json(&a.gram_raw[0][0].centre());

    json!({
        "kind": "finite-weil-gram-shadow",
        "status": "certified",
        "generator": "rust/weil-assembly",
        "sigma": rat_json(&a.sigma),
        "centres": a.centres.iter().map(|c| rat_json(c)).collect::<Vec<_>>(),
        "prime_cutoff": cutoff,
        "density_panels": {
            "H": rat_json(&params.h),
            "T": rat_json(&params.t_max),
            "U": params.taylor_order,
            "order": params.n_shift,
            "h": rat_json(&params.t_start),
            "panels": panels,
            "n_shift": params.n_shift,
            "taylor_order": params.taylor_order,
            "grid_digits": a.grid_digits,
        },
        "margin": rat_json(&a.margin),
        "density": pairs(&a.density),
        "pole_intervals": pairs(&a.pole),
        "prime_intervals": pairs(&a.prime),
        "gram_raw": mat_iv(&a.gram_raw),
        "gram": mat_iv(&a.gram),
        "centre_matrix": mat_rat(&a.centre),
        "conversion_slack": rat_json(&a.conversion_slack),
        "operator_slack": rat_json(&a.t),
        "leading_minors": vec_rat(&a.leading_minors),
        "ldl_pivots": vec_rat(&a.ldl_pivots),
        "ldl": {
            "L": mat_rat(&a.ldl_l),
            "d": vec_rat(&a.ldl_d),
            "P": mat_rat(&a.p),
            "unit_lower": true,
        },
        "omega_samples": omega_pairs(omega_samples),
        "numerical": {
            "W_sigma": w_sigma,
            "prime_at_06": prime_at_06,
            "density": density_by_c,
            "gram": mat_rat(&a.numerical),
        },
        "provenance": "Rust exact-rational interval assembly (rust/weil-assembly): \
Omega via the T79 Euler-Maclaurin decomposition with MPFR log enclosures; \
density by per-panel Taylor integration of the Gaussian/cosine weight and the \
T79 panel enclosure of Omega; finite prime sum to X=20000. Every emitted \
endpoint is an exact rational; the certificate is cross-checked by \
tests/test_rust_certificate.py.",
    })
}
