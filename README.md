# PRJNA279828 Microbiome Analysis Pipeline

## Overview

This repository contains a reproducible Nextflow DSL2 workflow for analysing
the gut microbiome dataset PRJNA279828.

The workflow reproduces and extends the analyses presented in the publication:

Longitudinal analysis of the gut microbiome in persistently stunted children.

## Workflow

Raw FASTQ
    ↓
FastQC
    ↓
QIIME2 Import
    ↓
DADA2
    ↓
Phylogenetic Tree
    ↓
Taxonomic Classification
    ↓
Alpha Diversity
    ↓
Beta Diversity
    ↓
PERMANOVA
    ↓
Longitudinal Analysis
    ↓
Differential Abundance (ANCOM-BC2)
    ↓
R Statistical Analysis
    ↓
Publication-ready Figures

## Software

- Nextflow
- Docker
- QIIME2
- R
- Python

## Author

Jayanth Kumar
