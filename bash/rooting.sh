#midpoint root
for file in ./*.support
do
	name=`basename $file .treefile`
	echo "rooting tree for $name"
	gotree reroot midpoint -i $file -o $name.rooted.treefile.tre 
done

# outgroup root
for file in ./*.support
do
    name=`basename $file .treefile`
    echo "Rooting tree for $name using outgroup"
    gotree reroot outgroup -i $file -o $name.outgroup_rooted.treefile.tre -l outgroup.txt
done
