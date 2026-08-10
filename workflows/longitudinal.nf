include { PREPARE_LONGITUDINAL_METADATA } from '../modules/longitudinal/prepare_longitudinal_metadata'
include { ALPHA_LME } from '../modules/longitudinal/alpha_lme'
include { FIRST_DISTANCES } from '../modules/longitudinal/first_distances'
include { BETA_LME } from '../modules/longitudinal/beta_lme'


workflow LONGITUDINAL {

    take:

    metadata
    shannon
    beta_core_metrics


    main:

    /*
     * -----------------------------------------------------
     * 1. PREPARE LONGITUDINAL METADATA
     * -----------------------------------------------------
     */

    prepared_metadata = PREPARE_LONGITUDINAL_METADATA(metadata)


    /*
     * -----------------------------------------------------
     * 2. ALPHA DIVERSITY LME
     * -----------------------------------------------------
     */

    alpha_lme = ALPHA_LME(
        shannon,
        prepared_metadata.metadata
    )


    /*
     * -----------------------------------------------------
     * 3. FIRST DISTANCES
     * -----------------------------------------------------
     */

    first_distances = FIRST_DISTANCES(
        beta_core_metrics,
        prepared_metadata.metadata
    )


    /*
     * -----------------------------------------------------
     * 4. BETA DIVERSITY LME
     * -----------------------------------------------------
     */

    beta_lme = BETA_LME(
        first_distances.distances,
        prepared_metadata.metadata
    )


    emit:

    prepared = prepared_metadata.metadata

    alpha_lme = alpha_lme.visualization

    first_distances = first_distances.distances

    beta_lme = beta_lme.visualization
}