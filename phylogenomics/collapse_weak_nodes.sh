#################################################################
#########Script orginally written by jacob b. landis ############
#########last modified by joshua m. felton 7/23/24###############
#################################################################

mkdir summary_stats
mkdir collapsed_trees
mkdir rooted_trees
mkdir well_supported
mkdir larger_than70_nodes

#reroot trees
for file in primula/*.support
do
	name=`basename $file .treefile`
	echo "rooting tree for $name"
	gotree reroot midpoint -i $file -o $name.rooted.treefile.tre 
done

mv Primula/*.rooted.treefile.tre new_root/

#collapse weak nodes
for file in new_root/*.treefile.tre
do
	name=`basename $file .treefile.tre`
	echo "Collapsing weakly supported nodes for $name"
	gotree collapse support -i $file -s 70 -o collapsed_trees/$name.collapsed.treefile.tre 
done

#basic command for one tree using a 70% cutoff
for file in collapsed_trees/*.tre
do
	name=`basename $file .tre`
	echo "Collapsing weakly supported nodes for $name"
	gotree stats edges -i $file > summary_stats/$name.summary_file.txt
done

#select only internal nodes (not polytomy collapsed nodes)
for file in summary_stats/*.summary_file.txt
do
	name=`basename $file .min4.fasta.one_accession.summary_file.txt`
	awk '$4 != "N/A" && $5 == "false"' $file > well_supported/$name.wellsupported.txt
done

#double check that the correct nodes that are well-supported were saved (in this case anything with a bootstrap value of 70 or higher)
for file in well_supported/*.wellsupported.txt
do
	name=`basename $file .wellsupported.txt`
	awk '$4 > 69' $file > larger_than70_nodes/$name.larger_than70nodes.txt
done

#Count number of nodes that are well-supported by counting the lines with text, each node will be its own line
for file in larger_than70_nodes/*.larger_than70nodes.txt
do
	wc -l $file >> larger_than_70_nodes.txt
done
