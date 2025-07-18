#conda activate orthofinder
source /programs/miniconda3/bin/activate orthofinder-2.5.4

#default settings, very fast
orthofinder -f cleaned_reads/inputs -d -t 16 -a 6