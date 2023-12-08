use strict;
use warnings;
use feature ":5.34";

use List::Util "sum";

my $result = 0;

while (<>) {
	my @numbers;

	push @numbers, [/(-?\d+)/g];
	my @firstValues;

	my $i = 0;

	while (defined $numbers[$i]) {
		my @thisNumbers = @{$numbers[$i]};
		my $allZero = 1;
		for my $ii (0..$#thisNumbers) {
			if ($ii == 0) {
				push @firstValues, $thisNumbers[$ii];
			}
			if (defined $thisNumbers[$ii+1]) {
				my $difference = $thisNumbers[$ii+1] - $thisNumbers[$ii];
				push @{$numbers[$i+1]}, $difference;

				if ($difference != 0) {
					$allZero = 0;
				}
			}
		}

		last if ($allZero);
		$i++;
	}

	my $current = 0;
	for my $val (reverse @firstValues) {
		$current = $val - $current;
	}
	$result += $current;
}

say $result;
