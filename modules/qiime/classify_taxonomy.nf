process CLASSIFY_TAXONOMY {

    publishDir "${params.outdir}/07_taxonomy", mode: 'copy'

    cpus 8

    input:
    path repseqs

    output:
    path "taxonomy.qza", emit: taxonomy

    script:
    """
    qiime feature-classifier classify-sklearn \
        --i-classifier ${params.classifier} \
        --i-reads ${repseqs} \
        --o-classification taxonomy.qza
    """
}