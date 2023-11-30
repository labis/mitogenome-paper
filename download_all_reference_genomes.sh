#Use this to download all reference genomes from NCBI
#Install NCBI dataset using conda
conda install -c conda-forge ncbi-datasets-cli 
# Download all with fasta files and GFF anotation from reference genomes for Wolbachia TAXID 953
datasets download genome taxon 953 --reference --include genome,gff3 
cd ncbi_dataset/data
#Naming table of all sequences data
cat$(cat dataset_catalog.json | grep filePath | cut -f2 -d : | tr -d '",') > Wolbachia_170genomes.fasta
#Cleanup the mess
sed -i -n '/>/,$p' Wolbachia_170genomes.fasta