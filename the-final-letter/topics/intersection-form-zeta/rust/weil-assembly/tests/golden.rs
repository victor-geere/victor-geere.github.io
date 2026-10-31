//! Golden comparisons against the Python certificate.
//!
//! Runs a moderately sized assembly (T = 150, H = 1/100) and checks that its
//! intervals contain the independent Python/mpmath values recorded in
//! `python/weil_certificate.json`, that the two interval enclosures overlap,
//! and that the exact `LDLᵀ` identity holds.

use std::path::PathBuf;
use std::sync::OnceLock;

use rug::Rational;
use serde_json::Value;
use weil_assembly::assemble::assemble;
use weil_assembly::density::DensityParams;
use weil_assembly::lean_out::write_lean;
use weil_assembly::primes::prime_power_data;
use weil_assembly::rational::{parse_rational, rat_json};

fn topic_dir() -> PathBuf {
    PathBuf::from(env!("CARGO_MANIFEST_DIR"))
        .parent()
        .unwrap()
        .parent()
        .unwrap()
        .to_path_buf()
}

fn load_python_cert() -> Value {
    let path = topic_dir().join("python").join("weil_certificate.json");
    let text = std::fs::read_to_string(&path).expect("python/weil_certificate.json");
    serde_json::from_str(&text).expect("valid JSON")
}

fn val(v: &Value) -> Rational {
    parse_rational(v.as_str().expect("string leaf")).unwrap()
}

static ASSEMBLY: OnceLock<weil_assembly::assemble::Assembly> = OnceLock::new();

fn run() -> &'static weil_assembly::assemble::Assembly {
    ASSEMBLY.get_or_init(build_assembly)
}

fn build_assembly() -> weil_assembly::assemble::Assembly {
    let sigma = parse_rational("1/20").unwrap();
    let centres = [
        parse_rational("-3/10").unwrap(),
        parse_rational("-1/10").unwrap(),
        parse_rational("1/10").unwrap(),
        parse_rational("3/10").unwrap(),
    ];
    let cs = vec![
        parse_rational("0").unwrap(),
        parse_rational("1/5").unwrap(),
        parse_rational("2/5").unwrap(),
        parse_rational("3/5").unwrap(),
    ];
    let data = prime_power_data(20000);
    assert_eq!(data.len(), 2328);
    let params = DensityParams {
        sigma: sigma.clone(),
        t_start: parse_rational("1/100000").unwrap(),
        t_max: parse_rational("80").unwrap(),
        h: parse_rational("1/100").unwrap(),
        n_shift: 30,
        taylor_order: 6,
    };
    let margin = parse_rational("1/10000").unwrap();
    assemble(&cs, &sigma, &centres, &data, &params, &margin, 15)
        .expect("certificate assembly")
}

#[test]
fn golden_density_and_prime_against_python() {
    let py = load_python_cert();
    let a = run();

    // Density: independent numerical values and overlap with the Python box.
    let py_density = py["density"].as_array().unwrap();
    let py_numerical = py["numerical"]["density"].as_object().unwrap();
    for rec in py_density {
        let c = parse_rational(rec["c"].as_str().unwrap()).unwrap();
        let ours = a
            .density
            .iter()
            .find(|(k, _)| *k == c)
            .map(|(_, iv)| iv)
            .expect("density entry");
        let lo = val(&rec["lo"]);
        let hi = val(&rec["hi"]);
        assert!(
            ours.lo <= hi && lo <= ours.hi,
            "density(c={}) intervals do not overlap",
            rat_json(&c)
        );
        let key = format!("{:.1}", c.to_f64());
        if let Some(num) = py_numerical
            .iter()
            .find(|(k, _)| *k == &key)
            .map(|(_, v)| v)
        {
            let point = val(num);
            assert!(ours.contains(&point), "density interval misses numerical value");
        }
        assert!(ours.width() < parse_rational("1/1000").unwrap());
    }

    // Prime sums: check the recorded numerical prime at c = 3/5.
    let prime_06 = val(&py["numerical"]["prime_at_06"]);
    let ours_06 = a
        .prime
        .iter()
        .find(|(c, _)| *c == parse_rational("3/5").unwrap())
        .map(|(_, iv)| iv)
        .unwrap();
    assert!(ours_06.contains(&prime_06));
    assert!(ours_06.width() < parse_rational("1/100000000").unwrap());
}

#[test]
fn golden_gram_contains_python_numerical_matrix() {
    let py = load_python_cert();
    let a = run();
    let py_gram = py["numerical"]["gram"].as_array().unwrap();
    let py_box = py["gram"].as_array().unwrap();
    for i in 0..4 {
        for j in 0..4 {
            let point = val(&py_gram[i][j]);
            assert!(
                a.gram[i][j].contains(&point),
                "gram interval ({i},{j}) misses the numerical value"
            );
            let lo = val(&py_box[i][j][0]);
            let hi = val(&py_box[i][j][1]);
            assert!(
                a.gram[i][j].lo <= hi && lo <= a.gram[i][j].hi,
                "gram intervals do not overlap at ({i},{j})"
            );
        }
    }
}

#[test]
fn certificate_is_internally_consistent() {
    let a = run();
    // t = max row sum + 10^-9, and P = G0 - tI.
    let slack = parse_rational("1/1000000000").unwrap();
    let max_row = a.row_sums().into_iter().max().unwrap();
    assert_eq!(a.t, max_row + slack);
    let zero = Rational::from(0);
    for i in 0..4 {
        for j in 0..4 {
            let offset = if i == j { &a.t } else { &zero };
            let expected = Rational::from(&a.centre[i][j] - offset);
            assert_eq!(a.p[i][j], expected);
        }
    }
    // Exact LDL reconstruction.
    for i in 0..4 {
        for j in 0..4 {
            let mut s = Rational::from(0);
            for k in 0..4 {
                let prod = Rational::from(&a.ldl_l[i][k] * &a.ldl_d[k]);
                s += Rational::from(&prod * &a.ldl_l[j][k]);
            }
            assert_eq!(s, a.p[i][j], "LDL mismatch at ({i},{j})");
        }
    }
    assert!(a.ldl_d.iter().all(|d| *d > 0));
    assert!(a.gram_contains(&a.numerical));
}

#[test]
fn lean_output_is_sorry_free() {
    let a = run();
    let text = write_lean(&a);
    for bad in ["sorry", "axiom ", "native_decide"] {
        assert!(!text.contains(bad), "Lean output contains {bad}");
    }
    assert!(text.contains("theorem certA_posDef"));
    assert!(text.contains("theorem certP_posDef"));
}
