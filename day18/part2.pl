use strict;
use warnings;
use feature ":5.34";

my %direction_num_to_direction = (
	0 => 'R',
	1 => 'D',
	2 => 'L',
	3 => 'U',
);

while (<>) {
	chomp;
	my ($hex_num, $direction_num) = /\(#(.{5})(\d)\)/;
	my $num = hex($hex_num);
	say "$direction_num_to_direction{$direction_num} $num";
}
