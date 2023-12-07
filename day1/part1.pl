use strict;
use warnings;
use feature ":5.34";

my $sum = 0;

while (<>) {
	/^\D*(\d)/;
	my $num = $1;

	/(\d)\D*$/;
	$num .= $1;
	$sum += $num;
}

say $sum;
