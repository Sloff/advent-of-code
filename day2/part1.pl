use strict;
use warnings;
use feature ":5.34";

my $sum = 0;

while (<>) {
	my $possible = 1;

	my @matches = m/(\d+) red/g;

	for my $match (@matches) {
		if ($match > 12) {
			$possible = 0;
		}
	}

	if (!$possible) {
		next;
	}

	@matches = m/(\d+) green/g;

	for my $match (@matches) {
		if ($match > 13) {
			$possible = 0;
		}
	}

	if (!$possible) {
		next;
	}

	@matches = m/(\d+) blue/g;

	for my $match (@matches) {
		if ($match > 14) {
			$possible = 0;
		}
	}

	if (!$possible) {
		next;
	}

	/^Game (\d+):/;
	$sum += $1;
}

say $sum;
