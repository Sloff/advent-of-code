use strict;
use warnings;
use feature ":5.34";

my @grid;

while (<>) {
	chomp;
	push @grid, [split //];
}

my $rows_len = @grid;
my $col_len = @{$grid[0]};

my %col_index;
$col_index{$_} = 0 for 0..$col_len-1;

my $total = 0;

for my $row (0..$rows_len-1) {
	for my $col (0..$col_len-1) {
		my $char = $grid[$row][$col];

		if ($char eq '#') {
			$col_index{$col} = $row + 1;
			next;
		}

		if ($char eq 'O') {
			$total += $rows_len - $col_index{$col};
			$col_index{$col}++;
			next;
		}
	}
}

say $total;
