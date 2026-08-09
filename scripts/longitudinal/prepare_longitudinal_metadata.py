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
    "timepoint"
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
# Convert data types
# ---------------------------------------------------------

df["age_days"] = pd.to_numeric(
    df["age_days"],
    errors="coerce"
)

df["age_months"] = pd.to_numeric(
    df["age_months"],
    errors="coerce"
)

df["collection_date"] = pd.to_datetime(
    df["collection_date"],
    errors="coerce"
)

df["timepoint"] = pd.to_numeric(
    df["timepoint"],
    errors="coerce"
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

subject_counts = (
    df.groupby("subject")["sample-id"]
      .transform("count")
)

df["n_timepoints"] = subject_counts


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
# Calculate time since first observation
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

