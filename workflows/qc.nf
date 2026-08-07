include { FASTQC } from '../modules/qc/fastqc'
include { MULTIQC } from '../modules/qc/multiqc'

workflow QC {

    take:
    reads

    main:

    FASTQC(reads)

    MULTIQC(
        FASTQC.out.zip.collect()
    )

}