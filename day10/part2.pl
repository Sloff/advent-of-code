use strict;
use warnings;
use feature ":5.34";

my @grid;

my ($startRow, $startCol);
my $length;

while (<>) {
	chomp;
	if (/S/) {
		$startRow = $. - 1;
		$startCol = $-[0];
	}
	push @grid, [split //];

	if (!defined $length) {
		$length = scalar @{$grid[0]};
	}
}

my @canGoUp = ("|", "L", "J", "S");
my @fromBottom = ("|", "7", "F", "S");

my @canGoLeft = ("-", "J", "7", "S");
my @fromRight = ("-", "L", "F", "S");

my @canGoDown = ("|", "7", "F", "S");
my @fromTop = ("|", "L", "J", "S");

my @canGoRight = ("-", "L", "F", "S");
my @fromLeft = ("-", "J", "7", "S");

my (%alreadyChecked, %nodeInPath);

my @nodesToCheck = ([$startRow, $startCol, 0]);

while (@nodesToCheck) {
	my $thisNode = shift @nodesToCheck;
	my ($row, $col, $distance) = @{$thisNode};

	if ($nodeInPath{"$row:$col"}) {
		last;
	} else {
		$nodeInPath{"$row:$col"} = 1;
	}

	my $thisLetter = $grid[$row][$col];

	if ($row != 0 && grep { $_ eq $thisLetter } @canGoUp) {
		my $newLetterRow = $row - 1;
		my $newLetterCol = $col;
		my $newLetter = $grid[$newLetterRow][$newLetterCol];

		if (!$alreadyChecked{"$newLetterRow:$newLetterCol"} && grep { $_ eq $newLetter } @fromBottom) {
			push @nodesToCheck, [$newLetterRow, $newLetterCol, $distance + 1];
		}
	}

	if ($row != $#grid && grep { $_ eq $thisLetter } @canGoDown) {
		my $newLetterRow = $row + 1;
		my $newLetterCol = $col;
		my $newLetter = $grid[$newLetterRow][$newLetterCol];

		if (!$alreadyChecked{"$newLetterRow:$newLetterCol"} && grep { $_ eq $newLetter } @fromTop) {
			push @nodesToCheck, [$newLetterRow, $newLetterCol, $distance + 1];
		}
	}

	if ($col != 0 && grep { $_ eq $thisLetter } @canGoLeft) {
		my $newLetterRow = $row;
		my $newLetterCol = $col - 1;
		my $newLetter = $grid[$newLetterRow][$newLetterCol];

		if (!$alreadyChecked{"$newLetterRow:$newLetterCol"} && grep { $_ eq $newLetter } @fromRight) {
			push @nodesToCheck, [$newLetterRow, $newLetterCol, $distance + 1];
		}
	}

	if ($col != $length && grep { $_ eq $thisLetter } @canGoRight) {
		my $newLetterRow = $row;
		my $newLetterCol = $col + 1;
		my $newLetter = $grid[$newLetterRow][$newLetterCol];

		if (!$alreadyChecked{"$newLetterRow:$newLetterCol"} && grep { $_ eq $newLetter } @fromLeft) {
			push @nodesToCheck, [$newLetterRow, $newLetterCol, $distance + 1];
		}
	}

	$alreadyChecked{"$row:$col"} = 1;
}

my @expandedGrid;

for my $row (0..$#grid) {
	push @expandedGrid, [split //, "-" . "|-"x$length];
	for my $col (0..$length-1) {
		push @{$expandedGrid[($row*2)+1]}, "-";
		if (!$nodeInPath{"$row:$col"}) {
			push @{$expandedGrid[($row*2)+1]}, "I";
		} else {
			if ($grid[$row][$col] eq "S") {
				$startRow = ($row*2)+1;
				$startCol = ($col*2)+1;
			}
			push @{$expandedGrid[($row*2)+1]}, $grid[$row][$col];
		}

		if ($col == $length - 1) {
			push @{$expandedGrid[($row*2)+1]}, "-";
		}
	}
}
push @expandedGrid, [split //, "-" . "|-"x$length];

my (%exAlreadyChecked, %exNodeInPath);

my @exNodesToCheck = ([$startRow, $startCol]);
my $exLength = scalar @{$expandedGrid[0]};

while (@exNodesToCheck) {
	my $thisNode = shift @exNodesToCheck;
	my ($row, $col) = @{$thisNode};

	if ($exNodeInPath{"$row:$col"}) {
		last;
	} else {
		$exNodeInPath{"$row:$col"} = 1;
	}

	my $thisLetter = $expandedGrid[$row][$col];

	if ($row != 0 && grep { $_ eq $thisLetter } @canGoUp) {
		my $newLetterRow = $row - 1;
		my $newLetterCol = $col;
		my $newLetter = $expandedGrid[$newLetterRow][$newLetterCol];

		if (!$exAlreadyChecked{"$newLetterRow:$newLetterCol"} && grep { $_ eq $newLetter } @fromBottom) {
			push @exNodesToCheck, [$newLetterRow, $newLetterCol];
		}
	}

	if ($row != $#expandedGrid && grep { $_ eq $thisLetter } @canGoDown) {
		my $newLetterRow = $row + 1;
		my $newLetterCol = $col;
		my $newLetter = $expandedGrid[$newLetterRow][$newLetterCol];

		if (!$exAlreadyChecked{"$newLetterRow:$newLetterCol"} && grep { $_ eq $newLetter } @fromTop) {
			push @exNodesToCheck, [$newLetterRow, $newLetterCol];
		}
	}

	if ($col != 0 && grep { $_ eq $thisLetter } @canGoLeft) {
		my $newLetterRow = $row;
		my $newLetterCol = $col - 1;
		my $newLetter = $expandedGrid[$newLetterRow][$newLetterCol];

		if (!$exAlreadyChecked{"$newLetterRow:$newLetterCol"} && grep { $_ eq $newLetter } @fromRight) {
			push @exNodesToCheck, [$newLetterRow, $newLetterCol];
		}
	}

	if ($col != $exLength && grep { $_ eq $thisLetter } @canGoRight) {
		my $newLetterRow = $row;
		my $newLetterCol = $col + 1;
		my $newLetter = $expandedGrid[$newLetterRow][$newLetterCol];

		if (!$exAlreadyChecked{"$newLetterRow:$newLetterCol"} && grep { $_ eq $newLetter } @fromLeft) {
			push @exNodesToCheck, [$newLetterRow, $newLetterCol];
		}
	}

	$exAlreadyChecked{"$row:$col"} = 1;
}

my @outsideNodesToCheck = ([0, 0]);

while (@outsideNodesToCheck) {
	my $thisNode = shift @outsideNodesToCheck;
	my ($row, $col) = @{$thisNode};

	if ($expandedGrid[$row][$col] eq "O") {
		next;
	}

	$expandedGrid[$row][$col] = "O";

	if ($row != 0) {
		my $newLetterRow = $row - 1;
		my $newLetterCol = $col;
		my $newLetter = $expandedGrid[$newLetterRow][$newLetterCol];

		if (!$exNodeInPath{"$newLetterRow:$newLetterCol"} && $newLetter ne "O") {
			push @outsideNodesToCheck, [$newLetterRow, $newLetterCol];
		}
	}

	if ($row != $#expandedGrid) {
		my $newLetterRow = $row + 1;
		my $newLetterCol = $col;
		my $newLetter = $expandedGrid[$newLetterRow][$newLetterCol];

		if (!$exNodeInPath{"$newLetterRow:$newLetterCol"} && $newLetter ne "O") {
			push @outsideNodesToCheck, [$newLetterRow, $newLetterCol];
		}
	}

	if ($col != 0) {
		my $newLetterRow = $row;
		my $newLetterCol = $col - 1;
		my $newLetter = $expandedGrid[$newLetterRow][$newLetterCol];

		if (!$exNodeInPath{"$newLetterRow:$newLetterCol"} && $newLetter ne "O") {
			push @outsideNodesToCheck, [$newLetterRow, $newLetterCol];
		}
	}

	if ($col != $exLength - 1) {
		my $newLetterRow = $row;
		my $newLetterCol = $col + 1;
		my $newLetter = $expandedGrid[$newLetterRow][$newLetterCol];

		if (!$exNodeInPath{"$newLetterRow:$newLetterCol"} && $newLetter ne "O") {
			push @outsideNodesToCheck, [$newLetterRow, $newLetterCol];
		}
	}
}

my $result = 0;
for my $row (0..$#expandedGrid) {
	my @expGridRow = @{$expandedGrid[$row]};
	$result += grep /I/, @expGridRow;
}

say $result;
