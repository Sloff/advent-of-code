use strict;
use warnings;
use feature ":5.34";

if (@ARGV < 2) {
	die "Need an expansion amount and an input file";
}

my $expansionAmount = shift;

my @lines;

my %rowHasGalaxy;
my %colHasGalaxy;

while (<>) {
	chomp;
	if ($_ =~ /#/) {
		$rowHasGalaxy{$. - 1} = 1;
		while (/(#)/g) {
			$colHasGalaxy{$-[0]} = 1;
		}
	}
	push @lines, [split //];
}

my @galaxyLocations;
my $rowOffset = 0;

for my $row (0..$#lines) {
	if (!$rowHasGalaxy{$row}) {
		$rowOffset += $expansionAmount - 1;
		next;
	}

	my $colOffset = 0;
	for my $col (0..$#{$lines[$row]}) {
		if (!$colHasGalaxy{$col}) {
			$colOffset += $expansionAmount - 1;
			next;
		}

		if ($lines[$row][$col] =~ /#/) {
			push @galaxyLocations, [$row + $rowOffset, $col + $colOffset];
		}
	}
}

my $result = 0;

while (@galaxyLocations) {
	my $location = shift @galaxyLocations;

	for my $otherLocation (@galaxyLocations) {
		$result += abs($otherLocation->[0] - $location->[0]);
		$result += abs($otherLocation->[1] - $location->[1]);
	}
}

say $result;
