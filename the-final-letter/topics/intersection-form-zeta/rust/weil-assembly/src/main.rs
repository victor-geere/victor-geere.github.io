//! CLI: emit `lean/Certificate.lean` and `python/rust_certificate.json`.

use clap::Parser;
use std::path::PathBuf;
use std::process::ExitCode;

use weil_assembly::assemble::assemble;
use weil_assembly::density::DensityParams;
use weil_assembly::interval::Iv;
use weil_assembly::json_out::to_json;
use weil_assembly::lean_out::write_lean;
use weil_assembly::omega::omega_point;
use weil_assembly::primes::prime_power_data;
use weil_assembly::rational::parse_rational;
use rug::ops::Pow;
use rug::Rational;

#[derive(Parser, Debug)]
#[command(
    name = "weil-assembly",
    about = "Certified rational interval assembly of the 4x4 Gaussian Weil Gram matrix"
)]
struct Args {
    #[arg(long, default_value = "lean/Certificate.lean")]
    out_lean: PathBuf,
    #[arg(long, default_value = "python/rust_certificate.json")]
    out_json: PathBuf,
    #[arg(long, default_value = "1/20")]
    sigma: String,
    #[arg(long, default_value_t = 20000)]
    cutoff: u32,
    #[arg(long, default_value = "150")]
    t_max: String,
    #[arg(long, default_value = "1/1000")]
    h: String,
    #[arg(long, default_value = "1/100000")]
    t_start: String,
    #[arg(long, default_value_t = 30)]
    n_shift: u32,
    #[arg(long, default_value_t = 6)]
    taylor_order: u32,
    #[arg(long, default_value_t = 15)]
    grid_digits: u32,
    #[arg(long, default_value = "1/10000")]
    margin: String,
    #[arg(long, default_value_t = 200)]
    log_series_m: u32,
}

fn main() -> ExitCode {
    match run() {
        Ok(()) => ExitCode::SUCCESS,
        Err(e) => {
            eprintln!("weil-assembly: {e}");
            ExitCode::FAILURE
        }
    }
}

fn run() -> Result<(), String> {
    let args = Args::parse();
    let sigma = parse_rational(&args.sigma)?;
    let margin = parse_rational(&args.margin)?;

    let centres = [
        parse_rational("-3/10")?,
        parse_rational("-1/10")?,
        parse_rational("1/10")?,
        parse_rational("3/10")?,
    ];
    let cs = vec![
        parse_rational("0")?,
        parse_rational("1/5")?,
        parse_rational("2/5")?,
        parse_rational("3/5")?,
    ];

    eprintln!("sieving prime powers to X = {}", args.cutoff);
    let prime_data = prime_power_data(args.cutoff);
    eprintln!("prime powers: {}", prime_data.len());

    let params = DensityParams {
        sigma: sigma.clone(),
        t_start: parse_rational(&args.t_start)?,
        t_max: parse_rational(&args.t_max)?,
        h: parse_rational(&args.h)?,
        n_shift: args.n_shift,
        taylor_order: args.taylor_order,
    };

    eprintln!(
        "density quadrature: T = {}, H = {}, start = {}, N = {}, order = {}",
        args.t_max, args.h, args.t_start, args.n_shift, args.taylor_order
    );
    let assembly = assemble(
        &cs,
        &sigma,
        &centres,
        &prime_data,
        &params,
        &margin,
        args.grid_digits,
    )?;

    // Count the panels actually used.
    let mut panels: u64 = 0;
    let mut a = params.t_start.clone();
    while a < params.t_max {
        let mut b = Rational::from(&a + &params.h);
        if b > params.t_max {
            b = params.t_max.clone();
        }
        panels += 1;
        a = b;
    }

    let omega_scale = rug::Integer::from(10).pow(args.grid_digits);
    let mut omega_samples: Vec<(Rational, Iv)> = Vec::new();
    for t in ["0", "1/2", "1", "10"] {
        let tv = parse_rational(t)?;
        let iv = omega_point(&tv, args.n_shift, args.log_series_m).round_to_grid(&omega_scale);
        omega_samples.push((tv, iv));
    }

    let lean = write_lean(&assembly);
    let json = serde_json::to_string_pretty(&to_json(&assembly, &params, panels, args.cutoff, &omega_samples))
        .map_err(|e| format!("JSON serialisation failed: {e}"))?;

    std::fs::write(&args.out_lean, lean)
        .map_err(|e| format!("cannot write {}: {e}", args.out_lean.display()))?;
    std::fs::write(&args.out_json, format!("{json}\n"))
        .map_err(|e| format!("cannot write {}: {e}", args.out_json.display()))?;

    println!("wrote {}", args.out_lean.display());
    println!("wrote {}", args.out_json.display());
    println!("CERTIFIED");
    println!("panels: {panels}");
    println!("operator slack t = {}", assembly.t);
    for (k, m) in assembly.leading_minors.iter().enumerate() {
        println!("  minor {}: {}", k + 1, m);
    }
    println!("density widths:");
    for (c, iv) in &assembly.density {
        println!(
            "  c = {:>4}: width = {:.3e}  [{}, {}]",
            c,
            iv.width().to_f64(),
            iv.lo,
            iv.hi
        );
    }
    println!("pole widths:");
    for (c, iv) in &assembly.pole {
        println!("  c = {:>4}: width = {:.3e}", c, iv.width().to_f64());
    }
    println!("prime widths:");
    for (c, iv) in &assembly.prime {
        println!("  c = {:>4}: width = {:.3e}", c, iv.width().to_f64());
    }
    println!("ω samples:");
    for (t, iv) in &omega_samples {
        println!(
            "  t = {:>4}: width = {:.3e}",
            t,
            iv.width().to_f64()
        );
    }
    if !assembly.gram_contains(&assembly.numerical) {
        return Err("numerical matrix is outside the certified box".into());
    }
    Ok(())
}
