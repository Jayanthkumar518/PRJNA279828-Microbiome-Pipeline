#!/usr/bin/env bash

set -euo pipefail

RUN=$1
THREADS=8

echo "========================================"
echo "Downloading ${RUN}"
echo "========================================"

# Create local SRA directory inside the process work directory
mkdir -p sra

# Download SRA
prefetch \
    "${RUN}" \
    --output-directory sra

# Convert to FASTQ in the CURRENT WORK DIRECTORY
fasterq-dump \
    "sra/${RUN}/${RUN}.sra" \
    --split-files \
    --threads ${THREADS} \
    --outdir .

# Compress FASTQ files
pigz -p ${THREADS} "${RUN}_1.fastq"
pigz -p ${THREADS} "${RUN}_2.fastq"

echo "[SUCCESS] ${RUN} downloaded successfully."