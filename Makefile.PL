
require 5.004;
use strict;

use lib "./lib/";
use Getopt::Long;
use ExtUtils::MakeMaker;

use vars qw($opt_config);
my %prereq;


# Check for non-standard modules that are used by this library.
$| = 1;
my $missing_modules = 0;

print "Checking for LWP::UserAgent...........";
eval {
    require LWP::UserAgent;
};
if ($@) {
    print " failed\n";
    $missing_modules++;
    print <<EOT;
$@
LWP::UserAgent is missing.

EOT
    sleep(2);  # Don't hurry too much
} else {
    print " ok\n";
}

print "Checking for XML::DOM...........";
eval {
    require XML::DOM;
};
if ($@) {
    print " failed\n";
    $missing_modules++;
    print <<EOT;
$@
XML::DOM is missing.

EOT
    sleep(2);  # Don't hurry too much
} else {
    print " ok\n";
}

my %opts = (NAME         => "Net::SMS",
	      DISTNAME     => "Net-SMS",
	      VERSION_FROM => "lib/Net/SMS.pm",
          	PREREQ_PM     => {'LWP::UserAgent'              => 0,
          				'XML::DOM'     					=> 0,
                            	'HTTP::Request::Common'          => 0,
					'HTTP::Headers'					=> 0,
                     },
		  dist         => { COMPRESS => "gzip", SUFFIX => "gz" },
	      );

if ($ExtUtils::MakeMaker::VERSION >= 5.43) {
    $opts{'ABSTRACT'} = 'Send SMS or any kind of message to ANY device.  Net::SMS is a wireless communication conduit.';
    $opts{'AUTHOR'} = 'Simplewire <techsupport@simplewire.com>';
    $opts{'PREREQ_PM'} = \%prereq;
}



WriteMakefile(%opts);

print "Makefile Successful.\n";
print "\nNEWS!\n";
print "Net::SMS has a home page and a development site. Try\n\n";
print "\thttp://www.simplewire.com/\n\n";
