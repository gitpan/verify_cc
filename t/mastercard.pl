print "t/mastercard.pl\n";
print "1..4\n";

$ret = `../src/verify_cc -m 1234567890123456`;
$t1 = 1 if $ret =~ /invalid/;
print ($t1 ? "1 ok\n" : "1 not ok\n");

$ret = `../src/verify_cc -m 1234567890123450`;
$t2 = 1 if $ret =~ /perfect/;
print ($t2 ? "2 ok\n" : "2 not ok\n");

$ret = `../src/verify_cc -m 123456789012345`;
$t3 = 1 if $ret =~ /length/;
print ($t3 ? "3 ok\n" : "3 not ok\n");

$ret = `../src/verify_cc 123456789012345`;
$t4 = 1 if $ret =~ /usage/;
print ($t4 ? "4 ok\n" : "4 not ok\n");

$total = $t1 + $t2 + $t3 + $t4;
printf "Passed %d/%d tests: %.2f%%\n", $total, 4, 100*$total/4;

return ($total == 4 ? 1 : -1);
