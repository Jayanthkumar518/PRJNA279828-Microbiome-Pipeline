process EXPORT_FIRST_DISTANCES {

```
tag "export_longitudinal_first_distances"

cpus 1

conda "${projectDir}/envs/qiime2.yml"

publishDir "${params.outdir}/09_longitudinal/beta",
    mode: 'copy'

input:

path distances

output:

path "first_distances_metadata.tsv",
    emit: metadata

script:

"""
qiime tools export \
    --input-path ${distances} \
    --output-path exported_first_distances

cp exported_first_distances/*.tsv first_distances_metadata.tsv
"""
```

}
