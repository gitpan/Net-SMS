############################################################################
# Copyright (c) 2000 SimpleWire. All rights reserved. This program is free
# software; you can redistribute it and/or modify it under the same terms
# as Perl itself.
#
# Net::SMS.pm, version 1.00
#
# Net::SMS is a global short text messaging service interface via the
# Internet.  It brings you the first and only way to send SMS messages
# through one easy interface.  SimpleWire has defined an XML SMS standard
# and will make numerous tools available for developer's use so that SMS
# technology can be better utilized.
#
# NOTE: This current version of Net::SMS is provided as a wrapper to
# Net::Pager, but it will implement SMS specific functionality in
# later versions.
#
# SimpleWire
# 743 Beaubien St
# Suite 300
# Detroit, MI 48226
# 313.961.4407
#
# Net::SMS 1.00 Release: 10/05/2000
# Coded By: Joe Lauer <joelauer@simplewire.com>
#
############################################################################

#---------------------------------------------------------------------
# User documentation within and more is in POD format is at end of
# this file.  Search for =head
#---------------------------------------------------------------------

package Net::SMS;

#---------------------------------------------------------------------
# Version Info
#---------------------------------------------------------------------
$Net::SMS::VERSION = '1.00';
require 5.002;

#---------------------------------------------------------------------
# Other module use
#---------------------------------------------------------------------
use strict;
use XML::DOM;
use HTTP::Request::Common;
use HTTP::Headers;
use LWP::UserAgent;
use Net::SMS::Response;
use Net::Pager;


######################################################################
# All objects that this object derives from
######################################################################
@Net::SMS::ISA = qw(Net::Pager);

######################################################################
# If Net::SMS::Dev module exists, then set this module to development
# mode.
######################################################################
$Net::SMS::dev_mode = 0;
eval {
    require Net::SMS::Dev;
};
if ($@) {
    # Net::SMS::Dev module not found, so this is production
} else {
    # Net::SMS::Dev module found, so set this to development
    $Net::SMS::dev_mode = 1;
}



######################################################################
#
# PUBLIC FUNCTIONS
#
######################################################################


######################################################################
# Net::SMS->new();
#
######################################################################

sub new {
    
	my $that  = shift;
    my $class = ref($that) || $that;
    local $_;
    my %args;

    #-----------------------------------------------------------------
    # Declare vars that will be used locally to set package vars
    #-----------------------------------------------------------------
    #my ();

    #-----------------------------------------------------------------
	# Define default package vars
    #-----------------------------------------------------------------
    my $self = {

        DEBUG                   => 0,
        RPC_SERVER_NAME         => 'rpc',
        RPC_SERVER_DOMAIN       => 'simplewire.com',
        RPC_SERVER_PORT         => 80,
        RPC_FLOOR               => 1,
        RPC_CEILING             => 20,
        RPC_PROTOCOL            => 'http://',
        RPC_PAGING_URL          => '/paging/rpc.xml',
        RPC_END_RESPONSE        => '</response>',

        LAST_ERROR_CODE         => '',
        LAST_ERROR_DESCRIPTION  => '',

    };

    bless($self, $class);

    ##################################################################
    # If development mode, set different variables for $self
    ##################################################################
    if ($Net::SMS::dev_mode) {
        Net::SMS::Dev::set_devmode($self);
    }

	return $self;
}


sub request {

	my $self = shift();
    die "You must instantiate an object to use this function" if !(ref($self));

    # Check if it is a Net::SMS::Request object
	my $r = shift();
    die "A Net::SMS::Request object must be passed to request()" . "\n" if (ref($r) ne "Net::SMS::Request");

    # Check to see if a request type has been made
    if ($r->request_type eq "") {
        die "You must set a type of request via \$r->request_type('sendpage') before Net::SMS can send it off.";
    }

	# Construct the file request
    my $content = $self->escape($r->as_xml);

    my $response_xml = $self->send_request($content);

    my $response = Net::SMS::Response->new();

    $response->parse_xml($response_xml);

    return $response;

}


1;
__END__;


######################## User Documentation ##########################


## To format the following user documentation into a more readable
## format, use one of these programs: pod2man; pod2html; pod2text.

