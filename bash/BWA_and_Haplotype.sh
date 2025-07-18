# written by jacob b. landis 

mkdir SAM_files
mkdir bam_files
mkdir sorted_bam_files
mkdir Duplicates_marked
mkdir GVCF
mkdir Completed_BAMs_after_SNPs
mkdir angsd

#make sure update java is installed with conda
#conda install bioconda::java-jdk

#create dictionary file for reference genome
/local/workdir/jbl256/Installed_programs/gatk-4.2.3.0/gatk CreateSequenceDictionary R=GCF_012489685.1_LjGifu_v1.2_genomic.fna O=GCF_012489685.1_LjGifu_v1.2_genomic.dict

#create index file with faidx for reference genome
/local/workdir/jbl256/Installed_programs/samtools-1.19.2/samtools faidx GCF_012489685.1_LjGifu_v1.2_genomic.fna


#reference file
GENOME=GCF_012489685.1_LjGifu_v1.2_genomic.fna

# Read group information starts with "@RG
# ID: is unique identifier of the samples, for now doing the sample name and the barcode info
# SM: is the sample name
# PL: is the sequencing equipment, in almost all cases this will be Illumina
# PU: is the run identifier, the lane, followed by the specific barcode of the sample
# LB: is the library count

#generate BAM

for file in ../cleaned_reads/*R1.fastq.gz
do
	name=`basename $file .R1.fastq.gz`
	echo "mapping $name to reference"
	forward=$name".R1.fastq.gz"
	reverse=$name".R2.fastq.gz"
	design=`basename $file .R1.fastq.gz`
	#perform the alignment
	/local/workdir/jbl256/Installed_programs/bwa-mem2-2.2.1_x64-linux/bwa-mem2 mem -t 16 -R "@RG\tID:$design.wgs\tSM:$design\tPL:IlluminaSRA\tPU:HTNMKDSXX\tLB:WGS_SRA" ../genomes/$GENOME ../cleaned_reads/$forward ../cleaned_reads/$reverse | /local/workdir/jbl256/Installed_programs/samtools-1.19.2/samtools view -S -b --threads 16 > bam_files/$name.bam
done


#Sort BAM for SNP calling

for file in bam_files/*.bam
do
	echo "Sort $file"
	name=`basename $file .bam`
	readid=$name
	/local/workdir/jbl256/Installed_programs/samtools-1.19.2/samtools sort --threads 16 -o sorted_bam_files/$readid.bam $file
	rm $file
done

#create sequence dictionary in Picard (needed for GATK analysis), need to already have the genome indexed with BWA

# mark duplicates
for file in sorted_bam_files/*.bam
do
	echo "Marking duplicates in $file "
	name=`basename $file .bam`
	/local/workdir/jbl256/Installed_programs/gatk-4.2.3.0/gatk --java-options "-Xmx10G" MarkDuplicates -I $file -O Duplicates_marked/$name.duplicates.bam -M Duplicates_marked/$name.dup_metrics.txt
	rm $file
done


#index bam files before calling SNPs
for file in Duplicates_marked/*.bam
do
	echo "Indexing $file "
	name=`basename $file .bam`
	/local/workdir/jbl256/Installed_programs/samtools-1.19.2/samtools index $file
done


cd angsd

# heterozygosity with ANGSD 
for file in ../Duplicates_marked/*bam
do
	name=`basename $file .bam`
	echo "Running angsd on $name to calculate genome wide heterozygostiy"
	/local/workdir/jbl256/Installed_programs/angsd/angsd -i $file -anc ../../genomes/$GENOME -dosaf 1 -gl 1 -minMapQ 30 -minQ 20
	/local/workdir/jbl256/Installed_programs/angsd/misc/realSFS angsdput.saf.idx > $name.est.ml
	rm angsdput.saf.pos.gz
	rm angsdput.saf.idx
	rm angsdput.saf.gz
	rm angsdput.arg
done

cd ..

#Use HaplotypeCaller for each sample
for file in Duplicates_marked/*.bam
do
	echo "Calling SNPs on $file "
	name=`basename $file .bam`
	/local/workdir/jbl256/Installed_programs/gatk-4.2.3.0/gatk --java-options "-Xmx10G" HaplotypeCaller -R ../genomes/$GENOME -I $file -O GVCF/$name.g.vcf.gz -ERC GVCF
	echo "finished" $file 
done
