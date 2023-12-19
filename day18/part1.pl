use strict;
use warnings;
use feature ":5.34";

my ($top, $left, $right, $bottom) = (0, 0, 0, 0);

my %trench;
$trench{"0:0"} = 1;

my ($digger_row, $digger_col) = (0, 0);

while (<>) {
	chomp;
	my ($direction, $amount) = /^(\w)\s+(\d+)/;
	
	if ($direction eq 'R') {
		for (1..$amount) {
			$digger_col++;
			$trench{"$digger_row:$digger_col"} = 1;
		}

		$right = $digger_col if $digger_col > $right;
	} elsif ($direction eq 'L') {
		for (1..$amount) {
			$digger_col--;
			$trench{"$digger_row:$digger_col"} = 1;
		}

		$left = $digger_col if $digger_col < $left;
	} elsif ($direction eq 'U') {
		for (1..$amount) {
			$digger_row--;
			$trench{"$digger_row:$digger_col"} = 1;
		}

		$top = $digger_row if $digger_row < $top;
	} elsif ($direction eq 'D') {
		for (1..$amount) {
			$digger_row++;
			$trench{"$digger_row:$digger_col"} = 1;
		}

		$bottom = $digger_row if $digger_row > $bottom;
	}
}

my @nodes_to_check;

my $amount_not_dug = 0;
for my $row ($top..$bottom) {
	if (!$trench{"$row:$left"}) {
		push @nodes_to_check, [$row, $left];
	}

	if (!$trench{"$row:$right"}) {
		push @nodes_to_check, [$row, $right];
	}
}

for my $col ($left..$right) {
	if (!$trench{"$top:$col"}) {
		push @nodes_to_check, [$top, $col];
	}

	if (!$trench{"$bottom:$col"}) {
		push @nodes_to_check, [$bottom, $col];
	}
}

my %checked;

while (@nodes_to_check) {
	my $node_to_check = shift @nodes_to_check;
	my ($row, $col) = @$node_to_check;
	
	if (exists $checked{"$row:$col"}) {
		next;
	}

	$checked{"$row:$col"} = 1;

	if ($trench{"$row:$col"}) {
		next;
	} else {
		$amount_not_dug++;

		push @nodes_to_check, [$row - 1, $col] if $row > $top;
		push @nodes_to_check, [$row + 1, $col] if $row < $bottom;
		push @nodes_to_check, [$row, $col - 1] if $col > $left;
		push @nodes_to_check, [$row, $col + 1] if $col < $right;
	}
}

my $result = (abs($bottom - $top + 1) * abs($right - $left + 1)) - $amount_not_dug;

# for my $row (@grid) {
# 	for my $col (@$row) {
# 		$result++ if $col ne 'O';
# 	}
# }

say $result;
