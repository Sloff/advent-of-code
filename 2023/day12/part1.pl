use strict;
use warnings;
use feature ":5.34";

my $result = 0;

while (<>) {
	say "Line $.";
	chomp;
	my ($line, $numbers) = split / /;

	my @numberGroups = map { "1{$_}" } split /,/, $numbers;

	my $lineRegex = $line =~ s/\./0/gr;
	$lineRegex =~ s/#/1/g;
	$lineRegex =~ s/\?/./g;

	my $numberGroupsRegex = "^0*" . (join "0+", @numberGroups) . '0*$';

	my $lineAsBinWithUnknown = $line =~ s/\./0/gr;
	$lineAsBinWithUnknown =~ s/#/1/g;

	my $numberOfUnknows = scalar(() = $line =~ /(\?)/g);

	my $currentBin = "0"x$numberOfUnknows;
	my $endingBin = "1"x$numberOfUnknows;

	my $length = length $currentBin;

	# my $ending = $line =~ s/[\.]/0/gr;
	# $ending =~ s/[#\?]/1/g;

	# say $numberGroupsRegex;

	# say $line;
	# say $lineAsBinWithUnknown;
	# say $lineRegex;

	my $count = 0;
	my $lineAsBin = $lineAsBinWithUnknown =~ s/\?/substr($currentBin, $count++, 1)/erg;
	# say $lineAsBin;
	$result++ if ($lineAsBin =~ /$lineRegex/ && $lineAsBin =~ /$numberGroupsRegex/);
	while ($currentBin != $endingBin) {
		my $number = oct("0b" . $currentBin);
		$number++;
		$currentBin = sprintf("%0${length}b", $number);
		$count = 0;
		$lineAsBin = $lineAsBinWithUnknown =~ s/\?/substr($currentBin, $count++, 1)/erg;
		# say $lineAsBin;
		$result++ if ($lineAsBin =~ /$lineRegex/ && $lineAsBin =~ /$numberGroupsRegex/);
	}

}

say $result;
