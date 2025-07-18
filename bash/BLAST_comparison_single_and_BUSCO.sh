####orthofinder vs BUSCO
#BLAST instead of map
makeblastdb -in Plectropomus_raw_singlecopy_reference.fasta -dbtype nucl -out single_copy_genes_orthofinder_blast_db
blastn -db single_copy_genes_orthofinder_blast_db -query ../genomes/Plectropomus_busco_reference.fasta -max_target_seqs 1 -outfmt 6 -out Plectropomus_busco_to_singles_all-vs-all.tsv

makeblastdb -in ../genomes/Plectropomus_busco_reference.fasta -dbtype nucl -out busco_blast_db
blastn -db busco_blast_db -query Plectropomus_raw_singlecopy_reference.fasta -max_target_seqs 1 -outfmt 6 -out Plectropomus_single_to_busco_all-vs-all.tsv

