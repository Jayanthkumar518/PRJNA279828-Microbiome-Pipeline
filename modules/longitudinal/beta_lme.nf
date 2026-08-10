process BETA_LME {

    tag "longitudinal_beta_lme"

    cpus params.threads

    conda "${projectDir}/envs/qiime2.yml"

    publishDir "${params.outdir}/09_longitudinal/beta",
        mode: 'copy'

    input:
    path first_distances
    path metadata

    output:
    path "unweighted_unifrac_longitudinal_lme.qzv",
        emit: visualization

    script:

    """
    qiime longitudinal linear-mixed-effects \
        --m-metadata-file ${first_distances} \
        --m-metadata-file ${metadata} \
        --p-metric Distance \
        --p-state-column timepoint \
        --p-individual-id-column subject \
        --o-visualization unweighted_unifrac_longitudinal_lme.qzv
    """
}