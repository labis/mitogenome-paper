#Parametros para análise
workdir="/experiments/wolbachia-hermathena"
genomebait="/experiments/wolbachia-hermathena/genome/GCF_014107475.1_ASM1410747v1_genomic.fna"
baitresult="baitresult"
assemblydir="assembly/spades"
spadesfile="/experiments/wolbachia-hermathena/spades/SPAdes-3.15.4-Linux/bin/spades.py"
baitlist="list.tmp"
mlstfile="$workdir/mlst.py"

#Go to the working diretory
cd $workdir
#Find the positive baited reads
find $workdir/$baitresult -type f ! -empty | cut -d _ -f 3 | sort -u > $baitlist

#Run Spades assembler for each baited reads pair
while read line;
do echo $line;
mkdir $workdir/$assemblydir/tmp
$spadesfile --careful -1 $workdir/$baitresult/bait_match_${line}_R1.fastq -2 $workdir/$baitresult/bait_match_${line}_R2.fastq -o $workdir/$assemblydir/tmp
$mv $workdir/$assemblydir/tmp/scaffolds.fasta $workdir/$assemblydir/${line}_spades_scaffolds.fasta
sed -i "s/>NODE/>${line}/g" $workdir/$assemblydir/${line}_spades_scaffolds.fasta
python $mlstfile -f $workdir/$assemblydir/${line}_spades_scaffolds.fasta > $workdir/$assemblydir/${line}_mlst.out
find $workdir/$assemblydir/${line}_mlst.out -type f -size -10c -exec rm -f {} \; -exec echo ${line} >> $workdir/$assemblydir/missing_mlst.out \;
rm -rf $workdir/$assemblydir/tmp
done < $baitlist