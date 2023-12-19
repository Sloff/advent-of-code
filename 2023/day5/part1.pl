use strict;
use warnings;
use feature ":5.34";

use List::Util "min";

local $/ = "";

my @paragraph = <>;

my @seeds = $paragraph[0] =~ /(\d+)/g;

sub getNewSeeds {
	my @mappingLines = @{shift @_};
	my @seeds = @{shift @_};

	my %mapped;

	for my $i (1..$#mappingLines) {
		my ($destStart, $sourceStart, $length) = $mappingLines[$i] =~ /(\d+)/g;

		for my $seedIndex (0..$#seeds) {
			my $seed = $seeds[$seedIndex];
			if (!$mapped{$seedIndex} && $seed >= $sourceStart && $seed < $sourceStart + $length) {
				my $offset = $seed - $sourceStart;
				@seeds[$seedIndex] = $destStart + $offset;
				$mapped{$seedIndex} = 1;
			}
		}
	}

	return @seeds;
}

my @seedToSoilLines = split /\n/, $paragraph[1];
@seeds = getNewSeeds(\@seedToSoilLines, \@seeds);

my @soilToFertLines = split /\n/, $paragraph[2];
@seeds = getNewSeeds(\@soilToFertLines, \@seeds);

my @fertToWaterLines = split /\n/, $paragraph[3];
@seeds = getNewSeeds(\@fertToWaterLines, \@seeds);

my @waterToLightLines = split /\n/, $paragraph[4];
@seeds = getNewSeeds(\@waterToLightLines, \@seeds);

my @lightToTempLines = split /\n/, $paragraph[5];
@seeds = getNewSeeds(\@lightToTempLines, \@seeds);

my @tempToHumLines = split /\n/, $paragraph[6];
@seeds = getNewSeeds(\@tempToHumLines, \@seeds);

my @humToLocLines = split /\n/, $paragraph[7];
@seeds = getNewSeeds(\@humToLocLines, \@seeds);

say min @seeds;
