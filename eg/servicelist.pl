#!/usr/bin/perl -I ../lib

use Net::SMS;

# Instantiate new SMS object
my $sms = Net::SMS->new();

######################################################################
# This option determines what services get passed back.  The choices
# are "production" which is the default, "discontinued" for
# the services that went out of business, and "development" for development
# services.
######################################################################
$sms->optType("production");
$sms->optFields("selectbox");

# Send the request now
$sms->carrierListSend();

if ($sms->success) {
    print "Service List successfully downloaded!\n";
} else {
   print "Service List could not be successfully downloaded!\n";
   print "Error Code: " . $sms->errorCode . "\n";
   print "Error Description: " . $sms->errorDesc . "\n";
   exit(1);
}

# Grab a service one at a time and plop them into a hash
@services = $sms->carrierList();

foreach $row (@services) {
    print $row->{ID} . " " . $row->{Title} . " " . $row->{SubTitle} . "\n";
}

