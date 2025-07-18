# written by jacob b landis

#make sure you have hybpiper environment loaded or installed in base

#assemble loop
while read name; 
do hybpiper assemble --targetfile_dna ../genomes/HYB_Lotus_singlecopy_reference.fasta -r ../cleaned_reads/$name*.fastq.gz --prefix $name --bwa --cpu 8 --hybpiper_output SC_hybpiper
done < ../namelist.txt

#####################################################################################
##set up to retrieve supercontig (introns and exons) change to 'dna' for exons only##
#####################################################################################

hybpiper retrieve_sequences supercontig --targetfile_dna ../genomes/HYB_Lotus_singlecopy_reference.fasta --sample_names SC_hybpiper


# modify output folder names for whichever UCE set
# move all the .fasta output files (one per locus) into the output folder from the run, then move to that folder
mv *supercontig.fasta SC_hybpiper
cd SC_hybpiper


# generate stats for all samples and loci
hybpiper stats --targetfile_dna .../genomes/HYB_Lotus_singlecopy_reference.fasta ../../namelist.txt

# generate heatmap for all samples
hybpiper recovery_heatmap seq_lengths.tsv --figure_length 30 --figure_height 30 --heatmap_filetype pdf --heatmap_dpi 200

mkdir supercontigs_with_introns
mv *supercontig.fasta supercontigs_with_introns
mv *.tsv supercontigs_with_introns
mv recovery_heatmap.pdf supercontigs_with_introns


