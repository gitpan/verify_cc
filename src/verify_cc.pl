#!/usr/local/bin/perl -s

use strict;
use vars qw( $VERSION $USAGE $v $m $a $n );

sub catch ($$);

$VERSION = '1.00';
$USAGE = << "END";
usage: verify_cc -[ v | m | a | n ] cardnumber

options:
  -v	Visa
  -m	Mastercard
  -a	American Express
  -n	Novus
END

my ($card,$len,@digits,$sum);

($v ^ $m ^ $a ^ $n) or catch 1, $USAGE;
$card = shift or catch 1, $USAGE;
$card =~ tr/- //d;
$card =~ /^(\d+)$/ or catch 2, "invalid card number: $card\n";
$len = length $card;

catch 3, "invalid card length: $len\n" unless
	$v && ($len == 13 || $len == 16) ||
	$m && $len == 16 ||
	$a && $len == 15 ||
	$n && $len == 16;

@digits = split //, $card;
unshift @digits, 0 if $len % 2;

for (0..$#digits){
	my $d = $digits[$_];
	$sum += ($d * (2 - ($_ % 2)) > 9) ? ($d * 2 - 9) : $d;
}
catch 2, "invalid card number: $card\n" if $sum % 10;

catch 0, "$card is perfectly fine.\n";


sub catch ($$) {
	my ($errno,$msg) = @_;
	print $msg;
	exit $errno;
}
