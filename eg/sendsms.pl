#!/usr/bin/perl -I ../lib

use Net::SMS;

# Create a new SMS object
my $r = Net::SMS->new();

# Create a new SMS Request object

# Set request type

# Set your SUBSCRIBER ID here that Simplewire provided you as signup 
$r->subscriberID("K1F-3G4-XXX-XXXXX");

# Set the IP Address of the person you are peforming this request on
# the behalf of. This is optional
$r->userIP("56.78.90.45");


######################################################################
# Set the options for this request, which are specific to sendpage
######################################################################

# This overrides simplewire's default delimiter of the " |" to seperate
# a callback, from, and text in the final message sent to users.
 $r->optDelimiter(" |");

#!!!!!
# This allows you to send asynchronous or sychronous pages thru
# simplewire.  synch will wait for the server to connect to the final
# service and send the page off.  This gives instant feedback on the
# success or failure of a page.  However, its been know to cause some
# timeout issues.  Guranteed faster delivery is with the asynch property.
# asynch will send the message, do as much error checking as possible
# before sending out the final message.  A TICKET_ID can later be used
# to see what the final status of that message was.

$r->synchronous(1);


######################################################################
# Set the parameters necessary to send a page
######################################################################

# The service id is proprietary to simplewire and you will have to
# check out our service list via our website (www.simplewire.com) or
# by checking out our servicelist.pl script.
$r->msgCarrierID(7);

# Set parameters of message
$r->msgPin("3135551212");
$r->msgFrom("Bob");
$r->msgCallback("3135551212");
$r->msgText("Demo Using Simplewire!");
$r->msgSend();

# Check out what happened
if ($r->success) {
    print "Message was successfully sent via Simplewire!\n";
} else {
    print "Message was not successfully sent via Simplewire!\n";
    print "Error Code: " . $r->errorCode . "\n";
    print "Error Description: " . $r->errorDesc . "\n";
}



