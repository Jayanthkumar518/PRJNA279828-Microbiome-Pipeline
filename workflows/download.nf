include { DISCOVER_RUNS } from '../modules/download/discover_runs'
include { DOWNLOAD_FASTQ } from '../modules/download/download_fastq'

workflow DOWNLOAD {

    take:

    project_id


    main:

    /*
     * ---------------------------------------------------------
     * 1. Discover all SRA runs belonging to the project
     * ---------------------------------------------------------
     */

    discovered = DISCOVER_RUNS(project_id)


    /*
     * ---------------------------------------------------------
     * 2. Convert run list into individual accessions
     * ---------------------------------------------------------
     */

    runs = discovered.accessions
        .splitText()
        .map { it.trim() }
        .filter { it }


    /*
     * ---------------------------------------------------------
     * 3. Download each accession
     * ---------------------------------------------------------
     */

    downloaded = DOWNLOAD_FASTQ(runs)


    /*
     * ---------------------------------------------------------
     * OUTPUT
     * ---------------------------------------------------------
     */

    emit:

    reads = downloaded.reads
}