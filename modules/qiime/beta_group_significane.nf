process BETA_GROUP_SIGNIFICANCE {

    publishDir "${params.outdir}/12_beta_diversity", mode: 'copy'

    input:
    path distance_matrix
    path metadata

    output:
    path "beta-group-significance.qzv", emit: significance

    script:
    """
    qiime diversity beta-group-significance \
        --i-distance-matrix ${distance_matrix} \
        --m-metadata-file ${metadata} \
        --m-metadata-column group \
        --p-method permanova \
        --p-pairwise \
        --o-visualization beta-group-significance.qzv
    """
}