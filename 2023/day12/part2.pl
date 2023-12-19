use strict;
use warnings;
use feature ":5.34";
use feature 'state';

sub count {
	state %cache;
	my ($line, $numbers, $index, $numbers_index) = @_;

	if ($index < length($line) && $numbers_index < @$numbers) {
		my $cache_key = substr($line, $index) . "[" . join(",", @{$numbers}[$numbers_index..$#{$numbers}]) . "]";

		return $cache{$cache_key} if exists $cache{$cache_key};

		my $count = inner_count($line, $numbers, $index, $numbers_index);
		$cache{$cache_key} = $count;
		return $count;
	}
	return inner_count($line, $numbers, $index, $numbers_index);
}

sub inner_count {

	my ($line, $numbers, $index, $numbers_index) = @_;

	return 1 if $index >= length($line) && $numbers_index >= @$numbers;
	return 0 if $index >= length($line) || $numbers_index > @$numbers;

	my $char = substr $line, $index, 1;

	if ($char eq '.') {
		return count($line, $numbers, $index + 1, $numbers_index);
	}

	if ($char eq '#' && ($numbers_index < @$numbers)) {
		my $valid = 1;

		for my $i ($index..$index + $numbers->[$numbers_index] - 1) {
			if ($i >= length $line) {
				return 0;
			}
			my $check = substr $line, $i, 1;
			$valid = $check eq '#' || $check eq '?';
			substr($line, $i, 1) = '#' if $valid;
			last if !$valid;
		}

		my $next_index = $index + $numbers->[$numbers_index];
		$valid = $valid && ($index + $numbers->[$numbers_index] >= length($line) || substr($line, $next_index, 1) eq '.' || substr($line, $next_index, 1) eq '?');

		if ($valid) {
			return count($line, $numbers, $next_index + 1, $numbers_index + 1);
		} else {
			return 0;
		}
	}

	if ($char eq '?' && ($numbers_index <= @$numbers)) {
		# Handle as .
		my $new_line = $line;
		substr($new_line, $index, 1) = '.';
		my $count = count($new_line, $numbers, $index + 1, $numbers_index);

		if ($numbers_index < @$numbers) {
			substr($line, $index, 1) = "#";
			$count += count($line, $numbers, $index, $numbers_index);
		}
		return $count;
	}
}

my $result = 0;

while (<>) {
	chomp;
	my ($line, $numbers) = split / /;
	my @number_groups = split /,/, $numbers;

	$result += count($line, \@number_groups, 0, 0);
}

say $result;
