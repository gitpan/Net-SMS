#!/usr/bin/perl -I ../lib

use Net::SMS;

# Create a new SMS object
my $r = Net::SMS->new();

# Setup the SMS message parameters
$r->msgCarrierID("82");
$r->msgPin("100-510-1234");
$r->msgFrom("Demo");
$r->msgCallback("3124445555");
$r->msgText("Hello World from Simplewire!");

# Send the SMS message off
$r->msgSend();

# Check out what happened
if ($r->success) {
    print "Message was successfully sent via Simplewire!\n";
} else {
    print "Message was not successfully sent via Simplewire!\n";
    print "Error Code: " . $r->errorCode . "\n";
    print "Error Description: " . $r->errorDscr . "\n";
}
