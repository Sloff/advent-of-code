use strict;
use warnings;
use feature ":5.34";

my @initial_grid;

while (<>) {
	chomp;
	push @initial_grid, [split //];
}


sub new_grid {
	my ($grid_ref) = @_;
	my @grid = @$grid_ref;

	my $rows_len = @grid;
	my $col_len = @{$grid[0]};

	my %col_index;
	my %row_index;

	# North
	$col_index{$_} = 0 for 0..$col_len-1;
	for my $row (0..$rows_len-1) {
		for my $col (0..$col_len-1) {
			my $char = $grid[$row][$col];

			if ($char eq '#') {
				$col_index{$col} = $row + 1;
				next;
			}

			if ($char eq 'O') {
				$grid[$row][$col] = '.';
				$grid[$col_index{$col}++][$col] = 'O';
				next;
			}
		}
	}

	# West
	$row_index{$_} = 0 for 0..$rows_len-1;
	for my $row (0..$rows_len-1) {
		for my $col (0..$col_len-1) {
			my $char = $grid[$row][$col];

			if ($char eq '#') {
				$row_index{$row} = $col + 1;
				next;
			}

			if ($char eq 'O') {
				$grid[$row][$col] = '.';
				$grid[$row][$row_index{$row}++] = 'O';
				next;
			}
		}
	}

	# South
	$col_index{$_} = $col_len - 1 for 0..$col_len-1;
	for my $row (reverse 0..$rows_len-1) {
		for my $col (0..$col_len-1) {
			my $char = $grid[$row][$col];

			if ($char eq '#') {
				$col_index{$col} = $row - 1;
				next;
			}

			if ($char eq 'O') {
				$grid[$row][$col] = '.';
				$grid[$col_index{$col}--][$col] = 'O';
				next;
			}
		}
	}

	# West
	$row_index{$_} = $rows_len - 1 for 0..$rows_len-1;
	for my $row (0..$rows_len-1) {
		for my $col (reverse 0..$col_len-1) {
			my $char = $grid[$row][$col];

			if ($char eq '#') {
				$row_index{$row} = $col - 1;
				next;
			}

			if ($char eq 'O') {
				$grid[$row][$col] = '.';
				$grid[$row][$row_index{$row}--] = 'O';
				next;
			}
		}
	}

	return @grid;
}

my $amount = 1000000000;

my @rotated_grid = @initial_grid;

my %found;
my $loop_start = 0;
my $loop_end = 0;
my $count = 0;

while (!$loop_end) {
	my $key = join "", map {join "", @$_} @rotated_grid;
	if (exists $found{$key}) {
		$loop_start = $found{$key};
		$loop_end = $count;
	}

	$found{$key} = $count++;

	say "$count / $amount";
	@rotated_grid = new_grid(\@rotated_grid);
}

my $loop_len = $loop_end - $loop_start;

my $ratio = int($amount / $loop_len) - $loop_start;

for my $count2 (($ratio * $loop_len) + $loop_start + 2..$amount) {
	say "$count2 / $amount";
	@rotated_grid = new_grid(\@rotated_grid);
}

my $total = 0;

my $rows_len = @rotated_grid;
my $col_len = @{$rotated_grid[0]};

for my $row (0..$rows_len-1) {
	for my $col (0..$col_len-1) {
		my $char = $rotated_grid[$row][$col];
		if ($char eq 'O') {
			$total += $rows_len - $row;
			next;
		}
	}
}

say $total;
