############################################################################
# Copyright (c) 2000 SimpleWire. All rights reserved. This program is free
# software; you can redistribute it and/or modify it under the same terms
# as Perl itself.
#
# Net::SMS::Request.pm, version 1.00
#
# Handles all the formatting of requests to SimpleWire
#
# NOTE:  This module currently is just a wrapper to Net::Pager::Request
# However, more functionality specific to SMS will be coming soon.
#
# SimpleWire
# 743 Beaubien St
# Suite 300
# Detroit, MI 48226
# 313.961.4407
#
# Net::SMS::Request 1.00 Release: 08/28/2000
# Coded By: Joe Lauer <joelauer@simplewire.com>
#
############################################################################


package Net::SMS::Request;

#---------------------------------------------------------------------
# Version Info
#---------------------------------------------------------------------
$Net::SMS::Request::VERSION = '1.00';
require 5.002;


#---------------------------------------------------------------------
# Other module use
#---------------------------------------------------------------------
use strict;
use Net::SMS::Common;
use Net::Pager::Request;

######################################################################
# All objects that this object derives from
######################################################################
@Net::SMS::Request::ISA = qw(Net::SMS::Common Net::Pager::Request);


1;
__END__;


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


Net::SMS::Request - Constructs a request object to be used in
conjunction with Net::SMS.

=head1 SYNOPSIS


Net::SMS::Request is a helper object for Net::SMS.  It is the object
that constructs the request to use with the Net::SMS object.

=head1 PREREQUISITES


See the prerequisites for Net::SMS.

=head1 DESCRIPTION


Net::SMS::Request generally requires you to set the request type, set
a few requried parameters, and then pass it to the Net::SMS::request()
method.  Each property and method is enumerated below.   Each property
and method is sectioned off based on the type of request they fit under.
Common methods and properties for each request type
are listed first.

=head1 GENERAL NOTE ABOUT PROPERTIES


All properties are either set to their default or are null.  Once a
property or method is called its state moves from undef to defined and
whatever it was defined to.  This could cause problems if you are not
careful.  A good example is the delimiter() property.  If you set it to
an empty string then it will now be an empty string in the message you
send off.  The only way to get rid of it so that it uses the default
on the SimpleWire network is to make this call delimiter(undef) which
will erase any call ever made to that function.  This same method
can be applied to any function used within this module.  Passing undef
to it will erase it.

=head1 COMMON METHODS and PROPERTIES


See below for more methods and properties available for each type of
request that SimpleWire can currently handle.

I<as_xml()>

Returns the current data structure of the Net::SMS::Request object in XML.
This is also the XML that will get sent to the SimpleWire API.

I<is_checkstatus()>

Returns true or false based on whether or not the current object is set
to a 'checkstatus' request.

I<is_sendpage()>

Returns true or false based on whether or not the current object is set
to a 'sendpage' request.

I<is_servicelist()>

Returns true or false based on whether or not the current object is set
to a 'servicelist' request.

I<request_type($str)>

Sets the request type if $str is passed in, or gets the current request
type if $str is omitted.

I<subscriber_id($str)>

Sets the subscriber id if $str is passed in, or gets the current subscriber id
if $str is omitted.  A subscriber id is assigned when a customer signs
up on www.simplewire.com.  Developers and small volume users are allowed
to use Net::SMS for free, but grabbing a free subscriber id will help us
track the popularity of certain tools.  Please sign up for free if you
are going to use this module to send any quantity of messages.

I<timeout($str)>

Sets the client side timeout if $str is passed in, or gets the current client
side timeout if $str is omitted.  The client side timeout controls how long
a client will wait for client/simplewire server connections.  You
might also want to check out the I<option_timeout()> function for setting
the timeout for the simplewire server/carrier connection.

I<user_agent($str)>

Sets the user agent if $str is passed in, or gets the current user agent
if $str is omitted.  The user agent is a string like "Perl/Net-SMS/1.00" and
is strictly for statistics on the SimpleWire network.

I<user_ip($str)>

Sets the user ip if $str is passed in, or gets the current user ip
if $str is omitted.  The user ip is the IP Address of the computer or device
that a request is on the behalf of.  An example would be a website sending
a page off for a visiting websurfer.  The websurfer's IP would be set here.

=head1 SENDPAGE REQUEST METHODS and PROPERTIES

These methods are available for sending a message thru SimpleWire.  A
'sendpage' request basically requests SimpleWire to send a message.  A
ticket id will be assigned on our network for messages that make it past
our preliminary error checking.  This ticket id will eventually allow
all sorts of fancy features including our support for two-way messaging
fairly soon.

I<set_sendpage()>

Sets the current request to a 'sendpage'.   This will allow a message
to be sent thru the SimpleWire network.

