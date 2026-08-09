process EXPORT_REPSEQS {

    publishDir "${params.outdir}/14_exports", mode: 'copy'

    input:
    path repseqs

    output:
    path "repseqs-export", emit: exported

    script:
    """
    mkdir -p repseqs-export

    qiime tools export \
        --input-path ${repseqs} \
        --output-path repseqs-export
    """
}