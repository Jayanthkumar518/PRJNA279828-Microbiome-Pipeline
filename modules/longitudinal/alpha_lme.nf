process ALPHA_LME {

    tag "alpha_longitudinal_lme"

    cpus params.threads

    conda "${projectDir}/envs/qiime2.yml"

    publishDir "${params.outdir}/09_longitudinal/alpha",
        mode: 'copy'

    input:

    path shannon
    path metadata

    output:

    path "alpha_shannon_lme.qzv",
        emit: visualization

    script:

    """
    echo "===== Exporting Shannon diversity ====="

    qiime tools export \
        --input-path ${shannon} \
        --output-path shannon_export

    echo "===== Preparing LME metadata ====="

    python - <<'PY'
import pandas as pd

metadata = pd.read_csv(
    "${metadata}",
    sep="\\t"
)

shannon = pd.read_csv(
    "shannon_export/alpha-diversity.tsv",
    sep="\\t"
)

# ---------------------------------------------------------
# Identify sample ID column
# ---------------------------------------------------------

shannon = shannon.rename(
    columns={shannon.columns[0]: "sample-id"}
)

print("Metadata columns:")
print(metadata.columns.tolist())

print("Shannon columns:")
print(shannon.columns.tolist())

# ---------------------------------------------------------
# QIIME 2 exports Shannon as 'shannon_entropy'
# Rename it to 'shannon' for the LME model
# ---------------------------------------------------------

if "shannon_entropy" not in shannon.columns:
    raise ValueError(
        "Expected 'shannon_entropy' column was not found "
        f"in Shannon output. Found: {shannon.columns.tolist()}"
    )

shannon = shannon.rename(
    columns={
        "shannon_entropy": "shannon"
    }
)

# ---------------------------------------------------------
# Merge metadata with Shannon diversity
# ---------------------------------------------------------

merged = metadata.merge(
    shannon[["sample-id", "shannon"]],
    on="sample-id",
    how="inner"
)

if merged.empty:
    raise ValueError(
        "No sample IDs matched between longitudinal metadata "
        "and Shannon diversity values."
    )

# ---------------------------------------------------------
# Validate required columns
# ---------------------------------------------------------

required = [
    "sample-id",
    "subject",
    "timepoint",
    "shannon"
]

missing = [
    column
    for column in required
    if column not in merged.columns
]

if missing:
    raise ValueError(
        f"Missing required columns: {missing}"
    )

# ---------------------------------------------------------
# Remove samples with missing Shannon values
# ---------------------------------------------------------

merged["shannon"] = pd.to_numeric(
    merged["shannon"],
    errors="coerce"
)

merged = merged.dropna(
    subset=["shannon", "subject", "timepoint"]
)

if merged.empty:
    raise ValueError(
        "No valid Shannon observations remain after filtering."
    )

# ---------------------------------------------------------
# Save metadata for QIIME 2 LME
# ---------------------------------------------------------

merged.to_csv(
    "alpha_lme_metadata.tsv",
    sep="\\t",
    index=False
)

# ---------------------------------------------------------
# Summary
# ---------------------------------------------------------

print(
    f"Prepared alpha LME metadata: "
    f"{len(merged)} samples"
)

print(
    f"Subjects: "
    f"{merged['subject'].nunique()}"
)

print(
    f"Timepoints: "
    f"{merged['timepoint'].nunique()}"
)

print(
    "Shannon column successfully prepared."
)
PY

    echo "===== Running QIIME 2 longitudinal LME ====="

    qiime longitudinal linear-mixed-effects \
        --m-metadata-file alpha_lme_metadata.tsv \
        --p-metric shannon \
        --p-state-column timepoint \
        --p-individual-id-column subject \
        --o-visualization alpha_shannon_lme.qzv

    echo "===== Alpha longitudinal LME completed ====="
    """
}

