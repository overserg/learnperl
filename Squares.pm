package Squares {
    use 5.016;
    use Moose;
    use List::AllUtils qw/ sum /;
    
    use Class:XSAccessor {
        constructor => 'new',
        accesssors => [qw(number sum_of_squares square_of_sum difference)];
    }
    
    has number => (
      is => 'ro',
      trigger => sub {
        my( $self, $number ) = @_;
        die "out of range" if $number > 64 or $number < 1;
      } 
    );
    
    sub SumOfSquares {
        my $self = shift;
        return sum map { $_**2 } 1..$self->number;
        
    }

    sub SquareOfSum {
        my $self = shift;
        return  (sum 1..$self->number )**2;
        }
    }
    sub Difference {
        my $self = shift;
        return $self->SumOfSquares() - $self->SquareOfSum();
    }
1;
}


