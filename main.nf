Channel
    .fromPath("${params.pon_db_path}")
    .set {  pon_db_for_create_somatic_PoN }

Channel
    .fromPath(params.ref)
    .set { ref_create_somatic_PoN }

Channel
    .fromPath(params.ref_index)
    .set { ref_index_create_somatic_PoN }

Channel
    .fromPath(params.ref_dict)
    .set { ref_dict_create_somatic_PoN }

Channel
    .fromPath(params.af_only_gnomad_vcf)
    .set { af_only_gnomad_vcf_channel }

Channel
    .fromPath(params.af_only_gnomad_vcf_idx)
    .set { af_only_gnomad_vcf_idx_channel }

process create_somatic_PoN {
    
    tag "$af_only_gnomad_vcf"
    publishDir "create_somatic_PoN_Results", mode: 'copy'
    container "broadinstitute/gatk:latest"

    input:
    file(pon_db_path) from pon_db_for_create_somatic_PoN
    file(ref) from ref_create_somatic_PoN
    file(ref_index) from ref_index_create_somatic_PoN
    file(ref_dict) from ref_dict_create_somatic_PoN
    file(af_only_gnomad_vcf) from af_only_gnomad_vcf_channel
    file(af_only_gnomad_vcf_idx) from af_only_gnomad_vcf_idx_channel

    output:
    file("pon.vcf.gz") into create_somatic_PoN_results_channel
    
    script:
    """
    gatk CreateSomaticPanelOfNormals \
    -R $ref \
    --germline-resource $af_only_gnomad_vcf \
    -V gendb://$pon_db_path \
    -O pon.vcf.gz  
    """
}