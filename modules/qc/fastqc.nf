process FASTQC {

    tag "${sample_id}"

    publishDir "${params.outdir}/02_fastqc",
        mode: 'copy'

    cpus 4

    input:
    tuple val(sample_id), path(read1), path(read2)

    output:
    path("*_fastqc.html"), emit: html
    path("*_fastqc.zip"), emit: zip

    script:
    """
    fastqc \
        --threads ${task.cpus} \
        ${read1} \
        ${read2}
    """
}