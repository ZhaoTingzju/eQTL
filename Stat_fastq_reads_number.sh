for name in *.fastq.gz;
do line=`zcat $name | wc -l`;
let seq_num=$line/4; # 在shell中，let命令用于指定算术运算
echo "$name \c";
echo $seq_num;
done


