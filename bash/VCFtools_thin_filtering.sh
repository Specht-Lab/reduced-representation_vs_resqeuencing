##############################
### final filtering parameters
##############################
# #/local/workdir/jbl256/Installed_programs/vcftools-0.1.16/bin/vcftools --gzvcf /local/workdir/jbl256/PLSCI6940_class_project/Camellia_sinensis_jbl/map_to_genome/Camellia_genome_unfiltered_snps.vcf.gz --max-missing 0.5 --min-alleles 2 --max-alleles 2 --maf 0.05 --mac 3 --recode --recode-INFO-all --out Camellia_genome_initial_filtering

# #gives missing proportion of loci for each individual
# /local/workdir/jbl256/Installed_programs/vcftools-0.1.16/bin/vcftools --vcf /local/workdir/jbl256/PLSCI6940_class_project/D_similis_chloe/map_to_genome/VCFtools/genome_initial_filtering.recode.vcf --missing-indv

# #create a list of individuals with at least 50% missing data
# awk '$5 > 0.5' out.imiss | cut -f1 > lowDP50.indv

# #drop low samples and get ready to filter for LD
# /local/workdir/jbl256/Installed_programs/vcftools-0.1.16/bin/vcftools --vcf /local/workdir/jbl256/PLSCI6940_class_project/D_similis_chloe/map_to_genome/VCFtools/genome_initial_filtering.recode.vcf --min-alleles 2 --max-alleles 2 --max-missing 0.7 --maf 0.05 --mac 3 --recode --recode-INFO-all --out Ready_for_plink

# #before LD filtering need to calculate LD values with PopLDdecay
# #calculate LD on all samples
# /local/workdir/jbl256/Installed_programs/PopLDdecay/bin/PopLDdecay -InVCF genome_initial_filtering.recode.vcf -OutStat LDdecay_Diprion -MaxDist 100 -MAF 0.05 -OutType 1

# #plot one figure for all samples
# perl /local/workdir/jbl256/Installed_programs/PopLDdecay/bin/Plot_OnePop.pl -inFile LDdecay_Diprion.stat.gz -output Fig_LDdecay_Aquilegia_genome -keepR -percent 0.5


# /programs/plink-1.9-x86_64-beta7/plink --vcf Ready_for_plink.recode.vcf --make-bed --allow-extra-chr --double-id --out pop_sorted --set-missing-var-ids @:#

# #tests for pairwise LD in a sliding window (5kb window with a step size of 0.5 and r^2 of 0.5)
# /programs/plink-1.9-x86_64-beta7/plink --bfile pop_sorted --indep-pairwise 20 10 0.2 --allow-extra-chr --double-id --threads 4

# #this grabs the correct positions, but chr1-20 need to be modified in the To_prune.txt to put the prefix in
# awk '{gsub(":", " ");print}' plink.prune.out > To_prune.txt

# #/local/workdir/jbl256/Installed_programs/vcftools-0.1.16/bin/vcftools to prune out selected SNPs from plink
# /local/workdir/jbl256/Installed_programs/vcftools-0.1.16/bin/vcftools --vcf Ready_for_plink.recode.vcf --exclude-positions To_prune.txt --recode --recode-INFO-all --out Aquilegia_genome_LD_pruned_SNPs

# Convert the pruned VCF back to PLINK format
/programs/plink-1.9-x86_64-beta7/plink --vcf Aquilegia_genome_LD_pruned_SNPs.recode.vcf --make-bed --allow-extra-chr --double-id --out Aquilegia_genome_pruned

/programs/plink-1.9-x86_64-beta7/plink --bfile Aquilegia_genome_pruned --thin-count 100000 --allow-extra-chr --recode --out  Aquilegia_genome_pruned_100000

/programs/plink-1.9-x86_64-beta7/plink --file Aquilegia_genome_pruned_100000 --allow-extra-chr --recode vcf --out Aquilegia_genome_pruned_100000


#gives missing proportion of loci for each individual
/local/workdir/jbl256/Installed_programs/vcftools-0.1.16/bin/vcftools --vcf Aquilegia_genome_pruned_100000.vcf --missing-indv

#average depth for each individual
/local/workdir/jbl256/Installed_programs/vcftools-0.1.16/bin/vcftools --vcf Aquilegia_genome_pruned_100000.vcf --depth 

#observed and expected heterozygosity
/local/workdir/jbl256/Installed_programs/vcftools-0.1.16/bin/vcftools --vcf Aquilegia_genome_pruned_100000.vcf --het


#create fasta file for downstream analyses
/local/workdir/jbl256/Installed_programs/vcf2phylip-2.8/vcf2phylip.py --input Aquilegia_genome_pruned_100000.vcf -f -n

#make structure file for later
/local/workdir/jbl256/Installed_programs/stacks-2.66/bin/populations -V Aquilegia_genome_pruned_100000.vcf -O ./ -M popmap.txt --threads 8 --ordered-export --structure
