package Utils;

use strict;
use warnings;

# gcd($a, $b): Returns the greatest common divisor of 2 numbers
sub gcd {
	my ($a, $b) = @_;
	while ($b) {
		($a, $b) = ($b, $a % $b);
	}

	return $a;
}

# lcm($a, $b): Calculates the least common multiple of 2 numbers
# This is useful if you have multiple number "pipelines" that cycle at different rates,
# and you want to determine the first point at which they would overlap
sub lcm {
	my ($a, $b) = @_;
	return ($a * $b) / gcd($a, $b);
}

# extrapolate_quadratic_from_3_points($v1, $v2, $v3, $x):
# This function extrapolates (or estimates) a quadratic function based on three y-values 
# corresponding to NOTE: x-values of 0, 1, and 2.
sub extrapolate_quadratic_from_3_points {
	my ($v1, $v2, $v3, $x) = @_;

	my $a = ($v1 - 2*$v2 + $v3) / 2;
	my $b = (-3*$v1 + 4*$v2 - $v3) / 2;
	my $c = $v1;

	return $a * $x**2 + $x * $b + $c;
}

# get_grid($a): Turns an array of strings into a grid, or from std in if nothing is supplied
sub get_grid {
	my ($lines) = @_;

	my $grid;

	if (defined $lines) {
		for my $line (@$lines) {
			push @$grid, [split //, $line];
		}
	} else {
		while (<>) {
			chomp;
			push @$grid, [split //];
		}
	}

	my $row_len = @$grid;
	my $col_len = @{$grid->[0]};

	return $grid, $row_len, $col_len;
}

1;
