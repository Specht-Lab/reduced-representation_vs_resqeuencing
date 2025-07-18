export PATH=/programs/jellyfish-2.2.7/bin:/programs/salmon-1.0.0/bin:$PATH
export TRINITY_HOME=/programs/trinityrnaseq-v2.14.0/
export LD_LIBRARY_PATH=/usr/local/gcc-7.3.0/lib64:/usr/local/gcc-7.3.0/lib
export PATH=/local/workdir/jbl256/Installed_programs/samtools-1.19.2:$PATH


#basic assembly
/programs/trinityrnaseq-v2.14.0/Trinity --seqType fq --left cleaned_reads/Epinephelus_coioides_transcript.R1.fastq.gz --right cleaned_reads/Epinephelus_coioides_transcript.R2.fastq.gz --max_memory 150G --CPU 8 --min_contig_length 300 --no_salmon --output cleaned_reads/trinity_Epinephelus_coioides_transcript --full_cleanup

#make supertranscripts
/programs/trinityrnaseq-v2.14.0/Analysis/SuperTranscripts/Trinity_gene_splice_modeler.py --trinity_fasta cleaned_reads/trinity_Epinephelus_coioides_transcript.Trinity.fasta

#basic assembly
/programs/trinityrnaseq-v2.14.0/Trinity --seqType fq --left cleaned_reads/Epinephelus_fuscoguttatus_transcript.R1.fastq.gz --right cleaned_reads/Epinephelus_fuscoguttatus_transcript.R2.fastq.gz --max_memory 150G --CPU 8 --min_contig_length 300 --no_salmon --output cleaned_reads/trinity_Epinephelus_fuscoguttatus_transcript --full_cleanup

#make supertranscripts
/programs/trinityrnaseq-v2.14.0/Analysis/SuperTranscripts/Trinity_gene_splice_modeler.py --trinity_fasta cleaned_reads/trinity_Epinephelus_fuscoguttatus_transcript.Trinity.fasta
