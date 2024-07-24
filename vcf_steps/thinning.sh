#############################################################
###modifed from VCF_filtering.sh written by jacob b. landis##
########first three lines written by joshua m felton#########
#############################################################


# Convert the pruned VCF back to PLINK format
/programs/plink-1.9-x86_64-beta7/plink --vcf Juglans_genome_LD_pruned_SNPs.recode.vcf --make-bed --allow-extra-chr --double-id --out Juglans_genomeLD_pruned_thin

/programs/plink-1.9-x86_64-beta7/plink --bfile Juglans_genomeLD_pruned_thin --thin-count 30000 --allow-extra-chr --double-id --recode --out Juglans_genomeLD_pruned_thin_plink

/programs/plink-1.9-x86_64-beta7/plink --file Juglans_genomeLD_pruned_thin_plink --allow-extra-chr --recode vcf --out Juglans_genomeLD_pruned_thin_thinned


#gives missing proportion of loci for each individual
/local/workdir/jbl256/Installed_programs/vcftools-0.1.16/bin/vcftools --vcf Juglans_genomeLD_pruned_thin_thinned.vcf --missing-indv

#average depth for each individual
/local/workdir/jbl256/Installed_programs/vcftools-0.1.16/bin/vcftools --vcf Juglans_genomeLD_pruned_thin_thinned.vcf --depth 

#observed and expected heterozygosity
/local/workdir/jbl256/Installed_programs/vcftools-0.1.16/bin/vcftools --vcf Juglans_genomeLD_pruned_thin_thinned.vcf --het


#create fasta file for downstream analyses
/local/workdir/jbl256/Installed_programs/vcf2phylip-2.8/vcf2phylip.py --input Juglans_genomeLD_pruned_thin_thinned.vcf -f -n

#make structure file for later
/local/workdir/jbl256/Installed_programs/stacks-2.66/bin/populations -V Juglans_genomeLD_pruned_thin_thinned.vcf -O ./ -M popmap.txt --threads 8 --ordered-export --structure
