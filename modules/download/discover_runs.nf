process DISCOVER_RUNS {

    tag "${project_id}"

    cpus 1

    publishDir "${params.outdir}/01_download",
        mode: 'copy'

    input:
    val project_id

    output:
    path "run_accessions.txt",
        emit: accessions

    script:

    """
    set -euo pipefail

    echo "========================================"
    echo "Discovering SRA runs"
    echo "Project: ${project_id}"
    echo "========================================"

    esearch -db sra -query "${project_id}" \
        | efetch -format runinfo \
        | awk -F',' 'NR > 1 && \$1 ~ /^(SRR|ERR|DRR)/ {print \$1}' \
        | sort -u \
        > run_accessions.txt

    if [ ! -s run_accessions.txt ]; then
        echo "ERROR: No SRA run accessions found."
        exit 1
    fi

    echo "Discovered runs:"
    cat run_accessions.txt

    echo ""
    echo "Total runs:"
    wc -l < run_accessions.txt
    """
}