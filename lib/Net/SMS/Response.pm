############################################################################
# Copyright (c) 2000 SimpleWire. All rights reserved. This program is free
# software; you can redistribute it and/or modify it under the same terms
# as Perl itself.
#
# Net::SMS::Response.pm, version 1.00
#
# Handles all the formatting for responses from SimpleWire
#
# NOTE:  This module currently is just a wrapper to Net::Pager::Response
# However, more functionality specific to SMS will be coming soon.
#
# SimpleWire
# 743 Beaubien St
# Suite 300
# Detroit, MI 48226
# 313.961.4407
#
# Coded By: Joe Lauer <joelauer@simplewire.com>
#
############################################################################


package Net::SMS::Response;

#---------------------------------------------------------------------
# Version Info
#---------------------------------------------------------------------
$Net::SMS::Response::VERSION = '1.00';
require 5.002;


#---------------------------------------------------------------------
# Other module use
#---------------------------------------------------------------------
use strict;
use Net::SMS::Common;
use Net::Pager::Response;

######################################################################
# All objects that this object derives from
######################################################################
@Net::SMS::Response::ISA = qw(Net::SMS::Common Net::Pager::Response);


1;
__END__;


######################## User Documentation ##########################


## To format the following user documentation into a more readable
## format, use one of these programs: pod2man; pod2html; pod2text.

=head1 NAME

Net::SMS::Response - An object that represents the response back from
a request sent to SimpleWire.  To be used in conjunction with Net::SMS
and Net::SMS::Request.

=head1 SYNOPSIS

Net::SMS::Response is a helper object for Net::SMS.  It is the object
that represents the response from the SimpleWire network after a call
to the Net::SMS::request() function.

=head1 PREREQUISITES

See the prerequisites for Net::SMS.

=head1 DESCRIPTION

Net::SMS::Response provides all the functionality to analyze a response
back from a request sent to SimpleWire.

=head1 COMMON METHODS and PROPERTIES

I<is_success()>

Returns true or false and represents whether the request sent was
considered a success or failure.  For example, the error code won't
represent this correctly since error codes of 0 - 10 are considered
successes.  Call this function to check whether the request was
successful.

I<error_code()>

Returns the error code in the response from SimpleWire.  Every single
request will have an error code available.  Error codes can be obtained
as a Word document or PDF from the www.simplewire.com website.

I<error_description()>

Returns the error description in the response from SimpleWire.  Every single
request will have an error description available.  Error descriptions can be obtained
as a Word document or PDF from the www.simplewire.com website.

I<as_xml()>

Returns the current data structure of the Net::SMS::Response object in XML.

I<is_checkstatus()>

Returns true or false based on whether or not the current object is set
to a 'checkstatus' request.

I<is_sendpage()>

Returns true or false based on whether or not the current object is set
to a 'sendpage' request.

I<is_servicelist()>

Returns true or false based on whether or not the current object is set
to a 'servicelist' request.

I<request_type()>

Gets the current request type.  Will return a string
like "servicelist", "sendpage", etc.

=head1 SENDPAGE REQUEST METHODS and PROPERTIES

I<ticket_id()>

Gets the ticket id from the 'sendpage' request.  Note that some
sendpage requests might not generate a ticket id if they fail some
preliminary error checking on our server.  Preliminary errors include things
like badly formed XML posted to our API.

=head1 SERVICELIST REQUEST METHODS and PROPERTIES

A 'servicelist' request will return a large list of services that SimpleWire
currently supports.  Each service will be dumped into its own hash.  There
are too many different keys that can be sent back to go thru them all here, so I suggest
that you just loop thru each key in the hash to see how many different keys
exist.  Another easy way to see what keys exist is to print out the response
as XML with code like:

    print $response->as_xml();

The key for each hash will be the exact same as whatever exists between each <service and />
tags.  For example if <service ID="18"/> exists then the hash key would be ID.

I<fetchall_services()>

Returns the entire service list as an array of hashes.  The following code will access
whatever is returned.

    # Grab all the services and plop them into an array of hashes
    @services = $response->fetchall_services();

    foreach $ser (@services) {
        print $ser->{ID} . "\n";
    }


I<fetchrow_service()>

This method is like the DBI package if you have ever used that.  It allows you to return
one hash at a time and it will auto increment the placeholder.  So you can iterate over
the entire list in this fashion:

    # Grab a row at a time into a hash like DBI
    while ($row = $response->fetchrow_service) {

        foreach $var (keys %{ $row }) {
            print $row->{$var} . "\t";
        }

        print "\n";

    }

It will return a false when it reaches the end and it will exit the loop for you.

I<fetchrow_rewind()>

This function resets the placeholder for the fetchrow_service() function and rewinds
you back to the beginning of the list.  This is useful for needing the list in
multiple areas but only downloading it one time.

=head1 CHECKSTATUS REQUEST METHODS and PROPERTIES

The 'checkstatus' request will return a status code and a status description.  They
both corrospond to the same meanings as the error code and description.  However, the
error code and description strictly relate to the 'checkstatus' transaction, while the
status code and description describe what happened to the previously sent message.
If the ticket id passed in during the 'checkstatus' request generates an error then
its possible no status code or description will exist.

I<status_code()>

Returns the status code associated with the ticket id.  The code corrosponds to the
error codes in the error_code() function.

I<status_description()>

Returns the status description associated with the ticket id.  The description corrosponds to the
error descriptions in the error_description() function.

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