process ALPHA_GROUP_SIGNIFICANCE {

    publishDir "${params.outdir}/10_alpha_diversity", mode: 'copy'

    input:
    path alpha_diversity
    path metadata

    output:
    path "alpha-group-significance.qzv", emit: significance

    script:
    """
    qiime diversity alpha-group-significance \
        --i-alpha-diversity ${alpha_diversity} \
        --m-metadata-file ${metadata} \
        --o-visualization alpha-group-significance.qzv
    """
}