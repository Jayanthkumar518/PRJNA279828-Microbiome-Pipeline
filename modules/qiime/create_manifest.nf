process CREATE_MANIFEST {

    publishDir "${params.outdir}/04_import", mode: 'copy'

    output:
    path "manifest.tsv", emit: manifest

    script:
    """
    python ${projectDir}/scripts/metadata/create_manifest.py \
        ${projectDir}/${params.raw_dir} \
        manifest.tsv
    """
}