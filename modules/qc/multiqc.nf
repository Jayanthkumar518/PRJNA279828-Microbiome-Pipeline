process MULTIQC {

    publishDir "${params.outdir}/03_multiqc",
        mode: 'copy'

    cpus 2

    input:
    path fastqc_zip

    output:
    path "multiqc_report.html"

    script:
    """
    multiqc . \
        --force \
        --filename multiqc_report.html
    """
}