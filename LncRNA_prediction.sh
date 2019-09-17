#Hisat2 version 2.1.0
#samtools version 1.6
#stringtie 2.0
#gffcompare v0.10.4
#CPC,py 0.1
#HMMER 3.1b2
# pfam_scan
# TransDecoder V5.3.0



### building genome index
$extract_splice_sites.py TM-1_V2.1.gene.gtf > TM-1_V2.1.ss 
$ extract_exons.py TM-1_V2.1.gene.gtf > TM-1_V2.1.exon
$ hisat2-build --ss TM-1_V2.1.ss --exon TM-1_V2.1.exon TM-1_V2.1.fa TM-1_V2.1
### mapping
$stringtie -G ../../ref/TM-1_V2.1.gene.gtf -p 2 -o V001-V002-1.sam.sorted.bam.gtf V001-V002-1.sam.sorted.bam
$stringtie -G ../../ref/TM-1_V2.1.gene.gtf -p 2 -o V001-V002.sam.sorted.bam.gtf V001-V002.sam.sorted.bam
$stringtie -G ../../ref/TM-1_V2.1.gene.gtf -p 2 -o V003-V004-1.sam.sorted.bam.gtf V003-V004-1.sam.sorted.bam
$stringtie -G ../../ref/TM-1_V2.1.gene.gtf -p 2 -o V003-V004.sam.sorted.bam.gtf V003-V004.sam.sorted.bam
....
/public/home/zhaoting/biosoftware/samtools-1.6/samtools sort -@ 1 -o V001-V002-1.sam.sorted.bam V001-V002-1.sam && rm V001-V002-1.sam
/public/home/zhaoting/biosoftware/samtools-1.6/samtools sort -@ 1 -o V001-V002.sam.sorted.bam V001-V002.sam && rm V001-V002.sam
/public/home/zhaoting/biosoftware/samtools-1.6/samtools sort -@ 1 -o V003-V004-1.sam.sorted.bam V003-V004-1.sam && rm V003-V004-1.sam
/public/home/zhaoting/biosoftware/samtools-1.6/samtools sort -@ 1 -o V003-V004.sam.sorted.bam V003-V004.sam && rm V003-V004.sam
### assemble
stringtie -G ../../ref/TM-1_V2.1.gene.gtf -p 2 -o V001-V002-1.sam.sorted.bam.gtf V001-V002-1.sam.sorted.bam
stringtie -G ../../ref/TM-1_V2.1.gene.gtf -p 2 -o V001-V002.sam.sorted.bam.gtf V001-V002.sam.sorted.bam
stringtie -G ../../ref/TM-1_V2.1.gene.gtf -p 2 -o V003-V004-1.sam.sorted.bam.gtf V003-V004-1.sam.sorted.bam
stringtie -G ../../ref/TM-1_V2.1.gene.gtf -p 2 -o V003-V004.sam.sorted.bam.gtf V003-V004.sam.sorted.bam

### lncRNA prediction
ls *gtf > mergelist.txt
stringtie --merge -o merged.gtf -c 3 ./mergelist.txt
gffcompare -r ../ref/TM-1_V2.1.gene.gtf -p 4 merged.gtf -o merged_lncRNA
awk '$3 == "x"|| $3 == "u"|| $3 == "i" {print $0}' merged_lncRNA.merged.gtf.tmap > novel.gtf.tmap
awk '$11 >200 {print}' novel.gtf.tmap > novel.longRNA.gtf.tmap
awk '{print $5}' novel.longRNA.gtf.tmap | perl ~/zt_script/extract_gtf_by_name.pl merged.gtf - > novel.longRNA.gtf
gffread -g ~/eGWAS/ref/TM-1_V2.1.fa -w exon.fa ./novel.longRNA.gtf
TransDecoder.LongOrfs -t exon.fa # This step generated a file named longest_orfs.ped

