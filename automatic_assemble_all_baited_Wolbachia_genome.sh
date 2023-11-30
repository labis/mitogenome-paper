#use this script to assemble all Wolbachia genomes
#Parametros para análise
workdir="/experiments/wolbachia-hermathena"
genomebait="/experiments/wolbachia-hermathena/genome/GCF_014107475.1_ASM1410747v1_genomic.fna"
baitresult="baitresult"
assemblydir="assembly"
mirabaitfile="/experiments/wolbachia-hermathena/mira/mira"
baitlist="list.tmp"

#Go to working dir
cd $assemblydir
#fiding positiv reads
find $workdir/$baitresult -type f ! -empty | cut -d _ -f 3 | sort -u > $baitlist

#Run mira for each reads pair
while read line;
do echo $line;
echo "
#manifest file for testing mira 4

project = $line
job = genome,denovo,accurate

parameters = -GE:not=10:kpmf=5 -SK:mmhr=1:pr=70:kms=17 -CL:ascdc=no -KS:mnr=yes -NW:cmrnl=no -NW:cmrnl=warn
parameters = COMMON_SETTINGS -AS:sd=y:nop=2
parameters = SOLEXA_SETTINGS -CL:qc=yes:qcmq=5:qcwl=5 -AS:mrpc=3

# now the shotgun Illumina data

readgroup = wolbachia
autopairing
technology = solexa
data =$workdir/$baitresult/bait_match_$line\_R1.fastq
data =$workdir/$baitresult/bait_match_$line\_R2.fastq
" > $line\_manifest.txt
$mirabaitfile $line\_manifest.txt
rm -f $line\_manifest.txt
done < $baitlist