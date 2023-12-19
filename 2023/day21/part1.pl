use strict;
use warnings;
use feature ":5.34";

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

for my $count (0..64) {
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

		if ($row > 0 && $grid->[$row-1][$col] ne '#') {
			push @next_nodes, [$row - 1, $col];
		}

		if ($row < $row_len - 1 && $grid->[$row+1][$col] ne '#') {
			push @next_nodes, [$row + 1, $col];
		}

		if ($col > 0 && $grid->[$row][$col-1] ne '#') {
			push @next_nodes, [$row, $col - 1];
		}

		if ($col < $col_len - 1 && $grid->[$row][$col+1] ne '#') {
			push @next_nodes, [$row, $col + 1];
		}
	}

	@nodes = @next_nodes;

}

my $evens_count = keys %evens;
say $evens_count;
