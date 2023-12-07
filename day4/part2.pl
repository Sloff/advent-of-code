use strict;
use warnings;
use feature ":5.34";

my %cards;

while (<>) {
	s/^Card *\d+: //;

	my ($winningStr, $numbersStr) = split /\|/;

	my @winning = $winningStr =~ /(\d+)/g;
	my @numbers = $numbersStr =~ /(\d+)/g;

	my $numberOfMatches = 0;
	my $lineNum = $. + 0;
	$cards{$lineNum} += 1;

	foreach my $number (@numbers) {
		if (grep /^$number$/, @winning) {
			$numberOfMatches += 1;
			$cards{$lineNum + $numberOfMatches} += $cards{$lineNum};
		}
	}
}

my $sum = 0;

foreach my $lineNum (keys %cards) {
	$sum += $cards{$lineNum};
}

say $sum;
