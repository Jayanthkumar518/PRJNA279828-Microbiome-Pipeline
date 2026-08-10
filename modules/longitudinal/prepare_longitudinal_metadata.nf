process PREPARE_LONGITUDINAL_METADATA {

    tag "longitudinal_metadata"

    /*
     * -----------------------------------------------------
     * Container
     * -----------------------------------------------------
     *
     * Custom image contains:
     * - Python 3.11
     * - pandas
     * - procps / ps
     */
    container 'microbiome-longitudinal:1.0'

    /*
     * -----------------------------------------------------
     * Resources
     * -----------------------------------------------------
     */

    cpus 1

    /*
     * -----------------------------------------------------
     * Output directory
     * -----------------------------------------------------
     */

    publishDir "${params.outdir}/08_longitudinal",
        mode: 'copy'

    /*
     * -----------------------------------------------------
     * Input
     * -----------------------------------------------------
     */

    input:

    path metadata

    /*
     * -----------------------------------------------------
     * Output
     * -----------------------------------------------------
     */

    output:

    path "longitudinal_metadata.tsv",
        emit: metadata

    /*
     * -----------------------------------------------------
     * Script
     * -----------------------------------------------------
     */

    script:

    """
    python ${projectDir}/scripts/longitudinal/prepare_longitudinal_metadata.py \
        ${metadata} \
        longitudinal_metadata.tsv
    """
}

