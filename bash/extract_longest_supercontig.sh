# https://www.biostars.org/p/78487/

# modified by jacob b. landis 

mkdir longest_contig_per_locus

#loop through the output from hybpiper, extract the longest supercontig per locus, then extract that the original fasta file
for file in ./*.fasta
do
	name=`basename $file .fasta`
	cat $file | /local/workdir/jbl256/Installed_programs/bioawk-1.0/bioawk -c fastx '{ print length($seq), $name }' | sort -k1,1rn | head -1 > $name.longest.txt
	contig_name=`awk '{print $2}' $name.longest.txt`
	#echo "$contig_name"
	/local/workdir/jbl256/Installed_programs/samtools-1.19.2/samtools faidx $file "$contig_name" > longest_contig_per_locus/$name.longest_contig.fasta
done


#add file name into header
cd longest_contig_per_locus
for f in *.fasta; do sed -i "s/^>/>${f%.longest_contig.fasta} /g" "${f}"; done

#combined all the new fasta files together into one file for a reference
cat *.fasta > Lotus_BUSCOsuper_reference.fasta

#reports back sequence lengths for all contigs
cat Lotus_BUSCOsuper_reference.fasta | /local/workdir/jbl256/Installed_programs/bioawk-1.0/bioawk -c fastx '{ print length($seq), $name }' > Lotus_BUSCOsuper_reference.gene_lengths.txt

