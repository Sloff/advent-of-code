use strict;
use warnings;
use feature ":5.34";

use constant {
    UP => 1,
    DOWN => 2,
    LEFT => 4,
    RIGHT => 8,
};

my $grid;

while (<>) {
	chomp;
	push @$grid, [split //];
}

my $row_len = @$grid;
my $col_len = @{$grid->[0]};

sub get_energy_from_starting_point {
	my ($row_start, $col_start, $direction) = @_;
	my @locations_to_visit = ([$row_start, $col_start, $direction]);
	my %locations_visited;

	while (@locations_to_visit) {
		my $location = shift @locations_to_visit;
		my ($row, $col, $current_direction) = @$location;

		if ($row >= $row_len || $col >= $col_len || $col < 0 || $row < 0) {
			next;
		}

		$locations_visited{"$row:$col"} //= 0;
		if ($locations_visited{"$row:$col"} & $current_direction) {
			next;
		} else {
			$locations_visited{"$row:$col"} |= $current_direction;
		}


		my $char = $grid->[$row][$col];

		if ($char eq '.') {
			if ($current_direction == RIGHT) {
				push @locations_to_visit, [$row, $col + 1, $current_direction];
			} elsif ($current_direction == LEFT) {
				push @locations_to_visit, [$row, $col - 1, $current_direction];
			} elsif ($current_direction == UP) {
				push @locations_to_visit, [$row - 1, $col, $current_direction];
			} elsif ($current_direction == DOWN) {
				push @locations_to_visit, [$row + 1, $col, $current_direction];
			}
		} elsif ($char eq '/') {
			if ($current_direction == RIGHT) {
				push @locations_to_visit, [$row - 1, $col, UP];
			} elsif ($current_direction == LEFT) {
				push @locations_to_visit, [$row + 1, $col, DOWN];
			} elsif ($current_direction == UP) {
				push @locations_to_visit, [$row, $col + 1, RIGHT];
			} elsif ($current_direction == DOWN) {
				push @locations_to_visit, [$row, $col - 1, LEFT];
			}
		} elsif ($char eq '\\') {
			if ($current_direction == RIGHT) {
				push @locations_to_visit, [$row + 1, $col, DOWN];
			} elsif ($current_direction == LEFT) {
				push @locations_to_visit, [$row - 1, $col, UP];
			} elsif ($current_direction == UP) {
				push @locations_to_visit, [$row, $col - 1, LEFT];
			} elsif ($current_direction == DOWN) {
				push @locations_to_visit, [$row, $col + 1, RIGHT];
			}
		} elsif (($char eq '-' && ($current_direction == LEFT || $current_direction == RIGHT)) || ($char eq '|' && ($current_direction == UP || $current_direction == DOWN))) {
			if ($current_direction == RIGHT) {
				push @locations_to_visit, [$row, $col + 1, $current_direction];
			} elsif ($current_direction == LEFT) {
				push @locations_to_visit, [$row, $col - 1, $current_direction];
			} elsif ($current_direction == UP) {
				push @locations_to_visit, [$row - 1, $col, $current_direction];
			} elsif ($current_direction == DOWN) {
				push @locations_to_visit, [$row + 1, $col, $current_direction];
			}
		} elsif ($char eq '-') {
			push @locations_to_visit, [$row, $col - 1, LEFT];
			push @locations_to_visit, [$row, $col + 1, RIGHT];
		} elsif ($char eq '|') {
			push @locations_to_visit, [$row - 1, $col, UP];
			push @locations_to_visit, [$row + 1, $col, DOWN];
		}
	}

	my $count = keys %locations_visited;

	return $count;
}

my $biggest_energy = 0;
for my $row_start (0..$row_len-1) {
	my $energy = get_energy_from_starting_point($row_start, 0, RIGHT);
	$biggest_energy = $energy if $energy > $biggest_energy;

	$energy = get_energy_from_starting_point($row_start, $col_len-1, LEFT);
	$biggest_energy = $energy if $energy > $biggest_energy;
}

for my $col_start (0..$col_len-1) {
	my $energy = get_energy_from_starting_point(0, $col_start, DOWN);
	$biggest_energy = $energy if $energy > $biggest_energy;

	$energy = get_energy_from_starting_point($row_len-1, $col_start, UP);
	$biggest_energy = $energy if $energy > $biggest_energy;
}

say $biggest_energy;

