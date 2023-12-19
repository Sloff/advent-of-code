use strict;
use warnings;
use feature ":5.34";
use FindBin;

use lib "$FindBin::Bin/../utils";

use Utils;

my $grid;

while (<>) {
	chomp;
	push @$grid, [split //];
}

my $row_len = @$grid;
my $col_len = @{$grid->[0]};

my ($s_row, $s_col);

for my $row (0..$row_len-1) {
	for my $col (0..$col_len-1) {
		if ($grid->[$row][$col] eq 'S') {
			$s_row = $row;
			$s_col = $col;
			last;
		}
	}
}

my %evens;
my %odds;

my @nodes = ([$s_row, $s_col]);

my $remainder = 26501365 % $col_len;
my ($v1, $v2, $v3);

for my $count (0..1000) {
	my $hash;

	if ($count % 2 == 0) {
		$hash = \%evens;
	} else {
		$hash = \%odds;
	}

	my @next_nodes;

	while (@nodes) {
		my ($row, $col) = @{shift @nodes};

		if (exists $hash->{"$row:$col"}) {
			next;
		}

		$hash->{"$row:$col"} = 1;

		if ($grid->[($row-1) % $row_len][$col % $col_len] ne '#') {
			push @next_nodes, [$row - 1, $col];
		}

		if ($grid->[($row+1) % $row_len][$col % $col_len] ne '#') {
			push @next_nodes, [$row + 1, $col];
		}

		if ($grid->[$row % $row_len][($col-1) % $col_len] ne '#') {
			push @next_nodes, [$row, $col - 1];
		}

		if ($grid->[$row % $row_len][($col+1) % $col_len] ne '#') {
			push @next_nodes, [$row, $col + 1];
		}
	}

	@nodes = @next_nodes;

	if ($count == $remainder) {
		$v1 = keys %{$hash};
	}

	if ($count == $col_len + $remainder) {
		$v2 = keys %{$hash};
	}

	if ($count == ($col_len * 2) + $remainder) {
		$v3 = keys %{$hash};
		last;
	}

}

say Utils::extrapolate_quadratic_from_3_points($v1, $v2, $v3, int(26501365 / $col_len));
