process DOWNLOAD_FASTQ {

    tag "${run}"

    cpus params.download_threads

    publishDir "${projectDir}/data/raw_fastq",
        mode: 'copy',
        overwrite: false

    input:
    val run

    output:
    tuple val(run), path("${run}_1.fastq.gz"), path("${run}_2.fastq.gz"),
        emit: reads

    script:

    """
    bash ${projectDir}/scripts/download/download_fastq.sh \
        "${run}" \
        "${task.cpus}" \
        "."
    """
}