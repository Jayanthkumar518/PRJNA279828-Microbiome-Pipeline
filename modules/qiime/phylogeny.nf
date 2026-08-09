process PHYLOGENY {

    publishDir "${params.outdir}/06_phylogeny", mode: 'copy'

    cpus 8

    input:
    path repseqs

    output:
    path "aligned-rep-seqs.qza",        emit: aligned
    path "masked-aligned-rep-seqs.qza", emit: masked
    path "unrooted-tree.qza",           emit: unrooted
    path "rooted-tree.qza",             emit: rooted

    script:
    """
    qiime phylogeny align-to-tree-mafft-fasttree \
        --i-sequences ${repseqs} \
        --o-alignment aligned-rep-seqs.qza \
        --o-masked-alignment masked-aligned-rep-seqs.qza \
        --o-tree unrooted-tree.qza \
        --o-rooted-tree rooted-tree.qza
    """
}