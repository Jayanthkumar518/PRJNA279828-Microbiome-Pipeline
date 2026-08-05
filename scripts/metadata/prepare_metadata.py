#!/usr/bin/env python3

"""
Prepare QIIME2 metadata from the SRA Run Table
Project:
PRJNA279828

Output:
metadata.tsv
manifest.tsv
"""

import pandas as pd
from pathlib import Path

# ---------------------------------------------------
# Directories
# ---------------------------------------------------

ROOT = Path(__file__).resolve().parents[1]

sra_table = ROOT / "data" / "metadata" / "SraRunTable.csv"

metadata_out = ROOT / "data" / "metadata" / "metadata.tsv"
manifest_out = ROOT / "data" / "metadata" / "manifest.tsv"

raw_dir = ROOT / "data" / "raw"

# ---------------------------------------------------
# Read SRA table
# ---------------------------------------------------

df = pd.read_csv(sra_table)

# ---------------------------------------------------
# Rename columns
# ---------------------------------------------------

metadata = pd.DataFrame()

metadata["sample-id"] = df["Run"]

metadata["subject"] = df["host_subject_id"]

metadata["age_days"] = df["host_age_(in_days)"]

metadata["birth_weight"] = df["Birth_weight_(kg)"]

metadata["sex"] = df["host_sex"]

metadata["weight"] = df["host_weight_(kg)"]

metadata["height_cm"] = df["host_height_(cm)"]

metadata["country"] = df["geo_loc_name_country"]

metadata["collection_date"] = df["Collection_Date"]

# ---------------------------------------------------
# Create group column
# ---------------------------------------------------

metadata["group"] = metadata["birth_weight"].apply(
    lambda x: "stunted" if float(x) < 2.5 else "control"
)

# ---------------------------------------------------
# Calculate age in months
# ---------------------------------------------------

metadata["age_months"] = (metadata["age_days"] / 30).round(1)

# ---------------------------------------------------
# Timepoint
# ---------------------------------------------------

metadata["timepoint"] = (
    metadata
    .groupby("subject")
    .cumcount() + 1
)

# ---------------------------------------------------
# Save metadata
# ---------------------------------------------------

metadata.to_csv(
    metadata_out,
    sep="\t",
    index=False
)

print("Metadata saved")

# ---------------------------------------------------
# Manifest
# ---------------------------------------------------

manifest = pd.DataFrame()

manifest["sample-id"] = df["Run"]

manifest["forward-absolute-filepath"] = [
    str((raw_dir / f"{x}_1.fastq.gz").resolve())
    for x in df["Run"]
]

manifest["reverse-absolute-filepath"] = [
    str((raw_dir / f"{x}_2.fastq.gz").resolve())
    for x in df["Run"]
]

manifest["direction"] = [
    "forward"
] * len(df)

manifest_forward = manifest.copy()

manifest_reverse = manifest.copy()

manifest_reverse["forward-absolute-filepath"] = manifest_reverse[
    "reverse-absolute-filepath"
]

manifest_reverse = manifest_reverse.rename(
    columns={
        "forward-absolute-filepath":
        "absolute-filepath"
    }
)

manifest_forward = manifest_forward.rename(
    columns={
        "forward-absolute-filepath":
        "absolute-filepath"
    }
)

manifest_forward["direction"] = "forward"

manifest_reverse["direction"] = "reverse"

manifest = pd.concat(
    [manifest_forward, manifest_reverse]
)

manifest = manifest[
    [
        "sample-id",
        "absolute-filepath",
        "direction"
    ]
]

manifest.to_csv(
    manifest_out,
    sep="\t",
    index=False
)

print("Manifest saved")