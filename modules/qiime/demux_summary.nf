process DEMUX_SUMMARY {

    publishDir "${params.outdir}/04_import", mode: 'copy'

    input:
    path demux

    output:
    path "paired-end-demux.qzv", emit: summary

    script:
    """
    qiime demux summarize \
        --i-data ${demux} \
        --o-visualization paired-end-demux.qzv
    """
}