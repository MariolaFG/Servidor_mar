#!/usr/bin/perl

use strict;
use Switch;
use Getopt::Long;

my $usage = qq~Usage:$0 <args>
where <args> are:
    -i, --input         <input tabular file>
    -c, --column        <column to analyze>
    -w, --window_size   <window size>
    -m, --min_occurence <minimal number of occurence>
    -e, --expression    <expression to detect as an occurence>
~;
$usage .= "\n";

my ($input,$column,$window,$min_occurence,$expression);

GetOptions(
	"input=s"         => \$input,
	"column=s"        => \$column,
	"window=s"        => \$window,
	"min_occurence=s" => \$min_occurence,
	"expr=s"          => \$expression
);


die $usage
  if ( !$input or !$column or !$window or !$min_occurence or !$expression);
  

my $num_line = 0;
my %values;
my %lines;
open(I,$input);
while(<I>)
{
	$num_line++;
	my $line = $_;
	chomp($line);
	my @infos = split(/\t/,$line);
	my $value = $infos[$column-1];
	if ($value =~/(\w+)/)
	{
		$value = $1;
	}

	$values{$num_line} = $value;
	$lines{$num_line} = $line;
}
close(I);


for (my $i=1; $i <= ($num_line - $window); $i++)
{
	my $count_OK = 0;
	

	# parse window
	for (my $j=0; $j < $window; $j++)
	{
		my $test = $i + $j;

		if ($values{$test} eq $expression)
		{
			$count_OK++;
		}
	}

	
	if ($count_OK >= $min_occurence)
	{
		print $lines{$i} . "\n";
	}
}



