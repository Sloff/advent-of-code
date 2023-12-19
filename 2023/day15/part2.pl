use strict;
use warnings;
use feature ":5.34";

$/ = ",";

my %boxes;

while (<>) {
	s/[\n,]//g;
	my ($label, $operator, $focal) = /(\w+)([-=])(\d*)?/;

	my $label_value = 0;
	for my $letter (split //, $label) {
		$label_value += ord($letter);
		$label_value *= 17;
		$label_value %= 256;
	}

	$boxes{$label_value} //= [];
	my $found_index = -1;

	for my $i (0..$#{$boxes{$label_value}} ) {
		if ($label eq $boxes{$label_value}->[$i][0]) {
			$found_index = $i;
		}
	}

	if ($operator eq '-') {
		if ($found_index != -1) {
			splice @{$boxes{$label_value}}, $found_index, 1;
		}
	} elsif ($operator eq '=') {
		if ($found_index != -1) {
			splice @{$boxes{$label_value}}, $found_index, 1, [$label, $focal];
		} else {
			push @{$boxes{$label_value}}, [$label, $focal];
		}
	}
}

my $result = 0;

for my $i (0..255) {
	next if !exists $boxes{$i};
	my $lenses = $boxes{$i};

	for my $lense_index (0..$#$lenses) {
		my $amount = $i + 1;
		$amount *= $lense_index + 1;
		$amount *= $lenses->[$lense_index][1];
		$result += $amount;
	}
}

say $result;
