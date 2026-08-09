process BETA_OUTPUTS {

    publishDir "${params.outdir}/12_beta_diversity", mode: 'copy'

    input:
    path core_metrics

    output:
    path "unweighted-unifrac.qza", emit: unweighted_unifrac
    path "weighted-unifrac.qza", emit: weighted_unifrac
    path "bray-curtis.qza", emit: bray_curtis
    path "jaccard.qza", emit: jaccard
    path "unweighted-unifrac-pcoa.qza", emit: unweighted_pcoa
    path "weighted-unifrac-pcoa.qza", emit: weighted_pcoa
    path "bray-curtis-pcoa.qza", emit: bray_curtis_pcoa
    path "jaccard-pcoa.qza", emit: jaccard_pcoa

    script:
    """
    cp core-metrics-results/unweighted_unifrac_distance_matrix.qza \
       unweighted-unifrac.qza

    cp core-metrics-results/weighted_unifrac_distance_matrix.qza \
       weighted-unifrac.qza

    cp core-metrics-results/bray_curtis_distance_matrix.qza \
       bray-curtis.qza

    cp core-metrics-results/jaccard_distance_matrix.qza \
       jaccard.qza

    cp core-metrics-results/unweighted_unifrac_pcoa_results.qza \
       unweighted-unifrac-pcoa.qza

    cp core-metrics-results/weighted_unifrac_pcoa_results.qza \
       weighted-unifrac-pcoa.qza

    cp core-metrics-results/bray_curtis_pcoa_results.qza \
       bray-curtis-pcoa.qza

    cp core-metrics-results/jaccard_pcoa_results.qza \
       jaccard-pcoa.qza
    """
}