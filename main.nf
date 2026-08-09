nextflow.enable.dsl = 2

include { QC } from './workflows/qc'
include { QIIME } from './workflows/qiime'
include { LONGITUDINAL } from './workflows/longitudinal'


workflow {

    /*
     * -----------------------------------------------------
     * INPUT READS
     * -----------------------------------------------------
     */

    Channel
        .fromFilePairs(
            params.reads,
            checkIfExists: true
        )
        .set { read_pairs }


    /*
     * -----------------------------------------------------
     * QUALITY CONTROL
     * -----------------------------------------------------
     */

    QC(read_pairs)


    /*
     * -----------------------------------------------------
     * QIIME2 MICROBIOME ANALYSIS
     * -----------------------------------------------------
     */

    qiime_results = QIIME(read_pairs)


    /*
     * -----------------------------------------------------
     * LONGITUDINAL ANALYSIS
     * -----------------------------------------------------
     *
     * Metadata is currently supplied independently because
     * longitudinal analysis requires subject/time information.
     *
     * -----------------------------------------------------
     */

    metadata = Channel
        .fromPath(
            "${projectDir}/data/metadata/sample-metadata.tsv",
            checkIfExists: true
        )

    LONGITUDINAL(metadata)
}