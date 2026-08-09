process IMPORT_READS {

    publishDir "${params.outdir}/04_import", mode: 'copy'

    cpus 4

    input:
    path manifest

    output:
    path "paired-end-demux.qza", emit: demux

    script:
    """
    qiime tools import \
        --type 'SampleData[PairedEndSequencesWithQuality]' \
        --input-path ${manifest} \
        --output-path paired-end-demux.qza \
        --input-format PairedEndFastqManifestPhred33V2
    """
}