I<option_method($str)>

Sets the optional method parameter if $str is passed in, or gets the current method
if $str is omitted.  This directs which method SimpleWire should use to send the
message.  The current options are 'synch' (synchronous) or 'asynch' (asynchronous).
Synchronous is the default method and it means SimpleWire will attempt to immediately
deliver your message to the carrier/provider.  Asynchronous is optional and it means
we will put your message into a queue.  The status of that message can be checked
later via the 'checkstatus' request.

I<option_timeout($str)>

Sets the SimpleWire server timeout if $str is passed in, or gets the current timeout
if $str is omitted.  This controls how long the SimpleWire server will wait during
connections with the carrier/provider.  The default timeout is 30 seconds
on the SimpleWire network.

I<option_delimiter($str)>

Sets the delimiter if $str is passed in, or gets the current delimiter
if $str is omitted.  This is undef by default, but this controls the
characters that seperate the from, callback, and text fields in the
final message.  The default delimiter on our network is " |" but it
can be overridden here.

I<alias($str)>

Sets the alias if $str is passed in, or gets the current alias
if $str is omitted.  The alias is the SimpleWire alias if a device
has been registered on SimpleWire.  Ability to register devices thru
this client tool will be coming in later versions.  This property
will override a pin and service_id setting.

I<service_id($str)>

Sets the Service ID if $str is passed in, or gets the current Service ID
if $str is omitted.  The service id is the propietary id assigned by
SimpleWire to every carrier or provider that we support.  A service list
can either be downloaded via a 'servicelist' request or browsed on the
www.simplewire.com website.  An example would be '7' for AT&T.

I<pin($str)>

Sets the pin if $str is passed in, or gets the current pin
if $str is omitted.  The pin is the PIN or Pager Identification Number.  A PIN
is typically the device's phone number without the 1 for the area code.  However,
the PIN is different for some carriers like PageNet.  Check the www.simplewire.com
website for more help.

I<from($str)>

Sets the from if $str is passed in, or gets the current from
if $str is omitted.   The from is whoever is sending the message.  This field
is optional in most cases.

I<callback($str)>

Sets the callback if $str is passed in, or gets the current callback
if $str is omitted.  The callback is the number that the user would like to be called
back at.  This field is optional except for numeric paging services.

I<text($str)>

Sets the text if $str is passed in, or gets the current text
if $str is omitted.  The text is the message that will be sent to the device.
The maximum text length differs for each service and can only be obtained
via a 'servicelist' request or on the www.simplewire.com website.


=head1 CHECKSTATUS REQUEST METHODS and PROPERTIES

I<set_checkstatus()>

Sets the current request to a 'checkstatus'.   This will allow a previously
sent message to be checked on SimpleWire.  This request is useful if a message
was sent asynchronously and the client would like to see if the page got
delivered correctly.

I<ticket_id($str)>

Sets the ticket id if $str is passed in, or gets the current ticket id
if $str is omitted.  The ticket id is always 23 characters long and looks something
like "D9VZ1-3MTWX-28UM0-8H1L7".  This ticket id is assigned by SimpleWire during
a 'sendpage' request.


=head1 SERVICELIST REQUEST METHODS and PROPERTIES

This allows the client tool to download our real time list of supported
service providers/carriers and their associated service ids.  This request is useful for populating
<select> boxes on websites.  This request also allows the client tool to
get information like the maximum text length allowed for each service.

I<set_servicelist()>

Sets the current request to a 'servicelist'.

I<option_type($str)>

Sets the type if $str is passed in, or gets the current type
if $str is omitted.  The type is the kind of service list that the
client tool would like to download.  The default is "production" which
is every service that SimpleWire currently supports and updates.  Other
possible options include "development" and "all".  The names are intuitive
and describe what type of service list you want to get.

I<option_fields($str)>

Sets the fields if $str is passed in, or gets the current fields
if $str is omitted.  The fields is what fields the client tool wants
back about each service.  The default is "all" which will obviously get
every available field.  However, the other option of "selectbox" will
only get the fields necessary to populate a <select> box on a website.
Since the service list is so large this can help cut down on Internet lag.

=head1 EXAMPLES


All examples are in the perldoc for Net::SMS.

Any further code questions can either be answered via a perldoc on
Net::SMS or Net::SMS::Response.  Support can also be obtained
by emailing techsupport@simplewire.com.

=head1 SEE ALSO


Net::SMS, Net::SMS::Response, www.simplewire.com on the web.

=head1 AUTHOR


Joe Lauer E<lt>joelauer@simplewire.comE<gt>
www.simplewire.com

=head1 COPYRIGHT


Copyright (c) 2000 SimpleWire. All rights reserved. This program is free
software; you can redistribute it and/or modify it under the same terms
as Perl itself.




