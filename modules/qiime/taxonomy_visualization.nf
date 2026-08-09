process TAXONOMY_VISUALIZATION {

    publishDir "${params.outdir}/07_taxonomy", mode: 'copy'

    input:
    path taxonomy

    output:
    path "taxonomy.qzv", emit: visualization

    script:
    """
    qiime metadata tabulate \
        --m-input-file ${taxonomy} \
        --o-visualization taxonomy.qzv
    """
}