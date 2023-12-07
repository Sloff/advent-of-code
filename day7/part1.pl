use strict;
use warnings;
use feature ":5.34";

my %values = (
	A => 1,
	K => 2,
	Q => 3,
	J => 4,
	T => 5,
	9 => 6,
	8 => 7,
	7 => 8,
	6 => 9,
	5 => 10,
	4 => 11,
	3 => 12,
	2 => 13,
);

my %handTypes = (
	five => [],
	four => [],
	full => [],
	three => [],
	two => [],
	one => [],
	high => [],
);

while (<>) {
	my ($hand, $bet) = /^(\S+)\s(\d+)$/;

	if ($hand =~ /(\S)\1{4}/) {
		push @{$handTypes{five}}, [$hand, $bet];
	} elsif ($hand =~ /(\S).*\1.*\1.*\1/) {
		push @{$handTypes{four}}, [$hand, $bet];
	} elsif ($hand =~ /(\S).*\1.*\1/ && $hand =~ /([^$1]).*\1/) {
		push @{$handTypes{full}}, [$hand, $bet];
	} elsif ($hand =~ /(\S).*\1.*\1/) {
		push @{$handTypes{three}}, [$hand, $bet];
	} elsif ($hand =~ /(\S).*\1/ && $hand =~ /([^$1]).*\1/) {
		push @{$handTypes{two}}, [$hand, $bet];
	} elsif ($hand =~ /(\S).*\1/) {
		push @{$handTypes{one}}, [$hand, $bet];
	} else {
		push @{$handTypes{high}}, [$hand, $bet];
	}
}

my $rankAmount = $.;
my $sum = 0;

for my $key ("five", "four", "full", "three", "two", "one", "high") {
	my @handsInGroup = @{$handTypes{$key}};

	my @sortedHands = sort {
		my @aLetters = split //, $a->[0];
		my @bLetters = split //, $b->[0];

		for my $i (0..$#aLetters) {
			if ($aLetters[$i] eq $bLetters[$i]) {
				next;
			}

			return $values{$aLetters[$i]} <=> $values{$bLetters[$i]};
		}

		return 0;
	} @handsInGroup;

	for my $handBet (@sortedHands) {
		$sum += $handBet->[1] * $rankAmount--;
	}
}

say $sum;
