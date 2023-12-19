use strict;
use warnings;
use feature ":5.34";

use List::Util qw(max product);

my $sum = 0;
my $prev = "";
my $curr = "";
my $next = "";

my %gears;

while (<>) {
	if ($. == 1) {
		$curr = $_;
		next;
	} else {
		$next = $_;
	}

	while ($curr =~ /(\d+)/g) {
		my $startPos = max($-[1] - 1, 0);

		my $prevSub = $prev ? substr($prev, $startPos, (length $1) + 2) : "";
		my $currSub = substr($curr, $startPos, (length $1) + 2);
		my $nextSub = substr($next, $startPos, (length $1) + 2);

		my $num = $1;


		while ($prevSub =~ /(\*)/g) {
			my $key = ($. - 2) . ":" . ($-[1] + $startPos);
			push @{$gears{$key}}, $num;
		}

		while ($currSub =~ /(\*)/g) {
			my $key = ($. - 1) . ":" . ($-[1] + $startPos);
			push @{$gears{$key}}, $num;
		}

		while ($nextSub =~ /(\*)/g) {
			my $key = $. . ":" . ($-[1] + $startPos);
			push @{$gears{$key}}, $num;
		}
	}

	$prev = $curr;
	$curr = $next;
}

while ($curr =~ /(\d+)/g) {
	my $startPos = max($-[1] - 1, 0);

	my $prevSub = $prev ? substr($prev, $startPos, (length $1) + 2) : "";
	my $currSub = substr($curr, $startPos, (length $1) + 2);

	my $num = $1;


	while ($prevSub =~ /(\*)/g) {
		my $key = ($. - 1) . ":" . ($-[1] + $startPos);
		push @{$gears{$key}}, $num;
	}

	while ($currSub =~ /(\*)/g) {
		my $key = $. . ":" . ($-[1] + $startPos);
		push @{$gears{$key}}, $num;
	}
}

foreach my $gearLoc (keys %gears) {
	my @values = @{$gears{$gearLoc}};
	if (scalar @values == 2) {
		$sum += product @values;
	}
}

say $sum;
