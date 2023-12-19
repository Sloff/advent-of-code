use strict;
use warnings;
use feature ":5.34";

use List::PriorityQueue;

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

my $nodes_to_explore = new List::PriorityQueue;
$nodes_to_explore->insert([0, 0, 0, 0], 0);

my %cost_so_far;
$cost_so_far{"0:0:0:0"} = 0;

while (1) {
	my $node = $nodes_to_explore->pop();
	my ($row, $col, $direction, $direction_count) = @$node;

	my $current_key = "$row:$col:$direction:$direction_count";

	if ($row == $row_len - 1 && $col == $col_len - 1) {
		say $cost_so_far{$current_key};
		last;
	}

	my $can_up = ($direction == UP && $direction_count < 3) || ($direction != UP && $direction != DOWN);
	my $can_down = ($direction == DOWN && $direction_count < 3) || ($direction != DOWN && $direction != UP);
	my $can_left = ($direction == LEFT && $direction_count < 3) || ($direction != LEFT && $direction != RIGHT);
	my $can_right = ($direction == RIGHT && $direction_count < 3) || ($direction != RIGHT && $direction != LEFT);

	if ($row > 0 && $can_up) {
		my $new_row = $row - 1;
		my $new_col = $col;
		my $new_cost = $cost_so_far{$current_key} + $grid->[$new_row][$new_col];

		my $new_direction_count = $direction_count;

		$new_direction_count++ if $direction == UP;
		$new_direction_count = 1 if $direction != UP;
		my $new_key = "$new_row:$new_col:" . UP . ":$new_direction_count";

		if (!exists $cost_so_far{$new_key} || $new_cost < $cost_so_far{$new_key}) {
			$cost_so_far{$new_key} = $new_cost;
			$nodes_to_explore->insert([$new_row, $new_col, UP, $new_direction_count], $new_cost);
		}
	}

	if ($row < $row_len - 1 && $can_down) {
		my $new_row = $row + 1;
		my $new_col = $col;
		my $new_cost = $cost_so_far{$current_key} + $grid->[$new_row][$new_col];

		my $new_direction_count = $direction_count;

		$new_direction_count++ if $direction == DOWN;
		$new_direction_count = 1 if $direction != DOWN;
		my $new_key = "$new_row:$new_col:" . DOWN . ":$new_direction_count";

		if (!exists $cost_so_far{$new_key} || $new_cost < $cost_so_far{$new_key}) {
			$cost_so_far{$new_key} = $new_cost;
			$nodes_to_explore->insert([$new_row, $new_col, DOWN, $new_direction_count], $new_cost);
		}
	} 

	if ($col > 0 && $can_left) {
		my $new_row = $row;
		my $new_col = $col - 1;
		my $new_cost = $cost_so_far{$current_key} + $grid->[$new_row][$new_col];

		my $new_direction_count = $direction_count;

		$new_direction_count++ if $direction == LEFT;
		$new_direction_count = 1 if $direction != LEFT;
		my $new_key = "$new_row:$new_col:" . LEFT . ":$new_direction_count";

		if (!exists $cost_so_far{$new_key} || $new_cost < $cost_so_far{$new_key}) {
			$cost_so_far{$new_key} = $new_cost;
			$nodes_to_explore->insert([$new_row, $new_col, LEFT, $new_direction_count], $new_cost);
		}
	}

	if ($col < $col_len - 1 && $can_right) {
		my $new_row = $row;
		my $new_col = $col + 1;
		my $new_cost = $cost_so_far{$current_key} + $grid->[$new_row][$new_col];

		my $new_direction_count = $direction_count;

		$new_direction_count++ if $direction == RIGHT;
		$new_direction_count = 1 if $direction != RIGHT;
		my $new_key = "$new_row:$new_col:" . RIGHT . ":$new_direction_count";

		if (!exists $cost_so_far{$new_key} || $new_cost < $cost_so_far{$new_key}) {
			$cost_so_far{$new_key} = $new_cost;
			$nodes_to_explore->insert([$new_row, $new_col, RIGHT, $new_direction_count], $new_cost);
		}
	}
}
