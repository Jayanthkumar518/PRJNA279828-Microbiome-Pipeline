nextflow.enable.dsl = 2

include { DOWNLOAD_WORKFLOW } from './workflows/download'

workflow {

    DOWNLOAD_WORKFLOW()

}