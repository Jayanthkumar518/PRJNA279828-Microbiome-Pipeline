import sys
import pandas as pd


input_file = sys.argv[1]
output_file = sys.argv[2]

# ---------------------------------------------------------
# Read metadata
# ---------------------------------------------------------

df = pd.read_csv(input_file, sep="\t")

required_columns = [
    "sample-id",
    "subject",
    "collection_date",
    "timepoint"
]

missing = [col for col in required_columns if col not in df.columns]

if missing:
    raise ValueError(
        f"Missing required metadata columns: {', '.join(missing)}"
    )


# ---------------------------------------------------------
# Convert data types
# ---------------------------------------------------------

df["collection_date"] = pd.to_datetime(
    df["collection_date"],
    errors="coerce"
)

df["timepoint"] = pd.to_numeric(
    df["timepoint"],
    errors="coerce"
)

if "age_days" in df.columns:
    df["age_days"] = pd.to_numeric(
        df["age_days"],
        errors="coerce"
    )

if "age_months" in df.columns:
    df["age_months"] = pd.to_numeric(
        df["age_months"],
        errors="coerce"
    )

if "weight" in df.columns:
    df["weight"] = pd.to_numeric(
        df["weight"],
        errors="coerce"
    )

if "height_cm" in df.columns:
    df["height_cm"] = pd.to_numeric(
        df["height_cm"],
        errors="coerce"
    )


# ---------------------------------------------------------
# Sort longitudinal observations
# ---------------------------------------------------------

df = df.sort_values(
    ["subject", "timepoint"]
).reset_index(drop=True)


# ---------------------------------------------------------
# Add longitudinal helper columns
# ---------------------------------------------------------

df["is_repeated_subject"] = df["subject"].duplicated(
    keep=False
)

df["n_timepoints"] = df.groupby(
    "subject"
)["timepoint"].transform("count")

df["previous_timepoint"] = df.groupby(
    "subject"
)["timepoint"].shift(1)

df["timepoint_change"] = (
    df["timepoint"] -
    df["previous_timepoint"]
)


# ---------------------------------------------------------
# Create analysis-friendly aliases
# ---------------------------------------------------------

df["individual_id"] = df["subject"]

df["state"] = df["timepoint"]

df["time"] = df["age_months"] if "age_months" in df.columns else df["timepoint"]


# ---------------------------------------------------------
# Validation
# ---------------------------------------------------------

print("Longitudinal metadata prepared.")
print(f"Samples: {len(df)}")
print(f"Subjects: {df['subject'].nunique()}")
print(
    f"Repeated subjects: "
    f"{df.loc[df['is_repeated_subject'], 'subject'].nunique()}"
)

print(
    f"Timepoints: "
    f"{df['timepoint'].nunique()}"
)


# ---------------------------------------------------------
# Write output
# ---------------------------------------------------------

df.to_csv(
    output_file,
    sep="\t",
    index=False
)