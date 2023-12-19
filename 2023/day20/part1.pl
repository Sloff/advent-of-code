use strict;
use warnings;
use feature ":5.34";

use constant {
	LOW => 0,
	HIGH => 1,

	ON => 1,
	OFF => 0,
};

my %modules;

my %inputs;

while (<>) {
	chomp;
	my ($module_and_type, $dest_modules_str) = /(.+) -> (.+)$/;
	my @dest_modules = split /, /, $dest_modules_str;
	my $module_name;

	if ($module_and_type eq 'broadcaster') {
		$module_name = $module_and_type;
		$modules{$module_name} = \@dest_modules;
	} else {
		my ($type, $_module_name) = $module_and_type =~ /^([%&])(\w+)$/;
		$module_name = $_module_name;

		$modules{$module_name} = [$type, \@dest_modules];
	}

	for my $dest (@dest_modules) {
		$inputs{$dest} //= [];
		push @{$inputs{$dest}}, $module_name;
	}
}

for my $key (keys %modules) {
	if ($key eq 'broadcaster') {
		next;
	}

	if ($modules{$key}->[0] eq '%') {
		push @{$modules{$key}}, OFF;
	} elsif ($modules{$key}->[0] eq '&') {
		my %state;

		for my $input_key (@{$inputs{$key}}) {
			$state{$input_key} = LOW;
		}

		push @{$modules{$key}}, \%state;
	}
}

my ($high_pulses, $low_pulses) = (0, 0);

for (1..1000) {
	my @signals_to_process = ([LOW, "broadcaster", "button"]);

	while (@signals_to_process) {
		my ($level, $module_name, $from) = @{shift @signals_to_process};
		
		if ($level == HIGH) {
			$high_pulses++;
		} else {
			$low_pulses++;
		}

		if (!exists $modules{$module_name}) {
			next;
		}

		my $module = $modules{$module_name};

		if ($module_name eq 'output') {
			next;
		}

		if ($module_name eq 'broadcaster') {
			for my $dest (@{$module}) {
				push @signals_to_process, [$level, $dest, $module_name];
			}
		} else {
			my $type = $module->[0];

			my $pulse;

			if ($type eq '%') {
				if ($level == HIGH) {
					next;
				}

				if ($module->[2] == OFF) {
					$pulse = HIGH;
					$module->[2] = ON;
				} else {
					$pulse = LOW;
					$module->[2] = OFF;
				}
			} else {
				$module->[2]->{$from} = $level;

				$pulse = LOW;

				for my $input_key (keys %{$module->[2]}) {
					if ($module->[2]->{$input_key} == LOW) {
						$pulse = HIGH;
						last;
					}
				}
			}

			for my $dest (@{$module->[1]}) {
				push @signals_to_process, [$pulse, $dest, $module_name];
			}
		}
	}
}

say $low_pulses * $high_pulses;
