use ExtUtils::MakeMaker;

WriteMakefile(
    NAME	=> 'Net::SMS',
    DISTNAME => 'Net-SMS',
    VERSION_FROM => 'lib/Net/SMS.pm',
    PREREQ_PM => { 'XML::DOM' => '0' },
    dist        => {'COMPRESS'  => 'gzip', 'SUFFIX'    => '.gz'},
	($] ge '5.005') ? (
        'AUTHOR' => 'Simplewire (support@simplewire.com)',
        'ABSTRACT' => 'Implementation that can send and receive SMS (Short Message Service) wireless text-messages.',
    ) : (),
);

print "\nNEWS!\n";
print "Net::SMS has a home page and a development site. Try\n\n";
print "\thttp://www.simplewire.com/\n\n";
