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
    args = ap.parse_args()
    here = os.path.dirname(os.path.abspath(__file__))
    size = args.size
    for i, c in enumerate(args.cc, start=args.first_index):
        # total number of panels is the same for every c (the partition is fixed)
        # read it from a dry run: use 1305 for the canonical partition
        P = 1305
        nchunks = (P + size - 1) // size
        for j in range(nchunks):
            start = j * size
            end = min(P, start + size)
            out = os.path.join(args.outdir, f"DensityC{i}_{j}.lean")
            cmd = [sys.executable, os.path.join(here, "panels.py"),
                   "--c", c, "--h0", "1/125", "--h1", "1/20",
                   "--start", str(start), "--end", str(end),
                   "--out", out, "--ns", f"D{i}", "--wden", str(args.wden)]
            if j:
                cmd += ["--import", f"DensityC{i}_{j-1}"]
            if end == P:
                cmd += ["--final", "--name", f"density_mem_c{i}"]
            subprocess.run(cmd, check=True)

if __name__ == "__main__":
    main()
