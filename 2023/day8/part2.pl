use strict;
use warnings;
use feature ":5.34";

my @input = <>;

my @operations = split //, $input[0];

my %map;

my @currentNodes;

for my $lineIndex (2..$#input) {
	my $line = $input[$lineIndex];
	my ($key, $lLoc, $rLoc) = $line =~ /(\w{3}).*\((\w{3}), (\w{3})\)/;
	$map{$key} = [$lLoc, $rLoc];

	if ($key =~ /A$/) {
		push @currentNodes, $map{$key};
	}
}

my %letterToIndex = (
	L => 0,
	R => 1,
);

sub gcd {
	my ($a, $b) = @_;
	while ($b) {
		($a, $b) = ($b, $a % $b);
	}

	return $a;
}

sub lcm {
	my ($a, $b) = @_;
	return ($a * $b) / gcd($a, $b);
}

my @stepsToZ;

for my $currentNodeRef (@currentNodes) {
	my @currentNode = @{$currentNodeRef};
	my $step = 0;

	while (1) {
		my $index = $letterToIndex{$operations[$step++ % $#operations]};
		my $key = $currentNode[$index];
		last if $key =~ /Z$/;
		@currentNode = @{$map{$key}};
	}

	push @stepsToZ, $step;
}

my $result = $stepsToZ[0];

for my $i (1..$#stepsToZ) {
	$result = lcm($result, $stepsToZ[$i])
}

say $result;
