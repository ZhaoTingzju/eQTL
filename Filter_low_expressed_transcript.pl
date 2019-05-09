#!/usr/bin/perl -w
use Getopt::Long;
my ($data_frame,$threshold,$p,$gene_id);
GetOptions
(
    "i:s" => \$data_frame,
	"threshold:f" => \$threshold,
	"p:f" => \$p,
);
sub usage
{
        die qq/
Filter out genes with very low expression levels.
Find genes expressed in 75% sample

Usage: perl $0 [options]
Options:
        -i        <s> : data_frame of input data, head is required .
        -threshold  <int> : The threshold of expressed genes (default >1)
        -p  <float> :--proportion: float  sample by proportion (default 0.75)
\n/;
}
if (!defined $data_frame  )
{    &usage();       }

if (!defined $threshold ){$threshold = 1;}
if (!defined $p ){$p = 0.75;}


#print $threshold."\n";
#print $p."\n";

open (IN,"$data_frame");
$head=<IN>;
#print $head;
@arr=split("\t",$head);
$sample_num=$#arr;
$sample_threshold=  $sample_num * $p;
#print $sample_threshold."\n";
$count=0;
while (<IN>) { 
	@arr2=split("\t",$_);
	$gene_id=shift @arr2;
    #print $#arr2."\n";
		foreach $element(@arr2) {
			if ($element > $threshold) { $count++;} 
                                     }
#print $count."\n";
	if ( $count > $sample_threshold ) {print "$_";	}
$count=0;
	
} 