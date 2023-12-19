use strict;
use warnings;
use feature ":5.34";

use List::Util "min";

local $/ = "";

my @paragraph = <>;

my @seeds = $paragraph[0] =~ /(\d+ \d+)/g;

my @seedToSoilLines = split /\n/, $paragraph[1];
my @soilToFertLines = split /\n/, $paragraph[2];
my @fertToWaterLines = split /\n/, $paragraph[3];
my @waterToLightLines = split /\n/, $paragraph[4];
my @lightToTempLines = split /\n/, $paragraph[5];
my @tempToHumLines = split /\n/, $paragraph[6];
my @humToLocLines = split /\n/, $paragraph[7];

sub prevLoc {
	my @mappingLines = @{shift @_};
	my $loc = shift;

	for my $i (1..$#mappingLines) {
		my ($destStart, $sourceStart, $length) = $mappingLines[$i] =~ /(\d+)/g;

		if ($loc >= $destStart && $loc < $destStart + $length) {
			my $offset = $loc - $destStart;
			return $sourceStart + $offset;
		}
	}

	return $loc;
}

my $lower = 0;
my $prevGuess = 0;
my $guess = 0;
my $upper = 242892183;

while (1) {
	my $loc = prevLoc(\@humToLocLines, $guess);
	$loc = prevLoc(\@tempToHumLines, $loc);
	$loc = prevLoc(\@lightToTempLines, $loc);
	$loc = prevLoc(\@waterToLightLines, $loc);
	$loc = prevLoc(\@fertToWaterLines, $loc);
	$loc = prevLoc(\@soilToFertLines, $loc);
	$loc = prevLoc(\@seedToSoilLines, $loc);

	my $found = 0;

	for my $seedStr (@seeds) {
		my @seed = split / /, $seedStr;
		if ($loc >= $seed[0] && $loc < $seed[0] + $seed[1]) {
			$found = 1;

			$upper = $guess;
			$prevGuess = $guess;
			$guess = int(($lower + $guess) / 2);
		}
	}

	if (!$found) {
		$lower = $guess;
		$prevGuess = $guess;
		$guess = int(($upper + $guess) / 2);
	}

	if ($prevGuess == $guess) {
		say $upper;
		last
	}
}

