package Utils;

use strict;
use warnings;

sub gcd {
	my ($a, $b) = @_;
	while ($b) {
		($a, $b) = ($b, $a % $b);
	}

	return $a;
}

sub lcm {
	my ($a, $b) = @_;
	return ($a * $b) / gcd($a, $b);
}

1;
