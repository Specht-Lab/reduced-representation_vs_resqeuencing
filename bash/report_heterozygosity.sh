# written by jacob b landis 

for file in ./*.est.ml
do
	name=`basename $file .est.ml`
	awk '{print FILENAME, $2/($1 + $2 +$3)}' $file >> heteroszygosity_calculation.txt
done


