process FIRST_DISTANCES {

    tag "longitudinal_first_distances"

    cpus params.threads

    conda "${projectDir}/envs/qiime2.yml"

    publishDir "${params.outdir}/09_longitudinal/beta",
        mode: 'copy'

    input:
    path beta_core_metrics
    path metadata

    output:
    path "unweighted_unifrac_first_distances.qza",
        emit: distances

    script:

    """
    qiime longitudinal first-distances \
        --i-distance-matrix ${beta_core_metrics}/unweighted_unifrac_distance_matrix.qza \
        --m-metadata-file ${metadata} \
        --p-state-column timepoint \
        --p-individual-id-column subject \
        --p-replicate-handling random \
        --o-first-distances unweighted_unifrac_first_distances.qza
    """
}