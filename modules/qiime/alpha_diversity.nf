process ALPHA_DIVERSITY {

    publishDir "${params.outdir}/11_alpha_diversity", mode: 'copy'

    cpus 4

    input:
    path table
    path rooted_tree

    output:
    path "observed-features.qza", emit: observed
    path "shannon.qza", emit: shannon
    path "faith-pd.qza", emit: faith_pd

    path "observed-features.qzv", emit: observed_viz
    path "shannon.qzv", emit: shannon_viz
    path "faith-pd.qzv", emit: faith_pd_viz

    script:
    """
    qiime diversity alpha \
        --i-table ${table} \
        --p-metric observed_features \
        --o-alpha-diversity observed-features.qza

    qiime diversity alpha \
        --i-table ${table} \
        --p-metric shannon \
        --o-alpha-diversity shannon.qza

    qiime diversity alpha-phylogenetic \
        --i-table ${table} \
        --i-phylogeny ${rooted_tree} \
        --p-metric faith_pd \
        --o-alpha-diversity faith-pd.qza

    qiime metadata tabulate \
        --m-input-file observed-features.qza \
        --o-visualization observed-features.qzv

    qiime metadata tabulate \
        --m-input-file shannon.qza \
        --o-visualization shannon.qzv

    qiime metadata tabulate \
        --m-input-file faith-pd.qza \
        --o-visualization faith-pd.qzv
    """
}