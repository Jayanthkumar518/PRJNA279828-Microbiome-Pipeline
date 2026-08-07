nextflow.enable.dsl = 2

include { QC } from './workflows/qc'

workflow {

    Channel
        .fromFilePairs(
            params.reads,
            checkIfExists: true
        )
        .set { read_pairs }

    QC(read_pairs)

}