#!/usr/bin/env perl

use v5.20;

die "Script must have arguments. Please try again with arguments\n" if ($#ARGV == -1);
# Try open file on reading
open(my $fh, "<", shift @ARGV) or die "Can't open file: $!";

# matrix-array-ref from file
my %matrix;
# it's a rows and columns
my $rows = 0;

# sub transpose
sub transpose {
  my $rows = $_[0];
  my $columns = $_[1];
  my $ref = $_[2];
  for my $i (0..$rows-1){
    for my $j ($i+1..$columns-1){
      if (exists $ref->{"$j,$i"}) {
        ($ref->{"$i,$j"},$ref->{"$j,$i"}) = ($ref->{"$j,$i"},$ref->{"$i,$j"});
      }
      else {
      	$ref->{"$j,$i"} = delete $ref->{"$i,$j"};
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
my $columns = values(%matrix) / $rows;
# let's transpose matrix
transpose($rows, $columns, \%matrix);



#print transpose matrix-hash
for my $column (0..$columns-1){
  for my $row (0..$rows-1){
    print "$matrix{\"$column,$row\"}\t"
  }
  print "\n"
}



