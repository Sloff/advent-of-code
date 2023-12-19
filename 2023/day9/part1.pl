use strict;
use warnings;
use feature ":5.34";

use List::Util "sum";

my $result = 0;

while (<>) {
	my @numbers;

	push @numbers, [/(-?\d+)/g];
	my @lastValues;

	my $i = 0;

	while (defined $numbers[$i]) {
		my @thisNumbers = @{$numbers[$i]};
		my $allZero = 1;
		for my $ii (0..$#thisNumbers) {
			if (defined $thisNumbers[$ii+1]) {
				my $difference = $thisNumbers[$ii+1] - $thisNumbers[$ii];
				push @{$numbers[$i+1]}, $difference;

				if ($difference != 0) {
					$allZero = 0;
				}
			} else {
				push @lastValues, $thisNumbers[$ii];
			}
		}

		last if ($allZero);
		$i++;
	}

	$result += sum @lastValues;
}

say $result;
