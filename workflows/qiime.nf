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

    /*
     * ---------------------------------------------------------
     * INPUT
     * ---------------------------------------------------------
     */

    take:
    reads


    main:

    /*
     * ---------------------------------------------------------
     * 1. CREATE QIIME2 MANIFEST
     * ---------------------------------------------------------
     */

    manifest = CREATE_MANIFEST()


    /*
     * ---------------------------------------------------------
     * 2. IMPORT PAIRED-END READS
     * ---------------------------------------------------------
     */

    imported = IMPORT_READS(manifest.manifest)


    /*
     * ---------------------------------------------------------
     * 3. DEMULTIPLEXING SUMMARY
     * ---------------------------------------------------------
     */

    DEMUX_SUMMARY(imported.demux)


    /*
     * ---------------------------------------------------------
     * 4. DADA2 DENOISING
     *
     * Outputs:
     *   - Feature table
     *   - Representative sequences
     *   - Denoising statistics
     * ---------------------------------------------------------
     */

    dada = DADA2(imported.demux)

    dada_table   = dada.table
    dada_repseqs = dada.repseqs
    dada_stats   = dada.stats


    /*
     * ---------------------------------------------------------
     * 5. PHYLOGENY
     *
     * Uses representative ASV sequences.
     * ---------------------------------------------------------
     */

    tree = PHYLOGENY(dada_repseqs)

    rooted_tree = tree.rooted


    /*
     * ---------------------------------------------------------
     * 6. TAXONOMIC CLASSIFICATION
     *
     * Uses the SILVA classifier.
     * ---------------------------------------------------------
     */

    taxonomy = CLASSIFY_TAXONOMY(dada_repseqs)

    taxonomy_result = taxonomy.taxonomy


    /*
     * ---------------------------------------------------------
     * 7. FEATURE TABLE SUMMARY
     * ---------------------------------------------------------
     */

    feature_summary = FEATURE_TABLE_SUMMARY(dada_table)


    /*
     * ---------------------------------------------------------
     * 8. TAXONOMIC BARPLOT
     *
     * Inputs:
     *   - Feature table
     *   - Taxonomy
     *   - Sample metadata
     * ---------------------------------------------------------
     */

    metadata = Channel
        .fromPath(
            "${projectDir}/data/metadata/sample-metadata.tsv",
            checkIfExists: true
        )


    barplot = TAXA_BARPLOT(
        dada_table,
        taxonomy_result,
        metadata
    )


    /*
     * ---------------------------------------------------------
     * 9. ALPHA DIVERSITY
     *
     * Outputs:
     *   - Observed features
     *   - Shannon diversity
     *   - Faith's phylogenetic diversity
     * ---------------------------------------------------------
     */

    alpha = ALPHA_DIVERSITY(
        dada_table,
        rooted_tree
    )


    /*
     * ---------------------------------------------------------
     * 10. BETA DIVERSITY
     *
     * Produces:
     *
     *   core-metrics-results/
     *
     * containing QIIME2 beta-diversity distance matrices,
     * PCoA results and related outputs.
     *
     * IMPORTANT:
     * Requires at least two samples in the feature table.
     * ---------------------------------------------------------
     */

    beta = BETA_DIVERSITY(
        dada_table,
        rooted_tree,
        metadata
    )


    /*
     * ---------------------------------------------------------
     * WORKFLOW OUTPUTS
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