#!/usr/bin/env perl

use strict;
use warnings;
use v5.10;
use Data::Dumper;

# Try open file on reading
open(my $fh, "<", shift @ARGV) or die "Can't open file: $!";

# matrix-array-ref from file
my %matrix;
# it's a rows
my $i = 0;
# sub transpose
sub transpose {
      my $rows = $_[0];
      my $columns = $_[1];
      my $ref = $_[2];
      for my $i (0..$rows-1){
      	for my $j ($i+1..$columns-1){
      		if (exists $ref->{"$j,$i"}) {
      			my $tmp = $ref->{"$j,$i"};
      			$ref->{"$j,$i"} = $ref->{"$i,$j"};
      			$ref->{"$i,$j"} = $tmp;
      		}
      		else {
      			$ref->{"$j,$i"} = $ref->{"$i,$j"};
      			delete $ref->{"$i,$j"}; 
      		}
      	}
      }
 
}

# Creating @matrix
while (!eof $fh) {
    my $line = readline $fh;
    # delete trailing symbols
    chomp $line;
    # split line-string into list
    my @row = split /\t/, $line;
    # create matrix-hash
    for my $j (0..$#row){
    	$matrix{"$i,$j"} = $row[$j];
    } 
    # incremet row_count
    $i++;

}
#it's a columns
my $j = (scalar values %matrix) / $i;
# let's transpose matrix
transpose($i, $j, \%matrix);

for my $i (sort keys %matrix){
	say "$matrix{$i}\t";
}



