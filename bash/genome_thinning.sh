/programs/plink-1.9-x86_64-beta7/plink --vcf Costus_genome_LD_pruned_SNPs.vcf --make-bed --double-id --allow-extra-chr --out Costus_genome_LD_pruned_SNPs

/programs/plink-1.9-x86_64-beta7/plink --bfile Costus_genome_LD_pruned_SNPs --thin-count 100000 --allow-extra-chr --recode --out Costus_genome_LD_pruned_SNPs_100000

/programs/plink-1.9-x86_64-beta7/plink --file Costus_genome_LD_pruned_SNPs_100000 --allow-extra-chr --recode vcf --out Costus_genome_LD_pruned_SNPs_100000
