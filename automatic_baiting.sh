#Run this script for baiting
#Parameters
ftpuser=""
ftppass=""
ftpserver=
ftpdir="/Raw_New_Fastq/"
ftpfile="Mk-Hel"
ftpoutdir="/experiments/wolbachia-hermathena/reads"
baitout="/experiments/wolbachia-hermathena/bait"
workdir="/experiments/wolbachia-hermathena"
genomebait="/experiments/wolbachia-hermathena/genome/GCF_014107475.1_ASM1410747v1_genomic.fna"
baitresult="baitresult"
mirabaitfile="/mira/mirabait"
#Loop over the indivuduals
for indv in $(seq 63 82)
    do echo "Starting downloadin reads from indv $indv"
    #go to directory
    cd $workdir
    #Start downloading file
    wget --quiet --ftp-user=$ftpuser --ftp-password=$ftppass --directory-prefix=$ftpoutdir ftp://$ftpserver$ftpdir$ftpfile$indv\_R1.fastq.gz ftp://$ftpserver$ftpdir$ftpfile$indv\_R2.fastq.gz
    #Start mirabait
    echo "Starting baiting for indv $indv"
    cd $workdir/$baitresult
    $workdir/$mirabaitfile -n 10 -t 4 -b $genomebait -p $ftpoutdir/$ftpfile$indv\_R1.fastq.gz $ftpoutdir/$ftpfile$indv\_R2.fastq.gz
    rm -f $ftpoutdir/$ftpfile$indv\_R1.fastq.gz $ftpoutdir/$ftpfile$indv\_R2.fastq.gz
    done
echo "All done!"