#!/usr/bin/perl -I ../lib

use Net::SMS;

# Create a new SMS object
my $sms = Net::SMS->new();

# Set your SUBSCRIBER ID here that Simplewire provided you as signup 
$sms->subscriberID("");

######################################################################
# Set the options for this request, which are specific to sendpage
######################################################################

# This overrides simplewire's default delimiter of the " |" to seperate
# a callback, from, and text in the final message sent to users.
 $sms->optDelimiter(" |");

#!!!!!
# This allows you to send asynchronous or sychronous pages thru
# simplewire.  synch will wait for the server to connect to the final
# service and send the page off.  This gives instant feedback on the
# success or failure of a page.  However, its been know to cause some
# timeout issues.  Guranteed faster delivery is with the asynch property.
# asynch will send the message, do as much error checking as possible
# before sending out the final message.  A TICKET_ID can later be used
# to see what the final status of that message was.

$sms->synchronous(1);


######################################################################
# Set the parameters necessary to send a page
######################################################################

# The service id is proprietary to simplewire and you will have to
# check out our service list via our website (www.simplewire.com) or
# by checking out our servicelist.pl script.

# Set parameters of message
$sms->msgPin("100-510-1234");
$sms->msgFrom("Bob");
$sms->msgCallback("3135551212");
$sms->msgText("Demo Using Simplewire > <!");
$sms->msgSend();

# Check out what happened
if ($sms->success) {
    print "Message was successfully sent via Simplewire!\n";

	# Carrier Recognition
	@services = $sms->carrierList();
	if (@services > 0) {
		print "Used " . $services[0]->{Title} . " located in ";
		print $services[0]->{CountryRegion} . ", " . $services[0]->{CountryName} . "\n";
	}

} else {
    print "Message was not successfully sent via Simplewire!\n";
    print "Error Code: " . $sms->errorCode . "\n";
    print "Error Description: " . $sms->errorDesc . "\n";
}



