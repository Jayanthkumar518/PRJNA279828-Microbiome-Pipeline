process CREATE_MANIFEST {

    tag "Create QIIME2 manifest"

    publishDir "${params.outdir}/03_manifest",
        mode: 'copy'

    input:
    path read_files

    output:
    path "manifest.tsv", emit: manifest

    script:
    """
    python ${projectDir}/scripts/metadata/create_manifest.py \
        . \
        manifest.tsv
    """
}