process IMPORT_READS {

    tag "QIIME2 paired-end import"

    publishDir "${params.outdir}/04_import", mode: 'copy'

    input:
    path manifest

    output:
    path "paired-end-demux.qza", emit: demux

    script:
    """
    qiime tools import \
        --type 'SampleData[PairedEndSequencesWithQuality]' \
        --input-path manifest.tsv \
        --output-path paired-end-demux.qza \
        --input-format PairedEndFastqManifestPhred33V2
    """
}