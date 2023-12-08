use strict;
use warnings;
use feature ":5.34";

my @input = <>;

my @operations = split //, $input[0];

my %map;

for my $lineIndex (2..$#input) {
	my $line = $input[$lineIndex];
	my ($key, $lLoc, $rLoc) = $line =~ /(\w{3}).*\((\w{3}), (\w{3})\)/;
	$map{$key} = [$lLoc, $rLoc];
}

my @currentNode = @{$map{"AAA"}};

my %letterToIndex = (
	L => 0,
	R => 1,
);

my $step = 0;

while (1) {
	my $index = $letterToIndex{$operations[$step++ % $#operations]};
	my $key = $currentNode[$index];
	last if $key eq "ZZZ";
	@currentNode = @{$map{$key}};
}

say $step;
