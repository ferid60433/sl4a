BEGIN {
    chdir 't' if -d 't';
    @INC = '../lib';
    push @INC, "::lib:$MacPerl::Architecture:" if $^O eq 'MacOS';
    require Config; import Config;
    if ($Config{'extensions'} !~ /\bXS\/APItest\b/) {
        print "1..0 # Skip: XS::APItest was not built\n";
        exit 0;
    }
}

use Test::More tests => 12;

BEGIN { use_ok('XS::APItest') };

#########################

my $rv;

$XS::APItest::exception_caught = undef;

$rv = eval { apitest_exception(0) };
is($@, '');
ok(defined $rv);
is($rv, 42);
is($XS::APItest::exception_caught, 0);

$XS::APItest::exception_caught = undef;

$rv = eval { apitest_exception(1) };
is($@, "boo\n");
ok(not defined $rv);
is($XS::APItest::exception_caught, 1);

$rv = eval { mycroak("foobar\n"); 1 };
is($@, "foobar\n", 'croak');
ok(not defined $rv);

$rv = eval { $@ = bless{}, "foo"; mycroak(undef); 1 };
is(ref($@), "foo", 'croak(NULL)');
ok(not defined $rv);
