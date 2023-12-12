use strict;
use warnings;
use List::Util qw(min);

use feature ":5.34";

$/ = "";

my $result = 0;

while (<>) {
	my @grid = map {[split //]} split /\n/;

	my $row_len = @grid;
	my $col_len = @{$grid[0]};

	my (%has_mirror_col, %has_mirror_row);

	$has_mirror_row{$_} = 1 for (0..$row_len-2);
	$has_mirror_col{$_} = 1 for (0..$col_len-2);

	my @grid_inverse;

	for my $row (0..$row_len-1) {
		for my $col (0..$col_len-1) {
			$grid_inverse[$col][$row] = $grid[$row][$col];
		}
	}

	for my $row (0..$row_len-1) {
		for my $col (0..$col_len-2) {

			my $amount = min($col, $col_len - 2 - $col);

			my @left = @{$grid[$row]}[($col - $amount)..$col];

			my $right_start = ($col - $amount + @left);
			my @right = reverse @{$grid[$row]}[$right_start..($right_start + @left - 1)];

			if (join('', @left) ne join('', @right)) {
				delete %has_mirror_col{$col};
			}
		}
	}

	my @col_keys = keys %has_mirror_col;

	if (scalar @col_keys == 1) {
		$result += $col_keys[0] + 1;
		next;
	}

	for my $col (0..$col_len-1) {
		for my $row (0..$row_len-2) {
			my $amount = min($row, $row_len - 2 - $row);

			my @left = @{$grid_inverse[$col]}[($row - $amount)..$row];

			my $right_start = ($row - $amount + @left);
			my @right = reverse @{$grid_inverse[$col]}[$right_start..($right_start + @left - 1)];

			if (join('', @left) ne join('', @right)) {
				delete %has_mirror_row{$row};
			}
		}
	}

	my @row_keys = keys %has_mirror_row;

	if (scalar @row_keys == 1) {
		$result += ($row_keys[0] + 1) * 100;
		next;
	}

	say "Woops";
}

say $result;
