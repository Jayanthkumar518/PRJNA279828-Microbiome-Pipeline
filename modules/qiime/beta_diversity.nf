process BETA_DIVERSITY {

    publishDir "${params.outdir}/12_beta_diversity", mode: 'copy'

    cpus params.threads

    input:
    path table
    path rooted_tree
    path metadata

    output:
    path "core-metrics-results", emit: core_metrics

    script:
    """
    qiime diversity core-metrics-phylogenetic \
        --i-table ${table} \
        --i-phylogeny ${rooted_tree} \
        --p-sampling-depth ${params.sampling_depth} \
        --m-metadata-file ${metadata} \
        --output-dir core-metrics-results
    """
}