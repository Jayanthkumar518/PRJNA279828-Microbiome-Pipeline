include { CREATE_MANIFEST } from '../modules/qiime/create_manifest'
include { IMPORT_READS } from '../modules/qiime/import_reads'
include { DEMUX_SUMMARY } from '../modules/qiime/demux_summary'
include { DADA2 } from '../modules/qiime/dada2'
include { PHYLOGENY } from '../modules/qiime/phylogeny'
include { CLASSIFY_TAXONOMY } from '../modules/qiime/classify_taxonomy'
include { TAXA_BARPLOT } from '../modules/qiime/taxa_barplot'
include { FEATURE_TABLE_SUMMARY } from '../modules/qiime/feature_table_summary'
include { ALPHA_DIVERSITY } from '../modules/qiime/alpha_diversity'
include { BETA_DIVERSITY } from '../modules/qiime/beta_diversity'


workflow QIIME {

    take:
    reads


    main:

    /*
     * ---------------------------------------------------------
     * 1. COLLECT DOWNLOADED READS
     * ---------------------------------------------------------
     */

    read_files = reads
        .map { run, r1, r2 -> [r1, r2] }
        .flatten()
        .collect()


    /*
     * ---------------------------------------------------------
     * 2. CREATE QIIME2 MANIFEST
     * ---------------------------------------------------------
     */

    manifest = CREATE_MANIFEST(read_files)


    /*
     * ---------------------------------------------------------
     * 3. IMPORT PAIRED-END READS
     * ---------------------------------------------------------
     */

    imported = IMPORT_READS(manifest.manifest)


    /*
     * ---------------------------------------------------------
     * 4. DEMUX SUMMARY
     * ---------------------------------------------------------
     */

    DEMUX_SUMMARY(imported.demux)


    /*
     * ---------------------------------------------------------
     * 5. DADA2 DENOISING
     * ---------------------------------------------------------
     */

    dada = DADA2(imported.demux)

    dada_table   = dada.table
    dada_repseqs = dada.repseqs
    dada_stats   = dada.stats


    /*
     * ---------------------------------------------------------
     * 6. PHYLOGENY
     * ---------------------------------------------------------
     */

    tree = PHYLOGENY(dada_repseqs)

    rooted_tree = tree.rooted


    /*
     * ---------------------------------------------------------
     * 7. TAXONOMIC CLASSIFICATION
     * ---------------------------------------------------------
     */

    taxonomy = CLASSIFY_TAXONOMY(dada_repseqs)

    taxonomy_result = taxonomy.taxonomy


    /*
     * ---------------------------------------------------------
     * 8. FEATURE TABLE SUMMARY
     * ---------------------------------------------------------
     */

    feature_summary = FEATURE_TABLE_SUMMARY(dada_table)


    /*
     * ---------------------------------------------------------
     * 9. SAMPLE METADATA
     * ---------------------------------------------------------
     */

    metadata = Channel
        .fromPath(
            "${projectDir}/data/metadata/sample-metadata.tsv",
            checkIfExists: true
        )


    /*
     * ---------------------------------------------------------
     * 10. TAXONOMIC BARPLOT
     * ---------------------------------------------------------
     */

    barplot = TAXA_BARPLOT(
        dada_table,
        taxonomy_result,
        metadata
    )


    /*
     * ---------------------------------------------------------
     * 11. ALPHA DIVERSITY
     * ---------------------------------------------------------
     */

    alpha = ALPHA_DIVERSITY(
        dada_table,
        rooted_tree
    )


    /*
     * ---------------------------------------------------------
     * 12. BETA DIVERSITY
     * ---------------------------------------------------------
     */

    beta = BETA_DIVERSITY(
        dada_table,
        rooted_tree,
        metadata
    )


    /*
     * ---------------------------------------------------------
     * OUTPUTS
     * ---------------------------------------------------------
     */

    emit:

    table = dada_table

    repseq = dada_repseqs

    stats = dada_stats

    rooted_tree = rooted_tree

    taxonomy = taxonomy_result

    feature_table_summary = feature_summary.summary

    barplot = barplot.barplot

    alpha_observed = alpha.observed

    alpha_shannon = alpha.shannon

    alpha_faith_pd = alpha.faith_pd

    beta_core_metrics = beta.core_metrics
}