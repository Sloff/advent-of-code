use strict;
use warnings;
use feature ":5.34";

my %values = (
	A => 1,
	K => 2,
	Q => 3,
	T => 5,
	9 => 6,
	8 => 7,
	7 => 8,
	6 => 9,
	5 => 10,
	4 => 11,
	3 => 12,
	2 => 13,
	J => 14,
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

my %numberToType = (
	1 => "five",
	2 => "four",
	3 => "full",
	4 => "three",
	5 => "two",
	6 => "one",
	7 => "high"
);

sub getTypeNum {
	my $hand = shift;
	if ($hand =~ /(\S)\1{4}/) {
		return 1;
	} elsif ($hand =~ /(\S).*\1.*\1.*\1/) {
		return 2;
	} elsif ($hand =~ /(\S).*\1.*\1/ && $hand =~ /([^$1]).*\1/) {
		return 3;
	} elsif ($hand =~ /(\S).*\1.*\1/) {
		return 4;
	} elsif ($hand =~ /(\S).*\1/ && $hand =~ /([^$1]).*\1/) {
		return 5;
	} elsif ($hand =~ /(\S).*\1/) {
		return 6;
	} 

	return 7;
}

while (<>) {
	my ($hand, $bet) = /^(\S+)\s(\d+)$/;

	if ($hand =~ /J/) {
		my $lowest = 7;
		for my $jVal (keys %values) {
			my $handWithJoker = $hand =~ s/J/$jVal/gr;

			my $handTypeValue = getTypeNum($handWithJoker);

			$lowest = $handTypeValue if $lowest > $handTypeValue;
			next if $lowest == 1;
		}

		push @{$handTypes{$numberToType{$lowest}}}, [$hand, $bet];
	} else {
		my $handTypeValue = getTypeNum($hand);
		push @{$handTypes{$numberToType{$handTypeValue}}}, [$hand, $bet];
	}

}

my $rankAmount = $.;
my $sum = 0;

for my $keyNum (1..7) {
	my $key = $numberToType{$keyNum};
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
		my ($hand, $bet) = @{$handBet};
		$sum += $bet * $rankAmount--;
	}
}

say $sum;
