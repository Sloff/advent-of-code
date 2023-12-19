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
		say $distance;
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