=head1 NAME

Net::SMS - Send SMS messages to ANY device.

=head1 SYNOPSIS

Net::SMS is a global short text messaging service interface via the
Internet.  It brings you the first and only way to send SMS messages
through one easy interface.  SimpleWire has defined an XML SMS standard
and will make numerous tools available for developer's use so that SMS
technology can be better utilized.  Currently, this interface supports
more than just SMS enabled devices and can send messages to ANY
protocol.

=head1 PREREQUISITES

The following packages are required in order to run or even install
Net::SMS.

   * LWP::UserAgent >= 5.47
   * XML::DOM (libxml-enno) >= 1.02
   * Net::Pager >= 2.00

=head1 DESCRIPTION

Net::SMS is the perl interface to SimpleWire's expanding messaging
network.  The module interacts with SimleWire's Remote Procedure Calls.
The Remote Procedure Calls provide an XML API and the protocol is open to
all developers.  For futher support or questions, you should visit
SimpleWire's website at I<www.simplewire.com>.  There you will find
support and documentation including the white paper explaining the
SimpleWire XML API.

=head1 SMS OVERVIEW

SMS stands for short-text messaging service.  The current version
of this module takes a minimalist approach to SMS, but upcoming
versions plan to take full advantage of SMS.

A SMS message will require a minimum of 3 to 5 properties to be set within
a request object.  The first property, a I<PIN>, is the Pager
Identification Number.  This is typically the phone number of the device
you are trying to message.  This number does not include a 1 before the area
code and typically looks like 3135551212.  The second property, a I<Service ID>, is
a proprietary service number assigned by SimpleWire.  The Service ID tells
SimpleWire where to route your message.  For example, a Service ID of 7
sends a message to AT&T.  The third property, the I<From> field, is typically
an optional field that is simply the sender's name.  An example would
be "Joe".  The fourth property, the I<Callback> field, is typically
an optional field that is simply the sender's callback number.  An example would
be "3135551212".   The fifth and last property is the I<Text> field.  This is
not optional and is the alphanumeric message you wish to send.  This just
explains the basic properties, but be aware that MANY more properties and
functions exist within the Net::SMS::Request and Net::SMS::Response
objects.  More documentation is available via a perldoc commond on both
of those objects.

=head1 Net::SMS OVERVIEW

See EXAMPLES section below to see working code.

The first step to using the Net::SMS module is to make sure
LWP:UserAgent and XML::DOM are fully and correctly installed. Net::SMS
works in conjunction with Net::SMS::Request and Net::SMS::Response in
order to create requests and receive responses from the SimpleWire
network.

Basically, you instantiate a new Net::SMS object via $sms = new Net::SMS
and this object handles communication with the simplewire servers.
The next step is to instantiate a new Net::SMS::Request object and then
set its properties.  This means you set the PIN, callback number, from, 
message text, etc.  There are numerous properties and they are all explained
in full via a perldoc on Net::SMS::Request.

Then pass in the new Net::SMS::Request object to the $sms->request() function
and your message will be sent.  The $sms->request() function will
return with a new Net::SMS::Response object.  Just like the Net::SMS::Request
object, the Net::SMS::Response object has many properties and functions
available.  They are fully explained via a perldoc on Net::SMS::Response.

That's all it takes to send a short-text message.  However, the Net::SMS
package provides much more functionality then these basic features.  The
perldoc for Net::SMS::Request and Net::SMS::Response will explain every
feature available.

=head1 EXAMPLES

All perl scripts or modules that use Net::SMS must include these lines
before the code attempts to access any functions in the Net::SMS package.

    use Net::SMS
    use Net::SMS::Request

