print "t/visa.pl\n";
print "1..7\n";

$ret = `../src/verify_cc -v 1234567890123456`;
$t1 = 1 if $ret =~ /invalid/;
print ($t1 ? "1 ok\n" : "1 not ok\n");

$ret = `../src/verify_cc -v 1234567890123450`;
$t2 = 1 if $ret =~ /perfect/;
print ($t2 ? "2 ok\n" : "2 not ok\n");

$ret = `../src/verify_cc -v 123456789012345`;
$t3 = 1 if $ret =~ /length/;
print ($t3 ? "3 ok\n" : "3 not ok\n");

$ret = `../src/verify_cc -v 1234567890123`;
$t4 = 1 if $ret =~ /invalid/;
print ($t4 ? "4 ok\n" : "4 not ok\n");

$ret = `../src/verify_cc -v 1234567890126`;
$t5 = 1 if $ret =~ /perfect/;
print ($t5 ? "5 ok\n" : "5 not ok\n");

$ret = `../src/verify_cc -v 123456789012`;
$t6 = 1 if $ret =~ /length/;
print ($t6 ? "6 ok\n" : "6 not ok\n");

$ret = `../src/verify_cc 123456789012345`;
$t7 = 1 if $ret =~ /usage/;
print ($t7 ? "7 ok\n" : "7 not ok\n");

$total = $t1 + $t2 + $t3 + $t4 + $t5 + $t6 + $t7;
printf "Passed %d/%d tests: %.2f%%\n", $total, 7, 100*$total/7;

return ($total == 7 ? 1 : -1);
