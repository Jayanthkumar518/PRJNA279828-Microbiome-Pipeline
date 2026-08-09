process DADA2 {

    publishDir "${params.outdir}/05_dada2", mode: 'copy'

    cpus params.threads

    input:
    path demux

    output:
    path "table.qza", emit: table
    path "rep-seqs.qza", emit: repseqs
    path "stats.qza", emit: stats
    path "base-transition-stats.qza", emit: basestats

    script:
    """
    qiime dada2 denoise-paired \
    --i-demultiplexed-seqs ${demux} \
    --p-trunc-len-f ${params.trunc_len_f} \
    --p-trunc-len-r ${params.trunc_len_r} \
    --p-max-ee-f ${params.max_ee_f} \
    --p-max-ee-r ${params.max_ee_r} \
    --p-n-threads 2 \
    --o-table table.qza \
    --o-representative-sequences rep-seqs.qza \
    --o-denoising-stats stats.qza \
    --o-base-transition-stats base-transition-stats.qza
    """
}