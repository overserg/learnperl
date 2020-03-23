package Ant;

use strict;
use warnings;
use v5.30;

use Exporter;
use parent qw( Exporter );

our @EXPORT_OK = qw(
    travel
    step_forward
    turn

    TURN_LEFT
    TURN_RIGHT
);

=encoding utf8

=head1 Ant

Реализация муравья Лэнгтона.

=cut

use constant {
    TURN_LEFT  => -1,
    TURN_RIGHT => 1,
};

=head2 travel()

Осуществляет передвижение муравья по полю

    travel( \@field, $pos_x, $pos_y, $steps, $dir_x, $dir_y );

@field - массив массивов (см. perldoc L<perllol>) с числами, где -1 - чёрная клетка, а 1 - белая. Пример:

    @field = (
        [ -1, -1, -1 ],
        [ -1,  1, -1 ],
        [ -1, -1, -1 ],
    );

$pos_x/$pos_y - стартовые координаты муравья

$steps        - количество шагов которое сделает муравей

$dir_x/$dir_y - направление муравья. Пример:

    my ( $dir_x, $dir_y ) = ( -1, 0 );

=cut

sub travel {
    my ($field, $pos_x, $pos_y, $steps, $dir_x, $dir_y) = @_;
    for (my $i = 0; $i < $steps; $i++) {
        my $color = $field->[$pos_x][$pos_y];
        if ($color == 1) {
            my ($vec_x, $vec_y) = turn ($dir_x, $dir_y, TURN_RIGHT);
            $field->[$pos_x][$pos_y] = -1;
            ($dir_x, $dir_y) = ($vec_x, $vec_y);             
        }
        else { 
            my ($vec_x, $vec_y) = turn ($dir_x, $dir_y, TURN_LEFT);
            $field->[$pos_x][$pos_y] = 1;
            ($dir_x, $dir_y) = ($vec_x, $vec_y);         
        }
        my ($new_x, $new_y) = step_forward( $pos_x, $pos_y, scalar @{$field}, $dir_x, $dir_y);
        ($pos_x, $pos_y) = ($new_x, $new_y);

    }
}

=head2 step_forward()

Производит шаг в заданном направлении, возвращает новые координаты муравья.
Поле замкнуто. Например, переходя через левую границу - муравей попадает на правый край.

    my ( $new_x, $new_y ) = step_forward( $pos_x, $pos_y, $field_size, $dir_x, $dir_y );

=cut

sub step_forward {
    my ($pos_x, $pos_y, $field_size, $dir_x, $dir_y) = @_;
    my $max = $field_size-1;
    if ($dir_x == -1 && $dir_y == 0) {
        if ($pos_x == 0) {
            return ($max, $pos_y);
        }
        else {
            $pos_x-=1;
            return ($pos_x, $pos_y); }
    }
    elsif ($dir_x == 0 && $dir_y == -1) {
        if ($pos_y == 0) {
            return ($pos_x, $max);
        }    
        else { 
            $pos_y-=1;
            return ($pos_x, $pos_y); }
    }    
    elsif ($dir_x == 1 && $dir_y == 0) {
        if ($pos_x ==  $max) {
            return (0, $pos_y);
        }
        else {
            $pos_x+=1; 
            return ($pos_x, $pos_y); }
    }
    else {
        if ($pos_y == $max) {
            return ($pos_x, 0);
        }
        else {
            $pos_y+=1;
            return ($pos_x, $pos_y); }
    }        
}

=head2 turn()

Поворачивает муравья налево или направо.

    my ( $vec_x, $vec_y ) = turn( -1, 0, TURN_LEFT );

=cut

sub turn {
    my ($dir_x, $dir_y, $turn_to) = @_;
    if ($turn_to == 1) {
        if ($dir_x == -1 && $dir_y == 0) {
            ++$dir_x; ++$dir_y;
            return ($dir_x, $dir_y);
        }
        elsif ($dir_x == 0 && $dir_y == -1) {
            --$dir_x; ++$dir_y;
            return ($dir_x, $dir_y);
        }
        elsif ($dir_x == 1 && $dir_y == 0) {
            --$dir_x; --$dir_y;
            return ($dir_x, $dir_y);
        }
        else { 
            ++$dir_x; --$dir_y;
            return ($dir_x, $dir_y); 
        }
    }
    else {
        if ($dir_x == -1 && $dir_y == 0) {
            ++$dir_x; --$dir_y;
            return ($dir_x, $dir_y);
        }
        elsif ($dir_x == 0 && $dir_y == -1) {
            ++$dir_x; ++$dir_y;
            return ($dir_x, $dir_y);
        }
        elsif ($dir_x == 1 && $dir_y == 0) {
            --$dir_x; ++$dir_y;
            return ($dir_x, $dir_y)
        }
        else { 
            --$dir_x; --$dir_y;
            return ($dir_x, $dir_y); }        
    }
}

1
