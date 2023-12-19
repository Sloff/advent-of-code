use strict;
use warnings;
use feature ":5.34";

use List::Util qw(max);

my $sum = 0;
my $prev = "";
my $curr = "";
my $next = "";

while (<>) {
	if ($. == 1) {
		$curr = $_;
		next;
	} else {
		$next = $_;
	}

	while ($curr =~ /(\d+)/g) {
		my $startPos = max ($-[1] - 1, 0);
		my $len = length $1;

		my $prevSub = $prev ? substr($prev, $startPos, $len + 2) : "";
		my $currSub = substr($curr, $startPos, $len + 2);
		my $nextSub = substr($next, $startPos, $len + 2);

		my $num = $1;

		if (($prevSub . $currSub . $nextSub) =~ /[^\d.\n]/g) {
			$sum += $num;
		}
	}

	$prev = $curr;
	$curr = $next;
}

while ($curr =~ /(\d+)/g) {
	my $startPos = max ($-[1] - 1, 0);
	my $len = length $1;

	my $prevSub = $prev ? substr($prev, $startPos, $len + 2) : "";
	my $currSub = substr($curr, $startPos, $len + 2);

	my $num = $1;

	if (($prevSub . $currSub) =~ /[^\d.]/g) {
		$sum += $num;
	}
}

say $sum;
