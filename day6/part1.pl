use strict;
use warnings;
use feature ":5.34";

my @lines = <>;

my @times = $lines[0] =~ /(\d+)/g;
my @distances = $lines[1] =~ /(\d+)/g;

my $result = 1;

for my $i (0..$#times) {
	my $time = $times[$i];
	my $distance = $distances[$i];

	my $sum = 0;

	for my $heldTime (0..$time) {
		my $distanceAvailable = $time - $heldTime;
		my $distanceTravelled = $distanceAvailable * $heldTime;

		if ($distanceTravelled > $distance) {
			$sum++;
		}
	}

	$result *= $sum;
}

say $result;
