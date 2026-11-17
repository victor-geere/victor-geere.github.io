#!/usr/bin/env python3
"""Emit the four chunked density certificates.

Each `c` is split into chunks of `--size` panels (default 150) to keep the peak
memory of a single `lean` invocation within a few GB.  The chunks of one `c`
share the namespace `PrimeSpectrumTensor.D<i>`, so they can import each other;
`DensityCertificates.lean` imports only the last chunk of each.
"""
import argparse, subprocess, sys, os

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--size", type=int, default=150)
    ap.add_argument("--outdir", default="..")
    ap.add_argument("--cc", nargs="+", default=["0", "1/5", "2/5", "3/5"])
    ap.add_argument("--first-index", type=int, default=0,
                    help="index of the first c (controls the DensityC<i>_* names)")
    ap.add_argument("--wden", type=int, default=400,
                    help="second-derivative constant denominator (200 for c = ±4/5)")
    ap.add_argument("--one", action="store_true",
                    help="use the |c| ≤ 1 panel certificate")
    ap.add_argument("--h0", default="1/125")
    ap.add_argument("--h1", default="1/20")
    args = ap.parse_args()
    here = os.path.dirname(os.path.abspath(__file__))
    size = args.size
    for i, c in enumerate(args.cc, start=args.first_index):
        # total number of panels for this partition
        from fractions import Fraction
        h0f = Fraction(args.h0)
        h1f = Fraction(args.h1)
        P = int(round(1 / h0f)) + int(round(59 / h1f))
        nchunks = (P + size - 1) // size
        for j in range(nchunks):
            start = j * size
            end = min(P, start + size)
            out = os.path.join(args.outdir, f"DensityC{i}_{j}.lean")
            cmd = [sys.executable, os.path.join(here, "panels.py"),
                   "--c", c, "--h0", args.h0, "--h1", args.h1,
                   "--start", str(start), "--end", str(end),
                   "--out", out, "--ns", f"D{i}", "--wden", str(args.wden)]
            if args.one:
                cmd += ["--one"]
            if j:
                cmd += ["--import", f"DensityC{i}_{j-1}"]
            if end == P:
                cmd += ["--final", "--name", f"density_mem_c{i}"]
            subprocess.run(cmd, check=True)

if __name__ == "__main__":
    main()
