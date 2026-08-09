/*
 * =========================================================
 * LONGITUDINAL MICROBIOME WORKFLOW
 * =========================================================
 *
 * Purpose:
 *   Prepare metadata for repeated-measures / longitudinal
 *   microbiome analysis.
 *
 * Current longitudinal metadata:
 *
 *   sample-id
 *   subject
 *   age_days
 *   birth_weight
 *   sex
 *   weight
 *   height_cm
 *   country
 *   collection_date
 *   group
 *   age_months
 *   timepoint
 *
 * =========================================================
 */


/*
 * =========================================================
 * PROCESS
 * =========================================================
 */

process PREPARE_LONGITUDINAL_METADATA {

    tag "longitudinal_metadata"


    /*
     * -----------------------------------------------------
     * Conda environment
     * -----------------------------------------------------
     */

    conda "${projectDir}/envs/longitudinal.yml"


    /*
     * -----------------------------------------------------
     * Publish result
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


/*
 * =========================================================
 * LONGITUDINAL WORKFLOW
 * =========================================================
 */

workflow LONGITUDINAL {


    /*
     * -----------------------------------------------------
     * INPUT
     * -----------------------------------------------------
     */

    take:

    metadata


    /*
     * -----------------------------------------------------
     * MAIN
     * -----------------------------------------------------
     */

    main:

    prepared_metadata = PREPARE_LONGITUDINAL_METADATA(metadata)


    /*
     * -----------------------------------------------------
     * OUTPUT
     * -----------------------------------------------------
     */

    emit:

    prepared = prepared_metadata.metadata
}