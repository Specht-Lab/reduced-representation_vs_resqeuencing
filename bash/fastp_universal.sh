mkdir cleaned_reads

for file in raw_reads/*R1.fastq.gz
do
	name=`basename $file .R1.fastq.gz`
	echo "Running fastp on $name"
	forward=$name".R1.fastq.gz"
	reverse=$name".R2.fastq.gz"
	Installed_programs/fastp  -i raw_reads/$forward -o cleaned_reads/$forward -I raw_reads/$reverse -O cleaned_reads/$reverse -z 4 -q 20 --trim_poly_g --length_required 75 --thread 16
done
