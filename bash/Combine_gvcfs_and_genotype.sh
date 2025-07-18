
#create dictionary file for reference genome
/local/workdir/jmf425/Installed_programs/gatk-4.2.3.0/gatk CreateSequenceDictionary R=../genomes/GCF_012489685.1_LjGifu_v1.2_genomic.fna  O=../genomes/GCF_012489685.1_LjGifu_v1.2_genomic.dict

#create index file with faidx for reference genome
/local/workdir/jbl256/Installed_programs/samtools-1.19.2/samtools faidx ../genomes/GCF_012489685.1_LjGifu_v1.2_genomic.fna 

#combine individual gVCFs into one file and call SNPs on combined gVCF file
/local/workdir/jmf425/Installed_programs/gatk-4.2.3.0/gatk GenomicsDBImport -R ../genomes/GCF_012489685.1_LjGifu_v1.2_genomic.fna --java-options "-Djava.io.tmpdir=/SSD/jmf425/tmp" -V samples.list -L interval.list --genomicsdb-workspace-path Lotus_genome_database --batch-size 15
/local/workdir/jmf425/Installed_programs/gatk-4.2.3.0/gatk GenotypeGVCFs -R ../genomes/GCF_012489685.1_LjGifu_v1.2_genomic.fna --java-options "-Djava.io.tmpdir=/SSD/jmf425/tmp" -V gendb://Lotus_genome_database --output Lotus_genome_combined_SNP_calls.vcf.gz
