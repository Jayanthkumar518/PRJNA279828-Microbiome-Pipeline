#!/usr/bin/env python3

import os
import sys

raw_dir = sys.argv[1]
outfile = sys.argv[2]

forward = {}
reverse = {}

for filename in sorted(os.listdir(raw_dir)):

    if filename.endswith("_1.fastq.gz"):
        sample = filename[:-len("_1.fastq.gz")]
        forward[sample] = os.path.abspath(
            os.path.join(raw_dir, filename)
        )

    elif filename.endswith("_2.fastq.gz"):
        sample = filename[:-len("_2.fastq.gz")]
        reverse[sample] = os.path.abspath(
            os.path.join(raw_dir, filename)
        )

samples = sorted(set(forward) & set(reverse))

if not samples:
    raise RuntimeError(
        "No complete paired-end FASTQ files were found."
    )

missing_forward = sorted(set(reverse) - set(forward))
missing_reverse = sorted(set(forward) - set(reverse))

if missing_forward:
    raise RuntimeError(
        f"Missing forward reads for: {missing_forward}"
    )

if missing_reverse:
    raise RuntimeError(
        f"Missing reverse reads for: {missing_reverse}"
    )

with open(outfile, "w") as out:

    out.write(
        "sample-id\t"
        "forward-absolute-filepath\t"
        "reverse-absolute-filepath\n"
    )

    for sample in samples:

        out.write(
            f"{sample}\t"
            f"{forward[sample]}\t"
            f"{reverse[sample]}\n"
        )

print(f"Manifest created successfully.")
print(f"Paired-end samples: {len(samples)}")