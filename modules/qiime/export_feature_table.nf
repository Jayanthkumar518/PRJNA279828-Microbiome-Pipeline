process EXPORT_FEATURE_TABLE {

    publishDir "${params.outdir}/14_exports", mode: 'copy'

    input:
    path table

    output:
    path "feature-table-export", emit: exported

    script:
    """
    mkdir -p feature-table-export

    qiime tools export \
        --input-path ${table} \
        --output-path feature-table-export
    """
}