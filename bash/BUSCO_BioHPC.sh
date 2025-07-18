#two ways to run BUSCO, local install with conda or use the BipHPC version

#source /home/UserID/miniconda3/bin/activate

#create a conda environment just for BUSCO runs since there was an incompatibility with the base environment on Boyce
source /programs/miniconda3/bin/activate busco-5.5.0

#the line below needs to be ran the firs time only to write the necessary file to a working directory you own
#cp -r /programs/miniconda3/envs/busco-5.5.0/config /local/workdir/userID/BUSCO
#export AUGUSTUS_CONFIG_PATH=/local/workdir/jmf425/BUSCO/config


############

#run standard busco search with genome
busco -i genomes/GCF_012489685.1_LjGifu_v1.2_genomic.fna -l /local/workdir/jbl256/busco_libs/embryophyta_odb10 -o Lotus_BUSCO -m genome --cpu 16 

############
#create busco plot
generate_plot.py -wd Lotus_BUSCO

conda deactivate BUSCO