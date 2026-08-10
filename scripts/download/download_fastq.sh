#!/usr/bin/env bash

set -euo pipefail

RUN="$1"
THREADS="${2:-4}"
OUTPUT_DIR="${3:-.}"

echo "========================================"
echo "Downloading ${RUN}"
echo "Threads: ${THREADS}"
echo "Output: ${OUTPUT_DIR}"
echo "========================================"

mkdir -p "${OUTPUT_DIR}"
mkdir -p sra

# ---------------------------------------------------------
# 1. Download SRA accession
# ---------------------------------------------------------

echo "[1/5] Prefetching ${RUN}..."

prefetch \
    "${RUN}" \
    --output-directory sra \
    --max-size u

# ---------------------------------------------------------
# 2. Locate SRA object
# ---------------------------------------------------------

SRA_FILE="sra/${RUN}/${RUN}.sra"

if [[ ! -f "${SRA_FILE}" ]]; then
    echo "ERROR: SRA file not found:"
    echo "${SRA_FILE}"
    exit 1
fi

echo "[2/5] Locating SRA object..."
echo "SRA input: ${SRA_FILE}"

# ---------------------------------------------------------
# 3. Validate SRA object
# ---------------------------------------------------------

echo "[3/5] Validating ${RUN}..."

vdb-validate "${SRA_FILE}"

# ---------------------------------------------------------
# 4. Convert SRA to paired FASTQ
# ---------------------------------------------------------

echo "[4/5] Converting ${RUN} to FASTQ..."

fasterq-dump \
    "${SRA_FILE}" \
    --split-files \
    --threads "${THREADS}" \
    --outdir .

# ---------------------------------------------------------
# Check that paired FASTQ files were created
# ---------------------------------------------------------

if [[ ! -f "${RUN}_1.fastq" || ! -f "${RUN}_2.fastq" ]]; then
    echo "ERROR: Paired FASTQ files were not created for ${RUN}."
    exit 1
fi

# ---------------------------------------------------------
# 5. Compress FASTQ
# ---------------------------------------------------------

echo "[5/5] Compressing FASTQ..."

pigz -p "${THREADS}" \
    "${RUN}_1.fastq" \
    "${RUN}_2.fastq"

# ---------------------------------------------------------
# Move files only when OUTPUT_DIR is different from "."
# ---------------------------------------------------------

if [[ "${OUTPUT_DIR}" != "." && "${OUTPUT_DIR}" != "./" ]]; then
    mv "${RUN}_1.fastq.gz" "${OUTPUT_DIR}/"
    mv "${RUN}_2.fastq.gz" "${OUTPUT_DIR}/"
fi

# ---------------------------------------------------------
# Final verification
# ---------------------------------------------------------

if [[ "${OUTPUT_DIR}" == "." || "${OUTPUT_DIR}" == "./" ]]; then

    [[ -s "${RUN}_1.fastq.gz" ]] || {
        echo "ERROR: ${RUN}_1.fastq.gz was not created."
        exit 1
    }

    [[ -s "${RUN}_2.fastq.gz" ]] || {
        echo "ERROR: ${RUN}_2.fastq.gz was not created."
        exit 1
    }

else

    [[ -s "${OUTPUT_DIR}/${RUN}_1.fastq.gz" ]] || {
        echo "ERROR: ${OUTPUT_DIR}/${RUN}_1.fastq.gz was not created."
        exit 1
    }

    [[ -s "${OUTPUT_DIR}/${RUN}_2.fastq.gz" ]] || {
        echo "ERROR: ${OUTPUT_DIR}/${RUN}_2.fastq.gz was not created."
        exit 1
    }

fi

echo "========================================"
echo "[SUCCESS] ${RUN} downloaded successfully."
echo "========================================"

