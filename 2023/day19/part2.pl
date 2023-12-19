use strict;
use warnings;
use feature ":5.34";

$/ = "";

my %rules;

sub get_len {
	my ($i, $j) = @_;

	return $j - $i + 1;
}

sub get_combinations {
	my ($key, $x_range, $m_range, $a_range, $s_range) = @_;

	if ($key eq 'A') {
		return get_len(@$x_range) * get_len(@$m_range) * get_len(@$a_range) * get_len(@$s_range);
	}

	if ($key eq 'R') {
		return 0;
	}

	my @workflow = @{$rules{$key}};

	my @this_x_range = @$x_range;
	my @this_m_range = @$m_range;
	my @this_a_range = @$a_range;
	my @this_s_range = @$s_range;

	my @other_x_range = @$x_range;
	my @other_m_range = @$m_range;
	my @other_a_range = @$a_range;
	my @other_s_range = @$s_range;

	my $result = 0;

	for my $i (0..$#workflow) {
		if ($workflow[$i] =~ /[<>]/) {
			my ($condition, $condition_key) = split /:/, $workflow[$i];

			my ($amount) = $condition =~ /\w[<>](\d+)$/;

			if ($condition =~ /x</) {
				$this_x_range[1] = $amount - 1;
				$other_x_range[0] = $amount;
				$result += get_combinations($condition_key, \@this_x_range, \@this_m_range, \@this_a_range, \@this_s_range);
			} elsif ($condition =~ /x>/) {
				$this_x_range[0] = $amount + 1;
				$other_x_range[1] = $amount;
				$result += get_combinations($condition_key, \@this_x_range, \@this_m_range, \@this_a_range, \@this_s_range);
			} elsif ($condition =~ /m</) {
				$this_m_range[1] = $amount - 1;
				$other_m_range[0] = $amount;
				$result += get_combinations($condition_key, \@this_x_range, \@this_m_range, \@this_a_range, \@this_s_range);
			} elsif ($condition =~ /m>/) {
				$this_m_range[0] = $amount + 1;
				$other_m_range[1] = $amount;
				$result += get_combinations($condition_key, \@this_x_range, \@this_m_range, \@this_a_range, \@this_s_range);
			} elsif ($condition =~ /a</) {
				$this_a_range[1] = $amount - 1;
				$other_a_range[0] = $amount;
				$result += get_combinations($condition_key, \@this_x_range, \@this_m_range, \@this_a_range, \@this_s_range);
			} elsif ($condition =~ /a>/) {
				$this_a_range[0] = $amount + 1;
				$other_a_range[1] = $amount;
				$result += get_combinations($condition_key, \@this_x_range, \@this_m_range, \@this_a_range, \@this_s_range);
			} elsif ($condition =~ /s</) {
				$this_s_range[1] = $amount - 1;
				$other_s_range[0] = $amount;
				$result += get_combinations($condition_key, \@this_x_range, \@this_m_range, \@this_a_range, \@this_s_range);
			} elsif ($condition =~ /s>/) {
				$this_s_range[0] = $amount + 1;
				$other_s_range[1] = $amount;
				$result += get_combinations($condition_key, \@this_x_range, \@this_m_range, \@this_a_range, \@this_s_range);
			}

			@this_x_range = @other_x_range;
			@this_m_range = @other_m_range;
			@this_a_range = @other_a_range;
			@this_s_range = @other_s_range;
		} else {
			$result += get_combinations($workflow[$i], \@other_x_range, \@other_m_range, \@other_a_range, \@other_s_range);
		}
	}

	return $result;
}

while (<>) {
	if ($. == 1) {
		for my $line (split /\n/) {
			my ($name, $rule_str) = $line =~ /(\w+)\{(.+)\}/;

			my @rules = split ',', $rule_str;

			$rules{$name} = \@rules;
		}
		last;
	}
}

say get_combinations('in', [1, 4000], [1, 4000], [1, 4000], [1, 4000]);
