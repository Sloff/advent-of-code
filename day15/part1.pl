use strict;
use warnings;
use feature ":5.34";

$/ = ",";

my $result;

while (<>) {
	s/[\n,]//g;
	my @letters = split //;

	my $curr = 0;
	for my $letter (@letters) {
		$curr += ord($letter);
		$curr *= 17;
		$curr %= 256;
	}

	$result += $curr;
}

say $result;
