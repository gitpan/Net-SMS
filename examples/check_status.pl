###################################################################
#  Copyright (c) 1999-2001 Simplewire, Inc. All Rights Reserved.
# 
#  Simplewire grants you ("Licensee") a non-exclusive, royalty
#  free, license to use, modify and redistribute this software
#  in source and binary code form, provided that i) Licensee
#  does not utilize the software in a manner which is
#  disparaging to Simplewire.
# 
#  This software is provided "AS IS," without a warranty of any
#  kind. ALL EXPRESS OR IMPLIED CONDITIONS, REPRESENTATIONS AND
#  WARRANTIES, INCLUDING ANY IMPLIED WARRANTY OF MERCHANTABILITY,
#  FITNESS FOR A PARTICULAR PURPOSE OR NON-INFRINGEMENT, ARE
#  HEREBY EXCLUDED. SIMPLEWIRE AND ITS LICENSORS SHALL NOT BE
#  LIABLE FOR ANY DAMAGES SUFFERED BY LICENSEE AS A RESULT OF
#  USING, MODIFYING OR DISTRIBUTING THE SOFTWARE OR ITS
#  DERIVATIVES. IN NO EVENT WILL SIMPLEWIRE OR ITS LICENSORS BE
#  LIABLE FOR ANY LOST REVENUE, PROFIT OR DATA, OR FOR DIRECT,
#  INDIRECT, SPECIAL, CONSEQUENTIAL, INCIDENTAL OR PUNITIVE
#  DAMAGES, HOWEVER CAUSED AND REGARDLESS OF THE THEORY OF
#  LIABILITY, ARISING OUT OF THE USE OF OR INABILITY TO USE
#  SOFTWARE, EVEN IF SIMPLEWIRE HAS BEEN ADVISED OF THE
#  POSSIBILITY OF SUCH DAMAGES.
###################################################################

###################################################################
#  Shows how to check the status of a message in Perl.
# 
#  Please visit www.simplewire.com for sales and support.
# 
#  @author Vidal Borromeo
#  @version 2.4.0
###################################################################

#!/usr/bin/perl -I ../lib

use Net::SMS;

# Create New SMS object
my $r = Net::SMS->new();

# Subscriber properties
$r->subscriberID( '123-456-789-12345' );
$r->subscriberPassword( 'Password Goes Here' );

# Message properties
$r->msgPin( "+1 100 510 1234" );
$r->msgFrom( "Demo" );
$r->msgCallback( "+1 100 555 1212" );
$r->msgText( "Hello World from Simplewire!" );

# Send Message
print "Submitting message To Simplewire...\n";
$r->msgSend();

# Check For Errors
if ($r->success)
{
    print "Message was successfully sent via Simplewire!\n";
}
else
{
    print "Message was not successfully sent via Simplewire!\n";
    print "Error Code: " . $r->errorCode . "\n";
    print "Error Description: " . $r->errorDesc . "\n";
}



# And Now Check The Message Status...
print "\nChecking Status of Message...\n";
my $ticketID = $r->msgTicketID();


# Send the request off
print "Submitting Status Request To Simplewire...\n";
$r->msgStatusSend();


# Check if the status check was successful
if ($r->success)
{
    print 'The status of message ' . $ticketID . " was retrieved.\n";
    print 'Status Code: ' . $r->msgStatusCode . "\n";
    print 'Status Desc: ' . $r->msgStatusDesc . "\n";
}
else
{
    print 'The status of message #' . $ticketID . " could NOT be retrieved.\n";
    print 'Error Code: ' . $r->errorCode . "\n";
    print 'Error Description: ' . $r->errorDesc . "\n";
}
