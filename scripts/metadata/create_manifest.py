#!/usr/bin/env python3

import os
import sys

raw_dir = sys.argv[1]
outfile = sys.argv[2]

forward = {}
reverse = {}

for f in sorted(os.listdir(raw_dir)):
    if f.endswith("_1.fastq.gz"):
        sample = f.replace("_1.fastq.gz", "")
        forward[sample] = os.path.abspath(os.path.join(raw_dir, f))

    elif f.endswith("_2.fastq.gz"):
        sample = f.replace("_2.fastq.gz", "")
        reverse[sample] = os.path.abspath(os.path.join(raw_dir, f))

with open(outfile, "w") as out:

    out.write("sample-id\tforward-absolute-filepath\treverse-absolute-filepath\n")

    for sample in sorted(forward):

        out.write(
            f"{sample}\t{forward[sample]}\t{reverse[sample]}\n"
        )

print("Manifest created successfully.")