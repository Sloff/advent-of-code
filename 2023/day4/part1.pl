use strict;
use warnings;
use feature ":5.34";

my $totalScore;

while (<>) {
	s/^Card *\d+: //;

	my ($winningStr, $numbersStr) = split /\|/;

	my @winning = $winningStr =~ /(\d+)/g;
	my @numbers = $numbersStr =~ /(\d+)/g;

	my $score = 0;

	foreach my $number (@numbers) {
		if (grep /^$number$/, @winning) {
			$score = $score ? $score * 2 : 1;
		}
	}

	$totalScore += $score if $score;
}

say $totalScore;
