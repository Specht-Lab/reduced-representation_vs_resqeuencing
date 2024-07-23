##################################################
########last modified by jacob b landis###########
##################################################


#combine individual gVCFs into one file and call SNPs on combined gVCF file
/local/workdir/jmf425/Installed_programs/gatk-4.2.3.0/gatk GenomicsDBImport -R /local/workdir/jbl256/PLSCI6940_class_project/Liriodendron_chinense_jbl/reference_genome/Liriodendron_chinense_A353_gene_reference.fasta -V samples.list -L interval.list --genomicsdb-workspace-path Liriodendron_chinense_353_database --batch-size 15
/local/workdir/jmf425/Installed_programs/gatk-4.2.3.0/gatk GenotypeGVCFs -R /local/workdir/jbl256/PLSCI6940_class_project/Liriodendron_chinense_jbl/reference_genome/Liriodendron_chinense_A353_gene_reference.fasta -V gendb://Liriodendron_chinense_353_database --output Liriodendron_chinense_353_gene_combined_SNP_calls.vcf.gz