After properly including these two modules above, your code is ready to
begin sending a message.  The following code will construct a basic Net::SMS::Request
object and send off a message.

    use Net::SMS
    use Net::SMS::Request

    # Construct a new SMS object
    my $sms = Net::SMS->new();
    # Construct a new SMS::Request object
    my $r = new Net::SMS::Request;
    # Set the type of request to 'sendpage'
    $r->set_sendpage;

    # Set the service id.  Check www.simplewire.com for a full listing
    # of the services that are supported.
    $r->service_id(2);
    $r->pin("1234567890");
    $r->from("Joe Lauer");
    $r->callback("9876543210");
    $r->text("Hello World From Net::SMS 1.00");

    # Send the request off and get a Net::SMS::Response object back.
    $response = $sms->request($r);

    # Check out what happened.
    if ($response->is_success) {
        print "Success!\n";
        print "Error Code: " . $response->error_code . "\n";
        print "Error Description: " . $response->error_description . "\n";
        print "Your ticket number is: " . $response->ticket_id . "\n";
    } else {
        print "Error occurred!\n";
        print "Error Code: " . $response->error_code . "\n";
        print "Error Description: " . $response->error_description . "\n";
    }

Besides being able to send a message to a PIN and Service ID, a message
can be sent to an Alias if a device has been registered on www.simplewire.com.
Just replace the the these lines from above:

    $r->service_id(2);
    $r->pin("1234567890");

With this one line:

    $r->alias('email@email.com');

B<Again there are more features explained in a perldoc on Net::SMS::Request>.
These include features ranging from asynchronous sending of messages to
setting the delimiter to seperate the from, callback, and text fields.

The second type of request supported in Net::SMS::Request is a 'servicelist'.
This request will fetch the service list from SimpleWire and the associated
service id's for each provider.  This is useful for populating a <select>
box for websites.  The following code will grab the list and set two
optional parameters so that only the information necessary for populating
a <select> box is retrieved from SimpleWire.  The code will then print
out some of the results in two different ways.

    use Net::SMS;
    use Net::SMS::Request;

    my $sms = Net::SMS->new();
    my $r = new Net::SMS::Request;

    $r->set_servicelist;
    $r->option_type("production");
    # This could be "all" so that every field is retrieved
    $r->option_fields("selectbox");

    # Send the request now
    $response = $sms->request($r);

    if ($response->is_success) {
        print "Success!\n";
        print "Error Code: " . $response->error_code . "\n";
        print "Error Description: " . $response->error_description . "\n";
    } else {
        print "Error occurred!\n";
        print "Error Code: " . $response->error_code . "\n";
        print "Error Description: " . $response->error_description . "\n";
    }

    # Grab all the services and plop them into an array of hashes
    @services = $response->fetchall_services();

    foreach $ser (@services) {
        print $ser->{ID} . "\n";
    }

    # Grab a row at a time into a hash like DBI
    while ($row = $response->fetchrow_service) {

        foreach $var (keys %{ $row }) {
            print $row->{$var} . "\t";
        }

        print "\n";

    }

The third type of request supported in Net::SMS::Request is a 'checkstatus'.
This request will fetch the status of a previously sent message.  Every
'sendpage' request that passes most error checking will be assigned a ticket.
It is this ticket that needs to be sent thru during a 'checkstatus' request.
The following code example will check the status of a previously sent message.

    use Net::SMS;
    use Net::SMS::Request;

    # Note that you will have had to do a sendpage and get a TICKET_ID
    # back for you to check with.

    my $sms = Net::SMS->new();
    my $r = new Net::SMS::Request;

    $r->set_checkstatus;

    # Set the ticket id to check.
    $r->ticket_id("D9VZ1-3MTWX-28UM0-8H1L7");

    # Request it.
    $response = $sms->request($r);

    # Check the response that was returned
    if ($response->is_success) {
        print "Success!\n";
        print "The status code: " . $response->status_code . "\n";
        print "The status description: " . $response->status_description . "\n";
    } else {
        print "Error occurred!\n";
        print "Error Code: " . $response->error_code . "\n";
        print "Error Description: " . $response->error_description . "\n";
    }

Any further code questions can either be answered via a perldoc on
Net::SMS::Request or Net::SMS::Response.  Support can also be obtained
by emailing techsupport@simplewire.com.

=head1 SEE ALSO

Net::SMS::Request, Net::SMS::Response, www.simplewire.com on the web.

=head1 AUTHOR

Joe Lauer E<lt>joelauer@simplewire.comE<gt>
www.simplewire.com

=head1 COPYRIGHT

Copyright (c) 2000 SimpleWire. All rights reserved. This program is free
software; you can redistribute it and/or modify it under the same terms
as Perl itself.
