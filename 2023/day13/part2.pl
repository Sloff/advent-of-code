use strict;
use warnings;
use List::Util qw(min);

use feature ":5.34";

$/ = "";

sub get_value {
	my ($grid_ref, $initial_result) = @_;

	my @grid = @{$grid_ref};

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
			if (!$has_mirror_col{$col}) {
				next;
			}

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

	if (scalar @col_keys >= 1) {
		for my $key (@col_keys) {
			return $key + 1 if $key + 1 != $initial_result;
		}
	}

	for my $col (0..$col_len-1) {
		for my $row (0..$row_len-2) {
			if (!$has_mirror_row{$row}) {
				next;
			}

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

	if (scalar @row_keys >= 1) {
		for my $key (@row_keys) {
			return ($key + 1) * 100 if ($key + 1) * 100 != $initial_result;
		}
	}
	
	return 0;
}

sub get_other_value {
	my ($grid_ref, $initial_result) = @_;
	my @grid = @$grid_ref;

	my $row_len = @grid;
	my $col_len = @{$grid[0]};

	my $new_result;

	for my $row (0..$row_len-1) {
		for my $col (0..$col_len-1) {
			my $char = $grid[$row][$col];

			$grid[$row][$col] = '.' if $char eq '#';
			$grid[$row][$col] = '#' if $char eq '.';

			$new_result = get_value(\@grid, $initial_result);

			return $new_result if $new_result != 0 && $new_result != $initial_result;

			$grid[$row][$col] = $char;
		}
	}

	say "Woops";
	return 0;
}

my $result = 0;

while (<>) {
	my @grid = map {[split //]} split /\n/;

	my $initial_result = get_value(\@grid, 0);

	$result += get_other_value(\@grid, $initial_result);
}

say $result;
