/*
------------------------------------------------------------
Download FASTQ files from NCBI SRA
------------------------------------------------------------
Input:
    SRR accession (e.g. SRR2914118)

Output:
    Paired-end FASTQ files (*.fastq.gz)
------------------------------------------------------------
*/

process DOWNLOAD_FASTQ {

    tag "${run}"

    publishDir "${params.outdir}/01_download",
        mode: 'copy'

    cpus 8

    input:
    val run

    output:
    path("*.fastq.gz"), emit: reads

    script:
    """
    bash ${projectDir}/scripts/download/download_fastq.sh \
        ${run} \
        .
    """
}