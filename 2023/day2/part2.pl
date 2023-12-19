use strict;
use warnings;
use feature ":5.34";

use List::Util qw(max);

my $sum = 0;

while (<>) {
	my @matches = m/(\d+) red/g;
	my $red = max @matches;

	@matches = m/(\d+) green/g;
	my $green = max @matches;

	@matches = m/(\d+) blue/g;
	my $blue = max @matches;

	$sum += ($red * $green * $blue)
}

say $sum;
