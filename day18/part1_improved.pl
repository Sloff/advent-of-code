use strict;
use warnings;
use feature ":5.34";

use List::Util qw(sum);

my ($digger_row, $digger_col) = (0, 0);

my @digger_locations = ([0, 0]);

while (<>) {
	chomp;
	my ($direction, $amount) = /^(\w)\s+(\d+)/;

	if ($direction eq 'R') {
		$digger_col += $amount;
	} elsif ($direction eq 'L') {
		$digger_col -= $amount;
	} elsif ($direction eq 'U') {
		$digger_row -= $amount;
	} elsif ($direction eq 'D') {
		$digger_row += $amount;
	}

	push @digger_locations, [$digger_row, $digger_col];
}

sub distance {
	my ($x1, $y1, $x2, $y2) = @_;

	return sqrt(($x2 - $x1)**2 + ($y2 - $y1)**2);
}

sub calculate_area {
	my @points = @_;
	my $n = scalar @points;

	my $area = 0;
	my $edge_len = 0;

	for my $i (0..$n-1) {
		my $j = ($i + 1) % $n;

		$area += $points[$i][0] * $points[$j][1];
		$area -= $points[$i][1] * $points[$j][0];

		$edge_len += distance($points[$i][0], $points[$i][1], $points[$j][0], $points[$j][1])
	}

	return (abs($area) / 2) + ($edge_len / 2) + 1;
}

say calculate_area(@digger_locations);
