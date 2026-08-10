nextflow.enable.dsl=2

include { DOWNLOAD } from './workflows/download'
include { QC } from './workflows/qc'
include { QIIME } from './workflows/qiime'
include { LONGITUDINAL } from './workflows/longitudinal'

workflow {

    /*
     * ---------------------------------------------------------
     * 1. DOWNLOAD PROJECT DATA
     * ---------------------------------------------------------
     */

    download_results = DOWNLOAD(
        params.project_id
    )


    /*
     * ---------------------------------------------------------
     * 2. PREPARE READ PAIRS
     * ---------------------------------------------------------
     */

    read_pairs = download_results.reads
        .map { run, r1, r2 ->
            tuple(run, r1, r2)
        }


    /*
     * ---------------------------------------------------------
     * 3. QUALITY CONTROL
     * ---------------------------------------------------------
     */

    QC(read_pairs)


    /*
     * ---------------------------------------------------------
     * 4. QIIME2 MICROBIOME ANALYSIS
     * ---------------------------------------------------------
     */

    qiime_results = QIIME(read_pairs)


    /*
     * ---------------------------------------------------------
     * 5. LONGITUDINAL METADATA
     * ---------------------------------------------------------
     */

    metadata = Channel
        .fromPath(
            params.metadata,
            checkIfExists: true
        )


    /*
     * ---------------------------------------------------------
     * 6. LONGITUDINAL MICROBIOME ANALYSIS
     * ---------------------------------------------------------
     */

    LONGITUDINAL(
        metadata,
        qiime_results.alpha_shannon,
        qiime_results.beta_core_metrics
    )
}