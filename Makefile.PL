use ExtUtils::MakeMaker;

if ($^O eq 'MSWin32')
{
  $smspath = 'lib\\Net\\SMS.pm';
}
else
{
  $smspath = 'lib/Net/SMS.pm';  
}


WriteMakefile(
    NAME	=> 'Net::SMS',
    DISTNAME => 'Net-SMS',
    VERSION_FROM => $smspath,
    PREREQ_PM => {'XML::DOM'		=> "1.25",
			'Unicode::String'	=> "2.06",
			'LWP::UserAgent'	=> 0,
			'HTTP::Request'	=> 0,
			'HTTP::Response'	=> 0},
    dist        => {'COMPRESS'  => 'gzip', 'SUFFIX'    => '.gz'},
	($] ge '5.005') ? (
        'AUTHOR' => 'Simplewire (support@simplewire.com)',
        'ABSTRACT' => 'Implementation that can send and receive SMS (Short Message Service) wireless text-messages.',
    ) : (),
);

print "\nNEWS!\n";
print "Net::SMS has a home page and a development site. Try\n\n";
print "\thttp://www.simplewire.com/\n\n";
