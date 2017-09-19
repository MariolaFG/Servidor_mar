#!/usr/bin/perl

use strict;
use Switch;
use Getopt::Long;

my $usage = qq~Usage:$0 <args>
where <args> are:
    -i, --input         <sniploid output as input file>
~;
$usage .= "\n";

my ($input);

GetOptions(
	"input=s"         => \$input
);


die $usage
  if ( !$input);


my $previous_gene; 
my $current_pos_3or4;
my $current_pos_5;
my $count3or4 = 0; 
my %phasing = 0;
my $current_3or4;
open(IN,$input);
while(<IN>)
{
	my @infos = split(";",$_);
	my $gene = $infos[0];
	my $pos = $infos[1];
	my $scenario = $infos[8];
	
	if ($gene ne $previous_gene)
	{
		$current_pos_3or4 = "";
		$current_pos_5 = "";
		$current_3or4 = "";
	}
	
	if ($scenario eq "3or4")
	{
		$count3or4++;
		$current_pos_3or4 = $pos;
		$current_3or4 = "$gene-$pos";
	}
	
	my $diff1 = $current_pos_3or4 - $current_pos_5;
	my $diff2 = $current_pos_5 - $current_pos_3or4;
	if ($current_pos_3or4 && $current_pos_5 && (($diff1 > 0 && $diff1 < 30) or ($diff2 > 0 && $diff2 < 30)))
	{
		$phasing{$current_3or4} = 1;
	}
	
	if ($scenario eq "5")
	{
		$current_pos_5 = $pos;
	}
	
	$previous_gene = $gene;
}
close(IN);



print scalar keys(%phasing) . " / $count3or4\n";
