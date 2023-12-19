use strict;
use warnings;
use feature ":5.34";

$/ = "";

my %rules;

my $result = 0;

while (<>) {
	if ($. == 1) {
		for my $line (split /\n/) {
			my ($name, $rule_str) = $line =~ /(\w+)\{(.+)\}/;

			my @rules = split ',', $rule_str;

			for my $i (0..$#rules) {
				if ($rules[$i] =~ /[<>]/) {
					$rules[$i] = '$' . $rules[$i];
				}
			}

			$rules{$name} = \@rules;
		}
	} elsif ($. == 2) {
		for my $line (split /\n/) {
			my ($x, $m, $a, $s) = $line =~ /x=(\d+),m=(\d+),a=(\d+),s=(\d+)/;

			my $key = 'in';

			while ($key ne 'A' && $key ne 'R') {
				my @workflow = @{$rules{$key}};

				for my $i (0..$#workflow) {
					if ($workflow[$i] =~ /[<>]/) {
						my ($condition, $condition_key) = split /:/, $workflow[$i];

						if (eval $condition) {
							$key = $condition_key;
							last;
						}
					} else {
						$key = $workflow[$i];
					}
				}

			}

			if ($key eq 'A') {
				$result += $x + $m + $a + $s;
			}
		}
	}
}

say $result;
