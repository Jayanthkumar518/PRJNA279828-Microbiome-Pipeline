process EXPORT_TAXONOMY {

    publishDir "${params.outdir}/14_exports", mode: 'copy'

    input:
    path taxonomy

    output:
    path "taxonomy-export", emit: exported

    script:
    """
    mkdir -p taxonomy-export

    qiime tools export \
        --input-path ${taxonomy} \
        --output-path taxonomy-export
    """
}