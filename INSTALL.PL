##	INSTALL.PL
##	version 1.0
##	Jeff Pinyan
##	japhy+perl@pobox.com
##	CPAN ID: PINYAN

$SIG{INT} = \&quickend;
$PROGRAM = "verify_cc.pl";
$EXEC = "verify_cc";
$DOCS = "verify_cc.1";

chdir "src";
unlink $EXEC;
open PROGRAM or die "can't open $PROGRAM: $!";
while (<PROGRAM>){ ($VERSION) = /^\$VERSION\s*=\s*'([^']+)'/ and last }
close PROGRAM;
chdir "..";

print "Installing $PROGRAM v$VERSION...\n\n";


chomp($PATH = $ENV{PATH} || `echo \$PATH`);
print "Looking for perl...\n";
$PERL = find($^X);

if (!$PERL){
	for (qw( perl perl5 )){
		print "Still looking for perl...\n";
		last if $PERL = find($_);
	}
}

die "Perl not found.  Aborting.\n\n" if !$PERL;

$VER = ver($PERL);
print "Perl $VER found in: $PERL\n";
print "It is suggested you visit CPAN\n";
print "to ensure you have the most\n";
print "recent stable version of Perl.\n\n";


until ($PREFIX){
	print "[~user notation accepted]\n";
	print "Where do you wish to install\n";
	print "the files? [/usr/local]: ";
	chomp($PREFIX = <STDIN>);
	$PREFIX =~ s!/$!!;
	$PREFIX ||= "/usr/local";
	$PREFIX =~ s!^~([^/]+)!(getpwnam($1))[-2]!e;

	if (not -d $PREFIX){
		print "$PREFIX does not exist.  Create? (y/[n]) ";
		chomp($make = <STDIN>);
		undef $PREFIX unless lc $make =~ /^y/;
	}
}
$INST = "$PREFIX/bin";
$MAN1 = "$PREFIX/man";
$MAN = "$PREFIX/man/man1";

print "Installing executables in $INST.\n";
print "Installing man page in $MAN.\n\n";

chdir "src";
system "$PERL -pi.bak -e 's,%%PERL%%,$PERL,' $PROGRAM";
unlink "$PROGRAM.bak";


print "Do you wish to compile $PROGRAM? (y/[n]) ";
chomp($comp = <STDIN>);

if (lc $comp =~ /^y/){
	print "Compiling $PROGRAM to $EXEC... please wait...\n";
	system "perlcc $PROGRAM > /dev/null 2>&1";
}

if (!-e $EXEC){
	print "Compilation failed!\n" if lc $comp =~ /^y/;
	print "Copying $PROGRAM to $EXEC...\n";
	system "cp", $PROGRAM, $EXEC;
}

chmod 0755, $EXEC;
chdir "..";
print "Ok.\n\n";

print "Running tests...\n";
chdir "t";
$s += require "visa.pl";
$s += require "mastercard.pl";
$s += require "amex.pl";
$s += require "discover.pl";
chdir "..";

die "Not all tests passed.  Aborting.\n\n" if $s != 4;
print "All tests passed!\n\n";


print "Installing $EXEC to $INST/$EXEC...\n";
chdir "src";
if (not -d $INST){
	print "Creating $INST...\n";
	mkdir $PREFIX, 0755 or $! !~ /exists/ and
		die "Could not create $PREFIX: $!\nAborting.\n";
	mkdir $INST, 0755 or $! !~ /exists/ and
		die "Could not create $PREFIX: $!\nAborting.\n";
	die "Could not create $INST: $!\nAborting.\n" if not -d $INST;
}
system "cp", $EXEC, "$INST/$EXEC" and
	die "Could not install $EXEC to $INST/$EXEC error: $!\nAborting.\n";

print "Installing $DOCS to $MAN/$DOCS...\n";
if (not -d $MAN){
	print "Creating $MAN...\n";
	mkdir $PREFIX, 0755 or $! !~ /exists/ and
		die "Could not create $PREFIX: $!\nAborting.\n";
	mkdir $MAN1, 0755 or $! !~ /exists/ and
		die "Could not create $PREFIX: $!\nAborting.\n";
	mkdir $MAN, 0755 or $! !~ /exists/ and
		die "Could not create $PREFIX: $!\nAborting.\n";
	die "Could not create $MAN: $!\nAborting.\n" if not -d $MAN;
}
system "cp", $DOCS, "$MAN/$DOCS" and
	die "Could not install $DOCS to $MAN/$DOCS error: $!\nAborting.\n";
chdir "..";

print "\n\nDone!  Have fun!\n\n";


sub find {
	my $prog = shift;
	for (split /:/, $PATH){
		my $perl = "$_/$prog";
		return $perl if -x $perl and ver($perl) >= 5;
	}
}


sub ver {
	my $prog = shift;
	my ($ver) = `$prog -v` =~ /(\d+\.\w+)/;
	$ver =~ tr/0-9.//cd;
	return $ver;
}


sub quickend {
	print "\n\n^C caught.  Aborting.\n";
	exit 1;
}
