process TAXA_BARPLOT {

    publishDir "${params.outdir}/09_taxa_barplot", mode: 'copy'

    input:
    path table
    path taxonomy
    path metadata

    output:
    path "taxa-barplot.qzv", emit: barplot

    script:
    """
    qiime taxa barplot \
        --i-table ${table} \
        --i-taxonomy ${taxonomy} \
        --m-metadata-file ${metadata} \
        --o-visualization taxa-barplot.qzv
    """
}