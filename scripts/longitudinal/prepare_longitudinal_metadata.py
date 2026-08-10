import sys
import pandas as pd


input_file = sys.argv[1]
output_file = sys.argv[2]


# ---------------------------------------------------------
# Read metadata
# ---------------------------------------------------------

df = pd.read_csv(input_file, sep="\t")


# ---------------------------------------------------------
# Validate required columns
# ---------------------------------------------------------

required_columns = [
    "sample-id",
    "subject",
    "collection_date",
    "timepoint",
]

missing_columns = [
    col for col in required_columns
    if col not in df.columns
]

if missing_columns:
    raise ValueError(
        f"Missing required longitudinal columns: {missing_columns}"
    )


# ---------------------------------------------------------
# Convert numeric columns
# ---------------------------------------------------------

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

df["timepoint"] = pd.to_numeric(
    df["timepoint"],
    errors="coerce"
)


# ---------------------------------------------------------
# Convert collection date
# ---------------------------------------------------------

df["collection_date"] = pd.to_datetime(
    df["collection_date"],
    errors="coerce"
)


# ---------------------------------------------------------
# Validate critical values
# ---------------------------------------------------------

if df["subject"].isna().any():
    raise ValueError("Missing subject IDs detected.")

if df["timepoint"].isna().any():
    raise ValueError(
        "Missing or invalid timepoint values detected."
    )

if df["collection_date"].isna().any():
    raise ValueError(
        "Missing or invalid collection dates detected."
    )


# ---------------------------------------------------------
# Identify repeated subjects
# ---------------------------------------------------------

df["is_repeated_subject"] = (
    df["subject"].duplicated(keep=False)
)


# ---------------------------------------------------------
# Number of observations per subject
# ---------------------------------------------------------

df["n_timepoints"] = (
    df.groupby("subject")["sample-id"]
      .transform("count")
)


# ---------------------------------------------------------
# Identify longitudinal subjects
# ---------------------------------------------------------

df["is_longitudinal"] = (
    df["n_timepoints"] > 1
)


# ---------------------------------------------------------
# Sort observations
# ---------------------------------------------------------

df = df.sort_values(
    ["subject", "timepoint", "collection_date"]
)


# ---------------------------------------------------------
# Calculate days since baseline
# ---------------------------------------------------------

first_date = (
    df.groupby("subject")["collection_date"]
      .transform("min")
)

df["days_since_baseline"] = (
    df["collection_date"] - first_date
).dt.days


# ---------------------------------------------------------
# Save prepared metadata
# ---------------------------------------------------------

df.to_csv(
    output_file,
    sep="\t",
    index=False
)


# ---------------------------------------------------------
# Summary
# ---------------------------------------------------------

print("Longitudinal metadata prepared successfully.")
print(f"Samples: {len(df)}")
print(f"Subjects: {df['subject'].nunique()}")

print(
    f"Longitudinal subjects: "
    f"{df.loc[df['is_longitudinal'], 'subject'].nunique()}"
)