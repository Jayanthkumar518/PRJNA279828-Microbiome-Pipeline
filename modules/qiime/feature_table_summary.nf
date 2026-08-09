process FEATURE_TABLE_SUMMARY {

    publishDir "${params.outdir}/10_feature_table", mode: 'copy'

    input:
    path table

    output:
    path "feature-table.qzv", emit: summary

    script:
    """
    qiime feature-table summarize \
        --i-table ${table} \
        --o-visualization feature-table.qzv
    """
}