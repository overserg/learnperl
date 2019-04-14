#!/usr/bin/env perl

use v5.20;

die "Script must have arguments! Please choose file with matrix inside.\n" if $ARGV;
# Try open file on reading
open(my $fh, "<", shift @ARGV) or die "Can't open file: $!";

# matrix-array-matrix from file
my %matrix;
# it's a rows and columns
my $rows = 0;

# sub transpose
sub transpose {
  my ($rows, $columns, $matrix) = @_;
  for my $i (0..$rows-1){
    for my $j ($i+1..$columns-1){
      if (exists $matrix->{"$j,$i"}) {
        ($matrix->{"$i,$j"},$matrix->{"$j,$i"}) = ($matrix->{"$j,$i"},$matrix->{"$i,$j"});
        next;
      }
      $matrix->{"$j,$i"} = delete $matrix->{"$i,$j"};
    }
  } 
}

# Creating @matrix
while (!eof $fh) {
    my $line = readline $fh;
    # delete trailing symbols
    chomp $line;
    # split line-string into list
    my @elements = split /\t/, $line;
    # create matrix-hash
    my $columns = 0;
    for my $element (@elements){
    	$matrix{"$rows,$columns"} = $element;
      $columns++;
    } 
    # incremet row_count
    $rows++;

}
#it's a columns
my $columns = %matrix / $rows;
# let's transpose matrix
transpose($rows, $columns, \%matrix);



#print transpose matrix-hash
for my $column (0..$columns-1){
  for my $row (0..$rows-1){
    print qq($matrix{"$column,$row"}\t)
  }
  print "\n"
}



